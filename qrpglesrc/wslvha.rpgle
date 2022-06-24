     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * wslvha  : Tareas generales.                                  *
      *           WebService - Retorna los accesorios de un Vehiculo *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *21-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 29/04/2015 - Agrego validacion de parametro base         *
      * SGF 16/05/2015 - Todo desde GAUS.                            *
      *                                                              *
      * ************************************************************ *
     Fset001    if   e           k disk
     Fpahet995  if   e           k disk
     Fpahet1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLVHA          pr                  ExtPgm('WSLVHA')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peAveh                            likeds(pahaut4_t) dim(99)
     D   peAvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLVHA          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peAveh                            likeds(pahaut4_t) dim(99)
     D   peAvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1het9          ds                  likerec(p1het9 : *key)
     D k1het1          ds                  likerec(p1het1 : *key)

     D @@poco          s              6  0
     D @@repl          s          65535a
     D @@leng          s             10i 0

       *inLr = *On;

       peAvehC = *Zeros;
       peErro  = *Zeros;

       clear peAveh;
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

       k1het9.t9empr = peBase.peEmpr;
       k1het9.t9sucu = peBase.peSucu;
       k1het9.t9rama = peRama;
       k1het9.t9poli = pePoli;
       k1het9.t9spol = peSpol;
       k1het9.t9poco = pePoco;
       chain %kds(k1het9:6) pahet995;
       if not %found;
          @@poco = pePoco;
          %subst(@@Repl:1:6) = %char(@@poco);
          %subst(@@Repl:7:2) = %char(peRama);
          %subst(@@Repl:9:7) = %char(pePoli);
          @@Leng = %len( %trim ( @@repl ) );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0001'
                       : peMsgs
                       : @@Repl
                       : 15 );
          peErro = -1;
          return;
       endif;

       k1het1.t1empr = t9empr;
       k1het1.t1sucu = t9sucu;
       k1het1.t1arcd = t9arcd;
       k1het1.t1spol = t9spol;
       k1het1.t1sspo = t9sspo;
       k1het1.t1rama = t9rama;
       k1het1.t1arse = t9arse;
       k1het1.t1oper = t9oper;
       k1het1.t1poco = t9poco;
       k1het1.t1suop = t9sspo;
       setll %kds(k1het1:10) pahet1;
       reade %kds(k1het1:10) pahet1;
       dow not %eof;

           peAvehC += 1;

           peAveh(peAvehC).a4empr = t1empr;
           peAveh(peAvehC).a4sucu = t1sucu;
           peAveh(peAvehC).a4rama = t1rama;
           peAveh(peAvehC).a4poli = t1poli;
           peAveh(peAvehC).a4poco = t1poco;
           peAveh(peAvehC).a4cert = t1cert;
           peAveh(peAvehC).a4arcd = t1arcd;
           peAveh(peAvehC).a4spol = t1spol;
           peAveh(peAvehC).a4arse = t1arse;
           peAveh(peAvehC).a4oper = t1oper;
           peAveh(peAvehC).a4secu = t1secu;
           peAveh(peAvehC).a4accd = t1accd;
           peAveh(peAvehC).a4accv = t1accv;
           peAveh(peAvehC).a4mar1 = t1mar1;
           peAveh(peAvehC).a4mar2 = t1mar2;
           peAveh(peAvehC).a4mar3 = t1mar3;
           peAveh(peAvehC).a4mar4 = t1mar4;
           peAveh(peAvehC).a4mar5 = t1mar5;
           peAveh(peAvehC).a4ts20 = *zeros;
           select;
            when t1mar1 = '1';
                 peAveh(peAvehC).a4acct = 'TARIFABLE';
            when t1mar1 = '2';
                 peAveh(peAvehC).a4acct = 'NO TARIFABLE';
            other;
                 peAveh(peAvehC).a4acct = 'INDETERMINADO';
           endsl;

        reade %kds(k1het1:10) pahet1;
       enddo;

       return;

