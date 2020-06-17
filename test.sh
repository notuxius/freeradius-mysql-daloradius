#!/bin/bash
echo "Executing: radtest test test localhost 0 testing123"
radtest test test localhost 0 testing123

echo
echo 'Executing: echo "User-Name = test,User-password=test" | radclient localhost:1812 auth testing123'
echo "User-Name = test,User-password=test" | radclient localhost:1812 auth testing123

echo
echo 'Executing radclient -x -f /home/start|update|stop_packet.rad localhost acct "testing123"'
radclient -x -f /home/start_packet.rad localhost acct "testing123"
radclient -x -f /home/update_packet.rad localhost acct "testing123"
radclient -x -f /home/stop_packet.rad localhost acct "testing123"
