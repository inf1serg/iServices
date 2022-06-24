     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRVRC: QUOM Versión 2                                       *
      *         Confiuracion de Voucher                              *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *30-Ene-2019            *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/czwutl_h.rpgle'

     D uri             s            512a
     D Empr            s              1a
     D Sucu            s              2a
     D Nivt            s              1a
     D Nivc            s              5a
     D Nit1            s              1a
     D Niv1            s              5a
     D Fech            s             10a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@Fech          s              8  0
     D @@Ctre          s              5  0
     D @@Qrev          s              1  0
     D @@Frue          s              3  0
     D @@Fcri          s              3  0
     D @@repl          s          65535a
     D tmpfec          s               d   datfmt(*iso) inz

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
       Fech = REST_getNextPart(url);

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

       monitor;
         tmpFec  = %date( Fech : *iso );
         @@Fech  = %dec( tmpFec : *iso );
       on-error;
         @@repl = Fech;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0009'
                      : peMsgs
                      : %trim(@@repl)
                      : %len(%trim(@@repl)) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         return;
       endmon;

       if CZWUTL_getTarifa( @@Ctre
                          : @@Fech ) = 0;


         REST_writeHeader();
         REST_writeEncoding();
         REST_writeXmlLine( 'voucherSiniestros' : '*BEG' );

         clear @@Qrev;
         clear @@Frue;
         clear @@Fcri;

         SVPSIN_getConfiguracionVoucherRuedasCristales( Empr
                                                      : Sucu
                                                      : @@Qrev
                                                      : @@Frue
                                                      : @@Fcri
                                                      : @@Fech );

         if @@Frue = *zeros;
           REST_writeXmlLine('cantidadPermitidaRuedasVigencia' : '0');
         else;
           REST_writeXmlLine('cantidadPermitidaRuedasVigencia' :
                              %char(@@Frue));
         endif;
         if @@Fcri = *zeros;
           REST_writeXmlLine('cantidadPermitidaCristalesVigencia' : '0');
         else;
           REST_writeXmlLine('cantidadPermitidaCristalesVigencia' :
                              %char(@@Fcri));
         endif;
         if @@Qrev = *zeros;
           REST_writeXmlLine('cantidadPermitidaRuedasEvento' : '0');
         else;
           REST_writeXmlLine('cantidadPermitidaRuedasEvento' :
                              %char(@@Qrev));
         endif;
         REST_writeXmlLine( 'voucherSiniestros' : '*END' );

       endif;

       return;

      /end-free

