#!/bin/bash
java -cp "../../sepia.jar:../../statistics.jar" -Djavax.net.ssl.trustStore=peer03KeyStore.jks  MainCmd -p 0 -c config.peer03.properties