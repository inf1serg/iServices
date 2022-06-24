     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRSUP: QUOM Versión 2                                       *
      *         Suplementos de una póliza.                           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *05-Jun-2017            *
      * ------------------------------------------------------------ *
      * Modificaciones :                                             *
      * LRG 13/12/2017 : Se incorpora nuevo TAG para Kausay          *
      * LRG 26/12/2017 : Se modifica porque No se muestran           *
      *                  correctamente las fechas de vencimiento     *
      *                  de las cuotas cuando una en tiene cuotas    *
      *                  el medio no.                                *
      * JSN 09/02/2018 : Se agrega entre los tags, el tipo de opera- *
      *                  ción, subtipo de operación, subtipo de ope- *
      *                  ración del sistema y descripción de la ope- *
      *                  ción.                                       *
      * LRG 21/03/2018 : Se solicita agregar el punto antes de los   *
      *                  importes que solo contienen decimales       *
      * JSN 07/06/2018 : Se agrega entre los tags, Código de Plan de *
      *                  Pago, Número de CBU Descifrado, Fecha de    *
      *                  Vencimiento de TDC, Cod. de empresa de TDC  *
      *                  y Número de TDC descifrado.                 *
      * EXT 23-07-18   : Nuevos tags                                 *
      *                  - <cantidadDeCuotas>                        *
      *                  - <isPagada>                                *
      *                  - <permiteRecibo>                           *
      *                  - <origenDelPago>                           *
      *                  - <imprimeOrigenDelPago>                    *
      *                  - <muestraOrigenDelPago>                    *
      * SGF 01/08/18   : Mal peSuop en getOrigenDePago.              *
      * EXT 02/08/18   : Mal peNrcu en getOrigenDePago.              *
      * SGF 02/11/18   : Origen del pago COBRADOR mostrarlo en la    *
      *                  consulta.                                   *
      * SGF 16/01/19   : Editar bien el importe de pago en cuotas.   *
      * SGF 04/07/19   : Agrego factura, chequera y cuadernillo.     *
      * JSN 16/08/2019 : Se agrega nuevos tags                       *
      * SGF 21/08/19   : Tags para copia productor y organizador.    *
      * SGF 19/02/20   : Estado de cuota.                            *
      * SGF 21/09/2020 : PDF de póliza versión corta                 *
      * SGF 16/11/21   : tipoAsistencia() trae cuadernillo.          *
      * SGF 10/06/22   : Corrijo comisión de nivel 3 cuando el que   *
      *                  se loguea es Nivel 5.                       *
      *                                                              *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fsehni201  if   e           k disk
     Fset001    if   e           k disk
     Fpahec1    if   e           k disk
     Fgntfpg    if   e           k disk
     Fgnttc101  if   e           k disk
     Fcntbco    if   e           k disk
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)
     Fpawec1v   if   e           k disk
     Fgnhdtc    if   e           k disk
     Fpahcd6    if   e           k disk
     Fivhcar01  if   e           k disk
     Fgntorp    if   e           k disk
     Fpahcc2    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'
      /copy './qcpybooks/svpcuo_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'

     D WSLSUP          pr                  ExtPgm('WSLSUP')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peAsdc                       1a   const
     D   pePosi                            likeds(keysup_t)
     D   pePreg                            likeds(keysup_t)
     D   peUreg                            likeds(keysup_t)
     D   peLsup                            likeds(pahsup_t) dim(99)
     D   peLsupC                     10i 0
     D   peMore                       1n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSU1          pr                  ExtPgm('WSLSU1')
     D   peBase                            likeds(paramBase) const
     D   peAsdc                       1a   const
     D   pePosi                            likeds(keysup_t)
     D   peLsu1                            likeds(pahsu1_t) dim(1000)
     D   peLsu1C                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLCEN          pr                  ExtPgm('WSLCEN')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peCuot                            likeds(pahcuo_t) dim(100)
     D   peCuotC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPDETAON        pr                  extpgm('SPDETAON')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peEaon                        1n
     D  peEpgm                        3a   const
     D  peTpcd                        2a   options(*nopass)

     D SPDETEUR        pr                  extpgm('SPDETEUR')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peEeur                        1n
     D  peEpgm                        3a   const
     D  peTpcd                        2a   options(*nopass)

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
     D femi            s             10a
     D fdes            s             10a
     D fhas            s             10a
     D fpag            s             10a
     D fvto            s             10a
     D prim            s             30a
     D prem            s             30a
     D ipag            s             30a
     D imcu            s             30a
     D epv             s             30a
     D refi            s             30a
     D seri            s             30a
     D ipr1            s             30a
     D ipr6            s             30a
     D impu            s             30a
     D xref            s             10a
     D xrea            s             10a
     D pimp            s             10a
     D dpdf            s             55a
     D nrtc            s             20a
     D dere            s             30a
     D rc              s              1n
     D peMore          s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@rama          s              2  0
     D @imp            s             15  2
     D ximp            s              5  2
     D @@repl          s          65535a
     D peErro          s             10i 0
     D peErr1          s             10i 0
     D x               s             10i 0
     D h               s             10i 0
     D q               s             10i 0
     D z               s             10i 0
     D peLsu1C         s             10i 0
     D peLsupC         s             10i 0
     D peCuotC         s             10i 0
     D @@dura          s             40a
     D copr            s             30a
     D @@kaus          s              1a
     D @@Ffta          s              4  0
     D @@Fftm          s              2  0
     D @@cbu           s             25
     D cCuotas         s              2  0
     D oriPago         s             40
     D impPago         s              1
     D muePago         s              1
     D fact_ase        s             55a
     D fact_org        s             55a
     D fact_pro        s             55a
     D chequera        s             55a
     D peEaon          s              1n
     D peEeur          s              1n
     D cuad            s            256a
     D tasi            s              3a
     D peCval          s             10a
     D peVsys          s            512a
     D @@Impo          s             30a
     D @@Porc          s             15a
     D @@Nras          s              6  0

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D pePosi          ds                  likeds(keysup_t)
     D pePos1          ds                  likeds(keysup_t)
     D pePreg          ds                  likeds(keysup_t)
     D peUreg          ds                  likeds(keysup_t)
     D peLsu1          ds                  likeds(pahsu1_t) dim(1000)
     D peLsup          ds                  likeds(pahsup_t) dim(99)
     D peCuot          ds                  likeds(pahcuo_t) dim(100)
     D k1hni2          ds                  likerec(s1hni2:*key)
     D k2hni2          ds                  likerec(s1hni201:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1wec1v         ds                  likerec(p1wec1v:*key)
     D k1ydtc          ds                  likerec(g1hdtc:*key)
     D k1hcc2          ds                  likerec(p1hcc2:*key)

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
                               : 'RAM0001'
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
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // ---------------------------------------------
       // Obtengo lista de endosos que corresponden a
       // peBase
       // ---------------------------------------------
       clear peBase;
       clear pePosi;
       clear peLsu1;
       clear peMsgs;

       peLsu1C = 0;
       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRSUP':peBase);

       pePosi.psrama = %dec(rama:2:0);
       pePosi.pspoli = %dec(poli:7:0);
       pePosi.psspol = d0spol;
       pePosi.psarcd = d0arcd;
       pePosi.pscert = d0cert;
       pePosi.psarse = d0arse;
       pePosi.psoper = d0oper;

       WSLSU1( peBase
             : 'D'
             : pePosi
             : peLsu1
             : peLsu1C
             : peErro
             : peMsgs );

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'suplementos' : '*BEG');

       if peLsu1C > 0;
          for x = 1 to peLsu1C;

              SPDETAON( d0empr
                      : d0sucu
                      : d0arcd
                      : d0spol
                      : peEaon
                      : *blanks );

              SPDETEUR( d0empr
                      : d0sucu
                      : d0arcd
                      : d0spol
                      : peEeur
                      : *blanks );

              clear pePos1;
              clear pePreg;
              clear peUreg;
              clear peLsup;
              clear peMsgs;

              peLsupC = 0;

              pePos1.psrama = d0rama;
              pePos1.pspoli = d0poli;
              pePos1.psspol = d0spol;
              pePos1.pssuop = peLsu1(x).pssspo;
              pePos1.psarcd = d0arcd;
              pePos1.pscert = d0cert;
              pePos1.pssspo = peLsu1(x).pssspo;
              pePos1.psarse = d0arse;
              pePos1.psoper = d0oper;

              WSLSUP( peBase
                    : 1
                    : 'I'
                    : 'A'
                    : pePos1
                    : pePreg
                    : peUreg
                    : peLsup
                    : peLsupC
                    : peMore
                    : peErro
                    : peMsgs );

              if peErro = 0;
                 if peLsupC > 0;

                    k1wec1v.wcempr = peLsup(1).psempr;
                    k1wec1v.wcsucu = peLsup(1).pssucu;
                    k1wec1v.wcarcd = peLsup(1).psarcd;
                    k1wec1v.wcspol = peLsup(1).psspol;
                    k1wec1v.wcsspo = peLsup(1).pssspo;
                    setll %kds( k1wec1v : 5 ) pawec1v;
                    if %equal;
                      @@kaus = 'S';
                    else;
                      @@kaus = 'N';
                    endif;

                    femi = %char(peLsup(1).psfemi:*iso);
                    fdes = %char(peLsup(1).psfdes:*iso);
                    fhas = %char(peLsup(1).psfhas:*iso);
                    prim = %editw(peLsup(1).psprim:'            0.  ');
                    if peLsup(1).psprim = 0;
                       prim = '.00';
                    endif;
                    if peLsup(1).psprim < 0;
                       prim = '-' + %trim(prim);
                    endif;
                    prem = %editw(peLsup(1).psprem:'            0.  ');
                    if peLsup(1).psprem = 0;
                       prim = '.00';
                    endif;
                    if peLsup(1).psprem < 0;
                       prem = '-' + %trim(prem);
                    endif;
                    epv  = %editw(peLsup(1).psread:'            0.  ');
                    if peLsup(1).psread = 0;
                       epv = '.00';
                    endif;
                    if peLsup(1).psread < 0;
                       epv = '-' + %trim(epv);
                    endif;
                    refi = %editw(peLsup(1).psrefi:'            0.  ');
                    if peLsup(1).psrefi = 0;
                       refi = '.00';
                    endif;
                    if peLsup(1).psrefi < 0;
                       refi = '-' + %trim(refi);
                    endif;
                    seri = %editw(peLsup(1).psseri:'            0.  ');
                    if peLsup(1).psseri = 0;
                       seri = '.00';
                    endif;
                    if peLsup(1).psseri < 0;
                       seri = '-' + %trim(seri);
                    endif;
                    ipr1 = %editw(peLsup(1).psipr1:'            0.  ');
                    if peLsup(1).psipr1 = 0;
                       ipr1 = '.00';
                    endif;
                    if peLsup(1).psipr1 < 0;
                       ipr1 = '-' + %trim(ipr1);
                    endif;
                    ipr6 = %editw(peLsup(1).psipr6:'            0.  ');
                    if peLsup(1).psipr6 = 0;
                       ipr6 = '.00';
                    endif;
                    if peLsup(1).psipr6 < 0;
                       ipr6 = '-' + %trim(ipr6);
                    endif;
                    @imp = peLsup(1).psimpi +peLsup(1).pssers +peLsup(1).pstssn;
                    impu = %editw(@imp:'            0.  ');
                    if @imp = 0;
                       impu = '.00';
                    endif;
                    if @imp < 0;
                       impu = '-' + %trim(impu);
                    endif;
                    ximp = peLsup(1).pspimi +peLsup(1).pspsso +peLsup(1).pspssn;
                    pimp = %editw(ximp:'  0.  ');
                    if ximp = 0;
                       pimp = '.00';
                    endif;
                    xref = %editw(peLsup(1).psxref:'  0.  ');
                    if peLsup(1).psxref = 0;
                       xref = '.00';
                    endif;
                    xrea = %editw(peLsup(1).psxrea:'  0.  ');
                    if peLsup(1).psxrea = 0;
                       xrea = '.00';
                    endif;
                    dere = %editw(peLsup(1).psdere:'            0.  -');
                    if peLsup(1).psdere = 0;
                       dere = '.00';
                    endif;
                    if peLsup(1).psdere < 0;
                       dere = '-' + %trim(dere);
                    endif;
                    dpdf = 'POLIZA_'
                         + %editc(d0arcd:'X')
                         + '_'
                         + %editc(d0spol:'X')
                         + '_'
                         + %editc(peLsup(1).pssspo:'X')
                         + '_'
                         + %editc(d0rama:'X')
                         + '_'
                         + %editc(d0poli:'X')
                         + '_'
                         + %editc(peLsup(1).pssuop:'X')
                         + '.pdf';
                    fact_ase = 'POLIZA_'
                             + %editc(d0arcd:'X')
                             + '_'
                             + %editc(d0spol:'X')
                             + '_'
                             + %editc(peLsup(1).pssspo:'X')
                             + '_'
                             + %editc(d0rama:'X')
                             + '_'
                             + %editc(d0poli:'X')
                             + '_'
                             + %editc(peLsup(1).pssuop:'X')
                             + '_FAA'
                             + '.pdf';
                    chequera = 'POLIZA_'
                             + %editc(d0arcd:'X')
                             + '_'
                             + %editc(d0spol:'X')
                             + '_'
                             + %editc(peLsup(1).pssspo:'X')
                             + '_'
                             + %editc(d0rama:'X')
                             + '_'
                             + %editc(d0poli:'X')
                             + '_'
                             + %editc(peLsup(1).pssuop:'X')
                             + '_CHE'
                             + '.pdf';
                    fact_org = 'POLIZA_'
                             + %editc(d0arcd:'X')
                             + '_'
                             + %editc(d0spol:'X')
                             + '_'
                             + %editc(peLsup(1).pssspo:'X')
                             + '_'
                             + %editc(d0rama:'X')
                             + '_'
                             + %editc(d0poli:'X')
                             + '_'
                             + %editc(peLsup(1).pssuop:'X')
                             + '_FAO'
                             + '.pdf';
                    fact_pro = 'POLIZA_'
                             + %editc(d0arcd:'X')
                             + '_'
                             + %editc(d0spol:'X')
                             + '_'
                             + %editc(peLsup(1).pssspo:'X')
                             + '_'
                             + %editc(d0rama:'X')
                             + '_'
                             + %editc(d0poli:'X')
                             + '_'
                             + %editc(peLsup(1).pssuop:'X')
                             + '_FAP'
                             + '.pdf';

                    chain peLsup(1).pscfpg gntfpg;
                    if not %found;
                       fpdefp = *blanks;
                    endif;

                    bcnomb = *blanks;
                    dfnomb = *blanks;
                    nrtc   = *blanks;

                    @@cbu  = peLsup(1).psncta;

                    select;
                     when peLsup(1).pscfpg = 1;
                          chain peLsup(1).psctcu gnttc101;
                          nrtc = %editc(peLsup(1).psnrtc:'X');
                          q = 0;
                          for h = 20 downto 1;
                              if %subst(nrtc:h:1) <> ' ';
                                 q += 1;
                                 if q > 4;
                                    %subst(nrtc:h:1) = '*';
                                 endif;
                              endif;
                          endfor;
                     when peLsup(1).pscfpg = 2 or peLsup(1).pscfpg = 3;
                          chain peLsup(1).psivbc cntbco;
                          for h = 25 downto 1;
                              if %subst(peLsup(1).psncta:h:1) <> ' ';
                                 q += 1;
                                 if q > 4;
                                    %subst(peLsup(1).psncta:h:1) = '*';
                                 endif;
                              endif;
                          endfor;
                    endsl;

                    REST_writeXmlLine( 'suplemento' : '*BEG' );
                    REST_writeXmlLine( 'nro'         : %char(peLsup(1).pssspo));
                    REST_writeXmlLine( 'operacion'   : peLsup(1).psdsop);
                    REST_writeXmlLine( 'asegurado'   : peLsup(1).psasno);
                    REST_writeXmlLine( 'polAnterior' : %char(peLsup(1).pspoan));
                    REST_writeXmlLine( 'polSiguiente': %char(peLsup(1).psponu));
                    REST_writeXmlLine( 'fechaEmis'   : femi);
                    REST_writeXmlLine( 'fechaDesde'  : fdes);
                    REST_writeXmlLine( 'fechaHasta'  : fhas);
                    REST_writeXmlLine( 'moneda'      : peLsup(1).psnmoc);
                    REST_writeXmlLine( 'prima'       : prim);
                    REST_writeXmlLine( 'premio'      : prem);
                    REST_writeXmlLine( 'extraPaFija' : dere );
                    REST_writeXmlLine( 'extraPaVar'  : epv );
                    REST_writeXmlLine( 'porcExtraPaVar': xrea);
                    REST_writeXmlLine( 'recFinanciero': refi);
                    REST_writeXmlLine( 'porcRecFinanciero': xref);
                    REST_writeXmlLine( 'documentoPdf': %trim(dpdf));
                    REST_writeXmlLine( 'impuestos': impu);
                    REST_writeXmlLine( 'sellado': seri);
                    REST_writeXmlLine( 'ivaTotal': ipr1);
                    REST_writeXmlLine( 'porcIva': '21.00');
                    REST_writeXmlLine( 'ingresosBrutos' : ipr6);
                    REST_writeXmlLine( 'porcImpuestos' : pimp);
                    REST_writeXmlLine( 'formaDePago' : fpdefp);
                    REST_writeXmlLine( 'empresaTc': dfnomb);
                    REST_writeXmlLine( 'numeroTc': nrtc);
                    REST_writeXmlLine( 'banco': bcnomb);
                    REST_writeXmlLine( 'nroCbu': peLsup(1).psncta);
                    select;
                     when d0dup2 = 2;
                        @@dura = 'BIMESTRAL';
                     when d0dup2 = 3;
                        @@dura = 'TRIMESTRAL';
                     when d0dup2 = 4;
                        @@dura = 'CUATRIMESTRAL';
                     when d0dup2 = 6;
                        @@dura = 'SEMESTRAL';
                     when d0dup2 = 12;
                        @@dura = 'ANUAL';
                    endsl;
                    REST_writeXmlLine( 'duracionPer': @@dura);
                    REST_writeXmlLine( 'esperaKausay': @@kaus);
                    REST_writeXmlLine('tipoOperacion':%char(peLsup(1).pstiou));
                    REST_writeXmlLine('subTipoOper':%char(peLsup(1).psstou));
                    REST_writeXmlLine('operSistema':%char(peLsup(1).psstos));
                    REST_writeXmlLine('descripcionOperacion'
                                     :%trim(PeLsup(1).psdsop));

                    exsr comisi;

                    exsr cuotas;

                    REST_writeXmlLine('CodPlanPago':
                                      %editc(PeLsup(1).psNrpp:'X'));
                    REST_writeXmlLine('CodEmpresaTarjetaCredito':
                                      %editc(peLsup(1).psCtcu:'X'));
                    REST_writeXmlLine('NroTDC':%editc(peLsup(1).psnrtc:'X'));
                    REST_writeXmlLine('NroCBUSin':%trim(@@Cbu));

                    exsr FchVenc;

                    cCuotas = SPVSPO_getCantidadCuotasEmitidas (
                              peLsup( 1 ).psempr
                            : peLsup( 1 ).pssucu
                            : peLsup( 1 ).psarcd
                            : peLsup( 1 ).psspol
                            : peLsu1( x ).pssspo
                            : peLsup( 1 ).psrama
                            : peLsup( 1 ).psarse
                            : peLsup( 1 ).psoper
                            : peLsu1( x ).pssspo );
                    REST_writeXmlLine( 'cantidadDeCuotas' : %char( cCuotas ) );

                    REST_writeXmlLine( 'facturaAsegurado' : %trim(fact_ase) );
                    REST_writeXmlLine( 'chequeraDePago' : %trim(chequera) );

                    exsr $cuadernillo;

                    REST_writeXmlLine('cuadernilloAsistencia':%trim(cuad));

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Seem );
                    REST_writeXmlLine('selladoEmpresa': @@Impo);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Impi );
                    REST_writeXmlLine('impuestoInterno': @@Impo);

                    clear @@Porc;
                    @@Porc = %editw(d0Pimi:'  0.  ');
                    if d0Pimi = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Pimi < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceImpuestoInterno': @@Porc);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Sers );
                    REST_writeXmlLine('servicioSociales': @@Impo);

                    clear @@Porc;
                    @@Porc = %editw(d0Psso:'  0.  ');
                    if d0Psso = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Psso < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceServicioSociales': @@Porc);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Tssn );
                    REST_writeXmlLine('tasaSSN': @@Impo);

                    clear @@Porc;
                    @@Porc = %editw(d0Pssn:'  0.  ');
                    if d0Pssn = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Pssn < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceTasaSSN': @@Porc);

                    clear @@Porc;
                    @@Porc = %editw(d0Pivi:'  0.  ');
                    if d0Pivi = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Pivi < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceIvaInscripto': @@Porc);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Ipr4 );
                    REST_writeXmlLine('ivaRespNoInscripto': @@Impo);

                    clear @@Porc;
                    @@Porc = %editw(d0Pivn:'  0.  ');
                    if d0Pivn = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Pivn < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceIvaRespNoInscripto': @@Porc);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Ipr3 );
                    REST_writeXmlLine('ivaImportePercepcion': @@Impo);

                    clear @@Porc;
                    @@Porc = %editw(d0Pivr:'  0.  ');
                    if d0Pivr = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Pivr < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceIvaRes3125': @@Porc);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Ipr7 );
                    REST_writeXmlLine('ingresoBrutoRiesgo': @@Impo);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Ipr8 );
                    REST_writeXmlLine('ingresoBrutoEmpresa': @@Impo);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Ipr9 );
                    REST_writeXmlLine('componentePremio': @@Impo);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Bpri );
                    REST_writeXmlLine('bonificacionPrima': @@Impo);

                    clear @@Porc;
                    @@Porc = %editw(d0Bpip:'  0.  ');
                    if d0Bpip = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Bpip < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceBonificPrima': @@Porc);

                    clear @@Porc;
                    @@Porc = %editw(d0Bpep:'  0.  ');
                    if d0Bpep = 0;
                      @@Porc = '.00';
                    endif;
                    if d0Bpep < 0;
                      @@Porc = '-' + %trim(@@Porc);
                    endif;
                    REST_writeXmlLine('porceDerechoEmision': @@Porc);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Ipr2 );
                    REST_writeXmlLine('acciones': @@Impo);

                    clear @@Impo;
                    @@Impo = SVPREST_editImporte( d0Ipr5 );
                    REST_writeXmlLine('recargoCapital': @@Impo);
                    REST_writeXmlLine('facturaOrganizador': %trim(fact_org));
                    REST_writeXmlLine('facturaProductor': %trim(fact_pro));

                    dpdf = 'POLIZA_'
                         + %editc(d0arcd:'X')
                         + '_'
                         + %editc(d0spol:'X')
                         + '_'
                         + %editc(peLsup(1).pssspo:'X')
                         + '_'
                         + %editc(d0rama:'X')
                         + '_'
                         + %editc(d0poli:'X')
                         + '_'
                         + %editc(peLsup(1).pssuop:'X')
                         + '_ORG.pdf';
                    REST_writeXmlLine('copiaOrganizador': %trim(dpdf));
                    dpdf = 'POLIZA_'
                         + %editc(d0arcd:'X')
                         + '_'
                         + %editc(d0spol:'X')
                         + '_'
                         + %editc(peLsup(1).pssspo:'X')
                         + '_'
                         + %editc(d0rama:'X')
                         + '_'
                         + %editc(d0poli:'X')
                         + '_'
                         + %editc(peLsup(1).pssuop:'X')
                         + '_PRO.pdf';
                    REST_writeXmlLine('copiaProductor': %trim(dpdf));
                    dpdf = 'POLIZA_'
                         + %editc(d0arcd:'X')
                         + '_'
                         + %editc(d0spol:'X')
                         + '_'
                         + %editc(peLsup(1).pssspo:'X')
                         + '_'
                         + %editc(d0rama:'X')
                         + '_'
                         + %editc(d0poli:'X')
                         + '_'
                         + %editc(peLsup(1).pssuop:'X')
                         + '_CLA.pdf';
                    REST_writeXmlLine('clausulado': %trim(dpdf));

                    dpdf = 'POLIZA_'
                         + %editc(d0arcd:'X')
                         + '_'
                         + %editc(d0spol:'X')
                         + '_'
                         + %editc(peLsup(1).pssspo:'X')
                         + '_'
                         + %editc(d0rama:'X')
                         + '_'
                         + %editc(d0poli:'X')
                         + '_'
                         + %editc(peLsup(1).pssuop:'X')
                         + '_RED'
                         + '.pdf';
                    REST_writeXmlLine( 'pdfReducido': %trim(dpdf));

                    REST_writeXmlLine( 'suplemento' : '*END' );

                 endif;
              endif;

          endfor;
       endif;

       REST_writeXmlLine( 'suplementos' : '*END');
       REST_end();

       close *all;

       return;

       begsr comisi;

        REST_writeXmlLine( 'comisiones': '*BEG');
        k2hni2.n2empr = peBase.peEmpr;
        k2hni2.n2sucu = peBase.peSucu;

         // -----------------------------------------------
         // Productor
         // -----------------------------------------------
        select;
         when peBase.peNit1 = 1;

          k2hni2.n2nivt = peLsup(1).psnivt1;
          k2hni2.n2nivc = peLsup(1).psnivc1;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '1');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc1) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr1:'  0.  '));
           copr = %editw(peLsup(1).pscopr1:'            0.  ');
           if peLsup(1).pscopr1 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr1 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

         // -----------------------------------------------
         // Organizador
         // -----------------------------------------------
         when peBase.peNit1 = 3;
          k2hni2.n2nivt = peLsup(1).psnivt1;
          k2hni2.n2nivc = peLsup(1).psnivc1;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;
          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '1');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc1) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr1:'  0.  '));
           copr = %editw(peLsup(1).pscopr1:'            0.  ');
           if peLsup(1).pscopr1 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr1 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

          k2hni2.n2nivt = peLsup(1).psnivt3;
          k2hni2.n2nivc = peLsup(1).psnivc3;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '3');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc3) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr3:'  0.  '));
           copr = %editw(peLsup(1).pscopr3:'            0.  ');
           if peLsup(1).pscopr3 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr3 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

         // -----------------------------------------------
         // Productor 2
         // -----------------------------------------------
         when peBase.peNit1 = 5;

          k2hni2.n2nivt = peLsup(1).psnivt1;
          k2hni2.n2nivc = peLsup(1).psnivc1;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '1');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc1) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr1:'  0.  '));
           copr = %editw(peLsup(1).pscopr1:'            0.  ');
           if peLsup(1).pscopr1 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr1 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

          k2hni2.n2nivt = peLsup(1).psnivt3;
          k2hni2.n2nivc = peLsup(1).psnivc3;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '3');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc3) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr3:'  0.  '));
           copr = %editw(peLsup(1).pscopr3:'            0.  ');
           if peLsup(1).pscopr3 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr3 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

          k2hni2.n2nivt = peLsup(1).psnivt5;
          k2hni2.n2nivc = peLsup(1).psnivc5;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '5');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc5) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr5:'  0.  '));
           copr = %editw(peLsup(1).pscopr5:'            0.  ');
           if peLsup(1).pscopr5 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr5 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

         // -----------------------------------------------
         // Productor 3
         // -----------------------------------------------
         when peBase.peNit1 = 6;

          k2hni2.n2nivt = peLsup(1).psnivt1;
          k2hni2.n2nivc = peLsup(1).psnivc1;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '1');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc1) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr1:'  0.  '));
           copr = %editw(peLsup(1).pscopr1:'            0.  ');
           if peLsup(1).pscopr1 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr1 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

          k2hni2.n2nivt = peLsup(1).psnivt3;
          k2hni2.n2nivc = peLsup(1).psnivc3;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '3');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc3) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr3:'  0.  '));
           copr = %editw(peLsup(1).pscopr3:'            0.  ');
           if peLsup(1).pscopr3 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr3 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

          k2hni2.n2nivt = peLsup(1).psnivt5;
          k2hni2.n2nivc = peLsup(1).psnivc5;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '5');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc5) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr5:'  0.  '));
           copr = %editw(peLsup(1).pscopr5:'            0.  ');
           if peLsup(1).pscopr5 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr5 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');

          k2hni2.n2nivt = peLsup(1).psnivt6;
          k2hni2.n2nivc = peLsup(1).psnivc6;
          chain %kds(k2hni2) sehni201;
          if not %found;
             dfnomb = *blanks;
          endif;

          REST_writeXmlLine( 'comision' : '*BEG');
           REST_writeXmlLine( 'nivel' : '6');
           REST_writeXmlLine( 'codigo' : %char(peLsup(1).psnivc6) );
           REST_writeXmlLine( 'porcComision'
                            : %editw(peLsup(1).psxopr6:'  0.  '));
           copr = %editw(peLsup(1).pscopr6:'            0.  ');
           if peLsup(1).pscopr6 = 0;
              copr = '.00';
           endif;
           if peLsup(1).pscopr6 < 0;
              copr = '-' + %trim(copr);
           endif;
           REST_writeXmlLine( 'comision' : copr );
           REST_writeXmlLine( 'nombre' : dfnomb);
          REST_writeXmlLine( 'comision' : '*END');
        endsl;

        REST_writeXmlLine( 'comisiones': '*END');

       endsr;

       begsr cuotas;
        REST_writeXmlLine( 'cuotas' : '*BEG' );
        clear peCuot;
        peCuotC = 0;
        WSLCEN( peBase
              : d0arcd
              : d0spol
              : peLsu1(x).pssspo
              : d0rama
              : d0poli
              : d0arse
              : d0oper
              : peLsu1(x).pssspo
              : peCuot
              : peCuotC
              : peErr1
              : peMsgs  );
        for z = 1 to peCuotC;
            fvto = %char(peCuot(z).cdfcuo:*iso);
            if fvto = '0001-01-01';
               fvto = *blanks;
            endif;
            fpag = %char(peCuot(z).cdfpag:*iso);
            if fpag = '0001-01-01';
               fpag = *blanks;
            endif;
            imcu = %editw(peCuot(z).cdimcu:'            0.  ');
            if peCuot(z).cdimcu = 0;
               imcu = '.00';
            endif;
            if peCuot(z).cdimcu < 0;
               imcu = '-' + %trim(imcu);
            endif;
            ipag = %editw(peCuot(z).cdimpag:'            0.  ');
            if peCuot(z).cdimpag = 0;
               ipag = '.00';
            endif;
            if peCuot(z).cdimpag < 0;
               ipag = '-' + %trim(ipag);
            endif;
            REST_writeXmlLine( 'cuota' : '*BEG');
            REST_writeXmlLine( 'suplemento' : %char(peLsu1(x).pssspo) );
            REST_writeXmlLine( 'nroCuota'   : %char(peCuot(z).cdnrcu));
            REST_writeXmlLine( 'nroSubCuota': %char(peCuot(z).cdnrsc));
            REST_writeXmlLine( 'fecVto'     : fvto);
            REST_writeXmlLine( 'importeCuota' : imcu );
            REST_writeXmlLine( 'fecPago' : fpag );
            REST_writeXmlLine( 'importePago' : ipag );
            REST_writeXmlLine( 'moneda' : peCuot(z).cdnmoc);
         // if SPVSPO_chkCuotaPaga ( d0empr
         //                        : d0sucu
         //                        : d0arcd
         //                       : d0spol
         //                        : peLsu1( x ).pssspo
         //                        : peCuot( z ).cdnrcu
         //                        : peCuot( z ).cdnrsc );
         //   REST_writeXmlLine( 'isPagada' : 'S' );
         // else;
         //   REST_writeXmlLine( 'isPagada' : 'N' );
         // endif;
            if SPVSPO_chkCuotaPermiteRecibo ( d0empr
                                            : d0sucu
                                            : d0arcd
                                            : d0spol
                                            : peLsu1( x ).pssspo
                                            : peCuot( z ).cdnrcu
                                            : peCuot( z ).cdnrsc );
              REST_writeXmlLine( 'permiteRecibo' : 'S' );
            else;
              REST_writeXmlLine( 'permiteRecibo' : 'N' );
            endif;
            getOrigenPago ( d0empr
                          : d0sucu
                          : d0arcd
                          : d0spol
                          : peLsu1( x ).pssspo
                          : d0rama
                          : d0arse
                          : d0oper
                          : peLsu1( x ).pssspo
                          : peCuot( z ).cdnrcu
                          : peCuot( z ).cdnrsc
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
            k1hcc2.c2sspo = d0sspo;
            k1hcc2.c2nrcu = peCuot(z).cdnrcu;
            if SVPCUO_getNumeroAsiento(d0empr
                                            :d0sucu
                                            :d0arcd
                                            :d0spol
                                            :peLsu1( x ).pssspo
                                            :d0rama
                                            :d0arse
                                            :d0oper
                                            :peLsu1( x ).pssspo
                                            :peCuot( z ).cdnrcu
                                            :peCuot( z ).cdnrsc
                                            :*omit ) <> *zeros;
               REST_writeXmlLine( 'estadoDeCuota' : '3');
               REST_writeXmlLine( 'isPagada' : 'S' );
             else;
               REST_writeXmlLine( 'isPagada' : 'N' );
               chain %kds(k1hcc2:6) pahcc2;
                if %found;
                  REST_writeXmlLine( 'estadoDeCuota' : c2sttc );
                 else;
                  REST_writeXmlLine( 'estadoDeCuota' : '0');
                endif;
            endif;
            REST_writeXmlLine( 'cuota' : '*END');
        endfor;

        REST_writeXmlLine( 'cuotas': '*END');

       endsr;

       begsr FchVenc;

         clear @@Ffta;
         clear @@Fftm;
         k1ydtc.dfNrdf = peLsup(1).psAsen;
         k1ydtc.dfCtcu = peLsup(1).psCtcu;
         k1ydtc.dfNrtc = peLsup(1).psNrtc;
         chain %kds( k1ydtc : 3 ) gnhdtc;
         if %found( gnhdtc );
           @@Ffta = dfFfta;
           @@Fftm = dfFftm;
         endif;
           REST_writeXmlLine( 'CardExpirationYear':
                              %editc(@@Ffta:'X'));
           REST_writeXmlLine( 'CardExpirationMonth':
                              %editc(@@Fftm:'X'));

       endsr;

       begsr $cuadernillo;

        cuad = *blanks;
        tasi = SVPPOL_tipoAsistencia( d0empr
                                    : d0sucu
                                    : d0arcd
                                    : d0spol
                                    : d0rama
                                    : d0arse
                                    : d0oper
                                    : d0poli
                                    : cuad     );

       endsr;

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
            peMar2 = 'S';
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
