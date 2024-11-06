set -o allexport; source .env; set +o allexport; docker exec -it postgres psql -U ${GRAPH_NODE_DB_USER} ${GRAPH_NODE_DB_NAME} -c "refresh materialized view info.subgraph_sizes;"
