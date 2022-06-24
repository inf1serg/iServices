      * ************************************************************ *
      * WSRDVE: Servicio REST                                        *
      *         Retorna lista de pólizas con deuda vencida           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                       *17-Feb-2022          *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f pahec002 disk usage(*input) keyed;
        dcl-f pahcd5   disk usage(*input) keyed;

        dcl-s uri  char(512);
        dcl-s url  varchar(3000);
        dcl-s empr char(1);
        dcl-s sucu char(2);
        dcl-s asen char(7);

        dcl-s peAsen packed(7:0);
        dcl-s deuda  packed(15:2);
        dcl-s fvto   packed(8:0);
        dcl-s hoy    packed(8:0);
        dcl-s peFema packed(4:0);
        dcl-s peFemm packed(2:0);
        dcl-s peFemd packed(2:0);
        dcl-s rc     ind;

        dcl-ds k1hec0 likerec(p1hec002:*key);
        dcl-ds k1hcd5 likerec(p1hcd5  :*key);

        dcl-ds @PsDs psds qualified;
               this char(10) pos(1);
        end-ds;

        dcl-pr PAR310X3 extpgm('PAR310X3');
               peEmpr char(1) const;
               peFema packed(4:0);
               peFemm packed(2:0);
               peFemd packed(2:0);
        end-pr;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'

        *inlr = *on;

        rc  = REST_getUri( @PsDs.this : uri );
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
        asen = REST_getNextPart(url);

        monitor;
          peAsen = %dec(asen:7:0);
         on-error;
          peAsen = 0;
        endmon;

        if SVPASE_chkAse( peAsen ) = *off;
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit  );
           REST_end();
           SVPREST_end();
           return;
        endif;

        PAR310X3( empr : peFema : peFemm : peFemd );
        hoy = (peFema * 10000)
            + (peFemm *   100)
            +  peFemd;

        REST_writeHeader();
        REST_writeEncoding();
        REST_startArray( 'polizas' );

        k1hec0.c0empr = empr;
        k1hec0.c0sucu = sucu;
        k1hec0.c0asen = peAsen;

        setll %kds(k1hec0:3) pahec002;
        reade %kds(k1hec0:3) pahec002;
        dow not %eof;

            deuda = 0;
            k1hcd5.d5empr = c0empr;
            k1hcd5.d5sucu = c0sucu;
            k1hcd5.d5arcd = c0arcd;
            k1hcd5.d5spol = c0spol;
            setll %kds(k1hcd5:4) pahcd5;
            reade %kds(k1hcd5:4) pahcd5;
            dow not %eof;
                fvto = (d5fvca * 10000)
                     + (d5fvcm *   100)
                     +  d5fvcd;
                if (fvto < hoy) and
                   (d5sttc <> '3');
                   deuda += d5imcu;
                endif;
             reade %kds(k1hcd5:4) pahcd5;
            enddo;

            if (deuda > 0);
             REST_startArray( 'poliza' );
              REST_writeXmlLine( 'articulo'              : %char(d5arcd) );
              REST_writeXmlLine( 'superPoliza'           : %char(d5spol) );
              REST_writeXmlLine( 'rama'                  : %char(d5rama) );
              REST_writeXmlLine( 'operacion'             : %char(d5oper) );
              REST_writeXmlLine( 'articuloRamaSecuencia' : %char(d5arse) );
              REST_writeXmlLine( 'numero'                : %char(d5poli) );
              REST_writeXmlLine( 'deuda' : SVPREST_editImporte(deuda)    );
             REST_endArray  ( 'poliza' );
            endif;

         reade %kds(k1hec0:3) pahec002;
        enddo;

        REST_endArray( 'polizas' );

        REST_end();
        SVPREST_end();
        return;

