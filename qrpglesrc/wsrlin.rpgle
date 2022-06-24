     H option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRLIN: QUOM Versión 2                                       *
      *         Listado de Intermediarios por CUIT                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ------------------------------------------------------------ *
      * SGF 23/03/21: Agrego log.                                    *
      *                                                              *
      * ************************************************************ *
     Fpahusu2   if   e           k disk
     Fsehnid    if   e           k disk
     Fsehni201  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehni4e   if   e           k disk

      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D cuit            s             11a
     D nrag            s              5a
     D usri            s              1a

     D uri             s            512a
     D url             s           3000a   varying
     D c               s             10i 0
     D rc2             s             10i 0
     D rc              s              1n
     D @repl           s          65535a
     D es_agencia      s              1n
     D @@nrag          s              5  0
     D blqVoucher      s              1n

     D peMsgs          ds                  likeds(paramMsgs)
     D k1husu          ds                  likerec(d1husu2:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1hnid          ds                  likerec(d1hnid:*key)
     D k1hni4          ds                  likerec(s1hni4e:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

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
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       cuit = REST_getNextPart(url);
       nrag = REST_getNextPart(url);
       usri = REST_getNextPart(url);

       setll empr gntemp;
       if not %equal;
          %subst(@repl:1:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0113'
                             : peMsgs
                             : %trim(@repl)
                             : %len(%trim(@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       setll (empr : sucu) gntsuc;
       if not %equal;
          %subst(@repl:1:2) = sucu;
          %subst(@repl:3:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0114'
                             : peMsgs
                             : %trim(@repl)
                             : %len(%trim(@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0114'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       monitor;
         @@nrag = %dec( nrag : 5 : 0 );
        on-error;
         @@nrag = 0;
       endmon;

       COWLOG_loglin( empr
                    : sucu
                    : cuit
                    : @@nrag
                    : usri   );

       // -----------------------------------------
       // Usuario internos
       // -----------------------------------------
       c = 0;
       if usri = 'S' or usri = 's';
          REST_writeHeader();
          REST_write('<?xml version="1.0" encoding="ISO-8859-1"?>');
          REST_writeXmlLine( 'intermediarios' : '*BEG' );
          setll *start pahusu2;
          read pahusu2;
          dow not %eof;
              if u2mp02 <> 'B';
                 k1hni2.n2empr = empr;
                 k1hni2.n2sucu = sucu;
                 k1hni2.n2nivt = u2nivt;
                 k1hni2.n2nivc = u2nivc;
                 chain %kds(k1hni2) sehni201;
                 if %found;
                    c += 1;
                    REST_writeXmlLine( 'intermediario' : '*BEG' );
                     REST_writeXmlLine( 'cuitInter'   : %trim(u2cuit)        );
                     REST_writeXmlLine( 'nivelInter'  : %trim(%char(u2nivt)) );
                     REST_writeXmlLine( 'codigoInter' : %trim(%char(u2nivc)) );
                     REST_writeXmlLine( 'nombreInter' : %trim(dfnomb)        );
                     REST_writeXmlLine( 'codMayorAux' : %trim(n2coma)        );
                     REST_writeXmlLine( 'nroMayorAux' : %trim(%char(n2nrma)) );
                     exsr $chkVoucher;
                     if blqVoucher;
                        REST_writeXmlLine( 'bloquearVoucher' : 'S');
                     else;
                        REST_writeXmlLine( 'bloquearVoucher' : 'N');
                     endif;
                    REST_writeXmlLine( 'intermediario' : '*END' );
                 endif;
              endif;
           read pahusu2;
          enddo;
          REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
          REST_writeXmlLine( 'intermediarios' : '*END' );
          REST_end();
          close *all;
          return;
       endif;

       // -----------------------------------------
       // Intento agencia
       // -----------------------------------------
       es_agencia = *on;
       k1hnid.idempr = empr;
       k1hnid.idsucu = sucu;
       k1hnid.idnrag = @@nrag;

       if k1hnid.idnrag <= 0;
          es_agencia = *off;
       endif;

       if es_agencia;
          chain %kds(k1hnid:3) sehnid;
          if not %found;
             %subst(@repl:1:5) = nrag;
             rc2 = SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'AGE0001'
                                : peMsgs
                                : %trim(@repl)
                                : %len(%trim(@repl)) );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'AGE0001'
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
             REST_end();
             close *all;
             return;
           else;
              k1hni2.n2empr = empr;
              k1hni2.n2sucu = sucu;
              k1hni2.n2nivt = idnivt;
              k1hni2.n2nivc = idnivc;
              chain %kds(k1hni2) sehni201;
              if %found;
                 REST_writeHeader();
                 REST_write('<?xml version="1.0" encoding="ISO-8859-1"?>');
                 REST_writeXmlLine( 'intermediarios' : '*BEG' );
                 c += 1;
                 REST_writeXmlLine( 'intermediario' : '*BEG' );
                  REST_writeXmlLine( 'cuitInter'   : %trim(dfcuit)        );
                  REST_writeXmlLine( 'nivelInter'  : %trim(%char(n2nivt)) );
                  REST_writeXmlLine( 'codigoInter' : %trim(%char(n2nivc)) );
                  REST_writeXmlLine( 'nombreInter' : %trim(dfnomb)        );
                  REST_writeXmlLine( 'codMayorAux' : %trim(n2coma)        );
                  REST_writeXmlLine( 'nroMayorAux' : %trim(%char(n2nrma)) );
                  exsr $chkVoucher;
                  if blqVoucher;
                     REST_writeXmlLine( 'bloquearVoucher' : 'S');
                  else;
                     REST_writeXmlLine( 'bloquearVoucher' : 'N');
                  endif;
                 REST_writeXmlLine( 'intermediario' : '*END' );
                 REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
                 REST_writeXmlLine( 'intermediarios' : '*END' );
                 REST_end();
                 close *all;
                 return;
              endif;
          endif;
       endif;

       // -----------------------------------------
       // Intermediario verdadero
       // -----------------------------------------
       c = 0;
       REST_writeHeader();
       REST_write('<?xml version="1.0" encoding="ISO-8859-1"?>');
       REST_writeXmlLine( 'intermediarios' : '*BEG' );
       setll cuit pahusu2;
       reade cuit pahusu2;
          dow not %eof;
              if u2mp02 <> 'B';
                 k1hni2.n2empr = empr;
                 k1hni2.n2sucu = sucu;
                 k1hni2.n2nivt = u2nivt;
                 k1hni2.n2nivc = u2nivc;
                 chain %kds(k1hni2) sehni201;
                 if %found;
                    c += 1;
                    REST_writeXmlLine( 'intermediario' : '*BEG' );
                     REST_writeXmlLine( 'cuitInter'   : %trim(u2cuit)        );
                     REST_writeXmlLine( 'nivelInter'  : %trim(%char(u2nivt)) );
                     REST_writeXmlLine( 'codigoInter' : %trim(%char(u2nivc)) );
                     REST_writeXmlLine( 'nombreInter' : %trim(dfnomb)        );
                     REST_writeXmlLine( 'codMayorAux' : %trim(n2coma)        );
                     REST_writeXmlLine( 'nroMayorAux' : %trim(%char(n2nrma)) );
                  exsr $chkVoucher;
                  if blqVoucher;
                     REST_writeXmlLine( 'bloquearVoucher' : 'S');
                  else;
                     REST_writeXmlLine( 'bloquearVoucher' : 'N');
                  endif;
                    REST_writeXmlLine( 'intermediario' : '*END' );
                 endif;
              endif;
           reade cuit pahusu2;
          enddo;
          REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
          REST_writeXmlLine( 'intermediarios' : '*END' );
          REST_end();
          close *all;
          return;

       begsr $chkVoucher;
        blqVoucher = SVPINT_bloquearVoucher( empr
                                           : sucu
                                           : u2nivt
                                           : u2nivc
                                           : *omit  );
       endsr;

      /end-free
