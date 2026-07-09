# Immich Face To Album

HAOS wrapper for [immich-face-to-album](https://github.com/romainrbr/immich-face-to-album).

Add-only by default: assets are added to the target album, never removed,
unless "Remove non-matching" is enabled for a job. The target album must
already exist on each account and, for multi-account jobs, be shared with
that account with the Editor role.

Each entry in `jobs` runs independently with its own server URL, API key and
face IDs (person IDs are per-account in Immich, so the same real person will
have a different ID on each account).
