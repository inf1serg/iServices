     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLRCA  : Tareas generales.                                  *
      *           WebService - Retorna riesgos/cobertura seg.vida.   *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *27-Abr-2015  *
      * JORGE GRONDA                                   *29-May-2015  *
      * ------------------------------------------------------------ *
      * ************************************************************ *
     Fpahev095  if   e           k disk
     Fpahev102  if   e           k disk
     Fset001    if   e           k disk
     Fset104    if   e           k disk
     Fset107    if   e           k disk
     Fpahev2    if   e           k disk
     Fpahed004  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLRCA          pr                  ExtPgm('WSLRCA')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peLryc                            likeds(pahvid1_t) dim(30)
     D   peLrycC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLRCA          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peLryc                            likeds(pahvid1_t) dim(30)
     D   peLrycC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSXNEX          pr                  ExtPgm('WSXNEX')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peSpol                        9  0 const
     D  peNomi                        7  0

     D k1hev0          ds                  likerec( p1hev0   : *key )
     D k1hed0          ds                  likerec( p1hed004 : *key )
     D k1hev1          ds                  likerec( p1hev102 : *key )
     D k1hev2          ds                  likerec( p1hev2   : *key )
     D k1t104          ds                  likerec( s1t104   : *key )
     D k1t107          ds                  likerec( s1t107   : *key )

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D longm           s             10i 0

     D peNomi          s              7  0

       *inLr = *On;

       peLrycC = *Zeros;
       peErro  = *Zeros;
       peNomi  = *Zeros;

       clear peLryc;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       WSXNEX( peBase.peEmpr
             : peBase.peSucu
             : peRama
             : pePoli
             : peSpol
             : peNomi         );

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0Poli = pePoli;
       setll %kds ( k1hed0 : 4 ) pahed004;
       if not %equal( pahed004);
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePoli));
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
         peErro = -1;
         return;
       endif;

       k1hev0.v0empr = peBase.peEmpr;
       k1hev0.v0sucu = peBase.peSucu;
       k1hev0.v0rama = peRama;
       k1hev0.v0Poli = pePoli;
       k1hev0.v0Spol = peSpol;
       if peNomi = 0;
          k1hev0.v0Poco = 1;
          k1hev0.v0Paco = 1;
        else;
          k1hev0.v0Poco = pePoco;
          k1hev0.v0Paco = pePaco;
       endif;
       chain %kds ( k1hev0 : 7 ) pahev095;
       if not %found( pahev095);
          %subst(@@repl:1:6) = %trim(%char(pePoco));
          %subst(@@repl:7:6) = %trim(%char(pePaco));
          %subst(@@repl:13:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0010'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
         peErro = -1;
         return;
       endif;

       chain (peRama) set001;
       if (t@rame <> 18 and t@rame <> 21);
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0003'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
          peErro = -1;
          return;
       endif;


       k1hev1.v1empr = peBase.peEmpr;
       k1hev1.v1sucu = peBase.peSucu;
       K1hev1.v1arcd = v0arcd;
       k1hev1.v1spol = v0spol;
       k1hev1.v1rama = v0rama;
       k1hev1.v1arse = v0arse;
       k1hev1.v1oper = v0oper;
       if peNomi = 0;
          k1hev1.v1Poco = 1;
          k1hev1.v1Paco = 1;
        else;
          k1hev1.v1Poco = v0poco;
          k1hev1.v1Paco = v0paco;
       endif;
       setll %kds ( k1hev1 : 9 ) pahev102;
       reade %kds ( k1hev1 : 9 ) pahev102;
       if not %eof;
          k1hev2.v2empr = peBase.peEmpr;
          k1hev2.v2sucu = peBase.peSucu;
          K1hev2.V2arcd = v1arcd;
          k1hev2.v2spol = v1spol;
          k1hev2.v2sspo = v1sspo;
          k1hev2.v2rama = v1rama;
          k1hev2.v2arse = v1arse;
          k1hev2.v2oper = v1oper;
          if peNomi = 0;
             k1hev2.v2poco = 1;
             k1hev2.v2paco = 1;
           else;
             k1hev2.v2poco = v0poco;
             k1hev2.v2paco = v0paco;
          endif;
          k1hev2.v2suop = v1suop;
          setll %kds ( k1hev2 : 11 ) pahev2;
          reade %kds ( k1hev2 : 11 ) pahev2;
          dow not %eof and peLrycC < 30;

              peLrycC += 1;

              k1t104.t@rama = v2rama;
              k1t104.t@riec = v2riec;
              chain %kds(k1t104:2) set104;
              if %found;
                 pelryc(peLrycC).vdried  = t@ried;
               else;
                 pelryc(peLrycC).vdried  = *all'*';
              endif;

              k1t107.t@rama = v2rama;
              k1t107.t@cobc = v2xcob;
              chain %kds(k1t107:2) set107;
              if %found;
                 pelryc(peLrycC).vdcobd  = t@cobd;
               else;
                 pelryc(peLrycC).vdcobd  = *all'*';
              endif;
              pelryc(peLrycC).vdriec  = v2riec;
              pelryc(PeLrycC).vdxcob  = v2xcob;
              pelryc(PeLrycC).vdSaco  = v2Saco;

           reade %kds ( k1hev2 : 11 ) pahev2;
          enddo;
       endif;

       return;

