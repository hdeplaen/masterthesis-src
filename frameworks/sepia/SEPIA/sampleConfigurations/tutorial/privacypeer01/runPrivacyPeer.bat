java -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5555 -cp "../../sepia.jar;../../tutorial.jar" -Djavax.net.ssl.trustStore=pKeyStore.jks MainCmd -v -p 1 -c config.properties
pause
