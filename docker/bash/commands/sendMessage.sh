#!/bin/sh

# First check if there is any message to send
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 1
fi

urlencode() {
    local string="${1}"
    local length="${#string}"
    local encoded=""
    local pos=0

    while [ $pos -lt $length ]; do
        local substring="${string:$pos:1}"
        case $substring in
        [a-zA-Z0-9._-])
            encoded="${encoded}${substring}"
            ;;
        *)
            local hex=$(printf "%02X" "'${substring}")
            encoded="${encoded}%${hex}"
            ;;
        esac
        pos=$((pos + 1))
    done

    echo "${encoded}"
}

TELEGRAM_TOKEN_FILE=/var/tmp/scripts/config/telegram-token
ALLOWED_CHATS_FILE=/var/tmp/scripts/config/allowed-chat-ids
ALLOWED_USERS_FILE=/var/tmp/scripts/config/allowed-user-ids

if [ ! -f "$TELEGRAM_TOKEN_FILE" ]; then
    echo "$TELEGRAM_TOKEN_FILE file does not exist"
    exit 1
fi

if [ ! -f "$ALLOWED_CHATS_FILE" ] && [ ! -f "$ALLOWED_USERS_FILE" ]; then
    echo "$ALLOWED_CHATS_FILE and $ALLOWED_USERS_FILE file do not exist, you need at least one ids file"
    exit 1
fi

# Read telegram token from file
TELEGRAM_TOKEN=$(cat "$TELEGRAM_TOKEN_FILE")

# Read chat ids from file
if [ -f "$ALLOWED_CHATS_FILE" ]; then
    CHAT_IDS=$(cat "$ALLOWED_CHATS_FILE")
fi

# Read user ids from file
if [ -f "$ALLOWED_USERS_FILE" ]; then
    USER_IDS=$(cat "$ALLOWED_USERS_FILE")
fi

# Merge chat ids and user ids into recipients array
RECIPIENTS=$(echo "$CHAT_IDS $USER_IDS" | tr ' ' '\n')

for id in $RECIPIENTS; do
    text=$(urlencode "$1")
    curl "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage?chat_id=$id&text=$text"
done

exit 0

