#!/bin/bash
#java -Xms128m -Xmx1024m  -cp "../sepia.jar:../intersection_card.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd  -p 1 -c final.properties
java -cp "../../sepia.jar:../../intersection_card.jar" -Djavax.net.ssl.trustStore=../../testConfigKeyStore.jks  MainCmd -p 1 -c final.properties
