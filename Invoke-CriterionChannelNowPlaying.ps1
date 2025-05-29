Import-Module .\Receive-CriteronChannelNowPlaying.psm1 -Force

$nowPlaying = Get-NowPlaying
Format-NextMovieTime -Countdown $nowPlaying.Countdown | Out-File NextMovieTime.txt
$message = Format-Message -FilmTitle $nowPlaying.Title -Countdown $nowPlaying.Countdown
Write-Host $message
