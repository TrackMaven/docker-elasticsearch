FROM java:8-jre

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV ES_VERSION 2.1.2

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

RUN apt-get update --fix-missing
RUN apt-get -y install python-pip
RUN pip install envtpl

# Add etcdenv
ADD https://github.com/upfluence/etcdenv/releases/download/v0.3.1/etcdenv-linux-amd64-0.3.1 /usr/local/bin/etcdenv
RUN chmod +x /usr/local/bin/etcdenv

ADD elasticsearch.yml.tpl /elasticsearch/config/elasticsearch.yml.tpl

ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

CMD run