#!/usr/bin/env bash

toggle-status(){
  export MUS_TOG="[ ♫ ]"
  export SFX_TOG="[ ♪ ]"
  export FPS_TOG="[ ≈ ]"
  if ((MUSIC_ENABLED == 0)); then
    MUS_TOG="[   ]"
  fi
  if ((SFX_ENABLED == 0)); then
    SFX_TOG="[   ]"
  fi
  if ((FPS_ENABLED == 0)); then
    FPS_TOG="[   ]"
  fi
}

attract-mode() {
  if ((TITLE_SCREEN_ATTRACT_COUNT >= TITLE_SCREEN_ATTRACT_MAX)); then
    blank-screen
    toggle-status
    P1_SHIELDS=0
    P2_SHIELDS=0
    HI_SCORE_PADDED=$(printf "%07d" ${HI_SCORE})
    draw-centered 0 "${WHT}${BBLK}" "HISCORE ${HI_SCORE_PADDED}"
    case ${TITLE_SCREEN_ATTRACT_MODE} in
      0) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "T H E   S T O R Y"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-----------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "The year is 2138. Planet Earth is under attack by aliens, and they're antsy!"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "You're a mercenary with a state of the art space fighter and a gun for hire."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "The United Federation of Planet Earth has hired you to dispatch the aliens"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "and restore calm."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "Your contact features performance-related pay. Earn money for each alien"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "destroyed with financial penalties for each alien that escapes. Efficient use"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "of lasers is rewarded. Collect power-ups to enhance your ship and earn bonuses."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "Go get 'em!"
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      1) local KU KL KD KR KF
         KU=$(key-name "${P1_KEY_UP}"); KL=$(key-name "${P1_KEY_LEFT}")
         KD=$(key-name "${P1_KEY_DOWN}"); KR=$(key-name "${P1_KEY_RIGHT}")
         KF=$(key-name "${P1_KEY_FIRE}")
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 1   C O N T R O L S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "${KU}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "${KL} ←   → ${KR}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "${KD}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[${KF}] Unleash the lasers"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      2) local KU KL KD KR KF
         KU=$(key-name "${P2_KEY_UP}"); KL=$(key-name "${P2_KEY_LEFT}")
         KD=$(key-name "${P2_KEY_DOWN}"); KR=$(key-name "${P2_KEY_RIGHT}")
         KF=$(key-name "${P2_KEY_FIRE}")
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 2   C O N T R O L S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "${KU}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "${KL} ←   → ${KR}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "${KD}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[${KF}] Unleash the lasers"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      3) lol-draw-centered $((SCREEN_HEIGHT / 2 -  1)) "P O W E R   U P S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 +  0)) "-----------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 +  1)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 +  2)) "    $ylw\$   Bonus      "
         lol-draw-centered $((SCREEN_HEIGHT / 2 +  3)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 +  4)) "    $red♥   Extra Life  "
         lol-draw-centered $((SCREEN_HEIGHT / 2 +  5)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 +  6)) "    $cyn☼   Smart Bomb  "
         lol-draw-centered $((SCREEN_HEIGHT / 2 +  7)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 +  8)) "    $grn≡   Shields     "
         lol-draw-centered $((SCREEN_HEIGHT / 2 +  9)) ""
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "    $mgn‼   Fire Power  "
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      4) local HUNTER_X=$(( (SCREEN_WIDTH / 2) - (FIGHTER_WIDTH / 2) ))
         local HUNTER_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "T H E   H U N T E R"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------"
         draw-sprite-unmasked ${HUNTER_X} ${HUNTER_Y} "${HUNTER_SPRITE[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "Flies toward the nearest player ship."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Fires lasers in a straight line."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      5) local SNIPER_X=$(( (SCREEN_WIDTH / 2) - (FIGHTER_WIDTH / 2) ))
         local SNIPER_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "T H E   S N I P E R"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------"
         draw-sprite-unmasked ${SNIPER_X} ${SNIPER_Y} "${SNIPER_SPRITE[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "Flies mostly in straight lines."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Fires homing missles."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      6) local MANAGER_X=$(( (SCREEN_WIDTH / 2) - (BOSS_SMALL_WIDTH / 2) ))
         local MANAGER_Y=$(( SCREEN_HEIGHT / 2 + 2 ))
         BOSS_TYPE=0
         compose-sprites
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "M A N A G E R   C L A S S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------"
         draw-sprite-unmasked ${MANAGER_X} ${MANAGER_Y} "${BOSS_SMALL_0[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Evasive latreal flight path."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 12)) "Unleashes a modest salvo."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      7) local DIRECTOR_X=$(( (SCREEN_WIDTH / 2) - (BOSS_MEDIUM_WIDTH / 2) ))
         local DIRECTOR_Y=$(( SCREEN_HEIGHT / 2 + 1 ))
         BOSS_TYPE=1
         compose-sprites
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "D I R E C T O R   C L A S S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "---------------------------"
         draw-sprite-unmasked ${DIRECTOR_X} ${DIRECTOR_Y} "${BOSS_MEDIUM_0[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Evasive latreal flight path."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 12)) "Unleashes a considerable salvo."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      8) local PRESIDENT_X=$(( (SCREEN_WIDTH / 2) - (BOSS_LARGE_WIDTH / 2) ))
         local PRESIDENT_Y=$(( SCREEN_HEIGHT / 2 + 1 ))
         BOSS_TYPE=2
         compose-sprites
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "E L   P R E S I D E N T E"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------"
         draw-sprite-unmasked ${PRESIDENT_X} ${PRESIDENT_Y} "${BOSS_LARGE_0[@]}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Evasive latreal flight path."
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 12)) "Unleashes a devasting salvo."
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      9) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C O N F I G U R A T I O N"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "M = Toggle Music: ${MUS_TOG}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "S = Toggle Sound: ${SFX_TOG}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "F = Toggle FPS:   ${FPS_TOG}"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "C = Configure Controls"
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
     10) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "C R E D I T S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Code: Martin Wimpress"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "Graphics: Agatha Wimpress"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "Music: Patrick de Arteaga"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "Sound: Kenney Vleugels & Viktor Hahn"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
    esac
    ((TITLE_SCREEN_ATTRACT_MODE >= TITLE_SCREEN_ATTRACT_MODE_MAX)) && TITLE_SCREEN_ATTRACT_MODE=0 || ((TITLE_SCREEN_ATTRACT_MODE++))
  fi
  ((TITLE_SCREEN_ATTRACT_COUNT >= TITLE_SCREEN_ATTRACT_MAX)) && TITLE_SCREEN_ATTRACT_COUNT=0 || ((TITLE_SCREEN_ATTRACT_COUNT++))
}

title-mode() {
  export DELAY=0.0125
  export KEY=
  export TITLE_MUSIC_THREAD=
  export TITLE_SCREEN=()
  export TITLE_SCREEN_OFFSET=
  export TITLE_SCREEN_ATTRACT_MAX=500
  export TITLE_SCREEN_ATTRACT_COUNT=500
  export TITLE_SCREEN_ATTRACT_MODE=0
  export TITLE_SCREEN_ATTRACT_MODE_MAX=10

  reset-timers
  music title
  TITLE_MUSIC_THREAD=$!

  readarray -t TITLE_SCREEN < gfx/title.ans
  TITLE_SCREEN_LONGEST_LINE=$(wc -L gfx/title.txt | cut -d' ' -f1)
  TITLE_SCREEN_OFFSET=$(center ${TITLE_SCREEN_LONGEST_LINE})

  export LOOP=title-loop
}

title-loop() {
  if [[ $KEY == '1' ]] || [[ $KEY == '2' ]]; then
    kill-thread ${TITLE_MUSIC_THREAD}
    game-mode ${KEY}
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${TITLE_MUSIC_THREAD}
    teardown
  elif [[ $KEY == 'm' ]]; then
    if ((MUSIC_ENABLED == 1)); then
      MUSIC_ENABLED=0
      music-setup
      kill-thread ${TITLE_MUSIC_THREAD}
      sound switch-off
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "M = Toggle Music: ${MUS_TOG}"
      fi
      cfg-save
    elif ((MUSIC_ENABLED == 0)); then
      MUSIC_ENABLED=1
      music-setup
      music title
      TITLE_MUSIC_THREAD=$!
      sound switch-on
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "M = Toggle Music: ${MUS_TOG}"
      fi
      cfg-save
    fi
  elif [[ $KEY == 's' ]]; then
    if ((SFX_ENABLED == 1)); then
      SFX_ENABLED=0
      sound-setup
      sound switch-off
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "S = Toggle Sound: ${SFX_TOG}"
      fi
      cfg-save
    elif ((SFX_ENABLED == 0)); then
      SFX_ENABLED=1
      sound-setup
      sound switch-on
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "S = Toggle Sound: ${SFX_TOG}"
      fi
      cfg-save
    fi
  elif [[ $KEY == 'f' ]]; then
    if ((FPS_ENABLED == 1)); then
      FPS_ENABLED=0
      fps-counter-erase
      sound switch-off
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "F = Toggle FPS:   ${FPS_TOG}"
      fi
      cfg-save
    elif ((FPS_ENABLED == 0)); then
      FPS_ENABLED=1
      toggle-status
      if ((TITLE_SCREEN_ATTRACT_MODE == 10)); then
        lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) "F = Toggle FPS:   ${FPS_TOG}"
      fi
      sound switch-on
      cfg-save
    fi
  elif [[ $KEY == 'c' ]]; then
    controls-menu
  else
    attract-mode
    wave-picture "${TITLE_SCREEN_OFFSET}" "${TITLE_SCREEN[@]}"
    local MULTIPLIER=4
    local P1_X=$(( (SCREEN_WIDTH / 2) - (P1_WIDTH * MULTIPLIER) ))
    local P1_Y=$(( SCREEN_HEIGHT - (P1_HEIGHT * 2) ))
    local P2_X=$(( (SCREEN_WIDTH / 2) + (P2_WIDTH * (MULTIPLIER - 1)) ))
    local P2_Y=$(( SCREEN_HEIGHT - (P2_HEIGHT * 2) ))
    compose-sprites
    draw-sprite-unmasked ${P1_X} ${P1_Y} "${P1_SPRITE[@]}"
    draw-sprite-unmasked ${P2_X} ${P2_Y} "${P2_SPRITE[@]}"
    render
  fi
  KEY=
}

# ---------- Controls submenu ----------

# Human-readable labels for each binding slot (parallel to KEY_BINDING_NAMES)
readonly CTRL_LABELS=(
  "P1 Up" "P1 Down" "P1 Left" "P1 Right" "P1 Fire" "P1 Bomb" "P1 Pause"
  "P2 Up" "P2 Down" "P2 Left" "P2 Right" "P2 Fire" "P2 Bomb" "P2 Pause"
)

controls-menu() {
  blank-screen
  local MID=$((SCREEN_HEIGHT / 2))
  local P1_COL=$((SCREEN_WIDTH / 6))
  local P2_COL=$((SCREEN_WIDTH / 2 + SCREEN_WIDTH / 8))
  local I VAL LABEL

  lol-draw-centered $((MID - 6)) "C O N T R O L S"
  lol-draw-centered $((MID - 5)) "---------------"

  draw ${P1_COL} $((MID - 4)) "${WHT}${BBLK}" "PLAYER 1"
  draw ${P2_COL} $((MID - 4)) "${WHT}${BBLK}" "PLAYER 2"

  for I in "${!KEY_BINDING_NAMES[@]}"; do
    eval "VAL=\${${KEY_BINDING_NAMES[$I]}}"
    LABEL="${CTRL_LABELS[$I]}"
    local KN
    KN=$(key-name "${VAL}")
    if ((I < 7)); then
      # P1 column (left)
      draw ${P1_COL} $((MID - 2 + I)) "${WHT}${BBLK}" "[$((I+1))] ${LABEL}: ${KN}"
    else
      # P2 column (right)
      draw ${P2_COL} $((MID - 2 + I - 7)) "${WHT}${BBLK}" "[$((I+1))] ${LABEL}: ${KN}"
    fi
  done

  local FOOTER_Y=$((MID + 7))
  lol-draw-centered ${FOOTER_Y}     "Select [1]-[9],[0],[A]-[D] to rebind a key"
  lol-draw-centered $((FOOTER_Y+2)) "[R] Reset to defaults    [ESC] Back"
  render
  export LOOP=controls-loop
}

controls-loop() {
  local ACTION_INDEX=

  case "${KEY}" in
    '1') ACTION_INDEX=0 ;;
    '2') ACTION_INDEX=1 ;;
    '3') ACTION_INDEX=2 ;;
    '4') ACTION_INDEX=3 ;;
    '5') ACTION_INDEX=4 ;;
    '6') ACTION_INDEX=5 ;;
    '7') ACTION_INDEX=6 ;;
    '8') ACTION_INDEX=7 ;;
    '9') ACTION_INDEX=8 ;;
    '0') ACTION_INDEX=9 ;;
    'A'|'a') ACTION_INDEX=10 ;;
    'B'|'b') ACTION_INDEX=11 ;;
    'C'|'c') ACTION_INDEX=12 ;;  # Note: lowercase c would normally be reserved, but we are in controls context
    'D'|'d') ACTION_INDEX=13 ;;
    'r'|'R')
      reset-key-bindings
      cfg-save
      controls-menu
      KEY=
      return
      ;;
    $'\x1b')
      # Return to title
      export LOOP=title-loop
      KEY=
      return
      ;;
    *)
      KEY=
      return
      ;;
  esac

  if [[ -n "${ACTION_INDEX}" ]] && ((ACTION_INDEX >= 0 && ACTION_INDEX < ${#KEY_BINDING_NAMES[@]})); then
    export REBIND_INDEX=${ACTION_INDEX}
    export REBIND_VAR="${KEY_BINDING_NAMES[$ACTION_INDEX]}"
    export REBIND_LABEL="${CTRL_LABELS[$ACTION_INDEX]}"
    controls-rebind-prompt
  fi
  KEY=
}

controls-rebind-prompt() {
  local MID=$((SCREEN_HEIGHT / 2))
  # Clear footer area and show prompt
  local Y=$((MID + 9))
  local BLANK_LINE
  BLANK_LINE=$(repeat " " "${SCREEN_WIDTH}")
  draw 0 ${Y} "${SPC}" "${BLANK_LINE}"
  draw 0 $((Y+1)) "${SPC}" "${BLANK_LINE}"
  lol-draw-centered ${Y} "Press new key for: ${REBIND_LABEL}"
  lol-draw-centered $((Y+1)) "(ESC to cancel)"
  render
  export LOOP=controls-rebind-loop
}

controls-rebind-loop() {
  # ESC cancels
  if [[ "${KEY}" == $'\x1b' ]]; then
    controls-menu
    KEY=
    return
  fi

  local PROPOSED="${KEY}"
  if check-key-conflict "${PROPOSED}" "${REBIND_VAR}"; then
    # Valid key — apply it
    eval "${REBIND_VAR}='${PROPOSED}'"
    cfg-save
    controls-menu
  else
    # Show error and stay in rebind mode
    local MID=$((SCREEN_HEIGHT / 2))
    local Y=$((MID + 11))
    local BLANK_LINE
    BLANK_LINE=$(repeat " " "${SCREEN_WIDTH}")
    draw 0 ${Y} "${SPC}" "${BLANK_LINE}"
    draw 0 ${Y} "${RED}${BBLK}" "  ${CONFLICT_REASON} — try again or ESC to cancel  "
    render
  fi
  KEY=
}