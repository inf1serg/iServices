     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ************************************************************ *
      * COWRTV10: WebService                                         *
      *           Cotización AP  - Retorna _Informacion de una       *
      *           cotizacion guardada                                *
      *                                                              *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        *17-ABR-2017            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/cowrtv_h.rpgle'

     D COWRTV10        pr                  ExtPgm('COWRTV10')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0
     D   peArse                       2  0
     D   peNrpp                       3  0
     D   peVdes                       8  0
     D   peVhas                       8  0
     D   peXpro                       3  0
     D   peClie                            likeds(ClienteCot_t)
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWRTV10        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0
     D   peArse                       2  0
     D   peNrpp                       3  0
     D   peVdes                       8  0
     D   peVhas                       8  0
     D   peXpro                       3  0
     D   peClie                            likeds(ClienteCot_t)
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D WSLOG           pr                  ExtPgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

     D i               s             10i 0
     D o               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

     D PsDs           sds                  qualified
     D  JobName                      26a   overlay(PsDs:244)

      /free

       *inlr = *on;

       clear peImpu;
       clear pePrim;
       clear pePrem;
       clear peErro;
       clear peMsgs;

       separa = *all'-';

       Data = CRLF                                          + CRLF
            + '<b>COWRTV10 (Request)</b>'                   + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + 'PEBASE'                                      + CRLF
            + '&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
            + '&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
            + '&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + 'PEBASE'                                 + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       COWRTV_getComponentesVid3( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : peNrpp
                                : peVdes
                                : peVhas
                                : peXpro
                                : peClie
                                : peActi
                                : peActiC
                                : peImpu
                                : pePrim
                                : pePrem
                                : peErro
                                : peMsgs   );

       Data = CRLF
            + '<b>COWRTV10 (Response)</b>'              + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF;

       COWLOG_log( peBase : peNctw : Data );

       Data = 'PERAMA: '  + %editc(peRama:'X')         + CRLF
            + 'PEARSE: '  + %editc(peArse:'X')         + CRLF
            + 'PENRPP: '  + %editc(peNrpp:'X')         + CRLF
            + 'PEVDES: '  + %editc(peVdes:'X')         + CRLF
            + 'PEVHAS: '  + %editc(peVhas:'X')         + CRLF
            + 'PEXPRO: '  + %editc(peXpro:'X')         + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PECLIE' + CRLF
          + '&nbsp;ASEN: ' + %editc(peClie.Asen:'X')   + CRLF
          + '&nbsp;TIDO: ' + %editc(peClie.Tido:'X')   + CRLF
          + '&nbsp;NRDO: ' + %editc(peClie.Nrdo:'X')   + CRLF
          + '&nbsp;NOMB: ' + peClie.Nomb               + CRLF
          + '&nbsp;CUIT: ' + peClie.Cuit               + CRLF
          + '&nbsp;TIPE: ' + peClie.Tipe               + CRLF
          + '&nbsp;PROC: ' + peClie.Proc               + CRLF
          + '&nbsp;RPRO: ' + %editc(peClie.Rpro:'X')   + CRLF
          + '&nbsp;COPO: ' + %editc(peClie.Copo:'X')   + CRLF
          + '&nbsp;COPS: ' + %editc(peClie.Cops:'X')   + CRLF
          + '&nbsp;CIVA: ' + %editc(peClie.Civa:'X')   + CRLF
          + 'PECLIE'                                   + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to peActiC;
         Data = 'PEACTI(' + %trim(%char(i)) + ')' + CRLF
            + '&nbsp;ACTI: ' + %editc(peActi(i).Acti:'X') + CRLF
            + '&nbsp;CANT: ' + %editc(peActi(i).Cant:'X') + CRLF
            + '&nbsp;PACO: ' + %editc(peActi(i).Paco:'X') + CRLF
            + '&nbsp;SECU: ' + %editc(peActi(i).Secu:'X') + CRLF
            + '&nbsp;RAED: ' + %editc(peActi(i).Raed:'X') + CRLF
            + '&nbsp;PRIM: ' +
                 %editw(peActi(i).Prim:' .   .   .   . 0 ,  ') + CRLF
            + '&nbsp;PREM: ' +
                 %editw(peActi(i).Prem:' .   .   .   . 0 ,  ') + CRLF;
         COWLOG_log( peBase : peNctw : Data );

         for o = 1 to peActi(i).CobeC;
           Data = 'COBE(' + %trim(%char(o)) + ')' + CRLF
                + '&nbsp;RIEC: ' + %trim(peActi(i).cobe(o).riec) + CRLF
                + '&nbsp;XCOB: ' + %editc(peActi(i).Cobe(o).xcob:'X') + CRLF
                + '&nbsp;SAC1: ' +
                     %editw(peActi(i).Cobe(o).sac1:'  .   .   . 0 ,  ')+CRLF
                + '&nbsp;XPRI: ' +
                        %editw(peActi(i).Cobe(o).xpri:' 0 ,      ')+CRLF
                + '&nbsp;PRIM: ' +
                        %editw(peActi(i).Cobe(o).prim:'  .   .   . 0 ,  ')+CRLF
                + 'COBE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

        Data = 'IMPU' + CRLF
        + '&nbsp;COBL: ' +
                   %trim(peActi(i).impu.cobl)                     + CRLF
        + '&nbsp;XREA: ' +
                   %editw(peActi(i).impu.xrea:' 0 ,  ')           + CRLF
        + '&nbsp;READ: ' +
                   %editw(peActi(i).impu.read:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;XOPR: ' +
                   %editw(peActi(i).impu.xopr:' 0 ,  ')               + CRLF
        + '&nbsp;COPR: ' +
                   %editw(peActi(i).impu.copr:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;XREF: ' +
                   %editw(peActi(i).impu.xref:' 0 ,  ')               + CRLF
        + '&nbsp;REFI: ' +
                   %editw(peActi(i).impu.refi:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;DERE: ' +
                   %editw(peActi(i).impu.dere:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;SERI: ' +
                   %editw(peActi(i).impu.seri:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;SEEM: ' +
                   %editw(peActi(i).impu.seem:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIMI: ' +
                   %editw(peActi(i).impu.pimi:' 0 ,  ')               + CRLF
        + '&nbsp;IMPI: ' +
                   %editw(peActi(i).impu.impi:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PSSO: ' +
                   %editw(peActi(i).impu.psso:' 0 ,  ')               + CRLF
        + '&nbsp;SERS: ' +
                   %editw(peActi(i).impu.sers:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PSSN: ' +
                   %editw(peActi(i).impu.pssn:' 0 ,  ')               + CRLF
        + '&nbsp;TSSN: ' +
                   %editw(peActi(i).impu.tssn:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIVI: ' +
                   %editw(peActi(i).impu.pivi:' 0 ,  ')               + CRLF
        + '&nbsp;IPR1: ' +
                   %editw(peActi(i).impu.ipr1:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIVN: ' +
                   %editw(peActi(i).impu.pivn:' 0 ,  ')               + CRLF
        + '&nbsp;IPR4: ' +
                   %editw(peActi(i).impu.ipr4:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIVR: ' +
                   %editw(peActi(i).impu.pivr:' 0 ,  ')               + CRLF
        + '&nbsp;IPR3: ' +
                   %editw(peActi(i).impu.ipr3:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;IPR6: ' +
                   %editw(peActi(i).impu.ipr6:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;IPR7: ' +
                   %editw(peActi(i).impu.ipr7:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;IPR8: ' +
                   %editw(peActi(i).impu.ipr8:' .   .   .   . 0 ,  ') + CRLF
        + 'IMPU'                                                      + CRLF
        + 'PEACTI'                                                    + CRLF;
         COWLOG_log( peBase : peNctw : Data );

       endfor;

       Data = 'PEPRIM: ' + %editw(pePrim:' .   .   .   . 0 ,  ') + CRLF
            + 'PEPREM: ' + %editw(pePrem:' .   .   .   . 0 ,  ') + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PEIMPU' + CRLF
        + '&nbsp;COBL: ' + %trim(peimpu.cobl)                     + CRLF
        + '&nbsp;XREA: ' + %editw(peimpu.xrea:' 0 ,  ')           + CRLF
        + '&nbsp;READ: ' + %editw(peimpu.read:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;XOPR: ' + %editw(peimpu.xopr:' 0 ,  ')               + CRLF
        + '&nbsp;COPR: ' + %editw(peimpu.copr:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;XREF: ' + %editw(peimpu.xref:' 0 ,  ')               + CRLF
        + '&nbsp;REFI: ' + %editw(peimpu.refi:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;DERE: ' + %editw(peimpu.dere:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;SERI: ' + %editw(peimpu.seri:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;SEEM: ' + %editw(peimpu.seem:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIMI: ' + %editw(peimpu.pimi:' 0 ,  ')               + CRLF
        + '&nbsp;IMPI: ' + %editw(peimpu.impi:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PSSO: ' + %editw(peimpu.psso:' 0 ,  ')               + CRLF
        + '&nbsp;SERS: ' + %editw(peimpu.sers:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PSSN: ' + %editw(peimpu.pssn:' 0 ,  ')               + CRLF
        + '&nbsp;TSSN: ' + %editw(peimpu.tssn:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIVI: ' + %editw(peimpu.pivi:' 0 ,  ')               + CRLF
        + '&nbsp;IPR1: ' + %editw(peimpu.ipr1:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIVN: ' + %editw(peimpu.pivn:' 0 ,  ')               + CRLF
        + '&nbsp;IPR4: ' + %editw(peimpu.ipr4:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;PIVR: ' + %editw(peimpu.pivr:' 0 ,  ')               + CRLF
        + '&nbsp;IPR3: ' + %editw(peimpu.ipr3:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;IPR6: ' + %editw(peimpu.ipr6:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;IPR7: ' + %editw(peimpu.ipr7:' .   .   .   . 0 ,  ') + CRLF
        + '&nbsp;IPR8: ' + %editw(peimpu.ipr8:' .   .   .   . 0 ,  ') + CRLF
        + 'PEIMPU' + CRLF;
       COWLOG_log( peBase : peNctw : Data );

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
