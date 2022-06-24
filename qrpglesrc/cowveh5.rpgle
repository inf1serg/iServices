     H dftactgrp(*no) actgrp(*caller)
     H indent('|') option(*nodebugio:*noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COWVEH5: WebService                                          *
      *          Cotización Autos - Código de Buen resultado         *
      *                                                              *
      *          peBase (input)  Parámetros Base                     *
      *          peNctw (input)  Número de Cotizacion                *
      *          pePoco (input)  Número de Componente                *
      *          peCobe (output) Códigos de Buen resultado           *
      *                                                              *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto          * 28-Oct-2015                    *
      * ************************************************************ *
     Fctw000    if   e           k disk
     Fpahet911  if   e           k disk

     D COWVEH5         pr                  ExtPgm('COWVEH5')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   pePoco                       4  0 const
     D   peCobe                       1  0 dim(10)

     D COWVEH5         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   pePoco                       4  0 const
     D   peCobe                       1  0 dim(10)

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'

     D  k1y000         ds                  likerec( c1w000 : *key )
     D  k1y911         ds                  likerec( p1het9 : *key )

     D SPREBRV2        pr                  extpgm('SPREBRV2')
     D    asen                        7  0 const
     D    nmat                       25    const
     D    rebr                        1  0

     D @@rebr          s              1  0 inz

      /free

       *inlr = *on;

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain %kds( k1y000 ) ctw000;
       if %found( ctw000 );
        k1y911.t9empr = w0empr;
        k1y911.t9sucu = w0sucu;
        k1y911.t9arcd = w0arcd;
        k1y911.t9spol = w0spo1;
        k1y911.t9poco = pePoco;
        chain %kds( k1y911 ) pahet911;
        if %found( pahet911 );
         SPREBRV2 ( SPVSPO_getAsen ( t9Empr
                                   : t9Sucu
                                   : t9Arcd
                                   : t9Spol
                                   : t9Sspo )
                  : t9Nmat
                  : @@rebr );
         select;
          when @@rebr = 5;
               pecobe(1) = 0;
               pecobe(2) = 1;
               pecobe(3) = 2;
               pecobe(4) = 3;
          when @@rebr = 4;
               pecobe(1) = 0;
               pecobe(2) = 1;
               pecobe(3) = 2;
               pecobe(4) = 3;
          when @@rebr = 3;
               pecobe(1) = 0;
               pecobe(2) = 1;
               pecobe(3) = 2;
               pecobe(4) = 3;
          when @@rebr = 2;
               pecobe(1) = 0;
               pecobe(2) = 1;
               pecobe(3) = 2;
          when @@rebr = 1;
               pecobe(1) = 0;
               pecobe(2) = 1;
          when @@rebr = 0;
               pecobe(1) = 0;

          other;
           clear pecobe;

         endsl;
        endif;
       endif;

       return;

      /end-free
