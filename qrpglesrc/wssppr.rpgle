     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSPPR :  Log Portal Proveedores                             *
      * ------------------------------------------------------------ *
      * Facundo Astiz                       *09-Jun-2022             *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D wssppr_t        ds                  qualified template
     D  idError                      10
     D  errorStatus                  10
     D  request                     250
     D  response                   1000
     D  datosExtra                  600
     D  usuario                     200
     D  tipoUsuario                  10
     D  nivelDeLog                   10
     D  fechaError                   22

     D request         ds                  likeds(wssppr_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0

     D @@repl          s          65535a
     D peValu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)

      * -- Variables --
     D @@Fech          s              8p 0

     D @@Hora          s              8p 0
     D @@Status        s              5a
     D peDspr          ds                  likeds( dsLogppr_t )

      /free

        *inlr = *on;

        // Inicio
        options = 'path=grabaLogPortalProveedores ' +
                  'case=any allowextra=yes allowmissing=yes';

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
        if REST_getEnvVar('WSSPPR_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSSPPR_BODY');
        else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          @@repl = 'wssppr_t';
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

        //Control de Campos
        request.idError     = %upper(request.idError);
        request.tipoUsuario = %upper(request.tipoUsuario);
        request.nivelDeLog  = %upper(request.nivelDeLog);

        @@Fech = *zeros;

        monitor;
           @@Fech = %dec(%subst(request.fechaError:7:4):4:0) * 10000
                  + %dec(%subst(request.fechaError:4:2):2:0) * 100
                  + %dec(%subst(request.fechaError:1:2):2:0);
        on-error;
           @@Fech = *zeros;
        endmon;

        @@Hora = *zeros;
        monitor;
           @@Hora = %dec(%subst(request.fechaError:12:2):2:0) * 1000000
                  + %dec(%subst(request.fechaError:15:2):2:0) * 10000
                  + %dec(%subst(request.fechaError:18:2):2:0) * 100
                  + %dec(%subst(request.fechaError:21:2):2:0);
        on-error;
           @@Hora = *zeros;
        endmon;

        //Carga Estructura
        peDspr.pridta = *zeros; //Calculado en rutina
        peDspr.prider = request.idError;
        peDspr.prerrs = request.errorStatus;
        peDspr.prrequ = request.request;
        peDspr.prresp = request.response;
        peDspr.prdaex = request.datosExtra;
        peDspr.pruser = request.usuario;
        peDspr.prtusu = request.tipoUsuario;
        peDspr.prnivl = request.nivelDeLog;
        peDspr.prtime = @@Hora;
        peDspr.prdate = @@Fech;

        //Graba Log
        if cowlog_setLogppr( peDspr ) = *on;
          REST_writeHeader( 201
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
          @@Status = 'Ok';
        else;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
          @@Status = 'Error';
        endif;

        REST_writeEncoding();

        REST_startArray( 'logPortalProveedores' );
          REST_writeXmlLine( 'status' : @@Status );
        REST_endArray  ( 'logPortalProveedores' );

        REST_end();

       return;
