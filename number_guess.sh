#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUMBER=$(shuf -i 1-1000 -n 1)

PSQL_FULL_JOIN_ALL_TABLES="
  SELECT
    u.user_id AS users_user_id,
    u.username,
    u.games_played,
    g.game_id,
    g.number_of_guesses
  FROM
    users u
  FULL JOIN
    games g ON u.user_id = g.user_id
"

MAIN_MENU() {
  echo -e "\n~~~~ Number Guessing Game ~~~~\n"

  echo Enter your username:
  read USERNAME

  USERNAME_RESULT=$($PSQL "
    SELECT
      u.user_id AS users_user_id,
      u.username,
      u.games_played,
      g.game_id,
      g.number_of_guesses
    FROM
      users u
    FULL JOIN
      games g ON u.user_id = g.user_id
    WHERE username='$USERNAME'
    ORDER BY
        g.number_of_guesses
    LIMIT 1
  ")

  if [[ -z $USERNAME_RESULT ]]
  then
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  else
    echo $USERNAME_RESULT
    echo "$USERNAME_RESULT" | while IFS='|' read USER_ID USERNAME GAMES_PLAYED GAME_ID NUMBER_OF_GUESSES
    do
      echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $NUMBER_OF_GUESSES guesses."
    done
  fi

  echo -e "\nGuess the secret number between 1 and 1000:"
  read USER_GUESS
  NUMBER_OF_GUESSES=1

  GUESSING_LOOP() {
    if [[ ! $1 =~ ^-?[0-9]+$ ]]
      then
        echo That is not an integer, guess again:
        read USER_GUESS
        GUESSING_LOOP "$USER_GUESS"
    elif [[ $1 -lt $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read USER_GUESS
        ((NUMBER_OF_GUESSES++))
        GUESSING_LOOP "$USER_GUESS"
    elif [[ $1 -gt $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read USER_GUESS
        ((NUMBER_OF_GUESSES++))
        GUESSING_LOOP "$USER_GUESS"
    else
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

      ADD_GAME_END_RESULT=$($PSQL "INSERT INTO games (user_id, number_of_guesses) VALUES ($USER_ID, $NUMBER_OF_GUESSES)")

      ADD_TO_GAMES_PLAYED_RESULT=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id = $USER_ID")

      echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!
      exit 0
    fi
  }

  GUESSING_LOOP "$USER_GUESS"
  
}

MAIN_MENU