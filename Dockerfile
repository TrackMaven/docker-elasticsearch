# ElasticSearch Dockerfile
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM dockerfile/java

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.7.2.tar.gz && \
  tar xvzf elasticsearch-1.7.2.tar.gz && \
  rm -f elasticsearch-1.7.2.tar.gz && \
  mv /tmp/elasticsearch-1.7.2 /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

EXPOSE 9200
EXPOSE 9300

# Elasticsearch plugins woop!
RUN /elasticsearch/bin/plugin install elasticsearch/elasticsearch-cloud-aws/2.4.1

RUN apt-get update
RUN apt-get -y install python-pip
RUN pip install envtpl

# Add etcdenv
ADD https://github.com/cameronmaske/etcdenv/releases/download/exit/etcdenv-linux-amd64-exit /usr/local/bin/etcdenv
RUN chmod +x /usr/local/bin/etcdenv

ADD elasticsearch.yml.tpl /elasticsearch/config/elasticsearch.yml.tpl

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
