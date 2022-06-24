     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRACC: QUOM Versión 2                                       *
      *         Lista de actividades de comercio                     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *30-Ene-2021            *
      * ------------------------------------------------------------ *
      * SGF 25/06/2021: Cambio forma de acceso a SET101.             *
      *                                                              *
      * ************************************************************ *
     Fset6261   if   e           k disk
     Fset101    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D arcd            s              6a
     D rama            s              2a
     D arse            s              2a
     D tipo            s              1a

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

     D k1t626          ds                  likerec(s1t6261:*key)
     D k1t101          ds                  likerec(s1t101:*key)
     D inp101          ds                  likerec(s1t101:*input)

     D actis           ds                  qualified dim(9999) inz
     D  ctar                          4  0
     D  cta1                          2a
     D  cta2                          2a
     D  ceta                          4a
     D  cev1                          2a
     D  cev2                          2a
     D  ctds                         20a
     D  ctdl                         40a
     D  cagr                          2  0
     D  riec                          3a

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

     D rc              s              1n
     D primera         s              1n
     D z               s             10i 0

     Is1t101
     I              t@fech                      ttfech

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
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       arse = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       tipo = %xlate(min:may:tipo);
       if tipo <> 'T' and tipo <> 'W';
          tipo = 'T';
       endif;

       monitor;
          k1t626.t@arcd = %dec(arcd:6:0);
        on-error;
          k1t626.t@arcd = 0;
       endmon;

       monitor;
          k1t626.t@rama = %dec(rama:2:0);
        on-error;
          k1t626.t@rama = 0;
       endmon;

       monitor;
          k1t626.t@arse = %dec(arse:2:0);
        on-error;
          k1t626.t@arse = 0;
       endmon;

       z = 0;

       REST_writeHeader();
       REST_writeEncoding();

       setll %kds(k1t626:3) set6261;
       reade %kds(k1t626:3) set6261;
       dow not %eof;
           monitor;
              k1t101.t@rama = %dec(rama:2:0);
            on-error;
              k1t101.t@rama = 0;
           endmon;
           k1t101.t@ctar = t@ctar;
           k1t101.t@cta1 = t@cta1;
           k1t101.t@cta2 = t@cta2;
           chain %kds(k1t101:4) set101 inp101;
           if %found;
              if tipo = 'T' or
                 (tipo = 'W' and inp101.t@mweb = '1');
                  exsr $array;
              endif;
           endif;
        reade %kds(k1t626:3) set6261;
       enddo;

       sorta actis(*).ctdl;
       for z = 1 to %elem(actis);
           if actis(z).ctar > 0;
              if z > 1;
                 actis(z-1).ctar = 0;
                 actis(z-1).cta1 = *blanks;
                 actis(z-1).cta2 = *blanks;
                 actis(z-1).ceta = *blanks;
                 actis(z-1).cev1 = *blanks;
                 actis(z-1).cev2 = *blanks;
                 actis(z-1).ctds = 'SELECCIONE';
                 actis(z-1).ctdl = 'SELECCIONE';
                 actis(z-1).riec = *blanks;
                 actis(z-1).cagr = 0;
                 leave;
              endif;
           endif;
       endfor;

       REST_startArray( 'actividades' );
       for z = 1 to %elem(actis);
           if actis(z).ctdl <> *blanks;
              exsr $linea;
           endif;
       endfor;
       REST_endArray('actividades');

       return;

       begsr $array;
        z += 1;
        actis(z).ctar = t@ctar;
        actis(z).cta1 = t@cta1;
        actis(z).cta2 = t@cta2;
        actis(z).ceta = inp101.t@ceta;
        actis(z).cev1 = inp101.t@cev1;
        actis(z).cev2 = inp101.t@cev2;
        actis(z).ctds = inp101.t@ctds;
        actis(z).ctdl = inp101.t@ctdl;
        actis(z).cagr = inp101.t@cagr;
        actis(z).riec = inp101.t@riec;
       endsr;

       begsr $linea;
        REST_startArray( 'actividad' );
         actis(z).cta1 = %scanrpl( ' ' : '-' : actis(z).cta1 );
         actis(z).cta2 = %scanrpl( ' ' : '-' : actis(z).cta2 );
         REST_writeXmlLine( 'capituloTarifa' : %char(actis(z).ctar) );
         REST_writeXmlLine( 'capituloTarifaInc1' : actis(z).cta1 );
         REST_writeXmlLine( 'capituloTarifaInc2' : actis(z).cta2 );
         REST_writeXmlLine( 'capituloTarifaSist' : actis(z).ceta );
         REST_writeXmlLine( 'capituloTarifaInc1Sist' : actis(z).cev1 );
         REST_writeXmlLine( 'capituloTarifaInc2Sist' : actis(z).cev2 );
         REST_writeXmlLine( 'descripcionCorta'       : actis(z).ctds );
         REST_writeXmlLine( 'descripcionLarga'       : actis(z).ctdl );
         REST_writeXmlLine( 'agravamientoDefecto' : %char(actis(z).cagr));
         REST_writeXmlLine( 'codigoRiesgo' : actis(z).riec );
        REST_endArray( 'actividad' );
       endsr;

