# Elasticsearch

An [2.1.2](https://www.elastic.co/guide/en/elasticsearch/reference/current/release-notes-2.1.2.html) Elasticsearch docker image for AWS deployments.

# Quick Start

To start a basic container, expose port 9200.

```
docker run --name elasticsearch \
  --publish 9200:9200 \
  quay.io/trackmaven/elasticsearch:2.1.2
```

# Persistence

With the container, the volumes `/elasticsearch/data` and `/elasticsearch/logs` can be persistent
to the host machine.

 To start a default container with attached persistent/shared storage for data:

```sh
docker run --name elasticsearch
  --publish 9200:9200 \
  --volume /data:/elasticsearch/data \
  quay.io/trackmaven/elasticsearch:2.1.2
```

# Adjust configuration

Environment variables are accepted as a means to provide further configuration by reading those starting with `ES_`. Any matching variables will get added to ElasticSearch's configuration file, `elasticsearch.yml' by:

  1. Removing the `ES_` prefix
  2. Transforming to lower case
  3. Replacing occurrences of `_` with `.`, except where there is a double (`__`) which is replaced by a single (`_`).

For example, an environment variable `ES_CLUSTER_NAME=lscluster` will result in `cluster.name=lscluster` within `elasticsearch.yml`. Similarly, `ES_CLOUD_AWS_ACCESS__KEY=GHKDFIADFNADFIADFKJG` would result in `cloud.aws.access_key=GHKDFIADFNADFIADFKJG` within `elasticsearch.yml`.

```
docker run --name elasticsearch \
  --publish 9200:9200 \
  --env ES_CLUSTER_NAME=monolith \
  quay.io/trackmaven/elasticsearch:2.1.2
```

There are a few specific shortcut env vars.

* `NODE_MASTER` - Setting any value will turn this into a [dedicated master node](https://www.elastic.co/guide/en/elasticsearch/reference/1.4/modules-node.html).
* `NODE_DATA` - Setting any value will turn this into a dedicated data node.
* `NODE_CLIENT` - Setting any value will turn this into a dedicated client node.

# Setting Environment Variables with etcd

The image includes [etcdenv](https://github.com/upfluence/etcdenv) as an convenient way to populate environments variables from one your etcd directory.

To start the container linked to an etcd dir, wrap the `run` script with `etcdenv` and desired settings.

```bash
docker run quay.io/trackmaven/elasticsearch:2.1.2 \
  etcdenv --namespace /env/service/prod/es --server http://etcd.skipper.discover:2379 run
```

# Gotchas from 1.X

With Elasticsearch versions >2 the default network bound address is 127.0.0.1. Typically to get access to this from the container, you'll need to add the env var, `ES_NETWORK_BIND__HOST=0.0.0.0`

```bash
docker run --env ES_NETWORK_BIND__HOST=0.0.0.0 quay.io/trackmaven/elasticsearch:2.1.2
```

# Volume sharing workaround.

For docker-machine users, you may run into an issue when syncing the container's volume to your own machine.

```
chown: changing ownership of '...': Operation not permitted
````

The container will attempt to chown elasticsearch's data volume for the user `elasticsearch`.
In local development, you can skip this by setting the env var `SKIP_CHOWN_DATA=true`, but is not advised for production.