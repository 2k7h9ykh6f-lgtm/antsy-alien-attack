#!/usr/bin/env bash

export GAME_TITLE="Antsy Alien Attack!"
export FPS_ENABLED=0
export MUSIC_ENABLED=1
export SFX_ENABLED=1
export HI_SCORE=1000

# Player 1 key bindings
export P1_KEY_UP='w'
export P1_KEY_DOWN='s'
export P1_KEY_LEFT='a'
export P1_KEY_RIGHT='d'
export P1_KEY_FIRE='x'
export P1_KEY_BOMB='e'
export P1_KEY_PAUSE='p'

# Player 2 key bindings
export P2_KEY_UP='i'
export P2_KEY_DOWN='k'
export P2_KEY_LEFT='j'
export P2_KEY_RIGHT='l'
export P2_KEY_FIRE=','
export P2_KEY_BOMB='.'
export P2_KEY_PAUSE=';'

cfg-load(){
  if [ -e ${HOME}/.antsy-alien-attack ]; then
    source ${HOME}/.antsy-alien-attack
  fi
  # Fallback defaults for missing keys (handles upgrade from older config)
  : ${P1_KEY_UP:='w'}
  : ${P1_KEY_DOWN:='s'}
  : ${P1_KEY_LEFT:='a'}
  : ${P1_KEY_RIGHT:='d'}
  : ${P1_KEY_FIRE:='x'}
  : ${P1_KEY_BOMB:='e'}
  : ${P1_KEY_PAUSE:='p'}
  : ${P2_KEY_UP:='i'}
  : ${P2_KEY_DOWN:='k'}
  : ${P2_KEY_LEFT:='j'}
  : ${P2_KEY_RIGHT:='l'}
  : ${P2_KEY_FIRE:=','}
  : ${P2_KEY_BOMB:='.'}
  : ${P2_KEY_PAUSE:=';'}
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
