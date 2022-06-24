     H nomain
     H alwnull(*usrctl)
     H option(*nodebugio : *srcstmt : *noshowcpy : *nounref)
      * ************************************************************ *
      * SPVVEH: Programa de Servicio.                                *
      *         Validacion de Autos.                                 *
      * ------------------------------------------------------------ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                <*
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*
      *>           DBGVIEW(&DV)                         <*
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*
      *>           MODULE(QTEMP/&N) -                   <*
      *>           EXPORT(*SRCFILE) -                   <*
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*
      *> TEXT('Programa de Servicio: Envío de mails')   <*
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     14-Jun-2013             *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 11/09/13: Se agregan los procedimientos: - CheckTarDif   *
      *                                              - CheckCobCPlus2*
      *               No utilizar el procedimiento CheckCobCPlus     *
      *               Se modifica el procedimiento CheckCodRelacion  *
      * SFA 25/09/13: Se agregan los procedimientos: - CheckRcAir2   *
      *               No utilizar el procedimiento CheckRcAir        *
      * SGF 13/12/13: Agrego:                                        *
      *               SPVVEH_getSumaMinima()                         *
      *               SPVVEH_getSumaMaxima()                         *
      *               SPVVEH_chkSumaMinima()                         *
      *               SPVVEH_chkSumaMaxima()                         *
      * SGF 16/12/13: Corrección loop sobre set219.                  *
      * SFA 26/12/13: Corrección SPVVEH_inz() y SPVVEH_end()         *
      * SMA 10/07/14  Se crea el procedimiento SPVVEH_chkCoberturaA  *
      * SFA 14/07/14: Agrego SPVVEH_chkRamaCapitulo()                *
      * SFA 05/12/14: Agrego SPVVEH_chkRamaCobertura()               *
      *                      SPVVEH_chkArticuloCobertura()           *
      *                      SPVVEH_CheckArcd1006()                  *
      * SFA 15/12/14: Agrego SPVVEH_CheckArcd1006Gral()              *
      * SFA 27/11/14: Agrego procedimientos de Pautas                *
      * SFA 13/02/15: Se modifica SPVVEH_CheckArcd1006Gral()         *
      * SFA 18/03/15: Agrego SPVVEH_getCodInfoautos                  *
      * NGF 10/08/15: Agrego SPVVEH_getMinMaxSuma()                  *
      * LRG 04/09/15: Agrego SPVVEH_getRastreador()                  *
      * JCB 10/08/15: Agrego SPVVEH_getClasificacion()               *
      *                      SPVVEH_getTipoVehiculo()                *
      *                      SPVVEH_getCarroceria()                  *
      * LRG 25/11/15: se recompila por cambio en archivo DBA22531    *
     * NWN 13/06/16: Se crea una nueva version del procedimiento    *
     *               SPVVEH_getCodInfoautos = SPVVEH_getCodInfoauto1*
     *               Se cambia el archivo TAUTOS* por IAUTOS*.      *
      * LRG 28/06/16: Agrego SPVVEH_getAÑoVehiculo()                 *
      * LRG 08/09/16: Se modifica SPVVEH_getSumaMovAut si no         *
      *               encuentra suma maxima = *all'9'                *
      * LRG 28/06/16: Agrego SPVVEH_getCodDeRastreador();            *
      * LRG 21/12/2016: Se agregan Coberturas de auto D4-D5-D6-D7    *
      *                 dentro del procedimiento                     *
      *                 SPVVEH_GetImpFranquicia                      *
      * LRG 24/10/2017: Se agregan nuevos procedimientos:            *
      *                 SPVVEH_chkVehiculo0km                        *
      *                 SPVVEH_getValor0km                           *
      *                 SPVVEH_chkAÑoVehiculo                        *
      * EXT 21/09/2018: Agrego _confirmarInspeccion()                *
      *                 _vehiculo0Km()                               *
      *                 _getInspector()                              *
      *                 _getInspectorWeb()                           *
      * JSN 18/01/2019: Se agregan nuevos procedimientos:            *
      *                 _getLimiteMaximoRuedasCristales              *
      *                 _getLimiteMaximoRuedas                       *
      *                 _getLimiteMaximoCristales                    *
      *                 _getCodEquixCodDesRec                        *
      *                 _getCodDesRecxCodEqui                        *
      *                 _getListaDescuentoRecargo                    *
      * JSN 28/08/2019: Se agrega nuevo procedimiento:               *
      *                 _getRastreadorXSpol                          *
      * NWN 06/11/2019: Se agrega nuevo procedimiento:               *
      *                 _chkSeguroRegistro                           *
      * JSN 05/09/2019: Se agregan nuevos procedimientos:            *
      *                 SPVVEH_getPahet3                             *
      *                 SPVVEH_chkPahet3                             *
      * JSN 10/09/2019: Se agrega nuevo procedimiento:               *
      *                 SPVVEH_getUltimoSuplemento                   *
      * JSN 20/09/2019: Se agrega nuevo procedimiento:               *
      *                 _validaPreguntas                             *
      * JSN 26/09/2019: Se agrega nuevo Procedimiento:               *
      *                 _aplicaScoring                               *
      * JSN 07/10/2019: Se agrega nuevo Procedimiento:               *
      *                 _validaScoringEmision                        *
      *                 _chkScoringEnCotizacion                      *
      * JSN 20/01/2019: Se agrega nuevos procedimientos:             *
      *                 _getPahet1                                   *
      *                 _setPahet1                                   *
      *                 _setPahet3                                   *
      *                 _setPahet4                                   *
      *                 _getPahet5                                   *
      *                 _setPahet5                                   *
      *                 _getPahet6                                   *
      *                 _setPahet6                                   *
      *                 _setPahet9                                   *
      *                 _setPahet0                                   *
      * JSN 04/03/2020: Se agrega el procedimiento:                  *
      * LRG 04/03/2020: _getAÑoVehUsado                              *
      *                 _getValorUsado                               *
      *                 _chk0km2aÑos                                 *
      *                 _chkModuloDescRec                            *
      *                 _calcDescRecSpol                             *
      *                 _chkVehiculo0kmSpol                          *
      *                 _chkDescuentoReno                            *
      *                 _chkCoberturaDesc                            *
      *                 _getConvSumaAsegurada                        *
      *                 _calcSumaAsegurada                           *
      *                 _getRangoCapitales                           *
      *                 _calcDescRecSpol                             *
      *                 _chkPahet4                                   *
      *                 _calcPrimaAnual                              *
      *                 _calcPrimaPeriodo                            *
      *                 _getPahet4                                   *
      *                 _getUltimoSuop                               *
      *                 _getListaPahet9                              *
      *                 _aplicaRevScoring                            *
      *                 _getPrimasAcumu                              *
      *                                                              *
      * SPV 27/03/2020: Cambia lectura de archivo SET220 por SET2202 *
      *                                                              *
      * LRG 05/05/2020: Se agrega nuevo procedimiento:               *
      *                 _SPVVEH_getLimitesRC                         *
      * SGF 17/07/2020: Descuento decreciente.                       *
      * SGF 27/01/2022: Agrego _chkLocalidadZo().                    *
      *                                                              *
      * VCM 07/03/2022 Se agrega nuevo procedimiento:                *
      *                _getUltimoEstadoComponente                    *
      * ************************************************************ *
     Fset201    if   e           k disk    usropn
     Fset202    if   e           k disk    usropn
     Fset203    if   e           k disk    usropn
     Fset204    if   e           k disk    usropn
     Fset205    if   e           k disk    usropn
     Fset206    if   e           k disk    usropn
     Fset207    if   e           k disk    usropn
     Fset208    if   e           k disk    usropn
     Fset210    if   e           k disk    usropn prefix(ta:2)
     Fset211    if   e           k disk    usropn prefix(t2:2)
     Fset215    if   e           k disk    usropn
     Fset220    if   e           k disk    usropn
     Fset2201   if   e           k disk    usropn
     Fset2202   if   e           k disk    usropn
     Fset221    if   e           k disk    usropn
     Fset2211   if   e           k disk    usropn
     Fset2221   if   e           k disk    usropn
     Fset2222   if   e           k disk    usropn
     Fset225    if   e           k disk    usropn
     Fset625    if   e           k disk    usropn
     Fset901    if   e           k disk    usropn prefix(t3:2)
     Fsetpat01  if   e           k disk    usropn
     Fgnhda102  if   e           k disk    usropn
     Fsetfpa01  if   e           k disk    usropn
     Fpahet9    if a e           k disk    usropn
     Fpahet911  if   e           k disk    usropn rename(p1het9:p1het911)
     Fpahed004  if   e           k disk    usropn
     Fsehase    if   e           k disk    usropn
     Fset219    if   e           k disk    usropn prefix(tx:2)
     Fset242    if   e           k disk    usropn prefix(tt:2)
     Fset6251   if   e           k disk    usropn
     Fpahet0    if a e           k disk    usropn
     Fpahet004  if   e           k disk    usropn
     Fset225303 if   e           k disk    usropn
     Fset22531  if   e           k disk    usropn
     Ftautos    if   e           k disk    usropn
     Fiautos    if   e           k disk    usropn
     Fset239    if   e           k disk    usropn prefix(tb:2)
     Fset20001  if   e           k disk    usropn
     Fset225311 if   e           k disk    usropn   rename( s1t22531: s1t225311)
     Fset22532  uf a e           k disk    usropn prefix( t5 : 2 )
     Fset155    if   e           k disk    usropn
     Fpahet1    if a e           k disk    usropn
     Fset243    if   e           k disk    usropn prefix( t6 : 2 )
     Fpahet4    if a e           k disk    usropn
     Fset276    if   e           k disk    usropn prefix( ti : 2 )
     Fset271    if   e           k disk    usropn prefix( t7 : 2 )
     Fpahet406  if   e           k disk    usropn
     Fpahet402  if   e           k disk    usropn rename(p1het4:p1het402)
     Fpahet301  if a e           k disk    usropn
     Fpahet302  if   e           k disk    usropn rename(p1het3:p1het302)
     Fpahet5    if a e           k disk    usropn
     Fpahet6    if a e           k disk    usropn
     Fset228    if   e           k disk    usropn
     Fset250    if   e           k disk    usropn
     Fset227    if   e           k disk    usropn
     Fset2272   if   e           k disk    usropn
     Fset285    if   e           k disk    usropn prefix(t8_)
     Fgntloc    if   e           k disk    usropn
     Fpahet002  if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/spvveh_h.rpgle'

      *--- DS Registros -------------------------------------------- *
     D rec204          ds                  likeds(@@@204)
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrCode         s             10i 0
     D ErrText         s             80a

      *--- Initialized --------------------------------------------- *
     D Initialized     s              1N   inz(*OFF)

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

      *--- PR Internos --------------------------------------------- *
     D getInspector    pr            10i 0
     D   peCopo                       5  0 Const
     D   peCops                       1  0 Const
     D   peTipo                       1    Const
     D   peNomb                      40    Dim( 99 )

      *--- PR Externos --------------------------------------------- *
     D SP0082          pr                  extpgm('SP0082')
     D    Arcd                        6  0 const
     D    Spol                        9  0 const
     D    Nmat                       25    const
     D    fech                        8  0 const
     D    erro                        1
     D    erro                        1
     D    empr                        1    options(*nopass:*omit)    const
     D    sucu                        2    options(*nopass:*omit)    const
     D    poco                        4  0 options(*nopass:*omit)    const
     D   oarcd                        6  0 options(*nopass:*omit)
     D   ospol                        9  0 options(*nopass:*omit)
     D   orama                        2  0 options(*nopass:*omit)
     D   opoli                        7  0 options(*nopass:*omit)
     D   opoco                        4  0 options(*nopass:*omit)
     D   ofech                        8  0 options(*nopass:*omit)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D    Empr                        1    const
     D    @aÑo                        4  0
     D    @mes                        2  0
     D    @dia                        2  0

     D SPCPLUS         pr                  extpgm('SPCPLUS')
     D    Vhca                        2  0 const
     D    Scta                        1  0 const
     D    Vhuv                        2  0 const
     D    Mtdf                        1a   const
     D    ok                           n
     D    Ctre                        5  0 const

     D SPFMTPAT        pr                  extpgm('SPFMTPAT')
     D    empr                        1    const
     D    sucu                        2    const
     D    Nmat                       25    const
     D    pvigh                        d   datfmt(*ymd)
     D    tipval                      1
     D    cuso                        1
     D    Tmat                        3    const
     D    vald                        1
     D    fmtp                        7

     D SPIFRA          pr                  extpgm('SPIFRA')
     D    Cobl                        2    const
     D    Ifra                       15p 2 const
     D    erro                        1

     D SPRUTA          pr                  extpgm('SPRUTA')
     D    Arcd                        6  0 const
     D    Spol                        9  0 const
     D    Sspo                        3  0 const
     D    Rama                        2  0 const
     D    Arse                        2  0 const
     D    Oper                        7  0 const
     D    Suop                        3  0 const
     D    Ruta                       16  0 const
     D    Asen                        7  0 const
     D    Vhca                        2  0 const
     D    Vhuv                        2  0 const
     D    Fdes                        8  0 const
     D    reto                        2  0
     D    endp                        3a

     D SP0004          pr                  extpgm('SP0004')
     D    Vhmc                        3    const
     D    Vhmo                        3    const
     D    Vhcs                        3    const
     D    vehi                       40
     D    erro                        1
     D    vhmd                       15
     D    vhdm                       15
     D    vhds                       10

     D SPTRCAIR        pr                  extpgm('SPTRCAIR')
     D    Ctre                        5  0 const
     D    Scta                        1  0 const
     D    Como                        2    const
     D    Vhca                        2  0 const
     D    Vhv1                        1  0 const
     D    Vhv2                        1  0 const
     D    Tarc                        2  0
     D    Tair                        2  0
     D    Femi                        8  0 const
     D    Marc                        1    options(*nopass:*omit)

     D SPDESCG         pr                  extpgm('SPDESCG')
     D    Arcd                        6  0 const
     D    Spol                        9  0 const
     D    Sspo                        3  0 const
     D    Rama                        2  0 const
     D    Arse                        2  0 const
     D    Oper                        7  0 const
     D    Suop                        3  0 const
     D    Poco                        4  0 const
     D    rror                        1n
     D    Marc                        1    const

     D SPDETFRA        pr                  ExtPgm('SPDETFRA')
     D                                6  0 const
     D                                9  0 const
     D                                2  0 const
     D                                2  0 const
     D                                7  0 const
     D                                4  0 const
     D                                1
     D                               15p 2

     D PAR651H         pr                  ExtPgm('PAR651H')
     D                                1
     D                                2
     D                                6  0
     D                                9  0
     D                                2
     D                                2

     D SP0018          pr                  extpgm('SP0018')
     D  @@mon1                        2    const
     D  @@mon2                        2    const
     D  @@vh0k                       15  2 const
     D  @@vhvu                       15  2 const
     D  @@erro                        1    const

     D SPT224          pr                  extpgm('SPT224')
     D  Ds224                              likeds  ( dsSet224_t ) const
     D  @in20                         1
     D  endpgm                        2    const

     D PAR313G         pr                  extpgm('PAR313G')
     D  p@cobl                        2    const
     D  p@vhvu                       15  2 const
     D  p@vh0k                       15  2 const
     D  p@vacc                       15  0 const
     D  p@claj                        3  0 const
     D  p@rebr                        1  0 const
     D  p@cfas                        1    const
     D  p@tarc                        2  0 const
     D  p@tair                        2  0 const
     D  p@scta                        1  0 const
     D  p@vhca                        2  0 const
     D  p@vhv1                        1  0 const
     D  p@vhv2                        1  0 const
     D  p@vhaÑ                        4  0 const
     D  p@vhni                        1    const
     D  p@vhct                        2  0 const
     D  p@vhuv                        2  0 const
     D  p@mone                        2    const
     D  @@ncoc                        5  0 const
     D  @@mar1                        1    const
     D  @@mar2                        1    const
     D  @@alldesc                     5  2 const
     D  es_0km                         n   const
     D  p@fvid                        8  0 const
     D  p@prrc                       15  2
     D  p@prac                       15  2
     D  p@prin                       15  2
     D  p@prro                       15  2
     D  p@pacc                       15  2
     D  p@praa                       15  2
     D  p@prsf                       15  2
     D  p@prce                       15  2
     D  p@prap                       15  2
     D  p@rcle                       15  2
     D  p@rcco                       15  2
     D  p@rcac                       15  2
     D  p@lrce                       15  2
     D  p@saap                       15  2
     D  @@sumdesc                     5  2
     D  p@ctre                        5  0 const
     D  p@mtdf                        1    const

     D PAX011          pr                  ExtPgm('PAX011')
     D  peTipo                        1    const
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  pePoco                        4  0 const
     D  peNmat                       25    const
     D  peAInf                        4  0
     D  pe0kms                         n
     D  peDel0Km2a                     n

      *---------------------------------------------------------------*
      * "SPDETDES" determina si está activo el módulo de Desc/Recargos*
      *---------------------------------------------------------------*
     Dspdetdes         pr                  extpgm('SPDETDES')
     D empr                           1    const
     D sucu                           2    const
     D arcd                           6  0 const
     D spol                           9  0 const
     D sspo                           3  0 const
     D rama                           2  0 const
     D poco                           4  0 const
     D ctrol                          1n
     D fpgm                           3a

     D SP0001          pr                  extpgm('SP0001')
     D   parf                         8  0
     D   parm                         2  0
     D   fpgm                         3a

     D SPVIG3          pr                  ExtPgm('SPVIG3')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  pePoco                        4  0 const
     D  peFvig                        8  0 const
     D  peFemi                        8  0 const
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3    const
     D  peSpvig2                      1n   options(*nopass) const

     d lda             ds                  dtaara(*lda) qualified
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

     D  empr           s              1    inz('A')
     D  sucu           s              2    inz('CA')

     Ip1het3
     I              t3date                      x@date
     Ip1het302
     I              t3date                      e@date
     Is1t2202
     I              t@date                      z@date
     Is1t2272
     I              t@date                      z@date

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SPVVEH_CheckMarca(): Chequea Marca de Vehiculo               *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckMarca...
     P                 B                   export
     D SPVVEH_CheckMarca...
     D                 pi             1n
     D   peVhmc                       3    const

      /free

       SPVVEH_Inz();

       chain peVhmc set201;

       if not %found;
         SetError( SPVVEH_VMCNF
                 : 'Marca Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *ON;

      /end-free

     P SPVVEH_CheckMarca...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckMod(): Chequea Modelo de Vehiculo                *
      *                                                              *
      *     peVhmo   (input)   Modelo                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckMod...
     P                 B                   export
     D SPVVEH_CheckMod...
     D                 pi             1n
     D   peVhmo                       3    const

      /free

       SPVVEH_Inz();

       chain peVhmo set202;

       if not %found;
         SetError( SPVVEH_VMONF
                 : 'Modelo Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckMod...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckSubMod(): Chequea SubModelo de Vehiculo          *
      *                                                              *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckSubMod...
     P                 B                   export
     D SPVVEH_CheckSubMod...
     D                 pi             1n
     D   peVhcs                       3    const

      /free

       SPVVEH_Inz();

       chain peVhcs set203;

       if not %found;
         SetError( SPVVEH_VCSNF
                 : 'SubModelo Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckSubMod...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckVeh(): Chequea Existencia de Vehiculo            *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peVhcs   (Output)  Registro de Vehiculo                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckVeh...
     P                 B                   export
     D SPVVEH_CheckVeh...
     D                 pi             1n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVehr                            likeds(@@@204)options(*nopass:*omit)

     D k1s204          ds                  likerec(s1t204:*key)

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckMarca( peVhmc );
         Initialized = *OFF;
         return *off;
       endif;

       if not SPVVEH_CheckMod( peVhmo );
         Initialized = *OFF;
         return *off;
       endif;

       if not SPVVEH_CheckSubMod( peVhcs );
         Initialized = *OFF;
         return *off;
       endif;

       k1s204.t@vhmc = peVhmc;
       k1s204.t@vhmo = peVhmo;
       k1s204.t@vhcs = peVhcs;
       chain %kds(k1s204) set204;

       if not %found;
         SetError( SPVVEH_VVONF
                 : 'Vehiculo no Encontrado' );
         Initialized = *OFF;
         return *off;
       endif;

       if %parms >= 4 and %addr(peVehr) <> *null;
         peVehr.t@vhmc = t@vhmc;
         peVehr.t@vhmo = t@vhmo;
         peVehr.t@vhcs = t@vhcs;
         peVehr.t@vhmd = t@vhmd;
         peVehr.t@vhdm = t@vhdm;
         peVehr.t@vhds = t@vhds;
         peVehr.t@vhca = t@vhca;
         peVehr.t@vhv1 = t@vhv1;
         peVehr.t@vhv2 = t@vhv2;
         peVehr.t@vhct = t@vhct;
         peVehr.t@vhcr = t@vhcr;
         peVehr.t@vhni = t@vhni;
         peVehr.t@vhma = t@vhma;
         peVehr.t@vhml = t@vhml;
         peVehr.t@vhms = t@vhms;
         peVehr.t@cmar = t@cmar;
         peVehr.t@cmod = t@cmod;
         peVehr.t@vhcb = t@vhcb;
         peVehr.t@vhff = t@vhff;
         peVehr.t@vhpe = t@vhpe;
         peVehr.t@mar1 = t@mar1;
         peVehr.t@mar2 = t@mar2;
         peVehr.t@mar3 = t@mar3;
         peVehr.t@mar4 = t@mar4;
         peVehr.t@mar5 = t@mar5;
         peVehr.t@cgru = t@cgru;
       endif;
       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckVeh...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_GetDescripcion(): Retorna la Descripcion del Vehiculo *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peVhmd   (output)  Descripcion Marca                     *
      *     peVhdm   (output)  Descripcion Modelo                    *
      *     peVhds   (output)  Descripcion SubModelo                 *
      *                                                              *
      * Retorna: Descripcion del Vehiculo o Blanks por Error         *
      *          peVhmd, peVhdm, y peVhds si se Pasan Como Parametro *
      * ------------------------------------------------------------ *

     P SPVVEH_GetDescripcion...
     P                 B                   export
     D SPVVEH_GetDescripcion...
     D                 pi            40
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhmd                      15    options(*nopass:*omit)
     D   peVhdm                      15    options(*nopass:*omit)
     D   peVhds                      10    options(*nopass:*omit)

     D @@vehi          s             40
     D @error          s              1

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckVeh( peVhmc
                             : peVhmo
                             : peVhcs );
         Initialized = *OFF;
         return *blanks;
       endif;

       SP0004( peVhmc
             : peVhmo
             : peVhcs
             : @@vehi
             : @error
             : t@vhmd
             : t@vhdm
             : t@vhds );

       if %parms >= 4 and %addr(peVhmd) <> *null;
         peVhmd = t@vhmd;
       endif;
       if %parms >= 5 and %addr(peVhdm) <> *null;
         peVhdm = t@vhdm;
       endif;
       if %parms >= 6 and %addr(peVhds) <> *null;
         peVhds = t@vhds;
       endif;

       Initialized = *OFF;
       return @@vehi;

      /end-free

     P SPVVEH_GetDescripcion...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAÑoIn(): Chequea Año Ingresado del Vehiculo      *
      *                                                              *
      *     peVhaÑ   (input)   Año                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckAÑoIn...
     P                 B                   export
     D SPVVEH_CheckAÑoIn...
     D                 pi             1n
     D   peVhaÑ                       4  0 const

      /free

       SPVVEH_Inz();

       if peVhaÑ = *zeros;
         SetError( SPVVEH_VAVNF
                 : 'Año de Vehiculo Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckAÑoIn...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRangoAÑos(): Cheque Existencia en Tabla 625 y    *
      *                          Retorna Rango de Años si Solicita   *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peFdes   (Output)  Año Desde                             *
      *     peFhas   (Output)  Año Hasta                             *
      *                                                              *
      * Retorna: *On - Año Desde y Hasta - / *Off                    *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckRangoAÑos...
     P                 B                   export
     D SPVVEH_CheckRangoAÑos...
     D                 pi             1n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peFdes                       4  0 options(*nopass:*omit)
     D   peFhas                       4  0 options(*nopass:*omit)

     D k1t625          ds                  likerec(s1t625:*key)

      /free

       SPVVEH_Inz();

       k1t625.t@arcd = peArcd;
       k1t625.t@rama = peRama;
       k1t625.t@arse = peArse;
       chain %kds(k1t625) set625;

       if not %found;
         if %parms >= 4 and %addr(peFdes) <> *null;
           peFdes = *zeros;
         endif;
         if %parms >= 5 and %addr(peFhas) <> *null;
           peFhas = *zeros;
         endif;
         SetError( SPVVEH_VAENF
                 : 'Articulo: Extencion Rama Autos Invalida' );
         Initialized = *OFF;
         return *off;
       else;
         if %parms >= 4 and %addr(peFdes) <> *null;
           peFdes = t@aÑo1;
         endif;
         if %parms >= 5 and %addr(peFhas) <> *null;
           peFhas = t@aÑo2;
         endif;
         Initialized = *OFF;
         return *on;
       endif;

      /end-free

     P SPVVEH_CheckRangoAÑos...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAÑo(): Chequea Año del Vehiculo                  *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peVhaÑ   (input)   Fecha de Vehiculo                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckAÑo...
     P                 B                   export
     D SPVVEH_CheckAÑo...
     D                 pi             1n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peVhaÑ                       4  0 const

     D @@Fdes          s              4  0
     D @@Fhas          s              4  0

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckAÑoIn( peVhaÑ );
         Initialized = *OFF;
         return *off;
       endif;

       if not SPVVEH_CheckRangoAÑos( peArcd
                                   : peRama
                                   : peArse
                                   : @@Fdes
                                   : @@Fhas );
         Initialized = *OFF;
         return *off;
       endif;

       if peVhaÑ < @@Fdes or peVhaÑ > @@Fhas;
         SetError( SPVVEH_VAVFR
                 : 'Año de Vehiculo Fuera de Rango' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckAÑo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCarroceria(): Chequea Carroceria de Vehiculo     *
      *                                                              *
      *     peVhcr   (input)   Carroceria                            *
      *     peVhcd   (output)  Descripcion Carroceria                *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Carroceria si Recibe el *
      *          Parametro peVhcd                                    *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCarroceria...
     P                 B                   export
     D SPVVEH_CheckCarroceria...
     D                 pi             1n
     D   peVhcr                       3    const
     D   peVhcd                      15    options(*nopass:*omit)

      /free

       SPVVEH_Inz();

       chain peVhcr set205;

       if not %found;
         if %parms >= 2 and %addr(peVhcd) <> *null;
           peVhcd = *blanks;
         endif;
         SetError( SPVVEH_VCRNF
                 : 'Carroceria Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       if %parms >= 2 and %addr(peVhcd) <> *null;
         peVhcd = t@vhcd;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCarroceria...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodUso(): Chequea Codigo de Uso de Vehiculo      *
      *                                                              *
      *     peVhuv   (input)   Codigo de Uso                         *
      *     peVhdu   (output)  Descripcion Codigo de Uso             *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Codigo de Uso si Recibe *
      *          Parametro peVhdu                                    *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodUso...
     P                 B                   export
     D SPVVEH_CheckCodUso...
     D                 pi             1n
     D   peVhuv                       2  0 const
     D   peVhdu                      15    options(*nopass:*omit)

      /free

       SPVVEH_Inz();

       chain peVhuv set211;

       if not %found;
         if %parms >= 2 and %addr(peVhdu) <> *null;
           peVhdu = *blanks;
         endif;
         SetError( SPVVEH_VUVNF
                 : 'Codigo de Uso Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       if %parms >= 2 and %addr(peVhdu) <> *null;
         peVhdu = t2vhdu;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodUso...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckOrigen(): Chequea Origen del Vehiculo            *
      *                                                              *
      *     peVhni   (input)   Origen del Vehiculo                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckOrigen...
     P                 B                   export
     D SPVVEH_CheckOrigen...
     D                 pi             1n
     D   peVhni                       1    const

     D @@vhni          s              1

      /free

       SPVVEH_Inz();

       if peVhni <> 'I' and peVhni <> 'N';
         SetError( SPVVEH_VNINF
                 : 'Codigo de Origen Ivalido' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckOrigen...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCapVar(): Chequea Capitulo/Variante              *
      *                                                              *
      *     peVhca   (input)   Capitulo del Vehiculo                 *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peCvde   (output)  Descripcion de Capitulo               *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Capitulo si Recibe      *
      *          Parametro peCvde                                    *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCapVar...
     P                 B                   export
     D SPVVEH_CheckCapVar...
     D                 pi             1n
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peCvde                      20    options(*nopass:*omit)

     D k1s215          ds                  likerec(s1t215:*key)

      /free

       SPVVEH_Inz();

       k1s215.t@vhca = peVhca;
       k1s215.t@vhv1 = peVhv1;
       k1s215.t@vhv2 = peVhv2;
       chain %kds(k1s215) set215;

       if not %found;
         if %parms >= 4 and %addr(peCvde) <> *null;
           peCvde = *blanks;
         endif;
         SetError( SPVVEH_VCPNF
                 : 'Capitulo Variante Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       if %parms >= 4 and %addr(peCvde) <> *null;
         peCvde = t@cvde;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCapVar...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTipoVeh(): Chequea Tipo de vehiculo              *
      *                                                              *
      *     peVhct   (input)   Tipo del Vehiculo                     *
      *     peVhdt   (output)  Descripcion Tipo del Vehiculo         *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Tipo de Vehiculo si     *
      *          Recibe Parametro peVhdt                             *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckTipoVeh...
     P                 B                   export
     D SPVVEH_CheckTipoVeh...
     D                 pi             1n
     D   peVhct                       2  0 const
     D   peVhdt                      15    options(*nopass:*omit)

      /free

       SPVVEH_Inz();

       chain peVhct set210;

       if not %found;
         if %parms >= 2 and %addr(peVhdt) <> *null;
          peVhdt = *blanks;
         endif;
         SetError( SPVVEH_VCTNF
                 : 'Tipo Vehiculo Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       if %parms >= 2 and %addr(peVhdt) <> *null;
         peVhdt = tavhdt;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckTipoVeh...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckValorUsado(): Chequea Valor del Vehiculo Usado   *
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *     peVhvu   (input)   Valor del Vehiculo Usado              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckValorUsado...
     P                 B                   export
     D SPVVEH_CheckValorUsado...
     D                 pi             1n
     D   peCobl                       2    const
     D   peVhvu                      15  2 const

     D @@coss          s              2

      /free

       SPVVEH_Inz();

       if SPVVEH_CheckCobertura( peCobl );
         @@coss = SPVVEH_GetCobEquivalente( peCobl );
         if peVhvu  = *zeros and @@coss <> 'A ';
           SetError( SPVVEH_VVUNF
                   : 'Valor de Usado Invalido' );
           Initialized = *OFF;
           return *off;
         endif;
       else;
         if peVhvu  = *zeros;
           SetError( SPVVEH_VVUNF
                   : 'Valor de Usado Invalido' );
         endif;
           Initialized = *OFF;
           return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckValorUsado...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTipoPatente(): Chequea Tipo de patente           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peTmat   (input)   Tipo de Patente                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckTipoPatente...
     P                 B                   export
     D SPVVEH_CheckTipoPatente...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTmat                       3    const

     D k1tpat          ds                  likerec(s1tpat:*key)

      /free

       SPVVEH_Inz();

       k1tpat.ptempr = peEmpr;
       k1tpat.ptsucu = peSucu;
       k1tpat.ptmcod = peTmat;
       chain %kds(k1tpat) setpat01;

       if not %found;
         SetError( SPVVEH_VANNF
                 : 'Tipo de Patente Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckTipoPatente...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckFmtPatente(): Chequea Formato de Patente         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNmat   (input)   Nro. de Patente                       *
      *     peTmat   (input)   Tipo de Patente                       *
      *     peVald   (Output)  Validar Duplicada                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckFmtPatente...
     P                 B                   export
     D SPVVEH_CheckFmtPatente...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peTmat                       3    const
     D   peVald                       1    options(*nopass:*omit)

     D p_pmvigh        s               d   datfmt(*ymd)
     D p_tipval        s              1
     D p_vald          s              1
     D p_cuso          s              1
     D p_rtnfmtpat     s              7
     D @aÑo            s              4  0
     D @mes            s              2  0
     D @dia            s              2  0

      /free

       SPVVEH_Inz();

       clear p_tipval;
       clear p_cuso;
       clear p_vald;
       p_tipval = '1';
       p_cuso = 'A';

       PAR310X3( peEmpr
               : @aÑo
               : @mes
               : @dia );

       monitor;
          p_pmvigh = %date( (@aÑo * 10000)
                           +(@mes * 100)
                           + @dia
                          : *iso );
          on-error;
           SetError( SPVVEH_VATNF
                   : 'Formato de Patente Invalido' );
           Initialized = *OFF;
           return *OFF;
       endmon;

       SPFMTPAT( peEmpr
               : peSucu
               : peNmat
               : p_pmvigh
               : p_tipval
               : p_cuso
               : peTmat
               : p_vald
               : p_rtnfmtpat );

       if p_rtnfmtpat <> 'OK';
           SetError( SPVVEH_VATNF
                   : 'Formato de Patente Invalido' );
           if %parms >= 5 and %addr(peVald) <> *null;
             peVald = *blanks;
           endif;
           Initialized = *OFF;
           return *off;
       endif;

       if %parms >= 5 and %addr(peVald) <> *null;
         peVald = p_vald;
       endif;
       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckFmtPatente...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPatenteDupli(): Chequea Patente Duplicada        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peNmat   (input)   Nro. de Patente                       *
      *     peCopo   (input)   Componente                            *
      *     peFech   (input)   Fecha                                 *
      *     pePadu   (Output)  Registro con Patente Duplicada        *
      *                                                              *
      * Retorna: *On Si la Patente es Duplicada                      *
      *          *Off Si la Patente No es Duplicada                  *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckPatenteDupli...
     P                 B                   export
     D SPVVEH_CheckPatenteDupli...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNmat                      25    const
     D   pePoco                       4  0 const
     D   peFech                       8  0 options(*nopass:*omit)
     D   pePadu                            likeds(patdup)options(*nopass:*omit)

     D @@err1          s              1
     D @@err2          s              1
     D @@Empr          s              1
     D @@Sucu          s              2
     D @@poco          s              4  0
     D @@Fech          s              8  0
     D @oarcd          s              6  0
     D @ospol          s              9  0
     D @orama          s              2  0
     D @opoli          s              7  0
     D @opoco          s              4  0
     D @ofech          s              8  0

      /free

       SPVVEH_Inz();

       @@empr = peEmpr;
       @@sucu = peSucu;

       if %parms >= 7 and %addr(peFech) <> *null;
         @@Fech=peFech;
       else;
         @@Fech=*day*1000000+*month*10000+*year;
       endif;

       @@poco = pePoco;
       select;
       when %parms >= 8 and %addr(pePadu) <> *null;
         SP0082( peArcd
               : peSpol
               : peNmat
               : @@Fech
               : @@err1
               : @@err2
               : @@Empr
               : @@Sucu
               : @@Poco
               : @oarcd
               : @ospol
               : @orama
               : @opoli
               : @opoco
               : @ofech );
         if @@err1 = *blanks and @@err2 = *blanks;
           pePadu.duarcd = @oarcd;
           pePadu.duspol = @ospol;
           pePadu.durama = @orama;
           pePadu.dupoco = @opoco;
           pePadu.dupoli = @opoli;
           pePadu.duhast = @ofech;
           Initialized = *OFF;
           return *off;
         endif;
       other;
         SP0082( peArcd
               : peSpol
               : peNmat
               : @@Fech
               : @@err1
               : @@err2
               : @@Empr
               : @@Sucu
               : @@Poco );
         if @@err1 = *blanks and @@err2 = *blanks;
           Initialized = *OFF;
           return *off;
         endif;
       endsl;

       SetError( SPVVEH_VANDU
               : 'Patente Duplicada' );
       Initialized = *OFF;
       return *on;

       Initialized = *OFF;
       return *off;

      /end-free

     P SPVVEH_CheckPatenteDupli...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPatente(): Chequea Patente de Vehiculo           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursar                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peNmat   (input)   Nro. de Patente                       *
      *     peTmat   (input)   Tipo de Patente                       *
      *     pePoco   (input)   Componente                            *
      *     peFech   (input)                                         *
      *     pePadu   (input)   Registro con Patente Duplicada        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckPatente...
     P                 B                   export
     D SPVVEH_CheckPatente...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNmat                      25    const
     D   peTmat                       3    const
     D   pePoco                       4  0 const
     D   peFech                       8  0 options(*nopass:*omit)
     D   pePadu                            likeds(patdup)options(*nopass:*omit)

     D @@empr          s              1
     D @@sucu          s              2
     D @@Fech          s              8  0
     D @@Poco          s              4  0
     D @@Padu          ds                  likeds(patdup)

      /free

       SPVVEH_Inz();

       if %parms >= 8 and %addr(peFech) <> *null;
         @@Fech=peFech;
       else;
         @@Fech=*year*10000+*month*100+*day;
       endif;

       if not SPVVEH_CheckTipoPatente( peEmpr
                                     : peSucu
                                     : peTmat );
         Initialized = *OFF;
         return *off;
       endif;

       if not SPVVEH_CheckFmtPatente( peEmpr
                                    : peSucu
                                    : peNmat
                                    : peTmat );
         Initialized = *OFF;
         return *off;
       endif;

       @@empr = peEmpr;
       @@sucu = peSucu;
       @@poco = pePoco;
       select;
       when %parms >= 9 and %addr(pePadu) <> *null;
         if SPVVEH_CheckPatenteDupli( @@Empr
                                    : @@Sucu
                                    : peArcd
                                    : peSpol
                                    : peNmat
                                    : @@Poco
                                    : @@Fech
                                    : @@Padu );
           Initialized = *OFF;
           return *off;
         else;
           pePadu = @@padu;
         endif;
       other;
         if SPVVEH_CheckPatenteDupli( @@Empr
                                    : @@Sucu
                                    : peArcd
                                    : peSpol
                                    : peNmat
                                    : @@Poco
                                    : @@Fech );
           Initialized = *OFF;
           return *off;
         endif;
       endsl;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckPatente...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_GetOrigen(): Retorna Origen del Vehiculo              *
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *                                                              *
      * Retorna: Origen de Vehiculo o Blanks por Error               *
      * ------------------------------------------------------------ *

     P SPVVEH_GetOrigen...
     P                 B                   export
     D SPVVEH_GetOrigen...
     D                 pi             1
     D   peCobl                       2    const

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckCobertura( peCobl );
         Initialized = *OFF;
         return *blank;
       endif;

       chain peCobl set225;

       Initialized = *OFF;
       return t@vhni;

      /end-free

     P SPVVEH_GetOrigen...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobOrigen(): Chequea Cobertura Origen Vehiculo   *
      *                                                              *
      *     peVhni   (input)   Origen del Vehiculo                   *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobOrigen...
     P                 B                   export
     D SPVVEH_CheckCobOrigen...
     D                 pi             1n
     D   peVhni                       1    const
     D   peCobl                       2    const

     D @@vhni          s              1

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckOrigen( peVhni );
         Initialized = *OFF;
         return *off;
       endif;

       if not SPVVEH_CheckCobertura( peCobl );
         Initialized = *OFF;
         return *off;
       endif;

       @@vhni = SPVVEH_GetOrigen( peCobl );

       select;
       when peVhni = 'N' and @@vhni = 'N';
       when peVhni = 'N' and @@vhni = 'A';
       when peVhni = 'I' and @@vhni = 'I';
       when peVhni = 'I' and @@vhni = 'A';
       other;
         SetError( SPVVEH_VCONF
                 : 'Error de Cobertura Origen' );
         Initialized = *OFF;
         return *off;
       endsl;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobOrigen...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobertura(): Chequea Cobertura Valida            *
      *                                                              *
      *     peCobl   (input)   Tipo del Vehiculo                     *
      *     peNomb   (Output)  Descripcion de Cobertura              *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de la Cobertura si Recibe  *
      *          Parametro peNomb                                    *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobertura...
     P                 B                   export
     D SPVVEH_CheckCobertura...
     D                 pi             1n
     D   peCobl                       2    const
     D   peNomb                      40    options(*nopass:*omit)

      /free

       SPVVEH_Inz();

       chain peCobl set225;

       if not %found;
         if %parms >= 2 and %addr(peNomb) <> *null;
           peNomb = *blanks;
         endif;
         SetError( SPVVEH_VBLNF
                 : 'Codigo de Cobertura Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       if %parms >= 2 and %addr(peNomb) <> *null;
         peNomb = t@cobd;
       endif;
       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobertura...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckMotor(): Chequea Motor de Vehiculo               *
      *                                                              *
      *     peMoto   (input)   Nro. de Motor                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckMotor...
     P                 B                   export
     D SPVVEH_CheckMotor...
     D                 pi             1n
     D   peMoto                      25    const

      /free

       SPVVEH_Inz();

       if peMoto = *blanks;
         SetError( SPVVEH_VTONF
                 : 'Motor Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckMotor...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckChasis(): Chequea Chasis de Vehiculo             *
      *                                                              *
      *     peChas   (input)   Nro. de Chasis                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckChasis...
     P                 B                   export
     D SPVVEH_CheckChasis...
     D                 pi             1n
     D   peChas                      25    const

      /free

       SPVVEH_Inz();

       if peChas = *blanks;
         SetError( SPVVEH_VASNF
                 : 'Chasis Ivalido' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckChasis...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAveria(): Chequea Marca de Averia                *
      *                                                              *
      *     peAver   (input)   Marca de Averia                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckAveria...
     P                 B                   export
     D SPVVEH_CheckAveria...
     D                 pi             1n
     D   peAver                       1    const

      /free

       SPVVEH_Inz();

       if peAver <> '0' and peAver <> '1';
         SetError( SPVVEH_VERNF
                 : 'Marca de Averia Ivalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckAveria...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAcPrendario(): Chequea Codigo de Acreedor        *
      *                                                              *
      *     peAcrc   (input)   Codigo de Acreedor Prendario          *
      *     peNomb   (Output)  Nombre de Acreedor Prendario          *
      *                                                              *
      * Retorna: *On / *Off y Nombre de Acreedor Prendario si Recibe *
      *          Parametro peNomb                                    *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckAcPrendario...
     P                 B                   export
     D SPVVEH_CheckAcPrendario...
     D                 pi             1n
     D   peAcrc                       7  0 const
     D   peNomb                      40    options(*nopass:*omit)

      /free

       SPVVEH_Inz();

       if peAcrc = *zeros;
         if %parms >= 1 and %addr(peNomb) <> *null;
           peNomb = *blanks;
         endif;
         SetError( SPVVEH_VCPAP
                 : 'Codigo de Acreedor Prendario Invalido');
         Initialized = *OFF;
         return *off;
       endif;

       if %parms >= 1 and %addr(peNomb) <> *null;
         chain peAcrc gnhda102;
         if not %found;
           if %parms >= 1 and %addr(peNomb) <> *null;
             peNomb = *blanks;
           endif;
           SetError( SPVVEH_VCPAP
                   : 'Codigo de Acreedor Prendario Invalido');
           Initialized = *OFF;
           return *off;
         else;
           peNomb = dfnomb;
         endif;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckAcPrendario...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPagoAcPrendario(): Chequea Pago de Acreedor      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peAcrc   (input)   Codigo de Acreedor Prendario          *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peCfpg   (input)   Codigo de Forma de Pago               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckPagoAcPrendario...
     P                 B                   export
     D SPVVEH_CheckPagoAcPrendario...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAcrc                       7  0 const
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const

     D k1tfpa01        ds                  likerec(s1tfpa01:*key)

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckAcPrendario( peAcrc );
         Initialized = *OFF;
         return *off;
       endif;

       k1tfpa01.fpempr = peEmpr;
       k1tfpa01.fpsucu = peSucu;
       k1tfpa01.fpacrc = peAcrc;
       k1tfpa01.fparcd = peArcd;
       k1tfpa01.fpcfpg = peCfpg;
       chain %kds(k1tfpa01) setfpa01;

       if not %found;
         SetError( SPVVEH_VRCNF
                 : 'Forma de Pago Acreedor Prendario Invalida');
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckPagoAcPrendario...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckGNC(): Chequea Marca de GNC                      *
      *                                                              *
      *     peMgnc   (input)   Marca de GNC                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckGNC...
     P                 B                   export
     D SPVVEH_CheckGNC...
     D                 pi             1n
     D   peMgnc                       1    const

      /free

       SPVVEH_Inz();

       if peMgnc <> 'S' and peMgnc <> 'N';
         SetError( SPVVEH_VGNNF
                 : 'Marca GNC Ivalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckGNC...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRebaja(): Chequea Buen Resultado de Rebaja       *
      *                                                              *
      *     peRebr   (input)   Marca de Rebaja por Buen Resultado    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckRebaja...
     P                 B                   export
     D SPVVEH_CheckRebaja...
     D                 pi             1n
     D   peRebr                       1  0 const

      /free

       SPVVEH_Inz();

       if peRebr <> 0 and peRebr <> 1 and peRebr <> 2
          and peRebr <> 3 and peRebr <> 4;
         SetError( SPVVEH_VBRNF
                 : 'Error de Rebaja por Buen Resultado');
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckRebaja...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRcNoTar(): Chequea Codigo Tabla RC No Tarifa  *
      *                                                              *
      *     peTarc   (input)   Nro. Tabla RC                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodRcNoTar...
     P                 B                   export
     D SPVVEH_CheckCodRcNoTar...
     D                 pi             1n
     D   peTarc                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const

     D k1t2202         ds                  likerec(s1t2202:*key)

      /free

       SPVVEH_Inz();

       k1t2202.t@tarc = peTarc;
       k1t2202.t@como = peComo;
       k1t2202.t@vhca = peVhca;
       k1t2202.t@vhv1 = peVhv1;
       chain %kds(k1t2202:4) set2202;

       if not %found;
         SetError( SPVVEH_VRCST
                 : 'Error de Codigo Tabla RC Sin Tarifa');
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodRcNoTar...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRcSiTar(): Chequea Codigo Tabla RC Si Tarifa  *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. CoAseguradora             *
      *     peTarc   (input)   Nro. Tabla RC                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodRcSiTar...
     P                 B                   export
     D SPVVEH_CheckCodRcSiTar...
     D                 pi             1n
     D   peNcoc                       5  0 const
     D   peTarc                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const

     D k1t2201         ds                  likerec(s1t2201:*key)

      /free

       SPVVEH_Inz();

       k1t2201.t@ncoc = peNcoc;
       k1t2201.t@tarc = peTarc;
       k1t2201.t@como = peComo;
       k1t2201.t@vhca = peVhca;
       k1t2201.t@vhv1 = peVhv1;
       chain %kds(k1t2201) set2201;

       if not %found;
         SetError( SPVVEH_VRCCT
                 : 'Error de Codigo Tabla RC Con Tarifa');
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodRcSiTar...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRc(): Chequea Codigo de Tabla RC              *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. CoAsegurada               *
      *     peTarc   (input)   Nro. Tabla RC                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodRc...
     P                 B                   export
     D SPVVEH_CheckCodRc...
     D                 pi             1n
     D   peNcoc                       5  0 const
     D   peTarc                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckRangoAÑos( peArcd
                                   : peRama
                                   : peArse );
         SetError( SPVVEH_VAENF
                 : 'Articulo: Extencion Rama Autos Invalida' );
         Initialized = *OFF;
         return *off;
       else;
         if t@mar1 = '0';
           if not SPVVEH_CheckCodRcNoTar( peTarc
                                        : peComo
                                        : peVhca
                                        : peVhv1 );
             Initialized = *OFF;
             return *off;
           endif;
         else;
           if not SPVVEH_CheckCodRcSiTar( peNcoc
                                        : peTarc
                                        : peComo
                                        : peVhca
                                        : peVhv1 );
             Initialized = *OFF;
             return *off;
           endif;
         endif;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodRc...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodAirNoTar(): Chequea Codigo de Tabla AIR       *
      *                            Sin Tarifa                        *
      *                                                              *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodAirNoTar...
     P                 B                   export
     D SPVVEH_CheckCodAirNoTar...
     D                 pi             1n
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const

     D k1t221          ds                  likerec(s1t221:*key)

      /free

       SPVVEH_Inz();

       k1t221.t@tair = peTair;
       k1t221.t@scta = peScta;
       k1t221.t@como = peComo;
       k1t221.t@vhca = peVhca;
       k1t221.t@vhv2 = peVhv2;
       chain %kds(k1t221) set221;

       if not %found;
         k1t221.t@como = '**';
         chain %kds(k1t221) set221;
         if not %found;
           if not SPVVEH_CheckPorMilajeSa( peTair
                                         : peScta
                                         : peComo
                                         : peVhca
                                         : peVhv2 );
             Initialized = *OFF;
             return *off;
           endif;
         endif;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodAirNoTar...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodAirSiTar(): Chequea Codigo de Tabla AIR       *
      *                            Con Tarifa                        *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. Coasegurada               *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodAirSiTar...
     P                 B                   export
     D SPVVEH_CheckCodAirSiTar...
     D                 pi             1n
     D   peNcoc                       5  0 const
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const

     D k2t221          ds                  likerec(s1t221:*key)
     D k2t2211         ds                  likerec(s1t2211:*key)

      /free

       SPVVEH_Inz();

       k2t221.t@tair = peTair;
       k2t221.t@scta = peScta;
       k2t221.t@como = peComo;
       k2t221.t@vhca = peVhca;
       k2t221.t@vhv2 = peVhv2;
       chain %kds(k2t221) set221;

       if not %found;
         k2t2211.t@ncoc = peNcoc;
         k2t2211.t@tair = peTair;
         k2t2211.t@scta = peScta;
         k2t2211.t@vhca = peVhca;
         k2t2211.t@vhv2 = peVhv2;
         k2t2211.t@como = '**';
         chain %kds(k2t2211) set2211;
         if not %found;
           SetError( SPVVEH_VAIRC
                   : 'Error de Codigo Tabla AIR Con Tarifa');
           Initialized = *OFF;
           return *off;
         endif;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodAirSiTar...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodAir(): Chequea Codigo de Tabla AIR            *
      *                                                              *
      *     peNcoc   (input)   Codigo Cia. Coasegurada               *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodAir...
     P                 B                   export
     D SPVVEH_CheckCodAir...
     D                 pi             1n
     D   peNcoc                       5  0 const
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D rec204          ds                  likeds(@@@204)

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckRangoAÑos( peArcd
                                   : peRama
                                   : peArse );
         SetError( SPVVEH_VAENF
                 : 'Articulo: Extencion Rama Autos Invalida' );
         Initialized = *OFF;
         return *off;
       else;
         if not SPVVEH_CheckVeh( peVhmc
                               : peVhmo
                               : peVhcs
                               : rec204 );
           Initialized = *OFF;
           return *off;
         endif;
         if rec204.t@Mar2 = '0';
           if not SPVVEH_CheckCodAirNoTar( peTair
                                         : peScta
                                         : peComo
                                         : peVhca
                                         : peVhv2 );
             Initialized = *OFF;
             return *off;
           endif;
         else;
           if not SPVVEH_CheckCodAirSiTar( peNcoc
                                         : peTair
                                         : peScta
                                         : peComo
                                         : peVhca
                                         : peVhv2 );
             Initialized = *OFF;
             return *off;
           endif;
         endif;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodAir...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPorMilajeSa(): Obtiene PorMilaje de Suma Aseg.   *
      *                                                              *
      *     peTair   (input)   Nro. Tabla AIR                        *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peIfr8   (output)  Importe Franquicia D2                 *
      *     peIfr9   (output)  Importe Franquicia D3                 *
      *                                                              *
      * Retorna: *On - Importes de Franquicias D2 y D3 - / *Off      *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckPorMilajeSa...
     P                 B                   export
     D SPVVEH_CheckPorMilajeSa...
     D                 pi             1n
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peIfr8                      15  2 options(*nopass:*omit)
     D   peIfr9                      15  2 options(*nopass:*omit)

     D k2t221          ds                  likerec(s1t221:*key)

      /free

       SPVVEH_Inz();

       k2t221.t@tair = peTair;
       k2t221.t@scta = peScta;
       k2t221.t@como = peComo;
       k2t221.t@vhca = peVhca;
       k2t221.t@vhv2 = peVhv2;
       chain %kds(k2t221) set2221;

       if not %found;
         k2t221.t@como = '**';
         chain %kds(k2t221) set2221;
         if not %found;
           SetError( SPVVEH_VAIRS
                   : 'Error de Codigo Tabla AIR Sin Tarifa');
           Initialized = *OFF;
           if %parms >= 6 and %addr(peIfr8) <> *null;
             peIfr8 = *zeros;
           endif;
           if %parms >= 7 and %addr(peIfr9) <> *null;
             peIfr9 = *zeros;
           endif;
           Initialized = *OFF;
           return *off;
         endif;
       endif;

       if %parms >= 6 and %addr(peIfr8) <> *null;
         peIfr8 = tnifr8;
       endif;
       if %parms >= 7 and %addr(peIfr9) <> *null;
         peIfr9 = tnifr9;
       endif;
       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckPorMilajeSa...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_GetImpFranquicia(): Retorna Importe de Franquicia     *
      *                                                              *
      *     peTair   (input)   Nro Tabla AIR                         *
      *     peScta   (input)   Nro SubTabla AIR                      *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo del Vehiculo                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peCobl   (input)   Codigo de Cobertura                   *
      *                                                              *
      * Retorna: Importe de Franquicia o cero por no encontrar en las*
      *          tablas 221 y 2221 o no ser cobertura D%             *
      * ------------------------------------------------------------ *

     P SPVVEH_GetImpFranquicia...
     P                 B                   export
     D SPVVEH_GetImpFranquicia...
     D                 pi            15p 2
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peCobl                       2    const

     D @@ifr8          s             15  2
     D @@ifr9          s             15  2

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckPorMilajeSa( peTair
                                     : peScta
                                     : peComo
                                     : peVhca
                                     : peVhv2
                                     : @@ifr8
                                     : @@ifr9 );
         Initialized = *OFF;
         return 0;
       endif;

       Initialized = *OFF;

       if peCobl = 'D2';
         return tnifr8;
       endif;

       if peCobl = 'D' or peCobl = 'D3';
         return tnifr9;
       endif;

       if peCobl = 'D4';
         return tnifra;
       endif;

       if peCobl = 'D5';
         return tnifrb;
       endif;

       if peCobl = 'D6';
         return tnifrc;
       endif;

       if peCobl = 'D7';
         return tnifrd;
       endif;

       Initialized = *OFF;
       return 0;

      /end-free

     P SPVVEH_GetImpFranquicia...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckFranquicia(): Chequea Franquicia                 *
      *                                                              *
      *     peVhvu   (input)   Valor Vehiculo Usado                  *
      *     peCobl   (input)   Codigo de Cobertura                   *
      *     peIfra   (input)   Importe de Franquicia                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckFranquicia...
     P                 B                   export
     D SPVVEH_CheckFranquicia...
     D                 pi             1n
     D   peVhvu                      15  2 const
     D   peCobl                       2    const
     D   peIfra                      15p 2 const

     D @error          s              1

      /free

       SPVVEH_Inz();

       SPIFRA( peCobl
             : peIfra
             : @error);

       if @error = '2';
         SetError( SPVVEH_VFRNI
                 : 'Se Debe Ingresar una Franquicia');
         Initialized = *OFF;
         return *off;
       else;
         if @error = '3';
           SetError( SPVVEH_VFRSI
                   : 'No Se Debe Ingresar una Franquicia');
           Initialized = *OFF;
           return *off;
         endif;
       endif;

       if peIfra > peVhvu;
         SetError( SPVVEH_VFRMA
                 : 'Importe de Franquicia Mayor a Valor Asegurado');
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckFranquicia...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodFranquiciaSeg(): Chequea Franquicia en Seguros*
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *     peCfas   (input)   Codigo de Franquicia                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodFranquiciaSeg...
     P                 B                   export
     D SPVVEH_CheckCodFranquiciaSeg...
     D                 pi             1n
     D   peCobl                       2    const
     D   peCfas                       1    const

     D @@coss          s              2

      /free

       SPVVEH_Inz();

       @@coss = SPVVEH_GetCobEquivalente( peCobl );
       if @@Coss <> 'D';
         if peCfas <> 'A' and peCfas <> 'B' and peCfas <> 'M';
           SetError( SPVVEH_VFRMU
                   : 'Franquicia Debe ser A/B/M');
           Initialized = *OFF;
           return *off;
         endif;
       else;
         if @@coss = 'D';
           if peCfas <> '0' and peCfas <> '1' and peCfas <> '2' and
              peCfas <> '3' and peCfas <> '4' and peCfas <> '5' and
              peCfas <> '6' and peCfas <> '7' and peCfas <> '8' and
              peCfas <> '9' and peCfas <> 'A' and peCfas <> 'B' and
              peCfas <> 'M';
             SetError( SPVVEH_VFR19
                     : 'Franquicia Debe ser 1 a 9');
             Initialized = *OFF;
             return *off;
           endif;
         endif;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCodFranquiciaSeg...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTarjMercosur(): Chequea Tarjeta Mercosur         *
      *                                                              *
      *     peNmer   (input)   Tarjeta Mercosur                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckTarjMercosur...
     P                 B                   export
     D SPVVEH_CheckTarjMercosur...
     D                 pi             1n
     D   peNmer                      40    const

      /free

       SPVVEH_Inz();

       if peNmer = *blanks;
         SetError( SPVVEH_VTMIN
                 : 'Tarjeta de Mercosur Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckTarjMercosur...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRuta(): Chequea R.U.T.A.                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento Superpoliza                *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRuta   (input)   Nro. Ruta                             *
      *     peAsen   (input)   Nro. Asegurado                        *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhuv   (input)   Codigo de Uso                         *
      *     pePoco   (input)   Componente                            *
      *     peFdes   (input)   Vigencia Desde                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckRuta...
     P                 B                   export
     D SPVVEH_CheckRuta...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peRuta                      16  0 const
     D   peAsen                       7  0 const
     D   peVhca                       2  0 const
     D   peVhuv                       2  0 const
     D   pePoco                       4  0 const
     D   peFdes                       8  0 options(*nopass:*omit)

     D k1het9          ds                  likerec(p1het9:*key)

     D @@reto          s              2  0
     D @@endp          s              3a
     D @@Fdes          s              8  0

      /free

       SPVVEH_Inz();

       if %parms >= 12 and %addr(peFdes) <> *null;
         @@Fdes=peFdes;
       else;
         @@Fdes=*year*10000+*month*100+*day;
       endif;

       SPRUTA( peArcd
             : peSpol
             : peSspo
             : peRama
             : peArse
             : peOper
             : peSuop
             : peRuta
             : peAsen
             : peVhca
             : peVhuv
             : @@Fdes
             : @@reto
             : @@endp );

       select;
       when @@reto = 0;
         Initialized = *OFF;
         return *on;
       when @@reto = 1;
         SetError( SPVVEH_VRUNC
                 : 'Capitulo/Uso No lleva RUTA' );
         Initialized = *OFF;
         return *off;
       when @@reto = 2;
         k1het9.t9empr = peEmpr;
         k1het9.t9sucu = peSucu;
         k1het9.t9arcd = peArcd;
         k1het9.t9spol = peSpol;
         k1het9.t9rama = peRama;
         k1het9.t9arse = peArse;
         k1het9.t9oper = peOper;
         k1het9.t9poco = pePoco;
         chain %kds(k1het9) pahet9;
         if %found;
           chain peAsen sehase;
           if asruta <> *zeros;
             SetError( SPVVEH_VRUSC
                     : 'Capitulo/Uso lleva RUTA' );
             Initialized = *OFF;
             return *off;
           endif;
         endif;
       when @@reto = 3;
         SetError( SPVVEH_VRUAN
                 : 'RUTA Vehiculo-Asegurado No');
         Initialized = *OFF;
         return *off;
       when @@reto = 4;
         SetError( SPVVEH_VRUOV
                 : 'RUTA Asignado a Otro Vehiculo');
         Initialized = *OFF;
         return *off;
       endsl;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckRuta...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckZona(): Chequea Zona                             *
      *                                                              *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckZona...
     P                 B                   export
     D SPVVEH_CheckZona...
     D                 pi             1n
     D   peScta                       1  0 const

      /free

       SPVVEH_Inz();

       if peScta = *zeros;
         SetError( SPVVEH_VZONF
                 : 'Zona Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckZona...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckEstado(): Chequea Estado de Componente Contra    *
      *                       Estado de Operacion                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Estado de Componente                  *
      *     pePoli   (input)   Tipo de Operacion                     *
      *     pePoco   (input)   Subtipo de Operacion                  *
      *     peTiou   (input)   Tipo de Operacion                     *
      *     peStou   (input)   Subtipo de Operacion                  *
      *     peStos   (input)   Subtipo de Operacion de Sistema       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckEstado...
     P                 B                   export
     D SPVVEH_CheckEstado...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peTiou                       1  0 const
     D   peStou                       3  0 const
     D   peStos                       2  0 const

     D k1t901          ds                  likerec(s1t901:*key)
     D k1hed004        ds                  likerec(p1hed004:*key)
     D k1het9          ds                  likerec(p1het9:*key)

      /free

       SPVVEH_Inz();

       k1t901.t3tiou = peTiou;
       k1t901.t3stou = peStou;
       chain %kds(k1t901) set901;

       if not %found;
         SetError( SPVVEH_VOONF
                 : 'Error en Tipos de Operaciones');
         Initialized = *OFF;
         return *off;
       endif;

       k1hed004.d0empr = peEmpr;
       k1hed004.d0sucu = peSucu;
       k1hed004.d0rama = peRama;
       k1hed004.d0poli = pePoli;
       chain %kds(k1hed004) pahed004;

       if not %found;
         SetError( SPVVEH_VECIO
                 : 'Estado Componente Invalido para Operacion');
         Initialized = *OFF;
         return *off;
       endif;

       k1het9.t9empr = d0empr;
       k1het9.t9sucu = d0sucu;
       k1het9.t9arcd = d0arcd;
       k1het9.t9spol = d0spol;
       k1het9.t9rama = d0rama;
       k1het9.t9arse = d0arse;
       k1het9.t9oper = d0oper;
       k1het9.t9poco = pePoco;
       chain %kds(k1het9) pahet9;

       if (t3stos = 10 and %found) or
          (t3stos <> 10 and not %found) or
          (t3stos <> 10 and %found and t9aegn > *zeros);
         SetError( SPVVEH_VECIO
                 : 'Estado Componente Invalido para Operacion');
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckEstado...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobCRI(): Chequea Cumplimiento de Cobertura CRI  *
      *                                                              *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante RC                  *
      *     peVhni   (input)   Origen de Vehiculo                    *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobCRI...
     P                 B                   export
     D SPVVEH_CheckCobCRI...
     D                 pi             1n
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhni                       1    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D rec204          ds                  likeds(@@@204)

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckVeh( peVhmc
                             : peVhmo
                             : peVhcs
                             : rec204 );
         Initialized = *OFF;
         return *off;
       endif;

       if not (peVhca = 01 and peVhv1 = 1 and peVhni = 'N') or
          not (peVhca = 04 and rec204.t@mar2 = '2');
         SetError( SPVVEH_VCCIN
                 : 'Cobertura CRI Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobCRI...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobA(): Chequea Cumplimiento de Cobertura A      *
      *                                                              *
      *     peClaj   (input)   % Ajuste Automatico                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobA...
     P                 B                   export
     D SPVVEH_CheckCobA...
     D                 pi             1n
     D   peClaj                       3  0 const

      /free

       SPVVEH_Inz();

       if peClaj <> *zeros;
         SetError( SPVVEH_VCAIN
                 : 'Cobertura A Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobA...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobOtras(): Chequea Cumplimiento Otras Coberturas*
      *                                                              *
      *     peClaj   (input)   % Ajuste Automatico                   *
      *     peClao   (input)   % Ajuste Automatico                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobOtras...
     P                 B                   export
     D SPVVEH_CheckCobOtras...
     D                 pi             1n
     D   peClaj                       3  0 const
     D   peClao                       3  0 const

      /free

       SPVVEH_Inz();

       if peClaj = *zeros and peClao <> *zeros;
         SetError( SPVVEH_VCOIN
                 : 'Cobertura Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobOtras...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobB1(): Chequea Cumplimiento Cobertura B1       *
      *                                                              *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobB1...
     P                 B                   export
     D SPVVEH_CheckCobB1...
     D                 pi             1n
     D   peScta                       1  0 const

      /free

       SPVVEH_Inz();

       if peScta <> 1 and peScta <> 2 and peScta <> 3 and peScta <> 6;
         SetError( SPVVEH_VCBIN
                 : 'Cobertura B1 Invalida en la Zona' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobB1...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobCPlus(): Chequea Cumplimiento Cobertura CPlus *
      * "DEPRECATED" Se debe utilizar SPVVEH_CheckCobCPlus2()        *
      *                                                              *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peScta   (input)   Zona                                  *
      *     peVhuv   (input)   Valor Vehiculo Usado                  *
      *     peCtre   (input)   Codigo Relacion                       *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobCPlus...
     P                 B                   export
     D SPVVEH_CheckCobCPlus...
     D                 pi             1n
     D   peVhca                       2  0 const
     D   peScta                       1  0 const
     D   peVhuv                      15  2 const
     D   peCtre                       5  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D @@ok            s               n
     D rec204          ds                  likeds(@@@204)

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckVeh( peVhmc
                             : peVhmo
                             : peVhcs );
         Initialized = *OFF;
         return *off;
       endif;

       SPCPLUS( peVhca
              : peScta
              : peVhuv
              : rec204.t@mar2
              : @@ok
              : peCtre );

       if not @@ok;
         SetError( SPVVEH_VCPIN
                 : 'Cobertura CPlus Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobCPlus...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRcAir(): Chequea Tabla Air y Tabla RC            *
      * "DEPRECATED" Se debe utilizar SPVVEH_CheckRcAir2             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante AIR                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peTarc   (Output)  Nro. Tabla RC                         *
      *     peTair   (Output)  Nro. Tabla AIR                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckRcAir...
     P                 B                   export
     D SPVVEH_CheckRcAir...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peCtre                       5  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peTarc                       2  0
     D   peTair                       2  0

     D @@ok            s               n
     D rec204          ds                  likeds(@@@204)

     D @aÑo            s              4  0
     D @mes            s              2  0
     D @dia            s              2  0
     D @femi           s              8  0

      /free

       SPVVEH_Inz();

       if peCtre <> *zeros;

         PAR310X3( peEmpr
                 : @aÑo
                 : @mes
                 : @dia );

         @femi=(@aÑo*10000)+(@mes*100)+@dia;

         peTair = *zeros;
         peTarc = *zeros;

         if not SPVVEH_CheckVeh( peVhmc
                               : peVhmo
                               : peVhcs );
           Initialized = *OFF;
           return *off;
         endif;

         SPTRCAIR ( peCtre
                  : peScta
                  : peComo
                  : peVhca
                  : peVhv1
                  : peVhv2
                  : peTarc
                  : peTair
                  : @femi
                  : rec204.t@mar2 );
       else;
         peTair = *zeros;
         peTarc = *zeros;
       endif;

       if peTair = *zeros or peTarc = *zeros;
         SetError( SPVVEH_RCAIR
                 : 'Nros. AIR y RC Invalidos' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckRcAir...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTar(): Chequea Codigo de Tarifa                  *
      *                                                              *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peTarc   (Output)  Nro. Tabla RC                         *
      *     peTair   (Output)  Nro. Tabla AIR                        *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante AIR                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peMarc   (input)   Marca                                 *
      *     peFema   (input)   Año                                   *
      *     peFemm   (input)   Mes                                   *
      *     peFemd   (input)   Dia                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckTar...
     P                 B                   export
     D SPVVEH_CheckTar...
     D                 pi             1n
     D   peCtre                       5  0 const
     D   peScta                       1  0 const
     D   peTarc                       2  0 const
     D   peTair                       2  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peMarc                       1    const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const

     D k1s2222         ds                  likerec(s1t2222:*key)

      /free

       SPVVEH_Inz();

       k1s2222.t@ctre = peCtre;
       k1s2222.t@scta = peScta;
       k1s2222.t@tarc = peTarc;
       k1s2222.t@tair = peTair;
       k1s2222.t@como = peComo;
       k1s2222.t@vhv1 = peVhv1;
       k1s2222.t@mtdf = peMarc;
       k1s2222.t@fema = peFema;
       k1s2222.t@femm = peFemm;
       k1s2222.t@femd = peFemd;
       chain %kds(k1s2222) set2222;

       if not %found;
         SetError( SPVVEH_COTNF
                 : 'Codigo de Tarida Invalido' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *ON;

      /end-free

     P SPVVEH_CheckTar...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_GetCobEquivalente(): Retorna Cobertura Equivalente    *
      *                                                              *
      *     peCobl   (input)   Cobertura del Vehiculo                *
      *                                                              *
      * Retorna: Cobertura Equivalente o Blanks por Error            *
      * ------------------------------------------------------------ *

     P SPVVEH_GetCobEquivalente...
     P                 B                   export
     D SPVVEH_GetCobEquivalente...
     D                 pi             1
     D   peCobl                       2    const

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckCobertura( peCobl );
         Initialized = *OFF;
         return *blank;
       endif;

       chain peCobl set225;

       Initialized = *OFF;
       return t@coss;

      /end-free

     P SPVVEH_GetCobEquivalente...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckVeh0Km(): Chequea Vehiculo 0 Km                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peVhaÑ   (input)   Año                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckVeh0Km...
     P                 B                   export
     D SPVVEH_CheckVeh0Km...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peVhaÑ                       4  0 const

     D @aÑo            s              4  0
     D @mes            s              2  0
     D @dia            s              2  0
     D h               s              4  0
     D d               s              4  0

      /free

       SPVVEH_Inz();

       PAR310X3( peEmpr
               : @aÑo
               : @mes
               : @dia );

       if @mes >= 7;
         d = @aÑo;
       else;
         d = @aÑo - 1;
       endif;

       h = @aÑo + 1;

       if peVhaÑ >= d and peVhaÑ <= h;
         Initialized = *OFF;
         return *On;
       endif;

       SetError( SPVVEH_VENT0
               : 'Vehiculo 0Km Invalido' );
       Initialized = *OFF;
       return *Off;

      /end-free

     P SPVVEH_CheckVeh0Km...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPlan0Km(): Chequea Plan 0 Km                     *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   SuplementoSuperPoliza                 *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Sup. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *     peMarc   (input)   Marca                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckPlan0Km...
     P                 B                   export
     D SPVVEH_CheckPlan0Km...
     D                 pi             1n
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peMarc                       1    const

     D @error          s                   like(*in50)

      /free

       SPVVEH_Inz();

       SPDESCG ( peArcd
               : peSpol
               : peSspo
               : peRama
               : peArse
               : peOper
               : peSuop
               : pePoco
               : @error
               : peMarc );

       if @error;
         Initialized = *OFF;
         return *Off;
       endif;

       Initialized = *OFF;
       return *On;

      /end-free

     P SPVVEH_CheckPlan0Km...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckAcPrendarioCuit(): Chequea Cuit de Acreedor      *
      *                                                              *
      *     peCuit   (input)   Cuit de Acreedor Prendario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckAcPrendarioCuit...
     P                 B                   export
     D SPVVEH_CheckAcPrendarioCuit...
     D                 pi             1n
     D   peCuit                      11    const

      /free

       SPVVEH_Inz();

       read gnhda102;
       dow not %eof and dfcuit <> peCuit;
         read gnhda102;
       enddo;

       if %eof;
         SetError( SPVVEH_VRCNF
                 : 'Codigo de Acreedor Prendario Invalido');
         Initialized = *OFF;
         return *Off;
       else;
         Initialized = *OFF;
         return *On;
       endif;

      /end-free

     P SPVVEH_CheckAcPrendarioCuit...
     P                 E
      * ------------------------------------------------------------ *
      * SPVVEH_CheckCodRelacion(): Chequea Relacion en Set2222       *
      *                                                              *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peFema   (input)   Año de Relacion                       *
      *     peFemm   (input)   Mes de Relacion                       *
      *     peFemd   (input)   Dia de Relacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCodRelacion...
     P                 B                   export
     D SPVVEH_CheckCodRelacion...
     D                 pi             1n
     D   peCtre                       5  0 const
     D   peFema                       4  0 options(*nopass:*omit)
     D   peFemm                       2  0 options(*nopass:*omit)
     D   peFemd                       2  0 options(*nopass:*omit)

     D @@Fema          s              4  0
     D @@Femm          s              2  0
     D @@Femd          s              2  0
     D fecrel          s              8  0
     D fecpar          s              8  0

      /free

       SPVVEH_Inz();

       if %parms >= 2 and %addr(peFema) <> *null;
         @@Fema = peFema;
       else;
         @@Fema = *year;
       endif;
       if %parms >= 3 and %addr(peFemm) <> *null;
         @@Femm = peFemm;
       else;
         @@Femm = *month;
       endif;
       if %parms >= 4 and %addr(peFemd) <> *null;
         @@Femd = peFemd;
       else;
         @@Femd = *day;
       endif;

       setll peCtre set2222;
       reade peCtre set2222;

       if not %found;
         SetError( SPVVEH_VECRN
                 : 'Codigo de Relacion Invalido');
         Initialized = *OFF;
         return *Off;
       else;
         fecpar=@@Fema*10000+@@Femm*100+@@Femd;
         fecrel=t@fema*10000+t@femm*100+t@femd;
         if fecpar < fecrel;
           SetError( SPVVEH_VECRN
                   : 'Codigo de Relacion Invalido');
           Initialized = *OFF;
           return *Off;
         else;
           Initialized = *OFF;
           return *On;
         endif;
       endif;

      /end-free

     P SPVVEH_CheckCodRelacion...
     P                 E
      * ------------------------------------------------------------ *
      * SPVVEH_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVVEH_inz      B                   export
     D SPVVEH_inz      pi

      /free

       monitor;
         if (Initialized);
           return;
         endif;

         if not %open(set201);
           open set201;
         endif;

         if not %open(set202);
           open set202;
         endif;

         if not %open(set203);
           open set203;
         endif;

         if not %open(set204);
           open set204;
         endif;

         if not %open(set205);
           open set205;
         endif;

         if not %open(set208);
           open set208;
         endif;

         if not %open(set210);
           open set210;
         endif;

         if not %open(set211);
           open set211;
         endif;

         if not %open(set215);
           open set215;
         endif;

         if not %open(set220);
           open set220;
         endif;

         if not %open(set2201);
           open set2201;
         endif;

         if not %open(set2202);
           open set2202;
         endif;

         if not %open(set221);
           open set221;
         endif;

         if not %open(set2211);
           open set2211;
         endif;

         if not %open(set2221);
           open set2221;
         endif;

         if not %open(set2222);
           open set2222;
         endif;

         if not %open(set225);
           open set225;
         endif;

         if not %open(set276);
           open set276;
         endif;

         if not %open(set625);
           open set625;
         endif;

         if not %open(set901);
           open set901;
         endif;

         if not %open(setpat01);
           open setpat01;
         endif;

         if not %open(gnhda102);
           open gnhda102;
         endif;

         if not %open(setfpa01);
           open setfpa01;
         endif;

         if not %open(pahet9);
           open pahet9;
         endif;

         if not %open(pahed004);
           open pahed004;
         endif;

         if not %open(sehase);
           open sehase;
         endif;

         if not %open(set219);
            open set219;
         endif;

         if not %open(set242);
            open set242;
         endif;

         if not %open(set6251);
            open set6251;
         endif;

         if not %open(pahet0);
            open pahet0;
         endif;

         if not %open(pahet004);
            open pahet004;
         endif;

         if not %open(set225303);
            open set225303;
         endif;

         if not %open(set22531);
            open set22531;
         endif;

         if not %open(tautos);
            open tautos;
         endif;

         if not %open(iautos);
            open iautos;
         endif;

         if not %open(set239);
            open set239;
         endif;

         if not %open(set20001);
            open set20001;
         endif;

         if not %open(pahet911);
            open pahet911;
         endif;

         if not %open(set225311);
            open set225311;
         endif;

         if not %open(set22532);
            open set22532;
         endif;


         if not %open(set155);
            open set155;
         endif;

         if not %open(pahet1);
            open pahet1;
         endif;

         if not %open(set243);
            open set243;
         endif;

         if not %open(pahet4);
            open pahet4;
         endif;

         if not %open(set206);
            open set206;
         endif;

         if not %open(set207);
            open set207;
         endif;

         if not %open(set271);
            open set271;
         endif;

         if not %open(pahet402);
            open pahet402;
         endif;

         if not %open(pahet406);
            open pahet406;
         endif;

         if not %open(pahet301);
           open pahet301;
         endif;

         if not %open(pahet302);
           open pahet302;
         endif;

         if not %open(pahet5);
           open pahet5;
         endif;

         if not %open(pahet6);
           open pahet6;
         endif;

         if not %open(set228);
           open set228;
         endif;

         if not %open(set250);
           open set250;
         endif;

         if not %open(set227);
           open set227;
         endif;

         if not %open(set2272);
           open set2272;
         endif;

         if not %open(set285);
           open set285;
         endif;

         if not %open(gntloc);
           open gntloc;
         endif;

         if not %open(pahet002);
           open pahet002;
         endif;

         Initialized = *ON;
         return;
         on-error;
         Initialized = *OFF;
       endmon;

       /end-free

     P SPVVEH_inz      E

      * ------------------------------------------------------------ *
      * SPVVEH_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVVEH_End      B                   export
     D SPVVEH_End      pi

      /free

        close *all;

        Initialized = *Off;

      /end-free

     P SPVVEH_End      E

      * ------------------------------------------------------------ *
      * SPVVEH_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SPVVEH_Error    B                   export
     D SPVVEH_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SPVVEH_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peEnum   (input)   Número de error a setear.             *
      *     peEtxt   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peEnum                       10i 0 const
     D  peEtxt                       80a   const

      /free

       ErrCode = peEnum;
       ErrText = peEtxt;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckCobCPlus2(): Chequea Cumplimiento Cobertura CPlus*
      *                                                              *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peScta   (input)   Zona                                  *
      *     peVhuv   (input)   Valor Vehiculo Usado                  *
      *     peCtre   (input)   Codigo Relacion                       *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckCobCPlus2...
     P                 B                   export
     D SPVVEH_CheckCobCPlus2...
     D                 pi             1n
     D   peVhca                       2  0 const
     D   peScta                       1  0 const
     D   peVhuv                       2  0 const
     D   peCtre                       5  0 const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D @@ok            s               n
     D rec204          ds                  likeds(@@@204)

      /free

       SPVVEH_Inz();

       if not SPVVEH_CheckVeh( peVhmc
                             : peVhmo
                             : peVhcs );
         Initialized = *OFF;
         return *off;
       endif;

       SPCPLUS( peVhca
              : peScta
              : peVhuv
              : rec204.t@mar2
              : @@ok
              : peCtre );

       if not @@ok;
         SetError( SPVVEH_VCPIN
                 : 'Cobertura CPlus Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckCobCPlus2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckTarDif(): Chequea Tarifia Diferencia Set208      *
      *                                                              *
      *     peMtdf   (input)   Marca                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckTarDif...
     P                 B                   export
     D SPVVEH_CheckTarDif...
     D                 pi             1n
     D   peMtdf                       1    const

      /free

       SPVVEH_Inz();

       chain peMtdf set208;

       if not %found;
         SetError( SPVVEH_MTDIN
                 : 'Marca Tarifa Diferencia Invalida' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *ON;

      /end-free

     P SPVVEH_CheckTarDif...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckRcAir2(): Chequea Tabla Air y Tabla RC           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peCtre   (input)   Codigo de Relacion                    *
      *     peScta   (input)   Sub Tabla AIR                         *
      *     peComo   (input)   Codigo de Moneda                      *
      *     peVhca   (input)   Capitulo de Vehiculo                  *
      *     peVhv1   (input)   Capitulo Variante AIR                 *
      *     peVhv2   (input)   Capitulo Variante AIR                 *
      *     peTarc   (Output)  Nro. Tabla RC                         *
      *     peTair   (Output)  Nro. Tabla AIR                        *
      *     peTadi   (Input)   Marca de Tarifa Diferencial           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckRcAir2...
     P                 B                   export
     D SPVVEH_CheckRcAir2...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peCtre                       5  0 const
     D   peScta                       1  0 const
     D   peComo                       2    const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peTarc                       2  0
     D   peTair                       2  0
     D   peTadi                       1    options(*nopass:*omit)

     D @@ok            s               n
     D rec204          ds                  likeds(@@@204)

     D @aÑo            s              4  0
     D @mes            s              2  0
     D @dia            s              2  0
     D @femi           s              8  0

      /free

       SPVVEH_Inz();

       if peCtre <> *zeros;

         PAR310X3( peEmpr
                 : @aÑo
                 : @mes
                 : @dia );

         @femi=(@aÑo*10000)+(@mes*100)+@dia;

         peTair = *zeros;
         peTarc = *zeros;

         if %parms >= 10 and %addr(peTadi) <> *null;
           SPTRCAIR ( peCtre
                    : peScta
                    : peComo
                    : peVhca
                    : peVhv1
                    : peVhv2
                    : peTarc
                    : peTair
                    : @femi
                    : peTadi );
         else;
           SPTRCAIR ( peCtre
                    : peScta
                    : peComo
                    : peVhca
                    : peVhv1
                    : peVhv2
                    : peTarc
                    : peTair
                    : @femi  );
         endif;
       else;
         peTair = *zeros;
         peTarc = *zeros;
       endif;

       if peTair = *zeros or peTarc = *zeros;
         SetError( SPVVEH_RCAIR
                 : 'Nros. AIR y RC Invalidos' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *on;

      /end-free

     P SPVVEH_CheckRcAir2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaMinima(): Recupera suma asegurada mínima       *
      *                                                              *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: Importe de Suma Mínima (puede ser cero)             *
      * ------------------------------------------------------------ *
     P SPVVEH_getSumaMinima...
     P                 B                   EXPORT
     D SPVVEH_getSumaMinima...
     D                 pi            15  2
     D   peFemi                       8  0 options(*nopass:*omit)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D @femi           s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D empr            s              1a   inz('A')
     D @smin           s             15  2
     D k1t219          ds                  likerec(s1t219:*key)

      /free

       SPVVEH_inz();

       if %parms >= 1 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smin = 0;

       setll *start set219;
       read set219;
       dow not %eof;

           if txfech <= @femi;
              @smin = txsmin;
           endif;

        read set219;
       enddo;

       return @smin;

      /end-free

     P SPVVEH_getSumaMinima...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaMaxima(): Recupera suma asegurada máxima       *
      *                                                              *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: Importe de Suma Máxima (puede ser cero)             *
      * ------------------------------------------------------------ *
     P SPVVEH_getSumaMaxima...
     P                 B                   EXPORT
     D SPVVEH_getSumaMaxima...
     D                 pi            15  2
     D   peFemi                       8  0 options(*nopass:*omit)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D @femi           s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D empr            s              1a   inz('A')
     D @smax           s             15  2
     D k1t219          ds                  likerec(s1t219:*key)

      /free

       SPVVEH_inz();

       if %parms >= 1 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smax = 999999999999,99;

       setll *start set219;
       read set219;
       dow not %eof;

           if txfech <= @femi;
              @smax = txsmax;
           endif;

        read set219;
       enddo;

       return @smax;

      /end-free

     P SPVVEH_getSumaMaxima...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkSumaMinima(): Controla Suma aseg > a suma mínima   *
      *                                                              *
      *     peVhvu   (input)   Suma asegurada                        *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     P SPVVEH_chkSumaMinima...
     P                 B                   export
     D SPVVEH_chkSumaMinima...
     D                 pi             1N
     D   peVhvu                      15  2
     D   peFemi                       8  0 options(*nopass:*omit)

     D @femi           s              8  0
     D @smin           s             15  2
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D empr            s              1a   inz('A')

      /free

       SPVVEH_inz();

       if %parms >= 2 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smin = SPVVEH_getSumaMinima( @femi );
       if peVhvu < @smin;
          SetError( SPVVEH_SUMIN
                  : 'Suma Aseg. Inferior a la mínima permitida' );
          return *OFF;
       endif;

       return *ON;

      /end-free

     P SPVVEH_chkSumaMinima...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkSumaMaxima(): Controla Suma aseg > a suma mínima   *
      *                                                              *
      *     peVhvu   (input)   Suma asegurada                        *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     P SPVVEH_chkSumaMaxima...
     P                 B                   export
     D SPVVEH_chkSumaMaxima...
     D                 pi             1N
     D   peVhvu                      15  2
     D   peFemi                       8  0 options(*nopass:*omit)

     D @femi           s              8  0
     D @smax           s             15  2
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D empr            s              1a   inz('A')

      /free

       SPVVEH_inz();

       if %parms >= 2 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smax = SPVVEH_getSumaMaxima( @femi );
       if peVhvu > @smax;
          SetError( SPVVEH_SUMAX
                  : 'Suma Aseg. Supera a la permitida' );
          return *OFF;
       endif;

       return *ON;

      /end-free

     P SPVVEH_chkSumaMaxima...
     P                 E


      * ------------------------------------------------------------ *
      * SPVVEH_chkCoberturaA                                         *
      *                                                              *
      *     peCobl   (input)   Código de cobertura.                  *
      *     peVhvu   (input)   Suma asegurada.                       *
      *                                                              *
      *  Verifica si una cobertura es Responsabilidad Civil y si lo  *
      * lo es, que no tenga suma asegurada.
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     P SPVVEH_chkCoberturaA...
     P                 B                   export
     D SPVVEH_chkCoberturaA...
     D                 pi             1N
     D   peCobl                       2    const
     D   peVhvu                      15  2 const

      /free

       SPVVEH_inz();

       if SPVVEH_CheckCobertura(peCobl);
       chain peCobl set225;
       if T@COSS <> 'A';
         SetError(SPVVEH_COBNA: 'La cobertura no es Responsabilidad Civil');
         Initialized = *OFF;
         return *off;
       endif;
       if peVhvu <> 0;
         SetError(SPVVEH_SUMCA:
         'Suma asegurada debe ser cero para cobertura A');
         Initialized = *OFF;
         return *off;
       endif;

       return *ON;

       Else;
       return *off;
       Endif;

      /end-free

     P SPVVEH_chkCoberturaA...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkRamaCapitulo(): Verifica relación Rama vs VHCA/VHV1*
      *                           VHV2.                              *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peVhca   (input)   Capítulo                              *
      *     peVhv1   (input)   Variante RC                           *
      *     peVhv2   (input)   Variante AIR                          *
      *                                                              *
      * Retorna: *ON existe la relación, *OFF no                     *
      * ------------------------------------------------------------ *

     P SPVVEH_chkRamaCapitulo...
     P                 B                   export
     D SPVVEH_chkRamaCapitulo...
     D                 pi              n
     D   peRama                       2  0 const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const

     D k1y242          ds                  likerec(s1t242:*key)

      /free

       SPVVEH_inz();

       k1y242.ttrama = peRama;
       k1y242.ttvhca = peVhca;
       k1y242.ttvhv1 = peVhv1;
       k1y242.ttvhv2 = peVhv2;
       setll %kds(k1y242) set242;

       if not %equal;
          SetError( SPVVEH_RCVIN
                  : 'Relacion Rama-Capitulo-Variante Inexistente' );
          return *OFF;
       endif;

       return *ON;

      /end-free

     P SPVVEH_chkRamaCapitulo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkRamaCobertura(): Chequea cobertura valida para     *
      *                            Arcd/Rama                         *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_chkRamaCobertura...
     P                 B                   export
     D SPVVEH_chkRamaCobertura...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCobl                       2    const
     D   peFech                       8  0 options(*nopass:*omit)

     D @@fech          s              8  0
     D aufech          s              8  0
     D aunres          s              7  0
     D auarse          s              2  0

     D k1y6251         ds                  likerec(s1t6251:*key)

      /free

       SPVVEH_inz();

       if %parms >= 4 and %addr(peFech) <> *null;
         @@fech = peFech;
       else;
         @@fech = *Year*10000+*Month*100+*Day;
       endif;

       // ------------------------------------
       // Fecha de instalación
       // ------------------------------------
       if @@fech < 20141209;
          return *ON;
       endif;

       k1y6251.t@arcd = peArcd;
       k1y6251.t@rama = peRama;
       setll %kds(k1y6251:2) set6251;
       reade %kds(k1y6251:2) set6251;

       dow not %eof (set6251) and t@fech > @@fech;
         reade %kds(k1y6251:2) set6251;
       enddo;

       if not %eof;
         aufech = t@fech;
         auarse = t@arse;
         aunres = t@nres;
         dow not %eof (set6251) and aufech = t@fech;
           select;
             when auarse = t@arse and aunres <> t@nres;
               auarse = t@arse;
               aunres = t@nres;
               dow not %eof(set6251) and (auarse=t@arse and aunres=t@nres);
                 reade %kds(k1y6251:2) set6251;
               enddo;
             when t@cobl = peCobl;
               return *On;
             other;
               reade %kds(k1y6251:2) set6251;
           endsl;
         enddo;
       endif;

       SetError( SPVVEH_CNPAR
               : 'Cobertura no Permitida para Articulo/Rama' );
       return *Off;

      /end-free

     P SPVVEH_chkRamaCobertura...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkArticuloCobertura(): Chequea cobertura valida para *
      *                                articulo                      *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_chkArticuloCobertura...
     P                 B                   export
     D SPVVEH_chkArticuloCobertura...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peCobl                       2    const
     D   peFech                       8  0 options(*nopass:*omit)

     D @@fech          s              8  0
     D aufech          s              8  0
     D aunres          s              7  0
     D auarse          s              2  0
     D aurama          s              2  0

     D k1y6251         ds                  likerec(s1t6251:*key)

      /free

       SPVVEH_inz();

       if %parms >= 3 and %addr(peFech) <> *null;
         @@fech = peFech;
       else;
         @@fech = *Year*10000+*Month*100+*Day;
       endif;

       // ------------------------------------
       // Fecha de instalación
       // ------------------------------------
       if @@fech < 20141209;
          return *ON;
       endif;

       k1y6251.t@arcd = peArcd;
       setll %kds(k1y6251:1) set6251;
       reade %kds(k1y6251:1) set6251;

       dow not %eof (set6251) and t@fech > @@fech;
         reade %kds(k1y6251:1) set6251;
       enddo;

       if not %eof;
         aufech = t@fech;
         auarse = t@arse;
         aunres = t@nres;
         aurama = t@rama;
         dow not %eof (set6251) and aufech = t@fech;
           select;
             when aurama = t@rama and auarse = t@arse and aunres <> t@nres;
               auarse = t@arse;
               aunres = t@nres;
               aurama = t@rama;
               dow not %eof(set6251) and
                   (aurama=t@rama and auarse=t@arse and aunres=t@nres);
                 reade %kds(k1y6251:1) set6251;
               enddo;
             when t@cobl = peCobl;
               return *On;
             other;
               reade %kds(k1y6251:1) set6251;
           endsl;
         enddo;
       endif;

       SetError( SPVVEH_CNPAR
               : 'Cobertura no Permitida para Articulo/Rama' );
       return *Off;

      /end-free

     P SPVVEH_chkArticuloCobertura...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckArcd1006(): Chequea si corresponde a Arcd 1006   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento Superpoliza                *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckArcd1006...
     P                 B                   export
     D SPVVEH_CheckArcd1006...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const

     D k1yet0          ds                  likerec(p1het0:*key)

      /free

       SPVVEH_inz();

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0sspo = peSspo;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0oper = peOper;
       setll %kds(k1yet0:8) pahet0;
       reade %kds(k1yet0:8) pahet0;

       dow not %eof(pahet0);
         if t0cobl <> 'A ' and t0cobl <> 'A1';
           return *Off;
         else;
           reade %kds(k1yet0:8) pahet0;
         endif;
       enddo;

       return *On;

      /end-free

     P SPVVEH_CheckArcd1006...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckArcd1006Gral():Chequea si corresponde a Arcd 1006*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_CheckArcd1006Gral...
     P                 B                   export
     D SPVVEH_CheckArcd1006Gral...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const

     D k1yet9          ds                  likerec(p1het9:*key)
     D k1yet0          ds                  likerec(p1het0:*key)

      /free

       SPVVEH_inz();

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       k1yet9.t9rama = peRama;
       k1yet9.t9arse = peArse;
       k1yet9.t9oper = peOper;
       setll %kds(k1yet9:7) pahet9;
       reade %kds(k1yet9:7) pahet9;

       dow not %eof(pahet9);
         k1yet0.t0empr = t9empr;
         k1yet0.t0sucu = t9sucu;
         k1yet0.t0arcd = t9arcd;
         k1yet0.t0spol = t9spol;
         k1yet0.t0sspo = t9sspo;
         k1yet0.t0rama = t9rama;
         k1yet0.t0arse = t9arse;
         k1yet0.t0oper = t9oper;
         k1yet0.t0poco = t9poco;
         setll %kds(k1yet0:9) pahet0;
         reade %kds(k1yet0:9) pahet0;
         if t0cobl <> 'A ' and t0cobl <> 'A1';
           return *Off;
         else;
           reade %kds(k1yet9:7) pahet9;
         endif;
       enddo;

       return *On;

      /end-free

     P SPVVEH_CheckArcd1006Gral...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkPautasCobl(): Retorna Pautas por Cobertura         *
      *                                                              *
      *     peCobl   (input)   Cobertura                             *
      *     peTiou   (input)   Tipo Operacion                        *
      *     peStou   (input)   SubTipo Operacion                     *
      *     peStos   (input)   Tipo Operacion Sistema                *
      *     peFech   (input)   Fecha                                 *
      *     pePaut   (output)  Variante AIR                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_chkPautasCobl...
     P                 B                   export
     D SPVVEH_chkPautasCobl...
     D                 pi              n
     D   peCobl                       2    const
     D   peTiou                       2  0 const
     D   peStou                       2  0 const
     D   peStos                       1  0 const
     D   pePaut                            likeds(pautas)options(*nopass:*omit)
     D   peFech                       8  0 options(*nopass:*omit)

     D @@fech          s              8  0

     D k1y225303       ds                  likerec(s1t2253:*key)
     D k1y22531        ds                  likerec(s1t22531:*key)

      /free

       SPVVEH_inz();

       if %parms >= 6 and %addr(peFech) <> *null;
         @@fech = peFech;
       else;
         @@fech = *Year*10000+*Month*100+*Day;
       endif;

       k1y225303.t@cobl = peCobl;
       k1y225303.t@vigd = @@fech;
       setll %kds(k1y225303:2) set225303;
       reade %kds(k1y225303:2) set225303;

       if %eof(set225303);
          SetError( SPVVEH_SINPA
                  : 'No se Encontraron Pautas' );
          return *Off;
       endif;

       if %parms >= 5 and %addr(pePaut) <> *null;
         k1y22531.t1cobl = peCobl;
         k1y22531.t1nres = t@nres;
         k1y22531.t1tiou = peTiou;
         k1y22531.t1stou = peStou;
         k1y22531.t1stos = peStos;
         chain %kds(k1y22531) set22531;

         pePaut.paanti = t1anti;
         pePaut.painsp = t1insp;
         pePaut.parast = t1rast;
       endif;

       return *On;

      /end-free

     P SPVVEH_chkPautasCobl...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getCodInfoautos(): Retorna Codigo de INFOAUTOS        *
      * DEPRECATED   Se debe utilizar SPVVEH_getCodinfoauto1()       *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_getCodInfoautos...
     P                 B                   export
     D SPVVEH_getCodInfoautos...
     D                 pi             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

     D k1yet0          ds                  likerec(p1het0:*key)
     D k1y204          ds                  likerec(s1t204:*key)
     D k1yinf          ds                  likerec(t1utos:*key)

      /free

       SPVVEH_inz();

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0sspo = peSspo;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0oper = peOper;
       k1yet0.t0poco = pePoco;
       setll %kds( k1yet0 : 9 ) pahet0;
       reade %kds( k1yet0 : 9 ) pahet0;

       if %eof ( pahet0 );
         Initialized = *Off;
         return -1;
       endif;

       k1y204.t@vhmc = t0vhmc;
       k1y204.t@vhmo = t0vhmo;
       k1y204.t@vhcs = t0vhcs;
       chain %kds( k1y204 ) set204;

       if not %found ( set204 );
         SetError( SPVVEH_VVONF
                 : 'Vehiculo no Encontrado' );
         Initialized = *Off;
         return -1;
       endif;

       k1yinf.t@cmar = t@cmar;
       k1yinf.t@cmod = t@cmod;
       chain %kds( k1yinf ) tautos;

       if not %found ( tautos );
         SetError( SPVVEH_NEINF
                 : 'Vehiculo no Encontrado en INFOAUTOS' );
         Initialized = *Off;
         return -1;
       endif;

       return t@cinf;

      /end-free

     P SPVVEH_getCodInfoautos...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getCodInfoauto1(): Retorna Codigo de INFOAUTOS        *
      *                           toma los datos de IAUTOS.          *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_getCodInfoauto1...
     P                 B                   export
     D SPVVEH_getCodInfoauto1...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

     D k1yet0          ds                  likerec(p1het0:*key)
     D k1y204          ds                  likerec(s1t204:*key)
     D k1yinf          ds                  likerec(i1utos:*key)

      /free

       SPVVEH_inz();

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0sspo = peSspo;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0oper = peOper;
       k1yet0.t0poco = pePoco;
       setll %kds( k1yet0 : 9 ) pahet0;
       reade %kds( k1yet0 : 9 ) pahet0;

       if %eof ( pahet0 );
         Initialized = *Off;
         return -1;
       endif;

       k1y204.t@vhmc = t0vhmc;
       k1y204.t@vhmo = t0vhmo;
       k1y204.t@vhcs = t0vhcs;
       chain %kds( k1y204 ) set204;

       if not %found ( set204 );
         SetError( SPVVEH_VVONF
                 : 'Vehiculo no Encontrado' );
         Initialized = *Off;
         return -1;
       endif;

       k1yinf.i@cmar = t@cma1;
       k1yinf.i@cmod = t@cmo1;
       chain %kds( k1yinf ) iautos;

       if not %found ( iautos );
         SetError( SPVVEH_NEINF
                 : 'Vehiculo no Encontrado en INFOAUTOS' );
         Initialized = *Off;
         return -1;
       endif;

       return t@cinf;

      /end-free

     P SPVVEH_getCodInfoauto1...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getValGnc(): Retorna Valor de GNC                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Valor de GNC / -1 caso de error                     *
      * ------------------------------------------------------------ *

     P SPVVEH_getValGnc...
     P                 B                   export
     D SPVVEH_getValGnc...
     D                 pi             9  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1y239          ds                  likerec(s1t239:*key)

      /free

       SPVVEH_inz();

       k1y239.tbempr = peEmpr;
       k1y239.tbsucu = peSucu;

       if %parms >= 3 and %addr(peFech) <> *Null;
         k1y239.tbfech = peFech;
       else;
         k1y239.tbfech = *Year*10000+*Month*100+*Day;
       endif;

       setll %kds ( k1y239 : 3 ) set239;
       reade %kds ( k1y239 : 2 ) set239;

       return tbrgnc;

      /end-free

     P SPVVEH_getValGnc...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getValGncComp(): Retorna Valor de GNC Componente      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Valor de GNC / -1 caso de error                     *
      * ------------------------------------------------------------ *

     P SPVVEH_getValGncComp...
     P                 B                   export
     D SPVVEH_getValGncComp...
     D                 pi             9  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

     D k1yet0          ds                  likerec(p1het0:*key)

      /free

       SPVVEH_inz();

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0sspo = peSspo;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0oper = peOper;
       k1yet0.t0poco = pePoco;
       setll %kds( k1yet0 : 9 ) pahet0;
       reade %kds( k1yet0 : 9 ) pahet0;

       if %eof ( pahet0 );
         Initialized = *Off;
         return -1;
       endif;

       return t0rgnc;

      /end-free

     P SPVVEH_getValGncComp...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkGnc(): Retorna si Componente con GNC               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVVEH_chkGnc...
     P                 B                   export
     D SPVVEH_chkGnc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const

     D k1yet0          ds                  likerec(p1het0:*key)

      /free

       SPVVEH_inz();

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0sspo = peSspo;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0oper = peOper;
       k1yet0.t0poco = pePoco;
       setll %kds( k1yet0 : 9 ) pahet0;
       reade %kds( k1yet0 : 9 ) pahet0;

       if %eof ( pahet0 );
         Initialized = *Off;
         return *Off;
       endif;

       if ( t0vhv2 = 5 or t0vhv2 = 6 );
         return *On;
       else;
         return *Off;
       endif;

      /end-free

     P SPVVEH_chkGnc...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getValGncUlt (): Retorna Valor de GNC Componente      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Superpoliza                           *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Valor de GNC / -1 caso de error                     *
      * ------------------------------------------------------------ *

     P SPVVEH_getValGncUlt...
     P                 B                   export
     D SPVVEH_getValGncUlt...
     D                 pi             9  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const

     D k1yet9          ds                  likerec(p1het911:*key)

      /free

       SPVVEH_inz();

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       k1yet9.t9poco = pePoco;
       setll %kds( k1yet9 : 5 ) pahet911;
       reade %kds( k1yet9 : 5 ) pahet911;

       if %eof ( pahet911 );
         Initialized = *Off;
         return -1;
       endif;

       return t9rgnc;

      /end-free

     P SPVVEH_getValGncUlt...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getMinMaxSuma(): Retorna % de Suma Asegurada          *
      *                                                              *
      *     peMone   (input)   Moneda                                *
      *     peSumh   (input)   Suma Asegurada                        *
      *                                                              *
      *     peMini   (output)  % Minimo                              *
      *     peMaxi   (output)  % Maximo                              *
      *                                                              *
      * Retorna: *On si OK / *Off si error                           *
      * ------------------------------------------------------------ *

     P SPVVEH_getMinMaxSuma...
     P                 b                   export
     D SPVVEH_getMinMaxSuma...
     D                 pi              n
     D   peMone                       2    const
     D   peSumh                      15  2 const
     D   peMini                       5  2
     D   peMaxi                       5  2

     D k1y201          ds                  likerec(s1t200:*key)

       SPVVEH_inz();

       clear peMini;
       clear peMaxi;

       k1y201.t@mone = peMone;
       k1y201.t@sumh = peSumh;

       setll %kds(k1y201) set20001;
       read  set20001;
       if not %eof(set20001);
          eval peMini = t@mini;
          eval peMaxi = t@maxi;
          return *On;
       else;
          return *Off;
       endif;

     P SPVVEH_getMinMaxSuma...
     P                 e
      * ------------------------------------------------------------ *
      * SPVVEH_getRastreador(): Retorna Código de Rastreador         *
      *                                                              *
      *     peCobl   (input)   Cobertura                             *
      *     peTiou   (input)   Tipo de operación                     *
      *     peStou   (input)   Subtipo de operación Usiario          *
      *     peStos   (input)  Subtipo de operación Sistema           *
      *     peScta   (input)  Subtabla AIR                           *
      *                                                              *
      * Retorna: Código de Rastreador / -1 caso de error             *
      * ------------------------------------------------------------ *

     P SPVVEH_getRastreador...
     P                 b                   export
     D SPVVEH_getRastreador...
     D                 pi             3  0
     D   peCobl                       2    const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D   peScta                       1  0 const

     D   wcras         s              3  0
     D   primera       s               n

     D k1y531          ds                  likerec( s1t225311 : *key )
     D k2y532          ds                  likerec( s2t22532  : *key )

       SPVVEH_inz();

       k1y531.t1Cobl = peCobl;
       k1y531.t1Tiou = peTiou;
       k1y531.t1Stou = peStou;
       k1y531.t1Stos = peStos;
       k1y531.t1Scta = peScta;
       chain %kds( k1y531 : 5 ) set225311;
          if %found( set225311 );
             k2y532.t5nres = t1nres;
             k2y532.t5Tiou = t1Tiou;
             k2y532.t5Stou = t1Stou;
             k2y532.t5Stos = t1Stos;
             k2y532.t5Scta = t1Scta;
             setll %kds( k2y532 : 5 )  set22532;
                  if not %equal( set22532 );
                    // error no existe
                    return -1;
                  endif;
             reade %kds( k2y532 : 5 ) set22532;
                dow not %eof( set22532 );
                  if t5cant < (t5porc * 10)/100;
                     t5cant += 1;
                     update s2t22532;
                     return t5cras;
                  endif;
              reade %kds( k2y532 : 5 ) set22532;
                enddo;
          else;
          // error no existe
              return -1;
          endif;

          // si se utilizaron todos se reinicia el contador
             wcras = *zeros;
             primera = *on;
             setll %kds( k2y532 : 5 ) set22532;
             reade %kds( k2y532 : 5 ) set22532;
                dow not %eof( set22532 );
                  if primera;
                     wcras   = t5cras;
                     primera = *off;
                     t5cant  = 1;
                  else;
                     t5cant = *zeros;
                  endif;
                  update s2t22532;
              reade %kds( k2y532 : 5 ) set22532;
                enddo;
             return wcras;

     P SPVVEH_getRastreador...
     P                 e
      * ----------------------------------------------------------------- *
      * SPVVEH_getClasificacion(): Devuelve Capítulo, variante AIR,       *
      *                            Variante RC y tarifa diferencial       *
      *        Input :                                                    *
      *                                                                   *
      *                peVhmc  -  Marca del Vehículo                      *
      *                peVhmo  -  Modelo del Vehículo                     *
      *                peVhcs  -  SubModelo del Vehículo                  *
      *                                                                   *
      *        Output :                                                   *
      *                                                                   *
      *                peVhca  -  Capítulo                                *
      *                peVhv1  -  Variante R.C.                           *
      *                peVhv2  -  Variante Air                            *
      *                peMtdf  -  Tarifa Diferencial                      *
      *                                                                   *
      * ----------------------------------------------------------------- *

     P SPVVEH_getClasificacion...
     P                 B                   export
     D SPVVEH_getClasificacion...
     D                 pi              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhca                       2  0
     D   peVhv1                       1  0
     D   peVhv2                       1  0
     D   peMtdf                       1

     D k1y204          ds                  likerec(s1t204:*key)

      /free

       SPVVEH_inz();

       k1y204.t@Vhmc = peVhmc;
       k1y204.t@Vhmo = peVhmo;
       k1y204.t@Vhcs = peVhcs;

       chain  %kds( k1y204 : 3 ) set204;
       if %found;

         peVhca = t@vhca;
         peVhv1 = t@vhv1;
         peVhv2 = t@vhv2;
         peMtdf = t@mar2;
         return *on;

       endif;

       return *off;

      /end-free

     P SPVVEH_getClasificacion...
     P                 E
      * ----------------------------------------------------------------- *
      * SPVVEH_getCarroceria(): Devuelve el codigo de carroceria          *
      *                                                                   *
      *        Input :                                                    *
      *                                                                   *
      *                peVhmc  -  Marca del Vehículo                      *
      *                peVhmo  -  Modelo del Vehículo                     *
      *                peVhcs  -  SubModelo del Vehículo                  *
      *                                                                   *
      * ----------------------------------------------------------------- *

     P SPVVEH_getCarroceria...
     P                 B                   export
     D SPVVEH_getCarroceria...
     D                 pi             3
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D k1y204          ds                  likerec(s1t204:*key)

      /free

       SPVVEH_inz();

       k1y204.t@Vhmc = peVhmc;
       k1y204.t@Vhmo = peVhmo;
       k1y204.t@Vhcs = peVhcs;

       chain  %kds( k1y204 : 3 ) set204;
       if %found;

         return t@vhcr;

       endif;

       return *blanks;

      /end-free

     P SPVVEH_getCarroceria...
     P                 E
      * ----------------------------------------------------------------- *
      * SPVVEH_getTipoVehiculo():Devuelve el tipo de Vehiculo             *
      *                                                                   *
      *        Input :                                                    *
      *                                                                   *
      *                peVhmc  -  Marca del Vehículo                      *
      *                peVhmo  -  Modelo del Vehículo                     *
      *                peVhcs  -  SubModelo del Vehículo                  *
      *                                                                   *
      * ----------------------------------------------------------------- *

     P SPVVEH_getTipoVehiculo...
     P                 B                   export
     D SPVVEH_getTipoVehiculo...
     D                 pi             2  0
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D k1y204          ds                  likerec(s1t204:*key)

      /free

       SPVVEH_inz();

       k1y204.t@Vhmc = peVhmc;
       k1y204.t@Vhmo = peVhmo;
       k1y204.t@Vhcs = peVhcs;

       chain  %kds( k1y204 : 3 ) set204;
       if %found;

         return t@vhct;

       endif;

       return 0;

      /end-free

     P SPVVEH_getTipoVehiculo...
     P                 E
      * ------------------------------------------------------------ *
      * SPVVEH_coberturaD: Busca Coberturas D.                       *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_coberturaD...
     P                 B                   export
     D SPVVEH_coberturaD...
     D                 pi              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

     D   k1yet9        ds                    likerec( p1het9 : *key )
     D   k1yet0        ds                    likerec( p1het0 : *key )

      /free

       SPVVEH_inz();

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       setll %kds( k1yet9 : 4 ) pahet9;
       reade %kds( k1yet9 : 4 ) pahet9;

       dow not %eof ( pahet9 );

         k1yet0.t0empr = t9empr;
         k1yet0.t0sucu = t9sucu;
         k1yet0.t0arcd = t9arcd;
         k1yet0.t0spol = t9spol;
         k1yet0.t0sspo = t9sspo;
         k1yet0.t0rama = t9rama;
         k1yet0.t0arse = t9arse;
         k1yet0.t0oper = t9oper;
         k1yet0.t0poco = t9poco;
         chain %kds( k1yet0 : 9) pahet0;

         if %found( pahet0 ) and t0cobl = 'D';

           SetError( SPVVEH_PLANP
                   : 'Tiene Cobertura D' );
           return *On;

         endif;

         reade %kds( k1yet9 : 4 ) pahet9;

       enddo;

       return *Off;

      /end-free

     P SPVVEH_coberturaD...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_CheckPatenteDupliSpol(): Chequea Patente Duplicada    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peFech   (input)   Fecha                                 *
      *     pePadu   (Output)  Registro con Patente Duplicada        *
      *                                                              *
      * Retorna: *On Si la Patente es Duplicada                      *
      *          *Off Si la Patente No es Duplicada                  *
      * ------------------------------------------------------------ *
     P SPVVEH_CheckPatenteDupliSpol...
     P                 B                   export
     D SPVVEH_CheckPatenteDupliSpol...
     D                 pi              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   peFech                       8  0   options(*Omit:*Nopass)
     D   pePadu                            likeds(patdup)options(*nopass:*omit)

     D @@fech          s              8  0
     D @@padu          ds                  likeds(patdup)

     D k1yet9          ds                    likerec( p1het9 : *key )

      /free

       SPVVEH_inz();

       if %parms >= 5 and %addr(peFech) <> *null;
         @@fech=peFech;
       else;
         @@fech=*Day*1000000+*Month*10000+*Year;
       endif;

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       setll %kds( k1yet9 : 4 ) pahet9;
       reade %kds( k1yet9 : 4 ) pahet9;

       dow not %eof ( pahet9 );

         if not SPVVEH_CheckPatenteDupli ( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : t9nmat
                                         : t9poco
                                         : @@fech
                                         : @@padu );

           if %parms >= 6 and %addr( pePadu ) <> *null;
             pePadu = @@padu;
           endif;

           return *On;

         endif;

         reade %kds( k1yet9 : 4 ) pahet9;

       enddo;

       return *Off;

      /end-free

     P SPVVEH_CheckPatenteDupliSpol...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_franquiciaManual: Valida si tiene franquicia Manual   *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *        pePoco (input)  Componente                            *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_franquiciaManual...
     P                 B                   export
     D SPVVEH_franquiciaManual...
     D                 pi              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   pePoco                       4  0   const

     D   @@Mfra        s              1
     D   @@Ifra        s             15  2

     D   k1yet9        ds                    likerec( p1het911 : *key )

      /free

       SPVVEH_inz();

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       k1yet9.t9poco = pePoco;
       chain %kds( k1yet9 ) pahet911;
       if %found( pahet911 );

         SPDETFRA( t9arcd
                 : t9spol
                 : t9rama
                 : t9arse
                 : t9oper
                 : t9poco
                 : @@Mfra
                 : @@Ifra );

         if @@Mfra = '1';
           SetError( SPVVEH_FRAMA
                   : 'Tipo de Franquicia Manual');
           return *On;
         endif;

       endif;

       return *Off;

      /end-free

     P SPVVEH_franquiciaManual...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_franquiciaManualSpol: Valida si SuperPoliza           *
      *                                     tiene franquicia Manual  *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_franquiciaManualSpol...
     P                 B                   export
     D SPVVEH_franquiciaManualSpol...
     D                 pi              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

     D   k1yet9        ds                    likerec( p1het9 : *key )

      /free

       SPVVEH_inz();

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;

       setll %kds( k1yet9 : 4 ) pahet9;
       reade %kds( k1yet9 : 4 ) pahet9;

       dow not %eof( pahet9 );

         if SPVVEH_franquiciaManual( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : t9Poco );
           return *On;

         endif;

         reade %kds( k1yet9 : 4 ) pahet9;

       enddo;

       return *Off;

      /end-free

     P SPVVEH_franquiciaManualSpol...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_tablasRcAir: Valida si tiene AIR                      *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_tablasRcAir...
     P                 B                   export
     D SPVVEH_tablasRcAir...
     D                 pi              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

     D   @@Empr        s              1
     D   @@Sucu        s              2
     D   @@Arcd        s              6  0
     D   @@Spol        s              9  0
     D   @@Band        s              2
     D   @@Ban1        s              2

      /free

       SPVVEH_inz();

       @@Empr = peEmpr;
       @@Sucu = peSucu;
       @@Arcd = peArcd;
       @@Spol = peSpol;


       PAR651H( @@Empr
              : @@Sucu
              : @@Arcd
              : @@Spol
              : @@Band
              : @@Ban1 );

       if @@Band = 'SI' or
          @@Ban1 = 'SI';

         SetError( SPVVEH_RCAIR
                 : 'Tablas de RC/AIR en Cero');
         return *Off;

       endif;

       return *On;

      /end-free

     P SPVVEH_tablasRcAir...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaMovAut() Suma Maxima Mov Automaticos           *
      *                                                              *
      *        peArcd (input)  Articulo                              *
      *        peTiou (input)  Tipo Operacion                        *
      *        peStou (input)  SubTipo Operacion                     *
      *                                                              *
      * Retorna: Monto                                               *
      * ------------------------------------------------------------ *
     P SPVVEH_getSumaMovAut...
     P                 B                   export
     D SPVVEH_getSumaMovAut...
     D                 pi            15  2
     D   peArcd                       6  0   const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const

     D k1y155          ds                    likeRec(s1t155:*Key)

       SPVVEH_inz();

       k1y155.t@ento = 'Z';
       k1y155.t@arcd = peArcd;
       k1y155.t@tiou = peTiou;
       k1y155.t@stou = peStou;

       chain %kds ( k1y155 ) set155;

       if %found ( set155 );
         return t@caha;
       endif;

       return *all'9';

     P SPVVEH_getSumaMovAut...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet0(): Retorna Registro de PAHET0               *
      *                                                              *
      * DEPRECATED: Usar SPVVEH_getPahet02().                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peSspo   (input)   Suplemento                            *
      *     peDsT0   (Output)  Registro con PAHET0                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getPahet0...
     P                 B                   export
     D SPVVEH_getPahet0...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass)
     D   peDsT0                            likeds(dsPahet0_t)
     D                                     options(*nopass:*omit)

     D p2DsT0          ds                  likeds(dsPahet02_t)
     D rc              s              1n

       SPVVEH_inz();

       if %parms >= 8 and %addr( peSspo ) <> *null;
          rc = SPVVEH_getPahEt02( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol
                                : peRama
                                : peArse
                                : pePoco
                                : peSspo
                                : p2DsT0 );
        else;
          rc = SPVVEH_getPahEt02( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol
                                : peRama
                                : peArse
                                : pePoco
                                : *omit
                                : p2DsT0 );
       endif;

       if rc;
          if %parms >= 9 and %addr( peDsT0 ) <> *null;
             eval-corr peDsT0 = p2DsT0;
          endif;
       endif;

       return rc;

     P SPVVEH_getPahet0...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet9(): Retorna Registro de PAHET9               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peDsT9   (Output)  Registro con PAHET9                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getPahet9...
     P                 B                   export
     D SPVVEH_getPahet9...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peDsT9                            likeds(dsPahet9_t)
     D                                     options(*nopass:*omit)

     D k1yet9          ds                  likeRec(p1het9:*Key)

     D @@DsT0          ds                  likeds(dsPahet0_t)
     D dsEt9           ds                  likerec(p1het9:*input)

       SPVVEH_inz();

       if SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                           : peArse : pePoco : *Omit  : @@DsT0 );

         k1yet9.t9empr = peEmpr;
         k1yet9.t9sucu = peSucu;
         k1yet9.t9arcd = peArcd;
         k1yet9.t9spol = peSpol;
         k1yet9.t9rama = peRama;
         k1yet9.t9arse = peArse;
         k1yet9.t9oper = @@DsT0.t0oper;
         k1yet9.t9poco = pePoco;

         chain %kds( k1yet9 ) pahet9 dsEt9;

         if not %found ( pahet9 );
           return *Off;
         endif;

         if %parms >= 8 and %addr( peDsT9 ) <> *null;
           eval-corr peDsT9 = dsEt9;
         endif;

         return *On;

       else;

         return *off;

       endif;

     P SPVVEH_getPahet9...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getSumaAccesorios() Suma Total de Accesorios          *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Arse                                  *
      *        pePoco (input)  Componente                            *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getSumaAccesorios...
     P                 B                   export
     D SPVVEH_getSumaAccesorios...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yet1        ds                    likerec( p1het1 : *key )

     D @@DsT0          ds                  likeds(dsPahet0_t)

     D @@suma          s             15  2

       SPVVEH_inz();

       @@suma = *Zeros;

       SPVVEH_getPahet0 ( peEmpr : peSucu : peArcd : peSpol : peRama
                        : peArse : pePoco : *Omit  : @@DsT0 );

       k1yet1.t1empr = @@Dst0.t0empr;
       k1yet1.t1sucu = @@Dst0.t0sucu;
       k1yet1.t1arcd = @@Dst0.t0arcd;
       k1yet1.t1spol = @@Dst0.t0spol;
       k1yet1.t1sspo = @@Dst0.t0sspo;
       k1yet1.t1rama = @@Dst0.t0rama;
       k1yet1.t1arse = @@Dst0.t0arse;

       setll %kds( k1yet1 : 7 ) pahet1;
       reade %kds( k1yet1 : 7 ) pahet1;

       dow not %eof( pahet1 );

         @@suma += t1accv;

         reade %kds( k1yet1 : 7 ) pahet1;

       enddo;

       return @@suma;

      /end-free

     P SPVVEH_getSumaAccesorios...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getAÑoVehiculo(): Retorna Año del Vehiculo            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getAÑoVehiculo...
     P                 B                   export
     D SPVVEH_getAÑoVehiculo...
     D                 pi             4  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass)
      *
     D   @@VeT0        ds                  likeds(dsPahet0_t)

         /free

          if %parms >= 8 and %addr(peSspo) <> *null;
            SPVVEH_getPahet0( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peRama
                            : peArse
                            : pePoco
                            : peSspo
                            : @@VeT0 );
           else;
            SPVVEH_getPahet0( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peRama
                            : peArse
                            : pePoco
                            : *omit
                            : @@VeT0 );
           endif;
           return  @@VeT0.t0vhaÑ;

         /end-free

     P SPVVEH_getAÑoVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getCobertura(): Retorna Cobertura de Componente       *
      *                                                              *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peArcd (input)  Articulo                              *
      *        peSpol (input)  SuperPoliza                           *
      *        pePoco (input)  Componente                            *
      *                                                              *
      * Retorna: Cobertura                                           *
      * ------------------------------------------------------------ *
     P SPVVEH_getCobertura...
     P                 B                   export
     D SPVVEH_getCobertura...
     D                 pi             2
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   pePoco                       4  0   const

     D   k1yet9        ds                    likerec( p1het911 : *key )

     D @@DsT0          ds                  likeds(dsPahet0_t)

       SPVVEH_inz();

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9arcd = peArcd;
       k1yet9.t9spol = peSpol;
       k1yet9.t9poco = pePoco;
       setll %kds( k1yet9 : 5 ) pahet911;
       reade %kds( k1yet9 : 5 ) pahet911;

       SPVVEH_getPahet0 ( t9empr : t9sucu : t9arcd : t9spol : t9rama
                        : t9arse : t9poco : *Omit  : @@DsT0 );

       return @@DsT0.t0cobl;

       return *On;

     P SPVVEH_getCobertura...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getCodDeRastreador(): Retorna Código de Rastreador    *
      *                              para Anterior.-                 *
      *        peEmpr (input)  Empresa                               *
      *        peSucu (input)  Sucursal                              *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Cant. de Polizas por rama             *
      *        pePoco (input)  Componente                            *
      *        peArcd (input)  Cod. de Articulo                      *
      *        peSpol (Input)  Super Poliza                          *
      *                                                              *
      * Retorna: Cod. Rastreador / *Zeros                            *
      * ------------------------------------------------------------ *
     P SPVVEH_getCodDeRastreador...
     P                 B                   export
     D SPVVEH_getCodDeRastreador...
     D                 pi             3  0
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const

     D   k1yet4        ds                  likerec( p1het4 : *key )
     D   @@DsT0        ds                  likeds( dsPahet0_t )

      /free

         SPVVEH_getPahet0( peEmpr
                         : peSucu
                         : peArcd
                         : peSpol
                         : peRama
                         : peArse
                         : pePoco
                         : *omit
                         : @@Dst0 );

         setll *loval set243;
         read set243;
         dow not %eof( set243 );
           if t6mweb = '1';
             k1yet4.t4empr = @@Dst0.t0empr;
             k1yet4.t4sucu = @@Dst0.t0sucu;
             k1yet4.t4arcd = @@Dst0.t0arcd;
             k1yet4.t4spol = @@Dst0.t0spol;
             k1yet4.t4sspo = @@Dst0.t0sspo;
             k1yet4.t4rama = @@Dst0.t0rama;
             k1yet4.t4arse = @@Dst0.t0arse;
             k1yet4.t4oper = @@Dst0.t0oper;
             k1yet4.t4suop = @@Dst0.t0suop;
             k1yet4.t4poco = @@Dst0.t0poco;
             k1yet4.t4ccbp = t6ccbp;
             setll %kds( k1yet4 ) pahet4;
             if %equal( pahet4 );
               return t6cras;
             endif;
           endif;
          read set243;
         enddo;

         return *zeros;

      /end-free

     P SPVVEH_getCodDeRastreador...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkVehiculo0km: Valida si vehiculo es 0KM             *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: *off = No es valido como 0km / *off = 0KM valido    *
      * ------------------------------------------------------------ *
     P SPVVEH_chkVehiculo0km...
     P                 B                   export
     D SPVVEH_chkVehiculo0km...
     D                 pi              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

      /free

       SPVVEH_inz();

       if SPVVEH_getValor0km( peVhmc
                            : peVhmo
                            : peVhcs  ) = *zeros;

         SetError( SPVVEH_NO0KM
                 : 'Vehiculo no apto para 0KM');
         Initialized = *OFF;
         return *off;
       endif;

       return *on;

      /end-free
     P SPVVEH_chkVehiculo0km...
     P                 E
      * ------------------------------------------------------------ *
      * SPVVEH_getValor0km(): Retorna Valor de 0km                   *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: 0 = No tiene valor / > 0 Valor                      *
      * ------------------------------------------------------------ *
     P SPVVEH_getValor0km...
     P                 B                   export
     D SPVVEH_getValor0km...
     D                 pi            15  2
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D   @@vhcr        s              3
     D   k1t206        ds                  likerec( s1t206 : *key )

      /free

       SPVVEH_inz();
       @@vhcr = SPVVEH_getCarroceria( peVhmc
                                    : peVhmo
                                    : peVhcs );
       k1t206.t@vhmc = peVhmc;
       k1t206.t@vhmo = peVhmo;
       k1t206.t@vhcs = peVhcs;
       k1t206.t@vhcr = @@vhcr;
       chain %kds( k1t206 : 4 ) set206;
       if %found( set206 );
         return t@vh0k;
       endif;

       return *zeros;
      /end-free
     P SPVVEH_getValor0km...
     P                 E
      * ------------------------------------------------------------ *
      * SPVVEH_chkAÑoVehiculo: Valida si vehiculo corresponde al año *
      *                        ingresado                             *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *     peVhan   (input)   Año del Vehiculo                      *
      *                                                              *
      * Retorna: *off = No es valido para el año / *off = Valido     *
      * ------------------------------------------------------------ *
     P SPVVEH_chkAÑoVehiculo...
     P                 B                   export
     D SPVVEH_chkAÑoVehiculo...
     D                 pi              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhan                       4  0 const

     D   @@vhcr        s              3
     D   k1t207        ds                  likerec( s1t207 : *key )

      /free

       SPVVEH_inz();

       @@vhcr = SPVVEH_getCarroceria( peVhmc
                                    : peVhmo
                                    : peVhcs );
       k1t207.t@vhmc = peVhmc;
       k1t207.t@vhmo = peVhmo;
       k1t207.t@vhcs = peVhcs;
       k1t207.t@vhcr = @@vhcr;
       k1t207.t@vhaÑ = peVhan;
       chain %kds( k1t207 : 5 ) set207;
       if %found( set207 );
         return *on;
       endif;

       SetError( SPVVEH_NOAÑO
               : 'Vehiculo no apto para el año ingresado');
       Initialized = *OFF;
       return *off;

      /end-free
     P SPVVEH_chkAÑoVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_confirmarInspeccion():Retorna si confirma inspeccion  *
      *                                                              *
      *     peCobl   (input)   Codigo de Cobertura                   *
      *     peVhaÑ   (input)   AÑo Vehiculo                          *
      *     peTiou   (input)   Tipo de Operacion                     *
      *     peStou   (input)   Subtipo de Operacion                  *
      *     peStos   (input)   Subtipo de Operacion de Sistema       *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_confirmarInspeccion...
     P                 B                   export
     D SPVVEH_confirmarInspeccion...
     D                 pi              n
     D   peCobl                       2    Const
     D   peVhaÑ                       4    Const
     D   peTiou                       1  0 Const
     D   peStou                       3  0 Const
     D   peStos                       2  0 Const
     D   peScta                       1  0 Const

     D antVehiculo     s              4  0
     D antVehiculoP    s              4  0

     D k1y225303       ds                  likerec( s1t2253  : *Key )
     D k1y22531        ds                  likerec( s1t22531 : *Key )

      /free

       SPVVEH_inz();

       k1y225303.t@cobl = peCobl;
       setll %kds( k1y225303 : 1 ) set225303;
       reade %kds( k1y225303 : 1 ) set225303;
       if %eof ( set225303 );
          SetError( SPVVEH_SINPA
                  : 'No se Encontraron Pautas' );
          return *On;
       endif;

       k1y22531.t1cobl = peCobl;
       k1y22531.t1nres = t@nres;
       k1y22531.t1tiou = peTiou;
       k1y22531.t1stou = peStou;
       k1y22531.t1stos = peStos;
       k1y22531.t1scta = peScta;
       chain %kds( k1y22531 : 6 ) set22531;
       if not %found ( set22531 );
          return *On;
       endif;

       if ( SPVVEH_vehiculo0KM( peVhaÑ ) = 'S' );
         return *Off;
       endif;

       if ( t1emax = *Zeros );
         return *On;
       endif;

       //Antiguedad
       monitor;
         antVehiculoP = %dec( peVhaÑ : 4 : 0 );
         antVehiculo = SPVFEC_obtAÑoFecha8( ) - antVehiculoP;
       on-error;
         antVehiculo = *Zeros;
       endmon;

       if ( antVehiculo <= t1emax );
         return *Off;
       endif;

       if ( antVehiculo > t1emax );
         return *On;
       endif;

       return *On;

      /end-free

     P SPVVEH_confirmarInspeccion...
     P                 E

      * ---------------------------------------------------------------- *
      * SPVVEH_vehiculo0km() :Valida si es un 0KM o no                   *
      *                                                                  *
      *        Input :                                                   *
      *                peVhan  -  Año del Vehículo                       *
      *                                                                  *
      * Retorna: S/N                                                     *
      * ---------------------------------------------------------------- *
     P SPVVEH_vehiculo0km...
     P                 B                   Export
     D SPVVEH_vehiculo0km...
     D                 pi             1
     D   peVhan                       4    const

       SPVVEH_inz();

       if %trim( peVhan ) = '0km' or %trim( peVhan ) = '0Km' or
          %trim( peVhan ) = '0KM' or %trim( peVhan ) = '0kM';
         return 'S';
       endif;

       return 'N';

     P SPVVEH_vehiculo0km...
     P                 E

      * ---------------------------------------------------------------- *
      * getInspector(): retorna Inspectores de Zona                      *
      *                                                                  *
      *        Input :                                                   *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  SubCodigo Postal                       *
      *                peTipo  -  T/W(Todos / Web )                      *
      *        Output:                                                   *
      *                peNomb  -  Lista de Nombres                       *
      *                                                                  *
      * Retorna: Cantidad Lista de Nombres                               *
      * ---------------------------------------------------------------- *
     P getInspector    B
     D getInspector    pi            10i 0
     D   peCopo                       5  0 Const
     D   peCops                       1  0 Const
     D   peTipo                       1    Const
     D   peNomb                      40    Dim( 99 )

     D k1y276          ds                  likerec( s1t276 : *Key )

     D x               s             10i 0

       clear peNomb;
       x = *Zeros;

       k1y276.ticopo = peCopo;
       k1y276.ticops = peCops;
       setll %kds( k1y276 : 2 ) set276;
       reade %kds( k1y276 : 2 ) set276;
       dow not %eof ( set276 );
         if ( tiblq = '0' );
           if ( peTipo = 'W' and tiweb = '1' ) or
              ( peTipo = 'T' );
             x += 1;
             peNomb( x ) = SVPDAF_getNombre( tinrdf );
           endif;
         endif;
         reade %kds( k1y276 : 2 ) set276;
       enddo;

       return x;

     P getInspector    E

      * ---------------------------------------------------------------- *
      * SPVVEH_getInspector(): retorna Inspectores de Zona               *
      *                                                                  *
      *        Input :                                                   *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  SubCodigo Postal                       *
      *        Output:                                                   *
      *                peNomb  -  Lista de Nombres                       *
      *                                                                  *
      * Retorna: Cantidad Lista de Nombres                               *
      * ---------------------------------------------------------------- *
     P SPVVEH_getInspector...
     P                 B                   Export
     D SPVVEH_getInspector...
     D                 pi            10i 0
     D   peCopo                       5  0 Const
     D   peCops                       1  0 Const
     D   peNomb                      40    Dim( 99 )

     D k1y276          ds                  likerec( s1t276 : *Key )

     D x               s             10i 0

       SPVVEH_inz();

       return getInspector( peCopo : peCops : 'T' : peNomb );

     P SPVVEH_getInspector...
     P                 E

      * ---------------------------------------------------------------- *
      * SPVVEH_getInspectorWeb(): Retorna Inspectores de Zona Web        *
      *                                                                  *
      *        Input :                                                   *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  SubCodigo Postal                       *
      *        Output:                                                   *
      *                peNomb  -  Lista de Nombres                       *
      *                                                                  *
      * Retorna: Cantidad Lista de Nombres                               *
      * ---------------------------------------------------------------- *
     P SPVVEH_getInspectorWeb...
     P                 B                   Export
     D SPVVEH_getInspectorWeb...
     D                 pi            10i 0
     D   peCopo                       5  0 Const
     D   peCops                       1  0 Const
     D   peNomb                      40    Dim( 99 )

     D k1y276          ds                  likerec( s1t276 : *Key )

     D x               s             10i 0

       SPVVEH_inz();

       return getInspector( peCopo : peCops : 'W' : peNomb );

     P SPVVEH_getInspectorWeb...
     P                 E

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimiteMaximoRuedasCristales: Retorna Límite Máximo de  *
      *                                        Ruedas y Cristales        *
      *                                                                  *
      *        Input :                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                peCobl  -  Cobertura                              *
      *        Output:                                                   *
      *                peMaxr  -  Límite Máximo de Ruedas                *
      *                peMaxc  -  Límite Máximo de Cristales             *
      *                                                                  *
      * Retorna: *On / *Off                                              *
      * ---------------------------------------------------------------- *
     P SPVVEH_getLimiteMaximoRuedasCristales...
     P                 B                   Export
     D SPVVEH_getLimiteMaximoRuedasCristales...
     D                 pi              n
     D   peCtre                       5  0 Const
     D   peCobl                       2    Const
     D   peMaxr                      15  2
     D   peMaxc                      15  2

     D k1y271          ds                  likerec( s1t271 : *Key )

       SPVVEH_inz();

       k1y271.t7Ctre = peCtre;
       k1y271.t7Cobl = peCobl;
       setgt  %kds( k1y271 : 2 ) set271;
       readpe %kds( k1y271 : 2 ) set271;
       if not %eof( set271 );
         peMaxr = t7Maxr;
         peMaxc = t7Maxc;
         return *on;
       endif;

       return *off;

     P SPVVEH_getLimiteMaximoRuedasCristales...
     P                 E

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimiteMaximoRuedas: Retorna Límite Máximo de Ruedas    *
      *                                                                  *
      *        Input :                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                peCobl  -  Cobertura                              *
      *        Output:                                                   *
      *                peMaxr  -  Límite Máximo de Ruedas                *
      *                                                                  *
      * Retorna: *On / *Off                                              *
      * ---------------------------------------------------------------- *
     P SPVVEH_getLimiteMaximoRuedas...
     P                 B                   Export
     D SPVVEH_getLimiteMaximoRuedas...
     D                 pi
     D   peCtre                       5  0 Const
     D   peCobl                       2    Const
     D   peMaxr                      15  2

     D p@Maxc          s             15  2

       SPVVEH_inz();

       SPVVEH_getLimiteMaximoRuedasCristales( peCtre
                                            : peCobl
                                            : peMaxr
                                            : p@Maxc );

     P SPVVEH_getLimiteMaximoRuedas...
     P                 E

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimiteMaximoCristales: Retorna Límite Máximo de Cris-  *
      *                                  tales                           +
      *                                                                  *
      *        Input :                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                peCobl  -  Cobertura                              *
      *        Output:                                                   *
      *                peMaxc  -  Límite Máximo de Cristales             *
      *                                                                  *
      * Retorna: *On / *Off                                              *
      * ---------------------------------------------------------------- *
     P SPVVEH_getLimiteMaximoCristales...
     P                 B                   Export
     D SPVVEH_getLimiteMaximoCristales...
     D                 pi
     D   peCtre                       5  0 Const
     D   peCobl                       2    Const
     D   peMaxc                      15  2

     D p@Maxr          s             15  2

       SPVVEH_inz();

       SPVVEH_getLimiteMaximoRuedasCristales( peCtre
                                            : peCobl
                                            : p@Maxr
                                            : peMaxc );

     P SPVVEH_getLimiteMaximoCristales...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getCodEquixCodDesRec: Retorna Código Compo. Bonif.    *
     ?*                              Prima equivalente               *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Póliza                               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Cant.de Polizas                      *
     ?*     peCcbp   ( input  ) Cód. Componente Bonif.               *
     ?*     peCcbe   ( output ) Cód. Compo. Bonif. Equiv.            *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getCodEquixCodDesRec...
     P                 b                   export
     D SPVVEH_getCodEquixCodDesRec...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peCcbp                       3  0 const
     D   peCcbe                       3    options( *nopass : *omit )

     D   @@Ds406       ds                  likeds( dsPahet406_t ) dim( 999 )
     D   @@Ds406C      s             10i 0
     D   i             s             10i 0

      /free

       SPVVEH_inz();

       if SPVVEH_getListaDescuentoRecargo( peEmpr
                                         : peSucu
                                         : peRama
                                         : pePoli
                                         : pePoco
                                         : peSuop
                                         : @@Ds406
                                         : @@Ds406C );

         for i = 1 to @@Ds406C;
           if @@Ds406(i).t4Ccbp = peCcbp;
             peCcbe = @@Ds406(i).stCcbe;
             return *on;
           endif;
         endfor;

       endif;

       return *off;

      /end-free

     P SPVVEH_getCodEquixCodDesRec...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getCodDesRecxCodEqui: Retorna Código Compo. Bonif.    *
     ?*                              Prima                           *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Póliza                               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Cant.de Polizas                      *
     ?*     peCcbe   ( input  ) Cód. Compo. Bonif. Equiv.            *
     ?*     peCcbp   ( output ) Cód. Componente Bonif.               *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getCodDesRecxCodEqui...
     P                 b                   export
     D SPVVEH_getCodDesRecxCodEqui...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peCcbe                       3    const
     D   peCcbp                       3  0 options( *nopass : *omit )

     D   @@Ds406       ds                  likeds( dsPahet406_t ) dim( 999 )
     D   @@Ds406C      s             10i 0
     D   i             s             10i 0

      /free

       SPVVEH_inz();

       if SPVVEH_getListaDescuentoRecargo( peEmpr
                                         : peSucu
                                         : peRama
                                         : pePoli
                                         : pePoco
                                         : peSuop
                                         : @@Ds406
                                         : @@Ds406C );
         for i = 1 to @@Ds406C;
           if @@Ds406(i).stCcbe = peCcbe;
             peCcbp = @@Ds406(i).t4Ccbp;
             return *on;
           endif;
         endfor;

       endif;

       return *off;

      /end-free

     P SPVVEH_getCodDesRecxCodEqui...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getListaDescuentoRecargo: Retorna Lista de descuento/ *
     ?*                                  recargo                     *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Póliza                               *
     ?*     pePoco   ( input  ) Componente                (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peDs406  ( output ) Cód. Componente Bonif.               *
     ?*     peDs406  ( output ) Cód. Compo. Bonif. Equiv.            *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getListaDescuentoRecargo...
     P                 b                   export
     D SPVVEH_getListaDescuentoRecargo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDs406                           likeds( dsPahet406_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDs406C                    10i 0 options( *nopass : *omit )

     D   k1yet4        ds                  likerec( p1het406 : *key )
     D   @@DsID406     ds                  likerec( p1het406 : *input )
     D   @@DsD406      ds                  likeds( dsPahet406_t ) dim( 999 )
     D   @@DsD406C     s             10i 0

      /free

       SPVVEH_inz();

       k1yet4.t4Empr = peEmpr;
       k1yet4.t4Sucu = peSucu;
       k1yet4.t4Rama = peRama;
       k1yet4.t4Poli = pePoli;

       if %parms >= 5;
         Select;
           when %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null;

             k1yet4.t4Poco = pePoco;
             k1yet4.t4Suop = peSuop;
             setll %kds( k1yet4 : 6 ) pahet406;
             if not %equal( pahet406 );
               return *off;
             endif;
             reade(n) %kds( k1yet4 : 6 ) pahet406 @@DsID406;
             dow not %eof( pahet406 );
               @@DsD406C += 1;
               eval-corr @@DsD406( @@DsD406C ) = @@DsID406;
               reade(n) %kds( k1yet4 : 6 ) pahet406 @@DsID406;
             enddo;

           when %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null;

             k1yet4.t4Poco = pePoco;
             setll %kds( k1yet4 : 5 ) pahet406;
             if not %equal( pahet406 );
               return *off;
             endif;
             reade(n) %kds( k1yet4 : 5 ) pahet406 @@DsID406;
             dow not %eof( pahet406 );
               @@DsD406C += 1;
               eval-corr @@DsD406( @@DsD406C ) = @@DsID406;
               reade(n) %kds( k1yet4 : 5 ) pahet406 @@DsID406;
             enddo;

           other;

             setll %kds( k1yet4 : 4 ) pahet406;
             if not %equal( pahet406 );
               return *off;
             endif;
             reade(n) %kds( k1yet4 : 4 ) pahet406 @@DsID406;
             dow not %eof( pahet406 );
               @@DsD406C += 1;
               eval-corr @@DsD406( @@DsD406C ) = @@DsID406;
               reade(n) %kds( k1yet4 : 4 ) pahet406 @@DsID406;
             enddo;

         endsl;
       else;

         setll %kds( k1yet4 : 4 ) pahet406;
         if not %equal( pahet406 );
           return *off;
         endif;
         reade(n) %kds( k1yet4 : 4 ) pahet406 @@DsID406;
         dow not %eof( pahet406 );
           @@DsD406C += 1;
           eval-corr @@DsD406( @@DsD406C ) = @@DsID406;
           reade(n) %kds( k1yet4 : 4 ) pahet406 @@DsID406;
         enddo;

       endif;

       if %parms >= 5;
         if %addr( peDs406 ) <> *null;
           eval-corr peDs406 = @@DsD406;
         endif;
         if %addr( peDs406C ) <> *null;
           peDs406C = @@DsD406C;
         endif;
       endif;

       return *on;

      /end-free

     P SPVVEH_getListaDescuentoRecargo...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getRastreadorXSpol(): Retorna Rastreador por Super-   *
      *                              poliza                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: Código de Rastreador / 0 Si no existe               *
      * ------------------------------------------------------------ *

     P SPVVEH_getRastreadorXSpol...
     P                 B                   export
     D SPVVEH_getRastreadorXSpol...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const

     D x               s             10i 0
     D @@Poli          s              7  0

     D k1yet4          ds                  likerec( p1het4 : *key )
     D @@Ds406         ds                  likeds( dsPahet406_t ) dim( 999 )
     D @@Ds406C        s             10i 0

      /free

       SPVVEH_Inz();

       clear @@Ds406;
       clear @@Ds406C;

       @@Poli = SPVSPO_getPoliza( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol );

       if @@Poli > 0;
         if SPVVEH_getListaDescuentoRecargo( peEmpr
                                           : peSucu
                                           : peRama
                                           : @@Poli
                                           : *omit
                                           : *omit
                                           : @@Ds406
                                           : @@Ds406C );

           for x = 1 to @@Ds406C;
             if @@Ds406(x).t4Ccbp = 3 or @@Ds406(x).t4Ccbp = 35;
               return @@Ds406(x).t4Ccbp;
             endif;
           endfor;
         endif;
       endif;

       return 0;

      /end-free

     P SPVVEH_getRastreadorXSpol...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkSeguroRegistro(): Chequea Seguro de Registro       *
      *                             Si es Capitulo = 33              *
      *                                                              *
      *     peVhca   (input)   Capitulo del Vehiculo                 *
      *                                                              *
      * Retorna: *On / *Off y Descripcion de Capitulo si Recibe      *
      *          Parametro peCvde                                    *
      * ------------------------------------------------------------ *

     P SPVVEH_chkSeguroRegistro...
     P                 B                   export
     D SPVVEH_chkSeguroRegistro...
     D                 pi             1n
     D   peVhca                       2  0 const

     D k1s215          ds                  likerec(s1t215:*key)

      /free

       SPVVEH_Inz();

       k1s215.t@vhca = peVhca;
       chain %kds(k1s215:1) set215;

       if %found;
        if t@vhca <> 33;
           SetError( SPVVEH_VCPNS
                   : 'Capitulo no es seguro de registro' );
           Initialized = *OFF;
           return *off;
         else;
           Initialized = *OFF;
           return *on;
        endif;
       endif;


      /end-free

     P SPVVEH_chkSeguroRegistro...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet3: Retorna datos Prod.Art. Rama Automotores.  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peSuop   ( input  ) Suplemento de la operacion           *
     ?*     peOper   ( input  ) Operacion                            *
     ?*     peTaaj   ( input  ) Cod. Tabla ajuste                    *
     ?*     peCosg   ( input  ) Item de Scoring                      *
     ?*     peDst3   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst3C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*     peForm   ( input  ) Formatear Valores                    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getPahet3...
     P                 b                   export
     D SPVVEH_getPahet3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peTaaj                       2  0 options( *nopass : *omit ) const
     D   peCosg                       4    options( *nopass : *omit ) const
     D   peDst3                            likeds ( dspahet3_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst3C                     10i 0 options( *nopass : *omit )
     D   peForm                       1    options( *nopass : *omit )

     D   k1yet3        ds                  likerec( p1het3 : *key )
     D   @@DsIt3       ds                  likerec( p1het3 : *input )
     D   @@Dst3        ds                  likeds ( dspahet3_t ) dim( 999 )
     D   @@Dst3C       s             10i 0

      /free

       SPVVEH_inz();

       clear k1yet3;
       clear @@Dst3;
       clear @@Dst3C;

       k1yet3.t3Empr = peEmpr;
       k1yet3.t3Sucu = peSucu;
       k1yet3.t3Arcd = peArcd;
       k1yet3.t3Spol = peSpol;
       k1yet3.t3Rama = peRama;
       k1yet3.t3Arse = peArse;
       k1yet3.t3Poco = pePoco;

       select;
         when %parms >= 12 and %addr( peSspo ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( peTaaj ) <> *null
                           and %addr( peCosg ) <> *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           k1yet3.t3Oper = peOper;
           k1yet3.t3Taaj = peTaaj;
           k1yet3.t3Cosg = peCosg;
           setll %kds( k1yet3 : 12 ) pahet301;
           if not %equal( pahet301 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 12 ) pahet301 @@DsIt3;
           dow not %eof( pahet301 );
             @@Dst3C += 1;
             if %addr( peForm ) <> *null;
               if peForm = 'S';
                 select;
                   when @@DsIt3.t3Vefa = '1';
                     @@DsIt3.t3Vefa = 'V';
                   when @@DsIt3.t3Vefa = '0';
                     @@DsIt3.t3Vefa = 'F';
                 endsl;
               endif;
             endif;
             eval-corr @@Dst3( @@Dst3C ) = @@DsIt3;
             reade(n) %kds( k1yet3 : 12 ) pahet301 @@DsIt3;
           enddo;

         when %parms >= 11 and %addr( peSspo ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( peTaaj ) <> *null
                           and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           k1yet3.t3Oper = peOper;
           k1yet3.t3Taaj = peTaaj;
           setll %kds( k1yet3 : 11 ) pahet301;
           if not %equal( pahet301 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 11 ) pahet301 @@DsIt3;
           dow not %eof( pahet301 );
             @@Dst3C += 1;
             if %addr( peForm ) <> *null;
               if peForm = 'S';
                 select;
                   when @@DsIt3.t3Vefa = '1';
                     @@DsIt3.t3Vefa = 'V';
                   when @@DsIt3.t3Vefa = '0';
                     @@DsIt3.t3Vefa = 'F';
                 endsl;
               endif;
             endif;
             eval-corr @@Dst3( @@Dst3C ) = @@DsIt3;
             reade(n) %kds( k1yet3 : 11 ) pahet301 @@DsIt3;
           enddo;

         when %parms >= 10 and %addr( peSspo ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( peTaaj ) =  *null
                           and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           k1yet3.t3Oper = peOper;
           setll %kds( k1yet3 : 10 ) pahet301;
           if not %equal( pahet301 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 10 ) pahet301 @@DsIt3;
           dow not %eof( pahet301 );
             @@Dst3C += 1;
             if %addr( peForm ) <> *null;
               if peForm = 'S';
                 select;
                   when @@DsIt3.t3Vefa = '1';
                     @@DsIt3.t3Vefa = 'V';
                   when @@DsIt3.t3Vefa = '0';
                     @@DsIt3.t3Vefa = 'F';
                 endsl;
               endif;
             endif;
             eval-corr @@Dst3( @@Dst3C ) = @@DsIt3;
             reade(n) %kds( k1yet3 : 10 ) pahet301 @@DsIt3;
           enddo;

         when %parms >= 9 and %addr( peSspo ) <> *null
                          and %addr( peSuop ) <> *null
                          and %addr( peOper ) =  *null
                          and %addr( peTaaj ) =  *null
                          and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           setll %kds( k1yet3 : 9 ) pahet301;
           if not %equal( pahet301 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 9 ) pahet301 @@DsIt3;
           dow not %eof( pahet301 );
             @@Dst3C += 1;
             if %addr( peForm ) <> *null;
               if peForm = 'S';
                 select;
                   when @@DsIt3.t3Vefa = '1';
                     @@DsIt3.t3Vefa = 'V';
                   when @@DsIt3.t3Vefa = '0';
                     @@DsIt3.t3Vefa = 'F';
                 endsl;
               endif;
             endif;
             eval-corr @@Dst3( @@Dst3C ) = @@DsIt3;
             reade(n) %kds( k1yet3 : 9 ) pahet301 @@DsIt3;
           enddo;

         when %parms >= 8 and %addr( peSspo ) <> *null
                          and %addr( peSuop ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( peTaaj ) =  *null
                          and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           setll %kds( k1yet3 : 8 ) pahet301;
           if not %equal( pahet301 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 8 ) pahet301 @@DsIt3;
           dow not %eof( pahet301 );
             @@Dst3C += 1;
             if %addr( peForm ) <> *null;
               if peForm = 'S';
                 select;
                   when @@DsIt3.t3Vefa = '1';
                     @@DsIt3.t3Vefa = 'V';
                   when @@DsIt3.t3Vefa = '0';
                     @@DsIt3.t3Vefa = 'F';
                 endsl;
               endif;
             endif;
             eval-corr @@Dst3( @@Dst3C ) = @@DsIt3;
             reade(n) %kds( k1yet3 : 8 ) pahet301 @@DsIt3;
           enddo;

         other;
           setll %kds( k1yet3 : 7 ) pahet301;
           if not %equal( pahet301 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 7 ) pahet301 @@DsIt3;
           dow not %eof( pahet301 );
             @@Dst3C += 1;
             if %addr( peForm ) <> *null;
               if peForm = 'S';
                 select;
                   when @@DsIt3.t3Vefa = '1';
                     @@DsIt3.t3Vefa = 'V';
                   when @@DsIt3.t3Vefa = '0';
                     @@DsIt3.t3Vefa = 'F';
                 endsl;
               endif;
             endif;
             eval-corr @@Dst3( @@Dst3C ) = @@DsIt3;
             reade(n) %kds( k1yet3 : 7 ) pahet301 @@DsIt3;
           enddo;

       endsl;

       if %addr( peDst3 ) <> *null;
         eval-corr peDst3 = @@Dst3;
       endif;

       if %addr( peDst3C ) <> *null;
         eval peDst3C = @@Dst3C;
       endif;

       return *on;

      /end-free

     P SPVVEH_getPahet3...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_chkPahet3: Retorna datos Prod.Art. Rama Automotores.  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peSuop   ( input  ) Suplemento de la operacion           *
     ?*     peOper   ( input  ) Operacion                            *
     ?*     peTaaj   ( input  ) Cod. Tabla ajuste                    *
     ?*     peCosg   ( input  ) Item de Scoring                      *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_chkPahet3...
     P                 b                   export
     D SPVVEH_chkPahet3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peTaaj                       2  0 options( *nopass : *omit ) const
     D   peCosg                       4    options( *nopass : *omit ) const

     D   k1yet3        ds                  likerec( p1het3 : *key )

      /free

       SPVVEH_inz();

       k1yet3.t3Empr = peEmpr;
       k1yet3.t3Sucu = peSucu;
       k1yet3.t3Arcd = peArcd;
       k1yet3.t3Spol = peSpol;
       k1yet3.t3Rama = peRama;
       k1yet3.t3Arse = peArse;
       k1yet3.t3Poco = pePoco;

       select;
         when %parms >= 12 and %addr( peSspo ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( peTaaj ) <> *null
                           and %addr( peCosg ) <> *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           k1yet3.t3Oper = peOper;
           k1yet3.t3Taaj = peTaaj;
           k1yet3.t3Cosg = peCosg;
           setll %kds( k1yet3 : 12 ) pahet301;

         when %parms >= 11 and %addr( peSspo ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( peTaaj ) <> *null
                           and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           k1yet3.t3Oper = peOper;
           k1yet3.t3Taaj = peTaaj;
           setll %kds( k1yet3 : 11 ) pahet301;

         when %parms >= 10 and %addr( peSspo ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( peTaaj ) =  *null
                           and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           k1yet3.t3Oper = peOper;
           setll %kds( k1yet3 : 10 ) pahet301;

         when %parms >= 9 and %addr( peSspo ) <> *null
                          and %addr( peSuop ) <> *null
                          and %addr( peOper ) =  *null
                          and %addr( peTaaj ) =  *null
                          and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           k1yet3.t3Suop = peSuop;
           setll %kds( k1yet3 : 9 ) pahet301;

         when %parms >= 8 and %addr( peSspo ) <> *null
                          and %addr( peSuop ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( peTaaj ) =  *null
                          and %addr( peCosg ) =  *null;

           k1yet3.t3Sspo = peSspo;
           setll %kds( k1yet3 : 8 ) pahet301;

         other;

           setll %kds( k1yet3 : 7 ) pahet301;

       endsl;

       return %equal();

      /end-free

     P SPVVEH_chkPahet3...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getUltimoSuplemento(): Retorna último suplemento.     *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( output ) Suplemento de la superpoliza         *
     ?*     peSuop   ( output ) Suplemento de la operación           *
     ?*     peOper   ( output ) operacion       ( opcional )         *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getUltimoSuplemento...
     P                 b                   export
     D SPVVEH_getUltimoSuplemento...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0
     D   peSuop                       3  0
     D   peOper                       7  0 options(*nopass:*omit)

     D   k1yet0        ds                  likerec( p1het004 : *key )

      /free

       SPVVEH_inz();

       k1yet0.t0Empr = peEmpr;
       k1yet0.t0Sucu = peSucu;
       k1yet0.t0Arcd = peArcd;
       k1yet0.t0Spol = peSpol;
       k1yet0.t0Rama = peRama;
       k1yet0.t0Arse = peArse;
       k1yet0.t0Poco = pePoco;

       setll %kds( k1yet0 : 7 ) pahet004;
       if not %equal( pahet004 );
         return *off;
       endif;

       reade(n) %kds( k1yet0 : 7 ) pahet004;

       peSspo = t0Sspo;
       peSuop = t0Suop;

       if %parms>=10 and %addr( peOper) <> *null;
         peOper = t0oper;
       endif;

       return *on;

      /end-free

     P SPVVEH_getUltimoSuplemento...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_validaPreguntas(): Valida Detalle del Scoring         *
     ?*                                                              *
     ?*     peArcd   ( input  ) Codigo de Articulo                   *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( input  ) Estr. Items de un componente         *
     ?*     peDsIteC ( input  ) Cant. Items de un componente         *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_validaPreguntas...
     P                 b                   export
     D SPVVEH_validaPreguntas...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200)
     D   peDsIteC                    10i 0

     D i               s             10i 0
     D x               s             10i 0
     D itc             s              4    dim(200)
     D ix1             s              4    dim(200)
     D ix2             s              4    dim(200)
     D ix3             s              4    dim(200)
     D @@coex          s              4
     D z@cosg          s              1
     D @@Ds371         ds                  likeds ( set2371_t )

      /free

       SPVVEH_inz();

       clear itc;
       clear ix1;
       clear ix2;
       clear ix3;

       // Valida que el Artículo requiera Scoring...

       if SVPART_chkScoring( peArcd
                           : peRama
                           : peArse );

         if peTaaj = *zeros or peDsIte(1).Cosg = *blanks;

           SetError( SPVVEH_ARCSC
                   : 'El Articulo: (' + %char(peArcd) + '), requiere +
                      responder el Cuestionario de Scoring.');
           Initialized = *off;
           return *off;
         endif;
       else;

         if peTaaj <> *zeros or peDsIte(1).Cosg <> *blanks;

           SetError( SPVVEH_ARCNS
                   : 'El Articulo: (' + %char(peArcd) + '), no requiere +
                      responder el Cuestionario de Scoring.');
           Initialized = *off;
           return *off;
         endif;
         return *on;
       endif;

       // Valida que el Cuestionario Existe...

       if not SVPTAB_chkCuestionario( peTaaj );

         SetError( SPVVEH_VTAAJ
                 : 'Cuestionario no existe' );
         Initialized = *off;
         return *off;
       endif;

       for x = 1 to peDsIteC;

         // Valida que existe la Pregunta para el Cuestionario...

         if not SVPTAB_getPregunta( peTaaj
                                  : peDsIte(x).Cosg
                                  : @@Ds371         );

           SetError( SPVVEH_VCOSG
                   : 'Item de Scoring (' + (peDsIte(x).Cosg) +
                     ') no existe en tabla' );
           Initialized = *off;
           return *off;
         endif;

         // Valida respuesta Verdadero o Falso...

         if peDsIte(x).Vefa <> 'F' and peDsIte(x).Vefa <> 'V';

           SetError( SPVVEH_VVEFA
                   : 'Resultado del Item (' + (peDsIte(x).Cosg) + ') debe   +
                      ser F=Falso o V=Verdadero' );
           Initialized = *off;
           return *off;
         endif;

         // Valida si se informa Cantidad...

         if peDsIte(x).Cant <> *zeros and @@Ds371.t@Mar2 = '0';

           SetError( SPVVEH_VCANT
                   : 'Item de Scoring (' + (peDsIte(x).Cosg) + ') no admit  e +
                      que se cargue cantidad' );
           Initialized = *off;
           return *off;
         endif;

         // Valida que no se duplique el ítem...

         i = %lookup( peDsIte(x).Cosg : itc : 1 );
         if i = 0;
           i = %lookup( *blanks : itc : 1 );
           itc(i) = peDsIte(x).Cosg;
         else;

           SetError( SPVVEH_VDCOS
                   : 'Item de Scoring (' + (peDsIte(x).Cosg) +
                     ') duplicado' );
           Initialized = *off;
           return *off;
         endif;

       endfor;

       // Ahora tengo una serie con los Códigos Excluyentes...

       SVPTAB_getItemsExcluyentes( petaaj
                                 : ix1
                                 : ix3    );

       // Serie con los ítems Obligatorios...

       SVPTAB_getItemsObligatorio( petaaj
                                 : ix2    );

       // Validar si tiene todos los ítems Obligatorios...

       for x = 1 to 200;
         if ix2(x) <> *blanks;
           i = %lookup( ix2(x) : itc );
           if i = 0;

             SetError( SPVVEH_VOBLI
                     : 'Faltan como ingreso obligatorio el ítem (' +
                       (ix2(x)) + ')' );
             Initialized = *off;
             return *off;
           endif;
         endif;
       endfor;

       // Comparo si el ítem no es obligatorio y si se encuentra excluido
       // por otro ítem...

       for x = 1 to peDsIteC;
         i = %lookup( itc(x) : ix2 );
         if i = 0;
           i = %lookup( itc(x) : ix1 );
           if i > 0;

             SetError( SPVVEH_VDCOX
                     : 'El ítem (' + (itc(x)) + ') se encuentra +
                        excluido por el ítem (' + (ix3(i)) + ').');
             Initialized = *off;
             return *off;
           endif;
         endif;
       endfor;

       // Validar la secuencia de carga de los ítems...

       for x = 1 to peDsIteC;
         if x > 1 and itc(x) <> *blanks;
           i = x - 1;
           if itc(x) < itc(i);

             SetError( SPVVEH_VSECU
                     : 'Error en la secuencia de carga del ítem (' +
                       (itc(x)) + ')' );
             Initialized = *off;
             return *off;
           endif;
         endif;
       endfor;

       return *on;

      /end-free

     P SPVVEH_validaPreguntas...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_aplicaScoring(): Aplica Scoring en las primas anuales *
     ?*                                                              *
     ?*     pePrrc   ( input  ) Prima de RC                          *
     ?*     pePrac   ( input  ) Prima de Accidente                   *
     ?*     pePrin   ( input  ) Prima de Incendio                    *
     ?*     pePrro   ( input  ) Prima de Robo                        *
     ?*     pePacc   ( input  ) Prima de Accesorios                  *
     ?*     pePraa   ( input  ) Prima de Ajuste                      *
     ?*     pePrsf   ( input  ) Prima Sin Franquicia                 *
     ?*     pePrce   ( input  ) Prima RC Exterior                    *
     ?*     pePrap   ( input  ) Prima de AP                          *
     ?*     peActu   ( input  ) Actualiza?                           *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( in/out ) Estr. Items de un componente         *
     ?*     peDsIteC ( in/out ) Cant. Items de un componente         *
     ?*     poRrcp   ( output ) Prima de RC                          *
     ?*     poRacp   ( output ) Prima de Accidente                   *
     ?*     poRinp   ( output ) Prima de Incendio                    *
     ?*     poRrop   ( output ) Prima de Robo                        *
     ?*     poAccp   ( output ) Prima de Accesorios                  *
     ?*     poRaap   ( output ) Prima de Ajuste                      *
     ?*     poRsfp   ( output ) Prima Sin Franquicia                 *
     ?*     poRcep   ( output ) Prima RC Exterior                    *
     ?*     poRapp   ( output ) Prima de AP                          *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_aplicaScoring...
     P                 b                   export
     D SPVVEH_aplicaScoring...
     D                 pi              n
     D   pePrrc                      15  2 const
     D   pePrac                      15  2 const
     D   pePrin                      15  2 const
     D   pePrro                      15  2 const
     D   pePacc                      15  2 const
     D   pePraa                      15  2 const
     D   pePrsf                      15  2 const
     D   pePrce                      15  2 const
     D   pePrap                      15  2 const
     D   peActu                       1    const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200)
     D   peDsIteC                    10i 0
     D   poPrrc                      15  2
     D   poPrac                      15  2
     D   poPrin                      15  2
     D   poPrro                      15  2
     D   poPacc                      15  2
     D   poPraa                      15  2
     D   poPrsf                      15  2
     D   poPrce                      15  2
     D   poPrap                      15  2

     D i               s             10i 0
     D x               s             10i 0
     D @@Aux1          s             29  9
     D @@Cant          s              2  0
     D @@Corc          s              7  4
     D @@Coca          s              7  4
     D @@Tiaj          s              1
     D @@Tiac          s              1
     D @@DsCu          ds                  likeds ( set2370_t )
     D @@DsPe          ds                  likeds ( set2371_t )

      /free

       SPVVEH_inz();

       clear @@DsCu;
       clear @@DsPe;

       if not SVPTAB_getCuestionario( peTaaj
                                    : @@DsCu );

         SetError( SPVVEH_VTAAJ
                 : 'Cuestionario no existe' );
         Initialized = *off;
         return *off;
       endif;

       poPrrc = pePrrc;
       poPrac = pePrac;
       poPrin = pePrin;
       poPrro = pePrro;
       poPacc = pePacc;
       poPraa = pePraa;
       poPrsf = pePrsf;
       poPrce = pePrce;
       poPrap = pePrap;

       for x = 1 to peDsIteC;

         if peDsIte(x).Cosg <> *blanks;

           if not SVPTAB_getPregunta( peTaaj
                                    : peDsIte(x).Cosg
                                    : @@DsPe          );

             SetError( SPVVEH_VCOSG
                     : 'Item de Scoring no existe en tabla' );
             Initialized = *off;
             return *off;
           endif;

           // Determinar la cantidad de veces a aplicar...

           if peDsIte(x).Cant = *zeros;
             @@Cant = 1;
           else;
             @@Cant = peDsIte(x).Cant;
           endif;

           // Define dependiendo de la marca peActu con que valores
           // se va a trabajar.

           clear @@Corc;
           clear @@Coca;

           if peActu = '1';
             // Datos de las tablas set2370 y set2371
             @@Tiaj = @@DsCu.t@Tiaj;
             @@Tiac = @@DsCu.t@Tiac;
             select;
               // Porcentajes...
               when @@Tiaj = 'P';
                 // Convertir porcentajes en coeficientes...
                 select;
                   when peDsIte(x).Vefa = 'V';
                     if @@DsPe.t@Crc1 <> *zeros;
                       @@Corc = ( @@DsPe.t@Crc1 / 100 );
                     endif;
                     @@Corc += 1;
                     if @@DsPe.t@Cca1 <> *zeros;
                       @@Coca = ( @@DsPe.t@Cca1 / 100 );
                     endif;
                     @@Coca += 1;
                   when peDsIte(x).Vefa = 'F';
                     if @@DsPe.t@Crc2 <> *zeros;
                       @@Corc = ( @@DsPe.t@Crc2 / 100 );
                     endif;
                     @@Corc += 1;
                     if @@DsPe.t@Cca2 <> *zeros;
                       @@Coca = ( @@DsPe.t@Cca2 / 100 );
                     endif;
                     @@Coca += 1;
                 endsl;

               when @@Tiaj = 'C';

                 select;
                   when peDsIte(x).Vefa = 'V';
                     @@Corc = @@DsPe.t@Crc1;
                     @@Coca = @@DsPe.t@Cca1;
                   when peDsIte(x).Vefa = 'F';
                     @@Corc = @@DsPe.t@Crc2;
                     @@Coca = @@DsPe.t@Cca2;
                 endsl;
             endsl;

             peDsIte(x).Tiaj = @@Tiaj;
             peDsIte(x).Tiac = @@Tiac;
             peDsIte(x).Corc = @@Corc;
             peDsIte(x).Coca = @@Coca;
           else;
             // Datos de la Estructura de Items
             @@Tiaj = peDsIte(x).Tiaj;
             @@Tiac = peDsIte(x).Tiac;
             @@Corc = peDsIte(x).Corc;
             @@Coca = peDsIte(x).Coca;
           endif;

           // Forma de aplicar el Scoring...

           select;
             // Porcentajes...
             when @@Tiaj = 'P';
               // Base de cálculo del Scoring...
               select;
                 // Aplicación acumulativa...
                 when @@Tiac = 'A';

                   for i = 1 to @@Cant;
                     poPrrc *= @@Corc;
                     poPrce *= @@Corc;
                     poPrap *= @@Corc;
                     poPrac *= @@Coca;
                     poPrin *= @@Coca;
                     poPrro *= @@Coca;
                     poPacc *= @@Coca;
                     poPraa *= @@Coca;
                     poPrsf *= @@Coca;
                   endfor;

                 // Siempre sobre la misma base...
                 when @@Tiac = 'B';

                   for i = 1 to @@Cant;
                     @@Aux1 = pePrrc * @@Corc;
                     @@Aux1 -= pePrrc;
                     poPrrc += @@Aux1;

                     @@Aux1 = pePrce * @@Corc;
                     @@Aux1 -= pePrce;
                     poPrce += @@Aux1;

                     @@Aux1 = pePrap * @@Corc;
                     @@Aux1 -= pePrap;
                     poPrap += @@Aux1;

                     @@Aux1 = pePrac * @@Coca;
                     @@Aux1 -= pePrac;
                     poPrac += @@Aux1;

                     @@Aux1 = pePrin * @@Coca;
                     @@Aux1 -= pePrin;
                     poPrin += @@Aux1;

                     @@Aux1 = pePrro * @@Coca;
                     @@Aux1 -= pePrro;
                     poPrro += @@Aux1;

                     @@Aux1 = pePacc * @@Coca;
                     @@Aux1 -= pePacc;
                     poPacc += @@Aux1;

                     @@Aux1 = pePraa * @@Coca;
                     @@Aux1 -= pePraa;
                     poPraa += @@Aux1;

                     @@Aux1 = pePrsf * @@Coca;
                     @@Aux1 -= pePrsf;
                     poPrsf += @@Aux1;
                   endfor;
               endsl;

             // Coeficientes...
             when @@Tiaj = 'C';
               // Base de cálculo del Scoring...
               select;
                 // Aplicación acumulativa...
                 when @@Tiac = 'A';

                   for i = 1 to @@Cant;
                     poPrrc *= @@Corc;
                     poPrce *= @@Corc;
                     poPrap *= @@Corc;
                     poPrac *= @@Coca;
                     poPrin *= @@Coca;
                     poPrro *= @@Coca;
                     poPacc *= @@Coca;
                     poPraa *= @@Coca;
                     poPrsf *= @@Coca;
                   endfor;

                 // Siempre sobre la misma base...
                 when @@Tiac = 'B';

                   for i = 1 to @@Cant;
                     @@Aux1 = pePrrc * @@Corc;
                     @@Aux1 -= pePrrc;
                     poPrrc += @@Aux1;

                     @@Aux1 = pePrce * @@Corc;
                     @@Aux1 -= pePrce;
                     poPrce += @@Aux1;

                     @@Aux1 = pePrap * @@Corc;
                     @@Aux1 -= pePrap;
                     poPrap += @@Aux1;

                     @@Aux1 = pePrac * @@Coca;
                     @@Aux1 -= pePrac;
                     poPrac += @@Aux1;

                     @@Aux1 = pePrin * @@Coca;
                     @@Aux1 -= pePrin;
                     poPrin += @@Aux1;

                     @@Aux1 = pePrro * @@Coca;
                     @@Aux1 -= pePrro;
                     poPrro += @@Aux1;

                     @@Aux1 = pePacc * @@Coca;
                     @@Aux1 -= pePacc;
                     poPacc += @@Aux1;

                     @@Aux1 = pePraa * @@Coca;
                     @@Aux1 -= pePraa;
                     poPraa += @@Aux1;

                     @@Aux1 = pePrsf * @@Coca;
                     @@Aux1 -= pePrsf;
                     poPrsf += @@Aux1;
                   endfor;
               endsl;
           endsl;
         endif;
       endfor;

       return *on;

      /end-free

     P SPVVEH_aplicaScoring...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_validaScoringEmisión(): Valida Detalle del Scoring    *
     ?*                                para la Emisión               *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucursal                             *
     ?*     peArcd   ( input  ) Codigo de Articulo                   *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Polizas por Rama               *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSspo   ( input  ) Suplemento Superpoliza               *
     ?*     peSuop   ( input  ) Suplemento Operacion                 *
     ?*     peOper   ( input  ) Nro. Operacion                       *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( input  ) Estr. Items de un componente         *
     ?*     peDsIteC ( input  ) Cant. Items de un componente         *
     ?*     peTiou   ( input  ) Tipo de Operación                    *
     ?*     peStou   ( input  ) SubTipo de Operación de Usuario      *
     ?*     peStos   ( input  ) SubTipo de Operación de Sistema      *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_validaScoringEmision...
     P                 b                   export
     D SPVVEH_validaScoringEmision...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 const
     D   peSuop                       3  0 const
     D   peOper                       7  0 const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200) const
     D   peDsIteC                    10i 0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const

     D x               s             10i 0
     D i               s             10i 0
     D Encontro        s               n
     D peForm          s              1    inz('S')
     D @@Dst3C         s             10i 0
     D @@Dst3          ds                  likeds ( dspahet3_t ) dim( 999 )
     D @@DsIte         ds                  likeds (items_t) dim(200)
     D @@DsIteC        s             10i 0

      /free

       SPVVEH_inz();

       clear @@Dst3;
       clear @@Dst3C;
       clear @@DsIte;
       clear @@DsIteC;

       if peTiou = 1 or peTiou = 2 or
          ( peTiou = 3 and peStou = 5 and peStos = 10);

         eval-corr @@DsIte = peDsIte;
         @@DsIteC = peDsIteC;

         if not SPVVEH_validaPreguntas( peArcd
                                      : peRama
                                      : peArse
                                      : peTaaj
                                      : @@DsIte
                                      : @@DsIteC );
           return *off;
         endif;
       else;
         if not SPVVEH_getPahet3( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol
                                : peRama
                                : peArse
                                : pePoco
                                : peSspo
                                : peSuop
                                : peOper
                                : peTaaj
                                : *omit
                                : @@Dst3
                                : @@Dst3C
                                : peForm  );
           return *off;
         endif;

         if @@Dst3C <> peDsIteC;
           SetError( SPVVEH_ECOMP
                   : 'La cantidad de preguntas en el cuestionario +
                      es diferente al anterior' );
           Initialized = *off;
           return *off;
         endif;

         for x = 1 to @@Dst3C;

           Encontro = *off;

           for i = 1 to peDsIteC;
             if peDsIte(i).Cosg = @@Dst3(x).t3Cosg;
               select;
                 when peDsIte(i).Tiaj <> @@Dst3(x).t3Tiaj;
                   SetError( SPVVEH_ETIAJ
                           : 'Item de Scoring (' + (peDsIte(i).Cosg) +
                             '), el tipo de ajuste es diferente al anterior' );
                   Initialized = *off;
                   return *off;

                 when peDsIte(i).Tiac <> @@Dst3(x).t3Tiac;
                   SetError( SPVVEH_ETIAC
                           : 'Item de Scoring (' + (peDsIte(i).Cosg) +
                             '), la Forma de Aplicar ajuste es diferente al +
                             anterior' );
                   Initialized = *off;
                   return *off;

                 when peDsIte(i).Vefa <> @@Dst3(x).t3Vefa;
                   SetError( SPVVEH_EVEFA
                           : 'Item de Scoring (' + (peDsIte(i).Cosg) +
                             '), el Resultado es diferente al anterior' );
                   Initialized = *off;
                   return *off;

                 when peDsIte(i).Corc <> @@Dst3(x).t3Corc;
                   SetError( SPVVEH_ECORC
                           : 'Item de Scoring (' + (peDsIte(i).Cosg) +
                             '), el Coef/Porc. RC es diferente al anterior' );
                   Initialized = *off;
                   return *off;

                 when peDsIte(i).Coca <> @@Dst3(x).t3Coca;
                   SetError( SPVVEH_ECOCA
                           : 'Item de Scoring (' + (peDsIte(i).Cosg) +
                             '), Coef/Porc. Casco es diferente al anterior');
                   Initialized = *off;
                   return *off;

                 when peDsIte(i).Cant <> @@Dst3(x).t3Cant;
                   SetError( SPVVEH_ECANT
                           : 'Item de Scoring (' + (peDsIte(i).Cosg) +
                             '), la Cantidad es diferente al anterior' );
                   Initialized = *off;
                   return *off;

               endsl;
               Encontro = *on;
             endif;
           endfor;

           if not Encontro;
             SetError( SPVVEH_EFCOS
                     : 'La pregunta (' + @@Dst3(x).t3Cosg +
                       '), no se encuentra' );
             Initialized = *off;
             return *off;
           endif;

         endfor;


       endif;

       return *on;

      /end-free

     P SPVVEH_validaScoringEmision...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_chkScoringEnEmision(): Retorna si existe una Emision  *
      *                               guardada o vigente de Scoring. *
      *                                                              *
      *        Input :                                               *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peTaaj  -  Código de Cuestionario             *
      *                peCosg  -  Código de Pregunta      (Opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = No Encontro              *
      * -------------------------------------------------------------*
     P SPVVEH_chkScoringEnEmision...
     P                 B                   export
     D SPVVEH_chkScoringEnEmision...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTaaj                       2  0 const
     D   peCosg                       4    options( *nopass : *omit ) const

     D k1yet3          ds                  likerec( p1het302 : *key )

      /free

       SPVVEH_inz();

       k1yet3.t3Empr = peEmpr;
       k1yet3.t3Sucu = peSucu;
       k1yet3.t3Taaj = peTaaj;

       if %parms >= 4 and %addr(peCosg) <> *null;
         k1yet3.t3Cosg = peCosg;
         setll %kds( k1yet3 : 4 ) pahet302;
         reade %kds( k1yet3 : 4 ) pahet302;
       else;
         setll %kds( k1yet3 : 3 ) pahet302;
         reade %kds( k1yet3 : 3 ) pahet302;
       endif;

       dow not %eof( pahet302 );

         if SPVSPO_chkVig( peEmpr
                         : peSucu
                         : t3Arcd
                         : t3Spol
                         : *omit
                         : *omit  );

           return *on;
         else;
           return *off;
         endif;

         if %parms >= 4 and %addr(peCosg) <> *null;
           reade %kds( k1yet3 : 4 ) pahet302;
         else;
           reade %kds( k1yet3 : 3 ) pahet302;
         endif;
       enddo;

       return *off;

      /end-free

     P SPVVEH_chkScoringEnEmision...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getValorUsado: Retorna Valor de Usado                 *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: 0 = No tiene valor / > 0 Valor                      *
      * ------------------------------------------------------------ *
     P SPVVEH_getValorUsado...
     P                 B                   export
     D SPVVEH_getValorUsado...
     D                 pi            15  2
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D   @@vhcr        s              3
     D   k1t207        ds                  likerec( s1t207 : *key )

      /free

       SPVVEH_inz();
       @@vhcr = SPVVEH_getCarroceria( peVhmc
                                    : peVhmo
                                    : peVhcs );
       k1t207.t@vhmc = peVhmc;
       k1t207.t@vhmo = peVhmo;
       k1t207.t@vhcs = peVhcs;
       k1t207.t@vhcr = @@vhcr;
       chain %kds( k1t207 : 4 ) set207;
       if %found( set207 );
         return t@vhvu;
       endif;

       return *zeros;
      /end-free
     P SPVVEH_getValorUsado...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getConvSumaAsegurada : Conversor de suma asegurada    *
      *                                                              *
      *     peMon1   (input)   Moneda de entrada                     *
      *     peMon2   (input)   Moneda de salida                      *
      *     peVh0k   (input)   Valor 0km                             *
      *     peVhvu   (input)   Valor Usado                           *
      *                                                              *
      * Retorna: *on = Conversion Ok / *off = Error                  *
      * ------------------------------------------------------------ *
     P SPVVEH_getConvSumaAsegurada...
     P                 b                   export
     D SPVVEH_getConvSumaAsegurada...
     D                 pi              n
     D   peMon1                       2    const
     D   peMon2                       2    const
     D   peVh0k                      15  2 const
     D   peVhvu                      15  2 const
     D   @@erro        s              1

      /free

       SPVVEH_inz();

       SP0018( peMon1
             : peMon2
             : peVh0k
             : peVhvu
             : @@erro );

       // Utilizo este if para estandarizar las respuestas, debido a que
       // el pgm devuelve alreves...
       if @@erro = '0';
         return *on;
       else;
         return *off;
       endif;

      /end-free
     P SPVVEH_getConvSumaAsegurada...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_calcSumaAsegurada : Calcula suma asegurada de un      *
      *                            vehiculo.                         *
      *                                                              *
      *     peVhmc   (input)   Marca de vehiculo                     *
      *     peVhmo   (input)   Modelo de vehiculo                    *
      *     peVhcs   (input)   SubModelo de Vehiculo                 *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peMone   (input)   Moneda                                *
      *     peCobl   (input)   Cobertura                             *
      *     peTair   (input)   Numero de tabla air                   *
      *     peVhca   (input)   Codigo de moneda de emision           *
      *     peVhv2   (input)   Capitulo del vehiculo                 *
      *     peVhvu   (input)   Suma Asegurada                        *
      *                                                              *
      * Retorna: *on = Conversion Ok / *off = Error                  *
      * ------------------------------------------------------------ *
     P SPVVEH_calcSumaAsegurada...
     P                 b                   export
     D SPVVEH_calcSumaAsegurada...
     D                 pi            15  2
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peMone                       2    const
     D   peCobl                       2    const
     D   peTair                       2  0 const
     D   peVhca                       2  0 const
     D   peVhv2                       1  0 const
     D   peVhvu                      15  2 const

     D   @@vh0k        s             15  2
     D   @1vh0k        s             15  2
     D   @@vhvu        s             15  2
     D   @1vhvu        s             15  2
     D   @@vase        s             15  2
     D   @@Ds625       ds                  likeds( dsset625_t ) dim( 9999 )
     D   @@Ds224       ds                  likeds( dsSet224_t )
     D   @@DsRc        ds                  likeds( DsSet228_t ) dim( 9999 )
     D   @@DsRcC       s             10i 0
     D   x             s             10i 0
     D   @@in20        s              1
     D   NoSet228      s               n

      /free

       SPVVEH_inz();

       clear @@Ds625;
       clear @@DsRc;
       clear @@DsRcC;
       clear x;
       clear @@vase;
       @@vhvu = peVhvu;
       if not SVPART_getExt625( peArcd
                              : peRama
                              : peArse
                              : @@Ds625
                              : x       );
          //Error...
          return *zeros;
       endif;

       if @@Ds625(1).t@mar3 = '1';
          @@vh0k = SPVVEH_getValor0km( peVhmc
                                     : peVhmo
                                     : peVhcs );

          @@vhvu = SPVVEH_getValorUsado( peVhmc
                                       : peVhmo
                                       : peVhcs );

          clear @@Ds224;
          SPT224( @@Ds224
                : @@in20
                : 'RT'   );

          if @@in20 <> '0';
             @@Ds224.t@como = '00';
          endif;

          @1vh0k = @@vh0k;
          @1vhvu = @@vhvu;
          SPVVEH_getConvSumaAsegurada( @@Ds224.t@como
                                     : peMone
                                     : @1vh0k
                                     : @1vhvu        );
          if @1vh0k <> *zeros;
             @@vh0k = @1vh0k;
          endif;

          if @1vhvu <> *zeros;
             @@vhvu = @1vhvu;
          endif;

        endif;

        if not SPVVEH_getRangoCapitales( peCobl
                                       : petair
                                       : pemone
                                       : peVhca
                                       : peVhv2
                                       : *omit
                                       : *omit
                                       : @@DsRc
                                       : @@DsRcC );
          for x = 1 to @@DsRcC;
            if @@vhvu >= @@DsRc( x ).t@cap1 and
               @@vhvu <= @@DsRc( x ).t@cap2;
               if @@DsRc( x ).t@cap3 <> *zeros;
                 @@vhvu = @@DsRc( x ).t@cap3;
                 NoSet228 = *off;
               else;
                 NoSet228 = *on;
               endif;
               leave;
            endif;
          endfor;
        endif;

        if noSet228;

         if not SPVVEH_getRangoCapitales( *blanks
                                        : petair
                                        : pemone
                                        : peVhca
                                        : peVhv2
                                        : *omit
                                        : *omit
                                        : @@DsRc
                                        : @@DsRcC );
           for x = 1 to @@DsRcC;
             if @@vhvu >= @@DsRc( x ).t@cap1 and
                @@vhvu <= @@DsRc( x ).t@cap2;
                if @@DsRc( x ).t@cap3 <> *zeros;
                  @@vhvu = @@DsRc( x ).t@cap3;
                endif;
                leave;
             endif;
           endfor;
         endif;
       endif;

       return @@vhvu;

     P SPVVEH_calcSumaAsegurada...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getRangoCapitales : Obtener rando de capitales        *
      *                                                              *
      *     peCobl   (input)   Codigo de cobertura        (opcional) *
      *     peTair   (input)   Numero de tabla air        (opcional) *
      *     peMone   (input)   Codigo de moneda de emision(opcional) *
      *     peVhca   (input)   Capitulo del vehiculo      (opcional) *
      *     peVhv2   (input)   Capitulo variante air      (opcional) *
      *     peCap1   (input)   Capital desde              (opcional) *
      *     peCap2   (input)   Capital hasta              (opcional) *
      *     peDsRc   (output)  Estructura de tabla        (opcional) *
      *     peDsRcC  (output)  Cantidad de registros      (opcional) *
      *                                                              *
      * Retorna: *on = encontro / *off = No encontro                 *
      * ------------------------------------------------------------ *
     P SPVVEH_getRangoCapitales...
     P                 b                   export
     D SPVVEH_getRangoCapitales...
     D                 pi              n
     D   peCobl                       2    const options(*nopass:*omit)
     D   peTair                       2  0 const options(*nopass:*omit)
     D   peMone                       2    const options(*nopass:*omit)
     D   peVhca                       2  0 const options(*nopass:*omit)
     D   peVhv2                       1  0 const options(*nopass:*omit)
     D   peCap1                      15  2 const options(*nopass:*omit)
     D   peCap2                      15  2 const options(*nopass:*omit)
     D   peDsRc                            likeds( DsSet228_t ) dim( 9999 )
     D                                     options(*nopass:*omit)
     D   peDsRcC                     10i 0 options(*nopass:*omit)

     D   @@DsIRc       ds                  likerec( s1t228 : *input )
     D   @@DsRc        ds                  likeds( DsSet228_t ) dim( 9999 )
     D   @@DsRcC       S             10i 0
     D   k1y228        ds                  likerec( s1t228 : *key )

      /free
       SPVVEH_inz();

       clear @@DsIRc;
       clear @@DsRc;
       clear @@DsRcC;

       select;

         when %parms >= 7 and %addr( peCobl ) <> *null
                          and %addr( peTair ) <> *null
                          and %addr( peMone ) <> *null
                          and %addr( peVhca ) <> *null
                          and %addr( peVhv2 ) <> *null
                          and %addr( peCap1 ) <> *null
                          and %addr( peCap2 ) <> *null;

            k1y228.t@cobl =  peCobl;
            k1y228.t@tair =  peTair;
            k1y228.t@mone =  peMone;
            k1y228.t@vhca =  peVhca;
            k1y228.t@vhv2 =  peVhv2;
            k1y228.t@cap1 =  peCap1;
            k1y228.t@cap2 =  peCap2;
            setll %kds( k1y228 : 7 ) set228;
            if not %equal();
              return %equal();
            endif;
            reade %kds( k1y228 : 7 ) set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              reade %kds( k1y228 : 7 ) set228 @@DsIRc;
            enddo;

         when %parms >= 6 and %addr( peCobl ) <> *null
                          and %addr( peTair ) <> *null
                          and %addr( peMone ) <> *null
                          and %addr( peVhca ) <> *null
                          and %addr( peVhv2 ) <> *null
                          and %addr( peCap1 ) <> *null;

            k1y228.t@cobl =  peCobl;
            k1y228.t@tair =  peTair;
            k1y228.t@mone =  peMone;
            k1y228.t@vhca =  peVhca;
            k1y228.t@vhv2 =  peVhv2;
            k1y228.t@cap1 =  peCap1;
            setll %kds( k1y228 : 6 ) set228;
            if not %equal();
              return %equal();
            endif;
            reade %kds( k1y228 : 6 ) set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              reade %kds( k1y228 : 6 ) set228 @@DsIRc;
            enddo;

         when %parms >= 5 and %addr( peCobl ) <> *null
                          and %addr( peTair ) <> *null
                          and %addr( peMone ) <> *null
                          and %addr( peVhca ) <> *null
                          and %addr( peVhv2 ) <> *null;

            k1y228.t@cobl =  peCobl;
            k1y228.t@tair =  peTair;
            k1y228.t@mone =  peMone;
            k1y228.t@vhca =  peVhca;
            k1y228.t@vhv2 =  peVhv2;
            setll %kds( k1y228 : 5 ) set228;
            if not %equal();
              return %equal();
            endif;
            reade %kds( k1y228 : 5 ) set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              reade %kds( k1y228 : 5 ) set228 @@DsIRc;
            enddo;

         when %parms >= 4 and %addr( peCobl ) <> *null
                          and %addr( peTair ) <> *null
                          and %addr( peMone ) <> *null
                          and %addr( peVhca ) <> *null;

            k1y228.t@cobl =  peCobl;
            k1y228.t@tair =  peTair;
            k1y228.t@mone =  peMone;
            k1y228.t@vhca =  peVhca;
            setll %kds( k1y228 : 4 ) set228;
            if not %equal();
              return %equal();
            endif;
            reade %kds( k1y228 : 4 ) set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              reade %kds( k1y228 : 4 ) set228 @@DsIRc;
            enddo;

         when %parms >= 3 and %addr( peCobl ) <> *null
                          and %addr( peTair ) <> *null
                          and %addr( peMone ) <> *null;

            k1y228.t@cobl =  peCobl;
            k1y228.t@tair =  peTair;
            k1y228.t@mone =  peMone;
            setll %kds( k1y228 : 3 ) set228;
            if not %equal();
              return %equal();
            endif;
            reade %kds( k1y228 : 3 ) set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              reade %kds( k1y228 : 3 ) set228 @@DsIRc;
            enddo;

         when %parms >= 2 and %addr( peCobl ) <> *null
                          and %addr( peTair ) <> *null;

            k1y228.t@cobl =  peCobl;
            k1y228.t@tair =  peTair;
            setll %kds( k1y228 : 2 ) set228;
            if not %equal();
              return %equal();
            endif;
            reade %kds( k1y228 : 2 ) set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              reade %kds( k1y228 : 2 ) set228 @@DsIRc;
            enddo;

         when %parms >= 1 and %addr( peCobl ) <> *null;

            k1y228.t@cobl =  peCobl;
            setll %kds( k1y228 : 1 ) set228;
            if not %equal();
              return %equal();
            endif;
            reade %kds( k1y228 : 1 ) set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              reade %kds( k1y228 : 1 ) set228 @@DsIRc;
            enddo;
          other;

            setll *start set228;
            if not %equal();
              return %equal();
            endif;
            read set228 @@DsIRc;
            dow not %eof();
              @@DsRcC += 1;
              eval-corr @@DsRc( @@DsRcC ) = @@DsIRc;
              read set228 @@DsIRc;
            enddo;
          endsl;

        if %addr( peDsRc ) <> *Null;
          eval-corr peDsRC = @@DsRc;
        endif;

        if %addr( peDsRcC ) <> *Null;
          eval peDsRcC = @@DsRcC;
        endif;

       return *on;
      /end-free

     P SPVVEH_getRangoCapitales...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet1: Retorna datos Prod.Art. Rama Automotores.  *
     ?*                   Accesorios                                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Suplemento de la operación           *
     ?*     peSecu   ( input  ) Secuencia Accesorios                 *
     ?*     peDst1   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst1C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getPahet1...
     P                 b                   export
     D SPVVEH_getPahet1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const
     D   peDst1                            likeds ( dspahet1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst1C                     10i 0 options( *nopass : *omit )

     D   k1yet1        ds                  likerec( p1het1 : *key )
     D   @@DsIt1       ds                  likerec( p1het1 : *input )
     D   @@Dst1        ds                  likeds ( dspahet1_t ) dim( 999 )
     D   @@Dst1C       s             10i 0

      /free

       SPVVEH_inz();

       clear @@Dst1;
       clear @@Dst1C;

       k1yet1.t1Empr = peEmpr;
       k1yet1.t1Sucu = peSucu;
       k1yet1.t1Arcd = peArcd;
       k1yet1.t1Spol = peSpol;

       select;
         when %parms >= 11 and %addr( peSspo ) <> *null
                           and %addr( peRama ) <> *null
                           and %addr( peArse ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peSecu ) <> *null;

           k1yet1.t1Sspo = peSspo;
           k1yet1.t1Rama = peRama;
           k1yet1.t1Arse = peArse;
           k1yet1.t1Oper = peOper;
           k1yet1.t1Poco = pePoco;
           k1yet1.t1Suop = peSuop;
           k1yet1.t1Secu = peSecu;
           setll %kds( k1yet1 : 11 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 11 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 11 ) pahet1 @@DsIt1;
           enddo;

         when %parms >= 10 and %addr( peSspo ) <> *null
                           and %addr( peRama ) <> *null
                           and %addr( peArse ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peSecu ) =  *null;

           k1yet1.t1Sspo = peSspo;
           k1yet1.t1Rama = peRama;
           k1yet1.t1Arse = peArse;
           k1yet1.t1Oper = peOper;
           k1yet1.t1Poco = pePoco;
           k1yet1.t1Suop = peSuop;
           setll %kds( k1yet1 : 10 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 10 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 10 ) pahet1 @@DsIt1;
           enddo;

         when %parms >= 9 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) <> *null
                          and %addr( pePoco ) <> *null
                          and %addr( peSuop ) =  *null
                          and %addr( peSecu ) =  *null;

           k1yet1.t1Sspo = peSspo;
           k1yet1.t1Rama = peRama;
           k1yet1.t1Arse = peArse;
           k1yet1.t1Oper = peOper;
           k1yet1.t1Poco = pePoco;
           setll %kds( k1yet1 : 9 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 9 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 9 ) pahet1 @@DsIt1;
           enddo;

         when %parms >= 8 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) <> *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peSecu ) =  *null;

           k1yet1.t1Sspo = peSspo;
           k1yet1.t1Rama = peRama;
           k1yet1.t1Arse = peArse;
           k1yet1.t1Oper = peOper;
           setll %kds( k1yet1 : 8 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 8 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 8 ) pahet1 @@DsIt1;
           enddo;

         when %parms >= 7 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peSecu ) =  *null;

           k1yet1.t1Sspo = peSspo;
           k1yet1.t1Rama = peRama;
           k1yet1.t1Arse = peArse;
           setll %kds( k1yet1 : 7 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 7 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 7 ) pahet1 @@DsIt1;
           enddo;

         when %parms >= 6 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peSecu ) =  *null;

           k1yet1.t1Sspo = peSspo;
           k1yet1.t1Rama = peRama;
           setll %kds( k1yet1 : 6 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 6 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 6 ) pahet1 @@DsIt1;
           enddo;

         when %parms >= 5 and %addr( peSspo ) <> *null
                          and %addr( peRama ) =  *null
                          and %addr( peArse ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peSecu ) =  *null;

           k1yet1.t1Sspo = peSspo;
           setll %kds( k1yet1 : 5 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 5 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 5 ) pahet1 @@DsIt1;
           enddo;

         other;
           setll %kds( k1yet1 : 4 ) pahet1;
           if not %equal( pahet1 );
             return *off;
           endif;
           reade(n) %kds( k1yet1 : 4 ) pahet1 @@DsIt1;
           dow not %eof( pahet1 );
             @@Dst1C += 1;
             eval-corr @@Dst1( @@Dst1C ) = @@DsIt1;
             reade(n) %kds( k1yet1 : 4 ) pahet1 @@DsIt1;
           enddo;

       endsl;

       if %addr( peDst1 ) <> *null;
         eval-corr peDst1 = @@Dst1;
       endif;

       if %addr( peDst1C ) <> *null;
         eval peDst1C = @@Dst1C;
       endif;

       return *on;

      /end-free

     P SPVVEH_getPahet1...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet1: Graba datos Prod.Art. Rama Automotores.    *
     ?*                   Accesorios                                 *
     ?*                                                              *
     ?*     peDst1   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet1...
     P                 b                   export
     D SPVVEH_setPahet1...
     D                 pi              n

     D  peDst1                             likeds ( dspahet1_t )
     D                                     options( *nopass : *omit ) const

     D DsOet1          ds                  likerec( p1het1 : *output )
     D @@Dst1          ds                  likeds ( dspahet1_t ) dim( 999 )
     D @@Dst1C         s             10i 0

      /Free

       SPVVEH_inz();

       clear @@Dst1;
       clear @@Dst1C;

       if SPVVEH_getPahet1( peDst1.t1Empr
                          : peDst1.t1Sucu
                          : peDst1.t1Arcd
                          : peDst1.t1Spol
                          : peDst1.t1Sspo
                          : peDst1.t1Rama
                          : peDst1.t1Arse
                          : peDst1.t1Oper
                          : peDst1.t1Poco
                          : peDst1.t1Suop
                          : peDst1.t1Secu
                          : @@Dst1
                          : @@Dst1C       );

         return *off;
       endif;

       eval-corr DsOet1 = peDst1;
       monitor;
         write p1het1 DsOet1;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SPVVEH_setPahet1...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet3: Graba datos Prod.Art. Rama Automotores     *
     ?*                   Scoring.                                   *
     ?*                                                              *
     ?*     peDst3   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet3...
     P                 b                   export
     D SPVVEH_setPahet3...
     D                 pi              n

     D  peDst3                             likeds ( dspahet3_t )
     D                                     options( *nopass : *omit ) const

     D DsOet3          ds                  likerec( p1het3 : *output )
     D @@Dst3          ds                  likeds ( dspahet3_t ) dim( 999 )
     D @@Dst3C         s             10i 0

      /Free

       SPVVEH_inz();

       clear @@Dst3;
       clear @@Dst3C;

       if SPVVEH_getPahet3( peDst3.t3Empr
                          : peDst3.t3Sucu
                          : peDst3.t3Arcd
                          : peDst3.t3Spol
                          : peDst3.t3Rama
                          : peDst3.t3Arse
                          : peDst3.t3Poco
                          : peDst3.t3Sspo
                          : peDst3.t3Suop
                          : peDst3.t3Oper
                          : peDst3.t3Taaj
                          : peDst3.t3Cosg
                          : @@Dst3
                          : @@Dst3C
                          : *omit         );

         return *off;
       endif;

       eval-corr DsOet3 = peDst3;
       monitor;
         write p1het3 DsOet3;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SPVVEH_setPahet3...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet4: Graba Composición Descuentos/Recargos de   *
     ?*                   Item Autos.                                *
     ?*                                                              *
     ?*     peDst4   ( imput  ) Estr. Prod.Art. Descuento/Recargo    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet4...
     P                 b                   export
     D SPVVEH_setPahet4...
     D                 pi              n

     D  peDst4                             likeds ( dspahet4_t )
     D                                     options( *nopass : *omit ) const

     D DsOet4          ds                  likerec( p1het4 : *output )
     D @@Ds406         ds                  likeds( dsPahet406_t ) dim( 999 )
     D @@Ds406C        s             10i 0

      /Free

       SPVVEH_inz();

       clear @@Ds406;
       clear @@Ds406C;

       if SPVVEH_getListaDescuentoRecargo( peDst4.t4Empr
                                         : peDst4.t4Sucu
                                         : peDst4.t4Rama
                                         : peDst4.t4Poli
                                         : peDst4.t4Poco
                                         : peDst4.t4Suop
                                         : @@Ds406
                                         : @@Ds406C      );

         return *off;
       endif;

       eval-corr DsOet4 = peDst4;
       monitor;
         write p1het4 DsOet4;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SPVVEH_setPahet4...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet5: Retorna datos Carta de Daños/restricciones *
     ?*                   de Cobertura.                              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Suplemento de la operación           *
     ?*     peCdaÑ   ( input  ) Código de Daño                       *
     ?*     peDst5   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst5C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getPahet5...
     P                 b                   export
     D SPVVEH_getPahet5...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peCdaÑ                       4  0 options( *nopass : *omit ) const
     D   peDst5                            likeds ( dspahet5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst5C                     10i 0 options( *nopass : *omit )

     D   k1yet5        ds                  likerec( p1het5 : *key )
     D   @@DsIt5       ds                  likerec( p1het5 : *input )
     D   @@Dst5        ds                  likeds ( dspahet5_t ) dim( 999 )
     D   @@Dst5C       s             10i 0

      /free

       SPVVEH_inz();

       clear @@Dst5;
       clear @@Dst5C;

       k1yet5.t5Empr = peEmpr;
       k1yet5.t5Sucu = peSucu;
       k1yet5.t5Arcd = peArcd;
       k1yet5.t5Spol = peSpol;

       select;
         when %parms >= 11 and %addr( peSspo ) <> *null
                           and %addr( peRama ) <> *null
                           and %addr( peArse ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peCdaÑ ) <> *null;

           k1yet5.t5Sspo = peSspo;
           k1yet5.t5Rama = peRama;
           k1yet5.t5Arse = peArse;
           k1yet5.t5Oper = peOper;
           k1yet5.t5Poco = pePoco;
           k1yet5.t5Suop = peSuop;
           k1yet5.t5CdaÑ = peCdaÑ;
           setll %kds( k1yet5 : 11 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 11 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 11 ) pahet5 @@DsIt5;
           enddo;

         when %parms >= 10 and %addr( peSspo ) <> *null
                           and %addr( peRama ) <> *null
                           and %addr( peArse ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peCdaÑ ) =  *null;

           k1yet5.t5Sspo = peSspo;
           k1yet5.t5Rama = peRama;
           k1yet5.t5Arse = peArse;
           k1yet5.t5Oper = peOper;
           k1yet5.t5Poco = pePoco;
           k1yet5.t5Suop = peSuop;
           setll %kds( k1yet5 : 10 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 10 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 10 ) pahet5 @@DsIt5;
           enddo;

         when %parms >= 9 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) <> *null
                          and %addr( pePoco ) <> *null
                          and %addr( peSuop ) =  *null
                          and %addr( peCdaÑ ) =  *null;

           k1yet5.t5Sspo = peSspo;
           k1yet5.t5Rama = peRama;
           k1yet5.t5Arse = peArse;
           k1yet5.t5Oper = peOper;
           k1yet5.t5Poco = pePoco;
           setll %kds( k1yet5 : 9 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 9 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 9 ) pahet5 @@DsIt5;
           enddo;

         when %parms >= 8 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) <> *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peCdaÑ ) =  *null;

           k1yet5.t5Sspo = peSspo;
           k1yet5.t5Rama = peRama;
           k1yet5.t5Arse = peArse;
           k1yet5.t5Oper = peOper;
           setll %kds( k1yet5 : 8 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 8 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 8 ) pahet5 @@DsIt5;
           enddo;

         when %parms >= 7 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peCdaÑ ) =  *null;

           k1yet5.t5Sspo = peSspo;
           k1yet5.t5Rama = peRama;
           k1yet5.t5Arse = peArse;
           setll %kds( k1yet5 : 7 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 7 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 7 ) pahet5 @@DsIt5;
           enddo;

         when %parms >= 6 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peCdaÑ ) =  *null;

           k1yet5.t5Sspo = peSspo;
           k1yet5.t5Rama = peRama;
           setll %kds( k1yet5 : 6 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 6 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 6 ) pahet5 @@DsIt5;
           enddo;

         when %parms >= 5 and %addr( peSspo ) <> *null
                          and %addr( peRama ) =  *null
                          and %addr( peArse ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peCdaÑ ) =  *null;

           k1yet5.t5Sspo = peSspo;
           setll %kds( k1yet5 : 5 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 5 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 5 ) pahet5 @@DsIt5;
           enddo;

         other;
           setll %kds( k1yet5 : 4 ) pahet5;
           if not %equal( pahet5 );
             return *off;
           endif;
           reade(n) %kds( k1yet5 : 4 ) pahet5 @@DsIt5;
           dow not %eof( pahet5 );
             @@Dst5C += 1;
             eval-corr @@Dst5( @@Dst5C ) = @@DsIt5;
             reade(n) %kds( k1yet5 : 4 ) pahet5 @@DsIt5;
           enddo;

       endsl;

       if %addr( peDst5 ) <> *null;
         eval-corr peDst5 = @@Dst5;
       endif;

       if %addr( peDst5C ) <> *null;
         eval peDst5C = @@Dst5C;
       endif;

       return *on;

      /end-free

     P SPVVEH_getPahet5...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet5: Graba Carta de Daños/Restricciones de      *
     ?*                   Cobertura.                                 *
     ?*                                                              *
     ?*     peDst5   ( imput  ) Estr. Carta de Daños/Restricciones.  *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet5...
     P                 b                   export
     D SPVVEH_setPahet5...
     D                 pi              n

     D  peDst5                             likeds ( dspahet5_t )
     D                                     options( *nopass : *omit ) const

     D DsOet5          ds                  likerec( p1het5 : *output )
     D @@Dst5          ds                  likeds ( dspahet5_t ) dim( 999 )
     D @@Dst5C         s             10i 0

      /Free

       SPVVEH_inz();

       clear @@Dst5;
       clear @@Dst5C;

       if SPVVEH_getPahet5( peDst5.t5Empr
                          : peDst5.t5Sucu
                          : peDst5.t5Arcd
                          : peDst5.t5Spol
                          : peDst5.t5Sspo
                          : peDst5.t5Rama
                          : peDst5.t5Arse
                          : peDst5.t5Oper
                          : peDst5.t5Poco
                          : peDst5.t5Suop
                          : peDst5.t5CdaÑ
                          : @@Dst5
                          : @@Dst5C       );

         return *off;
       endif;

       eval-corr DsOet5 = peDst5;
       monitor;
         write p1het5 DsOet5;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SPVVEH_setPahet5...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getPahet6: Retorna datos Carta de Daños/Restricciones *
     ?*                   Cobertura.                                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peSuop   ( input  ) Suplemento de la operación           *
     ?*     peNcon   ( input  ) Número de Conductor                  *
     ?*     peDst6   ( output ) Estr. Prod.Art. Rama Automotores.    *
     ?*     peDst6C  ( output ) cant. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getPahet6...
     P                 b                   export
     D SPVVEH_getPahet6...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       4  0 options( *nopass : *omit ) const
     D   peNcon                       4  0 options( *nopass : *omit ) const
     D   peDst6                            likeds ( dspahet6_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst6C                     10i 0 options( *nopass : *omit )

     D   k1yet6        ds                  likerec( p1het6 : *key )
     D   @@DsIt6       ds                  likerec( p1het6 : *input )
     D   @@Dst6        ds                  likeds ( dspahet6_t ) dim( 999 )
     D   @@Dst6C       s             10i 0

      /free

       SPVVEH_inz();

       clear @@Dst6;
       clear @@Dst6C;

       k1yet6.t6Empr = peEmpr;
       k1yet6.t6Sucu = peSucu;
       k1yet6.t6Arcd = peArcd;
       k1yet6.t6Spol = peSpol;

       select;
         when %parms >= 11 and %addr( peSspo ) <> *null
                           and %addr( peRama ) <> *null
                           and %addr( peArse ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peNcon ) <> *null;

           k1yet6.t6Sspo = peSspo;
           k1yet6.t6Rama = peRama;
           k1yet6.t6Arse = peArse;
           k1yet6.t6Oper = peOper;
           k1yet6.t6Poco = pePoco;
           k1yet6.t6Suop = peSuop;
           k1yet6.t6Ncon = peNcon;
           setll %kds( k1yet6 : 11 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 11 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 11 ) pahet6 @@DsIt6;
           enddo;

         when %parms >= 10 and %addr( peSspo ) <> *null
                           and %addr( peRama ) <> *null
                           and %addr( peArse ) <> *null
                           and %addr( peOper ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( peSuop ) <> *null
                           and %addr( peNcon ) =  *null;

           k1yet6.t6Sspo = peSspo;
           k1yet6.t6Rama = peRama;
           k1yet6.t6Arse = peArse;
           k1yet6.t6Oper = peOper;
           k1yet6.t6Poco = pePoco;
           k1yet6.t6Suop = peSuop;
           setll %kds( k1yet6 : 10 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 10 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 10 ) pahet6 @@DsIt6;
           enddo;

         when %parms >= 9 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) <> *null
                          and %addr( pePoco ) <> *null
                          and %addr( peSuop ) =  *null
                          and %addr( peNcon ) =  *null;

           k1yet6.t6Sspo = peSspo;
           k1yet6.t6Rama = peRama;
           k1yet6.t6Arse = peArse;
           k1yet6.t6Oper = peOper;
           k1yet6.t6Poco = pePoco;
           setll %kds( k1yet6 : 9 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 9 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 9 ) pahet6 @@DsIt6;
           enddo;

         when %parms >= 8 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) <> *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peNcon ) =  *null;

           k1yet6.t6Sspo = peSspo;
           k1yet6.t6Rama = peRama;
           k1yet6.t6Arse = peArse;
           k1yet6.t6Oper = peOper;
           setll %kds( k1yet6 : 8 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 8 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 8 ) pahet6 @@DsIt6;
           enddo;

         when %parms >= 7 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) <> *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peNcon ) =  *null;

           k1yet6.t6Sspo = peSspo;
           k1yet6.t6Rama = peRama;
           k1yet6.t6Arse = peArse;
           setll %kds( k1yet6 : 7 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 7 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 7 ) pahet6 @@DsIt6;
           enddo;

         when %parms >= 6 and %addr( peSspo ) <> *null
                          and %addr( peRama ) <> *null
                          and %addr( peArse ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peNcon ) =  *null;

           k1yet6.t6Sspo = peSspo;
           k1yet6.t6Rama = peRama;
           setll %kds( k1yet6 : 6 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 6 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 6 ) pahet6 @@DsIt6;
           enddo;

         when %parms >= 5 and %addr( peSspo ) <> *null
                          and %addr( peRama ) =  *null
                          and %addr( peArse ) =  *null
                          and %addr( peOper ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( peSuop ) =  *null
                          and %addr( peNcon ) =  *null;

           k1yet6.t6Sspo = peSspo;
           setll %kds( k1yet6 : 5 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 5 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 5 ) pahet6 @@DsIt6;
           enddo;

         other;
           setll %kds( k1yet6 : 4 ) pahet6;
           if not %equal( pahet6 );
             return *off;
           endif;
           reade(n) %kds( k1yet6 : 4 ) pahet6 @@DsIt6;
           dow not %eof( pahet6 );
             @@Dst6C += 1;
             eval-corr @@Dst6( @@Dst6C ) = @@DsIt6;
             reade(n) %kds( k1yet6 : 4 ) pahet6 @@DsIt6;
           enddo;

       endsl;

       if %addr( peDst6 ) <> *null;
         eval-corr peDst6 = @@Dst6;
       endif;

       if %addr( peDst6C ) <> *null;
         eval peDst6C = @@Dst6C;
       endif;

       return *on;

      /end-free

     P SPVVEH_getPahet6...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet6: Graba Carta de Daños/Restricciones de      *
     ?*                   Cobertura.                                 *
     ?*                                                              *
     ?*     peDst6   ( imput  ) Estr. Carta de Daños/Restricciones.  *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet6...
     P                 b                   export
     D SPVVEH_setPahet6...
     D                 pi              n

     D  peDst6                             likeds ( dspahet6_t )
     D                                     options( *nopass : *omit ) const

     D DsOet6          ds                  likerec( p1het6 : *output )
     D @@Dst6          ds                  likeds ( dspahet6_t ) dim( 999 )
     D @@Dst6C         s             10i 0

      /Free

       SPVVEH_inz();

       clear @@Dst6;
       clear @@Dst6C;

       if SPVVEH_getPahet6( peDst6.t6Empr
                          : peDst6.t6Sucu
                          : peDst6.t6Arcd
                          : peDst6.t6Spol
                          : peDst6.t6Sspo
                          : peDst6.t6Rama
                          : peDst6.t6Arse
                          : peDst6.t6Oper
                          : peDst6.t6Poco
                          : peDst6.t6Suop
                          : peDst6.t6Ncon
                          : @@Dst6
                          : @@Dst6C       );

         return *off;
       endif;

       eval-corr DsOet6 = peDst6;
       monitor;
         write p1het6 DsOet6;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SPVVEH_setPahet6...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet9: Graba datos Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?*     peDst9   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet9...
     P                 b                   export
     D SPVVEH_setPahet9...
     D                 pi              n

     D  peDst9                             likeds ( dspahet9_t )
     D                                     options( *nopass : *omit ) const

     D DsOet9          ds                  likerec( p1het9 : *output )
     D @@Dst9          ds                  likeds ( dspahet9_t )

      /Free

       SPVVEH_inz();

       clear @@Dst9;

       if SPVVEH_getPahet9( peDst9.t9Empr
                          : peDst9.t9Sucu
                          : peDst9.t9Arcd
                          : peDst9.t9Spol
                          : peDst9.t9Rama
                          : peDst9.t9Arse
                          : peDst9.t9Poco
                          : @@DsT9        );

         return *off;
       endif;

       eval-corr DsOet9 = peDst9;
       monitor;
         write p1het9 DsOet9;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SPVVEH_setPahet9...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet0: Graba datos Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?*     peDst0   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet0...
     P                 b                   export
     D SPVVEH_setPahet0...
     D                 pi              n

     D  peDst0                             likeds ( dspahet0_t )
     D                                     options( *nopass : *omit ) const

     D p1Dst0          ds                  likeds ( dspahet02_t )

      /Free

       SPVVEH_inz();

       eval-corr p1Dst0 = peDst0;
       p1Dst0.t0copo = 0;
       p1Dst0.t0cops = 0;

       return SPVVEH_setPahet02( p1Dst0 );

      /end-free

     P SPVVEH_setPahet0...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getAÑoVehUsado(): Retorna Año del Vehiculo            *
      *                                                              *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   SubModelo                             *
      *                                                              *
      * Retorna: 0 = No tiene valor / > 0 Valor                      *
      * ------------------------------------------------------------ *
     P SPVVEH_getAÑoVehUsado...
     P                 B                   export
     D SPVVEH_getAÑoVehUsado...
     D                 pi             4  0
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const

     D   @@vhcr        s              3
     D   k1t207        ds                  likerec( s1t207 : *key )

      /free

       SPVVEH_inz();

       @@vhcr = SPVVEH_getCarroceria( peVhmc
                                    : peVhmo
                                    : peVhcs );
       k1t207.t@vhmc = peVhmc;
       k1t207.t@vhmo = peVhmo;
       k1t207.t@vhcs = peVhcs;
       k1t207.t@vhcr = @@vhcr;
       chain %kds( k1t207 : 4 ) set207;
       if %found( set207 );
         return t@vhaÑ;
       endif;

       return *zeros;

      /end-free

     P SPVVEH_getAÑoVehUsado...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_chk0km2aÑos(): Chequea si cumple con los filtros de   *
     ?*                       0kms 2 años                            *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Artículo                             *
     ?*     peSpol   ( input  ) Superpoliza                          *
     ?*     peSspo   ( input  ) Suplemento de la superpoliza         *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. Pólizas por Rama               *
     ?*     peOper   ( input  ) Operación                            *
     ?*     pePoco   ( input  ) Componente                           *
     ?*     peTipo   ( input  ) Refacturación/Renovación             *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_chk0km2aÑos...
     P                 b                   export
     D SPVVEH_chk0km2aÑos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peTipo                       1    const

     D @@AÑo           s              4  0
     D @@Mes           s              2  0
     D @@Dia           s              2  0
     D @@Ainf          s              4  0
     D @@0kms          s               n
     D @@D0km2         s               n

     D @@Dst9          ds                  likeds( dsPahet9_t )

      /free

       SPVVEH_inz();

       clear @@Dst9;
       PAR310X3( peEmpr
               : @@aÑo
               : @@mes
               : @@dia );

       if SPVVEH_getPahet9( peEmpr
                          : peSucu
                          : peArcd
                          : peSpol
                          : peRama
                          : peArse
                          : pePoco
                          : @@DsT9 );

         PAX011( peTipo
               : peEmpr
               : peSucu
               : peArcd
               : peSpol
               : peSspo
               : peRama
               : peArse
               : peOper
               : pePoco
               : @@DsT9.t9Nmat
               : @@Ainf
               : @@0kms
               : @@D0km2       );

         if ( @@Ainf = @@AÑo ) and @@0kms and not @@D0km2;
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SPVVEH_chk0km2aÑos...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_chkModuloDescRec: Valida si módulo de descuentos y    *
      *                          recargos                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     pePoco   (input)   Componente             ( opcional )   *
      *                                                              *
      * Retorna: *on = Esta Activo / *off = No esta activo           *
      * ------------------------------------------------------------ *
     P SPVVEH_chkModuloDescRec...
     P                 b                   export
     D SPVVEH_chkModuloDescRec...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoco                       4  0 const options(*nopass:*omit)

     D   esta_activo   s               n
     D   endpgm        s              3
     D   @@poco        s              4  0

      /free

       SPVVEH_inz();

       clear @@poco;
       if %parms >= 7 and %addr(pePoco) <> *null;
          @@poco = pePoco;
       endif;

       spdetdes( peEmpr
               : peSucu
               : peArcd
               : peSpol
               : peSspo
               : peRama
               : @@poco
               : esta_activo
               : endpgm      );

       return esta_activo;

       return *on;
      /end-free

     P SPVVEH_chkModuloDescRec...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_calcDescRecSpol : Calcula descuento y recargo de      *
      *                          una póliza                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     pePoco   (input)   Componente                            *
      *     peVhvu   (input)   Suma Asegurada                        *
      *     peClin   (input)   Cliente Integral       ( opcional )   *
      *     peBure   (input)   Buen Resultado         ( opcional )   *
      *     peTiou   (input)   Tipo Operacion         ( opcional )   *
      *     peStou   (input)   Subtipo Usuario        ( opcional )   *
      *     peStos   (input)   Subtipo Sistema        ( opcional )   *
      *     pePcli   (input)   Porcentaje CI          ( opcional )   *
      *     pePbur   (input)   Porcentaje BURE        ( opcional )   *
      *     peDset4  (output)  Estructura Des/Rec     ( opcional )   *
      *     peDset4C (output)  cantidad Des/Rec       ( opcional )   *
      *                                                              *
      * Retorna: *on = calculo ok / *off = No calculó                *
      * ------------------------------------------------------------ *
     P SPVVEH_calcDescRecSpol...
     P                 b                   export
     D SPVVEH_calcDescRecSpol...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoco                       4  0 const
     D   peVhvu                      15  2 const
     D   peClin                        n   const options(*nopass:*omit)
     D   peBure                       1  0 const options(*nopass:*omit)
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)
     D   pePcli                       5  2 const options(*nopass:*omit)
     D   pePbur                       5  2 const options(*nopass:*omit)
     D   peCobl                       2    const options(*nopass:*omit)
     D   peCob2                       2    const options(*nopass:*omit)
     D   peDset4                           likeds(dsPahet406_t) dim(999)
     D                                     options(*nopass:*omit)
     D   peDset4C                    10i 0 options(*nopass:*omit)

     D   @@DsD0        ds                  likeds(dsPahed0_t) dim(999)
     D   @@DsD0C       s             10i 0
     D   @@DsT0        ds                  likeds(dsPahet0_t)
     D   @@Dset4       ds                  likeds(dsPahet406_t) dim(999)
     D   @@Dset4C      s             10i 0
     D   @1Dset4       ds                  likeds(dsPahet406_t)
     D   @@Dset46      ds                  likeds(dsPahet406_t) dim(999)
     D   @@Dset46C     s             10i 0
     D   @@Ds250       ds                  likeds(dsSet250_t)
     D   x             s             10i 0
     D   @@cond        s               n
     D   @@setAG       s               n   inz('0')
     D   @@setClin     s               n   inz('1')
     D   @@setBure     s               n   inz('1')
     D   @@setMMS      s               n   inz('0')
     D   @@ccbeMMS     s              3
     D   @@ccbpMMS     s              3  0
     D   rc            s             40
     D   @@nivt        s              1  0
     D   @@nivc        s              5  0
     D   @@ccbp        s              3  0
     D   @@pcbp        s              5  2
     D   @@sspo        s              3  0
     D   @@Tipo        s              1
     D   @@Cobl        s              2
     D   @@Cob2        s              2
     D   @@pcli        s              5  2
     D   @@pbur        s              5  2
     D   @@vhvu        s             15  2
     D   @@suop        s              3  0
     D   @@tiou        s              1  0
     D   @@stou        s              2  0
     D   @@stos        s              2  0

      /free

       SPVVEH_inz();

       clear @@Dset46;
       clear @@Dset46C;

       if not SPVVEH_chkModuloDescRec( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peSspo
                                     : peRama
                                     : pePoco );
         return *off;
       endif;

       if not SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsD0
                                              : @@DsD0C );
         return *off;
       endif;

       clear @@DsT0;
       if not SPVVEH_getPahet0( @@DsD0(@@DsD0C).d0empr
                              : @@DsD0(@@DsD0C).d0sucu
                              : @@DsD0(@@DsD0C).d0arcd
                              : @@DsD0(@@DsD0C).d0spol
                              : @@DsD0(@@DsD0C).d0rama
                              : @@DsD0(@@DsD0C).d0arse
                              : pePoco
                              : @@DsD0(@@DsD0C).d0sspo
                              : @@DsT0                 );
         return *off;
       endif;

       // Obtener informacion de Recargo Marca Modelo Submodelo...
       clear @@ccbeMMS;
       clear @@ccbpMMS;
       if CZWUTL_getDescMarcaModelo( @@DsT0.t0vhmc
                                   : @@DsT0.t0vhmo
                                   : @@DsT0.t0vhcs
                                   : @@ccbpMMS      )   <> *Zeros;

         if SVPDAU_isVigente( @@DsT0.t0empr
                            : @@DsT0.t0sucu
                            : @@DsT0.t0arcd
                            : @@DsT0.t0rama
                            : @@ccbpMMS
                            : 'C'
                            : *omit             );
           @@ccbeMMS = SVPDAU_getCodigoEquivalente( @@DsT0.t0empr
                                                  : @@DsT0.t0sucu
                                                  : @@DsT0.t0arcd
                                                  : @@DsT0.t0rama
                                                  : @@ccbpMMS
                                                  : 'C'               );
           @@setMMS  = *on;
         endif;
       endif;

       clear @@DsEt4;
       clear @@DsEt4C;
       @@setClin = *off;
       @@setBure = *off;

       if %parms >= 7 and %addr( peClin ) <> *null;
         @@setClin = peClin;
         @@pcli = *zeros;
         if %addr( pePcli ) <> *Null;
           @@pcli = pePcli;
         endif;
       endif;

       @@setBure = *off;
       if %parms >= 7 and %addr( pePbur ) <> *null;
           @@pbur = pePbur;
           @@setBure = *on;
       endif;

       clear @@Tipo;
       @@tiou = 1;
       @@stou = 0;
       @@stos = 0;

       if %parms >= 7  and %addr( peTiou ) <> *null
                       and %addr( peStou ) <> *null
                       and %addr( peStos ) <> *null;
         select;
           when peTiou = 2 and peStou = 0 and peStos = 0;
             @@Tipo = '2';
           when peTiou = 3 and peStou = 11 and peStos = 1;
             @@Tipo = '1';
         endsl;

         @@tiou = peTiou;
         @@stou = peStou;
         @@stos = peStos;

       endif;

       select;
         when %parms >= 7  and %addr( peCobl ) <> *null
                           and %addr( peCob2 ) <> *null;
           @@Cobl = peCobl;
           @@Cob2 = peCob2;

         when %parms >= 7  and %addr( peCobl ) <> *null
                           and %addr( peCob2 ) =  *null;
           @@Cobl = peCobl;
           @@Cob2 = peCobl;

         when %parms >= 7  and %addr( peCobl ) =  *null
                           and %addr( peCob2 ) <> *null;
           @@Cobl = peCob2;
           @@Cob2 = peCob2;

         other;
           @@Cobl = @@DsT0.t0cobl;
           @@Cob2 = @@DsT0.t0cobl;

       endsl;

       @@cond = SPVVEH_chkVehiculo0kmSpol( @@DsT0.t0empr
                                         : @@DsT0.t0sucu
                                         : @@DsT0.t0arcd
                                         : @@DsT0.t0spol
                                         : @@DsT0.t0sspo
                                         : @@DsT0.t0rama
                                         : @@DsT0.t0arse
                                         : @@DsT0.t0oper
                                         : @@DsT0.t0suop
                                         : @@DsT0.t0poco
                                         : @@tiou
                                         : @@stou
                                         : @@stos        );

       if @@tipo = '2' and ( @@Cobl = *blanks and @@Cob2 = *blanks );
         return *off;
       endif;

       @@suop = SPVVEH_getUltimoSuop( @@DsT0.t0empr
                                    : @@DsT0.t0sucu
                                    : @@DsT0.t0arcd
                                    : @@DsT0.t0spol
                                    : @@DsT0.t0poco  );

       if SPVVEH_getListaDescuentoRecargo( @@DsT0.t0empr
                                         : @@DsT0.t0sucu
                                         : @@DsT0.t0rama
                                         : @@DsT0.t0poli
                                         : @@DsT0.t0poco
                                         : @@suop
                                         : @@Dset4
                                         : @@Dset4C      );

         for x = 1 to @@Dset4C;
           if SVPDAU_getXCodDescuento( @@DsEt4(x).t4empr
                                     : @@DsEt4(x).t4sucu
                                     : @@DsEt4(x).t4arcd
                                     : @@DsEt4(x).t4rama
                                     : @@DsEt4(x).t4ccbp
                                     : 'C'
                                     : @@Ds250           );

             if @@Ds250.stccbe = 'AG';
                @@setAG = *on;
             endif;

             if @@Ds250.stccbe = 'CLI' and @@setClin;
               if %parms >= 7 and %addr( pePcli ) <> *null;
                 @@Dset4(x).t4pcbp = @@pcli;
               else;
                 if @@Tipo = '2' and SPVVEH_chkDescuentoReno( peEmpr
                   : peSucu : peArcd : peRama : @@Dset4(x).t4Ccbp );
                   @@Dset4(x).t4pcbp = @@Ds250.stEppd;
                 endif;
               endif;
               @@setclin = *off;
             endif;

             if @@Ds250.stccbe = 'BUR';
               if %parms >= 14 and %addr( pePbur ) <> *null;
                 @@Dset4(x).t4pcbp = pePbur;
               else;
                 if @@Tipo = '2' and SPVVEH_chkDescuentoReno( peEmpr
                   : peSucu : peArcd : peRama : @@Dset4(x).t4Ccbp );
                   @@Dset4(x).t4pcbp = SVPBUE_getPorceBuenResultado(peBure);
                 endif;
               endif;
               @@setBure = *off;
             endif;

             if @@ccbeMMS = @@Ds250.stccbe and @@setMMS;
               if @@Tipo = '1';
                  @@setMMS = *off;
               endif;
               if @@Tipo = '2' and SPVVEH_chkDescuentoReno( peEmpr
                 : peSucu : peArcd : peRama : @@Dset4(x).t4Ccbp );
                 @@Dset4(x).t4pcbp = CZWUTL_getDescMarcaModelo(@@DsT0.t0vhmc
                                                              :@@DsT0.t0vhmo
                                                              :@@DsT0.t0vhcs
                                                              :@@ccbpMMS     );
                 @@setMMS = *off;
               endif;
             endif;
           else;
             if @@Tipo = '2';
               @@Dset4(x).t4pcbp = *zeros;
             endif;
           endif;

           //ccbp 14 = recargo de 17% no va mas(validar valsys HADDREC17P)
           if @@Ds250.stccbe <> 'MCD' and
              @@Ds250.stccbe <> 'AG' and
              @@Ds250.stccbp <> 14;

             if @@DsEt4(x).t4pcbp <> 0 or
                @@DsEt4(x).t4pcbp =  0 and @@Ds250.stmar3 = 'S';
                Select;
                  when @@Tipo = '1';
                    SPVVEH_grabDsEt4( @@Ds250.stCcbp
                                    : @@DsEt4(x).t4Pcbp
                                    : @@DsEt4(x).t4Mcbp
                                    : @@DsEt4(x)
                                    : @@Dset46
                                    : @@Dset46C      );
                  when @@Tipo = '2';
                    if SPVVEH_chkDescuentoReno( peEmpr : peSucu
                       : peArcd : peRama : @@Ds250.stCcbp ) and
                       not SPVVEH_chkCoberturaDesc( peEmpr
                                                  : pesucu
                                                  : @@Ds250.stCcbp
                                                  : @@pbur
                                                  : @@Cobl
                                                  : @@Cob2         );
                      SPVVEH_grabDsEt4( @@Ds250.stCcbp
                                      : @@DsEt4(x).t4Pcbp
                                      : @@DsEt4(x).t4Mcbp
                                      : @@DsEt4(x)
                                      : @@Dset46
                                      : @@Dset46C      );
                    endif;
                endsl;
             endif;
           endif;
         endfor;
       endif;
       clear @1DsEt4;
       @1DsEt4.t4Empr = peEmpr;
       @1DsEt4.t4Sucu = peSucu;
       @1DsEt4.t4Arcd = peArcd;
       @1DsEt4.t4Spol = peSpol;
       @1DsEt4.t4Sspo = peSspo;
       @1DsEt4.t4Rama = peRama;
       @1DsEt4.t4Arse = @@Dst0.t0Arse;
       @1DsEt4.t4Oper = @@Dst0.t0Oper;
       @1DsEt4.t4Suop = peSspo;
       @1DsEt4.t4Poco = pePoco;

       if @@setClin and peClin;

         clear @@Pcbp;
         if SVPDAU_getXCodDescuento( @1DsEt4.t4empr
                                   : @1DsEt4.t4sucu
                                   : @1DsEt4.t4arcd
                                   : @1DsEt4.t4rama
                                   : 10
                                   : 'C'
                                   : @@Ds250           );

           if %parms >= 7 and %addr( pePcli ) <> *null;
             @@Pcbp = pePcli;
           else;
             @@Pcbp = @@Ds250.steppd;
           endif;

           SPVVEH_grabDsEt4( 10
                           : @@Pcbp
                           : 'S'
                           : @1DsEt4
                           : @@Dset46
                           : @@Dset46C  );
         endif;
       endif;

       if @@setBure and @@pbur <> 0;

         clear @@Pcbp;
         if SVPDAU_getXCodDescuento( @1DsEt4.t4empr
                                   : @1DsEt4.t4sucu
                                   : @1DsEt4.t4arcd
                                   : @1DsEt4.t4rama
                                   : 4
                                   : 'C'
                                   : @@Ds250           );

           if %parms >= 14 and %addr( pePbur ) <> *null;
             @@Pcbp = pePbur;
           else;
             @@Pcbp = @@Ds250.steppd;
           endif;

           SPVVEH_grabDsEt4( 4
                           : @@Pcbp
                           : 'S'
                           : @1DsEt4
                           : @@Dset46
                           : @@Dset46C  );
         endif;
       endif;

       if @@Tipo <> '1';
         if SPVVEH_chk0km2aÑos( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : peSspo
                              : peRama
                              : @@Dst0.t0Arse
                              : @@Dst0.t0Oper
                              : pePoco
                              : @@Tipo         );

           if SVPDAU_getXCodDescuento( @1DsEt4.t4empr
                                     : @1DsEt4.t4sucu
                                     : @1DsEt4.t4arcd
                                     : @1DsEt4.t4rama
                                     : 993
                                     : 'C'
                                     : @@Ds250           );

             SPVVEH_grabDsEt4( 993
                             : *zeros
                             : 'S'
                             : @1DsEt4
                             : @@Dset46
                             : @@Dset46C      );
           endif;
           if SVPDAU_getXCodDescuento( @1DsEt4.t4empr
                                     : @1DsEt4.t4sucu
                                     : @1DsEt4.t4arcd
                                     : @1DsEt4.t4rama
                                     : 994
                                     : 'C'
                                     : @@Ds250           );

             SPVVEH_grabDsEt4( 994
                             : @@Ds250.steppd
                             : 'S'
                             : @1DsEt4
                             : @@Dset46
                             : @@Dset46C      );
           endif;
         endif;
       endif;

       clear @@ccbp;
       clear @@pcbp;
       clear @@vhvu;

       @@vhvu = peVhvu;
       if @@Tipo = '1' and @@setAG;
          @@vhvu = *all'9';
       endif;

       if @@Tipo = '2';
         @@setAG = *on;
       endif;

       if @@setAG;
         if CZWUTL_chkDescAltaGama2( @@dsT0.t0empr
                                   : @@dsT0.t0sucu
                                   : @@dsT0.t0cobl
                                   : @@dsT0.t0vhca
                                   : @@dsT0.t0vhv1
                                   : @@dsT0.t0vhv2
                                   : @@dsT0.t0mtdf
                                   : @@vhvu
                                   : @@cond
                                   : @@ccbp
                                   : @@pcbp );
           if @@pcbp > 0
              and SVPDAU_isVigente( @@dsT0.t0empr
                                  : @@dsT0.t0sucu
                                  : @@dsT0.t0arcd
                                  : @@dsT0.t0rama
                                  : @@ccbp
                                  :  'C'
                                  :  *omit        );

             @1Dset4.t4pcbp = @@pcbp;
             // Grabar et4;
             SPVVEH_grabDsEt4( @@ccbp
                             : @@pcbp
                             : 'N'
                             : @1DsEt4
                             : @@Dset46
                             : @@Dset46C  );
           endif;
         endif;
       endif;
       @@sspo = peSspo;
       clear @@nivt;
       clear @@nivc;
       rc = SPVSPO_getProductor( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : @@sspo
                               : @@nivt
                               : @@nivc );

       clear @@ccbp;
       clear @@pcbp;

       if SVPINT_isCabeceraEspecial( peEmpr
                                   : peSucu
                                   : 1
                                   : @@nivc
                                   : @@ccbp
                                   : @@pcbp );

         if SVPDAU_isVigente( peEmpr
                            : peSucu
                            : peArcd
                            : peRama
                            : @@ccbp
                            : 'C'
                            : *omit  );

         //grabet4...
         SPVVEH_grabDsEt4( @@Ccbp
                         : @@Pcbp
                         : 'N'
                         : @1DsEt4
                         : @@Dset46
                         : @@Dset46C);

         endif;
       endif;

       if @@setMMS;
          clear @@Ccbp;
          clear @@Pcbp;

         @@Pcbp = CZWUTL_getDescMarcaModelo(@@DsT0.t0vhmc
                                           :@@DsT0.t0vhmo
                                           :@@DsT0.t0vhcs
                                           :@@ccbpMMS    );
         //grabet4...
         SPVVEH_grabDsEt4( @@ccbpMMS
                         : @@Pcbp
                         : 'N'
                         : @1DsEt4
                         : @@Dset46
                         : @@Dset46C);
       endif;

       if %parms >= 7 and %addr( peDset4 ) <> *null;
          eval-corr peDset4 = @@Dset46;
       endif;

       if %parms >= 7 and %addr( peDset4C ) <> *null;
          peDset4C = @@Dset46C;
       endif;

       return *on;

      /end-free

     P SPVVEH_calcDescRecSpol...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_grabDsEt4(): Graba DsEt4 para el archivo PAHET4.      *
      *                                                              *
      *     peCcbp   ( input  ) Cód. Componente Bonificación         *
      *     pePcbp   ( input  ) Porcentaje de Bonificación           *
      *     peMcbp   ( input  ) Valor cambiado por USER 'S/N'        *
      *     peEDs4   ( input  ) Estructura de entrada pahet4         *
      *     peSDs4   ( output ) Estructura de salida pahet4          *
      *     peSDs4C  ( output ) Cantidad de registro                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P SPVVEH_grabDsEt4...
     P                 b
     D SPVVEH_grabDsEt4...
     D                 pi
     D   peCcbp                       3  0 const
     D   pePcbp                       5  2 const
     D   peMcbp                       1    const
     D   peEDs4                            likeds(dsPahet406_t) const
     D   peSDs4                            likeds(dsPahet406_t) dim( 999 )
     D   peSDs4C                     10i 0

      /free

       SPVVEH_inz();

       peSDs4C += 1;
       eval-corr peSDs4(peSDs4C) = peEDs4;

       peSDs4(peSDs4C).t4Ccbp = peCcbp;
       peSDs4(peSDs4C).t4Cert = *zeros;
       peSDs4(peSDs4C).t4Poli = *zeros;
       peSDs4(peSDs4C).t4Prin = *zeros;
       peSDs4(peSDs4C).t4Pcbp = pePcbp;
       peSDs4(peSDs4C).t4Pori = *zeros;
       peSDs4(peSDs4C).t4Mcbp = peMcbp;
       peSDs4(peSDs4C).t4User = @PsDs.CurUsr;
       peSDs4(peSDs4C).t4Time = %dec(%time);
       peSDs4(peSDs4C).t4Date = udate;

       return;

      /end-free

     P SPVVEH_grabDsEt4...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_chkPahet4 : Valida Descuento en Vehiculo de una       *
      *                    Superpoliza                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Componente                            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento de Operacion               *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *                                                              *
      * Retorna: *on = Existe / *off = No existe                     *
      * ------------------------------------------------------------ *
     P SPVVEH_chkPahet4...
     P                 b                   export
     D SPVVEH_chkPahet4...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       4  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peCcbp                       3  0 const

     D   k1yet4        ds                  likerec( p1het4 : *key )

       /free

       SPVVEH_inz();

       k1yet4.t4empr =  peEmpr;
       k1yet4.t4sucu =  peSucu;
       k1yet4.t4arcd =  peArcd;
       k1yet4.t4spol =  peSpol;
       k1yet4.t4sspo =  peSspo;
       k1yet4.t4rama =  peRama;
       k1yet4.t4arse =  peArse;
       k1yet4.t4oper =  peOper;
       k1yet4.t4suop =  peSuop;
       k1yet4.t4ccbp =  peCcbp;

       setll %kds( k1yet4 : 10 ) pahet4;

       return %equal;

      /end-free
     P SPVVEH_chkPahet4...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_chkVehiculo0kmSpol: Valida si vehiculo tiene descuento*
      *                            de 0km                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Componente                            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento de Operacion               *
      *     pePoco   (input)   Codigo de componente                  *
      *     peTiou   (input)   Tipo de Operacion       ( opcional )  *
      *     peStou   (input)   Subtipo de Operacion    ( opcional )  *
      *     peStos   (input)   Subtipo de Op. Sistema  ( opcional )  *
      *                                                              *
      * Retorna: *on = Existe / *off = No existe                     *
      * ------------------------------------------------------------ *
     P SPVVEH_chkVehiculo0kmSpol...
     P                 b                   export
     D SPVVEH_chkVehiculo0kmSpol...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       4  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)

     D   @@0km         s              3    inz('0KM')
     D   @@0km2        s              3    inz('2KM')
     D   rc            s               n
     D   x             s             10i 0
     D   @@Desc        ds                  likeds( dsset250_t )
     D   @@Dset0       ds                  likeds(dsPahet0_t)
     D   @@Dset4       ds                  likeds(dsPahet406_t) dim( 999 )
     D   @@Dset4C      s             10i 0
     D   @@ccbe        s              3
     D   @@sspo        s              3  0
     D   @@tiou        s              1  0
     D   @@stou        s              2  0
     D   @@stos        s              2  0

       /free

       SPVVEH_inz();

       @@tiou = 1;
       @@stou = 0;
       @@stos = 0;

       if %parms >= 11 and %addr( peTiou ) <> *null and
                           %addr( peStou ) <> *null and
                           %addr( peStos ) <> *null;
         @@tiou = peTiou;
         @@stou = peStou;
         @@stos = peStos;
       endif;

       clear @@DseT0;
       @@sspo = peSspo;
       if not SPVVEH_getPahet0( peEmpr
                              : pesucu
                              : peArcd
                              : peSpol
                              : peRama
                              : peArse
                              : pePoco
                              : @@sspo
                              : @@DsEt0 );
         return *off;
       endif;


       if SPVVEH_getListaDescuentoRecargo( @@DsEt0.t0empr
                                         : @@DsEt0.t0sucu
                                         : @@DsEt0.t0rama
                                         : @@DsEt0.t0poli
                                         : @@DsEt0.t0poco
                                         : @@DsEt0.t0suop
                                         : @@Dset4
                                         : @@Dset4C      );


          for x = 1 to @@Dset4C;

            clear @@ccbe;
            @@ccbe = SVPDAU_getCodigoEquivalente( peEmpr
                                                : peSucu
                                                : peArcd
                                                : peRama
                                                : @@dset4(x).t4ccbp
                                                : 'C'               );

            if @@ccbe = @@0km;
               return *on;
            endif;

            if @@ccbe = @@0km2 and @@tiou <> 2;
               return *on;
            endif;

          endfor;

       endif;

        return *off;

      /end-free

     P SPVVEH_chkVehiculo0kmSpol...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_chkDescuentoReno(): Chequea descuento para la renova- *
      *                            ción.                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Artículo                              *
      *     peRama   (input)   Rama                                  *
      *     peCcbp   (input)   Código de descuento                   *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_chkDescuentoReno...
     P                 b                   export
     D SPVVEH_chkDescuentoReno...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const

       /free

       SPVVEH_inz();

       if peCcbp <> 993 and peCcbp <> 994 and peCcbp <> 995 and
          peCcbp <> 997 and peCcbp <> 18  and peCcbp <> 30  and
          peCcbp <> 31  and peCcbp <> 36  and peCcbp <> 998 and
          not SVPDAU_chkDescxEquivalente( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peRama
                                        : 'RMM'
                                        : 'C'
                                        : peCcbp ) and
          not SVPDAU_chkDescxEquivalente( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peRama
                                        : 'AG'
                                        : 'C'
                                        : peCcbp ) and
          not SVPDAU_chkDescxEquivalente( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peRama
                                        : 'WEB'
                                        : 'C'
                                        : peCcbp );

         return *on;
       endif;

       return *off;

      /end-free

     P SPVVEH_chkDescuentoReno...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_chkCoberturaDesc(): Chequea cobertura del descuento   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peCcbp   (input)   Código de descuento                   *
      *     pePbur   (input)   % de buen resultado                   *
      *     peCobl   (input)   Cobertura                             *
      *     peCob2   (input)   Cobertura por Omisión                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_chkCoberturaDesc...
     P                 b                   export
     D SPVVEH_chkCoberturaDesc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCcbp                       3  0 const
     D   pePbur                       5  2 const
     D   peCobl                       2    const
     D   peCob2                       2    const

       /free

       SPVVEH_inz();

       if peCcbp = 996 and not ( pePbur <> 0 and
          ( peCob2 = 'D1' or peCob2 = 'D2' or peCob2 = 'D3' ) and
          ( peCobl = 'D1' or peCobl = 'D2' or peCobl = 'D3' ) );

         return *on;
       endif;

       return *off;

      /end-free

     P SPVVEH_chkCoberturaDesc...
     P                 e
      * ------------------------------------------------------------ *
      * SPVVEH_calcPrimaAnual : Calcula prima de un vehiculo         *
      *                                                              *
      *     peCobl   (input)   Cobertura                             *
      *     peVhvu   (input)   Valor usado                           *
      *     peVh0k   (input)   Valor cero kilometro                  *
      *     peVacc   (input)   Valor Accesorios                      *
      *     peClaj   (input)   Clausula de ajuste                    *
      *     peRebr   (input)   Buen Resultado                        *
      *     peCfas   (input)   Código de Franquicia                  *
      *     peTarc   (input)   Tabla RC                              *
      *     peTair   (input)   Tabla AIR                             *
      *     peScta   (input)   Zona                                  *
      *     peVhca   (input)   Capitulo del vehiculo                 *
      *     peVhv1   (input)   Capitulo variante r.c.                *
      *     peVhv2   (input)   Capitulo variante air                 *
      *     peVhaÑ   (input)   Año del Vechiculo                     *
      *     peVhni   (input)   Origen del Vehiculo                   *
      *     peVhct   (input)   Tipo de vehiculo                      *
      *     peVhuv   (input)   Codigo de uso de vehiculo             *
      *     peMone   (input)   Codigo de Moneda                      *
      *     peNcoc   (input)   Codigo de Coaseguradora               *
      *     peMar1   (input)   Buscar en tabla general RC            *
      *     peMar2   (input)   Buscar en tabla general AIR           *
      *     peDesc   (input)   Total de Descuentos                   *
      *     pe0km    (input)   Marca de 0Km                          *
      *     peFvid   (input)   Fecha de Vigencia                     *
      *     peCtre   (output)  Codigo de Tarifa                      *
      *     peMtdf   (output)  Marca tarifa diferencial              *
      *     poPrrc   (output)  Importe de Prima RC                   *
      *     poPrac   (output)  Importe de Prima por Accidente        *
      *     poPrin   (output)  Importe de Prima por Incendio         *
      *     poPrro   (output)  Importe de Prima Robo                 *
      *     poPacc   (output)  Importe de Prima Accesorio            *
      *     poPraa   (output)  Importe de Prima Ajuste Automatico    *
      *     poPrsf   (output)  Importe de Prima sin Franquicia       *
      *     poPrce   (output)  Importe de Prima Exterior             *
      *     poPrap   (output)  Importe de Prima por Accidente Pers.  *
      *     poRcle   (output)  Limite RC de Lesiones                 *
      *     poRcco   (output)  Limite RC Cosas                       *
      *     poRcac   (output)  Limite RC Acontecimientos             *
      *     poLrce   (output)  Limite RC de Exterior                 *
      *     poSaap   (output)  Suma.Aseg.Acci.Personales             *
      *     poSdes   (output)  Suma.Aseg.Descuentos                  *
      *                                                              *
      * Retorna: *on = Calculó / *off = No Calculó                   *
      * ------------------------------------------------------------ *
     P SPVVEH_calcPrimaAnual...
     P                 b                   export
     D SPVVEH_calcPrimaAnual...
     D                 pi              n
     D   peCobl                       2    const
     D   peVhvu                      15  2 const
     D   peVh0k                      15  2 const
     D   peVacc                      15  0 const
     D   peClaj                       3  0 const
     D   peRebr                       1  0 const
     D   peCfas                       1    const
     D   peTarc                       2  0 const
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peVhaÑ                       4  0 const
     D   peVhni                       1    const
     D   peVhct                       2  0 const
     D   peVhuv                       2  0 const
     D   peMone                       2    const
     D   peNcoc                       5  0 const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peDesc                       5  2 const
     D   pe0km                         n   const
     D   peFvid                       8  0 const
     D   peCtre                       5  0 const
     D   peMtdf                       1    const
     D   poPrrc                      15  2
     D   poPrac                      15  2
     D   poPrin                      15  2
     D   poPrro                      15  2
     D   poPacc                      15  2
     D   poPraa                      15  2
     D   poPrsf                      15  2
     D   poPrce                      15  2
     D   poPrap                      15  2
     D   poRcle                      15  2
     D   poRcco                      15  2
     D   poRcac                      15  2
     D   poLrce                      15  2
     D   poSaap                      15  2
     D   poSdes                       5  2

      /free

       SPVVEH_inz();

       clear  poPrrc;
       clear  poPrac;
       clear  poPrin;
       clear  poPrro;
       clear  poPacc;
       clear  poPraa;
       clear  poPrsf;
       clear  poPrce;
       clear  poPrap;
       clear  poRcle;
       clear  poRcle;
       clear  poRcco;
       clear  poRcac;
       clear  poLrce;
       clear  poSaap;
       clear  poSdes;

       PAR313G( peCobl
              : peVhvu
              : peVh0k
              : peVacc
              : peClaj
              : peRebr
              : peCfas
              : peTarc
              : peTair
              : peScta
              : peVhca
              : peVhv1
              : peVhv2
              : peVhaÑ
              : peVhni
              : peVhct
              : peVhuv
              : peMone
              : peNcoc
              : peMar1
              : peMar2
              : peDesc
              : pe0km
              : peFvid
              : poPrrc
              : poPrac
              : poPrin
              : poPrro
              : poPacc
              : poPraa
              : poPrsf
              : poPrce
              : poPrap
              : poRcle
              : poRcco
              : poRcac
              : poLrce
              : poSaap
              : poSdes
              : peCtre
              : peMtdf  );

       return *on;
      /end-free
     P SPVVEH_calcPrimaAnual...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_calcPrimaPeriodo: Calcula prima de un vehiculo        *
      *                          para un peridodo determinado        *
      *                                                              *
      *     peFini   ( input )   Fecha Inicio de Vigencia            *
      *     peFfin   ( input )   Fecha Fin de Vigencia               *
      *     peFhaf   ( input )   Fecha Hasta Facturado               *
      *     pePrrc   ( input )   Importe de Prima RC                 *
      *     pePrac   ( input )   Importe de Prima por Accidente      *
      *     pePrin   ( input )   Importe de Prima por Incendio       *
      *     pePrro   ( input )   Importe de Prima Robo               *
      *     pePacc   ( input )   Importe de Prima Accesorio          *
      *     pePraa   ( input )   Importe de Prima Ajuste Automatico  *
      *     pePrsf   ( input )   Importe de Prima sin Franquicia     *
      *     pePrce   ( input )   Importe de Prima Exterior           *
      *     pePrap   ( input )   Importe de Prima por Accidente Pers.*
      *     peTiou   ( input )   Tipo de Operacion                   *
      *     peStou   ( input )   Subtipo Usuario                     *
      *     peStos   ( input )   Subtipo Sistema                     *
      *                                                              *
      ****************************************************************
     P SPVVEH_calcPrimaPeriodo...
     P                 b                   export
     D SPVVEH_calcPrimaPeriodo...
     D                 pi              n
     D   peFini                       8  0 const
     D   peFfin                       8  0 const
     D   peFhaf                       8  0 const
     D   pePrrc                      15  2
     D   pePrac                      15  2
     D   pePrin                      15  2
     D   pePrro                      15  2
     D   pePacc                      15  2
     D   pePraa                      15  2
     D   pePrsf                      15  2
     D   pePrce                      15  2
     D   pePrap                      15  2
     D   peDup2                       2  0 options(*nopass:*omit)
     D   peTiou                       1  0 options(*nopass:*omit)
     D   peStou                       2  0 options(*nopass:*omit)
     D   peStos                       2  0 options(*nopass:*omit)

     D pri             s             15  2 dim(9)
     D tmphas          s               d   datfmt(*iso)
     D tmphf1          s               d   datfmt(*iso)
     D tmphf2          s               d   datfmt(*iso)
     D @@dias          s             10i 0
     D @@fhas          s              8  0
     D @@fhf1          s              8  0
     D @@fhf2          s              8  0
     D @@fin           s              3
     D @@aux1          s             30  9
     D x               s             10i 0

      /free
       SPVVEH_inz();

       pri(1) = pePrrc;
       pri(2) = pePrac;
       pri(3) = pePrin;
       pri(4) = pePrro;
       pri(5) = pePacc;
       pri(6) = pePraa;
       pri(7) = pePrsf;
       pri(8) = pePrce;
       pri(9) = pePrap;

       @@fhas = peFfin;
       @@fhf1 = peFhaf;
       @@fhf2 = peFini;

       tmphf1 = %date( %editc ( @@fhf1 : 'X' ) : *eur0 );
       tmphas = %date( %editc ( @@fhas : 'X' ) : *eur0 );
       tmphf2 = %date( %editc ( @@fhf2 : 'X' ) : *eur0 );

       //Restar fechas, resultado en dias
       @@dias = %DIFF (tmphf2 : tmphf1 : *DAYS);

       select;
         when peDup2 <> 99;
           SP0001( @@fhf2 : peDup2 : @@fin );
         when peDup2 = 99;
           @@fhf2 = @@fhas;
       endsl;

       //fecha hasta facturado
       tmphf2 = %date( %editc ( @@fhf2 : 'X' ) : *eur0 );

       if %subdt(tmphas:*YEARS)  =  %subdt(tmphf2:*YEARS) and
          %subdt(tmphas:*MONTHS) =  %subdt(tmphf2:*MONTHS);
          if %DIFF (tmphas : tmphf2 : *DAYS) <= 3;
             @@fhf2 = %int(%subst(%char(@@fhf2):3)) +
                      %int(%char(%subdt(tmphf2:*DAYS))) * 1000000;
          endif;
       endif;

       if @@fhf1 <> @@fhf2  and
          @@fhf1 = @@fhas   and
          peDup2 <> 99      and
          peDup2 =  99;

          for x = 1 to 9;
            eval(h) @@aux1 = pri(x)/365;
            eval(h) pri(x) = @@aux1 * @@dias;
          endfor;
       else;
          for x = 1 to 9;
            eval(h) @@aux1 = pri(x)/12;
            eval(h) pri(x) = @@aux1 * peDup2;
          endfor;
       endif;

       pePrrc  =  pri(1);
       pePrac  =  pri(2);
       pePrin  =  pri(3);
       pePrro  =  pri(4);
       pePacc  =  pri(5);
       pePraa  =  pri(6);
       pePrsf  =  pri(7);
       pePrce  =  pri(8);
       pePrap  =  pri(9);


        return *on;

      /end-free

     P SPVVEH_calcPrimaPeriodo...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet4 : Retorna Descuentos de un Vehiculo de una  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Componente                            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento de Operacion               *
      *     pePoco   (input)   Nro de Componente                     *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *     peDsT4   (Output)  Registro con PAHET4                   *
      *     peDsT4C  (Output)  Cantidad de Registros                 *
      *                                                              *
      * Retorna: *on = Existe / *off = No existe                     *
      * ------------------------------------------------------------ *
     P SPVVEH_getPahet4...
     P                 b                   export
     D SPVVEH_getPahet4...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *omit : *nopass )
     D   peRama                       2  0 const options( *omit : *nopass )
     D   peArse                       4  0 const options( *omit : *nopass )
     D   peOper                       7  0 const options( *omit : *nopass )
     D   peSuop                       3  0 const options( *omit : *nopass )
     D   pePoco                       4  0 const options( *omit : *nopass )
     D   peCcbp                       3  0 const options( *omit : *nopass )
     D   peDsT4                            likeds(dsPahet4_t) dim(999)
     D                                     options( *omit : *nopass )
     D   peDsT4C                     10i 0 options( *omit : *nopass )

     D   k1yet4        ds                  likerec( p1het4 : *key )

     D   @@DsIt4       ds                  likerec( p1het4 : *input )
     D   @@DsT4        ds                  likeds ( dsPahet4_t ) dim(999)
     D   @@DsT4C       s             10i 0

       /free

       SPVVEH_inz();

       clear @@Dst4;
       clear @@Dst4C;

       k1yet4.t4empr =  peEmpr;
       k1yet4.t4sucu =  peSucu;
       k1yet4.t4arcd =  peArcd;
       k1yet4.t4spol =  peSpol;

       if %parms >= 5;
       select;
         when %addr( peSspo ) <> *null and
              %addr( peRama ) <> *null and
              %addr( peArse ) <> *null and
              %addr( peOper ) <> *null and
              %addr( pePoco ) <> *null and
              %addr( peSuop ) <> *null and
              %addr( peCcbp ) <> *null;

              k1yet4.t4sspo =  peSspo;
              k1yet4.t4rama =  peRama;
              k1yet4.t4arse =  peArse;
              k1yet4.t4oper =  peOper;
              k1yet4.t4poco =  pePoco;
              k1yet4.t4suop =  peSuop;
              k1yet4.t4ccbp =  peCcbp;
              setll %kds( k1yet4 : 11 ) pahet4;
              reade(n) %kds( k1yet4 : 11 ) pahet4 @@DsIT4;
              dow not %eof( pahet4 );
                @@DsT4c += 1;
                eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
               reade(n) %kds( k1yet4 : 11 ) pahet4 @@DsIT4;
              enddo;

         when %addr( peSspo ) <> *null and
              %addr( peRama ) <> *null and
              %addr( peArse ) <> *null and
              %addr( peOper ) <> *null and
              %addr( pePoco ) <> *null and
              %addr( peSuop ) <> *null and
              %addr( peCcbp ) =  *null;

              k1yet4.t4sspo =  peSspo;
              k1yet4.t4rama =  peRama;
              k1yet4.t4arse =  peArse;
              k1yet4.t4oper =  peOper;
              k1yet4.t4poco =  pePoco;
              k1yet4.t4suop =  peSuop;
              setll %kds( k1yet4 : 10 ) pahet4;
              reade(n) %kds( k1yet4 : 10 ) pahet4 @@DsIT4;
              dow not %eof( pahet4 );
                @@DsT4c += 1;
                eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
               reade(n) %kds( k1yet4 : 10 ) pahet4 @@DsIT4;
              enddo;

         when %addr( peSspo ) <> *null and
              %addr( peRama ) <> *null and
              %addr( peArse ) <> *null and
              %addr( peOper ) <> *null and
              %addr( pePoco ) <> *null and
              %addr( peSuop ) =  *null and
              %addr( peCcbp ) =  *null;

              k1yet4.t4sspo =  peSspo;
              k1yet4.t4rama =  peRama;
              k1yet4.t4arse =  peArse;
              k1yet4.t4oper =  peOper;
              k1yet4.t4poco =  pePoco;
              setll %kds( k1yet4 : 9 ) pahet4;
              reade(n) %kds( k1yet4 : 9 ) pahet4 @@DsIT4;
              dow not %eof( pahet4 );
                @@DsT4c += 1;
                eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
               reade(n) %kds( k1yet4 : 9 ) pahet4 @@DsIT4;
              enddo;

         when %addr( peSspo ) <> *null and
              %addr( peRama ) <> *null and
              %addr( peArse ) <> *null and
              %addr( peOper ) <> *null and
              %addr( pePoco ) =  *null and
              %addr( peSuop ) =  *null and
              %addr( peCcbp ) =  *null;

              k1yet4.t4sspo =  peSspo;
              k1yet4.t4rama =  peRama;
              k1yet4.t4arse =  peArse;
              k1yet4.t4oper =  peOper;
              setll %kds( k1yet4 : 8 ) pahet4;
              reade(n) %kds( k1yet4 : 8 ) pahet4 @@DsIT4;
              dow not %eof( pahet4 );
                @@DsT4c += 1;
                eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
               reade(n) %kds( k1yet4 : 8 ) pahet4 @@DsIT4;
              enddo;

         when %addr( peSspo ) <> *null and
              %addr( peRama ) <> *null and
              %addr( peArse ) <> *null and
              %addr( peOper ) =  *null and
              %addr( pePoco ) =  *null and
              %addr( peSuop ) =  *null and
              %addr( peCcbp ) =  *null;

              k1yet4.t4sspo =  peSspo;
              k1yet4.t4rama =  peRama;
              k1yet4.t4arse =  peArse;
              setll %kds( k1yet4 : 7 ) pahet4;
              reade(n) %kds( k1yet4 : 7 ) pahet4 @@DsIT4;
              dow not %eof( pahet4 );
                @@DsT4c += 1;
                eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
               reade(n) %kds( k1yet4 : 7 ) pahet4 @@DsIT4;
              enddo;

         when %addr( peSspo ) <> *null and
              %addr( peRama ) <> *null and
              %addr( peArse ) =  *null and
              %addr( peOper ) =  *null and
              %addr( pePoco ) =  *null and
              %addr( peSuop ) =  *null and
              %addr( peCcbp ) =  *null;

              k1yet4.t4sspo =  peSspo;
              k1yet4.t4rama =  peRama;
              setll %kds( k1yet4 : 6 ) pahet4;
              reade(n) %kds( k1yet4 : 6 ) pahet4 @@DsIT4;
              dow not %eof( pahet4 );
                @@DsT4c += 1;
                eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
               reade(n) %kds( k1yet4 : 6 ) pahet4 @@DsIT4;
              enddo;

         when %addr( peSspo ) <> *null and
              %addr( peRama ) =  *null and
              %addr( peArse ) =  *null and
              %addr( peOper ) =  *null and
              %addr( pePoco ) =  *null and
              %addr( peSuop ) =  *null and
              %addr( peCcbp ) =  *null;

              k1yet4.t4sspo =  peSspo;
              setll %kds( k1yet4 : 5 ) pahet4;
              reade(n) %kds( k1yet4 : 5 ) pahet4 @@DsIT4;
              dow not %eof( pahet4 );
                @@DsT4c += 1;
                eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
               reade(n) %kds( k1yet4 : 5 ) pahet4 @@DsIT4;
              enddo;

         other;
           setll %kds( k1yet4 : 4 ) pahet4;
           reade(n) %kds( k1yet4 : 4 ) pahet4 @@DsIT4;
           dow not %eof( pahet4 );
             @@DsT4c += 1;
             eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
            reade(n) %kds( k1yet4 : 4 ) pahet4 @@DsIT4;
           enddo;
         endsl;
       else;
         setll %kds( k1yet4 : 4 ) pahet4;
         reade(n) %kds( k1yet4 : 4 ) pahet4 @@DsIT4;
         dow not %eof( pahet4 );
           @@DsT4c += 1;
           eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
          reade(n) %kds( k1yet4 : 4 ) pahet4 @@DsIT4;
         enddo;
       endif;

       if not %equal( pahet4 );
         return *off;
       endif;

       if %parms >= 5;
         if %addr( peDsT4  ) <> *null;
           eval-corr peDsT4 = @@DsT4;
         endif;
         if %addr( peDsT4C ) <> *null;
           peDsT4C = @@DsT4C;
         endif;
       endif;

       return *on;

      /end-free
     P SPVVEH_getPahet4...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_getUltimoSuop : Obtener ultimo nro de suplemento de   *
     ?*                        operacion de un componentee           *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     pePoco   ( input  ) Componente                           *
     ?*                                                              *
     ?* Retorna: -1:No encontro / >= 0:Encontro                      *
     ?* ------------------------------------------------------------ *
     P SPVVEH_getUltimoSuop...
     P                 b                   export
     D SPVVEH_getUltimoSuop...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const

     D   k1yet4        ds                  likerec( p1het402 : *key )

      /free

       SPVVEH_inz();

       k1yet4.t4empr = peEmpr;
       k1yet4.t4sucu = peSucu;
       k1yet4.t4arcd = peArcd;
       k1yet4.t4spol = peSpol;
       k1yet4.t4poco = pePoco;
       chain(n) %kds( k1yet4 : 5 ) pahet402;
       if not %found(pahet402);
         return -1;
       endif;

       return t4suop;

      /end-free

     P SPVVEH_getUltimoSuop...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getListaPahet9(): Retorna Lista de PAHET9             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                ( opcional )      *
      *     peArse   (input)   Arse                ( opcional )      *
      *     peOper   (input)   Operacion           ( opcional )      *
      *     pePoco   (input)   Componetne          ( opcional )      *
      *     peDsT9   (Output)  Estructura PAHET9   ( opcional )      *
      *     peDsT9C  (Output)  Cantidad   PAHET9   ( opcional )      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getListaPahet9...
     P                 B                   export
     D SPVVEH_getListaPahet9...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peOper                       7  0 const options(*nopass:*omit)
     D   pePoco                       4  0 const options(*nopass:*omit)
     D   peDsT9                            likeds(dsPahet9_t) dim( 999 )
     D                                     options(*nopass:*omit)
     D   peDst9C                     10i 0 options(*nopass:*omit)

     D k1yet9          ds                  likeRec(p1het9:*Key)
     D @@dsEt9         ds                  likeds(dsPahet9_t) dim( 999 )
     D @@dsEt9C        s             10i 0
     D @@dsIEt9        ds                  likerec( p1het9 : *input )

       SPVVEH_inz();

         k1yet9.t9empr = peEmpr;
         k1yet9.t9sucu = peSucu;
         k1yet9.t9arcd = peArcd;
         k1yet9.t9spol = peSpol;

         if %parms >= 5;
           Select;
             when %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) <> *null and
                  %addr( pePoco ) <> *null;

                  k1yet9.t9rama = peRama;
                  k1yet9.t9arse = peArse;
                  k1yet9.t9oper = peOper;
                  k1yet9.t9poco = pePoco;
                  setll %kds( k1yet9 : 8 ) pahet9;
                  if not %equal( pahet9 );
                    return *off;
                  endif;
                  reade(n) %kds( k1yet9 : 8 ) pahet9 @@DsIEt9;
                  dow not %eof( pahet9 );
                    @@DsEt9c += 1;
                    eval-corr @@DsEt9 ( @@DsEt9C ) = @@DsIEt9;
                   reade(n) %kds( k1yet9 : 8 ) pahet9 @@DsIEt9;
                 enddo;

             when %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) <> *null and
                  %addr( pePoco ) =  *null;

                  k1yet9.t9rama = peRama;
                  k1yet9.t9arse = peArse;
                  k1yet9.t9oper = peOper;
                  setll %kds( k1yet9 : 7 ) pahet9;
                  if not %equal( pahet9 );
                    return *off;
                  endif;
                  reade(n) %kds( k1yet9 : 7 ) pahet9 @@DsIEt9;
                  dow not %eof( pahet9 );
                    @@DsEt9C += 1;
                    eval-corr @@DsEt9 ( @@DsEt9C ) = @@DsIEt9;
                   reade(n) %kds( k1yet9 : 7 ) pahet9 @@DsIEt9;
                 enddo;

             when %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) =  *null and
                  %addr( pePoco ) =  *null;

                  k1yet9.t9rama = peRama;
                  k1yet9.t9arse = peArse;
                  setll %kds( k1yet9 : 6 ) pahet9;
                  if not %equal( pahet9 );
                    return *off;
                  endif;
                  reade(n) %kds( k1yet9 : 6 ) pahet9 @@DsIEt9;
                  dow not %eof( pahet9 );
                    @@DsEt9C += 1;
                    eval-corr @@DsEt9 ( @@DsEt9C ) = @@DsIEt9;
                   reade(n) %kds( k1yet9 : 6 ) pahet9 @@DsIEt9;
                 enddo;

             when %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( peOper ) =  *null and
                  %addr( pePoco ) =  *null;

                  k1yet9.t9rama = peRama;
                  setll %kds( k1yet9 : 5 ) pahet9;
                  if not %equal( pahet9 );
                    return *off;
                  endif;
                  reade(n) %kds( k1yet9 : 5 ) pahet9 @@DsIEt9;
                  dow not %eof( pahet9 );
                    @@DsEt9C += 1;
                    eval-corr @@DsEt9 ( @@DsEt9C ) = @@DsIEt9;
                   reade(n) %kds( k1yet9 : 5 ) pahet9 @@DsIEt9;
                 enddo;

             when %addr( peRama ) =  *null and
                  %addr( peArse ) =  *null and
                  %addr( peOper ) =  *null and
                  %addr( pePoco ) =  *null;

                  setll %kds( k1yet9 : 4 ) pahet9;
                  if not %equal( pahet9 );
                    return *off;
                  endif;
                  reade(n) %kds( k1yet9 : 4 ) pahet9 @@DsIEt9;
                  dow not %eof( pahet9 );
                    @@DsEt9C += 1;
                    eval-corr @@DsEt9 ( @@DsEt9C ) = @@DsIEt9;
                   reade(n) %kds( k1yet9 : 4 ) pahet9 @@DsIEt9;
                 enddo;
           other;
             setll %kds( k1yet9 : 4 ) pahet9;
             if not %equal( pahet9 );
               return *off;
             endif;
             reade(n) %kds( k1yet9 : 4 ) pahet9 @@DsIEt9;
             dow not %eof( pahet9 );
               @@DsEt9C += 1;
               eval-corr @@DsEt9 ( @@DsEt9C ) = @@DsIEt9;
              reade(n) %kds( k1yet9 : 4 ) pahet9 @@DsIEt9;
             enddo;
           endsl;
        else;
           setll %kds( k1yet9 : 4 ) pahet9;
           if not %equal( pahet9 );
             return *off;
           endif;
           reade(n) %kds( k1yet9 : 4 ) pahet9 @@DsIEt9;
           dow not %eof( pahet9 );
             @@DsEt9C += 1;
             eval-corr @@DsEt9 ( @@DsEt9C ) = @@DsIEt9;
            reade(n) %kds( k1yet9 : 4 ) pahet9 @@DsIEt9;
           enddo;
        endif;

         if %parms >= 5 and %addr( peDsT9 ) <> *null;
           eval-corr peDsT9 = @@dsEt9;
         endif;

         if %parms >= 5 and %addr( peDsT9C ) <> *null;
           peDsT9C = @@dsEt9C;
         endif;

         return *On;

     P SPVVEH_getListaPahet9...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_aplicaRevScoring(): Aplica Reverso de Scoring en las  *
     ?*                            primas                            *
     ?*                                                              *
     ?*     pePrrc   ( input  ) Prima de RC                          *
     ?*     pePrac   ( input  ) Prima de Accidente                   *
     ?*     pePrin   ( input  ) Prima de Incendio                    *
     ?*     pePrro   ( input  ) Prima de Robo                        *
     ?*     pePacc   ( input  ) Prima de Accesorios                  *
     ?*     pePraa   ( input  ) Prima de Ajuste                      *
     ?*     pePrsf   ( input  ) Prima Sin Franquicia                 *
     ?*     pePrce   ( input  ) Prima RC Exterior                    *
     ?*     pePrap   ( input  ) Prima de AP                          *
     ?*     peTaaj   ( input  ) Código de Cuestionario               *
     ?*     peDsIte  ( input  ) Estr. Items de un componente         *
     ?*     peDsIteC ( input  ) Cant. Items de un componente         *
     ?*     poRrcp   ( output ) Prima de RC                          *
     ?*     poRacp   ( output ) Prima de Accidente                   *
     ?*     poRinp   ( output ) Prima de Incendio                    *
     ?*     poRrop   ( output ) Prima de Robo                        *
     ?*     poAccp   ( output ) Prima de Accesorios                  *
     ?*     poRaap   ( output ) Prima de Ajuste                      *
     ?*     poRsfp   ( output ) Prima Sin Franquicia                 *
     ?*     poRcep   ( output ) Prima RC Exterior                    *
     ?*     poRapp   ( output ) Prima de AP                          *
     ?*                                                              *
     ?* ------------------------------------------------------------ *
     P SPVVEH_aplicaRevScoring...
     P                 b                   export
     D SPVVEH_aplicaRevScoring...
     D                 pi
     D   pePrrc                      15  2 const
     D   pePrac                      15  2 const
     D   pePrin                      15  2 const
     D   pePrro                      15  2 const
     D   pePacc                      15  2 const
     D   pePraa                      15  2 const
     D   pePrsf                      15  2 const
     D   pePrce                      15  2 const
     D   pePrap                      15  2 const
     D   peTaaj                       2  0 const
     D   peDsIte                           likeds (items_t) dim(200) const
     D   peDsIteC                    10i 0 const
     D   poPrrc                      15  2
     D   poPrac                      15  2
     D   poPrin                      15  2
     D   poPrro                      15  2
     D   poPacc                      15  2
     D   poPraa                      15  2
     D   poPrsf                      15  2
     D   poPrce                      15  2
     D   poPrap                      15  2

     D i               s             10i 0
     D x               s             10i 0
     D @@Aux1          s             29  9
     D @@Cant          s              2  0
     D @@Corc          s              7  4
     D @@Coca          s              7  4
     D @@Tiaj          s              1
     D @@Tiac          s              1

      /free

       SPVVEH_inz();

       poPrrc = pePrrc;
       poPrac = pePrac;
       poPrin = pePrin;
       poPrro = pePrro;
       poPacc = pePacc;
       poPraa = pePraa;
       poPrsf = pePrsf;
       poPrce = pePrce;
       poPrap = pePrap;

       for x = 1 to peDsIteC;

         // Determinar la cantidad de veces a aplicar...

         if peDsIte(x).Cant = *zeros;
           @@Cant = 1;
         else;
           @@Cant = peDsIte(x).Cant;
         endif;

         clear @@Corc;
         clear @@Coca;

         // Datos de la Estructura de Items
         @@Tiaj = peDsIte(x).Tiaj;
         @@Tiac = peDsIte(x).Tiac;
         @@Corc = peDsIte(x).Corc;
         @@Coca = peDsIte(x).Coca;

         // Forma de aplicar el Scoring...

         select;
           // Porcentajes...
           when @@Tiaj = 'P';
             // Base de cálculo del Scoring...
             select;
               // Aplicación acumulativa...
               when @@Tiac = 'A';

                 for i = 1 to @@Cant;
                   poPrrc /= @@Corc;
                   poPrce /= @@Corc;
                   poPrap /= @@Corc;
                   poPrac /= @@Coca;
                   poPrin /= @@Coca;
                   poPrro /= @@Coca;
                   poPacc /= @@Coca;
                   poPraa /= @@Coca;
                   poPrsf /= @@Coca;
                 endfor;

               // Siempre sobre la misma base...
               when @@Tiac = 'B';

                 for i = 1 to @@Cant;
                   @@Aux1 = pePrrc / @@Corc;
                   @@Aux1 += pePrrc;
                   poPrrc -= @@Aux1;

                   @@Aux1 = pePrce / @@Corc;
                   @@Aux1 += pePrce;
                   poPrce -= @@Aux1;

                   @@Aux1 = pePrap / @@Corc;
                   @@Aux1 += pePrap;
                   poPrap -= @@Aux1;

                   @@Aux1 = pePrac / @@Coca;
                   @@Aux1 += pePrac;
                   poPrac -= @@Aux1;

                   @@Aux1 = pePrin / @@Coca;
                   @@Aux1 += pePrin;
                   poPrin -= @@Aux1;

                   @@Aux1 = pePrro / @@Coca;
                   @@Aux1 += pePrro;
                   poPrro -= @@Aux1;

                   @@Aux1 = pePacc / @@Coca;
                   @@Aux1 += pePacc;
                   poPacc -= @@Aux1;

                   @@Aux1 = pePraa / @@Coca;
                   @@Aux1 += pePraa;
                   poPraa -= @@Aux1;

                   @@Aux1 = pePrsf / @@Coca;
                   @@Aux1 += pePrsf;
                   poPrsf -= @@Aux1;
                 endfor;
             endsl;

           // Coeficientes...
           when @@Tiaj = 'C';
             // Base de cálculo del Scoring...
             select;
               // Aplicación acumulativa...
               when @@Tiac = 'A';

                 for i = 1 to @@Cant;
                   poPrrc /= @@Corc;
                   poPrce /= @@Corc;
                   poPrap /= @@Corc;
                   poPrac /= @@Coca;
                   poPrin /= @@Coca;
                   poPrro /= @@Coca;
                   poPacc /= @@Coca;
                   poPraa /= @@Coca;
                   poPrsf /= @@Coca;
                 endfor;

               // Siempre sobre la misma base...
               when @@Tiac = 'B';

                 for i = 1 to @@Cant;
                   @@Aux1 = pePrrc / @@Corc;
                   @@Aux1 += pePrrc;
                   poPrrc -= @@Aux1;

                   @@Aux1 = pePrce / @@Corc;
                   @@Aux1 += pePrce;
                   poPrce -= @@Aux1;

                   @@Aux1 = pePrap / @@Corc;
                   @@Aux1 += pePrap;
                   poPrap -= @@Aux1;

                   @@Aux1 = pePrac / @@Coca;
                   @@Aux1 += pePrac;
                   poPrac -= @@Aux1;

                   @@Aux1 = pePrin / @@Coca;
                   @@Aux1 += pePrin;
                   poPrin -= @@Aux1;

                   @@Aux1 = pePrro / @@Coca;
                   @@Aux1 += pePrro;
                   poPrro -= @@Aux1;

                   @@Aux1 = pePacc / @@Coca;
                   @@Aux1 += pePacc;
                   poPacc -= @@Aux1;

                   @@Aux1 = pePraa / @@Coca;
                   @@Aux1 += pePraa;
                   poPraa -= @@Aux1;

                   @@Aux1 = pePrsf / @@Coca;
                   @@Aux1 += pePrsf;
                   poPrsf -= @@Aux1;
                 endfor;
             endsl;
         endsl;
       endfor;

       return;

      /end-free

     P SPVVEH_aplicaRevScoring...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getPrimasAcumu(): Retonar primas acumuladas           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     pePrrc   (input)   Prima de RC                           *
      *     pePrac   (input)   Prima de Accidente                    *
      *     pePrin   (input)   Prima de Incendio                     *
      *     pePrro   (input)   Prima de Robo                         *
      *     pePacc   (input)   Prima de Accesorios                   *
      *     pePraa   (input)   Prima de Ajuste                       *
      *     pePrsf   (input)   Prima Sin Franquicia                  *
      *     pePrce   (input)   Prima RC Exterior                     *
      *     pePrap   (input)   Prima de AP                           *
      *     pePrim   (input)   Prima Total                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getPrimasAcumu...
     P                 B                   export
     D SPVVEH_getPrimasAcumu...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePrrc                      15  2
     D   pePrac                      15  2
     D   pePrin                      15  2
     D   pePrro                      15  2
     D   pePacc                      15  2
     D   pePraa                      15  2
     D   pePrsf                      15  2
     D   pePrce                      15  2
     D   pePrap                      15  2
     D   pePrim                      15  2

     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0

     D k1yet0          ds                  likeRec(p1het004:*Key)

      /free

       SPVVEH_inz();

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0poco = pePoco;
       setll %kds( k1yet0 : 7 ) pahet004;
       reade %kds( k1yet0 : 7 ) pahet004;

       dow not %eof ( pahet004 );
         pePrrc += t0Prrc;
         pePrac += t0Prac;
         pePrin += t0Prin;
         pePrro += t0Prro;
         pePacc += t0Pacc;
         pePraa += t0Praa;
         pePrsf += t0Prsf;
         pePrce += t0Prce;
         pePrap += t0Prap;

         if SPVSPO_getTipoOperacion( t0empr
                                   : t0sucu
                                   : t0arcd
                                   : t0spol
                                   : t0sspo
                                   : @@tiou
                                   : @@stou
                                   : @@stos );
           if ( @@tiou = 3 and @@stou = 11 and @@stos = 1 );
             leave;
           endif;
         endif;
         reade %kds( k1yet0 : 7 ) pahet004;

       enddo;

       pePrim = pePrrc
              + pePrac
              + pePrin
              + pePrro
              + pePacc
              + pePraa
              + pePrsf
              + pePrce
              + pePrap;

       return *On;

     P SPVVEH_getPrimasAcumu...
     P                 E

      * ---------------------------------------------------------------- *
      * SPVVEH_getLimitesRC(): obtener limites de cobertura RC           *
      *                                                                  *
      *     peTarc ( intput ) Tabla de RC                                *
      *     peMone ( intput ) Moneda                                     *
      *     peRcle ( output ) Rc Lesiones                                *
      *     peRcco ( output ) RC Cosas                                   *
      *     peRcac ( output ) RC Acontecimiento                          *
      *     peLrce ( output ) RC Exterior                                *
      *     peCtre ( intput ) Codigo de tarifa                           *
      *     peVhca ( intput ) Capitulo                                   *
      *     peVhv1 ( intput ) Variante RC                                *
      *     peMtdf ( intput ) Marca de Tarifa Diferencial                *
      *     peScta ( intput ) Zona                                       *
      *                                                                  *
      * Retona : *on = obtuvo / *off = no obtuvo                         *
      * ---------------------------------------------------------------- *
     P SPVVEH_getLimitesRC...
     P                 B                    export
     D SPVVEH_getLimitesRC...
     D                 pi              n
     D   peTarc                       2  0  const
     D   peMone                       2     const
     D   peRcle                      15  2
     D   peRcco                      15  2
     D   peRcac                      15  2
     D   peLrce                      15  2
     D   peCtre                       5  0  const
     D   peVhca                       2  0  const
     D   peVhv1                       1  0  const
     D   peMtdf                       1a    const
     D   peScta                       1  0  const

     D k1t227          ds                  likerec(s1t227:*key)
     D k1t2272         ds                  likerec(s1t2272:*key)

     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D peFemi          s              8  0

      /free

       SPVVEH_inz();

       peRcle = *Zeros;
       peRcco = *Zeros;
       peRcac = *Zeros;
       peLrce = *Zeros;

       k1t2272.t@tarc = peTarc;
       k1t2272.t@como = peMone;
       k1t2272.t@vhca = peVhca;
       k1t2272.t@vhv1 = peVhv1;

       // -------------------------------------
       // Límite RC Exterior sale de SET227
       // -------------------------------------
       k1t227.t@tarc = peTarc;
       k1t227.t@como = peMone;
       chain %kds(k1t227:2) set227;
       if %found;
          peLrce = t@lrce;
       endif;

       if peCtre >= 123;
          chain %kds(k1t2272) set2272;
          if %found;
             peLrce = t@lrce;
          endif;
       endif;

       // ---------------------------------------------------
       // Hay que tener en cuenta dos cosas para el
       // resto de los límites:
       // 1) Todas las que vendemos son CON LIMITE
       // 2) Por ahora los únicos USOS que se permiten son
       //    PARTICULAR y PARTICULAR/COMERCIAL
       // A futuro este procedimiento debería recibir qué
       // Cobertura y Uso tiene el vehículo para hacer un
       // cálculo posta de los límites de RC...
       // Otro tema a ver es Empresa/Sucursal...
       // ----------------------------------------------------
       PAR310X3( 'A' : peFema : peFemm : peFemd);
       peFemi = (peFema * 10000) + (peFemm * 100) + peFemd;
       peRcac = SVPLRC_getLimiteRC( 'A'
                                  : 'CA'
                                  : peFemi );

       return *on;

      /end-free

     P SPVVEH_getLimitesRC...
     P                 E

      * ---------------------------------------------------------------- *
      * SPVVEH_chkVigencia : Obtener limites de cobertura RC             *
      *                                                                  *
     *     Si no se envían fechas se toma la del día ( par310x3 )       *
      *                                                                  *
      *     peEmpr ( intput ) Empresa                                    *
      *     peSucu ( intput ) Sucursal                                   *
      *     peArcd ( intput ) Artículo                                   *
      *     peSpol ( intput ) Superpoliza                                *
      *     peRama ( intput ) Rama                                       *
      *     peArse ( intput ) Secuencia Articulo/rama                    *
      *     peOper ( intput ) Nro de operaion                            *
      *     pePoco ( intput ) Nro de componente                          *
      *     peVig2 ( intput ) Valida SPVVIG2? 1=Si / 0=No                *
      *     peSspo ( output ) Suplemento                                 *
      *     peSuop ( output ) Suplemento Operación                       *
      *     peFvig ( intput ) Fecha de Vigencia         (opcional)       *
      *     peFemi ( intput ) Fecha de emision          (opcional)       *
      *                                                                  *
      * Retorna: *on = Vigente / *off = No vigente                       *
      * ---------------------------------------------------------------- *
     P SPVVEH_chkVigencia...
     P                 B                    export
     D SPVVEH_chkVigencia...
     D                 pi              n
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  pePoco                        4  0 const
     D  peVig2                         n   const
     D  peSspo                        3  0 options(*nopass:*omit)
     D  peSuop                        3  0 options(*nopass:*omit)
     D  peFvig                        8  0 options(*nopass:*omit)
     D  peFemi                        8  0 options(*nopass:*omit)

     D @a              s              4  0
     D @m              s              2  0
     D @d              s              2  0
     D @@fhoy          s              8  0
     D @@femi          s              8  0
     D @@fvig          s              8  0
     D @@sspo          s              3  0
     D @@suop          s              3  0
     D @@endp          s              3
     D @@stat          s               n
     D @1stat          s               n
     D tmpfec          s               d   datfmt(*iso) inz

      /free

       SPVVEH_inz();

        PAR310X3( peEmpr  : @a : @m : @d );
        @@fhoy = (@a * 10000) + (@m * 100) + @d;

        if %parms >= 9 and %addr( peFvig ) <> *null;
           monitor;
             tmpfec = %date( %editc( peFvig : 'X' ) : *iso0 );
             @@fvig = peFvig;
           on-error;
              return *off;
           endmon;
        else;
           @@fvig = @@fhoy;
        endif;

        if %parms >= 9 and %addr( peFemi ) <> *null;
           monitor;
             tmpfec = %date( %editc( peFemi : 'X' ) : *iso0 );
             @@femi = peFemi;
           on-error;
              return *off;
           endmon;
        else;
           @@femi = @@fhoy;
        endif;

        @@stat = *off;
        clear @@sspo;
        clear @@suop;
        clear @@endp;
        in lda;
         if lda.empr = *blanks;
            lda.empr = empr;
            out lda;
         endif;

         if lda.sucu = *blanks;
            lda.sucu = sucu;
            out lda;
         endif;
        SPVIG3( peArcd
              : peSpol
              : peRama
              : peArse
              : peOper
              : pePoco
              : @@fvig
              : @@femi
              : @@stat
              : @@sspo
              : @@suop
              : @@endp
              : peVig2 );

          if %parms >= 9 and %addr( peSspo ) <> *null;
             peSspo = @@sspo;
          endif;

          if %parms >= 9 and %addr( peSuop ) <> *null;
             peSuop = @@suop;
          endif;

          @@endp = 'FIN';
          SPVIG3( peArcd
                : peSpol
                : peRama
                : peArse
                : peOper
                : pePoco
                : @@fvig
                : @@femi
                : @1stat
                : @@sspo
                : @@suop
                : @@endp
                : peVig2 );

          return @@stat;

      /end-free

     P SPVVEH_chkVigencia...
     P                 E

      * ------------------------------------------------------------ *
      * SPVVEH_getDescDecreciente(): Obtener descuento decreciente   *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Codigo de Rama                        *
      *     peTiou   (input)   Tipo de Operacion                     *
      *     peStou   (input)   Subtipo de Operacion                  *
      *     peFemi   (input)   Fecha de Emision                      *
      *     peNref   (input)   Numero de Refacturacion (0=Endoso 0)  *
      *     pePcbp   (output)  Porcentaje a usar                     *
      *                                                              *
      * Retorna: *On si debe aplicarse y *Off si no debe aplicarse   *
      * ------------------------------------------------------------ *
     P SPVVEH_getDescDecreciente...
     P                 b                   export
     D SPVVEH_getDescDecreciente...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peFemi                       8  0 const
     D   peNref                       2  0 const
     D   pePcbp                       5  2

     D k1t285          ds                  likerec(s1t285:*key)
     D @@secu          s              5  0
     D @@fech          s              8  0

      /free

       SPVVEH_inz();

       @@secu = 0;
       @@fech = 0;

       k1t285.t8_t@arcd = peArcd;
       k1t285.t8_t@tiou = peTiou;
       k1t285.t8_t@stou = peStou;
       setll %kds(k1t285:3) set285;
       reade %kds(k1t285:3) set285;
       dow not %eof;
           if t8_t@fech <= peFemi;
              @@secu = t8_t@secu;
              @@fech = t8_t@fech;
              leave;
           endif;
        reade %kds(k1t285:3) set285;
       enddo;

       if @@secu = 0 or @@fech = 0;
          return *off;
       endif;

       k1t285.t8_t@fech = @@fech;
       k1t285.t8_t@secu = @@secu;
       k1t285.t8_t@nref = peNref;
       chain %kds(k1t285:6) set285;
       if %found;
          pePcbp = t8_t@pcbp;
          if t8_t@pcbp <> 0;
             return *on;
          endif;
       endif;

       return *off;

      /end-free

     P SPVVEH_getDescDecreciente...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_chkLocalidadZona(): Valida Localidad vs Zona          *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   Sufijo de Codigo Postal               *
      *     peScta   (input)   Zona                                  *
      *                                                              *
      * Retorna: *On si OK y *OFF si falla.                          *
      * ------------------------------------------------------------ *
     P SPVVEH_chkLocalidadZona...
     P                 b                   Export
     D SPVVEH_chkLocalidadZona...
     D                 pi              n
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const

      /free

       SPVVEH_inz();

       chain (peCopo:peCops) gntloc;
       if not %found;
          SetError( SPVVEH_loczo
                  : 'Incongruencia entre CP y Zona');
          return *off;
       endif;

       if (loscta <> peScta);
          SetError( SPVVEH_loczo
                  : 'Incongruencia entre CP y Zona');
          return *off;
       endif;

       return *on;

      /end-free

     P SPVVEH_chkLocalidadZona...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getPahet02(): Retorna Registro de PAHET0              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componetne                            *
      *     peSspo   (input)   Suplemento                            *
      *     peDsT0   (Output)  Registro con PAHET0                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getPahet02...
     P                 B                   export
     D SPVVEH_getPahet02...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass)
     D   peDsT0                            likeds(dsPahet02_t)
     D                                     options(*nopass:*omit)

     D k1yet0          ds                  likeRec(p1het004:*Key)
     D k2het0          ds                  likeRec(p1het0:*Key)

     D dsEt0           ds                  likerec(p1het004:*input)
     D dsEt02          ds                  likerec(p1het0:*input)

       SPVVEH_inz();

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0poco = pePoco;

       if %parms >= 8 and %addr( peSspo ) <> *null;
         k1yet0.t0sspo = peSspo;
         chain %kds( k1yet0 : 8 ) pahet004 dsEt0;
       else;
         chain %kds( k1yet0 : 7 ) pahet004 dsEt0;
       endif;

       if %found;
          k2het0.t0empr = peEmpr;
          k2het0.t0sucu = peSucu;
          k2het0.t0arcd = peArcd;
          k2het0.t0spol = peSpol;
          k2het0.t0sspo = dsEt0.t0sspo;
          k2het0.t0rama = peRama;
          k2het0.t0arse = peArse;
          k2het0.t0oper = dsEt0.t0oper;
          k2het0.t0poco = pePoco;
          k2het0.t0suop = dsEt0.t0suop;
          chain(n) %kds(k2het0) pahet0 dsEt02;
          if %found;
             if %parms >= 9 and %addr( peDsT0 ) <> *null;
               eval-corr peDsT0 = dsEt02;
               return *On;
             endif;
          endif;
       endif;

       return *Off;


     P SPVVEH_getPahet02...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVVEH_setPahet02: Graba datos Prod.Art. Rama Automotores.   *
     ?*                                                              *
     ?*     peDst0   ( imput  ) Estr. Prod.Art. Rama Automotores.    *
     ?*                                                              *
     ?* Retorna: *on / *off                                          *
     ?* ------------------------------------------------------------ *
     P SPVVEH_setPahet02...
     P                 b                   export
     D SPVVEH_setPahet02...
     D                 pi              n
     D  peDst0                             likeds ( dspahet02_t )
     D                                     options( *nopass : *omit ) const

     D DsOet0          ds                  likerec( p1het0 : *output )
     D peSspo          s              3  0

      /Free

       SPVVEH_inz();

       peSspo = peDst0.t0Sspo;
       if SPVVEH_getPahet02( peDst0.t0Empr
                           : peDst0.t0Sucu
                           : peDst0.t0Arcd
                           : peDst0.t0Spol
                           : peDst0.t0Rama
                           : peDst0.t0Arse
                           : peDst0.t0Poco
                           : peSspo
                           : *omit         );
         return *off;
       endif;

       eval-corr DsOet0 = peDst0;
       monitor;
         write p1het0 DsOet0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SPVVEH_setPahet02...
     P                 e

      * ------------------------------------------------------------ *
      * SPVVEH_getUltimoEstadoComponente():                          *
      *                                                              *
      *     peEmpr   (input)   Cod. Empresa                          *
      *     peSucu   (input)   Cod. Sucursal                         *
      *     peArcd   (input)   Cod. Articulo                         *
      *     peSpol   (input)   Nro. Superpoliza                      *
      *     peRama   (input)   Cod. Rama                             *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Nro. Operacion                        *
      *     pePoco   (input)   Nro. Componente                       *
      *     peDsT0   (Output)  Registro con PAHET0                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVVEH_getUltimoEstadoComponente...
     P                 B                   export
     D SPVVEH_getUltimoEstadoComponente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peDsT0                            likeds( DsPahet002_t )

     D   k1yet0        ds                  likerec( p1het002 : *key   )
     D   @@DsIT0       ds                  likerec( p1het002 : *input )


       SPVVEH_inz();

       clear @@DsIT0;

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0oper = peOper;
       k1yet0.t0poco = pePoco;
       chain %kds( k1yet0 : 8 ) Pahet002 @@DsIT0;
       if not %found( Pahet002 );
          return *off;
       endif;

       eval-corr peDsT0  = @@DsIT0;

       return *on;


     P SPVVEH_getUltimoEstadoComponente...
     P                 E


