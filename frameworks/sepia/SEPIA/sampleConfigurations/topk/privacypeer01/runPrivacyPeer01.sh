#!/bin/bash
java -cp "../../sepia.jar:../../pptks.jar" -Djavax.net.ssl.trustStore=privacypeer01KeyStore.jks  MainCmd -p 1 -c config.privacypeer01.properties
#java -cp "../../sepia.jar:../../pptks.jar" -Djavax.net.ssl.trustStore=privacypeer01KeyStore.jks  MainCmd -v -p 1 -c config.privacypeer01.properties
#java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=10044 -cp "../../sepia.jar:../../pptks.jar" -Djavax.net.ssl.trustStore=privacypeer01KeyStore.jks  MainCmd -v -p 1 -c config.privacypeer01.properties
