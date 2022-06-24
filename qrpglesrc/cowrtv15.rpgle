     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV15: Recupera los bienes asegurados(Sepelio)         *
      * ********************************************************* *
      *                                                           *
      * ********************************************************* *

     D COWRTV15        pr                  ExtPgm('COWRTV15')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNrpp                        3  0
     D  peVdes                        8  0
     D  peXpro                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  peCsep                             likeds(CompSepelio_t)
     D  peImpu                             likeds(Impuesto)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWRTV15        pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNrpp                        3  0
     D  peVdes                        8  0
     D  peXpro                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  peCsep                             likeds(CompSepelio_t)
     D  peImpu                             likeds(Impuesto)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D x               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      /copy './qcpybooks/cowrtv_h.rpgle'

       *inlr  = *on;

       peNrpp = 0;
       peVdes = 0;
       peXpro = 0;
       peErro = 0;
       pePrim = 0;
       pePrem = 0;
       peSuma = 0;
       clear peMsgs;
       clear peClie;
       clear peCsep;
       clear peImpu;

       Data = CRLF                                          + CRLF
            + '<b>COWRTV15 - Recupera Bienes Sepelio(Request)</b>' + CRLF
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
            + 'PEBASE'                                      + CRLF
            + 'PERAMA:'   + %editc(peRama:'X')              + CRLF
            + 'PEARAE:'   + %editc(peArse:'X')              + CRLF
            + 'PENCTW: '  + %editc(peNctw:'X');
       COWLOG_log( peBase : peNctw : Data );

       COWRTV_getComponentesSepelio( peBase
                                   : peNctw
                                   : peRama
                                   : peArse
                                   : peNrpp
                                   : peVdes
                                   : peXpro
                                   : peClie
                                   : peCsep
                                   : peImpu
                                   : peSuma
                                   : pePrim
                                   : pePrem
                                   : peErro
                                   : peMsgs );

       Data = CRLF + CRLF +
          '<b>COWRTV15 - Recupera Bienes Sepelio (Response)</b>' + CRLF
          + 'Fecha/Hora: '
          + %trim(%char(%date():*iso)) + ' '
          + %trim(%char(%time():*iso)) + CRLF
          + 'PENRPP:' + %editc(peNrpp:'X') + CRLF
          + 'PEVDES:' + %editc(peVdes:'X') + CRLF
          + 'PEXPRO:' + %editc(peXpro:'X');
       COWLOG_log( peBase : peNctw : Data );

       Data = CRLF
        + 'PECLIE'   + CRLF
        + '&nbsp;ASEN:' + %editc(peClie.asen:'X') + CRLF
        + '&nbsp;CIVA:' + %editc(peClie.civa:'X') + CRLF
        + '&nbsp;COPO:' + %editc(peClie.copo:'X') + CRLF
        + '&nbsp;COPS:' + %editc(peClie.cops:'X') + CRLF
        + '&nbsp;CUIT:' + %trim (peClie.cuit)     + CRLF
        + '&nbsp;NRDO:' + %editc(peClie.nrdo:'X') + CRLF
        + '&nbsp;NOMB:' + %trim(peClie.nomb)      + CRLF
        + '&nbsp;PROC:' + %trim(peClie.proc)      + CRLF
        + '&nbsp;RPRO:' + %editc(peClie.rpro:'X') + CRLF
        + '&nbsp;TIPE:' + %trim(peClie.tipe)      + CRLF
        + '&nbsp;TIDO:' + %editc(peClie.tido:'X') + CRLF
        + 'PECLIE';
       COWLOG_log( peBase : peNctw : Data );

       Data = CRLF
        + 'PECSEP'   + CRLF
        + '&nbsp;CANT:' + %editc(peCsep.cant:'X') + CRLF
        + '&nbsp;PACO:' + %editc(peCsep.paco:'X') + CRLF
        + '&nbsp;RAED:' + %editc(peCsep.raed:'X') + CRLF
        + '&nbsp;PRIM:' + %editc(peCsep.prim:'X') + CRLF
        + '&nbsp;PREM:' + %editc(peCsep.prem:'X') + CRLF
        + '&nbsp;COBEC:'+ %editc(peCsep.cobec:'X');
       COWLOG_log( peBase : peNctw : Data );

       for x = 1 to peCsep.cobec;
           if peCsep.cobe(x).riec = *blanks;
              leave;
           endif;
           Data = CRLF
            + 'PECOBE(' + %char(x) + ')' + CRLF
            + '&nbsp;RIEC:' + peCsep.cobe(x).riec  + CRLF
            + '&nbsp;XCOB:' + %editc(peCsep.cobe(x).xcob:'X')+ CRLF
            + '&nbsp;XPRI:' + %editc(peCsep.cobe(x).xpri:'X')+ CRLF
            + '&nbsp;SAC1:' + %editc(peCsep.cobe(x).sac1:'X')+ CRLF
            + '&nbsp;PRIM:' + %editc(peCsep.cobe(x).prim:'X')+ CRLF
            + 'PECOBE';
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       Data = CRLF
        + 'PEIMPU' + CRLF
        + '&nbsp;COBL:' + %trim(peImpu.cobl)   + CRLF
        + '&nbsp;XREA:' + %editc(peImpu.xrea:'X') + CRLF
        + '&nbsp;READ:' + %editc(peImpu.read:'X') + CRLF
        + '&nbsp;XOPR:' + %editc(peImpu.xopr:'X') + CRLF
        + '&nbsp;COPR:' + %editc(peImpu.copr:'X') + CRLF
        + '&nbsp;XREF:' + %editc(peImpu.xref:'X') + CRLF
        + '&nbsp;REFI:' + %editc(peImpu.refi:'X') + CRLF
        + '&nbsp;DERE:' + %editc(peImpu.dere:'X') + CRLF
        + '&nbsp;SERI:' + %editc(peImpu.seri:'X') + CRLF
        + '&nbsp;SEEM:' + %editc(peImpu.seem:'X') + CRLF
        + '&nbsp;PIMI:' + %editc(peImpu.pimi:'X') + CRLF
        + '&nbsp;IMPI:' + %editc(peImpu.impi:'X') + CRLF
        + '&nbsp;PSSO:' + %editc(peImpu.psso:'X') + CRLF
        + '&nbsp;SERS:' + %editc(peImpu.sers:'X') + CRLF
        + '&nbsp;PSSN:' + %editc(peImpu.pssn:'X') + CRLF
        + '&nbsp;TSSN:' + %editc(peImpu.tssn:'X') + CRLF
        + '&nbsp;PIVI:' + %editc(peImpu.pivi:'X') + CRLF
        + '&nbsp;IPR1:' + %editc(peImpu.ipr1:'X') + CRLF
        + '&nbsp;PIVN:' + %editc(peImpu.pivn:'X') + CRLF
        + '&nbsp;IPR4:' + %editc(peImpu.ipr4:'X') + CRLF
        + '&nbsp;PIVR:' + %editc(peImpu.pivr:'X') + CRLF
        + '&nbsp;IPR3:' + %editc(peImpu.ipr3:'X') + CRLF
        + '&nbsp;IPR6:' + %editc(peImpu.ipr6:'X') + CRLF
        + '&nbsp;IPR7:' + %editc(peImpu.ipr7:'X') + CRLF
        + '&nbsp;IPR8:' + %editc(peImpu.ipr8:'X') + CRLF
        + 'PEIMPU';
       COWLOG_log( peBase : peNctw : Data );

       Data = CRLF
        + 'PESUMA' + %editc(peSuma:'X') + CRLF
        + 'PEPRIM' + %editc(pePrim:'X') + CRLF
        + 'PEPREM' + %editc(pePrem:'X');
       COWLOG_log( peBase : peNctw : Data );

       COWRTV_end();
       return;
