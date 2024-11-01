#!/bin/bash

docker-compose down -v
docker-compose up --build -d
sleep 7
docker exec debezium curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d "@/kafka/connectors/card_test_connector.json"
docker exec -it db psql -U postgres -d test -f /db_scripts/card_test_insert.sql
docker exec -it kafka kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic pgtest.public.card_test --from-beginning
