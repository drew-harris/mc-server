cd /plugins

echo "Rebuilding MFP Portal"
echo "========================"
cd  MFPPortal
mvn -f ./pom.xml clean package
cp /plugins/MFPPortal/target/MFPPortal-1.0-SNAPSHOT.jar /server/plugins/MFPPortal.jar
cd /plugins
