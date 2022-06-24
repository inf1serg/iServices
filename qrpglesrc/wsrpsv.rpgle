     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPSV: QUOM Versión 2                                       *
      *         Seleccionar póliza para siniestrar.                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Oct-2017            *
      * ------------------------------------------------------------ *
      * Modificaciones :                                             *
      *                                                              *
      * LRG 04/05/18 - Se cambia la severidad del mensaje de         *
      *                Cobertura Financiera pasa de 40 a 10,         *
      *                se mantiene la validacion y el mensaje pero   *
      *                sin ser bloqueante.                           *
      * SGF 01/07/19 - Agrego tags <tieneCoberturaFinanciera> y      *
      *                <estaVigente>.                                *
      *                                                              *
      * ************************************************************ *
     Fpahed004  if   e           k disk
     Fpahec0    if   e           k disk
     Fpahec1    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fsehni201  if   e           k disk
     Fgntmon    if   e           k disk
     Fset901    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRS002          pr                  ExtPgm('PRS002')
     D  peBase                             likeds(paramBase) const
     D  pePate                       25a   const
     D  peFocu                        8  0 const
     D  peHocu                        6  0 const
     D  peRama                        2  0
     D  pePoli                        7  0
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSPVIG          pr                  extpgm('WSPVIG')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peFech                       10a   const
     D  peHora                        8a   const
     D  peVige                        1a
     D  peCfin                        1a
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSPCSP          pr                  ExtPgm('WSPCSP')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0
     D  pePoli                        7  0
     D  peFech                         d   datfmt(*iso) const
     D  peCast                       10i 0
     D  peCasp                       10i 0
     D  peCass                       10i 0
     D  peCasi                       10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

     D WSLOG           pr                  ExtPgm('QUOMDATA/WSLOG')
     D  msg                         512a   const

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D filt            s              1a
     D focu            s              8a
     D hocu            s              6a
     D pate            s             25a
     D rama            s              2a
     D poli            s              7a

     D a               s              4a
     D m               s              2a
     D d               s              2a
     D h               s              2a
     D i               s              2a
     D s               s              2a
     D x               s             10i 0
     D @a              s              4  0
     D @m              s              2  0
     D @d              s              2  0
     D @h              s              2  0
     D @i              s              2  0
     D @s              s              2  0
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@repl          s          65535a
     D peErro          s             10i 0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D peFocu          s              8  0
     D peHocu          s              6  0
     D pePoli          s              7  0
     D peRama          s              2  0
     D pxPoli          s              7  0
     D pxRama          s              2  0
     D pxFocu          s             10a
     D pxHocu          s              8a
     D peVige          s              1a
     D peCfin          s              1a
     D peCasi          s             10i 0
     D peCast          s             10i 0
     D peCasp          s             10i 0
     D peCass          s             10i 0
     D dsop            s             20a
     D femi            s             10a
     D fdes            s             10a
     D fhas            s             10a
     D nase            s             40a
     D npro            s             40a
     D nmoc            s              5a
     D prem            s             30a
     D prim            s             30a

     D peMsgs          ds                  likeds(paramMsgs)
     D @@msgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)

     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hec0          ds                  likerec(p1hec0:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1t901          ds                  likerec(s1t901:*key)
     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  job                          26a   overlay(psds:244)

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

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       filt = REST_getNextPart(url);
       focu = REST_getNextPart(url);
       for x = 1 to 8;
           if %subst(focu:x:1) <> '-' and
              %subst(focu:x:1) <> '0' and
              %subst(focu:x:1) <> '1' and
              %subst(focu:x:1) <> '2' and
              %subst(focu:x:1) <> '3' and
              %subst(focu:x:1) <> '4' and
              %subst(focu:x:1) <> '5' and
              %subst(focu:x:1) <> '6' and
              %subst(focu:x:1) <> '7' and
              %subst(focu:x:1) <> '8' and
              %subst(focu:x:1) <> '9';
              %subst(focu:x:1) = '0';
           endif;
       endfor;
       a = %subst(focu:1:4);
       m = %subst(focu:5:2);
       d = %subst(focu:7:2);
       monitor;
          @d = %dec(d:2:0);
        on-error;
          @d = 0;
       endmon;
       monitor;
          @m = %dec(m:2:0);
        on-error;
          @m = 0;
       endmon;
       monitor;
          @a = %dec(a:4:0);
        on-error;
          @a = 0;
       endmon;

       hocu = REST_getNextPart(url);
       for x = 1 to 6;
           if %subst(hocu:x:1) <> ':' and
              %subst(hocu:x:1) <> '0' and
              %subst(hocu:x:1) <> '1' and
              %subst(hocu:x:1) <> '2' and
              %subst(hocu:x:1) <> '3' and
              %subst(hocu:x:1) <> '4' and
              %subst(hocu:x:1) <> '5' and
              %subst(hocu:x:1) <> '6' and
              %subst(hocu:x:1) <> '7' and
              %subst(hocu:x:1) <> '8' and
              %subst(hocu:x:1) <> '9';
              %subst(hocu:x:1) = '0';
           endif;
       endfor;
       h = %subst(hocu:1:2);
       i = %subst(hocu:3:2);
       s = %subst(hocu:5:2);
       monitor;
          @h = %dec(h:2:0);
        on-error;
          @h = 0;
       endmon;
       monitor;
          @i = %dec(i:2:0);
        on-error;
          @i = 0;
       endmon;
       monitor;
          @s = %dec(s:2:0);
        on-error;
          @s = 0;
       endmon;

       if filt <> 'R' and filt <> 'P';
          filt = 'P';
       endif;

       // ---------------------------------------
       // Busca por Rama/Póliza
       // ---------------------------------------
       if filt = 'R';
          rama = REST_getNextPart(url);
          poli = REST_getNextPart(url);
          monitor;
              peRama = %dec(rama:2:0);
           on-error;
              peRama = 0;
          endmon;
          monitor;
              pePoli = %dec(poli:7:0);
           on-error;
              pePoli = 0;
          endmon;
          k1hed0.d0empr = empr;
          k1hed0.d0sucu = sucu;
          k1hed0.d0rama = peRama;
          k1hed0.d0poli = pePoli;
          chain %kds(k1hed0:4) pahed004;
          if not %found;
             %subst(@@repl:1:2) = rama;
             %subst(@@repl:3:7) = poli;
             %subst(@@repl:10:1) = nivt;
             %subst(@@repl:11:5) = nivc;
             rc2 = SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'POL0001'
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
             SVPREST_end();
             close *all;
             return;
          endif;
          pxFocu = d + '/' + m + '/' + a;
          pxHocu = h + ':' + i + ':' + s;
          WSPVIG( peBase
                : peRama
                : pePoli
                : pxFocu
                : pxHocu
                : peVige
                : peCfin
                : peErro
                : peMsgs  );
          if peErro = -1;
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
          if peVige = 'N';
             peMsgs.peMsid = 'VIG0001';
             peMsgs.peMsev = 40;
             peMsgs.peMsg1 = 'La póliza indicada no se encuentra vi'
                           + 'gente.';
             peMsgs.peMsg2 = 'La póliza indicada no se encuentra vi'
                           + 'gente a la fecha/hora del siniestro.';
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
          clear @@msgs;
          if peCfin = 'N';
             @@msgs.peMsid = 'VIG0002';
             @@msgs.peMsev = 10;
             @@msgs.peMsg1 = 'La póliza indicada no posee cobertura'
                           + ' financiera.';
             @@msgs.peMsg2 = 'La póliza indicada no posee cobertura'
                           + ' financiera a la fecha/hora del sinie'
                           + 'stro.';
          endif;
          pxRama = peRama;
          pxPoli = pePoli;
          exsr $poliza;
       endif;

       if filt = 'P';
          pate = REST_getNextPart(url);
       endif;

       // ---------------------------------------
       // Busca por Patente
       // ---------------------------------------
       if filt = 'P';
          peFocu = (@a * 10000) + (@m * 100) + @d;
          peHocu = (@h * 10000) + (@i * 100) + @s;
          PRS002( peBase
                : pate
                : peFocu
                : peHocu
                : pxRama
                : pxPoli
                : peArcd
                : peSpol
                : peErro
                : peMsgs   );
          if peErro = -1;
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
          exsr $poliza;
       endif;

       return;

       begsr $poliza;
        WSPCSP( peBase
              : pxRama
              : pxPoli
              : %date()
              : peCast
              : peCasp
              : peCass
              : peCasi
              : peErro
              : peMsgs );
        if peErro = -1;
           peCasi = 0;
        endif;
        nase = *blanks;
        npro = *blanks;
        dsop = *blanks;
        femi = *blanks;
        fdes = *blanks;
        fhas = *blanks;
        nmoc = *blanks;
        prim = *blanks;
        prem = *blanks;
        k1hed0.d0empr = empr;
        k1hed0.d0sucu = sucu;
        k1hed0.d0rama = pxRama;
        k1hed0.d0poli = pxPoli;
        chain %kds(k1hed0:4) pahed004;
        if %found;
           k1hec0.c0empr = d0empr;
           k1hec0.c0sucu = d0sucu;
           k1hec0.c0arcd = d0arcd;
           k1hec0.c0spol = d0spol;
           chain %kds(k1hec0) pahec0;
           if %found;
              chain c0asen gnhdaf;
              if %found;
                 nase = dfnomb;
              endif;
              k1hni2.n2empr = c0empr;
              k1hni2.n2sucu = c0sucu;
              k1hni2.n2nivt = c0nivt;
              k1hni2.n2nivc = c0nivc;
              chain %kds(k1hni2) sehni201;
              if %found;
                 npro = dfnomb;
              endif;
              setgt  %kds(k1hec0:4) pahec1;
              readpe %kds(k1hec0:4) pahec1;
              if not %eof;
                 k1t901.t@tiou = c1tiou;
                 k1t901.t@stou = c1stou;
                 chain %kds(k1t901) set901;
                 if %found;
                    dsop = t@dsop;
                 endif;
              endif;
           endif;
        endif;
        femi = %editc(c0fema:'X')
             + '-'
             + %editc(c0femm:'X')
             + '-'
             + %editc(c0femd:'X');
        fdes = %editc(c0fioa:'X')
             + '-'
             + %editc(c0fiom:'X')
             + '-'
             + %editc(c0fiod:'X');
        fhas = %editc(c0fvoa:'X')
             + '-'
             + %editc(c0fvom:'X')
             + '-'
             + %editc(c0fvod:'X');
        chain c0mone gntmon;
        if %found;
           nmoc = monmoc;
        endif;
        prim = %editw( c1prim : '                 .  -' );
        prem = %editw( c1prem : '                 .  -' );
        if PeCfin = 'N';
          rc = REST_writeHeader( 200
                               : *omit
                               : *omit
                               : @@msgs.peMsid
                               : @@msgs.peMsev
                               : @@msgs.peMsg1
                               : @@msgs.peMsg2 );
        else;
          REST_writeHeader();
        endif;
        REST_writeEncoding();
        REST_writeXmlLine('polizas':'*BEG');
        REST_writeXmlLine('poliza':'*BEG');
         REST_writeXmlLine('rama': %trim(%char(pxrama)) );
         REST_writeXmlLine('nroPoliza': %trim(%char(pxpoli)) );
         REST_writeXmlLine('tipoOperacion':%trim(dsop));
         REST_writeXmlLine('nombreAsegurado': %trim(nase)          );
         REST_writeXmlLine('codigoProductor': %trim(%char(c0nivc)));
         REST_writeXmlLine('nombreProductor': %trim(npro));
         REST_writeXmlLine('fechaEmision': %trim(femi));
         REST_writeXmlLine('fechaVigDesd': %trim(fdes));
         REST_writeXmlLine('fechaVigHast': %trim(fhas));
         REST_writeXmlLine('moneda': %trim(nmoc));
         REST_writeXmlLine('prima': %trim(prim));
         REST_writeXmlLine('premio':%trim(prem));
         if filt = 'P';
            REST_writeXmlLine('patente':%trim(pate));
          else;
            REST_writeXmlLine('patente':*blanks);
         endif;
         REST_writeXmlLine('cantidadSiniestros':%trim(%char(peCasi)));
         REST_writeXmlLine('articulo':%trim(%char(c0arcd)));
         REST_writeXmlLine('superpoliza':%trim(%char(c0spol)));
         REST_writeXmlLine('tieneCoberturaFinanciera': peCfin );
         REST_writeXmlLine('estaVigente': peVige );
        REST_writeXmlLine( 'poliza ' : '*END' );
        REST_writeXmlLine( 'polizas' : '*END' );
       endsr;

      /end-free
