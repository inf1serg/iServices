     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPREN: Renovacion Automatica                                *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     08-Jun-2016             *
      *------------------------------------------------------------- *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *>           BNDDIR(HDIILE/HDIBDIR) -             <*           *
      *> TEXT('Prgrama de Servicio: Renovacion Automatica')     <*   *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                           <*   *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPREN))   <*   *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPREN))        <*   *
      *> IGN: DLTSPLF FILE(SVPREN)                              <*   *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SFA 01/09/16 - Agrego procedimiento _getAccesorios           *
      * LRG 08/09/16 - Se corrigue llamda al procedimiento           *
      *                SVPREN_getSumaAseguradaVehiculo en            *
      *                procedimiento SVPREN_chkComponenteAuto        *
      * LRG 08/09/16 - Se agrega validacion de Suma Asegurada Maxima *
      * LRG 18/05/17 - Se grega nuevo procedimiemnto                 *
      *                SVPREN_chkCobMayorVeh()                       *
      *                SVPREN_getListaCobMayorVeh                    *
      * JSN 04/05/18 - Se agrega nuevo procedimiento:                *
      *                _chkMarcaTecCobRen                            *
      *                _aumentoSumaAsegurada                         *
      * GIO 12/02/19 - Adecuacion para beneficio 0-Kms Segundo Año   *
      * JSN 16/10/19 - Se agrega nuevo procedimiento:                *
      *                _getScoring().                                *
      * JSN 28/02/20 - Se modifica el procedimiento                  *
      *                _chkComponenteAuto                            *
      * LRG 27/05/2019: Se cambia llamada ed SVPWS_getGrupoRama por  *
      *                 SVPWS_getGrupoRamaArch                       *
      *                                                              *
      * SPV 11/06/2020: Incorpora procedimiento                      *
      *                           SVPREN_getPlanDePago               *
      *                 Redefinir campo t@Date de archivo SETCMY     *
      *                 Por error de longitud en otros archivos      *
      *                                                              *
      * LRG 14/07/2020: Nuevo PRC: _ChkGeneralWeb                    *
      * SGF 21/01/2021: En _aumentoSumaAsegurada() cuando la rama    *
      *                 dice 0, es 0. No 1.                          *
      * SGF 20/07/2021: En SVPREN_chkAsegurado() no es error si el   *
      *                 asegurado es de Cordoba y Mendoza.           *
      *                 Ver el Redmine 10272.                        *
      *                                                              *
      * ************************************************************ *
     Fset6303   if   e           k disk    usropn
     Fset207    if   e           k disk    usropn
     fpahed0    if   e           k disk    usropn
     fpahet0    if   e           k disk    usropn
     fpahet1    if   e           k disk    usropn
     fpahet4    if   e           k disk    usropn
     fpahet9    if   e           k disk    usropn
     fpaher9    if   e           k disk    usropn
     Fset22225  if   e           k disk    usropn prefix( t1 : 2 )
     Fgntloc    if   e           k disk    usropn
     Fsehni41   if   e           k disk    usropn
     Fsetbre    if   e           k disk    usropn
     Fsetcmy    if   e           k disk    usropn
     Fpawrn1    if   e           k disk    usropn
     Fset103    if   e           k disk    usropn
     Fset608    if   e           k disk    usropn
     Fset60802  if   e           k disk    usropn
     F                                     rename(s1t608:s1t60802)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/SVPART_H.rpgle'
      /copy './qcpybooks/SVPREN_H.rpgle'
      /copy './qcpybooks/SVPTAB_H.rpgle'
      /copy './qcpybooks/SVPPOL_H.rpgle'
      /copy './qcpybooks/SPVSPO_H.rpgle'

     D ErrN            s             10i 0
     D ErrM            s             80a
     D Initialized     s              1n

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

      *--- PR Interno ---------------------------------------------- *
     D getSumaUltimoEndoso...
     D                 pr            15  2
     D                                1    const
     D                                2    const
     D                                6  0 const
     D                                9  0 const
     D                                2  0 const
     D                                2  0 const
     D                                4  0 const

     D getSumaInfoAutos...
     D                 pr            15  2
     D                                1    const
     D                                2    const
     D                                6  0 const
     D                                9  0 const
     D                                2  0 const
     D                                2  0 const
     D                                4  0 const

     D esGnc...
     D                 pr              n
     D                                1    const
     D                                2    const
     D                                6  0 const
     D                                9  0 const
     D                                2  0 const
     D                                2  0 const
     D                                4  0 const

     D getAÑo...
     D                 pr             4  0
     D                                1    const
     D                                2    const
     D                                6  0 const
     D                                9  0 const
     D                                2  0 const
     D                                2  0 const
     D                                4  0 const

     D esCeroKm...
     D                 pr              n
     D                                1    const
     D                                2    const
     D                                6  0 const
     D                                9  0 const
     D                                2  0 const
     D                                2  0 const
     D                                4  0 const

      *--- PR Externos --------------------------------------------- *
     D SPCHKPJIVA      pr                  extpgm('SPCHKPJIVA')
     D                                1a
     D                                2a
     D                                6  0
     D                                9  0
     D                                3  0
     D                                1  0

     D SP0079B         pr                  extpgm('SP0079B')
     D                                6  0
     D                                9  0
     D                                8  0
     D                                5  0

     D PAR310X3        pr                  extpgm('PAR310X3')
     D                                1
     D                                4  0
     D                                2  0
     D                                2  0

     D SPTRCAIR        pr                  extpgm('SPTRCAIR')
     D                                5  0
     D                                1  0
     D                                2
     D                                2  0
     D                                1  0
     D                                1  0
     D                                2  0
     D                                2  0
     D                                8  0
     D                                1    options(*nopass)

     D SPSUMAS         pr                  extpgm('SPSUMAS')
     D                                1
     D                                2
     D                                6  0
     D                                9  0
     D                                3  0
     D                                2  0
     D                                2  0
     D                                7  0
     D                                4  0
     D                                3  0
     D                               15  2
     D                               15  2
     D                                3    options(*nopass) const
     D                                1    options(*nopass) const

     D SPTRCAI1        pr                  extpgm('SPTRCAI1')
     D                                2  0
     D                                2  0
     D                                1  0
     D                                8  0
     D                                2
     D                                1  0
     D                                1  0
     D                                5  0
     D                                1    options(*nopass)

     DSPGMTDF          pr                  extpgm('SPGMTDF')
     D                                3
     D                                3
     D                                3
     D                                1
     D                                3

     DSPREBRV2         pr                  extpgm('SPREBRV2')
     D                                7  0
     D                               25
     D                                1  0
     D                                7  0  options(*nopass)
     D                                8  0  options(*nopass)
     D                                1     options(*nopass)

     DSPGETPSUA        pr                  extpgm('SPGETPSUA')
     D peRama                         2  0 const
     D peXpro                         3  0 const
     D peRetu                         2  0

     d pax011          pr                  ExtPgm('PAX011')
     d  peTipo                             const like(t9empr)
     d  peEmpr                             const like(t9empr)
     d  peSucu                             const like(t9sucu)
     d  peArcd                             const like(t9arcd)
     d  peSpol                             const like(t9spol)
     d  peSspo                             const like(t9sspo)
     d  peRama                             const like(t9rama)
     d  peArse                             const like(t9arse)
     d  peOper                             const like(t9oper)
     d  pePoco                             const like(t9poco)
     d  peNmat                             const like(t9nmat)
     d  peAInf                                   like(t9vhaÑ)
     d  pe0kms                                   like(*in99)
     d  peDel0Km2a                               like(*in99)

      *----------------------------------------------------------------*
      * Define renombre de campos
      *----------------------------------------------------------------*
     IS1tcmy
     I              T@Date                      t@Fech

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPREN_chkArticulo(): Validaciones Spobre Articulo.          *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkArticulo...
     P                 B                   export
     D SVPREN_chkArticulo...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0

       SVPREN_inz();

       clear @@erro;
       @@erroC = *Zeros;

       if not SVPVAL_articulo ( peArcd );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SVPVAL_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_ARTNE;
       endif;

       if not SVPVAL_articuloWeb ( peArcd );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SVPVAL_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_ARTNW;
       endif;

       if not SVPVAL_articuloRenovacion ( peArcd );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SVPVAL_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_ARNOR;
       endif;

       if %parms >= 2 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 3 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkArticulo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkSuperPoliza(): Validaciones Sobre SuperPoliza      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkSuperPoliza...
     P                 B                   export
     D SVPREN_chkSuperPoliza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@empr          s              1
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@ccuo          s              5  0
     D @@fech          s              8  0

     D @@dia           s              2  0
     D @@mes           s              2  0
     D @@aÑo           s              4  0

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0

     D @@conf          ds                  likeDs(ds603_t)

       SVPREN_inz();

       clear @@erro;
       @@erroC = *Zeros;

       if not SVPVRENO_SuperPolizaRenovable ( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol );
         @@erroC += 1;
         @@erro( @@erroC ).errM = 'SuperPoliza Inhibida';
         @@erro( @@erroC ).errN = SVPREN_SPINH;
       endif;

       if SPVSPO_chkSpolRenovada ( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol ) <> *Zeros;
         @@erroC += 1;
         @@erro( @@erroC ).errM = SPVSPO_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_SPYRE;
       endif;

       if SPVSPO_chkSpolSuspendida ( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SPVSPO_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_SPSUS;
       endif;

       if SPVSPO_chkPenSpeedway ( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SPVSPO_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_SPPSP;
       endif;

       @@empr = peEmpr;
       PAR310X3 ( @@empr
                : @@aÑo
                : @@mes
                : @@dia  );

       @@arcd = peArcd;
       @@spol = peSpol;
       @@fech = SPVSPO_getHastaFac( peEmpr : Pesucu : PeArcd : PeSpol);
       SP0079B ( @@arcd
               : @@spol
               : @@fech
               : @@ccuo );

       if not SVPREN_getConfiguracion ( peArcd : @@conf );
         return *Off;
       endif;

       if @@ccuo > @@conf.t@3ccuo;
         @@erroC += 1;
         @@erro( @@erroC ).errM = 'Poliza Con Cuotas Pendientes';
         @@erro( @@erroC ).errN = SVPREN_PCUOP;
       endif;

       if SPVVEH_franquiciaManualSpol( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SPVVEH_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_FRAMA;
       endif;

       if %parms >= 5 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 6 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkSuperPoliza...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkProductor(): Validaciones Sobre Productor          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkProductor...
     P                 B                   export
     D SVPREN_chkProductor...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@nivt          s              1  0
     D @@nivc          s              5  0

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0

       SVPREN_inz();

       clear @@erro;
       @@erroC = *Zeros;

       SPVSPO_getProductor ( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol
                           : *Omit
                           : @@nivt
                           : @@nivc );

       if SVPVAL_productorBloqueado ( peEmpr
                                    : peSucu
                                    : @@nivt
                                    : @@nivc
                                    : 2      );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SVPVAL_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_PRBLO;
       endif;

       if %parms >= 5 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 6 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkProductor...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkAsegurado(): Validaciones Sobre Asegurado          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkAsegurado...
     P                 B                   export
     D SVPREN_chkAsegurado...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@asen          s              7  0

     D @@empr          s              1a
     D @@sucu          s              2a
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@reto          s              1  0

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0

       SVPREN_inz();

       clear @@erro;
       @@erroC = *Zeros;

       @@asen = SPVSPO_getAsen ( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol );

       @@empr = peEmpr;
       @@sucu = peSucu;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = 999;

       SPCHKPJIVA ( @@empr
                  : @@sucu
                  : @@arcd
                  : @@spol
                  : @@sspo
                  : @@reto );

       if @@reto <> *Zeros;
         @@erroC += 1;
         @@erro( @@erroC ).errM = 'Asegurado con IVA Invalido';
         @@erro( @@erroC ).errN = SVPREN_ASIVA;
       endif;

       if SVPVAL_aseguradoCbaMza ( peEmpr
                                 : peSucu
                                 : @@asen );
         //@@erroC += 1;
         //@@erro( @@erroC ).errM = SVPVAL_Error ( @@erro( @@erroC ).errN );
         //@@erro( @@erroC ).errN = SVPREN_ACBMZ;
       endif;

       if %parms >= 5 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 6 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkAsegurado...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkPolizaAuto(): Validaciones sobre Poliza de Auto    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkPolizaAuto...
     P                 B                   export
     D SVPREN_chkPolizaAuto...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@nivt          s              1  0
     D @@nivc          s              5  0
     D @@xrea          s              5  2
     D @@retu          s              1

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0

       SVPREN_inz();

       clear @@erro;
       @@erroC = *Zeros;

       SPVSPO_getProductor ( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol
                           : *Omit
                           : @@nivt
                           : @@nivc );

       @@xrea = SPVSPO_getRecAdministrativo ( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peRama
                                            : peArse );

       if not SVPEPV_chkEpvIngresada( peEmpr
                                    : peSucu
                                    : @@nivt
                                    : @@nivc
                                    : peArcd
                                    : peRama
                                    : peArse
                                    : @@xrea
                                    : @@retu );

         if @@retu = '2';
           @@erroC += 1;
           @@erro( @@erroC ).errM = SVPEPV_Error ( @@erro( @@erroC ).errN );
           @@erro( @@erroC ).errN = SVPREN_EPVFL;
         endif;

       endif;

       if %parms >= 7 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 8 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkPolizaAuto...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkPolizaHogar(): Validaciones sobre Poliza de Hogar  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkPolizaHogar...
     P                 B                   export
     D SVPREN_chkPolizaHogar...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0

       SVPREN_inz();

       return *On;

     P SVPREN_chkPolizaHogar...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkPolizas(): Valida Polizas para Renovacion          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkPolizas...
     P                 B                   export
     D SVPREN_chkPolizas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yed0          ds                  likeRec(p1hed0:*Key)

     D esAuto          s              1    inz('A')
     D esRgv           s              1    inz('R')

       SVPREN_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       setgt %kds ( k1yed0 : 4 ) pahed0;
       readpe %kds ( k1yed0 : 4 ) pahed0;
       k1yed0.d0sspo = d0sspo;

       setll %kds ( k1yed0 : 5 ) pahed0;
       reade %kds ( k1yed0 : 5 ) pahed0;

       dow not %eof ( pahed0 );

         select;
           when SVPWS_getGrupoRamaArch ( d0rama ) = esAuto;
             if not SVPREN_chkPolizaAuto ( d0empr
                                         : d0sucu
                                         : d0arcd
                                         : d0spol
                                         : d0rama
                                         : d0arse );
               return *Off;
             endif;
           when SVPWS_getGrupoRamaArch ( d0rama ) = esRgv;
             if not SVPREN_chkPolizaHogar ( d0empr
                                          : d0sucu
                                          : d0arcd
                                          : d0spol
                                          : d0rama
                                          : d0arse );
               return *Off;
             endif;
         endsl;

         reade %kds ( k1yed0 : 5 ) pahed0;

       enddo;

     P SVPREN_chkPolizas...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkComponenteAuto(): Validaciones sobre Poco de Autos *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkComponenteAuto...
     P                 B                   export
     D SVPREN_chkComponenteAuto...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@DsT0          ds                  likeds(dsPahet0_t)
     D @@DsT9          ds                  likeds(dsPahet9_t)

     D @@Vhca          s              2  0
     D @@Vhv1          s              1  0
     D @@Vhv2          s              1  0
     D @@Mtdf          s              1
     D @@tarc          s              2  0
     D @@tair          s              2  0
     D @@mone          s              2
     D @@empr          s              1
     D @@dia           s              2  0
     D @@mes           s              2  0
     D @@aÑo           s              4  0
     D @@femi          s              8  0
     D @@ctre          s              5  0
     D @@scta          s              1  0

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0

     d @@SPVVEH_getSumaMovAut...
     d                 s             15  2 inz(*zeros)

     d @@SVPREN_getSumaAseguradaVehiculo...
     d                 s             15  2 inz(*zeros)

     d @@SPVVEH_getSumaMaxima...
     d                 s             15  2 inz(*zeros)

       SVPREN_INZ();

       clear @@erro;
       @@erroC = *Zeros;

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       SPVVEH_getPahet9 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : @@DsT9 );

       if SPVVEH_getClasificacion( @@DsT0.t0Vhmc
                                 : @@DsT0.t0Vhmo
                                 : @@DsT0.t0Vhcs
                                 : @@Vhca
                                 : @@Vhv1
                                 : @@Vhv2
                                 : @@Mtdf   );
       endif;

       if not SPVVEH_chkRamaCapitulo( peRama
                                    : @@Vhca
                                    : @@Vhv1
                                    : @@Vhv2 );

           @@erroC += 1;
           @@erro( @@erroC ).errM = SPVVEH_Error ( @@erro( @@erroC ).errN );
           @@erro( @@erroC ).errN = SVPREN_RCVIN;
       endif;

       @@SPVVEH_getSumaMovAut = SPVVEH_getSumaMovAut( peArcd : 2 : 0 );

       @@SVPREN_getSumaAseguradaVehiculo =
                       SVPREN_getSumaAseguradaVehiculo( @@DsT9.t9empr
                                                      : @@DsT9.t9sucu
                                                      : @@DsT9.t9arcd
                                                      : @@DsT9.t9spol
                                                      : @@DsT9.t9rama
                                                      : @@DsT9.t9arse
                                                      : @@DsT9.t9poco );

       @@SPVVEH_getSumaMaxima = SPVVEH_getSumaMaxima();

       if @@SPVVEH_getSumaMovAut = *Zeros;
         @@erroC += 1;
         @@erro( @@erroC ).errM = 'Suma Asegurada en Cero';
         @@erro( @@erroC ).errN = SVPREN_SUMNE;
       else;
         if @@SVPREN_getSumaAseguradaVehiculo > @@SPVVEH_getSumaMovAut;
           @@erroC += 1;
           @@erro( @@erroC ).errM = 'Suma Asegurada Mayor a la Permitida';
           @@erro( @@erroC ).errN = SVPREN_SUMPE;
         else;
           if @@SPVVEH_getSumaMaxima <> *zeros and
              @@SPVVEH_getSumaMaxima < @@SVPREN_getSumaAseguradaVehiculo;

             @@erroC += 1;
             @@erro( @@erroC ).errM = 'Suma Asegurada Mayor a la Permitida';
             @@erro( @@erroC ).errN = SVPREN_SUMPE;
           endif;
         endif;
       endif;

       if SPVVEH_coberturaD( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol  );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SPVVEH_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_PLANP;
       endif;

       if not SVPSIN_chkCausaReno( peEmpr
                                 : peSucu
                                 : peRama
                                 : @@DsT0.t0Poli );

         @@erroC += 1;
         @@erro( @@erroC ).errM = SVPSIN_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_POLSI;
       endif;

       @@mone = SPVSPO_getMone( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : *omit  );

       @@empr = peEmpr;
       PAR310X3 ( @@empr
                : @@aÑo
                : @@mes
                : @@dia  );

       @@femi = @@aÑo * 10000 + @@mes * 100 + @@dia;

       @@ctre = @@DsT0.t0ctre;
       @@scta = @@DsT0.t0scta;

       if SPVVEH_CheckPatenteDupli( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : @@DsT9.t9nmat
                                  : pePoco );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SPVVEH_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_VANDU;
       endif;

       if SPVVEH_franquiciaManual( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : pePoco );
         @@erroC += 1;
         @@erro( @@erroC ).errM = SPVVEH_Error ( @@erro( @@erroC ).errN );
         @@erro( @@erroC ).errN = SVPREN_FRAMA;
       endif;

       if %parms >= 7 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 8 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkComponenteAuto...
     P                 E
      * ------------------------------------------------------------ *
      * SVPREN_chkComponenteHogar():Validaciones sobre Poco de Hogar *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkComponenteHogar...
     P                 B                   export
     D SVPREN_chkComponenteHogar...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

       return *On;

     P SVPREN_chkComponenteHogar...
     P                 E
      * ------------------------------------------------------------ *
      * SVPREN_chkComponentes(): Valida Componentes                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkComponentes...
     P                 B                   export
     D SVPREN_chkComponentes...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yer9          ds                  likeRec(p1her9:*Key)
     D k1yet9          ds                  likeRec(p1het9:*Key)

       SVPREN_inz();

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       setll %kds ( k1yet9 : 4 ) pahet9;
       reade %kds ( k1yet9 : 4 ) pahet9;

       dow not %eof ( pahet9 );

         if not SVPREN_chkComponenteAuto ( t9empr
                                         : t9sucu
                                         : t9arcd
                                         : t9spol
                                         : t9rama
                                         : t9arse
                                         : t9poco );
           return *Off;
         endif;

         reade %kds ( k1yet9 : 4 ) pahet9;

       enddo;

       k1yer9.r9empr = peEmpr;
       k1yer9.r9sucu = peSucu;
       k1yer9.r9arcd = peArcd;
       k1yer9.r9spol = peSpol;
       setll %kds ( k1yer9 : 4 ) paher9;
       reade %kds ( k1yer9 : 4 ) paher9;

       dow not %eof ( paher9 );
         if not SVPREN_chkComponenteHogar ( r9empr
                                          : r9sucu
                                          : r9arcd
                                          : r9spol
                                          : r9rama
                                          : r9arse
                                          : r9poco );
           return *Off;
         endif;

         reade %kds ( k1yer9 : 4 ) paher9;

       enddo;

       return *On;

     P SVPREN_chkComponentes...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkRenovacion(): Validacion de Renovacion Automatica  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkRenovacion...
     P                 B                   export
     D SVPREN_chkRenovacion...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

       SVPREN_inz();

       if not SVPREN_chkArticulo ( peArcd );
         return *Off;
       endif;

       if not SVPREN_chkSuperPoliza ( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol );
         return *Off;
       endif;

       if not SVPREN_chkProductor ( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol );
         return *Off;
       endif;

       if not SVPREN_chkAsegurado ( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol );
         return *Off;
       endif;

       if not SVPREN_chkPolizas ( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol );
         return *Off;
       endif;

       if not SVPREN_chkComponentes ( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol );
         return *Off;
       endif;

       return *On;

     P SVPREN_chkRenovacion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkGeneral(): Validaciones Generales                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkGeneral...
     P                 B                   export
     D SVPREN_chkGeneral...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D $$erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0
     D $$erroC         s             10i 0

     D x               s             10i 0

       SVPREN_inz();

       clear @@erro;
       @@erroC = *Zeros;

       if not SPVSPO_chkSpol ( peEmpr
                             : peSucu
                             : peArcd
                             : peSpol );
         @@erroC += 1;
         @@erro( @@erroC ).errM = 'SuperPoliza Inexistente';
         @@erro( @@erroC ).errN = SVPREN_SPINE;
         return *Off;
       endif;

       clear $$erro;
       $$erroC = *Zeros;
       if not SVPREN_chkArticulo ( peArcd : $$erro : $$erroC );
         for x = 1 to $$erroC;
           @@erroC += 1;
           @@erro ( @@erroC ) = $$erro ( x );
         endfor;
       endif;

       clear $$erro;
       $$erroC = *Zeros;
       if not SVPREN_chkSuperPoliza ( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : $$erro
                                    : $$erroC );
         for x = 1 to $$erroC;
           @@erroC += 1;
           @@erro ( @@erroC ) = $$erro ( x );
         endfor;
       endif;

       clear $$erro;
       $$erroC = *Zeros;
       if not SVPREN_chkProductor ( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : $$erro
                                  : $$erroC );
         for x = 1 to $$erroC;
           @@erroC += 1;
           @@erro ( @@erroC ) = $$erro ( x );
         endfor;
       endif;

       clear $$erro;
       $$erroC = *Zeros;
       if not SVPREN_chkAsegurado ( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : $$erro
                                  : $$erroC );
         for x = 1 to $$erroC;
           @@erroC += 1;
           @@erro ( @@erroC ) = $$erro ( x );
         endfor;
       endif;

       if %parms >= 5 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 6 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkGeneral...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getConfiguracion(): Configuracion de Articulo         *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peConf   (output)  Configuracion                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_getConfiguracion...
     P                 B                   export
     D SVPREN_getConfiguracion...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peConf                            likeDs(ds603_t)

     D ds6303          ds                  likerec(s1t6303:*input)

       SVPREN_INZ();

       if not SVPVAL_articuloRenovacion ( peArcd );
         return *Off;
       endif;

       chain peArcd set6303 ds6303;

       eval-corr peConf = ds6303;

       return *On;

     P SVPREN_getConfiguracion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getComponente(): Retorna Numero de Componente         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Numero de Componente                                *
      * ------------------------------------------------------------ *
     P SVPREN_getComponente...
     P                 B                   export
     D SVPREN_getComponente...
     D                 pi             4  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D k1yet9          ds                  likeRec(p1het9:*Key)

     D @@poco          s              4  0

       SVPREN_inz();

       @@poco = *Zeros;

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       k1yet9.t9rama = peRama;
       k1yet9.t9arse = peArse;
       setll %kds ( k1yet9 : 6 ) pahet9;
       reade %kds ( k1yet9 : 6 ) pahet9;

       dow not %eof ( pahet9 ) and t9poco <= pePoco;

         if t9aegn = *Zeros;
           @@poco += 1;
         endif;

         reade %kds ( k1yet9 : 6 ) pahet9;

       enddo;

       return @@poco;

     P SVPREN_getComponente...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getSumaAseguradaVehiculo(): Retorna Suma Asegurada    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Numero de Componente                                *
      * ------------------------------------------------------------ *
     P SVPREN_getSumaAseguradaVehiculo...
     P                 B                   export
     D SVPREN_getSumaAseguradaVehiculo...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@endo          s             15  2
     D @@info          s             15  2

     D @@conf          ds                  likeDs(ds603_t)

       SVPREN_inz();

       if not SVPREN_getConfiguracion ( peArcd : @@conf );
         return -1;
       endif;

       @@endo = getSumaUltimoEndoso( peEmpr : peSucu : peArcd : peSpol
                                   : peRama : peArse : pePoco );

       @@info = getSumaInfoAutos ( peEmpr : peSucu : peArcd : peSpol
                                 : peRama : peArse : pePoco );

       select;
         when @@conf.t@3mar3 = '0';
           return @@endo;
         when @@conf.t@3mar3 = '1';
           return @@info;
         when @@conf.t@3mar3 = '2';
           if @@info > @@info;
             return @@info;
           else;
             return @@info;
           endif;
         when @@conf.t@3mar3 = '3';
          if esCeroKm( peEmpr : peSucu : peArcd : peSpol
                      : peRama : peArse : pePoco );
             return @@info;
           else;
             if @@endo > @@info;
               return @@endo;
             else;
               return @@info;
             endif;
           endif;
       endsl;

     P SVPREN_getSumaAseguradaVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getImporteGnc(): Retorna Valor de Gnc                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Valor de GNC                                        *
      * ------------------------------------------------------------ *
     P SVPREN_getImporteGnc...
     P                 B                   export
     D SVPREN_getImporteGnc...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@conf          ds                  likeDs(ds603_t)

     D @@DsT9          ds                  likeds(dsPahet9_t)

       SVPREN_inz();

       if not esGnc ( peEmpr : peSucu : peArcd : peSpol
                    : peRama : peArse : pePoco );
         return *Zeros;
       endif;

       if not SVPREN_getConfiguracion ( peArcd : @@conf );
         return *Zeros;
       endif;

       SPVVEH_getPahet9 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : @@DsT9 );

       return @@DsT9.t9rgnc +
       ( ( @@DsT9.t9rgnc * @@conf.t@3pgnc ) / 100 );

     P SVPREN_getImporteGnc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getClienteIntegral(): Retorna si es Cliente Integral  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Retorna si es Cliente Integral                      *
      * ------------------------------------------------------------ *
     P SVPREN_getClienteIntegral...
     P                 B                   export
     D SVPREN_getClienteIntegral...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D k1yet4          ds                  likerec(p1het4:*Key)

     D @@DsT0          ds                  likeds(dsPahet0_t)

       SVPREN_INZ();

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       k1yet4.t4empr = @@DsT0.t0empr;
       k1yet4.t4sucu = @@DsT0.t0sucu;
       k1yet4.t4arcd = @@DsT0.t0arcd;
       k1yet4.t4spol = @@DsT0.t0spol;
       k1yet4.t4sspo = @@DsT0.t0sspo;
       k1yet4.t4rama = @@DsT0.t0rama;
       k1yet4.t4arse = @@DsT0.t0arse;
       k1yet4.t4oper = @@DsT0.t0oper;
       k1yet4.t4suop = @@DsT0.t0suop;
       k1yet4.t4poco = @@DsT0.t0poco;
       k1yet4.t4ccbp = 10;

       setll %kds ( k1yet4 ) pahet4;

       return %equal (pahet4);

     P SVPREN_getClienteIntegral...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getTarifa(): Retornar Tarifa                          *
      *                                                              *
      *        peEmpr ( input ) Empresa                              *         *
      *        peSucu ( input ) Sucursal                             *         *
      *        peArcd ( input ) Articulo                             *         *
      *        peSpol ( input ) SuperPoliza                          *         *
      *        peRama ( input ) Rama                                 *         *
      *        peArse ( input ) Cantidad de Polizas                  *         *
      *        pePoco ( input ) Nro de componente                    *         *
      *                                                              *         *
      * Retorna: Tarifa / -1                                         *
      * ------------------------------------------------------------ *
     P SVPREN_getTarifa...
     P                 B                   export
     D SVPREN_getTarifa...
     D                 pi             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@empr          s              1
     D @@vhca          s              2  0
     D @@vhv1          s              1  0
     D @@vhv2          s              1  0
     D @@mtdf          s              1
     D @@tarc          s              2  0
     D @@tair          s              2  0
     D @@mone          s              2
     D @@femi          s              8  0
     D @@ctre          s              5  0
     D @@scta          s              1  0
     D @@vhcs          s              3
     D @@vhmc          s              3
     D @@vhmo          s              3
     D @@finp          s              3

     D zztarc          s              2  0
     D zztair          s              2  0

     D @@dia           s              2  0
     D @@mes           s              2  0
     D @@aÑo           s              4  0

     D @@DsT0          ds                  likeds( dsPahet0_t )
     D @@conf          ds                  likeds( ds603_t )

     D k1y225          ds                  likerec( s1t22225 : *key )

       SVPREN_inz();

       if not SVPREN_getConfiguracion ( peArcd : @@conf );
         return -1;
       endif;

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       if @@conf.t@3mar2  = 'P' or @@conf.t@3mar2  = 'S';
          return @@DsT0.t0ctre;
       endif;

       @@scta = SVPREN_getZona( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : peRama
                              : peArse
                              : pePoco );

       @@empr = peEmpr;
       PAR310X3 ( @@empr
                : @@aÑo
                : @@mes
                : @@dia  );

       @@femi = ( @@aÑo * 10000) + ( @@mes + 100 ) + @@dia;

       k1y225.t1femi = @@femi;
       k1y225.t1scta = @@scta;
       setll %kds( k1y225 : 2 ) set22225;
       readp set22225;

       if not %eof( set22225 );
         @@ctre = t1ctre;
       else;
         @@ctre = *Zeros;
       endif;

       @@mone = SPVSPO_getMone( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : *omit  );

       @@vhmc = @@DsT0.t0vhmc;
       @@vhmo = @@DsT0.t0vhmo;
       @@vhcs = @@DsT0.t0vhcs;
       SPGMTDF ( @@vhmc : @@vhmo : @@vhcs : @@mtdf : @@finp );

       @@vhca = @@DsT0.t0vhca;
       @@vhv1 = @@DsT0.t0vhv1;
       @@vhv2 = @@DsT0.t0vhv2;

       @@tarc = *Zeros;
       @@tair = *Zeros;

       SPTRCAIR( @@ctre
               : @@scta
               : @@mone
               : @@vhca
               : @@vhv1
               : @@vhv2
               : @@tarc
               : @@tair
               : @@femi
               : @@Mtdf ) ;

       Select;
         when @@conf.t@3mar2 = 'C' or  @@conf.t@3mar2 = 'X';
           zztarc = @@DsT0.t0tarc;
           zztair = @@tair;
         when @@conf.t@3mar2 = 'I' or  @@conf.t@3mar2 = 'R';
           zztarc = @@tarc;
           zztair = @@DsT0.t0tair;
         when @@conf.t@3mar2 = 'T' or @@conf.t@3mar2  = 'Y';
           zztarc = @@tarc;
           zztair = @@tair;
       endsl;

       SPTRCAI1 ( @@tarc
                : @@tair
                : @@scta
                : @@femi
                : @@mone
                : @@vhv1
                : @@vhv2
                : @@ctre
                : @@mtdf );

       if not SVPVAL_tarifa ( @@femi : @@ctre );
         @@ctre = *Zeros;
       endif;

       if @@Ctre = *Zeros;
         @@femi = %dec(%date:*iso);
         CZWUTL_getTarifa( @@ctre :
                           @@femi );
       endif;

       return @@ctre;

     P SVPREN_getTarifa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getZona(): Retornar Zona                              *
      *                                                              *
      *        peEmpr ( input ) Empresa                              *         *
      *        peSucu ( input ) Sucursal                             *         *
      *        peArcd ( input ) Articulo                             *         *
      *        peSpol ( input ) SuperPoliza                          *         *
      *        peRama ( input ) Rama                                 *         *
      *        peArse ( input ) Cantidad de Polizas                  *         *
      *        pePoco ( input ) Nro de componente                    *         *
      *                                                              *         *
      * Retorna: Zona / -1                                           *
      * ------------------------------------------------------------ *
     P SVPREN_getZona...
     P                 B                   export
     D SVPREN_getZona...
     D                 pi             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@scta          s              1  0 inz
     D @@nivt          s              1  0 inz
     D @@nivc          s              5  0 inz
     D @@sspo          s              3  0 inz
     D @@copo          s              5  0 inz
     D @@cops          s              1  0 inz
     D @@mtdf          s              1    inz
     D @@asen          s              7  0 inz

     D @@DsT0          ds                  likeds( dsPahet0_t )
     D @@conf          ds                  likeds( ds603_t )

     D k1yloc          ds                  likerec( g1tloc  : *key )
     D k1yi41          ds                  likerec( s1hni41 : *key )

       SVPREN_inz();

       if not SVPREN_getConfiguracion ( peArcd : @@conf );
         return -1;
       endif;

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       @@asen = SPVSPO_getAsen( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : *omit  );

       @@scta = @@DsT0.t0scta;

       if @@conf.t@3getz  = 'S';
         if not SVPDAF_getLocalidad( @@asen
                                   : @@Copo
                                   : @@Cops );
           return -1;
         endif;

         k1yloc.locopo = @@Copo;
         k1yloc.locops = @@Cops;
         chain %kds( k1yloc : 2 ) gntloc;
         if %found ( gntloc );
           @@scta = loscta;
         endif;
       endif;

       SPVSPO_getProductor( peEmpr
                          : peSucu
                          : peArcd
                          : peSpol
                          : *omit
                          : @@Nivt
                          : @@Nivc  );

       k1yi41.n4nivt = @@nivt;
       k1yi41.n4nivc = @@nivc;
       k1yi41.n4scta = @@scta;
       chain %kds( k1yi41 ) sehni41;

       if %found( sehni41 );
         @@scta = n4ctae;
       endif;

       return
          CZWUTL_getZonaReal ( peEmpr : peSucu : @@nivt : @@nivc : @@scta );

     P SVPREN_getZona...
     P                 E

      *--------------------------------------------------------------*
      * SVPREN_getBuenResultado(): Retorna  Buen Resultado           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cantidad de Polizas                   *
      *     pePoco   (input)   Nro de componentes                    *
      *                                                              *
      * Retorna: Buen Resultado                                      *
      * ------------------------------------------------------------ *
     P SVPREN_getBuenResultado...
     P                 B                   export
     D SVPREN_getBuenResultado...
     D                 pi             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@DsT9          ds                  likeds(dsPahet9_t)

     D @@aÑos          s              1  0
     D @@asen          s              7  0
     D @@nmat          s             25

       SVPREN_inz();

       SPVVEH_getPahet9 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : @@DsT9 );

       @@asen = SPVSPO_getAsen ( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol );

       @@nmat = @@DsT9.t9Nmat;

       SPREBRV2 ( @@asen
                : @@nmat
                : @@aÑos );

       setll *Start setbre;
       read setbre;

       dow not %eof( setbre );
         if seaÑos > @@aÑos;
           return %dec ( @@aÑos : 1 : 0 );
         endif;
         read setbre;
       enddo;

       return %dec ( seaÑos : 1 : 0 );

     P SVPREN_getBuenResultado...
     P                 E
      *--------------------------------------------------------------*
      * SVPREN_getDescuentosComponente(): Retorna Descuentos         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *     peDesc   (input)   Ds de Descuentos                      *
      *     peDescC  (input)   Cantidad                              *
      *                                                              *
      * Retorna: Retorna Descuentos de Componente                    *
      * ------------------------------------------------------------ *
     P SVPREN_getDescuentosComponente...
     P                 B                   export
     D SVPREN_getDescuentosComponente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peDesc                            likeds(dsDescuentos_t) dim(20)
     D   peDescC                     10i 0

     D k1yet4          ds                  likerec(p1het4:*Key)

     D inEt4           ds                  likerec(p1het4:*input)

     D @@DsT0          ds                  likeds(dsPahet0_t)

       SVPREN_inz();

       clear peDesc;
       peDescC = *Zeros;

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       k1yet4.t4empr = @@DsT0.t0empr;
       k1yet4.t4sucu = @@DsT0.t0sucu;
       k1yet4.t4arcd = @@DsT0.t0arcd;
       k1yet4.t4spol = @@DsT0.t0spol;
       k1yet4.t4sspo = @@DsT0.t0sspo;
       k1yet4.t4rama = @@DsT0.t0rama;
       k1yet4.t4arse = @@DsT0.t0arse;
       k1yet4.t4oper = @@DsT0.t0oper;
       k1yet4.t4suop = @@DsT0.t0suop;
       k1yet4.t4poco = @@DsT0.t0poco;

       setll %kds ( k1yet4 ) pahet4;
       reade %kds ( k1yet4 ) pahet4 inEt4;

       dow not %eof ( pahet4 );
         peDescC += 1;
         eval-corr peDesc(peDescC) = inEt4;
         reade %kds ( k1yet4 ) pahet4 inEt4;
       enddo;

       return *On;

     P SVPREN_getDescuentosComponente...
     P                 E

      *--------------------------------------------------------------*
      * SVPREN_getAccesoriosComponente() Retorna Accesorios          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cantidad de Polizas                   *
      *     pePoco   (input)   Nro de componentes                    *
      *     peAcce   (input)   Ds de Accesorios                      *
      *     peAcceC  (input)   Cantidad                              *
      *                                                              *
      * Retorna: Retorna Accesorios de Componente                    *
      * ------------------------------------------------------------ *
     P SVPREN_getAccesoriosComponente...
     P                 B                   export
     D SVPREN_getAccesoriosComponente...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100)
     D   peAcceC                     10i 0

     D k1yet1          ds                  likeRec(p1het1:*Key)

     D @@DsT0          ds                  likeDs(dsPahet0_t)
     D @@conf          ds                  likeDs(ds603_t)

     D @@tota          s             10i 0

       SVPREN_inz();

       clear peAcce;
       peAcceC = *Zeros;
       @@tota = *Zeros;

       if not SVPREN_getConfiguracion ( peArcd : @@conf );
         return -1;
       endif;

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       k1yet1.t1empr = @@DsT0.t0empr;
       k1yet1.t1sucu = @@DsT0.t0sucu;
       k1yet1.t1arcd = @@DsT0.t0arcd;
       k1yet1.t1spol = @@DsT0.t0spol;
       k1yet1.t1sspo = @@DsT0.t0sspo;
       k1yet1.t1rama = @@DsT0.t0rama;
       k1yet1.t1arse = @@DsT0.t0arse;
       k1yet1.t1oper = @@DsT0.t0oper;
       k1yet1.t1suop = @@DsT0.t0suop;
       k1yet1.t1poco = @@DsT0.t0poco;

       setll %kds ( k1yet1 : 10 ) pahet1;
       reade %kds ( k1yet1 : 10 ) pahet1;

       dow not %eof ( pahet1 );
         peAcceC += 1;

         if @@conf.t@3pacc = *Zeros;
           peAcce(peAcceC).accv = t1accv;
         else;
           peAcce(peAcceC).accv = ( @@conf.t@3pacc * t1accv ) / 100;
         endif;

         peAcce(peAcceC).secu = t1secu;
         peAcce(peAcceC).accd = t1accd;
         peAcce(peAcceC).mar1 = t1mar1;

         @@tota += peAcce(peAcceC).accv;

         reade %kds ( k1yet1 : 10 ) pahet1;
       enddo;

       return @@tota;

     P SVPREN_getAccesoriosComponente...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPREN_inz      B                   export
     D SVPREN_inz      pi

       if (initialized);
          return;
       endif;

       if not %open(set6303);
          open set6303;
       endif;

       if not %open(set207);
          open set207;
       endif;

       if not %open(pahed0);
          open pahed0;
       endif;

       if not %open(pahet0);
          open pahet0;
       endif;

       if not %open(pahet1);
          open pahet1;
       endif;

       if not %open(pahet4);
          open pahet4;
       endif;

       if not %open(pahet9);
          open pahet9;
       endif;

       if not %open(paher9);
          open paher9;
       endif;

       if not %open( set22225 );
          open set22225;
       endif;

       if not %open( gntloc );
          open gntloc;
       endif;

       if not %open( sehni41 );
          open sehni41;
       endif;

       if not %open(setbre);
          open setbre;
       endif;

       if not %open(setcmy);
          open setcmy;
       endif;

       if not %open(pawrn1);
          open pawrn1;
       endif;

       if not %open(set103);
          open set103;
       endif;

       if not %open(set608);
          open set608;
       endif;

       if not %open(set60802);
          open set60802;
       endif;

       initialized = *ON;
       return;

     P SVPREN_inz      E

      * ------------------------------------------------------------ *
      * COWREB_End:   Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPREN_End      B                   export
     D SVPREN_End      pi

       close *all;
       initialized = *OFF;

       return;

     P SVPREN_End      E

      * ------------------------------------------------------------ *
      * SVPREN_Error():Retorna el último error del service program   *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPREN_Error    B                   export
     D SVPREN_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

     P SVPREN_Error    E

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
      * getSumaUltimoEndoso() Suma Asegurada de Ultimo Endoso        *
      *                                                              *
      * Retorna Suma Asegurada de Ultimo Endoso                      *
      * ------------------------------------------------------------ *
     P getSumaUltimoEndoso...
     P                 B
     D getSumaUltimoEndoso...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@empr          s              1
     D @@sucu          s              2
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@rama          s              2  0
     D @@arse          s              2  0
     D @@poco          s              4  0
     D @@oper          s              7  0
     D @@sume          s             15  2
     D @@sumc          s             15  2

     D @@DsT9          ds                  likeds(dsPahet9_t)

       @@sume = *Zeros;
       @@sumc = *Zeros;

       SPVVEH_getPahet9 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : @@DsT9 );

       @@empr = @@DsT9.t9empr;
       @@sucu = @@DsT9.t9sucu;
       @@arcd = @@DsT9.t9arcd;
       @@spol = @@DsT9.t9spol;
       @@sspo = @@DsT9.t9sspo;
       @@rama = @@DsT9.t9rama;
       @@arse = @@DsT9.t9arse;
       @@oper = @@DsT9.t9oper;
       @@poco = @@DsT9.t9poco;
       @@sspo = @@DsT9.t9sspo;

       SPSUMAS ( @@empr
               : @@sucu
               : @@arcd
               : @@spol
               : @@sspo
               : @@rama
               : @@arse
               : @@oper
               : @@poco
               : @@sspo
               : @@sume
               : @@sumc );

       return @@sumc;

     P getSumaUltimoEndoso...
     P                 E

      * ------------------------------------------------------------ *
      * esCeroKm(): Retorna si es 0KM para Renovacion                *
      *                                                              *
      * Retorna si es 0KM para Renovacion                            *
      * ------------------------------------------------------------ *
     P esCeroKm...
     P                 B
     D esCeroKm...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D k1yet4          ds                  likerec(p1het4:*key)

     D @@DsT0          ds                  likeds(dsPahet0_t)

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       k1yet4.t4empr = @@DsT0.t0empr;
       k1yet4.t4sucu = @@DsT0.t0sucu;
       k1yet4.t4arcd = @@DsT0.t0arcd;
       k1yet4.t4spol = @@DsT0.t0spol;
       k1yet4.t4sspo = @@DsT0.t0sspo;
       k1yet4.t4rama = @@DsT0.t0rama;
       k1yet4.t4arse = @@DsT0.t0arse;
       k1yet4.t4oper = @@DsT0.t0oper;
       k1yet4.t4suop = @@DsT0.t0suop;
       k1yet4.t4poco = @@DsT0.t0poco;
       k1yet4.t4ccbp = 997;

       setll %kds ( k1yet4 ) pahet4;

       return %equal (pahet4);

     P esCeroKm...
     P                 E

      * ------------------------------------------------------------ *
      * getAÑo() Retorna año vehiculo para acceder a valor Infoauto  *
      *                                                              *
      *                                                              *
      * Retorna año vehiculo para acceder a valor Infoauto           *
      * ------------------------------------------------------------ *
     P getAÑo...
     P                 B
     D getAÑo...
     D                 pi             4  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@aÑo           s              4  0

     D @@DsT9          ds                  likeds(dsPahet9_t)

     D k1y207          ds                  likerec(s1t207:*key)

     d  @@Tipo         s                   like(t9empr)
     d  @@Empr         s                   like(t9empr)
     d  @@Sucu         s                   like(t9sucu)
     d  @@Arcd         s                   like(t9arcd)
     d  @@Spol         s                   like(t9spol)
     d  @@Sspo         s                   like(t9sspo)
     d  @@Rama         s                   like(t9rama)
     d  @@Arse         s                   like(t9arse)
     d  @@Oper         s                   like(t9oper)
     d  @@Poco         s                   like(t9poco)
     d  @@Nmat         s                   like(t9nmat)
     d  @@AInf         s                   like(t9vhaÑ)
     d  @@0Kms         s                   like(*in99)
     d  @@Del0Km2a     s                   like(*in99)

       SPVVEH_getPahet9 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : @@DsT9 );

       @@Tipo = '2';
       @@Empr = @@DsT9.t9empr;
       @@Sucu = @@DsT9.t9sucu;
       @@Arcd = @@DsT9.t9arcd;
       @@Spol = @@DsT9.t9spol;
       @@Sspo = @@DsT9.t9sspo;
       @@Rama = @@DsT9.t9rama;
       @@Arse = @@DsT9.t9arse;
       @@Oper = @@DsT9.t9oper;
       @@Poco = @@DsT9.t9poco;
       @@Nmat = @@DsT9.t9nmat;

       clear @@AInf;
       @@0Kms = *Off;
       @@Del0Km2a = *Off;

       PAX011( @@Tipo
             : @@Empr
             : @@Sucu
             : @@Arcd
             : @@Spol
             : @@Sspo
             : @@Rama
             : @@Arse
             : @@Oper
             : @@Poco
             : @@Nmat
             : @@AInf
             : @@0Kms
             : @@Del0Km2a );

       @@aÑo = @@AInf;

       return @@aÑo;

     P getAÑo...
     P                 E

      * ------------------------------------------------------------ *
      * esGnc() Retorna si es GNC                                    *
      *                                                              *
      *                                                              *
      * Retorna Retorna si es 0KM                                    *
      * ------------------------------------------------------------ *
     P esGnc...
     P                 B
     D esGnc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@DsT9          ds                  likeds(dsPahet9_t)

       SPVVEH_getPahet9 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : @@DsT9 );

       if @@DsT9.t9vhv2 = 5 or @@DsT9.t9vhv2 = 6;
         return *On;
       else;
         return *Off;
       endif;

     P esGnc...
     P                 E

      * ------------------------------------------------------------ *
      * getSumaInfoAutos() Suma Asegurada de InfoAutos               *
      *                                                              *
      * Retorna Suma Asegurada de InfoAutos                          *
      * ------------------------------------------------------------ *
     P getSumaInfoAutos...
     P                 B
     D getSumaInfoAutos...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D @@DsT0          ds                  likeds(dsPahet0_t)

     D k1y207          ds                  likerec(s1t207:*key)
     D @@conf          ds                  likeDs(ds603_t)

     D @@suma          s             15  2

       SVPREN_inz();

       @@suma = *Zeros;

       if not SVPREN_getConfiguracion ( peArcd : @@conf );
         return -1;
       endif;

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       k1y207.t@vhmc = @@DsT0.t0vhmc;
       k1y207.t@vhmo = @@DsT0.t0vhmo;
       k1y207.t@vhcs = @@DsT0.t0vhcs;
       k1y207.t@vhcr = @@DsT0.t0vhcr;
       k1y207.t@vhaÑ = getAÑo ( peEmpr : peSucu : peArcd : peSpol
                              : peRama : peArse : pePoco );

       chain %kds ( k1y207 : 5 ) set207;

       if %found ( set207 );
         @@suma = t@vhvu;
       endif;

       if @@suma = *Zeros;

         @@suma = @@DsT0.t0vhvu;

         @@suma += (@@suma * @@conf.t@3prsa ) / 100;

       endif;

       if esGnc ( peEmpr : peSucu : peArcd : peSpol
                : peRama : peArse : pePoco ) and ( @@suma <> *Zeros );
         if @@conf.t@3pgnc > *Zeros;
           @@suma += SVPREN_getImporteGnc ( peEmpr : peSucu : peArcd
                                      : peSpol : peRama : peArse : pePoco );
         endif;
       endif;

       @@suma += SPVVEH_getSumaAccesorios ( peEmpr : peSucu : peArcd
                                      : peSpol : peRama : peArse : pePoco );

       return @@suma;

     P getSumaInfoAutos...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkCobMayorVeh(): Verifica si cobertura ingresada es  *
      *                          Mayor a la que se va a renovar.-    *
      *                                                              *
      *          peEmpr   ( input  )  Parámetros Base                *
      *          peSucu   ( input  )  Número de Cotizacion           *
      *          peArcd   ( input  )  Articulo                       *
      *          peArse   ( input  )  Cant. de Ramas Por Polizas     *
      *          peRama   ( input  )  Rama                           *
      *          peCobA   ( input  )  Cobertura Anterior             *
      *          peCobS   ( input  )  Cpbertura Seleccionada.        *
      *                                                              *
      * Retorna *on = Es Mayor / *off = No es Mayor                  *
      * ------------------------------------------------------------ *
     P SVPREN_chkCobMayorVeh...
     P                 B                   export
     D SVPREN_chkCobMayorVeh...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peArse                       2  0 const
     D   peRama                       2  0 const
     D   peCobA                       2    const
     D   peCobS                       2    const

     D   k1ycmy        ds                  likerec( s1tcmy : *key )

      /free

        SVPREN_inz();

        k1ycmy.t@empr = peEmpr;
        k1ycmy.t@sucu = peSucu;
        k1ycmy.t@arcd = peArcd;
        k1ycmy.t@arse = peArse;
        k1ycmy.t@rama = peRama;
        k1ycmy.t@cobl = peCoba;
        k1ycmy.t@cobm = peCobs;
        setll %kds( k1ycmy : 7 ) setcmy;
        return %equal( setcmy );

      /end-free
     P SVPREN_chkCobMayorVeh...
     P                 E
      * ------------------------------------------------------------ *
      * SVPREN_getListaCobMayorVeh(): Retorna Lista Coberturas       *
      *                               Mayores de un Vehiculo         *
      *                                                              *
      *          peEmpr   ( input  )  Parámetros Base                *
      *          peSucu   ( input  )  Número de Cotizacion           *
      *          peArcd   ( input  )  Articulo                       *
      *          peArse   ( input  )  Cant. de Ramas Por Polizas     *
      *          peRama   ( input  )  Rama                           *
      *          peCobe   ( input  )  Coberturas                     *
      *          peLcob   ( output )  Lista de Coberturas Mayores    *
      *          peLcobC  ( output )  Cantidad de Coberturas Mayores *
      *                                                              *
      * Retorna *on = Contiene / *off = No contiene                  *
      * ------------------------------------------------------------ *
     P SVPREN_getListaCobMayorVeh...
     P                 B                   export
     D SVPREN_getListaCobMayorVeh...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peArse                       2  0 const
     D   peRama                       2  0 const
     D   peCobe                       2    const
     D   peLcob                       2    dim( 20 )
     D   peLcobC                     10i 0

     D   k1ycmy        ds                  likerec( s1tcmy : *key )
      /free

        SVPREN_inz();

        clear peLcobC;
        clear peLcob;
        k1ycmy.t@empr = peEmpr;
        k1ycmy.t@sucu = peSucu;
        k1ycmy.t@arcd = peArcd;
        k1ycmy.t@arse = peArse;
        k1ycmy.t@rama = peRama;
        k1ycmy.t@cobl = peCobe;
        setll %kds( k1ycmy : 6 ) setcmy;
        if not %equal( setcmy );
          return *off;
        endif;
        reade %kds( k1ycmy : 6 ) setcmy;
        dow not %eof( setcmy );
          pelcobc += 1;
          peLcob( pelcobc ) = t@cobm;
        reade %kds( k1ycmy : 6 ) setcmy;
        enddo;

        return *on;
      /end-free

     P SVPREN_getListaCobMayorVeh...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_chkMarcaTecCobRen(): Chequea que las marcas de Técni- *
      *                             ca y Cobranzas estan habilitadas *
      *                             para renovación                  *
      *                                                              *
      *          peArcd   ( input  )  Articulo                       *
      *          peSpol   ( input  )  Superpoliza                    *
      *          peRama   ( input  )  Rama                           *
      *          peArse   ( input  )  Cant. de Ramas Por Polizas     *
      *          peOper   ( input  )  Nro. de Operación              *
      *                                                              *
      * Retorna 'S' = Habilitado / 'N' = No Habilitado               *
      * ------------------------------------------------------------ *
     P SVPREN_chkMarcaTecCobRen...
     P                 B                   export
     D SVPREN_chkMarcaTecCobRen...
     D                 pi             1a
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)

     D   k1yrn1        ds                  likerec( p1wrn1 : *key )

      /free

        SVPREN_inz();

        k1yrn1.pwArcd = peArcd;
        k1yrn1.pwSpol = peSpol;
        k1yrn1.pwRama = peRama;

        select;

          when %parms >= 4 and %addr( peArse ) <> *NULL
                           and %addr( peOper ) =  *NULL;

            k1yrn1.pwArse = peArse;
            chain %kds( k1yrn1 : 4 ) pawrn1;

          when %parms >= 5 and %addr( peArse ) <> *NULL
                           and %addr( peOper ) <> *NULL;

            k1yrn1.pwArse = peArse;
            k1yrn1.pwOper = peOper;
            chain %kds( k1yrn1 : 5 ) pawrn1;

          other;

            chain %kds( k1yrn1 : 3 ) pawrn1;

        endsl;
        if %found( pawrn1 );

          if pwMarc <> 'N' and pwMart <> 'N' and pwMarp <> 'N';
            return 'S';
          else;
            return 'N';
          endif;

        endif;

        return *blanks;

      /end-free
     P SVPREN_chkMarcaTecCobRen...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_aumentoSumaAsegurada(): Retorna importe de aumento de *
      *                                suma asegurada por cobertura. *
      *                                                              *
      *          peRama   ( input  )  Rama                           *
      *          peXpro   ( input  )  Código de Producto             *
      *          peRiec   ( input  )  Código de Riesgo               *
      *          peCobc   ( input  )  Código de Cobertura            *
      *          peMone   ( input  )  Código de Moneda de Emisión    *
      *          peSuas   ( input  )  Suma Asegurada por Cobertura   *
      *                                                              *
      * Retorna Importe de aumento de suma asegurada                 *
      * ------------------------------------------------------------ *
     P SVPREN_aumentoSumaAsegurada...
     P                 B                   export
     D SVPREN_aumentoSumaAsegurada...
     D                 pi            15  2
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peSuas                      15  2 const

     D   k1y103        ds                  likerec( s1t103 : *key )
     D   @@Isua        s             15  2
     D   @@Psua        s              2  0

      /free

        SVPREN_inz();

        clear @@Isua;
        clear @@Psua;

        SPGETPSUA( peRama
                 : peXpro
                 : @@Psua );

        if @@Psua = *Zeros;
           return 0;
        endif;

        k1y103.t@Rama = peRama;
        k1y103.t@Xpro = peXpro;
        k1y103.t@Riec = peRiec;
        k1y103.t@Cobc = peCobc;
        k1y103.t@Mone = peMone;
        chain %kds( k1y103 : 5 ) set103;
        if not %found( set103 );
           return 0;
        endif;

        if t@Mar2 = 'S';
          @@Isua = (peSuas * @@Psua ) / 100;
          return @@Isua;
        endif;

        return 0;

      /end-free

     P SVPREN_aumentoSumaAsegurada...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getScoring(): Retorna Datos del Scoring.              *
      *                                                              *
      *     peEmpr  ( input  ) Empresa                               *
      *     peSucu  ( input  ) Sucursal                              *
      *     peArcd  ( input  ) Articulo                              *
      *     peSpol  ( input  ) SuperPoliza                           *
      *     peRama  ( input  ) Rama                                  *
      *     peArse  ( input  ) Arse                                  *
      *     pePoco  ( input  ) Componente                            *
      *     peSspo  ( input  ) Suplemento de SuperPoliza  (Opcional) *
      *     peSuop  ( input  ) Suplemento de la Operación (Opcional) *
      *     peOper  ( input  ) Operación                  (Opcional) *
      *     peTaaj  ( output ) Código de Cuestionario                *
      *     peScor  ( output ) Estructura de Scoring                 *
      *     peScorC ( output ) Cant. de Scoring                      *
      *                                                              *
      * Retorna: *on = Si hay registro / *off = no hay registro      *
      * ------------------------------------------------------------ *
     P SVPREN_getScoring...
     P                 B                   export
     D SVPREN_getScoring...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*nopass:*omit) const
     D   peSuop                       3  0 options(*nopass:*omit) const
     D   peOper                       7  0 options(*nopass:*omit) const
     D   peTaaj                       2  0 options(*nopass:*omit)
     D   peScor                            likeds (preguntas_t) dim(200)
     D                                     options(*nopass:*omit)
     D   peScorC                     10i 0 options(*nopass:*omit)

     D c               s             10i 0
     D i               s             10i 0
     D x               s             10i 0
     D peForm          s              1    inz('S')
     D @@Sspo          s              3  0
     D @@Suop          s              3  0
     D @@Oper          s              7  0
     D @@Dst3          ds                  likeds ( dspahet3_t ) dim( 999 )
     D @@Dst3C         s             10i 0
     D @@DsPr          ds                  likeds( set2371_t ) dim( 200 )
     D @@DsPrc         s             10i 0
     D encontro        s               n

      /free

       SVPREN_inz();

       if not SVPART_chkScoring( peArcd
                               : peRama
                               : peArse );

         SetError( SVPREN_VARCD
                 : 'Articulo no Acepta Scoring' );
         Initialized = *off;
         return *off;
       endif;

       clear peScorC;
       clear @@Sspo;
       clear @@Suop;
       clear @@Oper;

       if SPVVEH_getUltimoSuplemento( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : peRama
                                    : peArse
                                    : pePoco
                                    : @@Sspo
                                    : @@Suop
                                    : @@Oper );
       endif;

       select;
         when %parms >= 10 and %addr( peSspo ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peOper ) <> *null;

           @@Sspo = peSspo;
           @@Suop = peSuop;
           @@Oper = peOper;

         when %parms >= 9 and %addr( peSspo ) <> *null
                          and %addr( peSuop ) <> *null
                          and %addr( peOper ) =  *null;

           @@Sspo = peSspo;
           @@Suop = peSuop;

         when %parms >= 8 and %addr( peSspo ) <> *null
                          and %addr( peSuop ) =  *null
                          and %addr( peOper ) =  *null;

           @@Sspo = peSspo;
       endsl;

       if SPVVEH_getPahet3( peEmpr
                          : peSucu
                          : peArcd
                          : peSpol
                          : peRama
                          : peArse
                          : pePoco
                          : @@Sspo
                          : @@Suop
                          : @@Oper
                          : *omit
                          : *omit
                          : @@Dst3
                          : @@Dst3C
                          : peForm  );

         if not SVPTAB_chkCuestionario( @@Dst3(1).t3Taaj );
           SetError( SPVVEH_VTAAJ
                   : 'Cuestionario no existe' );
           Initialized = *off;
           return *off;
         endif;

         SVPTAB_getPreguntas( @@Dst3(1).t3Taaj
                            : @@DsPr
                            : @@DsPrC
                            : *omit            );

         if @@DsPrC = *zeros;
           SetError( SVPREN_VPREG
                   : 'No existen preguntas para el cuestionario ' +
                     %char(@@Dst3(1).t3Taaj) );
           Initialized = *off;
           return *off;
         endif;
         // mueve codigo de cuestionario que jenny se olvido...
         peTaaj = @@Dst3(1).t3Taaj;

         for x = 1 to @@DsPrC;
           encontro = *off;
           for i = 1 to @@Dst3C;
             if @@DsPr(x).t@Cosg = @@DsT3(i).t3Cosg;
               encontro = *on;
               leave;
             endif;
           endfor;

           peScorC += 1;
           if encontro;
             peScor(peScorC).Cosg = @@DsT3(i).t3Cosg;
             peScor(peScorC).Vefa = @@DsT3(i).t3Vefa;
             peScor(peScorC).Cant = @@DsT3(i).t3Cant;
           else;
             peScor(peScorC).Cosg = @@DsPr(x).t@Cosg;
             peScor(peScorC).Vefa = *blanks;
             peScor(peScorC).Cant = *zeros;
           endif;
         endfor;

         return *on;

       endif;

       return *off;

      /end-free

     P SVPREN_getScoring...
     P                 E

      * ------------------------------------------------------------ *
      * SVPREN_getPlanDePago(): Retorna Plan de Pago                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Numero de Suplemento SuperPoliza      *
      *     peTipo   (input)   Tipo de Solicitud                     *
      *                                                              *
      * Retorna: Si encontro = Plan de Pago / Si no encontro = -1    *
      * ------------------------------------------------------------ *
     P SVPREN_getPlanDePago...
     P                 B                   export
     D SVPREN_getPlanDePago...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peTipo                       1    const
     D   peSspo                       3  0 options(*Omit:*NoPass)

     D   k1y608        ds                  likerec( s1t608 : *key )
     D   k1y60802      ds                  likerec( s1t608 : *key )

     D @@Tipo          s              1
     D @@Sspo          s              3  0
     D @@Cfpg          s              1  0
     D @@Nrpp          s              3  0
     D @@DsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D @@DsD0C         s             10i 0

      /free

        SVPREN_inz();

        if %parms >= 6 and %addr( peSspo ) <> *null;
           peSspo = @@Sspo;
        endif;

        @@Nrpp = -1;
        //Verifica, Tipo de Solicitud
        @@Tipo = peTipo;
        If  @@Tipo <> 'W';
            @@Tipo = 'T';
        EndIf;

        //Recupera SuperPoliza
        clear  @@DsD0;
        clear  @@DsD0C;
        If Not SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsD0
                                        : @@DsD0C );

           SetError( SVPREN_FPNWB
                   : 'Forma de Pago No Habilitada para Renovar Web');
           Return @@Nrpp;
        EndIf;

        //Recupera Forma de Pago
        @@Cfpg = SPVSPO_getFormaDePago(  peEmpr
                                      :  peSucu
                                      :  peArcd
                                      :  peSpol
                                      :  @@Sspo);

        If @@DsD0(@@DsD0C).d0dup2 = 1 and
           @@Cfpg = 4;

           //Web
           If @@Tipo = 'W';
              //Recupera Plan de Pago desde Plan Comercial (Articulo)
              k1y60802.t@Arcd = peArcd;
              Setll %kds( k1y60802 : 1 ) Set60802;
              Reade %kds( k1y60802 : 1 ) Set60802;
                 Dow not %Eof(Set60802);
                     If  t@mar1 = 'S' and
                         t@Cfpg <> 4;
                        //Verifica si Forma de Pago es WEB
                        If SVPVAL_formaDePagoWeb ( t@Cfpg );
                           @@Nrpp = t@Nrpp;
                           leave;
                        Endif;
                     EndIf;
                     Reade %kds( k1y60802 : 1 ) Set60802;
                 Enddo;
           EndIf;

           //Todo
           If @@Tipo = 'T';
              //Recupera Plan de Pago desde Plan Comercial (Articulo)
              k1y608.t@Arcd = peArcd;
              Setll %kds( k1y608 : 1 ) Set608;
              Reade %kds( k1y608 : 1 ) Set608;
                 Dow not %Eof(Set608);
                     If  t@mar1 = 'S' and
                         t@Cfpg <> 4;
                        //Verifica si Forma de Pago es WEB
                        If SVPVAL_formaDePago ( t@Cfpg );
                           @@Nrpp = t@Nrpp;
                           leave;
                        Endif;
                     EndIf;
                     Reade %kds( k1y608 : 1 ) Set608;
                 Enddo;
           EndIf;

        Else;
           //Recupera Plan de Pago
           @@Nrpp = SPVSPO_getCodPlanDePago( peEmpr
                                           : peSucu
                                           : peArcd
                                           : peSpol
                                           : *omit );
        EndIf;

        if @@Nrpp = -1;
           SetError( SVPREN_FPNWB
                   : 'Forma de Pago No Habilitada para Renovar Web');
        endif;
        Return @@Nrpp;

      /end-free

     P SVPREN_getPlanDePago...
     P                 E
      * ------------------------------------------------------------ *
      * SVPREN_chkGeneralWeb(): Validaciones Generales para renovar  *
      *                         desde la WEB                         *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPREN_chkGeneralWeb...
     P                 B                   export
     D SVPREN_chkGeneralWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

     D @@erro          ds                  likeDs(dsErro_t) dim(20)
     D $$erro          ds                  likeDs(dsErro_t) dim(20)
     D @@erroC         s             10i 0
     D $$erroC         s             10i 0
     D @@civa          s              2  0

     D x               s             10i 0
     D rc              s               n

       SVPREN_inz();

       clear @@erro;
       @@erroC = *Zeros;

       rc = SVPREN_chkGeneral( peEmpr
                             : peSucu
                             : peArcd
                             : peSpol
                             : @@erro
                             : @@erroc);

       if not COWGRAI_chkPlandePagoHabWeb( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : *omit  );
         @@erroC += 1;
         @@erro( @@erroC ).errM = 'Plan no habilitado para la Web';
         @@erro( @@erroC ).errN = SVPREN_PLNWB;
       endif;

       if not SVPVAL_ivaWeb ( SPVSPO_getCodigoIva ( peEmpr
                                                  : peSucu
                                                  : peArcd
                                                  : peSpol ) );

           @@erroC += 1;
           @@erro( @@erroC ).errM = 'Condicion de Iva no habilitada para Web';
           @@erro( @@erroC ).errN = SVPREN_IVANW;
       endif;

       if not SVPVAL_formaDePagoWeb( SPVSPO_getFormaDePago( peEmpr
                                                          : peSucu
                                                          : peArcd
                                                          : peSpol
                                                          : *omit  ) );
            @@erroC += 1;
            @@erro( @@erroC ).errM = 'Forma de pago no habilitada para la Web';
            @@erro( @@erroC ).errN = SVPREN_FDPNW;

       endif;

       if %parms >= 5 and %addr( peErro ) <> *Null;
         peErro = @@erro;
       endif;

       if %parms >= 6 and %addr( peErroC ) <> *Null;
         peErroC = @@erroC;
       endif;

       if @@erroC <> *Zeros;
         SetError( @@erro( 1 ).errN
                 : @@erro( 1 ).errM);
         return *Off;
       endif;

       return *On;

     P SVPREN_chkGeneralWeb...
     P                 E

