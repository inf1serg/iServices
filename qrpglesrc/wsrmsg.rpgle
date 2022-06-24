     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRMSG: QUOM Versión 2                                       *
      *         Mensajes de intermediario.                           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *19-Jun-2017            *
      * ************************************************************ *
     Fgntmsg01  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehni201  if   e           k disk    prefix(n2:2)

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D fmsg            s             10a
     D stat            s              2a
     D rc              s              1n
     D c               s             10i 0
     D rc2             s             10i 0

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peSini          ds                  likeds(pahstro_t)
     D peErro          s             10i 0
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1hmsg          ds                  likerec(g1tmsg:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRMSG':peBase);

       k1hmsg.sgempr = empr;
       k1hmsg.sgsucu = sucu;
       k1hmsg.sgnivt = %dec( nit1 : 1 : 0 );
       k1hmsg.sgnivc = %dec( niv1 : 5 : 0 );

       REST_writeHeader();
       rc = REST_writeEncoding();
       rc = REST_writeXmlLine( 'mensajes' : '*BEG');
       c = 0;

       setll %kds(k1hmsg:4) gntmsg01;
       reade %kds(k1hmsg:4) gntmsg01;
       dow not %eof;

           c += 1;

           if sgread = '1';
              stat = 'L';
            else;
              stat = 'NL';
           endif;

           fmsg = %char(sgfmsg:*iso);

           REST_writeXmlLine( 'mensaje' : '*BEG' );
            REST_writeXmlLine( 'idMensaje'          : %trim(sgmsid) );
            REST_writeXmlLine( 'bodyMensaje'        : %trim(sgbody) );
            REST_writeXmlLine( 'fechaMensaje'       : %trim(fmsg) );
            REST_writeXmlLine( 'importancia'        : %trim(%char(sgimpo)));
            REST_writeXmlLine( 'status'             : stat);
           REST_writeXmlLine( 'mensaje' : '*END' );

        reade %kds(k1hmsg:4) gntmsg01;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'mensajes' : '*END' );

       close *all;

       return;

      /end-free
