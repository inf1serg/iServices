     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWHOG1: WebService                                          *
      *          Cotización Riesgos Varios - wrapper para            *
      *          _cotizarWeb()                                       *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                       *24-Sep-2015        *
      * ------------------------------------------------------------ *
      * 15/12/15 - Se realizaron cambios de parametros               *
      * LRG 19/09/2017 - Se agrega Auditoria de llamada              *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/cowhog_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D COWHOG1         pr                  ExtPgm('COWHOG1')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peCfpg                       3  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peSuma                      13  2
     D   peLnsp                       1
     D   peBoni                            likeds(Bonific) dim(200)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrem                      13  2
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWHOG1         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peCfpg                       3  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peSuma                      13  2
     D   peLnsp                       1
     D   peBoni                            likeds(Bonific) dim(200)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrem                      13  2
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D @@Cfpg          s                   like(peCfpg) inz
     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D @@DsTim         ds                  likeds( Dsctwtim_t )

      /free

       *inlr = *on;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>COWHOG1 (Request)</b>'               + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEBASE'                                 + CRLF
            + '&nbsp;PEEMPR: ' + peBase.peEmpr         + CRLF
            + '&nbsp;PESUCU: ' + peBase.peSucu         + CRLF
            + '&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + 'PEBASE'                                 + CRLF
            + 'PERAMA: '  + %editc(peRama:'X')         + CRLF
            + 'PEARSE: '  + %editc(peArse:'X')         + CRLF
            + 'PEPOCO: '  + %editc(pePoco:'X')         + CRLF
            + 'PEXPRO: '  + %editc(peXpro:'X')         + CRLF
            + 'PETVIV: '  + %editc(peTviv:'X')         + CRLF
            + 'PECOPO: '  + %editc(peCopo:'X')         + CRLF
            + 'PECOPS: '  + %editc(peCops:'X')         + CRLF
            + 'PESCTA: '  + %editc(peScta:'X')         + CRLF
            + 'PEBURE: '  + %editc(peBure:'X')         + CRLF
            + 'PECFPG: '  + %editc(peCfpg:'X')         + CRLF
            + 'PETIPE: '  + %trim(peTipe)              + CRLF
            + 'PECIVA: '  + %editc(peCiva:'X') + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 50;
           if peCara(i).ccba <= 0;
              leave;
           endif;
           Data = 'PECARA(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;CCBA: ' + %editc(peCara(i).ccba:'X') + CRLF
                + '&nbsp;DCBA: ' + %trim(peCara(i).dcba) + CRLF
                + '&nbsp;MA01: ' + %trim(peCara(i).ma01) + CRLF
                + '&nbsp;MA02: ' + %trim(peCara(i).ma02) + CRLF
                + '&nbsp;MA01M: ' + %trim(peCara(i).ma01m) + CRLF
                + '&nbsp;MA02M: ' + %trim(peCara(i).ma02m) + CRLF
                + '&nbsp;CBAE: ' + %trim(peCara(i).cbae) + CRLF
                + 'PECARA' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       for i = 1 to 20;
           if peCobe(i).riec = *blanks;
              leave;
           endif;
           Data = 'PECOBE(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;RIEC: ' + %trim(peCobe(i).riec) + CRLF
                + '&nbsp;XCOB: ' + %editc(peCobe(i).xcob:'X') + CRLF
                + '&nbsp;SAC1: ' +
                        %editw(peCobe(i).sac1:'  .   .   . 0 ,  ')+CRLF
                + 'PECOBE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       callp COWHOG_cotizarWeb( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : peXpro
                              : peTviv
                              : peCara
                              : peCopo
                              : peCops
                              : peScta
                              : peBure
                              : peCfpg
                              : peTipe
                              : peCiva
                              : peCobe
                              : peSuma
                              : peLnsp
                              : peBoni
                              : peImpu
                              : pePrem
                              : peError
                              : peMsgs );
        clear @@DsTim;
        if COWGRAI_getAuditoria( peBase
                               : peNctw
                               : @@DsTim );
          @@DsTim.w0fcot = %dec(%date : *iso);
          @@DsTim.w0hcot = %dec(%time);
          COWGRAI_setAuditoria( @@DsTim );
        endif;

       Data = CRLF                                     + CRLF
            + '<b>COWHOG1 (Response)</b>'              + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 20;
           if peCobe(i).riec = *blanks;
              leave;
           endif;
           Data = 'PECOBE(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;RIEC: ' + %trim(peCobe(i).riec) + CRLF
                + '&nbsp;XCOB: ' + %editc(peCobe(i).xcob:'X') + CRLF
                + '&nbsp;SAC1: ' +
                        %editw(peCobe(i).sac1:'  .   .   . 0 ,  ')+CRLF
                + '&nbsp;XPRI: ' +
                        %editw(peCobe(i).xpri:' 0 ,      ')+CRLF
                + '&nbsp;PRIM: ' +
                        %editw(peCobe(i).prim:'  .   .   . 0 ,  ')+CRLF
                + 'PECOBE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       Data = 'PESUMA: ' + %editw(peSuma:'  .   .   . 0 ,  ') + CRLF
            + 'PELNSP: ' + peLnsp                             + CRLF
            + 'PEPREM: ' + %editw(pePrem:'  .   .   . 0 ,  ') + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 200;
           if peBoni(i).xcob <= 0;
              leave;
           endif;
           Data = 'PEBONI(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;XCOB: ' + %editc(peBoni(i).xcob:'X') + CRLF
                + '&nbsp;CCBP: ' + %editc(peBoni(i).ccbp:'X') + CRLF
                + '&nbsp;DCBP: ' + peBoni(i).dcbp             + CRLF
                + '&nbsp;NIVE: ' + %editc(peBoni(i).nive:'X') + CRLF
                + '&nbsp;PBON: ' + %editw(peBoni(i).pbon:' 0 ,  ') + CRLF
                + '&nbsp;PREC: ' + %editw(peBoni(i).prec:' 0 ,  ') + CRLF
                + 'PEBONI' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       for i = 1 to 99;
           if peImpu(i).cobl = *blanks;
              leave;
           endif;
           Data = 'PEIMPU(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;COBL: ' + peImpu(i).cobl             + CRLF
                + '&nbsp;XREA: ' + %editw(peImpu(i).xrea:' 0 ,  ') + CRLF
                + '&nbsp;READ: ' +
                         %editw(peImpu(i).read:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;XOPR: ' + %editw(peImpu(i).xopr:' 0 ,  ') + CRLF
                + '&nbsp;COPR: ' +
                         %editw(peImpu(i).copr:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;XREF: ' + %editw(peImpu(i).xref:' 0 ,  ') + CRLF
                + '&nbsp;REFI: ' +
                         %editw(peImpu(i).refi:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;DERE: ' +
                         %editw(peImpu(i).dere:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;SERI: ' +
                         %editw(peImpu(i).seri:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;SEEM: ' +
                         %editw(peImpu(i).seem:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIMI: ' + %editw(peImpu(i).pimi:' 0 ,  ') + CRLF
                + '&nbsp;IMPI: ' +
                         %editw(peImpu(i).impi:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PSSO: ' + %editw(peImpu(i).psso:' 0 ,  ') + CRLF
                + '&nbsp;SERS: ' +
                         %editw(peImpu(i).sers:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PSSN: ' + %editw(peImpu(i).pssn:' 0 ,  ') + CRLF
                + '&nbsp;TSSN: ' +
                         %editw(peImpu(i).tssn:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIVI: ' + %editw(peImpu(i).pivi:' 0 ,  ') + CRLF
                + '&nbsp;IPR1: ' +
                         %editw(peImpu(i).ipr1:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIVN: ' + %editw(peImpu(i).pivn:' 0 ,  ') + CRLF
                + '&nbsp;IPR4: ' +
                         %editw(peImpu(i).ipr4:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIVR: ' + %editw(peImpu(i).pivr:' 0 ,  ') + CRLF
                + '&nbsp;IPR3: ' +
                         %editw(peImpu(i).ipr3:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR6: ' +
                         %editw(peImpu(i).ipr6:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR7: ' +
                         %editw(peImpu(i).ipr7:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR8: ' +
                         %editw(peImpu(i).ipr8:' .   .   .   . 0 ,  ')+CRLF
                + 'PEIMPU' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       Data = 'PEERRO: ' +  %trim(%char(peError))         + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_log( peBase : peNctw : Data );
       Data = separa;
       COWLOG_log( peBase : peNctw : Data );

       return;

      /end-free
