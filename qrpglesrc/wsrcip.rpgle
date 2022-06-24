     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCIP: QUOM Versión 2                                       *
      *         Cuotas Impagas de una póliza.                        *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *06-Jun-2017            *
      * ------------------------------------------------------------ *
      * Modificacion                                                 *
      * LRG 21/03/2018: Se solicita agregar el punto antes de los    *
      *                 importes que solo contienen decimales        *
      * EXT 25/07/2018: Nuevos tags                                  *
      *                  - <isPagada>                                *
      *                  - <permiteRecibo>                           *
      *                  - <origenDelPago>                           *
      *                  - <imprimeOrigenDelPago>                    *
      *                  - <muestraOrigenDelPago>                    *
      * EXT 02/08/2018: Cambio en peSuop y peNrcu                    *
      * SGF 19/02/20   : Estado de cuota.                            *
      * NWN 17/06/20   : Mal acceso a PAHCC2.                        *
      * NWN 17/05/21   : Agregado de Chequeo via SVPCUO.             *
      *                                                              *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fset001    if   e           k disk
     Fpahec1    if   e           k disk
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)
     Fpahcd6    if   e           k disk
     Fivhcar01  if   e           k disk
     Fgntorp    if   e           k disk
     Fpahcc2    if   e           k disk

      /copy './qcpybooks/svpcuo_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

     D WSLCU1          pr                  ExtPgm('WSLCU1')
     D   peBase                            likeds(paramBase) const
     D   pePosi                            likeds(keycu1_t) const
     D   peLcuo                            likeds(cuotasImp_t) dim(100)
     D   peLcuoC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D getOrigenPago...
     D                 pr              n
     D peEmpr                         1    Const
     D peSucu                         2    Const
     D peArcd                         6  0 Const
     D peSpol                         9  0 Const
     D peSspo                         3  0 Const
     D peRama                         2  0 Const
     D peArse                         2  0 Const
     D peOper                         7  0 Const
     D peSuop                         3  0 Const
     D peNrcu                         2  0 Const
     D peNrsc                         2  0 Const
     D peNomb                        40
     D peMar1                         1
     D peMar2                         1

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@rama          s              2  0
     D @@repl          s          65535a
     D sspo            s              3a
     D suop            s              3a
     D fvto            s             10a
     D fvt1            s             10a
     D imcu            s             20a
     D nrcu            s              2a
     D nrsc            s              2a
     D peErro          s             10i 0
     D peLcuoC         s             10i 0
     D x               s             10i 0
     D @@nras          s              6  0

     D oriPago         s             40
     D impPago         s              1
     D muePago         s              1
     D @@cfpg          s              1  0

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D pePosi          ds                  likeds(keycu1_t)
     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1hcc2          ds                  likerec(p1hcc2:*key)
     D peLcuo          ds                  likeds(cuotasImp_t) dim(100)

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
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);

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
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(rama) ) <> 0;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       @@rama = %dec( rama : 2 : 0 );
       setll @@rama set001;
       if not %equal;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(poli) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0rama = %dec( rama : 2 : 0 );
       k1hed0.d0poli = %dec( poli : 7 : 0 );
       setgt  %kds(k1hed0:4) pahed004;
       readpe %kds(k1hed0:4) pahed004;
       if %eof;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1hec1.c1empr = d0empr;
       k1hec1.c1sucu = d0sucu;
       k1hec1.c1arcd = d0arcd;
       k1hec1.c1spol = d0spol;

       setgt %kds(k1hec1:4) pahec1;
       readpe %kds(k1hec1:4) pahec1;
       if %eof;
          c1cert = 0;
          c1cfpg = 0;
       endif;
       @@cfpg = c1cfpg;

       clear peBase;
       clear peLcuo;
       clear peMsgs;
       clear pePosi;

       peLcuoC = 0;
       peErro  = 0;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec( nivt : 1 : 0 );
       peBase.peNivc = %dec( nivc : 5 : 0 );
       peBase.peNit1 = %dec( nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( niv1 : 5 : 0 );

       COWLOG_logcon('WSRCIP':peBase);

       pePosi.rama = %dec( rama : 2 : 0 );
       pePosi.poli = %dec( poli : 7 : 0 );
       pePosi.spol = c1spol;
       pePosi.arcd = c1arcd;
       pePosi.cert = c1cert;
       pePosi.arse = d0arse;
       pePosi.oper = d0oper;

       WSLCU1( peBase
             : pePosi
             : peLcuo
             : peLcuoC
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
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_write('<?xml version="1.0" encoding="ISO-8859-1"?>');
       REST_writeXmlLine( 'cuotas' : '*BEG');

       for x = 1 to peLcuoC;
           sspo = %trim(%char(peLcuo(x).sspo));
           suop = %trim(%char(peLcuo(x).suop));
           nrcu = %trim(%char(peLcuo(x).nrcu));
           nrsc = %trim(%char(peLcuo(x).nrsc));
           fvt1 = %trim(peLcuo(x).fvto);
           fvto = %subst(fvt1:7:4)
                + '-'
                + %subst(fvt1:4:2)
                + '-'
                + %subst(fvt1:1:2);
           imcu = %editw(peLcuo(x).imcu:'            0.  ');
           if peLcuo(x).imcu = 0;
              imcu = '.00';
           endif;
           if peLcuo(x).imcu < 0;
              imcu = '-' + %trim(imcu);
           endif;
           REST_writeXmlLine( 'cuota' : '*BEG');
            REST_writeXmlLine( 'suplemento' : sspo);
            REST_writeXmlLine( 'nroCuota'   : nrcu);
            REST_writeXmlLine( 'nroSubCuota': nrsc);
            REST_writeXmlLine( 'fecVto'     : fvto);
            REST_writeXmlLine( 'importeCuota' : imcu );
            REST_writeXmlLine( 'fecPago' : *blanks );
            REST_writeXmlLine( 'importePago' : *blanks );
            REST_writeXmlLine( 'moneda'
                             : SVPDES_monedaAbreviada(peLcuo(x).mone) );
            if SPVSPO_chkCuotaPermiteRecibo ( d0empr
                                            : d0sucu
                                            : d0arcd
                                            : d0spol
                                            : peLcuo( x ).sspo
                                            : peLcuo( x ).nrcu
                                            : peLcuo( x ).nrsc );
              REST_writeXmlLine( 'permiteRecibo' : 'S' );
            else;
              REST_writeXmlLine( 'permiteRecibo' : 'N' );
            endif;
            getOrigenPago ( d0empr
                          : d0sucu
                          : d0arcd
                          : d0spol
                          : peLcuo( x ).sspo
                          : d0rama
                          : d0arse
                          : d0oper
                          : peLcuo( x ).suop
                          : peLcuo( x ).nrcu
                          : peLcuo( x ).nrsc
                          : oriPago
                          : impPago
                          : muePago );
            REST_writeXmlLine( 'origenDelPago' : %trim( oriPago ) );
            REST_writeXmlLine( 'imprimeOrigenDelPago' : impPago );
            REST_writeXmlLine( 'muestraOrigenDelPago' : muePago );
            k1hcc2.c2empr = d0empr;
            k1hcc2.c2sucu = d0sucu;
            k1hcc2.c2arcd = d0arcd;
            k1hcc2.c2spol = d0spol;
            k1hcc2.c2sspo = peLcuo(x).sspo;
            k1hcc2.c2nrcu = peLcuo(x).nrcu;
            k1hcc2.c2nrsc = peLcuo(x).nrsc;
            if SVPCUO_getNumeroAsiento(d0empr
                                      :d0sucu
                                      :d0arcd
                                      :d0spol
                                      :peLcuo( x ).sspo
                                      :d0rama
                                      :d0arse
                                      :d0oper
                                      :peLcuo( x ).suop
                                      :peLcuo( x ).nrcu
                                      :peLcuo( x ).nrsc
                                      :*omit ) <> *zeros ;
               REST_writeXmlLine( 'estadoDeCuota' : '3');
               REST_writeXmlLine( 'isPagada' : 'S' );
             else;
               REST_writeXmlLine( 'isPagada' : 'N' );
               chain %kds(k1hcc2:7) pahcc2;
                if %found;
                  REST_writeXmlLine( 'estadoDeCuota' : c2sttc );
                 else;
                  REST_writeXmlLine( 'estadoDeCuota' : '0');
                endif;
            endif;
            REST_writeXmlLine( 'codigoFormaDePago' : %char(@@cfpg) );
           REST_writeXmlLine( 'cuota' : '*END');
       endfor;

       REST_writeXmlLine( 'cuotas' : '*END');

       REST_end();

       close *all;

       return;

      /end-free

     P getOrigenPago...
     P                 B                   export
     D getOrigenPago...
     D                 pi              n
     D peEmpr                         1    Const
     D peSucu                         2    Const
     D peArcd                         6  0 Const
     D peSpol                         9  0 Const
     D peSspo                         3  0 Const
     D peRama                         2  0 Const
     D peArse                         2  0 Const
     D peOper                         7  0 Const
     D peSuop                         3  0 Const
     D peNrcu                         2  0 Const
     D peNrsc                         2  0 Const
     D peNomb                        40
     D peMar1                         1
     D peMar2                         1

     D k1y             ds                  likerec( p1hcd6 : *key )
     D k2y             ds                  likerec( i1hcar : *key )
     D k3y             ds                  likerec( g1torp : *key )

      /free

        peNomb = *Blanks;
        peMar1 = 'N';
        peMar2 = 'N';

        k1y.d6empr = peEmpr;
        k1y.d6sucu = peSucu;
        k1y.d6arcd = peArcd;
        k1y.d6spol = peSpol;
        k1y.d6sspo = peSspo;
        k1y.d6rama = peRama;
        k1y.d6arse = peArse;
        k1y.d6oper = peOper;
        k1y.d6suop = peSuop;
        k1y.d6nrcu = peNrcu;
        k1y.d6nrsc = peNrsc;
        chain %kds ( k1y : 11 ) pahcd6;
        if not %found( pahcd6 );
          return *Off;
        endif;

        k2y.caempr = d6empr;
        k2y.casucu = d6sucu;
        k2y.caivni = d6nras;
        chain %kds ( k2y : 3 ) ivhcar01;
        if not %found( ivhcar01 );
          return *Off;
        endif;

        k3y.rpempr = caempr;
        k3y.rpsucu = casucu;
        k3y.rpcoma = cacoma;
        k3y.rpnrma = canrma;
        chain %kds ( k3y : 4 ) gntorp;
        if not %found( gntorp );
          if ( cacoma = '60' );
            peNomb = 'COBRADOR';
          else;
            peNomb = *Blanks;
          endif;
          return *On;
        endif;

        peNomb = rpnomb;
        if ( rpmar1 = '1' );
          peMar1 = 'S';
        endif;
        if ( rpmar2 = '1' );
          peMar2 = 'S';
        endif;

        return *On;

      /end-free

     P getOrigenPago...
     P                 E
