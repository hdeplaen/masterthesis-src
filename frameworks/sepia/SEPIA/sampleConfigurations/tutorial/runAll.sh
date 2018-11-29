#!/bin/bash
echo "Starting privacy peers..."
cd privacypeer01
nohup ./runPrivacyPeer.sh&

cd ../privacypeer02
nohup ./runPrivacyPeer.sh&

cd ../privacypeer03
nohup ./runPrivacyPeer.sh&

echo "Wait 2s until peers are started..."
sleep 2

cd ../peer01
nohup ./runPeer.sh&

cd ../peer02
nohup ./runPeer.sh&

cd ../peer03
nohup ./runPeer.sh&




