@echo off

java -Xms128m -Xmx256m  -cp "../sepia.jar;../intersection_card.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd  -p 0 -c final.properties

