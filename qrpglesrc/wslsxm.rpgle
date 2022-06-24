     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLSXM  : Tareas generales.                                  *
      *           WebService - Retorna Saldo Cta.Cte x Mayor         *
      *                        auxiliar.                             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *27-Abr-2015  *
      * ------------------------------------------------------------ *
      * SGF 29/05/2015: Constantes algunos parámetros.               *
      *                 Paso *LDA a calificada.                      *
      *                 Unifico criterios: todo a /free              *
      *                                                              *
      * ************************************************************ *
     Fcntnau    if   e           k disk
     Fgntmon    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'

     D WSLSXM          pr                  ExtPgm('WSLSXM')
     D   peBase                            likeds(paramBase) const
     D   peComa                       2a   const
     D   peNrma                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 const
     D   peMone                       2a
     D   peNmol                      30a
     D   peNmoc                       5a
     D   peSald                      15  2
     D   peDeha                       1  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSXM          pi
     D   peBase                            likeds(paramBase) const
     D   peComa                       2a   const
     D   peNrma                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 const
     D   peMone                       2a
     D   peNmol                      30a
     D   peNmoc                       5a
     D   peSald                      15  2
     D   peDeha                       1  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPWLIBLC        pr                  ExtPgm('TAATOOL/SPWLIBLC')
     D   peEnto                       1a   const

     D PAR365          pr                  ExtPgm('PAR365')
     D   znivt                        1  0
     D   znivc                        5  0
     D   zcoma                        2
     D   znrma                        7  0
     D   zotro                        1
     D   zmepg                        1
     D   zsald                       15  2
     D   zreto                        3
     D   zfdea                        4  0
     D   zfdem                        2  0
     D   zfded                        2  0
     D   zfhaa                        4  0
     D   zfham                        2  0
     D   zfhad                        2  0
     D   zesm0                        1  0
     D   zesm1                        1  0
     D   zesm2                        1  0
     D   zesm3                        1  0
     D   zesm4                        1  0
     D   zesm5                        1  0
     D   zesm6                        1  0
     D   zesm7                        1  0
     D   zesm8                        1  0
     D   zesm9                        1  0
     D   zmone                        2

     D ktnau           ds                  likerec(c1tnau:*key)

     D pnivt           s              1  0
     D pnivc           s              5  0
     D pcoma           s              2
     D pnrma           s              7  0
     D potro           s              1
     D pmepg           s              1
     D psald           s             15  2
     D preto           s              3
     D pfdea           s              4  0
     D pfdem           s              2  0
     D pfded           s              2  0
     D pfhaa           s              4  0
     D pfham           s              2  0
     D pfhad           s              2  0
     D pesm0           s              1  0
     D pesm1           s              1  0
     D pesm2           s              1  0
     D pesm3           s              1  0
     D pesm4           s              1  0
     D pesm5           s              1  0
     D pesm6           s              1  0
     D pesm7           s              1  0
     D pesm8           s              1  0
     D pesm9           s              1  0
     D pmone           s              2

     D                 ds
     D faammdd                 1      8s 0
     D faa                     1      4s 0
     D fmm                     5      6s 0
     D fdd                     7      8s 0

     D respue          s          65536
     D longm           s             10i 0
     D saldo           s             15  2

     D local           ds                  dtaara(*lda) qualified
     D   moneda                       2a   overlay(local:420)

       *inLr = *On;

       SPWLIBLC('P');

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       peMone  = *Blank;
       peNmol  = *Blank;
       peNmoc  = *Blank;
       peSald  = *Zeros;
       peDeha  = *Zeros;
       peErro  = *Zeros;

       clear peMsgs;

       ktnau.naempr = pebase.peEmpr;
       ktnau.nasucu = pebase.peSucu;
       ktnau.nacoma = peComa;
       ktnau.nanrma = peNrma;

       chain %kds (ktnau:4) cntnau;

       if not %found( cntnau );
          %subst(respue:1:2) = peComa;
          %subst(respue:3:7) = %trim(%char(peNrma));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MAY0001'
                       : peMsgs
                       : %trim(respue)
                       : %len(%trim(respue)) );
          peErro = -1;
          return;
       endif;

       if peFdes > peFhas;
          respue = *blank;
          longm  = *Zeros;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'GEN0003'
                       : peMsgs
                       : respue
                       : 0 );
          peErro = -1;
          return;
       endif;

       in local;

       pnivt = *Zeros;
       pnivc = *Zeros;
       pcoma = peComa;
       pnrma = peNrma;
       potro = 'B';
       pmepg = *Blank;
       psald = *Zeros;
       preto = *Blank;
       faammdd = peFdes;
       pfdea = faa;
       pfdem = fmm;
       pfded = fdd;
       faammdd = peFhas;
       pfhaa = faa;
       pfham = fmm;
       pfhad = fdd;
       pesm0 = *Zeros;
       pesm1 = *Zeros;
       pesm2 = *Zeros;
       pesm3 = *Zeros;
       pesm4 = *Zeros;
       pesm5 = *Zeros;
       pesm6 = *Zeros;
       pesm7 = *Zeros;
       pesm8 = *Zeros;
       pesm9 = *Zeros;
       pmone = *Blank;

       PAR365( pnivt
             : pnivc
             : pcoma
             : pnrma
             : potro
             : pmepg
             : psald
             : preto
             : pfdea
             : pfdem
             : pfded
             : pfhaa
             : pfham
             : pfhad
             : pesm0
             : pesm1
             : pesm2
             : pesm3
             : pesm4
             : pesm5
             : pesm6
             : pesm7
             : pesm8
             : pesm9
             : pmone );

       saldo = psald;
       preto = 'FIN';

       PAR365( pnivt
             : pnivc
             : pcoma
             : pnrma
             : potro
             : pmepg
             : psald
             : preto
             : pfdea
             : pfdem
             : pfded
             : pfhaa
             : pfham
             : pfhad
             : pesm0
             : pesm1
             : pesm2
             : pesm3
             : pesm4
             : pesm5
             : pesm6
             : pesm7
             : pesm8
             : pesm9
             : pmone );

       chain (local.moneda) gntmon;

       peMone = local.moneda;
       peNmol = monmol;
       peNmoc = monmoc;
       peSald = %abs(saldo);

       if saldo >= *zero;
          peDeha = 1;
       else;
          peDeha = 2;
       endif;

       return;
