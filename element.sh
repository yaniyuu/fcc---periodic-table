#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_PROGRAM() {
  if [[ -z $1 ]]; then
    echo "Please provide an element as an argument."
  else
    # Check if input is a number or not
    if [[ $1 =~ ^[0-9]+$ ]]; then
      QUERY_CONDITION="atomic_number=$1"
    else
      QUERY_CONDITION="symbol ILIKE '$1' OR name ILIKE '$1'"
    fi

 
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $QUERY_CONDITION")

   
    if [[ -z $ELEMENT_INFO ]]; then
      echo "I could not find that element in the database."
    else
   
      IFS=" | " read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_INFO"

   
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    fi
  fi
}

MAIN_PROGRAM "$1"
