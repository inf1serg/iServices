        // -------------------------------------------------------- //
        // WSRRIS: QUOM Version 2.                                  //
        //         Lista recibo de indemnizacion.                   //
        // -------------------------------------------------------- //
        // Sergio Fernandez                     *30-Jul-2021        //
        // -------------------------------------------------------- //
        ctl-opt
               actgrp(*new)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f cnhric usage(*input) keyed;
        dcl-f cnhrid usage(*input) keyed;

      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

        dcl-ds k1hrid likerec(c1hrid:*key);
        dcl-ds k1hric likerec(c1hric:*key);

        dcl-ds peMsgs likeds(paramMsgs);
        dcl-ds peBase likeds(paramBase);

        dcl-s  t char(80);
        dcl-s  empr char(1);
        dcl-s  sucu char(2);
        dcl-s  nivt char(1);
        dcl-s  nivc char(5);
        dcl-s  nit1 char(1);
        dcl-s  niv1 char(5);
        dcl-s  pacp char(6);
        dcl-s  uri  char(512);
        dcl-s  @repl char(65535);
        dcl-s  url  varchar(3000);
        dcl-s  rc   ind;

        dcl-s pePacp packed(6:0);

        dcl-ds @psds psds qualified;
               this char(10) pos(1);
        end-ds;

       *inlr = *ON;

       rc  = REST_getUri( @psds.this : uri );
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
       pacp = REST_getNextPart(url);

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

       k1hric.icempr = empr;
       k1hric.icsucu = sucu;
       k1hric.icartc = 60;
       k1hrid.idempr = empr;
       k1hrid.idsucu = sucu;
       k1hrid.idartc = 60;
       monitor;
           k1hric.icpacp = %dec(pacp:6:0);
           k1hrid.idpacp = %dec(pacp:6:0);
        on-error;
           k1hric.icpacp = 0;
           k1hrid.idpacp = 0;
       endmon;

       setll %kds(k1hric:4) cnhric;
       if not %equal;
          @repl = pacp;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0011'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN0011'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       clear peBase;
       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec( nivt : 1 : 0 );
       peBase.peNivc = %dec( nivc : 5 : 0 );
       peBase.peNit1 = %dec( nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( niv1 : 5 : 0 );
       COWLOG_logcon('WSRRIS':peBase);

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray('recibo');
       REST_writeXmlLine('cantidad' : '46');
       REST_startArray('lineas');

       setll %kds(k1hrid:4) cnhrid;
       reade %kds(k1hrid:4) cnhrid;
       dow not %eof;

           REST_writeXmlLine('linea'  : %trim(idtpds));

        reade %kds(k1hrid:4) cnhrid;
       enddo;

       REST_endArray('lineas');
       REST_endArray('recibo');

       REST_end();
       close *all;

       return;
