      * ************************************************************ *
      * WSPRDH: QUOM Version 2 - Servicio POST                       *
      *         Insertar Relato del Hecho                            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *14-Oct-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
        ctl-opt
         option(*srcstmt) actgrp(*new) dftactgrp(*no)
         bnddir('HDIILE/HDIBDIR')
         alwnull(*usrctl);

        dcl-f gntemp usage(*input) keyed;
        dcl-f gntsuc usage(*input) keyed;
        dcl-f pahscd usage(*input) keyed;
        dcl-f pahsd0 usage(*input:*output:*update:*delete) keyed;
        dcl-f pahssp usage(*input:*output:*update) keyed;

      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

       dcl-ds request likeds(wsprdh_t);
       dcl-s buffer   char(65535);
       dcl-s options  char(100);
       dcl-s @@repl   char(65535);
       dcl-s peValu   char(1024);
       dcl-s Dato     char(79);
       dcl-s rc       int(10);
       dcl-s x        int(10);
       dcl-s z        packed(3:0);

       dcl-c min 'abcdefghijklmnñopqrstuvwxyzáéíóúàèìòùäëïöü';
       dcl-c may 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ';

       dcl-ds peMsgs  likeds(paramMsgs);
       dcl-ds k1tsuc  likerec(g1tsuc:*key);
       dcl-ds k1hscd  likerec(p1hscd:*key);

       dcl-ds @PsDs psds qualified;
              CurUsr char(10) pos(358);
       end-ds;

        *inlr = *on;

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

        if REST_getEnvVar('WSPRDH_BODY' : peValu );
            options = 'doc=file path=relatoHecho +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml('/tmp/wsprdh.xml' : options);
            on-error;
              exsr $errorParseo;
           endmon;
            Qp0zDltEnv('WSPRDH_BODY');
        else;
            rc = REST_readStdInput( %addr(buffer): %len(buffer) );
            options = 'doc=string path=relatoHecho +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml(buffer : options);
            on-error;
              exsr $errorParseo;
           endmon;
        endif;

        request.empresa  = %xlate( min : may : request.empresa);
        request.sucursal = %xlate( min : may : request.sucursal);

        setll request.empresa gntemp;
        if not %equal;
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

        k1tsuc.suempr = request.empresa;
        k1tsuc.susucu = request.sucursal;
        setll %kds(k1tsuc:2) gntsuc;
        if not %equal;
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
                          : 'RPG0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        k1hscd.cdempr = request.empresa;
        k1hscd.cdsucu = request.sucursal;
        k1hscd.cdrama = request.rama;
        k1hscd.cdsini = request.siniestro;
        k1hscd.cdnops = request.nroOpStro;
        setll %kds(k1hscd:5) pahscd;
        if not %equal;
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

        setll %kds(k1hscd:5) pahsd0;
        reade %kds(k1hscd:5) pahsd0;
        dow not %eof;
            delete p1hsd0;
         reade %kds(k1hscd:5) pahsd0;
        enddo;

        z = 0;
        for x = 1 to 999;
            if request.lineas.linea(x).texto <> *blanks;
               z += 1;
               d0empr = request.empresa;
               d0sucu = request.sucursal;
               d0rama = request.rama;
               d0sini = request.siniestro;
               d0nops = request.nroOpStro;
               d0nrre = z;
               d0retx = request.lineas.linea(x).texto;
               d0user = @Psds.CurUsr;
               d0fera = %subdt(%timestamp():*y);
               d0ferm = %subdt(%timestamp():*m);
               d0ferd = %subdt(%timestamp():*d);
               d0time = %dec(%time():*eur);
               write p1hsd0;
               chain %kds(k1hscd:5) pahssp;
               if %found;
                  spap02 = 1;
                  update p1hssp;
               endif;
            endif;
        endfor;

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

