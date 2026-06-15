#!/usr/bin/env bash

#--------------------------------------------------------------------------
# Endless Survival Mode
#--------------------------------------------------------------------------

survival-mode() {
  readonly NUM_PLAYERS=1
  GAME_MODE=1
  export DELAY=0.005
  export KEY=
  blank-screen

  reset-timers
  reset-game
  GAME_MODE=1   # reset-game sets it to 0; restore
  reset-gfx-timers
  survival-init
  export LOOP=game-loop
}

survival-init() {
  export SURVIVAL_WAVE=0
  export SURVIVAL_TOTAL_KILLS=0
  export SURVIVAL_ELAPSED=0
  export SURVIVAL_ANNOUNCE_FRAMES=0
  export SURVIVAL_MUSIC_TRACK=0
  export SURVIVAL_GAME_START_SECOND=${SECONDS}
  export SURVIVAL_WAVE_START_SECOND=${SECONDS}
  export SURVIVAL_GAMEOVER_MUSIC_THREAD=

  # Start with gentle difficulty (wave 0 = pre-wave)
  survival-apply-wave-difficulty 0

  # Random music track
  survival-cycle-music

  # Trigger first wave immediately
  survival-next-wave
}

survival-cycle-music() {
  kill-thread ${GAME_MUSIC_THREAD} 2>/dev/null
  SURVIVAL_MUSIC_TRACK=$(( (RANDOM % 3) + 1 ))
  music "track-${SURVIVAL_MUSIC_TRACK}"
  GAME_MUSIC_THREAD=$!
}

survival-next-wave() {
  ((SURVIVAL_WAVE++))
  export SURVIVAL_WAVE_START_SECOND=${SECONDS}

  # Clear remaining fighters/lasers for clean wave start
  export FIGHTERS=()
  export FIGHTER_LASERS=()
  export BOSS_FIGHT=0
  export BOSS_HEALTH=0
  export BOSS_FRAME=0

  # Apply difficulty for this wave
  survival-apply-wave-difficulty ${SURVIVAL_WAVE}

  # Reset per-wave kill counters (used by normal-mode boss trigger, not needed
  # in survival, but keep clean)
  export P1_KILLS=0
  export P2_KILLS=0
  export FIGHTERS_ESCAPED=0

  # Cycle music every 3 waves
  if ((SURVIVAL_WAVE % 3 == 1)); then
    survival-cycle-music
  fi

  # Show wave announcement overlay for ~3 seconds (~180 frames)
  export SURVIVAL_ANNOUNCE_FRAMES=180

  # Play wave announcement sound
  if ((SURVIVAL_WAVE == 1)); then
    sound ready go
  else
    sound level-up
  fi
}

survival-apply-wave-difficulty() {
  local WAVE=${1}
  local DW=${WAVE}
  ((DW > 15)) && DW=15

  case ${DW} in
    0)  export DELAY=0.006
        export ALIEN_SPAWN_RATE=200
        export ALIEN_FIRE_RATE=400
        export MAX_FIGHTERS=2
        export MAX_FIGHTER_LASERS=4
        export LEVEL_COMPENSATION=6
        ;;
    1)  export DELAY=0.005
        export ALIEN_SPAWN_RATE=175
        export ALIEN_FIRE_RATE=350
        export MAX_FIGHTERS=2
        export MAX_FIGHTER_LASERS=5
        export LEVEL_COMPENSATION=6
        ;;
    2)  export DELAY=0.005
        export ALIEN_SPAWN_RATE=150
        export ALIEN_FIRE_RATE=300
        export MAX_FIGHTERS=3
        export MAX_FIGHTER_LASERS=5
        export LEVEL_COMPENSATION=6
        ;;
    3)  export DELAY=0.005
        export ALIEN_SPAWN_RATE=125
        export ALIEN_FIRE_RATE=250
        export MAX_FIGHTERS=3
        export MAX_FIGHTER_LASERS=6
        export LEVEL_COMPENSATION=5
        ;;
    4)  export DELAY=0.004
        export ALIEN_SPAWN_RATE=110
        export ALIEN_FIRE_RATE=220
        export MAX_FIGHTERS=4
        export MAX_FIGHTER_LASERS=6
        export LEVEL_COMPENSATION=5
        ;;
    5)  export DELAY=0.004
        export ALIEN_SPAWN_RATE=100
        export ALIEN_FIRE_RATE=200
        export MAX_FIGHTERS=4
        export MAX_FIGHTER_LASERS=7
        export LEVEL_COMPENSATION=5
        ;;
    6)  export DELAY=0.004
        export ALIEN_SPAWN_RATE=90
        export ALIEN_FIRE_RATE=180
        export MAX_FIGHTERS=5
        export MAX_FIGHTER_LASERS=7
        export LEVEL_COMPENSATION=4
        ;;
    7)  export DELAY=0.003
        export ALIEN_SPAWN_RATE=80
        export ALIEN_FIRE_RATE=160
        export MAX_FIGHTERS=5
        export MAX_FIGHTER_LASERS=8
        export LEVEL_COMPENSATION=4
        ;;
    8)  export DELAY=0.003
        export ALIEN_SPAWN_RATE=70
        export ALIEN_FIRE_RATE=140
        export MAX_FIGHTERS=6
        export MAX_FIGHTER_LASERS=8
        export LEVEL_COMPENSATION=4
        ;;
    9)  export DELAY=0.003
        export ALIEN_SPAWN_RATE=60
        export ALIEN_FIRE_RATE=120
        export MAX_FIGHTERS=6
        export MAX_FIGHTER_LASERS=9
        export LEVEL_COMPENSATION=3
        ;;
    10) export DELAY=0.003
        export ALIEN_SPAWN_RATE=50
        export ALIEN_FIRE_RATE=100
        export MAX_FIGHTERS=7
        export MAX_FIGHTER_LASERS=9
        export LEVEL_COMPENSATION=3
        ;;
    11) export DELAY=0.002
        export ALIEN_SPAWN_RATE=45
        export ALIEN_FIRE_RATE=90
        export MAX_FIGHTERS=7
        export MAX_FIGHTER_LASERS=10
        export LEVEL_COMPENSATION=3
        ;;
    12) export DELAY=0.002
        export ALIEN_SPAWN_RATE=40
        export ALIEN_FIRE_RATE=80
        export MAX_FIGHTERS=8
        export MAX_FIGHTER_LASERS=10
        export LEVEL_COMPENSATION=3
        ;;
    13) export DELAY=0.002
        export ALIEN_SPAWN_RATE=35
        export ALIEN_FIRE_RATE=70
        export MAX_FIGHTERS=8
        export MAX_FIGHTER_LASERS=11
        export LEVEL_COMPENSATION=3
        ;;
    14) export DELAY=0.002
        export ALIEN_SPAWN_RATE=30
        export ALIEN_FIRE_RATE=60
        export MAX_FIGHTERS=9
        export MAX_FIGHTER_LASERS=11
        export LEVEL_COMPENSATION=3
        ;;
    *)  export DELAY=0.002
        export ALIEN_SPAWN_RATE=25
        export ALIEN_FIRE_RATE=50
        export MAX_FIGHTERS=10
        export MAX_FIGHTER_LASERS=12
        export LEVEL_COMPENSATION=3
        ;;
  esac

  # Beyond wave 15: linear scaling with caps
  if ((WAVE > 15)); then
    local EXTRA=$((WAVE - 15))
    ALIEN_SPAWN_RATE=$((25 - EXTRA))
    ALIEN_FIRE_RATE=$((50 - EXTRA * 2))
    MAX_FIGHTERS=$((10 + EXTRA / 3))
    ((ALIEN_SPAWN_RATE < 8)) && ALIEN_SPAWN_RATE=8
    ((ALIEN_FIRE_RATE < 15)) && ALIEN_FIRE_RATE=15
    ((MAX_FIGHTERS > 20)) && MAX_FIGHTERS=20
  fi

  # Scale points with wave
  export FIGHTER_POINTS=$((WAVE * 10))
  ((FIGHTER_POINTS < 10)) && FIGHTER_POINTS=10
  export BONUS_SPAWN_RATE=$((WAVE * 2))
  ((BONUS_SPAWN_RATE < 2)) && BONUS_SPAWN_RATE=2
  export BONUS_POINTS=$((1000 * WAVE))
  ((BONUS_POINTS < 1000)) && BONUS_POINTS=1000
  export BONUS_COLLECT=$((100 * WAVE))
  ((BONUS_COLLECT < 100)) && BONUS_COLLECT=100
}

survival-wave-check() {
  # Called every frame from game-loop when GAME_MODE==1
  local ELAPSED_THIS_WAVE=$((SECONDS - SURVIVAL_WAVE_START_SECOND))
  if ((ELAPSED_THIS_WAVE >= 30)); then
    survival-next-wave
  fi
}

survival-hud-update() {
  # Called inside ANIMATION_KEYFRAME==0 block in game-loop
  SURVIVAL_ELAPSED=$((SECONDS - SURVIVAL_GAME_START_SECOND))
  local MINUTES=$((SURVIVAL_ELAPSED / 60))
  local SECS=$((SURVIVAL_ELAPSED % 60))
  local TIME_PADDED
  TIME_PADDED=$(printf "%02d:%02d" ${MINUTES} ${SECS})
  local WAVE_PADDED
  WAVE_PADDED=$(printf "%03d" ${SURVIVAL_WAVE})

  # Draw centered on bottom row (replaces unused P2 lives area in 1P)
  draw-centered "${SCREEN_HEIGHT}" "${YLW}${BBLK}" "WAVE ${WAVE_PADDED}  TIME ${TIME_PADDED}"
}

survival-draw-announcement() {
  # Overlay during gameplay; decrements each frame
  if ((SURVIVAL_ANNOUNCE_FRAMES % 2 == 0)); then
    # Reuse level-N.ans art files (cycle 1-10)
    local ART_INDEX=$((SURVIVAL_WAVE % 10))
    ((ART_INDEX == 0)) && ART_INDEX=10
    draw-picture-centered "level-${ART_INDEX}"

    local Y_CENTER=$((SCREEN_HEIGHT / 2))
    lol-draw-centered $((Y_CENTER + 4)) "W A V E   ${SURVIVAL_WAVE}"
  fi
  ((SURVIVAL_ANNOUNCE_FRAMES--))
}

#--------------------------------------------------------------------------
# Survival Game Over — Stats screen before gameover art
#--------------------------------------------------------------------------

survival-gameover-mode() {
  export DELAY=0.0125
  export KEY=

  blank-screen
  reset-timers

  # Compute final stats
  local TOTAL_TIME=$((SECONDS - SURVIVAL_GAME_START_SECOND))
  local MINUTES=$((TOTAL_TIME / 60))
  local SECS=$((TOTAL_TIME % 60))
  local TIME_STR
  TIME_STR=$(printf "%02d:%02d" ${MINUTES} ${SECS})

  local WAVES_SURVIVED=$((SURVIVAL_WAVE - 1))
  ((WAVES_SURVIVED < 0)) && WAVES_SURVIVED=0

  # Music and sound
  music gameover
  SURVIVAL_GAMEOVER_MUSIC_THREAD=$!
  sound mission_failed game-over

  local Y_CENTER=$((SCREEN_HEIGHT / 2))

  # Title
  lol-draw-centered $((Y_CENTER - 7)) "S U R V I V A L   E N D E D"
  lol-draw-centered $((Y_CENTER - 6)) "---------------------------"

  # Stats
  lol-draw-centered $((Y_CENTER - 4)) "Survival Time:  ${TIME_STR}"
  lol-draw-centered $((Y_CENTER - 2)) "Waves Survived: ${WAVES_SURVIVED}"
  lol-draw-centered $((Y_CENTER + 0)) "Total Kills:    ${SURVIVAL_TOTAL_KILLS}"
  lol-draw-centered $((Y_CENTER + 2)) "Final Score:    ${P1_SCORE}"

  # Hi-score check
  if ((P1_SCORE > HI_SCORE)); then
    HI_SCORE=${P1_SCORE}
    lol-draw-centered $((Y_CENTER + 4)) "*** NEW HIGH SCORE! ***"
    sound new_highscore
    cfg-save
  fi

  # Load gameover art for waving animation
  readarray -t GAMEOVER_SCREEN < gfx/gameover.ans
  GAMEOVER_SCREEN_LONGEST_LINE=$(wc -L gfx/gameover.txt | cut -d' ' -f1)
  GAMEOVER_SCREEN_OFFSET=$(center ${GAMEOVER_SCREEN_LONGEST_LINE})

  lol-draw-centered $((Y_CENTER + 7)) "Press [R] to try again or [Q] to Quit"

  export LOOP=survival-gameover-loop
}

survival-gameover-loop() {
  if [[ $KEY == 'r' ]]; then
    kill-thread ${SURVIVAL_GAMEOVER_MUSIC_THREAD} 2>/dev/null
    title-mode
  elif [[ $KEY == 'q' ]]; then
    kill-thread ${SURVIVAL_GAMEOVER_MUSIC_THREAD} 2>/dev/null
    teardown
  else
    wave-picture "${GAMEOVER_SCREEN_OFFSET}" "${GAMEOVER_SCREEN[@]}"
    render
  fi
}
