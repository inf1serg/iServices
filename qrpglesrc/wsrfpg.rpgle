     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRFPG: QUOM Versión 2                                       *
      *         Lista de formas de pagos.                            *
      * ------------------------------------------------------------ *
      * Luis Roberto Gomez                   *11-Jun-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'

     D uri             s            512a
     D tipo            s              1a
     D cfpg            s              1a
     D url             s           3000a   varying
     D x               s             10i 0
     D rc              s              1n
     D @@cfpg          s              1  0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)

     d WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     d  msg                         512a   const
     d  peMsg          s            512a

     d sleep           pr            10u 0 extproc('sleep')
     d  secs                         10u 0 value

      * ------------------------------------------------------------ *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
      * Estructuras ------------------------------------------------ *
     D @@DsFpg         ds                  likeds( dsGntfpg_t ) dim( 99 )
     D @@DsFpgC        s             10i 0

      /free

       *inlr = *on;
        //peMsg = PsDs.JobName;
        //WSLOG( peMsg );
        //peMsg = PsDs.JobUser;
        //WSLOG( peMsg );
        //peMsg = %editc(PsDs.JobNbr:'X');
        //WSLOG( peMsg  );
        //sleep(60);

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
       cfpg = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       tipo = %xlate( min : may : tipo );
       if ( tipo <> 'T' and tipo <> 'W' );
          tipo = 'T';
       endif;

       if %check('0123456789':cfpg) <> *zeros;
          cfpg = '0';
       endif;

       @@cfpg = %int( cfpg );

       // Busca lista de formas de pagos...

       if @@cfpg = 0;
          rc = SVPTAB_getFormasDePago( tipo: @@DsFpg : @@DsFpgC : *omit );
       else;
          rc = SVPTAB_getFormasDePago( tipo: @@DsFpg : @@DsFpgC : @@cfpg);
       endif;

       if not rc;
         REST_writeHeader( 204
                    : *omit
                    : *omit
                    : 'TAB0001'
                    : 40
                    : 'No se encontraron datos para informar'
                    : 'Verifique la informacion solicitada ') ;

         REST_end();
         return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

        REST_startArray('formasDePago');
          for x = 1 to @@DsFpgC;
              REST_startArray( 'formaDePago' );
                REST_writeXmlLine( 'codigo' : %char( @@DsFpg(x).fpcfpg ) );
                REST_writeXmlLine( 'descripcion' : @@DsFpg(x).fpdefp );
              REST_endArray( 'formaDePago' );
          endfor;
        REST_endArray('formasDePago');

       return;
      /end-free

