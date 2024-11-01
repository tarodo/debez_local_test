# PAN Masking: Local Development Environment
This repository provides a local environment setup with PostgreSQL, Debezium, and Kafka for development and testing purposes.

## Example `card_test`
Included as part of the environment setup, connector settings are configured for various masking and hashing techniques at the Debezium stage before dispatching the message to Kafka.

Details for configuring the connector to work with PAN fields are found in the `connectors/card_test_connector.json`.

### The built-in mechanisms are:
1. PAN1, PAN5: Utilizes SHA-256 for data hashing.
1. PAN2: Employs SHA-512 for a higher level of data encryption.
1. PAN3: Replaces the entire card number with six asterisks.

### Third-party mechanisms:
1. PAN4, PAN6: Demonstrates the use of the custom-developed PanConverter.

## Add new Custom Converter
1. Add your `.jar` file into dir `debezium/converters/
2. Use it in your connector config

## Automated Build:
Run the following shell script to build the environment:
```shell
./check_flow.sh
```

## Automated Connector Update:
The following shell script updates the connector configuration:
```shell
./renew_connector.sh
```

## Manual build
1. Start services:
```sh
docker-compose up --build -d
```
2. Start connector:
```sh
docker exec debezium curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d "@/kafka/connectors/card_test_connector.json"
```
3. List connectors(Optional):
```sh
docker exec debezium curl -i localhost:8083/connectors/
```
4. Check connector status:
```sh
docker exec debezium curl -i localhost:8083/connectors/card_test/status
```
4. Check connector config:
```sh
docker exec debezium curl -i localhost:8083/connectors/card_test/config
```
4. Insert new row:
```sh
docker exec -it db psql -U postgres -d test -f /db_scripts/card_test_insert.sql
```
5. List Kafka topics(Optional):
```sh
docker exec -it kafka kafka-topics.sh --bootstrap-server=localhost:9092 --list
```
7. Check Kafka topic:
```sh
docker exec -it kafka kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic pgtest.public.card_test --from-beginning
```
9. Check messages count(Optional):
```shell
docker exec -it kafka kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic pgtest.public.card_test
```