#!/usr/bin/env bash

export SCORES_FILE="${HOME}/.antsy-alien-attack-scores"

scores-save() {
  local NUM_PLAYERS=${1}
  local BEST_SCORE=${2}
  local LEVEL_REACHED=${3}
  local TOTAL_KILLS=${4}
  local TIMESTAMP
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "0000-00-00 00:00:00")

  if ! printf '%s\n' "${TIMESTAMP}|${NUM_PLAYERS}|${BEST_SCORE}|${LEVEL_REACHED}|${TOTAL_KILLS}" >> "${SCORES_FILE}" 2>/dev/null; then
    lol-draw-centered $((SCREEN_HEIGHT - 2)) "Warning: Could not save high score!"
    render
    sleep 1
  fi
}

scores-load-top() {
  # Print top 10 scores sorted by score descending.
  # Format: rank|timestamp|players|score|level|kills
  if [[ ! -f "${SCORES_FILE}" ]]; then
    return 1
  fi
  if ! sort -t'|' -k3 -n -r "${SCORES_FILE}" 2>/dev/null | head -n 10; then
    return 1
  fi
  return 0
}

scores-clear() {
  if ! rm -f "${SCORES_FILE}" 2>/dev/null; then
    return 1
  fi
  return 0
}
