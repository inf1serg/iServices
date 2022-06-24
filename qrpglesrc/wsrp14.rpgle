     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRP14: QUOM Versión 2                                       *
      *         Listado de Preliquidaciones guardadas.               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *30-Jun-2020            *
      * ************************************************************ *
     Fpahpqc10  if   e           k disk
     Fpahpqe    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a

     D uri             s            512a
     D url             s           3000a   varying
     D c               s             10i 0
     D rc              s              1n
     D neto            s             15  2
     D @@repl          s          65535a
     D hoy             s              8  0
     D fvto            s             10d
     D @@fvto          s              8  0
     D allow           s             10a

     D peMsgs          ds                  likeds(paramMsgs)
     D k1hpqc          ds                  likerec(p1hpqc:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       hoy = %dec(%date():*iso);

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

       k1hpqc.qcempr = empr;
       k1hpqc.qcsucu = sucu;
       k1hpqc.qcnivt = %dec( nivt : 1 : 0 );
       k1hpqc.qcnivc = %dec( nivc : 5 : 0 );

       c = 0;

       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'preliquidaciones' );

       setll %kds(k1hpqc:4) pahpqc10;
       reade %kds(k1hpqc:4) pahpqc10;
       dow not %eof;

           c += 1;

           neto = 0;

           if qctipo = 'PB';
              neto = qcimpb;
           endif;
           if qctipo = 'PN';
              neto = qcimpn;
           endif;

           allow = 'true';
           fvto = %date( qcfech : *iso ) + %days(2);
           @@fvto = %dec(fvto:*iso);
           if hoy > @@fvto;
              qcmarp = 'V';
              allow = 'false';
           endif;
           chain qcmarp pahpqe;
           if not %found;
              qenomb = '*ERROR';
           endif;

           REST_startArray( 'preliquidacion' );
            REST_writeXmlLine( 'nroPreli'   : %trim(%char(qcnrpl)) );
            REST_writeXmlLine( 'fechaPreli' : SVPREST_editFecha(qcfech));
            REST_writeXmlLine( 'desdePreli' : SVPREST_editFecha(qcfdes));
            REST_writeXmlLine( 'hastaPreli' : SVPREST_editFecha(qcfhas));
            REST_writeXmlLine( 'importeNeto': SVPREST_editImporte(neto));
            REST_writeXmlLine( 'estado'     : %trim(qenomb) );
            REST_writeXmlLine( 'tipo'       : %trim(qctipo) );
            REST_writeXmlLine( 'permiteRetomar': allow      );
           REST_endArray( 'preliquidacion' );

        reade %kds(k1hpqc:4) pahpqc10;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );

       REST_endArray( 'preliquidaciones' );

       REST_end();

       close *all;

       return;

      /end-free
