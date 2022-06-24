     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRDPR: QUOM Versión 2                                       *
      *         Detalle de Propuesta.                                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *06-Jun-2017            *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fpahsp2    if   e           k disk
     Fpahspwc   if   e           k disk
     Fpahspwi   if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D soln            s              7a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@rama          s              2  0
     D @@repl          s          65535a
     D peErro          s             10i 0
     D suma            s             30a
     D fecinsp         s             10a

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hsp2          ds                  likerec(p1hsp2:*key)
     D k1hspc          ds                  likerec(p1hspwc:*key)
     D k1hspi          ds                  likerec(p1hspwi:*key)

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
       rama = REST_getNextPart(url);
       soln = REST_getNextPart(url);

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
       COWLOG_logcon('WSRDPR':peBase);

       if %check( '0123456789' : %trim(rama) ) <> 0;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       @@rama = %dec( rama : 2 : 0 );
       setll @@rama set001;
       if not %equal;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(soln) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = soln;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1hsp2.swempr = empr;
       k1hsp2.swsucu = sucu;
       k1hsp2.swnivt = %dec( nivt : 1 : 0 );
       k1hsp2.swnivc = %dec( nivc : 5 : 0 );
       k1hsp2.swrama = %dec( rama : 2 : 0 );
       k1hsp2.swsoln = %dec( soln : 7 : 0 );
       setll %kds(k1hsp2:6) pahsp2;
       if not %equal;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = soln;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'detallePropuesta' : '*BEG');

       setll  %kds(k1hsp2:6) pahsp2;
       reade  %kds(k1hsp2:6) pahsp2;
       dow not %eof;

           REST_writeXmlLine( 'vehiculos': '*BEG' );
           k1hspc.wcrama = swrama;
           k1hspc.wcsoln = swsoln;
           k1hspc.wcpoli = swpoli;
           setll %kds(k1hspc:3) pahspwc;
           reade %kds(k1hspc:3) pahspwc;
           dow not %eof;

               suma = %editw( wcvhvu : ' .   .   .   . 0 ,  -' );

               REST_writeXmlLine( 'vehiculo' : '*BEG');
                REST_writeXmlLine( 'anio' : %char(wcvhan) );
                REST_writeXmlLine( 'patente' : %trim(wcnmat) );
                REST_writeXmlLine( 'marca' : %trim(wcvhmd) );
                REST_writeXmlLine( 'chasis' : %trim(wcchas) );
                REST_writeXmlLine( 'modelo' : %trim(wcvhdm) );
                REST_writeXmlLine( 'motor' : %trim(wcmoto) );
                REST_writeXmlLine( 'version' : %trim(wcvhds) );
                REST_writeXmlLine( 'zona' : %char(wcscta) );
                REST_writeXmlLine( 'cobertura' : %trim(wccobd) );
                REST_writeXmlLine( 'rastreador' : %trim(wcrast) );
                REST_writeXmlLine( 'estadoRastreador' : %trim(wceras) );
                REST_writeXmlLine( 'sumaAsegurada' : %trim(suma) );
               REST_writeXmlLine( 'vehiculo' : '*END');

            reade %kds(k1hspc:3) pahspwc;
           enddo;

           REST_writeXmlLine( 'vehiculos': '*END' );

           k1hspi.siempr = swempr;
           k1hspi.sisucu = swsucu;
           k1hspi.sinivt = swnivt;
           k1hspi.sinivc = swnivc;
           k1hspi.sirama = swrama;
           k1hspi.sisoln = swsoln;
           chain %kds(k1hspi:6) pahspwi;
           if %found;

               monitor;
                 fecinsp = %char(sifins:*iso);
                on-error;
                 fecinsp = *blanks;
               endmon;

               if fecinsp = '0001-01-01';
                  fecinsp = *blanks;
               endif;

               REST_writeXmlLine( 'inspeccion' : '*BEG' );
                REST_writeXmlLine( 'nroInsp' : %trim(siinsp) );
                REST_writeXmlLine( 'estadoInsp' : %trim(siesta) );
                REST_writeXmlLine( 'domicilio' : %trim(sidomi) );
                REST_writeXmlLine( 'fechaInsp' : %trim(fecinsp) );
                REST_writeXmlLine( 'observaciones': %trim(simoti) );
               REST_writeXmlLine( 'inspeccion' : '*END' );

           endif;

        reade  %kds(k1hsp2:6) pahsp2;
       enddo;

       REST_writeXmlLine( 'detallePropuesta' : '*END');

       REST_end();

       close *all;

       return;

      /end-free
