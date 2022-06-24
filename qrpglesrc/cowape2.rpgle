     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWAPE2: WebService                                          *
      *          Cotización AP  - wrapper para _RecotizarWeb()       *
      *                                                              *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                       *21-Ene-2016        *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/cowape_h.rpgle'

     D COWAPE2         pr                  ExtPgm('COWAPE2')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWAPE2         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>COWAPE2 (Request)</b>'               + CRLF
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
            + 'PEPACO: '  + %editc(pePaco:'X')         + CRLF
            + 'PEACTI: '  + %editc(peActi:'X')         + CRLF
            + 'PESECU: '  + %editc(peSecu:'X')         + CRLF
            + 'PECANT: '  + %editc(peCant:'X')         + CRLF
            + 'PETIPE: '  + peTipe                     + CRLF
            + 'PECIVA: '  + %editc(peCiva:'X')         + CRLF
            + 'PENRPP: '  + %editc(peNrpp:'X')         + CRLF
            + 'PEVDES: '  + %editc(peVdes:'X')         + CRLF
            + 'PEVHAS: '  + %editc(peVhas:'X')         + CRLF
            + 'PEXPRO: '  + %editc(peXpro:'X')         + CRLF
            + 'PECOPO: '  + %editc(peCopo:'X')         + CRLF
            + 'PECOPS: '  + %editc(peCops:'X')         + CRLF
            + 'PERAED: '  + %editc(peRaed:'X')         + CRLF;
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
                + 'PECOBE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       callp COWAPE_RecotizarWeb( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : pePaco
                                : peActi
                                : peSecu
                                : peCant
                                : peTipe
                                : peCiva
                                : peNrpp
                                : peVdes
                                : peVhas
                                : peXpro
                                : peCopo
                                : peCops
                                : peRaed
                                : peCobe
                                : peImpu
                                : pePrim
                                : pePrem
                                : peErro
                                : peMsgs );

       Data = CRLF                                     + CRLF
            + '<b>COWAPE2 (Response)</b>'              + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEPRIM: ' + %editw(pePrim:' .   .   .   . 0 ,  ') + CRLF
            + 'PEPREM: ' + %editw(pePrem:' .   .   .   . 0 ,  ') + CRLF;
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

       for i = 1 to 99;
        if peimpu(i).cobl = *blanks;
          leave;
        endif;
        Data = 'PEIMPU(' + %trim(%char(i)) + ')' + CRLF
        + '&nbsp;cobl: ' + %trim(peimpu(i).cobl)                     + CRLF
        + '&nbsp;xrea: ' + %editw(peimpu(i).xrea:' 0 ,  ')           + CRLF
        + '&nbsp;read: ' + %editw(peimpu(i).read:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;xopr: ' + %editw(peimpu(i).xopr:' 0 ,  ')               + CRLF
        + '&nbsp;copr: ' + %editw(peimpu(i).copr:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;xref: ' + %editw(peimpu(i).xref:' 0 ,  ')               + CRLF
        + '&nbsp;refi: ' + %editw(peimpu(i).refi:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;dere: ' + %editw(peimpu(i).dere:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;seri: ' + %editw(peimpu(i).seri:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;seem: ' + %editw(peimpu(i).seem:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;pimi: ' + %editw(peimpu(i).pimi:' 0 ,  ')               + CRLF
        + '&nbsp;impi: ' + %editw(peimpu(i).impi:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;psso: ' + %editw(peimpu(i).psso:' 0 ,  ')               + CRLF
        + '&nbsp;sers: ' + %editw(peimpu(i).sers:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;pssn: ' + %editw(peimpu(i).pssn:' 0 ,  ')               + CRLF
        + '&nbsp;tssn: ' + %editw(peimpu(i).tssn:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;pivi: ' + %editw(peimpu(i).pivi:' 0 ,  ')               + CRLF
        + '&nbsp;ipr1: ' + %editw(peimpu(i).ipr1:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;pivn: ' + %editw(peimpu(i).pivn:' 0 ,  ')               + CRLF
        + '&nbsp;ipr4: ' + %editw(peimpu(i).ipr4:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;pivr: ' + %editw(peimpu(i).pivr:' 0 ,  ')               + CRLF
        + '&nbsp;ipr3: ' + %editw(peimpu(i).ipr3:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;ipr6: ' + %editw(peimpu(i).ipr6:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;ipr7: ' + %editw(peimpu(i).ipr7:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;ipr8: ' + %editw(peimpu(i).ipr8:' .   .   .   . 0 ,  ') + CRLF
        + 'PEIMPU' + CRLF;
         COWLOG_log( peBase : peNctw : Data );
       EndFor;

       Data = 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
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
