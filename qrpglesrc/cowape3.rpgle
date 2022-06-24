     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWAPE3: WebService                                          *
      *          Cotización AP  - wrapper para _listaComPorActividad *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *31-Ene-2017        *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy quom.pgmr/qcpybooks,cowape_h
      /copy './qcpybooks/cowape_h.rpgle'

     D COWAPE3         pr                  ExtPgm('COWAPE3')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peActi                        5  0 const
     D  peSecu                        2  0 const
     D  peLcom                             likeds(compActi_t) dim(999999)
     D  peLcomC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWAPE3         pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peActi                        5  0 const
     D  peSecu                        2  0 const
     D  peLcom                             likeds(compActi_t) dim(999999)
     D  peLcomC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       clear peLcom;
       clear peMsgs;
       peErro  = 0;
       peLcomC = 0;

       separa = *all'-';

       Data = CRLF                                          + CRLF
            + '<b>COWAPE3 (Request)</b>'                    + CRLF
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
            + 'PERAMA: '  + %editc(peRama:'X')              + CRLF
            + 'PEARSE: '  + %editc(peArse:'X')              + CRLF
            + 'PEACTI: '  + %editc(peActi:'X')              + CRLF
            + 'PESECU: '  + %editc(peSecu:'X')              + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       COWAPE_listaComPorActi( peBase
                             : peNctw
                             : peRama
                             : peArse
                             : peActi
                             : peSecu
                             : peLcom
                             : peLcomC
                             : peErro
                             : peMsgs );

       Data = CRLF                                            + CRLF
            + '<b>COWAPE3 (Response)</b>'                     + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                      + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 999999;
           if peLcom(i).poco = *zeros;
              leave;
           endif;
           Data = 'PELCOM(' + %trim(%char(i)) + ')'           + CRLF
                + '&nbsp;POCO: ' + %editc(peLcom(i).poco:'X') + CRLF
                + '&nbsp;PACO: ' + %editc(peLcom(i).paco:'X') + CRLF
                + 'PELCOM'                                    + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       Data = 'PEERRO: ' +  %trim(%char(peErro))              + CRLF
            + 'PEMSGS'                                        + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)         + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid                + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)         + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)         + CRLF
            + 'PEMSGS'                                        + CRLF;
       COWLOG_log( peBase : peNctw : Data );
       Data = separa;
       COWLOG_log( peBase : peNctw : Data );

       return;

      /end-free
