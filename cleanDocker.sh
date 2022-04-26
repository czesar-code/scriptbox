#!/bin/bash
set -e

GREEN=$'\e[1;32m'
RED=$'\e[1;31m'
NOCOLOR=$'\033[0m'

# START INFO
echo ""
echo "##########"
echo "### $GREEN INFO $NOCOLOR"
echo "##########"
echo ""
docker system df

sleep 3
echo ""
echo "##################"
echo "### $RED SYSTEM PRUNE $NOCOLOR"
echo "##################"
echo ""
docker system prune -af

# sleep 1
# docker image prune -af

# sleep 1
# docker container prune -f

sleep 1
echo ""
echo "##################"
echo "### $RED VOLUME PRUNE $NOCOLOR"
echo "##################"
echo ""
docker volume prune -f

# FINALLY
echo ""
echo "##########"
echo "### $GREEN INFO $NOCOLOR"
echo "##########"
echo ""
docker system df


