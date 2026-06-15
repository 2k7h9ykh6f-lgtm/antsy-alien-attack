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

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You failed! But you may try again."
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to seek revenge or [Q] to Quit"

  if ((SURVIVAL == 1)); then
    local T=$(printf '%02d:%02d' $(( SURVIVAL_TIME / 60 )) $(( SURVIVAL_TIME % 60 )))
    lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "E N D L E S S   S U R V I V A L"
    lol-draw-centered $((SCREEN_HEIGHT / 2 + 4)) "Reached WAVE ${SURVIVAL_WAVE}   -   Survived ${T}   -   ${SURVIVAL_KILLS} kills"
    lol-draw-centered $((SCREEN_HEIGHT / 2 + 5)) "FINAL SCORE $(printf '%07d' ${SURVIVAL_SCORE})"
  fi

  readarray -t GAMEOVER_SCREEN < gfx/gameover.ans
  GAMEOVER_SCREEN_LONGEST_LINE=$(wc -L gfx/gameover.txt | cut -d' ' -f1)
  GAMEOVER_SCREEN_OFFSET=$(center ${GAMEOVER_SCREEN_LONGEST_LINE})

  export LOOP=gameover-loop
}

gameover-loop() {
  if [[ $KEY == 'r' ]]; then
    kill-thread ${GAMEOVER_MUSIC_THREAD}
    title-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${GAMEOVER_MUSIC_THREAD}
    teardown
  else
    wave-picture "${GAMEOVER_SCREEN_OFFSET}" "${GAMEOVER_SCREEN[@]}"
    render
  fi
}
