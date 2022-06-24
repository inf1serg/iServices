     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSREAC: QUOM Versión 2                                       *
      *         Lista de endosos de aumento de suma.                 *
      * ------------------------------------------------------------ *
      * Valeria Marquezz                     *11-Mar-2022            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpaheac01  if   e           k disk

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

     D k1heac          ds                  likerec(p1heac:*key)

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

       k1heac.acempr = empr;
       k1heac.acsucu = sucu;
       k1heac.acnivt = %dec( nivt : 1 : 0 );
       k1heac.acnivc = %dec( nivc : 5 : 0 );

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSREAC':peBase);

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'componentes' );

       setll %kds(k1heac:4) paheac01;
       reade %kds(k1heac:4) paheac01;
       dow not %eof;

           REST_startArray( 'componente' );

            REST_writeXmlLine( 'codEmpresa'     : %char(acempr) );
            REST_writeXmlLine( 'codSucursal'    : %char(acsucu) );
            REST_writeXmlLine( 'codArticulo'    : %char(acarcd) );
            REST_writeXmlLine( 'nroSuperPoliza' : %char(acspol) );
            REST_writeXmlLine( 'codRama'        : %char(acrama) );
            REST_writeXmlLine( 'nroPoliza'      : %char(acpoli) );
            REST_writeXmlLine( 'cantPolizas'    : %char(acarse) );
            REST_writeXmlLine( 'nroOperacion'   : %char(acoper) );
            REST_writeXmlLine( 'nroComponente'  : %char(acpoco) );

            REST_writeXmlLine( 'ubicacion'          : %char(acrdes) );
            REST_writeXmlLine( 'sumaActualCaldera'  : %char(acsacc) );
            REST_writeXmlLine( 'sumaNuevaCaldera'   : %char(acsncc) );
            REST_writeXmlLine( 'sumaActualAscensor' : %char(acsaca) );
            REST_writeXmlLine( 'sumaNuevaAscensor'  : %char(acsnca) );

            REST_writeXmlLine( 'finVigencia'
                             : SVPREST_editFecha(acfhas) );

            REST_writeXmlLine( 'prima'    : SVPREST_editImporte(acprim));
            REST_writeXmlLine( 'premio'   : SVPREST_editImporte(acprem));
            REST_writeXmlLine( 'comision' : SVPREST_editImporte(accopr));


           REST_endArray( 'componente' );

        reade %kds(k1heac:4) paheac01;
       enddo;

       REST_endArray( 'componentes' );

       close *all;

       return;

      /end-free

