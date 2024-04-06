#!/bin/python3

from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/', methods=['GET'])
def get():
    return str("Usage:\n1) Team with the highest number of wins in a season\n2) Team with the highest total points scored in a season\n3) Game with the highest total rating\n\n")

@app.route('/', methods=['POST'])
def post():
    received_value = str(request.get_data(as_text=True))
    print("Received value:", received_value)
    answer = calculate_answer(received_value)
    return str(answer)

def calculate_answer(received_value):
    ret_value = None
    match received_value:
        case "1":
            q1 = '''
                SELECT team, season, COUNT(*) AS total_wins
                FROM (
                    SELECT 
                        CASE WHEN score1 > score2 THEN team1
                             WHEN score2 > score1 THEN team2
                        END AS team,
                        season
                    FROM corin_database.nba_elo_2023
                ) AS winners
                GROUP BY team, season
                ORDER BY total_wins DESC
                LIMIT 1;
            '''
            print("Executing query 1:", q1)
            ret_value = subprocess.run(['mysql'], shell=False, capture_output=True, text=True, input=q1)
            print("Query 1 output:", ret_value.stdout)
        case "2":
            q2 = '''
                SELECT team, season, SUM(score) AS total_points
                FROM (
                    SELECT team1 AS team, season, score1 AS score
                    FROM corin_database.nba_elo_2023
                    UNION ALL
                    SELECT team2 AS team, season, score2 AS score
                    FROM corin_database.nba_elo_2023
                ) AS all_teams
                GROUP BY team, season
                ORDER BY total_points DESC
                LIMIT 1;
            '''
            print("Executing query 2:", q2)
            ret_value = subprocess.run(['mysql'], shell=False, capture_output=True, text=True, input=q2)
            print("Query 2 output:", ret_value.stdout)
        case "3":
            q3 = '''
                SELECT date, team1, score1, team2, score2, total_rating
                FROM corin_database.nba_elo_2023
                ORDER BY total_rating DESC
                LIMIT 1;
            '''
            print("Executing query 3:", q3)
            ret_value = subprocess.run(['mysql'], shell=False, capture_output=True, text=True, input=q3)
            print("Query 3 output:", ret_value.stdout)
    return ret_value.stdout

if __name__ == "__main__":
    app.run(host='0.0.0.0')
