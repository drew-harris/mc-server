#################
#### PLUGINS ####
#################
FROM maven:3.9.2-eclipse-temurin-17 as plugins
WORKDIR /plugins

COPY ./plugins/DrewsPlugin/ ./DrewsPlugin
RUN mvn -f ./DrewsPlugin/pom.xml clean package


#################
#### SERVER #####
#################
FROM maven:3.9.2-eclipse-temurin-17

WORKDIR /server

ARG spigot_url=https://minecraft-hgl-drew.s3.amazonaws.com/spigot.jar

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

COPY ./spigot/spigot.yml ./

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["java", "-Xms1024M", "-Xmx2048M", "-Dfile.encoding=UTF-8", "-jar", "spigot.jar", "--world-dir", "./worlds", "nogui"]
