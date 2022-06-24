     H option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPRP: QUOM Versión 2                                       *
      *         Listado de Propuestas SpeedWay                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ************************************************************ *
     Fpahsp2    if   e           k disk
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
     D @vd             s             10a
     D @vh             s             10a
     D @fi             s             10a
     D c               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@repl          s          65535a

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D k1hsp2          ds                  likerec(p1hsp2:*key)
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

       k1hsp2.swempr = empr;
       k1hsp2.swsucu = sucu;
       k1hsp2.swnivt = %dec( nivt : 1 : 0 );
       k1hsp2.swnivc = %dec( nivc : 5 : 0 );

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon('WSRPRP':peBase);

       c = 0;

       REST_writeHeader();

       REST_writeEncoding();
       REST_writeXmlLine( 'propuestas' : '*BEG');

       setll %kds(k1hsp2:4) pahsp2;
       reade %kds(k1hsp2:4) pahsp2;
       dow not %eof;

           @vd = *blanks;
           @vh = *blanks;
           @fi = *blanks;

           if %nullind( swfvdp ) = *off;
              @vd = %char(swfvdp:*iso);
           endif;

           if %nullind( swfvhp ) = *off;
              @vh = %char(swfvhp:*iso);
           endif;

           if %nullind( swfpro ) = *off;
              @fi = %char(swfpro:*iso);
           endif;

           c += 1;

           REST_writeXmlLine( 'propuesta'       : '*BEG'               );
            REST_writeXmlLine( 'rama'            : %trim(%char(swrama)) );
            REST_writeXmlLine( 'poliza'          : %trim(%char(swpoli)) );
            REST_writeXmlLine( 'asegurado'       : %trim(swased)        );
            REST_writeXmlLine( 'codProductor'    : %trim(%char(swnivc)) );
            REST_writeXmlLine( 'nombreProductor' : %trim(swnivd)        );
            REST_writeXmlLine( 'solicitud'       : %trim(%char(swsoln)) );
            REST_writeXmlLine( 'vigenciaDesde'   : %trim(@vd)           );
            REST_writeXmlLine( 'vigenciaHasta'   : %trim(@vh)           );
            REST_writeXmlLine( 'fechaIngreso'    : %trim(@fi)           );
            REST_writeXmlLine( 'estado'          : %trim(swesta)        );
            REST_writeXmlLine( 'operacion'       : %trim(swdsop)        );
           REST_writeXmlLine( 'propuesta'       : '*END'               );

        reade %kds(k1hsp2:4) pahsp2;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );

       REST_writeXmlLine( 'propuestas' : '*END' );

       REST_end();

       close *all;

       return;

      /end-free
