#!/bin/bash
java -cp "../../sepia.jar:../../tutorial.jar" -Djavax.net.ssl.trustStore=pKeyStore.jks MainCmd -p 1 -c config.properties
