     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSTBE: BPM                                                  *
      *         Lista Tipo de Beneficiario.                          *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *20-Ago-2021            *
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
     D empr            s              1a
     D sucu            s              2a

     D x               s             10i 0

     D rc              s              1n
     D peDsBeC         s             10i 0
     D peDsBe          ds                  likeds(dsGnttbe_t) dim(99)

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

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);

       clear peDsBe;
       clear peDsBeC;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'beneficiarios' );
       if SVPTAB_listaTipoBeneficiario( empr : sucu : peDsBe : peDsBeC :
                                        *omit );
         for x = 1 to peDsBeC;
           REST_startArray( 'beneficiario' );
             REST_writeXmlLine( 'empresa' : peDsBe(x).g1Empr );
             REST_writeXmlLine( 'sucursal' : peDsBe(x).g1Sucu );
             REST_writeXmlLine( 'tipoBeneficiario' : %trim(peDsBe(x).g1Tben) );
             REST_writeXmlLine( 'descripBeneficiario' :
                                 %trim(peDsBe(x).g1Dben) );
             REST_writeXmlLine( 'cantDiasOPPagar1' : %char(peDsBe(x).g1Dia1));
             REST_writeXmlLine( 'cantDiasOPPagar2' : %char(peDsBe(x).g1Dia2));
             REST_writeXmlLine( 'cantDiasOPPagar3' : %char(peDsBe(x).g1Dia3));
           REST_endArray  ( 'beneficiario' );
         endfor;
       endif;
       REST_endArray  ( 'beneficiarios' );

       return;

