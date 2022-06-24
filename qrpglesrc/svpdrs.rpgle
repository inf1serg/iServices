     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPDRS: Programa de Servicio.                                *
      *         Descuentos RV                                        *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     17-07-2015              *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * SFA 03/08/16 - Modifico _updDesc para endosos                *
      * SFA 18/08/16 - Modifico _updDesc para renovaciones           *
      * SFA 19/09/16 - Agrega procedimiento SVPDRS_getCaract()       *
      *                                     SVPDRS_chkCambioCaract() *
      *                                     SVPDRS_chkCaract()       *
      * SGF 19/04/17 - Corrección en chkCambioCaract(): redondeo de  *
      *                prima y se igualan xpri/ptco con xpra/ptca.   *
      *                                                              *
      * ************************************************************ *
     Fpahec1    if   e           k disk    usropn
     Fpaher0    if   e           k disk    usropn
     Fpaher2    uf   e           k disk    usropn
     Fpaher206  if   e           k disk    usropn rename(p1her2 : p1her206)
     F                                            prefix ( r206 : 2 )
     Fpaher207  if   e           k disk    usropn rename(p1her2 : p1her207)
     F                                            prefix ( r207 : 2 )
     Fpaher4    uf a e           k disk    usropn
     Fpaher403  if   e           k disk    usropn rename(p1her4 : p1her403)
     F                                            prefix ( r403 : 2 )
     Fpaher6    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/SVPDRS_H.rpgle'
      /copy './qcpybooks/SVPDRS_H.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- Pr Externos --------------------------------------------- *
     D PAR310X3        pr                  extpgm('PAR310X3')
     D   empr                         1    const
     D   aÑo                          4  0
     D   mes                          2  0
     D   dia                          2  0

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPDRS_getDescCob(): Retorna Descuentos de Cobertura         *
      * Retornar para la cobertura, todos los descuentos de cada     *
      * nivel segun los descuentos que se grabaron durante la        *
      * emision de la superpoliza                                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (input)   Cobertura                             *
      *     peLdes   (output)  Lista de Descuentos                   *
      *     peLdesC  (output)  Cant. Lista de Descuentos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_getDescCob...
     P                 B                   export
     D SVPDRS_getDescCob...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peXcob                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(99)
     D   peLdesC                     10i 0

     D k1yer4          ds                  likerec( p1her4 : *Key )

      /free

       SVPDRS_inz();

      *- Inicializo campos de salida
       clear peLdes;
       peLdesC = *Zeros;

      *- Obtengo Descuentos
       k1yer4.r4empr = peEmpr;
       k1yer4.r4sucu = peSucu;
       k1yer4.r4arcd = peArcd;
       k1yer4.r4spol = peSpol;
       k1yer4.r4sspo = peSspo;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4oper = peOper;
       k1yer4.r4poco = pePoco;
       k1yer4.r4suop = peSuop;
       setll %kds ( k1yer4 : 10 ) paher4;
       reade(n) %kds ( k1yer4 : 10 ) paher4;

       dow ( not %eof ( paher4 ) );

         if ( r4xcob = peXcob );

           peLdesC += 1;

           peLdes( peLdesC ).empr = peEmpr;
           peLdes( peLdesC ).sucu = peSucu;
           peLdes( peLdesC ).arcd = peArcd;
           peLdes( peLdesC ).rama = peRama;
           peLdes( peLdesC ).xcob = peXcob;
           peLdes( peLdesC ).ccbp = r4ccbp;
           peLdes( peLdesC ).nive = r4nive;
           peLdes( peLdesC ).recs = r4reca;
           peLdes( peLdesC ).bons = r4boni;

         endif;

         reade(n) %kds ( k1yer4 : 10 ) paher4;

       enddo;

       return *On;

      /end-free

     P SVPDRS_getDescCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_setDesc(): Graba Descuentos. Segun caracteristicas del*
      *                   bien asegurado.                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_setDesc...
     P                 B                   export
     D SVPDRS_setDesc...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer6          ds                  likerec( p1her6 : *Key )
     D k1yer4          ds                  likerec( p1her4 : *Key )

     D @@ccbp          s              3  0
     D @@xpro          s              3  0

     D @@Ldes          ds                  likeds(cobCa_t) dim(999)
     D @@LdesC         s             10i 0

     D x               s             10i 0

      /free

       SVPDRS_inz();

       if SVPDRS_dltDesc ( peEmpr : peSucu : peArcd : peSpol : peSspo :
                           peRama : peArse : peOper : pePoco : peSuop );
       endif;

      *- Recorro las Caracteristicas
       k1yer6.r6empr = peEmpr;
       k1yer6.r6sucu = peSucu;
       k1yer6.r6arcd = peArcd;
       k1yer6.r6spol = peSpol;
       k1yer6.r6sspo = peSspo;
       k1yer6.r6rama = peRama;
       k1yer6.r6arse = peArse;
       k1yer6.r6oper = peOper;
       k1yer6.r6poco = pePoco;
       k1yer6.r6suop = peSuop;
       setll %kds ( k1yer6 : 10 ) paher6;
       reade(n) %kds ( k1yer6 : 10 ) paher6;

       dow ( not %eof ( paher6 ) );

      *- Si Aplica Descuentos
         if ( r6ma01 = 'S' );

      *- Obtengo Descuento de la Caracteristica
           @@ccbp = SVPDRV_getDescuentoCarac ( peEmpr : peSucu :
                                               peRama : r6ccba );

      *- Obtengo Producto
           @@xpro = SPVSPO_getProducto ( peEmpr : peSucu : peArcd : peSpol
                                       : peSspo : peRama : peArse : peOper
                                       : pePoco : peSuop );

      *- Obtengo Coberturas y % del descuento
           if SVPDRV_getCoberturaDescuentoCab ( @@ccbp : peArcd : peRama
                                              : @@xpro : @@Ldes : @@LdesC );
           endif;

           for x = 1 to @@LdesC;

             if SVPDRS_chkCob ( peEmpr : peSucu : peArcd : peSpol :
                                peSspo : peRama : peArse : peOper :
                                pePoco : peSuop : @@Ldes( x ).xcob);

               k1yer4.r4empr = peEmpr;
               k1yer4.r4sucu = peSucu;
               k1yer4.r4arcd = peArcd;
               k1yer4.r4spol = peSpol;
               k1yer4.r4sspo = peSspo;
               k1yer4.r4rama = peRama;
               k1yer4.r4arse = peArse;
               k1yer4.r4oper = peOper;
               k1yer4.r4poco = pePoco;
               k1yer4.r4suop = peSuop;
               k1yer4.r4xcob = @@Ldes( x ).xcob;
               k1yer4.r4nive = @@Ldes( x ).nive;
               setll %kds ( k1yer4 : 12 ) paher4;

               if not %equal ( paher4 );
                 r4empr = peEmpr;
                 r4sucu = peSucu;
                 r4arcd = peArcd;
                 r4spol = peSpol;
                 r4sspo = peSspo;
                 r4rama = peRama;
                 r4arse = peArse;
                 r4oper = peOper;
                 r4poco = pePoco;
                 r4suop = peSuop;
                 r4xcob = @@Ldes( x ).xcob;
                 r4nive = @@Ldes( x ).nive;
                 r4ccbp = @@Ldes( x ).ccbp;

                 if ( r6mar1 = 'S' );
                   r4reca = @@Ldes( x ).recs;
                   r4boni = @@Ldes( x ).bons;
                 else;
                   r4reca = @@Ldes( x ).recn;
                   r4boni = @@Ldes( x ).bonn;
                 endif;

                 r4cert = *Zeros;
                 r4poli = *Zeros;
                 r4ma01 = *Blanks;
                 r4ma02 = *Blanks;
                 r4ma03 = *Blanks;
                 r4ma04 = *Blanks;
                 r4ma05 = *Blanks;
                 r4ma06 = *Blanks;
                 r4ma07 = *Blanks;
                 r4ma08 = *Blanks;
                 r4ma09 = *Blanks;
                 r4user = r6user;
                 r4date = udate;
                 r4time = %dec(%time():*iso);

                 write p1her4;

               else;

                 reade %kds ( k1yer4 : 12 ) paher4;

                 if ( r6mar1 = 'S' );
                   r4reca += @@Ldes( x ).recs;
                   r4boni += @@Ldes( x ).bons;
                 else;
                   r4reca += @@Ldes( x ).recn;
                   r4boni += @@Ldes( x ).bonn;
                 endif;

                 update p1her4;

               endif;

             endif;

           endfor;

         endif;

         reade(n) %kds ( k1yer6 : 10 ) paher6;

       enddo;

       return SVPDRS_chkDesc ( peEmpr : peSucu : peArcd : peSpol : peSspo :
                               peRama : peArse : peOper : pePoco : peSuop );

      /end-free

     P SVPDRS_setDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_dltDesc(): Elimina Descuentos                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_dltDesc...
     P                 B                   export
     D SVPDRS_dltDesc...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer4          ds                  likerec( p1her4 : *Key )

      /free

       SVPDRS_inz();

       k1yer4.r4empr = peEmpr;
       k1yer4.r4sucu = peSucu;
       k1yer4.r4arcd = peArcd;
       k1yer4.r4spol = peSpol;
       k1yer4.r4sspo = peSspo;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4oper = peOper;
       k1yer4.r4poco = pePoco;
       k1yer4.r4suop = peSuop;
       setll %kds ( k1yer4 : 10 ) paher4;
       reade %kds ( k1yer4 : 10 ) paher4;

       dow ( not %eof ( paher4 ) );

         delete p1her4;

         reade %kds ( k1yer4 : 10 ) paher4;

       enddo;

       return *On;

      /end-free

     P SVPDRS_dltDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_getFec(): Retorna Fecha de Inicio de emision para     *
      *                  suspendidas o fecha del dia para nuevas     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Fecha                                               *
      * ------------------------------------------------------------ *
     P SVPDRS_getFec...
     P                 B                   export
     D SVPDRS_getFec...
     D                 pi             8  0
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1yec1          ds                  likerec( p1hec1 : *Key )

     D aÑo             s              4  0 inz(0000)
     D mes             s              2  0 inz(00)
     D dia             s              2  0 inz(00)

      /free

       SVPDRS_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       chain(n) %kds ( k1yec1 ) pahec1;

       if ( c1fema = *Zeros ) or ( c1femm = *Zeros ) or ( c1femd = *zeros );
         PAR310X3( peEmpr : aÑo : mes : dia );
         return aÑo * 10000 + mes * 100 + dia;
       else;
         return c1fema * 10000 + c1femm * 100 + c1femd;
       endif;

      /end-free

     P SVPDRS_getFec...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_updDesc(): Actualiza Tasa y Prima                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_updDesc...
     P                 B                   export
     D SVPDRS_updDesc...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer2          ds                  likerec( p1her2 : *Key )
     D k1yer6          ds                  likerec( p1her6 : *Key )

     D @@Ldec          ds                  likeds(cobCa_t) dim(999)
     D @@LdecC         s             10i 0

     D @@Nive          ds                  likeds(descCo_t) dim(999)
     D @@NiveC         s             10i 0

     D @@xpra          s              9  6
     D @@xpri          s              9  6
     D @@ptco          s             29  9
     D @@ptcoO         s             29  9
     D @@ptcoA         s             29  9
     D @@ptca          s             29  9
     D @@saco          s             15  2
     D @@prim          s             15  2
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0
     D @@sspo          s              3  0
     D descNuevo       s               n
     D CambCarac       s               n
     D CambSuma        s               n
     D CambSumaXpri    s               n
     D @@ptco_orig     s             15  2 inz
     D @@ptca1         s             15  2
     D @@ptco1         s             15  2
     D @@dupe          s              3  0

      /free

       SVPDRS_inz();
       eval @@sspo  = peSspo;
       callp SPVSPO_getTipoOperacion( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : @@sspo
                                    : @@tiou
                                    : @@stou
                                    : @@stos );

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;
       k1yer2.r2sspo = peSspo;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2oper = peOper;
       k1yer2.r2poco = pePoco;
       k1yer2.r2suop = peSuop;
       setll %kds ( k1yer2 : 10 ) paher2;
       reade %kds ( k1yer2 : 10 ) paher2;

       dow ( not %eof ( paher2 ) );

         SVPDRS_getDescCob ( peEmpr : peSucu : peArcd : peSpol : peSspo :
                             peRama : peArse : peOper : pePoco : peSuop :
                             r2xcob : @@Ldec : @@LdecC );

           descNuevo = *off;
           clear @@ptca;
           clear @@xpri;
           clear @@prim;
           // Obtiene prima anterior...
           if SVPDRS_getPrimaAnterior( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peSspo
                                     : peRama
                                     : peArse
                                     : peOper
                                     : pePoco
                                     : peSuop
                                     : r2riec
                                     : r2xcob
                                     : @@prim  );

           // Prorratea prima anterior...
           @@ptca = @@prim;
           @@dupe = SPVSPO_getDiasFacturacionEndoso
                    ( peEmpr : peSucu : peArcd : peSpol : peSspo );
           @@ptca1 = %dech( @@ptca : 15 : 2 );
           @@ptca = ( @@ptca1 / 365 ) * @@dupe;

           @@ptca1 = %dech( @@ptca : 15 : 2 );
           else;
             //Si no tiene prima anterior entonces el desc. es nuevo...
             @@ptco  = r2ptco;
             @@ptca1 = 0;
             if @@tiou <> 3;
               r2xpra = r2xpri;
             endif;
             descNuevo = *on;
           endif;

         @@xpri = r2xpra;
         if SVPDRV_getDescuentosCobNiv ( @@Ldec : @@LdecC : @@Nive : @@NiveC );

           if ( @@Nive( @@NiveC ).niv1 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv1 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv2 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv2 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv3 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv3 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv4 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv4 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv5 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv5 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv6 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv6 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv7 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv7 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv8 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv8 ) / 100;
           endif;

           if ( @@Nive( @@NiveC ).niv9 <> *Zeros );
             @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv9 ) / 100;
           endif;
         endif;

         //Calcula Nueva Prima con descuento...
         @@ptco = ( ( r2saco * @@xpri ) / 1000 );
         @@dupe = SPVSPO_getDiasFacturacionEndoso
                  ( peEmpr : peSucu : peArcd : peSpol : peSspo );
         @@ptco1 = %dech( @@ptco : 15 : 2 );
         @@ptco = ( @@ptco1 / 365 ) * @@dupe;
         @@ptco1 = %dech( @@ptco : 15 : 2 );
         r2ptco = ( @@ptca1 * -1 ) + @@ptco1;
         //eval(h) r2ptco = ( @@ptca * -1 ) + @@ptco;
         r2xpri = @@xpri;
         update p1her2;

         reade %kds ( k1yer2 : 10 ) paher2;
       enddo;
       return *On;

      /end-free

     P SVPDRS_updDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_updNoDesc(): Actualiza Tasa y Prima cuando no hay     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_updNoDesc...
     P                 B                   export
     D SVPDRS_updNoDesc...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer2          ds                  likerec( p1her2 : *Key )

     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0
     D @@sspo          s              3  0

      /free

       SVPDRS_inz();
       eval @@sspo  = peSspo;
       callp SPVSPO_getTipoOperacion( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : @@sspo
                                    : @@tiou
                                    : @@stou
                                    : @@stos );
       if @@tiou = 1;
          @@tiou = 2;
         if SVPDRS_chkCambioCaract( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : peSspo
                                  : peRama
                                  : peArse
                                  : peOper
                                  : pePoco
                                  : peSuop );
           return *on;
         endif;
       endif;

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;
       k1yer2.r2sspo = peSspo;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2oper = peOper;
       k1yer2.r2poco = pePoco;
       k1yer2.r2suop = peSuop;
       setll %kds ( k1yer2 : 10 ) paher2;
       reade %kds ( k1yer2 : 10 ) paher2;

       dow ( not %eof ( paher2 ) );

         r2xpra = r2xpri;
         r2ptca = r2ptco;

         update p1her2;

         reade %kds ( k1yer2 : 10 ) paher2;

       enddo;

       return *On;

      /end-free

     P SVPDRS_updNoDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_getLcob(): Retorna lista de Coberturas                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peLcob   (output)  Lista de Coberturas                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_getLcob...
     P                 B                   export
     D SVPDRS_getLcob...
     D                 pi            10i 0
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peLcob                            likeds(descCo_t) dim(20)

     D k1yer2          ds                  likerec( p1her2 : *Key )

     D x               s             10i 0

      /free

       SVPDRS_inz();

       x = *Zeros;

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;
       k1yer2.r2sspo = peSspo;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2oper = peOper;
       k1yer2.r2poco = pePoco;
       k1yer2.r2suop = peSuop;
       setll %kds ( k1yer2 : 10 ) paher2;
       reade(n) %kds ( k1yer2 : 10 ) paher2;

       dow ( not %eof ( paher2 ) );

         if SVPDRV_chkCobList ( peLcob : r2xcob ) = *Zeros;

           x += 1;
           peLcob(x).xcob = r2xcob;

         endif;

         reade(n) %kds ( k1yer2 : 10 ) paher2;

       enddo;

       return x;

      /end-free

     P SVPDRS_getLcob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_chkCob(): Existe cobertrua en Er2                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (output)  Lista de Coberturas                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_chkCob...
     P                 B                   export
     D SVPDRS_chkCob...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peXcob                       3  0 const

     D k1yer2          ds                  likerec( p1her2 : *Key )

      /free

       SVPDRS_inz();

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;
       k1yer2.r2sspo = peSspo;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2oper = peOper;
       k1yer2.r2poco = pePoco;
       k1yer2.r2suop = peSuop;
       setll %kds ( k1yer2 : 10 ) paher2;
       reade(n) %kds ( k1yer2 : 10 ) paher2;

       dow ( not %eof ( paher2 ) );

         if ( r2xcob = peXcob );

           return *On;

         endif;

         reade(n) %kds ( k1yer2 : 10 ) paher2;

       enddo;

       return *Off;

      /end-free

     P SVPDRS_chkCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_updDescAnt(): Vuelve valores anteriores a PAHER2      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_updDescAnt...
     P                 B                   export
     D SVPDRS_updDescAnt...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer2          ds                  likerec( p1her2 : *Key )

      /free

       SVPDRS_inz();

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;
       k1yer2.r2sspo = peSspo;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2oper = peOper;
       k1yer2.r2poco = pePoco;
       k1yer2.r2suop = peSuop;
       setll %kds ( k1yer2 : 10 ) paher2;
       reade %kds ( k1yer2 : 10 ) paher2;

       dow ( not %eof ( paher2 ) );

         r2xpri = r2xpra;
         r2ptco = r2ptca;

         r2xpra = *Zeros;
         r2ptca = *Zeros;

         update p1her2;

         reade %kds ( k1yer2 : 10 ) paher2;

       enddo;

       return *Off;

      /end-free

     P SVPDRS_updDescAnt...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_chkDesc(): Cheque si se realizaron Descuentos         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_chkDesc...
     P                 B                   export
     D SVPDRS_chkDesc...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer4          ds                  likerec( p1her4 : *Key )

      /free

       SVPDRS_inz();

       k1yer4.r4empr = peEmpr;
       k1yer4.r4sucu = peSucu;
       k1yer4.r4arcd = peArcd;
       k1yer4.r4spol = peSpol;
       k1yer4.r4sspo = peSspo;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4oper = peOper;
       k1yer4.r4poco = pePoco;
       k1yer4.r4suop = peSuop;
       setll %kds ( k1yer4 : 10 ) paher4;

       return %equal ( paher4 );

      /end-free

     P SVPDRS_chkDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_chkImpactoDesc(): Cheque si se impactaron Descuentos  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_chkImpactoDesc...
     P                 B                   export
     D SVPDRS_chkImpactoDesc...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer2          ds                  likerec( p1her2 : *Key )

      /free

       SVPDRS_inz();

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;
       k1yer2.r2sspo = peSspo;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2oper = peOper;
       k1yer2.r2poco = pePoco;
       k1yer2.r2suop = peSuop;
       setll %kds ( k1yer2 : 10 ) paher2;
       reade(n) %kds ( k1yer2 : 10 ) paher2;

       dow not %eof ( paher2 );

         if ( r2xpra <> r2xpri ) and ( r2ptca <> r2ptco );
           return *On;
         endif;

         reade(n) %kds ( k1yer2 : 10 ) paher2;

       enddo;

       return *Off;

      /end-free

     P SVPDRS_chkImpactoDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDRS_inz      B                   export
     D SVPDRS_inz      pi

      /free

       if not %open(pahec1);
         open pahec1;
       endif;

       if not %open(paher0);
         open paher0;
       endif;

       if not %open(paher2);
         open paher2;
       endif;

       if not %open(paher207);
         open paher207;
       endif;

       if not %open(paher206);
         open paher206;
       endif;

       if not %open(paher4);
         open paher4;
       endif;

       if not %open(paher403);
         open paher403;
       endif;

       if not %open(paher6);
         open paher6;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPDRS_inz      E

      * ------------------------------------------------------------ *
      * SVPDRS_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDRS_End      B                   export
     D SVPDRS_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPDRS_End      E

      * ------------------------------------------------------------ *
      * SVPDRS_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPDRS_Error    B                   export
     D SVPDRS_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPDRS_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_getDescCobDiferencia():                               *
      * Retornar para la cobertura, todos los descuentos de cada     *
      * nivel segun las caracteristicas que fueron grabadas en la    *
      * emision de la superpoliza, compara con el suplemento anterior*
      * y solo trae los que fueron modificados                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (input)   Cobertura                             *
      *     peLdes   (output)  Lista de Descuentos                   *
      *     peLdesC  (output)  Cant. Lista de Descuentos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_getDescCobDiferencia...
     P                 B                   export
     D SVPDRS_getDescCobDiferencia...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peXcob                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(99)
     D   peLdesC                     10i 0

     D k1yer4          ds                  likerec( p1her4 : *Key )
     D k2yer4          ds                  likerec( p1her403 : *Key )

      /free

       SVPDRS_inz();

      *- Inicializo campos de salida
       clear peLdes;
       peLdesC = *Zeros;

      *- Obtengo Descuentos
       k1yer4.r4empr = peEmpr;
       k1yer4.r4sucu = peSucu;
       k1yer4.r4arcd = peArcd;
       k1yer4.r4spol = peSpol;
       k1yer4.r4sspo = peSspo;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4oper = peOper;
       k1yer4.r4poco = pePoco;
       k1yer4.r4suop = peSuop;
       setll %kds ( k1yer4 : 10 ) paher4;
       reade(n) %kds ( k1yer4 : 10 ) paher4;

       dow ( not %eof ( paher4 ) );

      *- Obtengo Descuentos en endoso anterior
         k2yer4.r403empr = r4empr;
         k2yer4.r403sucu = r4sucu;
         k2yer4.r403arcd = r4arcd;
         k2yer4.r403spol = r4spol;
         k2yer4.r403sspo = r4sspo - 1;
         k2yer4.r403rama = r4rama;
         k2yer4.r403arse = r4arse;
         k2yer4.r403oper = r4oper;
         k2yer4.r403poco = r4poco;
         k2yer4.r403suop = r4suop - 1;
         k2yer4.r403xcob = r4xcob;
         chain(n) %kds ( k2yer4 : 11 ) paher403;

         if ( r4xcob = peXcob ) and ( not %found ( paher403 ) );

           peLdesC += 1;

           peLdes( peLdesC ).empr = peEmpr;
           peLdes( peLdesC ).sucu = peSucu;
           peLdes( peLdesC ).arcd = peArcd;
           peLdes( peLdesC ).rama = peRama;
           peLdes( peLdesC ).xcob = peXcob;
           peLdes( peLdesC ).ccbp = r4ccbp;
           peLdes( peLdesC ).nive = r4nive;
           peLdes( peLdesC ).recs = r4reca;
           peLdes( peLdesC ).bons = r4boni;

         endif;

         reade(n) %kds ( k1yer4 : 10 ) paher4;

       enddo;

       return *On;

      /end-free

     P SVPDRS_getDescCobDiferencia...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_getSumaAsegurada(): Retorna Suma Asegurada            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * Retorna: Suma Asegurada                                      *
      * ------------------------------------------------------------ *
     P SVPDRS_getSumaAsegurada...
     P                 B                   export
     D SVPDRS_getSumaAsegurada...
     D                 pi            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

     D k1yer2          ds                  likerec( p1her206 : *Key )

       SVPDRS_inz();

       k1yer2.r206empr = peEmpr;
       k1yer2.r206sucu = peSucu;
       k1yer2.r206arcd = peArcd;
       k1yer2.r206spol = peSpol;
       k1yer2.r206sspo = peSspo;
       k1yer2.r206rama = peRama;
       k1yer2.r206arse = peArse;
       k1yer2.r206oper = peOper;
       k1yer2.r206poco = pePoco;
       k1yer2.r206suop = peSuop;
       k1yer2.r206riec = peRiec;
       k1yer2.r206xcob = peXcob;
       chain(n) %kds ( k1yer2 : 12 ) paher206;

       if not %found ( paher206 );
         return *Zeros;
       else;
         return r206saco;
       endif;

     P SVPDRS_getSumaAsegurada...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_getTasa(): Retorna Tasa                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * Retorna: Tasa                                                *
      * ------------------------------------------------------------ *
     P SVPDRS_getTasa...
     P                 B                   export
     D SVPDRS_getTasa...
     D                 pi             9  6
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

     D k1yer2          ds                  likerec( p1her206 : *Key )

       SVPDRS_inz();

       k1yer2.r206empr = peEmpr;
       k1yer2.r206sucu = peSucu;
       k1yer2.r206arcd = peArcd;
       k1yer2.r206spol = peSpol;
       k1yer2.r206sspo = peSspo;
       k1yer2.r206rama = peRama;
       k1yer2.r206arse = peArse;
       k1yer2.r206oper = peOper;
       k1yer2.r206poco = pePoco;
       k1yer2.r206suop = peSuop;
       k1yer2.r206riec = peRiec;
       k1yer2.r206xcob = peXcob;
       chain(n) %kds ( k1yer2 : 12 ) paher206;

       if not %found ( paher206 );
         return *Zeros;
       else;
       return r206xpri;
       endif;

     P SVPDRS_getTasa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRS_getCaract(): Retorna Lista de Caracteristicas de una  *
      *                     Poliza                                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peLcar   (input)   Lista de Carcteristicas               *
      *     peLcarC  (input)   Cantidad de Caracteristicas           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_getCaract...
     P                 B                   export
     D SVPDRS_getCaract...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peLcar                            likeds(caract_t) dim(99)
     D   peLcarC                     10i 0

     D   @@tiou        s              1  0 inz
     D   @@stou        s              2  0 inz
     D   @@stos        s              2  0 inz

     D k1yer6          ds                  likerec( p1her6 : *Key )

      /free

       SVPDRS_inz();

       clear peLcar;

       k1yer6.r6empr = peEmpr;
       k1yer6.r6sucu = peSucu;
       k1yer6.r6arcd = peArcd;
       k1yer6.r6spol = peSpol;
       k1yer6.r6sspo = peSspo;
       k1yer6.r6rama = peRama;
       k1yer6.r6arse = peArse;
       k1yer6.r6oper = peOper;
       k1yer6.r6poco = pePoco;
       k1yer6.r6suop = peSuop;
       setll %kds ( k1yer6 : 10 ) paher6;
       if not %equal ( paher6 );
         return *off;
       endif;
       reade %kds ( k1yer6 : 10 ) paher6;
       dow not %eof( paher6 );

         peLcarC += 1;
         peLcar( peLcarC ).ccba = r6ccba;
         peLcar( peLcarC ).mar1 = r6mar1;
         peLcar( peLcarC ).ma01 = r6ma01;

        reade %kds ( k1yer6 : 10 ) paher6;
       enddo;

       return *on;

     P SVPDRS_getCaract...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDRS_getPrima(): Retorna Prima                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *     pePrim   (input)   Prima                                 *
      *                                                              *
      * Retorna: Prima                                               *
      * ------------------------------------------------------------ *
     P SVPDRS_getPrima...
     P                 B                   export
     D SVPDRS_getPrima...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   pePrim                      15  2

     D   @@prim        s             29  9

     D k1yer2          ds                  likerec( p1her207 : *Key )

       SVPDRS_inz();

       k1yer2.r207empr = peEmpr;
       k1yer2.r207sucu = peSucu;
       k1yer2.r207arcd = peArcd;
       k1yer2.r207spol = peSpol;
       k1yer2.r207rama = peRama;
       k1yer2.r207arse = peArse;
       k1yer2.r207oper = peOper;
       k1yer2.r207poco = pePoco;
       k1yer2.r207riec = peRiec;
       k1yer2.r207xcob = peXcob;
       k1yer2.r207sspo = pesspo;
       k1yer2.r207suop = pesuop;
       setll %kds ( k1yer2 : 12 ) paher207;
       if not %equal ( paher207 );
         clear pePrim;
         return *off;
       endif;
       reade %kds ( k1yer2 : 10 ) paher207;
       dow not %eof( paher207 );
         @@prim = ( r207ptco *  SPVSPO_getDiasFacturacionEndoso
                  ( peEmpr : peSucu : peArcd : peSpol : 0) ) /
                    SPVSPO_getDiasFacturacionEndoso
                   ( peEmpr : peSucu : peArcd : peSpol : r207sspo);
         eval(h) pePrim += @@prim;
         clear @@prim;
         reade %kds ( k1yer2 : 10 ) paher207;
       enddo;

       return *on;

     P SVPDRS_getPrima...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDRS_chkCambioCaract(): Valida Cambio de Caracteristicas de*
      *                          de una Poliza                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_chkCambioCaract...
     P                 B                   export
     D SVPDRS_chkCambioCaract...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D   @1Lcar        ds                  likeds(caract_t) dim(99)
     D   @1LcarC       s             10i 0

     D   @2Lcar        ds                  likeds(caract_t) dim(99)
     D   @2LcarC       s             10i 0

     D @@Carac_T       ds
     D   @@cara                            dim(999)
     D   @@ccba                       3  0 overlay( @@cara : *NEXT )
     D   @@mar1                       1    overlay( @@cara : *NEXT )
     D   @@ma01                       1    overlay( @@cara : *NEXT )

     D k1yer2          ds                  likerec( p1her2 : *Key )

     D x               s             10i 0
     D z               s             10i 0
     D rc              s              1n
     D ri              s              1n

      /free

       SVPDRS_inz();

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;
       k1yer2.r2sspo = peSspo;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2oper = peOper;
       k1yer2.r2poco = pePoco;
       k1yer2.r2suop = peSuop;
       setll %kds ( k1yer2 : 10 ) paher2;
       reade %kds ( k1yer2 : 10 ) paher2;
       dow ( not %eof ( paher2 ) );
         r2xpri = r2xpra;
         r2ptco = r2ptca;
         update p1her2;
         reade %kds ( k1yer2 : 10 ) paher2;
       enddo;

       rc =   SVPDRS_getCaract( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : peSspo -1
                              : peRama
                              : peArse
                              : peOper
                              : pePoco
                              : peSuop -1
                              : @1Lcar
                              : @1LcarC  );

       ri = SVPDRS_getCaract( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peRama
                            : peArse
                            : peOper
                            : pePoco
                            : peSuop
                            : @2Lcar
                            : @2LcarC );

       // ------------------------------
       // Antes no tenía y ahora sí
       // ------------------------------
       if not rc and ri;
          return *on;
       endif;

         @@cara = @1Lcar;

         for x = 1 to @2LcarC;
           z = %lookup(@2Lcar(x).ccba : @@ccba: 1: 99);
           if z = 0;
             if @2Lcar(x).ma01 = 'S';
               return *on;
             endif;
           else;
             if @@ma01(z) <> @2Lcar(x).ma01;
               return *on;
             endif;
           endif;

         endfor;

         clear @@cara;
         @@cara = @2Lcar;

         for x = 1 to @1LcarC;
           z = %lookup(@1Lcar(x).ccba : @@ccba: 1: 99);
           if z = 0;
             if @1Lcar(x).ma01 = 'S';
               return *on;
             endif;
           else;
             if @@ma01(z) <> @1Lcar(x).ma01;
               return *on;
             endif;
           endif;

         endfor;
       return *off;

     P SVPDRS_chkCambioCaract...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDRS_chkCaract(): Valida si superpoliza contiene           *
      *                     Caracteristicas                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRS_chkCaract...
     P                 B                   export
     D SVPDRS_chkCaract...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer6          ds                  likerec( p1her6 : *Key )

      /free

       SVPDRS_inz();

       k1yer6.r6empr = peEmpr;
       k1yer6.r6sucu = peSucu;
       k1yer6.r6arcd = peArcd;
       k1yer6.r6spol = peSpol;
       k1yer6.r6sspo = peSspo;
       k1yer6.r6rama = peRama;
       k1yer6.r6arse = peArse;
       k1yer6.r6oper = peOper;
       k1yer6.r6poco = pePoco;
       k1yer6.r6suop = peSuop;
       setll %kds ( k1yer6 : 10 ) paher6;
         return %equal;

     P SVPDRS_chkCaract...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDRS_getPrimaAnterior(): Retorna Prima Anterior            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *     pePrim   (input)   Prima                                 *
      *                                                              *
      * Retorna: Prima                                               *
      * ------------------------------------------------------------ *
     P SVPDRS_getPrimaAnterior...
     P                 B                   export
     D SVPDRS_getPrimaAnterior...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   pePrim                      15  2

     D   @@Suop        s              3  0
     D   @@Sspo        s              3  0

       SVPDRS_inz();

       @@sspo  = peSspo - 1 ;
       @@suop  = peSuop - 1 ;

       dow @@sspo >= *zeros;

         if SVPDRS_getPrima( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol
                           : @@sspo
                           : peRama
                           : peArse
                           : peOper
                           : pePoco
                           : @@suop
                           : r2riec
                           : r2xcob
                           : pePrim  );

           return *on;
         endif;
         @@sspo -= 1;
         @@suop -= 1;
       enddo;
       return *off;

     P SVPDRS_getPrimaAnterior...
     P                 E
