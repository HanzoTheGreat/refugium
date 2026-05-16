use axum::routing::get;
use axum::Router;
use axum_server::tls_rustls::RustlsConfig;
use std::path::PathBuf;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

mod routes;
mod models;
mod crypto;
mod db;
mod push;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();

    tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::new(
            std::env::var("RUST_LOG").unwrap_or_else(|_| "refugium_server=debug".into()),
        ))
        .with(tracing_subscriber::fmt::layer())
        .init();

    let database_url = std::env::var("DATABASE_URL")
        .unwrap_or_else(|_| "sqlite:///home/necrohanzo/refugium/backend/refugium.db".into());

    let ntfy_url = std::env::var("NTFY_URL")
        .unwrap_or_else(|_| "http://localhost:7867".into());

    let pool = db::init_pool(&database_url).await.expect("DB init fehlgeschlagen");

    tracing::info!("Refugium Server startet...");

    let api_routes = routes::router(pool, ntfy_url);

    let app = Router::new()
        .route("/health", get(health))
        .nest("/api/v1", api_routes);

    let cert_path = std::env::var("TLS_CERT")
        .unwrap_or_else(|_| "/etc/letsencrypt/live/refugium-sync.duckdns.org/fullchain.pem".into());
    let key_path = std::env::var("TLS_KEY")
        .unwrap_or_else(|_| "/etc/letsencrypt/live/refugium-sync.duckdns.org/privkey.pem".into());

    let tls_config = RustlsConfig::from_pem_file(
        PathBuf::from(cert_path),
        PathBuf::from(key_path),
    )
    .await
    .expect("TLS-Konfiguration fehlgeschlagen");

    let bind_addr = std::env::var("BIND_ADDR")
        .unwrap_or_else(|_| "0.0.0.0:443".into());

    let addr = bind_addr.parse().unwrap();
    tracing::info!("Listening on https://{}", addr);

    axum_server::bind_rustls(addr, tls_config)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn health() -> &'static str {
    "ok"
}