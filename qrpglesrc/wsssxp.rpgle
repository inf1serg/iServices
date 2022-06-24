     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSSSXP: QUOM Versión 2                                       *
      *         Consulta de Siniestralidad por Patente               *
      * ------------------------------------------------------------ *
      * Astiz Facundo                        *12/10/2021*            *
      * ------------------------------------------------------------ *
      * David Tilatti                        *27/01/2022*            *
      * Descripcion: Se cambio la organizacion de la esposicion, a   *
      *              dominio y dentro del siniestro el Daf del titu_ *
      *              de poliza. El dominio es uno y pueden haber     *
      *              habido tenido uno o varios daf titulares de po_ *
      *              lizas en las que el componente siniestrado sea  *
      *              el dominio solicitado.                          *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      *--- Archivos ------------------------------------------------ *
     FPahsva06  if   e           k disk    usropn
      *------------------------------------------------------------- *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      *------------------------------------------------------------- *

      *--- Variables REST ------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)
      *------------------------------------------------------------- *

      *--- Parametros de Entrada ----------------------------------- *
     D empr            s              1
     D sucu            s              2
     D nmat            s             25
      *------------------------------------------------------------- *

      *--- WSSSX1 -------------------------------------------------- *
     D Siniestralidad  pr                  extpgm('WSSSX1')
     D peEmpr                         1
     D peSucu                         2
     D peRama                         2  0
     D peSini                         7  0
     D peNops                         7  0
      *------------------------------------------------------------- *

      *--- Variables de Trabajo ------------------------------------ *
     D @oneTime        s               n   inz(*off)
     D p@DsCd          ds                  likeds ( DsPahscd_t )
      *------------------------------------------------------------- *

      *--- Keys ---------------------------------------------------- *
     D k1hsva          ds                  likeRec(p1hsva:*Key)
      *------------------------------------------------------------- *

      *--- Estructura Interna -------------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)
      *------------------------------------------------------------- *

      *--- Variables de conversion --------------------------------- *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
      *------------------------------------------------------------- *

       //------------------------------------------------------//
      /free

       *inlr = *on;


       //Inicio

       // FIJO: Recuperar la URL desde conde se lo llamo
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

       // FIJO: Para la URI a URL
       url = %trim(uri);

       // Obtener los parámetros de la URL
       // Esto es FIJO y es una ejecución por CADA
       // parámetro de la URL
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nmat = REST_getNextPart(url);

       empr = %xlate(min : may: empr);
       sucu = %xlate(min : may: sucu);
       nmat = %xlate(min : may: nmat);

       //Validacion

       //Empresa debe existir
       if SVPEMP_getDatosDeEmpresa(empr) = *off;
          @@repl = empr;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0113'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       //Sucursal debe existir
       if SVPVAL_sucursal(empr: sucu) = *off;
          @@repl = sucu;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0113'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       //Patente no blanco
       if nmat = *blanks;
          @@repl = nmat;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0050'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0050'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endif;

       // FIJO: Grabar SIEMPRE el header y el encoding
       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'siniestralidad');

           exsr srProg;

         if @oneTime = *on;
            REST_endArray( 'siniestros');
         endif;
       REST_endArray( 'siniestralidad');
       REST_end();
      *------------------------------------------------------------- *
       begsr srprog;
          if not %open(Pahsva06);
             open Pahsva06;
          endif;

          k1hsva.vaEmpr = empr;
          k1hsva.vaSucu = sucu;
          k1hsva.vaNmat = nmat;

          setgt %kds(k1hsva : 3) Pahsva06;
          readpe %kds(k1hsva : 3) Pahsva06;
          dow not %eof;
             //para mostrar nro daf y nombre entro por unica vez
             if @oneTime = *off;
                if SVPSIN_getCaratula2( vaEmpr
                                      : vaSucu
                                      : vaRama
                                      : vaSini
                                      : p@DsCd ) = *on;
                   REST_startArray( 'siniestros');
                   @oneTime = *on;
                endif;
             endif;
             if vaSini <> 0;
                callp Siniestralidad ( vaEmpr
                                     : vaSucu
                                     : vaRama
                                     : vaSini
                                     : vaNops);
             endif;
          readpe %kds(k1hsva : 3) Pahsva06;
          enddo;

          if %open(Pahsva06);
             close Pahsva06;
          endif;
       endsr;
      *------------------------------------------------------------- *
