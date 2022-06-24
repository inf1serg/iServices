     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV7: Recupera la cabecera de la Cotización            *
      * --------------------------------------------------------- *
      * Sergio Fernandez                    *19-Ene-2017          *
      * ----------------------------------------------------------*
      * ATENCION: Este Servicio reemplaza a COWRTV1.              *
      *                                                           *
      * ********************************************************* *

     D COWRTV7         pr                  ExtPgm('COWRTV7')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCcot                            likeds(CabeceraCot_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWRTV7         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCcot                            likeds(CabeceraCot_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              1N
     D @repl           s          65535a
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      /free

       *inlr  = *on;

       clear peCcot;
       peErro = 0;
       clear peMsgs;

       Data = CRLF                                          + CRLF
            + '<b>COWRTV7 (Request)</b>'                    + CRLF
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
            + 'PENCTW: '  + %editc(peNctw:'X');
       COWLOG_log( peBase : peNctw : Data );

       rc = COWRTV_getCabeceraCotizacion( peBase
                                        : peNctw
                                        : peCcot );

       Data = '<br><br><b>COWRTV7 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       if rc = *off;
          %subst(@repl:1:7) = %trim(%char(peNctw));
          %subst(@repl:8:1) = %editc(peBase.peNivt:'X');
          %subst(@repl:9:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          peErro = -1;
       endif;

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
