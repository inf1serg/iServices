     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSLO1: BPM                                                  *
      *         Lista de Localidades Cap. Fed.                       *
      * ------------------------------------------------------------ *
      * Facundo Astiz                        *01-Dic-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      *------------------------------------------------------------- *

      *--- Variables REST ------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n

     D rc1             s             10i 0
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)

      *--- Variables de Entrada ------------------------------------ *
     D Copo            s              5
     D peCopo          s              5p 0

      *--- Variables de Trabajo ------------------------------------ *
     D @@DsL1          ds                  likeds(dsgntlo1_t) dim(9999)
     D @@DsL1C         s             10i 0
     D @x              s             10i 0


      *--- Estructura Interna -------------------------------------- *
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      *------------------------------------------------------------- *
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
       peCopo = 0;
       if url <> *blanks;
          copo = REST_getNextPart(url);
          monitor;
             peCopo = %dec(copo:5:0);
          on-error;
             @@repl = copo;
             rc1 = SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'RPG0001'
                                : peMsgs
                                : %trim(@@repl)
                                : %len(%trim(@@repl)) );
             REST_writeHeader( 204
                             : *omit
                             : *omit
                             : 'RPG0001'
                             : peMsgs.peMsev
                             : peMsgs.peMsg1
                             : peMsgs.peMsg2 );
             REST_end();
             return;
          endmon;
       endif;

       // ------------------------------------------
       // Recupera Informacion
       // ------------------------------------------

        if peCopo <> *zeros;
           if SVPTAB_getGntlo1( @@DsL1
                              : @@DsL1C
                              : peCopo ) = *off;
             @@repl = copo;
             rc1 = SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'LOC0001'
                                : peMsgs
                                : %trim(@@repl)
                                : %len(%trim(@@repl)) );
             REST_writeHeader( 400
                             : *omit
                             : *omit
                             : 'LOC0001'
                             : peMsgs.peMsev
                             : peMsgs.peMsg1
                             : peMsgs.peMsg2 );
              REST_end();
              return;
           endif;
        else;
           SVPTAB_getGntlo1( @@DsL1
                           : @@DsL1C
                           : *omit);
        endif;

        // ------------------------------------------
        // Armo XML
        // ------------------------------------------

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'localidades' );

       for @x = 1 to @@DsL1C;
         REST_startArray( 'localidad' );
           REST_writeXmlLine( 'codigoPostal' : %char(@@Dsl1(@x).l1Copo ) );
           REST_writeXmlLine( 'sufijoCodPos' : %char(@@Dsl1(@x).l1Cops ) );
           REST_writeXmlLine( 'secuencia'    : %char(@@Dsl1(@x).l1Psec ) );
           REST_writeXmlLine( 'calle'        : @@Dsl1(@x).l1Malo         );
           REST_writeXmlLine( 'alturaDesde'  : %char( @@Dsl1(@x).l1Nrd1) );
           REST_writeXmlLine( 'alturaHasta'  : %char( @@Dsl1(@x).l1Nrd2) );

         REST_endArray( 'localidad' );
       endfor;

       REST_endArray( 'localidades' );
       REST_end();

       return;

