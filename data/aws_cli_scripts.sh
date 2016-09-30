#!/usr/bin/env bash

URL="http://localhost:8000"

aws dynamodb list-tables --endpoint-url ${URL}

aws dynamodb scan --endpoint-url ${URL} --table-name patient

aws dynamodb delete-table --endpoint-url ${URL} --table-name event
aws dynamodb delete-table --endpoint-url ${URL} --table-name patient
aws dynamodb delete-table --endpoint-url ${URL} --table-name shipment
aws dynamodb delete-table --endpoint-url ${URL} --table-name specimen
aws dynamodb delete-table --endpoint-url ${URL} --table-name variant
aws dynamodb delete-table --endpoint-url ${URL} --table-name assignment
aws dynamodb delete-table --endpoint-url ${URL} --table-name variant_report
aws dynamodb list-tables --endpoint-url ${URL}

aws dynamodb delete-table --endpoint-url ${URL} --table-name treatment_arm
aws dynamodb delete-table --endpoint-url ${URL} --table-name treatment_arm_patient
