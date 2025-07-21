#!/bin/bash
tmp=$1
# Вкажіть свій API токен та ID чату
TOKEN="7694534317:AAET2bPYnuUrgufxfPXVnCcQVmTclL1QSVA"
CHAT_ID="1862834069"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Вкажіть критичний відсоток заповнення диска
THRESHOLD=96

# Масив путей для моніторингу, можна модифікувати для додавання чи видалення путей
mountpoints=($tmp)

# Функція для відправки повідомлення
send_message() {
    curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$1" > /dev/null
}

# Перевірка дискового простору для кожного зазначеного шляху
for mount in "${mountpoints[@]}"
do
    usage=$(df $mount | grep / | awk '{ print $5 }' | sed 's/%//g')
    if [ $usage -ge $THRESHOLD ]; then
        send_message "Warning $IP_ADDRESS: Partition at '$mount' is at $usage% capacity."
    fi
done