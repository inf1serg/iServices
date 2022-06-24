     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
      * ************************************************************ *
      * WSLTDP : WebService                                          *
      *          Retorna Tipo de Plan (Abierto/Cerrado)              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *16-May-2016        *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fset100    if   e           k disk

      /copy './qcpybooks/wsstruc_h.rpgle'

     D WSLTDP          pr                  ExtPgm('WSLTDP')
     D   peRama                       2  0 const
     D   pePrds                            likeds(Planes_t) dim(999)
     D   pePrdsC                     10i 0 const

     D WSLTDP          pi
     D   peRama                       2  0 const
     D   pePrds                            likeds(Planes_t) dim(999)
     D   pePrdsC                     10i 0 const

     D x               s             10i 0

     D k1y100          ds                  likerec(s1t100:*key)

      /free

       *inlr = *On;

       for x = 1 to pePrdsC;

         k1y100.t@rama = peRama;
         k1y100.t@xpro = pePrds(x).xpro;
         k1y100.t@mone = pePrds(x).mone;

         chain %kds ( k1y100 ) set100;

         select;

           when not %found ( set100 );
              pePrds(x).tidp = 'E';
           when t@prem = *Zeros;
              pePrds(x).tidp = 'A';
           other;
              pePrds(x).tidp = 'C';

         endsl;

       endfor;

       return;

      /end-free
