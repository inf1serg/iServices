     H option(*srcstmt:*noshowcpy:*nodebugio)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCSP: Producción Por Artículos                             *
      *         REST para confirmar solicitud speedway.              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *07-Jun-2017            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpawpc094  if   e           k disk    rename(p1wpc0:p1wpc094)
     Fgti98009  if   e           k disk    rename(g1i980:g1i98009)
     Fctw00003  if   e           k disk    rename(c1w000:c1w00003)
     F                                     prefix(ww:2)
     Fgti983    if   e           k disk
     Fpahed0    if   e           k disk
     Fset001    if   e           k disk
     Fpawpc002  uf   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D PAR310X         pr                  ExtPgm('PAR310X')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSpo1                        9  0 const
     D  peSspo                        3  0 const
     D  peModo                        3a   const
     D  peEpgm                        3a   const
     D  peSpo2                        9  0 const options(*nopass)

      * ------------------------------------------------------------ *
      * Parámetros de URL                                            *
      * ------------------------------------------------------------ *
     D empr            s              1a
     D sucu            s              2a
     D arcd            s              6a
     D soln            s              7a
     D uri             s            512a
     D url             s           3000a   varying
     D @@repl          s          65535a

     D peArcd          s              6  0
     D peSoln          s              7  0
     D rc              s              1n
     D peMsgs          ds                  likeds(paramMsgs)

     D k1wpc0          ds                  likerec(p1wpc094:*key)
     D k2wpc0          ds                  likerec(p1wpc002:*key)
     D k1i980          ds                  likerec(g1i98009:*key)
     D k1i983          ds                  likerec(g1i983  :*key)
     D k1w000          ds                  likerec(c1w00003:*key)
     D k1hed0          ds                  likerec(p1hed0  :*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  job                          26a   overlay(psds:244)

      /free

       *inlr = *on;

       if REST_getUri( psds.this : uri ) = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       soln = REST_getNextPart(url);

       monitor;
          peArcd = %dec(arcd:6:0);
        on-error;
          peArcd = 0;
       endmon;

       monitor;
          peSoln = %dec(soln:7:0);
        on-error;
          peSoln = 0;
       endmon;

       // --------------------------------------
       // Si la propuesta es cero, error
       // --------------------------------------
       if peSoln <= 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1009'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1009'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------------
       // La propuesta SpeedWay no debe estar
       // en GTI980
       // --------------------------------------
       k1i980.g0empr = empr;
       k1i980.g0sucu = sucu;
       k1i980.g0arcd = peArcd;
       k1i980.g0soln = peSoln;
       setll %kds(k1i980:4) gti98009;
       if %equal;
          %subst(@@repl:1:6) = arcd;
          %subst(@@repl:7:9) = soln;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1010'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1010'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------------
       // La propuesta SpeedWay debe estar en
       // PAWPC0
       // --------------------------------------
       k1wpc0.w0empr = empr;
       k1wpc0.w0sucu = sucu;
       k1wpc0.w0arcd = peArcd;
       k1wpc0.w0soln = peSoln;
       chain %kds(k1wpc0:4) pawpc094;
       if not %found;
          %subst(@@repl:1:6) = arcd;
          %subst(@@repl:7:7) = soln;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1000'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1000'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------------
       // El paso 1 (cabecera superpóliza) debe
       // estar cumplido
       // --------------------------------------
       if w0wp01 <> 1;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1001'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------------
       // El paso 2 (cuotas unificadas) debe
       // estar cumplido
       // --------------------------------------
       if w0wp02 <> 1;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1002'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1002'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // ------------------------------------------
       // PAR310X no debe haber comenzado a numerar
       // los archivos (w0wp14 = 1, quiere decir que
       // PAR310X numeró)
       // ------------------------------------------
       if w0wp14 <> 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1003'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------------------
       // PAR310X no debe haber acreditado comisiones
       // anticipadas (w0wp15 = 1, quiere decir que
       // PAR310X acreditó comisiones anticipadas)
       // --------------------------------------------
       if w0wp15 <> 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1004'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1004'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------------
       // Tiene que estar suspendida normal
       // --------------------------------------
       if w0marp <> '0';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1005'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1005'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // -------------------------------------------------
       // La solicitud no debe estar siendo emitida
       // en este momento.
       // Si esto es así (la están emitiendo ahora)
       // la teoría dice que debería estar suspendida
       // especial (y se fue en el if anterior). Pero por
       // las dudas chequeo contra GTI983.
       // Si está ahí, significa que:
       // a. Existe en este momento una sesión en QFACING
       //    emitiendola o,
       // b. Canceló una sesión de QFACING.
       // Para b., debe arreglarse desde SpeedWay
       // -------------------------------------------------
       k1i983.g3empr = empr;
       k1i983.g3sucu = sucu;
       k1i983.g3arcd = peArcd;
       k1i983.g3soln = peSoln;
       chain %kds(k1i983:4) gti983;
       if %found;
          %subst(@@repl:01:10) = g3user;
          %subst(@@repl:11:08) = %editc(g3date:'X');
          %subst(@@repl:19:06) = %editc(g3time:'X');
          %subst(@@repl:25:10) = g3jnam;
          %subst(@@repl:35:06) = g3jnbr;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1006'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1006'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0arcd = w0arcd;
       k1hed0.d0spol = w0spol;
       k1hed0.d0sspo = w0sspo;

       // --------------------------------------
       // La superpóliza tiene que ser web
       // --------------------------------------
       k1w000.wwempr = w0empr;
       k1w000.wwsucu = w0sucu;
       k1w000.wwarcd = w0arcd;
       k1w000.wwspol = w0spol;
       chain %kds(k1w000:4) ctw00003;
       if not %found;
          %subst(@@repl:1:6) = arcd;
          %subst(@@repl:7:7) = soln;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1007'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1007'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------------
       // Tiene que ser una nueva (verifico en
       // PAWPC0 y en CTW000)
       // --------------------------------------
       if wwtiou <> 1 or w0tiou <> 1;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPW1008'
                       : peMsgs      );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPW1008'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       PAR310X( w0empr
              : w0sucu
              : w0arcd
              : w0spol
              : w0spo1
              : w0sspo
              : 'BCH'
              : *blanks
              : *zeros   );

       k2wpc0.w0empr = w0empr;
       k2wpc0.w0sucu = w0sucu;
       k2wpc0.w0arcd = w0arcd;
       k2wpc0.w0spol = w0spol;
       chain %kds(k2wpc0:4) pawpc002;
       if %found;
          delete p1wpc002;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine('polizas':'*BEG');

       setll %kds(k1hed0:5) pahed0;
       reade %kds(k1hed0:5) pahed0;
       dow not %eof;
           chain d0rama set001;
           if not %found;
              t@rame = 0;
           endif;
           REST_writeXmlLine('poliza':'*BEG');
            REST_writeXmlLine('rama'  :%trim(%char(d0rama)));
            REST_writeXmlLine('ramaEq':%editc(t@rame:'X'));
            REST_writeXmlLine('numero':%trim(%char(d0poli)));
           REST_writeXmlLine('poliza':'*END');
        reade %kds(k1hed0:5) pahed0;
       enddo;

       REST_writeXmlLine('polizas':'*END');

       REST_end();

       PAR310X( w0empr
              : w0sucu
              : w0arcd
              : w0spol
              : w0spo1
              : w0sspo
              : 'FIN'
              : *blanks
              : *zeros   );

       close *all;

       return;

      /end-free
