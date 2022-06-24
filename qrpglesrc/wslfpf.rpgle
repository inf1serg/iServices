     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLFPF : WebService: Retorna Forma de Pago por Fecha         *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                              *30/12/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * Para AP si la vigencia es menor a 90 días solo debe informar *
      * planes de pago en 1 cuota                                    *
      * ------------------------------------------------------------ *
      * SGF 15/12/2017: Cortar planes de pago de acuerdo a vigencia. *
      * NWN 16/10/2019: Para AP si es periodo menor a 6 Meses solo   *
      *                 debe aceptar Debito en Cuenta o Tarj.Crédito.*
      *                 Solo para Ramas de Vida.                     *
      *                                                              *
      * ************************************************************ *
     Fset60802  if   e           k disk
     Fset912    if   e           k disk
     Fset621    if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/wsltab_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'

     D WSLFPF          pr                  ExtPgm('WSLFPF')
     D   peArcd                       6  0 const
     D   peIvig                       8  0 const
     D   peFvig                       8  0 const
     D   peLfpg                            likeds(gntfpg_t) dim(999)
     D   peLfpgC                     10i 0

     D WSLFPF          pi
     D   peArcd                       6  0 const
     D   peIvig                       8  0 const
     D   peFvig                       8  0 const
     D   peLfpg                            likeds(gntfpg_t) dim(999)
     D   peLfpgC                     10i 0

     D k1y608          ds                  likeRec(s1t608:*Key)
     D k1y912          ds                  likeRec(s1t912:*Key)
     D k1y621          ds                  likeRec(s1t621:*Key)
     D k1y001          ds                  likeRec(s1t001:*Key)

     D @@1cuota        s               n
     D @@esvida        s               n
     D tope_cuotas     s              2  0

     D @@fvig          s              8  0
     D @@dias          s              5  0
     D x               s             10i 0

     D @@Lfpg          ds                  likeds(gntfpg_t) dim(999)
     D @@LfpgC         s             10i 0

       *inLr = *On;

       clear peLfpg;
       clear peLfpgC;

       clear @@Lfpg;
       clear @@LfpgC;

       WSLTAB_listaFormasDePagoWeb ( peArcd : @@Lfpg : @@LfpgC );

       @@fvig = peFvig;
       @@dias = SPVFEC_DiasEntreFecha8 ( peIvig : @@fvig );
       // ------------------------------------------
       // Si la diferencia es <= 0 fuerzo 365 días
       // ya que serán los artículos que no cargan
       // desde/hasta antes de cotizar
       // ------------------------------------------
       if @@dias <= 0;
          @@dias = 365;
       endif;

       // ------------------------------------------
       // De acuerdo a la diferencia de vigencia
       // establezco el tope de cuotas a dar
       // ------------------------------------------
       tope_cuotas = 12;
       select;
        when @@dias <= 90;
             tope_cuotas = 1;
        when @@dias <= 120;
             tope_cuotas = 4;
        when @@dias <= 150;
             tope_cuotas = 5;
        when @@dias <= 180;
             tope_cuotas = 6;
        when @@dias <= 210;
             tope_cuotas = 7;
        when @@dias <= 240;
             tope_cuotas = 8;
        when @@dias <= 270;
             tope_cuotas = 9;
        when @@dias <= 300;
             tope_cuotas = 10;
        when @@dias <= 330;
             tope_cuotas = 11;
       endsl;

         @@esvida = *off;
         k1y621.t@arcd = pearcd;
         chain %kds ( k1y621:1 ) set621;
         if %found(set621);
             k1y001.t@rama = t@rama;
             chain %kds ( k1y001 ) set001;
             if %found(set001);
               if t@rame = 18;
                @@esvida = *on;
               endif;
             endif;
         endif;

       k1y608.t@arcd = peArcd;

       for x = 1 to @@LfpgC;
         k1y608.t@nrpp = @@Lfpg( x ).cfpg;
         chain %kds ( k1y608 : 2 ) set60802;
         if %found( set60802 );
            chain @@Lfpg(x).cfpg set912;
            if not %found;
               t@ccuo = 99;
            endif;

          if @@esvida;
           if t@ccuo <= tope_cuotas and tope_cuotas <= 6 and t@cfpg <= 3 or
              t@ccuo <= tope_cuotas and tope_cuotas > 6;
               peLfpgC += 1;
               peLfpg ( peLfpgC ) = @@Lfpg ( x );
           endif;
             else;
           if t@ccuo <= tope_cuotas;
               peLfpgC += 1;
               peLfpg ( peLfpgC ) = @@Lfpg ( x );
           endif;
          endif;
         endif;

       endfor;

       return;
