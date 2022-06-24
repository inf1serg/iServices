     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV12: Recupera los Bienes asegurados(Hogar) V2        *
      * --------------------------------------------------------- *
      * Jennifer Segovia                     14-Jun-2018          *
      * ********************************************************* *

     D COWRTV12        pr                  ExtPgm('COWRTV12')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0
     D  peXrea                        5  2
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWRTV12        pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0
     D  peXrea                        5  2
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D i               s             10i 0
     D x               s             10i 0
     D u               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      /copy './qcpybooks/cowrtv_h.rpgle'

      /free

       *inlr = *on;

       peCfpg  = 0;
       pePocoC = 0;
       peXrea  = 0;
       peSuma  = 0;
       pePrim  = 0;
       pePrem  = 0;
       peErro  = 0;

       clear peClie;
       clear pePoco;
       clear peImpu;
       clear peCond;
       clear peCon1;
       clear peMsgs;

       Data = CRLF                                          + CRLF
            + '<b>COWRTV12 (Request)</b>'                   + CRLF
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
            + 'PENCTW: '  + %editc(peNctw:'X')              + CRLF
            + 'PERAMA: '  + %editc(peRama:'X')              + CRLF
            + 'PEARSE: '  + %editc(peArse:'X');
       COWLOG_log( peBase : peNctw : Data );

       COWRTV_getComponentesHogar( peBase
                                 : peNctw
                                 : peRama
                                 : peArse
                                 : peCfpg
                                 : peClie
                                 : pePoco
                                 : pePocoC
                                 : peXrea
                                 : peImpu
                                 : peSuma
                                 : pePrim
                                 : pePrem
                                 : peCond
                                 : peCon1
                                 : peErro
                                 : peMsgs  );

       Data = '<br><br><b>COWRTV12 (Response)</b>'     + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PECLIE' + CRLF
          + '&nbsp;ASEN: ' + %editc(peClie.Asen:'X') + CRLF
          + '&nbsp;TIDO: ' + %editc(peClie.Tido:'X') + CRLF
          + '&nbsp;NRDO: ' + %editc(peClie.Nrdo:'X') + CRLF
          + '&nbsp;NOMB: ' + %trim(peClie.Nomb) + CRLF
          + '&nbsp;CUIT: ' + %trim(peClie.Cuit) + CRLF
          + '&nbsp;TIPE: ' + %trim(peClie.Tipe) + CRLF
          + '&nbsp;PROC: ' + %trim(peClie.Proc) + CRLF
          + '&nbsp;RPRO: ' + %editc(peClie.Rpro:'X') + CRLF
          + '&nbsp;COPO: ' + %editc(peClie.Copo:'X') + CRLF
          + '&nbsp;COPS: ' + %editc(peClie.Cops:'X') + CRLF
          + '&nbsp;CIVA: ' + %editc(peClie.Civa:'X') + CRLF
          + 'PECLIE' + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 10;
         if pePoco(i).Poco <= 0;
           leave;
         endif;
         Data = 'PEPOCO(' + %trim(%char(i)) + ')' + CRLF
              + '&nbsp;POCO: ' + %editc(pePoco(i).Poco:'X') + CRLF
              + '&nbsp;XPRO: ' + %editc(pePoco(i).Xpro:'X') + CRLF
              + '&nbsp;TVIV: ' + %editc(pePoco(i).Tviv:'X') + CRLF
              + '&nbsp;COPO: ' + %editc(pePoco(i).Copo:'X') + CRLF
              + '&nbsp;COPS: ' + %editc(pePoco(i).Cops:'X') + CRLF
              + '&nbsp;SCTA: ' + %editc(pePoco(i).Scta:'X') + CRLF
              + '&nbsp;BURE: ' + %editc(pePoco(i).Bure:'X') + CRLF
              + '&nbsp;CARAC:' + %editc(pePoco(i).CaraC:'X') + CRLF;
         COWLOG_log( peBase : peNctw : Data );

         for x = 1 to 50;
           if pePoco(i).Cara(x).Ccba <= 0;
             leave;
           endif;
           Data = 'CARA(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;CCBA: ' + %editc(pePoco(i).Cara(x).Ccba:'X') + CRLF
                + '&nbsp;DCBA: ' + %trim(pePoco(i).Cara(x).Dcba) + CRLF
                + '&nbsp;MA01: ' + %trim(pePoco(i).Cara(x).Ma01) + CRLF
                + '&nbsp;MA02: ' + %trim(pePoco(i).Cara(x).Ma02) + CRLF
                + '&nbsp;MA03: ' + %trim(pePoco(i).Cara(x).Ma03) + CRLF
                + '&nbsp;CBAE: ' + %trim(pePoco(i).Cara(x).Cbae) + CRLF
                + 'CARA' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

         for x = 1 to 20;
           if pePoco(i).Cobe(x).Riec = *blanks;
             leave;
           endif;
           Data = 'COBE(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;RIEC: ' + %trim(pePoco(i).Cobe(x).Riec) + CRLF
                + '&nbsp;XCOB: ' + %editc(pePoco(i).Cobe(x).Xcob:'X') + CRLF
                + '&nbsp;SAC1: ' +
                      %editw(pePoco(i).Cobe(X).Sac1:'  .   .   . 0 ,  ') + CRLF
                + '&nbsp;XPRI: ' +
                      %editw(pePoco(i).Cobe(X).Xpri:' 0 ,      ') + CRLF
                + '&nbsp;PRIM: ' +
                      %editw(pePoco(i).Cobe(X).Prim:'  .   .   . 0 ,  ') + CRLF
                + 'COBE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

         Data = 'SUMA: ' + %editw(pePoco(i).Suma:'  .   .   . 0 ,  ') + CRLF
              + 'INSP: ' + pePoco(i).Insp                             + CRLF
              + 'PREM: ' + %editw(pePoco(i).Prem:'  .   .   . 0 ,  ') + CRLF
              + 'PSUA: ' + %editc(pePoco(i).Psua:'X') + CRLF;
         COWLOG_log( peBase : peNctw : Data );

       endfor;

         for x = 1 to 99;
           if peImpu(x).rama = *zeros;
              leave;
           endif;
           Data = 'PEIMPU(' + %trim(%char(x)) + ')' + CRLF
                + '&nbsp;RAMA: ' + %editc(peImpu(x).rama:'X')      + CRLF
                + '&nbsp;ARSE: ' + %editc(peImpu(x).arse:'X')      + CRLF
                + '&nbsp;PRIM: ' +
                     %editw(peImpu(x).prim:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;XREF: ' + %editw(peImpu(x).xref:' 0 ,  ') + CRLF
                + '&nbsp;REFI: ' +
                     %editw(peImpu(x).refi:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;DERE: ' +
                     %editw(peImpu(x).dere:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;SUBT: ' +
                     %editw(peImpu(x).subt:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;SERI: ' +
                     %editw(peImpu(x).seri:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;SEEM: ' +
                     %editw(peImpu(x).seem:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;PIMI: ' + %editw(peImpu(x).pimi:' 0 ,  ') + CRLF
                + '&nbsp;IMPI: ' +
                     %editw(peImpu(x).impi:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;PSSO: ' + %editw(peImpu(x).psso:' 0 ,  ') + CRLF
                + '&nbsp;SERS: ' +
                     %editw(peImpu(x).sers:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;PSSN: ' + %editw(peImpu(x).pssn:' 0 ,  ') + CRLF
                + '&nbsp;TSSN: ' +
                     %editw(peImpu(x).tssn:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;PIVI: ' + %editw(peImpu(x).pivi:' 0 ,  ') + CRLF
                + '&nbsp;IPR1: ' +
                     %editw(peImpu(x).ipr1:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;PIVN: ' + %editw(peImpu(x).pivn:' 0 ,  ') + CRLF
                + '&nbsp;IPR4: ' +
                     %editw(peImpu(x).ipr4:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;PIVR: ' + %editw(peImpu(x).pivr:' 0 ,  ') + CRLF
                + '&nbsp;IPR3: ' +
                     %editw(peImpu(x).ipr3:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;IPR5: ' +
                     %editw(peImpu(x).ipr5:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;IPR6: ' +
                     %editw(peImpu(x).ipr6:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;IPR7: ' +
                     %editw(peImpu(x).ipr7:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;IPR8: ' +
                     %editw(peImpu(x).ipr8:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;IPR9: ' +
                     %editw(peImpu(x).ipr9:' .   .   .   . 0 ,  ') + CRLF
                + '&nbsp;PREM: ' +
                     %editw(peImpu(x).prem:' .   .   .   . 0 ,  ') + CRLF
                + 'PEIMPU' + CRLF;
           COWLOG_log( peBase : peNctw : Data );

         endfor;

       Data = 'PESUMA: ' + %editw(peSuma:'  .   .   . 0 ,  ') + CRLF
            + 'PEPRIM: ' + %editw(pePrim:' .   .   .   . 0 ,  ') + CRLF
            + 'PEPREM: ' + %editw(pePrem:' .   .   .   . 0 ,  ') + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PECON1(' + %trim(%char(x)) + ')'  + CRLF
            + 'RAMA: ' + %editc(peCon1.Rama:'X') + CRLF
            + 'XREA: ' + %editw(peCon1.Xrea:' 0 ,  ') + CRLF
            + 'PECON1' + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PECOND(' + %trim(%char(x)) + ')'  + CRLF
            + 'RAMA: ' + %editc(peCond.Rama:'X') + CRLF
            + 'ARSE: ' + %editc(peCond.Arse:'X') + CRLF
            + 'XREA: ' + %editw(peCond.Xrea:' 0 ,  ') + CRLF
            + 'READ: ' + %editw(peCond.Read:' .   .   .   . 0 ,  ') + CRLF
            + 'XOPR: ' + %editw(peCond.Xopr:' 0 ,  ') + CRLF
            + 'COPR: ' + %editw(peCond.Copr:' .   .   .   . 0 ,  ') + CRLF
            + 'XRE1: ' + %editw(peCond.Xre1:' 0 ,  ') + CRLF
            + 'XOP1: ' + %editw(peCond.Xop1:' 0 ,  ') + CRLF
            + 'PECOND' + CRLF;
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

       COWRTV_end();

       return;

      /end-free

