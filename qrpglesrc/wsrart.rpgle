     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H*option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRART: QUOM Versión 2                                       *
      *         Lista de cuetionarios                                *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        *10-Sep-2019            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      * SGF 17/05/21: Agrego pop up.                                 *
      * SGF 29/06/21: Agrego tiporeporte.                            *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpweb_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D arcd            s              6a
     D tipo            s              1a

     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc1             s             10i 0

     D CRLF            c                   x'0d25'

     D peMsgs          ds                  likeds(paramMsgs)
     D peDsWb          ds                  likeds( dsParamWeb_t )
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
     D peArcd          s              6  0
     D @tipoRepo       s              3a

      * Estructuras ------------------------------------------------ *
     D @@DsAr          ds                  likeds( dsset620_t ) dim(9999)
     D @@DsRa          ds                  likeds( dsset621_t ) dim( 2 )

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
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       monitor;
         peArcd = %dec( arcd : 6 : 0 );
       on-error;
         peArcd = 0;
       endmon;

       tipo = %xlate( min : may : tipo );
       if ( tipo <> 'T' and tipo <> 'W' );
          tipo = 'T';
       endif;

       clear @@DsAr;
       if tipo = 'W';
         if peArcd = 0;
           rc = SVPART_getArticulosWeb( @@DsAr : cReg : *omit );
         else;
           rc = SVPART_getArticulosWeb( @@DsAr : cReg : peArcd );
         endif;
       else;
         if peArcd = 0;
           rc = SVPART_getArticulos( @@DsAr : cReg : *omit );
         else;
           rc = SVPART_getArticulos( @@DsAr : cReg : peArcd );
         endif;
       endif;

       if not rc;
         rc = REST_writeHeader( 204
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
       REST_startArray( 'articulos' );
       for x = 1 to cReg;
         REST_startArray( 'articulo' );
           REST_writeXmlLine('codigo'
                            : %editw(@@DsAr( x ).t@arcd :'    0 ' ));
           REST_writeXmlLine('descCorta'
                            : %trim(@@DsAr( x ).t@arn1));
           REST_writeXmlLine('descLarga'
                            : %trim(@@DsAr( x ).t@arno));
           REST_writeXmlLine('libre'
                            : %trim(@@DsAr( x ).t@free));
           if @@DsAr( x ).t@bloq = '1';
             REST_writeXmlLine('bloqueado' : 'S');
           else;
             REST_writeXmlLine('bloqueado' : 'N');
           endif;

           if SVPWEB_getParametrosWeb2( empr
                                      : sucu
                                      : @@DsAr( x ).t@arcd
                                      : *omit
                                      : peDsWb              );
              REST_writeXmlLine('showCotizacion' : peDsWb.T@SHCO);
              REST_writeXmlLine('pathCotizacion' : peDsWb.T@PACO);
              REST_writeXmlLine('linkCotizacion' : peDsWb.T@LICO);
              REST_writeXmlLine('showEmision' : peDsWb.T@SHEM);
              REST_writeXmlLine('pathEmision' : peDsWb.T@PAEM);
              REST_writeXmlLine('linkEmision' : peDsWb.T@LIEM);
            else;
              REST_writeXmlLine('showCotizacion' : *blanks);
              REST_writeXmlLine('pathCotizacion' : *blanks);
              REST_writeXmlLine('linkCotizacion' : *blanks);
              REST_writeXmlLine('showEmision' : *blanks);
              REST_writeXmlLine('pathEmision' : *blanks);
              REST_writeXmlLine('linkEmision' : *blanks);
           endif;
           select;
            when  @@DsAr( x ).t@arcd = 1203 or
                  @@DsAr( x ).t@arcd = 1006;
                  @tipoRepo = 'SEM';
            when  @@DsAr( x ).t@arcd = 1303 or
                  @@DsAr( x ).t@arcd = 1306 or
                  @@DsAr( x ).t@arcd = 1205 or
                  @@DsAr( x ).t@arcd = 1206;
                  @tipoRepo = 'MYW';
            other;
                  @tipoRepo = 'ANU';
           endsl;
           REST_writeXmlLine('tipoReporte': @tipoRepo);
           if SVPART_getArticuloRama( @@DsAr( x ).t@arcd
                                    : @@DsRa : cRe2 : *omit );
             REST_startArray( 'ramas' );
             for z = 1 to cRe2;
               REST_startArray( 'rama' );
               REST_writeXmlLine('codigo' :
                                 %editW( @@DsRa( z ).t@rama :'0 ' ));
               REST_writeXmlLine('grupo'
                                : SVPWS_getGrupoRama(
                                  @@DsRa( z ).t@rama ));
               REST_writeXmlLine('secRamaArticulo'
                                :%char( @@DsRa( z ).t@arse ));
               if SVPART_chkScoring( @@DsAr( x ).t@arcd
                                   : @@DsRa( z ).t@rama
                                   : @@DsRa( z ).t@arse );

                 REST_writeXmlLine('scoring' : 'S');
               else;
                 REST_writeXmlLine('scoring' : 'N');
               endif;
               REST_endArray('rama');
             endfor;
             REST_endArray('ramas');
           endif;
         REST_endArray('articulo');
        endfor;
        REST_endArray('articulos');

       return;
