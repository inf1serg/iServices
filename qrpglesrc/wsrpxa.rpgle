     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRACC: QUOM Versión 2                                       *
      *         Lista de actividades de comercio                     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *30-Ene-2021            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *  JSN 18/05/2021 - Se agrega los tags RQAP y RQRC y se llama  *
      *                   el procedimiento _listaProductosProductor2 *
      * ************************************************************ *
     Fset100    if   e           k disk
     Fset101c   if   e           k disk

      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'

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
     D ctar            s              4a
     D cta1            s              2a
     D cta2            s              2a

     D peArcd          s              6  0
     D peRama          s              2  0
     D peArse          s              2  0
     D peCtar          s              4  0
     D peLproC         s             10i 0
     D x               s             10i 0

     D k1y100          ds                  likerec(s1t100:*key)
     D k1t101          ds                  likerec(s1t101c:*key)
     D peBase          ds                  likeds(paramBase)
     D peLpro          ds                  likeds(set102_t2) dim(999)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

     D rc              s              1n

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
       ctar = REST_getNextPart(url);
       cta1 = REST_getNextPart(url);
       cta2 = REST_getNextPart(url);

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       monitor;
          peBase.peNivt = %dec(nivt:1:0);
        on-error;
          peBase.peNivt = 0;
       endmon;
       monitor;
          peBase.peNivc = %dec(nivc:5:0);
        on-error;
          peBase.peNivc = 0;
       endmon;
       monitor;
          peBase.peNit1 = %dec(nit1:1:0);
        on-error;
          peBase.peNit1 = 0;
       endmon;
       monitor;
          peBase.peNiv1 = %dec(niv1:5:0);
        on-error;
          peBase.peNiv1 = 0;
       endmon;
       monitor;
          peRama = %dec(rama:2:0);
        on-error;
          peRama = 0;
       endmon;
       monitor;
          peArse = %dec(arse:2:0);
        on-error;
          peArse = 0;
       endmon;
       monitor;
          peArcd = %dec(arcd:6:0);
        on-error;
          peArcd = 0;
       endmon;

       monitor;
          peCtar = %dec(ctar:4:0);
        on-error;
          peCtar = 0;
       endmon;

       cta1 = %scanrpl( '-' : ' ' : cta1 );
       cta2 = %scanrpl( '-' : ' ' : cta2 );

       WSLTAB_listaProductosProductor2( peBase
                                      : peArcd
                                      : peRama
                                      : peLpro
                                      : peLproC );

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'planes' );

       for x = 1 to peLproC;
           k1t101.t@rama = peRama;
           k1t101.t@ctar = peCtar;
           k1t101.t@cta1 = cta1;
           k1t101.t@cta2 = cta2;
           k1t101.t@xpro = peLpro(x).xpro;
           setll %kds(k1t101) set101c;
           if %equal;
              exsr $linea;
           endif;
       endfor;

       REST_endArray('planes');

       return;

       begsr $linea;
        REST_startArray( 'plan' );
         REST_writeXmlLine( 'CAGR' : %editc(peLpro(x).cagr:'X'));
         REST_writeXmlLine( 'CTA1' : %trim(peLpro(x).cta1));
         REST_writeXmlLine( 'CTA2' : %trim(peLpro(x).cta2));
         REST_writeXmlLine( 'CTAR' : %char(peLpro(x).ctar));
         REST_writeXmlLine( 'CTDS' : %trim(peLpro(x).ctds));
         REST_writeXmlLine( 'PRDL' : %trim(peLpro(x).prdl));
         REST_writeXmlLine( 'PRDS' : %trim(peLpro(x).prds));
         REST_writeXmlLine( 'XPRO' : %char(peLpro(x).xpro));
         if peLpro(x).Mar1 = '1';
           REST_writeXmlLine( 'RQAP' : 'S' );
         else;
           REST_writeXmlLine( 'RQAP' : 'N' );
         endif;

         if peLpro(x).Mar2 = '1';
           REST_writeXmlLine( 'RQRC' : 'S' );
         else;
           REST_writeXmlLine( 'RQRC' : 'N' );
         endif;

         k1y100.t@rama = peRama;
         k1y100.t@xpro = peLpro(x).xpro;
         k1y100.t@mone = '01';
         chain %kds ( k1y100 : 3 ) set100;
         select;
           when not %found ( set100 );
             REST_writeXmlLine( 'TIDP' : 'E' );
           when t@prem = *Zeros;
             REST_writeXmlLine( 'TIDP' : 'A' );
           other;
             REST_writeXmlLine( 'TIDP' : 'C' );
         endsl;

        REST_endArray( 'plan' );
       endsr;

