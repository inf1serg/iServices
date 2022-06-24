     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV4: Retorna Condiciones Comerciales                  *
      * --------------------------------------------------------- *
      * Alvarez Fernando                     07-Ene-2016          *
      * ********************************************************* *
     Fset6118   if   e           k disk


     D COWRTV4         pr                  ExtPgm('COWRTV4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peCond                            likeds(condCome2_t) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWRTV4         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peCond                            likeds(condCome2_t) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')
     D peCon2          ds                  likeds(condComer_t) dim(99)
     D k1t6118         ds                  likerec(s1t6118:*key)

      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

       *inlr  = *on;

       peErro = *Zeros;
       clear peMsgs;
       clear peCon2;
       clear peCond;

       Data = CRLF                                            + CRLF
            + '<b>COWRTV4 '
            + 'Obtener Condiciones Comerciales (Request)</b>' + CRLF
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
            + 'PERAMA: '  + %editc(peRama:'X');
            COWLOG_log( peBase : peNctw : Data );

       COWRTV_getCondComerciales ( peBase
                                 : peNctw
                                 : peCon2
                                 : peErro
                                 : peMsgs );

       eval-corr peCond = peCon2;

       for i = 1 to 99;
           if peCond(i).rama <> 0;
              k1t6118.t@empr = peBase.peEmpr;
              k1t6118.t@sucu = peBase.peSucu;
              k1t6118.t@nivt = peBase.peNivt;
              k1t6118.t@nivc = peBase.peNivc;
              k1t6118.t@rama = peCond(i).rama;
              chain %kds(k1t6118) set6118;
              if %found;
                 peCond(i).xre1 = t@xrea;
                 peCond(i).xop1 = t@pdn1;
               else;
                 peCond(i).xre1 = 0;
                 peCond(i).xop1 = 0;
              endif;
           endif;
       endfor;


       Data =
              '<br><br><b>COWRTV4 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso));
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 99;
           if peCond(i).rama = *zeros;
              leave;
           endif;
           Data =                                               CRLF
                + 'PECOND(' + %trim(%char(i)) + ')'           + CRLF
                + '&nbsp;RAMA: ' + %editc(pecond(i).rama:'X') + CRLF
                + '&nbsp;ARSE: ' + %editc(pecond(i).arse:'X') + CRLF
                + '&nbsp;XREA: ' + %editw(pecond(i).xrea:' 0 ,  ')
                                                              + CRLF
                + '&nbsp;READ: ' + %editc(pecond(i).read:'K') + CRLF
                + '&nbsp;XOPR: ' + %editw(pecond(i).xopr:' 0 ,  ')
                                                              + CRLF
                + '&nbsp;COPR: ' + %editc(pecond(i).copr:'K') + CRLF
                + '&nbsp;XRE1: ' + %editw(pecond(i).xre1:' 0 ,  ')
                                                              + CRLF
                + '&nbsp;XOP1: ' + %editw(pecond(i).xop1:' 0 ,  ')
                + 'PECOND';
         COWLOG_log( peBase : peNctw : Data );
       endfor;

       Data =                                               CRLF
            + 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
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
