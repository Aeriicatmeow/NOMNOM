[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$IssueBody
)

# Initialize an ordered dictionary to keep the JSON output structure clean
$Data = [ordered]@{
    version_string = ""
    mod_id_strings = [System.Collections.Generic.List[string]]::new()
}

$CurrentSection = $null

# Issue forms split the inputs by Markdown headers corresponding to their labels
foreach ($Line in ($IssueBody -split "`r?`n")) {
    $Trimmed = $Line.Trim()
    
    if ($Trimmed -eq "### Version number") {
        $CurrentSection = "Version"
    }
    elseif ($Trimmed -eq "### MOD IDs") {
        $CurrentSection = "Mods"
    }
    elseif ($Trimmed -match "^###\s") {
        # Unrecognized section
        $CurrentSection = $null
    }
    elseif ($Trimmed -ne "" -and $Trimmed -ne "_No response_") {
        # Collect data based on the current active section
        if ($CurrentSection -eq "Version" -and $Data.version_string -eq "") {
            $Data.version_string = $Trimmed
        }
        elseif ($CurrentSection -eq "Mods") {
            $Data.mod_id_strings.Add($Trimmed)
        }
    }
}

# Convert the list to a standard array for correct JSON formatting
$OutputObj = [ordered]@{
    version_string = $Data.version_string
    mod_id_strings = @($Data.mod_id_strings)
}

# Print as JSON
$JsonOutput = $OutputObj | ConvertTo-Json -Depth 5
Write-Output $JsonOutput
