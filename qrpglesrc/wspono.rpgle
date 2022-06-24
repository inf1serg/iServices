     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSPONO : Retorna Número de Operación de Siniestro            *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        29/09/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspono_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
     D request         ds                  likeds(wspono_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D penmro          s              7p 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D @@Ds60          ds                  likeds(dsGti960_t)

     D                sds
     D  ususer               254    263
     D  ususr2               358    367

     d sav900          pr                  extpgm('SAV900')
     D numero                         7  0
     D endpgm1                        3a   const

     D SAV901          pr                  extpgm('SAV901')
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  peEpgm                        3a   const
     D  peEmpr                        1a   const options(*omit:*nopass)
     D  peSucu                        2a   const options(*omit:*nopass)

      /free

       *inlr = *on;

       // Inicio

        options = 'path=nroOperacion';

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

        if REST_getEnvVar('WSPONO_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPONO_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          @@repl = 'wspono_t';
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

       // Llamo a programa que devuelve Número de Siniestro

         sav900 (penmro:*blanks);
         if penmro <> 0;
            SAV901( request.rama
                  : 0
                  : peNmro
                  : *blanks
                  : 'A'
                  : 'CA'    );
            SAV901( request.rama
                  : 0
                  : peNmro
                  : 'FIN'
                  : *omit
                  : *omit   );
         endif;

       // Cargo tabla de Siniestros BPM
       @@Ds60.g0Empr = 'A';
       @@Ds60.g0Sucu = 'CA';
       @@Ds60.g0Rama = request.rama;
       @@Ds60.g0Nops = penmro;
       @@Ds60.g0User = ususr2;
       @@Ds60.g0Date = %dec(%date():*iso);
       @@Ds60.g0Time = %dec(%time():*iso);

       SVPSIN_setGti960(@@Ds60);

       REST_writeHeader( 201
                       : *omit
                       : *omit
                       : *omit
                       : *omit
                       : *omit
                       : *omit );

       REST_writeEncoding();

       // Armo Salida

       REST_startArray( 'nroOperacion' );
                  REST_writeXmlLine( 'rama'
                                   : %char(request.rama) );
                  REST_writeXmlLine( 'nroOperStro'
                                   : %char(penmro) );
       REST_endArray  ( 'nroOperacion');

       REST_end();

       // Descargo Programa

         sav900 (penmro:'FIN') ;

       return;
