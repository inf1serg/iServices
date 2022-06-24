     H option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCXP: QUOM Versión 2                                       *
      *         Lista de coberturas por plan y actividad de comercio *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *13-Feb-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fset101    if   e           k disk

      /copy './qcpybooks/wsltab_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D rama            s              2a
     D mone            s              2a
     D xpro            s              3a
     D ctar            s              4a
     D cta1            s              2a
     D cta2            s              2a

     D peRama          s              2  0
     D peXpro          s              3  0
     D peCtar          s              4  0
     D x               s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

     D peXcob          ds                  likeds(cobert_t) dim(999)
     D peXcobC         s             10i 0
     D rc              s              1n
     D prsa            s             10a

     D k1t101          ds                  likerec(s1t101:*key)

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
       rama = REST_getNextPart(url);
       mone = REST_getNextPart(url);
       xpro = REST_getNextPart(url);
       ctar = REST_getNextPart(url);
       cta1 = REST_getNextPart(url);
       cta2 = REST_getNextPart(url);

       monitor;
          peRama = %dec(rama:2:0);
        on-error;
          peRama = 0;
       endmon;
       monitor;
          peXpro = %dec(xpro:3:0);
        on-error;
          peXpro = 0;
       endmon;

       monitor;
          peCtar = %dec(ctar:4:0);
        on-error;
          peCtar = 0;
       endmon;

       cta1 = %scanrpl( '-' : ' ' : cta1 );
       cta2 = %scanrpl( '-' : ' ' : cta2 );

       k1t101.t@rama = peRama;
       k1t101.t@ctar = peCtar;
       k1t101.t@cta1 = cta1;
       k1t101.t@cta2 = cta2;
       chain %kds(k1t101:4) set101;
       if not %found;
          t@riec = *blanks;
       endif;

       WSLTAB_coberturasPorPlan( peRama
                               : peXpro
                               : mone
                               : peXcob
                               : peXcobC );

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'coberturas' );

       for x = 1 to peXcobC;
           if peXcob(x).riec = t@riec;
              exsr $linea;
           endif;
       endfor;

       REST_endArray('coberturas' );

       return;

       begsr $linea;
        REST_startArray( 'PEXCOB' );
         prsa = %editw(peXcob(x).prsa:' 0 ,  ');
         if peXcob(x).prsa = 0;
            prsa = '0.00';
         endif;
         REST_writeXmlLine( 'BAOP' : peXcob(x).baop);
         REST_writeXmlLine( 'CFAC' : %char(peXcob(x).cfac));
         REST_writeXmlLine( 'COBD' : peXcob(x).cobd);
         REST_writeXmlLine( 'COBL' : peXcob(x).cobl);
         REST_writeXmlLine( 'DFAC' : peXcob(x).dfac);
         REST_writeXmlLine( 'ESAP' : peXcob(x).esap );
         REST_writeXmlLine( 'OCOB' : %char(peXcob(x).ocob));
         REST_writeXmlLine( 'ORIE' : peXcob(x).orie);
         REST_writeXmlLine( 'PRSA' : prsa          );
         REST_writeXmlLine( 'RIEC' : peXcob(x).riec);
         REST_writeXmlLine( 'RIED' : peXcob(x).ried );
         REST_writeXmlLine( 'RMRS' : %char(peXcob(x).rmrs));
         REST_writeXmlLine( 'SACO'
                          : SVPREST_editImporte(peXcob(x).saco));
         REST_writeXmlLine( 'SMAX'
                          : SVPREST_editImporte(peXcob(x).smax));
         REST_writeXmlLine( 'SMIN'
                          : SVPREST_editImporte(peXcob(x).smin));
         REST_writeXmlLine( 'XCOB' : %char(peXcob(x).xcob));
        REST_endArray( 'PEXCOB' );
       endsr;

