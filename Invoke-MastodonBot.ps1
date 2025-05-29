Import-Module .\Receive-CriterionChannelNowPlaying.psm1 -Force

function Invoke-MastodonPost {
    <#
        .SYNOPSIS
            Sends a request to post a message through Mastodon API.
    #>
    params (
        [string]$message
    )

    $headers = @{
        "Authorization" = "Bearer $($Env:AccessToken)"
    }

    $body = @{
        status = $message
    }

    try {
        Invoke-RestMethod -Uri $Env:MastodonInstance -Method Post -Headers $headers -Body $body
    }
    catch {
        "Unable to post message"
    }
}

if (test-path -Path '.\config.psd1') {
    $Config = Import-PowerShellDataFile '.\config.psd1'
    $Env:MastodonInstance = $Config.MastodonInstance
    $Env:AccessToken = $Config.AccessToken
}

if (test-path -Path '.\NextMovieTime.txt') {
    [int]$nextMovieTime = Get-Content '.\NextMovieTime.txt'
    $nextMovieStarted = Confirm-NextMovieStarted -StartTime $nextMovieTime

    if ($nextMovieStarted) {
        $message = Invoke-CriterionChannelNowPlaying
    }
} else {
    $message = Invoke-CriterionChannelNowPlaying
}

if ($message) {
    Invoke-MastodonPost -Message $message
}