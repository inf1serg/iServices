     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H*option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRGAR: QUOM Versión 2                                       *
      *         Lista de Grupos - Artículos                          *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        *11-Dic-2019            *
      * ------------------------------------------------------------ *
      * SET639 : Grupos.                                             *
      * SET630W: Artículos - Grupos                                  *
      *                                                              *
      * ------------------------------------------------------------ *
      * Fecha      Usuario     Motivo                                *
      * ------------------------------------------------------------ *
      * 2020/02/05 INFSER1     Cambia Servicio                       *
      *                        SVPART_getGrupo  por SVPART_getGrupo2 *
      *                        por incorporacion de campo t@icon en  *
      *                        tabla SET639                          *
      * 2020/02/06 NWN         Se cambia el TAG 'desCorta' x         *
      *                        'descCorta'                           *
      *                        Lo mismo para 'desLarga' x            *
      *                        'descLarga'                           *
      * 2021/04/15 JSN         Se elimina llamado al procedimiento   *
      *                        _getGrupo2 ya que el mismo lee el     *
      *                        set639 y se agregan nuevos tags       *
      *                        <showCotizacion>  <showEmision>       *
      *                        <pathCotizacion>  <pathEmision>       *
      *                        <linkCotizacion>  <linkEmision>       *
      * 2021/04/27 JSN         Se agrega filtro para mostrar articulo*
      * 2021/06/29 SGF         Agrego tiporeporte.                   *
      * 2021/10/20 SGF         Rompi 2021/04/15 JSN. Recompongo.     *
      * **************************************************************
     Fset639    if   e           k disk

      /copy './qcpybooks/svpweb_h.rpgle'
      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D garc            s              6a

     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc1             s              1n
     D @tipoRepo       s              3a

     D CRLF            c                   x'0d25'

     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D x               s             10i 0
     D z               s             10i 0
     D t               s             10i 0

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
     D cRe3            s             10i 0
     D peArcd          s              6  0
     D peGarc          s              6  0

      * Estructuras ------------------------------------------------ *

     D @@DsGr          ds                  likeds( dsset639_t1)
     D @@DsAr          ds                  likeds( dsset630w2_t ) dim(9999)
     D @@DsArt         ds                  likeds( dsset620_t ) dim(9999)
     D @@DsRa          ds                  likeds( dsset621_t ) dim(2)
     D @@DsWb          ds                  likeds( dsParamWeb_t )

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

       exsr Cabe_Grupos;
       setll *loval set639;
       read set639;
       dow not %eof( set639 );
          //clear @@DsGr;
          //rc = SVPART_getGrupo2( t@Garc: @@DsGr);
          clear @@DsAr;
          rc = SVPART_getGrupoArticulos( t@garc : @@DsAr : cRe3);
          if rc;
            exsr Cabe_Grupo;
            for t = 1 to cRe3;
              exsr Detalle_Articulo;
            endfor;
              exsr Cierra_Grupo;
          endif;
       read set639;
       enddo;
       exsr Cierra_Grupos;
       Return;

       //Armado de XML ...

       begsr Cabe_Grupos;

        REST_writeHeader();
        REST_writeEncoding();
        REST_startArray( 'Grupos' );

       endsr;

       Begsr Cierra_Grupos;

        REST_endArray('Grupos');

       endsr;

       Begsr Cabe_Grupo;

         REST_startArray( 'Grupo' );

           REST_writeXmlLine('codigo'
                            : %editc(t@Garc :'X'));
           REST_writeXmlLine('descripcion'
                            : %trim(t@Dgar));
           REST_writeXmlLine('Orden'
                            : %editc(t@orde :'X' ));
           REST_writeXmlLine('Icono'
                            : t@icon);
           REST_startArray( 'articulos' );

       endsr;

       Begsr Detalle_Articulo;


         rc = SVPART_getArticulo( @@DsAr(t).t@arcd : @@DsArt(t));

         if SVPWEB_getParametrosWeb2( empr
                                    : sucu
                                    : @@DsArt(t).t@arcd
                                    : *omit
                                    : @@DsWb            );

           if @@DsWb.t@Mar4 = '1';

             REST_startArray( 'articulo' );

              REST_writeXmlLine('codigo'
                               : %editc(@@DsArt(t).t@arcd:'X'));
              REST_writeXmlLine('descCorta'
                               : %trim(@@DsArt(t).t@arn1));
              REST_writeXmlLine('descLarga'
                               : %trim(@@DsArt(t).t@arno));
              REST_writeXmlLine('libre'
                               : %trim(@@DsArt(t).t@free));

              if @@DsArt(cRe3).t@bloq = '1';
                REST_writeXmlLine('bloqueado' : 'S');
              else;
                REST_writeXmlLine('bloqueado' : 'N');
              endif;
              REST_writeXmlLine('orden'
                               : %trim(@@DsArt(t).t@free));

              REST_startArray( 'ramas' );

               REST_startArray( 'rama' );
               if SVPART_getArticuloRama( @@DsAr(t).t@arcd
                                        : @@DsRa : cRe2 : *omit );
                 for z = 1 to cRe2;
                   REST_writeXmlLine('codigo' :
                                     %editW( @@DsRa( z ).t@rama :'0 ' ));
                   REST_writeXmlLine('grupo'
                                    : SVPWS_getGrupoRama(
                                      @@DsRa( z ).t@rama ));
                   REST_writeXmlLine('secRamaArticulo'
                                    :%char( @@DsRa( z ).t@arse ));
                   if SVPART_chkScoring( @@DsAr( cRe3 ).t@arcd
                                       : @@DsRa( z ).t@rama
                                       : @@DsRa( z ).t@arse );

                     REST_writeXmlLine('scoring' : 'S');
                   else;
                     REST_writeXmlLine('scoring' : 'N');
                   endif;
                 endfor;
               REST_endArray('rama');
               endif;
              REST_endArray('ramas');
              clear @@DsWb;
              if SVPWEB_getParametrosWeb2( empr
                                         : sucu
                                         : @@DsArt(t).t@arcd
                                         : *omit
                                         : @@DsWb            );

              REST_writeXmlLine('showCotizacion' : %trim(@@DsWb.t@Shco));
              REST_writeXmlLine('pathCotizacion' : %trim(@@DsWb.t@Paco));
              REST_writeXmlLine('linkCotizacion' : %trim(@@DsWb.t@Lico));
              REST_writeXmlLine('showEmision' : %trim(@@DsWb.t@Shem));
              REST_writeXmlLine('pathEmision' : %trim(@@DsWb.t@Paem));
              REST_writeXmlLine('linkEmision' : %trim(@@DsWb.t@Liem));
               else;
              REST_writeXmlLine('showCotizacion' : '0'                 );
              REST_writeXmlLine('pathCotizacion' : ' '                 );
              REST_writeXmlLine('linkCotizacion' : ' '                 );
              REST_writeXmlLine('showEmision' : '0'                 );
              REST_writeXmlLine('pathEmision' : ' '                 );
              REST_writeXmlLine('linkEmision' : ' '                 );
              endif;
           select;
            when  @@DsArt(t).t@arcd  = 1203 or
                  @@DsArt(t).t@arcd  = 1205 or
                  @@DsArt(t).t@arcd  = 1206 or
                  @@DsArt(t).t@arcd  = 1006;
                  @tipoRepo = 'SEM';
            when  @@DsArt(t).t@arcd  = 1303 or
                  @@DsArt(t).t@arcd  = 1306;
                  @tipoRepo = 'MYW';
            other;
                  @tipoRepo = 'ANU';
           endsl;
           REST_writeXmlLine('tipoReporte': @tipoRepo);
             REST_endArray('articulo');
           endif;
         endif;
       endsr;

       Begsr Cierra_Grupo;

          REST_endArray('articulos');
        REST_endArray('Grupo');

       endsr;

