     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * wslvhc  : Tareas generales.                                  *
      *           WebService - Retorna las claúsulas  de un Vehiculo *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *22-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 28/04/2015 - Agrego validacion de parametro base         *
      * SGF 11/05/2015 - Tomar todo desde archivos de GAUS.          *
      * CSz 22/05/2015 - Tomar todo desde GAUS (completar).          *
      *                                                              *
      * ************************************************************ *
     Fset001    if   e           k disk
     Fpahed004  if   e           k disk
     Fpahet995  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLVHC          pr                  ExtPgm('WSLVHC')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCveh                            likeds(pahautc_t) dim(30)
     D   peCvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLVHC          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCveh                            likeds(pahautc_t) dim(30)
     D   peCvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SP0068D         pr                  extpgm('SP0068D')
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0
     D   peSpol                       9  0
     D   peSspo                       3  0
     D   peRama                       2  0
     D   peArse                       2  0
     D   peOper                       7  0
     D   peSuop                       3  0
     D   pePoco                       4  0
     D   peClau                       3a   dim(30)
     D   peClan                       9a   dim(30) options(*nopass:*omit)

     D k1hed0          ds                  likerec(p1hed004 : *key)
     D k1het9          ds                  likerec(p1het9   : *key)

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D peClau          s              3a   dim(30)
     D peClan          s              9a   dim(30)
     D @@Poco          s              6  0
     D d               s             10i 0
     D x               s             10i 0

       *inLr = *On;

       peCvehC = *Zeros;
       peErro  = *Zeros;

       clear peCveh;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       chain peRama set001;
       if not %found (set001);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %editw(peRama:'0 ')
                       : %len(%editw(peRama:'0 ')) );
          peErro = -1;
          return;
       endif;

      if t@rame <> 4;
         @@Repl = %editw( peRama : '0 ' ) + %editw(pePoli : '0      '  );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       chain %kds(k1hed0:4) pahed004;
       if not %found;
          @@Repl = %editw( peRama : '0 ' ) + %editw(pePoli : '0      ' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : @@Repl
                       : %len(%trimr(@@Repl)) );
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
          @@Poco = pePoco;
          @@Repl = %editw( @@Poco : '    0 ' )
                 + %editw( peRama : '0 ' )
                 + %editw(pePoli : '     0 ' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0001'
                       : peMsgs
                       : @@Repl
                       : %len(%trimr(@@Repl)) );
          peErro = -1;
          return;
       endif;

       SP0068D( peBase.peEmpr
              : peBase.peSucu
              : t9arcd
              : t9spol
              : t9sspo
              : t9rama
              : t9arse
              : t9oper
              : t9sspo
              : t9poco
              : peClau
              : peClan );

       for x = 1 to 30;
           if peClau(x) <> *blanks;
              peCvehC += 1;
              peCveh(peCvehC).auclau = peClau(x);
              peCveh(peCvehC).auclan = peClan(x);
           endif;
       endfor;

       return;

