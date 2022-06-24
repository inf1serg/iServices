     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSPVIG  : Tareas generales.                                  *
      *           WebService - Retorna Vigente y cobertura financie- *
      *           ra.                                                *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *05-May-2017  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahed004  if   e           k disk
     Fpahec1    if   e           k disk

     D WSPVIG          pr
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peFech                       10a   const
     D  peHora                        8a   const
     D  peVige                        1a
     D  peCfin                        1a
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSPVIG          pi
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peFech                       10a   const
     D  peHora                        8a   const
     D  peVige                        1a
     D  peCfin                        1a
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

      /copy './qcpybooks/svpws_h.rpgle'

     D SPVIG2          pr                  extpgm('SPVIG2')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peFvig                        8  0 const
     D  peFemi                        8  0 const
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3a   const

     D SPCOBFIN        pr                  extpgm('SPCOBFIN')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peFcfi                        8  0 const
     D  peConv                        1a   const
     D  peCobf                        1n
     D  peFpgm                        3a   const

     D peFvig          s              8  0
     D peFemi          s              8  0
     D peStat          s              1n
     D peCobf          s              1n
     D peSspo          s              3  0
     D peSuop          s              3  0
     D @@fema_a        s              4a
     D @@femm_a        s              2a
     D @@femd_a        s              2a
     D @@fema          s              4  0
     D @@femm          s              2  0
     D @@femd          s              2  0
     D @@repl          s          65535a
     D @@nivc          s              5  0

     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)

     D lda             ds                  qualified dtaara(*lda)
     D  empr                          1a   overlay(lda:401)
     D  sucu                          2a   overlay(lda:402)

      /free

       *inlr = *on;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       lda.empr = peBase.peEmpr;
       lda.sucu = peBase.peSucu;
       out lda;

       @@femd_a = %subst(peFech:1:2);
       @@femm_a = %subst(peFech:4:2);
       @@fema_a = %subst(peFech:7:4);

       monitor;
          @@fema = %dec(@@fema_a:4:0);
          @@femm = %dec(@@femm_a:2:0);
          @@femd = %dec(@@femd_a:2:0);
        on-error;
          %subst(@@repl:1:10) = peFech;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'GEN0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endmon;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       chain %kds(k1hed0:4) pahed004;
       if not %found;
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %editc(pePoli:'X');
          %subst(@@repl:10:1) = %editc(peBase.peNivt:'X');
          %subst(@@repl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       k1hec1.c1empr = d0empr;
       k1hec1.c1sucu = d0sucu;
       k1hec1.c1arcd = d0arcd;
       k1hec1.c1spol = d0spol;
       setgt %kds(k1hec1:4) pahec1;
       readpe %kds(k1hec1:4) pahec1;
       if %eof;
          %subst(@@repl:1:6) = %trim(%char(d0arcd));
          %subst(@@repl:7:9) = %trim(%char(d0spol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       @@nivc = 0;
       select;
        when peBase.peNivt = 1;
             @@nivc = c1niv1;
        when peBase.peNivt = 2;
             @@nivc = c1niv2;
        when peBase.peNivt = 3;
             @@nivc = c1niv3;
        when peBase.peNivt = 4;
             @@nivc = c1niv4;
        when peBase.peNivt = 5;
             @@nivc = c1niv5;
        when peBase.peNivt = 6;
             @@nivc = c1niv6;
        when peBase.peNivt = 7;
             @@nivc = c1niv7;
        when peBase.peNivt = 8;
             @@nivc = c1niv8;
        when peBase.peNivt = 9;
             @@nivc = c1niv9;
       endsl;
       if peBase.peNivc <> @@nivc;
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %editc(pePoli:'X');
          %subst(@@repl:10:1) = %editc(peBase.peNivt:'X');
          %subst(@@repl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       @@nivc = 0;
       select;
        when peBase.peNit1 = 1;
             @@nivc = c1niv1;
        when peBase.peNit1 = 2;
             @@nivc = c1niv2;
        when peBase.peNit1 = 3;
             @@nivc = c1niv3;
        when peBase.peNit1 = 4;
             @@nivc = c1niv4;
        when peBase.peNit1 = 5;
             @@nivc = c1niv5;
        when peBase.peNit1 = 6;
             @@nivc = c1niv6;
        when peBase.peNit1 = 7;
             @@nivc = c1niv7;
        when peBase.peNit1 = 8;
             @@nivc = c1niv8;
        when peBase.peNit1 = 9;
             @@nivc = c1niv9;
       endsl;
       if peBase.peNiv1 <> @@nivc;
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %editc(pePoli:'X');
          %subst(@@repl:10:1) = %editc(peBase.peNit1:'X');
          %subst(@@repl:11:5) = %editc(peBase.peNiv1:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       peFvig = (@@fema * 10000)
              + (@@femm *   100)
              +  @@femd;
       peFemi = (*year  * 10000)
              + (*month *   100)
              +  *day;

       SPVIG2( d0arcd
             : d0spol
             : d0rama
             : d0arse
             : d0oper
             : peFvig
             : peFemi
             : peStat
             : peSspo
             : peSuop
             : *blanks );

       if peStat;
          peVige = 'S';
        else;
          peVige = 'N';
       endif;

       SPVIG2( d0arcd
             : d0spol
             : d0rama
             : d0arse
             : d0oper
             : peFvig
             : peFemi
             : peStat
             : peSspo
             : peSuop
             : 'FIN'   );

       SPCOBFIN( d0empr
               : d0sucu
               : d0arcd
               : d0spol
               : peFvig
               : 'P'
               : peCobf
               : *blanks );

       if peCobf;
          peCfin = 'S';
        else;
          peCfin = 'N';
       endif;

       SPCOBFIN( d0empr
               : d0sucu
               : d0arcd
               : d0spol
               : peFvig
               : 'P'
               : peCobf
               : 'FIN'   );

       return;

      /end-free

