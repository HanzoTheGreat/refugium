use tracing::warn;

pub async fn send_notification(
    ntfy_base_url: &str,
    topic: &str,
    title: &str,
    message: &str,
) {
    let url = format!("{}/{}", ntfy_base_url, topic);
    let client = reqwest::Client::new();
    let result = client
        .post(&url)
        .header("Title", title)
        .header("Priority", "high")
        .body(message.to_string())
        .send()
        .await;

    if let Err(e) = result {
        warn!("Push-Benachrichtigung fehlgeschlagen: {}", e);
    }
}