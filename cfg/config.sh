#!/usr/bin/env bash

export GAME_TITLE="Antsy Alien Attack!"
export FPS_ENABLED=0
export MUSIC_ENABLED=1
export SFX_ENABLED=1
export HI_SCORE=1000
export SCORES_FILE="${HOME}/.antsy-alien-attack-scores"

cfg-load(){
  if [ -e ${HOME}/.antsy-alien-attack ]; then
    source ${HOME}/.antsy-alien-attack
  fi
}

cfg-save(){
  cat << END_CFG > ${HOME}/.antsy-alien-attack
FPS_ENABLED=${FPS_ENABLED}
MUSIC_ENABLED=${MUSIC_ENABLED}
SFX_ENABLED=${SFX_ENABLED}
HI_SCORE=${HI_SCORE}
END_CFG
}

# Append the result of a finished game to the high score table.
# Args: PLAYERS LEVEL KILLS P1_SCORE P2_SCORE
# Stored as: BEST|PLAYERS|LEVEL|KILLS|P1_SCORE|P2_SCORE|TIMESTAMP (best score first field for sorting)
# Returns non-zero if the file could not be written; never aborts the game.
highscore-record(){
  local PLAYERS=${1:-1}
  local LEVEL=${2:-0}
  local KILLS=${3:-0}
  local P1=${4:-0}
  local P2=${5:-0}
  local BEST=${P1}
  ((P2 > BEST)) && BEST=${P2}
  local STAMP
  STAMP=$(date '+%Y-%m-%d %H:%M:%S')
  if ! { printf '%d|%d|%d|%d|%d|%d|%s\n' \
           "${BEST}" "${PLAYERS}" "${LEVEL}" "${KILLS}" "${P1}" "${P2}" "${STAMP}" \
           >> "${SCORES_FILE}"; } 2>/dev/null; then
    return 1
  fi
  return 0
}

# Print the top N high score records, best first.
# Args: COUNT (default 10). Returns non-zero (and prints nothing) if unreadable.
highscore-read-top(){
  local COUNT=${1:-10}
  [ -r "${SCORES_FILE}" ] || return 1
  sort -t'|' -k1,1nr "${SCORES_FILE}" 2>/dev/null | head -n "${COUNT}"
}

# Remove the high score table. Returns non-zero if it exists but cannot be removed.
highscore-clear(){
  if [ -e "${SCORES_FILE}" ]; then
    rm -f "${SCORES_FILE}" 2>/dev/null || return 1
  fi
  return 0
}