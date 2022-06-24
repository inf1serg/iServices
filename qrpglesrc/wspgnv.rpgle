     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSPGNV : Retorna Número de Voucher                           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                    *17-Dic-2021             *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'

     D request         ds                  likeds(wspgnv_t)
     D buffer          s           5000a
     D options         s            100a
     D @@nvou          s              7  0
     D rc1             s             10i 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D k1tsuc          ds                  likerec(g1tsuc:*key)
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       *inlr = *on;

       // Inicio

        options = 'path=obtenerNumeroVoucher +
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

       // Lectura y Parseo

        if REST_getEnvVar('WSPGNV_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPGNV_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          @@repl = 'wspgnv_t';
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

        if %xlate( min : may : request.tipoVoucher ) <> 'R' and
           %xlate( min : may : request.tipoVoucher ) <> 'C';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0066'
                       : peMsgs      );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0066'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        @@nvou = SVPSIN_getNumeroVoucher( request.empresa
                                        : request.sucursal );

        REST_writeHeader( 201
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit );
        REST_writeEncoding();

        REST_startArray( 'voucher' );
         REST_writeXmlLine( 'numero' : %char(@@nvou) );
        REST_endArray  ( 'voucher');

        REST_end();

       return;
