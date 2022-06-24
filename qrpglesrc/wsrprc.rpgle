     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPRC: QUOM Versión 2                                       *
      *         Lista de proveedores de ruedas y cristales, filtran- *
      *         do por tipo de proveedor recibido                    *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *30-Ene-2019            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *   JSN 25/06/2020 - Se agrega condición, en el caso del que   *
      *                    tipo de proveedor sea "A" se agregue en   *
      *                    lista del filtro que esten consultando    *
      *                    ya sea "R" o "C".                         *
      *                    A = Ambas, R = Ruedas y C = Cristales     *
     * David Tilatti                                                *
     *       17/09/2021 - Filtra lista solo lleva activos del master*
     *                    de proveedores de cristales y Ruedas.     *
     *                    RqTk 10627.                               *
     *                    Baja logica en tabla CNTNAP campo NAMAR2  *
     *                    0=Activo, 9=Bloqueado                     *
      *                                                              *
      * ************************************************************ *
     Fcntnap    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

     D uri             s            512a
     D Empr            s              1a
     D Sucu            s              2a
     D tipo            s              1a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D peBase          ds                  likeds(paramBase)
     D @@repl          s          65535a
     D @@Loca          s             25a
     D @@Rpro          s              2  0
     D @@Dpro          s             20
     D tmpfec          s               d   datfmt(*iso) inz
     D peErro          s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)

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
       Empr = REST_getNextPart(url);
       Sucu = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'proveedores' : '*BEG' );

       setll *loval cntnap;
       read cntnap;
       dow not %eof( cntnap );

      // Filtra y muestra solo activos
         if naMar2 <> '9';
          if tipo <> 'A';
           if naMar1 = tipo or naMar1 = 'A';
             exsr response;
           endif;
          else;
           exsr response;
          endif;
         endif;
        read cntnap;

       enddo;

       REST_writeXmlLine( 'proveedores' : '*END' );

       return;

       // *------------------------------------------------*
       // Retorna los tag para la lista de provedores      *
       // *------------------------------------------------*
       begsr response;

         REST_writeXmlLine( 'proveedor' : '*BEG' );
           REST_writeXmlLine('codigo' : %trim(%editc(naNres:'X')));
           REST_writeXmlLine('nombre' : %trim(naNomb));
           REST_writeXmlLine('domicilio' : %trim(naDomi));
           REST_writeXmlLine('codigoPostal' : %trim(%editc(naCopo:'X')));
           REST_writeXmlLine('sufijoCodigoPostal' : %trim(%editc(naCops:'X')));

           @@Loca = SVPDES_localidad( naCopo
                                    : naCops );

           REST_writeXmlLine('localidad' : %trim(@@Loca));

           @@Rpro = COWGRAI_GetCodProInd( nacopo
                                        : naCops );

           REST_writeXmlLine('codigoProvincia' : %trim(%editc(@@Rpro:'X')));
           @@Dpro = SVPDES_provinciaInder(@@Rpro);
           REST_writeXmlLine('provincia' : %trim(@@Dpro));

           REST_writeXmlLine('telefono' : %trim(naNtel));
           REST_writeXmlLine('contacto' : %trim(naCont));
           REST_writeXmlLine('mail' : %trim(naMail));
           REST_writeXmlLine('horarioAtencion' : %trim(naAten));
           REST_writeXmlLine('tipoProveedor' : %trim(naMar1));
         REST_writeXmlLine( 'proveedor' : '*END' );

       endsr;

      /end-free

