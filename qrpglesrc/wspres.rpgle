      * ************************************************************ *
      * WSPRES: QUOM Version 2 - Servicio POST                       *
      *         Rehabilitar Siniestro.                               *
      * ------------------------------------------------------------ *
      * Facundo Astiz                        *03-Dic-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
        ctl-opt
         option(*srcstmt) actgrp(*new) dftactgrp(*no)
         bnddir('HDIILE/HDIBDIR')
         alwnull(*usrctl);

      * -- Copy H --
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'

      * -- Prototipo Validador Caratula --
     D WSPVST          pr                  ExtPgm('WSPVST')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  peMsgf                        6a
     D  peIdms                        7a

      * -- Variables de Arquitectura --
       dcl-ds request likeds(caratula_t);
       dcl-s buffer   char(65535);
       dcl-s options  char(100);
       dcl-s peValu   char(1024);
       dcl-s rc       int(10);

      * -- Variables de Mensajes Fin Error--
       dcl-s @@repl   char(65535);
       dcl-s @@CodM   char(7);

      * -- Variables de conversion
       dcl-c min 'abcdefghijklmnñopqrstuvwxyzáéíóúàèìòùäëïöü';
       dcl-c may 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ';

      * -- Variables de Arquitectura Interna SDS--
       dcl-ds @PsDs psds qualified;
              CurUsr char(10) pos(358);
       end-ds;

      * -- Variables de Trabajo --
       dcl-s x        int(10);
       dcl-s z        packed(3:0);
       dcl-ds @@dsd1  likeds(dspahsd1_t) dim(9999);
       dcl-ds @1dsd1  likeds(dspahsd1_t);
       dcl-s @@dsd1C  int(10);

      * -- Variables Validador Caratula --
     D  peMsgf         s              6a
     D  peIdms         s              7a
      *

       // -------------------------------------
       /free
        *inlr = *on;


        // ----------------------------------------
        // Inicio
        // ----------------------------------------


        options = 'path=rehabilitarSiniestro +
                   case=any allowextra=yes allowmissing=yes';

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

        // ----------------------------------------
        // Lectura y Parseo
        // ----------------------------------------

        if REST_getEnvVar('WSPRES_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPRES_BODY');
        else;
           rc = REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

        monitor;
           xml-into request %xml(buffer : options);
        on-error;
           @@repl = 'caratula_t';
           @@CodM = 'RPG0001';
           FinErr ( @@repl
                  : @@CodM);
           return;
        endmon;


        // -------------------------------------
        // Control sobre los parámetros enviados
        // -------------------------------------


        // -------------------
        // Mayuscula
        request.sucursal = %xlate( min : may : request.sucursal);
        request.empresa  = %xlate( min : may : request.empresa);

        // -------------------
        // La caratula debe existir
        WSPVST( request.empresa
              : request.sucursal
              : %dec(request.rama:2:0)
              : %dec(request.siniestro:7:0)
              : %dec(request.nroOperStro:7:0)
              : peMsgf
              : peIdms );

        if peMsgf <> *blanks ;
           select;
              when peIdms = 'COW0113';
                 @@repl = request.empresa;
              when peIdms = 'COW0114';
                 @@repl = request.sucursal;
              when peIdms = 'RAM0001';
                 @@repl = %char(request.rama);
              when peIdms = 'SIN0001';
                 %subst(@@repl:1:2) = %char(request.rama);
                 %subst(@@repl:3:7) = %char(request.siniestro);
           endsl;
           @@CodM = peIdms;
           FinErr ( @@repl
                  : @@CodM);
           return;
        endif;

        // -------------------
        // Valida siniestro habilitado
        if SVPSIN_chkSinModificable( request.empresa
                                   : request.sucursal
                                   : request.rama
                                   : request.nroOperStro ) = *on;
           %subst(@@repl:1:2) = %char(request.rama);
           %subst(@@repl:3:7) = %char(request.nroOperStro) ;
           @@CodM = 'SIN0065';
           FinErr ( @@repl
                  : @@CodM);
           return;
        endif;

        // -------------------
        // Valida que no tenga siniestro en juicio
spv     if SVPSIN_chkStroEnJuicio( request.empresa
spv                              : request.sucursal
spv                              : request.rama
spv                              : request.siniestro
spv                              : request.nroOperStro ) = *on;
           //%subst(@@repl:1:2) = %char(request.rama);
           //%subst(@@repl:3:7) = %char(request.nroOperStro) ;
           @@CodM = 'SIN1005';
           FinErr ( @@repl
                  : @@CodM);
           return;
        endif;


        // Valida que no tenga siniestro en juicio
spv     if SVPSIN_rehabilitarSiniestro( request.empresa
spv                                   : request.sucursal
spv                                   : request.rama
spv                                   : request.siniestro
spv                                   : request.nroOperStro ) = *on;
           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit );
        else;
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit );
        endif;
        REST_end();
        SVPREST_end();
        return;

      * ------------------------------------------------- *
      *  Funcion Error Salida
       dcl-proc finErr;
      * Interfaz Procedimiento...
       dcl-pi *N;
          p1Repl  char(65535);
          p1CodM  char(7);
       end-pi;

       dcl-ds p1Msgs  likeds(paramMsgs);

       /free

       rc = SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : p1CodM
                         : p1Msgs
                         : %trim(p1repl)
                         : %len(%trim(p1repl)) );
       REST_writeHeader( 400
                       : *omit
                       : *omit
                       : p1CodM
                       : p1Msgs.peMsev
                       : p1Msgs.peMsg1
                       : p1Msgs.peMsg2 );
       REST_end();
       SVPREST_end();
       return;
       end-proc;


