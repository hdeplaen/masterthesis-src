#!/bin/bash
java -cp "../../sepia.jar:../../benchmark.jar" -Djavax.net.ssl.trustStore=peer03KeyStore.jks  MainCmd -p 0 -c config.peer03.properties