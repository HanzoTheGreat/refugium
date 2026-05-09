use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Device {
    pub id: String,
    pub public_key: String,
    pub created_at: DateTime<Utc>,
    pub last_seen: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Pairing {
    pub id: String,
    pub initiator_device_id: String,
    pub peer_device_id: Option<String>,
    pub invite_code: Option<String>,
    pub role: String,
    pub status: String,
    pub created_at: DateTime<Utc>,
    pub confirmed_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct Message {
    pub id: String,
    pub sender_device_id: String,
    pub recipient_device_id: String,
    pub payload: String,
    pub message_type: String,
    pub created_at: DateTime<Utc>,
    pub delivered_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, sqlx::FromRow)]
pub struct PushSubscription {
    pub device_id: String,
    pub ntfy_topic: String,
    pub updated_at: DateTime<Utc>,
}

// Request/Response DTOs
#[derive(Debug, Deserialize)]
pub struct RegisterDeviceRequest {
    pub public_key: String,
}

#[derive(Debug, Serialize)]
pub struct RegisterDeviceResponse {
    pub device_id: String,
}

#[derive(Debug, Deserialize)]
pub struct CreateInviteRequest {
    pub device_id: String,
    pub role: String,
}

#[derive(Debug, Serialize)]
pub struct CreateInviteResponse {
    pub invite_code: String,
    pub pairing_id: String,
}

#[derive(Debug, Deserialize)]
pub struct JoinPairingRequest {
    pub invite_code: String,
    pub device_id: String,
}

#[derive(Debug, Deserialize)]
pub struct ConfirmPairingRequest {
    pub pairing_id: String,
    pub device_id: String,
}

#[derive(Debug, Deserialize)]
pub struct SendMessageRequest {
    pub sender_device_id: String,
    pub recipient_device_id: String,
    pub payload: String,
    pub message_type: String,
}

#[derive(Debug, Deserialize)]
pub struct RegisterPushRequest {
    pub device_id: String,
    pub ntfy_topic: String,
}

#[derive(Debug, Serialize)]
pub struct ApiError {
    pub error: String,
}

impl ApiError {
    pub fn new(msg: impl Into<String>) -> Self {
        Self { error: msg.into() }
    }
}