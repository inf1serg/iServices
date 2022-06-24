     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLLO: BPM                                                  *
      *         Lista de localidades                                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Jul-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fgntloc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D tipo            s              1a
     D copo            s              5a

     D peCopo          s              5  0
     D x               s             10i 0

     D rc              s              1n
     D peLocaC         s             10i 0
     D peLoca          ds                  likeds(gntloc_t) dim(15000)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D k1tloc          ds                  likerec(g1tloc:*key)

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
       if tipo <> 'T' and tipo <> 'W';
          tipo = 'T';
       endif;

       peCopo = 0;
       if url <> *blanks;
          copo = REST_getNextPart(url);
          monitor;
             peCopo = %dec(copo:5:0);
           on-error;
             peCopo = 0;
          endmon;
       endif;

       x = 0;

       REST_writeHeader();
       REST_writeEncoding();

       if tipo = 'T';
          WSLTAB_listaLocalidades( peLoca : peLocaC );
       endif;
       if tipo = 'W';
          WSLTAB_listaLocalidadesWeb( peLoca : peLocaC );
       endif;

       if peCopo <> 0;
          for x = 1 to peLocaC;
              if peLoca(x).copo <> peCopo;
                 peLoca(x).copo = -1;
              endif;
          endfor;
       endif;

       REST_startArray( 'localidades' );

       for x = 1 to peLocaC;
        if peLoca(x).copo <> -1;
        REST_startArray( 'localidad' );
         REST_writeXmlLine( 'codigoPostal' : %editc(peLoca(x).copo:'Z'));
         REST_writeXmlLine( 'nombre'       : %trim(peLoca(x).loca)    );
         REST_writeXmlLine( 'sufijoCodPos' : %char(peLoca(x).cops)    );
         REST_writeXmlLine( 'codProv'      : %trim(peLoca(x).proc)    );
        REST_endArray  ( 'localidad' );
        endif;
       endfor;

       REST_endArray  ( 'localidades' );


       return;

