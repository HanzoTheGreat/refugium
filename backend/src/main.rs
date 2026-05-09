use axum::routing::get;
use axum::Router;
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
        .unwrap_or_else(|_| "sqlite:refugium.db".into());

    let ntfy_url = std::env::var("NTFY_URL")
        .unwrap_or_else(|_| "http://localhost:7867".into());

    let pool = db::init_pool(&database_url).await.expect("DB init fehlgeschlagen");

    tracing::info!("Refugium Server startet...");

    let api_routes = routes::router(pool, ntfy_url);

    let app = Router::new()
        .route("/health", get(health))
        .nest("/api/v1", api_routes);

    let bind_addr = std::env::var("BIND_ADDR")
        .unwrap_or_else(|_| "127.0.0.1:8080".into());

    let listener = tokio::net::TcpListener::bind(&bind_addr)
        .await
        .unwrap();

    tracing::info!("Listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}

async fn health() -> &'static str {
    "ok"
}