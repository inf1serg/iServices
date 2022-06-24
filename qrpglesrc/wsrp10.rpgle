     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRP10: QUOM Versión 2                                       *
      *         Preliquidación - Enviar                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *21-Jul-2017            *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D PLQWEB31        pr                  ExtPgm('PLQWEB31')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D nrpl            s              7a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D x               s             10i 0
     D peNrpl          s              7  0

     D CRLF            c                   x'0d25'

     D k1hni2          ds                  likerec(s1hni201:*key)

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

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
       nrpl = REST_getNextPart(url);

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

       monitor;
          peNrpl = %dec(nrpl:7:0);
        on-error;
          peNrpl = 0;
       endmon;

       clear peBase;
       clear peMsgs;
       peErro = 0;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       PLQWEB31( peBase
               : %dec(nrpl:7:0)
               : peErro
               : peMsgs );

       if peErro = -1;
          @@repl = nrpl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PQW0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'PQW0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'preliquidacion' : 'OK' );

       REST_end();
       close *all;

       return;

