#!/bin/bash
set -e

echo "This is travis-build.bash..."

echo "Installing the packages that CKAN requires..."
sudo apt-get update -qq
sudo apt-get install solr-jetty libcommons-fileupload-java

echo "Installing CKAN and its Python dependencies..."
git clone https://github.com/ckan/ckan
cd ckan
if [ $CKANVERSION == 'master' ]
then
    echo "CKAN version: master"
else
    CKAN_TAG=$(git tag | grep ^ckan-$CKANVERSION | sort --version-sort | tail -n 1)
    git checkout $CKAN_TAG
    echo "CKAN version: ${CKAN_TAG#ckan-}"
fi

# install the recommended version of setuptools
if [ -f requirement-setuptools.txt ]
then
    echo "Updating setuptools..."
    pip install -r requirement-setuptools.txt
fi

python setup.py develop

pip install -r requirements.txt
pip install -r dev-requirements.txt
cd -

echo "Setting up Solr..."

echo $JAVA_OPTS

printf "NO_START=0\nJETTY_HOST=127.0.0.1\nJETTY_PORT=8983\nJAVA_HOME=$JAVA_HOME\nJAVA_OPTS=\"$JAVA_OPTS\"" | sudo tee /etc/default/jetty

echo "here comes jetty"
cat /etc/default/jetty
echo "here comes jetty"

# use ckanext-switzerland custom schema.xml to run tests
sudo cp solr/schema.xml /etc/solr/conf/schema.xml
sudo cp solr/fr_elision.txt /etc/solr/conf/fr_elision.txt
sudo cp solr/german_stop.txt /etc/solr/conf/german_stop.txt
sudo cp solr/english_stop.txt /etc/solr/conf/english_stop.txt
sudo cp solr/french_stop.txt /etc/solr/conf/french_stop.txt
sudo cp solr/italian_stop.txt /etc/solr/conf/italian_stop.txt
sudo cp solr/german_dictionary.txt /etc/solr/conf/german_dictionary.txt
sudo service jetty restart

echo "Creating the PostgreSQL user and database..."
sudo -u postgres psql -c "CREATE USER ckan_default WITH PASSWORD 'pass';"
sudo -u postgres psql -c 'CREATE DATABASE ckan_test WITH OWNER ckan_default;'

echo "Initialising the database..."
cd ckan
paster db init -c test-core.ini
cd -

echo "Installing ckanext-scheming and its requirements..."
git clone https://github.com/ckan/ckanext-scheming
cd ckanext-scheming
python setup.py develop
pip install -r requirements.txt
cd -

echo "Installing ckanext-fluent and its requirements..."
git clone https://github.com/ckan/ckanext-fluent
cd ckanext-fluent
python setup.py develop
cd -

echo "Installing ckanext-hierarchy and its requirements..."
git clone https://github.com/opendata-swiss/ckanext-hierarchy
cd ckanext-hierarchy
python setup.py develop
cd -

echo "Installing ckanext-harvest and its requirements..."
git clone https://github.com/ckan/ckanext-harvest
cd ckanext-harvest
python setup.py develop
pip install -r pip-requirements.txt
paster harvester initdb -c ../ckan/test-core.ini
cd -

echo "Installing ckanext-dcat and its requirements..."
git clone https://github.com/ckan/ckanext-dcat
cd ckanext-dcat
python setup.py develop
pip install -r requirements.txt
pip install -r dev-requirements.txt
cd -

echo "Installing ckanext-dcatapchharvest and its requirements..."
git clone https://github.com/opendata-swiss/ckanext-dcatapchharvest
cd ckanext-dcatapchharvest
python setup.py develop
pip install -r requirements.txt
pip install -r dev-requirements.txt
cd -

echo "Installing ckanext-xloader and its requirements..."
git clone https://github.com/ckan/ckanext-xloader
cd ckanext-xloader
python setup.py develop
pip install -r requirements.txt
cd -

echo "Installing ckanext-showcase..."
git clone https://github.com/ckan/ckanext-showcase
cd ckanext-showcase
python setup.py develop
cd -

echo "Installing ckanext-switzerland and its requirements..."
python setup.py develop
pip install -r requirements.txt
pip install -r dev-requirements.txt

echo "Moving test.ini into a subdir..."
mkdir subdir
mv test.ini subdir

echo "travis-build.bash is done."
