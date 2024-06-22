#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

TRUNCATE_TABLES=$($PSQL "TRUNCATE TABLE users, games RESTART IDENTITY")