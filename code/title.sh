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

# Controls rebinding state
export CONTROLS_STATE='idle'
export CONTROLS_TARGET=
export CONTROLS_TARGET_LABEL=
export CONTROLS_ERROR_MSG=

attract-mode() {
  if ((TITLE_SCREEN_ATTRACT_COUNT >= TITLE_SCREEN_ATTRACT_MAX)) || ((TITLE_SCREEN_ATTRACT_MODE == 11)); then
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
      1) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 1   C O N T R O L S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "$(key-display-name "${P1_KEY_UP}")"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "$(key-display-name "${P1_KEY_LEFT}") ←   → $(key-display-name "${P1_KEY_RIGHT}")"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "$(key-display-name "${P1_KEY_DOWN}")"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[$(key-display-name "${P1_KEY_FIRE}")] Unleash the lasers"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "[$(key-display-name "${P1_KEY_BOMB}")] Smart Bomb  [$(key-display-name "${P1_KEY_PAUSE}")] Pause"
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
      2) lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "P L A Y E R 2   C O N T R O L S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "-------------------------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "$(key-display-name "${P2_KEY_UP}")"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 2)) "↑"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "$(key-display-name "${P2_KEY_LEFT}") ←   → $(key-display-name "${P2_KEY_RIGHT}")"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "↓"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "$(key-display-name "${P2_KEY_DOWN}")"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 6)) ""
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 7)) "[$(key-display-name "${P2_KEY_FIRE}")] Unleash the lasers"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "[$(key-display-name "${P2_KEY_BOMB}")] Smart Bomb  [$(key-display-name "${P2_KEY_PAUSE}")] Pause"
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
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) "C = Controls"
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
     11) lol-draw-centered $((SCREEN_HEIGHT / 2 - 5)) "C O N T R O L S"
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 4)) "---------------"
         lol-draw-centered $((SCREEN_HEIGHT / 2 - 2)) "PLAYER 1                    PLAYER 2"
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 0)) " A. Up     [$(key-display-name "${P1_KEY_UP}")]            H. Up     [$(key-display-name "${P2_KEY_UP}")]"
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 1)) " B. Down   [$(key-display-name "${P1_KEY_DOWN}")]            I. Down   [$(key-display-name "${P2_KEY_DOWN}")]"
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 2)) " C. Left   [$(key-display-name "${P1_KEY_LEFT}")]            J. Left   [$(key-display-name "${P2_KEY_LEFT}")]"
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 3)) " D. Right  [$(key-display-name "${P1_KEY_RIGHT}")]            K. Right  [$(key-display-name "${P2_KEY_RIGHT}")]"
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 4)) " E. Fire   [$(key-display-name "${P1_KEY_FIRE}")]            L. Fire   [$(key-display-name "${P2_KEY_FIRE}")]"
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 5)) " F. Bomb   [$(key-display-name "${P1_KEY_BOMB}")]            M. Bomb   [$(key-display-name "${P2_KEY_BOMB}")]"
         raw-draw-centered $((SCREEN_HEIGHT / 2 + 6)) " G. Pause  [$(key-display-name "${P1_KEY_PAUSE}")]            N. Pause  [$(key-display-name "${P2_KEY_PAUSE}")]"
         lol-draw-centered $((SCREEN_HEIGHT / 2 + 8)) ""
         case ${CONTROLS_STATE} in
           idle)
             lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) "[A-N] to rebind  [Q] back"
             ;;
           rebinding)
             lol-draw-centered $((SCREEN_HEIGHT / 2 + 9)) "Press new key for ${CONTROLS_TARGET_LABEL}..."
             ;;
           error)
             raw-draw-centered $((SCREEN_HEIGHT / 2 + 9)) "${RED}${CONTROLS_ERROR_MSG}${DEF}"
             lol-draw-centered $((SCREEN_HEIGHT / 2 + 10)) "Press any key to try again..."
             ;;
         esac
         lol-draw-centered $((SCREEN_HEIGHT - 4)) "Press [1] for one player, [2] for two player or [Q] to Quit"
         ;;
    esac
    # Freeze cycling on controls page
    if ((TITLE_SCREEN_ATTRACT_MODE != 11)); then
      ((TITLE_SCREEN_ATTRACT_MODE >= TITLE_SCREEN_ATTRACT_MODE_MAX)) && TITLE_SCREEN_ATTRACT_MODE=0 || ((TITLE_SCREEN_ATTRACT_MODE++))
    fi
  fi
  if ((TITLE_SCREEN_ATTRACT_MODE != 11)); then
    ((TITLE_SCREEN_ATTRACT_COUNT >= TITLE_SCREEN_ATTRACT_MAX)) && TITLE_SCREEN_ATTRACT_COUNT=0 || ((TITLE_SCREEN_ATTRACT_COUNT++))
  fi
}

validate-key-binding() {
  local target_var="$1"
  local new_key="$2"
  local target_player="${target_var%%_*}"

  # Rule 1: Must be a printable ASCII character
  if [[ -z "$new_key" ]] || [[ "$new_key" == $'\x1b' ]] || [[ "$new_key" == $'\t' ]]; then
    echo "Invalid key"
    return
  fi

  # Rule 2: Must not be a reserved global key
  case "$new_key" in
    1|2|q)
      echo "Key [$(key-display-name "$new_key")] is reserved"
      return
      ;;
  esac

  # Rule 3: Must not duplicate another binding for the same player
  local actions="UP DOWN LEFT RIGHT FIRE BOMB PAUSE"
  local act existing check_var
  for act in ${actions}; do
    check_var="${target_player}_KEY_${act}"
    if [[ "$check_var" != "$target_var" ]]; then
      eval "existing=\"\$$check_var\""
      if [[ "$existing" == "$new_key" ]]; then
        echo "Already bound to ${target_player} ${act}"
        return
      fi
    fi
  done

  # Rule 4: Cross-player critical actions must not conflict
  local other_player target_action crit
  if [[ "$target_player" == "P1" ]]; then other_player="P2"; else other_player="P1"; fi
  target_action="${target_var##*_}"
  case "$target_action" in
    FIRE|BOMB|PAUSE)
      for crit in FIRE BOMB PAUSE; do
        check_var="${other_player}_KEY_${crit}"
        eval "existing=\"\$$check_var\""
        if [[ "$existing" == "$new_key" ]]; then
          echo "Conflicts with ${other_player} ${crit}"
          return
        fi
      done
      ;;
  esac

  echo ""
}

controls-page-handle-key() {
  case ${CONTROLS_STATE} in
    idle)
      case ${KEY} in
        a|b|c|d|e|f|g|h|i|j|k|l|m|n)
          local idx player action label
          case ${KEY} in
            a) player="P1"; action="UP";    label="P1 UP";    idx=0;;
            b) player="P1"; action="DOWN";  label="P1 DOWN";  idx=1;;
            c) player="P1"; action="LEFT";  label="P1 LEFT";  idx=2;;
            d) player="P1"; action="RIGHT"; label="P1 RIGHT"; idx=3;;
            e) player="P1"; action="FIRE";  label="P1 FIRE";  idx=4;;
            f) player="P1"; action="BOMB";  label="P1 BOMB";  idx=5;;
            g) player="P1"; action="PAUSE"; label="P1 PAUSE"; idx=6;;
            h) player="P2"; action="UP";    label="P2 UP";    idx=7;;
            i) player="P2"; action="DOWN";  label="P2 DOWN";  idx=8;;
            j) player="P2"; action="LEFT";  label="P2 LEFT";  idx=9;;
            k) player="P2"; action="RIGHT"; label="P2 RIGHT"; idx=10;;
            l) player="P2"; action="FIRE";  label="P2 FIRE";  idx=11;;
            m) player="P2"; action="BOMB";  label="P2 BOMB";  idx=12;;
            n) player="P2"; action="PAUSE"; label="P2 PAUSE"; idx=13;;
          esac
          CONTROLS_TARGET="${player}_KEY_${action}"
          CONTROLS_TARGET_LABEL="$label"
          CONTROLS_STATE='rebinding'
          ;;
      esac
      KEY=
      ;;
    rebinding)
      local err
      err=$(validate-key-binding "$CONTROLS_TARGET" "$KEY")
      if [[ -n "$err" ]]; then
        CONTROLS_ERROR_MSG="$err"
        CONTROLS_STATE='error'
      else
        eval "${CONTROLS_TARGET}=\"\${KEY}\""
        cfg-save
        CONTROLS_STATE='idle'
      fi
      KEY=
      ;;
    error)
      CONTROLS_STATE='rebinding'
      CONTROLS_ERROR_MSG=
      KEY=
      ;;
  esac
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
  export TITLE_SCREEN_ATTRACT_MODE_MAX=11
  export CONTROLS_STATE='idle'
  export CONTROLS_TARGET=
  export CONTROLS_TARGET_LABEL=
  export CONTROLS_ERROR_MSG=

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
  elif ((TITLE_SCREEN_ATTRACT_MODE == 11)); then
    if [[ -n ${KEY} ]]; then
      controls-page-handle-key
    fi
    attract-mode
    render
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
    TITLE_SCREEN_ATTRACT_MODE=11
    TITLE_SCREEN_ATTRACT_COUNT=0
    CONTROLS_STATE='idle'
    CONTROLS_ERROR_MSG=
    sound switch-on
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