# Crafting Recipes

A cross-platform recipe app built with Flutter and Supabase.

Built by Karoline Siarsky as a personal project.

## Features

- Create, edit and organise recipes with ingredient sections, units and notes
- Meal plans and shopping lists, shareable with other users
- Chat with replies, unread notifications and push notifications (Android)
- Offline recipe creation with sync and conflict detection
- Likes and recipe references

## Tech stack

- **Frontend:** Flutter / Dart (Web, Android, iOS, macOS, Windows, Linux)
- **Backend:** Supabase (PostgreSQL, Auth, Realtime, Row-Level Security)
- **Local storage:** Drift (SQLite)
- **Notifications:** Firebase Cloud Messaging

## Getting started

1. Install Flutter (SDK >= 3.0.5).
2. Copy `.env/dev-example.json` to `.env/dev.json` and fill in your Supabase project values.
3. Apply the SQL files in `supabase/sql/` to your Supabase project, starting with
   `supabase_auth_foundation.sql` and then `supabase_rls_policies.sql`.
4. Run the app:

        flutter pub get
        flutter run --dart-define-from-file=.env/dev.json
