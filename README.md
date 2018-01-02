# environmentPI
raspberry pi development temp sensor



# habridge:
/opt/habridge/
https://github.com/bwssytems/ha-bridge

/opt/jre/bin/java
java8 https://discourse.osmc.tv/t/oracle-java-8/37092/2


[Unit]
Description=HA Bridge
Wants=network.target
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/habridge
ExecStart=/opt/jre/bin/java  -jar -Dconfig.file=/opt/habridge/data/habridge.config /opt/habridge/ha-bridge-5.1.0.jar

[Install]
WantedBy=multi-user.target

