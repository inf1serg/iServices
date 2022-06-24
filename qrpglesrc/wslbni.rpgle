     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLBNI  : Tareas generales.                                  *
      *           WebService - Retorna Datos de intermediario por  - *
      *           Nombre.                                            *
      *                                                              *
      * ------------------------------------------------------------ *
      * Ruben Dario Vinent                             *07-jul-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SGF 17/07/2015 - No va parámetro Base. Mal definido por HDI. *
      *                                                              *
      * ************************************************************ *
     Fsehni202  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/ifsio_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'

     D WSLBNI          pr                  ExtPgm('WSLBNI')
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keybni_t) const
     D   pePreg                            likeds(keybni_t)
     D   peUreg                            likeds(keybni_t)
     D   peLint                            likeds(pahint_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLBNI          pi
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keybni_t) const
     D   pePreg                            likeds(keybni_t)
     D   peUreg                            likeds(keybni_t)
     D   peLint                            likeds(pahint_t) dim(99)
     D   peLintC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLINT          pr                  ExtPgm('WSLINT')
     D   xeBase                            likeds(paramBase) const
     D   xeDint                            likeds(pahint_t)
     D   xeMint                            likeds(dsMail_t) dim(100)
     D   xeMintC                     10i 0
     D   xeErro                            like(paramErro)
     D   xeMsgs                            likeds(paramMsgs)

     D finArc          pr              n

     D k1hni202        ds                  likerec(s1hni202 : *key)

     D @@cant          s             10i 0
     D xeBase          ds                  likeds(paramBase)
     D xeDint          ds                  likeds(pahint_t)
     D xeMint          ds                  likeds(dsMail_t) dim(100)
     D xeMintC         s             10i 0
     D xeErro          s                   like(paramErro)
     D @@more          s              1N
     D xeMsgs          ds                  likeds(paramMsgs)

       *inLr = *On;

       peLintC = *Zeros;
       peErro  = *Zeros;
       peMore  = *Off;
       @@More  = *On;

       clear peLint;
       clear peMsgs;

      *- Validaciones
      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;
       exsr leeArc;

       dow ( ( not finArc ) and ( peLintC < @@cant ) );

         // --------------------------------------
         // Muevo Datos directamente de WSLINT
         // --------------------------------------

               xeBase.peEmpr = n2empr;
               xeBase.peSucu = n2sucu;
               xeBase.peNit1 = n2nivt;
               xeBase.peNiv1 = n2nivc;
               xeBase.peNivt = n2nivt;
               xeBase.peNivc = n2nivc;
               WSLINT(xeBase:
                      xeDint:
                      xeMint:
                      xeMintc:
                      xeErro:
                      xeMsgs);

         peLintC += 1;

         if peLintC = 1;
           exsr PriReg;
         endif;

         peLint( peLintC ).inempr = xeDint.inempr;
         peLint( peLintC ).insucu = xeDint.insucu;
         peLint( peLintC ).innivt = xeDint.innivt;
         peLint( peLintC ).innivc = xeDint.innivc;
         peLint( peLintC ).innomb = xeDint.innomb;
         peLint( peLintC ).indomi = xeDint.indomi;
         peLint( peLintC ).inndom = xeDint.inndom;
         peLint( peLintC ).inpiso = xeDint.inpiso;
         peLint( peLintC ).indeto = xeDint.indeto;
         peLint( peLintC ).incopo = xeDint.incopo;
         peLint( peLintC ).incops = xeDint.incops;
         peLint( peLintC ).inloca = xeDint.inloca;
         peLint( peLintC ).inproc = xeDint.inproc;
         peLint( peLintC ).inprod = xeDint.inprod;
         peLint( peLintC ).incoma = xeDint.incoma;
         peLint( peLintC ).innrma = xeDint.innrma;
         peLint( peLintC ).incuit = xeDint.incuit;
         peLint( peLintC ).intido = xeDint.intido;
         if peLint(peLintC).intido <= 0 or
            peLint(peLintC).intido = 99;
            peLint(peLintC).intido = 4;
         endif;
         peLint( peLintC ).innrdo = xeDint.innrdo;
         peLint( peLintC ).innuib = xeDint.innuib;
         peLint( peLintC ).incaliva = xeDint.incaliva;
         peLint( peLintC ).inporiva = xeDint.inporiva;
         peLint( peLintC ).inporret = xeDint.inporret;
         peLint( peLintC ).inretmin = xeDint.inretmin;
         peLint( peLintC ).intel2 = xeDint.intel2;
         peLint( peLintC ).intel3 = xeDint.intel3;
         peLint( peLintC ).intel4 = xeDint.intel4;
         peLint( peLintC ).intel5 = xeDint.intel5;
         peLint( peLintC ).intel6 = xeDint.intel6;
         peLint( peLintC ).intel7 = xeDint.intel7;
         peLint( peLintC ).intel8 = xeDint.intel8;
         peLint( peLintC ).intel9 = xeDint.intel9;
         peLint( peLintC ).inmail = xeDint.inmail;
         peLint( peLintC ).infnaa = xeDint.infnaa;
         peLint( peLintC ).infnam = xeDint.infnam;
         peLint( peLintC ).infnad = xeDint.infnad;
         peLint( peLintC ).ininta = xeDint.ininta;
         peLint( peLintC ).infiaa = xeDint.infiaa;
         peLint( peLintC ).infiam = xeDint.infiam;
         peLint( peLintC ).infiad = xeDint.infiad;
         peLint( peLintC ).ints20 = xeDint.ints20;
         peLint( peLintC ).inbloq = xeDint.inbloq;
         peLint( peLintC ).inmatr = xeDint.inmatr;
         peLint( peLintC ).inpaid = xeDint.inpaid;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when peRoll = 'R';
          peMore = @@more;
        when %eof(sehni202);
          peMore = *Off;
        other;
          peMore = *On;
       endsl;

      *- Rutina de Posicionamiento de Archivo. pePosi, peRoll
       begsr posArc;

         k1hni202.dfNomb = pePosi.dfNomb;
         k1hni202.dfNrdf = pePosi.dfNrdf;

             if ( peRoll = 'F' );
               setgt %kds ( k1hni202 : 2 ) sehni202;
             else;
               setll %kds ( k1hni202 : 2 ) sehni202;
             endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         read  sehni202;

         dow n2empr= ' ' and n2sucu= ' ' and n2nivt = 0 and
           n2nivc= 0 and not %eof(sehni202);
           exsr leeArc1;
         enddo;

           xeBase.peempr = n2empr;
           xeBase.pesucu = n2sucu;
           xeBase.penivt = n2nivt;
           xeBase.penivc = n2nivc;
           xeBase.penit1 = n2nivt;
           xeBase.peniv1 = n2nivc;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "R"
       begsr retArc;

         readp  sehni202;

         dow n2empr= ' ' and n2sucu= ' ' and n2nivt= 0 and
          n2nivc= 0 and not %eof(sehni202);
          exsr retArc1;
         enddo;

          xeBase.peempr = n2empr;
          xeBase.pesucu = n2sucu;
          xeBase.penivt = n2nivt;
          xeBase.penivc = n2nivc;
          xeBase.penit1 = n2nivt;
          xeBase.peniv1 = n2nivc;

          k1hni202.dfNomb = dfNomb;
          k1hni202.dfNrdf = dfNrdf;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc1;

         read  sehni202;

       endsr;

      *- Rutina de Lectura en caso de Paginado "R"
       begsr retArc1;

         readp  sehni202;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

             setll %kds( k1hni202 : 2 ) sehni202;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

         if ( peRoll = 'R' );
           exsr retArc;
           dow ( ( not %eof(sehni202) ) and ( @@cant > 0 ) );
             @@cant -= 1;
             exsr retArc;
           enddo;
           if %eof(sehni202);
              @@more = *off;
             exsr priArc;
           endif;
           @@cant = peCant;
           if (@@cant <= 0 or @@cant > 99);
              @@cant = 99;
           endif;
         endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

         pePreg.dfnomb = dfnomb;
         pePreg.dfnrdf = dfnrdf;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.dfnomb = dfnomb;
         peUreg.dfnrdf = dfnrdf;

       endsr;

     **- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

             return %eof ( sehni202 );

     P finArc          E
