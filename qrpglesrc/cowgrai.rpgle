     H nomain
     H datedit(*DMY/)
     H alwnull(*usrctl)
     H option(*nodebugio : *srcstmt : *noshowcpy : *nounref)
      * ************************************************************ *
      * COWGRAI: Devolver datos Varios.                              *
      * ------------------------------------------------------------ *
      * Barranco Julio                       18-Ago-2015             *
      *------------------------------------------------------------- *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -                  <*           *
      *>           BNDDIR(HDIILE/HDIBDIR) -             <*           *
      *> TEXT('Prorama de Servicio: Trabajar Cotización') <*        *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWGRAI)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWGRAI)) <*         *
      *> IGN: DLTSPLF FILE(COWGRAI)                           <*     *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SGF 04/12/2015: Agrego _getFormaDePagoPdP().                 *
      * SGF 05/08/2016: Recompilo por ACRC en CTWET0/ER0.            *
      * SGF 06/08/2016: Recompilo por ASEN en CTW000.                *
      *                 Grabo ASEN en _saveCotizacion().             *
      * SFA 23/08/2016: _getNuevaCotizacion no estaba grabando       *
      *                 superPoliza a renovar                        *
      * SFA 25/08/2016: Agrego procedimiento _getSuperPolizaReno     *
      * SFA 31/08/2016: Agrego procedimiento _deleteImpuesto         *
      * SFA 01/09/2016: Modifico procedimiento _getPremioFinal       *
      * LRG 01/09/2016: Modifico procedimiento _deleteAccesorios     *
      * SGF 31/10/2016: Chanchada en _getXref(). Pero recién hoy se  *
      *                 dan cuenta que el sistema no lo puede calcu- *
      *                 lar automáticamente.                         *
      *                 Cuando se defina, se programa correctamente. *
      * LRG 25/11/2016: Agrego llamada a PRO401T para cálculo de IVA.*
      *                 COWGRAI_getMinimoRes3125()                   *
      *                 Modifico:                                    *
      *                 COWGRAI_getPremioFinal() se Agrega           *
      *                 COWGRAI_updTablaDeImpuestos()                *
      *                 COWGRAI_setSellados()                        *
      * LRG 15/12/2016: Se corrigen parámetros para la llamada del   *
      *                 PRO401S                                      *
      * LRG 25/01/2017: Se agrega nuevo procedimiento                *
      *                 COWGRAI_getCtw000, se obtienen todos los     *
      *                 datos de la Cabecera                         *
      *                 Se modifica la llamada al PRO401N - Sellados *
      *                 de Empresa( este debe usar el código de      *
      *                 provincia de la Empresa emisora HDI )        *
      * JSN 27/01/2017: Recompilo por cambio de formato en CTWEVC.   *
      * SGF 30/01/2017: Grabar Vigencia Desde/Hasta en updCotizacion *
      * LRG 06/02/2017: Se modifica calculo de comisión dentro del   *
      *                 procedimiento COWGRAI_getImpuestos, la       *
      *                 comisión se calcula de manera incorrecta.    *
      * LRG 07/02/2017: Se modifica Cálculo de Percepcion de IB e    *
      *                 IVA de percepción, solo debe utilizarse para *
      *                 Responsables Inscriptos                      *
      * LRG 09/02/2017: Nuevo Procedimiento: COWGRAI_deleteCompVida  *
      * SGF 18/03/2017: Cargar LDA porque la basura del 401T accede  *
      *                 a GNTEMP.                                    *
      * SGF 23/03/2017: Agrego todos los planes de pago en _getXRef()*
      * SGF 27/03/2017: Suma asegurada para calculo de impuestos en  *
      *                 Vida no se estaba mandando.                  *
      * LRG 27/03/2017: Nuev procedimiendo _getImpPrimaMinima        *
      * JSN 24/07/2017: Eliminar la cargar obligatoria del dato de   *
      *                 DNI en Persona Juridicas                     *
      * LRG 15/08/2017: Se recompila por cambios en CTW000:          *
      *                          º Número de Cotización API          *
      *                          º Nombre de Sistema Remoto          *
      *                          º CUIT del productor                *
      * LRG 19/09/2017: Nuevos procedimientos _setAuditoria          *
      *                                       _getAuditoria          *
      * LRG 03/07/2017: Nuevo  procedimiendo  _getPolizaxPopuesta    *
      * LRG 28/07/2017: Nuevos procedimientos _updCabecera           *
      *                                       _setNroCotizacionAPI   *
      * GIO 13/12/2017: Nuevo procedimiento _chkCotizacionApi        *
      * SGF 09/11/2017: Por fin!! Se corrige la chanchada de la PTF  *
      *                 del 31/10/2016: El recargo financiero va por *
      *                 plan de pagos y lo rescata DBA918R.          *
      *                 En updCabecera() si llegan grabo estado y    *
      *                 subestado.                                   *
      * JSN 02/05/2018: Nuevos procedimientos _chkRenovProcGuarEm    *
      *                                       _chkPlandePagoHabWeb   *
      * NWN 14/02/2019: Agregado de nueva validación por Tarjeta de  *
      *                 Crédito. Se valida primer digito contra      *
      *                 tabla GNTTC9.                                *
      * JSN 08/02/2019: Nuevos procedimientos _updEstado             *
      *                                       _updCtw000             *
      *                                       _setCtw000             *
      * JSN 26/02/2019: Nuevos procedimientos _vencerCotizacion      *
      *                                       _getCotizacionDeMoneda *
      *                                                              *
      * EXT 17/01/2019: Se recompila por cambios en CTWET0           *
      * JSN 27/05/2019: Nuevos procedimientos _setFlota              *
      *                                       _isFLota               *
      * NWN 20/05/2019: Agregado de Derecho de emisión en SPEXCODE.  *
      * LRG 25/06/2019: se adiciona calculo de comision nivel 6      *
      *                 nuevos procedimientos:                       *
      *                 _getVacc                                     *
      *                 _setExtraComision                            *
      *                 Modificación de procedimiento:               *
      *                 _setDerechoEmi : guardar vacc en ctw001      *
      * JSN 29/08/2019: Nuevo procedimiento _deletePocoScoring() y se*
      *                 agrega llamado en _deletePoco                *
      * LRG 10/10/2019: Nuevo Procedimiento                          *
      *                         _getDatosCapituloRGV                 *
      *                 Depreca _getDatosCapituloHogar               *
      *                         _getEstadoCotizacion                 *
      *                         _getNroPropuesta                     *
      *                         _setNroPropuesta                     *
      *                         _chkCotizacionEnviada                *
      *                         _chkCotizacionVencida                *
      *                         _chkTieneAseguradoPrincipal          *
      *                         _chktodasLasRamasCotizadas           *
      * SGF 21/04/2020: Agrego CTWSEP y CTWSE1.                      *
      *                 Nuevo prc _getCtwEg3.                        *
      * JSN 01/07/2020: Se agrega proedimiento _getPendientes        *
      * SGF 16/04/2021: Prima Minima de AP va a 500.                 *
      *                 En algun momento hay que pasar esto a tabla. *
      * JSN 09/08/2021: Se modifica el procedimiento _updImpConcComer*
      * JSN 06/05/2021: Se agregan los procedimientos:               *
      *                 _getPremio                                   *
      *                 _getCliente                                  *
      *                 _setRelacion                                 *
      *                 _chkRelacionAP                               *
      *                 _chkRelacionRC                               *
      *                 _getNroCotiXSpol                             *
      *     22/06/2021: Se modifica el procedimiento                 *
      *                 _getPolizasDeSuperpoliza                     *
      * JSN 21/01/2022: Se agrega el procedimiento :                 *
      *                 _getNroCotiAPRC                              *
      * ************************************************************ *
     Fset915    uf a e           k disk    usropn
     Fctw000    uf a e           k disk    usropn
     Fctw00015  if   e           k disk    usropn rename(c1w000 : c1w00015)
     Fctw001    uf a e           k disk    usropn
     Fctw001c   uf a e           k disk    usropn
     Fctw002    uf a e           k disk    usropn
     Fctw003    uf a e           k disk    usropn
     Fctw004    uf a e           k disk    usropn
     Fctwer0    uf a e           k disk    usropn
     Fctwer1    uf a e           k disk    usropn
     Fctwer001  if   e           k disk    usropn rename (c1wer0:c1werx)
     Fctwet0    uf a e           k disk    usropn
     Fctwet001  if   e           k disk    usropn rename (c1wet0:c1wetx)
     Fctwet4    uf a e           k disk    usropn
     Fctwetc    uf a e           k disk    usropn
     Fctwetc01  if   e           k disk    usropn rename(c1wetc:c1wetc01)
     Fctwer2    uf a e           k disk    usropn
     Fctwer4    uf a e           k disk    usropn
     Fctwer6    uf a e           k disk    usropn
     Fctwev1    uf a e           k disk    usropn rename( c1wev1 : c1wev1x )
     Fctwev101  uf a e           k disk    usropn
     Fctwev2    uf a e           k disk    usropn
     Fctwevc    uf a e           k disk    usropn
     Fctwse1    uf a e           k disk    usropn
     Fctwtim    uf a e           k disk    usropn
     Fpahed0    uf a e           k disk    usropn
     Fset611    if   e           k disk    usropn prefix( t1 : 2 )
     Fset6118   if   e           k disk    usropn prefix( t2 : 2 )
     Fset620    if   e           k disk    usropn prefix( t6 : 2 )
     Fset621    if   e           k disk    usropn prefix( t3 : 2 )
     Fset630    if   e           k disk    usropn prefix( t4 : 2 )
     Fset638    if   e           k disk    usropn
     Fset699    if   e           k disk    usropn prefix( t7 : 2 )
     Fset100    if   e           k disk    usropn prefix( t9 : 2 )
     Fset122    if   e           k disk    usropn
     Fset123    if   e           k disk    usropn prefix( t5 : 2 )
     Fgntloc    if   e           k disk    usropn
     Fgntpro    if   e           k disk    usropn
     Fgntcmo    if   e           k disk    usropn
     Fset121    if   e           k disk    usropn
     Fctweg3    uf a e           k disk    usropn
     Fset250    if   e           k disk    usropn
     Fctwet1    uf a e           k disk    usropn
     Fset207    if   e           k disk    usropn
     Fset6303   if   e           k disk    usropn
     Fsehni2    if   e           k disk    usropn
     Fset101    if   e           k disk    usropn prefix( s1 : 2 )
     Fset102    if   e           k disk    usropn prefix( s2 : 2 )
     Fset60802  if   e           k disk    usropn prefix( t8 : 2 )
     Fset021    if   e           k disk    usropn
     Fgntfpg    if   e           k disk    usropn
     Fgnttc1    if   e           k disk    usropn prefix(tc:2)
     Fctw00017  if   e           k disk    usropn rename(c1w000 : c1w00017)
     Fpahec3    if   e           k disk    usropn
     Fgnttc9    if   e           k disk    usropn
     Fctw00003  if   e           k disk    usropn  rename(c1w000:c1w00003)
     Fctw099    uf a e           k disk    usropn
     Fctw09901  if   e           k disk    usropn  rename(c1w099:c1w09901)
     Fctw09902  if   e           k disk    usropn  rename(c1w099:c1w09902)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'

     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

      * --------------------------------------------------- *
      * Validación de Nro de CUIT
      * --------------------------------------------------- *
     Dpro401s          pr                  extpgm('PRO401S')
     D                                2  0 const
     D                                2  0 const
     D                                2    const
     D                               15  6 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                                9  6 options(*nopass)
     D                                9  6 options(*nopass)
     D                                2  0 options(*nopass)
     D                               15  2 options(*nopass)

     Dpro401n          pr                  extpgm('PRO401N')
     D                                2  0 const
     D                                2  0 const
     D                                2    const
     D                               15  6 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                                9  6 options(*nopass)
     D                                9  6 options(*nopass)
     D                                2  0 options(*nopass)
     D                               15  2 options(*nopass)

     Dpro401m          pr                  extpgm('PRO401M')
     D                                2  0 const
     D                                2  0 const
     D                                1    const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2

     Dpro401o          pr                  extpgm('PRO401O')
     D                                2  0 const
     D                                2  0 const
     D                                2    const
     D                               15  6 const
     D                               15  2 const
     D                               15  2 const
     D                                7  0 const
     D                                2  0 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                                9  6 const
     D                               15  2 const
     D                               11    options(*nopass)
      *
     Dpro401t          pr                  extpgm('PRO401T')
     D                               15  6 const
     D                                2  0 const
     D                                1    const
     D                               15  2 const
     D                               15  2 const
     D                                5  2 const
     D                                5  2 const
     D                                5  2 const
     D                               15  2
     D                               15  2
     D                               15  2

     D SPCADCOM        pr                  extpgm('SPCADCOM')
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1  0
     D  nivc                          5  0
     D  cade                          5  0 dim(9)
     D  erro                           n
     D  endp                          3a
     D  nrdf                          7  0 dim(9) options(*nopass)

     Dspexcode         pr                  extpgm('SPEXCODE')
     D                                1a
     D                                2a
     D                                1  0
     D                                5  0
     D                                2  0
     D                                1  0
     D                                2  0
     D                                8  0
     D                                3a
     D                                 n
     D                               15  2
     D                                1a
     D                                1a
     D                                5  0
     D                               15  2

     D getDescPago     pr            20a
     D  peCfpg                        1  0 const

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)

     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     Is1t638
     I              t@date                      tydate
      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * COWGRAI_getNroCotizacion() Devuelve el numero de cotización. *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getNroCotizacion...
     P                 B                   export
     D COWGRAI_getNroCotizacion...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

     D k1y915          ds                  likerec(s1t915:*key)
     D nrocot          s              7  0

     D
      /free

       COWGRAI_inz();

       k1y915.t@empr = peEmpr;
       k1y915.t@sucu = peSucu;
       k1y915.t@tnum = 'NC';

       chain %kds( k1y915 : 3 ) set915;
       if %found( set915 );

         //si llego al tope no sigo sumando y retorno ese valor para
         //dar el error.

         if t@nres = 9999999;
           return 0;
         endif;

         t@nres += 1;
         t@user  = @PsDs.CurUsr;
         t@date  = %dec(%date);
         t@time  = %dec(%time);
         update s1t915;

        else;

         t@empr  = peEmpr;
         t@sucu  = peSucu;
         t@tnum  = 'NC';
         t@nres  = 1;
         t@user  = @PsDs.CurUsr;
         t@date  = %dec(%date);
         t@time  = %dec(%time);
         write  s1t915;

       endif;

       return t@nres;

      /end-free

     P COWGRAI_getNroCotizacion...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_chkCotizacion() Verifica el número de cotización.    *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_chkCotizacion...
     P                 B                   export
     D COWGRAI_chkCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       setll %kds( k1y000 : 5 ) ctw000;
       if not %equal( ctw000 );

         SetError( COWGRAI_COTNP
                 : 'Cotización no pertenece a Productor' );
         return *Off;

       endif;

       return *on;

      /end-free

     P COWGRAI_chkCotizacion...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCabecera() Elimina cotización del CTW000.      *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_deleteCabecera...
     P                 B                   export
     D COWGRAI_deleteCabecera...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         delete c1w000;

         return *on;

       endif;

       return *off;

      /end-free

     P COWGRAI_deleteCabecera...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteAsegurados() Elimina asegurados del CTW003.    *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_deleteAsegurados...
     P                 B                   export
     D COWGRAI_deleteAsegurados...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y003          ds                  likerec(c1w003:*key)

     D
      /free

       COWGRAI_inz();

       k1y003.w3empr = PeBase.peEmpr;
       k1y003.w3sucu = PeBase.peSucu;
       k1y003.w3nivt = PeBase.peNivt;
       k1y003.w3nivc = PeBase.peNivc;
       k1y003.w3nctw = peNctw;

       setll %kds( k1y003 : 5 ) ctw003;
       reade %kds( k1y003 : 5 ) ctw003;
       dow not %eof;

         delete c1w003;

         reade %kds( k1y003 : 5 ) ctw003;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteAsegurados...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_deleteAseguradosMails(): Elimina asegurados del CTW004*
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *                                                               *
      * ------------------------------------------------------------- *

     P COWGRAI_deleteAseguradosMails...
     P                 B                   export
     D COWGRAI_deleteAseguradosMails...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y004          ds                  likerec(c1w004:*key)

     D
      /free

       COWGRAI_inz();

       k1y004.w4empr = PeBase.peEmpr;
       k1y004.w4sucu = PeBase.peSucu;
       k1y004.w4nivt = PeBase.peNivt;
       k1y004.w4nivc = PeBase.peNivc;
       k1y004.w4nctw = peNctw;

       setll %kds( k1y004 : 5 ) ctw004;
       reade %kds( k1y004 : 5 ) ctw004;
       dow not %eof;

         delete c1w004;

         reade %kds( k1y004 : 5 ) ctw004;
       enddo;

       return *off;

      /end-free

     P COWGRAI_deleteAseguradosMails...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_getNuevaCotizacion(): Crear registro de cotización    *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peArcd   (input)   Código de Artículo                     *
      *     peMone   (input)   Código de Moneda                       *
      *     peTiou   (input)   Tipo de Operación                      *
      *     peStou   (input)   SubTipo de Operación de Usuario        *
      *     peStos   (input)   SubTipo de Operación de Sistema        *
      *     peSpo1   (input)   SuperPoliza Relacionada                *
      *     peNctw   (output)  Número de Cotización                   *
      *     peErro   (output)  Indicador de Error                     *
      *     peMsgs   (output)  Estructura de Error                    *
      *                                                               *
      * ------------------------------------------------------------- *

     P COWGRAI_getNuevaCotizacion...
     P                 B                   export
     D COWGRAI_getNuevaCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peMone                       2      const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
     D   peSpo1                       7  0   const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)

     D @@empr          s              1a
     D @@sucu          s              2a
     D @@nivt          s              1  0
     D @@nivc          s              5  0
     D @@cade          s              5  0 dim(9)
     D @@erro          s              1n
     D @@dife          s              1n
     D @@finp          s              3a

     D wrepl           s          65535a

      /free

       COWGRAI_inz();

       //Valido ParmBase

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return *off;

       endif;

       //Valido que el nivel del productor sea 1
       if SVPVAL_nivelProductor( peBase.peNivt ) = *off;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0087'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return *off;

       endif;

       //Valido relacion actual
       if ( peBase.peNivt <> peBase.peNit1 );

         @@empr = peBase.peEmpr;
         @@sucu = peBase.peSucu;
         @@nivt = peBase.peNivt;
         @@nivc = peBase.peNivc;
         @@finp = *Blanks;

         SPCADCOM ( @@empr
                  : @@sucu
                  : @@nivt
                  : @@nivc
                  : @@cade
                  : @@erro
                  : @@finp );

         @@dife = *Off;

         select;
           when ( peBase.peNit1 = 1 );
             if ( peBase.peNiv1 <> @@cade( 1 ) );
               @@dife = *On;
             endif;
           when ( peBase.peNit1 = 2 );
             if ( peBase.peNiv1 <> @@cade( 2 ) );
               @@dife = *On;
             endif;
           when ( peBase.peNit1 = 3 );
             if ( peBase.peNiv1 <> @@cade( 3 ) );
               @@dife = *On;
             endif;
           when ( peBase.peNit1 = 4 );
             if ( peBase.peNiv1 <> @@cade( 4 ) );
               @@dife = *On;
             endif;
           when ( peBase.peNit1 = 5 );
             if ( peBase.peNiv1 <> @@cade( 5 ) );
               @@dife = *On;
             endif;
           when ( peBase.peNit1 = 6 );
             if ( peBase.peNiv1 <> @@cade( 6 ) );
               @@dife = *On;
             endif;
           when ( peBase.peNit1 = 7 );
             if ( peBase.peNiv1 <> @@cade( 7 ) );
               @@dife = *On;
             endif;
           when ( peBase.peNit1 = 8 );
             if ( peBase.peNiv1 <> @@cade( 8 ) );
               @@dife = *On;
             endif;
         endsl;

         if @@dife;

           wrepl = %char ( @@nivt ) + %char ( @@nivc )
                 + %char ( peBase.peNit1 ) + %char( peBase.peNiv1 );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0116'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return *off;

         endif;

       endif;

       //Valido tipo de operación.

       if SVPVAL_tipoDeOperacion ( peTiou : peStou : peStos ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_TOPNE = ErrCode;

           %subst(wrepl:1:1) = %editc( peTiou :'X');
           %subst(wrepl:3:4) = %editc( peStou :'X');
           %subst(wrepl:6:7) = %editc( peStos :'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0006'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;


       //Valido tipo de operación Web.

       if SVPVAL_tipoDeOperacionWeb ( peTiou : peStou : peStos ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_TOPNW = ErrCode;

           %subst(wrepl:1:1) = %editc( peTiou :'X');
           %subst(wrepl:3:4) = %editc( peStou :'X');
           %subst(wrepl:6:7) = %editc( peStos :'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0007'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;

       //Valido bloqueo del productor
       if COWGRAI_bloqueoProd ( peBase : peTiou ) = *off;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0105'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return *off;

       endif;

       //Valido artículo y si esta bloqueado

       if SVPVAL_articulo ( peArcd ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_ARTNE = ErrCode;

           %subst(wrepl:1:6) = %editc( peArcd :'X');
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0000'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_ARTBL = ErrCode;

           %subst(wrepl:1:6) = %editc( peArcd :'X');
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0001'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;

       //Valido artículo web

       if SVPVAL_articuloWeb ( peArcd ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_ARTNW = ErrCode;

           %subst(wrepl:1:6) = %editc( peArcd :'X');
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0002'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;

       //Valido si existe moneda o si esta bloqueada

       if SVPVAL_moneda ( peMone ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_MONNE = ErrCode;

           %subst(wrepl:1:2) = peMone;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_MONBL = ErrCode;

           %subst(wrepl:1:2) = peMone;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0004'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;

       //Valido moneda para la Web.

       if SVPVAL_monedaWeb ( peMone ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_MONNW = ErrCode;

           %subst(wrepl:1:2) = peMone;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0005'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;


       //Valido SuperPoliza.

       if SVPVAL_spolRenovacion ( PeBase.peEmpr :
                                  PeBase.peSucu :
                                  peArcd :
                                  peSpo1 :
                                  peTiou :
                                  peStou ) = *off;


         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_SPOCE = ErrCode;

           %subst(wrepl:1:6) = %editc( peArcd :'X');
           %subst(wrepl:8:9) = %editc( peSpo1 :'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0016'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_SPONE = ErrCode;

           %subst(wrepl:1:6) = %editc( peArcd :'X');
           %subst(wrepl:8:9) = %editc( peSpo1 :'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0017'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;

       clear c1w000;

       peNctw = COWGRAI_getNroCotizacion(PeBase.peEmpr:
                                         PeBase.peSucu);
       if peNctw = 0;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0103'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return *off;

       endif;

       if peNctw <> 0;

         w0empr = PeBase.peEmpr;
         w0sucu = PeBase.peSucu;
         w0nivt = PeBase.peNivt;
         w0nivc = PeBase.peNivc;
         w0nit1 = PeBase.peNit1;
         w0niv1 = PeBase.peNiv1;
         w0fctw = %dec(%date);
         w0mone = peMone;
         w0noml = SVPDES_moneda(peMone);
         w0come = COWGRAI_cotizaMoneda(peMone:
                                       w0fctw);
         w0arcd = peArcd;
         w0arno = SVPDES_articulo(peArcd);
         w0tiou = peTiou;
         w0stou = peStou;
         w0stos = peStos;
         w0dsop = SVPDES_tipoDeOperacion(peTiou:
                                         peStou:
                                         peStos);
         w0cest = 1;
         w0cses = 1;
         w0dest = SVPDES_estadoCot(w0cest:
                                   w0cses);
         w0nctw = peNctw;

         w0spol = *Zeros;
         w0spo1 = peSpo1;

         write c1w000;
         return *on;

       endif;

       return *off;

      /end-free

     P COWGRAI_getNuevaCotizacion...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_deleteCotizacion(): Elimina cotización.               *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peErro   (output)  Indicador de Error                     *
      *     peMsgs   (output)  Estructura de Error                    *
      *                                                               *
      * ------------------------------------------------------------- *

     P COWGRAI_deleteCotizacion...
     P                 B                   export
     D COWGRAI_deleteCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1yer0          ds                  likerec(c1wer0:*key)
     D k1yet0          ds                  likerec(c1wet0:*key)
     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       //Valido ParmBase

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return *off;

       endif;

       //Valido Cotizacion

       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %trim(%char(peNctw));
           %subst(wrepl:8:1) = %char(peBase.peNivt);
           %subst(wrepl:9:5) = %trim(%char(peBase.peNivc));

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
         endif;

         return *off;

       endif;

       //Valido si puedo borrar o no.

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         if ( w0cest = 1 ) and ( w0cses = 1 );

           %subst(wrepl:1:7) = %trim(%char(peNctw));
           %subst(wrepl:8:1) = %char(peBase.peNivt);
           %subst(wrepl:9:5) = %trim(%char(peBase.peNivc));

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


           peErro = -1;
           return *off;

         endif;

       endif;

       COWGRAI_deleteAsegurados( peBase : peNctw );

       COWGRAI_deleteAseguradosMails( peBase : peNctw );

       k1yer0.r0empr = PeBase.peEmpr;
       k1yer0.r0sucu = PeBase.peSucu;
       k1yer0.r0nivt = PeBase.peNivt;
       k1yer0.r0nivc = PeBase.peNivc;
       k1yer0.r0nctw = peNctw;

       setll %kds( k1yer0 : 5 ) ctwer0;
       reade %kds( k1yer0 : 5 ) ctwer0;
       dow not %eof;

         COWGRAI_deletePoco ( peBase : peNctw : t0rama : t0arse : t0poco );

         reade %kds( k1yer0 : 5 ) ctwer0;
       enddo;

       k1yet0.t0empr = PeBase.peEmpr;
       k1yet0.t0sucu = PeBase.peSucu;
       k1yet0.t0nivt = PeBase.peNivt;
       k1yet0.t0nivc = PeBase.peNivc;
       k1yet0.t0nctw = peNctw;

       setll %kds( k1yet0 : 5 ) ctwet0;
       reade %kds( k1yet0 : 5 ) ctwet0;
       dow not %eof;

         COWGRAI_deletePoco ( peBase : peNctw : t0rama : t0arse : t0poco );

         reade %kds( k1yet0 : 5 ) ctwet0;
       enddo;

       COWGRAI_deleteImportes ( peBase : peNctw );

       COWGRAI_deleteImpuestos ( peBase : peNctw );

       COWGRAI_delCondComerciales( peBase : peNctw );

       return *on;

      /end-free

     P COWGRAI_deleteCotizacion...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_saveCotizacion(): Actualizar registro de cotización   *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peAsen   (input)   Código de Cliente (será 0 si es nuevo) *
      *     peNomb   (input)   Nombre del Cliente                     *
      *     peCiva   (input)   Código de Iva                          *
      *     peTipe   (input)   Tipo de Persona                        *
      *     peCopo   (input)   Código Postal                          *
      *     peCops   (input)   Sufijo Código Postal                   *
      *     peErro   (output)  Indicador de Error                     *
      *     peMsgs   (output)  Estructura de Error                    *
      *                                                               *
      * ------------------------------------------------------------- *
     P COWGRAI_saveCotizacion...
     P                 B                   export
     D COWGRAI_saveCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40      const
     D   peCiva                       2  0   const
     D   peTipe                       1      const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCuit                      11a     const
     D   peTido                       1  0   const
     D   peNrdo                       8  0   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D k1w003          ds                  likerec(c1w003:*key)

      /free

       COWGRAI_inz();

       //Valido ParmBase

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return *off;

       endif;

       //Valido Cotización

       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %trim(%char(peNctw));
           %subst(wrepl:8:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:9:5) = %trim(%char(peBase.peNivc));

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         peErro = -1;
         endif;

         return *off;

       endif;

       //Valido Nombre del cliente

       if SVPVAL_nombreCliente( peNomb ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_NOMBL = ErrCode;

           %subst(wrepl:1:2) = ' ';

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0009'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         endif;

         peErro = -1;
         return *off;

       endif;

       //Valido código de Iva y si esta bloqueado.

       if SVPVAL_iva ( peCiva ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_IVANE = ErrCode;

           %subst(wrepl:1:1) = %editc(peCiva:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_IVABL = ErrCode;

           %subst(wrepl:1:1) = %editc(peCiva:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0011'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return *off;

       endif;


       //Valido código de Iva Web.

       if SVPVAL_ivaWeb ( peCiva ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_IVANW = ErrCode;

           %subst(wrepl:1:1) = %editc(peCiva:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0012'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return *off;

       endif;


       //Valido código Postal.

       if SVPVAL_codigoPostal ( peCopo : peCops ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_COPNE = ErrCode;

           %subst(wrepl:1:5) = %editc(peCopo:'X');
           %subst(wrepl:6:1) = %editc(peCops:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0013'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
         endif;

         return *off;

       endif;

       //Valido código Postal para web.

       if SVPVAL_codigoPostalWeb ( peCopo : peCops ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_COPNW = ErrCode;

           %subst(wrepl:1:5) = %editc(peCopo:'X');
           %subst(wrepl:6:1) = %editc(peCops:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0014'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return *off;

       endif;

       //Valido tipo de persona.

       if SVPVAL_tipoPersona ( peTipe ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_TPENV = ErrCode;

           %subst(wrepl:1:1) = peTipe;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0015'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
         endif;

         return *off;

       endif;

       //Si todo bien actualizo.

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         w0nomb = peNomb;
         w0civa = peCiva;
         w0ncil = SVPDES_codigoIva ( peCiva );
         w0tipe = peTipe;
         w0copo = peCopo;
         w0cops = peCops;
         w0loca = SVPDES_localidad ( peCopo : peCops );
         w0cses = 2;
         w0asen = peAsen;

         update c1w000;

         k1w003.w3empr = peBase.peEmpr;
         k1w003.w3sucu = peBase.peSucu;
         k1w003.w3nivt = peBase.peNivt;
         k1w003.w3nivc = peBase.peNivc;
         k1w003.w3nctw = peNctw;
         k1w003.w3nase = 0;
         chain %kds(k1w003:6) ctw003;
         if %found;
            w3nomb = peNomb;
            w3tido = peTido;
            w3nrdo = peNrdo;
            w3cuit = peCuit;
            update c1w003;
          else;
            w3empr = peBase.peEmpr;
            w3sucu = peBase.peSucu;
            w3nivt = peBase.peNivt;
            w3nivc = peBase.peNivc;
            w3nctw = peNctw;
            w3nase = 0;
            w3nomb = peNomb;
            w3tido = peTido;
            w3nrdo = peNrdo;
            w3cuit = peCuit;
            write c1w003;
         endif;

         return *on;

       endif;

       return *off;

      /end-free

     P COWGRAI_saveCotizacion...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_deleteBienAsegurado(): Elimina bien asegurado.        *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peRama   (input)   Código de Rama                         *
      *     peArse   (input)   Cant. Pólizas por Rama                 *
      *     pePoco   (input)   Número de Bien Asegurado               *
      *     peErro   (output)  Indicador de Error                     *
      *     peMsgs   (output)  Mensaje de Error                       *
      *                                                               *
      * ------------------------------------------------------------- *

     P COWGRAI_deleteBienAsegurado...
     P                 B                   export
     D COWGRAI_deleteBienAsegurado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y004          ds                  likerec(c1w004:*key)

     D
      /free

       COWGRAI_inz();

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return *off;

       endif;

       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %trim(%char(peNctw));
           %subst(wrepl:8:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:9:5) = %trim(%char(peBase.peNivc));

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;

       if chkDeleteBienAsegurado ( peBase : peNctw ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_CTWNT = ErrCode;

           %subst(wrepl:1:7) = %editc(peNctw:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0018'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;

         return *off;

       endif;

       COWGRAI_deletePoco( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco );

       COWGRAI_getPremioFinal ( peBase : peNctw );

       return *on;

      /end-free

     P COWGRAI_deleteBienAsegurado...
     P                 E
      * -----------------------------------------------------------------*
      * COWGRAI_getPolizasDeSuperpoliza (): Obtiene el listado de polizas*
      *                                     de una superpoliza.          *
      *                                                                  *
      *     peBase   (input)   Parametro Base                            *
      *     peArcd   (input)   Número de Artículo                        *
      *     peSpol   (input)   SuperPoliza                               *
      *     pePoli   (Output)  Pólizas                                   *
      *     peErro   (output)  Indicador de Error                        *
      *     peMsgs   (output)  Mensaje de Error                          *
      *     pePoliC  (output)  Cantidad dePolizas ( opcional )           *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_getPolizasDeSuperpoliza...
     P                 B                   export
     D COWGRAI_getPolizasDeSuperpoliza...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoli                            likeds(spolizas) Dim(100)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   pePoliC                     10i 0 options( *omit : *nopass )

     D k1yed0          ds                  likerec(p1hed0:*key)
     D x               s              3  0

     D
      /free

       COWGRAI_inz();

       if SPVSPO_chkSpol ( PeBase.peEmpr:
                           PeBase.peSucu:
                           peArcd:
                           peSpol ) = *off;

         ErrText = SPVSPO_error(ErrCode);

         %subst(wrepl:1:6) = %editc(peArcd:'X');
         %subst(wrepl:8:9) = %editc(peSpol:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0017'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return *off;

       endif;

       x = 0;
       k1yed0.d0empr = PeBase.peEmpr;
       k1yed0.d0sucu = PeBase.peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       setll %kds( k1yed0 : 4 ) pahed0;
       reade %kds( k1yed0 : 4 ) pahed0;
       dow not %eof(pahed0);

           x += 1;
           pePoli(x).rama = d0rama;
           pePoli(x).poliza = d0poli;

         reade %kds( k1yed0 : 4 ) pahed0;
       enddo;

       if x > 0;
         if %parms >= 7 and %addr( pePoliC ) <> *Null;
           pePoliC = x;
         endif;
         return *on;
       else;
         peErro = -1;
         return *off;
       endif;

      /end-free

     P COWGRAI_getPolizasDeSuperpoliza...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_personaIsValid(): Validar si la persona es valida para*
      *                           emitir.                             *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peTipe   (input)   Tipo de Persona                        *
      *     peTido   (input)   Código Tipo Documento                  *
      *     peNrdo   (input)   Número de Documento                    *
      *     peCuit   (input)   CUIT                                   *
      *     peCuil   (input)   CUIL                                   *
      *     peErro   (output)  Indicador de Error                     *
      *     peMsgs   (output)  Mensaje de Error                       *
      *                                                               *
      * ------------------------------------------------------------- *

     P COWGRAI_personaIsValid...
     P                 B                   export
     D COWGRAI_personaIsValid...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTipe                       1    const
     D   peTido                       2  0 const
     D   peNrdo                       9  0 const
     D   peCuit                      11  0 const
     D   peCuil                      11  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D
     D   p@cuit        s             14

      /free

       COWGRAI_inz();

       //Valido ParmBase

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
         peErro = -1;
         return *off;
       endif;

       //Valido Nro de Cotización.

       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;
         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %trim(%char(peNctw));
           %subst(wrepl:8:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:9:5) = %trim(%char(peBase.peNivc));

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
         endif;

         return *off;
       endif;

       //Validar el tipo de persona.

       if peTipe <> ' ';

         if SVPVAL_tipoPersona ( peTipe ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_TPENV = ErrCode;

             %subst(wrepl:1:1) = peTipe;

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0015'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
           endif;

           return *off;

         endif;

       endif;

       //Validar que vengan ambos datos

       if peTido <> 0 and peNrdo = 0 and peTipe = 'F';
          %subst(wrepl:1:1) = %editc( peTido : 'X' );
          SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0005'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         peErro = -1;
         return *off;
       endif;

       if peTido = 0 and peNrdo <> 0 and peTipe = 'F';
          %subst(wrepl:1:1) = %editc( peTido : 'X' );
          SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0004'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         peErro = -1;
         return *off;
       endif;

       //Valido tipo de documento
       if peTido <> 0;
         if SVPVAL_tipoDeDocumento ( peTido ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_TDONE = ErrCode;

             %subst(wrepl:1:2) = %editc( peTido : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0004'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             peErro = -1;
           endif;

           return *off;

         endif;

       endif;

       //Valido Documento
       if peTido <> 0 and peNrdo <> 0;

         if SVPVAL_chkBlkDocumento ( peBase :
                                     peNctw :
                                     peTido :
                                     peNrdo ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_ASBLK = ErrCode;

             %subst(wrepl:1:2) = %editc( peTido : 'X' );
             %subst(wrepl:4:9) = %editc( peNrdo : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0033'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
            peErro = -1;
           endif;

           return *off;

         endif;

       endif;

       //Valido Nro de Cuit
       if peCuit <> 0;

         EvalR p@cuit = %editc( peCuit : 'Z' );
         if SVPVAL_CuitCuil ( p@cuit ) = *off;

            %subst(wrepl:1:11) = %editc( peCuit : 'X' );

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PRW0008'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peErro = -1;
            return *off;

         endif;

         if SVPVAL_chkBlkCuit ( peBase :
                                peNctw :
                                PeCuit ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_ASBLK = ErrCode;

             %subst(wrepl:1:11) = %editc( peCuit : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0007'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
            peErro = -1;
           endif;

           return *off;

         endif;

       endif;

       //Valido Nro de Cuil
       if peCuil <> 0;

         EvalR p@cuit = %editc( peCuil : 'Z' );
         if SVPVAL_CuitCuil ( p@cuit ) = *off;

           %subst(wrepl:1:11) = %editc( peCuil : 'X' );
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0009'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return *off;

         endif;

         if SVPVAL_chkBlkCuit ( peBase :
                                peNctw :
                                PeCuil ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_ASBLK = ErrCode;

             %subst(wrepl:1:11) = %editc( peCuil : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0009'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
           endif;

           peErro = -1;
           return *off;

         endif;
       endif;

       // Si no se envió ningun dato...
       if peNrdo = 0 and
          peCuil = 0 and
          peCuit = 0;

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0041'
                          : peMsgs     );

         peErro = -1;
         return *off;
       endif;
       return *on;

      /end-free

     P COWGRAI_personaIsValid...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_monedaCotizacion(): Devuelve la moneda de la cotiza- *
      *                             ción                             *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_monedaCotizacion...
     P                 B                   export
     D COWGRAI_monedaCotizacion...
     D                 pi             2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         return w0mone;

       endif;

       return *off;

      /end-free

     P COWGRAI_monedaCotizacion...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_chkComponente():Valida que el componete no se repita     *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Número de Componente                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWGRAI_chkComponente...
     P                 B                   export
     D COWGRAI_chkComponente...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const

     D K1yet0          ds                  likerec(c1wet0:*key)
     D K1yer0          ds                  likerec(c1wer0:*key)
     D K1yev1          ds                  likerec(c1wev1x:*key)

      /free

       COWGRAI_inz();

       if SVPWS_getGrupoRama ( peRama ) = 'A' ;

         k1yet0.t0empr = PeBase.peEmpr;
         k1yet0.t0sucu = PeBase.peSucu;
         k1yet0.t0nivt = PeBase.peNivt;
         k1yet0.t0nivc = PeBase.peNivc;
         k1yet0.t0nctw = peNctw;
         k1yet0.t0rama = peRama;
         k1yet0.t0poco = pePoco;
         k1yet0.t0arse = peArse;

         setll %kds( k1yet0 : 8 ) ctwet0;
         if %equal ( ctwet0 );

           SetError( COWGRAI_POCOEX
                   : 'Número de Componente ya Existe' );
           return *Off;

         endif;

       elseif SVPWS_getGrupoRama ( peRama ) = 'H'  or
              SVPWS_getGrupoRama ( peRama ) = 'X'  or
              SVPWS_getGrupoRama ( peRama ) = 'Y'  or
              SVPWS_getGrupoRama ( peRama ) = 'Z'  or
              SVPWS_getGrupoRama ( peRama ) = 'O'  or
              SVPWS_getGrupoRama ( peRama ) = 'T'  or
              SVPWS_getGrupoRama ( peRama ) = 'M'  or
              SVPWS_getGrupoRama ( peRama ) = 'C'  or
              SVPWS_getGrupoRama ( peRama ) = 'R'  or
              SVPWS_getGrupoRama ( peRama ) = 'W';

        k1yer0.r0empr = PeBase.peEmpr;
        k1yer0.r0sucu = PeBase.peSucu;
        k1yer0.r0nivt = PeBase.peNivt;
        k1yer0.r0nivc = PeBase.peNivc;
        k1yer0.r0nctw = peNctw;
        k1yer0.r0rama = peRama;
        k1yer0.r0poco = pePoco;
        k1yer0.r0arse = peArse;

        setll %kds( k1yer0 ) ctwer0;
        if %equal ( ctwer0 );

          SetError( COWGRAI_POCOEX
                  : 'Número de Componente ya Existe' );
          return *Off;

        endif;

       elseif SVPWS_getGrupoRama ( peRama ) = 'V' ;

        k1yev1.v1empr = PeBase.peEmpr;
        k1yev1.v1sucu = PeBase.peSucu;
        k1yev1.v1nivt = PeBase.peNivt;
        k1yev1.v1nivc = PeBase.peNivc;
        k1yev1.v1nctw = peNctw;
        k1yev1.v1rama = peRama;
        k1yev1.v1poco = pePoco;
        k1yev1.v1arse = peArse;

        setll %kds( k1yev1 : 8 ) ctwev1;
        if %equal ( ctwev1 );

          SetError( COWGRAI_POCOEX
                  : 'Número de Componente ya Existe' );
          return *Off;

        endif;

       endif;

       return *On;

      /end-free

     P COWGRAI_chkComponente...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_SaveImpuestos():Graba Impuestos                          *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Cant. Pólizas por Rama                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *

     P COWGRAI_SaveImpuestos...
     P                 B                   export
     D COWGRAI_SaveImpuestos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain %kds( k1y001 ) ctw001;
       chain %kds( k1y001 ) ctw001c;

       clear c1w001;
       clear c1w001c;

       w1empr = peBase.peEmpr;
       w1sucu = peBase.pesucu;
       w1nivt = peBase.peNivt;
       w1nivc = peBase.peNivc;
       w1nctw = peNctw;
       w1rama = peRama;
       w1xref = COWGRAI_getXref( peBase : peNctw : w1rama );

       chain peRama set123;

       if %found( set123 );

         w1pimi = t5pimi;
         w1psso = t5psso;
         w1pssn = t5pssn;
         w1pivi = t5pivi;
         clear  w1pivr;
         clear  w1pivn;

         if COWGRAI_getCodigoIva ( peBase : peNctw ) = 1;
           w1pivr = t5pivr;
           w1pivn = t5pivn;
         Endif;

         if %found ( ctw001 );
           update c1w001;
         else;
           write c1w001;
         endif;

         COWGRAI_GetCondComerciales (peBase:peNctw:peRama:w1xrea:w1xopr);

         if %found ( ctw001c );
           update c1w001c;
         else;
           write c1w001c;
         endif;

         return *on;

       else;

         return *off;

       endif;

     P COWGRAI_SaveImpuestos...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_getXref():Retorna % Rec Financiero                       *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     P COWGRAI_getXref...
     P                 B                   export
     D COWGRAI_getXref...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D DBA918R         pr                  extpgm('DBA918R')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNrpp                        3  0 const
     D  peMone                        2a   const
     D  peXref                        5  2
     D  peFech                        8  0 const options(*nopass:*omit)

     D K1y000          ds                  likerec(c1w000:*key)
     D K1y611          ds                  likerec(s1t611:*key)
     D K1y6118         ds                  likerec(s1t6118:*key)
     D K1y621          ds                  likerec(s1t621:*key)
     D K1y699          ds                  likerec(s1t699:*key)

     D @@arcd          s              6  0
     D @@xref          s              5  2

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.pesucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds( k1y000 ) ctw000;
       if %found;
          DBA918R( peBase.peEmpr
                 : peBase.peSucu
                 : w0nrpp
                 : w0mone
                 : @@xref
                 : *omit         );
       endif;

       return @@xref;

     P COWGRAI_getXref...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetCalculoPercepcion(): obtiene el IPR6 (Calculo de      *
      *                                                  percepción)     *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      peSubp (input)  Prima subtotal                              *
      *      peSuma (input)  Suma Asegurada                              *
      *      peCiva (input)  Códidgo de IVA                              *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peCuit (input)  Cuit                           ( opcional ) *
      *      peAsen (input)  Asegurado                      ( opcional ) *
      *      pePorc (input)  Porcentaje                     ( opcional ) *
      *      pePpr1 (output) Impuesto Valor Agregado x Porc ( opcional ) *
      *      pePpr3 (output) IVA-Importe Percepcion x Porc  ( opcional ) *
      *      pePpr4 (output) IVA-Resp.No Inscripto x Porc   ( opcional ) *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetCalculoPercepcion...
     P                 B
     D COWGRAI_GetCalculoPercepcion...
     D                 pi            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   peSubp                      15  2 const
     D   peSuma                      15  2 const
     D   peCiva                       2  0 const
     D   peIpr1                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peCuit                      11    options( *omit : *nopass )
     D   peAsen                       7  0 options( *omit : *nopass )
     D   pePorc                       9  6 options( *omit : *nopass )
     D   pePpr1                      15  2 options( *omit : *nopass )
     D   pePpr3                      15  2 options( *omit : *nopass )
     D   pePpr4                      15  2 options( *omit : *nopass )

     D   @@ipr6        s             15  2 inz
     D   p@Porc        s              9  6
     D   p@Asen        s              7  0
     D   p@Cuit        s             11
     D   @@ipr1        s             15  2 inz
     D   @@ipr3        s             15  2 inz
     D   @@ipr4        s             15  2 inz

      /free

         COWGRAI_inz();

         if %parms >= 11 and %addr( peCuit ) <> *Null;
           p@Cuit = peCuit;
         endif;

         if %parms >= 12 and %addr( peAsen ) <> *Null;
           p@Asen = peAsen;
         endif;

         if %parms >= 13 and %addr( pePorc ) <> *Null;
           if pePorc = *Zeros;
             p@Porc = 100;
           else;
             p@Porc = pePorc;
           endif;
         else;
           p@Porc = 100;
         endif;

         @@ipr1 = peIpr1;
         @@ipr3 = peIpr3;
         @@ipr4 = peIpr4;

         pro401o( peRpro
                : peRama
                : peMone
                : peCome
                : peSubp
                : peSuma
                : p@Asen
                : peCiva
                : @@Ipr1
                : @@Ipr3
                : @@Ipr4
                : p@Porc
                : @@Ipr6
                : p@Cuit );

        if %parms >= 14 and %addr( pePpr1 ) <> *Null;
          pePpr1 = @@ipr1;
        endif;

        if %parms >= 15 and %addr( pePpr3 ) <> *Null;
          pePpr3 = @@ipr3;
        endif;

        if %parms >= 16 and %addr( pePpr4 ) <> *Null;
          pePpr4 = @@ipr4;
        endif;

        return @@Ipr6;

       /end-free

     P COWGRAI_GetCalculoPercepcion...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetSelladosprovinciales: Obtener Sellados de Riesgo      *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      pePrim (input)  Prima                                       *
      *      peBpri (input)  Bonificaciones                              *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *      peSub1 (input)  Subtotal                                    *
      *      peSaop (input)  Suma Asegurada                              *
      *      peImpi (input)  Impuestos Internos                          *
      *      peSers (input)  Servicios Sociales                          *
      *      peTssn (input)  Tasa SSN                                    *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr2 (input)  Acciones                                    *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peIpr5 (input)  Recargo de Capital                          *
      *      peIpr6 (input)  Componente Premio 6                         *
      *      peIpr7 (input)  Ing.Brutos Riesgo                           *
      *      peIpr8 (input)  Ing.Brutos Empresa                          *
      *      pePorc (input)  Porcentaje                                  *
      *      pePor1 (input)  Porcentaje 1                                *
      *      peTiso (input)  Tipo de Sociedad                            *
      *                                                                  *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetSelladosprovinciales...
     P                 B                   export
     D                 pi            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSub1                      15  2 const
     D   peSaop                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePorc                       9  6 options(*nopass)
     D   pePor1                       9  6 options(*nopass)
     D   peTiso                       2  0 options(*nopass)
     D   peimfo                      15  2 options(*nopass)

     D   @@seri        s             15  2 inz

      /free

         COWGRAI_inz();

         pro401s( peRpro
                : peRama
                : peMone
                : peCome
                : pePrim
                : peBpri
                : peRead
                : peRefi
                : peDere
                : peSub1
                : peSaop
                : @@seri
                : peImpi
                : peSers
                : peTssn
                : peIpr1
                : peIpr2
                : peIpr3
                : peIpr4
                : peIpr5
                : peIpr6
                : peIpr7
                : peIpr8
                : pePorc
                : pePor1
                : peTiso
                : peimfo );

        return @@seri;

       /end-free
     P COWGRAI_GetSelladosprovinciales...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetSelladodelaEmpresa: Obtener Sellados de La Empresa    *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      pePrim (input)  Prima                                       *
      *      peBpri (input)  Bonificaciones                              *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *      peSub1 (input)  Subtotal                                    *
      *      peSaop (input)  Suma Asegurada                              *
      *      peImpi (input)  Impuestos Internos                          *
      *      peSers (input)  Servicios Sociales                          *
      *      peTssn (input)  Tasa SSN                                    *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr2 (input)  Acciones                                    *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peIpr5 (input)  Recargo de Capital                          *
      *      peIpr6 (input)  Componente Premio 6                         *
      *      peIpr7 (input)  Ing.Brutos Riesgo                           *
      *      peIpr8 (input)  Ing.Brutos Empresa                          *
      *      pePorc (input)  Porcentaje                                  *
      *      pePor1 (input)  Porcentaje 1                                *
      *      peTiso (input)  Tipo de Sociedad                            *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetSelladodelaEmpresa...
     P                 B                   export
     D                 pi            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSub1                      15  2 const
     D   peSaop                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePorc                       9  6 options(*nopass)
     D   pePor1                       9  6 options(*nopass)
     D   peTiso                       2  0 options(*nopass)
     D   peimfo                      15  2 options(*nopass)

     D   @@seem        s             15  2 inz

      /free

         COWGRAI_inz();

         pro401n( peRpro
                : peRama
                : peMone
                : peCome
                : pePrim
                : peBpri
                : peRead
                : peRefi
                : peDere
                : peSub1
                : peSaop
                : @@seem
                : peImpi
                : peSers
                : peTssn
                : peIpr1
                : peIpr2
                : peIpr3
                : peIpr4
                : peIpr5
                : peIpr6
                : peIpr7
                : peIpr8
                : pePorc
                : pePor1
                : peTiso
                : peimfo );

        return @@seem;

       /end-free
     P COWGRAI_GetSelladodelaEmpresa...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIngBrutosConvMultilateral: Obtener Ingresos Brutos    *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peTipo (input)  Tipo de Impuesto                            *
      *      peNeto (input)  Prima                                       *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetIngBrutosConvMultilateral...
     P                 B                   export
     D                 pi            15  2
     D peRpro                         2  0 const
     D peRama                         2  0 const
     D peTipo                         1    const
     D peNeto                        15  2 const
     D peRead                        15  2 const
     D peRefi                        15  2 const
     D peDere                        15  2 const

     D   @@iprx        s             15  2 inz

      /free

         COWGRAI_inz();

         pro401m( peRpro
                : peRama
                : peTipo
                : peNeto
                : peRead
                : peRefi
                : peDere
                : @@iprx );

        return @@iprx;

       /end-free

     P COWGRAI_GetIngBrutosConvMultilateral...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetDerechoEmision(): retorna el impuesto de derecho de   *
      *                             emision.                             *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetDerechoEmision...
     P                 B                   export
     D COWGRAI_GetDerechoEmision...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1dere;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetDerechoEmision...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetRecargoFinanc():  % Recargo Financiero                *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetRecargoFinanc...
     P                 B                   export
     D COWGRAI_GetRecargoFinanc...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1xref;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetRecargoFinanc...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImpuestosInte(): % Impuestos Internos                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImpuestosInte...
     P                 B                   export
     D COWGRAI_GetImpuestosInte...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1pimi;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetImpuestosInte...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetServiciosSoci(): % Servicios Sociales                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetServiciosSoci...
     P                 B                   export
     D COWGRAI_GetServiciosSoci...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1psso;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetServiciosSoci...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetTasaSsn(): % Tasa SSN                                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetTasaSsn...
     P                 B                   export
     D COWGRAI_GetTasaSsn...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1pssn;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetTasaSsn...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIvaInscripto(): % Iva Inscripto                       *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetIvaInscripto...
     P                 B                   export
     D COWGRAI_GetIvaInscripto...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1pivi;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetIvaInscripto...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIvaRes(): % Iva Res.3125                              *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetIvaRes...
     P                 B                   export
     D COWGRAI_GetIvaRes...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1pivr;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetIvaRes...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIvaNoInscripto(): % Iva No Inscripto                  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetIvaNoInscripto...
     P                 B                   export
     D COWGRAI_GetIvaNoInscripto...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds( k1y001 : 6 ) ctw001;
       if %found ( ctw001 );

         return w1pivn;

       endif;

       return 0;

      /end-free
     P COWGRAI_GetIvaNoInscripto...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetCodProInd(): Código Pcia. del Inder                   *
      *                                                                  *
      *      peCopo (input)  Código Postal                               *
      *      peCops (input)  Sufijo del Código Postal                    *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetCodProInd...
     P                 B                   export
     D COWGRAI_GetCodProInd...
     D                 pi             2  0
     D   peCopo                       5  0   const
     D   peCops                       1  0   const

     D K1yloc          ds                  likerec(g1tloc:*key)
     D K1ypro          ds                  likerec(g1tpro:*key)

      /free

       COWGRAI_inz();

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;

       chain(n) %kds( k1yloc : 2 ) gntloc;
       if %found;

         k1ypro.prproc = loproc;

         chain(n) %kds( k1ypro : 1 ) gntpro;
         if %found;

           return prrpro;

         endif;

       endif;

       return 0;


      /end-free
     P COWGRAI_GetCodProInd...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteImpi(): Retorna Importe Impuesto interno       *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImporteImpi...
     P                 B                   export
     D COWGRAI_GetImporteImpi...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D K1yloc          ds                  likerec(g1tloc:*key)
     D K1ypro          ds                  likerec(g1tpro:*key)

      /free

       COWGRAI_inz();

       return ( pePrim * COWGRAI_GetImpuestosInte (peBase:peNctw:peRama ))/100;

      /end-free
     P COWGRAI_GetImporteImpi...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteSers(): Retorna Importe Servicios Sociales     *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImporteSers...
     P                 B                   export
     D COWGRAI_GetImporteSers...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D K1yloc          ds                  likerec(g1tloc:*key)
     D K1ypro          ds                  likerec(g1tpro:*key)

      /free

       COWGRAI_inz();

       return ( pePrim * COWGRAI_GetServiciosSoci (peBase:peNctw:peRama ))/100;

      /end-free
     P COWGRAI_GetImporteSers...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteTssn(): Retorna Importe Tasa Ssn.              *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImporteTssn...
     P                 B                   export
     D COWGRAI_GetImporteTssn...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D K1yloc          ds                  likerec(g1tloc:*key)
     D K1ypro          ds                  likerec(g1tpro:*key)

      /free

       COWGRAI_inz();

       return ( pePrim * COWGRAI_GetTasaSsn  (peBase:peNctw:peRama ))/100;

      /end-free
     P COWGRAI_GetImporteTssn...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteIins(): Retorna Importe de IVA.                *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImporteIins...
     P                 B                   export
     D COWGRAI_GetImporteIins...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D   @@mone        s              2
     D   @@ivrs        s              1
     D   @@ipr1        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2

      /free

       COWGRAI_inz();

       //return ( pePrim * COWGRAI_GetIvaInscripto  (peBase:peNctw:peRama ))/100;
       //Percepcion de IVA solo se cobra a Responsables Inscriptos, para el
       //futuro se debe realizar validacion de excencion como lo hace el
       // PRO401TE.-

       clear @@ipr1;
       clear @@ipr3;
       clear @@ipr4;

       @@ivrs = '1';
       if COWGRAI_getCodigoIva( peBase : peNctw ) = 1;
         @@ivrs = '0';
       endif;

       @@mone = COWGRAI_monedaCotizacion( peBase : peNctw );

       PRO401T( COWGRAI_cotizaMoneda( @@mone :  %dec(%date:*iso))
              : COWGRAI_getCodigoIva( peBase : peNctw )
              : @@ivrs
              : pePrim
              : COWGRAI_getMinimoRes3125( peRama )
              : COWGRAI_GetIvaInscripto( peBase : peNctw : peRama )
              : COWGRAI_GetIvaNoInscripto( peBase : peNctw : peRama )
              : COWGRAI_GetIvaRes( peBase : peNctw : peRama )
              : @@ipr1
              : @@ipr3
              : @@ipr4  );

       return @@ipr1;
      /end-free
     P COWGRAI_GetImporteIins...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteIres(): Retorna Importe de IVA Rnl             *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImporteIres...
     P                 B                   export
     D COWGRAI_GetImporteIres...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D   @@mone        s              2
     D   @@ivrs        s              1
     D   @@ipr1        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2

      /free

       COWGRAI_inz();

       //Percepcion de IVA solo se cobra a Responsables Inscriptos, para el
       //futuro se debe realizar validacion de excencion como lo hace el
       // PRO401TE.-

       clear @@ipr1;
       clear @@ipr3;
       clear @@ipr4;

       @@mone = COWGRAI_monedaCotizacion( peBase : peNctw );

       @@ivrs = '1';
       if COWGRAI_getCodigoIva( peBase : peNctw ) = 1;
         @@ivrs = '0';
       endif;

       PRO401T( COWGRAI_cotizaMoneda( @@mone :  %dec(%date:*iso))
              : COWGRAI_getCodigoIva( peBase : peNctw )
              : @@ivrs
              : pePrim
              : COWGRAI_getMinimoRes3125( peRama )
              : COWGRAI_GetIvaInscripto( peBase : peNctw : peRama )
              : COWGRAI_GetIvaNoInscripto( peBase : peNctw : peRama )
              : COWGRAI_GetIvaRes( peBase : peNctw : peRama )
              : @@ipr1
              : @@ipr3
              : @@ipr4  );

       return @@ipr4;

      /end-free
     P COWGRAI_GetImporteIres...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteInoi(): Retorna Importe de IVA no Inscripto    *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImporteInoi...
     P                 B                   export
     D COWGRAI_GetImporteInoi...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D   @@mone        s              2
     D   @@ivrs        s              1
     D   @@ipr1        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2

     D   come          s             15  6
     D   civa          s              1  0
     D   ivam          s              5  2
     D   ipr1          s             15  2
     D   ipr4          s             15  2
     D   ipr3          s             15  2



      /free

       COWGRAI_inz();

       //Percepcion de IVA solo se cobra a Responsables Inscriptos, para el
       //futuro se debe realizar validacion de excencion como lo hace el
       // PRO401TE.-

       clear @@ipr1;
       clear @@ipr3;
       clear @@ipr4;

       @@mone = COWGRAI_monedaCotizacion( peBase : peNctw );
       @@ivrs = 'N';

       @@ivrs = '1';
       if COWGRAI_getCodigoIva( peBase : peNctw ) = 1;
         @@ivrs = '0';
       endif;

       come =  COWGRAI_cotizaMoneda( @@mone :  %dec(%date:*iso) );
       civa =  COWGRAI_getCodigoIva( peBase : peNctw );
       ivam =  COWGRAI_getMinimoRes3125( peRama );
       ipr1 =  COWGRAI_GetIvaInscripto( peBase : peNctw : peRama );
       ipr4 =  COWGRAI_GetIvaNoInscripto( peBase : peNctw : peRama );
       ipr3 =  COWGRAI_GetIvaRes( peBase : peNctw : peRama );

       PRO401T( come
              : civa
              : @@ivrs
              : pePrim
              : ivam
              : ipr1
              : ipr4
              : ipr3
              : @@ipr1
              : @@ipr3
              : @@ipr4  );

       return @@ipr3;

      /end-free
     P COWGRAI_GetImporteInoi...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteRefi(): Retorna Importe de Recargo Financiero  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetImporteRefi...
     P                 B                   export
     D COWGRAI_GetImporteRefi...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D K1yloc          ds                  likerec(g1tloc:*key)
     D K1ypro          ds                  likerec(g1tpro:*key)

      /free

       COWGRAI_inz();

       return ( pePrim * COWGRAI_GetRecargoFinanc (peBase:peNctw:peRama ))/100;

      /end-free
     P COWGRAI_GetImporteRefi...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetPrimaSubtot(): Retorna prima SubTotal                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetPrimaSubtot...
     P                 B                   export
     D COWGRAI_GetPrimaSubtot...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
     D   peForm                       1     options(*omit:*nopass)

     D K1yloc          ds                  likerec(g1tloc:*key)
     D K1ypro          ds                  likerec(g1tpro:*key)

     D @@epv           s              5  2
     D @@com           s              5  2
     D @@Idere         s             15  2
     D @@Iread         s             15  2
     D @@Iepv          s             15  2
     D @@resul         s             15  2

      /free

       COWGRAI_inz();

       if %parms >= 5 and %addr( peForm ) <> *Null;
         COWGRAI_GetCondComercialesA (peBase:peNctw:peRama:@@epv:@@com);
       else;
         COWGRAI_GetCondComerciales (peBase:peNctw:peRama:@@epv:@@com);
       endif;

       @@Idere = COWGRAI_GetDerechoEmision (peBase:peNctw:peRama);
       @@Iread = pePrim * COWGRAI_GetRecargoFinanc( peBase
                                                  : peNctw
                                                  : peRama )/100;
       @@Iepv  = pePrim* (@@epv/100);
       @@resul = pePrim + @@Idere + @@Iread + @@Iepv;

       return @@resul;

      /end-free
     P COWGRAI_GetPrimaSubtot...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_cotizaMoneda(): devuelve cotización de la moneda.    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peComo  -  Código de Moneda                   *
      *                peFcot  -  Fecha de Cotización (aaaammdd)     *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWGRAI_cotizaMoneda...
     P                 B                   export
     D COWGRAI_cotizaMoneda...
     D                 pi            15  6
     D   peComo                       2      const
     D   peFcot                       8  0   const

     D k1ycmo          ds                  likerec(g1tcmo:*key)

     D                 ds
     D feccmo                  1      8  0
     D feccoa                  1      4  0
     D feccom                  5      6  0
     D feccod                  7      8  0

      /free

       COWGRAI_inz();

       feccmo = peFcot;
       k1ycmo.mocomo = peComo;
       k1ycmo.mofcoa = feccoa;
       k1ycmo.mofcom = feccom;
       k1ycmo.mofcod = feccod;

       setgt %kds( k1ycmo ) gntcmo;
       readpe peComo gntcmo;

       if not %eof ( gntcmo );

         return mocotv;

       endif;

       return 0;

      /end-free

     P COWGRAI_cotizaMoneda...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deletePoco(): Elimina los componentes                *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deletePoco...
     P                 B                   export
     D COWGRAI_deletePoco...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      /free

       COWGRAI_inz();

       COWGRAI_deleteCabePoco( peBase : peNctw : peRama : peArse : pePoco );

       COWGRAI_deleteCoberturas( peBase : peNctw : peRama : peArse : pePoco );

       COWGRAI_deleteBonificaciones(peBase : peNctw : peRama : peArse : pePoco);

       COWGRAI_deleteCarac( peBase : peNctw : peRama : peArse : pePoco);

       COWGRAI_deleteImpImpu( peBase : peNctw : peRama : peArse : pePoco);

       COWGRAI_deleteAccesorios( peBase : peNctw : peRama : peArse : pePoco );

       COWGRAI_deleteCompVida( peBase : peNctw : peRama : peArse : pePoco );

       COWGRAI_deletePocoScoring( peBase : peNctw : peRama : peArse : pePoco );

       return *on;

      /end-free

     P COWGRAI_deletePoco...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCabePoco(): Elimina cabecera de cotizacion de  *
      *                          auto                                *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteCabePoco...
     P                 B                   export
     D COWGRAI_deleteCabePoco...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yet0        ds                  likerec( c1wet0  : *key )

      /free

       COWGRAI_inz();

       //Auto
       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.penivt;
       k1yet0.t0nivc = peBase.penivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0poco = pePoco;

       chain %kds ( k1yet0 ) ctwet0;

       if %found ( ctwet0 );
         delete c1wet0;
       endif;

       //Hogar
       chain %kds ( k1yet0 ) ctwer0;

       if %found ( ctwer0 );
         delete c1wer0;
       endif;

       return *on;

      /end-free

     P COWGRAI_deleteCabePoco...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCoberturas(): Elimina cabecera de cotizacion de*
      *                            auto                              *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteCoberturas...
     P                 B                   export
     D COWGRAI_deleteCoberturas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yet0        ds                  likerec( c1wet0  : *key )
     D   k1yetc        ds                  likerec( c1wetc  : *key )

      /free

       COWGRAI_inz();

       //Auto
       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.penivt;
       k1yet0.t0nivc = peBase.penivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0poco = pePoco;

       chain(n) %kds ( k1yet0 : 8 ) ctwet0;

       k1yetc.t0empr = peBase.peEmpr;
       k1yetc.t0sucu = peBase.peSucu;
       k1yetc.t0nivt = peBase.penivt;
       k1yetc.t0nivc = peBase.penivc;
       k1yetc.t0nctw = peNctw;
       k1yetc.t0rama = peRama;
       k1yetc.t0arse = peArse;
       k1yetc.t0poco = pePoco;

       setll %kds ( k1yetc : 8 ) ctwetc;
       reade %kds ( k1yetc : 8 ) ctwetc;

       dow not %eof();

         if ( t0mar1 = '1' );

           COWGRAI_DeletePrimasPorProvincia ( peBase :
                                              peNctw :
                                              peRama :
                                              peArse :
                                              pePoco :
                                            COWGRAI_GetCodProInd( t0Copo:
                                                                  t0Cops ):
                                              t0vhvu :
                                              t0sast :
                                              t0prim :
                                              t0prem );

         endif;

         delete c1wetc;

         reade %kds ( k1yetc : 8 ) ctwetc;

       enddo;

       //Hogar
       setll %kds ( k1yetc : 8 ) ctwer2;
       reade %kds ( k1yetc : 8 ) ctwer2;
       dow not %eof();
         delete c1wer2;
         reade %kds ( k1yetc : 8 ) ctwer2;
       enddo;

       //vida
       setll %kds ( k1yetc : 8 ) ctwev2;
       reade %kds ( k1yetc : 8 ) ctwev2;
       dow not %eof();
         delete c1wev2;
         reade %kds ( k1yetc : 8 ) ctwev2;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteCoberturas...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteBonificaciones:Elimina cabecera de cotizacion  *
      *                              de auto                         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteBonificaciones...
     P                 B                   export
     D COWGRAI_deleteBonificaciones...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yet4        ds                  likerec( c1wet4  : *key )

      /free

       COWGRAI_inz();

       k1yet4.t4empr = peBase.peEmpr;
       k1yet4.t4sucu = peBase.peSucu;
       k1yet4.t4nivt = peBase.penivt;
       k1yet4.t4nivc = peBase.penivc;
       k1yet4.t4nctw = peNctw;
       k1yet4.t4rama = peRama;
       k1yet4.t4arse = peArse;
       k1yet4.t4poco = pePoco;

       //Auto
       setll %kds ( k1yet4 : 8 ) ctwet4;
       reade %kds ( k1yet4 : 8 ) ctwet4;

       dow not %eof();
         delete c1wet4;
         reade %kds ( k1yet4 : 8 ) ctwet4;
       enddo;

       //Hogar
       setll %kds ( k1yet4 : 8 ) ctwer4;
       reade %kds ( k1yet4 : 8 ) ctwer4;

       dow not %eof();
         delete c1wer4;
         reade %kds ( k1yet4 : 8 ) ctwer4;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteBonificaciones...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCarac:Elimina caracterizticas del bien         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteCarac...
     P                 B                   export
     D COWGRAI_deleteCarac...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yer6        ds                  likerec( c1wer6  : *key )

      /free

       COWGRAI_inz();

       k1yer6.r6empr = peBase.peEmpr;
       k1yer6.r6sucu = peBase.peSucu;
       k1yer6.r6nivt = peBase.penivt;
       k1yer6.r6nivc = peBase.penivc;
       k1yer6.r6nctw = peNctw;
       k1yer6.r6rama = peRama;
       k1yer6.r6arse = peArse;
       k1yer6.r6poco = pePoco;

       setll %kds ( k1yer6 : 8 ) ctwer6;
       reade %kds ( k1yer6 : 8 ) ctwer6;

       dow not %eof();
         delete c1wer6;
         reade %kds ( k1yer6 : 8 ) ctwer6;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteCarac...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImpImpu(): Elimina importes de impuestos       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteImpImpu...
     P                 B                   export
     D COWGRAI_deleteImpImpu...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1y002        ds                  likerec( c1w002  : *key )

      /free

       COWGRAI_inz();

       k1y002.w2empr = peBase.peEmpr;
       k1y002.w2sucu = peBase.peSucu;
       k1y002.w2nivt = peBase.penivt;
       k1y002.w2nivc = peBase.penivc;
       k1y002.w2nctw = peNctw;
       k1y002.w2rama = peRama;
       k1y002.w2arse = peArse;
       k1y002.w2poco = pePoco;

       chain %kds ( k1y002 : 8 ) ctw002;

       if %found ( ctw002 );
         delete c1w002;
       endif;

       return *on;

      /end-free

     P COWGRAI_deleteImpImpu...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_getArticulo():Recupera el articulo asociado en la        *
      *                       cabecera  de la cotización                 *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWGRAI_getArticulo...
     P                 B                   export
     D COWGRAI_getArticulo...
     D                 pi             6  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );

         return w0Arcd;

       endif;

       return 0;

      /end-free

     P COWGRAI_getArticulo...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_GetPremio():Obtiene Premio                               *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima                                       *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     P COWGRAI_GetPremioBruto...
     P                 B                   export
     D COWGRAI_GetPremioBruto...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D K1yet0          ds                  likerec(c1wet0:*key)
     D K1yetc          ds                  likerec(c1wetc:*key)

     D pBruto          s             15  2 inz
     D pNeto           s             15  2 inz
     D prima           s             15  2 inz

      /free
       COWGRAI_inz();

       pBruto = pePrim+ COWGRAI_GetDerechoEmision (peBase:peNctw:peRama )
              +(pePrim* COWGRAI_GetRecargoFinanc (peBase:peNctw:peRama ))/100;


       pNeto = ( pBruto * COWGRAI_GetImpuestosInte (peBase:peNctw:peRama ))/100;
       pNeto+= ( pBruto * COWGRAI_GetServiciosSoci (peBase:peNctw:peRama ))/100;
       pNeto+= ( pBruto * COWGRAI_GetTasaSsn (peBase:peNctw:peRama ))/100;
       pNeto+= ( pBruto * COWGRAI_GetIvaInscripto (peBase:peNctw:peRama ))/100;
       pNeto+= ( pBruto * COWGRAI_GetIvaRes (peBase:peNctw:peRama ))/100;
       pNeto+= ( pBruto * COWGRAI_GetIvaNoInscripto (peBase:peNctw:peRama))/100;

       return pNeto;

      /end-free
     P COWGRAI_GetPremioBruto...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_getCalculosimpuestos(): devuelve la suma total de los    *
      *                                 impuestos                        *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      peCopo (input)  Código Postal                               *
      *      peCops (input)  Sufijo del Código Postal                    *
      *      peSaop (input)  Suma Asegurada                              *
      *      pePrim (input)  Prima cobertura                             *
      *      peTipe (input)  Tipo de Persona                             *
      *      peMone (input)  Moneda                                      *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     P COWGRAI_getCalculosImpuestos...
     P                 B                   export
     D COWGRAI_getCalculosImpuestos...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peSaop                      15  2   const
     D   pePrim                      15  2   const
     D   peTipe                       1      const
     D   peMone                       2      const

     D K1yet0          ds                  likerec(c1wet0:*key)
     D K1yetc          ds                  likerec(c1wetc:*key)

     D p@premt         s             15  2 inz (0)
     D p@Prim          s             15  2 inz (0)
     D p@Tiso          s              2  0 inz (0)
     D cero            s             15  2 inz (0)
     D cero96          s              9  6 inz (0)
     D @@copo          s              5  0 inz
     D @@cops          s              1  0 inz

      /free
       COWGRAI_inz();

       if peTipe = 'F';
         p@Tiso = 98;
       else;
         p@Tiso = 0;
       endif;

       if SVPEMP_getLocalidadDeEmpresa( peBase.peEmpr
                                      : @@copo
                                      : @@cops         );
       endif;

       p@Prim = COWGRAI_GetPrimaSubtot ( peBase :
                                         peNctw :
                                         peRama :
                                         pePrim );


       p@premt = COWGRAI_getPremioBruto ( peBase :
                                          peNctw :
                                          peRama :
                                          pePrim ) +

       COWGRAI_GetSelladosprovinciales ( COWGRAI_GetCodProInd ( peCopo :
                                                                peCops ):
                                         %int(peRama) :
                                        peMone :
                                         COWGRAI_cotizaMoneda ( peMone :
                                                              %dec(%date:*iso)):
                                         pePrim :
                                         cero   :
                                         cero   :
                                         COWGRAI_GetImporteRefi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  pePrim ):
                                         COWGRAI_GetDerechoEmision ( peBase :
                                                                     peNctw :
                                                                     peRama ):
                                         p@Prim :
                                         peSaop :
                                         COWGRAI_GetImporteImpi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteSers ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteTssn ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteIins ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         cero   :
                                         COWGRAI_GetImporteIres ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteInoi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         cero   :   //peIpr5 :
                                         cero   :   //peIpr6 :
                                         cero   :   //peIpr7 :
                                         cero   :   //peIpr8 :
                                         cero96 :   //pePorc :
                                         cero96 :   //pepor1 :
                                         p@Tiso :
                                         cero    ) +

       COWGRAI_GetSelladodelaEmpresa   ( COWGRAI_GetCodProInd ( @@copo :
                                                                @@cops ):
                                         %int(peRama) :
                                         peMone :
                                         COWGRAI_cotizaMoneda ( peMone :
                                                              %dec(%date:*iso)):
                                         pePrim :
                                         cero   :
                                         cero   :
                                         COWGRAI_GetImporteRefi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  pePrim ):
                                         COWGRAI_GetDerechoEmision ( peBase :
                                                                     peNctw :
                                                                     peRama ):
                                         p@Prim :
                                         peSaop :
                                         COWGRAI_GetImporteImpi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteSers ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteTssn ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteIins ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         cero   :
                                         COWGRAI_GetImporteIres ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         COWGRAI_GetImporteInoi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@Prim ):
                                         cero   :   //peIpr5 :
                                         cero   :   //peIpr6 :
                                         cero   :   //peIpr7 :
                                         cero   :   //peIpr8 :
                                         cero96 :   //pePorc :
                                         cero96 :   //pepor1 :
                                         p@Tiso :
                                         cero    ) +

       COWGRAI_GetIngBrutosConvMultilateral( COWGRAI_GetCodProInd ( peCopo :
                                                                   peCops ):
                                         %int(peRama) :
                                         'E'    :
                                         pePrim :
                                         cero   :
                                         COWGRAI_GetImporteRefi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  pePrim ):
                                         COWGRAI_GetDerechoEmision ( peBase :
                                                                     peNctw :
                                                                     peRama ))+

       COWGRAI_GetIngBrutosConvMultilateral( COWGRAI_GetCodProInd ( peCopo :
                                                                   peCops ):
                                         %int(peRama) :
                                         'R'    :
                                         pePrim :
                                         cero   :
                                         COWGRAI_GetImporteRefi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  pePrim ):
                                         COWGRAI_GetDerechoEmision ( peBase :
                                                                     peNctw :
                                                                     peRama ));
       return p@premt;

      /end-free
     P COWGRAI_getCalculosImpuestos...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getCodigoIva(): Devuelve el codigo de Iva.           *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getCodigoIva...
     P                 B                   export
     D COWGRAI_getCodigoIva...
     D                 pi             2  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         return w0civa;

       endif;

       return 0;

      /end-free

     P COWGRAI_getCodigoIva...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_updCotizacion():  Actualizar registro de cotización   *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peCiva   (input)   Código de Iva                          *
      *     peTipe   (input)   Tipo de Persona                        *
      *     peCopo   (input)   Código Postal                          *
      *     peCops   (input)   Sufijo Código Postal                   *
      *     peCfpg   (input)   Código de Forma de pago                *
      *     peNrpp   (input)   Plan de Pago                           *
      *     peVdes   (input)   Vigencia Desde (opcional)              *
      *     peVhas   (input)   Vigencia Hasta (opcional)              *
      *                                                               *
      * ------------------------------------------------------------- *
     P COWGRAI_updCotizacion...
     P                 B                   export
     D COWGRAI_updCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peCiva                       2  0   const
     D   peTipe                       1      const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCfpg                       1  0   const
     D   peNrpp                       3  0   const
     D   peVdes                       8  0 const options(*omit:*nopass)
     D   peVhas                       8  0 const options(*omit:*nopass)

     D k1y000          ds                  likerec(c1w000:*key)
     D @vdes           s              8  0
     D @vhas           s              8  0

      /free

       COWGRAI_inz();

       if %parms >= 9 and %addr(peVdes) <> *null;
          @vdes = peVdes;
       endif;
       if %parms >= 10 and %addr(peVhas) <> *null;
          @vhas = peVhas;
       endif;

       //Si todo bien actualizo.

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         w0civa = peCiva;
         w0ncil = SVPDES_codigoIva ( peCiva );
         w0tipe = peTipe;
         w0copo = peCopo;
         w0cops = peCops;
         w0loca = SVPDES_localidad ( peCopo : peCops );
         w0cest = 1;
         w0cses = 2;
         w0dest = SVPDES_estadoCot(w0cest:
                                  w0cses);

         w0Cfpg = peCfpg;
         w0Nrpp = peNrpp;

         w0defp = getDescPago( w0cfpg );

         w0vdes = @vdes;
         w0vhas = @vhas;

         update c1w000;

         unlock ctw000;

         return *on;

       endif;

       unlock ctw000;

       return *off;

      /end-free

     P COWGRAI_updCotizacion...
     P                 E

      * ------------------------------------------------------------- *
      * COWGRAI_getImportesTot (): Recupera los importes de los       *
      *                            impuestos por componente           *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peArse   (input)   cant.polizas por rama/art              *
      *     peSeri   (output)  sellado riesgo                         *
      *     peSeem   (output)  sellado de la empresa                  *
      *     peImpi   (output)  impuestos internos                     *
      *     peSers   (output)  servicios sociales                     *
      *     peTssn   (output)  tasa super. seg. nacion.               *
      *     peIpr1   (output)  impuesto valor agregado                *
      *     peIpr4   (output)  iva-resp.no inscripto                  *
      *     peIpr3   (output)  iva-importe percepcion                 *
      *     peIpr6   (output)  componente premio 6                    *
      *     peIpr7   (output)  componente premio 7                    *
      *     peIpr8   (output)  componente del premio 8                *
      *     peIpr9   (output)  componente del premio 9                *
      *                                                               *
      *                                                               *
      * ------------------------------------------------------------- *
     P COWGRAI_getImportesTot...
     P                 B                   export
     D COWGRAI_getImportesTot...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   peSeri                      15  2
     D   peSeem                      15  2
     D   peImpi                      15  2
     D   peSers                      15  2
     D   peTssn                      15  2
     D   peIpr1                      15  2
     D   peIpr2                      15  2
     D   peIpr3                      15  2
     D   peIpr4                      15  2
     D   peIpr5                      15  2
     D   peIpr6                      15  2
     D   peIpr7                      15  2
     D   peIpr8                      15  2
     D   peIpr9                      15  2


     D k1y002          ds                  likerec(c1w002:*key)

      /free

       COWGRAI_inz();

       k1y002.w2empr = PeBase.peEmpr;
       k1y002.w2sucu = PeBase.peSucu;
       k1y002.w2nivt = PeBase.peNivt;
       k1y002.w2nivc = PeBase.peNivc;
       k1y002.w2nctw = peNctw;
       k1y002.w2rama = peRama;
       k1y002.w2arse = peArse;

       setll %kds( k1y002 : 7 ) ctw002;
       reade %kds( k1y002 : 7 ) ctw002;
       dow %eof();

         peSeri += w2seri;
         peSeem += w2seem;
         peImpi += w2impi;
         peSers += w2sers;
         peTssn += w2tssn;
         peIpr1 += w2ipr1;
         peIpr2 += w2ipr2;
         peIpr3 += w2ipr3;
         peIpr4 += w2ipr4;
         peIpr5 += w2ipr5;
         peIpr6 += w2ipr6;
         peIpr7 += w2ipr7;
         peIpr8 += w2ipr8;
         peIpr9 += w2ipr9;

         reade %kds( k1y002 : 7 ) ctw002;
       enddo;

       return;

      /end-free

     P COWGRAI_getImportesTot...
     P                 E
      * ------------------------------------------------------------- *
      * COWGRAI_saveImportes   (): Recupera los importes de los       *
      *                            impuestos por componente           *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   cant.polizas por rama/art              *
      *     pePoco   (input)   nro. de componente                     *
      *     peSeri   (input)   sellado riesgo                         *
      *     peSeem   (input)   sellado de la empresa                  *
      *     peImpi   (input)   impuestos internos                     *
      *     peSers   (input)   servicios sociales                     *
      *     peTssn   (input)   tasa super. seg. nacion.               *
      *     peIpr1   (input)   impuesto valor agregado                *
      *     peIpr4   (input)   iva-resp.no inscripto                  *
      *     peIpr3   (input)   iva-importe percepcion                 *
      *     peIpr6   (input)   componente premio 6                    *
      *     peIpr7   (input)   componente premio 7                    *
      *     peIpr8   (input)   componente del premio 8                *
      *     peIpr9   (input)   componente del premio 9                *
      *                                                               *
      *                                                               *
      * ------------------------------------------------------------- *
     P COWGRAI_saveImportes...
     P                 B                   export
     D COWGRAI_saveImportes...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const
     D   peSeri                      15  2   const
     D   peSeem                      15  2   const
     D   peImpi                      15  2   const
     D   peSers                      15  2   const
     D   peTssn                      15  2   const
     D   peIpr1                      15  2   const
     D   peIpr4                      15  2   const
     D   peIpr3                      15  2   const
     D   peIpr6                      15  2   const
     D   peIpr7                      15  2   const
     D   peIpr8                      15  2   const
     D   peIpr9                      15  2   const


     D k1y002          ds                  likerec(c1w002:*key)

      /free

       COWGRAI_inz();

       clear c1w002;
       k1y002.w2empr = PeBase.peEmpr;
       k1y002.w2sucu = PeBase.peSucu;
       k1y002.w2nivt = PeBase.peNivt;
       k1y002.w2nivc = PeBase.peNivc;
       k1y002.w2nctw = peNctw;
       k1y002.w2rama = peRama;
       k1y002.w2arse = peArse;
       k1y002.w2poco = pePoco;

       chain %kds( k1y002 : 8 ) ctw002;
       if %found();

         w2seri = peSeri;
         w2seem = peSeem;
         w2impi = peImpi;
         w2sers = peSers;
         w2tssn = peTssn;
         w2ipr1 = peIpr1;
         w2ipr4 = peIpr4;
         w2ipr3 = peIpr3;
         w2ipr6 = peIpr6;
         w2ipr7 = peIpr7;
         w2ipr8 = peIpr8;
         w2ipr9 = peIpr9;
         update c1w002;

       else;

         w2empr = PeBase.peEmpr;
         w2sucu = PeBase.peSucu;
         w2nivt = PeBase.peNivt;
         w2nivc = PeBase.peNivc;
         w2rama = peRama;
         w2nctw = peNctw;
         w2arse = peArse;
         w2poco = pePoco;
         w2seri = peSeri;
         w2seem = peSeem;
         w2impi = peImpi;
         w2sers = peSers;
         w2tssn = peTssn;
         w2ipr1 = peIpr1;
         w2ipr4 = peIpr4;
         w2ipr3 = peIpr3;
         w2ipr6 = peIpr6;
         w2ipr7 = peIpr7;
         w2ipr8 = peIpr8;
         w2ipr9 = peIpr9;

         write c1w002;

       endif;

       return;

      /end-free

     P COWGRAI_saveImportes...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_chkEstCotizacion() Verifica si se puede cotizar      *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWGRAI_chkEstCotizacion...
     P                 B                   export
     D COWGRAI_chkEstCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;

       if ( w0cest = 1 ) and ( w0cses = 1 );

         SetError( COWGRAI_COTTR
                 : 'Cotización en Tramite' );
         return *Off;

       endif;

       return *on;

      /end-free

     P COWGRAI_chkEstCotizacion...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImportes(): Elimina los importes generados por *
      *                           los impuestos                      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteImportes...
     P                 B                   export
     D COWGRAI_deleteImportes...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1y002        ds                  likerec( c1w002  : *key )

      /free

       COWGRAI_inz();

       k1y002.w2empr = peBase.peEmpr;
       k1y002.w2sucu = peBase.peSucu;
       k1y002.w2nivt = peBase.penivt;
       k1y002.w2nivc = peBase.penivc;
       k1y002.w2nctw = peNctw;

       setll %kds ( k1y002 : 5 ) ctw002;
       reade %kds ( k1y002 : 5 ) ctw002;
       dow not %eof();

         delete c1w002;

         reade %kds ( k1y002 : 5 ) ctw002;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteImportes...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImpuestos():Elimina los impuestos generados    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteImpuestos...
     P                 B                   export
     D COWGRAI_deleteImpuestos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1y001        ds                  likerec( c1w001 : *key )

      /free

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.penivt;
       k1y001.w1nivc = peBase.penivc;
       k1y001.w1nctw = peNctw;

       setll %kds ( k1y001 : 5 ) ctw001;
       reade %kds ( k1y001 : 5 ) ctw001;
       dow not %eof();

         delete c1w001;

         reade %kds ( k1y001 : 5 ) ctw001;
       enddo;

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.penivt;
       k1y001.w1nivc = peBase.penivc;
       k1y001.w1nctw = peNctw;

       setll %kds ( k1y001 : 5 ) ctw001c;
       reade %kds ( k1y001 : 5 ) ctw001c;
       dow not %eof();

         delete c1w001c;

         reade %kds ( k1y001 : 5 ) ctw001c;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteImpuestos...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImpuesto():Elimina los impuesto para rama      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteImpuesto...
     P                 B                   export
     D COWGRAI_deleteImpuesto...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

     D   k1y001        ds                  likerec( c1w001 : *key )

      /free

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.penivt;
       k1y001.w1nivc = peBase.penivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain %kds ( k1y001 : 6 ) ctw001;
       if %found();

         delete c1w001;

       endif;

       chain %kds ( k1y001 : 6 ) ctw001c;
       if %found();

         delete c1w001c;

       endif;

       return *on;

      /end-free

     P COWGRAI_deleteImpuesto...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getImpuestos(): devuelve estructuras de impuestos e  *
      *                         importes                             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                pePrim  -  Prima                              *
      *                peSuma  -  Suma Asegurada                     *
      *                peCopo  -  Código Postal                      *
      *                peCops  -  Sufijo Código Postal               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peImpu  -  Estructura de Impuestos            *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_getImpuestos...
     P                 B                   export
     D COWGRAI_getImpuestos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   pePrim                      15  2 const
     D   peSuma                      15  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peImpu                            likeds(Impuesto)

     D   k1y001        ds                  likerec( c1w001c : *key )
     D   p@prim        s             15  2
     D   cero96        s              9  6 inz (0)
     D   cero          s             15  2 inz (0)
     D   p@Tiso        s              2  0
     D   p@Mone        s              2
     D   p@Rpro        s              2  0
     D   p@Ipr6        s             15  2
     D   p@Cmon        s             15  6
     D   @@form        s              1    inz('A')
     D   @@Copo        s              5  0 inz
     D   @@Cops        s              1  0 inz

      /free

       COWGRAI_inz();

       if COWGRAI_getTipoPersona ( peBase :peNctw ) = 'F';
         p@Tiso = 98;
       else;
         p@Tiso = 1;
       endif;

       if SVPEMP_getLocalidadDeEmpresa( peBase.peEmpr
                                      : @@copo
                                      : @@cops         );
       endif;

       eval(h) p@Prim = COWGRAI_GetPrimaSubtot ( peBase :
                                                 peNctw :
                                                 peRama :
                                                 pePrim :
                                                 @@form );

       p@mone = COWGRAI_monedaCotizacion(peBase :
                                        peNctw) ;

       p@Rpro = COWGRAI_GetCodProInd ( peCopo : peCops );

       peImpu.cobl = ' ';
       peImpu.xrea = 0;
       peImpu.read = 0;
       peImpu.xopr = 0;
       peImpu.copr = 0;
       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain(n) %kds ( k1y001 ) ctw001c;
       if %found( ctw001c );
         peImpu.xrea =   w1xrea;
         peImpu.read = ( pePrim * w1xrea ) / 100;
         peImpu.xopr =   w1xopr;
         peImpu.copr = ( pePrim * w1xopr ) / 100;
       endif;
       peImpu.xref = COWGRAI_GetRecargoFinanc (peBase:peNctw:peRama);
       peImpu.refi = COWGRAI_GetImporteRefi ( peBase :
                                              peNctw :
                                              peRama :
                                              pePrim );
       peImpu.dere = COWGRAI_GetDerechoEmision ( peBase
                                               : peNctw
                                               : peRama );

       peImpu.pimi = COWGRAI_GetImpuestosInte (peBase:peNctw:peRama );
       peImpu.impi = COWGRAI_GetImporteImpi ( peBase :
                                              peNctw :
                                              peRama :
                                              p@Prim );
       peImpu.psso = COWGRAI_GetServiciosSoci (peBase:peNctw:peRama);
       peImpu.sers = COWGRAI_GetImporteSers ( peBase :
                                              peNctw :
                                              peRama :
                                              p@Prim );
       peImpu.pssn = COWGRAI_GetTasaSsn (peBase:peNctw:peRama );
       peImpu.tssn = COWGRAI_GetImporteTssn ( peBase :
                                              peNctw :
                                              peRama :
                                              p@Prim );
       peImpu.pivi = COWGRAI_GetIvaInscripto (peBase:peNctw:peRama );
       peImpu.ipr1 = COWGRAI_GetImporteIins ( peBase :
                                              peNctw :
                                              peRama :
                                              p@Prim );
       peImpu.pivr = COWGRAI_GetIvaRes (peBase:peNctw:peRama );
       peImpu.ipr4 = COWGRAI_GetImporteIres ( peBase :
                                              peNctw :
                                              peRama :
                                              p@Prim );
       peImpu.pivn = COWGRAI_GetIvaNoInscripto (peBase:peNctw:peRama);
       peImpu.ipr3 = COWGRAI_GetImporteInoi ( peBase :
                                              peNctw :
                                              peRama :
                                              p@Prim );
       //ipr6
       peImpu.ipr6 =
       COWGRAI_GetCalculoPercepcion( p@Rpro :
                                     peRama :
                                     COWGRAI_monedaCotizacion(peBase :
                                                             peNctw) :
                                     COWGRAI_cotizaMoneda ( p@Mone :
                                                  %dec(%date:*iso)):
                                     p@Prim :
                                     peSuma :
                                     COWGRAI_getCodigoIva ( peBase:
                                                            peNctw):
                                     peImpu.ipr1 :
                                     peImpu.ipr3 :
                                     peImpu.ipr4 );

       peImpu.ipr7 = 0;
       peImpu.ipr8 = 0;

       peImpu.seri =
       COWGRAI_GetSelladosprovinciales ( p@Rpro :
                                         %int(peRama) :
                                         p@mone :
                                         COWGRAI_cotizaMoneda ( p@Mone :
                                                            %dec(%date:*iso)):
                                         pePrim :
                                         0      :
                                         peImpu.read :
                                         peImpu.refi :
                                         peImpu.dere :
                                         p@Prim :
                                         peSuma :
                                         peImpu.impi :
                                         peImpu.sers :
                                         peImpu.tssn :
                                         peImpu.ipr1 :
                                         0           :
                                         peImpu.ipr3 :
                                         peImpu.ipr4 :
                                         0      :   //peIpr5 :
                                         peImpu.ipr6 :
                                         peImpu.ipr7 :
                                         peImpu.ipr8 :
                                         cero96 :   //pePorc :
                                         cero96 :   //pepor1 :
                                         p@Tiso :
                                         cero    );

       peImpu.seem =
       COWGRAI_GetSelladodelaEmpresa   ( COWGRAI_GetCodProInd ( @@copo
                                                              : @@cops ):
                                         %int(peRama) :
                                         p@mone :
                                         COWGRAI_cotizaMoneda ( p@Mone :
                                                            %dec(%date:*iso)):
                                         pePrim :
                                         0      :
                                         peImpu.read :
                                         peImpu.refi :
                                         peImpu.dere :
                                         p@Prim :
                                         peSuma :
                                         peImpu.impi :
                                         peImpu.sers :
                                         peImpu.tssn :
                                         peImpu.ipr1 :
                                         0           :
                                         peImpu.ipr3 :
                                         peImpu.ipr4 :
                                         0      :   //peIpr5 :
                                         peImpu.ipr6 :
                                         peImpu.ipr7 :
                                         peImpu.ipr8 :
                                         cero96 :   //pePorc :
                                         cero96 :   //pepor1 :
                                         p@Tiso :
                                         cero    );

       return peImpu;

      /end-free

     P COWGRAI_getImpuestos...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getTipoPersona(): Retorna el tipo de persona que esta*
      *                           en la cabecera de la cotización.   *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getTipoPersona...
     P                 B                   export
     D COWGRAI_getTipoPersona...
     D                 pi             1
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         return w0tipe;

       endif;

       return *off;

      /end-free

     P COWGRAI_getTipoPersona...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAseguradaRamaArse(): retorna la suma suma ase-*
      *                                     gurada por rama y arse.  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                         *
      *     peArse   (input)   Cant. Pólizas por Rama                 *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getSumaAseguradaRamaArse...
     P                 B                   export
     D COWGRAI_getSumaAseguradaRamaArse...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1yet0          ds                  likerec(c1wetx:*key)
     D k1yer0          ds                  likerec(c1werx:*key)
     D @@suas          s             15  2

     D
      /free

       COWGRAI_inz();

       @@suas = *Zeros;

       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.peNivt;
       k1yet0.t0nivc = peBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;

       setll %kds( k1yet0 : 7 ) ctwet001;
       reade %kds( k1yet0 : 7 ) ctwet001;
       dow not %eof ( ctwet001 );

         @@suas += t0vhvu;

         reade %kds( k1yet0 : 7 ) ctwet001;
       enddo;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0arse = peArse;

       setll %kds( k1yer0 : 7 ) ctwer001;
       reade %kds( k1yer0 : 7 ) ctwer001;
       dow not %eof ( ctwer001 );

         @@suas += r0suas;

         reade %kds( k1yer0 : 7 ) ctwer001;
       enddo;

       //vida
       setll    %kds( k1yer0 : 7 ) ctwevc;
       reade(n) %kds( k1yer0 : 7 ) ctwevc;
       dow not %eof ( ctwevc );
         @@suas += v0suas;
         reade(n) %kds( k1yer0 : 7 ) ctwevc;
       enddo;

       // Sepelio
       setll    %kds( k1yer0 : 7 ) ctwse1;
       reade(n) %kds( k1yer0 : 7 ) ctwse1;
       dow not %eof ( ctwse1 );
           @@suas += e1saco;
        reade(n) %kds( k1yer0 : 7 ) ctwse1;
       enddo;

       return @@suas;

      /end-free

     P COWGRAI_getSumaAseguradaRamaArse...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAsSiniRamaArse() Retorna la suma asegurada si-*
      *                                 niestrable por rama y arse.  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                         *
      *     peArse   (input)   Cant. Pólizas por Rama                 *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getSumaAsSiniRamaArse...
     P                 B                   export
     D COWGRAI_getSumaAsSiniRamaArse...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1yet0          ds                  likerec(c1wetx:*key)
     D k1yer0          ds                  likerec(c1werx:*key)
     D @@sast          s             15  2

     D
      /free

       COWGRAI_inz();

       @@sast = *Zeros;

       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.peNivt;
       k1yet0.t0nivc = peBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;

       setll %kds( k1yet0 : 7 ) ctwet001;
       reade(n) %kds( k1yet0 : 7 ) ctwet001;
       dow not %eof ( ctwet001 );

         @@sast += t0sast;

         reade(n) %kds( k1yet0 : 7 ) ctwet001;
       enddo;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0arse = peArse;

       setll %kds( k1yer0 : 7 ) ctwer001;
       reade(n) %kds( k1yer0 : 7 ) ctwer001;
       dow not %eof ( ctwer001 );

         @@sast += r0sast;

         reade(n) %kds( k1yer0 : 7 ) ctwer001;
       enddo;

       //VIDA
       setll %kds( k1yer0 : 7 ) ctwevc;
       reade(n) %kds( k1yer0 : 7 ) ctwevc;
       dow not %eof ( ctwevc );

         @@sast += v0suas;

         reade(n) %kds( k1yer0 : 7 ) ctwevc;
       enddo;

       // Sepelio
       setll %kds( k1yer0 : 7 ) ctwse1;
       reade(n) %kds( k1yer0 : 7 ) ctwse1;
       dow not %eof ( ctwse1 );
           @@sast += e1saco;
        reade(n) %kds( k1yer0 : 7 ) ctwse1;
       enddo;

       return @@sast;

      /end-free

     P COWGRAI_getSumaAsSiniRamaArse...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getPrimaRamaArse() : retorna prima por rama y arse   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                                                              *
      * -------------------------------------------------------------*
     P COWGRAI_getPrimaRamaArse...
     P                 B                   export
     D COWGRAI_getPrimaRamaArse...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const options(*omit:*nopass)

     D   k1yer0        ds                  likerec( c1wer0  : *key )
     D   k1yetc        ds                  likerec( c1wetc  : *key )
     D   @@prim        s             15  2
     D   allparms      s               n

      /free

       COWGRAI_inz();

       if %parms <= 3;
         allparms = *on;
       else;
         k1yetc.t0arse = peArse;
         allparms = *off;
       endif;

       @@prim = *Zeros;

       k1yetc.t0empr = peBase.peEmpr;
       k1yetc.t0sucu = peBase.peSucu;
       k1yetc.t0nivt = peBase.peNivt;
       k1yetc.t0nivc = peBase.peNivc;
       k1yetc.t0nctw = peNctw;
       k1yetc.t0rama = peRama;

       //prima Auto
       if allparms;
         setll %kds( k1yetc : 6 ) ctwetc01;
         reade(n) %kds( k1yetc : 6 ) ctwetc01;
       else;
         setll %kds( k1yetc : 7 ) ctwetc01;
         reade(n) %kds( k1yetc : 7 ) ctwetc01;
       endif;

       dow not %eof ( ctwetc01 );

         @@prim += t0prim;

         if allparms;
           reade(n) %kds( k1yetc : 6 ) ctwetc01;
         else;
           k1yer0.r0arse = peArse;
           reade(n) %kds( k1yetc : 7 ) ctwetc01;
         endif;

       enddo;

       //prima Hogar
       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;

       setll %kds( k1yer0 : 6 ) ctwer001;
       reade(n) %kds( k1yer0 : 6 ) ctwer001;

       dow not %eof ( ctwer001 );

         @@prim += r0prim;

         reade(n) %kds( k1yer0 : 6 ) ctwer001;
       enddo;

       //prima vida
       setll %kds( k1yer0 : 6 ) ctwevc;
       reade(n) %kds( k1yer0 : 6 ) ctwevc;

       dow not %eof ( );

         @@prim += v0prim;

         reade(n) %kds( k1yer0 : 6 ) ctwevc;
       enddo;

       // Sepelio
       setll %kds( k1yer0 : 6 ) ctwse1;
       reade(n) %kds( k1yer0 : 6 ) ctwse1;
       dow not %eof ( );
         @@prim += e1ptco;
         reade(n) %kds( k1yer0 : 6 ) ctwse1;
       enddo;

       return @@prim;

      /end-free

     P COWGRAI_getPrimaRamaArse...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_SavePrimasPorProvincia:Importes por provincias       *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro Componente                        *
      *     peProI   (input)   Provincia Inder                       *
      *     peSuas   (input)   Suma Asegurada                        *
      *     peSast   (input)   Suma asegurada Siniestrada            *
      *     pePrim   (input)   Prima                                 *
      *     pePrem   (input)   Premio                                *
      *                                                              *
      * -------------------------------------------------------------*
     P COWGRAI_SavePrimasPorProvincia...
     P                 B                   export
     D COWGRAI_SavePrimasPorProvincia...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peProI                       2  0 const
     D   peSuas                      15  2 const
     D   peSast                      15  2 const
     D   pePrim                      15  2 const
     D   pePrem                      15  2 const

     D   k1yeg3        ds                  likerec( c1weg3 : *key )
     D   k1y000        ds                  likerec( c1w000 : *key )
     D   k1y001        ds                  likerec( c1w001 : *key )
     D   k1y002        ds                  likerec( c1w002 : *key )

     D   p@dere        s                   like( w1dere ) inz
     D   p@refi        s             15  2
     D   p@seri        s                   like( w2seri ) inz
     D   p@seem        s                   like( w2seem ) inz
     D   p@ipr1        s                   like( w2ipr1 ) inz
     D   p@ipr3        s                   like( w2ipr3 ) inz
     D   p@ipr4        s                   like( w2ipr4 ) inz
     D   p@ipr6        s                   like( w2ipr6 ) inz
     D   p@ipr7        s                   like( w2ipr7 ) inz
     D   p@ipr8        s                   like( w2ipr8 ) inz

      /free

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain %kds( k1y000 : 5 ) ctw000;

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain(n) %kds( k1y001 ) ctw001;
       if %found ( ctw001 );

        p@dere = w1dere;
        p@refi = ( ( pePrim * w1xref ) / 100 );

       else;

        p@dere = *zeros;
        p@refi = *zeros;

       endif;

       k1y002.w2empr = peBase.peEmpr;
       k1y002.w2sucu = peBase.peSucu;
       k1y002.w2nivt = peBase.peNivt;
       k1y002.w2nivc = peBase.peNivc;
       k1y002.w2nctw = peNctw;
       k1y002.w2rama = peRama;
       k1y002.w2arse = peArse;
       k1y002.w2poco = pePoco;
       chain %kds( k1y002 ) ctw002;
       if %found( ctw002 );

        p@seri = w2seri;
        p@seem = w2seem;
        p@ipr1 = w2ipr1;
        p@ipr3 = w2ipr3;
        p@ipr4 = w2ipr4;
        p@ipr6 = w2ipr6;
        p@ipr7 = w2ipr7;
        p@ipr8 = w2ipr8;

       else;

        p@seri = *zeros;
        p@seem = *zeros;
        p@ipr1 = *zeros;
        p@ipr3 = *zeros;
        p@ipr4 = *zeros;
        p@ipr6 = *zeros;
        p@ipr7 = *zeros;
        p@ipr8 = *zeros;

       endif;

       k1yeg3.g3empr = peBase.peEmpr;
       k1yeg3.g3sucu = peBase.peSucu;
       k1yeg3.g3nivt = peBase.peNivt;
       k1yeg3.g3nivc = peBase.peNivc;
       k1yeg3.g3nctw = peNctw;
       k1yeg3.g3rama = peRama;
       k1yeg3.g3arse = peArse;
       k1yeg3.g3rpro = peProI;
       chain %kds( k1yeg3 ) ctweg3;
       if %found ( ctweg3 );

        g3suas += peSuas;
        g3sast += peSast;
        g3prim += pePrim;
        g3refi += p@refi;
        g3seri += p@seri;
        g3seem += p@seem;
        g3ipr1 += p@ipr1;
        g3ipr3 += p@ipr3;
        g3ipr4 += p@ipr4;
        g3ipr6 += p@ipr6;
        g3ipr7 += p@ipr7;
        g3ipr8 += p@ipr8;
        g3prem += pePrem;

        update c1weg3;

       else;

        clear c1weg3;
        g3empr = peBase.peEmpr;
        g3sucu = peBase.peSucu;
        g3nivt = peBase.peNivt;
        g3nivc = peBase.peNivc;
        g3nctw = peNctw;
        g3rama = peRama;
        g3arse = peArse;
        g3rpro = peProI;
        g3mone = COWGRAI_monedaCotizacion( peBase
                                         : peNctw );
        g3come = w0come;
        g3suas = peSuas;
        g3sast = peSast;
        g3prim = pePrim;
        g3refi = p@refi;
        g3dere = p@dere;
        g3seri = p@seri;
        g3seem = p@seem;
        g3ipr1 = p@ipr1;
        g3ipr3 = p@ipr3;
        g3ipr4 = p@ipr4;
        g3ipr6 = p@ipr6;
        g3ipr7 = p@ipr7;
        g3ipr8 = p@ipr8;
        g3prem = pePrem;

        write c1weg3;

       endif;

      /end-free

     P COWGRAI_SavePrimasPorProvincia...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_DeletePrimasPorProvincia:Importes por provincias     *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro Componente                        *
      *     peProI   (input)   Provincia Inder                       *
      *     peSuas   (input)   Suma Asegurada                        *
      *     peSast   (input)   Suma asegurada Siniestrada            *
      *     pePrim   (input)   Prima                                 *
      *     pePrem   (input)   Premio                                *
      *                                                              *
      * -------------------------------------------------------------*
     P COWGRAI_DeletePrimasPorProvincia...
     P                 B                   export
     D COWGRAI_DeletePrimasPorProvincia...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peProI                       2  0 const
     D   peSuas                      15  2 const
     D   peSast                      15  2 const
     D   pePrim                      15  2 const
     D   pePrem                      15  2 const

     D   k1yeg3        ds                  likerec( c1weg3 : *key )
     D   k1y001        ds                  likerec( c1w001 : *key )
     D   k1y002        ds                  likerec( c1w002 : *key )

     D   p@dere        s                   like( w1dere ) inz
     D   p@refi        s             15  2
     D   p@seri        s                   like( w2seri ) inz
     D   p@seem        s                   like( w2seem ) inz
     D   p@ipr1        s                   like( w2ipr1 ) inz
     D   p@ipr3        s                   like( w2ipr3 ) inz
     D   p@ipr4        s                   like( w2ipr4 ) inz
     D   p@ipr6        s                   like( w2ipr6 ) inz
     D   p@ipr7        s                   like( w2ipr7 ) inz
     D   p@ipr8        s                   like( w2ipr8 ) inz

      /free

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain(n) %kds( k1y001 ) ctw001;
       if %found ( ctw001 );

        p@dere = w1dere;
        p@refi = ( ( pePrim * w1xref ) / 100 );

       else;

        p@dere = *zeros;
        p@refi = *zeros;

       endif;

       k1y002.w2empr = peBase.peEmpr;
       k1y002.w2sucu = peBase.peSucu;
       k1y002.w2nivt = peBase.peNivt;
       k1y002.w2nivc = peBase.peNivc;
       k1y002.w2nctw = peNctw;
       k1y002.w2rama = peRama;
       k1y002.w2arse = peArse;
       k1y002.w2poco = pePoco;
       chain %kds( k1y002 ) ctw002;
       if %found( ctw002 );

        p@seri = w2seri;
        p@seem = w2seem;
        p@ipr1 = w2ipr1;
        p@ipr3 = w2ipr3;
        p@ipr4 = w2ipr4;
        p@ipr6 = w2ipr6;
        p@ipr7 = w2ipr7;
        p@ipr8 = w2ipr8;

       else;

        p@seri = *zeros;
        p@seem = *zeros;
        p@ipr1 = *zeros;
        p@ipr3 = *zeros;
        p@ipr4 = *zeros;
        p@ipr6 = *zeros;
        p@ipr7 = *zeros;
        p@ipr8 = *zeros;

       endif;

       k1yeg3.g3empr = peBase.peEmpr;
       k1yeg3.g3sucu = peBase.peSucu;
       k1yeg3.g3nivt = peBase.peNivt;
       k1yeg3.g3nivc = peBase.peNivc;
       k1yeg3.g3nctw = peNctw;
       k1yeg3.g3rama = peRama;
       k1yeg3.g3arse = peArse;
       k1yeg3.g3rpro = peProI;
       chain %kds( k1yeg3 ) ctweg3;
       if %found ( ctweg3 );

        g3suas -= peSuas;
        g3sast -= peSast;
        g3prim -= pePrim;
        g3refi -= p@refi;
        g3dere -= p@dere;
        g3seri -= p@seri;
        g3seem -= p@seem;
        g3ipr1 -= p@ipr1;
        g3ipr3 -= p@ipr3;
        g3ipr4 -= p@ipr4;
        g3ipr6 -= p@ipr6;
        g3ipr7 -= p@ipr7;
        g3ipr8 -= p@ipr8;
        g3prem -= pePrem;
        if g3suas = *zeros;
         delete c1weg3;
        else;
         update c1weg3;
        endif;
       endif;

      /end-free

     P COWGRAI_DeletePrimasPorProvincia...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_GetCopoCops: Obtiene Codigo Postal y Sufijo          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de cotización                  *
      *     peCopo   (output)  Código Postal                         *
      *     peCops   (output)  Sufijo Código Postal                  *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWGRAI_GetCopoCops...
     P                 B                   export
     D COWGRAI_GetCopoCops...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   pecopo                       5  0
     D   pecops                       1  0

     D   k1y000        ds                  likerec( c1w000 : *key )

      /free

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );

         peCopo = w0copo;
         peCops = w0cops;

       else;

         peCopo = *zeros;
         peCops = *zeros;

       endif;

       return;

      /end-free

     P COWGRAI_GetCopoCops...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getPrimaSPoliza () : retorna prima por SuperPoliza   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * -------------------------------------------------------------*
     P COWGRAI_getPrimaSPoliza...
     P                 B                   export
     D COWGRAI_getPrimaSPoliza...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1y001        ds                  likerec( c1w001  : *key )
     D   @@prim        s             15  2

      /free

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;

       setll %kds( k1y001 : 5 ) ctw001;
       reade(n) %kds( k1y001 : 5 ) ctw001;

       dow not %eof ( ctw001 );

         @@prim += COWGRAI_getPrimaRamaArse ( peBase :
                                              peNctw :
                                              w1rama );

         reade(n) %kds( k1y001 : 5 ) ctw001;
       enddo;

       return @@prim;

      /end-free

     P COWGRAI_getPrimaSPoliza...
     P                 E

      * -----------------------------------------------------------------*
      * COWGRAI_tipoOper() Tipo de Operacion                             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     P COWGRAI_tipoOper...
     P                 B                   export
     D COWGRAI_tipoOper...
     D                 pi             1  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         return w0tiou;

       endif;

      /end-free

     P COWGRAI_tipoOper...
     P                 E

      * -----------------------------------------------------------------*
      * COWGRAI_setDerechoEmi() Retorna Derecho de Emision               *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                pePrim  -  Prima                                  *
      *                                                                  *
      * --------------------------------------------------------------   *
     P COWGRAI_setDerechoEmi...
     P                 B                   export
     D COWGRAI_setDerechoEmi...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   pePrim                      15  2 const

     D k1y001          ds                  likerec(c1w001:*key)
     D k1y000          ds                  likerec(c1w000:*key)
     D k1yet0          ds                  likerec(c1wet0:*key)
     D k1y122          ds                  likerec(s1t122:*key)
     D k1y611          ds                  likerec(s1t611:*key)
     D k1y6118         ds                  likerec(s1t6118:*key)
     D k1y621          ds                  likerec(s1t621:*key)

     D @@arcd          s              6  0

     D @1dere          s             15  2
     D @@dere          s             15  2
     D @@vacc          s             15  2
     D @@tvcc          s              1a
     D @@facc          s              1a
     D @@xdia          s              5  0
     D @@tien          s               n
     D @@endp          s              3a   inz ( '   ' )
     D @@rama          s              2  0
     D @@niv6          s              1  0 inz ( 6 )

     D @@d             s              2  0
     D @@m             s              2  0
     D @@a             s              4  0
     D @@fech          s              8  0

     D @@empr          s              1a
     D @@sucu          s              2a
     D @@nivt          s              1  0
     D @@nivc          s              5  0
     D @@cade          s              5  0 dim(9)
     D @@erro          s              1n

       COWGRAI_inz();

       @@arcd = COWGRAI_getArticulo( peBase : peNctw );

       chain @@arcd set630;

       if t4ma26 = '0';

         k1y621.t3arcd = @@arcd;
         k1y621.t3rama = peRama;
         k1y621.t3arse = 1;
         chain %kds( k1y621 ) set621;

         k1y611.t1plac = t3plac;
         k1y611.t1mone = COWGRAI_monedaCotizacion( peBase : peNctw );

         chain %kds( k1y611 : 2 ) set611;

         if %found( set611 );

           @@dere = t1dere;

         else;

           @@dere = *Zeros;

         endif;

       else;

         k1y6118.t2empr = peBase.peEmpr;
         k1y6118.t2sucu = peBase.pesucu;
         k1y6118.t2nivt = peBase.peNivt;
         k1y6118.t2nivc = peBase.peNivc;
         k1y6118.t2rama = peRama;

         chain %kds( k1y6118 ) set6118;

         if %found( set6118 );

           if ( t2marp = 'T' );

             k1y122.t@rama = peRama;
             k1y122.t@arcd = @@arcd;
             k1y122.t@mone = COWGRAI_monedaCotizacion( peBase : peNctw );
             k1y122.t@tiou = COWGRAI_tipoOper( peBase : peNctw );

             chain %kds( k1y122 ) set122;

             if %found ( set122 );

               select;
                 when ( pePrim < t@tpr1 );
                   @@dere = t@dem1;
                 when ( pePrim < t@tpr2 );
                   @@dere = t@dem2;
                 when ( pePrim < t@tpr3 );
                   @@dere = t@dem3;
                 when ( pePrim < t@tpr4 );
                   @@dere = t@dem4;
                 when ( pePrim < t@tpr5 );
                   @@dere = t@dem5;
               endsl;

             else;

               @@dere = t2dere;

             endif;

           else;

             @@dere = t2dere;

           endif;

           if ( t2mar1 <> ' ' );

             k1yet0.t0empr = peBase.peEmpr;
             k1yet0.t0sucu = peBase.pesucu;
             k1yet0.t0nivt = peBase.peNivt;
             k1yet0.t0nivc = peBase.peNivc;
             k1yet0.t0nctw = peNctw;
             k1yet0.t0rama = peRama;
             chain(n) %kds ( k1yet0 : 6 ) ctwet0;

             setll t2mar1 set638;
             reade t2mar1 set638;

             dow not %eof ( set638 );

               if t@scta = t0scta;

                 @@dere += ( @@dere * t@dere ) / 100;
                 leave;

               endif;

               reade t2mar1 set638;

             enddo;

           endif;

         else;

           @@dere = *Zeros;

         endif;

       endif;

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.pesucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain %kds ( k1y000 ) ctw000;

       PAR310X3 ( peBase.peEmpr : @@a : @@m : @@d );

       @@fech = (@@a * 10000) + (@@m * 100) + @@d;

       @@rama = peRama;

       @@empr = peBase.peEmpr;
       @@sucu = peBase.peSucu;
       @@nivt = peBase.peNivt;
       @@nivc = peBase.peNivc;

       SPCADCOM ( @@empr
                : @@sucu
                : @@nivt
                : @@nivc
                : @@cade
                : @@erro
                : @@endp );


       SPEXCODE( w0empr : w0sucu : @@niv6 : @@cade( 6 ) : @@rama : w0tiou
               : w0stou : @@fech : @@endp : @@tien : @@vacc : @@tvcc
               : @@facc : @@xdia : @1dere);

       if @@tien;
         if w0come <> *Zeros;
           @@vacc = @1dere/w0come;
           @1dere = @1dere/w0come;
           else;
           @@vacc = @1dere*1;
           @1dere = @1dere*1;
         endif;
        @@dere = @@dere + @1dere;
       endif;

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain %kds ( k1y001 : 6 ) ctw001;

       w1dere = @@dere;
       w1vacc = @@vacc;
       update c1w001;

       return *On;

      /end-free

     P COWGRAI_setDerechoEmi...
     P                 E

      * -----------------------------------------------------------------*
      * COWGRAI_setPercepcion() Graba el Derecho de Emisión              *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                pePrim  -  Prima                                  *
      *                                                                  *
      * --------------------------------------------------------------   *
     P COWGRAI_setPercepcion...
     P                 B                   export
     D COWGRAI_setPercepcion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peSuma                      15  2 const
     D   pePrim                      15  2 const

     D k1y001          ds                  likerec(c1w001:*key)
     D k1yet0          ds                  likerec(c1wet0:*key)
     D k1y122          ds                  likerec(s1t122:*key)
     D k1y611          ds                  likerec(s1t611:*key)
     D k1y6118         ds                  likerec(s1t6118:*key)
     D k1y621          ds                  likerec(s1t621:*key)

     D @@arcd          s              6  0

     D @@dere          s             15  2
     D p@prim          s             15  2
     D p@Mone          s              2
     D @@copo          s              5  0
     D @@cops          s              1  0
     D p@Rpro          s              2  0

       COWGRAI_inz();

       eval(h) p@Prim = COWGRAI_GetPrimaSubtot ( peBase :
                                                 peNctw :
                                                 peRama :
                                                 pePrim );

       p@mone = COWGRAI_monedaCotizacion(peBase :
                                        peNctw) ;

       COWGRAI_GetCopoCops ( peBase : peNctw : @@copo : @@cops );

       p@Rpro = COWGRAI_GetCodProInd ( @@Copo : @@Cops );

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain %kds ( k1y001 : 6 ) ctw001;

       w1Ipr6 =
       COWGRAI_GetCalculoPercepcion( p@Rpro :
                                     peRama :
                                     p@Mone :
                                     COWGRAI_cotizaMoneda ( p@Mone :
                                                  %dec(%date:*iso)):
                                     p@Prim :
                                     peSuma :
                                     COWGRAI_getCodigoIva ( peBase:
                                                            peNctw):
                                     w1ipr1 :
                                     w1ipr3 :
                                     w1ipr4 );

       update c1w001;

       return *On;

      /end-free

     P COWGRAI_setPercepcion...
     P                 E
      * -----------------------------------------------------------------*
      * COWGRAI_getPremioFinal() Retorna el Premio Final                 *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     P COWGRAI_getPremioFinal...
     P                 B                   export
     D COWGRAI_getPremioFinal...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)
     D k1y001          ds                  likerec(c1w001:*key)
     D k1yet0          ds                  likerec(c1wet0:*key)
     D k1yer0          ds                  likerec(c1wer0:*key)
     D k1yeg3          ds                  likerec(c1weg3:*key)

     D @@dere          s             15  2
     D @@refi          s             15  2
     D @@suma          s             15  2
     D @@subt          s             15  2
     D @@prim          s             15  2
     D @@prem          s             15  2
     D @@impu          s             15  2

     D @@impi          s             15  2
     D @@sers          s             15  2
     D @@tssn          s             15  2
     D @@ipr1          s             15  2
     D @@ipr2          s             15  2
     D @@ipr3          s             15  2
     D @@ipr4          s             15  2
     D @@ipr5          s             15  2
     D @@ipr6          s             15  2
     D @@ipr7          s             15  2
     D @@ipr8          s             15  2
     D @@ipr9          s             15  2
     D @@seri          s             15  2 inz
     D @@seem          s             15  2 inz

     D @@rama          s              2  0
     D @@cant          s             10i 0
     D cero            s             15  2 inz (0)
     D cero96          s              9  6 inz (0)
     D p@Tiso          s              2  0
     D @@form          s              1    inz('A')
     D @@copo          s              5  0 inz
     D @@cops          s              1  0 inz
     D @@ImpEg3        ds                  likeds( ImpEg3 )

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds ( k1y000 ) ctw000;

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;

       if w0tipe = 'F';
         p@Tiso = 98;
       else;
         p@Tiso = 1;
       endif;

       if SVPEMP_getLocalidadDeEmpresa( peBase.peEmpr
                                      : @@copo
                                      : @@cops         );
       endif;

       setll %kds ( k1y001 : 5 ) ctw001;
       reade(n) %kds ( k1y001 : 5 ) ctw001;

       dow not %eof ( ctw001 );

         @@rama = w1rama;

         @@prim = COWGRAI_getPrimaRamaArse ( peBase : peNctw : w1rama : 1 );

         @@suma = COWGRAI_getSumaAseguradaRamaArse ( peBase : peNctw
                                                   : w1rama : 1 );

         @@dere = COWGRAI_GetDerechoEmision ( peBase : peNctw : w1rama );

         @@subt = COWGRAI_GetPrimaSubtot ( peBase : peNctw : w1rama
                                         : @@prim : @@form );

         COWGRAI_setImpConcComer ( peBase : peNctw : w1rama : @@prim );

         w1xref = COWGRAI_getXref( peBase : peNctw : w1rama );

         @@refi = ( ( @@prim * w1xref ) / 100 );
         @@impi = ( ( @@subt * w1pimi ) / 100 );
         @@sers = ( ( @@subt * w1psso ) / 100 );
         @@tssn = ( ( @@subt * w1pssn ) / 100 );

         @@ipr1 = COWGRAI_GetImporteIins ( peBase :
                                           peNctw :
                                           w1rama :
                                           @@subt );

         @@ipr3 = COWGRAI_GetImporteInoi ( peBase :
                                           peNctw :
                                           w1rama :
                                           @@subt );

         @@ipr4 = COWGRAI_GetImporteIres ( peBase :
                                           peNctw :
                                           w1rama :
                                           @@subt );
         clear @@ipr2;
         clear @@ipr5;
         clear @@ipr6;
         clear @@ipr7;
         clear @@ipr8;
         clear @@ipr9;
         clear @@prem;

         // En 1er instancia se graban Impuetos Calculados con totales...
         COWGRAI_setImportesImpuestos ( peBase : peNctw : w1rama : @@refi
                                      : @@dere : @@impi : @@sers : @@tssn
                                      : @@ipr1 : @@ipr2 : @@ipr3 : @@ipr4
                                      : @@ipr5 : @@ipr6 : @@ipr7 : @@ipr8
                                      : @@ipr9 : @@prem );

         reade(n) %kds ( k1y001 : 5 ) ctw001;

         if ( @@rama <> w1rama ) or %eof ( ctw001 );

           COWGRAI_dltEg3 ( peBase : peNctw : @@rama : 1 );

           COWGRAI_setCabeceraEg3 ( peBase : peNctw : @@rama : 1 );

           @@cant = COWGRAI_getCantProvIn ( peBase : peNctw : g3rama );

           // Calcula los campos de impuestos excepto el premio.
           COWGRAI_updEg3 ( peBase : peNctw : @@rama : 1 : @@cant );

           // Retorna Total y resto de impuestos para calcular Premio...
           clear @@ImpEg3;
           if COWGRAI_GetImpuestosTotalesEg3( peBase
                                            : peNctw
                                            : @@rama
                                            : 1
                                            : @@ImpEg3 );
           endif;

           @@prem = @@subt + @@impi + @@sers +  @@tssn
                  + @@ipr1 + @@ipr4 + @@ipr3 +  @@ImpEg3.ipr6
                  + @@ImpEg3.seri   + @@ImpEg3.seem;

           // Actualiza impuestos definitivos...
           COWGRAI_setImportesImpuestos ( peBase : peNctw : w1rama : @@refi
                                        : @@dere : @@impi : @@sers : @@tssn
                                        : @@ipr1 : @@ipr2 : @@ipr3 : @@ipr4
                                        : @@ipr5 : @@ImpEg3.ipr6   : @@ipr7
                                        : @@ipr8 : @@ipr9 : @@prem );


           // Actualiza Sellados Definitivos...
           COWGRAI_setSellados ( peBase
                               : peNctw
                               : w1rama
                               : @@ImpEg3.seri
                               : @@ImpEg3.seem );

           COWGRAI_setAjustaPremio( peBase
                                  : peNctw
                                  : w1rama
                                  : 1       );

           COWGRAI_setExtraComision( peBase : peNctw : w1rama );

           // se acomoda para siguiente lectura...
           k1y001.w1empr = peBase.peEmpr;
           k1y001.w1sucu = peBase.peSucu;
           k1y001.w1nivt = peBase.peNivt;
           k1y001.w1nivc = peBase.peNivc;
           k1y001.w1nctw = peNctw;
           k1y001.w1rama = @@rama;

           chain(n) %kds ( k1y001 : 6 ) ctw001;

         endif;

         reade(n) %kds ( k1y001 : 5 ) ctw001;

       enddo;

       COWGRAI_updTablaDeImpuestos( peBase : peNctw );


       return *on;

      /end-free

     P COWGRAI_getPremioFinal...
     P                 E

      * -----------------------------------------------------------------*
      * COWGRAI_getCantProvIn() Cantidad de Registros en EG3             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     P COWGRAI_getCantProvIn...
     P                 B                   export
     D COWGRAI_getCantProvIn...
     D                 pi            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

     D k1yeg3          ds                  likerec(c1weg3:*key)

     D cant            s             10i 0

       COWGRAI_inz();

       cant = *Zeros;

       k1yeg3.g3empr = peBase.peEmpr;
       k1yeg3.g3sucu = peBase.peSucu;
       k1yeg3.g3nivt = peBase.peNivt;
       k1yeg3.g3nivc = peBase.peNivc;
       k1yeg3.g3nctw = peNctw;
       k1yeg3.g3rama = peRama;

       setll %kds ( k1yeg3 : 6 ) ctweg3;
       reade(n) %kds ( k1yeg3 : 6 ) ctweg3;

       dow not %eof ( ctweg3 );

         cant += 1;

         reade(n) %kds ( k1yeg3 : 6 ) ctweg3;

       enddo;

       return cant;

      /end-free

     P COWGRAI_getCantProvIn...
     P                 E

      * -----------------------------------------------------------------*
      * COWGRAI_getPrimaIn() Retorna Prima por Inder                     *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     P COWGRAI_getPrimaIn...
     P                 B                   export
     D COWGRAI_getPrimaIn...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peRpro                       2  0 const

     D k1yet0          ds                  likerec(c1wet0:*key)
     D k1yetc          ds                  likerec(c1wetc01:*key)
     D k1yer0          ds                  likerec(c1wer0:*key)
     D k1yer2          ds                  likerec(c1wer2:*key)

     D prima           s             15  2

       COWGRAI_inz();

       prima = *Zeros;

       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.peNivt;
       k1yet0.t0nivc = peBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;

       setll %kds ( k1yet0 : 6 ) ctwet0;
       reade(n) %kds ( k1yet0 : 6 ) ctwet0;

       dow not %eof ( ctwet0 );

         if ( peRpro = COWGRAI_GetCodProInd ( t0copo : t0cops ) );

           k1yetc.t0empr = peBase.peEmpr;
           k1yetc.t0sucu = peBase.peSucu;
           k1yetc.t0nivt = peBase.peNivt;
           k1yetc.t0nivc = peBase.peNivc;
           k1yetc.t0nctw = peNctw;
           k1yetc.t0rama = peRama;
           k1yetc.t0arse = t0arse;
           k1yetc.t0poco = t0poco;

           chain(n) %kds ( k1yetc : 8 ) ctwetc01;

           prima += t0prim;

         endif;

         reade(n) %kds ( k1yet0 : 6 ) ctwet0;

       enddo;

       setll %kds ( k1yet0 : 6 ) ctwevc;
       reade(n) %kds ( k1yet0 : 6 ) ctwevc;
       dow not %eof ( ctwevc );
           prima += v0prim;
        reade(n) %kds ( k1yet0 : 6 ) ctwevc;
       enddo;

       setll %kds ( k1yet0 : 6 ) ctwse1;
       reade(n) %kds ( k1yet0 : 6 ) ctwse1;
       dow not %eof ( ctwse1 );
           prima += e1ptco;
        reade(n) %kds ( k1yet0 : 6 ) ctwse1;
       enddo;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;

       setll %kds ( k1yer0 : 6 ) ctwer0;
       reade(n) %kds ( k1yer0 : 6 ) ctwer0;

       dow not %eof ( ctwer0 );

         if ( peRpro = r0rpro );

           k1yer2.r2empr = peBase.peEmpr;
           k1yer2.r2sucu = peBase.peSucu;
           k1yer2.r2nivt = peBase.peNivt;
           k1yer2.r2nivc = peBase.peNivc;
           k1yer2.r2nctw = peNctw;
           k1yer2.r2rama = peRama;
           k1yer2.r2arse = r0arse;
           k1yer2.r2poco = r0poco;

           setll %kds ( k1yer2 : 8 ) ctwer2;
           reade(n) %kds ( k1yer2 : 8 ) ctwer2;

           dow not %eof ( ctwer2 );

             prima += r2ptco;

             reade(n) %kds ( k1yer2 : 8 ) ctwer2;

           enddo;

         endif;

         reade(n) %kds ( k1yer0 : 6 ) ctwer0;

       enddo;

       return prima;

      /end-free

     P COWGRAI_getPrimaIn...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_setImportesImpuestos(): Graba los importes de Impuestos  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *      peImpi (input)  Impuestos Internos                          *
      *      peSers (input)  Servicios Sociales                          *
      *      peTssn (input)  Tasa SSN                                    *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr2 (input)  Acciones                                    *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peIpr5 (input)  Recargo de Capital                          *
      *      peIpr6 (input)  Componente Premio 6                         *
      *      peIpr7 (input)  Ing.Brutos Riesgo                           *
      *      peIpr8 (input)  Ing.Brutos Empresa                          *
      *      peIpr9 (input)                                              *
      *      pePrem (input)                                              *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_setImportesImpuestos...
     P                 B                   export
     D COWGRAI_setImportesImpuestos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   peIpr9                      15  2 const
     D   pePrem                      15  2 const

     D k1y001          ds                  likerec(c1w001:*key)

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain %kds ( k1y001 ) ctw001;

       w1refi = peRefi;
       w1dere = peDere;
       w1impi = peImpi;
       w1sers = peSers;
       w1tssn = peTssn;
       w1ipr1 = peIpr1;
       w1ipr2 = peIpr2;
       w1ipr3 = peIpr3;
       w1ipr4 = peIpr4;
       w1ipr5 = peIpr5;
       w1ipr6 = peIpr6;
       w1ipr7 = peIpr7;
       w1ipr8 = peIpr8;
       w1ipr9 = peIpr9;
       w1prem = pePrem;

       update c1w001;

       return *On;

      /end-free

     P COWGRAI_setImportesImpuestos...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_dltEg3(): Elimina los registros CTWEG3                   *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peArse (input)  Arse                                        *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_dltEg3...
     P                 B                   export
     D COWGRAI_dltEg3...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1yeg3          ds                  likerec(c1weg3:*key)

       COWGRAI_inz();

       k1yeg3.g3empr = peBase.peEmpr;
       k1yeg3.g3sucu = peBase.peSucu;
       k1yeg3.g3nivt = peBase.peNivt;
       k1yeg3.g3nivc = peBase.peNivc;
       k1yeg3.g3nctw = peNctw;
       k1yeg3.g3rama = peRama;
       k1yeg3.g3arse = peArse;

       setll %kds ( k1yeg3 : 7 ) ctweg3;
       reade %kds ( k1yeg3 : 7 ) ctweg3;

       dow not %eof ( ctweg3 );

         delete c1weg3;
         reade %kds ( k1yeg3 : 7 ) ctweg3;

       enddo;

       return *On;

     P COWGRAI_dltEg3...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_setCabeceraEg3(): Graba Cabecera CTWEG3                  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peArse (input)  Arse                                        *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_setCabeceraEg3...
     P                 B                   export
     D COWGRAI_setCabeceraEg3...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1y000          ds                  likerec(c1w000:*key)
     D k1yeg3          ds                  likerec(c1weg3:*key)
     D k1yet0          ds                  likerec(c1wet0:*key)
     D k1yer0          ds                  likerec(c1wer0:*key)
     D k1yevc          ds                  likerec(c1wevc:*key)

     D @@copo          s              5  0
     D @@cops          s              1  0

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds ( k1y000 ) ctw000;

       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.peNivt;
       k1yet0.t0nivc = peBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;

       setll %kds ( k1yet0 : 6 ) ctwet0;
       reade(n) %kds ( k1yet0 : 6 ) ctwet0;

       dow not %eof ( ctwet0 );

         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;
         k1yeg3.g3rama = t0rama;
         k1yeg3.g3arse = t0arse;
         k1yeg3.g3rpro = COWGRAI_GetCodProInd ( t0copo : t0cops );

         setll %kds ( k1yeg3 ) ctweg3;

         if not %equal ( ctweg3 );

           clear  c1weg3;
           g3empr  = peBase.peEmpr;
           g3sucu  = peBase.peSucu;
           g3nivt  = peBase.peNivt;
           g3nivc  = peBase.peNivc;
           g3nctw  = peNctw;
           g3rama  = peRama;
           g3arse  = 1;
           COWGRAI_GetCopoCops ( peBase : peNctw : @@copo : @@cops );
           g3rpro  = COWGRAI_GetCodProInd ( @@copo : @@cops );
           g3mone  = w0mone;
           g3come  = w0come;
           g3suas  = COWGRAI_getSumaAseguradaRamaArse ( peBase : peNctw
                                                      : g3rama : 1 );
           g3saca  = *Zeros;
           g3sacr  = *Zeros;
           g3sast = COWGRAI_getSumaAsSiniRamaArse ( peBase : peNctw
                                                  : g3rama : 1 );
           g3read  = *Zeros;
           g3mar1  = *Blanks;
           g3mar2  = *Blanks;
           g3mar3  = *Blanks;
           g3mar4  = *Blanks;
           g3mar5  = *Blanks;
           g3strg  = *Blanks;
           g3sefe  = *Zeros;
           g3sefr  = *Zeros;

           write c1weg3;

         endif;

         reade(n) %kds ( k1yet0 : 6 ) ctwet0;

       enddo;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;

       setll %kds ( k1yer0 : 6 ) ctwer0;
       reade(n) %kds ( k1yer0 : 6 ) ctwer0;

       dow not %eof ( ctwer0 );

         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;
         k1yeg3.g3rama = peRama;
         k1yeg3.g3arse = r0arse;
         k1yeg3.g3rpro = COWGRAI_GetCodProInd ( r0copo : r0cops );

         setll %kds ( k1yeg3 ) ctweg3;

         if not %equal ( ctweg3 );

           clear  c1weg3;
           g3empr  = peBase.peEmpr;
           g3sucu  = peBase.peSucu;
           g3nivt  = peBase.peNivt;
           g3nivc  = peBase.peNivc;
           g3nctw  = peNctw;
           g3rama  = peRama;
           g3arse  = 1;
           g3rpro  = COWGRAI_GetCodProInd ( r0copo : r0cops );
           g3mone  = w0mone;
           g3come  = w0come;
           g3suas  = COWGRAI_getSumaAseguradaRamaArse ( peBase : peNctw
                                                      : g3rama : 1 );
           g3saca  = *Zeros;
           g3sacr  = *Zeros;
           g3sast = COWGRAI_getSumaAsSiniRamaArse ( peBase : peNctw
                                                      : g3rama : 1 );
           g3read  = *Zeros;
           g3mar1  = *Blanks;
           g3mar2  = *Blanks;
           g3mar3  = *Blanks;
           g3mar4  = *Blanks;
           g3mar5  = *Blanks;
           g3strg  = *Blanks;
           g3sefe  = *Zeros;
           g3sefr  = *Zeros;

           write c1weg3;

         endif;

         reade(n) %kds ( k1yer0 : 6 ) ctwer0;

       enddo;

       //Vida
       k1yevc.v0empr = peBase.peEmpr;
       k1yevc.v0sucu = peBase.peSucu;
       k1yevc.v0nivt = peBase.peNivt;
       k1yevc.v0nivc = peBase.peNivc;
       k1yevc.v0nctw = peNctw;
       k1yevc.v0rama = peRama;

       setll %kds ( k1yevc : 6 ) ctwevc;
       reade(n) %kds ( k1yevc : 6 ) ctwevc;
       dow not %eof ( ctwevc );

         clear  c1weg3;
         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;
         k1yeg3.g3rama = peRama;
         k1yeg3.g3arse = v0arse;
         k1yeg3.g3rpro = COWGRAI_GetCodProInd ( w0copo : w0cops );

         setll %kds ( k1yeg3 ) ctweg3;

         if not %equal ( ctweg3 );

           g3empr = peBase.peEmpr;
           g3sucu = peBase.peSucu;
           g3nivt = peBase.peNivt;
           g3nivc = peBase.peNivc;
           g3nctw = peNctw;
           g3rama = peRama;
           g3arse = 1;
           g3rpro = COWGRAI_GetCodProInd ( w0copo : w0cops );
           g3mone = w0mone;
           g3come = w0come;
           g3suas = COWGRAI_getSumaAseguradaRamaArse ( peBase : peNctw
                                                     : g3rama : 1 );
           g3saca = *Zeros;
           g3sacr = *Zeros;
           g3sast = COWGRAI_getSumaAsSiniRamaArse ( peBase : peNctw
                                                  : g3rama : 1 );
           g3read = *Zeros;
           g3mar1 = *Blanks;
           g3mar2 = *Blanks;
           g3mar3 = *Blanks;
           g3mar4 = *Blanks;
           g3mar5 = *Blanks;
           g3strg = *Blanks;
           g3sefe = *Zeros;
           g3sefr = *Zeros;

           write c1weg3;

         endif;

         reade(n) %kds ( k1yevc : 6 ) ctwevc;

       enddo;

       // Sepelio
       setll %kds ( k1yevc : 6 ) ctwse1;
       reade(n) %kds ( k1yevc : 6 ) ctwse1;
       dow not %eof ( ctwse1 );

         clear  c1weg3;
         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;
         k1yeg3.g3rama = peRama;
         k1yeg3.g3arse = e1arse;
         k1yeg3.g3rpro = COWGRAI_GetCodProInd ( w0copo : w0cops );

         setll %kds ( k1yeg3 ) ctweg3;

         if not %equal ( ctweg3 );

           g3empr = peBase.peEmpr;
           g3sucu = peBase.peSucu;
           g3nivt = peBase.peNivt;
           g3nivc = peBase.peNivc;
           g3nctw = peNctw;
           g3rama = peRama;
           g3arse = 1;
           g3rpro = COWGRAI_GetCodProInd ( w0copo : w0cops );
           g3mone = w0mone;
           g3come = w0come;
           g3suas = COWGRAI_getSumaAseguradaRamaArse ( peBase : peNctw
                                                     : g3rama : 1 );
           g3saca = *Zeros;
           g3sacr = *Zeros;
           g3sast = COWGRAI_getSumaAsSiniRamaArse ( peBase : peNctw
                                                  : g3rama : 1 );
           g3read = *Zeros;
           g3mar1 = *Blanks;
           g3mar2 = *Blanks;
           g3mar3 = *Blanks;
           g3mar4 = *Blanks;
           g3mar5 = *Blanks;
           g3strg = *Blanks;
           g3sefe = *Zeros;
           g3sefr = *Zeros;

           write c1weg3;

         endif;

         reade(n) %kds ( k1yevc : 6 ) ctwse1;

       enddo;


       return *On;

     P COWGRAI_setCabeceraEg3...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_updEg3(): Actualiza los registros CTWEG3                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peArse (input)  Arse                                        *
      *      peCant (input)  Cantidad en Inder                           *
      *                                                                  *
      * Retorna *on/*off                                                 *
      * ---------------------------------------------------------------- *
     P COWGRAI_updEg3...
     P                 B                   export
     D COWGRAI_updEg3...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCant                      10i 0 const

     D k1y000          ds                  likerec(c1w000 :*key)
     D k1y001          ds                  likerec(c1w001 :*key)
     D k1yeg3          ds                  likerec(c1weg3 :*key)
     D K1y001c         ds                  likerec(c1w001c:*key)

     D cero            s             15  2
     D cero96          s              9  6
     D @@rama          s              2  0 inz
     D @@tiso          s              2  0 inz
     D @@suma          s             15  2 inz
     D @@epv           s              5  2 inz
     D @@com           s              5  2 inz
     D @@subt          s             15  2 inz
     D @@subtT         s             15  2 inz
     D @@subtA         s             15  2 inz
     D @@imfo          s             15  2
     D @@copo          s              5  0 inz
     D @@cops          s              1  0 inz
     D @@impi          s             15  2 inz
     D @@sers          s             15  2 inz
     D @@tssn          s             15  2 inz
     D @@primero       s               n   inz
     D @@porc          s              5  2 inz
     D @@rest          s              5  2 inz
     D @@prim          s             15  2 inz
     D @@refi          s             15  2 inz
     D @@read          s             15  2 inz
     D @@dife          s             15  2 inz
     D @@primT         s             15  2 inz
     D @@porc1         s              9  6
     D @@form          s              1    inz('A')
     D @@ipr6          s             15  2 inz
     D @@dere          s             15  2 inz

       COWGRAI_inz();

       cero96 = *Zeros;
       cero = *Zeros;
       @@primero = *on;
       clear @@primT;
       clear @@refi;
       clear @@read;
       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds ( k1y000 ) ctw000;
         if not %found( ctw000 );
           return *off;
         endif;

       if ( w0tipe = 'F' );
         @@tiso = 98;
       else;
         @@tiso = 1;
       endif;

       //  Localida de Empresa - HDI...
       if SVPEMP_getLocalidadDeEmpresa( peBase.peEmpr
                                      : @@copo
                                      : @@cops         );
       endif;
       //Prima ...
       @@prim =  COWGRAI_getPrimaRamaArse ( peBase
                                          : peNctw
                                          : w1rama
                                          : 1      );
       @@subtT = COWGRAI_GetPrimaSubtot( peBase
                                       : peNctw
                                       : peRama
                                       : @@prim
                                       : @@form );

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain(n) %kds ( k1y001 ) ctw001;
         if not %found( ctw001 );
           return *off;
         endif;

       k1y001c.w1empr = peBase.peEmpr;
       k1y001c.w1sucu = peBase.peSucu;
       k1y001c.w1nivt = peBase.peNivt;
       k1y001c.w1nivc = peBase.peNivc;
       k1y001c.w1nctw = peNctw;
       k1y001c.w1rama = peRama;
       chain(n) %kds ( K1y001c : 6 ) ctw001c;
         if not %found( ctw001c );
           return *off;
         endif;

        k1yeg3.g3empr = peBase.peEmpr;
        k1yeg3.g3sucu = peBase.peSucu;
        k1yeg3.g3nivt = peBase.peNivt;
        k1yeg3.g3nivc = peBase.peNivc;
        k1yeg3.g3nctw = peNctw;
        k1yeg3.g3rama = peRama;
        k1yeg3.g3arse = peArse;

        setll %kds ( k1yeg3 : 7 ) ctweg3;
        if not %equal( ctweg3 );
          return *off;
        endif;
        reade %kds ( k1yeg3 : 7 ) ctweg3;
        dow not %eof ( ctweg3 );

          g3prim = COWGRAI_getPrimaIn ( peBase
                                      : peNctw
                                      : g3rama
                                      : g3rpro );
          @@primT+= g3prim;

          @@suma = COWGRAI_getSumaAseguradaPorvInd ( peBase
                                                   : peNctw
                                                   : g3rama
                                                   : g3rpro );
          g3refi = ( g3prim * w1xref ) / 100;
          g3read = ( g3Prim * w1xrea ) / 100;
          @@refi+= g3refi;
          @@read+= g3read;

          update c1weg3;

         reade %kds ( k1yeg3 : 7 ) ctweg3;
        enddo;

        k1yeg3.g3empr = peBase.peEmpr;
        k1yeg3.g3sucu = peBase.peSucu;
        k1yeg3.g3nivt = peBase.peNivt;
        k1yeg3.g3nivc = peBase.peNivc;
        k1yeg3.g3nctw = peNctw;
        k1yeg3.g3rama = peRama;
        k1yeg3.g3arse = peArse;
        setll %kds ( k1yeg3 : 7 ) ctweg3;
        reade %kds ( k1yeg3 : 7 ) ctweg3;
          dow not %eof ( ctweg3 );
            @@rama = g3rama;
            g3prim = COWGRAI_getPrimaIn ( peBase
                                        : peNctw
                                        : g3rama
                                        : g3rpro );
            g3dere = w1dere / peCant;
            if @@primero;
               @@subtA = ( g3prim - g3bpri ) + g3dere + g3refi + g3read;
               @@dife  = @@prim - @@primt;
               g3prim += @@dife;
               //Derecho de Emision...
               @@dere  = g3dere * peCant;
               g3dere += w1dere - @@dere;
               //Recargo administrativo...
               @@dife  = w1read - @@read;
               g3read += @@dife;
               //Recargo financiero...
               @@dife  = w1refi - @@refi;
               g3refi += @@dife;

               @@primero = *off;
            endif;

              @@subt = ( g3prim - g3bpri ) + g3dere + g3refi + g3read;

             // se obtiene Ipr1-Ipr3-Ipr4-Ipr6...
             @@porc1 = ( g3prim / @@prim ) * 100;
             g3ipr6 = COWGRAI_GetCalculoPercepcion( g3rpro
                                                  : peRama
                                                  : w0mone
                                                  : w0come
                                                  : @@subt
                                                  : @@suma
                                                  : w0civa
                                                  : w1ipr1
                                                  : w1ipr3
                                                  : w1ipr4
                                                  : *omit
                                                  : *omit
                                                  : @@porc1
                                                  : g3ipr1
                                                  : g3ipr3
                                                  : g3ipr4  );
             @@ipr6+= g3ipr6;
             g3mar1 = '0';
             g3mar2 = '0';
             g3mar3 = '0';
             g3mar4 = '0';
             g3mar5 = '0';

             update c1weg3;

          reade %kds ( k1yeg3 : 7 ) ctweg3;

          enddo;

        @@primero = *on;
        k1yeg3.g3empr = peBase.peEmpr;
        k1yeg3.g3sucu = peBase.peSucu;
        k1yeg3.g3nivt = peBase.peNivt;
        k1yeg3.g3nivc = peBase.peNivc;
        k1yeg3.g3nctw = peNctw;
        k1yeg3.g3rama = peRama;
        k1yeg3.g3arse = peArse;
        setll %kds ( k1yeg3 : 7 ) ctweg3;
        reade %kds ( k1yeg3 : 7 ) ctweg3;
          dow not %eof ( ctweg3 );
            @@rama = g3rama;

            if @@primero;
              @@subt = @@subtA;
              @@primero = *off;
            else;
              clear @@subt;
              @@subt = ( g3prim - g3bpri ) + g3dere + g3refi + g3read;
            endif;

             @@porc1 = ( g3prim / @@prim ) * 100;
             clear @@imfo;
             g3seri = COWGRAI_GetSelladosprovinciales ( g3rpro
                                                      : @@rama
                                                      : w0mone
                                                      : w0come
                                                      : g3prim
                                                      : cero
                                                      : g3read
                                                      : g3refi
                                                      : g3dere
                                                      : @@subt
                                                      : @@suma
                                                      : w1impi
                                                      : w1sers
                                                      : w1tssn
                                                      : w1ipr1
                                                      : cero
                                                      : w1ipr3
                                                      : w1ipr4
                                                      : cero
                                                      : @@ipr6
                                                      : w1ipr7
                                                      : w1ipr8
                                                      : @@porc1
                                                      : cero96
                                                      : @@tiso
                                                      : @@imfo );
             g3sefr = @@imfo;
             clear @@imfo;
             @@rama = g3rama;
             g3seem =
             COWGRAI_GetSelladodelaEmpresa ( COWGRAI_GetCodProInd ( @@copo
                                                                  : @@cops  )
                                            : @@rama
                                            : w0mone
                                            : w0come
                                            : g3prim
                                            : cero
                                            : g3read
                                            : g3refi
                                            : g3dere
                                            : @@subt
                                            : @@suma
                                            : w1impi
                                            : w1sers
                                            : w1tssn
                                            : w1ipr1
                                            : cero
                                            : w1ipr3
                                            : w1ipr4
                                            : cero
                                            : @@ipr6
                                            : w1ipr7
                                            : w1ipr8
                                            : @@porc1
                                            : cero96
                                            : @@tiso
                                            : @@imfo );
             g3sefe = @@imfo;

             update c1weg3;

          reade %kds ( k1yeg3 : 7 ) ctweg3;

          enddo;

       return *On;

     P COWGRAI_updEg3...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_UpdPremio() Actualiza Premio                             *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peSubt (input)  Subtotal                                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_updPremio...
     P                 B                   export
     D COWGRAI_updPremio...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSubt                      15  2 const

     D k1y001          ds                  likerec(c1w001:*key)
     D k1yeg3          ds                  likerec(c1weg3:*key)

     D @@sefr          s             15  2
     D @@sefe          s             15  2
     D @@subt          s             15  2
     D @@impi          s             15  2
     D @@sers          s             15  2
     D @@tssn          s             15  2

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;

       setll %kds ( k1y001 : 5 ) ctw001;
       reade %kds ( k1y001 : 5 ) ctw001;

       dow not %eof ( ctw001 );

         clear @@sefr;
         clear @@sefe;
         clear w1seri;
         clear w1seem;

         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;
         k1yeg3.g3rama = w1rama;

         setll %kds ( k1yeg3 : 6 ) ctweg3;
         reade %kds ( k1yeg3 : 6 ) ctweg3;

         dow not %eof ( ctweg3 );

           w1seri += g3seri;
           w1seem += g3seem;

           reade %kds ( k1yeg3 : 6 ) ctweg3;

         enddo;

         w1prem += w1seri + w1seem;

         update c1w001;

         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;
         k1yeg3.g3rama = w1rama;

         setll %kds ( k1yeg3 : 6 ) ctweg3;
         reade %kds ( k1yeg3 : 6 ) ctweg3;

         dow not %eof ( ctweg3 );

           clear @@impi;
           clear @@sers;
           clear @@tssn;
           clear @@subt;
           @@subt = ( g3prim - g3bpri ) + g3dere + g3refi + g3read;
           @@impi = ( ( @@subt * w1pimi ) / 100 );
           @@sers = ( ( @@subt * w1psso ) / 100 );
           @@tssn = ( ( @@subt * w1pssn ) / 100 );
           g3prem = @@subt + @@impi + @@sers + @@tssn
                  + g3ipr1 + g3ipr4 + g3ipr3 + g3seem
                  + g3seri + g3sefr + g3sefe + g3ipr6;

           update c1weg3;

           reade %kds ( k1yeg3 : 6 ) ctweg3;

         enddo;

         reade %kds ( k1y001 : 5 ) ctw001;

       enddo;

       return *On;

     P COWGRAI_updPremio...
     P                 E
      * -----------------------------------------------------------------*
      * COWGRAI_getSuperPoliza(): Obtiene Numero de SuperPoliza de una   *
      *                           cotización.                            *
      *                                                                  *
      *     peBase   (input)   Parametro Base                            *
      *     peNctw   (input)   Número de Cotizacion                      *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_getSuperPoliza...
     P                 B                   export
     D COWGRAI_getSuperPoliza...
     D                 pi             9  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

     D
      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;
       if %found();

         return w0spol;

       endif;

       return 0;

      /end-free

     P COWGRAI_getSuperPoliza...
     P                 E
      * -----------------------------------------------------------------*
      * COWGRAI_getTipodeOperacion(): devuelve el tipo de operacion de   *
      *                               la cotización                      *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peTiou  -  Tipo de Operación                      *
      *                peStou  -  SubTipo de Operación de Usuario        *
      *                peStos  -  SubTipo de Operación de Sistema        *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_getTipodeOperacion...
     P                 B                   export
     D COWGRAI_getTipodeOperacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTiou                       1  0
     D   peStou                       2  0
     D   peStos                       2  0

     D k1y000          ds                  likerec(c1w000:*key)

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );

         peTiou = w0tiou;
         peStou = w0stou;
         peStos = w0stos;

         return *on;

       endif;

       return *off;

      /end-free

     P COWGRAI_getTipodeOperacion...
     P                 E

      * -----------------------------------------------------------------*
      * COWGRAI_sumaDeAccesorios(): Devuelve suma de los accesorios por  *
      *                             componente                           *
      *        Input :                                                   *
      *                                                                  *
      *                peCobl  -  Cobertura                              *
      *                peVhan  -  Año del Vehículo                       *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_sumaDeAccesorios...
     P                 B                   export
     D COWGRAI_sumaDeAccesorios...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D k1yet1          ds                  likerec(c1wet1:*key)
     D Sumacc          S             15  2

       COWGRAI_inz();

       k1yet1.t1empr = PeBase.peEmpr;
       k1yet1.t1sucu = PeBase.peSucu;
       k1yet1.t1nivt = PeBase.peNivt;
       k1yet1.t1nivc = PeBase.peNivc;
       k1yet1.t1nctw = peNctw;
       k1yet1.t1rama = peRama;
       k1yet1.t1poco = pePoco;
       k1yet1.t1arse = peArse;

       sumacc = 0;


       setll %kds( k1yet1 : 8 ) ctwet1;
       reade %kds( k1yet1 : 8 ) ctwet1;
       dow not %eof;

         sumacc += t1accv;

       reade %kds( k1yet1 : 8 ) ctwet1;
       enddo;

       return sumacc;

      /end-free

     P COWGRAI_sumaDeAccesorios...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_SumaInfoPro  : devuelve la suma asegurada que corresponde*
      *                        de infopro.                               *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peArcd  -  código de Artículo                     *
      *                peVhmc  -  marca del vehiculo                     *
      *                pevhmo  -  codigo de modelo                       *
      *                pevhcs  -  codigo de submodelo                    *
      *                pevhcr  -  codigo de carroceria                   *
      *                pevhan  -  año del vehiculo                       *
      *                pevhvu  -  Suma Asegurada                         *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_SumaInfoPro...
     P                 B                   export
     D COWGRAI_SumaInfoPro...
     D                 pi            15  2
     D   peArcd                       6  0 const
     D   peVhmc                       3    const
     D   pevhmo                       3    const
     D   pevhcs                       3    const
     D   pevhcr                       3    const
     D   pevhan                       4  0 const
     D   pevhvu                      15  2 const

     D k1y207          ds                  likerec(s1t207:*key)

      /free

       COWGRAI_inz();

       k1y207.t@Vhmc = peVhmc;
       k1y207.t@vhmo = pevhmo;
       k1y207.t@vhcs = pevhcs;
       k1y207.t@vhcr = pevhcr;
       k1y207.t@vhaÑ = pevhan;

       chain %kds( k1y207 : 5) set207;
       if %found();

         return t@vhvu;

       else;

         chain ( peArcd ) set6303;
         if %found();

           return  (pevhvu * ( 1 + t@3prsa ));

         endif;

       endif;

       return *zeros;

      /end-free

     P COWGRAI_SumaInfoPro...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_bloqueoProd(): Verifica que el productor no este bloquea-*
      *                        do para el tipo de operación.             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peTiou  -  Tipo de Operación                      *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_bloqueoProd...
     P                 B                   export
     D COWGRAI_bloqueoProd...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peTiou                       1  0   const

     D k1yni2          ds                  likerec(s1hni2:*key)

      /free

       COWGRAI_inz();

       k1yni2.n2empr = PeBase.peEmpr;
       k1yni2.n2sucu = PeBase.peSucu;
       k1yni2.n2nivt = PeBase.peNivt;
       k1yni2.n2nivc = PeBase.peNivc;

       chain(n) %kds ( k1yni2 : 4 ) s1hni2;
       if %found();

         if %char(peTiou) <= n2Bloq;

           return *off;

         endif;

       endif;

       return *on;

      /end-free

     P COWGRAI_bloqueoProd...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAseguradaCobertura():retorna la suma suma ase-*
      *                                     gurada de la cobertura.  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro de Componente                     *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getSumaAseguradaCobertura...
     P                 B                   export
     D COWGRAI_getSumaAseguradaCobertura...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

     D k1yer2          ds                  likerec(c1wer2:*key)
     D @@suas          s             15  2

     D
      /free

       COWGRAI_inz();

       @@suas = *Zeros;

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = peRiec;
       k1yer2.r2xcob = peXcob;

       setll %kds( k1yer2 ) ctwer2;
       reade %kds( k1yer2 ) ctwer2;
       dow not %eof ( ctwer2 );

         @@suas += r2saco;

         reade %kds( k1yer2 ) ctwer2;
       enddo;

       return @@suas;

      /end-free

     P COWGRAI_getSumaAseguradaCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAsegAsegurados(): retorna la suma sum ase-    *
      *                                 gurada que se ha cargado     *
      *                                 para los asegurados          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro de Componente                     *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getSumaAsegAsegurados...
     P                 B                   export
     D COWGRAI_getSumaAsegAsegurados...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

     D k1yer1          ds                  likerec(c1wer1:*key)
     D @@suas          s             15  2

     D
      /free

       COWGRAI_inz();

       @@suas = *Zeros;

       k1yer1.r1empr = peBase.peEmpr;
       k1yer1.r1sucu = peBase.peSucu;
       k1yer1.r1nivt = peBase.peNivt;
       k1yer1.r1nivc = peBase.peNivc;
       k1yer1.r1nctw = peNctw;
       k1yer1.r1rama = peRama;
       k1yer1.r1arse = peArse;
       k1yer1.r1poco = pePoco;
       k1yer1.r1riec = peRiec;
       k1yer1.r1xcob = peXcob;

       setll %kds( k1yer1 : 10 ) ctwer1;
       reade %kds( k1yer1 : 10 ) ctwer1;
       dow not %eof ( ctwer1 );

         @@suas += r1suas;

         reade %kds( k1yer1 : 10 ) ctwer1;
       enddo;

       return @@suas;

      /end-free

     P COWGRAI_getSumaAsegAsegurados...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getDatosCapituloHogar ():retorna la clasificación    *
      *                                 del riesgo.                  *
      * ******************** Deprecated **************************** *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peXpro   (input)   Plan                                  *
      *     peCtar   (output)  capitulo de tarifa                    *
      *     peCta1   (output)  capitulo tarifa inciso 1              *
      *     peCeta   (output)  capitulo tarifa sistema               *
      *     peCagr   (output)  agravaciones de Riesgos               *
      *                                                              *
      * ------------------------------------------------------------ *

     P COWGRAI_getDatosCapituloHogar...
     P                 B                   export
     D COWGRAI_getDatosCapituloHogar...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peCtar                       4  0
     D   peCta1                       2
     D   peCeta                       4
     D   peCagr                       2  0

      /free

       COWGRAI_inz();

       return COWGRAI_getDatosCapituloRGV( peRama
                                         : peXpro
                                         : peCtar
                                         : peCta1
                                         : peCeta
                                         : peCagr );

      /end-free

     P COWGRAI_getDatosCapituloHogar...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_chkPadron():Verificar si el asegurado tiene algun    *
      *                     padron.                                  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Nro Cotización                        *
      *     peRama   (input)   Rama                                  *
      *     peSuma   (input)   Suma Asegurada                        *
      *     pePrim   (input)   Prima                                 *
      *     peCuit   (input)   Nro de Cuit                           *
      *     peAsen   (input)   Nro de Asegurado                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWGRAI_chkPadron...
     P                 B                   export
     D COWGRAI_chkPadron...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peSuma                      15  2 const
     D   pePrim                      15  2 const
     D   peCuit                      11    const
     D   peAsen                       7  0 const

     D k1y001          ds                  likerec(c1w001:*key)
     D @@Ipr6          s             15  2
     D p@Mone          s              2
     D p@Porc          s              9  6
     D p@Asen          s              7  0
     D p@Cuit          s             11
     D p@prim          s             15  2
     D p@Rpro          s              2  0
     D p@Cmon          s             15  6
     D @@copo          s              5  0
     D @@cops          s              1  0
     D @@Cuit          s             11
     D @@Asen          s              7  0

     D
      /free

       COWGRAI_inz();
       @@Cuit = peCuit;
       @@Asen = peAsen;


       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain %kds( k1y001 ) ctw001;
       if %found();

         eval(h) p@Prim = COWGRAI_GetPrimaSubtot ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   pePrim );

         p@mone = COWGRAI_monedaCotizacion(peBase : peNctw) ;

         COWGRAI_GetCopoCops ( peBase : peNctw : @@copo : @@cops );

         p@Rpro = COWGRAI_GetCodProInd ( @@Copo : @@Cops );

         p@Porc = 100;

         @@Ipr6 =
         COWGRAI_GetCalculoPercepcion( p@Rpro :
                                       peRama :
                                       p@Mone :
                                       COWGRAI_cotizaMoneda ( p@Mone :
                                                    %dec(%date:*iso)):
                                       p@Prim :
                                       peSuma :
                                       COWGRAI_getCodigoIva ( peBase:
                                                              peNctw):
                                       w1ipr1 :
                                       w1ipr3 :
                                       w1ipr4 :
                                       @@Cuit :
                                       @@Asen );

         return *off;

         if @@Ipr6 <> w1Ipr6 ;
           return *off;
         endif;

       endif;

       return *on;



      /end-free

     P COWGRAI_chkPadron...
     P                 E
      * --------------------------------------------------------------*
      * COWGRAI_formaDePagoCot():Valida forma de Pago de la cotización*
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peCfpg   (input)   Forma de Pago                          *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P COWGRAI_formaDePagoCot...
     P                 b                   export
     D COWGRAI_formaDePagoCot...
     D                 pi              n
     D
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCfpg                       1  0 const
     D
     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );

         if w0cfpg <> peCfpg;

           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P COWGRAI_formaDePagoCot...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getFormaDePagoPdP(): Obtiene Forma de Pago desde un  *
      *                              Plan de Pagos.                  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peArcd   (input)   Código de Artículo                    *
      *     peNrpp   (input)   Número de Plan de Pagos               *
      *     peCfpg   (output)  Forma de Pago                         *
      *                                                              *
      * Retorna: *on si OK, *OFF si no.                              *
      * ------------------------------------------------------------ *
     P COWGRAI_getFormaDePagoPdP...
     P                 B                   Export
     D COWGRAI_getFormaDePagoPdP...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peArcd                       6  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0

     D k1t60802        ds                  likerec(s1t608:*key)

      /free

       COWGRAI_inz();

       k1t60802.t8arcd = peArcd;
       k1t60802.t8Nrpp = peNrpp;

       setll %kds( k1t60802 : 2 ) set60802;
       if not %equal ( set60802 );
          return *off;
       endif;

       chain %kds( k1t60802 : 2 ) set60802;
       if %found();
         peCfpg = t8cfpg;
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_getFormaDePagoPdP...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getFormaDePagoCot(): Obtiene la forma de pago de la  *
      *                              cabecera de la cotización       *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: *on si OK, *OFF si no.                              *
      * ------------------------------------------------------------ *
     P COWGRAI_getFormaDePagoCot...
     P                 B                   Export
     D COWGRAI_getFormaDePagoCot...
     D                 pi             3  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain %kds( k1y000 : 5 ) ctw000;
       if %found();

         return w0nrpp;

       endif;

       return *Zeros;

      /end-free

     P COWGRAI_getFormaDePagoCot...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_updFormaDePagoCot(): Actualiza forma de pago en la   *
      *                              cabecera de la cotización       *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peNrpp   (input)   Plan de Pago                          *
      *                                                              *
      * Retorna: *on si OK, *OFF si no.                              *
      * ------------------------------------------------------------ *
     P COWGRAI_updFormaDePagoCot...
     P                 B                   Export
     D COWGRAI_updFormaDePagoCot...
     D                 pi             1n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const

     D k1y000          ds                  likerec(c1w000:*key)
     D k1y001          ds                  likerec(c1w001:*key)

     D x               s             10i 0

     D @@cfpg          s              1  0

      /free

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;

       COWGRAI_getFormaDePagoPdP( peBase
                                : peNctw
                                : COWGRAI_getArticulo ( peBase :
                                                        peNctw )
                                : peNrpp
                                : @@cfpg );

       chain %kds ( k1y000 ) ctw000;

       if %found ( ctw000 );

         w0nrpp = peNrpp;
         w0cfpg = @@cfpg;

         w0defp = getDescPago( w0cfpg );

         update c1w000;

       endif;

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;

       setll %kds ( k1y001 : 5 ) ctw001;
       reade %kds ( k1y001 : 5 ) ctw001;

       dow not %eof ( ctw001 );

         w1xref = COWGRAI_getXref ( peBase : peNctw : w1rama );
         w1refi = ( ( COWGRAI_getPrimaRamaArse ( peBase : peNctw : w1rama : 1 )
                  * w1xref ) / 100 ) ;
         update c1w001;

         reade %kds ( k1y001 : 5 ) ctw001;

       enddo;

       return *On;

      /end-free

     P COWGRAI_updFormaDePagoCot...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_getCondComerciales() Retorna condiciones comerciales     *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Epv                                          *
      *      peCopr (output)Comision                                     *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     P COWGRAI_getCondComerciales...
     P                 B                   export
     D COWGRAI_getCondComerciales...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2
     D   peXopr                       5  2

     D k1y6118         ds                  likerec(s1t6118:*key)

       COWGRAI_inz();

       k1y6118.t2empr = peBase.peEmpr;
       k1y6118.t2sucu = peBase.pesucu;
       k1y6118.t2nivt = peBase.peNivt;
       k1y6118.t2nivc = peBase.peNivc;
       k1y6118.t2rama = peRama;
       chain %kds( k1y6118 ) set6118;

       if %found( set6118 );
         peXrea = t2xrea;
         peXopr = t2pdn1;
       else;
         peXrea = *Zeros;
         peXopr = *Zeros;
       endif;

       return *On;

     P COWGRAI_getCondComerciales...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_getCondComercialesA() Retorna condiciones comerciales    *
      *                               desde archivo CTW001               *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Epv                                          *
      *      peCopr (output)Comision                                     *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     P COWGRAI_getCondComercialesA...
     P                 B                   export
     D COWGRAI_getCondComercialesA...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2
     D   peXopr                       5  2

     D k1y001          ds                  likerec(c1w001c:*key)

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain(n) %kds( k1y001 ) ctw001c;

       if %found ( ctw001c );

         peXrea = w1xrea;
         peXopr = w1xopr;

       else;

         peXrea = *Zeros;
         peXopr = *Zeros;

       endif;

       return *On;

     P COWGRAI_getCondComercialesA...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_setImpConcComer() Graba condiciones comerciales          *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      pePrim (output)Prima                                        *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     P COWGRAI_setImpConcComer...
     P                 B                   export
     D COWGRAI_setImpConcComer...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const

     D k1y001c         ds                  likerec(c1w001c:*key)

       COWGRAI_inz();

       k1y001c.w1empr = peBase.peEmpr;
       k1y001c.w1sucu = peBase.pesucu;
       k1y001c.w1nivt = peBase.peNivt;
       k1y001c.w1nivc = peBase.peNivc;
       k1y001c.w1nctw = peNctw;
       k1y001c.w1rama = peRama;
       chain %kds( k1y001c ) ctw001c;

       if %found( ctw001c );

         w1read = ( ( pePrim * w1xrea ) / 100 );
         w1copr = ( ( pePrim * w1xopr ) / 100 );

         update c1w001c;

       endif;

       return *On;

     P COWGRAI_setImpConcComer...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_getRead() Retorna Read                                   *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ------------------------------------------------------------ *
     P COWGRAI_getRead...
     P                 B                   export
     D COWGRAI_getRead...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const

     D k1y001c         ds                  likerec(c1w001c:*key)

       COWGRAI_inz();

       k1y001c.w1empr = peBase.peEmpr;
       k1y001c.w1sucu = peBase.pesucu;
       k1y001c.w1nivt = peBase.peNivt;
       k1y001c.w1nivc = peBase.peNivc;
       k1y001c.w1nctw = peNctw;
       k1y001c.w1rama = peRama;
       chain %kds( k1y001c ) ctw001c;

       return w1read;

     P COWGRAI_getRead...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteSecuAct() Elimina por Secuencia y Actividad    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                peActi  -  Actividad                          *
      *                peSecu  -  Secuencia                          *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteSecuAct...
     P                 B                   export
     D COWGRAI_deleteSecuAct...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

     D k1yev1          ds                  likerec(c1wev1:*key)

      /free

       COWGRAI_inz();

       k1yev1.v1empr = PeBase.peEmpr;
       k1yev1.v1sucu = PeBase.peSucu;
       k1yev1.v1nivt = PeBase.peNivt;
       k1yev1.v1nivc = PeBase.peNivc;
       k1yev1.v1nctw = peNctw;
       k1yev1.v1Rama = peRama;
       k1yev1.v1Arse = peArse;
       k1yev1.v1acti = peActi;
       k1yev1.v1secu = peSecu;

       setll %kds ( k1yev1 : 9 ) ctwev101;
       reade %kds ( k1yev1 : 9 ) ctwev101;
       dow not %eof;

         COWGRAI_deleteCoberturas( peBase : peNctw : peRama : peArse : v1Poco );

         delete c1wev1;

         reade %kds ( k1yev1 : 9 ) ctwev101;
       enddo;

       COWGRAI_deleteCategoria ( peBase :
                                 peNctw :
                                 peRama :
                                 peArse :
                                 peActi :
                                 peSecu );

       return *on;

      /end-free

     P COWGRAI_deleteSecuAct...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCategoria:Elimina archivo de categorias        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                peActi  -  Actividad                          *
      *                peSecu  -  Secuencia                          *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteCategoria...
     P                 B                   export
     D COWGRAI_deleteCategoria...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

     D   k1yevc        ds                  likerec( c1wevc  : *key )

      /free

       COWGRAI_inz();

       k1yevc.v0empr = peBase.peEmpr;
       k1yevc.v0sucu = peBase.peSucu;
       k1yevc.v0nivt = peBase.penivt;
       k1yevc.v0nivc = peBase.penivc;
       k1yevc.v0nctw = peNctw;
       k1yevc.v0rama = peRama;
       k1yevc.v0arse = peArse;
       k1yevc.v0Acti = peActi;
       k1yevc.v0Secu = peSecu;

       setll %kds ( k1yevc : 9 ) ctwevc;
       reade %kds ( k1yevc : 9 ) ctwevc;
       dow not %eof();

         delete c1wevc;

         reade %kds ( k1yevc : 9 ) ctwevc;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteCategoria...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getCategoria(): Obtiene la forma de pago de la       *
      *                         cabecera de la cotización            *
      *                                                              *
      *     peCact   (input)   Código de actividad                   *
      *                                                              *
      * Retorna: Codigo de Categoría                                 *
      * ------------------------------------------------------------ *
     P COWGRAI_getCategoria...
     P                 B                   Export
     D COWGRAI_getCategoria...
     D                 pi             2  0
     D   peCact                       5  0 const

     D k1y021          ds                  likerec(s1t021:*key)

      /free

       COWGRAI_inz();

       k1y021.t@Cact = PeCact;

       chain %kds( k1y021 : 1 ) set021;
       if %found();

         return t@cate;

       endif;

       return *zeros;

      /end-free

     P COWGRAI_getCategoria...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_ValPlanCerradoUnico(): Valida que plan cerrado tengo un  *
      *                                único compronente                 *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Artículo                                     *
      *      pePoco (input) Nro. de Componente                           *
      *      peXpro (input) Plan                                         *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ------------------------------------------------------------ *
     P COWGRAI_ValPlanCerradoUnico...
     P                 B                   export
     D COWGRAI_ValPlanCerradoUnico...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const

     D   es_cerrado    s               n
     D   k1y100        ds                  likerec( s1t100 : *key )
     D   k1yer0        ds                  likerec( c1wer0 : *key )

      /free

       COWGRAI_inz();

       es_cerrado = *off;

       k1y100.t9rama = peRama;
       k1y100.t9xpro = peXpro;
       k1y100.t9mone = COWGRAI_monedaCotizacion( peBase
                                               : peNctw);
       chain(n) %kds( k1y100 ) set100;
         if ( t9prem <> *Zeros );
           es_cerrado = *on;
         endif;

       k1yer0.r0empr = PeBase.peEmpr;
       k1yer0.r0sucu = PeBase.peSucu;
       k1yer0.r0nivt = PeBase.peNivt;
       k1yer0.r0nivc = PeBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       setll %kds( k1yer0 : 6 ) ctwer0;
       reade(n) %kds( k1yer0 : 6 ) ctwer0;
         dow not %eof( ctwer0 );

           if r0poco <> pePoco;
             if es_cerrado;
               SetError( COWGRAI_PLANCP
                 : 'Cotizacion con planes ' );
                return *off;
             endif;

             k1y100.t9rama = peRama;
             k1y100.t9xpro = r0xpro;
             k1y100.t9mone = COWGRAI_monedaCotizacion( peBase
                                                     : peNctw);
             chain(n) %kds( k1y100 ) set100;
               if ( t9prem <> *Zeros );
               SetError( COWGRAI_PLANCE
                 : 'Cotizacion con plan Cerrado ');
                return *off;
               endif;
          endif;
          reade %kds( k1yer0 : 6 ) ctwer0;
         enddo;

         return *on;
      /end-free

     P COWGRAI_ValPlanCerradoUnico...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWGRAI_inz     B                   export
     D COWGRAI_inz     pi

      /free

       if (initialized);
          return;
       endif;

       Local.empr = 'A';
       out Local;

       if not %open(set699);
          open set699;
       endif;

       if not %open(set620);
          open set620;
       endif;

       if not %open(set915);
          open set915;
       endif;

       if not %open(ctw000);
          open ctw000;
       endif;

       if not %open(ctw001);
          open ctw001;
       endif;

       if not %open(ctw001c);
          open ctw001c;
       endif;

       if not %open(ctw002);
          open ctw002;
       endif;

       if not %open(ctw003);
          open ctw003;
       endif;

       if not %open(ctw004);
          open ctw004;
       endif;

       if not %open(ctwer0);
          open ctwer0;
       endif;

       if not %open(ctwer1);
          open ctwer1;
       endif;

       if not %open(ctwer001);
          open ctwer001;
       endif;

       if not %open(ctwer2);
          open ctwer2;
       endif;

       if not %open(ctwer4);
          open ctwer4;
       endif;

       if not %open(ctwet0);
          open ctwet0;
       endif;

       if not %open(ctwet001);
          open ctwet001;
       endif;

       if not %open(ctwetc);
          open ctwetc;
       endif;

       if not %open(ctwse1);
          open ctwse1;
       endif;

       if not %open(ctwetc01);
         open ctwetc01;
       endif;

       if not %open(ctwtim);
          open ctwtim;
       endif;

       if not %open(ctwet4);
          open ctwet4;
       endif;

       if not %open(pahed0);
          open pahed0;
       endif;

       if not %open(set611);
          open set611;
       endif;

       if not %open(set6118);
          open set6118;
       endif;

       if not %open(set621);
          open set621;
       endif;

       if not %open(set630);
          open set630;
       endif;

       if not %open(set638);
          open set638;
       endif;

       if not %open(set100);
          open set100;
       endif;

       if not %open(set122);
          open set122;
       endif;

       if not %open(set123);
          open set123;
       endif;

       if not %open(gntloc);
          open gntloc;
       endif;

       if not %open(gntpro);
          open gntpro;
       endif;

       if not %open(gntcmo);
          open gntcmo;
       endif;

       if not %open(set121);
          open set121;
       endif;

       if not %open(ctweg3);
          open ctweg3;
       endif;

       if not %open(set250);
          open set250;
       endif;

       if not %open(ctwer6);
          open ctwer6;
       endif;

       if not %open(ctwet1);
          open ctwet1;
       endif;

       if not %open(set207);
          open set207;
       endif;

       if not %open(set6303);
          open set6303;
       endif;

       if not %open(sehni2);
          open sehni2;
       endif;

       if not %open(set101);
          open set101;
       endif;

       if not %open(set102);
          open set102;
       endif;

       if not %open(set60802);
          open set60802;
       endif;

       if not %open(set021);
          open set021;
       endif;

       if not %open(ctwev1);
          open ctwev1;
       endif;

       if not %open(ctwev101);
          open ctwev101;
       endif;

       if not %open(ctwev2);
          open ctwev2;
       endif;

       if not %open(ctwevc);
          open ctwevc;
       endif;

       if not %open(gntfpg);
          open gntfpg;
       endif;

       if not %open(gnttc1);
          open gnttc1;
       endif;

       if not %open(ctw00015);
          open ctw00015;
       endif;

       if not %open(ctw00017);
          open ctw00017;
       endif;

       if not %open(pahec3);
          open pahec3;
       endif;

       if not %open(gnttc9);
          open gnttc9;
       endif;

       if not %open(ctw00003);
          open ctw00003;
       endif;

       if not %open(ctw099);
          open ctw099;
       endif;

       if not %open(ctw09901);
          open ctw09901;
       endif;

       if not %open(ctw09902);
          open ctw09902;
       endif;

       initialized = *ON;
       return;

      /end-free

     P COWGRAI_inz     E

      * ------------------------------------------------------------ *
      * COWGRAI_End:  Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWGRAI_End     B                   export
     D COWGRAI_End     pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P COWGRAI_End     E

      * ------------------------------------------------------------ *
      * COWGRAI_Error():Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWGRAI_Error   B                   export
     D COWGRAI_Error   pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P COWGRAI_Error   E

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
      * getDescPago(): Recupera forma de pago.                       *
      *                                                              *
      *     peCfpg   (input)   Código de Forma de Pago.              *
      *                                                              *
      * retorna: Descripción o *all'*'                               *
      * ------------------------------------------------------------ *
     P getDescPago     B
     D getDescPago     pi            20a
     D  peCfpg                        1  0 const

      /free

       chain peCfpg gntfpg;
       if not %found;
          fpdefp = *all'*';
       endif;

       return fpdefp;

      /end-free

     P getDescPago     E

      * ---------------------------------------------------------------- *
      * COWGRAI_getTopesEpv(): Obtiene topes de Extra Prima Variable     *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peRama (input)  Rama                                        *
      *      peEpvm (output) Tope mínimo                                 *
      *      peEpvx (output) Tope máximo                                 *
      *      peErro (output) Código de Error                             *
      *      peMsgs (output) Mensaje de Error                            *
      *                                                                  *
      * ---------------------------------------------------------------  *
     P COWGRAI_getTopesEpv...
     P                 B                   export
     D COWGRAI_getTopesEpv...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peEpvm                       3  0
     D   peEpvx                       3  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@Epvm        s              5  2
     D   @@Epvx        s              5  2
     D   @@repl        s          65535a
      /free

       clear @@Epvm;
       clear @@Epvx;
       clear peErro;
       clear peMsgs;

       if SVPEPV_getlimiteProductor( peBase.peEmpr
                                   : peBase.peSucu
                                   : peBase.peNivt
                                   : peBase.peNivc
                                   : peRama
                                   : @@Epvm
                                   : @@Epvx       ) = -1 ;

         ErrText = SVPEPV_Error(ErrCode);
         select;
         when ErrCode = SVPEPV_RSCC;
           %subst(@@repl:1:2) = %editc( peRama : 'X');
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0170'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;

         when ErrCode = SVPEPV_PRSC;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0171'
                        : peMsgs       );
           peErro = -1;
         return;

         endsl;
       endif;

         peEpvm =  %dec(@@Epvm:3:0);
         peEpvx =  %dec(@@Epvx:3:0);
       return;

      /end-free

     P COWGRAI_getTopesEpv...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_updImpConcComer() Actualiza condiciones comerciales      *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Recargo Administrativo                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     P COWGRAI_updImpConcComer...
     P                 B                   export
     D COWGRAI_updImpConcComer...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2   const

     D k1y001c         ds                  likerec(c1w001c:*key)
     D @@dife          s              5  2

       COWGRAI_inz();

       k1y001c.w1empr = peBase.peEmpr;
       k1y001c.w1sucu = peBase.pesucu;
       k1y001c.w1nivt = peBase.peNivt;
       k1y001c.w1nivc = peBase.peNivc;
       k1y001c.w1nctw = peNctw;
       k1y001c.w1rama = peRama;

       chain %kds( k1y001c ) ctw001c;
       if %found( ctw001c );

         @@dife = w1xrea - peXrea;
         w1xrea = peXrea;
         w1xopr = w1xopr - @@dife;

         update c1w001c;

       endif;

       return *On;

     P COWGRAI_updImpConcComer...
     P                 E

      * ------------------------------------------------------------ *
      * chkDeleteBienAsegurado: Retorna si puede en cotizacion       *
      *                                                              *
      *     peBase   (input)   Parametro Base                        *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P chkDeleteBienAsegurado...
     P                 B
     D chkDeleteBienAsegurado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y000          ds                  likerec(c1w000:*key)

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );
         if w0cest <> 1;
           return *Off;
         endif;
       endif;

       return *On;

     P chkDeleteBienAsegurado...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_cpyCotizacion() Copiar una cotización en una nueva       *
      *                                                                  *
      *      peBase (input)  Parámetro Base                              *
      *      peNctw (input)  Número de Cotización a copiar               *
      *      peNct1 (output) Nuevo Número de Cotización                  *
      *      peErro (output) Indicador de Error                          *
      *      peMsgs (output) Indicador de Error                          *
      *                                                                  *
      * Retorna 0 si OK, -1 si error (verificar con _error() ).          *
      * ---------------------------------------------------------------- *
     P COWGRAI_cpyCotizacion...
     P                 B                   export
     D COWGRAI_cpyCotizacion...
     D                 pi            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNct1                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs) const

        return *Zeros;

     P COWGRAI_cpyCotizacion...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_getSuperPolizaReno(): Recupera SuperPoliza Relacionada   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWGRAI_getSuperPolizaReno...
     P                 B                   export
     D COWGRAI_getSuperPolizaReno...
     D                 pi             9  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const

     D k1y000          ds                  likerec(c1w000:*key)

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );

         return w0spo1;

       endif;

       return *Zeros;

      /end-free

     P COWGRAI_getSuperPolizaReno...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteAccesorios: Elimina caracterizticas del bien   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteAccesorios...
     P                 B                   export
     D COWGRAI_deleteAccesorios...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yet1        ds                  likerec( c1wet1  : *key )

      /free

       COWGRAI_inz();

       k1yet1.t1empr = peBase.peEmpr;
       k1yet1.t1sucu = peBase.peSucu;
       k1yet1.t1nivt = peBase.peNivt;
       k1yet1.t1nivc = peBase.peNivc;
       k1yet1.t1nctw = peNctw;
       k1yet1.t1rama = peRama;
       k1yet1.t1arse = peArse;
       k1yet1.t1poco = pePoco;
       setll %kds(k1yet1:8) ctwet1;
       reade %kds(k1yet1:8) ctwet1;
       dow not %eof;
           delete c1wet1;
        reade %kds(k1yet1:8) ctwet1;
       enddo;
       return *on;

      /end-free

     P COWGRAI_deleteAccesorios...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkTarjCredito: Valida Tarjeta de Credito.           *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peCtcu  -  Código TC                          *
      *                peNrtc  -  Número TC                          *
      *                                                              *
      * Retorna: 0 OK                                                *
      *         -1 Empresa inválida                                  *
      *         -2 Cantidad de Dígitos Inválida                      *
      *         -3 Primer dígito significativo 0                     *
      *         -4 Primer dígito segun tabla GNTTC9                  *
      * -------------------------------------------------------------*
     P COWGRAI_chkTarjCredito...
     P                 B                   Export
     D COWGRAI_chkTarjCredito...
     D                 pi            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

     D   k1ytc9        ds                  likerec( g1ttc9  : *key )

     D SPEDI1          pr                  ExtPgm('SPEDI1')
     D  peNrtc                       70a
     D                 ds
     D @nrtc                         20  0
     D @nrtc1                         1  0 dim(20) overlay(@nrtc:1)

     D c70             s             70a
     D nro             s             20a
     D nro_ed          s             25a
     D @@prid          s              1  0
     D x               s             10i 0
     D y               s             10i 0
     D cd              s             10i 0

      /free

       COWGRAI_inz();

       chain peCtcu gnttc1;
       if not %found;
          return -1;
       endif;

       c70  = %editc(peNrtc:'X');
       nro  = %editc(peNrtc:'X');

       %subst(c70:21) = tcment;
       SPEDI1( c70 );

       nro_ed = %subst(c70:46);

       y = 0;
       for x = 1 to 25;
           if %subst(nro_ed:x:1) = '0' or
              %subst(nro_ed:x:1) = '1' or
              %subst(nro_ed:x:1) = '2' or
              %subst(nro_ed:x:1) = '3' or
              %subst(nro_ed:x:1) = '4' or
              %subst(nro_ed:x:1) = '5' or
              %subst(nro_ed:x:1) = '6' or
              %subst(nro_ed:x:1) = '7' or
              %subst(nro_ed:x:1) = '8' or
              %subst(nro_ed:x:1) = '9';
              y += 1;
           endif;
       endfor;

       if y <> tccdnt;
          return -2;
       endif;

       cd = tccdnt - 1;
       cd = 20 - cd;
       if %subst(nro:cd:1) = '0';
          return -2;
       endif;

       @nrtc = peNrtc;

       x = 0;
       for x = 1 to 20;
           if @nrtc1(x) >=1 and @nrtc1(x) <= 9;
              @@prid = @nrtc1(x);
               leave;
              else;
           endif;
       endfor;

       k1ytc9.t9ctcu = peCtcu;
       k1ytc9.t9prid = @@prid;
       chain %kds( k1ytc9 : 2 ) gnttc9;
       if not %found;
          return -4;
       endif;

       return 0;

      /end-free

     P COWGRAI_chkTarjCredito...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_getMinimoRes3125: Retorna Importe Mínimo de Resolucion   *
      *                           3125                                   *
      *      peRama (input)  Parámetro Base                              *
      *                                                                  *
      * Retorna Importe.-                                                *
      * ---------------------------------------------------------------- *
     P COWGRAI_getMinimoRes3125...
     P                 B                   export
     D COWGRAI_getMinimoRes3125...
     D                 pi            15  2
     D   peRama                       2  0 const

      /free

       COWGRAI_inz();

       chain(n) peRama set123;

       if %found( set123 );
         return t5ivam;
       endif;

         return *zeros;

      /end-free

     P COWGRAI_getMinimoRes3125...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_setSellados (): Graba Importes de Sellados               *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peSeri (input)  Sellado Riesgos                             *
      *      peSeem (input)  Sellado Empresa                             *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     P COWGRAI_setSellados...
     P                 B                   export
     D COWGRAI_setSellados...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peSeri                      15  2 const
     D   peSeem                      15  2 const

     D k1y001          ds                  likerec(c1w001:*key)

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain %kds ( k1y001 ) ctw001;

       w1seri = peSeri;
       w1seem = peSeem;

       update c1w001;

       return *On;

      /end-free

     P COWGRAI_setSellados...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_updTablaDeImpuestos: Elimina porcentajes con monto en    *
      *                              Cero                                *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     P COWGRAI_updTablaDeImpuestos...
     P                 B                   export
     D COWGRAI_updTablaDeImpuestos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1y001          ds                  likerec(c1w001:*key)

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;

       setll %kds ( k1y001 : 5 ) ctw001;
       reade %kds ( k1y001 : 5 ) ctw001;
       dow not %eof( ctw001 );
         if w1ipr3 = *zeros;
            clear w1pivr;
         endif;
         if w1ipr4 = *zeros;
           clear w1pivn;
         endif;
         update c1w001;
        reade %kds ( k1y001 : 5 ) ctw001;
       enddo;

       return *On;

      /end-free

     P COWGRAI_updTablaDeImpuestos...
     P                 E

      * ----------------------------------------------------------------- *
      * COWGRAI_getCtw000():Retorna todos los datos de la Cabecera de     *
      *                     una Cotización                                *
      *                                                                   *
      *    peBase  (imput)  Base                                          *
      *    peNctw  (imput)  Nro. Cotización                               *
      *    peDsCtw (output) Registro con ctw000 ( opcional )              *
      *                                                                   *
      * Retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P COWGRAI_getCtw000...
     P                 B                   export
     D COWGRAI_getCtw000...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsCtw                           likeds(dsctw000_t)
     D                                     options(*nopass:*omit)

     D   @@dd          s              2  0
     D   @@mm          s              2  0
     D   @@aa          s              4  0
     D   @@fech        s              8  0
      *
     D k1y000          ds                  likerec(c1w000:*key)
     D dsEctw          ds                  likerec(c1w000:*input)

      /Free

       COWGRAI_inz();

       k1y000.w0empr =  peBase.peEmpr;
       k1y000.w0sucu =  peBase.peSucu;
       k1y000.w0nivt =  peBase.peNivt;
       k1y000.w0nivc =  peBase.peNivc;
       k1y000.w0nctw =  peNctw;
       chain(n) %kds(k1y000:5) ctw000 dsEctw;

         if not %found ( ctw000 );
           return *off;
         endif;

         if %parms >= 3 and %addr( peDsCtw ) <> *null;
           eval-corr peDsCtw = dsEctw;
         endif;

       return *on;


      /end-free

     P COWGRAI_getCtw000...
     P                 E
      * -----------------------------------------------------------------*
      * COWGRAI_getSumaAseguradaPorvInd: Retorna Suma Asegurada por      *
      *                                  provincia Inder                 *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                                                                  *
      * Retorna: Suma / *Zeros                                           *
      * --------------------------------------------------------------   *
     P COWGRAI_getSumaAseguradaPorvInd...
     P                 B                   export
     D COWGRAI_getSumaAseguradaPorvInd...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peRpro                       2  0 const

     D k1yet0          ds                  likerec(c1wet0:*key)
     D k1yetc          ds                  likerec(c1wetc01:*key)
     D k1yer0          ds                  likerec(c1wer0:*key)
     D k1yer2          ds                  likerec(c1wer2:*key)

     D @@suma          s             15  2

       COWGRAI_inz();

       clear @@suma;

       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.peNivt;
       k1yet0.t0nivc = peBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;

       setll %kds ( k1yet0 : 6 ) ctwet0;
       reade(n) %kds ( k1yet0 : 6 ) ctwet0;

       dow not %eof ( ctwet0 );

         if ( peRpro = COWGRAI_GetCodProInd ( t0copo : t0cops ) );

           k1yetc.t0empr = peBase.peEmpr;
           k1yetc.t0sucu = peBase.peSucu;
           k1yetc.t0nivt = peBase.peNivt;
           k1yetc.t0nivc = peBase.peNivc;
           k1yetc.t0nctw = peNctw;
           k1yetc.t0rama = peRama;
           k1yetc.t0arse = t0arse;
           k1yetc.t0poco = t0poco;

           chain(n) %kds ( k1yetc : 8 ) ctwetc01;

           @@suma += t0vhvu;

         endif;

         reade(n) %kds ( k1yet0 : 6 ) ctwet0;

       enddo;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;

       setll %kds ( k1yer0 : 6 ) ctwer0;
       reade(n) %kds ( k1yer0 : 6 ) ctwer0;

       dow not %eof ( ctwer0 );

         if ( peRpro = r0rpro );

           k1yer2.r2empr = peBase.peEmpr;
           k1yer2.r2sucu = peBase.peSucu;
           k1yer2.r2nivt = peBase.peNivt;
           k1yer2.r2nivc = peBase.peNivc;
           k1yer2.r2nctw = peNctw;
           k1yer2.r2rama = peRama;
           k1yer2.r2arse = r0arse;
           k1yer2.r2poco = r0poco;

           setll %kds ( k1yer2 : 8 ) ctwer2;
           reade(n) %kds ( k1yer2 : 8 ) ctwer2;

           dow not %eof ( ctwer2 );

             @@suma += r2saco;

             reade(n) %kds ( k1yer2 : 8 ) ctwer2;

           enddo;

         endif;

         reade(n) %kds ( k1yer0 : 6 ) ctwer0;

       enddo;

       setll %kds ( k1yer0 : 6 ) ctwevc;
       reade(n) %kds ( k1yer0 : 6 ) ctwevc;
       dow not %eof;
          @@suma += v0suas;
        reade(n) %kds ( k1yer0 : 6 ) ctwevc;
       enddo;

       setll %kds ( k1yer0 : 6 ) ctwse1;
       reade(n) %kds ( k1yer0 : 6 ) ctwse1;
       dow not %eof;
          @@suma += e1saco;
        reade(n) %kds ( k1yer0 : 6 ) ctwse1;
       enddo;

       return @@suma;

      /end-free

     P COWGRAI_getSumaAseguradaPorvInd...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCompVida(): Elimina Componentes de Vida        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_deleteCompVida...
     P                 B                   export
     D COWGRAI_deleteCompVida...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yev1        ds                  likerec( c1wev1x  : *key )

      /free

       COWGRAI_inz();

       k1yev1.v1empr = peBase.peEmpr;
       k1yev1.v1sucu = peBase.peSucu;
       k1yev1.v1nivt = peBase.penivt;
       k1yev1.v1nivc = peBase.penivc;
       k1yev1.v1nctw = peNctw;
       k1yev1.v1rama = peRama;
       k1yev1.v1arse = peArse;
       k1yev1.v1poco = pePoco;
       setll %kds ( k1yev1 : 8 ) ctwev1;
       if not %equal( ctwev1 );
         return *off;
       endif;

       reade %kds ( k1yev1 : 8 ) ctwev1;
       dow not %eof( ctwev1 );
          COWGRAI_deleteCategoria ( peBase
                                  : peNctw
                                  : peRama
                                  : peArse
                                  : v1acti
                                  : v1secu );
         delete c1wev1x;
        reade %kds ( k1yev1 : 8 ) ctwev1;
       enddo;

       return *on;

      /end-free

     P COWGRAI_deleteCompVida...
     P                 E
      * ------------------------------------------------------------ *
      *  COWGRAI_GetImpuestosTotalesEg3 : Retorna Total de Impuestos *
      *                                                              *
      *     peBase    (input)  Base                                  *
      *     peNctw    (input)  Número de cotización                  *
      *     peRama    (input)  Rama                                  *
      *     peArse    (input)  Cant. Pólizas por Rama                *
      *     peImpEg3  (output) Estructura de Impuestos x Prov        *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_GetImpuestosTotalesEg3...
     P                 B
     D COWGRAI_GetImpuestosTotalesEg3...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peImpEg3                          likeds( ImpEg3 )

     D   @@ImpEg3      ds                  likeds( ImpEg3 ) dim( 99 )
     D   @@ImpEg3C     s             10i 0
     D   x             s             10i 0

      /free

       COWGRAI_inz();

       clear peImpEg3;
       clear @@ImpEg3;
       clear @@ImpEg3C;

       if not COWGRAI_GetImpuestosEg3( peBase
                                     : peNctw
                                     : peRama
                                     : peArse
                                     : @@ImpEg3
                                     : @@ImpEg3C );
         return *off;
       endif;

       for x = 1 to @@ImpEg3C;
         peImpEg3.rpro  = *zeros;
         peImpEg3.prim += @@ImpEg3(x).prim;
         peImpEg3.bpri += @@ImpEg3(x).bpri;
         peImpEg3.refi += @@ImpEg3(x).refi;
         peImpEg3.read += @@ImpEg3(x).read;
         peImpEg3.dere += @@ImpEg3(x).dere;
         peImpEg3.seri += @@ImpEg3(x).seri;
         peImpEg3.seem += @@ImpEg3(x).seem;
         peImpEg3.ipr6 += @@ImpEg3(x).ipr6;
         peImpEg3.ipr7 += @@ImpEg3(x).ipr7;
         peImpEg3.ipr8 += @@ImpEg3(x).ipr8;
         peImpEg3.prem += @@ImpEg3(x).prem;
         peImpEg3.ipr1 += @@ImpEg3(x).ipr1;
         peImpEg3.ipr3 += @@ImpEg3(x).ipr3;
         peImpEg3.ipr4 += @@ImpEg3(x).ipr4;
         peImpEg3.sefr += @@ImpEg3(x).sefr;
         peImpEg3.sefe += @@ImpEg3(x).sefe;
       endfor;

        return *on;
      /end-free
     P COWGRAI_GetImpuestosTotalesEg3...
     P                 E
      * ------------------------------------------------------------ *
      *  COWGRAI_GetImpuestosEg3 : Retorna Impuestos x Prov.         *
      *                                                              *
      *     peBase    (input)  Base                                  *
      *     peNctw    (input)  Número de cotización                  *
      *     peRama    (input)  Rama                                  *
      *     peArse    (input)  Cant. Pólizas por Rama                *
      *     peImpEg3  (output) Estructura de Impuestos x Prov        *
      *     peImpEg3C (output) Cantidad de Prov.                     *
      *     peRpro    (input)  Cod. de Provincia ( opcional )        *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_GetImpuestosEg3...
     P                 B
     D COWGRAI_GetImpuestosEg3...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peImpEg3                          likeds( ImpEg3 ) dim( 99 )
     D   peImpEg3C                   10i 0
     D   peRpro                       2  0 options( *omit : *nopass )

     D   k1yeg3        ds                  likerec( c1weg3 : *key )

      /free

       COWGRAI_inz();

       clear peImpEg3;
       clear peImpEg3C;

       k1yeg3.g3empr =  pebase.peEmpr;
       k1yeg3.g3sucu =  pebase.peSucu;
       k1yeg3.g3nivt =  pebase.peNivt;
       k1yeg3.g3nivc =  pebase.peNivc;
       k1yeg3.g3nctw =  peNctw;
       k1yeg3.g3rama =  peRama;
       k1yeg3.g3arse =  peArse;
       if %parms >= 8 and %addr( peRpro ) <> *Null;
         k1yeg3.g3rpro =  peRpro;
         setll %kds( k1yeg3 : 7 ) ctweg3;
         if not %equal( ctweg3 );
           return *off;
         endif;
         reade %kds( k1yeg3 : 7 ) ctweg3;
       else;
         setll %kds( k1yeg3 : 6 ) ctweg3;
         if not %equal( ctweg3 );
           return *off;
         endif;
         reade %kds( k1yeg3 : 6 ) ctweg3;
       endif;

       dow not %eof( ctweg3 );

         peImpEg3C += 1;

         peImpEg3( peImpEg3C ).rpro = g3rpro;
         peImpEg3( peImpEg3C ).prim = g3prim;
         peImpEg3( peImpEg3C ).bpri = g3bpri;
         peImpEg3( peImpEg3C ).refi = g3refi;
         peImpEg3( peImpEg3C ).read = g3read;
         peImpEg3( peImpEg3C ).dere = g3dere;
         peImpEg3( peImpEg3C ).seri = g3seri;
         peImpEg3( peImpEg3C ).seem = g3seem;
         peImpEg3( peImpEg3C ).ipr6 = g3ipr6;
         peImpEg3( peImpEg3C ).ipr7 = g3ipr7;
         peImpEg3( peImpEg3C ).ipr8 = g3ipr8;
         peImpEg3( peImpEg3C ).prem = g3prem;
         peImpEg3( peImpEg3C ).ipr1 = g3ipr1;
         peImpEg3( peImpEg3C ).ipr3 = g3ipr3;
         peImpEg3( peImpEg3C ).ipr4 = g3ipr4;
         peImpEg3( peImpEg3C ).sefr = g3sefr;
         peImpEg3( peImpEg3C ).sefe = g3sefe;

         if %parms >= 8 and %addr( peRpro ) <> *Null;
           reade %kds( k1yeg3 : 7 ) ctweg3;
         else;
           reade %kds( k1yeg3 : 6 ) ctweg3;
         endif;
       enddo;

       return *on;

      /end-free
     P COWGRAI_GetImpuestosEg3...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_UpdPremioEg3: Actualiza Premio x Provincia               *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peSubt (input)  Subtotal                                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWGRAI_updPremioEg3...
     P                 B
     D COWGRAI_updPremioEg3...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSubt                      15  2 const

     D k1y001          ds                  likerec(c1w001:*key)
     D k1yeg3          ds                  likerec(c1weg3:*key)

     D @@aux1          s             29  9
     D @@subt          s             15  2

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;

       setll %kds ( k1y001 : 5 ) ctw001;
       reade %kds ( k1y001 : 5 ) ctw001;

       dow not %eof ( ctw001 );

         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;
         k1yeg3.g3rama = w1rama;

         setll %kds ( k1yeg3 : 6 ) ctweg3;
         reade %kds ( k1yeg3 : 6 ) ctweg3;

         dow not %eof ( ctweg3 );

           clear  @@subt;
           @@aux1  =  w1prem / peSubt;
           @@subt = ( g3prim - g3bpri ) + g3dere + g3refi + g3read;
           g3prem  =  @@aux1 * @@subt;

           update c1weg3;

           reade %kds ( k1yeg3 : 6 ) ctweg3;

         enddo;

         reade %kds ( k1y001 : 5 ) ctw001;

       enddo;

       return *On;

     P COWGRAI_updPremioEg3...
     P                 E
      * ------------------------------------------------------------ *
      *  COWGRAI_setAjustaPremio(): Se ajusta premio segùn tabla     *
      *                                                              *
      *     peBase    (input)  Base                                  *
      *     peNctw    (input)  Número de cotización                  *
      *     peRama    (input)  Rama                                  *
      *     peArse    (input)  Cant. Pólizas por Rama                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_setAjustaPremio...
     P                 B
     D COWGRAI_setAjustaPremio...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1y001          ds                  likerec( c1w001  : *key )
     D k1y001c         ds                  likerec( c1w001c : *key )
     D k1yeg3          ds                  likerec( c1weg3  : *key )

     D @@arcd          s              6  0 inz
     D @@prem          s             15  2 inz
     D @@prem1         s             15  1 inz
     D @@deci          s              2  2 inz                                  ||
     D @@subt          s             15  2 inz
     D @@subtEg3       s             15  2 inz
     D @@dife          s             15  2 inz
     D @@prim          s             15  2 inz
     D @@ImpEg3        ds                  likeds( ImpEg3 )
     D @@primero       s              1n   inz('1')
     D @@aux1          s             29  9
     D @@dere          s             15  2

      /free

       COWGRAI_inz();

       @@arcd = COWGRAI_getArticulo( peBase  : peNctw );
       chain @@arcd set630;
       if not %found( set630 );
         t4ma09 = *blanks;
       endif;

       @@prim = COWGRAI_getPrimaRamaArse( peBase
                                        : peNctw
                                        : peRama
                                        : peArse );

       if not COWGRAI_GetImpuestosTotalesEg3( peBase
                                            : peNctw
                                            : peRama
                                            : 1
                                            : @@ImpEg3 );
         return *off;
       endif;


       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain %kds ( k1y001 ) ctw001;
         if not %found( ctw001 );
           return *off;
         endif;

       k1y001c.w1empr = peBase.peEmpr;
       k1y001c.w1sucu = peBase.peSucu;
       k1y001c.w1nivt = peBase.peNivt;
       k1y001c.w1nivc = peBase.peNivc;
       k1y001c.w1nctw = peNctw;
       k1y001c.w1rama = peRama;
       chain %kds ( K1y001c : 6 ) ctw001c;
         if not %found( ctw001c );
           return *off;
         endif;

       @@prem = w1prem;
       @@subt = ( @@prim ) +  w1read + w1refi + w1dere;

     select;
         when t4ma09 = '1';
           if w1prem > *Zeros;
             w1prem += 0,05;
             @@prem1 = w1prem;
             w1prem  = @@prem1;
           else;
             w1prem  = *Zeros;
           endif;
         when t4ma09 = '2';
           if w1prem > *Zeros;
           w1prem += 0,50;
           w1prem  = %int(w1prem);
         else;
           w1prem  = *Zeros;
         endif;
       endsl;
       //ajusta...
       @@deci = w1prem - @@prem;
       select;
         when w1read <> *zeros;
              w1read = w1read + @@deci;
         when w1refi <> *zeros;
              w1refi = w1refi + @@deci;
         when w1dere <> *zeros;
              w1dere = w1dere + @@deci;
              @@dere = w1dere;
         //when w1bpri <> *zeros;
         //     w1bpri+= @@deci;
         when w1impi <> *zeros;
              w1impi = w1impi + @@deci;
         when w1sers <> *zeros;
              w1sers = w1sers + @@deci;
       when w1tssn <> *zeros;
              w1tssn = w1tssn + @@deci;
         other;
              w1prem = @@prem;
         endsl;

       // actualiza todo...
         update c1w001;
         update c1w001c;

         @@subt = ( @@prim ) +  w1read + w1refi + w1dere;
         k1yeg3.g3empr =  pebase.peEmpr;
         k1yeg3.g3sucu =  pebase.peSucu;
         k1yeg3.g3nivt =  pebase.peNivt;
         k1yeg3.g3nivc =  pebase.peNivc;
         k1yeg3.g3nctw =  peNctw;
         k1yeg3.g3rama =  peRama;
         k1yeg3.g3arse =  peArse;
         setll %kds ( k1yeg3 : 7 ) ctweg3;
         reade %kds ( k1yeg3 : 7 ) ctweg3;
           dow not %eof ( ctweg3 );
             if @@primero;
               @@dife  = @@prim - @@ImpEg3.prim;
               g3prim += @@dife;
               @@dife  = w1dere - @@ImpEg3.dere;
               g3dere += @@dife;
               @@dife  = w1read - @@ImpEg3.read;
               g3read += @@dife;
               @@dife  = w1refi - @@ImpEg3.refi;
               g3refi += @@dife;
               @@primero = *off;
             endif;

             @@subtEg3 = ( g3prim - g3bpri ) + g3dere + g3refi + g3read;

             //Calcula premio x Prov...
             @@aux1 = w1prem / @@subt;
             g3prem = @@aux1 * @@subtEg3;
             update c1weg3;

           reade %kds ( k1yeg3 : 7 ) ctweg3;
          enddo;

        //ajusta premio decimal..
        clear @@ImpEg3;
        if not COWGRAI_GetImpuestosTotalesEg3( peBase
                                             : peNctw
                                             : peRama
                                             : 1
                                             : @@ImpEg3 );
          return *off;
        endif;

        @@deci =  w1prem - @@ImpEg3.prem;

        k1yeg3.g3empr =  pebase.peEmpr;
        k1yeg3.g3sucu =  pebase.peSucu;
        k1yeg3.g3nivt =  pebase.peNivt;
        k1yeg3.g3nivc =  pebase.peNivc;
        k1yeg3.g3nctw =  peNctw;
        k1yeg3.g3rama =  peRama;
        k1yeg3.g3arse =  peArse;
        setll %kds ( k1yeg3 : 7 ) ctweg3;
        reade %kds ( k1yeg3 : 7 ) ctweg3;
          if not %eof ( ctweg3 );
            g3prem+= @@deci;
            update c1weg3;
          endif;

       return *on;

      /end-free

     P COWGRAI_setAjustaPremio...
     P                 E
      * ------------------------------------------------------------ *
      *  COWGRAI_getImpPrimaMinima: Obtiene Prima Minima             *
      *                                                              *
      *     peBase    (input)  Parametros Base                       *
      *     peNctw    (input)  Nro. Cotizacion                       *
      *     peRama    (input)  Rama                                  *
      *     peArcd    (input)  Artículo                              *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_getImpPrimaMinima...
     P                 b                   export
     D COWGRAI_getImpPrimaMinima...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArcd                       6  0 const

     D   @@pmini       s             15  2 inz(0)

      /free

       COWGRAI_inz();

       if peRama = 23 and peArcd = 23;
         @@pmini = 500;
       endif;

       return @@pmini;
      /end-free

     P COWGRAI_getImpPrimaMinima...
     P                 e
      * ---------------------------------------------------------------- *
      * COWGRAI_setCondComerciales: Graba Condiciones Comerciales        *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Cant. Pólizas por Rama                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *

     P COWGRAI_setCondComerciales...
     P                 B                   export
     D COWGRAI_setCondComerciales...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const

     D K1y001          ds                  likerec(c1w001c:*key)

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain %kds( k1y001 ) ctw001c;
       if %found( ctw001c );
         delete c1w001c;
       endif;

       clear c1w001c;
       w1empr = peBase.peEmpr;
       w1sucu = peBase.pesucu;
       w1nivt = peBase.peNivt;
       w1nivc = peBase.peNivc;
       w1nctw = peNctw;
       w1rama = peRama;
       COWGRAI_GetCondComerciales (peBase:peNctw:peRama:w1xrea:w1xopr);

       write c1w001c;

       return *on;

     P COWGRAI_setCondComerciales...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_updCondComerciales: Recalcula Condiciones Comerciales    *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Recargo Administrativo                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     P COWGRAI_updCondComerciales...
     P                 B                   export
     D COWGRAI_updCondComerciales...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2   const

     D k1y001c         ds                  likerec(c1w001c:*key)

     D @@dife          s              5  2
     D @@xrea          s              5  2
     D @@xopr          s              5  2

       COWGRAI_inz();

       COWGRAI_GetCondComerciales (peBase:peNctw:peRama:@@xrea:@@xopr);

       k1y001c.w1empr = peBase.peEmpr;
       k1y001c.w1sucu = peBase.pesucu;
       k1y001c.w1nivt = peBase.peNivt;
       k1y001c.w1nivc = peBase.peNivc;
       k1y001c.w1nctw = peNctw;
       k1y001c.w1rama = peRama;

       chain %kds( k1y001c ) ctw001c;

         w1xrea = peXrea;
         select;
           when peXrea > @@xrea;
             @@dife = peXrea - @@xrea;
             w1xopr = @@xopr + @@dife;
           when peXrea < @@xrea;
             @@dife = @@xrea - peXrea;
             w1xopr = @@xopr - @@dife;
           other;
             w1xopr = @@xopr;
           endsl;

       if %found( ctw001c );
         update c1w001c;
       else;
         w1empr = peBase.peEmpr;
         w1sucu = peBase.pesucu;
         w1nivt = peBase.peNivt;
         w1nivc = peBase.peNivc;
         w1nctw = peNctw;
         w1rama = peRama;
         write c1w001c;
       endif;

       return *On;

     P COWGRAI_updCondComerciales...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_delCondComerciales: Elimina Condiciones Comerciales  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWGRAI_delCondComerciales...
     P                 B                   export
     D COWGRAI_delCondComerciales...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1y001c       ds                  likerec( c1w001c : *key )

      /free

       COWGRAI_inz();

       k1y001c.w1empr = peBase.peEmpr;
       k1y001c.w1sucu = peBase.peSucu;
       k1y001c.w1nivt = peBase.penivt;
       k1y001c.w1nivc = peBase.penivc;
       k1y001c.w1nctw = peNctw;

       setll %kds ( k1y001c : 5 ) ctw001c;
       reade %kds ( k1y001c : 5 ) ctw001c;
       dow not %eof();

         delete c1w001c;

         reade %kds ( k1y001c : 5 ) ctw001c;
       enddo;

       return *on;

      /end-free

     P COWGRAI_delCondComerciales...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_SaveImpuestos2():Graba Impuestos                         *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Cant. Pólizas por Rama                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *

     P COWGRAI_SaveImpuestos2...
     P                 B                   export
     D COWGRAI_SaveImpuestos2...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const

     D K1y001          ds                  likerec(c1w001:*key)

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.pesucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain %kds( k1y001 ) ctw001;
       clear c1w001;

       w1empr = peBase.peEmpr;
       w1sucu = peBase.pesucu;
       w1nivt = peBase.peNivt;
       w1nivc = peBase.peNivc;
       w1nctw = peNctw;
       w1rama = peRama;
       w1xref = COWGRAI_getXref( peBase : peNctw : w1rama );
       chain peRama set123;
       if %found( set123 );

         w1pimi = t5pimi;
         w1psso = t5psso;
         w1pssn = t5pssn;
         w1pivi = t5pivi;
         clear  w1pivr;
         clear  w1pivn;

         if COWGRAI_getCodigoIva ( peBase : peNctw ) = 1;
           w1pivr = t5pivr;
           w1pivn = t5pivn;
         Endif;

         if %found ( ctw001 );
           update c1w001;
         else;
           write c1w001;
         endif;
         return *on;
       else;
         return *off;
       endif;

     P COWGRAI_SaveImpuestos2...
     P                 E

      * ---------------------------------------------------------------- *
      * COWGRAI_getAuditoria(): Devuelve datos de Auditoria              *
      *                                                                  *
      *      peBase  (input) Parametros Base                             *
      *      peNctw  (input) Numero de Cotizacion                        *
      *      peDstim (input) Esructura de Archivo CTWTIM                 *
      *                                                                  *
      * Return *on = Ok / *off = No encontro                             *
      * ---------------------------------------------------------------- *

     P COWGRAI_getAuditoria...
     P                 B                   export
     D COWGRAI_getAuditoria...
     D                 pi              n
     D   peBase                            likeds(parambase)const
     D   peNctw                       7  0 const
     D   peDstim                           likeds(dsctwtim_t)

     D   k1ytim        ds                  likerec( c1wtim : *key )
     D   dsItim        ds                  likerec( c1wtim : *input )

      /free

       COWGRAI_inz();

       k1yTim.w0empr = peBase.peEmpr;
       k1yTim.w0sucu = peBase.peSucu;
       k1yTim.w0nivt = peBase.peNivt;
       k1yTim.w0nivc = peBase.peNivc;
       k1yTim.w0nctw = peNctw;
       chain(n) %kds( k1ytim : 5) ctwtim dsItim;
       if not %found( ctwtim );
         return *off;
       endif;

       eval-corr peDstim = dsItim;
       return *on;

      /end-free
     P COWGRAI_getAuditoria...
     P                 e

      * ---------------------------------------------------------------- *
      * COWGRAI_setAduditoria(): Gaba/actualiza Datos de auditoria       *
      *                                                                  *
      *      peDstim (input) Esructura de Archivo CTWTIM                 *
      *                                                                  *
      * VOID                                                             *
      * ---------------------------------------------------------------- *

     P COWGRAI_setAuditoria...
     P                 B                   export
     D COWGRAI_setAuditoria...
     D                 pi
     D   peDstim                           likeds(dsctwtim_t)const

     D   k1ytim        ds                  likerec( c1wtim : *key )
     D   dsOtim        ds                  likerec( c1wtim : *output )

      /free

       k1yTim.w0empr = peDsTim.w0empr;
       k1yTim.w0sucu = peDsTim.w0sucu;
       k1yTim.w0nivt = peDsTim.w0nivt;
       k1yTim.w0nivc = peDsTim.w0nivc;
       k1yTim.w0nctw = peDsTim.w0nctw;
       chain %kds( k1ytim : 5) ctwtim;
       eval-corr dsOTim = peDsTim;
       if %found( ctwtim );
         update c1wtim dsOtim;
       else;
         write c1wtim dsOtim;
       endif;

       return;

      /end-free
     P COWGRAI_setAuditoria...
     P                 e

      * ---------------------------------------------------------------- *
      * COWGRAI_getPolizasxPropuesta: Obtener Nro. de Poliza por rama    *
      *                               asociado a una Propuesta.          *
      *      peBase ( input  ) Base                                      *
      *      peSoln ( input  ) Nro de Propuesta                          *
      *      pePoli ( output ) Estructura de Poliza ( RAMA/POLIZA )      *
      *      pePoliC( output ) Cantidad de Polizas                       *
      *      peErro ( output ) Indicador de Error                        *
      *      peMsgs ( output ) Estructura de Error                       *
      *      peCest ( output ) Estado de Propuesta ( opcional )          *
      *      peCses ( output ) Sub. Estado         ( opcional )          *
      *      peDest ( output ) Descripcion         ( opcional )          *
      *                                                                  *
      *                                                                  *
      * Retorna *On = Propuesta Correcta / *Off = Propuesta Inexistente  *
      * ---------------------------------------------------------------- *

     P COWGRAI_getPolizasxPropuesta...
     P                 B                   export
     D COWGRAI_getPolizasxPropuesta...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peSoln                       7  0 const
     D   pePoli                            likeds(spolizas) Dim(100)
     D   pePoliC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   peCest                       1  0 options( *omit : *nopass )
     D   peCses                       2  0 options( *omit : *nopass )
     D   peDest                      20    options( *omit : *nopass )

     D   k1y000        ds                  likerec( c1w00015 : *key )

      /free

       COWGRAI_inz();

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
         peErro = -1;
         return *off;
       endif;

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0Sucu = peBase.peSucu;
       k1y000.w0Nivt = peBase.peNivt;
       k1y000.w0Nivc = peBase.peNivc;
       k1y000.w0Soln = peSoln;
       chain %kds(k1y000:5) ctw00015;
       if %found(ctw00015);
         if not COWGRAI_getPolizasDeSuperpoliza( peBase
                                               : w0Arcd
                                               : w0Spol
                                               : pePoli
                                               : peErro
                                               : peMsgs
                                               : pePoliC );
           return *off;
         endif;

         if %parms >= 6 and %addr( peCest ) <> *Null;
            peCest = w0cest;
         endif;

         if %parms >= 7 and %addr( peCses ) <> *Null;
            peCses = w0Cses;
         endif;

         if %parms >= 8 and %addr( peDest ) <> *Null;
            peDest = w0Dest;
         endif;
       else;
        //error
        %subst(wrepl:1:9)  = %trim(%char(peSoln));
        %subst(wrepl:10:1) = %char(peBase.peNivt);
        %subst(wrepl:11:5) = %trim(%char(peBase.peNivc));

        SVPWS_getMsgs( '*LIBL'
                     : 'WSVMSG'
                     : 'COWXXXX'
                     : peMsgs
                     : %trim(wrepl)
                     : %len(%trim(wrepl))  );

        peErro = -1;
        return *off;
       endif;

       return *on;
      /end-free
     P COWGRAI_getPolizasxPropuesta...
     P                 E
      * ---------------------------------------------------------------- *
      * COWGRAI_setNroCotizacionAPI:  Asocia Nro de cotizacion API a     *
      *                               cotizacion WEB                     *
      *      peBase ( input  ) Base                                      *
      *      peNctw ( input  ) Nro. de Cotizacion WEB                    *
      *      peNcta ( input  ) Nro. de Cotizacion API                    *
      *      peErro ( output ) Cod.de Error                              *
      *      peMsgs ( output ) Estructura de Mensajes                    *
      *                                                                  *
      *                                                                  *
      * Retorna: *On = Actualizacion OK / *off = Error                   *
      * ---------------------------------------------------------------- *

     P COWGRAI_setNroCotizacionAPI...
     P                 B                   export
     D COWGRAI_setNroCotizacionAPI...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNcta                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   k1y000        ds                  likerec( c1w000 : *key )

      /free

       COWGRAI_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain %kds( k1y000 ) ctw000;
       if %found( ctw000 );
         w0ncta = peNcta;
         update c1w000;
         return *on;
       endif;

       return *off;

      /end-free
     P COWGRAI_setNroCotizacionAPI...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_updCabecera: Actualiza datos de Cabecera.            *
      *                                                              *
      *    peBase ( input  ) Base                                    *
      *    peNctw ( input  ) Nro. de Cotizacion WEB                  *
      *    peErro ( output ) Cod.de Error                            *
      *    peMsgs ( output ) Estructura de Mensajes                  *
      *    peNcta ( input  ) Nro. de Cotizacion API    ( opcional )  *
      *    peCuii ( input  ) Cuit del Intermediario    ( opcional )  *
      *    peNsys ( input  ) Nombre del Sistema Remoto ( opcional )  *
      *    peNuse ( input  ) Nombre del Usuario        ( opcional )  *
      *    peCest ( input  ) Estado                    ( opcional )  *
      *    peCses ( input  ) SubEstado                 ( opcional )  *
      *                                                              *
      * Retorna: PeErro '-1' No se actualizo / '0' Ok                *
      * ------------------------------------------------------------ *
     P COWGRAI_updCabecera...
     P                 B                   export
     D COWGRAI_updCabecera...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   peNcta                       7  0 options( *omit : *nopass )
     D   peCuii                      11    options( *omit : *nopass )
     D   peNsys                      20    options( *omit : *nopass )
     D   peNuse                      50    options( *omit : *nopass )
     D   peCest                       1  0 options( *omit : *nopass ) const
     D   peCses                       2  0 options( *omit : *nopass ) const

     D   k1y000        ds                  likerec( c1w000 : *key )

      /free

       COWGRAI_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain %kds( k1y000 : 5 ) ctw000;
       if %found( ctw000 );
         if %parms >=5 and %addr( peNcta ) <> *Null;
           w0ncta = peNcta;
         endif;
         if %parms >=6 and %addr( peCuii ) <> *Null;
           w0cuii = peCuii;
         endif;
         if %parms >=7 and %addr( peNsys ) <> *Null;
           w0nsys = peNsys;
         endif;
         if %parms >=8 and %addr( peNuse ) <> *Null;
           w0Nuse = peNuse;
         endif;
         if %parms >=9 and %addr( peCest ) <> *Null;
           w0Cest = peCest;
         endif;
         if %parms >=10 and %addr( peCses ) <> *Null;
           w0Cses = peCses;
         endif;
         update c1w000;
       endif;

       return;
      /end-free
     P COWGRAI_updCabecera...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkCotizacionApi: Verifica si la cotizacion vino por *
      *                           API                                *
      *          peBase   ( input  ) Base                            *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *                                                              *
      * Retorna: *On = Si vino de API / *off = Caso contrario        *
      * ------------------------------------------------------------ *
     P COWGRAI_chkCotizacionApi...
     P                 B                   export
     D COWGRAI_chkCotizacionApi...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   @@dsCtw       ds                  likeds(dsctw000_t)

      /free

       COWGRAI_inz();

       clear @@DsCtw;
       if COWGRAI_getCtw000( pebase : peNctw : @@DsCtw );
         if @@dsCtw.w0Ncta <> *zeros;
           return *On;
         endif;
       endif;

       return *Off;

      /end-free
     P COWGRAI_chkCotizacionApi...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkRenovProcGuarEm: Verifica si existe cotización de *
      *                             renovación en proceso o guardada *
      *                                                              *
      *          peBase   ( input  ) Parametros Base                 *
      *          peArcd   ( input  ) Código de Articulo              *
      *          peSpol   ( input  ) Número de SuperPoliza
      *                                                              *
      * Retorna: *On = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P COWGRAI_chkRenovProcGuarEm...
     P                 B                   export
     D COWGRAI_chkRenovProcGuarEm...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1y017          ds                  likerec(c1w00017:*key)

      /free

       COWGRAI_inz();

       k1y017.w0Empr = PeBase.peEmpr;
       k1y017.w0Sucu = PeBase.peSucu;
       k1y017.w0Nivt = PeBase.peNivt;
       k1y017.w0Nivc = PeBase.peNivc;
       k1y017.w0Arcd = peArcd;
       k1y017.w0Spo1 = peSpol;
       setll %kds( k1y017 : 6 ) ctw00017;
       reade %kds( k1y017 : 6 ) ctw00017;
       dow not %eof( ctw00017 );
         if w0Tiou = 2;
           select;
             when w0Cest = 1 and w0Cses = 1;  // Cotiz. en Tramite
               return *On;
             when w0Cest = 1 and w0Cses = 2;  // Cotización Salvada
               return *On;
             when w0Cest = 5 and w0Cses = 3;  // Prop. Recibida x CIA
               return *On;
             when w0Cest = 5 and w0Cses = 4;  // Prop. en Emisión
               return *On;
             when w0Cest = 7 and w0Cses = 4;  // Op. Asignada a SPW
               return *On;
             when w0Cest = 7 and w0Cses = 5;  // Op. Suspendida
               return *On;
             when w0Cest = 7 and w0Cses = 7;  // Op. Emitida
               return *On;
             other;
               return *Off;
           endsl;
         endif;
         reade %kds( k1y017 : 6 ) ctw00017;

       enddo;

       return *Off;

      /end-free

     P COWGRAI_chkRenovProcGuarEm...
     P                 E

      * ------------------------------------------------------------------ *
      * COWGRAI_chkPlandePagoHabWeb(): Chequea que el plan de pago de la   *
      *                                póliza este habilitado para la web  *
      *                                                                    *
      *     peEmpr ( input )  Código de Empresa                            *
      *     peSucu ( input )  Código de Sucursal                           *
      *     peArcd ( input )  Código de Articulo                           *
      *     peSpol ( input )  Nro. de Superpoliza                          *
      *     peSspo ( input )  Suplemento de Superpoliza                    *
      *                                                                    *
      * Retorna *on = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     P COWGRAI_chkPlandePagoHabWeb...
     P                 B                    export
     D COWGRAI_chkPlandePagoHabWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

     D   k1yec3        ds                  likerec( p1hec3  : *key )
     D   k1y608        ds                  likerec( s1t608  : *key )

      /free

       COWGRAI_inz();

       k1yec3.c3Empr = peEmpr;
       k1yec3.c3Sucu = peSucu;
       k1yec3.c3Arcd = peArcd;
       k1yec3.c3Spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *NULL;
         k1yec3.c3Sspo = peSspo;
         setgt  %kds( k1yec3 : 5 ) pahec3;
         readpe %kds( k1yec3 : 5 ) pahec3;
       else;
         setgt  %kds( k1yec3 : 4 ) pahec3;
         readpe %kds( k1yec3 : 4 ) pahec3;
       endif;

         if not %eof( pahec3 );

           k1y608.t8Arcd = c3Arcd;
           k1y608.t8Nrpp = c3Nrpp;
           chain %kds( k1y608 : 2 ) set60802;
           if %found( set60802 );
             return *on;
           endif;

         endif;

       return *off;

      /end-free

     P COWGRAI_chkPlandePagoHabWeb...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_updEstado: Actualiza el estado del ctw000            *
      *                                                              *
      *          peBase   ( input  ) Base                            *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *          peCest   ( input  ) Cód. Estado Cot/Prop            *
      *          peCses   ( input  ) Cod. Subestado Cot/Prop         *
      *                                                              *
      * Retorna: *On = Actualizo / *off = No actualizo               *
      * ------------------------------------------------------------ *
     P COWGRAI_updEstado...
     P                 B                   export
     D COWGRAI_updEstado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCest                       1  0 const
     D   peCses                       2  0 const

     D   k1yctw        ds                  likerec( c1w000 : *key )
     D   @@Dest        s             20

      /free

       COWGRAI_inz();

       clear @@Dest;

       k1yCtw.w0Empr = peBase.peEmpr;
       k1yCtw.w0Sucu = peBase.peSucu;
       k1yCtw.w0Nivt = peBase.peNivt;
       k1yCtw.w0Nivc = peBase.peNivc;
       k1yCtw.w0Nctw = peNctw;
       chain %kds( k1yCtw : 5 ) ctw000;
       if not %found( ctw000 );
         return *off;
       endif;

       w0cest = peCest;
       w0cses = peCses;

       @@Dest = SVPDES_estadoCot( peCest
                                : peCses );

       w0Dest = @@Dest;

       update c1w000;

       return *on;

      /end-free

     P COWGRAI_updEstado...
     P                 E

      * ----------------------------------------------------------------- *
      * COWGRAI_updCtw000(): Actualiza todos los datos de la Cabecera de  *
      *                      una Cotización                               *
      *                                                                   *
      *    peDsCtw ( input  )  Registro con ctw000                        *
      *                                                                   *
      * Retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P COWGRAI_updCtw000...
     P                 B                   export
     D COWGRAI_updCtw000...
     D                 pi              n
     D   peDsCtw                           likeds( dsctw000_t )
     D                                     options( *nopass : *omit ) const

     D k1yCtw          ds                  likerec( c1w000 : *key    )
     D DsCtw0          ds                  likerec( c1w000 : *output )

      /Free

       COWGRAI_inz();

       k1yCtw.w0Empr = peDsCtw.w0Empr;
       k1yCtw.w0Sucu = peDsCtw.w0Sucu;
       k1yCtw.w0Nivt = peDsCtw.w0Nivt;
       k1yCtw.w0Nivc = peDsCtw.w0Nivc;
       k1yCtw.w0Nctw = peDsCtw.w0Nctw;
       chain %kds( k1yCtw : 5 ) ctw000;
       if not %found( ctw000 );
         return *off;
       endif;

       eval-corr DsCtw0 = peDsCtw;
       monitor;
         update c1w000 DsCtw0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWGRAI_updCtw000...
     P                 E

      * ----------------------------------------------------------------- *
      * COWGRAI_setCtw000(): Graba todos los datos de la Cabecera de      *
      *                      una Cotización                               *
      *                                                                   *
      *    peDsCtw ( input  )  Registro con ctw000                        *
      *                                                                   *
      * Retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P COWGRAI_setCtw000...
     P                 B                   export
     D COWGRAI_setCtw000...
     D                 pi              n
     D   peDsCtw                           likeds( dsctw000_t )
     D                                     options( *nopass : *omit ) const

     D k1yCtw          ds                  likerec( c1w000 : *key    )
     D DsCtw0          ds                  likerec( c1w000 : *output )

      /Free

       COWGRAI_inz();

       k1yCtw.w0Empr = peDsCtw.w0Empr;
       k1yCtw.w0Sucu = peDsCtw.w0Sucu;
       k1yCtw.w0Nivt = peDsCtw.w0Nivt;
       k1yCtw.w0Nivc = peDsCtw.w0Nivc;
       k1yCtw.w0Nctw = peDsCtw.w0Nctw;
       chain %kds( k1yCtw : 5 ) ctw000;
       if %found( ctw000 );
         return *off;
       endif;

       eval-corr DsCtw0 = peDsCtw;
       monitor;
         write c1w000 DsCtw0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWGRAI_setCtw000...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_vencerCotizacion: Actualiza estado en ctw000 a       *
      *                           vencida                            *
      *                                                              *
      *          peBase   ( input  ) Base                            *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *                                                              *
      * Retorna: *On = Actualizo / *off = No actualizo               *
      * ------------------------------------------------------------ *
     P COWGRAI_vencerCotizacion...
     P                 B                   export
     D COWGRAI_vencerCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1yctw        ds                  likerec( c1w000 : *key )
     D   @@Dest        s             20

      /free

       COWGRAI_inz();

       k1yCtw.w0Empr = peBase.peEmpr;
       k1yCtw.w0Sucu = peBase.peSucu;
       k1yCtw.w0Nivt = peBase.peNivt;
       k1yCtw.w0Nivc = peBase.peNivc;
       k1yCtw.w0Nctw = peNctw;
       chain %kds( k1yCtw : 5 ) ctw000;
       if not %found( ctw000 );
         return *off;
       endif;

       w0Cest = 1;
       w0Cses = 9;

       @@Dest = SVPDES_estadoCot( w0Cest
                                : w0Cses );

       w0Dest = @@Dest;

       update c1w000;

       return *on;

      /end-free

     P COWGRAI_vencerCotizacion...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getCotizacionMoneda(): Retorna la cotización de mone-*
      *                           da usada en la cotización.         *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWGRAI_getCotizacionDeMoneda...
     P                 B                   export
     D COWGRAI_getCotizacionDeMoneda...
     D                 pi            15  6
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D rc              s              1n
     D regCtw          ds                  likeds(dsctw000_t)

      /free

       COWGRAI_inz();

       rc = COWGRAI_getCtw000( peBase : peNctw: regCtw );
       if rc = *off;
          return 1;
       endif;

       return regCtw.w0come;

      /end-free

     P COWGRAI_getCotizacionDeMoneda...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_setFlota(): Graba si la cotización es una Flota.     *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: *On = Actualizo / *off = No actualizo               *
      * ------------------------------------------------------------ *
     P COWGRAI_setFlota...
     P                 B                   export
     D COWGRAI_setFlota...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1yctw        ds                  likerec( c1w000 : *key )

      /free

       COWGRAI_inz();

       k1yCtw.w0Empr = peBase.peEmpr;
       k1yCtw.w0Sucu = peBase.peSucu;
       k1yCtw.w0Nivt = peBase.peNivt;
       k1yCtw.w0Nivc = peBase.peNivc;
       k1yCtw.w0Nctw = peNctw;
       chain %kds( k1yCtw : 5 ) ctw000;
       if not %found( ctw000 );
         return *off;
       endif;

       w0mp01 = '1';

       update c1w000;

       return *on;

      /end-free

     P COWGRAI_setFlota...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_isFlota(): Retorna si la cotización es de Flota.     *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: *On = Es flota / *off = No es Flota                 *
      * ------------------------------------------------------------ *
     P COWGRAI_isFlota...
     P                 B                   export
     D COWGRAI_isFlota...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1yctw        ds                  likerec( c1w000 : *key )

      /free

       COWGRAI_inz();

       k1yCtw.w0Empr = peBase.peEmpr;
       k1yCtw.w0Sucu = peBase.peSucu;
       k1yCtw.w0Nivt = peBase.peNivt;
       k1yCtw.w0Nivc = peBase.peNivc;
       k1yCtw.w0Nctw = peNctw;
       chain(n) %kds( k1yCtw : 5 ) ctw000;
       if not %found( ctw000 );
         return *off;
       endif;

       if w0Mp01 = '1';
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_isFlota...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_setExtraComision(): Graba Extra Comisión x rama      *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      * Retorna: *on = Grabo Ok / *off = Error                       *
      * ------------------------------------------------------------ *
     P COWGRAI_setExtraComision...
     P                 B                   export
     D COWGRAI_setExtraComision...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

     D   @@empr        s              1
     D   @@sucu        s              2
     D   @@nivt        s              1  0
     D   @@nivc        s              5  0
     D   @@cade        s              5  0 dim(9)
     D   @@erro        s               n
     D   @@endp        s              3a   inz ( '   ' )
     D   @@vacc        s             15  2
     D   @@tien        s               n
     D   @@tvcc        s              1a
     D   @@facc        s              1a
     D   @@xdia        s              5  0
     D   @1dere        s             15  2
     D   @@aux3        s             29  9                                      |
     D   k1y01c        ds                  likerec( c1w001c : *key )
     D   @@base        ds                  likeds(paramBase)
     D   prima         s             15  2
     D   @@fctw        s              8  0
     D   @@tiou        s              1  0
     D   @@stou        s              2  0
     D   @@stos        s              2  0
     D   @@rama        s              2  0
     D   @@come        s             15  6

      /free
       COWGRAI_inz();

       @@empr = peBase.peEmpr;
       @@sucu = peBase.peSucu;
       @@nivt = peBase.peNivt;
       @@nivc = peBase.peNivc;
       @@rama = peRama;
       SPCADCOM ( @@empr
                : @@sucu
                : @@nivt
                : @@nivc
                : @@cade
                : @@erro
                : @@endp );

       if @@cade(6) = *zeros;
         return *on;
       endif;

       prima = COWGRAI_getPrimaRamaArse( peBase
                                       : peNctw
                                       : peRama
                                       : 1       );
       if prima = *zeros;
         return *on;
       endif;

       @@fctw = COWGRAI_getFechaCotizacion( peBase : peNctw );
       COWGRAI_getTipodeOperacion( peBase
                                 : peNctw
                                 : @@tiou
                                 : @@stou
                                 : @@stos );
       @@base = peBase;
       @@base.peNivt = 6;
       @@base.peNivc = @@cade(6);
       @@nivt = 6;
       @@nivc = @@cade(6);
       SPEXCODE( @@empr
               : @@sucu
               : @@nivt
               : @@nivc
               : @@rama
               : @@tiou
               : @@stou
               : @@fctw
               : @@endp
               : @@tien
               : @@vacc
               : @@tvcc
               : @@facc
               : @@xdia
               : @1dere);

       //if not @@tien;
       //  return *on;
       //endif;
       @@come = COWGRAI_cotizaMoneda( COWGRAI_monedaCotizacion( peBase
                                                              : peNctw )
                                    : @@fctw );
       if @@come <> *zeros;
         @@vacc = @@vacc/@@come;
       endif;

       @@aux3 = (@@vacc / prima) * 100;

       k1y01c.w1empr = @@base.peEmpr;
       k1y01c.w1sucu = @@base.peSucu;
       k1y01c.w1nivt = @@base.peNivt;
       k1y01c.w1nivc = @@base.peNivc;
       k1y01c.w1nctw = peNctw;
       k1y01c.w1rama = peRama;
       chain %kds( k1y01c : 6 ) ctw001c;
       if %found( ctw001c );
         delete c1w001c;
       endif;
       w1empr = peBase.peEmpr;
       w1sucu = peBase.peSucu;
       w1nivt = @@base.peNivt;
       w1nivc = @@base.peNivc;
       w1nctw = peNctw;
       w1rama = peRama;
       clear w1xrea;
       clear w1read;
       eval(h) w1xopr = @@aux3;
       w1copr = @@vacc;
       write c1w001c;

       return *on;
      /end-free

     P COWGRAI_setExtraComision...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getVacc(): Obtener Importe de Extra Comision x rama  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      * Retorna Importe de Vacc                                      *
      * ------------------------------------------------------------ *
     P COWGRAI_getVacc...
     P                 B                   export
     D COWGRAI_getVacc...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

     D   rc            s             10i 0
     D   k1y001        ds                  likerec( c1w001 : *key )

      /free
       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;
       chain(n) %kds( k1y001 : 6 ) ctw001;
       if not %found( ctw001 );
         return *zeros;
       endif;
       return w1vacc;
       /end-free

     P COWGRAI_getVacc...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getFechaCotizacion(): Retorna fecha de cotización    *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: AAAAMMDD = OK / -1 = Error                          *
      * ------------------------------------------------------------ *
     P COWGRAI_getFechaCotizacion...
     P                 B                   export
     D COWGRAI_getFechaCotizacion...
     D                 pi             8  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D regCtw          ds                  likeds(dsctw000_t)

      /free

       COWGRAI_inz();

       if not COWGRAI_getCtw000( peBase : peNctw: regCtw );
          return -1;
       endif;

       return regCtw.w0fctw;

      /end-free

     P  COWGRAI_getFechaCotizacion...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getComision(): Retorna Comision                      *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peXopr   ( output ) % de Comisión                        *
      *     peCopr   ( output ) Importe de comisión                  *
      *                                                              *
      * Retorna: *on = encontró / *off = No encontró                 *
      * ------------------------------------------------------------ *
     P COWGRAI_getComision...
     P                 B                   export
     D COWGRAI_getComision...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXopr                       5  2
     D   peCopr                      15  2

     D   k1y01c        ds                  likerec( c1w001c : *key )

      /free
       COWGRAI_inz();

       k1y01c.w1empr = peBase.peEmpr;
       k1y01c.w1sucu = peBase.peSucu;
       k1y01c.w1nivt = peBase.peNivt;
       k1y01c.w1nivc = peBase.peNivc;
       k1y01c.w1nctw = peNctw;
       k1y01c.w1rama = peRama;
       chain(n) %kds( k1y01c : 6 ) ctw001c;
       if %found( ctw001c );
         peXopr = w1xopr;
         peCopr = w1copr;
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_getComision...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_deletePocoScoring(): Elimina registro en ctwet3      *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Componente                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWGRAI_deletePocoScoring...
     P                 B                   export
     D COWGRAI_deletePocoScoring...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      /free

       COWGRAI_inz();

       COWVEH_deletePocoScoring( peBase
                               : peNctw
                               : peRama
                               : peArse
                               : pePoco );

      /end-free

     P COWGRAI_deletePocoScoring...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getDatosCapituloRGV:  Retorna la clasificación       *
      *                                 del riesgo.                  *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peXpro   (input)   Plan                                  *
      *     peCtar   (output)  capitulo de tarifa                    *
      *     peCta1   (output)  capitulo tarifa inciso 1              *
      *     peCeta   (output)  capitulo tarifa sistema               *
      *     peCagr   (output)  agravaciones de Riesgos               *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWGRAI_getDatosCapituloRGV...
     P                 B                   export
     D COWGRAI_getDatosCapituloRGV...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peCtar                       4  0
     D   peCta1                       2
     D   peCeta                       4
     D   peCagr                       2  0

     D k1y101          ds                  likerec(s1t101:*key)
     D k1y102          ds                  likerec(s1t102:*key)

     D
      /free

       COWGRAI_inz();

       k1y102.s2rama = peRama;
       k1y102.s2xpro = peXpro;

       chain %kds ( k1y102 : 2 ) set102;
       if %found();

         k1y101.s1rama = peRama;
         k1y101.s1ctar = s2ctar;
         k1y101.s1cta1 = s2cta1;
         k1y101.s1cta2 = s2cta2;

         chain %kds ( k1y101 : 4 ) set101;
         if %found();

           peCtar = s2ctar;
           peCta1 = s2cta1;
           peCeta = s1ceta;
           peCagr = s1cagr;
           return *on;

         endif;

       endif;

       return *off;

      /end-free

     P COWGRAI_getDatosCapituloRGV...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getEstadoCotizacion : Retorna estado de una          *
      *                               Cotizacion.                    *
      *                                                              *
      *     peBase ( input  ) Parametros Base                        *
      *     peNctw ( input  ) Nro. de Cotización                     *
      *     peCest ( output ) Estado de Propuesta                    *
      *     peCses ( output ) Sub. Estado                            *
      *                                                              *
      * Retorna: *on = Encontro / *off = No Encontro                 *
      * ------------------------------------------------------------ *
     P COWGRAI_getEstadoCotizacion...
     P                 B                   export
     D COWGRAI_getEstadoCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCest                       1  0
     D   peCses                       2  0

     D rc              s              1n
     D regCtw          ds                  likeds(dsctw000_t)

      /free

       COWGRAI_inz();

       clear regCtw;
       if not COWGRAI_getCtw000( peBase : peNctw: regCtw );
          return *off;
       endif;

       peCest = regCtw.w0cest;
       peCses = regCtw.w0cses;
       return *on;

      /end-free

     P COWGRAI_getEstadoCotizacion...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getNroPropuesta: Retorna nro de propusta WEB.        *
      *                                                              *
      *     peBase ( input  ) Parametros Base                        *
      *     peNctw ( input  ) Nro. de Cotización                     *
      *     peSoln ( output ) Nro. de Propuesta                      *
      *                                                              *
      * Retorna: *on = Encontro / *off = No Encontro                 *
      * ------------------------------------------------------------ *
     P COWGRAI_getNroPropuesta...
     P                 B                   export
     D COWGRAI_getNroPropuesta...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       7  0

     D regCtw          ds                  likeds(dsctw000_t)

      /free

       COWGRAI_inz();

       clear peSoln;
       if not COWGRAI_getCtw000( peBase : peNctw: regCtw );
         return *off;
       endif;

       peSoln = regCtw.w0soln;
       return *on;

      /end-free

     P COWGRAI_getNroPropuesta...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_setNroPropuesta: Retorna nro de propusta WEB nuevo.  *
      *                                                              *
      *     peBase ( input  ) Parametros Base                        *
      *     peNctw ( input  ) Nro. de Cotización                     *
      *     peSoln ( output ) Nro. de Propuesta                      *
      *                                                              *
      * Retorna: 0 = Error /  >0 = Ok                                *
      * ------------------------------------------------------------ *
     P COWGRAI_setNroPropuesta...
     P                 B                   export
     D COWGRAI_setNroPropuesta...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       1  0

     D rc              s              1n
     D regCtw          ds                  likeds(dsctw000_t)
     D k1y915          ds                  likerec(s1t915:*key)

      /free

       COWGRAI_inz();

       k1y915.t@empr = peBase.peEmpr;
       k1y915.t@sucu = peBase.peSucu;
       k1y915.t@tnum = 'SO';
       chain %kds( k1y915 : 3 ) set915;
       if %found;
          t@nres += 1;
          t@user  = @PsDs.CurUsr;
          t@date  = udate;
          t@time  = %dec(%time);
          update s1t915;
       else;
          t@empr = peBase.peEmpr;
          t@sucu = peBase.peSucu;
          t@tnum = 'SO';
          t@dnum = 'NUMERO DE SOLICITUD';
          t@nres = 1;
          t@user = @PsDs.CurUsr;
          t@date = udate;
          t@time = %dec(%time);
          write s1t915;
       endif;

       return *on;

      /end-free

     P COWGRAI_setNroPropuesta...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkCotizacionEnviada: Retorna si la Cotizacion fue   *
      *                               enviada a emitir.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *                                                              *
      * Retorna: *on = Envida / *off = No Enviada                    *
      * ------------------------------------------------------------ *
     P COWGRAI_chkCotizacionEnviada...
     P                 B                   export
     D COWGRAI_chkCotizacionEnviada...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   @@soln        s              7  0
     D   rc            s               n

      /free
       COWGRAI_inz();

       rc = COWGRAI_getNroPropuesta( peBase
                                   : peNctw
                                   : @@soln );
       if @@soln = 0;
         return *off;
       endif;

       return *on;

      /end-free

     P COWGRAI_chkCotizacionEnviada...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkCotizacionVencida: Retorna si la Cotizacion se    *
      *                               encuentra vencida.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *                                                              *
      * Retorna: *on = Vencida / *off = No Vencida                   *
      * ------------------------------------------------------------ *
     P COWGRAI_chkCotizacionVencida...
     P                 B                   export
     D COWGRAI_chkCotizacionVencida...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   rc            s               n
     D   @@cest        s              1  0
     D   @@cses        s              2  0

      /free
       COWGRAI_inz();

       rc = COWGRAI_getEstadoCotizacion( peBase
                                       : peNctw
                                       : @@cest
                                       : @@cses );

       if @@cest = 1 and @@cses = 9;
         return *on;
       endif;

       return *off;

      /end-free
     P COWGRAI_chkCotizacionVencida...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkTieneAseguradoPrincipal : Retorna si cotizacion   *
      *                                      tiene asegurado         *
      *                                      principal.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *                                                              *
      * Retorna: *on = Tiene / *off = No tiene                       *
      * ------------------------------------------------------------ *
     P COWGRAI_chkTieneAseguradoPrincipal...
     P                 B                   export
     D COWGRAI_chkTieneAseguradoPrincipal...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1w003        ds                  likerec(c1w003:*key)
      /free
       COWGRAI_inz();

       k1w003.w3empr = peBase.peEmpr;
       k1w003.w3sucu = peBase.peSucu;
       k1w003.w3nivt = peBase.peNivt;
       k1w003.w3nivc = peBase.peNivc;
       k1w003.w3nctw = peNctw;
       k1w003.w3nase = 0;
       setll %kds(k1w003:6) ctw003;
       return %equal;

      /end-free
     P COWGRAI_chkTieneAseguradoPrincipal...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chktodasLasRamasCotizadas: Validar si se cotizaron   *
      *                                    todas las ramas asociadas *
      *                                    al artículo.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Estructura de Error                   *
      *                                                              *
      * Retorna: *on = Ok / *off = Error                             *
      * ------------------------------------------------------------ *
     P COWGRAI_chktodasLasRamasCotizadas...
     P                 B                   export
     D COWGRAI_chktodasLasRamasCotizadas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1t621          ds                  likerec(s1t621:*key)
     D K1y001          ds                  likerec(c1w001:*key)

      /free

       COWGRAI_inz();

       k1t621.t3arcd = COWGRAI_getArticulo ( peBase : peNctw );
       setll %kds(k1t621:1) set621;
       reade %kds(k1t621:1) set621;
       dow not %eof(set621);
         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.pesucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         k1y001.w1rama = t@rama;
         setll %kds( k1y001 ) ctw001;
         if not %equal(ctw001);
           %subst(wrepl:24:2) = %trim(%char(t3rama));
           %subst(wrepl:28:6) = %trim(%char(t3arcd));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0038'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return *off;
         endif;
        reade %kds(k1t621:1) set621;
       enddo;

       return *on;
      /end-free

     P COWGRAI_chktodasLasRamasCotizadas...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getCtweg3(): Retorna datos de Primas por provincia   *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                         ( opc ) *
      *    peArse   ( imput  )  Cant. de articulos por rama  ( opc ) *
      *    peRpro   ( imput  )  Provincia                    ( opc ) *
      *    peDsEg3  ( output )  Registro con ctweg3          ( opc ) *
      *    peDsEg3C ( output )  Cantidad de registros        ( opc ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_getCtweg3...
     P                 B                   export
     D COWGRAI_getCtweg3...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   peRpro                       2  0 options( *omit : *nopass ) const
     D   peDsEg3                           likeds(dsctweg3_t) dim( 9999 )
     D                                     options( *omit : *nopass )
     D   peDsEg3C                    10i 0 options( *omit : *nopass )

     D   @@dd          s              2  0
     D   @@mm          s              2  0
     D   @@aa          s              4  0
     D   @@fech        s              8  0
      *
     D k1yeg3          ds                  likerec(c1weg3:*key)
     D DsIeg3          ds                  likerec(c1weg3:*input)
     D @@DsEg3         ds                  likeds(dsctweg3_t) dim( 9999 )
     D @@DsEg3C        s             10i 0

      /Free

       COWGRAI_inz();

       clear @@DsEg3;
       clear @@DsEg3C;

       k1yeg3.g3empr = peBase.peEmpr;
       k1yeg3.g3sucu = peBase.peSucu;
       k1yeg3.g3nivt = peBase.peNivt;
       k1yeg3.g3nivc = peBase.peNivc;
       k1yeg3.g3nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peRpro ) <> *null;

                  k1yeg3.g3Rama = peRama;
                  k1yeg3.g3Arse = peArse;
                  k1yeg3.g3Rpro = peRpro;

                  setll %kds( k1yeg3 : 8 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yeg3 : 8 ) ctweg3 DsIeg3;
                  dow not %eof( ctweg3 );
                    @@DsEg3C += 1;
                    eval-corr @@DsEg3( @@DsEg3C ) = DsIeg3;
                    reade(n) %kds( k1yeg3 : 8 ) ctweg3;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peRpro ) =  *null;

                  k1yeg3.g3Rama = peRama;
                  k1yeg3.g3Arse = peArse;

                  setll %kds( k1yeg3 : 7 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yeg3 : 7 ) ctweg3 DsIeg3;
                  dow not %eof( ctweg3 );
                    @@DsEg3C += 1;
                    eval-corr @@DsEg3( @@DsEg3C ) = DsIeg3;
                    reade(n) %kds( k1yeg3 : 7 ) ctweg3;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( peRpro ) =  *null;

                  k1yeg3.g3Rama = peRama;

                  setll %kds( k1yeg3 : 6 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yeg3 : 6 ) ctweg3 DsIeg3;
                  dow not %eof( ctweg3 );
                    @@DsEg3C += 1;
                    eval-corr @@DsEg3( @@DsEg3C ) = DsIeg3;
                    reade(n) %kds( k1yeg3 : 6 ) ctweg3;
                  enddo;
            other;
                  setll %kds( k1yeg3 : 5 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yeg3 : 5 ) ctweg3 DsIeg3;
                  dow not %eof( ctweg3 );
                    @@DsEg3C += 1;
                    eval-corr @@DsEg3( @@DsEg3C ) = DsIeg3;
                    reade(n) %kds( k1yeg3 : 5 ) ctweg3;
                  enddo;
          endsl;
       else;
         setll %kds( k1yeg3 : 5 ) ctweg3;
         if not %equal ( ctweg3 );
            return *off;
         endif;
         reade(n) %kds( k1yeg3 : 5 ) ctweg3 DsIeg3;
         dow not %eof( ctweg3 );
           @@DsEg3C += 1;
           eval-corr @@DsEg3( @@DsEg3C ) = DsIeg3;
           reade(n) %kds( k1yeg3 : 5 ) ctweg3;
         enddo;
       endif;

       if %parms >= 3  and %addr( peDsEg3 ) <> *null;
           eval-corr peDsEg3 = @@DsEg3;
       endif;

       if %parms >= 3  and %addr( peDsEg3C ) <> *null;
           peDsEg3C = @@DsEg3C;
       endif;

       return *on;

      /end-free

     P COWGRAI_getCtweg3...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkCtweg3(): Valida si existen Primas por provincia  *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                         ( opc ) *
      *    peArse   ( imput  )  Cant. de articulos por rama  ( opc ) *
      *    peRpro   ( imput  )  Provincia                    ( opc ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_chkCtweg3...
     P                 B                   export
     D COWGRAI_chkCtweg3...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   peRpro                       2  0 options( *omit : *nopass ) const

     D   k1yeg3        ds                  likerec( c1weg3 : *key )

      /Free

       COWGRAI_inz();


       k1yeg3.g3empr = peBase.peEmpr;
       k1yeg3.g3sucu = peBase.peSucu;
       k1yeg3.g3nivt = peBase.peNivt;
       k1yeg3.g3nivc = peBase.peNivc;
       k1yeg3.g3nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peRpro ) <> *null;

                  k1yeg3.g3Rama = peRama;
                  k1yeg3.g3Arse = peArse;
                  k1yeg3.g3Rpro = peRpro;

                  setll %kds( k1yeg3 : 8 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peRpro ) =  *null;

                  k1yeg3.g3Rama = peRama;
                  k1yeg3.g3Arse = peArse;

                  setll %kds( k1yeg3 : 7 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( peRpro ) =  *null;

                  k1yeg3.g3Rama = peRama;

                  setll %kds( k1yeg3 : 6 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;
            other;
                  setll %kds( k1yeg3 : 5 ) ctweg3;
                  if not %equal ( ctweg3 );
                     return *off;
                  endif;
          endsl;
       else;
         setll %kds( k1yeg3 : 5 ) ctweg3;
         if not %equal ( ctweg3 );
            return *off;
         endif;
       endif;

       return *on;

      /end-free

     P COWGRAI_chkCtweg3...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_setCtweg3(): Graba Primas por provincia              *
      *                                                              *
      *    peDsEg3  ( output )  Registro con ctweg3   ( opcional )   *
      *                                                              *
      * Retorna *on = Grabo ok / *off = No grabo                     *
      * ------------------------------------------------------------ *
     P COWGRAI_setCtweg3...
     P                 B                   export
     D COWGRAI_setCtweg3...
     D                 pi              n
     D   peDsEg3                           likeds(dsctweg3_t)
     D                                     options( *omit : *nopass )

     D   @@base        ds                  likeds(paramBase)
     D   @@DsOEg3      ds                  likerec( c1weg3 : *output )

      /free

       COWGRAI_inz();

       @@base.peEmpr = peDseg3.g3empr;
       @@base.peSucu = peDseg3.g3sucu;
       @@base.peNivt = peDseg3.g3nivt;
       @@base.peNivc = peDseg3.g3nivc;
       @@base.peNiv1 = peDseg3.g3nivc;
       @@base.peNit1 = peDseg3.g3nivt;

       if COWGRAI_chkCtweg3 ( @@base
                            : peDsEg3.g3nctw
                            : peDsEg3.g3rama
                            : peDsEg3.g3arse
                            : peDsEg3.g3rpro );
         return *off;
       endif;

       eval-corr @@DsOEg3 = peDsEg3;
       monitor;
         write c1weg3 @@DsOEg3;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free
     P COWGRAI_setCtweg3...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_updCtweg3(): Actualiza Primas por provincia          *
      *                                                              *
      *    peDsEg3  ( output )  Registro con ctweg3   ( opcional )   *
      *                                                              *
      * Retorna *on = Actualizo ok / *off = No actualizo             *
      * ------------------------------------------------------------ *
     P COWGRAI_updCtweg3...
     P                 B                   export
     D COWGRAI_updCtweg3...
     D                 pi              n
     D   peDsEg3                           likeds(dsctweg3_t)
     D                                     options( *omit : *nopass )

     D   @@base        ds                  likeds(paramBase)
     D   @@DsOEg3      ds                  likerec( c1weg3 : *output )
     D   k1yeg3        ds                  likerec( c1weg3 : *key    )

      /free

       COWGRAI_inz();

       k1yeg3.g3Empr = peDseg3.g3empr;
       k1yeg3.g3sucu = peDseg3.g3sucu;
       k1yeg3.g3nivt = peDseg3.g3nivt;
       k1yeg3.g3nivc = peDseg3.g3nivc;
       k1yeg3.g3nctw = peDsEg3.g3nctw;
       k1yeg3.g3rama = peDsEg3.g3rama;
       k1yeg3.g3arse = peDsEg3.g3arse;
       k1yeg3.g3rpro = peDsEg3.g3rpro;
       chain %kds( k1yeg3 : 8 ) ctweg3;
       if not %found( ctweg3 );
          return *off;
       endif;

       eval-corr @@DsOEg3 = peDsEg3;
       monitor;
         update c1weg3 @@DsOEg3;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free
     P COWGRAI_updCtweg3...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getCtw001(): Retorna datos de Impuestos %            *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *    peDs001  ( output )  Registro con ctw001                  *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_getCtw001...
     P                 B                   export
     D COWGRAI_getCtw001...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peDs001                           likeds(dsCtw001_t) dim( 999 )

     D k1y001          ds                  likerec(c1w001:*key)
     D DsI001          ds                  likerec(c1w001:*input)

      /Free

       COWGRAI_inz();

       clear peDs001;

       k1y001.w1Empr = peBase.peEmpr;
       k1y001.w1Sucu = peBase.peSucu;
       k1y001.w1Nivt = peBase.peNivt;
       k1y001.w1Nivc = peBase.peNivc;
       k1y001.w1Nctw = peNctw;
       k1y001.w1Rama = peRama;

       setll %kds( k1y001 : 6 ) ctw001;
       if not %equal ( ctw001 );
         return *off;
       endif;
       reade(n) %kds( k1y001 : 6 ) ctw001 DsI001;
       dow not %eof( ctw001 );
         eval-corr peDs001 = DsI001;
         reade(n) %kds( k1y001 : 6 ) ctw001;
       enddo;

       return *on;

      /end-free

     P COWGRAI_getCtw001...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkCtw001(): Valida si existen Impuestos %           *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_chkCtw001...
     P                 B                   export
     D COWGRAI_chkCtw001...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

     D   k1y001        ds                  likerec( c1w001 : *key )

      /Free

       COWGRAI_inz();

       k1y001.w1Empr = peBase.peEmpr;
       k1y001.w1Sucu = peBase.peSucu;
       k1y001.w1Nivt = peBase.peNivt;
       k1y001.w1Nivc = peBase.peNivc;
       k1y001.w1Nctw = peNctw;
       k1y001.w1Rama = peRama;

       chain %kds( k1y001 : 6 ) ctw001;
       if %found( ctw001 );
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_chkCtw001...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_setCtw001(): Graba Impuestos %                       *
      *                                                              *
      *    peDs001  ( output )  Registro con ctweg3   ( opcional )   *
      *                                                              *
      * Retorna *on = Grabo ok / *off = No grabo                     *
      * ------------------------------------------------------------ *
     P COWGRAI_setCtw001...
     P                 B                   export
     D COWGRAI_setCtw001...
     D                 pi              n
     D   peDs001                           likeds(dsCtw001_t)
     D                                     options( *omit : *nopass )

     D   peBase        ds                  likeds(paramBase)
     D   @@DsO001      ds                  likerec( c1w001 : *output )

      /free

       COWGRAI_inz();

       peBase.peEmpr = peDs001.w1Empr;
       peBase.peSucu = peDs001.w1Sucu;
       peBase.peNivt = peDs001.w1Nivt;
       peBase.peNivc = peDs001.w1Nivc;
       peBase.peNiv1 = peDs001.w1Nivc;
       peBase.peNit1 = peDs001.w1Nivt;

       if COWGRAI_chkCtw001 ( peBase
                            : peDs001.w1Nctw
                            : peDs001.w1Rama );
         return *off;
       endif;

       eval-corr @@DsO001 = peDs001;
       monitor;
         write c1w001 @@DsO001;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free
     P COWGRAI_setCtw001...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getCtw001C(): Retorna datos de Impuestos %           *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *    peDs01C  ( output )  Registro con ctw001C                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_getCtw001C...
     P                 B                   export
     D COWGRAI_getCtw001C...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peDs01C                           likeds(dsCtw001C_t) dim( 999 )

     D k1y01C          ds                  likerec(c1w001C:*key)
     D DsI01C          ds                  likerec(c1w001C:*input)

      /Free

       COWGRAI_inz();

       clear peDs01C;

       k1y01C.w1Empr = peBase.peEmpr;
       k1y01C.w1Sucu = peBase.peSucu;
       k1y01C.w1Nivt = peBase.peNivt;
       k1y01C.w1Nivc = peBase.peNivc;
       k1y01C.w1Nctw = peNctw;
       k1y01C.w1Rama = peRama;

       setll %kds( k1y01C : 6 ) ctw001C;
       if not %equal ( ctw001C );
         return *off;
       endif;
       reade(n) %kds( k1y01C : 6 ) ctw001C DsI01C;
       dow not %eof( ctw001C );
         eval-corr peDs01C = DsI01C;
         reade(n) %kds( k1y01C : 6 ) ctw001C;
       enddo;

       return *on;

      /end-free

     P COWGRAI_getCtw001C...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_chkCtw001C(): Valida si existen Impuestos %          *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_chkCtw001C...
     P                 B                   export
     D COWGRAI_chkCtw001C...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

     D   k1y01C        ds                  likerec( c1w001C : *key )

      /Free

       COWGRAI_inz();

       k1y01C.w1Empr = peBase.peEmpr;
       k1y01C.w1Sucu = peBase.peSucu;
       k1y01C.w1Nivt = peBase.peNivt;
       k1y01C.w1Nivc = peBase.peNivc;
       k1y01C.w1Nctw = peNctw;
       k1y01C.w1Rama = peRama;

       chain %kds( k1y01C : 6 ) ctw001C;
       if %found( ctw001C );
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_chkCtw001C...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_setCtw001C(): Graba Impuestos %                      *
      *                                                              *
      *    peDs01C  ( output )  Registro con ctw001C  ( opcional )   *
      *                                                              *
      * Retorna *on = Grabo ok / *off = No grabo                     *
      * ------------------------------------------------------------ *
     P COWGRAI_setCtw001C...
     P                 B                   export
     D COWGRAI_setCtw001C...
     D                 pi              n
     D   peDs01C                           likeds(dsCtw001C_t)
     D                                     options( *omit : *nopass )

     D   peBase        ds                  likeds(paramBase)
     D   @@DsO01C      ds                  likerec( c1w001C : *output )

      /free

       COWGRAI_inz();

       peBase.peEmpr = peDs01C.w1Empr;
       peBase.peSucu = peDs01C.w1Sucu;
       peBase.peNivt = peDs01C.w1Nivt;
       peBase.peNivc = peDs01C.w1Nivc;
       peBase.peNiv1 = peDs01C.w1Nivc;
       peBase.peNit1 = peDs01C.w1Nivt;

       if COWGRAI_chkCtw001C( peBase
                            : peDs01C.w1Nctw
                            : peDs01C.w1Rama );
         return *off;
       endif;

       eval-corr @@DsO01C = peDs01C;
       monitor;
         write c1w001C @@DsO01C;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free
     P COWGRAI_setCtw001C...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getImpuestosCotizacion(): Retorna Impuestos de una   *
      *                                   cotizacion.                *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *    peImpu   ( output )  Ds con los impuestos                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_getImpuestosCotizacion...
     P                 b                   export
     D COWGRAI_getImpuestosCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peImpu                            likeds(Impuesto)

     D Reg001          ds                  likeds(dsctw001_t) dim(999)
     D Reg001C         s             10i 0
     D peW001c         ds                  likeds(dsctw001c_t) dim(999)
     D peW001Cc        s             10i 0

      /free

       COWGRAI_inz();

       clear peImpu;

       if COWGRAI_getCtw001( peBase
                           : peNctw
                           : peRama
                           : Reg001  ) = *off;
          return *off;
       endif;

       if COWGRAI_getCtw001c( peBase
                            : peNctw
                            : peRama
                            : peW001c ) = *off;
          return *off;
       endif;

       peImpu.cobl = 'XX';
       peImpu.xrea = peW001c(1).w1xrea;
       peImpu.read = peW001c(1).w1read;
       peImpu.xopr = peW001c(1).w1xopr;
       peImpu.copr = peW001c(1).w1copr;
       peImpu.xref = Reg001(1).w1xref;
       peImpu.refi = Reg001(1).w1refi;
       peImpu.dere = Reg001(1).w1dere;
       peImpu.seri = Reg001(1).w1seri;
       peImpu.seem = Reg001(1).w1seem;
       peImpu.pimi = Reg001(1).w1pimi;
       peImpu.impi = Reg001(1).w1impi;
       peImpu.psso = Reg001(1).w1psso;
       peImpu.sers = Reg001(1).w1sers;
       peImpu.pssn = Reg001(1).w1pssn;
       peImpu.tssn = Reg001(1).w1tssn;
       peImpu.pivi = Reg001(1).w1pivi;
       peImpu.ipr1 = Reg001(1).w1ipr1;
       peImpu.pivn = Reg001(1).w1pivn;
       peImpu.ipr4 = Reg001(1).w1ipr4;
       peImpu.pivr = Reg001(1).w1pivr;
       peImpu.ipr3 = Reg001(1).w1ipr3;
       peImpu.ipr6 = Reg001(1).w1ipr6;
       peImpu.ipr7 = Reg001(1).w1ipr7;
       peImpu.ipr8 = Reg001(1).w1ipr8;

       return *on;

      /end-free

     P COWGRAI_getImpuestosCotizacion...
     P                 e

      * ------------------------------------------------------------ *
      * COWGRAI_getPendientes(): Retorna si tiene movimientos        *
      *                          pendientes en ctw00003              *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peArcd   ( imput  )  Número de Artículo                   *
      *    peSpol   ( imput  )  SuperPoliza                          *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWGRAI_getPendientes...
     P                 b                   export
     D COWGRAI_getPendientes...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1y003          ds                  likerec( c1w00003 : *key )

      /free

       COWGRAI_inz();

        k1y003.w0arcd = peArcd;
        k1y003.w0spol = peSpol;
        k1y003.w0empr = peBase.peEmpr;
        k1y003.w0sucu = peBase.peSucu;
        k1y003.w0nivt = peBase.peNivt;
        k1y003.w0nivc = peBase.peNivc;
        setgt  %kds( k1y003 : 6 ) ctw00003;
        readpe %kds( k1y003 : 6 ) ctw00003;
        if not %eof( ctw00003 );
          if ( w0cest = 1 and w0cses  = 1 ) or
             ( w0cest = 1 and w0cses  = 2 ) or
             ( w0cest = 5 and w0cses  = 3 ) or
             ( w0cest = 5 and w0cses  = 4 ) or
             ( w0cest = 7 and w0cses  = 4 ) or
             ( w0cest = 7 and w0cses  = 5 );

            return *on;

          endif;
        endif;

        return *off;

      /end-free

     P COWGRAI_getPendientes...
     P                 e
      * ------------------------------------------------------------ *
      * COWGRAI_getPremio(): Obtener Premio                          *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWGRAI_getPremio...
     P                 B                   export
     D COWGRAI_getPremio...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1y001        ds                    likerec( c1w001 : *key )

      /free

       COWGRAI_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds ( k1y001 : 6 ) ctw001;

       return w1prem;

      /end-free

     P COWGRAI_getPremio...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_getCliente(): Retorna datos del cliente              *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     peClie   (output) Estructura de Cliente                  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWGRAI_getCliente...
     P                 B                   export
     D COWGRAI_getCliente...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peClie                            likeds(ClienteCot_t)

     D @@Nase          s              7  0
     D peAseg          ds                  likeds(Asegurado_t) dim(999)
     D peAsegC         s             10i 0

      /free

       COWGRAI_inz();

       clear peAseg;
       clear peAsegC;
       clear peClie;

       if COWRTV_getAsegurado( peBase
                             : peNctw
                             : peAseg
                             : peAsegC
                             : *omit   );


         peClie.asen = peAseg(1).w3Asen;
         peClie.tido = peAseg(1).w3Tido;
         peClie.nrdo = peAseg(1).w3Nrdo;
         peClie.nomb = peAseg(1).w3Nomb;
         peClie.cuit = peAseg(1).w3Cuit;

         select;
           when peAseg(1).w3Tiso = 80 or peAseg(1).w3Tiso = 81;
             peClie.tipe = 'C';         // Consorcio
           when peAseg(1).w3Tiso = 98;
             peClie.tipe = 'F';         // Persona Física
           other;
             peClie.tipe = 'J';         // Persona Jurídica
         endsl;

         peClie.proc = SVPTAB_getProvincia( peAseg(1).w3Rpro );
         peClie.rpro = peAseg(1).w3Rpro;
         peClie.copo = peAseg(1).w3Copo;
         peClie.cops = peAseg(1).w3Cops;
         peClie.civa = peAseg(1).w3Civa;

         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_getCliente...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_setRelacion(): Graba relación de cotización AP y RC  *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peArcd   (input)  Artículo                               *
      *     peNctw   (input)  Nro de Cotización Robo                 *
      *     peNctx   (input)  Nro de Cotización AP                   *
      *     peNcty   (input)  Nro de Cotización RC                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWGRAI_setRelacion...
     P                 B                   export
     D COWGRAI_setRelacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peNctw                       7  0 const
     D   peNctx                       7  0 const
     D   peNcty                       7  0 const

     D k1y099          ds                  likerec(c1w099:*key)

      /free

       COWGRAI_inz();

       k1y099.w9Empr = peBase.peEmpr;
       k1y099.w9Sucu = peBase.peSucu;
       k1y099.w9Nivt = peBase.peNivt;
       k1y099.w9Nivc = peBase.peNivc;
       k1y099.w9Nctw = peNctw;
       k1y099.w9Arcd = peArcd;
       chain %kds( k1y099 : 6 ) ctw099;
       if %found( ctw099 );
         return *off;
       endif;

       w9Empr = peBase.peEmpr;
       w9Sucu = peBase.peSucu;
       w9Nivt = peBase.peNivt;
       w9Nivc = peBase.peNivc;
       w9Nctw = peNctw;
       w9Arcd = peArcd;
       w9Nctx = peNctx;
       w9Ncty = peNcty;

       write c1w099;

       return *on;

      /end-free

     P COWGRAI_setRelacion...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_chkRelacionAP(): Chequea si la cotizacion AP esta    *
      *                          relacionada                         *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNctx   (input)  Nro de Cotización AP                   *
      *     peArcd   (output) Artículo de Superpoliza de Robo (opc)  *
      *     peNctw   (output) Nro. de cotización de Robo      (opc)  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWGRAI_chkRelacionAP...
     P                 B                   export
     D COWGRAI_chkRelacionAP...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctx                       7  0 const
     D   peArcd                       6  0 options( *omit : *nopass )
     D   peNctw                       7  0 options( *omit : *nopass )

     D k1y901          ds                  likerec(c1w09901:*key)

      /free

       COWGRAI_inz();

       k1y901.w9Empr = peBase.peEmpr;
       k1y901.w9Sucu = peBase.peSucu;
       k1y901.w9Nivt = peBase.peNivt;
       k1y901.w9Nivc = peBase.peNivc;
       k1y901.w9Nctx = peNctx;
       chain %kds( k1y901 : 5 ) ctw09901;
       if %found( ctw09901 );
         if %parms >= 3 and %addr( peArcd ) <> *Null;
           peArcd = w9Arcd;
         endif;
         if %parms >= 4 and %addr( peNctw ) <> *Null;
           peNctw = w9Nctw;
         endif;
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_chkRelacionAP...
     P                 E
      * ------------------------------------------------------------ *
      * COWGRAI_chkRelacionRC(): Chequea si la cotizacion RC esta    *
      *                          relacionada                         *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNcty   (input)  Nro de Cotización AP                   *
      *     peArcd   (output) Artículo de Superpoliza de Robo (opc)  *
      *     peNctw   (output) Nro. de cotización de Robo      (opc)  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWGRAI_chkRelacionRC...
     P                 B                   export
     D COWGRAI_chkRelacionRC...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNcty                       7  0 const
     D   peArcd                       6  0 options( *omit : *nopass )
     D   peNctw                       7  0 options( *omit : *nopass )

     D k1y902          ds                  likerec(c1w09902:*key)

      /free

       COWGRAI_inz();

       k1y902.w9Empr = peBase.peEmpr;
       k1y902.w9Sucu = peBase.peSucu;
       k1y902.w9Nivt = peBase.peNivt;
       k1y902.w9Nivc = peBase.peNivc;
       k1y902.w9Ncty = peNcty;
       chain %kds( k1y902 : 5 ) ctw09902;
       if %found( ctw09902 );
         if %parms >= 3 and %addr( peArcd ) <> *Null;
           peArcd = w9Arcd;
         endif;
         if %parms >= 4 and %addr( peNctw ) <> *Null;
           peNctw = w9Nctw;
         endif;
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_chkRelacionRC...
     P                 E

      * ------------------------------------------------------------ *
      * COWGRAI_getNroCotiXSpol(): Retorna Número de Cotización      *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peArcd   ( imput  )  Número de Artículo                   *
      *    peSpol   ( imput  )  SuperPoliza                          *
      *                                                              *
      * Retorna W0NCTW                                               *
      * ------------------------------------------------------------ *
     P COWGRAI_getNroCotiXSpol...
     P                 b                   export
     D COWGRAI_getNroCotiXSpol...
     D                 pi             7  0
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1y003          ds                  likerec( c1w00003 : *key )

      /free

       COWGRAI_inz();

        k1y003.w0arcd = peArcd;
        k1y003.w0spol = peSpol;
        k1y003.w0empr = peBase.peEmpr;
        k1y003.w0sucu = peBase.peSucu;
        k1y003.w0nivt = peBase.peNivt;
        k1y003.w0nivc = peBase.peNivc;
        chain %kds( k1y003 : 6 ) ctw00003;
        if %found( ctw00003 );
          return w0Nctw;
        endif;

        return *zeros;

      /end-free

     P COWGRAI_getNroCotiXSpol...
     P                 e

      * ------------------------------------------------------------ *
      * COWGRAI_getNroCotiAPRC(): Retorna Nro de cotización de AP y  *
      *                           RC                                 *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peArcd   (input)  Artículo                               *
      *     peNctw   (input)  Nro de Cotización Robo                 *
      *     peNctx   (input)  Nro de Cotización AP                   *
      *     peNcty   (input)  Nro de Cotización RC                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWGRAI_getNroCotiAPRC...
     P                 B                   export
     D COWGRAI_getNroCotiAPRC...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peNctw                       7  0 const
     D   peNctx                       7  0
     D   peNcty                       7  0

     D k1y099          ds                  likerec(c1w099:*key)

      /free

       COWGRAI_inz();

       k1y099.w9Empr = peBase.peEmpr;
       k1y099.w9Sucu = peBase.peSucu;
       k1y099.w9Nivt = peBase.peNivt;
       k1y099.w9Nivc = peBase.peNivc;
       k1y099.w9Nctw = peNctw;
       k1y099.w9Arcd = peArcd;
       chain %kds( k1y099 : 6 ) ctw099;
       if %found( ctw099 );
         peNctx = w9Nctx;
         peNcty = w9Ncty;
         return *on;
       endif;

       return *off;

      /end-free

     P COWGRAI_getNroCotiAPRC...
     P                 E
