     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H*option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCUE: QUOM Versión 2                                       *
      *         Lista de Scoring                                     *
      *         Preguntas y respuestas                               *
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
     D z               s             10i 0

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
     D cRe2            s             10i 0
     D peTaaj          s              2  0

      * Estructuras ------------------------------------------------ *
     D @@DsCu          ds                  likeds( set2370_t  ) dim( 99 )
     D @@DsPr          ds                  likeds( set2371_t  ) dim( 200 )

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

       if peTaaj = 0;
         SVPTAB_getCuestionarios( @@DsCu : cReg : *omit );
       else;
         SVPTAB_getCuestionarios( @@DsCu : cReg : peTaaj );
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
       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'scorings' : '*BEG' );
        for x = 1 to cReg;
          REST_startArray( 'scoring' );
            REST_writeXmlLine('codigoTabla'
                             : %editw(@@DsCu( x ).t@taaj :'0 ' ));
            REST_writeXmlLine('descripcionTabla'
                             : @@DsCu( x ).t@tabn );

            //Obtener preguntas...
           if cosg = ' ';
            SVPTAB_getPreguntas( @@DsCu(x).t@taaj : @@DsPr : cRe2 : *omit );
           else;
            SVPTAB_getPreguntas( @@Dscu(x).t@taaj : @@DsPr : cRe2 : cosg );
           endif;
            REST_startArray( 'preguntas' );
            for z = 1 to cRe2;
              REST_startArray( 'pregunta' );

                REST_writeXmlLine('codigoItem'
                                 : %trim(@@DsPr( z ).t@cosg));
                REST_writeXmlLine('descripcionItem'
                                 : %trim(@@DsPr( z ).t@cosd ));
                if @@DsPr( z ).t@cman = '1';
                  @@DsPr( z ).t@cman = 'S';
                else;
                  @@DsPr( z ).t@cman = 'N';
                endif;
                REST_writeXmlLine('obligatoria'
                                 : %trim(@@DsPr( z ).t@cman ));
                REST_writeXmlLine('respuestaValida'
                                 : %trim(@@DsPr( z ).t@mar1 ));
                if @@DsPr( z ).t@mar2 = '1';
                  @@DsPr( z ).t@mar2 = 'S';
                else;
                  @@DsPr( z ).t@mar2 = 'N';
                endif;
                REST_writeXmlLine('aceptaCantidad'
                                 : %trim(@@DsPr( z ).t@mar2 ));
                REST_writeXmlLine('grupo'
                                 : %trim(@@DsPr( z ).t@mar4 ));
              REST_endArray( 'pregunta' );
            endfor;
          REST_endArray( 'preguntas' );
          REST_endArray( 'scoring' );
        endfor;
       REST_writeXmlLine( 'scorings' : '*END' );

       return;

