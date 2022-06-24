     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSPNSI : Numerar Siniestro                                   *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        27/10/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspono_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
     D request         ds                  likeds(wspnsi_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D penmro          s              7p 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D peSini          s              7  0

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       *inlr = *on;

       // Inicio

        options = 'path=numerarSiniestro +
                   allowmissing=yes allowextra=yes case=any';

        REST_getEnvVar('REQUEST_METHOD':peValu);

        if %trim(peValu) <> 'POST';
           REST_writeHeader( 405
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit  );
           REST_end();
           SVPREST_end();
           return;
        endif;

       // Lectura y Parseo


        if REST_getEnvVar('WSPNSI_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPNSI_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

        buffer = %xlate( min : may : buffer );

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          @@repl = 'wspnsi_t';
          SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                       : 'RPG0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'RPG0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endmon;

       // -------------------------------------
       // Control sobre los parámetros enviados
       // -------------------------------------

         select;

       // Empresa recibida debe existir.

           when SVPEMP_getDatosDeEmpresa( request.empresa
                                      : *omit ) = *off;
             rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0113'
                             : peMsgs
                             : *omit
                             : *omit );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0113'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
             return;

       // Sucursal recibida debe existir.

           when SVPSUC_getDatosDeSucursal( request.empresa
                                       : request.sucursal
                                       : *omit ) = *off ;
             rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0114'
                             : peMsgs
                             : *omit
                             : *omit );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0114'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
             return;

       // La Rama recibida debe existir.

           when SVPTAB_chkSet001( request.rama ) = *on ;
             rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'RAM0001'
                             : peMsgs
                             : *omit
                             : *omit );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'RAM0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
             return;

       // El número de operación recibido no debe estar numerado

           when SVPSIN_getSiniestroDesdeNops( request.empresa
                                            : request.sucursal
                                            : request.rama
                                            : request.nroOperStro ) <> *zeros ;
             rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN1003'
                             : peMsgs
                             : *omit
                             : *omit );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN1003'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
             return;

       //  Los pasos necesarios deben estar completos

           when SVPSI1_chkPasoDeTrabajo( request.empresa
                                       : request.sucursal
                                       : request.rama
                                       : pesini
                                       : request.nroOperStro ) = *off;
             rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN1004'
                             : peMsgs
                             : *omit
                             : *omit );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN1004'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
             return;

         endsl;

       // Llamo a programa que devuelve el Número de Siniestro...

       pesini = SVPSI1_numeraAltaSiniestro( request.empresa
                                          : request.sucursal
                                          : request.rama
                                          : request.nroOperStro );


       REST_writeHeader( 201
                       : *omit
                       : *omit
                       : *omit
                       : *omit
                       : *omit
                       : *omit );

       REST_writeEncoding();

       // Armo Salida

       REST_startArray( 'numerarSiniestro' );

                  REST_writeXmlLine( 'empresa'
                                   : request.empresa );
                  REST_writeXmlLine( 'sucursal'
                                   : request.sucursal );
                  REST_writeXmlLine( 'rama'
                                   : %char(request.rama) );
                  REST_writeXmlLine( 'nroOperStro'
                                   : %char(request.nroOperStro) );
                  REST_writeXmlLine( 'nroSiniestro'
                                   : %char(pesini) );
       REST_endArray  ( 'numerarSiniestro' );

       REST_end();

       // Descargo Programa

       return;
