     H option(*nodebugio:*srcstmt)
     H nomain
      * ************************************************************ *
      * CZWIMP: Cotización Standard                                  *
      *         Programa de Servicio - Cálculo de Impuestos          *
      *                                                              *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                          <*    *
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                       <*    *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                          <*    *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -            <*    *
      *>           DBGVIEW(&DV)                                <*    *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                            <*    *
      *>           MODULE(QTEMP/&N) -                          <*    *
      *>           EXPORT(*SRCFILE) -                          <*    *
      *>           SRCFILE(HDIILE/QSRVSRC) -                   <*    *
      *>           BNDSRVPGM(CZWUTL) -                         <*    *
      *> TEXT('Cotización Standard: Cálcula Impuestos')        <*    *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                          <*    *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *01-Oct-2013        *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/czwutl_h.rpgle'
      /copy './qcpybooks/czwimp_h.rpgle'

      * Establecer ultimo error
     D SetError        pr
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

     D initialized     s              1n
     D ErrorNumb       s             10i 0
     D ErrorText       s             80a

     D CZWIMP_calcIva  pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D CZWIMP_calcIvaPercep...
     D                 pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D CZWIMP_calcImpInternos...
     D                 pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D CZWIMP_calcServSociales...
     D                 pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D CZWIMP_calcTasaSsn...
     D                 pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D CZWIMP_calcPercepIiBb...
     D                 pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D CZWIMP_calcSellados...
     D                 pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWIMP_Inz      B                   export
     D CZWIMP_Inz      pi

      /free

       if initialized = *ON;
          return;
       endif;

       initialized = *ON;

      /end-free

     P CZWIMP_Inz      E

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWIMP_End      B                   export
     D CZWIMP_End      pi

      /free

       initialized = *OFF;

      /end-free

     P CZWIMP_End      E

      * ------------------------------------------------------------ *
      * Error():     Retorna último error                            *
      *                                                              *
      *       peErrn    (input)   Número del error                   *
      *                                                              *
      * retorna: Mensaje del último error                            *
      * ------------------------------------------------------------ *
     P CZWIMP_Error    B                   export
     D CZWIMP_Error    pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *NULL;
          peErrn = ErrorNumb;
       endif;

       return ErrorText;

      /end-free

     P CZWIMP_Error    E

      * ------------------------------------------------------------ *
      * calcImpuestos():  Cálcula impuestos                          *
      *                                                              *
      *  ATENCION: Este porcentaje es un valor ficticio calculado    *
      *            por la gente de impuestos, sobre Prima + Recargos *
      *            Si no llega ningún parámetro se asume que se trata*
      *            de una Persona Física y Consumidor Final.         *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de Impuestos                                *
      * ------------------------------------------------------------ *
     P CZWIMP_calcImpuestos...
     P                 B                   export
     D CZWIMP_calcImpuestos...
     D                 pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const options(*nopass:*omit)
     D   peTipp                       1a   const options(*nopass:*omit)
     D   peFech                       8  0 const options(*nopass:*omit)

     D @Civa           s              2  0
     D @Tipp           s              1a
     D @Fech           s              8  0
     D @iiva           s             15  2
     D @piva           s             15  2
     D @impi           s             15  2
     D @sers           s             15  2
     D @tssn           s             15  2
     D @piib           s             15  2
     D @sell           s             15  2
     D @tota           s             15  2

      /free

       CZWIMP_Inz();

       if %parms >= 4 and %addr(peciva) <> *null;
          @civa = peciva;
        else;
          @civa = 5;
       endif;

       if %parms >= 5 and %addr(petipp) <> *null;
          @tipp = petipp;
        else;
          @tipp = 'F';
       endif;

       if %parms >= 6 and %addr(pefech) <> *null;
          @fech = pefech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       // --------------------------------
       // IVA
       // --------------------------------
       @iiva = CZWIMP_calcIva( pePrim: peReca: peRpro: @Civa: @Tipp: @fech);

       // --------------------------------
       // Percepcion de IVA
       // --------------------------------
       @piva = CZWIMP_calcIvaPercep( pePrim
                                   : peReca
                                   : peRpro
                                   : @Civa
                                   : @Tipp
                                   : @fech );

       // --------------------------------
       // Impuestos Internos
       // --------------------------------
       @impi = CZWIMP_calcImpInternos( pePrim
                                     : peReca
                                     : peRpro
                                     : @Civa
                                     : @Tipp
                                     : @fech );

       // --------------------------------
       // Servicios Sociales
       // --------------------------------
       @sers = CZWIMP_calcServSociales( pePrim
                                      : peReca
                                      : peRpro
                                      : @Civa
                                      : @Tipp
                                      : @fech );

       // --------------------------------
       // Tasa de SSN
       // --------------------------------
       @tssn = CZWIMP_calcTasaSsn( pePrim
                                 : peReca
                                 : peRpro
                                 : @Civa
                                 : @Tipp
                                 : @fech );

       // --------------------------------
       // Percepción de II BB
       // --------------------------------
       @piib = CZWIMP_calcPercepIiBb( pePrim
                                    : peReca
                                    : peRpro
                                    : @Civa
                                    : @Tipp
                                    : @fech );

       // --------------------------------
       // Sellados
       // --------------------------------
       @sell = CZWIMP_calcSellados( pePrim
                                  : peReca
                                  : peRpro
                                  : @Civa
                                  : @Tipp
                                  : @fech );

       @tota = @iiva + @piva + @impi + @sers + @tssn + @piib + @sell;
       return @tota;

      /end-free

     P CZWIMP_calcImpuestos...
     P                 E

      * ------------------------------------------------------------ *
      * calcIva():        Cálcula IVA                                *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de IVA                                      *
      * ------------------------------------------------------------ *
     P CZWIMP_calcIva  B
     D CZWIMP_calcIva  pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D @subt           s             15  2
     D @tota           s             15  2

      /free

       @subt = pePrim + peReca;
       @tota = (@subt * 21) / 100;
       return @tota;

      /end-free

     P CZWIMP_calcIva  E

      * ------------------------------------------------------------ *
      * calcIvaPercep():  Cálcula Percepción de IVA                  *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de IVA                                      *
      * ------------------------------------------------------------ *
     P CZWIMP_calcIvaPercep...
     P                 B
     D CZWIMP_calcIvaPercep...
     D                 pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D @subt           s             15  2
     D @tota           s             15  2
     D MINIMO          c                   21,30

      /free

       if (peCiva <> 1);
          return 0;
       endif;

       @subt = pePrim + PeReca;
       @tota = (@subt * 3) / 100;

       if @tota < MINIMO;
          return MINIMO;
        else;
          return @tota;
       endif;

      /end-free

     P CZWIMP_calcIvaPercep...
     P                 E

      * ------------------------------------------------------------ *
      * calcImpInternos(): Cálcula Impuestos Internos                *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de IVA                                      *
      * ------------------------------------------------------------ *
     P CZWIMP_calcImpInternos...
     P                 B
     D CZWIMP_calcImpInternos...
     D                 pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D @subt           s             15  2
     D @tota           s             15  2

      /free

       @subt = pePrim + PeReca;
       @tota = (@subt * 0,10) / 100;

       return @tota;

      /end-free

     P CZWIMP_calcImpInternos...
     P                 E

      * ------------------------------------------------------------ *
      * calcServSociales(): Cálculo Servicios Sociales               *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de IVA                                      *
      * ------------------------------------------------------------ *
     P CZWIMP_calcServSociales...
     P                 B
     D CZWIMP_calcServSociales...
     D                 pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D @subt           s             15  2
     D @tota           s             15  2

      /free

       @subt = pePrim + PeReca;
       @tota = (@subt * 0,50) / 100;

       return @tota;

      /end-free

     P CZWIMP_calcServSociales...
     P                 E

      * ------------------------------------------------------------ *
      * calcTasaSsn():   Cálculo Tasa de SSN                         *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de IVA                                      *
      * ------------------------------------------------------------ *
     P CZWIMP_calcTasaSsn...
     P                 B
     D CZWIMP_calcTasaSsn...
     D                 pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D @subt           s             15  2
     D @tota           s             15  2

      /free

       @subt = pePrim + PeReca;
       @tota = (@subt * 0,60) / 100;

       return @tota;

      /end-free

     P CZWIMP_calcTasaSsn...
     P                 E

      * ------------------------------------------------------------ *
      * calcPercepIiBb(): Cálculo Percepción IIBB                    *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de IVA                                      *
      * ------------------------------------------------------------ *
     P CZWIMP_calcPercepIiBb...
     P                 B
     D CZWIMP_calcPercepIiBb...
     D                 pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D @subt           s             15  2
     D @tota           s             15  2

      /free

       if peciva <> 1 and peciva <> 6 and peciva <> 7;
          return 0;
       endif;

       @subt = pePrim + PeReca;

       select;
        when peRpro = 1 or peRpro = 2;
             select;
               when peciva = 1;
                    @tota = (@subt * 6) / 100;
                    return @tota;
               when peciva = 6;
                    @tota = (@subt * 7,26) / 100;
                    return @tota;
               when peciva = 7;
                    @tota = (@subt * 8,02) / 100;
                    return @tota;
               other;
                    return 0;
             endsl;
        when peRpro = 3;
             return 0;
        when peRpro = 4;
             return 0;
        when peRpro = 5;
             select;
               when peciva = 1;
                    @tota = (@subt * 1,5) / 100;
                    return @tota;
               when peciva = 6;
                    @tota = (@subt * 1,82) / 100;
                    return @tota;
               when peciva = 7;
                    @tota = (@subt * 1,82) / 100;
                    return @tota;
               other;
                    return 0;
             endsl;
        when peRpro = 6;
             return 0;
        when peRpro = 7;
             return 0;
        when peRpro = 8;
             return 0;
        when peRpro = 9;
             return 0;
        when peRpro = 10;
             return 0;
        when peRpro = 11;
             select;
               when peciva = 1;
                    @tota = (@subt * 3,6) / 100;
                    return @tota;
               when peciva = 6;
                    @tota = (@subt * 4,36) / 100;
                    return @tota;
               when peciva = 7;
                    @tota = (@subt * 4,81) / 100;
                    return @tota;
               other;
                    return 0;
             endsl;
        when peRpro = 12;
             select;
               when peciva = 1;
                    @tota = (@subt * 2) / 100;
                    return @tota;
               when peciva = 6;
                    @tota = (@subt * 2,42) / 100;
                    return @tota;
               when peciva = 7;
                    @tota = (@subt * 2,67) / 100;
                    return @tota;
               other;
                    return 0;
             endsl;
        when peRpro = 13;
             return 0;
        when peRpro = 14;
             return 0;
        when peRpro = 15;
             return 0;
        when peRpro = 16;
             return 0;
        when peRpro = 17;
             return 0;
        when peRpro = 18;
             return 0;
        when peRpro = 19;
             return 0;
        when peRpro = 20;
             select;
               when peciva = 1;
                    @tota = (@subt * 3) / 100;
                    return @tota;
               when peciva = 6;
                    @tota = (@subt * 2,42) / 100;
                    return @tota;
               when peciva = 7;
                    @tota = (@subt * 2,67) / 100;
                    return @tota;
               other;
                    return 0;
             endsl;
        when peRpro = 21;
             return 0;
        when peRpro = 22;
             return 0;
        when peRpro = 23;
             return 0;
        when peRpro = 24;
             return 0;
        other;
             return 0;
       endsl;

       return 0;

      /end-free

     P CZWIMP_calcPercepIiBb...
     P                 E

      * ------------------------------------------------------------ *
      * calcSellados():  Cálculo Sellados                            *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de Sellados                                 *
      * ------------------------------------------------------------ *
     P CZWIMP_calcSellados...
     P                 B
     D CZWIMP_calcSellados...
     D                 pi            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const
     D   peTipp                       1a   const
     D   peFech                       8  0 const

     D @subt           s             15  2
     D @tota           s             15  2

      /free

       @subt = pePrim + PeReca;

       select;
        when peRpro = 1 or peRpro = 2;
             @tota = (@subt * 1.2) / 100;
             return @tota;
        when peRpro = 3;
             @tota = (@subt * 0.2) / 100;
             if @tota < 4;
                return 4;
              else;
                return @tota;
             endif;
        when peRpro = 4;
             @tota = (@subt * 1) / 100;
             return @tota;
        when peRpro = 5;
             @tota = (@subt * 1.5) / 100;
             return @tota;
        when peRpro = 6;
             @tota = (@subt * 1) / 100;
             return @tota;
        when peRpro = 7;
             @tota = (@subt * 1.2) / 100;
             if @tota < 5;
                return 5;
              else;
                return @tota;
             endif;
        when peRpro = 8;
             return 0;
        when peRpro = 9;
             @tota = (@subt * 1.5) / 100;
             return @tota;
        when peRpro = 10;
             @tota = (@subt * 1.2) / 100;
             if @tota < 1;
                return 1;
              else;
                return @tota;
             endif;
        when peRpro = 11;
             @tota = (@subt * 2.1) / 100;
             if @tota < 3.5;
                return 3.5;
              else;
                return @tota;
             endif;
        when peRpro = 12;
             @tota = (@subt * 0.5) / 100;
             if @tota < 7;
                return 7;
              else;
                return @tota;
             endif;
        when peRpro = 13;
             @tota = (@subt * 1.4) / 100;
             return @tota;
        when peRpro = 14;
             @tota = (@subt * 1) / 100;
             return @tota;
        when peRpro = 15;
             @tota = (@subt * 2) / 100;
             return @tota;
        when peRpro = 16;
             @tota = (@subt * 1) / 100;
             return @tota;
        when peRpro = 17;
             @tota = (@subt * 1) / 100;
             return @tota;
        when peRpro = 18;
             @tota = (@subt * 0.5) / 100;
             return @tota;
        when peRpro = 19;
             @tota = (@subt * 1.5) / 100;
             if @tota < 4.5;
                return 4.5;
              else;
                return @tota;
             endif;
        when peRpro = 20;
             if peTipp = 'J';
                @tota = (@subt * 0.8) / 100;
              else;
                @tota = 0;
             endif;
             return @tota;
        when peRpro = 21;
             @tota = (@subt * 1.5) / 100;
             return @tota;
        when peRpro = 22;
             return 0;
        when peRpro = 23;
             @tota = (@subt * 1) / 100;
             return @tota;
        when peRpro = 24;
             return 0;
        other;
             return 0;
       endsl;

      /end-free

     P CZWIMP_calcSellados...
     P                 E


      * ------------------------------------------------------------ *
      * SetError():  Establece último error del módulo               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

      /free

         ErrorNumb = peErrn;
         ErrorText = peErrm;

      /end-free

     P SetError        E

