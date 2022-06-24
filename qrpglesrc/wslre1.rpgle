     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLRE1  : WebService - Retorna lista de AP                   *
      * ------------------------------------------------------------ *
      * JSN 06-Mar-2017                                              *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fset1023   if   e           k disk
     FgntRed    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLRE1          pr                  ExtPgm('WSLRE1')
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peEdad                            likeds(edades_t) dim(99)
     D   peEdadC                     10i 0

     D WSLRE1          pi
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peEdad                            likeds(edades_t) dim(99)
     D   peEdadC                     10i 0

     D @@Repl          s          65535a
     D @@Leng          s             10i 0

     D k1y1023         ds                  likerec( s1t1023 : *key )
     D k1yEdad         ds                  likerec( g1tred  : *key )

       *inLr   = *On;

       peEdadC = *Zeros;

       clear peEdad;

      * Datos de posicionamiento siempre desde pePosi
       k1y1023.t@Rama = peRama;
       k1y1023.t@Xpro = peXpro;

       setll %kds ( k1y1023 : 2 ) set1023;
       reade %kds ( k1y1023 : 2 ) set1023;

 b2    dow not %eof ( set1023 );

         k1yEdad.edCodi = t@Codi;
         chain %kds( k1yEdad ) gntRed;
         if %found ( gntRed ) and edMweb = '1';

           peEdadC += 1;

           peEdad(peEdadC).codi = edCodi;
           peEdad(peEdadC).mini = edMini;
           peEdad(peEdadC).maxi = edMaxi;
           peEdad(peEdadC).desc = edDesc;

         endif;

         reade %kds( k1y1023 : 2 ) set1023;

 e2    enddo;

       return;


