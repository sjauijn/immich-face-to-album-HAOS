## v1.0.16
- Merged with the [v1.0.16](https://github.com/romainrbr/immich-face-to-album/releases/tag/1.0.16) of the original app.
- Switched asset lookup from the `timeline/buckets` + `timeline/bucket` + per-asset `GET /assets/{id}` calls to Immich's `POST /api/search/metadata` with `personIds` and `withPeople: true`. Fewer requests, no more per-asset fetch to check `--no-other-faces`.
- Added incremental sync: after a job's first successful run, only assets created since that job's last run are fetched. Tracked per-`album_id` in a shared `/data/state.json`, so it works safely across multiple jobs and multiple Immich servers. Automatically falls back to a full re-scan when a job's config changes or when `remove_non_matching` is enabled for it.
- Removed the `timebucket` option — it was specific to the old timeline-based lookup and has no equivalent in the new API.

## v1.0.14
- Initial release for Home Assistant!
- fully merged with [v1.0.14](https://github.com/romainrbr/immich-face-to-album/releases/tag/1.0.14) of original app
