<p align="center">
  <img src="https://raw.githubusercontent.com/sjauijn/immich-face-to-album-HAOS/main/immich_face_to_album/icon.png" alt="icon">
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

---

## Quick Start

---

## Getting the IDs

- Person (face) ID: open a person in the Immich “People / Faces” section; the last path segment in the URL is the ID.
- Album ID: open the target album; the last path segment is the ID.
- Server URL: include scheme and port (e.g. `http://homeassistant.local:[PORT]` or `https://photos.example.com`).
- API Key: generate in Immich settings.

The album must already exist (the tool only adds assets; it does not create albums).

---

## Examples

---

## Verbose Mode

---
