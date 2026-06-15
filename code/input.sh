#!/usr/bin/env bash

export KEY=
export JOYSTICK_THREAD=

joystick-setup() {
  local JOY2KEY=$(command -v joy2key)
  # Is joy2key in the path and is there joystick connected
  if [ -n "${JOY2KEY}" ] && [ -c /dev/input/js0 ]; then
    ${JOY2KEY} -rcfile cfg/xbox360.cfg > /dev/null 2>&1 &
    JOYSTICK_THREAD=$!
  fi
}

joystick-teardown() {
  if [ -n "${JOYSTICK_THREAD}" ]; then
    kill-thread ${JOYSTICK_THREAD}
  fi
}

start-input-handler() {
  while :; do
    read -sn1 KEY 2>/dev/null
  done
}

# Convert a raw key character to a human-readable display name.
key-name() {
  local K="${1}"
  case "${K}" in
    ' ')  echo "SPACE" ;;
    '')   echo "(none)" ;;
    $'\x1b') echo "ESC" ;;
    $'\x7f') echo "DEL" ;;
    $'\t') echo "TAB" ;;
    *)
      # Printable ASCII range 33-126
      local ORD
      ORD=$(LC_ALL=C printf '%d' "'${K}" 2>/dev/null)
      if [[ -z "${ORD}" ]] || ((ORD < 32 || ORD > 126)); then
        echo "(???)"
      else
        echo "${K}"
      fi
      ;;
  esac
}

# Check whether a proposed key is already in use by another binding or is reserved.
# Args: <proposed_key> <binding_var_name_being_changed>
# Returns: 0 if OK (no conflict), 1 if conflict found.
# Side-effect: on conflict, sets CONFLICT_REASON to a human-readable message.
check-key-conflict() {
  local PROPOSED="${1}"
  local CHANGING="${2}"

  # Reject empty input
  if [[ -z "${PROPOSED}" ]]; then
    CONFLICT_REASON="No key pressed"
    return 1
  fi

  # Reject escape (used for back navigation)
  if [[ "${PROPOSED}" == $'\x1b' ]]; then
    CONFLICT_REASON="ESC is reserved for Back"
    return 1
  fi

  # Reject non-printable / control characters
  local ORD
  ORD=$(LC_ALL=C printf '%d' "'${PROPOSED}" 2>/dev/null)
  if [[ -z "${ORD}" ]] || ((ORD < 32 || ORD > 126)); then
    CONFLICT_REASON="Invalid key (non-printable)"
    return 1
  fi

  # Reject characters that would break config file serialization
  if [[ "${PROPOSED}" == "'" ]] || [[ "${PROPOSED}" == '\' ]] || [[ "${PROPOSED}" == '$' ]]; then
    CONFLICT_REASON="Key [${PROPOSED}] cannot be used"
    return 1
  fi

  # Reject reserved keys
  local R
  for R in "${RESERVED_KEYS[@]}"; do
    if [[ "${PROPOSED}" == "${R}" ]]; then
      CONFLICT_REASON="Key [${R}] is reserved"
      return 1
    fi
  done

  # Check all other bindings for duplicates
  local NAME VAL
  for NAME in "${KEY_BINDING_NAMES[@]}"; do
    [[ "${NAME}" == "${CHANGING}" ]] && continue
    eval "VAL=\${${NAME}}"
    if [[ "${PROPOSED}" == "${VAL}" ]]; then
      CONFLICT_REASON="Key [${PROPOSED}] is already used"
      return 1
    fi
  done

  CONFLICT_REASON=
  return 0
}

# Reset all key bindings to their defaults.
reset-key-bindings() {
  local I
  for I in "${!KEY_BINDING_NAMES[@]}"; do
    eval "${KEY_BINDING_NAMES[$I]}='${KEY_BINDING_DEFAULTS[$I]}'"
  done
}