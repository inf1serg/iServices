     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPRP: QUOM Versión 2                                       *
      *         Listado de Propuestas SpeedWay                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ************************************************************ *
     Fpahpqc06  if   e           k disk
     Fsehni2    if   e           k disk

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
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D neto            s             15  2
     D @@repl          s          65535a
     D impo            s             30a
     D fdes            s             10d
     D fhas            s             10d
     D fech            s             10d

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D k1hpqc          ds                  likerec(p1hpqc:*key)
     D k1hni2          ds                  likerec(s1hni2:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

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
       COWLOG_logcon('WSRPQW':peBase);

       k1hpqc.qcempr = empr;
       k1hpqc.qcsucu = sucu;
       k1hpqc.qcnivt = %dec( nivt : 1 : 0 );
       k1hpqc.qcnivc = %dec( nivc : 5 : 0 );

       c = 0;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'preliquidaciones' : '*BEG');
       if rc = *off;
          return;
       endif;

       setll %kds(k1hpqc:4) pahpqc06;
       reade %kds(k1hpqc:4) pahpqc06;
       dow not %eof;

           c += 1;

           if qctipo = 'PB';
              neto = qcimpb;
           endif;
           if qctipo = 'PN';
              neto = qcimpn;
           endif;
           impo = %editw( neto : '                 .  -' );
           fech = %date(qcfech:*iso);
           fdes = %date(qcfdes:*iso);
           fhas = %date(qcfhas:*iso);

           if neto = 0;
              impo = '.00';
           endif;

           REST_writeXmlLine( 'preliquidacion'   : '*BEG'               );
            REST_writeXmlLine( 'nroPreli'        : %trim(%char(qcnrpl)) );
            REST_writeXmlLine( 'fechaPreli'      : %trim(%char(fech:*iso)));
            REST_writeXmlLine( 'desdePreli'      : %trim(%char(fdes:*iso)));
            REST_writeXmlLine( 'hastaPreli'      : %trim(%char(fhas:*iso)));
            REST_writeXmlLine( 'importeNeto'     : %trim(impo)    );
            REST_writeXmlLine( 'estado'          : %trim(qenomb) );
            REST_writeXmlLine( 'tipo'            : %trim(qctipo) );
           REST_writeXmlLine( 'preliquidacion'   : '*END'               );

        reade %kds(k1hpqc:4) pahpqc06;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );

       REST_writeXmlLine( 'preliquidaciones' : '*END' );

       REST_end();

       close *all;

       return;

      /end-free
