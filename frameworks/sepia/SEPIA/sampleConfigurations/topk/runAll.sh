#!/bin/bash
echo "Starting privacy peers..."
cd privacypeer01
nohup ./runPrivacyPeer01.sh&

cd ../privacypeer02
nohup ./runPrivacyPeer02.sh&

cd ../privacypeer03
nohup ./runPrivacyPeer03.sh&

echo "Wait 2s until peers are started..."
sleep 2

cd ../peer01
nohup ./runPeer01.sh&

cd ../peer02
nohup ./runPeer02.sh&

cd ../peer03
nohup ./runPeer03.sh&




