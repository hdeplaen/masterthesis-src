#!/bin/bash
java -cp "../../sepia.jar:../../statistics.jar" -Djavax.net.ssl.trustStore=peer02KeyStore.jks  MainCmd -p 0 -c config.peer02.properties