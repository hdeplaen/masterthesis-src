#!/bin/bash
#java -Xms128m -Xmx256m  -cp "../sepia.jar:../union.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd  -p 0 -c final.properties
java -cp "../../sepia.jar:../../union.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd -p 0 -c final.properties
