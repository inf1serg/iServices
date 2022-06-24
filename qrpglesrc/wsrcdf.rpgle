        // -------------------------------------------------------- //
        // WSRCDF: Servicio REST                                    //
        //         Lista Clases Documentales para proveedores       //
        //                                                          //
        // tipp: Tipo de proveedor (ver CNTTPR)                     //
        // type: Ver constantes                                     //
        //                                                          //
        //  Expuesto en iib en:                                     //
        //  /portalProveedores/listaClasesDocumentalesFilenet       //
        //                                                          //
        //  Expuesto en APIC en:                                    //
        //  /proveedores/listaClasesDocumentalesFilenet             //
        //                                                          //
        //  Sergio Fernandez                       *04-May-2022     //
        //                                                          //
        // -------------------------------------------------------- //
        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f settdf disk usage(*input) keyed;
        dcl-f settd1 disk usage(*input) keyed;

      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'

        dcl-s url      varchar(3000);
        dcl-s uri      char(512);

        dcl-s tipp     char(3);
        dcl-s type     char(50);
        dcl-s peType   char(1);

        dcl-c INFORME        'INFORME';
        dcl-c INFORME_FINAL  'INFORME_FINAL';
        dcl-c INFORME_PRELI  'INFORME_PRELIMINAR';
        dcl-c VOUCHER        'VOUCHER';
        dcl-c OTROS          'OTROS';

        dcl-ds @PsDs psds qualified;
               this char(10) pos(1);
        end-ds;

        *inlr = *ON;

        if REST_getUri( @psds.this : uri ) = *off;
           return;
        endif;
        url = %trim(uri);

        tipp = REST_getNextPart(url);
        type = REST_getNextPart(url);

        peType = 'O';
        select;
         when type = INFORME;
              peType = 'I';
         when type = INFORME_PRELI;
              peType = 'I';
         when type = INFORME_FINAL;
              peType = 'F';
         when type = VOUCHER;
              peType = 'V';
        endsl;

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'clasesDocumentales' );

        setll (tipp:peType) settd1;
        reade (tipp:peType) settd1;
        dow not %eof;
            chain t@idcf settdf;
            REST_startArray( 'claseDocumental' );
             REST_writeXmlLine( 'idClaseDocumental'     : t@idcf );
             REST_writeXmlLine( 'nombreClaseDocumental' : t@decf );
            REST_endArray( 'claseDocumental' );
         reade (tipp:peType) settd1;
        enddo;

        REST_endArray( 'clasesDocumentales' );

        return;

