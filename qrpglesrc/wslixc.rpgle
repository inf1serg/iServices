     H option(*nodebugio:*srcstmt: *noshowcpy)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLIXC  : Tareas generales.                                  *
      *           WebService - Retorna los Intermediarios de una Cuit*
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *28-Abr-2015  *
      * ------------------------------------------------------------ *
      * SGF 21/05/2015: Agrego COMA/NRMA y Nombre de intermediario.  *
      *                 Uso likeds en lugar de likerec.              *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      *                                                              *
      * ************************************************************ *
     Fpahusu2   if   e           k disk
     Fsehnid    if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLIXC          pr                  ExtPgm('WSLIXC')
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCuit                      11a   const
     D   peNrag                       5  0 const
     D   peUsri                       1a   const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyixc_t) const
     D   pePreg                            likeds(keyixc_t)
     D   peUreg                            likeds(keyixc_t)
     D   peLint                            likeds(pahusu2_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIXC          pi
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCuit                      11a   const
     D   peNrag                       5  0 const
     D   peUsri                       1a   const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyixc_t) const
     D   pePreg                            likeds(keyixc_t)
     D   peUreg                            likeds(keyixc_t)
     D   peLint                            likeds(pahusu2_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1husu2         ds                  likerec(d1husu2:*key)

     D k1hnid          ds                  likerec(d1hnid:*key)
     D k1hni2          ds                  likerec(s1hni201 : *key)

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D @@cant          s             10i 0
     D @@more          s               n

       *inLr = *On;

       peErro  = *Zeros;
       peLintC = *Zeros;

       clear peLint;
       clear peMsgs;

       @@more  = *On;

       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

       @@cant = peCant;
       if ( ( @@Cant <= *Zeros ) or ( @@Cant > 99 ) );
         @@cant = 99;
       endif;

       select;
         when ( peUsri  = 'S' );
           exsr retTodo;
         when ( peNrag <> *Zeros );
           exsr retAgen;
         other;
           exsr retCuit;
       endsl;

       return;

       // -------------------------------------------------

       begsr retTodo;

         k1husu2.u2cuit = pePosi.u2cuit;
         k1husu2.u2nivt = pePosi.u2nivt;
         k1husu2.u2nivc = pePosi.u2nivc;

         exsr posArc;

         if ( peRoll = 'R' );
           readp pahusu2;
           dow ( not %eof ( pahusu2 ) ) and ( @@cant > 0 );
             @@cant -= 1;
             readp pahusu2;
           enddo;
           if %eof ( pahusu2 );
             @@more = *Off;
             setll *Start pahusu2;
           endif;
           @@cant = peCant;
         endif;

         read pahusu2;
         exsr priReg;

         dow ( not %eof ( pahusu2  ) ) and ( peLintC  < @@cant );

           exsr retInt;
           exsr ultReg;

           read pahusu2;

         enddo;

         select;
           when ( peRoll = 'R' );
             peMore = @@more;
           when %eof ( pahusu2 );
             peMore = *Off;
           other;
             peMore = *On;
         endsl;

       endsr;

       // -------------------------------------------------

       begsr retAgen;

         k1hnid.idempr = peEmpr;
         k1hnid.idSucu = peSucu;
         k1hnid.idNrag = peNrag;

         chain %kds ( k1hnid  : 3 ) sehnid;

         if not %found ( sehnid );
           @@Repl =   %editw ( peNrag  : '0    ' );
           @@Leng = %len ( %trimr ( @@repl ) );
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'AGE0001' :
                         peMsgs : @@Repl  : @@Leng );
           peErro = -1;
           return;
         endif;

         k1husu2.u2cuit = peCuit;
         k1husu2.u2nivt = idnivt;
         k1husu2.u2nivc = idnivc;

         chain %kds ( k1husu2  : 3 ) pahusu2;
         exsr priReg;

         if %found ( pahusu2 );
           exsr retInt;
         endif;

         exsr UltReg;

       endsr;

       // -------------------------------------------------

       begsr retCuit;

         k1husu2.u2cuit = peCuit;
         k1husu2.u2nivt = pePosi.u2nivt;
         k1husu2.u2nivc = pePosi.u2nivc;

         exsr posArc;

         if ( peRoll = 'R' );
           readpe %kds( k1husu2 : 1 ) pahusu2;
           dow ( not %eof ( pahusu2 ) ) and ( @@cant > 0 );
             @@cant -= 1;
             readpe %kds( k1husu2 : 1 ) pahusu2;
           enddo;
           if %eof ( pahusu2 );
             @@more = *Off;
             setll %kds ( k1husu2 : 1 ) pahusu2;
           endif;
           @@cant = peCant;
         endif;

         reade %kds ( k1husu2 : 1 ) pahusu2;
         exsr priReg;

         dow ( not %eof ( PAHUSU2  ) ) and ( peLintC <  @@cant );

           exsr retInt;
           exsr ultReg;

           reade %kds ( k1husu2 : 1 ) pahusu2;

         enddo;

         if ( peRoll = 'R' );
           peMore = @@more;
         else;
           peMore = not %eof ( pahusu2 );
         endif;

       endsr;

       // -------------------------------------------------

       begsr retInt;

         peLintC += 1;

         peLint(peLintC).u2cuit = u2cuit;
         peLint(peLintC).u2nivt = u2nivt;
         peLint(peLintC).u2nivc = u2nivc;

         k1hni2.n2empr = peEmpr;
         k1hni2.n2sucu = peSucu;
         k1hni2.n2nivt = u2nivt;
         k1hni2.n2nivc = u2nivc;
         chain %kds(k1hni2:4) sehni201;

         if %found ( sehni201 );
           peLint(peLintC).u2nomb = dfnomb;
           peLint(peLintC).u2coma = n2coma;
           peLint(peLintC).u2nrma = n2nrma;
         else;
           peLint(peLintC).u2nomb = *all'?';
           peLint(peLintC).u2coma = *blanks;
           peLint(peLintC).u2nrma = *zeros;
         endif;

       endsr;

       // -------------------------------------------------

       begsr posArc;

         if ( peRoll = 'F' );
           setgt %kds ( k1husu2 ) pahusu2;
         else;
           setll %kds ( k1husu2: 3 ) pahusu2;
         endif;

       endsr;

       // -------------------------------------------------

       begsr priReg;

         pePreg.u2cuit = u2cuit;
         pePreg.u2nivt = u2nivt;
         pePreg.u2nivc = u2nivc;

       endsr;

       // -------------------------------------------------

       begsr ultReg;

         peUreg.u2cuit = u2cuit;
         peUreg.u2nivt = u2nivt;
         peUreg.u2nivc = u2nivc;

       endsr;

