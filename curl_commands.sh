#!/bin/bash

# Script to interact with Flask API using curl commands

# GET request to fetch usage information
echo "Fetching usage information..."
curl http://192.168.64.14:5000/

# POST request to query for the team with the highest number of wins in a season
echo "Querying for the team with the highest number of wins in a season..."
curl -X POST -d "1" http://192.168.64.14:5000/

# POST request to query for the team with the highest total points scored in a season
echo "Querying for the team with the highest total points scored in a season..."
curl -X POST -d "2" http://192.168.64.14:5000/

# POST request to query for the game with the highest total rating
echo "Querying for the game with the highest total rating..."
curl -X POST -d "3" http://192.168.64.14:5000/

