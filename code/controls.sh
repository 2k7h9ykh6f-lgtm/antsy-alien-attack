#!/usr/bin/env bash

# In-game key binding configuration. Reuses the same signal-driven model as
# title-loop: controls-mode swaps ${LOOP} to controls-loop, which runs once per
# USR1 tick and consumes the shared global ${KEY}.

controls-mode() {
  # The 14 bindable actions, in the order they are listed on screen.
  CONTROLS_VARS=(
    P1_KEY_UP P1_KEY_DOWN P1_KEY_LEFT P1_KEY_RIGHT P1_KEY_FIRE P1_KEY_BOMB P1_KEY_PAUSE
    P2_KEY_UP P2_KEY_DOWN P2_KEY_LEFT P2_KEY_RIGHT P2_KEY_FIRE P2_KEY_BOMB P2_KEY_PAUSE
  )
  CONTROLS_LABELS=(
    "P1 Up" "P1 Down" "P1 Left" "P1 Right" "P1 Fire" "P1 Bomb" "P1 Pause"
    "P2 Up" "P2 Down" "P2 Left" "P2 Right" "P2 Fire" "P2 Bomb" "P2 Pause"
  )
  export CONTROLS_CURSOR=0
  export CONTROLS_CAPTURE=0
  export CONTROLS_MSG=
  export KEY=
  controls-draw
  export LOOP=controls-loop
}

controls-draw() {
  local TOP=$(( SCREEN_HEIGHT / 2 - 5 ))
  local LX=$(( SCREEN_WIDTH / 2 - 20 ))
  local RX=$(( SCREEN_WIDTH / 2 + 2 ))
  local LOOP=0
  local ROW=
  local COLOR=
  local MARKER=
  local X=0
  local Y=0

  blank-screen
  draw-centered $((TOP - 2)) "${YLW}${BBLK}" "C O N F I G U R E   C O N T R O L S"

  for LOOP in "${!CONTROLS_VARS[@]}"; do
    if ((LOOP < 7)); then
      X=${LX}
      Y=$((TOP + LOOP))
    else
      X=${RX}
      Y=$((TOP + LOOP - 7))
    fi
    if ((LOOP == CONTROLS_CURSOR)); then
      COLOR="${BLK}${BWHT}"
      MARKER=">"
    else
      COLOR="${WHT}${BBLK}"
      MARKER=" "
    fi
    printf -v ROW "%s %-9s [ %s ]" "${MARKER}" "${CONTROLS_LABELS[${LOOP}]}" "${!CONTROLS_VARS[${LOOP}]}"
    draw "${X}" "${Y}" "${COLOR}" "${ROW}"
  done

  draw-centered $((TOP + 9)) "${WHT}${BBLK}" "[W]/[S] Move    [SPACE] Rebind    [Q] Back"
  if [[ -n ${CONTROLS_MSG} ]]; then
    draw-centered $((TOP + 11)) "${ylw}${BBLK}" "${CONTROLS_MSG}"
  fi
  render
}

# Returns 0 if CANDIDATE may be assigned to the binding at SLOT, otherwise sets
# CONTROLS_MSG to the reason and returns 1. Rejecting cross-slot duplicates is
# what prevents two players from ever sharing a key in 2P mode.
controls-key-valid() {
  local CANDIDATE=${1}
  local SLOT=${2}
  local LOOP=0

  if [[ -z ${CANDIDATE} ]]; then
    CONTROLS_MSG="No key detected, try again."
    return 1
  fi
  if [[ ${CANDIDATE} == 'q' ]]; then
    CONTROLS_MSG="'q' is reserved for quit/back."
    return 1
  fi
  if [[ ${CANDIDATE} == ' ' ]]; then
    CONTROLS_MSG="Space is reserved, choose another key."
    return 1
  fi
  if [[ ${CANDIDATE} == "'" ]]; then
    CONTROLS_MSG="That key cannot be used."
    return 1
  fi
  for LOOP in "${!CONTROLS_VARS[@]}"; do
    if ((LOOP != SLOT)) && [[ ${!CONTROLS_VARS[${LOOP}]} == "${CANDIDATE}" ]]; then
      CONTROLS_MSG="Already used by ${CONTROLS_LABELS[${LOOP}]} - pick another."
      return 1
    fi
  done
  return 0
}

controls-loop() {
  # Idle tick: nothing pressed, leave the menu as-is (avoids redraw flicker).
  if [[ -z ${KEY} ]]; then
    return 0
  fi

  if ((CONTROLS_CAPTURE == 1)); then
    # Awaiting the new key for the selected binding.
    if [[ ${KEY} == $'\e' ]]; then
      CONTROLS_CAPTURE=0
      CONTROLS_MSG="Cancelled."
    elif controls-key-valid "${KEY}" "${CONTROLS_CURSOR}"; then
      # The P*_KEY_* vars are already exported (see cfg/config.sh); printf -v
      # updates the value in place and preserves the export attribute.
      printf -v "${CONTROLS_VARS[${CONTROLS_CURSOR}]}" '%s' "${KEY}"
      cfg-save
      CONTROLS_CAPTURE=0
      CONTROLS_MSG="Saved ${CONTROLS_LABELS[${CONTROLS_CURSOR}]} = [ ${KEY} ]"
    fi
    # On an invalid key controls-key-valid set CONTROLS_MSG; stay in capture.
  else
    case ${KEY} in
      'w')
        if ((CONTROLS_CURSOR > 0)); then
          ((CONTROLS_CURSOR--))
        else
          CONTROLS_CURSOR=13
        fi
        CONTROLS_MSG=
        ;;
      's')
        if ((CONTROLS_CURSOR < 13)); then
          ((CONTROLS_CURSOR++))
        else
          CONTROLS_CURSOR=0
        fi
        CONTROLS_MSG=
        ;;
      ' ')
        CONTROLS_CAPTURE=1
        CONTROLS_MSG="Press a key for ${CONTROLS_LABELS[${CONTROLS_CURSOR}]} (ESC cancels)"
        ;;
      'q')
        blank-screen
        CONTROLS_MSG=
        KEY=
        export LOOP=title-loop
        return 0
        ;;
    esac
  fi

  controls-draw
  KEY=
}
