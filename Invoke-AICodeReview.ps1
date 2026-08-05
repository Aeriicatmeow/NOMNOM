param (
    [string]$ModId,
    [string]$PromptFilePath = ".\prompt.md"
)

$repoDir = ".\$ModId\repo"
$decompiledDir = ".\$ModId\decompiled"
$resultsFile = ".\$ModId\results\AI_Review.md"

# 1. Load the system prompt
$systemPrompt = Get-Content $PromptFilePath -Raw

# 2. Gather all code into a single string to send as context
$codeContext = "=== REPO SOURCE CODE ===`n"
Get-ChildItem -Path $repoDir -Recurse -Filter *.cs | ForEach-Object {
    $codeContext += "`n--- FILE: $($_.FullName.Replace($PWD.Path, '')) ---`n"
    $codeContext += Get-Content $_.FullName -Raw
}

$codeContext += "`n`n=== DECOMPILED SOURCE CODE ===`n"
Get-ChildItem -Path $decompiledDir -Recurse -Filter *.cs | ForEach-Object {
    $codeContext += "`n--- FILE: $($_.FullName.Replace($PWD.Path, '')) ---`n"
    $codeContext += Get-Content $_.FullName -Raw
}

# 3. Construct the full prompt string
$fullPrompt = "$systemPrompt`n`nHere is the code to review:`n`n$codeContext"

    Write-Host "Sending $ModId to local Ollama API (deepseek-coder:6.7b) for review (Context length: $($codeContext.Length) chars)..."
    
    try {
        $body = @{
            model = "deepseek-coder:6.7b"
            prompt = $fullPrompt
            stream = $false
        } | ConvertTo-Json -Depth 10 -Compress
        
        # 4. Call the local Ollama REST API
        $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json"
        
        # 5. Save the output
        $response.response | Out-File -FilePath $resultsFile -Encoding UTF8
        
        Write-Host "AI Review completed for $ModId!" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to run Ollama: $_"
    }
