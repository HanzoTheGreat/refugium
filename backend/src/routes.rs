use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::{
        sse::{Event, KeepAlive, Sse},
        Json,
    },
    routing::{get, post},
    Router,
};
use futures_util::stream::Stream;
use sqlx::SqlitePool;
use std::convert::Infallible;
use std::time::Duration;
use tokio::sync::broadcast;
use tokio_stream::{wrappers::BroadcastStream, StreamExt as _};
use crate::{models::*, crypto::*, push::send_notification};

pub fn router(pool: SqlitePool, ntfy_url: String, sse_tx: broadcast::Sender<String>) -> Router {
    Router::new()
        .route("/devices/register", post(register_device))
        .route("/pairs/invite", post(create_invite))
        .route("/pairs/join", post(join_pairing))
        .route("/pairs/confirm", post(confirm_pairing))
        .route("/messages/send", post(send_message))
        .route("/messages/{device_id}", get(fetch_messages))
        .route("/push/register", post(register_push))
        .route("/sse/{device_id}", get(sse_stream))
        .with_state(AppState { pool, ntfy_url, sse_tx })
}

#[derive(Clone)]
pub struct AppState {
    pub pool: SqlitePool,
    pub ntfy_url: String,
    pub sse_tx: broadcast::Sender<String>,
}

async fn register_device(
    State(state): State<AppState>,
    Json(req): Json<RegisterDeviceRequest>,
) -> Result<Json<RegisterDeviceResponse>, (StatusCode, Json<ApiError>)> {
    let id = req.device_id.unwrap_or_else(generate_id);
    let now = chrono::Utc::now();

    sqlx::query(
        "INSERT INTO devices (id, public_key, created_at, last_seen)
         VALUES (?, ?, ?, ?)
         ON CONFLICT(id) DO UPDATE SET
           public_key = excluded.public_key,
           last_seen  = excluded.last_seen"
    )
    .bind(&id)
    .bind(&req.public_key)
    .bind(now)
    .bind(now)
    .execute(&state.pool)
    .await
    .map_err(|e| (
        StatusCode::INTERNAL_SERVER_ERROR,
        Json(ApiError::new(e.to_string())),
    ))?;

    Ok(Json(RegisterDeviceResponse { device_id: id }))
}

async fn create_invite(
    State(state): State<AppState>,
    Json(req): Json<CreateInviteRequest>,
) -> Result<Json<CreateInviteResponse>, (StatusCode, Json<ApiError>)> {
    let pairing_id = generate_id();
    let invite_code = generate_invite_code();
    let now = chrono::Utc::now();

    sqlx::query(
        "INSERT INTO pairings (id, initiator_device_id, invite_code, role, status, created_at)
         VALUES (?, ?, ?, ?, 'pending', ?)"
    )
    .bind(&pairing_id)
    .bind(&req.device_id)
    .bind(&invite_code)
    .bind(&req.role)
    .bind(now)
    .execute(&state.pool)
    .await
    .map_err(|e| (
        StatusCode::INTERNAL_SERVER_ERROR,
        Json(ApiError::new(e.to_string())),
    ))?;

    Ok(Json(CreateInviteResponse { invite_code, pairing_id }))
}

async fn join_pairing(
    State(state): State<AppState>,
    Json(req): Json<JoinPairingRequest>,
) -> Result<Json<serde_json::Value>, (StatusCode, Json<ApiError>)> {
    let pairing = sqlx::query_as::<_, Pairing>(
        "SELECT * FROM pairings WHERE invite_code = ? AND status = 'pending'"
    )
    .bind(&req.invite_code)
    .fetch_optional(&state.pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(ApiError::new(e.to_string()))))?
    .ok_or((StatusCode::NOT_FOUND, Json(ApiError::new("Ungültiger Code"))))?;

    sqlx::query(
        "UPDATE pairings SET peer_device_id = ?, status = 'awaiting_confirm' WHERE id = ?"
    )
    .bind(&req.device_id)
    .bind(&pairing.id)
    .execute(&state.pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(ApiError::new(e.to_string()))))?;

    Ok(Json(serde_json::json!({
        "pairing_id": pairing.id,
        "initiator_device_id": pairing.initiator_device_id,
        "role": pairing.role,
    })))
}

async fn confirm_pairing(
    State(state): State<AppState>,
    Json(req): Json<ConfirmPairingRequest>,
) -> Result<Json<serde_json::Value>, (StatusCode, Json<ApiError>)> {
    let now = chrono::Utc::now();

    sqlx::query(
        "UPDATE pairings SET status = 'confirmed', confirmed_at = ?
         WHERE id = ? AND (initiator_device_id = ? OR peer_device_id = ?)"
    )
    .bind(now)
    .bind(&req.pairing_id)
    .bind(&req.device_id)
    .bind(&req.device_id)
    .execute(&state.pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(ApiError::new(e.to_string()))))?;

    Ok(Json(serde_json::json!({ "status": "confirmed" })))
}

async fn send_message(
    State(state): State<AppState>,
    Json(req): Json<SendMessageRequest>,
) -> Result<Json<serde_json::Value>, (StatusCode, Json<ApiError>)> {
    let id = generate_id();
    let now = chrono::Utc::now();

    sqlx::query(
        "INSERT INTO messages (id, sender_device_id, recipient_device_id, payload, message_type, created_at)
         VALUES (?, ?, ?, ?, ?, ?)"
    )
    .bind(&id)
    .bind(&req.sender_device_id)
    .bind(&req.recipient_device_id)
    .bind(&req.payload)
    .bind(&req.message_type)
    .bind(now)
    .execute(&state.pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(ApiError::new(e.to_string()))))?;

    // SSE-Ping an Empfänger – ignorieren wenn niemand subscribed (send() gibt Err wenn 0 Receiver)
    let _ = state.sse_tx.send(req.recipient_device_id.clone());

    if req.message_type == "SwitchEvent" {
        let sub = sqlx::query_as::<_, PushSubscription>(
            "SELECT * FROM push_subscriptions WHERE device_id = ?"
        )
        .bind(&req.recipient_device_id)
        .fetch_optional(&state.pool)
        .await
        .unwrap_or(None);

        if let Some(sub) = sub {
            send_notification(
                &state.ntfy_url,
                &sub.ntfy_topic,
                "Anteilwechsel",
                "Ein Anteil hat sich eingecheckt",
            ).await;
        }
    }

    Ok(Json(serde_json::json!({ "message_id": id })))
}

async fn fetch_messages(
    State(state): State<AppState>,
    Path(device_id): Path<String>,
) -> Result<Json<Vec<Message>>, (StatusCode, Json<ApiError>)> {
    sqlx::query(
        "DELETE FROM messages WHERE created_at < datetime('now', '-7 days')"
    )
    .execute(&state.pool)
    .await
    .ok();

    let messages = sqlx::query_as::<_, Message>(
        "SELECT * FROM messages
         WHERE recipient_device_id = ? AND delivered_at IS NULL
         ORDER BY created_at ASC
         LIMIT 50"
    )
    .bind(&device_id)
    .fetch_all(&state.pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(ApiError::new(e.to_string()))))?;

    sqlx::query(
        "UPDATE messages SET delivered_at = ? WHERE recipient_device_id = ? AND delivered_at IS NULL"
    )
    .bind(chrono::Utc::now())
    .bind(&device_id)
    .execute(&state.pool)
    .await
    .ok();

    Ok(Json(messages))
}

async fn register_push(
    State(state): State<AppState>,
    Json(req): Json<RegisterPushRequest>,
) -> Result<Json<serde_json::Value>, (StatusCode, Json<ApiError>)> {
    let now = chrono::Utc::now();
    sqlx::query(
        "INSERT INTO push_subscriptions (device_id, ntfy_topic, updated_at)
         VALUES (?, ?, ?)
         ON CONFLICT(device_id) DO UPDATE SET ntfy_topic = excluded.ntfy_topic, updated_at = excluded.updated_at"
    )
    .bind(&req.device_id)
    .bind(&req.ntfy_topic)
    .bind(now)
    .execute(&state.pool)
    .await
    .map_err(|e| (StatusCode::INTERNAL_SERVER_ERROR, Json(ApiError::new(e.to_string()))))?;

    Ok(Json(serde_json::json!({ "status": "ok" })))
}

// SSE-Endpoint: Gerät subscribed auf seine device_id.
// Server sendet "ping" Event sobald eine neue Nachricht für dieses Gerät eingeht.
async fn sse_stream(
    State(state): State<AppState>,
    Path(device_id): Path<String>,
) -> Sse<impl Stream<Item = Result<Event, Infallible>>> {
    let rx = state.sse_tx.subscribe();
    let stream = BroadcastStream::new(rx).filter_map(move |msg| {
        let target = device_id.clone();
        match msg {
            Ok(id) if id == target => {
                Some(Ok(Event::default().event("ping").data("new_message")))
            }
            _ => None,
        }
    });
    Sse::new(stream).keep_alive(
        KeepAlive::new()
            .interval(Duration::from_secs(10))
            .text("keep-alive"),
    )
}