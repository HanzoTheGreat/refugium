-- Geräte
CREATE TABLE IF NOT EXISTS devices (
    id TEXT PRIMARY KEY,
    public_key TEXT NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Pairing
CREATE TABLE IF NOT EXISTS pairings (
    id TEXT PRIMARY KEY,
    initiator_device_id TEXT NOT NULL REFERENCES devices(id),
    peer_device_id TEXT REFERENCES devices(id),
    invite_code TEXT UNIQUE,
    role TEXT NOT NULL DEFAULT 'partner',
    status TEXT NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    confirmed_at DATETIME
);

-- Mailbox: verschlüsselte Nachrichten warten auf Abholung
CREATE TABLE IF NOT EXISTS messages (
    id TEXT PRIMARY KEY,
    sender_device_id TEXT NOT NULL REFERENCES devices(id),
    recipient_device_id TEXT NOT NULL REFERENCES devices(id),
    payload TEXT NOT NULL,
    message_type TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivered_at DATETIME
);

-- ntfy Topics pro Gerät
CREATE TABLE IF NOT EXISTS push_subscriptions (
    device_id TEXT PRIMARY KEY REFERENCES devices(id),
    ntfy_topic TEXT NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
