FROM java:8-jre

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN arch="$(dpkg --print-architecture)" \
    && set -x \
    && curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch" \
    && curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ES_VERSION 2.1.0

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.tar.gz && \
  tar xvzf elasticsearch-${ES_VERSION}.tar.gz && \
  rm -f elasticsearch-${ES_VERSION}.tar.gz && \
  mv /tmp/elasticsearch-${ES_VERSION} /elasticsearch


RUN useradd elasticsearch

RUN set -ex \
    && for path in \
        /elasticsearch/data \
        /elasticsearch/logs \
        /elasticsearch/config \
        /elasticsearch/config/scripts \
    ; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done


# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

EXPOSE 9200
EXPOSE 9300

# Elasticsearch plugins woop!
RUN /elasticsearch/bin/plugin install cloud-aws

RUN apt-get update
RUN apt-get -y install python-pip
RUN pip install envtpl

# Add etcdenv
ADD https://github.com/upfluence/etcdenv/releases/download/v0.3.1/etcdenv-linux-amd64-0.3.1 /usr/local/bin/etcdenv
RUN chmod +x /usr/local/bin/etcdenv

ADD elasticsearch.yml.tpl /elasticsearch/config/elasticsearch.yml.tpl

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

CMD run