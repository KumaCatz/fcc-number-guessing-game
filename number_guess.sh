#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

RANDOM_NUMBER=$(shuf -i 1-1000 -n 1)

MAIN_MENU() {
  echo -e "\n~~~~ Number Guessing Game ~~~~\n"

  echo Enter your username:
  read USERNAME
  
}

MAIN_MENU