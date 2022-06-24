     H option(*nodebugio:*srcstmt: *noshowcpy)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLLIN  : Tareas generales.                                  *
      *           WebService - Retorna los Intermediarios de una Cuit*
      *                                                              *
      * ------------------------------------------------------------ *
      * JSN                                            *05-May-2017  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahusu2   if   e           k disk
     Fsehnid    if   e           k disk
     Fsehni201  if   e           k disk
     Fsehni202  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/ifsio_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'

     D WSLLIN          pr                  ExtPgm('WSLLIN')
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCuit                      11a   const
     D   peNrag                       5  0 const
     D   peUsri                       1a   const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keylin_t) const
     D   pePreg                            likeds(keylin_t)
     D   peUreg                            likeds(keylin_t)
     D   peLsu2                            likeds(pahusu2_t) dim(99)
     D   peLsu2C                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLLIN          pi
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCuit                      11a   const
     D   peNrag                       5  0 const
     D   peUsri                       1a   const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keylin_t) const
     D   pePreg                            likeds(keylin_t)
     D   peUreg                            likeds(keylin_t)
     D   peLsu2                            likeds(pahusu2_t) dim(99)
     D   peLsu2C                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D finArc          pr              n

     D k1husu2         ds                  likerec( d1husu2  : *key )
     D k1hnid          ds                  likerec(  d1hnid  : *key )
     D k1hni201        ds                  likerec( s1hni201 : *key )
     D k1hni202        ds                  likerec( s1hni202 : *key )

     D respue          s          65536
     D longm           s             10i 0

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D @@cant          s             10i 0
     D @@more          s               n

       *inLr = *On;

       peErro  = *Zeros;
       peLsu2C = *Zeros;
       peMore  = *Off;

       clear peLsu2;
       clear peMsgs;
       clear pePreg;
       clear peUreg;

       @@more  = *On;

      *- Valida Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valida Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( @@Cant <= *Zeros ) or ( @@Cant > 99 ) );
         @@cant = 99;
       endif;

      *- Valida Orden
       if not SVPWS_chkOrde( 'WSLLIN' : peOrde : peMsgs );
          peErro = -1;
          return;
       endif;

       select;
         when peOrde = 'INTXNOMBRE' and peUsri = 'S';
           exsr RetDatIntNomb;
         when peOrde = 'INTXCODNIV' and peUsri = 'N';
           exsr RetDatIntCuNiCo;
         when peOrde = 'INTXCODNIV' and peUsri = 'S';
           exsr RetDatIntNivCod;
         when peOrde = 'INTXCUIT';
           select;
             when ( peUsri  = 'S' );
               exsr retTodo;
             when ( peNrag <> *Zeros );
               exsr retAgen;
             other;
               exsr retCuit;
           endsl;
       endsl;

       return;

       // -------------------------------------------------

       begsr retTodo;

         k1husu2.u2Cuit = pePosi.u2Cuit;
         k1husu2.u2Nivt = pePosi.u2Nivt;
         k1husu2.u2Nivc = pePosi.u2Nivc;

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

         dow ( not %eof ( pahusu2  ) ) and ( peLsu2C  < @@cant );

           exsr retInt;

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

         k1hnid.idEmpr = peEmpr;
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

         k1husu2.u2Cuit = peCuit;
         k1husu2.u2Nivt = idNivt;
         k1husu2.u2Nivc = idNivc;

         chain %kds ( k1husu2  : 3 ) pahusu2;

         if %found ( pahusu2 );
           exsr retInt;
         endif;

       endsr;

       // -------------------------------------------------

       begsr retCuit;

         k1husu2.u2Cuit = peCuit;
         k1husu2.u2Nivt = pePosi.u2Nivt;
         k1husu2.u2Nivc = pePosi.u2Nivc;

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

         dow ( not %eof ( pahusu2  ) ) and ( peLsu2C <  @@cant );

           exsr retInt;

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

         if u2Mp02 <> 'B';

           peLsu2C += 1;

           peLsu2(peLsu2C).u2Cuit = u2Cuit;
           peLsu2(peLsu2C).u2Nivt = u2Nivt;
           peLsu2(peLsu2C).u2Nivc = u2Nivc;

           k1hni201.n2Empr = peEmpr;
           k1hni201.n2Sucu = peSucu;
           k1hni201.n2Nivt = u2Nivt;
           k1hni201.n2Nivc = u2Nivc;
           chain %kds(k1hni201:4) sehni201;

           if %found ( sehni201 );
             peLsu2(peLsu2C).u2Nomb = dfNomb;
             peLsu2(peLsu2C).u2Coma = n2Coma;
             peLsu2(peLsu2C).u2Nrma = n2Nrma;
           else;
             peLsu2(peLsu2C).u2Nomb = *all'?';
             peLsu2(peLsu2C).u2Coma = *blanks;
             peLsu2(peLsu2C).u2Nrma = *zeros;
           endif;

           if peLsu2C = 1;
             exsr priReg;
           endif;

           exsr ultReg;

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

         pePreg.u2Cuit = u2Cuit;
         pePreg.u2Nivt = u2Nivt;
         pePreg.u2Nivc = u2Nivc;
         pePreg.u2Nomb = dfNomb;
         pePreg.u2Nrdf = dfNrdf;

       endsr;

       // -------------------------------------------------

       begsr ultReg;

         peUreg.u2Cuit = u2Cuit;
         peUreg.u2Nivt = u2Nivt;
         peUreg.u2Nivc = u2Nivc;
         peUreg.u2Nomb = dfNomb;
         peUreg.u2Nrdf = dfNrdf;

       endsr;

       // -------------------------------------------------

       begsr RetDatIntNomb;

         k1hni202.dfNomb = pePosi.u2Nomb;
         k1hni202.dfNrdf = pePosi.u2Nrdf;

           if ( peRoll = 'F' );
             setgt %kds ( k1hni202 : 2 ) sehni202;
           else;
             setll %kds ( k1hni202 : 2 ) sehni202;
           endif;

           exsr RetPag202;
           exsr leeArc202;

           dow ( ( not finArc ) and ( peLsu2C < @@cant ) );

             k1husu2.u2Cuit = dfCuit;
             k1husu2.u2Nivt = n2Nivt;
             k1husu2.u2Nivc = n2Nivc;
             chain %kds( k1husu2 ) pahusu2;
             if %found( pahusu2 );

               if u2Mp02 <> 'B';

                 peLsu2C += 1;

                 if peLsu2C = 1;
                   pePreg.u2Cuit = u2Cuit;
                   pePreg.u2Nivt = u2Nivt;
                   pePreg.u2Nivc = u2Nivc;
                   pePreg.u2Nomb = dfNomb;
                   pePreg.u2Nrdf = dfNrdf;
                 endif;

                 peLsu2( peLsu2C ).u2Cuit = dfCuit;
                 peLsu2( peLsu2C ).u2Nivt = n2Nivt;
                 peLsu2( peLsu2C ).u2Nivc = n2Nivc;
                 peLsu2( peLsu2C ).u2Nomb = dfNomb;
                 peLsu2( peLsu2C ).u2Coma = n2Coma;
                 peLsu2( peLsu2C ).u2Nrma = n2Nrma;

                 peUreg.u2Cuit = u2Cuit;
                 peUreg.u2Nivt = u2Nivt;
                 peUreg.u2Nivc = u2Nivc;
                 peUreg.u2Nomb = dfNomb;
                 peUreg.u2Nrdf = dfNrdf;

               endif;

             endif;

             exsr leeArc202;

           enddo;

           select;
             when peRoll = 'R';
              peMore = @@more;
            when %eof(sehni202);
              peMore = *Off;
            other;
              peMore = *On;
           endsl;

       endsr;

       // -------------------------------------------------

       begsr RetDatIntCuNiCo;

         k1husu2.u2Cuit = peCuit;
         k1husu2.u2Nivt = pePosi.u2Nivt;
         k1husu2.u2Nivc = pePosi.u2Nivc;
         chain %kds( k1husu2:3 ) pahusu2;
         if %found ( pahusu2 );

           if u2Mp02 <> 'B';

             k1hni201.n2Empr = peEmpr;
             k1hni201.n2Sucu = peSucu;
             k1hni201.n2Nivt = u2Nivt;
             k1hni201.n2Nivc = u2Nivc;
             chain %kds ( k1hni201 ) sehni201;
             if %found ( sehni201 );

               peLsu2C = 1;
               peLsu2( peLsu2C ).u2Cuit = dfCuit;
               peLsu2( peLsu2C ).u2Nivt = n2Nivt;
               peLsu2( peLsu2C ).u2Nivc = n2Nivc;
               peLsu2( peLsu2C ).u2Nomb = dfNomb;
               peLsu2( peLsu2C ).u2Coma = n2Coma;
               peLsu2( peLsu2C ).u2Nrma = n2Nrma;

             endif;

           endif;

           return;

         else;

           respue =  %editC(pePosi.u2Nivt:'4':*ASTFILL) +
                     %editC(pePosi.u2Nivc:'4':*ASTFILL) +
                     %trim(peCuit);
           longm  = 17;
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PRD0005' :
                           peMsgs : respue  : longm );
           peErro = -1;
           return;

         endif;

       endsr;

       // -------------------------------------------------

       begsr RetDatIntNivCod;

         k1hni201.n2Empr = peEmpr;
         k1hni201.n2Sucu = peSucu;
         k1hni201.n2Nivt = pePosi.u2Nivt;
         k1hni201.n2Nivc = pePosi.u2Nivc;
         chain %kds ( k1hni201 ) sehni201;
         if %found ( sehni201 );

           k1husu2.u2Cuit = dfCuit;
           k1husu2.u2Nivt = n2Nivt;
           k1husu2.u2Nivc = n2Nivc;
           chain %kds( k1husu2:3 ) pahusu2;
           if %found ( pahusu2 );

             if u2Mp02 <> 'B';

               peLsu2C = 1;
               peLsu2( peLsu2C ).u2Cuit = dfCuit;
               peLsu2( peLsu2C ).u2Nivt = n2Nivt;
               peLsu2( peLsu2C ).u2Nivc = n2Nivc;
               peLsu2( peLsu2C ).u2Nomb = dfNomb;
               peLsu2( peLsu2C ).u2Coma = n2Coma;
               peLsu2( peLsu2C ).u2Nrma = n2Nrma;

             endif;

           endif;

           return;

         else;

           respue =  %editC(pePosi.u2Nivt:'4':*ASTFILL) +
                     %editC(pePosi.u2Nivc:'4':*ASTFILL);

           longm  = 17;
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PRD0005' :
                           peMsgs : respue  : longm );
           peErro = -1;
           return;

         endif;

       endsr;

       // -------------------------------------------------

       begsr RetPag202;

         if ( peRoll = 'R' );
           exsr retArc202;
           dow ( ( not %eof(sehni202) ) and ( @@cant > 0 ) );
             @@cant -= 1;
             exsr retArc202;
           enddo;
           if %eof(sehni202);
             @@more = *off;
             setll %kds( k1hni202 : 2 ) sehni202;
           endif;
           @@cant = peCant;
           if (@@cant <= 0 or @@cant > 99);
             @@cant = 99;
           endif;
         endif;

       endsr;

       // -------------------------------------------------

       begsr leeArc202;

         read  sehni202;

         dow n2Empr= ' ' and n2Sucu= ' ' and n2Nivt = 0 and
           n2Nivc= 0 and not %eof(sehni202);
           read sehni202;
         enddo;

       endsr;

       // -------------------------------------------------

       begsr retArc202;

         readp  sehni202;

         dow n2Empr= ' ' and n2Sucu= ' ' and n2Nivt= 0 and
           n2Nivc= 0 and not %eof(sehni202);
           readp sehni202;
         enddo;

         k1hni202.dfNomb = dfNomb;
         k1hni202.dfNrdf = dfNrdf;

       endsr;

     **- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

             return %eof ( sehni202 );

     P finArc          E

