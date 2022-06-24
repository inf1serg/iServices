      * ************************************************************ *
      * WSPDVH: QUOM Version 2 - Servicio POST                       *
      *         Insertar Daños al vehiculo.                          *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *15-Oct-2021            *
      * ------------------------------------------------------------ *
      *                                                           *
      * ************************************************************ *
        ctl-opt
         option(*srcstmt) actgrp(*new) dftactgrp(*no)
         bnddir('HDIILE/HDIBDIR')
         alwnull(*usrctl);

      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'

       dcl-ds request likeds(wspdvh_t);
       dcl-s buffer   char(65535);
       dcl-s options  char(100);
       dcl-s @@repl   char(65535);
       dcl-s peValu   char(1024);
       dcl-s rc       int(10);
       dcl-s x        int(10);
       dcl-s z        packed(3:0);
       dcl-ds @@dsd1  likeds(dspahsd1_t) dim(9999);
       dcl-ds @1dsd1  likeds(dspahsd1_t);
       dcl-s @@dsd1C  int(10);

       dcl-c min 'abcdefghijklmnñopqrstuvwxyzáéíóúàèìòùäëïöü';
       dcl-c may 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ';

       dcl-ds peMsgs  likeds(paramMsgs);

       dcl-ds @PsDs psds qualified;
              CurUsr char(10) pos(358);
       end-ds;

        *inlr = *on;

        // ----------------------------------------
        // Inicio
        // ----------------------------------------
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

        if REST_getEnvVar('WSPDVH_BODY' : peValu );
            options = 'doc=file path=daniosVehiculo +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml('/tmp/wspdvh.xml' : options);
            on-error;
              exsr $errorParseo;
           endmon;
            Qp0zDltEnv('WSPDVH_BODY');
          else;
            rc = REST_readStdInput( %addr(buffer): %len(buffer) );
            options = 'doc=string path=daniosVehiculo +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml(buffer : options);
            on-error;
              exsr $errorParseo;
           endmon;
        endif;


        request.sucursal = %xlate( min : may : request.sucursal);
        request.empresa  = %xlate( min : may : request.empresa);

        if SVPEMP_getDatosDeEmpresa( request.empresa
                                   : *omit
                                   ) = *off;
          @@repl = request.empresa;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0113'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
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
        endif;

        if SVPSUC_getDatosDeSucursal(request.empresa
                                    :request.sucursal
                                    :*omit) = *off;
          %subst(@@repl:1:2) = request.sucursal;
          %subst(@@repl:3:1) = request.empresa;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0114'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
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
        endif;

        // Valida siniestro no terminado
        if SVPSIN_chkFinSini( request.empresa
                            : request.sucursal
                            : request.rama
                            : request.siniestro
                            : request.nroOpStro )= *on;
          %subst(@@repl:1:2) = %char(request.rama);
          %subst(@@repl:3:7) = %char(request.nroOpStro);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0052'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0052'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // El Siniestro/caratula tiene Estado inhabilitado para modificacio n
        if SVPSIN_chkSinModificable( request.empresa
                                   : request.sucursal
                                   : request.rama
                                   : request.nroOpStro ) = *off;
          %subst(@@repl:1:2) = %char(request.rama);
          %subst(@@repl:3:7) = %char(request.nroOpStro) ;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0052'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0052'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        if SVPSI1_chkPahscd(request.empresa
                           :request.sucursal
                           :request.rama
                           :request.siniestro
                           :request.nroOpStro) = *off;

          %subst(@@repl:1:2) = %editc(request.rama:'X');
          %subst(@@repl:3:7) = %editc(request.siniestro:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        if SVPSI1_getPahsd1(request.empresa
                           :request.sucursal
                           :request.rama
                           :request.siniestro
                           :request.nroOpStro
                           :@@dsd1
                           :@@dsd1C) = *on;
           for x = 1 to @@dsd1C;
               SVPSI1_dltPahsd1(@@dsd1(x));
           endfor;
        endif;


        z = 0;
        for x = 1 to 999;
            if request.danios.linea(x).texto <> *blanks;
              z += 1;
              clear @1dsd1;
              @1dsd1.d1empr = request.empresa;
              @1dsd1.d1sucu = request.sucursal;
              @1dsd1.d1rama = request.rama;
              @1dsd1.d1sini = request.siniestro;
              @1dsd1.d1nops = request.nroOpStro;
              @1dsd1.d1nrre = z;
         //   @1dsd1.d1retx = %xlate(min:may:request.danios.linea(x).texto);
              @1dsd1.d1retx = request.danios.linea(x).texto;
              @1dsd1.d1user = @Psds.CurUsr;
              @1dsd1.d1fera = %subdt(%timestamp():*y);
              @1dsd1.d1ferm = %subdt(%timestamp():*m);
              @1dsd1.d1ferd = %subdt(%timestamp():*d);
              @1dsd1.d1time  = %dec(%time():*eur);
              if SVPSI1_setPahsd1(@1dsd1) = *off;
                 REST_writeHeader( 400
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit );
                 REST_end();
                 SVPREST_end();
                 return;
              endif;
            endif;
        endfor;

        //graba marca 03
        if SVPSI1_updMarca03(request.empresa
                            :request.sucursal
                            :request.rama
                            :request.siniestro
                            :request.nroOpStro) = *off;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'SIN0063'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN0063'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        REST_writeHeader( 204
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit );
        REST_end();

       return;

        begsr $errorParseo;
         @@repl = 'BPM';
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
        endsr;

