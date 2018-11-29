@echo off
cd privacypeer01
start cmd /C runPrivacyPeer01.bat

cd ../privacypeer02
start cmd /C runPrivacyPeer02.bat

cd ../privacypeer03
start cmd /C runPrivacyPeer03.bat

cd ../peer01
start cmd /C runPeer01.bat

cd ../peer02
start cmd /C runPeer02.bat

cd ../peer03
start cmd /C runPeer03.bat

pause

