     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************  *
      * WSLVHR  : Tareas generales.                                   *
      *           WebService - Retorna Nómina Conductores/Seg.Registro*
      *                                                               *
      * ------------------------------------------------------------  *
      * Jorge Gronda                                   *27-Abr-2015   *
      * ------------------------------------------------------------  *
      * SGF 16/05/2015: Tomar todo desde GAUS.                        *
      *                                                               *
      * ************************************************************  *
     Fset001    if   e           k disk
     Fpahet995  if   e           k disk
     Fpahed004  if   e           k disk
     Fpahet6    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLVHR          pr                  ExtPgm('WSLVHR')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCveh                            likeds(pahaut6_t) dim(100)
     D   peCvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLVHR          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCveh                            likeds(pahaut6_t) dim(100)
     D   peCvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1het9          ds                  likerec(p1het9   : *key)
     D k1het6          ds                  likerec(p1het6   : *key)
     D k1hed0          ds                  likerec(p1hed004 : *key)

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D poco6           s              6  0

      /free

       *inLr = *On;

       peErro  = *Zeros;
       peCvehC = *Zeros;

       clear peCveh;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       chain peRama set001;
      if %found and t@rame <> 4;
          @@Repl =   %editc( peRama : '4' : *astfill )
                 +   %editc( pePoli : '4' : *astfill );
          @@Leng = %len ( %trim ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;
       endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       setll %kds(k1hed0:4) pahed004;
       if not %equal;
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : @@repl
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       k1het9.t9empr = peBase.peEmpr;
       k1het9.t9sucu = peBase.peSucu;
       k1het9.t9rama = peRama;
       k1het9.t9poli = pePoli;
       k1het9.t9spol = peSpol;
       k1het9.t9poco = pePoco;
       chain %kds(k1het9:6) pahet995;
       if not %found;
          poco6  = pePoco;
          %subst(@@repl:1:6) = %trim(%char(poco6));
          %subst(@@repl:7:2) = %editc(peRama:'X');
          %subst(@@repl:9:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0001'
                       : peMsgs
                       : @@repl
                       : %len(%trim(@@repl)) );
         peErro = -1;
         return;
       endif;

       if t9vhca <> 33;
          %subst(@@repl:1:4) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0002'
                       : peMsgs
                       : @@repl
                       : %len(%trim(@@repl)) );
         peErro = -1;
         return;
       endif;

       k1het6.t6empr = t9empr;
       k1het6.t6sucu = t9sucu;
       k1het6.t6arcd = t9arcd;
       k1het6.t6spol = t9spol;
       k1het6.t6sspo = t9sspo;
       k1het6.t6rama = t9rama;
       k1het6.t6arse = t9arse;
       k1het6.t6oper = t9oper;
       k1het6.t6poco = t9poco;
       k1het6.t6suop = t9sspo;
       setll %kds(k1het6:10) pahet6;
       reade %kds(k1het6:10) pahet6;
       dow not %eof;

           peCvehC += 1;
           peCveh(peCvehC).auncon = t6ncon;
           peCveh(peCvehC).aunomb = t6nomb;
           peCveh(peCvehC).auapel = t6apel;
           peCveh(peCvehC).aunreg = t6nreg;
           peCveh(peCvehC).auexpp = t6expp;
           test(de) *iso t6fvto;
           if %error;
              peCveh(peCvehC).aufvto = d'0001-01-01';
            else;
              peCveh(peCvehC).aufvto = %date(t6fvto:*iso);
           endif;
           if (t6stat = 'B');
              peCveh(peCvehC).austat = 'BAJA';
            else;
              peCveh(peCvehC).austat = 'ACTIVO';
           endif;

        reade %kds(k1het6:10) pahet6;
       enddo;

        return;

      /end-free
