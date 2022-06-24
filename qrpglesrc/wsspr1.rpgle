     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSPR1: BPM                                                  *
      *         Retorna Datos de un proveedor                        *
      * ------------------------------------------------------------ *
      *                                      *09-Set-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fcntnau01  if   e           k disk
     Fcntnap    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D rc              s              1n
     D @@repl          s          65535a
     D @@cuit          s             11a
     D @@copo          s              5  0
     D @@cops          s              1  0
     D @@nrdf          s              7  0
     D @@rpro          s              2  0
     D peMsgs          ds                  likeds(paramMsgs)
     D k1tnau          ds                  likerec(c1tnau01:*key)

     D nres            s              7a
     D peNres          s              7  0
     D x               s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
         REST_writeHeader( 204
                         : *omit
                         : *omit
                         : 'RPG0001'
                         : 40
                         : 'Error al parsear URL'
                         : 'Error al parsear URL' );
         REST_end();
         return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------

        empr = REST_getNextPart(url);
        sucu = REST_getNextPart(url);
        nres = REST_getNextPart(url);
        empr = %upper(empr);
        sucu = %upper(sucu);

        monitor;
           peNres = %dec(nres:7:0);
         on-error;
           peNres = 0;
        endmon;

       //Empresa debe existir
       if SVPEMP_getDatosDeEmpresa(Empr) = *off;
          @@repl = empr;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0113'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       //Sucursal debe existir
       if SVPVAL_sucursal(Empr: Sucu) = *off;
          @@repl = sucu;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0114'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0114'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       chain peNres cntnap;
       if not %found;
          @@repl = nres;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MAY0003'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'MAY0003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       k1tnau.naempr = empr;
       k1tnau.nasucu = sucu;
       k1tnau.nacoma = nacoma;
       k1tnau.nanrma = nanrma;
       chain %kds(k1tnau:4) cntnau01;
       if not %found;
          @@cuit = *all'0';
          @@copo = 0;
          @@cops = 0;
          @@nrdf = 0;
        else;
          @@cuit = dfcuit;
          @@copo = dfcopo;
          @@cops = dfcops;
          @@nrdf = nanrdf;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'proveedor' );

        REST_writeXmlLine( 'empresa'        : empr );
        REST_writeXmlLine( 'sucursal'       : sucu );
        REST_writeXmlLine( 'codigoMayorAux' : nacoma );
        REST_writeXmlLine( 'numeroMayorAux' : %editc(nanrma:'X') );
        REST_writeXmlLine( 'codigoRueCri'   : %editc(nanres:'X') );
        REST_writeXmlLine( 'cuit'           : @@cuit );
        REST_writeXmlLine( 'nombre'         : nanomb );
        REST_writeXmlLine( 'tipo'           : natpro );
        REST_writeXmlLine( 'filiatorio'     : %editc(@@nrdf:'X'));

         REST_startArray( 'domicilio' );
          REST_writeXmlLine( 'calle'             : nadomi );
          REST_writeXmlLine( 'codigoPostal'      : %editc(@@copo:'X') );
          REST_writeXmlLine( 'sufijoCodigoPostal': %editc(@@cops:'X'));
          REST_writeXmlLine( 'localidad'
                           : SVPDES_localidad(@@copo:@@cops )        );
          @@rpro = SVPDES_getProvinciaPorLocalidad(@@copo:@@cops);
          REST_writeXmlLine( 'provincia'
                           : SVPDES_provinciaInder( @@rpro) );
         REST_endArray  ( 'domicilio' );

        REST_startArray( 'contacto' );
         REST_writeXmlLine( 'telefono' : nantel );
         REST_writeXmlLine( 'mail'     : namail );
         REST_writeXmlLine( 'horario'  : naaten );
         REST_writeXmlLine( 'nombre'   : nacont );
        REST_endArray  ( 'contacto' );

       REST_endArray  ( 'proveedor' );

       return;

