#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$(shuf -i 1-1000 -n 1)

PSQL_FULL_JOIN_ALL_TABLES="
  SELECT
    *
  FROM
    users
  FULL JOIN
    games ON users.user_id = games.user_id
"

MAIN_MENU() {
  echo -e "\n~~~~ Number Guessing Game ~~~~\n"

  echo Enter your username:
  read USERNAME

  USERNAME_RESULT=$($PSQL "$PSQL_FULL_JOIN_ALL_TABLES WHERE username='$USERNAME'")

  if [[ -z $USERNAME_RESULT ]]
  then
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  else
    echo $USERNAME_RESULT
    echo $USERNAME_RESULT | while IFS='|' read USER_ID
    do
      echo Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.
    done
  fi
  
}

MAIN_MENU