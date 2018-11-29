@echo off

echo The RunAll.bat will only work on localhost configurations
echo if you want to run distributed on windows host you need to start
echo the hosts manually by using the startup.bat in the corresponding folder

echo starting privacy peers...

cd localhostPP0 
start cmd /C startup.bat 
cd ..
cd localhostPP1 
start cmd /C startup.bat 
cd ..
cd localhostPP2 
start cmd /C startup.bat 
cd ..
echo starting input peers...

cd localhostIP0 
start cmd /C startup.bat 
cd .. 
cd localhostIP1 
start cmd /C startup.bat 
cd .. 
cd localhostIP2 
start cmd /C startup.bat 
cd .. 
echo finished!
pause