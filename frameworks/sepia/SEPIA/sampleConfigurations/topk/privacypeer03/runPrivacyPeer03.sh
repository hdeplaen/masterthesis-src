#!/bin/bash
java -cp "../../sepia.jar:../../pptks.jar" -Djavax.net.ssl.trustStore=privacypeer03KeyStore.jks  MainCmd -p 1 -c config.privacypeer03.properties