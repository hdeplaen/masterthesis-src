@echo off

java -Xms128m -Xmx1024m  -cp "../sepia.jar;../union.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd  -p 1 -c final.properties

