#!/usr/bin/env sh
#
# Kapow init script to serve dunst notification history
#

echo '[*] Starting dunst notification server'

# Route to serve the HTML interface
kapow route add / - <<-'EOF'
kapow set /response/headers/Content-Type text/html
cat index.html | kapow set /response/body
EOF

# Route to serve the current system uptime (needed for timestamp calculation)
kapow route add /api/uptime - <<-'EOF'
kapow set /response/headers/Content-Type text/plain
cut -d'.' -f1 /proc/uptime | kapow set /response/body
EOF

# Route to get all notification counts as JSON (used for both monitoring and display)
kapow route add /api/count - <<-'EOF'
kapow set /response/headers/Content-Type application/json
kapow set /response/headers/Access-Control-Allow-Origin "*"
jq -n \
  --argjson waiting "$(dunstctl count waiting)" \
  --argjson displayed "$(dunstctl count displayed)" \
  --argjson history "$(dunstctl count history)" \
  '{waiting: $waiting, displayed: $displayed, history: $history}' | kapow set /response/body
EOF

# Route to serve the dunst notification history as JSON API
kapow route add /api/notifications - <<-'EOF'
kapow set /response/headers/Content-Type application/json
kapow set /response/headers/Access-Control-Allow-Origin "*"
dunstctl history | kapow set /response/body
EOF

echo '[*] Routes configured:'
echo '  - / : HTML interface'
echo '  - /api/notifications : JSON API endpoint'
echo '  - /api/count : All counts as JSON (waiting, displayed, history)'
echo '  - /api/uptime : System uptime endpoint'
echo '[*] Server ready with real-time polling!'
