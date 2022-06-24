     H option(*nodebugio:*srcstmt)
     H nomain
      * ************************************************************ *
      * CZWPRI: Cotización Standard                                  *
      *         Programa de Servicio - Cálculo de Primas             *
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
      *> TEXT('Cotización Standard: Cálculo de Prima')         <*    *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                          <*    *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *01-Oct-2013        *
      * ------------------------------------------------------------ *
      * SGF 06/12/13: Agrego Pick Up A, Zona 3, Cobertura C+.        *
      * SGF 09/01/20: Agrego Tarifa y Marca de Tarifa diferencial a  *
      *               PAR313G.                                       *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/czwpri_h.rpgle'
      /copy './qcpybooks/czwutl_h.rpgle'

      * Establecer ultimo error
     D SetError        pr
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

     D PAR313G         pr                  extpgm('PAR313G')
     D  peCobl                        2a   const
     D  peVhvu                       15  2
     D  peVh0k                       15  2 const
     D  peVacc                       15  2 const
     D  peClaj                        3  0 const
     D  peRebr                        1  0 const
     D  peCfas                        1a   const
     D  peTarc                        2  0
     D  peTair                        2  0
     D  peScta                        1  0
     D  peVhca                        2  0
     D  peVhv1                        1  0
     D  peVhv2                        1  0
     D  peVhaÑ                        4  0
     D  peVhni                        1a
     D  peVhct                        2  0
     D  peVhuv                        2  0 const
     D  peMone                        2a   const
     D  peNcoc                        5  0 const
     D  peMar1                        1a   const
     D  peMar2                        1a   const
     D  peAlld                        5  2
     D  peVm0k                        1a
     D  peFIVD                        8  0 const
     D  pePrrc                       15  2
     D  pePrac                       15  2
     D  pePrin                       15  2
     D  pePrro                       15  2
     D  pePacc                       15  2
     D  pePraa                       15  2
     D  pePrsf                       15  2
     D  pePrce                       15  2
     D  pePrap                       15  2
     D  peRcle                       15  2
     D  peRcco                       15  2
     D  peRcac                       15  2
     D  peLrce                       15  2
     D  peSaap                       15  2
     D  peSumd                        5  2
     D  peCtre                        5  0 const
     D  peMtdf                        1a   const

     D SPCPLUS         pr                  extpgm('SPCPLUS')
     D  peVhca                        2  0
     D  peScta                        1  0
     D  peVhuv                        2  0 const
     D  peMtdf                        1a
     D  peOk                          1n
     D  peCtre                        5  0

     D SPTRCAIR        pr                  extpgm('SPTRCAIR')
     D   peCtre                       5  0
     D   peScta                       1  0
     D   peMone                       2a   const
     D   peVhca                       2  0
     D   peVhv1                       1  0
     D   peVhv2                       1  0
     D   peTarc                       2  0
     D   peTair                       2  0
     D   peFemi                       8  0
     D   peMtdf                       1a   options(*nopass)

     D initialized     s              1n
     D ErrorNumb       s             10i 0
     D ErrorText       s             80a

     D                uds
     D usempr                401    401
     D ussucu                402    403

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWPRI_Inz      B                   export
     D CZWPRI_Inz      pi

      /free

       if (initialized = *ON);
          return;
       endif;

       Initialized = *ON;

      /end-free

     P CZWPRI_Inz      E

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWPRI_End      B                   export
     D CZWPRI_End      pi

      /free

       Initialized = *OFF;

       /end-free

     P CZWPRI_End      E

      * ------------------------------------------------------------ *
      * Error():    Retorna último error del módulo                  *
      *                                                              *
      *         peErrn    (output)    Código de Error                *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     P CZWPRI_Error    B                   export
     D CZWPRI_Error    pi            80a
     D   peErrn                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *NULL;
          peErrn = ErrorNumb;
       endif;

       return ErrorText;

      /end-free

     P CZWPRI_Error    E

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

      * ------------------------------------------------------------ *
      * calCobA():   Calcula cobertura A                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *     pePrim    (output)   Importe de Prima                    *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     P CZWPRI_calCobA  B                   export
     D CZWPRI_calCobA  pi            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

     D peAlld          s              5  2
     D peSumd          s              5  2
     D pePrrc          s             15  2
     D pePrac          s             15  2
     D pePrin          s             15  2
     D pePrro          s             15  2
     D pePacc          s             15  2
     D pePraa          s             15  2
     D pePrsf          s             15  2
     D pePrce          s             15  2
     D pePrap          s             15  2
     D peRcle          s             15  2
     D peRcco          s             15  2
     D peRcac          s             15  2
     D peLrce          s             15  2
     D peSaap          s             15  2
     D peVhvu          s             15  2
     D peTarc          s              2  0
     D peTair          s              2  0
     D peScta          s              1  0
     D peVhca          s              2  0
     D peVhv1          s              1  0
     D peVhv2          s              1  0
     D peVhaÑ          s              4  0
     D peVhct          s              2  0
     D peFemi          s              8  0
     D primaMinima     s             15  2
     D @prim           s             15  2
     D @coci           s              2  0
     D peRama          s              2  0
     D peArcd          s              6  0
     D peArse          s              2  0
     D peCtre          s              5  0
     D rc              s             10i 0
     D @anti           s             10i 0

      /free

       CZWPRI_Inz();

       // -------------------------------
       // Desarmar la DS
       // -------------------------------
       peVhvu = peCot.vhvu;
       peScta = peCot.scta;
       peVhca = peCot.vhca;
       peVhv1 = peCot.vhv1;
       peVhv2 = peCot.vhv2;
       peVhaÑ = peCot.vhan;
       peVhct = peCot.vhct;
       peArcd = peCot.arcd;
       peRama = peCot.rama;

       // -------------------------------
       // Antigüedad: 15 años
       // -------------------------------
       @anti = *year - peVhaÑ;
       if (@anti < 0);
          return -1;
       endif;

       if (@anti > 15);
          return -1;
       endif;

       // -------------------------------
       // Buscar tarifa vigente
       // -------------------------------
       rc = CZWUTL_getTarifa( peCtre: *OMIT);
       if (rc = -1);
          peErrm = CZWUTL_Error(peErrn);
          SetError( peErrn: peErrm );
          return -1;
       endif;

       // -------------------------------
       // Fecha de Emisión
       // -------------------------------
       peFemi = CZWUTL_getFemi();

       // -------------------------------
       // Buscar Tablas de AIR/RC
       // -------------------------------
       SPTRCAIR( peCtre
               : peScta
               : '01'
               : peVhca
               : peVhv1
               : peVhv2
               : peTarc
               : peTair
               : peFemi
               : peCot.mtdf );
       if (peTarc <= 0 or peTair <= 0);
          peErrn = 10010;
          peErrm = 'No se han encontrado tablas para tarifar';
          SetError( peErrn: peErrm );
          return -1;
       endif;

       // -----------------------------
       // Tipo de vehículo válido
       // -----------------------------
       if (peCot.vhca > 5);
          return -1;
       endif;

       // Zona (Cob A válida en todas)

       // -----------------------------
       // Si es auto o 4x4, sumar 17%
       // -----------------------------
       if peCot.vhca = 1 or (peCot.vhca = 4 and peCot.mtdf <> ' ');
          peAlld = -17;
       endif;

       PAR313G( 'A'
              : peVhvu
              : *zeros
              : *zeros
              : *zeros
              : *zero
              : ' '
              : peTarc
              : peTair
              : peScta
              : peVhca
              : peVhv1
              : peVhv2
              : peVhaÑ
              : peCot.vhni
              : peVhct
              : 1
              : '01'
              : 99
              : '0'
              : '0'
              : peAlld
              : peCot.vh0k
              : *zeros
              : pePrrc
              : pePrac
              : pePrin
              : pePrro
              : pePacc
              : pePraa
              : pePrsf
              : pePrce
              : pePrap
              : peRcle
              : peRcco
              : peRcac
              : peLrce
              : peSaap
              : peSumd
              : peCtre
              : peCot.mtdf );

       @prim = pePrrc
             + pePrce
             + pePrap;

       if (peCot.dupe <> 0);
          @coci = 12/peCot.dupe;
        else;
          @coci = 1;
       endif;

       pePrim = @prim/@coci;
       primaMinima = CZWPRI_getPrimaMinima(*omit);

       if (pePrim < primaMinima);
          pePrim = primaMinima;
       endif;

       return 0;

      /end-free

     P CZWPRI_calCobA  E

      * ------------------------------------------------------------ *
      * calCobB():   Calcula cobertura B                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     P CZWPRI_calCobB  B                   export
     D CZWPRI_calCobB  pi            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

     D peAlld          s              5  2
     D peSumd          s              5  2
     D pePrrc          s             15  2
     D pePrac          s             15  2
     D pePrin          s             15  2
     D pePrro          s             15  2
     D pePacc          s             15  2
     D pePraa          s             15  2
     D pePrsf          s             15  2
     D pePrce          s             15  2
     D pePrap          s             15  2
     D peRcle          s             15  2
     D peRcco          s             15  2
     D peRcac          s             15  2
     D peLrce          s             15  2
     D peSaap          s             15  2
     D peVhvu          s             15  2
     D peTarc          s              2  0
     D peTair          s              2  0
     D peScta          s              1  0
     D peVhca          s              2  0
     D peVhv1          s              1  0
     D peVhv2          s              1  0
     D peVhaÑ          s              4  0
     D peVhct          s              2  0
     D peFemi          s              8  0
     D primaMinima     s             15  2
     D @prim           s             15  2
     D @coci           s              2  0
     D peArcd          s              6  0
     D peArse          s              2  0
     D peRama          s              2  0
     D peCtre          s              5  0
     D rc              s             10i 0
     D @anti           s             10i 0

      /free

       CZWPRI_Inz();

       // -----------------------------
       // Desarmar la DS
       // -----------------------------
       peVhvu = peCot.vhvu;
       peScta = peCot.scta;
       peVhca = peCot.vhca;
       peVhv1 = peCot.vhv1;
       peVhv2 = peCot.vhv2;
       peVhaÑ = peCot.vhan;
       peVhct = peCot.vhct;
       peArcd = peCot.arcd;
       peRama = peCot.rama;

       // -------------------------------
       // Antigüedad: 15 años
       // -------------------------------
       @anti = *year - peVhaÑ;
       if (@anti < 0);
          return -1;
       endif;

       if (@anti > 15);
          return -1;
       endif;

       // -------------------------------
       // Buscar tarifa vigente
       // -------------------------------
       rc = CZWUTL_getTarifa( peCtre: *OMIT );
       if (rc = -1);
          peErrm = CZWUTL_Error(peErrn);
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -------------------------------
       // Fecha de Emisión
       // -------------------------------
       peFemi = CZWUTL_getFemi();

       // -------------------------------
       // Buscar Tablas de AIR/RC
       // -------------------------------
       SPTRCAIR( peCtre
               : peScta
               : '01'
               : peVhca
               : peVhv1
               : peVhv2
               : peTarc
               : peTair
               : peFemi
               : peCot.mtdf );
       if (peTarc <= 0 or peTair <= 0);
          peErrn = 10010;
          peErrm = 'No se han encontrado tablas para tarifar';
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -----------------------------
       // Tipo de vehículo válido
       // -----------------------------
       if (peCot.vhca > 5);
          return -1;
       endif;

       // -----------------------------
       // Cob B no se comercializa en
       // zonas 0, 1 y 2
       // -----------------------------
       if (peCot.scta = 1 or peCot.scta = 2 or peCot.scta = 6
           or peCot.scta = 5 or peCot.scta = 9);
          return -1;
       endif;

       // -----------------------------
       // Suma asegurada minima
       // -----------------------------
       if (peCot.vhvu < CZWUTL_getSumaMinima());
          if (peCot.scta = 1 or peCot.scta = 2 or peCot.scta = 6
              or peCot.scta = 5 or peCot.scta = 9);
             return -1;
          endif;
       endif;

       // -----------------------------
       // Veo Marca/Modelo
       // -----------------------------
       peAlld = CZWUTL_getDescMarcaModelo( peCot.vhmc
                                         : peCot.vhmo
                                         : peCot.vhcs );
       PAR313G( 'B'
              : peVhvu
              : *zeros
              : *zeros
              : *zeros
              : *zero
              : ' '
              : peTarc
              : peTair
              : peScta
              : peVhca
              : peVhv1
              : peVhv2
              : peVhaÑ
              : peCot.vhni
              : peVhct
              : 1
              : '01'
              : 99
              : '0'
              : '0'
              : peAlld
              : peCot.vh0k
              : *zeros
              : pePrrc
              : pePrac
              : pePrin
              : pePrro
              : pePacc
              : pePraa
              : pePrsf
              : pePrce
              : pePrap
              : peRcle
              : peRcco
              : peRcac
              : peLrce
              : peSaap
              : peSumd
              : peCtre
              : peCot.mtdf );

       @prim = pePrrc
             + pePrac
             + pePrin
             + pePrro
             + pePacc
             + pePraa
             + pePrsf
             + pePrce
             + pePrap
             + peRcle
             + peRcco;

       if (peCot.dupe <> 0);
          @coci = 12/peCot.dupe;
        else;
          @coci = 1;
       endif;

       pePrim = @prim/@coci;
       primaMinima = CZWPRI_getPrimaMinima(*omit);

       if (pePrim < primaMinima);
          pePrim = primaMinima;
       endif;

       return 0;

      /end-free

     P CZWPRI_calCobB  E

      * ------------------------------------------------------------ *
      * calCobC():   Calcula cobertura C                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     P CZWPRI_calCobC  B                   export
     D CZWPRI_calCobC  pi            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

     D peAlld          s              5  2
     D peSumd          s              5  2
     D pePrrc          s             15  2
     D pePrac          s             15  2
     D pePrin          s             15  2
     D pePrro          s             15  2
     D pePacc          s             15  2
     D pePraa          s             15  2
     D pePrsf          s             15  2
     D pePrce          s             15  2
     D pePrap          s             15  2
     D peRcle          s             15  2
     D peRcco          s             15  2
     D peRcac          s             15  2
     D peLrce          s             15  2
     D peSaap          s             15  2
     D peVhvu          s             15  2
     D peTarc          s              2  0
     D peTair          s              2  0
     D peScta          s              1  0
     D peVhca          s              2  0
     D peVhv1          s              1  0
     D peVhv2          s              1  0
     D peVhaÑ          s              4  0
     D peVhct          s              2  0
     D peFemi          s              8  0
     D primaMinima     s             15  2
     D @prim           s             15  2
     D @coci           s              2  0
     D peArcd          s              6  0
     D peRama          s              2  0
     D peArse          s              2  0
     D peCtre          s              5  0
     D rc              s             10i 0
     D @anti           s             10i 0

      /free

       CZWPRI_Inz();

       // -----------------------------
       // Desarmar la DS
       // -----------------------------
       peVhvu = peCot.vhvu;
       peScta = peCot.scta;
       peVhca = peCot.vhca;
       peVhv1 = peCot.vhv1;
       peVhv2 = peCot.vhv2;
       peVhaÑ = peCot.vhan;
       peVhct = peCot.vhct;
       peArcd = peCot.arcd;
       peRama = peCot.rama;

       // -------------------------------
       // Antigüedad: 12 años
       // -------------------------------
       @anti = *year - peVhaÑ;
       if (@anti < 0);
          return -1;
       endif;

       if (@anti > 12);
          return -1;
       endif;

       // -------------------------------
       // Buscar tarifa vigente
       // -------------------------------
       rc = CZWUTL_getTarifa( peCtre: *OMIT );
       if (rc = -1);
          peErrm = CZWUTL_Error(peErrn);
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -------------------------------
       // Fecha de Emisión
       // -------------------------------
       peFemi = CZWUTL_getFemi();

       // -------------------------------
       // Buscar Tablas de AIR/RC
       // -------------------------------
       SPTRCAIR( peCtre
               : peScta
               : '01'
               : peVhca
               : peVhv1
               : peVhv2
               : peTarc
               : peTair
               : peFemi
               : peCot.mtdf );
       if (peTarc <= 0 or peTair <= 0);
          peErrn = 10010;
          peErrm = 'No se han encontrado tablas para tarifar';
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -----------------------------
       // Tipo de vehículo válido
       // -----------------------------
       if (peCot.vhca > 5);
          return -1;
       endif;

       // -----------------------------
       // Suma asegurada minima
       // -----------------------------
       if (peCot.vhvu < CZWUTL_getSumaMinima());
          if (peCot.scta = 1 or peCot.scta = 2 or peCot.scta = 6);
             return -1;
          endif;
       endif;

       // -----------------------------
       // Veo Marca/Modelo
       // -----------------------------
       peAlld = CZWUTL_getDescMarcaModelo( peCot.vhmc
                                         : peCot.vhmo
                                         : peCot.vhcs );
       peVhvu = peCot.vhvu;
       peScta = peCot.scta;
       peVhca = peCot.vhca;
       peVhv1 = peCot.vhv1;
       peVhv2 = peCot.vhv2;
       peVhaÑ = peCot.vhan;
       peVhct = peCot.vhct;
       PAR313G( 'C'
              : peVhvu
              : *zeros
              : *zeros
              : *zeros
              : *zero
              : ' '
              : peTarc
              : peTair
              : peScta
              : peVhca
              : peVhv1
              : peVhv2
              : peVhaÑ
              : peCot.vhni
              : peVhct
              : 1
              : '01'
              : 99
              : '0'
              : '0'
              : peAlld
              : peCot.vh0k
              : *zeros
              : pePrrc
              : pePrac
              : pePrin
              : pePrro
              : pePacc
              : pePraa
              : pePrsf
              : pePrce
              : pePrap
              : peRcle
              : peRcco
              : peRcac
              : peLrce
              : peSaap
              : peSumd
              : peCtre
              : peCot.mtdf );

       @prim = pePrrc
             + pePrac
             + pePrin
             + pePrro
             + pePacc
             + pePraa
             + pePrsf
             + pePrce
             + pePrap
             + peRcle
             + peRcco;

       if (peCot.dupe <> 0);
          @coci = 12/peCot.dupe;
        else;
          @coci = 1;
       endif;

       pePrim = @prim/@coci;
       primaMinima = CZWPRI_getPrimaMinima(*omit);

       if (pePrim < primaMinima);
          pePrim = primaMinima;
       endif;

       return 0;

      /end-free

     P CZWPRI_calCobC  E

      * ------------------------------------------------------------ *
      * calCobC1():  Calcula cobertura C+                            *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     P CZWPRI_calCobC1...
     P                 B                   export
     D CZWPRI_calCobC1...
     D                 pi            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

     D peAlld          s              5  2
     D peSumd          s              5  2
     D pePrrc          s             15  2
     D pePrac          s             15  2
     D pePrin          s             15  2
     D pePrro          s             15  2
     D pePacc          s             15  2
     D pePraa          s             15  2
     D pePrsf          s             15  2
     D pePrce          s             15  2
     D pePrap          s             15  2
     D peRcle          s             15  2
     D peRcco          s             15  2
     D peRcac          s             15  2
     D peLrce          s             15  2
     D peSaap          s             15  2
     D peVhvu          s             15  2
     D peTarc          s              2  0
     D peTair          s              2  0
     D peScta          s              1  0
     D peVhca          s              2  0
     D peVhv1          s              1  0
     D peVhv2          s              1  0
     D peVhaÑ          s              4  0
     D peVhct          s              2  0
     D peFemi          s              8  0
     D peOk            s              1n
     D primaMinima     s             15  2
     D @prim           s             15  2
     D @coci           s              2  0
     D peArcd          s              6  0
     D peArse          s              2  0
     D peRama          s              2  0
     D peCtre          s              5  0
     D rc              s             10i 0
     D @anti           s             10i 0

      /free

       CZWPRI_Inz();

       // -----------------------------
       // Desarmar la DS
       // -----------------------------
       peVhvu = peCot.vhvu;
       peScta = peCot.scta;
       peVhca = peCot.vhca;
       peVhv1 = peCot.vhv1;
       peVhv2 = peCot.vhv2;
       peVhaÑ = peCot.vhan;
       peVhct = peCot.vhct;
       peArcd = peCot.arcd;
       peRama = peCot.rama;

       // -------------------------------
       // Antigüedad: 10 años
       // -------------------------------
       @anti = *year - peVhaÑ;
       if (@anti < 0);
          return -1;
       endif;

       if (@anti > 10);
          return -1;
       endif;

       // -------------------------------
       // Buscar tarifa vigente
       // -------------------------------
       rc = CZWUTL_getTarifa( peCtre : *OMIT );
       if (rc = -1);
          peErrm = CZWUTL_Error(peErrn);
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -------------------------------
       // Fecha de Emisión
       // -------------------------------
       peFemi = CZWUTL_getFemi();

       // -------------------------------
       // Buscar Tablas de AIR/RC
       // -------------------------------
       SPTRCAIR( peCtre
               : peScta
               : '01'
               : peVhca
               : peVhv1
               : peVhv2
               : peTarc
               : peTair
               : peFemi
               : peCot.mtdf );
       if (peTarc <= 0 or peTair <= 0);
          peErrn = 10010;
          peErrm = 'No se han encontrado tablas para tarifar';
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -----------------------------
       // Pick Up B en ninguna Zona
       // -----------------------------
       if (peCot.vhca > 4);
          return -1;
       endif;

       // -----------------------------
       // Pick Up A sólo 0 y 1
       // -----------------------------
       if (peCot.vhca = 4 and peCot.mtdf = ' ');
          select;
           when peCtre >= 109;
                if (peCot.scta <> 6 and peCot.scta <> 1 and
                    peCot.scta <> 3);
                    return -1;
                endif;
           other;
                if (peCot.scta <> 6 and peCot.scta <> 1);
                    return -1;
                endif;
          endsl;
       endif;

       // -----------------------------
       // Suma asegurada minima
       // -----------------------------
       if (peCot.vhvu < CZWUTL_getSumaMinima());
          if (peCot.scta = 1 or peCot.scta = 2 or peCot.scta = 6);
             return -1;
          endif;
       endif;

       // -----------------------------
       // Aplica para C+?
       // -----------------------------
       SPCPLUS( peVhca
              : peScta
              : 1
              : peCot.mtdf
              : peOk
              : peCtre );
       if (peOk = *OFF);
          return -1;
       endif;

       // -----------------------------
       // Veo Marca/Modelo
       // -----------------------------
       peAlld = CZWUTL_getDescMarcaModelo( peCot.vhmc
                                         : peCot.vhmo
                                         : peCot.vhcs );

       // --------------------------------
       // Determina Alta Gama
       // --------------------------------
       if ( CZWUTL_esAltaGama(peVhvu) );
          // ------------------------------------
          // Auto o 4x4 tiene 10% de descuento
          // ------------------------------------
          if (peVhca = 1 or (peVhca = 4 and peCot.Mtdf <> ' ') );
              peAlld += CZWUTL_getPorcAltaGama( usempr
                                              : ussucu
                                              : peArcd
                                              : peRama   );
          endif;
       endif;

       // --------------------------------
       // Plan Promo 0 KM
       // --------------------------------
       if (peCot.vh0k = 'S');
          peAlld += CZWUTL_getPorcPromo0Km( usempr
                                          : ussucu
                                          : peArcd
                                          : peRama   );
       endif;

       PAR313G( 'C1'
              : peVhvu
              : *zeros
              : *zeros
              : *zeros
              : *zero
              : ' '
              : peTarc
              : peTair
              : peScta
              : peVhca
              : peVhv1
              : peVhv2
              : peVhaÑ
              : peCot.vhni
              : peVhct
              : 1
              : '01'
              : 99
              : '0'
              : '0'
              : peAlld
              : peCot.vh0k
              : *zeros
              : pePrrc
              : pePrac
              : pePrin
              : pePrro
              : pePacc
              : pePraa
              : pePrsf
              : pePrce
              : pePrap
              : peRcle
              : peRcco
              : peRcac
              : peLrce
              : peSaap
              : peSumd
              : peCtre
              : peCot.mtdf );

       @prim = pePrrc
             + pePrac
             + pePrin
             + pePrro
             + pePacc
             + pePraa
             + pePrsf
             + pePrce
             + pePrap
             + peRcle
             + peRcco;

       if (peCot.dupe <> 0);
          @coci = 12/peCot.dupe;
        else;
          @coci = 1;
       endif;

       pePrim = @prim/@coci;
       primaMinima = CZWPRI_getPrimaMinima(*omit);

       if (pePrim < primaMinima);
          pePrim = primaMinima;
       endif;

       return 0;

      /end-free

     P CZWPRI_calCobC1...
     P                 E

      * ------------------------------------------------------------ *
      * calCobD():   Calcula cobertura D                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     P CZWPRI_calCobD  B                   export
     D CZWPRI_calCobD  pi            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

     D peAlld          s              5  2
     D peSumd          s              5  2
     D pePrrc          s             15  2
     D pePrac          s             15  2
     D pePrin          s             15  2
     D pePrro          s             15  2
     D pePacc          s             15  2
     D pePraa          s             15  2
     D pePrsf          s             15  2
     D pePrce          s             15  2
     D pePrap          s             15  2
     D peRcle          s             15  2
     D peRcco          s             15  2
     D peRcac          s             15  2
     D peLrce          s             15  2
     D peSaap          s             15  2
     D peVhvu          s             15  2
     D peTarc          s              2  0
     D peTair          s              2  0
     D peScta          s              1  0
     D peVhca          s              2  0
     D peVhv1          s              1  0
     D peVhv2          s              1  0
     D peVhaÑ          s              4  0
     D peVhct          s              2  0
     D peCobl          s              2a
     D peFemi          s              8  0
     D primaMinima     s              8  0
     D @prim           s             15  2
     D @coci           s              2  0
     D peArcd          s              6  0
     D peRama          s              2  0
     D peArse          s              2  0
     D peCtre          s              5  0
     D rc              s             10i 0
     D @anti           s             10i 0

      /free

       CZWPRI_Inz();

       // -----------------------------
       // Desarmar la DS
       // -----------------------------
       peVhvu = peCot.vhvu;
       peScta = peCot.scta;
       peVhca = peCot.vhca;
       peVhv1 = peCot.vhv1;
       peVhv2 = peCot.vhv2;
       peVhaÑ = peCot.vhan;
       peVhct = peCot.vhct;
       peArcd = peCot.arcd;
       peRama = peCot.rama;

       // -------------------------------
       // Antigüedad: 5 años
       // -------------------------------
       @anti = *year - peVhaÑ;
       if (@anti < 0);
          return -1;
       endif;

       if (@anti > 5);
          return -1;
       endif;

       // -------------------------------
       // Buscar tarifa vigente
       // -------------------------------
       rc = CZWUTL_getTarifa( peCtre: *OMIT );
       if (rc = -1);
          peErrm = CZWUTL_Error(peErrn);
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -------------------------------
       // Fecha de Emisión
       // -------------------------------
       peFemi = CZWUTL_getFemi();

       // -------------------------------
       // Buscar Tablas de AIR/RC
       // -------------------------------
       SPTRCAIR( peCtre
               : peScta
               : '01'
               : peVhca
               : peVhv1
               : peVhv2
               : peTarc
               : peTair
               : peFemi
               : peCot.mtdf );
       if (peTarc <= 0 or peTair <= 0);
          peErrn = 10010;
          peErrm = 'No se han encontrado tablas para tarifar';
          SetError( peErrn: peErrm);
          return -1;
       endif;

       // -----------------------------
       // Pick Up B en ninguna Zona
       // -----------------------------
       if (peCot.vhca > 4);
          return -1;
       endif;

       // -----------------------------
       // Pick Up A sólo 0 y 1
       // -----------------------------
       if (peCot.vhca = 4 and peCot.mtdf = ' ');
          if (peCot.scta <> 6 and peCot.scta <> 1);
              return -1;
          endif;
       endif;

       // -----------------------------
       // Suma asegurada minima
       // -----------------------------
       if (peCot.vhvu < CZWUTL_getSumaMinima());
          if (peCot.scta = 1 or peCot.scta = 2 or peCot.scta = 6);
             return -1;
          endif;
       endif;

       // -----------------------------
       // Veo Marca/Modelo
       // -----------------------------
       peAlld = CZWUTL_getDescMarcaModelo( peCot.vhmc
                                         : peCot.vhmo
                                         : peCot.vhcs );
       // --------------------------------
       // Plan Promo 0 KM
       // --------------------------------
       if (peCot.vh0k = 'S');
          peAlld += CZWUTL_getPorcPromo0Km( usempr
                                          : ussucu
                                          : peArcd
                                          : peRama   );
       endif;

       // --------------------------------
       // Resolver cual de todas las D
       // --------------------------------
       rc = CZWUTL_getCobertD( peVhca
                             : peVhv1
                             : peVhv2
                             : peCot.mtdf
                             : peScta
                             : peCobl );
       if rc = -1;
          return -1;
       endif;

       PAR313G( peCobl
              : peVhvu
              : *zeros
              : *zeros
              : *zeros
              : *zero
              : ' '
              : peTarc
              : peTair
              : peScta
              : peVhca
              : peVhv1
              : peVhv2
              : peVhaÑ
              : peCot.vhni
              : peVhct
              : 1
              : '01'
              : 99
              : '0'
              : '0'
              : peAlld
              : peCot.vh0k
              : *zeros
              : pePrrc
              : pePrac
              : pePrin
              : pePrro
              : pePacc
              : pePraa
              : pePrsf
              : pePrce
              : pePrap
              : peRcle
              : peRcco
              : peRcac
              : peLrce
              : peSaap
              : peSumd
              : peCtre
              : peCot.mtdf );

       @prim = pePrrc
             + pePrac
             + pePrin
             + pePrro
             + pePacc
             + pePraa
             + pePrsf
             + pePrce
             + pePrap
             + peRcle
             + peRcco;

       if (peCot.dupe <> 0);
          @coci = 12/peCot.dupe;
        else;
          @coci = 1;
       endif;

       pePrim = @prim/@coci;
       primaMinima = CZWPRI_getPrimaMinima(*omit);

       if (pePrim < primaMinima);
          pePrim = primaMinima;
       endif;

       return 0;

      /end-free

     P CZWPRI_calCobD  E

      * ------------------------------------------------------------ *
      * getPrimaMinima():    Retorna Prima Mínima                    *
      *                                                              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Prima Mínima                                        *
      * ------------------------------------------------------------ *
     P CZWPRI_getPrimaMinima...
     P                 B                   export
     D CZWPRI_getPrimaMinima...
     D                 pi            15  2
     D   peFech                       8  0 options(*nopass:*omit)

     D @Fech           s              8  0
     D PRIMA_MINIMA    c                   320

      /free

       CZWPRI_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
          @Fech = peFech;
        else;
          @Fech = CZWUTL_getFemi();
       endif;

       return PRIMA_MINIMA;

      /end-free

     P CZWPRI_getPrimaMinima...
     P                 E

