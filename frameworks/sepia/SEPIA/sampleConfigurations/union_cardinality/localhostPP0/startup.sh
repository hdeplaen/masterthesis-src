#!/bin/bash
#java -Xms128m -Xmx256m  -cp "../sepia.jar:../union_card.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd  -p 1 -c final.properties
java -cp "../../sepia.jar:../../union_card.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd -p 1 -c final.properties
