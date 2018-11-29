@echo off
echo "Starting privacy peers..."

cd privacypeer01
start cmd /C runPrivacyPeer.bat

cd ../privacypeer02
start cmd /C runPrivacyPeer.bat

cd ../privacypeer03
start cmd /C runPrivacyPeer.bat

cd ../privacypeer04
start cmd /C runPrivacyPeer.bat

cd ../privacypeer05
start cmd /C runPrivacyPeer.bat


REM echo "Wait for a short time then press enter to start the input peers"
REM pause


cd ../peer01
start cmd /C runPeer.bat

cd ../peer02
start cmd /C runPeer.bat

cd ../peer03
start cmd /C runPeer.bat

REM pause

