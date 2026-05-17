# Refugium

Eine App für Menschen mit Dissoziativer Identitätsstörung (DIS) und ihre Angehörigen.

Switch Tracker, Consent-Profile, Notfallkarte, Ende-zu-Ende-verschlüsselter Sync mit Partner und Therapeutin. Lokal-First, kein Tracking, kein Cloud-Lock-in.

**Lizenz:** AGPL-3.0 · **Plattform:** Android · **Status:** Aktive Entwicklung / Testphase

---

## Inhalt

- [Funktionsübersicht](#funktionsübersicht)
- [Screenshots](#screenshots)
- [App installieren](#app-installieren)
- [Sync-Server selbst betreiben](#sync-server-selbst-betreiben)
- [Projekt lokal bauen](#projekt-lokal-bauen)
- [Architektur](#architektur)
- [Datenschutz & Sicherheit](#datenschutz--sicherheit)
- [Mitmachen](#mitmachen)
- [Lizenz](#lizenz)

---

## Funktionsübersicht

- **Switch Tracker** – Anteile checken sich ein (One-Tap), Partner und Therapeutin sehen in Echtzeit wer vorne ist – inklusive Consent und Trigger. Funktioniert auch wenn die App geschlossen ist (Android Foreground Service + SSE).
- **Anteil-Profile** – Name, Pronomen, Rolle, Beschreibungen, Sichtbarkeitsstufen (Notfall / Partner / Therapeutin / Intern), Status-Lifecycle. Soft-Delete by default.
- **Consent-Profile** – Pro Anteil: was ist gerade OK, was erst fragen, was nicht. Direkt sichtbar wenn der Anteil eingecheckt ist.
- **Trigger-Profile** – Strukturiert nach Typ und Schweregrad, mit Coping-Vorschlag. Extern sichtbare Trigger landen auf der Notfallkarte und im Sync.
- **Notfallkarte** – ICD-10: F44.81, Abgrenzung zu Psychose/Drogen/Behinderung, Anteile, Ersthelfer-Hinweise, Medizindaten, Notfallkontakte. PDF-Export.
- **Journal** – Pro Anteil, mit Privat-Flag. Private Einträge werden nie geteilt.
- **E2E-verschlüsselter Sync** – X25519 + AES-256-GCM. Der Server sieht nur Ciphertext.
- **Partner- und Therapeuten-Modus** – Rollengefilterter Read-only-Zugriff. Was geteilt wird, entscheidet die Betroffene per Sichtbarkeitsstufe.
- **Backup / Restore** – JSON-Export und -Import, komplett lokal.

---

## Screenshots

*Folgen.*

---

## App installieren

### APK direkt (empfohlen)

Die aktuellste Release-APK findet sich unter [Releases](../../releases). Einfach herunterladen und auf dem Gerät installieren. Falls nötig, unter *Einstellungen → Sicherheit → Unbekannte Quellen* erlauben.

Die APK ist für `arm64-v8a` gebaut und läuft auf allen modernen Android-Geräten (Android 8+), inklusive **GrapheneOS**, **LineageOS** und **/e/OS** – ohne Google-Services-Abhängigkeit.

### F-Droid

F-Droid-Einreichung ist geplant, sobald die Testphase abgeschlossen ist.

---

## Sync-Server selbst betreiben

Der Sync-Server ist ein schlankes Rust-Binary. Wer seinen Daten nicht auf fremden Servern haben will, kann ihn auf einem eigenen VPS oder Heimserver betreiben. Der gesamte Ablauf dauert ca. 15–20 Minuten.

### Voraussetzungen

- Linux-Server (getestet auf Ubuntu 24.04)
- `cargo` / Rust Toolchain ([rustup.rs](https://rustup.rs))
- Eine Domain oder DynDNS-Adresse (für TLS)
- `certbot` für Let's-Encrypt-Zertifikat (oder eigenes Zertifikat)

### 1. Repository klonen und Backend bauen

```bash
git clone https://github.com/HanzoTheGreat/refugium.git
cd refugium/backend
cargo build --release
```

### 2. Systembenutzer anlegen (empfohlen)

```bash
sudo useradd -m -s /bin/bash refugium
sudo -u refugium mkdir -p /home/refugium/refugium/backend
```

Das Binary in das Verzeichnis kopieren:

```bash
sudo cp target/release/refugium-server /home/refugium/refugium/backend/
```

### 3. TLS-Zertifikat einrichten

Mit Let's Encrypt (Domain nötig):

```bash
sudo apt install certbot
sudo certbot certonly --standalone -d deine-domain.example.com
```

Nach dem Ausstellen die Berechtigungen für den Service-User setzen:

```bash
sudo chown -R refugium:refugium /etc/letsencrypt/live/ /etc/letsencrypt/archive/
```

> **Hinweis:** Nach jedem automatischen Cert-Renewal müssen die Berechtigungen neu gesetzt werden. Am einfachsten als Post-Renewal-Hook in `/etc/letsencrypt/renewal-hooks/post/`:
> ```bash
> #!/bin/bash
> chown -R refugium:refugium /etc/letsencrypt/live/ /etc/letsencrypt/archive/
> ```

### 4. Konfiguration (.env)

`.env`-Datei im Backend-Verzeichnis anlegen:

```bash
sudo -u refugium nano /home/refugium/refugium/backend/.env
```

Inhalt:

```env
DATABASE_URL=sqlite:///home/refugium/refugium/backend/refugium.db
NTFY_URL=http://localhost:7867
BIND_ADDR=0.0.0.0:443
RUST_LOG=refugium_server=info
TLS_CERT=/etc/letsencrypt/live/deine-domain.example.com/fullchain.pem
TLS_KEY=/etc/letsencrypt/live/deine-domain.example.com/privkey.pem
```

`NTFY_URL` ist optional – nur nötig wenn ntfy für Push-Benachrichtigungen selbst gehostet wird. Ohne ntfy funktioniert der Sync trotzdem (via SSE und Polling), nur ohne Push-Notifications.

### 5. Berechtigungen für Port 443

Damit der Server als normaler User auf Port 443 lauschen darf:

```bash
sudo setcap 'cap_net_bind_service=+ep' /home/refugium/refugium/backend/refugium-server
```

> Dieser Schritt muss nach jedem neuen Build wiederholt werden.

### 6. systemd Service

```bash
sudo nano /etc/systemd/system/refugium-server.service
```

```ini
[Unit]
Description=Refugium Sync Server
After=network.target

[Service]
Type=simple
User=refugium
WorkingDirectory=/home/refugium/refugium/backend
EnvironmentFile=/home/refugium/refugium/backend/.env
ExecStart=/home/refugium/refugium/backend/refugium-server
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable refugium-server
sudo systemctl start refugium-server
sudo journalctl -u refugium-server -f
```

### 7. Firewall

```bash
sudo ufw allow 22/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

### 8. Gesundheitscheck

```bash
curl https://deine-domain.example.com/health
# Erwartete Antwort: ok
```

### 9. App mit eigenem Server verbinden

In `app/lib/core/sync/sync_provider.dart` und `sync_service.dart` die Server-URL anpassen:

```dart
const _serverUrl = 'https://deine-domain.example.com';
```

Dann neu bauen – siehe [Projekt lokal bauen](#projekt-lokal-bauen).

### Updates einspielen

```bash
cd ~/refugium
git pull
cd backend
cargo build --release
sudo setcap 'cap_net_bind_service=+ep' target/release/refugium-server
sudo cp target/release/refugium-server /home/refugium/refugium/backend/refugium-server
sudo systemctl restart refugium-server
sudo journalctl -u refugium-server -n 20 --no-pager
```

---

## Projekt lokal bauen

### Voraussetzungen

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android SDK / Android Studio
- Ein Android-Gerät oder Emulator

### App bauen und installieren

```bash
git clone https://github.com/HanzoTheGreat/refugium.git
cd refugium/app

# Abhängigkeiten holen
flutter pub get

# Code-Generierung (Drift-Schema)
dart run build_runner build --delete-conflicting-outputs

# Debug-Build auf verbundenem Gerät
flutter run

# Release-APK (arm64-v8a)
flutter build apk --split-per-abi --release
# APK liegt unter: build/app/outputs/apk/release/app-arm64-v8a-release.apk
```

### Keystore für Release-Builds

Für signierte Release-APKs braucht es einen Keystore. Entweder den eigenen anlegen:

```bash
keytool -genkey -v -keystore refugium-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias refugium
```

Dann `app/android/key.properties` anlegen:

```properties
storePassword=DEIN_PASSWORT
keyPassword=DEIN_PASSWORT
keyAlias=refugium
storeFile=../../../refugium-release.jks
```

---

## Architektur

```
refugium/
  app/           # Flutter-App (Dart)
    lib/
      core/
        database/      # Drift + SQLCipher (Schema v10)
        sync/          # SyncService, FullSync, SSE, Pairing
        crypto/        # X25519 + AES-256-GCM
        theme/         # AppTheme (Light + Dark)
      features/
        parts/         # Anteile, Consent, Trigger
        switch_tracker/
        emergency_card/
        journal/
    android/
      ...kotlin/       # MainActivity, ForegroundService, BootReceiver
  backend/       # Rust (axum)
    src/
      main.rs
      routes.rs  # API-Endpoints + SSE
      db.rs      # SQLite WAL-Modus
      models.rs
      crypto.rs
      push.rs    # ntfy-Integration
    migrations/
```

### API-Endpoints

```
POST /api/v1/devices/register
POST /api/v1/pairs/invite
POST /api/v1/pairs/join
POST /api/v1/pairs/confirm
POST /api/v1/messages/send
GET  /api/v1/messages/:device_id
POST /api/v1/push/register
GET  /api/v1/sse/:device_id      # Server-Sent Events
GET  /health
```

### Nachrichtentypen

| Typ | Richtung | Inhalt |
|---|---|---|
| `DeviceIntroduction` | Joiner → Initiator | Public Key für ECDH |
| `PublicKeyExchange` | Initiator → Joiner | Public Key für ECDH |
| `SwitchEvent` | Patient → Partner | Anteil-ID, Name, Timestamp |
| `FullSync` | Patient → Partner/Therapeutin | Gefilterter Datensatz (rollenabhängig) |
| `SyncRequest` | Partner/Therapeutin → Patient | Fordert FullSync an |
| `DisconnectEvent` | beide Richtungen | Verbindung trennen |

---

## Datenschutz & Sicherheit

- **Lokal-First:** Alle Daten primär auf dem Gerät. Sync ist optional.
- **Datenbank-Verschlüsselung:** SQLCipher 4.x (AES-256-CBC), Key im Android Keystore.
- **E2E-Verschlüsselung:** X25519 ECDH + AES-256-GCM. Der Server sieht ausschließlich verschlüsselte Payloads.
- **Kein Tracking:** Kein Analytics, kein Crashlytics, keine Telemetrie.
- **Keine Google-Services-Abhängigkeit:** Kein FCM. Push via ntfy (optional, selbst gehostet) oder SSE. Läuft vollständig auf GrapheneOS/LineageOS.
- **Reproduzierbare Builds:** Geplant für F-Droid-Einreichung.

### Bekannte offene Punkte

- Server-Requests sind noch nicht signiert (Ed25519-Signierung geplant)
- `emergenceContext` (Trauma-Entstehungskontext) hat noch kein separates Verschlüsselungs-Layer im UI

---

## Mitmachen

Pull Requests und Issues sind willkommen. Ein paar Punkte vorab:

- Das ist eine App für traumatisierte Menschen. PRs die Gamification, Streaks oder aufdringliche Notifications einführen, werden abgelehnt.
- Neue Features sollten die SAMHSA-Prinzipien für traumainformiertes Design nicht verletzen.
- Vor größeren Änderungen kurz ein Issue öffnen damit wir uns absprechen können.

Besonders gesucht:
- iOS-Entwicklung (Swift/Flutter)
- Klinisches Feedback aus der Traumatherapie-Praxis
- Übersetzungen (aktuell: Deutsch, Englisch geplant)

---

## Lizenz

AGPL-3.0 – siehe [LICENSE](LICENSE).

Kurzversion: Du kannst die App frei nutzen, modifizieren und weitergeben. Wenn du sie auf einem Server betreibst und Änderungen gemacht hast, musst du den Quellcode dieser Änderungen veröffentlichen. Kommerzielle Nutzung ohne Rücksprache ist nicht erlaubt.

---

*Refugium ersetzt keine Psychotherapie.*
