     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRFEC: QUOM Versión 2                                       *
      *         Fechas de Varias de GAUS                             *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        *03-Ene-2018            *
      * ------------------------------------------------------------ *
      * Modificiones:                                                *
      * SGF 10/01/2018: Se modifica envio de datos de aaaammdd a     *
      *                 aaaa-mm-dd. Se corrige envio de fecha de     *
      *                 asiento.-                                    *
      * SGF 16/01/2019: Agrego fecha para nuevo certificado mercosur.*
      * ************************************************************ *
     Fivt002    if   e           k disk
     Fset301    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     DDBA456R          pr                  extpgm('DBA456R')
     D                                4  0
     D                                2  0
     D                                2  0

     D splstday        pr                  extpgm('SPLSTDAY')
     D                                2  0
     D                                4  0
     D                                2  0

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@d             s              2  0
     D @@m             s              2  0
     D @@a             s              4  0
     D @@fech          s              8  0
     D @1fech          s              8  0
     D @2fech          s              8  0
     D ok              s               n
     D @@date          s             10d
     D peVsys          s            512a

     D CRLF            c                   x'0d25'

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D k1y002          ds                  likerec( i1t002 : *key )
     D k1y301          ds                  likerec( s1t301 : *key )

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

       REST_writeHeader();
       rc = REST_writeEncoding();
       if rc = *off;
          return;
       endif;

       ok = *off;
       REST_writeXmlLine( 'fechasDelSistema' : '*BEG');
         //Obtener Fecha del día de Produccion...
         clear @@fech;
         clear @@a;
         clear @@m;
         clear @@d;

         PAR310X3 ( empr : @@a : @@m : @@d );
         @@fech = (@@a * 10000) + (@@m * 100) + @@d;
         monitor;
         @@date = %date(@@fech:*iso);
          on-error;
             @@date = %date((*year*10000)+(*month*100)+*day:*iso);
         endmon;
         REST_writeXmlLine( 'produccion' : %trim( %char( @@date: *iso ) ) );
         if @@fech <> *zeros;
           ok = *on;
         endif;

         //Obtener Fecha del día de Siniestros...
         clear @@fech;
         clear @@a;
         clear @@m;
         clear @@d;

         DBA456R( @@a : @@m : @@d );
         @@fech = (@@a * 10000) + (@@m * 100) + @@d;
         monitor;
             @@date = %date(@@fech:*iso);
          on-error;
             @@date = %date((*year*10000)+(*month*100)+*day:*iso);
         endmon;
         REST_writeXmlLine('siniestros ':%trim(%char(@@date:*iso) ) );
         if @@fech <> *zeros;
           ok = *on;
         endif;

         //Obtener Fecha del día de Caja...
         //Obtener Fecha del Último ingreso de caja...
         //Obtener Fecha de Asiento...
         clear @@fech;
         clear @1fech;
         clear @2fech;

         k1y002.t2empr = empr;
         k1y002.t2sucu = sucu;
         chain %kds( k1y002 : 2 ) ivt002;
         if %found( ivt002 );
         @@fech = ( t2ic1a * 10000 ) + (t2ic1m * 100 ) + t2ic1d;
         @1fech = ( t2ic2a * 10000 ) + (t2ic2m * 100 ) + t2ic2d;
         @2fech = ( t2fasa * 10000 ) + (t2fasm * 100 ) + t2fasd;
         if @@fech <> *zeros or
            @1fech <> *zeros or
            @2fech <> *zeros;
           ok = *on;
         endif;
         endif;

         monitor;
             @@date = %date(@@fech:*iso);
          on-error;
             @@date = %date((*year*10000)+(*month*100)+*day:*iso);
         endmon;
         REST_writeXmlLine( 'caja ' : %trim( %char( @@date:*iso) ) );

         monitor;
             @@date = %date(@1fech:*iso);
          on-error;
             @@date = %date((*year*10000)+(*month*100)+*day:*iso);
         endmon;
         REST_writeXmlLine( 'ultimoIngresoDeCaja '
                          : %trim( %char( @@date:*iso ) ) );

         monitor;
             @@date = %date(@2fech:*iso);
          on-error;
             @@date = %date((*year*10000)+(*month*100)+*day:*iso);
         endmon;

         REST_writeXmlLine( 'Asiento ' : %trim( %char( @@date:*iso)) );

         //Obtener Fecha último cierre de comisiones
         clear @2fech;

         k1y301.t@empr = empr;
         k1y301.t@sucu = sucu;
         chain %kds( k1y301 : 2 ) set301;
         if %found( set301 );
           SPLSTDAY( @@m : t@fe1a : t@fe1m );
           @@fech = ( t@fe1a * 10000 ) + ( t@fe1m * 100 ) + @@m ;
           if @@fech <> *zeros;
             ok = *on;
           endif;
         endif;

       // -----------------------------------------
       // Fecha nuevo mercosur
       // -----------------------------------------
       rc = SVPVLS_getValSys( 'HFECNEWMER' : *omit : peVsys );
       if rc = *on;
          REST_writeXmlLine( 'fechaNuevoMercosur'
                           : %subst(peVsys:1:4)
                           + '-'
                           + %subst(peVsys:5:2)
                           + '-'
                           + %subst(peVsys:7:2)  );
        else;
          REST_writeXmlLine( 'fechaNuevoMercosur' : '2050-12-31' );
       endif;

       REST_writeXmlLine( 'fechasDelSistema' : '*END');

       if not ok;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
       endif;

       REST_end();
       close *all;
       return;

      /end-free

