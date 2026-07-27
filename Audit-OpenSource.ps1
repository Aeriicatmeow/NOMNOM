dotnet tool install -g ilspycmd

$mods = get-content .\manifest\manifest.json | ConvertFrom-Json

cd .\audit

foreach ($mod in $mods[0..2]) {


    mkdir $mod.id
    mkdir ".\$($mod.id)\repo"
    mkdir ".\$($mod.id)\release"
    mkdir ".\$($mod.id)\decompiled"

    $repo = "https://github.com/$($mod.gitHubOwner)/$($mod.gitHubRepoName)"
    $release = "https://github.com/$($mod.gitHubOwner)/$($mod.gitHubRepoName)\releases\latest"
    git clone $repo ".\$($mod.id)\repo"

    $outFile = ".\$($mod.id)\release\$($mod.artifacts[0].fileName)"
    Invoke-WebRequest -Uri $mod.artifacts[0].downloadUrl -OutFile $outFile

    if ($outFile -match '\.(zip|rar|7z|tar\.gz|tgz|gz|tar)$') {
        if ($outFile -match '\.zip$') {
            Expand-Archive -Path $outFile -DestinationPath ".\$($mod.id)\release" -Force
        }
        else {
            tar -xf $outFile -C ".\$($mod.id)\release"
        }
        Remove-Item -Path $outFile -Force
    }
}

cd ..

WaitForAllThreads

$repos = get-childitem .\audit