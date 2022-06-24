        // -------------------------------------------------------- //
        // WSRTDA: Servicio REST                                    //
        //         Retorna array con extensiones y tamaño máximo    //
        //         de archivos permitidos según el portal.          //
        //                                                          //
        // tppo: Tipo de portal (por ahora, soportamos *ALL)        //
        //                                                          //
        //  Expuesto en iib en:                                     //
        //  /portalProveedores/archivosPermitidos                   //
        //                                                          //
        //  Expuesto en APIC en:                                    //
        //  /proveedores/archivosPermitidos                         //
        //                                                          //
        //  Sergio Fernandez                       *11-May-2022     //
        //                                                          //
        // -------------------------------------------------------- //
        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f settda disk usage(*input) keyed;

      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'

        dcl-s url      varchar(3000);
        dcl-s uri      char(512);

        dcl-s tppo     char(50);
        dcl-s peTppo   char(50);

        dcl-c ANY            'ANY';
        dcl-c INSPECTORES    'INS';
        dcl-c INVESTIGADORES 'INV';
        dcl-c REPUESTEROS    'REP';
        dcl-c PRODUCTORES    'PRO';

        dcl-ds @PsDs psds qualified;
               this char(10) pos(1);
        end-ds;

        *inlr = *ON;

        if REST_getUri( @psds.this : uri ) = *off;
           return;
        endif;
        url = %trim(uri);

        if %trim(url) <> *blanks;
           tppo = REST_getNextPart(url);
        endif;

        peTppo = *blanks;
        select;
         when tppo = INSPECTORES;
              peTppo = '*INS';
         when tppo = INVESTIGADORES;
              peTppo = '*INV';
         when tppo = REPUESTEROS;
              peTppo = '*REP';
         when tppo = PRODUCTORES;
              peTppo = '*PRO';
        endsl;

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'tiposDeArchivo' );

        setll peTppo settda;
        reade peTppo settda;
        dow not %eof;
            REST_startArray( 'tipoDeArchivo' );
             REST_writeXmlLine( 'extension'       : %trim(t@exte) );
             REST_writeXmlLine( 'pesoMaximo'      : %trim(t@tama) );
             REST_writeXmlLine( 'unidadPesoMaximo': %trim(t@unid) );
            REST_endArray( 'tipoDeArchivo' );
         reade peTppo settda;
        enddo;

        REST_endArray( 'tiposDeArchivo' );

        return;

