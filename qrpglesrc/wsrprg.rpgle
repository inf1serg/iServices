     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H*option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPRG: QUOM Versión 2                                       *
      *         Lista de preguntas por cuestionario                  *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        *11-Sep-2019            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D taaj            s              2a
     D cosg            s              4a
     D tipo            s              1a

     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0

     D CRLF            c                   x'0d25'

     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D x               s             10i 0

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
      * Variables -------------------------------------------------- *
     D cReg            s             10i 0
     D peTaaj          s              2  0

      * Estructuras ------------------------------------------------ *
     D @@DsPr          ds                  likeds( set2371_t  ) dim( 200 )

      /free

       *inlr = *on;

      //peMsg = PsDs.JobName;
      //WSLOG( peMsg );
      //peMsg = PsDs.JobUser;
      //WSLOG( peMsg );
      //peMsg = %editc(PsDs.JobNbr:'X');
      //WSLOG( peMsg  );
      ////sleep(60);

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
       taaj = REST_getNextPart(url);
       cosg = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       monitor;
         peTaaj = %dec( taaj : 2 : 0 );
       on-error;
         peTaaj = 0;
       endmon;

       tipo = %xlate( min : may : tipo );
       if ( tipo <> 'T' and tipo <> 'W' );
          tipo = 'T';
       endif;

       if cosg = ' ';
         SVPTAB_getPreguntas( peTaaj : @@DsPr : cReg : *omit );
       else;
         SVPTAB_getPreguntas( peTaaj : @@DsPr : cReg : cosg );
       endif;

       if cReg = 0;
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

       //Armado de XML ...
       //Armado de XML ...
       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'preguntas' : '*BEG' );
        for x = 1 to cReg;
          REST_startArray( 'pregunta' );

             REST_writeXmlLine('codigoItem'
                              : %trim(@@DsPr( x ).t@cosg));
             REST_writeXmlLine('descripcionItem'
                              : %trim(@@DsPr( x ).t@cosd ));

             if @@DsPr( x ).t@cman = '1';
               @@DsPr( x ).t@cman = 'S';
             else;
               @@DsPr( x ).t@cman = 'N';
             endif;
             REST_writeXmlLine('obligatoria'
                              : %trim(@@DsPr( x ).t@cman ));

             REST_writeXmlLine('respuestaValida'
                              : %trim(@@DsPr( x ).t@mar1 ));

             if @@DsPr( x ).t@mar2 = '1';
               @@DsPr( x ).t@mar2 = 'S';
             else;
               @@DsPr( x ).t@mar2 = 'N';
             endif;
             REST_writeXmlLine('aceptaCantidad'
                              : %trim(@@DsPr( x ).t@mar2 ));

             REST_writeXmlLine('grupo'
                              : %trim(@@DsPr( x ).t@mar4 ));
          REST_endArray( 'pregunta' );
        endfor;
       REST_writeXmlLine( 'preguntas' : '*END' );


       return;

