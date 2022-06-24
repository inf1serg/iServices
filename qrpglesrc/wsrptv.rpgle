     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPTV: QUOM Versión 2                                       *
      *         Lista de parentescos de Vida                         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *27-Abr-2020            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'

     D uri             s            512a
     D tipo            s              1a

     D url             s           3000a   varying
     D rc              s              1n
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

     D peT069          ds                  likeds(set069_t) dim(999)
     D p2T069          ds                  likeds(set069_t) dim(999)
     D peT069C         s             10i 0
     D p2T069C         s             10i 0
     D x               s             10i 0

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
       tipo = REST_getNextPart(url);

       if ( tipo <> 'T' and tipo <> 'W' );
          tipo = 'T';
       endif;

       clear peT069;
       clear p2T069;
       peT069C = 0;
       p2T069C = 0;
       rc = SVPTAB_getParentescoVida( peT069 : peT069C );

       for x = 1 to peT069C;
           if (tipo = 'T' or
               tipo = 'W' and peT069(x).t@mweb = '1');
               p2T069c += 1;
               p2T069(p2T069C) = peT069(x);
           endif;
       endfor;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'parentescosVida' );

       for x = 1 to p2T069C;
        REST_startArray( 'parentescoVida' );
         REST_writeXmlLine( 'codigo'      : %char(p2T069(x).t@paco) );
         REST_writeXmlLine( 'descripcion' : %trim(p2T069(x).t@pade) );
        REST_endArray( 'parentescoVida' );
       endfor;

       REST_endArray( 'parentescosVida' );

       return;
