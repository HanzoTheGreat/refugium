# Refugium – Projektstand (10.05.2026)

## Was ist Refugium?

FOSS-App für Menschen mit Dissoziativer Identitätsstörung (DIS) und ihre Angehörigen. Ziel: Alltagsstabilisierung, Co-Bewusstheit, Notfallschutz. Nicht-kommerziell, kein Cloud-Lock-in, kein Tracking. Lizenz: AGPL-3.0. Vertrieb: F-Droid + GitHub Releases (Play Store optional später).

**Zielgruppe:** Betroffene (Patienten-Modus), Partner, Therapeuten (Viewer-Modus, noch nicht implementiert).

**Wichtig:** Die App ersetzt keine Therapie. Sie ist ein Werkzeug zur Alltagsunterstützung.

---

## Stack-Entscheidungen (festgelegt, nicht mehr offen)

| Thema | Entscheidung | Begründung |
|---|---|---|
| Framework | Flutter (Dart) | Pixel-perfect UI, Solo-Dev-tauglich, F-Droid-kompatibel |
| Dev-OS | Void Linux (runit, kein systemd) | Entwicklerrechner |
| MVP-Target | Android-only | Alle Beteiligten nutzen Android |
| iOS | Architektur abstrahiert, Release später via CI | Kein Zugangsproblem aber kein Bedarf jetzt |
| State Management | Riverpod 3.x (manuell, kein Codegen wegen Drift-Konflikt) | StreamProvider/AsyncNotifier |
| DB | Drift + SQLCipher | Typsichere Queries, E2E-verschlüsselt |
| Verschlüsselung DB | SQLCipher, Key in Android Keystore (flutter_secure_storage) | Hardware-gesichert |
| Codegen | build_runner + Drift Codegen + freezed + json_serializable + slang | Standard Flutter-Stack |
| i18n | slang (DE primary, EN secondary) | Typsicher, modular |
| Push | ntfy (selbst gehostet) | Kein FCM, kein Google, FOSS |
| Sync-Backend | axum (Rust) auf Hetzner VPS | Selbst gehostet, skalierbar |
| Backend-DB | SQLite via sqlx | Einfach, ausreichend |

---

## Implementierte Features (App)

### 1. Part-CRUD (Anteile)
- Anlegen, Bearbeiten, Löschen (Soft-Delete via Status)
- Felder: Name, Pronomen, Alter, Rolle, Beschreibung intern/extern
- Sichtbarkeit: Emergency / Partner / Therapist / Internal
- Status: Active / Dormant / Integrated / Hypothetical
- Live-Updates via Drift Stream (kein manuelles invalidate nötig)
- `@DataClassName('PartsData')` wegen Namenskonflikt mit Drift

### 2. Switch-Tracker
- One-Tap Check-in für aktuellen Anteil
- History der letzten 20 Wechsel mit Timestamp
- Consent-Zusammenfassung des aktuellen Anteils direkt sichtbar
- Layout: CustomScrollView (kein Column+Expanded, landscape-safe)

### 3. Consent-Profile
- 1:1 mit Anteil verknüpft
- Felder: Berührung allgemein/intim, Küssen, Kosenamen, Sex, Autofahren, Alkohol, Finanzen, Medizin
- Werte: Yes / AskFirst / No / Unknown
- SegmentedButton ohne Haken (showSelectedIcon: false) – passt auf Smartphone-Breite
- Zugang über Part-Detail-Screen

### 4. Trigger-Profile
- Pro Anteil, mehrere Einträge möglich
- Felder: Beschreibung, Typ (Sensory/Social/Situational/DateBased/Other), Schweregrad (Mild/Moderate/Severe/Critical), Coping-Vorschlag
- Flag: appliesExternally (auf Notfallkarte sichtbar)
- CRUD: hinzufügen, bearbeiten (EditTriggerDialog), löschen
- Farbkodierung nach Schweregrad

### 5. Notfallkarte
- ICD-10: F44.81, "Keine Psychose · Keine Drogen · Keine geistige Behinderung"
- Anteile mit Visibility=Emergency und Status=Active
- Externe Trigger pro Anteil (appliesExternally=true)
- Medizinische Daten (Blutgruppe, Allergien, Medikation, KV)
- Notfallkontakte mit Wissensstand-Chips (Diagnose/Anteile/Trauma – grün/rot)
- Ersthelfer-Hinweise
- PDF-Export via `printing` Package
- PDF enthält alle oben genannten Daten inkl. Trigger und Kontakte

### 6. Notfallkontakte
- CRUD: anlegen, bearbeiten, löschen
- Felder: Name, Beziehung, Telefon, E-Mail, Erreichbarkeit, bevorzugter Kontaktweg
- Wissensstand: kennt Diagnose / Anteile / Trauma
- Reihenfolge per Drag-and-Drop (ReorderableListView)
- Wissensstand auf Notfallkarte direkt sichtbar

### 7. Medizinische Daten
- Singleton (ein Datensatz pro Installation)
- Felder: Blutgruppe, Allergien, Medikation, Diagnosen, Hausarzt, Krankenkasse
- Auf Notfallkarte und im PDF-Export eingebunden

### 8. Journal
- Gemeinsames Tagebuch für alle Anteile
- Pro Eintrag: Anteil (optional), Stimmung (Emoji-Auswahl), Inhalt, Privat-Flag
- CRUD: schreiben, bearbeiten, löschen
- Bottom-Sheet statt eigener Screen

### 9. Pairing / Gerät verbinden
- Device-Registrierung beim ersten App-Start (UUID als Public Key, Device-ID persistent)
- Invite-Code generieren (8 Zeichen, alphanumerisch)
- QR-Code-Anzeige des generierten Codes
- QR-Code scannen via `mobile_scanner`
- Manuelle Code-Eingabe als Fallback
- Rolle wählbar: Partner / Therapeut:in
- Pairing-Flow: Patient generiert Code → Partner gibt ein oder scannt → Patient bestätigt

---

## Datenbankschema (Drift + SQLCipher)

Schema-Version: 7

| Tabelle | Inhalt |
|---|---|
| systems | System-Metadaten (Sprache, Name) |
| parts | Anteile mit allen Feldern, @DataClassName('PartsData') |
| switch_events | Switch-History mit Timestamp, @DataClassName('SwitchEventsData') |
| consent_profiles | 1:1 mit parts, @DataClassName('ConsentProfileData') |
| trigger_entries | N:1 mit parts, @DataClassName('TriggerEntryData') |
| emergency_contacts | Notfallkontakte mit Rang |
| medical_records | Singleton, medizinische Daten |
| journal_entries | Journal-Einträge, optional mit part_id |

**Verschlüsselung:** SQLCipher mit 32-Byte-Hex-Key, generiert via `Random.secure()`, gespeichert in `flutter_secure_storage` (Android Keystore / Secure Enclave).

**Wichtige Implementierungsdetails:**
- `@DataClassName` zwingend nötig bei Parts, SwitchEvents, ConsentProfiles, TriggerEntries, EmergencyContacts, MedicalRecords, JournalEntries – sonst Namenskonflikte
- Riverpod-Codegen funktioniert nicht mit Drift-generierten Typen → manuelle `AsyncNotifier`/`StreamNotifier`-Provider
- `partsProvider` nutzt `.watch()` (Stream) für Live-Updates
- DB-Öffnung via `NativeDatabase` mit SQLCipher PRAGMA, nicht mehr via `driftDatabase()`
- `sqlite3_flutter_libs` aus dem Build ausgeschlossen (Konflikt mit `sqlcipher_flutter_libs`)

---

## Bekannte technische Schulden / TODOs App

- Warnings: unused imports in models/mod.rs (harmlos)
- `emergence_context` Feld in Parts existiert in DB aber hat noch kein UI (hochsensibel, extra Verschlüsselungs-Layer geplant)
- Viewer-Modus (Partner/Therapeut) noch nicht implementiert
- Sichtbarkeits-Hierarchie für Sync noch nicht implementiert
- Push-Empfang in der App noch nicht implementiert (nur Senden)
- Cert-Renewal für Let's Encrypt noch nicht automatisiert
- Kein Request-Authentifizierungscheck auf dem Server (alle Requests werden akzeptiert)

---

## Backend (axum-Server)

### Infrastruktur
- **VPS:** Hetzner CPX22, Helsinki, Ubuntu 24.04
- **IP:** 65.108.149.162
- **Domain:** refugium-sync.dedyn.io (desec.io, DynDNS)
- **DNS:** A-Record noch ausstehend (desec.io Support kontaktiert wegen IP-Whitelist)
- **Aktuell:** Server läuft auf Port 8080 (HTTP, temporär bis TLS steht)
- **Geplant:** Port 443 (HTTPS via rustls + Let's Encrypt)

### Sicherheit VPS
- Root-Login deaktiviert
- Passwort-SSH deaktiviert, nur Key-Auth
- UFW Firewall: nur Port 22 (SSH) und 443 (HTTPS) offen (Port 8080 temporär offen)
- Server läuft als unprivilegierter User `refugium`
- MaxAuthTries: 3

### API-Endpoints

```
POST /api/v1/devices/register     – Gerät registrieren, gibt device_id zurück
POST /api/v1/pairs/invite         – Invite-Code generieren
POST /api/v1/pairs/join           – Mit Invite-Code beitreten
POST /api/v1/pairs/confirm        – Pairing bestätigen
POST /api/v1/messages/send        – Verschlüsselte Nachricht senden
GET  /api/v1/messages/:device_id  – Nachrichten abholen (danach als delivered markiert)
POST /api/v1/push/register        – ntfy-Topic registrieren
GET  /health                      – Health-Check
```

### Nachrichtentypen (message_type)
- `SwitchEvent` – triggert Push-Benachrichtigung via ntfy
- `PartUpdate`
- `ConsentUpdate`
- `FullSync`

### ntfy
- Selbst gehostet auf dem VPS (Port 7867, nur localhost)
- Konfiguration: `/etc/ntfy/server.yml`
- Push bei SwitchEvent: Title "Anteilwechsel", Message "Ein Anteil hat sich eingecheckt"

### Noch nicht implementiert Backend
- TLS (wartet auf DNS-Freischaltung bei desec.io)
- Request-Authentifizierung via Ed25519-Signatur
- E2E-Verschlüsselung der Payloads (ChaCha20-Poly1305 geplant)
- Push-Empfang in Flutter-App (UnifiedPush)

---

## Monorepo-Struktur

```
refugium/
  app/                    # Flutter-App
    lib/
      core/
        database/         # Drift Schema, Migrations, SQLCipher
        sync/             # API-Client, Sync-Provider
        security/         # (leer, geplant)
        router/           # (leer, geplant)
        i18n/             # slang Translations
      features/
        parts/            # Anteile CRUD, Consent, Trigger
        switch_tracker/   # Switch-Tracker, Pairing
        emergency_card/   # Notfallkarte, Kontakte, Medizin
        journal/          # Journal
      shared/             # Widgets, Models, Extensions
  backend/                # axum Rust Server
    src/
      routes/             # API-Endpoints
      models/             # Datenstrukturen + DTOs
      crypto/             # Invite-Code-Generator, UUID
      db/                 # SQLite Pool, Migrationen
      push/               # ntfy-Integration
    migrations/           # SQL-Migrationen
  docs/                   # (leer, geplant)
  design/                 # (leer, geplant)
```

---

## Nächste Schritte (Priorität)

1. **DNS/TLS fertigstellen** – desec.io Support-Antwort abwarten, dann certbot auf VPS, Server auf Port 443
2. **Push-Empfang in Flutter** – UnifiedPush-Integration, App erhält Benachrichtigung wenn Anteil eincheckt
3. **Switch-Event an Server senden** – wenn Anteil eincheckt, Nachricht an Partner-Gerät
4. **Viewer-Modus** – Partner/Therapeut-Modus: read-only, gefiltert nach Sichtbarkeits-Stufen
5. **Request-Authentifizierung** – Ed25519-Signatur auf allen API-Calls
6. **Design-Pass** – trauma-informiertes Design laut SAMHSA-Prinzipien
7. **F-Droid-Einreichung** – wenn App stabil genug

---

## Wichtige Entscheidungen für spätere Chats

- **Kein `FamilyAsyncNotifier`** in Riverpod 3.x – stattdessen einfache Funktionen (`addTrigger(ref, ...)`) oder `StreamProvider.family`
- **`build_runner build`** nach jeder Schema-Änderung zwingend nötig
- **`strings.g.dart` löschen** wenn slang-Konflikt bei build_runner (`InvalidOutputException`)
- **`sqlite3_flutter_libs` ausgeschlossen** in `android/app/build.gradle.kts` via `configurations.all { exclude(module = "sqlite3_flutter_libs") }`
- **compileSdk = 36** explizit setzen wegen sqlcipher_flutter_libs
- **Keystore** liegt unter `~/refugium/refugium-release.jks`, Passwort in Proton Pass
- **VPS-User** `refugium`, nicht root
- **ntfy** läuft auf Port 7867 (localhost only), axum kommuniziert intern damit

---

## Teststand

- **Mischkas Gerät:** App installiert als APK, testet aktiv
- **Entwicklergerät:** Xiaomi, Android 14 (API 34), arm64, ADB-Debugging aktiviert
- **Server:** Läuft, Health-Check erreichbar via `curl http://65.108.149.162:8080/health`
- **Pairing:** Noch nicht live getestet zwischen zwei echten Geräten (DNS ausstehend)
