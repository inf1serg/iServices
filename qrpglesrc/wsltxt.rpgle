     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLTXT  : Tareas generales.                                  *
      *           WebService - Retorna Número de Linea de Texto      *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Gronda                                   *07-May-2015  *
      * ------------------------------------------------------------ *
      * Modificado 26/05/2015 INF1NORBER cambian parametros salida.  *
      * ------------------------------------------------------------ *
      * ************************************************************ *
     Fpahed2    if   e           k disk
     Fpahec0    if   e           k disk
     Fpahec1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLTXT          pr                  ExtPgm('WSLTXT')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peLrtx                            likeds(pahed2_t) dim(800)
     D   peLrtxC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLTXT          pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peLrtx                            likeds(pahed2_t) dim(800)
     D   peLrtxC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hed2          ds                  likerec(P1HED2:*key)
     D k1hec0          ds                  likerec(P1HEC0:*key)
     D k1hec1          ds                  likerec(P1HEC1:*key)

     D textos          ds                  likerec(P1HED2)
     D @@repl          s          65535a
     D @@leng          s             10i 0

       *inLr = *On;

       peErro  = *Zeros;
       peLrtxC = *Zeros;

       clear peLrtx;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1hec0.c0Empr  = peBase.peEmpr;
       k1hec0.c0Sucu  = peBase.peSucu;
       k1hec0.c0Arcd  = peArcd;
       k1hec0.c0Spol  = peSpol;
       chain %kds ( k1hec0 : 4 ) PAHEC0;
       if   not  %found;
            %subst(@@repl:1:6) = %trim(%char(peArcd));
            %subst(@@repl:7:9) = %trim(%char(peSpol));
            @@Leng = %len ( %trimr ( @@repl ) );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SPO0001'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            peErro = -1;
            return;
       endif;

       K1HEC1.c1Empr  = peBase.peEmpr;
       K1HEC1.c1Sucu  = peBase.peSucu;
       K1HEC1.c1Arcd  = peArcd;
       K1HEC1.c1Spol  = peSpol;
       K1HEC1.c1Sspo  = peSspo;

       chain %kds ( K1HEC1 : 5 ) PAHEC1;

       if   not  %found;
            @@Repl =   %editw ( peSspo  : '0  ' )
                   +   %editw ( peArcd  : '0     ' )
                   +   %editw ( peSpol  : '0        ' );

            @@Leng = %len ( %trimr ( @@repl ) );

            SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'SPO0002' :
                             peMsgs : @@Repl  : @@Leng );
            peErro = -1;
            return;
       endif;

       K1HED2.d2Empr  = peBase.peEmpr;
       K1HED2.d2Sucu  = peBase.peSucu;
       K1HED2.d2Arcd  = peArcd;
       K1HED2.d2Spol  = peSpol;
       K1HED2.d2Sspo  = peSspo;
       K1HED2.d2Rama  = peRama;
       K1HED2.d2Arse  = peArse;
       K1HED2.d2Oper  = peOper;
       K1HED2.d2Suop  = peSuop;

       setll %kds ( k1HED2  : 9 ) PAHED2;

       reade %kds ( K1HED2   :  9 ) PAHED2;

              dow ( not %eof ( PAHED2 ) ) and ( peLrtxc <  800 );

                 if  %subst(d2retx:1:1) <> '&'
                 and %subst(d2retx:1:1) <> '#';

                     peLrtxc += 1;
                     peLrtx(peLrtxc).retx  = d2retx ;

                 endif;

                 reade %kds(K1HED2  : 9) PAHED2;
              enddo;

       return;
