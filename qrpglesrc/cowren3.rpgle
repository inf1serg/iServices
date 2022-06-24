     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************* *
      * COWREN3: Realiza Llamadas a COWVEH1/2                         *
      * ************************************************************* *
      * Alvarez Fernando                     24-Ago-2016              *
      * ************************************************************* *
      * Modificaciones:                                               *
      * SFA 01/09/16 - Recompilo por cambios en dsVeh_t               *
      * SGF 07/09/16 - Recompilo por cambios en dsVeh_t               *
      * ************************************************************* *
     D  COWREN3        pr                  ExtPgm('COWREN3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D  COWREN3        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /copy './qcpybooks/cowren_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D fecha           s               d
     D hora            s               t
     D x               s             10i 0

        *inlr = *on;

        peErro = *Zeros;

        fecha  = %date();
        hora   = %time();
        separa = *all'-';

        Data = '<br><br>'
             + '<b>COWREN3 (Request)</b>'                    + CRLF
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
             + 'PENCTW: '       + %editc(peNctw:'X');

        COWLOG_log( peBase : peNctw : Data );

        callp COWREN_setLlamadas( peBase
                                : peNctw
                                : peDsVh
                                : peDsVhC );

        if COWREN_chkErrores( peDsVh : peDsVhC );

          peErro = -1;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COWXXX'
                       :  peMsgs );

        endif;

        Data = '<br><br>'
             + '<b>COWREN3 (Response)</b>'                + CRLF
             + 'Fecha/Hora: '
             + %trim(%char(%date():*iso))                 + ' '
             + %trim(%char(%time():*iso))                 + CRLF
             + 'PENCTW: '         + %editc(peNctw:'X')    + CRLF
             + 'PEERRO: '         + %trim(%char(peErro))  + CRLF
             + 'PEMSGS: ' + %trim( %editw( x : '        0 '))    + CRLF
             + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)        + CRLF
             + '&nbsp;PEMSID: ' + peMsgs.peMsid               + CRLF
             + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)        + CRLF
             + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)        + CRLF
             + 'PEMSGS'                                          + CRLF     ;
         COWLOG_log( peBase : peNctw : Data );

         return;
