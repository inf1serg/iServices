     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSPRV: BPM                                                  *
      *         Lista de Proveedores                                 *
      * ------------------------------------------------------------ *
      *                                      *09-Set-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fcntnau    if   e           k disk

      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

      *--- Variables REST ------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)
     D k1tnau          ds                  likerec(c1tnau:*key)
      *------------------------------------------------------------- *

      *--- Parametros de Entrada ----------------------------------- *
     D empr            s              1a
     D sucu            s              2a
     D tipo            s              3a
      *------------------------------------------------------------- *

      *--- Variables de Trabajo ------------------------------------ *
     D peEmpr          s              1a
     D peSucu          s              2a
     D peTipo          s              3a

     D peDsPv          ds                  likeds(dsprovee_t) dim(50000)
     D peDsDm          ds                  likeds(domiprov_t) dim(50000)
     D peDsDc          ds                  likeds(ctcprov_t) dim(50000)
     D peDsPvC         s             10i 0
     D x               s             10i 0

      *--- Estructura Interna -------------------------------------- *
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
      *------------------------------------------------------------- *

      *--- Variables de conversion --------------------------------- *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
      *------------------------------------------------------------- *

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
        tipo = REST_getNextPart(url);
        peEmpr = %xlate(min : may : empr) ;
        peSucu = %xlate(min : may : sucu) ;
        peTipo = %xlate(min : may : tipo) ;

       //Empresa debe existir
       if SVPEMP_getDatosDeEmpresa(peEmpr) = *off;
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
       if SVPVAL_sucursal(peEmpr: peSucu) = *off;
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

       //Tipo Proveedor debe existir
       ///QQQQQQ
       if SVPTAB_chkTipoProveedor ( peTipo
                                  : *omit ) = *off;
      // if peTipo <> 'TOD' and peTipo <> 'CRI' and peTipo <> 'RUE'and
      //    peTipo <> 'INV' and peTipo <> 'INS' and peTipo <> 'LIQ';
          @@repl = peTipo;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MAY0002'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'MAY0002'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'proveedores' );
        if SVPTAB_ListaProveedores( peEmpr
                                  : peSucu
                                  : peTipo
                                  : peDsPv
                                  : peDsDm
                                  : peDsDc
                                  : peDspvC );
         for x = 1 to peDsPvC;
           REST_startArray( 'proveedor' );
             REST_writeXmlLine( 'empresa'
                                : %trim(peDsPv(x).pvEmpr) );
             REST_writeXmlLine( 'sucursal'
                                : %trim(peDsPv(x).pvSucu) );
             REST_writeXmlLine( 'codigoMayorAux'
                                : %trim(peDsPv(x).pvComa) );
             REST_writeXmlLine( 'numeroMayorAux'
                                : %editc(peDsPv(x).pvNrma:'Z'));
             REST_writeXmlLine( 'codigoRueCri'
                                  : %editc(peDsPv(x).pvCrcr:'Z'));
             REST_writeXmlLine( 'cuit'
                                : %trim(peDsPv(x).pvCuit) );
             REST_writeXmlLine( 'nombre'
                                : %trim(peDsPv(x).pvNomb) );
             REST_writeXmlLine( 'tipo'
                                : %trim(peDsPv(x).pvTipo) );
              REST_startArray( 'domicilio' );
               REST_writeXmlLine( 'calle'
                                  : %trim(peDsDm(x).pvDomi) );
               REST_writeXmlLine( 'codigoPostal'
                                  : %editc(peDsDm(x).pvCopo:'Z'));
               REST_writeXmlLine( 'sufijoCodigoPostal'
                                  : %editc(peDsDm(x).pvCops:'Z'));
               REST_writeXmlLine( 'localidad'
                                  : %trim(peDsDm(x).pvLoca) );
               REST_writeXmlLine( 'provincia'
                                : %trim(peDsDm(x).pvProd) );
              REST_endArray  ( 'domicilio' );
              REST_startArray( 'contacto' );
               REST_writeXmlLine( 'telefono'
                                : %trim(peDsDc(x).pvTele) );
               REST_writeXmlLine( 'mail'
                                : %trim(peDsDc(x).pvEmai) );
               REST_writeXmlLine( 'horario'
                                : %trim(peDsDc(x).pvHora) );
               REST_writeXmlLine( 'nombre'
                                : %trim(peDsDc(x).pvNomb) );
              REST_endArray  ( 'contacto' );
              k1tnau.naempr = %trim(peDsPv(x).pvEmpr);
              k1tnau.nasucu = %trim(peDsPv(x).pvSucu);
              k1tnau.nacoma = %trim(peDsPv(x).pvComa);
              k1tnau.nanrma = peDsPv(x).pvNrma;
              chain %kds(k1tnau:4) cntnau;
              if %found;
                 REST_writeXmlLine( 'filiatorio'
                                  : %trim(%char(nanrdf)) );
               else;
                 REST_writeXmlLine( 'filiatorio' : '0'  );
              endif;
           REST_endArray  ( 'proveedor' );
         endfor;
        endif;
       REST_endArray  ( 'proveedores' );

       return;

