<p align="center">
  <img src="https://raw.githubusercontent.com/sjauijn/immich-face-to-album-HAOS/main/icon.png" alt="icon">
</p>

# Immich Face To Album

I maintain this app, along with my other Home Assistant apps, solely for my own use. As long as I'm actively using them myself, I'll continue developing and updating them; otherwise, support for apps I no longer need will be discontinued.

## About

Sync all photos belonging to one or more detected faces into an existing Immich album (similar to Google Photos “live / auto-updating albums”).

## Installation

1. Click to add the stable repository:
   [![Add Stable Repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/sjauijn/immich-face-to-album-HAOS) 

2. Or manually add:

   ```text
   https://github.com/sjauijn/immich-face-to-album-HAOS
   ```

## Quick Start

1. Open the **Configuration** tab of the add-on and fill in one entry under **Sync jobs**:
   - `immich_url` — your Immich server URL (with scheme and port)
   - `api_key` — an API key generated on that Immich account
   - `album_id` — the ID of an existing album
   - `faces` — one or more person (face) IDs to sync
2. Save the configuration, then start the add-on.
3. Check the **Log** tab to confirm assets were added to the album.

By default the add-on runs once, adds matching assets, then repeats every `run_every_seconds` (600s / 10 minutes). Set `run_every_seconds` to `0` if you'd rather trigger a single sync from a Home Assistant automation (e.g. via the Supervisor "Start add-on" service) than run it continuously.

## Getting the IDs

- Person (face) ID: open a person in the Immich “People / Faces” section; the last path segment in the URL is the ID.
- Album ID: open the target album; the last path segment is the ID.
- Server URL: include scheme and port (e.g. `http://homeassistant.local:8080` or `https://photos.example.com`).
- API Key: generate in Immich settings.

The album must already exist (the tool only adds assets; it does not create albums).

## Configuration Options

Two global options apply to every job:

| Option | Default | Description |
|--------|---------|--------------|
| `run_every_seconds` | `600` | How often to re-run **all** jobs, in seconds. `0` runs once and exits (useful if you trigger the add-on from a Home Assistant automation instead). |
| `verbose` | `false` | Print detailed API calls for every job — helpful when troubleshooting, but noisy for normal use. |

Each entry under `jobs` syncs one album from one Immich account:

| Option | Required | Default | Description |
|--------|----------|---------|--------------|
| `immich_url` | Yes | — | Immich server URL, with scheme and port. |
| `api_key` | Yes | — | API key generated on this Immich account. |
| `album_id` | Yes | — | ID of the existing target album. |
| `faces` | Yes | — | One or more person IDs to include. Combined with AND/OR depending on `require_all_faces`. |
| `skip_faces` | No | *(empty)* | Person IDs to exclude. Assets containing any of these people are always excluded, regardless of other options. |
| `require_all_faces` | No | `true` | When enabled, only assets containing **every** ID in `faces` are added (AND). When disabled, assets containing **any** ID in `faces` are added (OR). |
| `no_other_faces` | No | `false` | Reject assets that contain any recognized person outside the `faces` set — even if they'd otherwise match. |
| `remove_non_matching` | No | `false` | ⚠️ Also **removes** assets already in the album that no longer satisfy the criteria above. Leave disabled if the add-on should only ever add assets, never remove them. |
| `timebucket` | No | `MONTH` | Internal paging granularity used when querying Immich (`MONTH`, `WEEK`, or `DAY`). Rarely needs changing. |

A job with a missing `immich_url`, `api_key`, `album_id`, or `faces` is skipped (with a warning in the log) rather than stopping the other jobs.

### Multiple jobs

`jobs` is a list, so a single add-on instance can keep several albums in sync at once — even across different Immich servers or accounts. Click **Add** under **Sync jobs** in the Configuration tab to add another entry. Every job in the list runs, in order, on each pass; `run_every_seconds` and `verbose` apply to all of them together.

## Examples

**Everyone in one album (OR):** include photos of either of two people.
```yaml
run_every_seconds: 600
verbose: false
jobs:
  - immich_url: "https://immich.example.com"
    api_key: "xxxxx"
    album_id: "album-id-here"
    faces:
      - "person-id-1"
      - "person-id-2"
    require_all_faces: false
    no_other_faces: false
    remove_non_matching: false
    timebucket: MONTH
```

**Photos of you together (AND):** only include assets where both people appear.
```yaml
run_every_seconds: 600
verbose: false
jobs:
  - immich_url: "https://immich.example.com"
    api_key: "xxxxx"
    album_id: "album-id-here"
    faces:
      - "person-id-1"
      - "person-id-2"
    require_all_faces: true
    no_other_faces: false
    remove_non_matching: false
    timebucket: MONTH
```

**Exclude a person:** gather two faces, but drop any asset that also contains a third.
```yaml
run_every_seconds: 600
verbose: false
jobs:
  - immich_url: "https://immich.example.com"
    api_key: "xxxxx"
    album_id: "album-id-here"
    faces:
      - "person-id-1"
      - "person-id-2"
    skip_faces:
      - "person-id-3"
    require_all_faces: false
    no_other_faces: false
    remove_non_matching: false
    timebucket: MONTH
```

**Two albums, two accounts, one add-on:**
```yaml
run_every_seconds: 600
verbose: false
jobs:
  - immich_url: "https://immich.example.com"
    api_key: "key-for-account-1"
    album_id: "kids-album-id"
    faces:
      - "kid-1-id"
      - "kid-2-id"
    require_all_faces: false
    no_other_faces: false
    remove_non_matching: false
    timebucket: MONTH
  - immich_url: "https://immich-2.example.com"
    api_key: "key-for-account-2"
    album_id: "us-album-id"
    faces:
      - "partner-1-id"
      - "partner-2-id"
    require_all_faces: true
    no_other_faces: false
    remove_non_matching: false
    timebucket: MONTH
```

## Big thanks to:
[@romainrbr](https://github.com/romainrbr/immich-face-to-album) for awesome work

[@ajb3932](https://github.com/ajb3932/immich-partner-sharing) for nice logo
