        ctl-opt
              actgrp(*caller) dftactgrp(*no)
              option(*debugio:*srcstmt:*noshowcpy:*nounref)
              datfmt(*iso) timfmt(*iso)
              bnddir('HDIILE/HDIBDIR');

        dcl-f prpwbs disk usage(*input) keyed;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

        dcl-s uri      char(512);
        dcl-s url      varchar(3000);
        dcl-s appl     char(128);

        dcl-ds @PsDs psds qualified;
               this  char(10) pos(1);
        end-ds;

      /free

        *inlr = *on;

        if not REST_getUri( @psds.this : uri );
           return;
        endif;
        url = %trim(uri);

        appl = REST_getNextPart(url);

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'propiedades' );

        setll appl prpwbs;
        reade appl prpwbs;
        dow not %eof;
            REST_startArray( 'propiedad' );
             REST_writeXmlLine( 'nombre' : %trim(bskeyn) );
             REST_writeXmlLine( 'valor'  : %trim(bsvalu) );
            REST_endArray  ( 'propiedad' );
         reade appl prpwbs;
        enddo;

        REST_endArray  ( 'propiedades' );

        REST_end();

        return;

