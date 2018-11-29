#!/bin/bash
java -cp "../../sepia.jar:../../statistics.jar" -Djavax.net.ssl.trustStore=privacypeer01KeyStore.jks  MainCmd -p 1 -c config.privacypeer01.properties