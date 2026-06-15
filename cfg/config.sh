#!/usr/bin/env bash

export GAME_TITLE="Antsy Alien Attack!"
export FPS_ENABLED=0
export MUSIC_ENABLED=1
export SFX_ENABLED=1
export HI_SCORE=1000

# Player 1 key bindings (defaults)
export P1_KEY_UP='w'
export P1_KEY_DOWN='s'
export P1_KEY_LEFT='a'
export P1_KEY_RIGHT='d'
export P1_KEY_FIRE='x'
export P1_KEY_BOMB='b'
export P1_KEY_PAUSE='p'

# Player 2 key bindings (defaults)
export P2_KEY_UP='i'
export P2_KEY_DOWN='k'
export P2_KEY_LEFT='j'
export P2_KEY_RIGHT='l'
export P2_KEY_FIRE=','
export P2_KEY_BOMB='.'
export P2_KEY_PAUSE='/'

# All binding variable names (used by validation & controls menu)
export KEY_BINDING_NAMES=(
  P1_KEY_UP P1_KEY_DOWN P1_KEY_LEFT P1_KEY_RIGHT P1_KEY_FIRE P1_KEY_BOMB P1_KEY_PAUSE
  P2_KEY_UP P2_KEY_DOWN P2_KEY_LEFT P2_KEY_RIGHT P2_KEY_FIRE P2_KEY_BOMB P2_KEY_PAUSE
)

# Default values (parallel array, used for reset)
export KEY_BINDING_DEFAULTS=( 'w' 's' 'a' 'd' 'x' 'b' 'p' 'i' 'k' 'j' 'l' ',' '.' '/' )

# Keys reserved by title/gameover/victory screens (cannot be assigned)
export RESERVED_KEYS=( '1' '2' 'q' 'r' 'm' 's' 'f' 'c' )

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
P1_KEY_UP='${P1_KEY_UP}'
P1_KEY_DOWN='${P1_KEY_DOWN}'
P1_KEY_LEFT='${P1_KEY_LEFT}'
P1_KEY_RIGHT='${P1_KEY_RIGHT}'
P1_KEY_FIRE='${P1_KEY_FIRE}'
P1_KEY_BOMB='${P1_KEY_BOMB}'
P1_KEY_PAUSE='${P1_KEY_PAUSE}'
P2_KEY_UP='${P2_KEY_UP}'
P2_KEY_DOWN='${P2_KEY_DOWN}'
P2_KEY_LEFT='${P2_KEY_LEFT}'
P2_KEY_RIGHT='${P2_KEY_RIGHT}'
P2_KEY_FIRE='${P2_KEY_FIRE}'
P2_KEY_BOMB='${P2_KEY_BOMB}'
P2_KEY_PAUSE='${P2_KEY_PAUSE}'
END_CFG
}