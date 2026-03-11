Script Code 
#!/bin/bash
DISCORD_WEBHOOK_URL="
kKd0md-G6dwdesCBKe
https://discord.com/api/webhooks/1332992007055999058/ldM7NQnlrffaxVYNLZN1JXiOua_-5nYGKQp_RPJ7TL8tBDiv0
"
MY_SERVER_IP=""
ABUSEIPDB_API_KEY="f7a59a7884b8c29bb861bcac185a8f53c0d6d3f50bae1b68f976b52edc0a87993ec09eb5f1d73cb0"
ATTEMPT_LOG="$HOME/ssh_attempt_count.log"
echo "" > "$ATTEMPT_LOG"
check_ip_blacklist() {
ATTACK_IP="$1"
RESPONSE=$(curl -s -G 
https://api.abuseipdb.com/api/v2/check
\--data-urlencode "ipAddress=$ATTACK_IP" \-d maxAgeInDays=90 \-d verbose \-H "Key: $ABUSEIPDB_API_KEY" \-H "Accept: application/json")
BLACKLIST_SCORE=$(echo "$RESPONSE" | grep -oP '"abuseConfidenceScore":\K\d+')
if [[ "$BLACKLIST_SCORE" -ge 50 ]]; then
echo "blacklisted"
else
echo "not_blacklisted"
fi
}
send_discord_alert() {
ATTACK_IP="$1"
ATTEMPT_COUNT="$2"
if [[ "$ATTACK_IP" == "$MY_SERVER_IP" ]]; then
return
fi
BLACKLIST_STATUS=$(check_ip_blacklist "$ATTACK_IP")
if [[ "$BLACKLIST_STATUS" == "blacklisted" ]]; then
ALERT_MSG="
🚨
 
ALERT: SSH Brute Force Detected!
$ATTEMPT_COUNT"
else
ALERT_MSG="
🚨
 
 
 
\n IP:
$ATTACK_IP\n⚠ 
ALERT: SSH Brute Force Detected!
🚨
Blacklisted by AbuseIPDB!
\n IP:
$ATTACK_IP\n
✅
 
Attempts:
\n
📌
 
Attempts:
Not Blacklisted by AbuseIPDB.
\n
📌
 
$ATTEMPT_COUNT"
fi
curl -H "Content-Type: application/json" \-X POST \-d "{\"content\": \"$ALERT_MSG\"}" \
"$DISCORD_WEBHOOK_URL"
}
while true; do
sudo journalctl -u ssh --no-pager -n 5 | grep "Failed password" | while read -r line; do
ATTACKER_IP=$(echo "$line" | grep -oP 'from \K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
if [ -n "$ATTACKER_IP" ]; then
if grep -q "$ATTACKER_IP" "$ATTEMPT_LOG"; then
ATTEMPT_COUNT=$(grep "$ATTACKER_IP" "$ATTEMPT_LOG" | awk '{print $2}')
((ATTEMPT_COUNT++))
sed -i "/$ATTACKER_IP/c\\$ATTACKER_IP $ATTEMPT_COUNT" "$ATTEMPT_LOG"
else
ATTEMPT_COUNT=1
echo "$ATTACKER_IP $ATTEMPT_COUNT" >> "$ATTEMPT_LOG"
fi
if (( ATTEMPT_COUNT == 3 )); then
send_discord_alert "$ATTACKER_IP" "$ATTEMPT_COUNT"
fi
fi
done
sleep 5
done
