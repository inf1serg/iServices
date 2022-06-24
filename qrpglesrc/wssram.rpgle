     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSRAM: BPM                                                  *
      *         Lista de Ramas                                       *
      * ------------------------------------------------------------ *
      * Nestor Nestor                        *31-Ago-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D tipo            s              1a

     D x               s             10i 0

     D rc              s              1n
     D peDsRaC         s             10i 0
     D peDsRa          ds                  likeds(dsset001_t) dim(99)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)


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

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'ramas' );
        if SVPTAB_ListaRamas( peDsRa : peDsRaC );
         for x = 1 to peDsRaC;
           REST_startArray( 'rama' );
             REST_writeXmlLine( 'codigoRama'
                                : %editc(peDsRa(x).t@rama:'Z'));
             REST_writeXmlLine( 'ramaEquivalente'
                                : %editc(peDsRa(x).t@rame:'Z'));
             REST_writeXmlLine( 'descripcionRama'
                                : %trim(peDsRa(x).t@ramd) );
             REST_writeXmlLine( 'descripcionAbreviada'
                                : %trim(peDsRa(x).t@ramb) );
             REST_writeXmlLine( 'polizaSinIntermed'
                                : %trim(peDsRa(x).t@posi) );
             REST_writeXmlLine( 'comprobarPertenencia'
                                : %trim(peDsRa(x).t@pert) );
             REST_writeXmlLine( 'admiteVigAbierta'
                                : %trim(peDsRa(x).t@osut) );
             REST_writeXmlLine( 'codAreaTecnica'
                                : %editc(peDsRa(x).t@artc:'Z'));
             REST_writeXmlLine( 'riesgoEnCurso'
                                : %trim(peDsRa(x).t@rcsn) );
             REST_writeXmlLine( 'prevIncobrabilidad'
                                : %trim(peDsRa(x).t@pisn) );
             REST_writeXmlLine( 'ajustaSumaAsegAvisoVto'
                                : %trim(peDsRa(x).t@mar1) );
             REST_writeXmlLine( 'coeficienteA'
                                : %editc(peDsRa(x).t@casa:'Z'));
             REST_writeXmlLine( 'procesarXWorkflow'
                                : %trim(peDsRa(x).t@mar2) );
             REST_writeXmlLine( 'nvoClausuladoSSN'
                                : %trim(peDsRa(x).t@mar3) );
             REST_writeXmlLine( 'procPolizaElectronica'
                                : %trim(peDsRa(x).t@mar4) );
             REST_writeXmlLine( 'procesarWeb'
                                : %trim(peDsRa(x).t@mar5) );
             REST_writeXmlLine( 'codigoRamoSSN'
                                : %editc(peDsRa(x).t@rasu:'Z'));
             REST_writeXmlLine( 'incluyeWeb'
                                : %trim(peDsRa(x).t@mweb) );
             REST_writeXmlLine( 'vencimiento'
                                : %trim(peDsRa(x).t@mvto) );
             REST_writeXmlLine( 'cantBienes'
                                : %editc(peDsRa(x).t@canb:'Z'));
             REST_writeXmlLine( 'ramaSSNInspeccion'
                                : %editc(peDsRa(x).t@rssn:'Z'));
             REST_writeXmlLine( 'descripPlanesMundiales'
                                : %trim(peDsRa(x).t@drpm) );
           REST_endArray  ( 'rama' );
         endfor;
        endif;
       REST_endArray  ( 'ramas' );

       return;

