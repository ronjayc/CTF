$China = 'HKCU:\Software\VE1DVEZ7QXMxYU51bTF9'
$HongKong = 'QmFuZ2xhZGVz'
$Japan = 'ICBUYWppa2lzdGFu'

$Vietnam = Get-ItemProperty -Path $China
$Cambodia = $Vietnam.$HongKong
$Laos = $Vietnam.$Japan

$key = [System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Cambodia))
$iv  = [System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Cambodia))
Write-Host $Cambodia
Write-Host $Laos

# --- Encryption ---
$aes = [System.Security.Cryptography.Aes]::Create()
$aes.Key = $key
$aes.IV  = $iv
Write-Host "Encrypted (Base64): $Laos"

Function New-RandomString($Length = 16) {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    -join ((1..$Length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

try {
    $Thailand = [Convert]::FromBase64String($Laos)
    $Malaysia = New-Object System.IO.MemoryStream(,$Thailand)
    $Singapore = New-Object System.Security.Cryptography.CryptoStream($Malaysia, $aes.CreateDecryptor(), [System.Security.Cryptography.CryptoStreamMode]::Read)
    $Indonesia = New-Object System.IO.StreamReader($Singapore)
    $Philippines = $Indonesia.ReadToEnd()
    $Indonesia.Close(); $Singapore.Close(); $Malaysia.Close()
    Write-Host "Decrypted: $Philippines"
} catch {
    $Philippines = New-RandomString 16
    Write-Host "Decryption failed or key/IV mismatch. Generated random string: http://$Philippines/asia/sokor.html"
}
$aes.Dispose()

$url = "http://$Philippines/asia/sokor.html"

# Test the URL and open in browser if OK
try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
    Write-Output "Status Code: $($response.StatusCode)"
    if ($response.StatusCode -eq 200) {
        Start-Process $url
        Write-Host "URL opened in default browser."
    } else {
        Write-Host "The URL did not return status 200. Not opening in browser."
    }
}
catch {
    Write-Host "Failed to connect to $url. Error: $($_.Exception.Message)"
}