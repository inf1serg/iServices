     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLUBR  : Tareas generales.                                  *
      *           WebService - Retorna coberturas para Intermediario *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Gronda                                   *24-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * INF1NORBER 27/05/2015 - Se modifica archivos y parms.        *
      * ************************************************************ *
     Fpaher2    if   e           k disk
     Fpahed004  if   e           k disk
     Fpaher995  if   e           k disk
     Fset001    if   e           k disk
     Fset104    if   e           k disk
     Fset107    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLUBR          pr                  ExtPgm('WSLUBR')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peLryc                            likeds(pahrsvs1_t) dim(99)
     D   peLrycC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUBR          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peLryc                            likeds(pahrsvs1_t) dim(99)
     D   peLrycC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D kher995         ds                  likerec(p1her9:*key)

     D kher2           ds                  likerec(p1her2:*key)

     D khed004         ds                  likerec(p1hed004:*key)

     D kset104         ds                  likerec(s1t104:*key)

     D kset107         ds                  likerec(s1t107:*key)

     D coberturas      ds                  likerec(p1her2)
     D @@repl          s          65535a
     D @@leng          s             10i 0

       *inLr = *On;

       peErro  = *Zeros;
       pelrycC = *Zeros;

       clear pelryc;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = peRama;
       khed004.d0poli = pePoli;

       setll %kds ( khed004 : 4 ) pahed004;

       if not %equal ( pahed004 );
         @@Repl =   %editw ( peRama  : '0 ' )
                +   %editw ( pePoli  : '0      ' );

         @@Leng = %len ( %trimr ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

       kher995.r9empr = peBase.peEmpr;
       kher995.r9sucu = peBase.peSucu;
       kher995.r9rama = peRama;
       kher995.r9poli = pePoli;
       kher995.r9spol = peSpol;
       kher995.r9poco = pePoco;

       chain %kds ( kher995 : 6 ) paher995;

       if not %found ( paher995 );
         @@Repl =   %editw ( pePoco  : '0   ' )
                +   %editw ( peRama  : '0 ' )
                +   %editw ( pePoli  : '0      ' );

         @@Leng = %len ( %trimr ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'BIE0001' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

       chain peRama set001;
      if t@rame = 4 or t@rame = 18 or t@rame = 21;
         @@Repl =   %editw( peRama : '0 ' )
                +   %editw( pePoli : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

       kher2.r2Empr = peBase.peEmpr;
       kher2.r2Sucu = peBase.peSucu;
       kher2.r2Arcd = r9arcd;
       kher2.r2Spol = peSpol;
       kher2.r2Sspo = r9sspo;
       kher2.r2Rama = peRama;
       kher2.r2Arse = r9arse;
       kher2.r2Oper = r9oper;
       kher2.r2Poco = pePoco;
       kher2.r2Suop = r9sspo;

       setll %kds ( kher2 : 10 ) paher2;

       reade %kds ( kher2 : 10 ) paher2 coberturas;

       dow ( not %eof ( paher2 ) ) and ( pelrycC < 99 );

         pelrycC += 1;

         peLryc(peLrycC).rsriec = coberturas.r2riec;
         peLryc(peLrycC).rsxcob = coberturas.r2xcob;
         peLryc(peLrycC).rsptco = coberturas.r2ptco;
         peLryc(peLrycC).rsxpri = coberturas.r2xpri;
         peLryc(peLrycC).rsprsa = coberturas.r2prsa;

         clear t@ried;
         kset104.t@rama = peRama;
         kset104.t@riec = coberturas.r2riec;
         chain %kds (kset104:2) set104;
         peLryc(peLrycC).rsried = t@ried;

         peLryc(peLrycC).rssaco = coberturas.r2saco;


         clear t@cobd;
         clear t@cobl;
         kset107.t@rama = peRama;
         kset107.t@cobc = coberturas.r2xcob;
         chain %kds (kset107:2) set107;
         peLryc(peLrycC).rscobd = t@cobd;
         peLryc(peLrycC).rscobl = t@cobl;

         reade %kds ( kher2 : 10 ) paher2 coberturas;

       enddo;

       return;
