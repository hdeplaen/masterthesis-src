#!/bin/bash
java -cp "../../sepia.jar:../../pptks.jar" -Djavax.net.ssl.trustStore=privacypeer02KeyStore.jks  MainCmd  -p 1 -c config.privacypeer02.properties