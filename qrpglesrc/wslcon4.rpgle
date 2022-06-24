     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCON4: WebService                                          *
      *          Certificado de Póliza sin deuda vencida.            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *10-Nov-2015        *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * EXT 30/01/2018: control de deuda vencida de toda la poliza   *
      * ************************************************************ *
     Fpahed004  if   e           k disk
     Fpahec1    if   e           k disk
     Fpahcc2    if   e           k disk
     Fcntbco    if   e           k disk
     Fgnttc101  if   e           k disk    prefix(t1:2)
     Fset001    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fgntfpg    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLCON4         pr                  ExtPgm('WSLCON4')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peText                            likeds(SdvTxt_t) dim(10)
     D   peTextC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D WSLCON4         pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peText                            likeds(SdvTxt_t) dim(10)
     D   peTextC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D unloadAll       pr

     D SPWLIBLC        pr                  ExtPgm('TAATOOL/SPWLIBLC')
     D  peEnto                        1a   const

     D SPCOBFIN        pr                  extpgm('SPCOBFIN')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peFech                        8  0
     D  peConv                        1    const
     D  peCobf                         n
     D  peFpgm                        3a   const

     D SPVIG2          pr                  extpgm('SPVIG2')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peFech                        8  0 const
     D  peFemi                        8  0 const
     D  peVige                        1N
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3a   const

     D tot             s             80a   dim(10) ctdata perrcd(1)
     D tar             s             80a   dim(10) ctdata perrcd(1)
     D bco             s             80a   dim(10) ctdata perrcd(1)
     D cob             s             80a   dim(10) ctdata perrcd(1)
     D meses           s             10a   dim(12) ctdata perrcd(1)

     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1hcc2          ds                  likerec(p1hcc2:*key)

     D rc              s              1N
     D peVige          s              1N
     D peCobf          s              1N
     D @pagt           s              1N
     D @hafa           s              8  0
     D @ini            s              8  0
     D feccobf         s              8  0
     D pxSspo          s              3  0
     D pxSuop          s              3  0
     D @sspo           s              3  0
     D x               s             10i 0
     D pVig2           s              1a
     D pCobf           s              1a
     D fin             s              8a
     D des             s              8a
     D fina            s              4a
     D finm            s              2a
     D find            s              2a
     D desa            s              4a
     D desm            s              2a
     D desd            s              2a
     D @rpl            s          65535a

      /free

       *inlr = *on;

       clear peMsgs;
       peErro = 0;
       pVig2 = *blank;
       pCobf = *blank;

       SPWLIBLC('P');

       // -------------------------------------
       // Chequeo parámetro base
       // -------------------------------------
       rc = SVPWS_chkParmBase( peBase : peMsgs );
       if rc = *off;
          peErro = -1;
          return;
       endif;

       // -------------------------------------
       // Chequeo existencia de póliza
       // -------------------------------------
       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       k1hed0.d0suop = peSuop;

       setll %kds(k1hed0:4) pahed004;
       if not %equal;
          %subst(@rpl:1:2)  = %editc(peRama:'X');
          %subst(@rpl:3:7)  = %trim(%char(pePoli));
          %subst(@rpl:10:1) = %editc(peBase.peNivt:'X');
          %subst(@rpl:11:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@rpl)
                       : %len(%trim(@rpl)) );
          peErro = -1;
          return;
       endif;

       // ---------------------------------------
       // Chequeo existencia de suplemento póliza
       // ---------------------------------------
       setll %kds(k1hed0:5) pahed004;
       if not %equal;
          %subst(@rpl:1:3)  = %editc(peSuop:'X');
          %subst(@rpl:4:2)  = %editc(peRama:'X');
          %subst(@rpl:6:7)  = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0008'
                       : peMsgs
                       : %trim(@rpl)
                       : %len(%trim(@rpl)) );
          peErro = -1;
          return;
       endif;

       chain peRama set001;
       if not %found;
          t@ramd = *all'*';
       endif;

       // ---------------------------------------
       // Obtengo SuperPóliza de la póliza
       // ---------------------------------------
       chain %kds(k1hed0:5) pahed004;

       // ---------------------------------------
       // Verifico vigente
       // ---------------------------------------
       SPVIG2( d0arcd
             : d0spol
             : d0rama
             : d0arse
             : d0oper
             : %dec(%date():*iso)
             : 99999999
             : peVige
             : pxSspo
             : pxSuop
             : *blanks );
       pVig2 = 'L';
       if peVige = *off;
          unloadAll();
          %subst(@rpl:1:2)  = %editc(peRama:'X');
          %subst(@rpl:3:7)  = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'CON0001'
                       : peMsgs
                       : %trim(@rpl)
                       : %len(%trim(@rpl)) );
          peErro = -1;
          return;
       endif;

       // ---------------------------------------
       // Obtengo hasta facturado
       // ---------------------------------------
       @hafa = 0;
       @sspo = 0;
       setgt  %kds(k1hed0:5) pahed004;
       readpe %kds(k1hed0:4) pahed004;
       dow not %eof;
           if d0tiou = 1 or
              d0tiou = 2 or
              (d0tiou = 3 and d0stos = 1);
              @hafa = (d0fhfa * 10000)
                    + (d0fhfm *   100)
                    +  d0fhfd;
              @ini  = (d0fioa * 10000)
                    + (d0fiom *   100)
                    +  d0fiod;
              @sspo = d0sspo;
              leave;
           endif;
        readpe %kds(k1hed0:4) pahed004;
       enddo;

       // ---------------------------------------
       // Si hoy es anterior a Hasta facturado
       // controlo cobertura financiera a hoy,
       // si no, controlo a fecha hasta facturado
       // ---------------------------------------
       feccobf = @hafa;
       if %dec(%date():*iso) < @hafa;
          feccobf = %dec(%date():*iso);
       endif;

       SPCOBFIN( d0empr
               : d0sucu
               : d0arcd
               : d0spol
               : feccobf
               : 'P'
               : peCobf
               : *blanks );

       pCobf = 'L';
       // ---------------------------------------
       // Si no tiene cobertura financiera, es
       // error
       // ---------------------------------------
       if peCobf = *off;
          unloadAll();
          %subst(@rpl:1:2)  = %editc(peRama:'X');
          %subst(@rpl:3:7)  = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'CON0002'
                       : peMsgs
                       : %trim(@rpl)
                       : %len(%trim(@rpl)) );
          peErro = -1;
          return;
       endif;

       // ---------------------------------------
       // Veo si tiene todas las cuotas pagadas
       // porque el texto es distinto
       // ---------------------------------------
       @pagt = *on;
       k1hcc2.c2empr = d0empr;
       k1hcc2.c2sucu = d0sucu;
       k1hcc2.c2arcd = d0arcd;
       k1hcc2.c2spol = d0spol;
       setll %kds(k1hcc2:4) pahcc2;
       reade %kds(k1hcc2:4) pahcc2;
       dow not %eof;
           if c2sttc <> '3';
              @pagt = *off;
              leave;
           endif;
        reade %kds(k1hcc2:4) pahcc2;
       enddo;

       // ---------------------------------------
       // Forma de pago
       // ---------------------------------------
       k1hec1.c1empr = d0empr;
       k1hec1.c1sucu = d0sucu;
       k1hec1.c1arcd = d0arcd;
       k1hec1.c1spol = d0spol;
       setgt  %kds(k1hec1:4) pahec1;
       readpe %kds(k1hec1:4) pahec1;

       chain c1cfpg gntfpg;
       if not %found;
          fpdefp = *all'*';
       endif;

       chain c1asen gnhdaf;
       if not %found;
          dfnomb = *all'*';
       endif;

       fin = %editc(@hafa:'X');
       des = %editc(@ini :'X');

       fina = %subst(fin:1:4);
       finm = %subst(fin:5:2);
       find = %subst(fin:7:2);

       desa = %subst(des:1:4);
       desm = %subst(des:5:2);
       desd = %subst(des:7:2);

       if @pagt;
          peTextC = 10;
          for x = 1 to 10;
              peText(x).nrli = x;
              peText(x).text = tot(x);
              peText(x).text = %scanrpl( '%P%'
                                       : %trim(%char(pePoli))
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%R%'
                                       : %trim(t@ramd)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%A%'
                                       : %trim(dfnomb)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%D%'
                                       : desd + '/' + desm + '/' + desa
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%H%'
                                       : find + '/' + finm + '/' + fina
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%S%'
                                       : %char(*day)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%Ñ%'
                                       : %editc(*year:'X')
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%E%'
                                       : %trim(meses(*month))
                                       : peText(x).text      );
          endfor;
          unloadAll();
          return;
       endif;

       // ----------------------------------
       // Pago con Tarjeta de Crédito
       // ----------------------------------
       if c1cfpg = 1;
          chain c1ctcu gnttc101;
          if not %found;
             t1nomb = *all'*';
          endif;
          peTextC = 10;
          for x = 1 to 10;
              peText(x).nrli = x;
              peText(x).text = tar(x);
              peText(x).text = %scanrpl( '%P%'
                                       : %trim(%char(pePoli))
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%R%'
                                       : %trim(t@ramd)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%A%'
                                       : %trim(dfnomb)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%D%'
                                       : desd + '/' + desm + '/' + desa
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%H%'
                                       : find + '/' + finm + '/' + fina
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%S%'
                                       : %char(*day)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%Ñ%'
                                       : %editc(*year:'X')
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%E%'
                                       : %trim(meses(*month))
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%T%'
                                       : %trim(t1nomb)
                                       : peText(x).text      );
          endfor;
          unloadAll();
          return;
       endif;

       // ----------------------------------
       // Pago con Débito en cuenta
       // ----------------------------------
       if c1cfpg = 2 or c1cfpg = 3;
          chain c1ivbc cntbco;
          if not %found;
             bcnomb = *all'*';
          endif;
          peTextC = 10;
          for x = 1 to 10;
              peText(x).nrli = x;
              peText(x).text = bco(x);
              peText(x).text = %scanrpl( '%P%'
                                       : %trim(%char(pePoli))
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%R%'
                                       : %trim(t@ramd)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%A%'
                                       : %trim(dfnomb)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%D%'
                                       : desd + '/' + desm + '/' + desa
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%H%'
                                       : find + '/' + finm + '/' + fina
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%S%'
                                       : %char(*day)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%Ñ%'
                                       : %editc(*year:'X')
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%E%'
                                       : %trim(meses(*month))
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%B%'
                                       : %trim(bcnomb)
                                       : peText(x).text      );
          endfor;
          unloadAll();
          return;
       endif;

       // ----------------------------------
       // Cobrador
       // ----------------------------------
       if c1cfpg = 4;
          peTextC = 10;
          for x = 1 to 10;
              peText(x).nrli = x;
              peText(x).text = cob(x);
              peText(x).text = %scanrpl( '%P%'
                                       : %trim(%char(pePoli))
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%R%'
                                       : %trim(t@ramd)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%A%'
                                       : %trim(dfnomb)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%D%'
                                       : desd + '/' + desm + '/' + desa
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%H%'
                                       : find + '/' + finm + '/' + fina
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%S%'
                                       : %char(*day)
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%Ñ%'
                                       : %editc(*year:'X')
                                       : peText(x).text      );
              peText(x).text = %scanrpl( '%E%'
                                       : %trim(meses(*month))
                                       : peText(x).text      );
          endfor;
          unloadAll();
          return;
       endif;

       unloadAll();

      /end-free

     P unloadAll       B
     D unloadAll       pr

      /free

       if pVig2 = 'L';
          SPVIG2( d0arcd
                : d0spol
                : d0rama
                : d0arse
                : d0oper
                : %dec(%date():*iso)
                : 99999999
                : peVige
                : pxSspo
                : pxSuop
                : 'FIN'   );
       endif;

       if pCobf = 'L';
          SPCOBFIN( d0empr
                  : d0sucu
                  : d0arcd
                  : d0spol
                  : @hafa
                  : 'P'
                  : peCobf
                  : 'FIN'   );
       endif;

      /end-free

     P unloadAll       E
**
Certificamos por la presente que la póliza Nº %P% ramo %R%
asegurado %A%, vigencia desde %D% - %H%, se encuentra pagada totalmente.
\n\n\n
Se extiende para ser presentado ante quien corresponda, en Buenos Aires
a los %S% días del mes de %E% de %Ñ%.
**
Certificamos por la presente que la póliza Nº %P% ramo %R%
asegurado %A%, vigencia desde %D% - %H%, no registra
deuda vencida al día de la fecha, siendo la misma abonada mediante
Débito Automático de su Tarjeta %T%.
\n\n\n
Se extiende para ser presentado ante quien corresponda, en Buenos Aires
a los %S% días del mes de %E% de %Ñ%.
**
Certificamos por la presente que la póliza Nº %P% ramo %R%
asegurado %A%, vigencia desde %D% - %H%, no registra
deuda vencida al día de la fecha, siendo la misma abonada mediante
Débito Automático de su cuenta del Banco %B%.
\n\n\n
Se extiende para ser presentado ante quien corresponda, en Buenos Aires
a los %S% días del mes de %E% de %Ñ%.
**
Certificamos por la presente que la póliza Nº %P% ramo %R%
asegurado %A%, vigencia desde %D% - %H%, no registra
deuda vencida al día de la fecha.
\n\n\n
Se extiende para ser presentado ante quien corresponda, en Buenos Aires
a los %S% días del mes de %E% de %Ñ%.
**
ENERO
FEBRERO
MARZO
ABRIL
MAYO
JUNIO
JULIO
AGOSTO                              0
SEPTIEMBRE
OCTUBRE
NOVIEMBRE
DICIEMBRE
