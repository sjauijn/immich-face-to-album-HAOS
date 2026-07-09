#!/usr/bin/with-contenv bashio

OPTIONS_FILE="/data/options.json"

RUN_EVERY_SECONDS="$(bashio::config 'run_every_seconds')"
VERBOSE="$(bashio::config 'verbose')"
JOB_COUNT="$(jq '.jobs | length' "${OPTIONS_FILE}")"

VERBOSE_FLAG=""
if [ "${VERBOSE}" = "true" ]; then
  VERBOSE_FLAG="--verbose"
fi

run_job() {
  local idx="$1"
  local job
  job="$(jq -c ".jobs[${idx}]" "${OPTIONS_FILE}")"

  local immich_url api_key album_id require_all_faces no_other_faces remove_non_matching timebucket
  immich_url="$(echo "${job}" | jq -r '.immich_url')"
  api_key="$(echo "${job}" | jq -r '.api_key')"
  album_id="$(echo "${job}" | jq -r '.album_id')"
  require_all_faces="$(echo "${job}" | jq -r '.require_all_faces')"
  no_other_faces="$(echo "${job}" | jq -r '.no_other_faces')"
  remove_non_matching="$(echo "${job}" | jq -r '.remove_non_matching')"
  timebucket="$(echo "${job}" | jq -r '.timebucket // "MONTH"')"

  if [ -z "${immich_url}" ] || [ "${immich_url}" = "null" ] || \
     [ -z "${api_key}" ] || [ "${api_key}" = "null" ] || \
     [ -z "${album_id}" ] || [ "${album_id}" = "null" ]; then
    bashio::log.warning "Job ${idx}: skipped, missing immich_url / api_key / album_id"
    return 0
  fi

  local -a face_args=()
  local face_count
  face_count="$(echo "${job}" | jq '.faces | length')"
  for ((f = 0; f < face_count; f++)); do
    local face_id
    face_id="$(echo "${job}" | jq -r ".faces[${f}]")"
    if [ -n "${face_id}" ] && [ "${face_id}" != "null" ]; then
      face_args+=(--face "${face_id}")
    fi
  done

  if [ "${#face_args[@]}" -eq 0 ]; then
    bashio::log.warning "Job ${idx}: skipped, no face IDs configured"
    return 0
  fi

  local -a skip_args=()
  local skip_count
  skip_count="$(echo "${job}" | jq '.skip_faces | length')"
  for ((s = 0; s < skip_count; s++)); do
    local skip_id
    skip_id="$(echo "${job}" | jq -r ".skip_faces[${s}]")"
    if [ -n "${skip_id}" ] && [ "${skip_id}" != "null" ]; then
      skip_args+=(--skip-face "${skip_id}")
    fi
  done

  local -a bool_args=()
  [ "${require_all_faces}" = "true" ] && bool_args+=(--require-all-faces)
  [ "${no_other_faces}" = "true" ] && bool_args+=(--no-other-faces)
  [ "${remove_non_matching}" = "true" ] && bool_args+=(--remove-non-matching)

  bashio::log.info "Job ${idx}: syncing to album ${album_id} on ${immich_url}"

  python3 -m immich_face_to_album \
    --key "${api_key}" \
    --server "${immich_url}" \
    "${face_args[@]}" \
    "${skip_args[@]}" \
    --album "${album_id}" \
    --timebucket "${timebucket}" \
    "${bool_args[@]}" \
    ${VERBOSE_FLAG}
}

bashio::log.info "Starting immich-face-to-album with ${JOB_COUNT} job(s)"

while true; do
  for ((i = 0; i < JOB_COUNT; i++)); do
    run_job "${i}"
  done

  if [ -z "${RUN_EVERY_SECONDS}" ] || [ "${RUN_EVERY_SECONDS}" -le 0 ]; then
    bashio::log.info "run_every_seconds <= 0, exiting after single pass"
    break
  fi

  bashio::log.info "Sleeping ${RUN_EVERY_SECONDS}s before next pass"
  sleep "${RUN_EVERY_SECONDS}"
done
