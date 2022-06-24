     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSSSXA: QUOM Versión 2                                       *
      *         Consulta de Siniestralidad por Asegurado             *
      * ------------------------------------------------------------ *
      * Astiz Facundo                        *12/10/2021*            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      *--- Archivos ------------------------------------------------ *
     FPahscd13  uf   e           k disk    usropn
      *------------------------------------------------------------- *

      *--- Copy H -------------------------------------------------- *
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

      *--- WSSSX1 -------------------------------------------------- *
     D Siniestralidad  pr                  extpgm('WSSSX1')
     D peEmpr                         1
     D peSucu                         2
     D peRama                         2  0
     D peSini                         7  0
     D peNops                         7  0
      *------------------------------------------------------------- *

      *--- Parametros de Entrada ----------------------------------- *
     D empr            s              1
     D sucu            s              2
     D asen            s              7
      *------------------------------------------------------------- *

      *--- Variables de Trabajo ------------------------------------ *
     D p@Asen          s              7  0
     D @oneTime        s               n   inz(*off)
      *------------------------------------------------------------- *

      *--- Keys ---------------------------------------------------- *
     D k1scd13         ds                  likeRec(p1hscd13:*Key)
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
       asen = REST_getNextPart(url);

       empr = %xlate(min : may: empr);
       sucu = %xlate(min : may: sucu);

       //Validacion

       // Codigo de Asegurado       Numerico 7/0
       monitor;
          p@asen = %dec(asen :7 :0);
       on-error;
          @@repl = asen;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'DAF0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'DAF0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2  );
          REST_end();
          SVPREST_end();
          return;
       endmon;

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

       //Asegurado debe existir
       if SVPASE_chkAse(p@asen) = *off;
          @@repl = asen;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'PRW0001'
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
          if not %open(pahscd13);
             open pahscd13;
          endif;

          k1scd13.cdEmpr = empr;
          k1scd13.cdSucu = sucu;
          k1scd13.cdAsen = p@Asen;

          setgt %kds(k1scd13 : 3) pahscd13;
          readpe %kds(k1scd13 : 3) pahscd13;
          dow not %eof;
             //para mostrar nro daf y nombre entro por unica vez
             if @oneTime = *off;
                REST_startArray( 'siniestros');
                @oneTime = *on;
             endif;
             if cdSini <> 0;
                unlock pahscd13;
                   callp Siniestralidad (cdEmpr
                                        : cdSucu
                                        : cdRama
                                        : cdSini
                                        : cdNops);
             endif;
          readpe %kds(k1scd13 : 3) pahscd13;
          enddo;

          if %open(pahscd13);
             close pahscd13;
          endif;
       endsr;
      *------------------------------------------------------------- *
