<#
.SYNOPSIS
Get-LeagueCalendar.ps1 - This script generates a league calendar giving a list of teams.

.DESCRIPTION 
This script generates a league calendar report containing all the matches 1 vs. 1 among the provided teams. The teams are provided in a .csv
file, which name is provided to the script when prompted. 
For instance, if your .csv file contains "Team A", "Team B", "Team C", and "Team D" this script will provide you with a league calendar
report made as follows:
Day | "Match 1"; "Match 2"
1   | "Team A - Team B"; "Team C - Team D"
2   | "Team A - Team C"; "Team B - Team D"
3   | "Team A - Team D"; "Team B - Team C"

.OUTPUTS
A final csv report will be provided at .\Calendar_$File.csv, where $File is the input file name.

.NOTES
Written by: Stefano Viti - stefano.viti1995@gmail.com
Follow me at https://www.linkedin.com/in/stefano-viti/

#>

Clear-Host

#1 - Environmental Variables

$Calendar = @()
$CheckGame = @()
$File = Read-Host "Insert the name of the file containing the list of the teams (without the .csv suffix!)"
$Path = ".\" + $File + ".csv"
$Teams = Import-csv -path $Path -Encoding UTF8
$TeamsCount = $Teams.count

#2 - Calendar Creation

For ($i=1; $i -lt $TeamsCount; $i++){
    Write-Host "Creating the matches for the day $($i)" -ForegroundColor Yellow
    $Day = @()
    $Teams = Import-csv -path $Path -Encoding UTF8
    $j = 0
    While ($j -lt ($TeamsCount-1)){
        $max = ($TeamsCount-1) - $j
        $selector1 = Get-Random -Minimum 0 -Maximum $max
        $Team1 = $Teams[$selector1].Team
        $Teams = $Teams | Where-Object {$_.Team -ne $Team1} 
        if ($j -eq ($TeamsCount-2)){
            $selector2 = 0
        }
        else{
            $max = $TeamsCount -2 - $j
            $selector2 = Get-Random -Minimum 0 -Maximum $max
        }
        $Team2 = $Teams[$selector2].Team
        $Teams = $Teams | Where-Object {$_.Team -ne $Team2}
        $Game = $Team1 + " - " + $Team2
        $ReturnGame = $Team2 + " - " + $Team1
        $GameHash = @{
            Game = $Game
        }
        $Match = New-Object -TypeName PSObject -Property $GameHash
        if ($CheckGame -match $Game -or $CheckGame -match $ReturnGame){
            if($Teams.count -eq 0){
                $j = 0
                $Teams = Import-csv -path $Path -Encoding UTF8
                $Day = @()
                $CheckGame = ({$CheckGame}.Invoke())
                $CountCheckGame = $CheckGame.count
                for ($k=1; $k -lt 10; $k++){
                    $CheckGame.RemoveAt($CountCheckGame - $k)
                }
                $CheckGameDummy = $CheckGame -join "|"
                $CheckGame = $CheckGameDummy -split "\|"
            }
            else{
                $hashTeam1=@{
                    Team = $Team1
                }
                $Team1ToReAdd = New-Object psobject -Property $hashTeam1
                $Teams = $Teams + $Team1ToReAdd
                $hashTeam2=@{
                    Team = $Team2
                }
                $Team2ToReAdd = New-Object psobject -Property $hashTeam2
                $Teams = $Teams + $Team2ToReAdd
            }
        }
        else{
            $CheckGame = $CheckGame +$match
            $Day = $Day + $Match
            $j = $j + 2
        }
    }
    $MatchList = $Day.game
    $MatchList = $MatchList -join "|"
    $DayHash = [ordered]@{
        Day = "Day " + $i
        MatchList = $MatchList
    }
    $DayCalendar = New-Object PSObject -Property $DayHash
    $Calendar = $Calendar + $DayCalendar
    Write-Host "Created all the matches in day $($i)" -ForegroundColor Green
}

#3 - Create the final report

$NewHeader = $Null
$l = 1

while ($l -le $TeamsCount/2){
    if ($l -eq $TeamsCount/2){
        $NewHeader = $NewHeader + "Game " + $l
    }
    else{
        $NewHeader = $NewHeader + "Game " + $l + "|"
    }
    $l = $l + 1
} 

$Calendar | Export-csv -path .\Calendar.txt -Encoding UTF8 -NoTypeInformation
$FinalCalendar = Import-Csv .\Calendar.txt -Encoding UTF8 -Header "Day",$NewHeader | Select-Object -skip 1
$ExportFile = "Calendar" + "-" + $File
$ExportPath = ".\" + $ExportFile + ".csv" 
$FinalCalendar | Export-csv -path $ExportPath -Encoding UTF8 -NoTypeInformation
Remove-Item -Path .\Calendar.txt