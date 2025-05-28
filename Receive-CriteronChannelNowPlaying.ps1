Install-Module -Name PowerHTML

function Receive-HTML {
    <#
        .SYNOPSIS
            Receive HTML containing the title of the movie currently playing and minutes remaining.
    #>
    param (
        [string]$url
    )
    process {
        try {
            $response = Invoke-WebRequest -uri $url

            if ($response.StatusCode -eq 200) {
                $html = $response.Content

                $html
            } else {
                throw
            }
        }
        catch {
            "Unable to connect to website"
        }
    }
}

function Get-Countdown {
    <#
        .SYNOPSIS
            Returns a string of the number of minutes before the next film starts.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param (
        $nodes
    )
    begin {
        $countdown = ""
    }
    process {
        foreach ($node in $nodes) {
            if ($node.innerText -like "*minutes") {
                $countdown = $node.innerText
            }
        }

        $countdown
    }
}

function Format-Message {
    <#
        .SYNOPSIS
            Constructs the message that will be displayed.
    #>
    [OutputType([string])]
    param (
        [string]$FilmTitle,
        [string]$Countdown
    )
    process {
        [string]$message = "Now Playing: $FilmTitle. `nNext film starts in: $Countdown"
        
        $message
    }
}

function Get-NowPlaying {
    <#
        .SYNOPSIS
            Returns a custom object containing the current movie playing and time remaining.
    #>
    [OutputType([PSCustomObject])]
    $url = "https://whatsonnow.criterionchannel.com/"

    $html = Receive-HTML -url $url
    $content = ConvertFrom-Html $html

    $filmTitle = $content.SelectNodes("//h2[@class='whatson__title']")[0].innerText
    $countdown = Get-Countdown -nodes $content.SelectNodes("//span[@class='whatson__eyebrow--bold']")

    $NowPlaying = [PSCustomObject]@{
        Title = $filmTitle
        Countdown = $countdown
    }

    $NowPlaying
}
