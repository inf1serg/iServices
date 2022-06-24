     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRZDE: QUOM Versión 2                                       *
      *         Lista de denuncias por intermediario                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *01-Jun-2017            *
      * ************************************************************ *
     Fpahzde    if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehase01  if   e           k disk
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
     D rc              s              1n
     D fnot            s             10d
     D fsin            s             10d
     D c               s             10i 0
     D rc2             s             10i 0

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hzde          ds                  likerec(p1hzde:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)

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
       COWLOG_logcon('WSRZDE':peBase);

       k1hzde.deempr = empr;
       k1hzde.desucu = sucu;
       k1hzde.denivt = %dec( nivt : 1 : 0 );
       k1hzde.denivc = %dec( nivc : 5 : 0 );

       rc = REST_writeHeader();
       if rc = *off;
          return;
       endif;

       REST_writeEncoding();
       REST_writeXmlLine( 'denuncias' : '*BEG');

       c = 0;

       setll %kds(k1hzde:4) pahzde;
       reade %kds(k1hzde:4) pahzde;
       dow not %eof;

           c += 1;

           fnot = %date(defnot:*iso);
           fsin = %date(defsin:*iso);

           REST_writeXmlLine( 'denuncia' : '*BEG' );
            REST_writeXmlLine( 'rama'               : %trim(%char(derama)) );
            REST_writeXmlLine( 'poliza'             : %trim(%char(depoli)) );
            REST_writeXmlLine( 'asegurado'          : %trim(deased)        );
            REST_writeXmlLine( 'nroReclamo'         : %trim(%char(deidre)) );
            REST_writeXmlLine( 'fechaNotificacion'  : %trim(%char(fnot:*iso)));
            REST_writeXmlLine( 'estado'             : %trim(deetap)        );
            REST_writeXmlLine( 'fechaSiniestro'     : %trim(%char(fsin:*iso)));
           REST_writeXmlLine( 'denuncia ' : '*END' );

        reade %kds(k1hzde:4) pahzde;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'denuncias' : '*END' );

       close *all;

       return;

