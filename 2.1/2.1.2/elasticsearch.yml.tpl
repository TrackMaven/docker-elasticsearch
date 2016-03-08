################################### Cluster ###################################

# Cluster name identifies your cluster for auto-discovery. If you're running
# multiple clusters on the same network, make sure you're using unique names.
#
cluster.name: "elasticsearch"


#################################### Node #####################################

# Node names are generated dynamically on startup, so you're relieved
# from configuring them manually. You can tie this node to a specific name:
#
{% if NODE_MASTER is defined %}
node.master: true
node.data: false
{% elif NODE_DATA is defined %}
node.master: false
node.data: true
{% elif NODE_CLIENT is defined %}
node.master: false
node.data: false
{% else %}
node.master: true
node.data: true
{% endif %}


################################### Memory ####################################

# Elasticsearch performs poorly when JVM starts swapping: you should ensure that
# it _never_ swaps.
#
# Set this property to true to lock the memory:
#
bootstrap.mlockall: true


################################## Discovery ##################################

discovery.zen.ping.multicast.enabled: false