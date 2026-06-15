#!/usr/bin/env bash

gameover-mode() {
  export DELAY=0.0125
  export KEY=
  export GAMEOVER_MUSIC_THREAD=
  export GAMEOVER_SCREEN=()
  export GAMEOVER_SCREEN_OFFSET=

  # Save score to high scores file
  local BEST_SCORE=0
  local TOTAL_KILLS=0
  if ((P1_SCORE > P2_SCORE)); then
    BEST_SCORE=${P1_SCORE}
  else
    BEST_SCORE=${P2_SCORE}
  fi
  TOTAL_KILLS=$((P1_KILLS + P2_KILLS))
  scores-save "${NUM_PLAYERS}" "${BEST_SCORE}" "${LEVEL}" "${TOTAL_KILLS}"

  blank-screen
  reset-timers
  music gameover
  GAMEOVER_MUSIC_THREAD=$!
  sound mission_failed game-over 

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You failed! But you may try again."
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to seek revenge or [Q] to Quit"

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
