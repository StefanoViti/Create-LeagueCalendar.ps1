# Create-LeagueCalendar.ps1
This script generates a league calendar giving a list of teams. Please read the synopsis for more details.

This script generates a league calendar report containing all the matches 1 vs. 1 among the given teams. The teams are presented in a .csv
file, which name must be provided to the script when prompted. 
For instance, if your .csv file contains "Team A", "Team B", "Team C", and "Team D" this script will provide you with a league calendar
report made as follows:
Day | "Match 1"; "Match 2"
1   | "Team A - Team B"; "Team C - Team D"
2   | "Team A - Team C"; "Team B - Team D"
3   | "Team A - Team D"; "Team B - Team C"

Written by: Stefano Viti - stefano.viti1995@gmail.com
Follow me at https://www.linkedin.com/in/stefano-viti/
