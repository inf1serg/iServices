     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSREAS: QUOM Versión 2                                       *
      *         Lista de endosos de aumento de suma.                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *08-Abr-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpaheas01  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a

     D rc              s              1n

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D @@porc          s             10a
     D @@tari          s              1a
     D peVsys          s            512a

     D k1heas          ds                  likerec(p1heas:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       // -----------------------------------------
       // Veo que tarifa usar:
       // N = Nueva
       // P = Poliza
       // -----------------------------------------
       @@tari = 'N';
       if SVPVLS_getValSys( 'HEASWEBTAR' : *omit : peVsys);
          @@tari = peVsys;
       endif;

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

       k1heas.asempr = empr;
       k1heas.assucu = sucu;
       k1heas.asnivt = %dec( nivt : 1 : 0 );
       k1heas.asnivc = %dec( nivc : 5 : 0 );

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSREAS':peBase);

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'componentes' );

       setll %kds(k1heas:4) paheas01;
       reade %kds(k1heas:4) paheas01;
       dow not %eof;

           if asvhdp <= 0;
              @@porc = '.00';
            else;
              @@porc = %editw(asvhdp:' 0 .  ');
           endif;

           REST_startArray( 'componente' );

            REST_writeXmlLine( 'codRama' : %char(asrama) );
            REST_writeXmlLine( 'nroPoliza' : %char(aspoli));
            REST_writeXmlLine( 'nroOperacion' : %char(asoper) );
            REST_writeXmlLine( 'nroArse' : %char(asarse) );
            REST_writeXmlLine( 'codArticulo' : %char(asarcd) );
            REST_writeXmlLine( 'nroSuperPoliza' : %char(asspol) );
            REST_writeXmlLine( 'nroComponente' : %char(aspoco) );
            REST_writeXmlLine( 'marca' : %trim(asdmar)         );
            REST_writeXmlLine( 'modelo' : %trim(asdmod)       );
            REST_writeXmlLine( 'anio' : %char(asvhaÑ)       );
            REST_writeXmlLine( 'sumaActual': SVPREST_editImporte(asvhvu) );
            REST_writeXmlLine( 'sumaInfoAuto':SVPREST_editImporte(asvhva));
            REST_writeXmlLine( 'diferenciaMonto'
                             : SVPREST_editImporte(asvhdi) );
            REST_writeXmlLine( 'diferenciaPorcentaje' : @@porc );
            REST_writeXmlLine( 'proximoVencimiento'
                             : SVPREST_editFecha(asfhfa) );
            REST_writeXmlLine( 'prima':SVPREST_editImporte(asprim));
            REST_writeXmlLine( 'premio': SVPREST_editImporte(asprem));
            REST_writeXmlLine( 'comision' : SVPREST_editImporte(ascopr));
            if @@tari = 'P';
               REST_writeXmlLine( 'tarifa'   : %char(asctrp) );
             else;
               REST_writeXmlLine( 'tarifa'   : %char(asctre) );
            endif;
            REST_writeXmlLine( 'habilitaEndoso' : asmar1 );

           REST_endArray( 'componente' );

        reade %kds(k1heas:4) paheas01;
       enddo;

       REST_endArray( 'componentes' );

       close *all;

       return;

      /end-free

