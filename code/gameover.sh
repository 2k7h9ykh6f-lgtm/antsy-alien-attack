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

  # Persist this game's result to the local high score table. A write failure
  # is surfaced to the player but must not interrupt the game over flow.
  local SAVE_MSG="Your score has been recorded."
  if ! highscore-record "${NUM_PLAYERS}" "${LEVEL}" \
       "$(( ${P1_KILLS_TOTAL:-0} + ${P2_KILLS_TOTAL:-0} ))" \
       "${P1_SCORE}" "${P2_SCORE}"; then
    SAVE_MSG="Warning: high score could not be saved."
  fi

  lol-draw-centered $((SCREEN_HEIGHT / 2 - 1)) "You failed! But you may try again."
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 1)) "Press [R] to seek revenge or [Q] to Quit"
  lol-draw-centered $((SCREEN_HEIGHT / 2 + 3)) "${SAVE_MSG}"

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
