#!/usr/bin/env bash

# High Scores Module for Antsy Alien Attack
# Score file format: BEST_SCORE|NUM_PLAYERS|P1_SCORE|P2_SCORE|LEVEL|P1_KILLS|P2_KILLS|TIMESTAMP

scores-save() {
  local P1_SCORE_VAL=${P1_SCORE:-0}
  local P2_SCORE_VAL=${P2_SCORE:-0}
  local P1_KILLS_TOTAL=$(( ${P1_TOTAL_KILLS:-0} + ${P1_KILLS:-0} ))
  local P2_KILLS_TOTAL=$(( ${P2_TOTAL_KILLS:-0} + ${P2_KILLS:-0} ))
  local LEVEL_VAL=${LEVEL:-0}
  local NUM_PLAYERS_VAL=${NUM_PLAYERS:-1}
  local BEST_SCORE=${P1_SCORE_VAL}
  if (( P2_SCORE_VAL > BEST_SCORE )); then
    BEST_SCORE=${P2_SCORE_VAL}
  fi
  local TIMESTAMP
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S" 2>/dev/null) || TIMESTAMP="unknown"
  local ENTRY="${BEST_SCORE}|${NUM_PLAYERS_VAL}|${P1_SCORE_VAL}|${P2_SCORE_VAL}|${LEVEL_VAL}|${P1_KILLS_TOTAL}|${P2_KILLS_TOTAL}|${TIMESTAMP}"
  if ! echo "${ENTRY}" >> "${SCORES_FILE}" 2>/dev/null; then
    return 1
  fi
}

scores-load() {
  local MAX=${1:-10}
  if [[ ! -f "${SCORES_FILE}" ]]; then
    return 0
  fi
  sort -t'|' -k1 -nr "${SCORES_FILE}" 2>/dev/null | head -n "${MAX}"
}

scores-display() {
  blank-screen
  local Y_START=3
  lol-draw-centered ${Y_START} "H I G H   S C O R E S"
  draw-centered $((Y_START + 1)) "${WHT}${BBLK}" "------------------------------------------"
  draw-centered $((Y_START + 2)) "${YLW}${BBLK}" " #  MODE  SCORE      LVL  KILLS  DATE"
  draw-centered $((Y_START + 3)) "${WHT}${BBLK}" "------------------------------------------"

  local LINE_NUM=0
  local Y_ROW=$((Y_START + 4))
  local SCORES_DATA
  SCORES_DATA=$(scores-load 10)

  if [[ -z "${SCORES_DATA}" ]]; then
    draw-centered $((Y_START + 8)) "${wht}${BBLK}" "No scores recorded yet."
    draw-centered $((Y_START + 9)) "${wht}${BBLK}" "Play a game to set the first record!"
  else
    while IFS='|' read -r BEST NUM_P P1S P2S LVL P1K P2K TS; do
      ((LINE_NUM++))
      local MODE_STR="1P"
      local SCORE_STR
      local KILLS_STR
      if (( NUM_P == 2 )); then
        MODE_STR="2P"
        SCORE_STR="$(printf '%07d' ${P1S})/$(printf '%07d' ${P2S})"
        KILLS_STR="${P1K}/${P2K}"
      else
        SCORE_STR="$(printf '%07d' ${P1S})"
        KILLS_STR="${P1K}"
      fi
      local RANK_PAD
      RANK_PAD=$(printf "%2d" ${LINE_NUM})
      local ROW="${RANK_PAD}  ${MODE_STR}    ${SCORE_STR}   $(printf '%2d' ${LVL})   ${KILLS_STR}   ${TS}"
      draw-centered ${Y_ROW} "${wht}${BBLK}" "${ROW}"
      ((Y_ROW++))
    done <<< "${SCORES_DATA}"
  fi

  draw-centered $((SCREEN_HEIGHT - 4)) "${YLW}${BBLK}" "[C] Clear Scores        [Any Key] Back"
  render
}

scores-clear() {
  if rm -f "${SCORES_FILE}" 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

highscores-mode() {
  export DELAY=0.0125
  export KEY=
  scores-display
  export LOOP=highscores-loop
}

highscores-loop() {
  if [[ $KEY == 'c' ]]; then
    scores-clear
    scores-display
  elif [[ -n $KEY ]]; then
    title-mode
  fi
  KEY=
}
