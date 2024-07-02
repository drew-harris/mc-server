#################
#### PLUGINS ####
#################
FROM maven:eclipse-temurin as plugins
WORKDIR /plugins

COPY ./plugins/DrewsPlugin/ ./DrewsPlugin
RUN mvn -f ./DrewsPlugin/pom.xml clean package


#################
#### SERVER #####
#################
FROM maven:eclipse-temurin

WORKDIR /server

ARG spigot_url=https://api.papermc.io/v2/projects/paper/versions/1.20.6/builds/147/downloads/paper-1.20.6-147.jar
# ARG nicknames_url=https://files.drewh.net/api/public/dl/2YOYS1es/HaoNick-v4.6.7.jar
# ARG nickapi=https://files.drewh.net/api/public/dl/xF20Wsdx/NickAPI-v6.6.0.jar
ARG essentials_url=https://files.drewh.net/api/public/dl/jIdxUNMJ/EssentialsX-2.21.0-dev%2B100-b392f03.jar

# Install wget
RUN apt-get update && apt-get install -y wget

# Install git
RUN apt-get update && apt-get install -y git

# Download spigot.jar
RUN wget -O ./spigot.jar $spigot_url

EXPOSE 25565/udp
EXPOSE 25565/tcp
EXPOSE 25575/tcp

RUN ["java", "-Xms1024M", "-Xmx2048M", "-Dfile.encoding=UTF-8", "-jar", "spigot.jar", "--world-dir", "./worlds", "nogui"]

# Change eula to true
RUN sed -i 's/false/true/g' eula.txt 

COPY ./server.properties ./server.properties

## PLUGIN SETUP ##
# Copy plugins from plugins stage
COPY --from=plugins /plugins/DrewsPlugin/target/DrewsPlugin-1.0-SNAPSHOT.jar ./plugins/DrewsPlugin.jar

# RUN wget -O ./plugins/nicknames.jar $nicknames_url
# RUN wget -O ./plugins/nickapi.jar $nickapi
RUN wget -O ./plugins/essentials.jar $essentials_url
COPY ./essentials/config.yml ./plugins/Essentials/config.yml

COPY ./spigot/spigot.yml ./

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["java", "-Xms3072M", "-Xmx3072M", "-Dfile.encoding=UTF-8", "-jar", "spigot.jar", "--world-dir", "./worlds", "nogui"]
