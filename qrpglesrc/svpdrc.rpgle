     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPDRC: Programa de Servicio.                                *
      *         Descuentos RV - Cotizacion                           *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                   09-09-2015              *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * SGF 26/01/17: Corrijo clave de lectura en el reade del proc. *
      *               _getDescCob().                                 *
      * SGF 27/03/17: Los descuentos se aplican de acuerdo a MA02 y  *
      *               no a MA01.                                     *
      *                                                              *
      * ************************************************************ *
     Fctwer2    uf a e           k disk    usropn
     Fctwer4    uf a e           k disk    usropn
     Fctwer6    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpdrc_H.rpgle'
      /copy './qcpybooks/svpdrv_H.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPDRC_getDescCob(): Retorna Descuentos de Cobertura         *
      * Retornar para la cobertura, todos los descuentos de cada     *
      * nivel segun los descuentos que se grabaron durante la        *
      * Cotizacion Web.                                              *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peXcob   (input)   Cobertura                             *
      *     peLdes   (output)  Lista de Descuentos                   *
      *     peLdesC  (output)  Cant. Lista de Descuentos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_getDescCob...
     P                 B                   export
     D SVPDRC_getDescCob...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pecobe                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(999)
     D   peLdesC                     10i 0

     D k1yer4          ds                  likerec( c1wer4 : *Key )

      /free

       SVPDRC_inz();

      *- Inicializo campos de salida
       clear peLdes;
       peLdesC = *Zeros;

      *- Obtengo Descuentos
       k1yer4.r4empr = peBase.peEmpr;
       k1yer4.r4sucu = peBase.peSucu;
       k1yer4.r4nivt = peBase.peNivt;
       k1yer4.r4nivc = peBase.peNivc;
       k1yer4.r4nctw = peNctw;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4poco = pePoco;
       k1yer4.r4xcob = peCobe;
       k1yer4.r4nive = *Zeros;
       setll %kds ( k1yer4 : 9 ) ctwer4;
       reade(n) %kds ( k1yer4 : 9 ) ctwer4;
       dow ( not %eof ( ctwer4 ) );
        if ( r4xcob = pecobe );
         peLdesC += 1;

         peLdes( peLdesC ).empr = r4Empr;
         peLdes( peLdesC ).sucu = r4Sucu;
         peLdes( peLdesC ).rama = r4rama;
         peLdes( peLdesC ).xcob = r4xcob;
         peLdes( peLdesC ).nive = r4nive;
         peLdes( peLdesC ).recs = r4reca;
         peLdes( peLdesC ).bons = r4boni;
         peLdes( peLdesC ).ccbp = r4ccbp;

        endif;

        reade(n) %kds ( k1yer4 : 9 ) ctwer4;

       enddo;

       return *On;

      /end-free

     P SVPDRC_getDescCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_setDesc(): Graba Descuentos. Segun caracteristicas del*
      *                   bien asegurado.                            *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     pexpro   (input)   Código de Plan                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_setDesc...
     P                 B                   export
     D SVPDRC_setDesc...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pexpro                       3  0 const

     D k1yer6          ds                  likerec( c1wer6 : *Key )
     D k1yer4          ds                  likerec( c1wer4 : *Key )

     D @@ccbp          s              3  0
     D @@Arcd          s              6  0

     D @@Ldes          ds                  likeds(cobCa_t) dim(999)
     D @@LdesC         s             10i 0

     D x               s             10i 0

      /free

       SVPDRC_inz();

       SVPDRC_dltDesc ( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco );

      *- Recorro las Caracteristicas
       k1yer6.r6empr = peBase.peEmpr;
       k1yer6.r6sucu = peBase.peSucu;
       k1yer6.r6nivt = peBase.peNivt;
       k1yer6.r6nivc = peBase.peNivc;
       k1yer6.r6nctw = peNctw;
       k1yer6.r6rama = peRama;
       k1yer6.r6arse = peArse;
       k1yer6.r6poco = pePoco;
       setll %kds ( k1yer6 : 8 ) ctwer6;
       reade %kds ( k1yer6 : 8 ) ctwer6;
       dow ( not %eof ( ctwer6 ) );
      *-Si Aplica Descuentos
        if ( r6ma02 = 'S' );

      *-Obtengo Descuento de la Caracteristica
          @@ccbp = SVPDRV_getDescuentoCarac ( pebase.peEmpr
                                            : pebase.peSucu
                                            : peRama
                                            : r6ccba);

         @@Arcd = COWGRAI_getArticulo( peBase
                                     : peNctw );

      *-Obtengo Coberturas y % del descuento
         if SVPDRV_getCoberturaDescuentoCab ( @@ccbp
                                            : @@Arcd
                                            : peRama
                                            : peXpro
                                            : @@Ldes
                                            : @@LdesC );
         endif;

         for x = 1 to @@LdesC;

          if SVPDRC_chkCob ( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : pePoco
                           : @@Ldes( x ).xcob);

           k1yer4.r4empr = peBase.peEmpr;
           k1yer4.r4sucu = peBase.peSucu;
           k1yer4.r4nivt = peBase.peNivt;
           k1yer4.r4nivc = peBase.peNivc;
           k1yer4.r4nctw = peNctw;
           k1yer4.r4rama = peRama;
           k1yer4.r4arse = peArse;
           k1yer4.r4poco = pePoco;
           k1yer4.r4xcob = @@Ldes( x ).xcob;
           k1yer4.r4nive = @@Ldes( x ).nive;
           setll %kds ( k1yer4 : 10 ) ctwer4;

            if not %equal ( ctwer4 );
             r4empr = peBase.peEmpr;
             r4sucu = peBase.peSucu;
             r4nivt = peBase.peNivt;
             r4nivc = peBase.peNivc;
             r4nctw = peNctw;
             r4rama = peRama;
             r4arse = peArse;
             r4poco = pePoco;
             r4xcob = @@Ldes( x ).xcob;
             r4nive = @@Ldes( x ).nive;
             r4ccbp = @@Ldes( x ).ccbp;

              if ( r6ma02 = 'S' );
               r4reca = @@Ldes( x ).recs;
               r4boni = @@Ldes( x ).bons;
              else;
               r4reca = @@Ldes( x ).recn;
               r4boni = @@Ldes( x ).bonn;
              endif;

               r4ma01 = *Blanks;
               r4ma02 = *Blanks;
               r4ma03 = *Blanks;
               r4ma04 = *Blanks;
               r4ma05 = *Blanks;

               write c1wer4;

            else;

               reade %kds ( k1yer4 : 10 ) c1wer4;

                if ( r6ma02 = 'S' );
                 r4reca += @@Ldes( x ).recs;
                 r4boni += @@Ldes( x ).bons;
                else;
                  r4reca += @@Ldes( x ).recn;
                  r4boni += @@Ldes( x ).bonn;
                endif;

                 update c1wer4;

            endif;

          endif;

         endfor;

        endif;

         reade %kds ( k1yer6 : 8 ) c1wer6;

       enddo;

        return *on;

      /end-free

     P SVPDRC_setDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_dltDesc(): Elimina Descuentos                         *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDRC_dltDesc...
     P                 B                   export
     D SVPDRC_dltDesc...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D k1yer4          ds                  likerec( c1wer4 : *Key )

      /free

       SVPDRC_inz();

       k1yer4.r4empr = peBase.peEmpr;
       k1yer4.r4sucu = peBase.peSucu;
       k1yer4.r4nivt = peBase.peNivt;
       k1yer4.r4nivc = peBase.peNivc;
       k1yer4.r4nctw = peNctw;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4poco = pePoco;
       setll %kds ( k1yer4 : 8 ) ctwer4;
       reade %kds ( k1yer4 : 8 ) ctwer4;

       dow ( not %eof ( ctwer4 ) );

         delete ctwer4;

         reade %kds ( k1yer4 : 8 ) ctwer4;

       enddo;

      /end-free

     P SVPDRC_dltDesc...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDRC_updDesc(): Actualiza Tasa y Prima                     *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura (Prima)                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_updDesc...
     P                 B                   export
     D SVPDRC_updDesc...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

     D k1yer2          ds                  likerec( c1wer2 : *Key )

     D @@Ldes          ds                  likeds(cobCa_t) dim(999)
     D @@LdesC         s             10i 0

     D @@Nive          ds                  likeds(descCo_t) dim(999)
     D @@NiveC         s             10i 0

     D @@xpri          s              9  6
     D @@ptco          s             15  2

      /free

       SVPDRC_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = *blank;
       k1yer2.r2xcob = *zeros;
       setll %kds ( k1yer2 : 10 ) ctwer2;
       reade %kds ( k1yer2 : 8 ) ctwer2;

       dow ( not %eof ( ctwer2 ) );

         if ( r2xcob = peCobe );

            SVPDRC_getDescCob ( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : peCobe
                              : @@Ldes
                              : @@LdesC );

            if SVPDRV_getDescuentosCobNiv ( @@Ldes
                                          : @@LdesC
                                          : @@Nive
                                          : @@NiveC );
              @@xpri = r2xpri;
              @@ptco = r2ptco;

               if ( @@Nive( @@NiveC ).niv1 <> *Zeros );
                  @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv1 ) / 100;
                  @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv1 ) / 100;
               endif;

               if ( @@Nive( @@NiveC ).niv2 <> *Zeros );
                  @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv2 ) / 100;
                  @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv2 ) / 100;
               endif;

               if ( @@Nive( @@NiveC ).niv3 <> *Zeros );
                  @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv3 ) / 100;
                  @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv3 ) / 100;
               endif;

               if ( @@Nive( @@NiveC ).niv4 <> *Zeros );
                  @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv4 ) / 100;
                  @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv4 ) / 100;
               endif;

               if ( @@Nive( @@NiveC ).niv5 <> *Zeros );
                  @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv5 ) / 100;
                  @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv5 ) / 100;
               endif;

              if ( @@Nive( @@NiveC ).niv6 <> *Zeros );
                 @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv6 ) / 100;
                 @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv6 ) / 100;
              endif;

              if ( @@Nive( @@NiveC ).niv7 <> *Zeros );
                 @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv7 ) / 100;
                 @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv7 ) / 100;
              endif;

              if ( @@Nive( @@NiveC ).niv8 <> *Zeros );
                 @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv8 ) / 100;
                 @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv8 ) / 100;
              endif;

              if ( @@Nive( @@NiveC ).niv9 <> *Zeros );
                 @@xpri += ( @@xpri * @@Nive( @@NiveC ).niv9 ) / 100;
                 @@ptco += ( @@ptco * @@Nive( @@NiveC ).niv9 ) / 100;
              endif;
              r2xpra = r2xpri;
              r2ptca = r2ptco;

              r2xpri = @@xpri;
              r2ptco = @@ptco;
            else;
              r2xpra = r2xpri;
              r2ptca = r2ptco;
            endif;
              update c1wer2;

         endif;

         reade %kds ( k1yer2 : 8 ) c1wer2;

       enddo;

       return *On;

      /end-free

     P SVPDRC_updDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_updNoDesc(): Actualiza Tasa y Prima cuando no hay     *
      *                                                              *
      *     PeBase   (input)   Parámetros Base                       *
      *     PeNctw   (input)   Nro. de Cotización                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_updNoDesc...
     P                 B                   export
     D SVPDRC_updNoDesc...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

     D k1yer2          ds                  likerec( c1wer2 : *Key )

      /free

       SVPDRC_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = *blank;
       k1yer2.r2xcob = *zeros;
       setll %kds ( k1yer2 : 10 ) ctwer2;
       reade %kds ( k1yer2 : 10 ) ctwer2;

       dow ( not %eof ( ctwer2 ) );

         if ( r2xcob = peCobe );

            r2xpra = r2xpri;
            r2ptca = r2ptco;

            update c1wer2;

         endif;
        reade %kds ( k1yer2 : 10 ) ctwer2;
       enddo;

       return *On;

      /end-free

     P SVPDRC_updNoDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_getLcob(): Retorna lista de Coberturas                *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peLcob   (output)  Lista de Coberturas                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_getLcob...
     P                 B                   export
     D SVPDRC_getLcob...
     D                 pi            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peLcob                            likeds(descCo_t) dim(20)

     D k1yer2          ds                  likerec( c1wer2 : *Key )

     D x               s             10i 0

      /free

       SVPDRC_inz();

       x = *Zeros;

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = *blank;
       k1yer2.r2xcob = *zeros;
       setll %kds ( k1yer2 : 10 ) ctwer2;
       reade(n) %kds ( k1yer2 : 8 ) ctwer2;

       dow ( not %eof ( ctwer2 ) );

         if SVPDRV_chkCobList ( peLcob : r2xcob ) = *Zeros;

           x += 1;
           peLcob(x).xcob = r2xcob;

         endif;

         reade(n) %kds ( k1yer2 : 8 ) ctwer2;

       enddo;

       return x;

      /end-free

     P SVPDRC_getLcob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_chkCob(): Existe cobertrua en Er2                     *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de cotización                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant.polizas por rama                 *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_chkCob...
     P                 B                   export
     D SVPDRC_chkCob...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

     D k1yer2          ds                  likerec( c1wer2 : *Key )

      /free

       SVPDRC_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = *blank;
       k1yer2.r2xcob = *zeros;
       setll %kds ( k1yer2 : 10 ) ctwer2;
       reade(n) %kds ( k1yer2 : 8 ) ctwer2;

       dow ( not %eof ( ctwer2 ) );

         if ( r2xcob = peCobe );

           return *On;

         endif;

         reade(n) %kds ( k1yer2 : 8 ) ctwer2;

       enddo;

       return *Off;

      /end-free

     P SVPDRC_chkCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_updDescAnt(): Vuelve valores anteriores a CTWER2      *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura(Prima)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_updDescAnt...
     P                 B                   export
     D SVPDRC_updDescAnt...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

     D k1yer2          ds                  likerec( c1wer2 : *Key )

      /free

       SVPDRC_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = *blank;
       k1yer2.r2xcob = *zeros;
       setll %kds ( k1yer2 : 10 ) ctwer2;
       reade %kds ( k1yer2 : 10 ) ctwer2;

       dow ( not %eof ( ctwer2 ) );

         if ( r2xcob = peCobe );

            r2xpri = r2xpra;
            r2ptco = r2ptca;

            r2xpra = *Zeros;
            r2ptca = *Zeros;

            update c1wer2;

         endif;
         reade %kds ( k1yer2 : 10 ) ctwer2;

       enddo;

       return *Off;

      /end-free

     P SVPDRC_updDescAnt...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_chkDesc(): Cheque si se realizaron Descuentos         *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de Cotizacion                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura(Prima)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_chkDesc...
     P                 B                   export
     D SVPDRC_chkDesc...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

     D k1yer4          ds                  likerec( c1wer4 : *Key )

      /free

       SVPDRC_inz();

       k1yer4.r4empr = peBase.peEmpr;
       k1yer4.r4sucu = peBase.peSucu;
       k1yer4.r4nivt = peBase.peNivt;
       k1yer4.r4nivc = peBase.peNivc;
       k1yer4.r4nctw = peNctw;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4poco = pePoco;
       k1yer4.r4xcob = peCobe;
       k1yer4.r4nive = *Zeros;

       setll %kds ( k1yer4 : 9 ) ctwer4;

       return %equal ( ctwer4 );

      /end-free

     P SVPDRC_chkDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_chkImpactoDesc(): Chequea si se impactaron Descuentos *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     prCobe   (input)   Cobertura (Prima)                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRC_chkImpactoDesc...
     P                 B                   export
     D SVPDRC_chkImpactoDesc...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

     D k1yer2          ds                  likerec( c1wer2 : *Key )

      /free

       SVPDRC_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = *blank;
       k1yer2.r2xcob = *zeros;
       setll %kds ( k1yer2 : 10 ) ctwer2;
       reade(n) %kds ( k1yer2 : 8 ) ctwer2;

       dow not %eof ( ctwer2 );

         if ( r2xcob = peCobe );
            if ( r2xpra <> *Zeros ) and ( r2ptca <> *Zeros );
              return *On;
            endif;
         endif;

         reade(n) %kds ( k1yer2 : 8 ) ctwer2;

       enddo;

       return *Off;

      /end-free

     P SVPDRC_chkImpactoDesc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDRC_inz      B                   export
     D SVPDRC_inz      pi

      /free

       if not %open(ctwer2);
         open ctwer2;
       endif;

       if not %open(ctwer4);
         open ctwer4;
       endif;

       if not %open(ctwer6);
         open ctwer6;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPDRC_inz      E

      * ------------------------------------------------------------ *
      * SVPDRC_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDRC_End      B                   export
     D SVPDRC_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPDRC_End      E

      * ------------------------------------------------------------ *
      * SVPDRC_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPDRC_Error    B                   export
     D SVPDRC_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPDRC_Error    E

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
