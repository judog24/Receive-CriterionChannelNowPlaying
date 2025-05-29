Import-Module .\Receive-CriterionChannelNowPlaying.psm1 -Force

function Invoke-MastodonPost {
    <#
        .SYNOPSIS
            Sends a request to post a message through Mastodon API.
    #>
    param (
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

$message = Invoke-CriterionChannelNowPlaying
Invoke-MastodonPost -Message $message