#!/usr/bin/env bash

# Local high score table. Records are stored, one per line, in a plain text
# file in the player's home directory. Every field is pipe delimited:
#
#   DATE|PLAYERS|P1_SCORE|P2_SCORE|BEST_SCORE|LEVEL|KILLS
#
# BEST_SCORE is the higher of the two player scores and is used for ranking.
# All file access is best-effort: any read/write failure sets
# HIGHSCORE_IO_ERROR so the game can show a hint, but never aborts play.

export SCORES_FILE="${HOME}/.antsy-alien-attack-scores"
export HIGHSCORE_LINES=()
export HIGHSCORE_IO_ERROR=

# Append the just-finished game to the high score file.
# Reads the current game globals (set by game.sh): P1_SCORE, P2_SCORE,
# NUM_PLAYERS, LEVEL, LAST_LEVEL, P1_TOTAL_KILLS, P2_TOTAL_KILLS.
highscore-record() {
  local p1=${P1_SCORE:-0}
  local p2=${P2_SCORE:-0}
  local best=${p1}
  ((p2 > best)) && best=${p2}

  local kills=$(( ${P1_TOTAL_KILLS:-0} + ${P2_TOTAL_KILLS:-0} ))

  # The game increments LEVEL past LAST_LEVEL to trigger victory; cap it so a
  # completed game reports the final level rather than the sentinel value.
  local level=${LEVEL:-0}
  ((level > ${LAST_LEVEL:-5})) && level=${LAST_LEVEL:-5}

  local stamp
  stamp=$(date '+%Y-%m-%d %H:%M' 2>/dev/null) || stamp="unknown"
  [[ -z "${stamp}" ]] && stamp="unknown"

  local line="${stamp}|${NUM_PLAYERS:-1}|${p1}|${p2}|${best}|${level}|${kills}"

  if ! printf '%s\n' "${line}" >> "${SCORES_FILE}" 2>/dev/null; then
    HIGHSCORE_IO_ERROR="Warning: could not save score to ${SCORES_FILE}"
    return 1
  fi
  return 0
}

# Load the top 10 records (by BEST_SCORE, descending) into HIGHSCORE_LINES.
# A missing file is normal and yields an empty list without an error.
highscore-read() {
  HIGHSCORE_LINES=()
  [ -e "${SCORES_FILE}" ] || return 0

  local raw=()
  if ! readarray -t raw < "${SCORES_FILE}" 2>/dev/null; then
    HIGHSCORE_IO_ERROR="Warning: could not read ${SCORES_FILE}"
    return 1
  fi
  ((${#raw[@]} == 0)) && return 0

  readarray -t HIGHSCORE_LINES < <(
    printf '%s\n' "${raw[@]}" | sort -t'|' -k5,5nr 2>/dev/null | head -n 10
  )
  return 0
}

# Remove all stored high scores.
highscore-clear() {
  if [ -e "${SCORES_FILE}" ]; then
    if ! rm -f "${SCORES_FILE}" 2>/dev/null; then
      HIGHSCORE_IO_ERROR="Warning: could not clear ${SCORES_FILE}"
      return 1
    fi
  fi
  HIGHSCORE_LINES=()
  HIGHSCORE_IO_ERROR=
  return 0
}

# Render the high score table into the frame buffer. Drawn once on entry and
# again after a clear; the loop only needs to flush it with render.
highscores-draw() {
  blank-screen
  highscore-read

  draw-centered 1 "${WHT}${BBLK}" "H I G H   S C O R E S"
  draw-centered 2 "${wht}${BBLK}" "====================="

  # All rows share one fixed column offset so they line up as a block.
  local sample
  sample=$(printf "%2s. %-16s  %-2s  P1:%07d  P2:%07d  Lv:%-2s  Kills:%-5s" \
    "10" "0000-00-00 00:00" "2P" 0 0 0 0)
  local offset
  offset=$(center ${#sample})

  if ((${#HIGHSCORE_LINES[@]} == 0)); then
    lol-draw-centered $((SCREEN_HEIGHT / 2)) "No high scores yet. Go blast some aliens!"
  else
    local row=4
    local rank=1
    local line stamp players p1 p2 best level kills mode rowstr
    for line in "${HIGHSCORE_LINES[@]}"; do
      IFS='|' read -r stamp players p1 p2 best level kills <<< "${line}"

      # Skip records that are not rankable; coerce the rest defensively in
      # case the file was edited by hand.
      [[ "${best}" =~ ^[0-9]+$ ]] || continue
      [[ "${p1}" =~ ^[0-9]+$ ]] || p1=0
      [[ "${p2}" =~ ^[0-9]+$ ]] || p2=0
      [[ "${level}" =~ ^[0-9]+$ ]] || level=0
      [[ "${kills}" =~ ^[0-9]+$ ]] || kills=0
      [[ -n "${stamp}" ]] || stamp="unknown"
      mode="1P"
      ((players == 2)) && mode="2P"

      rowstr=$(printf "%2s. %-16s  %-2s  P1:%07d  P2:%07d  Lv:%-2s  Kills:%-5s" \
        "${rank}" "${stamp}" "${mode}" "${p1}" "${p2}" "${level}" "${kills}")
      draw "${offset}" "${row}" "${grn}${BBLK}" "${rowstr}"

      ((row++))
      ((rank++))
      ((rank > 10)) && break
    done
  fi

  draw-centered $((SCREEN_HEIGHT - 3)) "${wht}${BBLK}" "[C] Clear Scores    [Q] or [B] Back to Title"

  if [[ -n "${HIGHSCORE_IO_ERROR}" ]]; then
    draw-centered $((SCREEN_HEIGHT - 1)) "${YLW}${BBLK}" "${HIGHSCORE_IO_ERROR}"
  fi
}

highscores-mode() {
  export DELAY=0.0125
  export KEY=
  export HIGHSCORES_MUSIC_THREAD=

  reset-timers
  music title
  HIGHSCORES_MUSIC_THREAD=$!

  highscores-draw

  export LOOP=highscores-loop
}

highscores-loop() {
  if [[ $KEY == 'q' ]] || [[ $KEY == 'b' ]]; then
    kill-thread ${HIGHSCORES_MUSIC_THREAD}
    title-mode
  elif [[ $KEY == 'c' ]]; then
    highscore-clear
    highscores-draw
    render
  else
    render
  fi
  KEY=
}
