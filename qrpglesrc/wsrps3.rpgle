     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPS3: QUOM Versión 2                                       *
      *         Actualizacion Tipo de Voucher                        *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *30-Ene-2019            *
      * ------------------------------------------------------------ *
      * Modificacion:                                                *
      * JSN 04/07/2019 - Se agrega Validacion de tipo de Voucher.    *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svppds_h.rpgle'

     D uri             s            512a
     D Empr            s              1a
     D Sucu            s              2a
     D Nivt            s              1a
     D Nivc            s              5a
     D Nit1            s              1a
     D Niv1            s              5a
     D Npds            s              7a
     D Nore            s              7a
     D tipo            s              1a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@Npds          s              7  0
     D @@Nore          s              7  0
     D peBase          ds                  likeds(paramBase)
     D @@repl          s          65535a
     D tmpfec          s               d   datfmt(*iso) inz
     D peErro          s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       Empr = REST_getNextPart(url);
       Sucu = REST_getNextPart(url);
       Nivt = REST_getNextPart(url);
       Nivc = REST_getNextPart(url);
       Nit1 = REST_getNextPart(url);
       Niv1 = REST_getNextPart(url);
       Npds = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         SVPREST_end();
         return;
       endif;

        if Tipo <> 'R' and Tipo <> 'C';
          %subst(@@repl:1:1)  = Tipo;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );

          peErro = -1;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
        endif;

       @@Npds = %dec(Npds:7:0);
       peBase.peEmpr = Empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(Nivt:1:0);
       peBase.peNivc = %dec(Nivc:5:0);
       peBase.peNit1 = %dec(Nit1:1:0);
       peBase.peNiv1 = %dec(Niv1:5:0);

       @@Nore = SVPSIN_getNumeroVoucher( Empr
                                       : Sucu );

       if SVPSIN_setNumeroVoucher( peBase
                                 : @@Npds
                                 : @@Nore );

         SVPPDS_setTipoDeVoucher( peBase
                                : @@Npds
                                : tipo
                                : peErro
                                : peMsgs );

         if peErro = -1;
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : peMsgs.peMsid
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           return;
         endif;

       else;

         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         return;

       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'resultado' : '*BEG' );
         REST_writeXmlLine('Result' : 'OK');
         REST_writeXmlLine('numeroVoucher' : %char(@@Nore));
       REST_writeXmlLine( 'resultado' : '*END' );

       return;

      /end-free

