#!/usr/bin/env bash

gameover-mode() {
  export DELAY=0.0125
  export KEY=
  export GAMEOVER_MUSIC_THREAD=
  export GAMEOVER_SCREEN=()
  export GAMEOVER_SCREEN_OFFSET=

  blank-screen
  reset-timers
  music gameover
  GAMEOVER_MUSIC_THREAD=$!
  sound mission_failed game-over

  if [[ "${GAME_MODE}" == "survival" ]]; then
    # Survival stats panel
    local _mins=$((${SURVIVAL_ELAPSED:-0} / 60))
    local _secs=$((${SURVIVAL_ELAPSED:-0} % 60))
    local _time_str=$(printf "%02d:%02d" ${_mins} ${_secs})
    local _final_score=${P1_SCORE}
    local _final_score_padded=$(printf "%07d" ${_final_score})

    lol-draw-centered $((SCREEN_HEIGHT / 2 - 5)) "G A M E   O V E R"
    lol-draw-centered $((SCREEN_HEIGHT / 2 - 4)) "-----------------"
    lol-draw-centered $((SCREEN_HEIGHT / 2 - 2)) "Wave Survived:  ${SURVIVAL_WAVE}"
    lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "Time Elapsed:   ${_time_str}"
    lol-draw-centered $((SCREEN_HEIGHT / 2 + 0)) "Total Kills:    ${SURVIVAL_TOTAL_KILLS}"
    lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Final Score:    ${_final_score_padded}"
    lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "Press [R] to try again or [Q] to Quit"
  else
    lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You failed! But you may try again."
    lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to seek revenge or [Q] to Quit"
  fi

  readarray -t GAMEOVER_SCREEN < gfx/gameover.ans
  GAMEOVER_SCREEN_LONGEST_LINE=$(wc -L gfx/gameover.txt | cut -d' ' -f1)
  GAMEOVER_SCREEN_OFFSET=$(center ${GAMEOVER_SCREEN_LONGEST_LINE})

  export LOOP=gameover-loop
}

gameover-loop() {
  if [[ $KEY == 'r' ]]; then
    kill-thread ${GAMEOVER_MUSIC_THREAD}
    export GAME_MODE=
    title-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${GAMEOVER_MUSIC_THREAD}
    teardown
  else
    wave-picture "${GAMEOVER_SCREEN_OFFSET}" "${GAMEOVER_SCREEN[@]}"
    render
  fi
}
