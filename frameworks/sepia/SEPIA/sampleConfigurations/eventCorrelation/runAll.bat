@echo off

cd privacypeer01
start cmd /C runPrivacyPeer.bat

cd ../privacypeer02
start cmd /C runPrivacyPeer.bat

cd ../privacypeer03
start cmd /C runPrivacyPeer.bat

cd ../peer01
start cmd /C runPeer.bat

cd ../peer02
start cmd /C runPeer.bat

cd ../peer03
start cmd /C runPeer.bat


