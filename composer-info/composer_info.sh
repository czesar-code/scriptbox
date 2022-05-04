#!/bin/bash
set -e

curl https://repo.ratioform.de/ratioform/ratioform-shop/-/raw/feature/RF-3509-Spryker-update-step6/composer.json --output feature_composer.json

sleep 1

curl https://repo.ratioform.de/ratioform/ratioform-shop/-/blob/dev/development/composer.json --output dev_composer.json

sleep 1

curl https://repo.ratioform.de/ratioform/ratioform-shop/-/blob/clean/stage/composer.json --output stage_composer.json

sleep 1

curl https://repo.ratioform.de/ratioform/ratioform-shop/-/blob/clean/production/composer.json --output prod_composer.json

