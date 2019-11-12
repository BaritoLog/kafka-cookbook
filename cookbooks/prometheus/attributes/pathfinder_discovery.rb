#
# Cookbook:: prometheus
# Attributes:: pathfinder_discovery
#
# Copyright:: 2019, BaritoLog.

# Pathfinder Discovery directory
default["pathfinder_discovery"]["dir"] = "#{node["prometheus"]["dir"]}/pathfinder_discovery"
default["pathfinder_discovery"]["log_dir"] = "#{node["prometheus"]["log_dir"]}"
default["pathfinder_discovery"]["pathfinder_url"] = ""
default["pathfinder_discovery"]["pathfinder_containers_path"] = "/api/v2/ext_app/containers"
default["pathfinder_discovery"]["pathfinder_nodes_path"] = "/api/v1/ext_app/nodes"
default["pathfinder_discovery"]["pathfinder_token"] = ""

# Port mapping for each service
default["pathfinder_discovery"]["zookeeper_port"] = "9141"
default["pathfinder_discovery"]["kafka_port"] = "9308"
default["pathfinder_discovery"]["kibana_port"] = "80"
default["pathfinder_discovery"]["barito_flow_consumer_port"] = "8008"
default["pathfinder_discovery"]["barito_flow_producer_port"] = "8008"
default["pathfinder_discovery"]["consul_port"] = "9107"
default["pathfinder_discovery"]["elasticsearch_port"] = "9114"
default["pathfinder_discovery"]["barito_app_port"] = "3000"
default["pathfinder_discovery"]["postgres_port"] = "9187"
default["pathfinder_discovery"]["redis_port"] = "9121"
default["pathfinder_discovery"]["alertmanager_port"] = "9093"
default["pathfinder_discovery"]["prometheus_port"] = "9090"
default["pathfinder_discovery"]["grafana_port"] = "3000"

default["pathfinder_discovery"]["pathfinder_cluster"] = []
default["pathfinder_discovery"]["pathfinder_scrape_type"] = {
    "container" => "target_container.json",
    "nodes" => "target_node.json"
}
