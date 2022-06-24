     H nomain
     H datedit(*DMY/)
     H option(*noshowcpy:*srcstmt:*nounref)
      * ************************************************************ *
      * COWVEH: Cotización Vehiculos                                 *
      * ------------------------------------------------------------ *
      * Barranco Julio                       03-Sep-2015             *
      * ------------------------------------------------------------ *
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
      *> TEXT('Programa de Servicio: Cotización Vehículos') <*       *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWVEH)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWVEH)) <*         *
      *> IGN: DLTSPLF FILE(COWVEH)                           <*     *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * 15/12/15 - Se realizaron cambios de parametros            *  *
      * SGF 05/08/2016: Recompilo por ACRC en CTWET0/ER0.            *
      * SGF 06/08/2016: Agrego lógica a _getLimitesRc().             *
      *                 En _saveCoberturas() para calcular los lími- *
      *                 tes de RC, usaba pePaxc en lugar de p@cveh.  *
      * SFA 25/08/2016: Marco cobertura por defecto en renovacion    *
      * SFA 31/08/2016: Cambio procedimiento COWGRAI_deleteImpuestos *
      *                 por COWGRAI_deleteImpuesto                   *
      * LRG 01/09/2016: Se agrega parámetro ( Accesorios ) en        *
      *                 cotizarWeb/ReCotizarWeb                      *
      * SFA 08/09/2016: al grabar alta gama estaba sumando todos los *
      *                 vehiculos por Rama/Arse                      *
      * SGF 07/10/2016: Agrego condiciones para 15% descuento C+/D.  *
      *                 Es sólo para Autos y 4x4.                    *
      * LRG 01/11/2016: Modifica COWVEH_saveDescuentosRec(), graba   *
      *                 AltaGama.-                                   *
      * LRG 02/11/2016: Modifica COWVEH_saveDescuentos()             *
      *                          COWVEH_saveDescuentosRec()          *
      *                          0km                                 *
      * LRG 04/11/2016: Modifica COWVEH_chkCotizar() - se Corrige    *
      *                          datos de mensaje COW0021            *
      * LRG 24/11/2016: Modifica COWVEH_getDescuentos si el mismo    *
      *                          tiene marca de permite grabar en 0  *
      *                          igual a 'S' aplica descuento.-      *
      * LRG 29/11/2016: Modifica COWVEH_saveDescuentos()             *
      *                          COWVEH_saveDescuentosRec()          *
      *                          si el mismo permite grabar en cero  *
      *                          pcbp = 0.-                          *
      * LRG 06/12/2016: Modifica COWVEH_saveCoberturas() para reno   *
      *                          se obtiene correctamente la         *
      *                          superpóliza anterior                *
      * SGF 14/12/2016: Nueva logica para determinar cobertura por   *
      *                 defecto.                                     *
      * LRG 26/12/2016: En renovación se envía código de Rastreador  *
      *                 anterior SPVVEH_getCodDeRastreador           *
      * JSN 13/01/2017: Se agrego procedimento de getCaracteristica  *
      * LRG 20/01/2017: Se agregan Coberturas de auto D4-D5-D6-D7    *
      *                 dentro del procedimiento COWVEH_getPorceCob  *
      * LRG 23/01/2017: Nuevo procedimiento _getListaBuenResultado   *
      *                 Retorna Lista cod. de Buen Resultado,        *
      *                 también valida si el productor tiene         *
      *                 tratamiento especial, contiene marca de      *
      *                 Habilitar o no mostrar la misma.-            *
      * LRG 25/04/2017: Se modifica procedimiento getCoberturas()    *
      *                 Para PickUps se deben informar todas las     *
      *                 coberturas.                                  *
      * LRG 06/06/2017: Renovacion: Al aumentar de cobertura         *
      *                 la Inspeccion es obligatoria.-               *
      * LRG 28/09/2017: saveDescuentos/saveDescuentosRC, aplicar     *
      *                 recargo 17  4/6                              *
      * LRG 12/10/2017: Validar que año de vehiculo no llegue vacio  *
      *                                                              *
      * LRG 04/12/2017: Renovacion: se corrige el siguiente proced:  *
      *                 COWVEH_updInspeccionReno, devuelve marca de  *
      *                 Inspeccion 'S' para coberturas mayores a la  *
      *                 que tiene por Default                        *
      * LRG 17/01/2018: Error al cotizar 4x4 Carrozadas con GNC      *
      * LRG 18/03/2018: Se modifica COWVEH_saveDescuentosRec()       *
      *                 Se corrige busqueda en set250 falta mar1 ='C'*
      *                                                              *
      * JSN 10/05/2018: Se modifica COWVEH_saveDescuentosRec()       *
      *                 Se corrige busqueda en set250 falta mar1 ='C'*
      *                 para Alta Gama                               *
      * LRG 21/05/2018: Se recompila para exportar procedimiento     *
      *                 _codigoZona                                  *
      *                                                              *
      * LRG 16/10/2018: Se corrige calculo de sumaasegurada minima   *
      *                                                              *
      * GIO 12/02/2019: Adecuacion para beneficio 0-Kms Segundo Año  *
      *                 Nueva funcion getCeroKmsSegundoAÑo           *
      *                 Graba Beneficios 993 y 994 en CTWET4         *
      *                                                              *
      * GIO 06/03/2019: RM#4194 Corrige acceso a PAHET0 en rutina    *
      *                 getCeroKmsSegundoAÑo                         *
      *                                                              *
      * LRG 22/09/2018: Agrego _confirmarInspeccion()                *
      *                                                              *
      * EXT 19/11/2018: Se modifica COWVEH_saveDescuentos() y        *
      *                 COWVEH_saveDescuentosRec() para tratar el    *
      *                 nuevo descuento 980                          *
      * EXT 14/01/2019: Nuevo cotizarWeb2 y reCotizarWeb2            *
      *                                                              *
      * GIO 21/03/2019: RM#03835 Desarrollo Servicio REST WSRECV     *
      *                 Nuevas funciones:                            *
      *                 - COWVEH_chkEndosoPoliza                     *
      *                 - COWVEH_chkEndosoComponente                 *
      *                 - COWVEH_setEndosoPoliza                     *
      *                 - COWVEH_setEndosoComponente                 *
      *                                                              *
      * SGF 21/03/2019: No se usa más _chkDescAltaGama() y se usa en *
      *                 su lugar _chkDescAltaGama2(). La idea es que *
      *                 el % de descuento es distinto si el auto es  *
      *                 0 KM o no.                                   *
      *                 En _saveDescuentos() agrego un recargo de    *
      *                 acuerdo a si es un Productor Cabecera espe-  *
      *                 cial (_isCabeceraEspecial()).                *
      * JSN 31/05/2019: Se agrega _isFlota() en los procedimientos   *
      *                 _SaveCoberturas(),  _SaveCoberturasRec()     *
      *                 _chkCotizar() y se crea procedimiento        *
      *                 _getCoberturasGaus().                        *
      * JSN 12/07/2019: Se modifica el procedimiento _chkCotizar     *
      *                 agregando llamada al getCeroKmsSegundoAÑo,   *
      *                 para determinar si se debe tratar como 0km   *
      *                 después del segundo año.                     *
      * JSN 29/08/2019: Nuevo procedimiento _deletePocoScoring()     *
      * JSN 23/09/2019: Nuevos procedimientos _getCtwet3             *
      *                                       _chkCtwet3             *
      *                                       _setCtwet3             *
      * JSN 01/10/2019: Se modifica el procedimiento _chkCotizar     *
      *                 agregando los parametros Taaj y Cosg, y sus  *
      *                 respectivas validaciones.                    *
      * JSN 07/10/2019: Se crea el procedimiento:                    *
      *                 _saveScoring().                              *
      *     08/10/2019: _validaPreguntas().                          *
      *                 _updCtwet3().                                *
      *                 _updScoring().                               *
      *                 Se modifica el procedimiento _cotizador()    *
      *                 agregando los parametros Taaj y Cosg, y sus  *
      *                 respectivas validaciones.                    *
      *     09/10/2019: _getPrimasXCoberturas().                     *
      *                 _aplicaScoring().                            *
      *     15/10/2019: _updPrimasXCoberturas().                     *
      *                 _cotizarWeb3().                              *
      *     16/10/2019: _reCotizarWeb3().                            *
      *                 _chkScoringEnCotizacion().                   *
      * SGF 09/01/2020: Nuevos parametros para getPorceCob(): se agre*
      *                 gan Codigo de tarifa y marca de tarifa dife- *
      *                 rencial.                                     *
      *                 En la búsqueda de tener una sola tabla de rc *
      *                 y air por tarifa, se cambia la variante de   *
      *                 acceso a SET220 y el capítulo para SET2221.  *
      *                 ATENCION: Solo se cambia para acceder.       *
      * SGF 09/01/2020: Mal en getPorceCob(). En lugar de mover el   *
      *                 campo VHV2 estaba moviendo VHCA.             *
      * JSN 10/03/2020: Se agrega procedimiento _getPorceCob2        *
      * LRG 15/04/2020: Se agrega procedimiento _chkEndoso           *
      * JSN 08/05/2020: Se agrega Procedimientos _chkCtwet5,         *
      *                 _updCtwet5, getCtwet5 y _setCtwet5           *
      * SGF 13/07/2020: Descuento decreciente.                       *
      *                 Exporto _getPrimas() para poder testear el   *
      *                 calculo automaticamente.                     *
      * JSN 15/07/2020: Se modifica longitud de código de error en el*
      *                 procedimento _chkEndoso                      *
      * SGF 26/05/2021: Agrego descuento por pago contado.           *
      * SGF 20/07/2021: Pick Up A Comercial tiene C1 en todas las    *
      *                 zonas (ver Redmine 10272).                   *
      * JSN 13/08/2021: Se agrega condición en el procedimiento      *
      *                 _saveCoberturas                              *
      * SGF 21/07/2021: No te dejo endosar para cambio de vehiculo   *
      *                 si tiene anulacion/arrepentimiento en proce  *
      *                 so.                                          *
      *                                                              *
      * ************************************************************ *
     Fctw000    if   e           k disk    usropn
     Fctwet0    uf a e           k disk    usropn
     Fctwet4    uf a e           k disk    usropn
     Fctwetc    uf a e           k disk    usropn
     Fctwet1    uf a e           k disk    usropn
     Fctwetc01  if   e           k disk    usropn rename(c1wetc:c1wetc01)
     Ftab009    if   e           k disk    usropn
     Fset1031   if   e           k disk    usropn
     Fset250    if   e           k disk    usropn
     Fset160    if   e           k disk    usropn
     Fsettar    if   e           k disk    usropn
     Fset204    if   e           k disk    usropn
     Fset210    if   e           k disk    usropn
     Fset227    if   e           k disk    usropn
     Fset625    if   e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fset015    if   e           k disk    usropn  prefix (s015_)
     Fset01601  if   e           k disk    usropn  prefix (s016_)
     Fset017    if   e           k disk    usropn  prefix (s017_)
     Fset018    if   e           k disk    usropn  prefix (s018_)
     Fset124    if   e           k disk    usropn  prefix (s124_)
     Fset220    if   e           k disk    usropn
     Fset225    if   e           k disk    usropn  prefix (s225_)
     Fset215    if   e           k disk    usropn
     Fset621    if   e           k disk    usropn
     Fset2221   if   e           k disk    usropn
     Fset225303 if   e           k disk    usropn
     Fset22531  if   e           k disk    usropn
     Fset22223  if   e           k disk    usropn
     Fsetbre    if   e           k disk    usropn
     Fpahed003  if   e           k disk    usropn
     Fpahet0    if   e           k disk    usropn
     Fset200    if   e           k disk    usropn
     Fset2071   if   e           k disk    usropn
     Fset246    if   e           k disk    usropn  prefix(tx:2)
     Fctwet001  if   e           k disk    usropn rename( c1wet0 : c1wet001 )
     Fsetpat01  if   e           k disk    usropn
     Fpahec0    if   e           k disk    usropn
     Fpahec1    if   e           k disk    usropn
     Fpahec3    if   e           k disk    usropn
     Fgnhdtc    if   e           k disk    usropn
     Fctw00003  if   e           k disk    usropn  rename(c1w000:c1w00003)
     Fsehase    if   e           k disk    usropn
     Fctwet3    uf a e           k disk    usropn
     Fctwet301  if   e           k disk    usropn  rename(c1wet3:c1wet301)
     Fset2202   if   e           k disk    usropn
     Fset2272   if   e           k disk    usropn
     Fctwet5    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowveh_h.rpgle'

     D COWVEH_getPorceCob...
     D                 pr              n
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peMone                       2    const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peCobl                       2    const
     D   peCoss                       2    const
     D   pePcox                       7  4
     D   pePacx                       7  4
     D   pePinx                       7  4
     D   peProx                       7  4
     D   peiFrx                      15  2
     D   peCtre                       5  0 const
     D   peMtdf                       1a   const

     D COWVEH_getLimitesRC...
     D                 pr              n
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

      * --------------------------------------------------- *
      * Tablas AIR y RC
      * --------------------------------------------------- *
     Dsptrcair         pr                  extpgm('SPTRCAIR')
     D  p@ctre                              like(t@ctre)
     D  p@scta                              like(t@scta)
     D  p@mone                              like(t@como)
     D  p@vhca                              like(t@vhca)
     D  p@vhv1                              like(t@vhv1)
     D  p@vhv2                              like(t@vhv2)
     D  p@tarc                              like(t@tarc)
     D  p@tair                              like(t@tair)
     D  p@femi                        8  0
     D  p@mtdf                              like(t@mtdf) options(*nopass)
     D
     D
     D  p@ctre         s                    like(t@ctre)
     D  p@scta         s                    like(t@scta)
     D  p@mone         s                    like(t@como)
     D  p@vhca         s                    like(t@vhca)
     D  p@vhv1         s                    like(t@vhv1)
     D  p@vhv2         s                    like(t@vhv2)
     D  p@tarc         s                    like(t@tarc)
     D  p@tair         s                    like(t@tair)
     D  p@femi         s              8  0
     D  p@mtdf         s                    like(t@mtdf)
     D
     DCOWGRA7          pr                  extpgm('COWGRA7')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
     D   peImpu7                           likeds(primPrem) dim(99)
     D   peImpuC                     10i 0
     D   pePrem7                     15  2
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     d SPFMTPAT        pr                  ExtPgm('SPFMTPAT')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNmat                       25a   const
     d  peFech                        8a   const
     d  peTval                        1a   const
     d  peCuso                        1a   const
     d  peMcod                        3a
     d  peVald                        1a
     d  peRtco                        7a

     d PAR310X3        pr                  extpgm('PAR310X3')
     d  peEmpr                        1a                           const
     d  peFema                        4  0
     d  peFemm                        2  0
     d  peFemd                        2  0

     d PAR317V         pr                  extpgm('PAR317V')
     d  peEmpr                        1a                           const
     d  peSucu                        2a                           const
     d  peArcd                        6  0                         const
     d  peSpol                        9  0                         const
     d  peRama                        2  0                         const
     d  pePoli                        7  0                         const
     d  peErro                        1n
     d  peMens                      512a

     D   peImpu7       ds                  likeds(primPrem) dim(99)
     D   peImpuC       s             10i 0
     D   pePrem7       s             15  2

      * --------------------------------------------------- *
      * Verifica si debe agregar recargo 17% cobertura A
      * --------------------------------------------------- *
     D addRecCobA      pr             1n

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     D Initialized     s              1n

     D wrepl           s          65535a

     D ErrCode         s             10i 0
     D ErrText         s             80A

     Is1t160
     I              t@date                      z@date
     Is1ttar
     I              t@date                      w@date
     Is1t210
     I              t@date                      y@date
     Is1t2202
     I              t@date                      m@date
     Is1t2272
     I              t@date                      n@date

      *--- Definicion de Procedimiento --------------------------------- *
      * ---------------------------------------------------------------- *
      * COWVEH_cotizarWeb():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peNrpp  -  Plan de Pago                           *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de Iva                          *
      *                peAcce  -  Lista de Accesorios                    *
      *        Output:                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  Bonificaciones por cobertura           *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_cotizarWeb...
     P                 B                   export
     D COWVEH_cotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peNrpp                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /free

       COWVEH_inz();

       peErro = *Zeros;

       COWVEH_cotizarWeb2( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco
                         : peVhan
                         : peVhmc
                         : peVhmo
                         : peVhcs
                         : peVhvu
                         : peMgnc
                         : peRgnc
                         : peCopo
                         : peCops
                         : peScta
                         : peClin
                         : peBure
                         : peNrpp
                         : peTipe
                         : peCiva
                         : peAcce
                         : *Zeros
                         : peCtre
                         : pePaxc
                         : peBoni
                         : peImpu
                         : peErro
                         : peMsgs );

       return;

      /end-free

     P COWVEH_cotizarWeb...
     P                 E
      *--- Definicion de Procedimiento --------------------------------- *
      * ---------------------------------------------------------------- *
      * COWVEH_cotizador ():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peCfpg  -  Código Forma de Pago                   *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de Iva                          *
      *                peNrpp  -  Plan de Pago                           *
      *                peAcce  -  Lista de Accesorios                    *
      *                peDesE  -  Descuento Especial                     *
      *                peTaaj  -  Código de Cuestionario                 *
      *                peScor  -  Scoring                                *
      *        Output:                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  Bonificaciones por cobertura           *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_cotizador...
     P                 B                   export
     D COWVEH_cotizador...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peCfpg                       1  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peDesE                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0
     D p@Scta          s              1  0
     D peArcd          s              6  0

     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0
     D rc              s               n

      /free

       COWVEH_inz();

       peErro = *Zeros;

       //Actualizo Informacion del CTW000
       COWGRAI_updCotizacion( peBase
                            : peNctw
                            : peCiva
                            : peTipe
                            : peCopo
                            : peCops
                            : peCfpg
                            : peNrpp );

       //Información de salida

       //si la tarifa viene en cero la busco, sino uso la que llega
       if peCtre = *Zeros;
         f@emi = %dec(%date:*iso);
         CZWUTL_getTarifa(peCtre :
                          *omit  );
       endif;

       //Busco Zona del productor
       p@Scta = CZWUTL_getZonaReal(PeBase.peEmpr :
                                   PeBase.peSucu :
                                   PeBase.peNivt :
                                   PeBase.peNivc :
                                   peScta );

       //Grabo Archivos

       COWVEH_saveCabecera ( peBase :
                             peNctw :
                             peRama :
                             peArse :
                             pePoco :
                             peVhan :
                             peVhmc :
                             peVhmo :
                             peVhcs :
                             peVhvu :
                             peMgnc :
                             peRgnc :
                             peCopo :
                             peCops :
                             p@Scta :
                             peClin :
                             peBure :
                             peCfpg :
                             peTipe :
                             peCtre :
                             peDesE );
        // Graba Accesorios...
        if COWVEH_saveAccesorios( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : pePoco
                                : peAcce );
        endif;

       // Valida y Graba si el Articulo tiene Scoring

       // Obtener artículo.
       clear peArcd;
       peArcd = COWGRAI_getArticulo( peBase
                                   : peNctw );

       if SVPART_chkScoring( peArcd
                           : peRama
                           : peArse );

          if COWVEH_validaPreguntas( peBase
                                   : peNctw
                                   : peRama
                                   : peArse
                                   : pePoco
                                   : peTaaj
                                   : peScor
                                   : peErro
                                   : peMsgs );

            if not COWVEH_saveScoring( peBase
                                     : peNctw
                                     : peRama
                                     : peArse
                                     : pePoco
                                     : peTaaj
                                     : peScor );

              %subst(wrepl:1:7) = %trim(%char(peNctw));

              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0119'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );

            endif;
          endif;
       endif;

       //Grabo las bonificaciones y recargos que recibo en la DS
       //si ya vienen

       if peBoni(1).cobl <> *blanks;

         COWVEH_saveDescuentosRec ( peBase :
                                    peNctw :
                                    peRama :
                                    peArse :
                                    pePoco :
                                    peBoni);
       endif;

       COWGRAI_SaveImpuestos( peBase :
                              peNctw :
                              peRama :
                              peArse );

       COWVEH_saveCoberturas( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              pePoco :
                              peVhan :
                              peVhmc :
                              peVhmo :
                              peVhcs :
                              peVhvu :
                              peMgnc :
                              peRgnc :
                              peCopo :
                              peCops :
                              peScta :
                              peClin :
                              peBure :
                              peCfpg :
                              peTipe :
                              peCtre :
                              pePaxc :
                              peBoni :
                              peImpu );

       COWGRAI_getTipoDeOperacion ( peBase : peNctw : @@tiou : @@stou : @@stos);

       if @@tiou = 2;

         ErrText = COWVEH_Error(ErrCode);

         if COWVEH_NOCOB = ErrCode;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0134'
                        : peMsgs );

         endif;

         rc = COWVEH_updInspeccionReno( peBase
                                      : peNctw
                                      : peRama
                                      : peArse
                                      : pePoco
                                      : pePaxc );


       endif;

       COWRTV_getBonVehiculo (peBase :
                              peNctw :
                              peRama :
                              peArse :
                              pepoco :
                              peBoni :
                              peErro :
                              peMsgs );

       return;

      /end-free

     P COWVEH_cotizador...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_reCotizar():   Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peNrpp  -  Plan de Pago                           *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de Iva                          *
      *                peAcce  -  Lista de Accesorios                    *
      *        Output:                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  Bonificaciones por cobertura           *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_reCotizarWeb...
     P                 B                   export
     D COWVEH_reCotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peNrpp                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peAcce                            likeds( AccVeh_t ) dim(100) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh)  dim(20)
     D   peBoni                            likeds(bonVeh)  dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /free

       COWVEH_inz();

       COWVEH_recotizarWeb2( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : pePoco
                           : peVhan
                           : peVhmc
                           : peVhmo
                           : peVhcs
                           : peVhvu
                           : peMgnc
                           : peRgnc
                           : peCopo
                           : peCops
                           : peScta
                           : peClin
                           : peBure
                           : peNrpp
                           : peTipe
                           : peCiva
                           : peAcce
                           : *Zeros
                           : peCtre
                           : pePaxc
                           : peBoni
                           : peImpu
                           : peErro
                           : peMsgs );

       return;

      /end-free

     P COWVEH_reCotizarWeb...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_anioVehiculo():Valida que el año del vehículo sea valido  *
      *                       para la emisión.                           *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peVhan  -  Año del Vehículo                       *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_anioVehiculo...
     P                 B
     D COWVEH_anioVehiculo...
     D                 pi              n
     D   peVhan                       4    const

     D k1y009          ds                  likerec(t9reg:*key)
     D @vhan           s              4a
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       COWVEH_inz();

       @vhan = %xlate( min : may : peVhan );

       //Si es 0KM es valido.
       if %trim(@vhan) = '0KM';

         return *on;

       Endif;

       //Si es caracter diferente a 0KM, deve ser numerico...
       if %check('0123456789':%trim(peVhan)) <> *zero or peVhan = *blanks;
         SetError( COWVEH_ANIONP
                 : 'Año de Vehículo Invalido para Emision' );
         return *Off;
       endif;


       //Si el año es mayor al archivo devuelvo OK, sino genero el error
       setll *start tab009;
       read tab009;
       if %int(peVhan) >= t9anio;

         return *on;

       else;

         SetError( COWVEH_ANIONP
                 : 'Año de Vehículo Invalido para Emision' );
         return *Off;

       endif;

       return *Off;

      /end-free

     P COWVEH_anioVehiculo...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_vehiculo0km() :Valida si es un 0KM o no                   *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peVhan  -  Año del Vehículo                       *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_vehiculo0km...
     P                 B
     D COWVEH_vehiculo0km...
     D                 pi             1
     D   peVhan                       4    const

     D k1y009          ds                  likerec(t9reg:*key)

      /free

       COWVEH_inz();


       if %trim(Pevhan) = '0km' or %trim(Pevhan) = '0Km' or
          %trim(Pevhan) = '0KM' or %trim(Pevhan) = '0kM';

         return 'S';

       Endif;

       return 'N';


      /end-free

     P COWVEH_vehiculo0km...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_codigoTarifa():Busca la tarifa dependiendo de la fecha    *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peFtar  -  Fecha de tarifa                        *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_codigoTarifa...
     P                 B
     D COWVEH_codigoTarifa...
     D                 pi             5  0
     D   peFtar                       8  0 const

     D k1ytar          ds                  likerec(s1ttar:*key)

      /free

       COWVEH_inz();

       k1ytar.t@fini = peFtar;

       setgt  %kds( k1ytar : 1 ) settar;
       readp settar;
       dow not %eof;

         if t@fini <= peFtar;
           return t@ctre;
         endif;

         readp settar;
       enddo;

       return 0;

      /end-free

     P COWVEH_codigoTarifa...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_codigoZona()  :Busca la Zona a la que Pertenece el auto   *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_codigoZona...
     P                 B                   export
     D COWVEH_codigoZona...
     D                 pi             1  0
     D   peCopo                       5  0 const
     D   peCops                       1  0 const

     D k1yloc          ds                  likerec(g1tloc:*key)

      /free

       COWVEH_inz();

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;

       chain  %kds( k1yloc : 2 ) gntloc;
       if %found;

           return loscta;

       endif;

       return 0;

      /end-free

     P COWVEH_codigoZona...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getTablaRC()  :obtener la tabla RC.                       *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getTablaRC...
     P                 B                   export
     D COWVEH_getTablaRC...
     D                 pi              n
     D   peCtre                       5  0  const
     D   peScta                       1  0  const
     D   peMone                       2     const
     D   peMgnc                       1     const
     D   pevhni                       1     const
     D   peVhca                       2  0  const
     D   peVhv1                       1  0  const
     D   peVhv2                       1  0
     D   peFemi                       8  0  const
     D   peMtdf                       1     const
     D   peTarc                       2  0
     D   peTair                       2  0


      /free

       COWVEH_inz();


       //buscar

       p@vhv2 = peVhv2;

       // ----------------------------------------
       // Pick Up A y B
       // ----------------------------------------
       if (peVhca = 4 and peVhv1 <> 6 and peMtdf = ' ')
           or
           peVhca = 5;
           if peMgnc = 'S';
              p@vhv2 = 5;
           endif;
       endif;

       // ----------------------------------------
       // Pick Up A de uso particular:
       // Son las 4-6-3 (Nacional) y
       // Son las 4-6-4 (Importada)
       // No se diferencian por motorización
       // Valen lo mismo Nafta, GNC y Diesel
       // ----------------------------------------
       if peVhca = 4 and peVhv1 = 6;
       endif;

       // ----------------------------------------
       // Autos Nacionales
       // ----------------------------------------
       if (peVhca = 1 and peVhv2 = 1)   // Nafta
           or
          (peVhca = 1 and peVhv2 = 7);  // Diesel
          if peMgnc = 'S';
             p@Vhv2 = 5;
          endif;
       endif;

       // ----------------------------------------
       // Autos Importados
       // ----------------------------------------
       if (peVhca = 1 and peVhv2 = 9)   // Nafta
           or
          (peVhca = 1 and peVhv2 = 8);  // Diesel
          if peMgnc = 'S';
             p@Vhv2 = 6;
          endif;
       endif;

       p@ctre = peCtre;
       p@scta = peScta;
       p@mone = peMone;
       p@vhca = peVhca;
       p@vhv1 = peVhv1;
       p@femi = peFemi;
       p@mtdf = peMtdf;
       p@Tarc = 0;
       p@Tair = 0;

       sptrcair ( p@ctre :
                  p@scta :
                  p@mone :
                  p@vhca :
                  p@vhv1 :
                  p@vhv2 :
                  p@Tarc :
                  p@Tair :
                  p@femi :
                  p@mtdf );

       peTarc = p@Tarc;
       peTair = p@Tair;
       pevhv2 = p@vhv2;

       return *on;

      /end-free

     P COWVEH_getTablaRC...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getLimitesRC(): obtener limites de cobertura RC           *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peTarc  -  Tabla de RC                            *
      *                peMone  -  Moneda                                 *
      *                peRcle  -  Rc Lesiones                            *
      *                peRcco  -  RC Cosas                               *
      *                peRcac  -  RC Acontecimiento                      *
      *                peLrce  -  RC Exterior                            *
      *                peCtre  -  Codigo de tarifa                       *
      *                peVhca  -  Capitulo                               *
      *                peVhv1  -  Variante RC                            *
      *                peMtdf  -  Marca de Tarifa Diferencial            *
      *                peScta  -  Zona                                   *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_getLimitesRC...
     P                 B
     D COWVEH_getLimitesRC...
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

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D k1t227          ds                  likerec(s1t227:*key)
     D k1t2272         ds                  likerec(s1t2272:*key)

     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D peFemi          s              8  0

      /free

       COWVEH_inz();

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

     P COWVEH_getLimitesRC...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_porcAjuste()  : obtener porcentaje de ajuste automatico   *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peArcd  -  Artículo                               *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_porcAjuste...
     P                 B
     D COWVEH_porcAjuste...
     D                 pi             3  0
     D   peArcd                       6  0  const
     D   peRama                       2  0  const
     D   peArse                       2  0  const

     D k1y625          ds                  likerec(s1t625:*key)

      /free

       COWVEH_inz();

       k1y625.t@Arcd = peArcd;
       k1y625.t@Rama = peRama;
       k1y625.t@Arse = peArse;

       chain %kds ( k1y625 : 3 ) set625;
       if %found;

         return t@claa;

       endif;

       return *zeros;

      /end-free

     P COWVEH_porcAjuste...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getCoberturaPorDefault(): obtener cobertura default       *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peArcd  -  Artículo                               *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getCoberturaPorDefault...
     P                 B
     D COWVEH_getCoberturaPorDefault...
     D                 pi             2
     D   peArcd                       6  0  const
     D   peRama                       2  0  const
     D   peArse                       2  0  const

     D k1y625          ds                  likerec(s1t625:*key)

      /free

       COWVEH_inz();

       k1y625.t@Arcd = peArcd;
       k1y625.t@Rama = peRama;
       k1y625.t@Arse = peArse;

       chain %kds ( k1y625 : 3 ) set625;
       if %found;

         return t@cobl;

       endif;

       return 'XX';

      /end-free

     P COWVEH_getCoberturaPorDefault...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_chkCoberturaPorDefault(): obtener cobertura default       *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peArcd  -  Artículo                               *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_chkCoberturaPorDefault...
     P                 B
     D COWVEH_chkCoberturaPorDefault...
     D                 pi              n
     D   pePaxc                            likeds(cobVeh) dim(20)

     D x               s             10i 0

      /free

       COWVEH_inz();

       for x = 1 to 20;

         if pePaxc(x).cdft = 'S';
           return *on;
         endif;

       endfor;

       //si sale por acá es que no encontró ninguna con 'S' así que marco la
       //primera que tenga.

       pePaxc(1).cdft = 'S';
       return *off;

      /end-free

     P COWVEH_chkCoberturaPorDefault...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_saveCabecera   (): Graba cabecera de la cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peCfpg  -  Código Forma de Pago                   *
      *                peTipe  -  Tipo de Persona                        *
      *                peCtre  -  Código de Tarifa                       *
      *                peDesE  -  Descuento Especial                     *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_saveCabecera...
     P                 B
     D COWVEH_saveCabecera...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0 const
     D   pePoco                       4  0   const
     D   peVhan                       4      const
     D   peVhmc                       3      const
     D   peVhmo                       3      const
     D   peVhcs                       3      const
     D   peVhvu                      15  2   const
     D   peMgnc                       1      const
     D   peRgnc                       7  2   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peClin                       1      const
     D   peBure                       1  0   const
     D   peCfpg                       1  0   const
     D   peTipe                       1      const
     D   peCtre                       5  0   const
     D   peDesE                       5  2   const

     D k1yet0          ds                  likerec(c1wet0:*key)
     D p@fec           s              8  0 inz(0)
     D p@Arcd          s              6  0
     D p@Tarc          s              2  0
     D p@Tair          s              2  0
     D p@Get0Km2a      s               n
     D p@Del0Km2a      s               n

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D hoy             s              8  0

      /free

       COWVEH_inz();

       PAR310X3( peBase.peEmpr : peFema : peFemm : peFemd );
       hoy = (peFema * 10000)
           + (peFemm *   100)
           +  peFemd;

       clear c1wet0;

       t0empr = PeBase.peEmpr;
       t0sucu = PeBase.peSucu;
       t0nivt = PeBase.peNivt;
       t0nivc = PeBase.peNivc;
       t0nctw = peNctw;
       t0rama = peRama;
       t0arse = peArse;
       t0poco = pePoco;
       t0vhmc = peVhmc;
       t0vhmo = peVhmo;
       t0vhcs = peVhcs;
       t0vhde = SPVVEH_GetDescripcion ( peVhmc : peVhmo : peVhcs );
       t0vhcr = SPVVEH_getCarroceria ( peVhmc : peVhmo : peVhcs );
       SPVVEH_getClasificacion( peVhmc :
                                peVhmo :
                                peVhcs :
                                t0vhca :
                                t0vhv1 :
                                t0vhv2 :
                                t0mtdf );

       t0vhct = SPVVEH_getTipoVehiculo ( peVhmc : peVhmo : peVhcs );
       t0vhvu = peVhvu;
       t0m0km = COWVEH_vehiculo0km( peVhan );
       if t0m0km = 'S';
         t0vhan = *year;
       else;
         t0vhan = %int(peVhan);
       endif;

       COWVEH_getTablaRC ( peCtre :
                           peScta :
                           COWGRAI_monedaCotizacion ( peBase : peNctw):
                           peMgnc :
                           COWVEH_origenVehiculo( peVhmc : peVhmo : peVhcs):
                           t0vhca :
                           t0vhv1 :
                           t0vhv2 :
                           hoy    :
                           t0mtdf :
                           p@Tarc :
                           p@Tair );

       COWVEH_getLimitesRC ( p@Tarc
                           : COWGRAI_monedaCotizacion ( peBase : peNctw)
                           : t0rcle
                           : t0rcco
                           : t0rcac
                           : t0lrce
                           : peCtre
                           : t0vhca
                           : t0vhv1
                           : t0mtdf
                           : peScta );

       t0copo = peCopo;
       t0cops = peCops;
       t0scta = peScta;
       t0mgnc = peMgnc;
       t0rgnc = peRgnc;
       t0ctre = peCtre;
       t0rebr = peBure;
       t0mar4 = '0';
       t0clin = peClin;
       t0sast = COWVEH_getSumaSiniestrablePoco ( peBase :
                                                 peNctw :
                                                 peRama :
                                                 peArse :
                                                 pePoco );

       t0vhni = COWVEH_origenVehiculo ( peVhmc :
                                        peVhmo :
                                        peVhcs );

       // Promocion Especial 0KM Segundo Año...
       p@Del0Km2a = *off;
       p@Get0Km2a = getCeroKmsSegundoAÑo( peBase
                                        : peNctw
                                        : peRama
                                        : peArse
                                        : pePoco
                                        : p@Del0Km2a );
       clear t0ma05;
       select;
       when p@Get0Km2a = *on and p@Del0Km2a = *off;
         t0ma05 = '1';
       when p@Get0Km2a = *on and p@Del0Km2a = *on;
         t0ma05 = '2';
       when p@Get0Km2a = *off and p@Del0Km2a = *on;
         t0ma05 = '3';
       endsl;

       t0dWeb = '0';
       t0pWeb = *Zeros;
       if ( peDesE <> *Zeros );
         t0dWeb = '1';
         t0pWeb = peDese;
       endif;

       write c1wet0;

       return *on;

      /end-free

     P COWVEH_saveCabecera...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_saveCoberturas   ():Graba coberturas de cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peCfpg  -  Código Forma de Pago                   *
      *                peTipe  -  Tipo de Persona                        *
      *                peCtre  -  Código de Tarifa                       *
      *                                                                  *
      *        Output:                                                   *
      *                                                                  *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  bonificacion por cobertura             *
      *                peImpo  -  Impuestos                              *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_saveCoberturas...
     P                 B
     D COWVEH_saveCoberturas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0 const
     D   pePoco                       4  0   const
     D   peVhan                       4      const
     D   peVhmc                       3      const
     D   peVhmo                       3      const
     D   peVhcs                       3      const
     D   peVhvu                      15  2   const
     D   peMgnc                       1      const
     D   peRgnc                       7  2   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peClin                       1      const
     D   peBure                       1  0   const
     D   peCfpg                       1  0   const
     D   peTipe                       1      const
     D   peCtre                       5  0   const
     D   pePaxc                            likeds(cobVeh)  dim(20)
     D   peBoni                            likeds(bonVeh)  dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D k1y227          ds                  likerec(s1t227:*key)
     D k1y220          ds                  likerec(s1t220:*key)
     D k1t2272         ds                  likerec(s1t2272:*key)
     D p@Cveh          ds                  likeds(cob225) dim(99)
     D p@ccob          s              2  0
     D x               s             10i 0
     D i               s             10i 0
     D c               s             10i 0
     D p@Tiou          s              1  0
     D p@Stou          s              2  0
     D p@Stos          s              2  0
     D p@Txtd          ds                  likeds(textdeta) dim(999)
     D p@TxtdC         s             10  0
     D p@Erro          s             10i 0
     D p@Msgs          ds                  likeds(paramMsgs)
     D p@Boni          ds                  likeds(bonVeh)
     D p@Impu          ds                  likeds(Impuesto)
     D p@Prim          s             15  2
     D p@Tiso          s              2  0
     D p@Mone          s              2
     D p@Prit          s             15  2
     D cero96          s              9  6 inz (0)
     D cero            s             15  2 inz (0)
     D cobdfl          s              2
     D p@Arcd          s              6  0
     D suminfo         s             15  2
     D p@vhcr          s              3
     D p@VaÑo          s              4  0
     D @@prim          s             15  2
     D @@xrea          s              5  2
     D @@xopr          s              5  2
     D @@vhct          s              2  0
     D @@vhca          s              2  0
     D @@vhv1          s              1  0
     D @@vhv2          s              1  0
     D @@mtdf          s              1
     D @@tarc          s              2  0
     D @@tair          s              2  0
     D @@ctre          s              5  0
     D @@scta          s              1  0
     D @@mone          s              2
     D @@fech          s              8  0
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0
     D p@spo1          s              9  0
     D @@form          s              1    inz('A')
     D Flota           s               n
     D @@DsT3          ds                  likeds( dsctwet3_t ) dim( 999 )
     D @@DsT3C         s             10i 0
     D p@Scor          ds                  likeds( preguntas_t ) dim( 200 )
     D peForm          s              1    inz('S')
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D hoy             s              8  0

      /free

       COWVEH_inz();

       PAR310X3( peBase.peEmpr : peFema : peFemm : peFemd );
       hoy = (peFema * 10000)
           + (peFemm *   100)
           +  peFemd;

       @@xrea = 0;
       for x = 1 to 99;

         monitor;
           if peImpu(x).xrea <> 0;

             @@xrea = peImpu(x).xrea;
             leave;

           endif;

         on-error;

           @@xrea = 0;
           leave;

         endmon;

       endfor;

       clear c1wetc;

       COWRTV_getOperacion ( peBase :
                             peNctw :
                             p@Tiou :
                             p@Stou :
                             p@Stos );

       if COWGRAI_isFlota( peBase
                         : peNctw );
         Flota = *on;

         COWVEH_getCoberturasGaus ( peBase :
                                    peNctw :
                                    peVhan :
                                    peVhmc :
                                    peVhmo :
                                    peVhcs :
                                    peScta :
                                    p@Tiou :
                                    p@Stou :
                                    p@Stos :
                                    p@Cveh :
                                    p@ccob );
       else;
         Flota = *off;

         COWVEH_getCoberturas ( peVhan :
                                peVhmc :
                                peVhmo :
                                peVhcs :
                                peScta :
                                p@Tiou :
                                p@Stou :
                                p@Stos :
                                p@Cveh :
                                p@ccob );
       endif;

       p@mone = COWGRAI_monedaCotizacion(peBase :
                                        peNctw) ;


       p@Arcd = COWGRAI_getArticulo ( peBase :
                                     peNctw );
       clear p@spo1;
       p@spo1 = COWGRAI_getSuperPolizaReno( peBase
                                          : peNctw );

       //Busco la carroceria
       p@vhcr = SPVVEH_getCarroceria ( peVhmc : peVhmo : peVhcs );

       //si es 0km le coloco el año actual, sino el que viene por dflt
       if COWVEH_vehiculo0km ( peVhan ) = 'S';
           p@VaÑo = %dec(*year);
       else;
           p@VaÑo = %int(peVhan);
       endif;

       //Busco la suma que le toca por infoauto
       suminfo = COWGRAI_SumaInfoPro ( p@arcd :
                                       peVhmc :
                                       pevhmo :
                                       pevhcs :
                                       p@vhcr :
                                       p@VaÑo :
                                       pevhvu );

       if COWVEH_getCtwet3 ( peBase.peEmpr
                           : peBase.peSucu
                           : peBase.peNivt
                           : peBase.peNivc
                           : peNctw
                           : peRama
                           : peArse
                           : pePoco
                           : *omit
                           : *omit
                           : @@Dst3
                           : @@Dst3C
                           : peForm        );

         clear p@Scor;

         c = 0;
         for i = 1 to @@Dst3C;
           if @@Dst3(i).t3Cosg <> *blanks;
             c += 1;
             p@Scor(c).Cosg = @@Dst3(i).t3Cosg;
             p@Scor(c).Vefa = @@Dst3(i).t3Vefa;
             p@Scor(c).Cant = @@Dst3(i).t3Cant;
           endif;
         endfor;

       endif;

       for x = 1 to p@ccob;

         if not SPVVEH_chkRamaCobertura ( p@arcd : peRama : p@Cveh(x).cobc );
           iter;
         endif;

         //Valido que la suma de accesorios para la cobertura no supere
         //el porcentaje maximo tabulado.

         if COWVEH_chkAccesorios (  peBase :
                                    peNctw :
                                    peRama :
                                    peArse :
                                    pePoco :
                                    p@Cveh(x).cobc :
                                    suminfo );

           t0empr = PeBase.peEmpr;
           t0sucu = PeBase.peSucu;
           t0nivt = PeBase.peNivt;
           t0nivc = PeBase.peNivc;
           t0nctw = peNctw;
           t0rama = peRama;
           t0arse = peArse;
           t0poco = pePoco;
           t0cobl = p@Cveh(x).cobc;
           COWVEH_getPrimas ( peVhmc
                            : peVhmo
                            : peVhcs
                            : peVhan
                            : peMgnc
                            : peVhvu
                            : peScta
                            : peCtre
                            : p@Arcd
                            : p@mone
                            : p@Cveh(x).Cobc
                            : p@Cveh(x).Coss
                            : p@Cveh(x).Ccrc
                            : t0Prac
                            : t0Prin
                            : t0Prro
                            : t0prrc
                            : t0prce
                            : t0prap
                            : t0ifra );

           // Si es flota mover el valor que cargo
           if Flota;
             t0ifra = pePaxc(x).ifra;
           endif;

           t0rras = COWVEH_getRastreador( p@Cveh(x).Cobc :
                                          peVhvu :
                                          p@Tiou :
                                          p@Stou :
                                          p@Stos );
           t0rins = COWVEH_getInspeccion( p@Cveh(x).Cobc :
                                          peVhan :
                                          p@Tiou :
                                          p@Stou :
                                          p@Stos );

           @@vhct = SPVVEH_getTipoVehiculo ( peVhmc : peVhmo : peVhcs );

           chain @@vhct set210;

           if %found ( set210 );

               SPVVEH_getClasificacion( peVhmc :
                                        peVhmo :
                                        peVhcs :
                                        @@vhca :
                                        @@vhv1 :
                                        @@vhv2 :
                                        @@mtdf );

               @@ctre = peCtre;
               @@scta = peScta;
               @@mone = COWGRAI_monedaCotizacion ( peBase : peNctw);
               @@fech = %dec(%date:*iso);

               sptrcair ( @@ctre :
                          @@scta :
                          @@mone :
                          @@vhca :
                          @@vhv1 :
                          @@vhv2 :
                          @@Tarc :
                          @@Tair :
                          hoy    :
                          @@mtdf );

               k1y227.t@tarc = @@tarc;
               k1y227.t@como = COWGRAI_monedaCotizacion ( peBase : peNctw);
               chain %kds ( k1y227 : 2 ) set227;

               if (@@ctre >= 123);
                  k1t2272.t@tarc = @@tarc;
                  k1t2272.t@como = COWGRAI_monedaCotizacion(peBase:peNctw);
                  k1t2272.t@vhca = @@vhca;
                  k1t2272.t@vhv1 = @@vhv1;
                  chain %kds(k1t2272) set2272;
               endif;

               if %found;

                 t0lrce = t@lrce;

                 chain p@Cveh(x).cobc set225;

                 select;

                   when ( s225_t@ccrc = 'O' );

                     t0rcle = t@rcle;
                     t0rcco = t@rcco;
                     t0rcac = t@rcac;

                   when ( s225_t@ccrc = 'L' );

                     t0rcle = *Zeros;
                     t0rcco = *Zeros;

                     if ( t@tlim = '2' );

                       t0rcac = t@rca2;

                     else;

                       t0rcac = SVPLRC_getLimiteRC( peBase.peEmpr
                                                  : peBase.peSucu
                                                  : %dec( %date : *iso ) )  ;

                     endif;

                   when ( s225_t@ccrc = 'S' or s225_t@ccrc = 'N' );

                     t0rcle = *Zeros;
                     t0rcco = *Zeros;
                     t0rcac = *Zeros;

                 endsl;

             endif;

           endif;

           //Clausula de Ajuste
           if p@Cveh(x).cobc = 'A ';
             t0claj = 0;
           else;
             t0claj =
                COWVEH_porcAjuste ( COWGRAI_getArticulo ( peBase : peNctw ):
                                    peRama :
                                    peArse );
           endif;

           write c1wetc;

           clear p@Boni;

           if SVPART_chkScoring( p@Arcd
                               : peRama
                               : peArse );

             COWVEH_aplicaScoring ( peBase
                                  : peNctw
                                  : peRama
                                  : peArse
                                  : pePoco
                                  : @@Dst3(1).t3Taaj
                                  : p@Scor
                                  : p@Erro
                                  : p@Msgs
                                  : p@Cveh(x).Cobc   );
           endif;

           COWVEH_saveDescuentos ( peBase :
                                   peNctw :
                                   peRama :
                                   peArse :
                                   pePoco :
                                   p@Cveh(x).Cobc );

           COWVEH_aplicaDescuentos ( peBase :
                                     peNctw :
                                     peRama :
                                     peArse :
                                     pePoco :
                                     p@Cveh(x).Cobc :
                                     COWVEH_getDescuentos( peBase :
                                                           peNctw :
                                                           peRama :
                                                           peArse :
                                                           pePoco :
                                                           p@Cveh(x).Cobc ));

           //Estructura a devolver de coberturas

           pePaxc(x).cobl = p@Cveh(x).Cobc;
           SPVVEH_CheckCobertura ( p@Cveh(x).cobc :
                                   pePaxc(x).cobd );
           pePaxc(x).rast = t0rras;

           // Si es Renovación obtengo código de rastreador anterior;
           if p@Tiou = 2 and p@Cveh(x).Coss <> 'A';

             pePaxc(x).cras = SPVVEH_getCodDeRastreador( peBase.peEmpr
                                                       : peBase.peSucu
                                                       : peRama
                                                       : peArse
                                                       : pePoco
                                                       : p@Arcd
                                                       : p@Spo1        );

           endif;
           pePaxc(x).insp = t0rins;
           COWRTV_getPrimaTot( peBase :
                               peNctw :
                               peRama :
                               peArse :
                               pePoco :
                               p@Cveh(x).Cobc :
                               pePaxc(x).prim );

           //Derecho de Emisión
           COWGRAI_setDerechoEmi ( peBase :
                                   peNctw :
                                   peRama :
                                   pePaxc(x).prim);

           @@Prim = COWGRAI_GetPrimaSubtot ( peBase :
                                             peNctw :
                                             peRama :
                                             pePaxc(x).prim );


           //Actualizo los porcentajes
           //if @@xrea <> 0;
             if peImpu(1).cobl = ' ';
               COWGRAI_GetCondComerciales (peBase:peNctw:peRama:@@xrea:@@xopr);
             endif;

             COWGRAI_updImpConcComer( peBase :
                                      peNctw :
                                      peRama :
                                      @@xrea );
           //endif;

           //Actualizo la comisión
           COWGRAI_setImpConcComer( peBase :
                                    peNctw :
                                    peRama :
                                    pePaxc(x).prim );

           //Retorno Limites
           pePaxc(x).rcle = t0rcle;
           pePaxc(x).rcco = t0rcco;
           pePaxc(x).rcac = t0rcac;
           pePaxc(x).lrce = t0lrce;

           pePaxc(x).claj = t0claj;

           //Franquicia - Siempre la misma franquicia
           //siempre y cuando no sea Flota de Vehículo
           if not COWGRAI_isFlota( peBase
                                 : peNctw );
             pePaxc(x).ifra = t0ifra;
           endif;

           //Estructura a devolver de impuestos
           Clear p@Impu;
           COWGRAI_getImpuestos( peBase :
                                 peNctw :
                                 peRama :
                                 pePaxc(x).prim :
                                 peVhvu :
                                 peCopo :
                                 peCops :
                                 p@Impu );
           clear @@prim;
           @@Prim = COWGRAI_GetPrimaSubtot ( peBase :
                                             peNctw :
                                             peRama :
                                             pePaxc(x).prim:
                                             @@form );
           eval(h) pePaxc(x).prem = @@prim +
                                  + p@Impu.seri
                                  + p@Impu.seem
                                  + p@Impu.impi
                                  + p@Impu.sers
                                  + p@Impu.tssn
                                  + p@Impu.ipr1
                                  + p@Impu.ipr4
                                  + p@Impu.ipr3
                                  + p@Impu.ipr6;

           peImpu(x).cobl = p@Cveh(x).Cobc;
           peImpu(x).xrea = p@Impu.xrea;
           peImpu(x).read = p@Impu.read;
           peImpu(x).xopr = p@Impu.xopr;
           peImpu(x).copr = p@Impu.copr;
           peImpu(x).xref = p@Impu.xref;
           peImpu(x).refi = p@Impu.refi;
           peImpu(x).dere = p@Impu.dere;
           peImpu(x).seri = p@Impu.seri;
           peImpu(x).seem = p@Impu.seem;
           peImpu(x).pimi = p@Impu.pimi;
           peImpu(x).impi = p@Impu.impi;
           peImpu(x).psso = p@Impu.psso;
           peImpu(x).sers = p@Impu.sers;
           peImpu(x).pssn = p@Impu.pssn;
           peImpu(x).tssn = p@Impu.tssn;
           peImpu(x).pivi = p@Impu.pivi;
           peImpu(x).ipr1 = p@Impu.ipr1;
           peImpu(x).pivn = p@Impu.pivn;
           peImpu(x).ipr4 = p@Impu.ipr4;
           peImpu(x).pivr = p@Impu.pivr;
           peImpu(x).ipr3 = p@Impu.ipr3;
           peImpu(x).ipr6 = p@Impu.ipr6;
           peImpu(x).ipr7 = 0;
           peImpu(x).ipr8 = 0;

           COWVEH_updprimasCob (peBase :
                                peNctw :
                                peRama :
                                peArse :
                                pePoco :
                                p@Cveh(x).Cobc :
                                pePaxc(x).prim :
                                pePaxc(x).prem :
                                peImpu(x).seri:
                                peImpu(x).seem:
                                peImpu(x).impi:
                                peImpu(x).sers:
                                peImpu(x).tssn:
                                peImpu(x).ipr1:
                                peImpu(x).ipr4:
                                peImpu(x).ipr3:
                                peImpu(x).ipr6:
                                cero:
                                cero:
                                cero );

         endif;

       endfor;

       COWVEH_setCoberturaPorDefecto( peBase
                                    : peNctw
                                    : p@Arcd
                                    : peRama
                                    : peArse
                                    : pePoco
                                    : p@ccob
                                    : pePaxc );

       return *on;

      /end-free

     P COWVEH_saveCoberturas...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_saveCoberturasRec():Graba coberturas de cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peCfpg  -  Código Forma de Pago                   *
      *                peTipe  -  Tipo de Persona                        *
      *                peCtre  -  Código de Tarifa                       *
      *                                                                  *
      *        Output:                                                   *
      *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  bonificacion por cobertura             *
      *
      * ---------------------------------------------------------------- *

     P COWVEH_saveCoberturasRec...
     P                 B
     D COWVEH_saveCoberturasRec...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0 const
     D   pePoco                       4  0   const
     D   peVhan                       4      const
     D   peVhmc                       3      const
     D   peVhmo                       3      const
     D   peVhcs                       3      const
     D   peVhvu                      15  2   const
     D   peMgnc                       1      const
     D   peRgnc                       7  2   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peClin                       1      const
     D   peBure                       1  0   const
     D   peCfpg                       1  0   const
     D   peTipe                       1      const
     D   peCtre                       5  0   const
     D   pePaxc                            likeds(cobVeh)  dim(20)
     D   peBoni                            likeds(bonVeh)  dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)

     D k1y220          ds                  likerec(s1t220:*key)
     D p@Cveh          ds                  likeds(cob225) dim(99)
     D p@ccob          s              2  0
     D x               s             10i 0
     D p@Tiou          s              1  0
     D p@Stou          s              2  0
     D p@Stos          s              2  0
     D p@Txtd          ds                  likeds(textdeta) dim(999)
     D p@TxtdC         s             10  0
     D p@Erro          s             10i 0
     D p@Msgs          ds                  likeds(paramMsgs)
     D p@Boni          ds                  likeds(bonVeh)
     D p@Impu          ds                  likeds(Impuesto)
     D p@Prim          s             15  2
     D p@Tiso          s              2  0
     D p@Mone          s              2
     D p@Prit          s             15  2
     D cero96          s              9  6 inz (0)
     D cero            s             15  2 inz (0)
     D Flota           s               n

      /free

       COWVEH_inz();

       clear c1wetc;

       COWRTV_getOperacion ( peBase :
                             peNctw :
                             p@Tiou :
                             p@Stou :
                             p@Stos );

       if COWGRAI_isFlota( peBase
                         : peNctw );
         Flota = *on;

         COWVEH_getCoberturasGaus ( peBase :
                                    peNctw :
                                    peVhan :
                                    peVhmc :
                                    peVhmo :
                                    peVhcs :
                                    peScta :
                                    p@Tiou :
                                    p@Stou :
                                    p@Stos :
                                    p@Cveh :
                                    p@Ccob );
       else;
         Flota = *off;

         COWVEH_getCoberturas ( peVhan :
                                peVhmc :
                                peVhmo :
                                peVhcs :
                                peScta :
                                p@Tiou :
                                p@Stou :
                                p@Stos :
                                p@Cveh :
                                p@Ccob );
       endif;

       if peTipe = 'F';
         p@Tiso = 98;
       else;
         p@Tiso = 0;
       endif;

       p@mone = COWGRAI_monedaCotizacion(peBase :
                                        peNctw) ;

       for x = 1 to p@ccob;


         t0empr = PeBase.peEmpr;
         t0sucu = PeBase.peSucu;
         t0nivt = PeBase.peNivt;
         t0nivc = PeBase.peNivc;
         t0nctw = peNctw;
         t0rama = peRama;
         t0arse = peArse;
         t0poco = pePoco;
         t0cobl = p@Cveh(x).cobc;
         COWVEH_getPrimas ( peVhmc :
                            peVhmo :
                            peVhcs :
                            peVhan :
                            peMgnc :
                            peVhvu :
                            peScta :
                            peCtre :
                            COWGRAI_getArticulo ( peBase : peNctw ) :
                            COWGRAI_monedaCotizacion(peBase:peNctw):
                            p@Cveh(x).Cobc :
                            p@Cveh(x).Coss :
                            p@Cveh(x).Ccrc :
                            t0Prac :
                            t0Prin :
                            t0Prro :
                            t0prrc :
                            t0prce :
                            t0prap :
                            t0ifra );

         // Si es flota mover el valor que cargo
         if Flota;
           t0ifra = pePaxc(x).ifra;
         endif;

         t0rras = COWVEH_getRastreador( p@Cveh(x).Cobc :
                                        peVhvu :
                                        p@Tiou :
                                        p@Stou :
                                        p@Stos );


         t0rins = COWVEH_getInspeccion( p@Cveh(x).Cobc :
                                        peVhan :
                                        p@Tiou :
                                        p@Stou :
                                        p@Stos );


         write c1wetc;

         COWVEH_saveDescuentosRec ( peBase :
                                    peNctw :
                                    peRama :
                                    peArse :
                                    pePoco :
                                    p@Boni);


         COWVEH_aplicaDescuentos ( peBase :
                                   peNctw :
                                   peRama :
                                   peArse :
                                   pePoco :
                                   p@Cveh(x).Cobc :
                                   COWVEH_getDescuentos( peBase :
                                                         peNctw :
                                                         peRama :
                                                         peArse :
                                                         pePoco :
                                                         p@Cveh(x).Cobc ));


         //Estructura a devolver de coberturas

         pePaxc(x).cobl = p@Cveh(x).Cobc;
         SPVVEH_CheckCobertura ( p@Cveh(x).cobc :
                                 pePaxc(x).cobd );
         pePaxc(x).rast = t0rras;
         pePaxc(x).cras = t0cras;
         pePaxc(x).insp = t0rins;
         pePaxc(x).insp = t0rins;
         COWRTV_getPrimaTot( peBase :
                             peNctw :
                             peRama :
                             peArse :
                             pePoco :
                             p@Cveh(x).Cobc :
                             pePaxc(x).prim );

         pePaxc(x).prem = pePaxc(x).prim +
                          COWGRAI_getCalculosImpuestos ( peBase :
                                                         peNctw :
                                                         peRama :
                                                         peCopo :
                                                         peCops :
                                                         peVhvu :
                                                         pePaxc(x).prim :
                                                         peTipe :
                                                         p@mone );



         //Estructura a devolver de Bonificaciones

         peBoni(x).cobl = p@Boni.cobl;
         peBoni(x).ccbp = p@Boni.ccbp;
         peBoni(x).dcbp = p@Boni.dcbp;
         peBoni(x).pcbp = p@Boni.pcbp;
         peBoni(x).pcbm = p@Boni.pcbm;
         peBoni(x).pcbx = p@Boni.pcbx;
         peBoni(x).modi = p@Boni.modi;

         //Estructura a devolver de impuestos
         p@Prim = COWGRAI_GetPrimaSubtot ( peBase :
                                           peNctw :
                                           peRama :
                                           pePaxc(x).prim );


         p@Prit = pePaxc(x).prim;

         peImpu(x).cobl = p@Cveh(x).Cobc;
         peImpu(x).xrea = 0;
         peImpu(x).read = 0;
         peImpu(x).xopr = 0;
         peImpu(x).copr = 0;
         peImpu(x).xref = COWGRAI_GetRecargoFinanc (peBase:peNctw:peRama);
         peImpu(x).refi = COWGRAI_GetImporteRefi ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   pePaxc(x).prim );
         peImpu(x).dere = COWGRAI_GetDerechoEmision ( peBase :
                                                      peNctw :
                                                      peRama );
         peImpu(x).seri =
         COWGRAI_GetSelladosprovinciales ( COWGRAI_GetCodProInd ( peCopo :
                                                                  peCops ):
                                           %int(peRama) :
                                           p@mone :
                                           COWGRAI_cotizaMoneda ( p@Mone :
                                                              %dec(%date:*iso)):
                                           p@prit :
                                           0      :
                                           0      :
                                           COWGRAI_GetImporteRefi ( peBase :
                                                                    peNctw :
                                                                    peRama :
                                                                    p@prit):
                                           COWGRAI_GetDerechoEmision ( peBase :
                                                                       peNctw :
                                                                       peRama ):
                                           p@Prim :
                                           peVhvu :
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
                                           0      :
                                           COWGRAI_GetImporteIres ( peBase :
                                                                    peNctw :
                                                                    peRama :
                                                                    p@Prim ):
                                           COWGRAI_GetImporteInoi ( peBase :
                                                                    peNctw :
                                                                    peRama :
                                                                    p@Prim ):
                                           0      :   //peIpr5 :
                                           0      :   //peIpr6 :
                                           0      :   //peIpr7 :
                                           0      :   //peIpr8 :
                                           cero96 :   //pePorc :
                                           cero96 :   //pepor1 :
                                           p@Tiso :
                                           cero    );
         peImpu(x).seem =
         COWGRAI_GetSelladodelaEmpresa   ( COWGRAI_GetCodProInd ( peCopo :
                                                                  peCops ):
                                         %int(peRama) :
                                         p@mone :
                                         COWGRAI_cotizaMoneda ( p@Mone :
                                                              %dec(%date:*iso)):
                                         p@prit :
                                         cero   :
                                         cero   :
                                         COWGRAI_GetImporteRefi ( peBase :
                                                                  peNctw :
                                                                  peRama :
                                                                  p@prit ):
                                         COWGRAI_GetDerechoEmision ( peBase :
                                                                     peNctw :
                                                                     peRama ):
                                         p@Prim :
                                         peVhvu :
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
                                         cero    );
         peImpu(x).pimi = COWGRAI_GetImpuestosInte (peBase:peNctw:peRama );
         peImpu(x).impi = COWGRAI_GetImporteImpi ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   p@Prim );
         peImpu(x).psso = COWGRAI_GetServiciosSoci (peBase:peNctw:peRama);
         peImpu(x).sers = COWGRAI_GetImporteSers ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   p@Prim );
         peImpu(x).pssn = COWGRAI_GetTasaSsn (peBase:peNctw:peRama );
         peImpu(x).tssn = COWGRAI_GetImporteTssn ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   p@Prim );
         peImpu(x).pivi = COWGRAI_GetIvaInscripto (peBase:peNctw:peRama );
         peImpu(x).ipr1 = COWGRAI_GetImporteIins ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   p@Prim );
         peImpu(x).pivn = COWGRAI_GetIvaRes (peBase:peNctw:peRama );
         peImpu(x).ipr4 = COWGRAI_GetImporteIres ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   p@Prim );
         peImpu(x).pivr =COWGRAI_GetIvaNoInscripto (peBase:peNctw:peRama);
         peImpu(x).ipr3 = COWGRAI_GetImporteIins ( peBase :
                                                   peNctw :
                                                   peRama :
                                                   p@Prim );
         peImpu(x).ipr6 = 0;
         peImpu(x).ipr7 = 0;
         peImpu(x).ipr8 = 0;

       endfor;


       return *on;

      /end-free

     P COWVEH_saveCoberturasRec...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getCoberturas():Busca posibles coberturas para el auto    *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peVhan  -  Año del Vehículo                       *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *        Output:                                                   *
      *                peCveh  -  Coberturas                             *
      *                peccob  -  Cant de coberturas                     *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getCoberturas...
     P                 B
     D COWVEH_getCoberturas...
     D                 pi              n
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peScta                       1  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D   peCveh                            likeds(cob225) dim(99)
     D   peCcob                       2  0

     D x               s              2  0
     D p@Vhca          s              2  0
     D p@Vhv1          s              1  0
     D p@Vhv2          s              1  0
     D p@Mtdf          s              1
     D p@Cobd          s              2

     D @cveh           ds                  likeds(cob225) dim(99)
     D @ccob           s              2  0
     D @@ccob          s              2  0

      /free

       COWVEH_inz();

       clear pecveh;
       clear peccob;

       SPVVEH_getClasificacion( peVhmc :
                                peVhmo :
                                peVhcs :
                                p@Vhca :
                                p@Vhv1 :
                                p@Vhv2 :
                                p@Mtdf );

       CZWUTL_getCobertD ( p@Vhca :
                           p@Vhv1 :
                           p@Vhv2 :
                           p@Mtdf :
                           peScta :
                           p@Cobd );

       setll *start set225;
       read set225;
       dow not %eof(set225);

         if s225_t@mar1 = 'I';

           If COWVEH_chkCobertura ( s225_t@cobl :
                                    peVhan :
                                    peTiou :
                                    peStou :
                                    peStos );


             if s225_t@cobl = 'D2' or s225_t@cobl = 'D3';//saber cual D usar

               if s225_t@cobl = p@Cobd;

                 peccob += 1;
                 peCveh(peccob).cobc = s225_t@cobl;
                 peCveh(peccob).coss = s225_t@coss;
                 peCveh(peccob).ccrc = s225_t@ccrc;

               endif;

             else;

               peccob += 1;
               peCveh(peccob).cobc = s225_t@cobl;
               peCveh(peccob).coss = s225_t@coss;
               peCveh(peccob).ccrc = s225_t@ccrc;

             endif;

           endif;

         endif;

         read set225;
       enddo;

       if p@vhca = 4 and p@mtdf = ' ';
          clear @cveh;
          @ccob = 0;
          for x = 1 to peCcob;
              if %subst(peCveh(x).cobc:1:1) <> 'D';
                 @ccob += 1;
                 @cveh(@ccob).cobc = peCveh(x).cobc;
                 @cveh(@ccob).coss = peCveh(x).coss;
                 @cveh(@ccob).ccrc = peCveh(x).ccrc;
              endif;
          endfor;

       // Pedido especial...Si Pickup "A" se ofrecen todas las coberturas...
         if p@vhca = 4 and p@Vhv1 = 6 and p@Vhv2 = 3 or
            p@vhca = 4 and p@Vhv1 = 6 and p@Vhv2 = 4;
           clear @cveh;
           @ccob = 0;
           for x = 1 to peCcob;
             @ccob += 1;
             @cveh(@ccob).cobc = peCveh(x).cobc;
             @cveh(@ccob).coss = peCveh(x).coss;
             @cveh(@ccob).ccrc = peCveh(x).ccrc;
           endfor;
         endif;
         clear peCveh;
         peCcob = 0;
         peCveh = @cveh;
         peCcob = @ccob;
       endif;

       if p@vhca = 5;
          clear @cveh;
          @ccob = 0;
          for x = 1 to peCcob;
              if peCveh(x).cobc = 'A' or
                 peCveh(x).cobc = 'B' or
                 peCveh(x).cobc = 'C';
                 @ccob += 1;
                 @cveh(@ccob).cobc = peCveh(x).cobc;
                 @cveh(@ccob).coss = peCveh(x).coss;
                 @cveh(@ccob).ccrc = peCveh(x).ccrc;
              endif;
          endfor;
       clear peCveh;
       peCcob = 0;
       peCveh = @cveh;
       peCcob = @ccob;
       endif;


       return *on;

      /end-free

     P COWVEH_getCoberturas...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getPrimas  ():Selecciona el monto de la cobertura RC      *
      *                     dependiendo de la forma de cobertura RC      *
      *        Input :                                                   *
      *                                                                  *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhan  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peVhvu  -  Suma Asegurada                         *
      *                peScta  -  Zona de Riesgo                         *
      *                peCtre  -  Código de Tarifa                       *
      *                peArcd  -  Número de artículo                     *
      *                peMone  -  Código Moneda                          *
      *                peCobl  -  Letra de Cobertura                     *
      *                peCcrc  -  Forma de Cobertura                     *
      *                pePrac  -  Importe prima de accidente             *
      *                pePrin  -  Importe prima de incendio              *
      *                pePrro  -  Importe prima de robo                  *
      *                pePrrc  -  Importe prima de rc                    *
      *                pePrce  -  Prima RC exterior                      *
      *                pePrap  -  Prima accidentes personales            *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getPrimas...
     P                 B                   export
     D COWVEH_getPrimas...
     D                 pi              n
     D   peVhmc                       3      const
     D   peVhmo                       3      const
     D   peVhcs                       3      const
     D   peVhan                       4      const
     D   peMgnc                       1      const
     D   peVhvu                      15  2   const
     D   peScta                       1  0   const
     D   peCtre                       5  0   const
     D   peArcd                       6  0   const
     D   peMone                       2      const
     D   peCobl                       2      const
     D   peCoss                       2      const
     D   peCcrc                       1      const
     D   pePrac                      15  2
     D   pePrin                      15  2
     D   pePrro                      15  2
     D   pePrrc                      15  2
     D   pePrce                      15  2
     D   pePrap                      15  2
     D   peIfra                      15  2

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D k1y220          ds                  likerec(s1t220:*key)
     D k1t2202         ds                  likerec(s1t2202:*key)
     D x               s              2  0
     D p@Tarc          s              2  0
     D p@Tair          s              2  0
     D p@Vhca          s              2  0
     D p@Vhv1          s              1  0
     D p@Vhv2          s              1  0
     D p@Mtdf          s              1
     D p@fec           s              8  0
     D p@pcox          s              7  4
     D p@pacx          s              7  4
     D p@pinx          s              7  4
     D p@prox          s              7  4
     D p@ifrx          s             15  2
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D hoy             s              8  0

      /free

       COWVEH_inz();

       PAR310X3( 'A' : peFema : peFemm : peFemd );
       hoy  = (peFema * 10000)
            + (peFemm *   100)
            +  peFemd;

       SPVVEH_getClasificacion( peVhmc :
                                peVhmo :
                                peVhcs :
                                p@Vhca :
                                p@Vhv1 :
                                p@Vhv2 :
                                p@Mtdf );


       COWVEH_getTablaRC ( peCtre :
                           peScta :
                           peMone :
                           peMgnc :
                           COWVEH_origenVehiculo( peVhmc : peVhmo : peVhcs):
                           p@Vhca :
                           p@Vhv1 :
                           p@Vhv2 :
                           hoy    :
                           p@Mtdf :
                           p@Tarc :
                           p@Tair );

       k1y220.t@tarc = p@Tarc;
       k1y220.t@como = peMone;
       k1y220.t@vhca = p@Vhca;
       k1y220.t@vhv1 = p@Vhv1;

       k1t2202.t@tarc = p@Tarc;
       k1t2202.t@como = peMone;
       k1t2202.t@vhca = p@Vhca;
       k1t2202.t@vhv1 = p@Vhv1;
       k1t2202.t@scta = peScta;

       //  ATENCION
       //  En vias de unificar las tablas de RC y AIR que se usan en cada
       //  tarifa, se cambia la variante RC que se usa para acceder en
       //  ciertos casos.
       //  La idea es usar una tabla de RC y una de AIR por tarifa y no
       //  500 como ahora
       //
       //  Autos Diesel (1/1/7 y 1/1/8) acceden con variante Rc = 2
       //  Autos Gnc    (1/1/5 y 1/1/6) acceden con variante Rc = 3
       //  4x4 Carrozada (4/1/2-1 y 4/1/2-2) acceden con variante Rc = 7

       if peCtre >= 123;
          if p@vhca = 1;
             select;
              when p@vhv2 = 7 or p@vhv2 = 8;
                   k1t2202.t@vhv1 = 2;
              when p@vhv2 = 5 or p@vhv2 = 5;
                   k1t2202.t@vhv1 = 3;
             endsl;
          endif;
          if p@vhca = 4 and
             p@vhv1 = 1 and
             p@vhv2 = 2 and
             p@mtdf <> ' ';
             k1t2202.t@vhv1 = 7;
          endif;
       endif;

       chain %kds ( k1y220 : 4) set220;
       if peCtre >= 123;
          chain %kds ( k1t2202 : 5) set2202;
       endif;

       if %found;

         if peCcrc =  'L';
           eval(h) pePrrc = T@RCCL / COWVEH_getDuracion ( peArcd );
         elseif peCcrc =  'S';
           eval(h) pePrrc = T@RCSL / COWVEH_getDuracion ( peArcd );
         elseif peCcrc =  'O';
           eval(h) pePrrc = T@RCOB / COWVEH_getDuracion ( peArcd );
         elseif peCcrc =  'N';
           pePrrc = 0;
         endif;

         eval(h) pePrrc = pePrrc * T@COVT; //Valor Base
         eval(h) pePrce = t@prce / COWVEH_getDuracion ( peArcd );
         eval(h) pePrap = t@prap / COWVEH_getDuracion ( peArcd );

       endif;

       COWVEH_getPorceCob ( p@Tair
                          : peScta
                          : peMone
                          : peVhan
                          : peVhvu
                          : p@Vhca
                          : p@Vhv1
                          : p@Vhv2
                          : peCobl
                          : peCoss
                          : p@pcox
                          : p@pacx
                          : p@pinx
                          : p@prox
                          : peIfra
                          : peCtre
                          : p@Mtdf );

       eval(h) pePrac = (peVhvu * (p@pcox /1000)) * (p@pacx / 100);
       eval(h) pePrac = pePrac / COWVEH_getDuracion ( peArcd );
       eval(h) pePrin = (peVhvu * (p@pcox /1000)) * (p@pinx / 100);
       eval(h) pePrin = pePrin / COWVEH_getDuracion ( peArcd );
       eval(h) pePrro = (peVhvu * (p@pcox /1000)) * (p@prox / 100);
       eval(h) pePrro = pePrro / COWVEH_getDuracion ( peArcd );

       return *on;

      /end-free

     P COWVEH_getPrimas...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getPorceCob():devuelve dependiendo de la letra el % de    *
      *                     cobertura de accidente, incendio y Robo.     *
      *        Input :                                                   *
      *                                                                  *
      *                peTair  -  número de tabla air                    *
      *                peScta  -  sub-tabla air                          *
      *                peMone  -  codigo de moneda                       *
      *                peVhan  -  año del vehículo                       *
      *                peVhca  -  capitulo del vehículo                  *
      *                peVhv2  -  capitulo variante air                  *
      *                peCobl  -  Cobertura                              *
      *                pePcox  -  0/00 cobertura                         *
      *                pePacx  -  % accidentes                           *
      *                pePinx  -  % incendio                             *
      *                peProx  -  % robo                                 *
      *                peIfrx  -  Franquicia                             *
      *                peCtre  -  Codigo de Tarifa                       *
      *                peMtdf  -  Marca de Tarifa Diferencial            *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_getPorceCob...
     P                 B
     D COWVEH_getPorceCob...
     D                 pi              n
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peMone                       2    const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peCobl                       2    const
     D   peCoss                       2    const
     D   pePcox                       7  4
     D   pePacx                       7  4
     D   pePinx                       7  4
     D   peProx                       7  4
     D   peiFrx                      15  2
     D   peCtre                       5  0 const
     D   peMtdf                       1a   const

     D k1y2221         ds                  likerec(s1t2221:*key)
     D k1y215          ds                  likerec(s1t215:*key)
     D x               s              2  0
     D cobDcam         s              2  0 dim(8)
     D cobDotr         s              2  0 dim(8)
     D difanio         s              4  0


      /free

       COWVEH_inz();

       k1y2221.tnTair = peTair;
       k1y2221.tnScta = peScta;
       k1y2221.tnComo = peMone;
       k1y2221.tnVhca = peVhca;
       k1y2221.tnVhv2 = peVhv2;
       k1y2221.tnsuma = peVhvu;

       if peCtre >= 123;
          if peVhca = 4 and
             peVhv1 = 1 and
             peVhv2 = 2 and
             peMtdf <> ' ';
             k1y2221.tnvhca = 99;
             if peMtdf = '1';
                k1y2221.tnvhv2 = 2;
             endif;
             if peMtdf = '2';
                k1y2221.tnvhv2 = 1;
             endif;
          endif;
       endif;

       setll %kds ( k1y2221 : 6 ) set2221;
       reade %kds ( k1y2221 : 5 ) set2221;
       if %eof();
         k1y2221.tnComo = '**';
         setll %kds ( k1y2221 : 6 ) set2221;
         reade %kds ( k1y2221 : 5 ) set2221;
         if %eof();
           return *off;
         endif;
       endif;

       if peCoss =  'B';

         pePcox = tnpco1;
         pePacx = tnpac1;
         pePinx = tnpin1;
         peProx = tnpro1;

       elseif peCoss = 'B1';

         pePcox = tnpco2;
         pePacx = tnpac2;
         pePinx = tnpin2;
         peProx = tnpro2;

       elseif peCoss = 'C';

         pePcox = tnpco3;
         pePacx = tnpac3;
         pePinx = tnpin3;
         peProx = tnpro3;

       elseif peCoss = 'C1';

         pePcox = tnpco4;
         pePacx = tnpac4;
         pePinx = tnpin4;
         peProx = tnpro4;

       elseif peCoss = 'E';

         pePcox = tnpco3;
         pePacx = tnpac3;
         pePinx = tnpin3;
         peProx = tnpro3;

       elseif peCoss = 'D' and peCobl = 'D2';

         pePcox = tnpco8;
         pePacx = tnpac8;
         pePinx = tnpin8;
         peProx = tnpro8;
         peiFrx = tnifr8;

       elseif peCoss = 'D' and peCobl = 'D3';

         pePcox = tnpco6;
         pePacx = tnpac6;
         pePinx = tnpin6;
         peProx = tnpro6;
         peiFrx = tnifr9;

       elseif peCoss = 'D' and peCobl = 'D4';

         pePcox = tnpcoa;
         pePacx = tnpaca;
         pePinx = tnpina;
         peProx = tnproa;
         peiFrx = tnifra;

       elseif peCoss = 'D' and peCobl = 'D5';

         pePcox = tnpcob;
         pePacx = tnpacb;
         pePinx = tnpinb;
         peProx = tnprob;
         peiFrx = tnifrb;

       elseif peCoss = 'D' and peCobl = 'D6';

         pePcox = tnpcoc;
         pePacx = tnpacc;
         pePinx = tnpinc;
         peProx = tnproc;
         peiFrx = tnifrc;

       elseif peCoss = 'D' and peCobl = 'D7';

         pePcox = tnpcod;
         pePacx = tnpacd;
         pePinx = tnpind;
         peProx = tnprod;
         peiFrx = tnifrd;

       elseif peCoss = 'D' and peCobl <> 'D2' and peCobl <> 'D3'
              and peCobl <> 'D4' and peCobl <> 'D5'and peCobl <> 'D6'
              and peCobl <> 'D7';

         if COWVEH_vehiculo0km ( peVhan ) = 'S';

           pePcox = tnpc00;

         else;

           difanio = *year - %int(peVhan);

           k1y215.t@vhca = peVhca;
           k1y215.t@vhv1 = peVhv1;
           k1y215.t@vhv2 = peVhv2;

           chain %kds ( k1y215 ) set215;
           if  t@vcss = 04 or t@vcss = 05 or t@vcss = 06;

             //camioneta

             if difanio = 0;

               pePcox = tnpc00;

             elseif difanio = 1;

               pePcox = tnpc01;

             elseif difanio >= 2 and difanio <= 4;

               pePcox = tnpc02;

             elseif difanio >= 5 and difanio <= 7;

               pePcox = tnpc03;

             elseif difanio >= 8 and difanio <= 10;

               pePcox = tnpc04;

             elseif difanio >= 11 and difanio <= 13;

               pePcox = tnpc05;

             elseif difanio >= 14 and difanio <= 16;

               pePcox = tnpc06;

             elseif difanio >= 17;

               pePcox = tnpc07;

             endif;

           else;

             //otros

             if difanio = 0;

               pePcox = tnpc00;

             elseif difanio = 1;

               pePcox = tnpc01;

             elseif difanio = 2;

               pePcox = tnpc02;

             elseif difanio = 3;

               pePcox = tnpc03;

             elseif difanio = 4;

               pePcox = tnpc04;

             elseif difanio = 5;

               pePcox = tnpc05;

             elseif difanio >= 6 and difanio <= 10;

               pePcox = tnpc06;

             elseif difanio >= 11;

               pePcox = tnpc07;

             endif;

           endif;

         endif;

         pePacx = tnpac5;
         pePinx = tnpin5;
         peProx = tnpro5;

       endif;

       return *on;

      /end-free

     P COWVEH_getPorceCob...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getRastreador():Busca si el vehiculo debe tener rastreador*
      *                        o no.                                     *
      *        Input :                                                   *
      *                                                                  *
      *                peCobl  -  Cobertura                              *
      *                peVhvu  -  Suma Asegurada                         *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getRastreador...
     P                 B
     D COWVEH_getRastreador...
     D                 pi             1
     D   peCobl                       2    const
     D   peVhvu                      15  2 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const

     D k1y2253         ds                  likerec(s1t2253:*key)
     D k1y22531        ds                  likerec(s1t22531:*key)

      /free

       COWVEH_inz();

       clear s1t22531;

       k1y2253.t@cobl = pecobl;

       setll %kds ( k1y2253 : 1 ) set225303;
       read set225303;

       k1y22531.t1cobl = pecobl;
       k1y22531.t1nres = t@nres;
       k1y22531.t1Tiou = peTiou;
       k1y22531.t1Stou = peStou;
       k1y22531.t1Stos = peStos;

       chain %kds ( k1y22531 : 5 ) set22531;
       if %found;
         if peVhvu >= t1rast;

           return 'S';

         endif;
       endif;

       return 'N';

      /end-free

     P COWVEH_getRastreador...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getInspeccion():Busca si el vehiculo debe tener inspeccion*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peCobl  -  Cobertura                              *
      *                peVhan  -  Año del Vehículo                       *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getInspeccion...
     P                 B
     D COWVEH_getInspeccion...
     D                 pi             1
     D   peCobl                       2    const
     D   peVhan                       4    const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const

     D k1y2253         ds                  likerec(s1t2253:*key)
     D k1y22531        ds                  likerec(s1t22531:*key)
     D difanio         s              2  0

      /free

       COWVEH_inz();

       if COWVEH_vehiculo0km( peVhan ) = 'S';

         return 'N';

       endif;

       clear s1t22531;

       difanio =  *year - %int( peVhan );

       k1y2253.t@cobl = pecobl;

       setll %kds ( k1y2253 : 1 ) set225303;
       read set225303;

       k1y22531.t1cobl = pecobl;
       k1y22531.t1nres = t@nres;
       k1y22531.t1Tiou = peTiou;
       k1y22531.t1Stou = peStou;
       k1y22531.t1Stos = peStos;

       chain %kds ( k1y22531 : 5 ) set22531;
       if %found;
         if difanio >= t1insp;

           return 'S';

         endif;
       endif;

       return 'N';

      /end-free

     P COWVEH_getInspeccion...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getDuracion  ():Busca la duracion de la cobertura         *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peArcd  -  Número de Artículo .                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getDuracion...
     P                 B
     D COWVEH_getDuracion...
     D                 pi             2  0
     D   peArcd                       6  0 const

     D k1y621          ds                  likerec(s1t621:*key)
     D duracion        s              2  0

      /free

       COWVEH_inz();


       k1y621.t@arcd = peArcd;

       chain %kds ( k1y621 : 1 ) set621;
       if %found();

         duracion = 12/t@dupe;
         return duracion;

       endif;

       return 1;

      /end-free

     P COWVEH_getDuracion...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_chkCobertura():Busca si el vehiculo debe tener inspeccion *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peCobl  -  Cobertura                              *
      *                peVhan  -  Año del Vehículo                       *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_chkCobertura...
     P                 B
     D COWVEH_chkCobertura...
     D                 pi              n
     D   peCobl                       2    const
     D   peVhan                       4    const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const

     D k1y2253         ds                  likerec(s1t2253:*key)
     D k1y22531        ds                  likerec(s1t22531:*key)
     D difanio         s              2  0

      /free

       COWVEH_inz();

       if COWVEH_vehiculo0km( peVhan ) = 'S';

         return *on;

       endif;

       clear s1t22531;

       difanio =  *year - %int( peVhan );

       k1y2253.t@cobl = peCobl;

       setll %kds ( k1y2253 : 1 ) set225303;
       if %equal();
         read set225303;

         k1y22531.t1cobl = peCobl;
         k1y22531.t1nres = t@nres;
         k1y22531.t1Tiou = peTiou;
         k1y22531.t1Stou = peStou;
         k1y22531.t1Stos = peStos;

         //valido antiguedad
         chain %kds ( k1y22531 : 5 ) set22531;
         if %found;

           if difanio <= t1anti;

             return *on;

           else;

             return *off;

           endif;

         endif;
       endif;

       return *on;

      /end-free

     P COWVEH_chkCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_saveDescuentos   ():Graba Descuentos de cotización de *
      *                          Autos                               *
      *                                                              *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Nro. de Componente                 *
      *                peCobl  -  Letra Cobertura                    *
      *                peBoni  -  Bonificaciones                     *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_saveDescuentos...
     P                 B                   export
     D COWVEH_saveDescuentos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const

     D   @@Vhmc        s              3a
     D   @@Vhmo        s              3a
     D   @@Vhcs        s              3a
     D   @@Ccbp        s              3  0
     D   @@mtdf        s              1

     D   @@250         ds                  likeds( dsSet250_t )

     D   k1yet0        ds                  likerec( c1wet0  : *key )
     D   k1y250        ds                  likerec( s1t250  : *key )
     D   k1ybre        ds                  likerec( s1tbre  : *key )
     D   k1yet4        ds                  likerec( c1wet4  : *key )
     D   x             s             10i 0
     D   p@Suas        S             15  2
     D   p@Ccbp        S              3  0
     D   p@Pcbp        S              5  2
     D peCond          s              1a
     D rc              s              1n
     D  @@Tiou         s              1  0
     D  @@Stou         s              2  0
     D  @@Stos         s              2  0

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D peArcd          s              6  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D hoy             s              8  0

     D peDesc          ds                  likeds( dsset250_t )

     D DESC_DECRECIENTE...
     D                 c                   'DEC'
     D POR_COMPONENTE  c                   'C'
     D DESC_CONTADO    c                   'CTD'

      /free

       COWVEH_inz();

       PAR310X3( peBase.peEmpr : peFema : peFemm : peFemd );
       hoy = (peFema * 10000)
           + (peFemm *   100)
           +  peFemd;

       COWGRAI_getTipodeOperacion( peBase
                                 : peNctw
                                 : @@Tiou
                                 : @@Stou
                                 : @@Stos );

       peArcd = COWGRAI_getArticulo( peBase : peNctw );

       k1yet4.t4empr = PeBase.peEmpr;
       k1yet4.t4sucu = PeBase.peSucu;
       k1yet4.t4nivt = PeBase.peNivt;
       k1yet4.t4nivc = PeBase.peNivc;
       k1yet4.t4nctw = peNctw;
       k1yet4.t4rama = peRama;
       k1yet4.t4poco = pePoco;
       k1yet4.t4arse = peArse;
       k1yet4.t4cobl = peCobl;
       setll %kds ( k1yet4 : 9 ) ctwet4;

       if %equal ( ctwet4 );
         return *On;
       endif;

       clear c1wet4;
       t4empr = PeBase.peEmpr;
       t4sucu = PeBase.peSucu;
       t4nivt = PeBase.peNivt;
       t4nivc = PeBase.peNivc;
       t4nctw = peNctw;
       t4rama = peRama;
       t4arse = peArse;
       t4poco = pePoco;
       t4ma01 = *blanks;
       t4ma02 = *blanks;
       t4ma03 = *blanks;
       t4ma04 = *blanks;
       t4ma05 = *blanks;

       k1yet0.t0empr = PeBase.peEmpr;
       k1yet0.t0sucu = PeBase.peSucu;
       k1yet0.t0nivt = PeBase.peNivt;
       k1yet0.t0nivc = PeBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0poco = pePoco;
       k1yet0.t0arse = peArse;
       //...
       t4cobl = peCobl;

       chain %kds( k1yet0 : 8 ) ctwet0;
       if %found( ctwet0 );

         // Descuentos

         // Buen Resultado...
         if t0rebr <> 0;

           t4ccbp = 4;

           k1ybre.seaÑos = t0rebr;
           setll %kds( k1ybre : 1 ) setbre;

           if %equal( setbre );

             reade %kds( k1ybre : 1 ) setbre;

           else;

             setgt *loval setbre;
             readp setbre;

           endif;

           if not %eof( setbre );

             t4pcbp = sepbon;
             write c1wet4;

           endif;

         endif;

         // Integral...
         if t0clin = 'S';
           t4ccbp = 10;
           k1y250.stempr = PeBase.peEmpr;
           k1y250.stsucu = PeBase.peSucu;
           k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                peNctw );
           k1y250.strama = peRama;
           k1y250.stccbp = 10;
           k1y250.stmar1 = 'C';
           chain %kds( k1y250 ) set250;
           if %found( set250 );
             t4pcbp = steppd;
             write c1wet4;
           endif;

         endif;

         // 0km y Cobertura 'D'/'C1'...
         if ( t0m0km = 'S' and
             (%subst(peCobl:1:1) = 'D' or peCobl = 'C1' ) );

          if t0vhca = 1 or t0mtdf <> ' '
          or t0vhca = 4 and t0vhv1 = 6 and t0vhv2 = 3 and t0mtdf = *blanks
          or t0vhca = 4 and t0vhv1 = 6 and t0vhv2 = 4 and t0mtdf = *blanks;

           t4ccbp = 18;

           k1y250.stempr = PeBase.peEmpr;
           k1y250.stsucu = PeBase.peSucu;
           k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                peNctw );
           k1y250.strama = peRama;
           k1y250.stccbp = 18;
           k1y250.stmar1 = 'C';

           chain %kds( k1y250 ) set250;
           if %found( set250 );
             t4pcbp = steppd;
             write c1wet4;
           endif;

          endif;

         endif;

         peCond = '0';

         // 0km...
         if ( t0m0km = 'S' );

           peCond = '1';

           t4ccbp = 997;

           k1y250.stempr = PeBase.peEmpr;
           k1y250.stsucu = PeBase.peSucu;
           k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                peNctw );
           k1y250.strama = peRama;
           k1y250.stccbp = 997;
           k1y250.stmar1 = 'C';

           chain %kds( k1y250 ) set250;
           if %found( set250 );
             if stmar3 = 'N';
               t4pcbp = steppd;
             else;
               clear t4pcbp;
             endif;
             write c1wet4;
           endif;

         endif;

         CZWUTL_chkDescAltaGama2( PeBase.peEmpr
                                : PeBase.peSucu
                                : peCobl
                                : t0vhca
                                : t0vhv1
                                : t0vhv2
                                : t0mtdf
                                : t0vhvu
                                : peCond
                                : p@Ccbp
                                : p@Pcbp        );

         if ( p@Ccbp <> 0 );
           t4Ccbp = p@Ccbp;
           t4pcbp = p@Pcbp;
           write c1wet4;
         endif;

         // Recargos

         // Recargo carrozada cob A...
         if addRecCobA();
            if (peCobl = 'A' and t0vhca = 1) or
               (peCobl = 'A' and t0vhca = 4 and t0mtdf <> ' ') or
               (peCobl = 'A' and t0vhca = 4 and t0vhv1 = 6 );

               t4ccbp = 14;

               k1y250.stempr = PeBase.peEmpr;
               k1y250.stsucu = PeBase.peSucu;
               k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                     peNctw );
               k1y250.strama = peRama;
               k1y250.stccbp = 14;
               k1y250.stmar1 = 'C';
               chain %kds( k1y250 ) set250;
               if %found( set250 );
                  t4pcbp = steppd;
                  write c1wet4;
               endif;

            endif;
         endif;

         // Recargo Marca/Modelo...
         @@vhmc  = t0vhmc;
         @@vhmo  = t0vhmo;
         @@vhcs  = t0vhcs;
         @@Ccbp  = *zeros;
         t4pcbp  = CZWUTL_getDescMarcaModelo( @@Vhmc :
                                              @@Vhmo :
                                              @@Vhcs :
                                              @@Ccbp );
         if ( t4pcbp <> 0 );
           t4Ccbp = 21;
           write c1wet4;
         endif;

         // Promocion Especial 0KM Segundo Año...
         if t0ma05 = '1' or t0ma05 = '2' or t0ma05 = '3';

           k1yet4.t4empr = PeBase.peEmpr;
           k1yet4.t4sucu = PeBase.peSucu;
           k1yet4.t4nivt = PeBase.peNivt;
           k1yet4.t4nivc = PeBase.peNivc;
           k1yet4.t4nctw = peNctw;
           k1yet4.t4rama = peRama;
           k1yet4.t4poco = pePoco;
           k1yet4.t4arse = peArse;
           k1yet4.t4cobl = peCobl;
           k1yet4.t4ccbp = 993;
           chain %kds ( k1yet4 : 10 ) ctwet4;
           if %found( ctwet4 );
             delete c1wet4;
           endif;

           t4ccbp = k1yet4.t4ccbp;

           k1y250.stempr = PeBase.peEmpr;
           k1y250.stsucu = PeBase.peSucu;
           k1y250.starcd = COWGRAI_getArticulo ( peBase
                                               : peNctw );
           k1y250.strama = peRama;
           k1y250.stccbp = k1yet4.t4ccbp;
           k1y250.stmar1 = 'C';

           clear t4pcbp;
           chain %kds( k1y250 ) set250;
           if %found( set250 );
             if stmar3 = 'N';
               t4pcbp = steppd;
             endif;

             if t0ma05 = '1';
               write c1wet4;
             endif;

           endif;

           k1yet4.t4empr = PeBase.peEmpr;
           k1yet4.t4sucu = PeBase.peSucu;
           k1yet4.t4nivt = PeBase.peNivt;
           k1yet4.t4nivc = PeBase.peNivc;
           k1yet4.t4nctw = peNctw;
           k1yet4.t4rama = peRama;
           k1yet4.t4poco = pePoco;
           k1yet4.t4arse = peArse;
           k1yet4.t4cobl = peCobl;
           k1yet4.t4ccbp = 994;
           chain %kds ( k1yet4 : 10 ) ctwet4;
           if %found( ctwet4 );
             delete c1wet4;
           endif;

           t4ccbp = k1yet4.t4ccbp;

           k1y250.stempr = PeBase.peEmpr;
           k1y250.stsucu = PeBase.peSucu;
           k1y250.starcd = COWGRAI_getArticulo ( peBase
                                               : peNctw );
           k1y250.strama = peRama;
           k1y250.stccbp = k1yet4.t4ccbp;
           k1y250.stmar1 = 'C';

           clear t4pcbp;
           chain %kds( k1y250 ) set250;
           if %found( set250 );
             if stmar3 = 'N';
               t4pcbp = steppd;
             endif;

             if t0ma05 = '1';
               write c1wet4;
             endif;

           endif;

         endif;

         //Intermediario habilitado para Descuento/Recargo especial
         if ( @@Tiou = 1 and @@Stou = 0 );
           if ( t0dWeb = '1' );
             SVPDAU_getDescxEquivalente( peBase.peEmpr
                                       : peBase.peSucu
                                       : COWGRAI_getArticulo( peBase : peNctw )
                                       : peRama
                                       : 'WEB'
                                       : 'C'
                                       : @@250 );
             if ( @@250.stccbp <> *Zeros );
               t4Ccbp = @@250.stccbp;
               t4pcbp = t0pWeb;
               write c1wet4;
             endif;
           endif;
         endif;

       endif;

       // ------------------------------------------
       // Productor cabecera castigado
       // ------------------------------------------
       if SVPINT_isCabeceraEspecial( peBase.peEmpr
                                   : peBase.peSucu
                                   : peBase.peNivt
                                   : peBase.peNivc
                                   : p@Ccbp
                                   : p@Pcbp        );
           k1yet4.t4empr = PeBase.peEmpr;
           k1yet4.t4sucu = PeBase.peSucu;
           k1yet4.t4nivt = PeBase.peNivt;
           k1yet4.t4nivc = PeBase.peNivc;
           k1yet4.t4nctw = peNctw;
           k1yet4.t4rama = peRama;
           k1yet4.t4poco = pePoco;
           k1yet4.t4arse = peArse;
           k1yet4.t4cobl = peCobl;
           k1yet4.t4ccbp = p@Ccbp;
           setll %kds(k1yet4:10) ctwet4;
           if not %equal;
              t4empr = PeBase.peEmpr;
              t4sucu = PeBase.peSucu;
              t4nivt = PeBase.peNivt;
              t4nivc = PeBase.peNivc;
              t4nctw = peNctw;
              t4rama = peRama;
              t4poco = pePoco;
              t4arse = peArse;
              t4cobl = peCobl;
              t4ccbp = p@Ccbp;
              t4pcbp = p@Pcbp;
              write c1wet4;
           endif;

       endif;

       // ------------------------------------------
       // Bonificacion Decreciente
       // ------------------------------------------
       if @@Tiou <= 2;
          if SPVVEH_getDescDecreciente( peArcd
                                      : peRama
                                      : @@Tiou
                                      : @@Stou
                                      : hoy
                                      : *zeros
                                      : p@Pcbp );
             if SVPDAU_getDescxEquivalente( peBase.peEmpr
                                          : peBase.peSucu
                                          : peArcd
                                          : peRama
                                          : DESC_DECRECIENTE
                                          : POR_COMPONENTE
                                          : peDesc             );
                if SVPDAU_isVigente( peDesc.stempr
                                   : peDesc.stsucu
                                   : peDesc.starcd
                                   : peDesc.strama
                                   : peDesc.stccbp
                                   : peDesc.stmar1
                                   : hoy           );
                   k1yet4.t4empr = PeBase.peEmpr;
                   k1yet4.t4sucu = PeBase.peSucu;
                   k1yet4.t4nivt = PeBase.peNivt;
                   k1yet4.t4nivc = PeBase.peNivc;
                   k1yet4.t4nctw = peNctw;
                   k1yet4.t4rama = peRama;
                   k1yet4.t4poco = pePoco;
                   k1yet4.t4arse = peArse;
                   k1yet4.t4cobl = peCobl;
                   k1yet4.t4ccbp = peDesc.stccbp;
                   setll %kds(k1yet4:10) ctwet4;
                   if not %equal;
                      t4empr = PeBase.peEmpr;
                      t4sucu = PeBase.peSucu;
                      t4nivt = PeBase.peNivt;
                      t4nivc = PeBase.peNivc;
                      t4nctw = peNctw;
                      t4rama = peRama;
                      t4poco = pePoco;
                      t4arse = peArse;
                      t4cobl = peCobl;
                      t4ccbp = peDesc.stccbp;
                      t4pcbp = p@Pcbp;
                      write c1wet4;
                   endif;
             endif;
          endif;
       endif;
       endif;

       // ------------------------------------------
       // Descuento de contado
       // ------------------------------------------
       if SVPDAU_getDescxEquivalente( peBase.peEmpr
                                    : peBase.peSucu
                                    : peArcd
                                    : peRama
                                    : DESC_CONTADO
                                    : POR_COMPONENTE
                                    : peDesc             );
          if SVPDAU_isVigente( peDesc.stempr
                             : peDesc.stsucu
                             : peDesc.starcd
                             : peDesc.strama
                             : peDesc.stccbp
                             : peDesc.stmar1
                             : hoy           );
             k1yet4.t4empr = PeBase.peEmpr;
             k1yet4.t4sucu = PeBase.peSucu;
             k1yet4.t4nivt = PeBase.peNivt;
             k1yet4.t4nivc = PeBase.peNivc;
             k1yet4.t4nctw = peNctw;
             k1yet4.t4rama = peRama;
             k1yet4.t4poco = pePoco;
             k1yet4.t4arse = peArse;
             k1yet4.t4cobl = peCobl;
             k1yet4.t4ccbp = peDesc.stccbp;
             setll %kds(k1yet4:10) ctwet4;
             if not %equal;
                t4empr = PeBase.peEmpr;
                t4sucu = PeBase.peSucu;
                t4nivt = PeBase.peNivt;
                t4nivc = PeBase.peNivc;
                t4nctw = peNctw;
                t4rama = peRama;
                t4poco = pePoco;
                t4arse = peArse;
                t4cobl = peCobl;
                t4ccbp = peDesc.stccbp;
                t4pcbp = peDesc.stpcbp;
                write c1wet4;
             endif;
          endif;
       endif;

       return *off;

      /end-free

     P COWVEH_saveDescuentos...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_saveDescuentosRec():Graba Descuentos de la Recotiza-  *
      *                            ción.                             *
      *                                                              *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Nro. de Componente                 *
      *                peCobl  -  Letra Cobertura                    *
      *                peBoni  -  Bonificaciones                     *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_saveDescuentosRec...
     P                 B                   export
     D COWVEH_saveDescuentosRec...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peBoni                            likeds(bonVeh) dim (99) const

     D   x             s             10i 0

     D   @@250         ds                  likeds( dsset250_t )
     D   @@290         ds                  likeds( dsset290_t )

     D   k1yet4        ds                  likerec( c1wet4  : *key )
     D   k1yet0        ds                  likerec( c1wet0  : *key )
     D   k1y250        ds                  likerec( s1t250  : *key )
     D   k1ybre        ds                  likerec( s1tbre  : *key )

     D  @@Tiou         s              1  0
     D  @@Stou         s              2  0
     D  @@Stos         s              2  0

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D peArcd          s              6  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D hoy             s              8  0
     D p@ccbp          s              5  2

     D peDesc          ds                  likeds( dsset250_t )

     D DESC_DECRECIENTE...
     D                 c                   'DEC'
     D POR_COMPONENTE  c                   'C'
     D DESC_CONTADO    c                   'CTD'

      /free

       COWVEH_inz();

       k1yet0.t0empr = PeBase.peEmpr;
       k1yet0.t0sucu = PeBase.peSucu;
       k1yet0.t0nivt = PeBase.peNivt;
       k1yet0.t0nivc = PeBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0poco = pePoco;
       k1yet0.t0arse = peArse;

       chain %kds( k1yet0 : 8 ) ctwet0;
       if %found( ctwet0 );

         for x = 1 to 99;

           clear c1wet4;
           t4empr = PeBase.peEmpr;
           t4sucu = PeBase.peSucu;
           t4nivt = PeBase.peNivt;
           t4nivc = PeBase.peNivc;
           t4nctw = peNctw;
           t4rama = peRama;
           t4arse = peArse;
           t4poco = pePoco;
           t4ma01 = *blanks;
           t4ma02 = *blanks;
           t4ma03 = *blanks;
           t4ma04 = *blanks;
           t4ma05 = *blanks;
           //...
           t4cobl = peBoni(x).cobl;

           if peBoni(x).ccbp = 4;

             // Buen Resultado...
             if t0rebr <> 0;
               t4ccbp = 4;
               k1ybre.seaÑos = t0rebr;
               setll %kds( k1ybre : 1 ) setbre;
               if  %equal( setbre );
                 reade %kds( k1ybre : 1 ) setbre;
               else;
                 setgt *hival setbre;
                 readp setbre;
               endif;

               if not %eof( setbre );
                 t4pcbp = peBoni(x).pcbp * -1;
                 write c1wet4;
               endif;

             endif;

           endif;

           if peBoni(x).ccbp = 10;
             // Integral...
             if t0clin = 'S';
               t4ccbp = 10;
               k1y250.stempr = PeBase.peEmpr;
               k1y250.stsucu = PeBase.peSucu;
               k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                    peNctw );
               k1y250.strama = peRama;
               k1y250.stccbp = 10;
               k1y250.stmar1 = 'C';
               chain %kds( k1y250 ) set250;
               if %found( set250 );
                 t4pcbp = peBoni(x).pcbp * -1;
                 write c1wet4;
               endif;

             endif;
           endif;

           if peBoni(x).ccbp = 18;
             // 0km...
             if ( t0m0km = 'S' and
                 %subst(peBoni(x).cobl:1:1) = 'D' or peBoni(x).cobl= 'C1' );

               t4ccbp = 18;

               k1y250.stempr = PeBase.peEmpr;
               k1y250.stsucu = PeBase.peSucu;
               k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                    peNctw );
               k1y250.strama = peRama;
               k1y250.stccbp = 18;
               k1y250.stmar1 = 'C';

               chain %kds( k1y250 ) set250;
               if %found( set250 );
                 t4pcbp = peBoni(x).pcbp * -1;
                 write c1wet4;
               endif;

             endif;
           endif;

           if addRecCobA();
              if peBoni(x).ccbp = 14;
                 // Recargo...
                 if peBoni(x).cobl = 'A' and t0vhca = 1 or
                    peBoni(x).cobl = 'A' and t0vhca = 4 and t0mtdf <> ' ' or
                    peBoni(x).cobl = 'A' and t0vhca = 4 and t0vhv1 = 6;

                    t4ccbp = 14;

                    k1y250.stempr = PeBase.peEmpr;
                    k1y250.stsucu = PeBase.peSucu;
                    k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                         peNctw );
                    k1y250.strama = peRama;
                    k1y250.stccbp = 14;
                    k1y250.stmar1 = 'C';
                    chain %kds( k1y250 ) set250;
                    if %found( set250 );
                      t4pcbp = peBoni(x).pcbp * -1;
                      write c1wet4;
                    endif;

                 endif;
              endif;
           endif;

           if peBoni(x).ccbp = 21;
             // Recargo Marca/Modelo...
             t4pcbp  = peBoni(x).pcbp * -1;
             if ( t4pcbp <> 0 );
               t4Ccbp = 21;
               write c1wet4;
             endif;

           endif;

           if peBoni(x).ccbp = 31;
             // AltaGama...
               t4ccbp = 31;
               k1y250.stempr = PeBase.peEmpr;
               k1y250.stsucu = PeBase.peSucu;
               k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                    peNctw );
               k1y250.strama = peRama;
               k1y250.stccbp = 31;
               k1y250.stmar1 = 'C';
               chain %kds( k1y250 ) set250;
               if %found( set250 );
                 t4pcbp = peBoni(x).pcbp * -1;
                 write c1wet4;
               endif;

           endif;

           // Promocion Especial 0KM...
           if ( t0m0km = 'S' and peBoni(x).ccbp = 997);
             t4ccbp = 997;
             k1y250.stempr = PeBase.peEmpr;
             k1y250.stsucu = PeBase.peSucu;
             k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                  peNctw );
             k1y250.strama = peRama;
             k1y250.stccbp = 997;
             k1y250.stmar1 = 'C';

             chain %kds( k1y250 ) set250;
             if %found( set250 );
               if stmar3 = 'N';
                 t4pcbp = peBoni(x).pcbp * -1;
               else;
                 clear t4pcbp;
               endif;
               write c1wet4;
             endif;
           endif;

           // Cero Kms Segundo Año...
           if ( t0ma05 = '1' or t0ma05 = '2' or t0ma05 = '3' )
              and peBoni(x).ccbp = 993;

             k1yet4.t4empr = PeBase.peEmpr;
             k1yet4.t4sucu = PeBase.peSucu;
             k1yet4.t4nivt = PeBase.peNivt;
             k1yet4.t4nivc = PeBase.peNivc;
             k1yet4.t4nctw = peNctw;
             k1yet4.t4rama = peRama;
             k1yet4.t4poco = pePoco;
             k1yet4.t4arse = peArse;
             k1yet4.t4cobl = peBoni(x).cobl;
             k1yet4.t4ccbp = 993;
             chain %kds ( k1yet4 : 10 ) ctwet4;
             if %found( ctwet4 );
               delete c1wet4;
             endif;

             t4ccbp = k1yet4.t4ccbp;
             k1y250.stempr = PeBase.peEmpr;
             k1y250.stsucu = PeBase.peSucu;
             k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                  peNctw );
             k1y250.strama = peRama;
             k1y250.stccbp = k1yet4.t4ccbp;
             k1y250.stmar1 = 'C';

             clear t4pcbp;
             chain %kds( k1y250 ) set250;
             if %found( set250 );
               if stmar3 = 'N';
                 t4pcbp = peBoni(x).pcbp * -1;
               endif;

               if t0ma05 = '1';
                 write c1wet4;
               endif;

             endif;

           endif;

           // Cero Kms Segundo Año...
           if ( t0ma05 = '1' or t0ma05 = '2' or t0ma05 = '3' )
              and peBoni(x).ccbp = 994;

             k1yet4.t4empr = PeBase.peEmpr;
             k1yet4.t4sucu = PeBase.peSucu;
             k1yet4.t4nivt = PeBase.peNivt;
             k1yet4.t4nivc = PeBase.peNivc;
             k1yet4.t4nctw = peNctw;
             k1yet4.t4rama = peRama;
             k1yet4.t4poco = pePoco;
             k1yet4.t4arse = peArse;
             k1yet4.t4cobl = peBoni(x).cobl;
             k1yet4.t4ccbp = 994;
             chain %kds ( k1yet4 : 10 ) ctwet4;
             if %found( ctwet4 );
               delete c1wet4;
             endif;

             t4ccbp = k1yet4.t4ccbp;
             k1y250.stempr = PeBase.peEmpr;
             k1y250.stsucu = PeBase.peSucu;
             k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                  peNctw );
             k1y250.strama = peRama;
             k1y250.stccbp = k1yet4.t4ccbp;
             k1y250.stmar1 = 'C';

             clear t4pcbp;
             chain %kds( k1y250 ) set250;
             if %found( set250 );
               if stmar3 = 'N';
                 t4pcbp = peBoni(x).pcbp * -1;
               endif;

               if t0ma05 = '1';
                 write c1wet4;
               endif;

             endif;

           endif;

           // Recargo Comercial;
           if peBoni(x).ccbp = 999;
             COWVEH_setRecargoComercial( peBase
                                       : peNctw
                                       : peRama
                                       : peArse
                                       : pePoco
                                       : peBoni(x).cobl
                                       : peBoni(x).ccbp
                                       : peBoni(x).pcbp );
           endif;

           // --------------------------------------------
           // Multiples conductores (Compara en casa)
           // --------------------------------------------
           if peBoni(x).ccbp = 36;
               t4ccbp = 36;
               k1y250.stempr = PeBase.peEmpr;
               k1y250.stsucu = PeBase.peSucu;
               k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                                    peNctw );
               k1y250.strama = peRama;
               k1y250.stccbp = 36;
               k1y250.stmar1 = 'C';
               chain %kds( k1y250 ) set250;
               if %found( set250 );
                 t4pcbp = peBoni(x).pcbp * -1;
                 write c1wet4;
               endif;
           endif;

           // Tiene descuento especial WEB?!!!...
           if ( t0dWeb = '1' and peBoni(x).ccbp = 980);
             SVPDAU_getDescxEquivalente( peBase.peEmpr
                                       : peBase.peSucu
                                       : COWGRAI_getArticulo(peBase:peNctw)
                                       : peRama
                                       : 'WEB'
                                       : 'C'
                                       : @@250 );
             if ( @@250.stccbp <> *Zeros );
               t4Ccbp = @@250.stccbp;
               t4pcbp = t0pWeb;
               write c1wet4;
             endif;
           endif;

           // --------------------------------
           // Decreciente
           // --------------------------------
           if peBoni(x).ccbp = 990;
              PAR310X3( peBase.peEmpr : peFema : peFemm : peFemd );
              hoy = (peFema * 10000)
                  + (peFemm *   100)
                  +  peFemd;
              COWGRAI_getTipodeOperacion( peBase
                                        : peNctw
                                        : @@Tiou
                                        : @@Stou
                                        : @@Stos );
              peArcd = COWGRAI_getArticulo( peBase : peNctw );
              if SPVVEH_getDescDecreciente( peArcd
                                          : peRama
                                          : @@Tiou
                                          : @@Stou
                                          : hoy
                                          : 0
                                          : p@Ccbp   );
                 t4Ccbp = 990;
                 t4pcbp = p@Ccbp;
                 write c1wet4;
              endif;
           endif;

           // ------------------------------------------
           // Descuento de contado
           // ------------------------------------------
           if peBoni(x).ccbp = 600;
              k1yet4.t4empr = PeBase.peEmpr;
              k1yet4.t4sucu = PeBase.peSucu;
              k1yet4.t4nivt = PeBase.peNivt;
              k1yet4.t4nivc = PeBase.peNivc;
              k1yet4.t4nctw = peNctw;
              k1yet4.t4rama = peRama;
              k1yet4.t4poco = pePoco;
              k1yet4.t4arse = peArse;
              k1yet4.t4cobl = peBoni(x).cobl;
              k1yet4.t4ccbp = peBoni(x).ccbp;
              setll %kds(k1yet4:10) ctwet4;
              if not %equal;
                 t4empr = PeBase.peEmpr;
                 t4sucu = PeBase.peSucu;
                 t4nivt = PeBase.peNivt;
                 t4nivc = PeBase.peNivc;
                 t4nctw = peNctw;
                 t4rama = peRama;
                 t4poco = pePoco;
                 t4arse = peArse;
                 t4cobl = peBoni(x).cobl;
                 t4ccbp = peBoni(x).ccbp;
                 t4pcbp = peBoni(x).pcbp * -1;
                 write c1wet4;
              endif;
           endif;

         endfor;

       endif;


       return *off;
      /end-free

     P COWVEH_saveDescuentosRec...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_getDescuentos ():Obtiene los descuentos y actualiza   *
      *                         las coberturas.                      *
      *                                                              *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Nro. de Componente                 *
      *                peCobl  -  Letra Cobertura                    *
      *                peBoni  -  Bonificacion/Descuento             *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_getDescuentos...
     P                 B
     D COWVEH_getDescuentos...
     D                 pi             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const

     D   p@pBon        s              5  2

     D   k1yet4        ds                  likerec( c1wet4  : *key )
     D   k1y250        ds                  likerec( s1t250  : *key )

      /free

       COWVEH_inz();

       clear p@pBon;
       k1yet4.t4empr = peBase.peEmpr;
       k1yet4.t4sucu = peBase.peSucu;
       k1yet4.t4nivt = peBase.peNivt;
       k1yet4.t4nivc = peBase.peNivc;
       k1yet4.t4nctw = peNctw;
       k1yet4.t4rama = peRama;
       k1yet4.t4arse = peArse;
       k1yet4.t4poco = pePoco;
       k1yet4.t4cobl = peCobl;

       setll %kds( k1yet4 : 9 ) ctwet4;
       reade %kds( k1yet4 : 9 ) ctwet4;
       dow not %eof ( ctwet4 );

         k1y250.stempr = PeBase.peEmpr;
         k1y250.stsucu = PeBase.peSucu;
         k1y250.starcd = COWGRAI_getArticulo ( peBase :
                                              peNctw );
         k1y250.strama = peRama;
         k1y250.stccbp = t4ccbp;
         k1y250.stmar1 = 'C';
         chain %kds( k1y250 ) set250;
         if %found( set250 );
           if stmar3 <> 'S';
             p@Pbon += t4pcbp;
           endif;
         endif;
         reade %kds( k1yet4 : 9 ) ctwet4;
       enddo;

       return p@Pbon;

      /end-free

     P COWVEH_getDescuentos...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_aplicaDescuentos():Aplica los descuentos y actualiza  *
      *                           las coberturas.                    *
      *                                                              *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Nro. de Componente                 *
      *                peCobl  -  Letra Cobertura                    *
      *                peBoni  -  Bonificacion/Descuento             *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_aplicaDescuentos...
     P                 B
     D COWVEH_aplicaDescuentos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const
     D   pePbon                       5  2 const

     D   p@Boni        s              5  2

     D   k1yetc        ds                  likerec( c1wetc  : *key )

      /free

       COWVEH_inz();

       k1yetc.t0empr = peBase.peEmpr;
       k1yetc.t0sucu = peBase.peSucu;
       k1yetc.t0nivt = peBase.peNivt;
       k1yetc.t0nivc = peBase.peNivc;
       k1yetc.t0nctw = peNctw;
       k1yetc.t0rama = peRama;
       k1yetc.t0arse = peArse;
       k1yetc.t0poco = pePoco;
       k1yetc.t0cobl = peCobl;

       chain %kds( k1yetc ) ctwetc;
       if %found ( ctwetc );

         t0prrc = t0prrc - ( t0prrc * pePbon ) / 100;
         t0prac = t0prac - ( t0prac * pePbon ) / 100;
         t0prro = t0prro - ( t0prro * pePbon ) / 100;
         t0prin = t0prin - ( t0prin * pePbon ) / 100;
         t0prce = t0prce - ( t0prce * pePbon ) / 100;
         t0prap = t0prap - ( t0prap * pePbon ) / 100;

         t0prim = t0prrc + t0prac + t0prro + t0prin + t0prce + t0prap;

         update c1wetc;

         return *on;

       endif;

       return *off;

      /end-free

     P COWVEH_aplicaDescuentos...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_detalleCobertura(): Buscar el texto de las coberturas *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Letra Cobertura                    *
      *                peScta  -  Zona de riesgo                     *
      *                peCobl  -  Letra Cobertura                    *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peTxtd  -  Texto detalle                      *
      *                peTxtdC -  Cantidad de lineas                 *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Estructura de Error                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_detalleCobertura...
     P                 B                   export
     D COWVEH_detalleCobertura...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peScta                       1  0 const
     D   peCobl                       2    const
     D   peTxtd                            likeds(textdeta) dim(999)
     D   peTxtdC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   k1y015        ds                  likerec( s1t015 : *key )
     D   k1y016        ds                  likerec( s1t016 : *key )
     D   k1y017        ds                  likerec( s1t017 : *key )
     D   k1y018        ds                  likerec( s1t018 : *key )
     D   k1y124        ds                  likerec( s1t124 : *key )

     D   @@Rama        s              2  0
     D   @@Arse        s              2  0
     D   @@Poco        s              4  0
     D   @@Cobl        s              2
     D   @@Ccbp        s              3  0
     D   peDsCt4       ds                  likeds(dsCarac_t) dim(999)
     D   peDsCt4C      s             10i 0
     D   @@Arcd        s              6  0
     D   @@Tiou        s              1  0
     D   @@Stou        s              2  0
     D   @@Stos        s              2  0
     D   x             s             10i 0
     D   mifecha       s             10d   datfmt(*iso)

      /free

       COWVEH_inz();

       peTxtdC = *Zeros;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return;

       endif;

       //Valido Cotización
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

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama que pueda emitir en web
       if SVPVAL_ramaWeb ( peRama ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_RAMNW = ErrCode;

           %subst(wrepl:1:2) = %editc(peRama:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama de auto
       if SVPWS_getGrupoRama ( peRama ) <> 'A';

         %subst(wrepl:1:2) = %editc ( peRama : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0067'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;

       endif;

       k1y015.s015_t@empr = peBase.peEmpr;
       k1y015.s015_t@sucu = peBase.peSucu;
       k1y015.s015_t@rama = peRama;

       setgt %kds ( k1y015 : 3 ) set015;
       readpe %kds ( k1y015 : 3 ) set015;

         if s015_t@marp = '*' and %date(*date) >= s015_t@vigd;

           k1y016.s016_t@empr = peBase.peEmpr;
           k1y016.s016_t@sucu = peBase.peSucu;
           k1y016.s016_t@nres = s015_t@nres;
           k1y016.s016_t@scta = peScta;
           k1y016.s016_t@cobl = peCobl;
           COWRTV_getOperacion ( peBase :
                                 peNctw :
                                 k1y016.s016_t@tiou :
                                 k1y016.s016_t@stou :
                                 k1y016.s016_t@stos );


           setll %kds ( k1y016 : 8 ) set01601;
           reade %kds ( k1y016 : 8 ) set01601;
           dow not %eof();

             k1y124.s124_t@rama = peRama;
             k1y124.s124_t@tpcd = s016_t@tpcd;

             setll %kds ( k1y124 : 2 ) set124;
             reade %kds ( k1y124 : 2 ) set124;
             dow not %eof();

               peTxtdC += 1;

               peTxtd(peTxtdC).tpnl = s124_t@tpnl;
               peTxtd(peTxtdC).tpds = s124_t@tpds;

               if peTxtdC = 999;
                  return;
               endif;

               reade %kds ( k1y124 : 2 ) set124;
             enddo;

             reade %kds ( k1y016 : 8 ) set01601;
           enddo;

         endif;

         // Se procede a cargar texto desde caracteristicas

         @@Rama =  peRama;
         @@Arse =  peArse;
         @@Poco =  pePoco;
         @@Cobl =  peCobl;

         if COWVEH_getCaracteristicas ( peBase
                                      : peNctw
                                      : @@Rama
                                      : @@Arse
                                      : @@Poco
                                      : @@Cobl
                                      : *omit
                                      : peDsCt4
                                      : peDsCt4C );

           @@Arcd = COWGRAI_getArticulo( peBase
                                       : peNctw );

           COWRTV_getOperacion( peBase
                              : peNctw
                              : @@Tiou
                              : @@Stou
                              : @@Stos );

           k1y017.s017_t@Empr = peBase.peEmpr;
           k1y017.s017_t@Sucu = peBase.peSucu;
           k1y017.s017_t@Rama = @@Rama;

           setgt %kds ( k1y017  : 3 ) set017;
           readpe %kds ( k1y017 : 3 ) set017;
           dow not %eof( set017 );

             if s017_t@marp = '*' and %date() >= s017_t@Vigd;

               for x = 1 to peDsCt4C;

                 k1y018.s018_t@Empr = peBase.peEmpr;
                 k1y018.s018_t@Sucu = peBase.peSucu;
                 k1y018.s018_t@Rama = @@Rama;
                 k1y018.s018_t@Nres = s017_t@Nres;
                 k1y018.s018_t@Arcd = @@Arcd;
                 k1y018.s018_t@Ccbp = peDsCt4(x).t4ccbp;
                 k1y018.s018_t@Tiou = @@Tiou;
                 k1y018.s018_t@Stou = @@Stou;
                 k1y018.s018_t@Stos = @@Stos;
                 chain %kds( k1y018:9 ) set018;

                 if %found ( set018 );
                   k1y124.s124_t@rama = @@Rama;
                   k1y124.s124_t@tpcd = s018_t@Tpcd;

                   setll %kds ( k1y124 : 2 ) set124;
                   reade %kds ( k1y124 : 2 ) set124;
                   dow not %eof( set124 );

                     peTxtdC += 1;

                     peTxtd(peTxtdC).tpnl = s124_t@tpnl;
                     peTxtd(peTxtdC).tpds = s124_t@tpds;

                     if peTxtdC = 999;
                       return;
                     endif;

                     reade %kds ( k1y124 : 2 ) set124;
                   enddo;
                 endif;
               endfor;
               leave;
              return;
             endif;
             readpe %kds ( k1y017 : 3 ) set017;
           enddo;
         endif;

       return;

      /end-free

     P COWVEH_detalleCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_selectCobertura(): Indica la cobertura que fue        *
      *                           seleccionada.                      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Número de Componente               *
      *                peCobl  -  Letra Cobertura                    *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Estructura de Error                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_selectCobertura...
     P                 B                   export
     D COWVEH_selectCobertura...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   k1yetc        ds                  likerec( c1wetc  : *key )
     D   @@indo        s              1
     D   @@prim        s             15  2
     D   @@prem        s             15  2

     D cambio          s               n
     D peImpu7         ds                  likeds(primPrem) dim(99)
     D peImpuC         s             10i 0
     D pePrem7         s             15  2

      /free

       COWVEH_inz();

       peErro = *Zeros;

       cambio = *Off;
       clear @@indo;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return;

       endif;

       //Valido Cotización
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

         endif;

         peErro = -1;
         return;

       endif;

       //Valido Estado Cotización
       if COWGRAI_chkEstCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTTR = ErrCode;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'EMI0000'
                        : peMsgs  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama que pueda emitir en web
       if SVPVAL_ramaWeb ( peRama ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_RAMNW = ErrCode;

           %subst(wrepl:1:2) = %editc(peRama:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama de auto
       if SVPWS_getGrupoRama ( peRama ) <> 'A';

         %subst(wrepl:1:2) = %editc ( peRama : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0067'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;

       endif;

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

         if t0cobl = peCobl;

           t0cobs = '1';
           cambio = *on;

           @@indo = 'S';
           @@prim = t0prim;
           @@prem = t0prem;

         else;

           t0cobs = '0';

         endif;

         update c1wetc;

         reade %kds ( k1yetc : 8 ) ctwetc;
       enddo;

       if cambio;
         //actualizo los importes de impuestos y primas
         COWVEH_setImportesVeh( peBase :
                                peNctw :
                                peRama :
                                peArse :
                                pePoco );

         clear peImpu7;

         COWGRAI_getPremioFinal ( peBase : peNctw );

       else;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0040'
                      : peMsgs );
         peErro = -1;
         return;
       endif;


       return;

      /end-free

     P COWVEH_selectCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_origenVehiculo: Busca si el vehiculo es nacional o    *
      *                        importado                             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peVhmc  -  Marca del Vehículo                 *
      *                peVhmo  -  Modelo del Vehículo                *
      *                peVhcs  -  SubModelo del Vehículo             *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_origenVehiculo...
     P                 B
     D COWVEH_origenVehiculo...
     D                 pi             1
     D   peVhmc                       3      const
     D   peVhmo                       3      const
     D   peVhcs                       3      const

     D   k1y204        ds                  likerec( s1t204  : *key )

      /free

       COWVEH_inz();

       k1y204.t@vhmc = peVhmc;
       k1y204.t@vhmo = peVhmo;
       k1y204.t@vhcs = peVhcs;

       chain %kds ( k1y204 ) set204;
       if %found;

         return t@vhni;

       endif;

       return '';

      /end-free

     P COWVEH_origenVehiculo...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_chkCotizar():  Valida Cotizacion                          *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peCfpg  -  Código Forma de Pago                   *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de IVA                          *
      *                peCtre  -  Tarifa                                 *
      *                peDesE  -  Descuento Especial                     *
      *                peTaaj  -  Código de Cuestionario                 *
      *                peScor  -  Estructura de Preguntas                *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_chkCotizar...
     P                 B                   export
     D COWVEH_chkCotizar...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peCfpg                       1  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peImpu                            likeds(Impuesto) dim(99) const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peDesE                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D k1t200          ds                  likerec(s1t200:*key)
     D k1t207          ds                  likerec(s1t207:*key)
     D k1t204          ds                  likerec(s1t204:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)
     D samin           s             15  2
     D samax           s             15  2

     D p@Tiou          s              1  0
     D p@Stou          s              2  0
     D p@Stos          s              2  0
     D p@xrea          s              5  2
     D p@xopr          s              5  2
     D @@dife          s              5  2
     D @@xopr          s              5  2
     D i               s             10i 0
     D x               s             10i 0
     D @min            s             20a
     D @max            s             20a
     D @@Vhvu          s             15  2 inz
     D @vhan           s              4a
     D @@vsys          s            512
     D @@Cosg          s              4
     D @@Coex          s              4
     D peArcd          s              6  0
     D Flota           s               n
     D @@Vhan          s              4
     D Del0Km2a        s                   like(*in99)
     D @@290           ds                  likeds( dsSet290_t )
     D ValidaDescuentoWEB...
     D                 s               n

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       COWVEH_inz();

       peErro = *Zeros;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return;

       endif;

       //Valido Cotización
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

         endif;

         peErro = -1;
         return;

       endif;

       // Verifica si es una flota
       if COWGRAI_isFlota( peBase
                         : peNctw );
         Flota = *on;
       else;
         Flota = *off;
       endif;

       //Valido Componente <> 0
       if pePoco = *Zeros;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0118'
                      : peMsgs );

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama que pueda emitir en web
       if SVPVAL_ramaWeb ( peRama ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_RAMNW = ErrCode;

           %subst(wrepl:1:2) = %editc(peRama:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama de auto
       if SVPWS_getGrupoRama ( peRama ) <> 'A';

         %subst(wrepl:1:2) = %editc ( peRama : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0067'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;

       endif;

       //Descuento Especial
       if ( peDese <> *Zeros );

         // Si la Cotizacion proviene desde API...
         if COWGRAI_chkCotizacionApi( peBase : peNctw );
           clear @@Vsys;
           SVPVLS_getValSys( 'HAPIDESHAB'  :*omit :@@Vsys );
           if %trim( @@Vsys ) <> 'S';

             %subst( wrepl : 1 : 40 ) = 'Descuento Especial WEB';
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0184'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;

           endif;
         endif;

          if not SVPINT_chkDescuentoWeb( peBase.peEmpr
                                       : peBase.peSucu
                                       : peBase.peNivt
                                       : peBase.peNivc
                                       : peRama );
            %subst( wrepl : 1 : 1 ) = %editc( peBase.peNivt : 'X');
            %subst( wrepl : 2 : 6 ) = %editc( peBase.peNivc : 'X');
            %subst( wrepl : 7 : 40) = %trim( SVPINT_GetNombre( peBase.peEmpr
                                                             : peBase.peSucu
                                                             : peBase.peNivt
                                                             : peBase.peNivc));
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'API0019'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
            peErro = -1;
            return;
          endif;

          if not SVPINT_getDescuentoWeb( peBase.peEmpr
                                       : peBase.peSucu
                                       : peBase.peNivt
                                       : peBase.peNivc
                                       : peRama
                                       : *Omit
                                       : @@290 );
            %subst( wrepl : 1 : 40 ) = 'Descuento Especial WEB';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0184'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
            peErro = -1;
            return;
          endif;

          if  peDesE > @@290.t@porc;
            %subst( wrepl : 1 : 6 ) = %editW( peDesE : ' 0 ,  ') ;
            %subst( wrepl : 7 : 6 ) = %editW( @@290.t@porc : ' 0 ,  ');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'API0020'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
            peErro = -1;
            return;
          endif;

          if ( peBure <> *Zeros );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'API0018'
                         : peMsgs );
            peErro = -1;
            return;
          endif;
       endif;

       //busco el tipo de operación en la cabecera, si es Tiou 2 (renovación)
       //no verifico el año del vehículo.

       COWRTV_getOperacion ( peBase :
                             peNctw :
                             p@Tiou :
                             p@Stou :
                             p@Stos );

       if p@Tiou <> 2;

        if not Flota;

         if COWVEH_anioVehiculo ( peVhan ) = *off;

           ErrText = COWVEH_Error(ErrCode);

           if COWVEH_ANIONP = ErrCode;

             %subst(wrepl:1:4) = peVhan;

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0083'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

           endif;

           peErro = -1;
           return;
         endif;

        endif;

       endif;

       //Valido modelo del Vehículo
       if SPVVEH_CheckMarca ( peVhmc ) = *off;

         ErrText = SPVVEH_Error(ErrCode);

         if SPVVEH_VMCNF = ErrCode;

           %subst(wrepl:1:15) = peVhmc;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0084'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido modelo del Vehículo
       if SPVVEH_CheckMod ( peVhmo ) = *off;

         ErrText = SPVVEH_Error(ErrCode);

         if SPVVEH_VMONF = ErrCode;

           %subst(wrepl:1:15) = peVhmo;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0085'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Submodelo del Vehículo
       if SPVVEH_CheckSubMod ( peVhcs ) = *off;

         ErrText = SPVVEH_Error(ErrCode);

         if SPVVEH_VCSNF = ErrCode;

           %subst(wrepl:1:15) = peVhcs;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0086'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       // ---------------------------------------------
       // Valido suma asegurada vs Infoauto + % de
       // SET200. Agregamos esto porque ahora resulta
       // que el usuario en el form web puede escribir
       // a mano la suma (y la barra con la que tanto
       // jodieron, resulta que es secundaria)
       // ---------------------------------------------
       // Se agrega mejora tras solicitar que a la suma
       // asegurada recibida se le resten los accesorios
       // y el valor de GNC
       // ------------------------------------------------
       @@vhvu = peVhvu - peRgnc;
       for x = 1 to 100;
          if peAcce(x).secu = *Zeros;
             leave;
          endif;
          @@vhvu -= peAcce(x).accv;
       endfor;

       // Verifica si aplica para 0KM segundo año
       clear @@Vhan;
       if getCeroKmsSegundoAÑo( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : Del0KM2a );
         @@Vhan = '0KM';
       endif;

       k1t204.t@vhmc = peVhmc;
       k1t204.t@vhmo = peVhmo;
       k1t204.t@vhcs = peVhcs;
       chain %kds(k1t204) set204;
       if %found;
          eval-corr k1t207 = k1t204;
          k1t207.t@vhcr = t@vhcr;
          if peVhan = '0KM' or
             peVhan = '0km' or
             peVhan = '0Km' or
             peVhan = '0kM' or
             @@Vhan = '0KM';
             k1t207.t@vhaÑ = *zeros;
           else;
             k1t207.t@vhaÑ = %dec(peVhan:4:0);
          endif;
          chain %kds(k1t207) set2071;
          if %found;
             k1t200.t@mone = COWGRAI_monedaCotizacion(peBase:peNctw);
             k1t200.t@sumh = t@vhvu;
             setll %kds( k1t200:2 ) set200;
             reade %kds( k1t200:1 ) set200;
             if not %eof(set200);
                samax = t@vhvu + ( (t@vhvu * t@maxi)/100 );
                samin = t@vhvu - ( (t@vhvu * t@mini)/100 );
                @min  = %editw(samin:' .   .   .   . 0 ,  ');
                @max  = %editw(samax:' .   .   .   . 0 ,  ');
                if @@vhvu > samax or @@vhvu < samin;
                 if not Flota;
                  %subst(wrepl:1:4)   = %trim(%char(pePoco));
                  %subst(wrepl:5:20)  = %trim(@min);
                  %subst(wrepl:25:20) = %trim(@max);
                  SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : 'COW0137'
                               : peMsgs
                               : %trim(wrepl)
                               : %len(%trim(wrepl))  );
                  peErro = -1;
                  return;
                 endif;
                endif;
             endif;
          endif;
       endif;

       //Valido Suma Asegurada
       samax = COWVEH_getSumaMaxima();
       samin = COWVEH_getSumaMinima();

       @min  = %editw(samin:' .   .   .   . 0 ,  ');
       @max  = %editw(samax:' .   .   .   . 0 ,  ');

       if peVhvu > samax or peVhvu < samin;
        if not Flota;

         %subst(wrepl:1:4)   = %trim(%char(pePoco));
         %subst(wrepl:5:20)  = %trim(@min);
         %subst(wrepl:25:20) = %trim(@max);

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0137'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );


         peErro = -1;
         return;
        endif;
       endif;


       //Valido Marca de GNC
       if SVPVAL_marcaGnc( peMgnc )= *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_GNCNV = ErrCode;

           %subst(wrepl:1:1) = peMgnc;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0030'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;


       //Valido Suma GNC
       if peRgnc > 0;
        if not Flota;
         if SVPVAL_sumaGncWeb ( peRgnc )= *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_GNCFV = ErrCode;

             %subst(wrepl:1:15) = %editc( peRgnc : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0022'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

           endif;

           peErro = -1;
           return;
         endif;
        endif;
       endif;


       //Valido Código Postal
       if SVPVAL_codigoPostalWeb( peCopo :
                                  peCops )= *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_COPNE = ErrCode;

           %subst(wrepl:1:5) = %editc( peCopo : 'X' );
           %subst(wrepl:7:1) = %editc( peCops : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0014'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;


       //Valido Zona de Riesgo
       if SVPVAL_zonaDeRiego( peScta ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_ZONFV = ErrCode;

           %subst(wrepl:1:1) = %editc( peScta : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0023'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;


       //Valido cliente integral
       if SVPVAL_clienteIntegral ( peClin ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_CLIFV = ErrCode;

           %subst(wrepl:1:1) =  peClin;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0024'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Forma de Pago
       if SVPVAL_formaDePagoWeb ( peCfpg ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_FDPNW = ErrCode;

           %subst(wrepl:1:1) =  %editc ( peCfpg : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0026'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Persona
       if SVPVAL_tipoPersona ( peTipe ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_TPENV = ErrCode;

           %subst(wrepl:1:1) =  peTipe;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0015'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Persona
       if SVPVAL_ivaWeb ( peCiva ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_IVANE = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_IVANW = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         endif;

         peErro = -1;
         return;
       endif;

       //Valido condiciones comerciales (si hay cambio)
       @@dife = 0;
       @@xopr = 0;
       for x = 1 to 99;

         monitor;
           if peImpu(x).xrea <> 0;

             COWGRAI_GetCondComerciales (peBase:peNctw:peRama:p@xrea:p@xopr);

             @@dife = p@xrea - peImpu(x).xrea;
             @@xopr = p@xopr - @@dife;

             if @@xopr < 0 or @@dife > 15 or @@dife < -10;

               peErro = -1;
               return;

             endif;

           endif;

         on-error;

           return;

         endmon;

       endfor;

       // -----------------------------------------
       // Si es 0KM no puede tener Buen Resultado
       // -----------------------------------------
       @vhan = %xlate( min : may : peVhan );
       if @vhan = '0KM' and peBure <> 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0143'
                       : peMsgs    );
          peErro = -1;
          return;
       endif;

       // -----------------------------------------
       // Si es 0KM no puede haber usados, y si es
       // usado, no debe haber 0KM...
       // -----------------------------------------
       if @vhan = '0KM';
          k1wet0.t0empr = peBase.peEmpr;
          k1wet0.t0sucu = peBase.peSucu;
          k1wet0.t0nivt = peBase.peNivt;
          k1wet0.t0nivc = peBase.peNivc;
          k1wet0.t0nctw = peNctw;
          setll %kds(k1wet0:5) ctwet0;
          reade(n) %kds(k1wet0:5) ctwet0;
          dow not %eof;
              if t0poco <> pePoco;
                 if t0m0km = 'N';
                    SVPWS_getMsgs( '*LIBL'
                                 : 'WSVMSG'
                                 : 'COW0144'
                                 : peMsgs    );
                    peErro = -1;
                    return;
                 endif;
              endif;
           reade(n) %kds(k1wet0:5) ctwet0;
          enddo;
        else;
          k1wet0.t0empr = peBase.peEmpr;
          k1wet0.t0sucu = peBase.peSucu;
          k1wet0.t0nivt = peBase.peNivt;
          k1wet0.t0nivc = peBase.peNivc;
          k1wet0.t0nctw = peNctw;
          setll %kds(k1wet0:5) ctwet0;
          reade(n) %kds(k1wet0:5) ctwet0;
          dow not %eof;
              if t0poco <> pePoco;
                 if t0m0km = 'S';
                    SVPWS_getMsgs( '*LIBL'
                                 : 'WSVMSG'
                                 : 'COW0144'
                                 : peMsgs    );
                    peErro = -1;
                    return;
                 endif;
              endif;
           reade(n) %kds(k1wet0:5) ctwet0;
          enddo;
       endif;

       // -----------------------------------------
       // Validar si el artículo requiere Scoring
       // -----------------------------------------

       if not COWVEH_validaPreguntas( peBase
                                    : peNctw
                                    : peRama
                                    : peArse
                                    : pePoco
                                    : peTaaj
                                    : peScor
                                    : peErro
                                    : peMsgs );
         return;
       endif;

       return;

      /end-free

     P COWVEH_chkCotizar...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_setImportesVeh (): llama a los servicios necesarios   *
      *                           para actualizar los importes.      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Nro de Componente                  *
      *                                                              *
      *                                                              *
      *                                                              *
      * -------------------------------------------------------------*
     P COWVEH_setImportesVeh...
     P                 B                   export
     D COWVEH_setImportesVeh...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D
     D   k1yetc        ds                  likerec( c1wetc  : *key )
     D   totpri        s             15  2
     D   total         s             15  2
     D   p@Prim        S             15  2
     D   p@Prem        S             15  2
     D   p@Seri        S             15  2
     D   p@Seem        S             15  2
     D   p@Impi        S             15  2
     D   p@Sers        S             15  2
     D   p@Tssn        S             15  2
     D   p@Ipr1        S             15  2
     D   p@Ipr4        S             15  2
     D   p@Ipr3        S             15  2
     D   p@Ipr6        S             15  2
     D   p@Ipr7        S             15  2
     D   p@Ipr8        S             15  2
     D   p@Ipr9        S             15  2

      /free

       COWVEH_inz();

       //Recupero el monto de las primas e importes de impuestos
       COWVEH_sumSelecCobertura ( peBase :
                                  peNctw :
                                  peRama :
                                  peArse :
                                  pePoco :
                                  p@Prim :
                                  p@Prem :
                                  p@Seri :
                                  p@Seem :
                                  p@Impi :
                                  p@Sers :
                                  p@Tssn :
                                  p@Ipr1 :
                                  p@Ipr4 :
                                  p@Ipr3 :
                                  p@Ipr6 :
                                  p@Ipr7 :
                                  p@Ipr8 :
                                  p@Ipr9 );

       //Actualizo los montos de los importes
       COWGRAI_saveImportes ( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              pePoco :
                              p@Seri :
                              p@Seem :
                              p@Impi :
                              p@Sers :
                              p@Tssn :
                              p@Ipr1 :
                              p@Ipr4 :
                              p@Ipr3 :
                              p@Ipr6 :
                              p@Ipr7 :
                              p@Ipr8 :
                              p@Ipr9 );

       return;

      /end-free

     P COWVEH_setImportesVeh...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_setPrimasPorProvincias(): llama a los servicios para  *
      *                                  actualizar las primas por   *
      *                                  provincia.                  *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Nro de Componente                  *
      *                                                              *
      * -------------------------------------------------------------*
     P COWVEH_setPrimasPorProvincias...
     P                 B                   export
     D COWVEH_setPrimasPorProvincias...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePrim                      15  2 const
     D   pePrem                      15  2 const
     D   peIndo                       1    const

     D   k1yetc        ds                  likerec( c1wetc  : *key )
     D   k1yet0        ds                  likerec( c1wet0  : *key )

     D   p@Copo        S              5  0
     D   p@Cops        S              1  0
     D   p@Suas        S             15  2
     D   p@Sast        S             13  0
     D   p@Prem        S             15  2
     D   p@Prim        S             15  2

      /free

       COWVEH_inz();

       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.penivt;
       k1yet0.t0nivc = peBase.penivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0arse = peArse;
       k1yet0.t0poco = pePoco;

       chain(n) %kds ( k1yet0 : 8 ) ctwet0;

       if peIndo = 'S';

         COWGRAI_SavePrimasPorProvincia ( peBase :
                                          peNctw :
                                          peRama :
                                          peArse :
                                          pePoco :
                                          COWGRAI_GetCodProInd( t0copo:
                                                                t0cops ):
                                          t0vhvu :
                                          t0sast :
                                          pePrim :
                                          pePrem );

       elseif peIndo = 'D';

         COWGRAI_DeletePrimasPorProvincia ( peBase :
                                            peNctw :
                                            peRama :
                                            peArse :
                                            pePoco :
                                            COWGRAI_GetCodProInd( t0copo:
                                                                  t0cops ):
                                            t0vhvu :
                                            t0sast :
                                            pePrim :
                                            pePrem );

       endif;

       return;

      /end-free

     P COWVEH_setPrimasPorProvincias...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_sumSelecCobertura():  suma la prima de las coberturas *
      *                              que fueron seleccionadas.       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Nro de Componente                  *
      *        Output:                                               *
      *                pePrim  -  monto Prima                        *
      *                pePrem  -  monto Premio                       *
      *                peSeri  -  sellado riesgo                     *
      *                peSeem  -  sellado de la empresa              *
      *                peImpi  -  impuestos internos                 *
      *                peSers  -  servicios sociales                 *
      *                peTssn  -  tasa super. seg. nacion.           *
      *                peIpr1  -  impuesto valor agregado            *
      *                peIpr4  -  iva-resp.no inscripto              *
      *                peIpr3  -  iva-importe percepcion             *
      *                peIpr6  -  componente premio 6                *
      *                peIpr7  -  componente premio 7                *
      *                peIpr8  -  componente del premio 8            *
      *                peIpr9  -  componente del premio 9            *
      *                                                              *
      *                                                              *
      *                                                              *
      * -------------------------------------------------------------*
     P COWVEH_sumSelecCobertura...
     P                 B                   export
     D COWVEH_sumSelecCobertura...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peSeri                      15  2
     D   peSeem                      15  2
     D   peImpi                      15  2
     D   peSers                      15  2
     D   peTssn                      15  2
     D   peIpr1                      15  2
     D   peIpr4                      15  2
     D   peIpr3                      15  2
     D   peIpr6                      15  2
     D   peIpr7                      15  2
     D   peIpr8                      15  2
     D   peIpr9                      15  2

     D   k1yetc        ds                  likerec( c1wetc  : *key )
     D   totpri        s             15  2
     D   total         s             15  2

      /free

       COWVEH_inz();

       k1yetc.t0empr = peBase.peEmpr;
       k1yetc.t0sucu = peBase.peSucu;
       k1yetc.t0nivt = peBase.penivt;
       k1yetc.t0nivc = peBase.penivc;
       k1yetc.t0nctw = peNctw;
       k1yetc.t0rama = peRama;
       k1yetc.t0arse = peArse;
       k1yetc.t0poco = pePoco;

       chain %kds ( k1yetc : 8 ) ctwetc01;
       if %found();

         pePrim = t0prim;
         pePrem = t0prem;
         peSeri = t0seri;
         peSeem = t0seem;
         peImpi = t0impi;
         peSers = t0sers;
         peTssn = t0tssn;
         peIpr1 = t0ipr1;
         peIpr4 = t0ipr4;
         peIpr3 = t0ipr3;
         peIpr6 = t0ipr6;
         peIpr7 = t0ipr7;
         peIpr8 = t0ipr8;
         peIpr9 = t0ipr9;

       endif;

       return;

      /end-free

     P COWVEH_sumSelecCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_updprimasCob  (): Actualiza el valor de la prima y el *
      *                          premio por componente y cobertura   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Número de Componente               *
      *                peCobl  -  Letra de Cobertura                 *
      *                pePrim  -  Monto Prima                        *
      *                pePrem  -  Monto Premio                       *
      *                peSeri  -  sellado riesgo                      *
      *                peSeem  -  sellado de la empresa               *
      *                peImpi  -  impuestos internos                  *
      *                peSers  -  servicios sociales                  *
      *                peTssn  -  tasa super. seg. nacion.            *
      *                peIpr1  -  impuesto valor agregado             *
      *                peIpr4  -  iva-resp.no inscripto               *
      *                peIpr3  -  iva-importe percepcion              *
      *                peIpr6  -  componente premio 6                 *
      *                peIpr7  -  componente premio 7                 *
      *                peIpr8  -  componente del premio 8             *
      *                peIpr9  -  componente del premio 9             *
      *                                                              *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_updprimasCob...
     P                 B                   export
     D COWVEH_updprimasCob...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const
     D   pePrim                      15  2 const
     D   pePrem                      15  2 const
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

     D   k1yetc        ds                  likerec( c1wetc  : *key )
     D   totpri        s             15  2
     D   total         s             15  2

      /free

       COWVEH_inz();

       k1yetc.t0empr = peBase.peEmpr;
       k1yetc.t0sucu = peBase.peSucu;
       k1yetc.t0nivt = peBase.penivt;
       k1yetc.t0nivc = peBase.penivc;
       k1yetc.t0nctw = peNctw;
       k1yetc.t0rama = peRama;
       k1yetc.t0arse = peArse;
       k1yetc.t0poco = pePoco;
       k1yetc.t0cobl = peCobl;

       chain %kds ( k1yetc : 9 ) ctwetc;
       if %found();

         t0prim = pePrim;
         t0prem = pePrem;
         t0Seri = peSeri;
         t0Seem = peSeem;
         t0Impi = peImpi;
         t0Sers = peSers;
         t0Tssn = peTssn;
         t0Ipr1 = peIpr1;
         t0Ipr4 = peIpr4;
         t0Ipr3 = peIpr3;
         t0Ipr6 = peIpr6;
         t0Ipr7 = peIpr7;
         t0Ipr8 = peIpr8;
         t0Ipr9 = peIpr9;
         update c1wetc;

       endif;

       return;

      /end-free

     P COWVEH_updprimasCob...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_getSumaSiniestrablePoco()devuelve la suma siniestrable*
      *                                 por componente               *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Número de Componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_getSumaSiniestrablePoco...
     P                 B                   export
     D COWVEH_getSumaSiniestrablePoco...
     D                 pi            13  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   @@vhvu        s             15  2

     D   k1y000        ds                  likerec( c1w000  : *key )
     D   k1yet0        ds                  likerec( c1wet0  : *key )
     D   k1yed0        ds                  likerec( p1hed003 : *key )
     D   k1yeh0        ds                  likerec( p1het0 : *key )

      /free

       COWVEH_inz();

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain %kds( k1y000 : 5 ) ctw000;
       // Obtengo Cabecera de Componente
       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.peNivt;
       k1yet0.t0nivc = peBase.peNivc;
       k1yet0.t0nctw = peNctw;
       k1yet0.t0rama = peRama;
       k1yet0.t0poco = pePoco;

       chain %kds( k1yet0 : 7 ) ctwet0;

       select;
         when ( w0tiou = 1 );
           return t0vhvu;
         when ( w0tiou = 2 );
           return t0vhvu;
         when ( w0tiou = 3 );
           @@vhvu = t0vhvu;
           // Obtengo Suma de Endoso Anterior
           k1yed0.d0empr = peBase.peEmpr;
           k1yed0.d0sucu = peBase.peSucu;
           k1yed0.d0arcd = w0arcd;
           k1yed0.d0spol = w0spo1;
           k1yed0.d0rama = t0rama;
           k1yed0.d0arse = t0arse;

           setgt %kds( k1yed0 : 6 ) pahed003;
           readpe %kds( k1yed0 : 6 ) pahed003;
           dow not %eof ( pahed003 );

             // Tomo el Endoso que Corresponde
             if ( d0tiou = 1 or d0tiou = 2 or d0tiou = 3 ) and
                ( d0stos <> 08 and d0stos <> 09 );

               // Voy al PAHET0
               k1yeh0.t0empr = d0empr;
               k1yeh0.t0sucu = d0sucu;
               k1yeh0.t0arcd = d0arcd;
               k1yeh0.t0spol = d0spol;
               k1yeh0.t0sspo = d0sspo;
               k1yeh0.t0rama = d0rama;
               k1yeh0.t0arse = d0arse;
               k1yeh0.t0oper = d0oper;
               k1yeh0.t0poco = pePoco;
               chain %kds( k1yeh0 : 9 ) pahet0;

               // el primero es el actual menos el anterior
               return @@vhvu - t0vhvu;

             endif;

             readpe %kds( k1yed0 : 6 ) pahed003;

           enddo;

       endsl;

       return *Zeros;

      /end-free

     P COWVEH_getSumaSiniestrablePoco...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_chkAccesorios():Validar que la suma de accesorios no su-  *
      *                        pere el %maximo permitido                 *
      *        Input :                                                   *
      *                                                                  *
      *                peCobl  -  Cobertura                              *
      *                peVhan  -  Año del Vehículo                       *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_chkAccesorios...
     P                 B
     D COWVEH_chkAccesorios...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const
     D   peSuma                      15  2 const

     D k1y2253         ds                  likerec(s1t2253:*key)
     D k1y22531        ds                  likerec(s1t22531:*key)
     D difanio         s              2  0
     D p@Tiou          s              1  0
     D p@Stou          s              2  0
     D p@Stos          s              2  0
     D sumacc          s             15  2

      /free

       COWVEH_inz();

       clear s1t22531;

       sumacc = COWGRAI_sumaDeAccesorios ( peBase :
                                           peNctw :
                                           peRama :
                                           peArse :
                                           pePoco );

       COWGRAI_getTipodeOperacion( peBase :
                                   peNctw :
                                   p@Tiou :
                                   p@Stou :
                                   p@Stos );

       k1y2253.t@cobl = peCobl;

       setll %kds ( k1y2253 : 1 ) set225303;
       if %equal();
         read set225303;

         k1y22531.t1cobl = peCobl;
         k1y22531.t1nres = t@nres;
         k1y22531.t1Tiou = p@Tiou;
         k1y22531.t1Stou = p@Stou;
         k1y22531.t1Stos = p@Stos;

         //valido que la suma de accesorios no supere el porcentaje permitido

         chain %kds ( k1y22531 : 5 ) set22531;
         if %found;

          if sumacc > (peSuma * t1pacc/100) ;

            return *off;

          endif;

         endif;

       endif;

       return *on;

      /end-free

     P COWVEH_chkAccesorios...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWVEH_inz      B
     D COWVEH_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(ctw000);
         open ctw000;
       endif;

       if not %open(ctwet0);
         open ctwet0;
       endif;

       if not %open(ctwet1);
         open ctwet1;
       endif;

       if not %open(ctwet4);
         open ctwet4;
       endif;

       if not %open(ctwetc);
         open ctwetc;
       endif;

       if not %open(ctwetc01);
         open ctwetc01;
       endif;

       if not %open(tab009);
         open tab009;
       endif;

       if not %open(set1031);
         open set1031;
       endif;

       if not %open(set250);
         open set250;
       endif;

       if not %open(set210);
         open set210;
       endif;

       if not %open(set160);
         open set160;
       endif;

       if not %open(settar);
         open settar;
       endif;

       if not %open(set204);
         open set204;
       endif;

       if not %open(set227);
         open set227;
       endif;

       if not %open(set625);
         open set625;
       endif;

       if not %open(gntloc);
         open gntloc;
       endif;

       if not %open(set015);
         open set015;
       endif;

       if not %open(set01601);
         open set01601;
       endif;

       if not %open(set124);
         open set124;
       endif;

       if not %open(set225);
         open set225;
       endif;

       if not %open(set220);
         open set220;
       endif;

       if not %open(set2221);
         open set2221;
       endif;

       if not %open(set22223);
         open set22223;
       endif;

       if not %open(set22531);
         open set22531;
       endif;

       if not %open(set225303);
         open set225303;
       endif;

       if not %open(setbre);
         open setbre;
       endif;

       if not %open(set215);
         open set215;
       endif;

       if not %open(set621);
         open set621;
       endif;

       if not %open(pahed003);
         open pahed003;
       endif;

       if not %open(pahet0);
         open pahet0;
       endif;

       if not %open(set200);
         open set200;
       endif;

       if not %open(set2071);
         open set2071;
       endif;

       if not %open(set017);
         open set017;
       endif;

       if not %open(set018);
         open set018;
       endif;

       if not %open(set246);
         open set246;
       endif;

       if not %open(ctwet001);
         open ctwet001;
       endif;

       if not %open(setpat01);
         open setpat01;
       endif;

       if not %open(pahec0);
         open pahec0;
       endif;

       if not %open(pahec1);
         open pahec1;
       endif;

       if not %open(pahec3);
         open pahec3;
       endif;

       if not %open(gnhdtc);
         open gnhdtc;
       endif;

       if not %open(ctw00003);
         open ctw00003;
       endif;

       if not %open(sehase);
         open sehase;
       endif;

       if not %open(ctwet3);
          open ctwet3;
       endif;

       if not %open(ctwet301);
          open ctwet301;
       endif;

       if not %open(set2202);
          open set2202;
       endif;

       if not %open(set2272);
          open set2272;
       endif;

       if not %open(ctwet5);
         open ctwet5;
       endif;

       initialized = *ON;
       return;

      /end-free

     P COWVEH_inz      E

      * ------------------------------------------------------------ *
      * COWVEH_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWVEH_End      B                   export
     D COWVEH_End      pi

      /free

       close(E) *all;
       initialized = *OFF;

       return;

      /end-free

     P COWVEH_End      E

      * ------------------------------------------------------------ *
      * COWVEH_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWVEH_Error    B
     D COWVEH_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P COWVEH_Error    E

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
      * COWVEH_saveAccesorios(): Salvar accesorios de un vehículo.   *
      *                                                              *
      *        peBase  (input)  Parámetro Base                       *
      *        peNctw  (input)  Número de Cotización                 *
      *        peRama  (input)  Rama                                 *
      *        peArse  (input)  Secuencia de Rama en Artículo        *
      *        pePoco  (input)  Número de Componente                 *
      *        peAcce  (input)  Lista de Accesorios                  *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWVEH_saveAccesorios...
     P                 B                   Export
     D COWVEH_saveAccesorios...
     D                 pi             1n
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  pePoco                        4  0 const
     D  peAcce                             likeds(AccVeh_t) dim(100) const

     D k1wet1          ds                  likerec(c1wet1:*key)
     D x               s             10i 0

      /free

       COWVEH_inz();

       COWGRAI_deleteAccesorios( peBase : peNctw : peRama : peArse : pePoco );

       for x = 1 to 100;
           if peAcce(x).secu <= 0;
              leave;
           endif;

           k1wet1.t1empr = peBase.PeEmpr;
           k1wet1.t1sucu = peBase.PeSucu;
           k1wet1.t1nivt = peBase.PeNivt;
           k1wet1.t1nivc = peBase.PeNivc;
           k1wet1.t1nctw = peNctw;
           k1wet1.t1rama = peRama;
           k1wet1.t1arse = peArse;
           k1wet1.t1poco = pePoco;
           k1wet1.t1secu = peAcce(x).secu;
           setll %kds(k1wet1:9) ctwet1;
           if not %equal;
              t1empr = peBase.peEmpr;
              t1sucu = peBase.peSucu;
              t1nivt = peBase.peNivt;
              t1nivc = peBase.peNivc;
              t1nctw = peNctw;
              t1rama = peRama;
              t1arse = peArse;
              t1poco = pePoco;
              t1secu = peAcce(x).secu;
              t1accd = peAcce(x).accd;
              t1accv = peAcce(x).accv;
              t1mar1 = peAcce(x).mar1;
              t1ma01 = '0';
              t1ma02 = '0';
              t1ma03 = '0';
              t1ma04 = '0';
              t1ma05 = '0';
              write c1wet1;
           endif;
       endfor;

       return *on;

      /end-free

     P COWVEH_saveAccesorios...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_setCoberturaPorDefecto(): selecciona cobertura por        *
      *                                  defecto                         *
      *                                                                  *
      *        Input :                                                   *
      *                peBase  -  Parametros Base                        *
      *                peNctw  -  Nro. Cotizacion                        *
      *                peArcd  -  Artículo                               *
      *                peRama  -  Coberturas                             *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro de Componente                      *
      *                peCcob  -  Cantidad de Coberturas                 *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     P COWVEH_setCoberturaPorDefecto...
     P                 B                   Export
     D COWVEH_setCoberturaPorDefecto...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peArcd                       6  0  const
     D   peRama                       2  0  const
     D   peArse                       2  0  const
     D   pePoco                       4  0  const
     D   peCcob                       2  0  const
     D   pePaxc                            likeds(cobVeh) dim(20)

     D x               s             10i 0
     D @@spo1          s              9  0 inz
     D @@CobReno       s              2    inz
     D @@CobDefa       s              2    inz
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0
     D tiene           s               n

     D z               s             10i 0
     D i               s             10i 0
     D idx             s             17a   dim(%elem(pePaxc))
     D idxd            s             17a   dim(%elem(pePaxc))
     D ifra            s             15  0

      /free

       COWVEH_inz();

       COWGRAI_gettipoDeOperacion( peBase
                                 : peNctw
                                 : @@tiou
                                 : @@stou
                                 : @@stos);

       // -----------------------------------------
       // Cobertura por Defecto:
       // Ya no se usa la marca de cobertura por
       // defecto si no que para determinarlo, se
       // usa la siguiente lógica (Beraldi):
       //
       //  - Póliza Nueva: La mayor cotizada
       //  - Renovación: La que tenía, y si ya no
       //                es válida, usar lógica de
       //                Nueva
       //
       // Aclaración Cobertura D: Ante más de una
       //       Cobertura D permitida, se da aquella
       //       que tenga la franquicia MAYOR
       //
       // -----------------------------------------
       i = 0;
       z = 0;
       idx(*)  = *blanks;
       idxd(*) = *blanks;

       for x = 1 to peCcob;
           if pePaxc(x).cobl <> 'XX' and pePaxc(x).cobl <> *blanks;
              ifra = pePaxc(x).ifra * 100;
              if %subst(pePaxc(x).cobl:1:1) = 'D';
                 z += 1;
                 idxd(z) = %editc(ifra:'X') + pePaxc(x).cobl;
               else;
                 i += 1;
                 idx(i) = %editc(ifra:'X') + pePaxc(x).cobl;
              endif;
           endif;
       endfor;

       sorta(d) idx;
       sorta(d) idxd;

       // ---------------------------------------------
       // Si hay cobertura D, entonces vemos la de mayor
       // franquicia.
       // Si no, tomo la mayor de las demas
       // ---------------------------------------------
       if z > 0;
          @@CobDefa = %subst(idxd(1):16:2);
        else;
          @@CobDefa = %subst(idx(1):16:2);
       endif;

       if @@tiou = 2;
         @@spo1 = COWGRAI_getSuperPolizaReno( peBase
                                            : peNctw );

         @@CobReno = SPVVEH_getCobertura ( peBase.peEmpr
                                         : peBase.peSucu
                                         : peArcd
                                         : @@spo1
                                         : pePoco );
         tiene = *off;
         for x = 1 to peccob;
           if @@CobReno = pePaxc(x).cobl;
             pePaxc(x).cdft = 'S';
             tiene = *on;
           else;
             pePaxc(x).cdft = 'N';
           endif;
         endfor;

         if tiene = *on;
           return *on;
         endif;
       endif;

       for x = 1 to peccob;
          if @@CobDefa = 'XX' and X = 1;
             pePaxc(x).cdft = 'S';
          else;
             if @@CobDefa = pePaxc(x).cobl;
               pePaxc(x).cdft = 'S';
             else;
               pePaxc(x).cdft = 'N';
             endif;
          endif;

       endfor;

       COWVEH_chkCoberturaPorDefault(pePaxc);

       return *on;

      /end-free

     P COWVEH_setCoberturaPorDefecto...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_getCaracteristicas() : Retorna caracteristicas de una     *
      *                               cotización, se puede filtrar por   *
      *                               peRama, peArse, pePoco, peCobl y   *
      *                               peCcbp.                            *
      *                                                                  *
      *     peBase  (input)   Base                                       *
      *     peNctw  (input)   Nro. Cotización                            *
      *     peDsCt4 (output)  Registro con Ctwte4                        *
      *                                                                  *
      * Retorna *on/*off                                                 *
      * ---------------------------------------------------------------- *
     P COWVEH_getCaracteristicas...
     P                 B                   Export
     D COWVEH_getCaracteristicas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 options(*nopass:*omit)
     D   peArse                       2  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)
     D   peCobl                       2    options(*nopass:*omit)
     D   peCcbp                       3  0 options(*nopass:*omit)
     D   peDsCt4                           likeds(dsCarac_t)
     D                                     options(*nopass:*omit) dim(999)
     D   peDsCt4C                    10i 0 options(*nopass:*omit)
      *
     D   k1yCar        ds                  likerec(c1wet4:*key)
     D   dsECar        ds                  likerec(c1wet4:*input)
      *
     D   @@DsCt4       ds                  likeds(dsCarac_t) dim(999)
     D   @@DsCt4C      s             10i 0
     D   encontro      s              1n
     D   clave         s             10i 0 inz
      *
      /Free

        COWVEH_inz();

        clear @@DsCt4;

        k1yCar.t4Empr = peBase.peEmpr;
        k1yCar.t4Sucu = peBase.peSucu;
        k1yCar.t4Nivt = pebase.peNivt;
        k1yCar.t4Nivc = peBase.peNivc;
        k1yCar.t4Nctw = peNctw;

        encontro = *on;

        if %parms >= 3 and %addr( peRama ) <> *null and encontro;
          k1yCar.t4Rama = peRama;
          clave = 3;
        else;
          encontro = *off;
        endif;

        if %parms >= 4 and %addr( peArse ) <> *null and encontro;
          k1yCar.t4Arse = peArse;
          clave = 4;
        else;
          encontro = *off;
        endif;

        if %parms >= 5 and %addr( pePoco ) <> *null and encontro;
          k1yCar.t4poco = pePoco;
          clave = 5;
        else;
          encontro = *off;
        endif;

        if %parms >= 6 and %addr( peCobl ) <> *null and encontro;
          k1yCar.t4Cobl = peCobl;
          clave = 6;
        else;
          encontro = *off;
        endif;

        if %parms >= 7 and %addr( peCcbp ) <> *null and encontro;
          k1yCar.t4Ccbp = peCcbp;
          clave = 7;
        else;
          encontro = *off;
        endif;

        Select;
          when clave = 3;
            setll %kds(k1yCar:6) Ctwet4;
            reade %kds(k1yCar:6) Ctwet4 dsECar;

          When clave = 4;
            setll %kds(k1yCar:7) Ctwet4;
            reade %kds(k1yCar:7) Ctwet4 dsECar;

          When clave = 5;
            setll %kds(k1yCar:8) Ctwet4;
            reade %kds(k1yCar:8) Ctwet4 dsECar;

          When clave = 6;
            setll %kds(k1yCar:9) Ctwet4;
            reade %kds(k1yCar:9) Ctwet4 dsECar;

          When clave = 7;
            setll %kds(k1yCar:10) Ctwet4;
            reade %kds(k1yCar:10) Ctwet4 dsECar;
        endsl;

        if %eof ( Ctwet4 );
          return *off;
        endif;

        dow not %eof ( Ctwet4 );

          @@DsCt4C += 1;
          @@DsCt4(@@DsCt4C) = dsECar;

          if @@DsCt4C = 999;
             return  *on;
          endif;

          Select;
            when clave = 3;
              reade %kds(k1yCar:6) Ctwet4 dsECar;
            When clave = 4;
              reade %kds(k1yCar:7) Ctwet4 dsECar;
            When clave = 5;
              reade %kds(k1yCar:8) Ctwet4 dsECar;
            When clave = 6;
              reade %kds(k1yCar:9) Ctwet4 dsECar;
            When clave = 7;
              reade %kds(k1yCar:10) Ctwet4 dsECar;
          endsl;
        enddo;

          if %parms >= 8 and %addr( peDsCt4 ) <> *null;
            peDsCt4 = @@DsCt4;
          endif;

          if %parms >= 9 and %addr( peDsCt4C ) <> *null;
            peDsCt4C = @@DsCt4C;
          endif;

        return *on;

      /end-free

     P COWVEH_getCaracteristicas...
     P                 E

      * -------------------------------------------------------------*
      * COWVEH_getListaBuenResultado: Retorna Lista cod. de Buen     *
      *                               Resultado, también valida      *
      *                               si el productor tiene          *
      *                               tratamiento especial, contiene *
      *                               marca de Habilitar o no mostrar*
      *                               la misma.-                     *
      *                                                              *
      *          peBase   (input)   Parámetros Base                  *
      *          peNctw   (input)   Número de Cotizacion             *
      *          peBure   (input)   Años de Buen Resultado           *
      *          peLbure  (output)  Lista de Cod. de buen resultado  *
      *          peLbureC (output)  Cantidad                         *
      *          peHabi   (output)  Habilita / No Habilita           *
      *          peErro   (output)  Error                            *
      *          peMsgs   (output)  Mensaje de Error                 *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_getListaBuenResultado...
     P                 B                   Export
     D COWVEH_getListaBuenResultado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peBure                       1  0 const
     D   peLbure                           likeds(dsBure_t) dim(99)
     D   peLbureC                    10i 0
     D   peHabi                       1
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0

      /free

       COWVEH_inz();

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
           %subst(wrepl:8:1) = %char(peBase.peNivt);
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

       clear peLbure;
       clear peLbureC;
       peHabi = 'S';
       COWGRAI_getTipoDeOperacion ( peBase
                                  : peNctw
                                  : @@tiou
                                  : @@stou
                                  : @@stos );
       if @@tiou = 1;
          if not SVPBUE_chkProductorEspecial(PeBase.peEmpr
                                            :PeBase.peSucu
                                            :PeBase.peNivt
                                            :PeBase.peNivc );

            peHabi = 'N';
          endif;
       endif;

       if not SVPBUE_getListaBuenResultado( peBure
                                          : peLbure
                                          : peLbureC );
       // enviar error
       return *off;
       endif;

       return *on;
      /end-free

     P COWVEH_getListaBuenResultado...
     P                 E
      * -------------------------------------------------------------*
      * COWVEH_updInspeccionReno: Actualiza Requiere Inspeccion,     *
      *                           por cambio de cobertura para una   *
      *                           Renovacion.-                       *
      *                                                              *
      *          peBase   ( input  )  Parámetros Base                *
      *          peNctw   ( input  )  Número de Cotizacion           *
      *          peRama   ( input  )  Rama                           *
      *          peArse   ( input  )  Cant. Pólizas por Rama         *
      *          pePoco   ( input  )  Nro. de Componente             *
      *          pePaxc   ( output )  Coberturas Prima a Premio      *
      *                                                              *
      * Retorna *on = Actualizo / *off = No actualizo                *
      * -------------------------------------------------------------*
     P COWVEH_updInspeccionReno...
     P                 B                   Export
     D COWVEH_updInspeccionReno...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePaxc                            likeds(cobVeh) dim(20)

     D   @@spo1        s              9  0
     D   @@CobReno     s              2    inz
     D   x             s             10i 0
     D   y             s             10i 0
     D   @@lcobl       s              2    dim( 20 )
     D   @@lcoblC      s             10i 0
     D   @@arcd        s              6  0

     D k1yetc          ds                  likerec( c1wetc : *key )
      /free
       @@arcd = COWGRAI_getArticulo ( peBase :
                                     peNctw );


       clear @@spo1;
       @@spo1 = COWGRAI_getSuperPolizaReno( peBase
                                          : peNctw );

       @@CobReno = SPVVEH_getCobertura( peBase.peEmpr
                                      : peBase.peSucu
                                      : @@arcd
                                      : @@spo1
                                      : pePoco         );

       clear @@lcobl;
       clear @@lcoblC;

       if SVPREN_getListaCobMayorVeh ( peBase.PeEmpr
                                     : peBase.peSucu
                                     : @@arcd
                                     : 1
                                     : peRama
                                     : @@CobReno
                                     : @@lcobl
                                     : @@lcoblC        );
         for x = 1 to 20;
           if pePaxc(x).cobl <> *blanks;
             if %lookup( pePaxc(x).cobl : @@lcobl ) > *zeros;
               pePaxc(x).insp = 'S';

               k1yetc.t0empr = peBase.PeEmpr;
               k1yetc.t0sucu = peBase.PeSucu;
               k1yetc.t0nivt = peBase.peNivt;
               k1yetc.t0nivc = peBase.Penivc;
               k1yetc.t0nctw = peNctw;
               k1yetc.t0rama = peRama;
               k1yetc.t0arse = peArse;
               k1yetc.t0poco = pePoco;
               k1yetc.t0cobl = pePaxc(x).cobl;
               chain %kds( k1yetc : 9 ) ctwetc;
               if %found( ctwetc );
                 t0rins = 'S';
                 update c1wetc;
               endif;
             endif;
           endif;
         endfor;
       endif;

       return *on;

      /end-free
     P COWVEH_updInspeccionReno...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_setRecargoComercial: Graba Recargo Comercial de Autos *
      *                                                              *
      *          peBase   ( input  ) Base                            *
      *          peNctw   ( input  ) Número de Cotización            *
      *          peRama   ( input  ) Rama                            *
      *          peArse   ( input  ) Cant. Pólizas por Rama          *
      *          pePoco   ( input  ) Nro. de Componente              *
      *          peCobl   ( input  ) Letra Cobertura                 *
      *          peCcbp   ( input  ) Codigo de Recargo               *
      *          pePcbp   ( input  ) % de Recargo                    *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P COWVEH_setRecargoComercial...
     P                 b                   export
     D COWVEH_setRecargoComercial...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const
     D   peCcbp                       3  0 const
     D   pePcbp                       5  2 const

     D   k1yet4        ds                  likerec( c1wet4  : *key )

      /free
       COWVEH_inz();

       k1yet4.t4empr = PeBase.peEmpr;
       k1yet4.t4sucu = PeBase.peSucu;
       k1yet4.t4nivt = PeBase.peNivt;
       k1yet4.t4nivc = PeBase.peNivc;
       k1yet4.t4nctw = peNctw;
       k1yet4.t4rama = peRama;
       k1yet4.t4poco = pePoco;
       k1yet4.t4arse = peArse;
       k1yet4.t4cobl = peCobl;
       k1yet4.t4ccbp = peCcbp;
       setll %kds( k1yet4 : 10 ) ctwet4;
       if %equal( ctwet4 );
         return *off;
       endif;

       t4ccbp = peCcbp;
       t4pcbp = pePcbp * -1;
       write c1wet4;

       return *on;

      /end-free
     P COWVEH_setRecargoComercial...
     P                 e

      * ------------------------------------------------------------ *
      * addRecCobA(): Verifica si debe o no agregar recargo 17% para *
      *               Cobertura A.                                   *
      *                                                              *
      *   Usado por COWVEH_saveDescuentos y COWVEH_saveDescuentosRec *
      *                                                              *
      * Como esto es a partir de tarifa 118, el valor por omisión es *
      * *ON para dar compatibilidad.                                 *
      *                                                              *
      * *ON = Debe agregar / *OFF = No debe agregar                  *
      * ------------------------------------------------------------ *

     P addRecCobA      B
     D addRecCobA      pi             1n

     D peVsys          s            512a
     D rc              s              1n

      /free

       rc = SVPVLS_getValSys( 'HADDREC17P'
                            : *omit
                            : peVsys       );

       // No existe valor de sistema, retorna *on
       if rc = *off;
          return *on;
       endif;

       if peVsys = 'N';
          return *off;
       endif;

       return *on;

      /end-free

     P addRecCobA      E

      * ------------------------------------------------------------ *
      * COWVEH_getSumaMinima(): Recupera suma asegurada mínima       *
      *                                                              *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: Importe de Suma Mínima (puede ser cero)             *
      * ------------------------------------------------------------ *
     P COWVEH_getSumaMinima...
     P                 B                   EXPORT
     D COWVEH_getSumaMinima...
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
     D k1t246          ds                  likerec(s1t246:*key)

      /free

       COWVEH_inz();

       if %parms >= 1 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smin = 0;

       setll *start set246;
       read set246;
       dow not %eof;

           if txfech <= @femi;
              @smin = txsmin;
           endif;

        read set246;
       enddo;

       return @smin;

      /end-free

     P COWVEH_getSumaMinima...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_getSumaMaxima(): Recupera suma asegurada máxima       *
      *                                                              *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: Importe de Suma Máxima (puede ser cero)             *
      * ------------------------------------------------------------ *
     P COWVEH_getSumaMaxima...
     P                 B                   EXPORT
     D COWVEH_getSumaMaxima...
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
     D k1t246          ds                  likerec(s1t246:*key)

      /free

       COWVEH_inz();

       if %parms >= 1 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smax = 999999999999,99;

       setll *start set246;
       read set246;
       dow not %eof;

           if txfech <= @femi;
              @smax = txsmax;
           endif;

        read set246;
       enddo;

       return @smax;

      /end-free

     P COWVEH_getSumaMaxima...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkSumaMinima(): Controla Suma aseg > a suma mínima   *
      *                                                              *
      *     peVhvu   (input)   Suma asegurada                        *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     P COWVEH_chkSumaMinima...
     P                 B                   export
     D COWVEH_chkSumaMinima...
     D                 pi             1N
     D   peVhvu                      15  2
     D   peFemi                       8  0 options(*nopass:*omit)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D @femi           s              8  0
     D @smin           s             15  2
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D empr            s              1a   inz('A')

      /free

       COWVEH_inz();

       if %parms >= 2 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smin = COWVEH_getSumaMinima( @femi );
       if peVhvu < @smin;
          SetError( SPVVEH_SUMIN
                  : 'Suma Aseg. Inferior a la mínima permitida' );
          return *OFF;
       endif;

       return *ON;

      /end-free

     P COWVEH_chkSumaMinima...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkSumaMaxima(): Controla Suma aseg > a suma mínima   *
      *                                                              *
      *     peVhvu   (input)   Suma asegurada                        *
      *     peFemi   (input)   Fecha a la cual controlar             *
      *                                                              *
      * Retorna: *ON OK, *OFF no OK                                  *
      * ------------------------------------------------------------ *
     P COWVEH_chkSumaMaxima...
     P                 B                   export
     D COWVEH_chkSumaMaxima...
     D                 pi             1N
     D   peVhvu                      15  2
     D   peFemi                       8  0 options(*nopass:*omit)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D @femi           s              8  0
     D @smax           s             15  2
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D empr            s              1a   inz('A')

      /free

       COWVEH_inz();

       if %parms >= 2 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          PAR310X3( empr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       @smax = COWVEH_getSumaMaxima( @femi );
       if peVhvu > @smax;
          SetError( SPVVEH_SUMAX
                  : 'Suma Aseg. Supera a la permitida' );
          return *OFF;
       endif;

       return *ON;

      /end-free

     P COWVEH_chkSumaMaxima...
     P                 E

      * ------------------------------------------------------------ *
      * getCeroKmsSegundoAÑo() devuelve si poliza a renovar aplica   *
      *                        para Cero Kms Segundo Año             *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Número de Componente               *
      *                                                              *
      *       Output :                                               *
      *            peDel0Km2a  -  Elimina dsctos 0Km segundo año     *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     P getCeroKmsSegundoAÑo...
     P                 B                   export
     D getCeroKmsSegundoAÑo...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     d   peDel0Km2a                        like(*in99)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D   peEmpr                       1a   const
     D   peFema                       4  0
     D   peFemm                       2  0
     D   peFemd                       2  0

     d pax011          pr                  ExtPgm('PAX011')
     d   peTipo                            const like(t0empr)
     d   peEmpr                            const like(t0empr)
     d   peSucu                            const like(t0sucu)
     d   peArcd                            const like(t0arcd)
     d   peSpol                            const like(t0spol)
     d   peSspo                            const like(t0sspo)
     d   peRama                            const like(t0rama)
     d   peArse                            const like(t0arse)
     d   peOper                            const like(t0oper)
     d   pePoco                            const like(t0poco)
     d   peNmat                            const like(t0nmat)
     d   peAInf                                  like(t0vhaÑ)
     d   pe0kms                                  like(*in99)
     d   peDel0Km2a                              like(*in99)

     D k1y000          ds                  likerec( c1w000  : *key )
     D k1yet0          ds                  likerec( c1wet0  : *key )
     D k1yed0          ds                  likerec( p1hed003 : *key )
     D k1yeh0          ds                  likerec( p1het0 : *key )
     D dsHet0Tmp       ds                  likerec( p1het0 : *input)

     D @@Fema          s              4  0
     D @@Femm          s              2  0
     D @@Femd          s              2  0
     D @@Femi          s              8  0

     d @@Tipo          s                   like(t0empr)
     d @@Empr          s                   like(t0empr)
     d @@Sucu          s                   like(t0sucu)
     d @@Arcd          s                   like(t0arcd)
     d @@Spol          s                   like(t0spol)
     d @@Sspo          s                   like(t0sspo)
     d @@Rama          s                   like(t0rama)
     d @@Arse          s                   like(t0arse)
     d @@Oper          s                   like(t0oper)
     d @@Poco          s                   like(t0poco)
     d @@Nmat          s                   like(t0nmat)

     d @@AInf          s                   like(t0vhaÑ)
     d @@0Kms          s                   like(*in99) inz(*off)
     d @@Del0Km2a      s                   like(*in99)

     d @@tiou          s              1  0 inz(*zeros)
     d @@stou          s              2  0 inz(*zeros)
     d @@stos          s              2  0 inz(*zeros)

      /free

        COWVEH_inz();

        @@Del0Km2a = *off;

        PAR310X3( peBase.peEmpr : @@Fema : @@Femm : @@Femd);
        @@Femi = (@@Fema * 10000) + (@@Femm * 100) + @@Femd;

        COWGRAI_getTipoDeOperacion(peBase : peNctw : @@tiou : @@stou : @@stos);

        if ( @@tiou = 2 );

          // Obtengo Suma de Endoso Anterior
          k1yed0.d0empr = peBase.peEmpr;
          k1yed0.d0sucu = peBase.peSucu;
          k1yed0.d0arcd = COWGRAI_getArticulo(peBase : peNctw);
          k1yed0.d0spol = COWGRAI_getSuperPolizaReno(peBase : peNctw);
          k1yed0.d0rama = peRama;
          k1yed0.d0arse = peArse;

          setgt %kds( k1yed0 : 6 ) pahed003;
          readpe %kds( k1yed0 : 6 ) pahed003;
          dow not %eof ( pahed003 );

            // Tomo el Endoso que Corresponde
            if ( d0tiou = 1 or d0tiou = 2 or d0tiou = 3 ) and
               ( d0stos <> 08 and d0stos <> 09 );

              // Voy al PAHET0
              k1yeh0.t0empr = d0empr;
              k1yeh0.t0sucu = d0sucu;
              k1yeh0.t0arcd = d0arcd;
              k1yeh0.t0spol = d0spol;
              k1yeh0.t0sspo = d0sspo;
              k1yeh0.t0rama = d0rama;
              k1yeh0.t0arse = d0arse;
              k1yeh0.t0oper = d0oper;
              k1yeh0.t0poco = pePoco;
              chain %kds( k1yeh0 : 9 ) pahet0 dsHet0Tmp;
              if %found(pahet0);

                @@Tipo = '2';
                @@Empr = dsHet0Tmp.t0empr;
                @@Sucu = dsHet0Tmp.t0sucu;
                @@Arcd = dsHet0Tmp.t0arcd;
                @@Spol = dsHet0Tmp.t0spol;
                @@Sspo = dsHet0Tmp.t0sspo;
                @@Rama = dsHet0Tmp.t0rama;
                @@Arse = dsHet0Tmp.t0arse;
                @@Oper = dsHet0Tmp.t0oper;
                @@Poco = dsHet0Tmp.t0poco;
                @@Nmat = dsHet0Tmp.t0nmat;

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

                peDel0Km2a = @@Del0Km2a;

                if @@Fema = @@AInf and @@0Kms;
                  return *on;
                else;
                  return *off;
                endif;

              endif;

            endif;

            readpe %kds( k1yed0 : 6 ) pahed003;

          enddo;

        endif;

        peDel0Km2a = @@Del0Km2a;
        return *off;

      /end-free

     P getCeroKmsSegundoAÑo...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_confirmarInspeccion(): Retorna si confirma inspeccion *
      *                                                              *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *        Input Opcionales :                                    *
      *                peRama  -  Rama                               *
      *                peArse  -  Arse                               *
      *                pePoco  -  Componente                         *
      *                                                              *
      * Retorna *On / *Off                                           *
      * -------------------------------------------------------------*
     P COWVEH_confirmarInspeccion...
     P                 b                   Export
     D COWVEH_confirmarInspeccion...
     D                 pi              n
     D   peBase                            Likeds( paramBase ) Const
     D   peNctw                       7  0 Const
     D   peRama                       2  0 Options( *Omit : *Nopass )
     D   peArse                       2  0 Options( *Omit : *Nopass )
     D   pePoco                       4  0 Options( *Omit : *Nopass )

     D @@rama          s              2  0
     D @@arse          s              2  0
     D @@poco          s              4  0
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0
     D @@vhan          s              4

     D k1yet0          ds                  likerec( c1wet001 : *Key )
     D k1yetc          ds                  likerec( c1wetc01 : *key )

     D @@msgs          ds                  likeds( paramMsgs )

       COWVEH_inz();

       //Valido ParmBase
       if not SVPWS_chkParmBase ( peBase : @@msgs );
         return *On;
       endif;

       //Valido Cotización
       if not COWGRAI_chkCotizacion ( peBase : peNctw );
         return *On;
       endif;

       COWGRAI_getTipoDeOperacion ( peBase : peNctw
                                  : @@tiou : @@stou : @@stos);

       k1yet0.t0empr = PeBase.peEmpr;
       k1yet0.t0sucu = PeBase.peSucu;
       k1yet0.t0nivt = PeBase.peNivt;
       k1yet0.t0nivc = PeBase.peNivc;
       k1yet0.t0nctw = PeNctw;

       select;
         when %parms >= 3 and %addr( peRama ) <> *Null
                          and %addr( peArse ) =  *Null
                          and %addr( pePoco ) =  *Null;
           k1yet0.t0rama = PeRama;
           setll    %kds( k1yet0 : 6 ) ctwet001;
           reade(n) %kds( k1yet0 : 6 ) ctwet001;

         when %parms >= 4 and %addr( peRama ) <> *Null
                          and %addr( peArse ) <> *Null
                          and %addr( pePoco ) =  *Null;
           k1yet0.t0rama = PeRama;
           k1yet0.t0arse = PeArse;
           setll    %kds( k1yet0 : 7 ) ctwet001;
           reade(n) %kds( k1yet0 : 7 ) ctwet001;

         when %parms >= 5 and %addr( peRama ) <> *Null
                          and %addr( peArse ) <> *Null
                          and %addr( pePoco ) <> *Null;
           k1yet0.t0rama = PeRama;
           k1yet0.t0arse = PeArse;
           k1yet0.t0arse = PePoco;
           setll    %kds( k1yet0 : 8 ) ctwet001;
           reade(n) %kds( k1yet0 : 8 ) ctwet001;

         other;
           setll    %kds( k1yet0 : 5 ) ctwet001;
           reade(n) %kds( k1yet0 : 5 ) ctwet001;

       endsl;

       dow not %eof( ctwet001 );
         k1yetc.t0empr = peBase.peEmpr;
         k1yetc.t0sucu = peBase.peSucu;
         k1yetc.t0nivt = peBase.peNivt;
         k1yetc.t0nivc = peBase.peNivc;
         k1yetc.t0nctw = peNctw;
         k1yetc.t0rama = t0rama;
         k1yetc.t0arse = t0arse;
         k1yetc.t0poco = t0poco;
         chain %kds( k1yetc : 8 ) ctwetc01;

         if ( %found ( ctwetc01 ) and ( t0rins = 'S' ) );
           if t0m0km = 'S';
             @@vhan = '0KM';
           else;
             @@vhan = %editC( t0vhan : 'X' );
           endif;
           if SPVVEH_confirmarInspeccion( t0cobl
                                        : @@vhan
                                        : @@tiou
                                        : @@stou
                                        : @@stos
                                        : t0scta );
             return *On;
           endif;
         endif;

         select;
           when %parms >= 3 and %addr( peRama ) <> *Null
                            and %addr( peArse ) =  *Null
                            and %addr( pePoco ) =  *Null;
             reade(n) %kds( k1yet0 : 6 ) ctwet001;

           when %parms >= 4 and %addr( peRama ) <> *Null
                            and %addr( peArse ) <> *Null
                            and %addr( pePoco ) =  *Null;

             reade(n) %kds( k1yet0 : 7 ) ctwet001;

           when %parms >= 5 and %addr( peRama ) <> *Null
                            and %addr( peArse ) <> *Null
                            and %addr( pePoco ) <> *Null;
             reade(n) %kds( k1yet0 : 8 ) ctwet001;

           other;
             reade(n) %kds( k1yet0 : 5 ) ctwet001;

         endsl;

       enddo;

       return *Off;

     P COWVEH_confirmarInspeccion...
     P                 e

      * ---------------------------------------------------------------- *
      * COWVEH_cotizarWeb2(): Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      * ********************** Deprecated ****************************** *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peNrpp  -  Plan de Pago                           *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de Iva                          *
      *                peAcce  -  Lista de Accesorios                    *
      *                peDesE  -  Descuento Especial                     *
      *        Output:                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  Bonificaciones por cobertura           *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_cotizarWeb2...
     P                 B                   export
     D COWVEH_cotizarWeb2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peNrpp                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peDesE                       5  2 const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0

     D @@Cfpg          s              1  0
     D @@Scor          ds                  likeds(preguntas_t) dim(200)

      /free

       COWVEH_inz();

       clear @@Scor;
       peErro = *Zeros;

       COWVEH_cotizarWeb3( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco
                         : peVhan
                         : peVhmc
                         : peVhmo
                         : peVhcs
                         : peVhvu
                         : peMgnc
                         : peRgnc
                         : peCopo
                         : peCops
                         : peScta
                         : peClin
                         : peBure
                         : peNrpp
                         : peTipe
                         : peCiva
                         : peAcce
                         : peDesE
                         : *zeros
                         : @@Scor
                         : peCtre
                         : pePaxc
                         : peBoni
                         : peImpu
                         : peErro
                         : peMsgs );

       return;

      /end-free

     P COWVEH_cotizarWeb2...
     P                 E
      * ---------------------------------------------------------------- *
      * COWVEH_reCotizarWeb2: Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      * ********************** Deprecated ****************************** *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peNrpp  -  Plan de Pago                           *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de Iva                          *
      *                peAcce  -  Lista de Accesorios                    *
      *                peDesE  -  Descuento Especial                     *
      *        Output:                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  Bonificaciones por cobertura           *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_reCotizarWeb2...
     P                 B                   export
     D COWVEH_reCotizarWeb2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peNrpp                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peAcce                            likeds( AccVeh_t ) dim(100) const
     D   peDesE                       5  2 const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh)  dim(20)
     D   peBoni                            likeds(bonVeh)  dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2

     D @@Cfpg          s              1  0
     D @@Scor          ds                  likeds(preguntas_t) dim(200)

      /free

       COWVEH_inz();

       clear @@Scor;
       peErro = *Zeros;

       COWVEH_recotizarWeb3( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : pePoco
                           : peVhan
                           : peVhmc
                           : peVhmo
                           : peVhcs
                           : peVhvu
                           : peMgnc
                           : peRgnc
                           : peCopo
                           : peCops
                           : peScta
                           : peClin
                           : peBure
                           : peNrpp
                           : peTipe
                           : peCiva
                           : peAcce
                           : peDesE
                           : *Zeros
                           : @@Scor
                           : peCtre
                           : pePaxc
                           : peBoni
                           : peImpu
                           : peErro
                           : peMsgs );

       return;

      /end-free

     P COWVEH_reCotizarWeb2...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkEndosoPoliza() Valida si poliza a modificar aplica *
      *                          para cambio de datos en vehiculo    *
      *                          Patente - Chasis - Motor            *
      * Input :                                                      *
      *         peBase          - Base                               *
      *         peUser          - Usuario                            *
      *         peArcd          - Codigo Articulo                    *
      *         peSpol          - Numero Superpoliza                 *
      *         peRama          - Codigo Rama                        *
      *         peArse          - Numero Polizas por Rama            *
      *         peOper          - Numero Operacion                   *
      *         pePoli          - Numero Poliza                      *
      *                                                              *
      * Output :                                                     *
      *         peError         - Indicador de Error                 *
      *         peMsgs          - Estructura de Error                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     p COWVEH_chkEndosoPoliza...
     p                 B                   export
     d COWVEH_chkEndosoPoliza...
     d                 pi              n
     d peBase                              likeds(paramBase)       const
     d peUser                        50                            const
     d peArcd                         6  0                         const
     d peSpol                         9  0                         const
     d peRama                         2  0                         const
     d peArse                         2  0                         const
     d peOper                         7  0                         const
     d pePoli                         7  0                         const
     d peError                       10i 0
     d peMsgs                              likeds(paramMsgs)

     d p@Erro          s              1n
     d p@Fema          s              4  0
     d p@Femd          s              2  0
     d p@Femm          s              2  0
     d p@Mens          s            512a

     d k1w00003        ds                  likerec(c1w00003:*key)

     d @@Iidx          s             10i 0
     d @@Femi          s              8  0
     d @@Repl          s          65535a

      /free

        COWVEH_inz();

        clear peMsgs;
        clear peError;

        PAR310X3( peBase.peEmpr : p@Fema : p@Femm : p@Femd);
        @@Femi = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;

        // Validar poliza vigente - SPVIG2
        if not SPVSPO_chkVig( peBase.peEmpr
                            : peBase.peSucu
                            : peArcd
                            : peSpol );

          clear @@Repl;
          %subst(@@Repl:1:6) = %char(peArcd);
          %subst(@@Repl:7:9) = %char(peSpol);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0016'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Validar si poliza tiene movimientos pendientes - PAR317V
        p@Erro = *off;
        clear p@Mens;
        PAR317V( peBase.peEmpr
               : peBase.peSucu
               : peArcd
               : peSpol
               : peRama
               : pePoli
               : p@Erro
               : p@Mens );
        if not p@Erro;

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0017'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Validar si poliza tiene movimientos pendientes en CTW00003
        k1w00003.w0arcd = peArcd;
        k1w00003.w0spol = peSpol;
        k1w00003.w0empr = peBase.peEmpr;
        k1w00003.w0sucu = peBase.peSucu;
        k1w00003.w0nivt = peBase.peNivt;
        k1w00003.w0nivc = peBase.peNivc;
        setgt %kds(k1w00003:6) ctw00003;
        readpe %kds(k1w00003:6) ctw00003;
        if not %eof( ctw00003 );
          if ( w0cest = 1 and w0cses  = 1 ) or
             ( w0cest = 1 and w0cses  = 2 ) or
             ( w0cest = 5 and w0cses  = 3 ) or
             ( w0cest = 5 and w0cses  = 4 ) or
             ( w0cest = 7 and w0cses  = 4 ) or
             ( w0cest = 7 and w0cses  = 5 );

            clear @@Repl;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0180'
                         : peMsgs
                         : %trim(@@Repl)
                         : %len(%trim(@@Repl)) );
            peError = -1;
            return *Off;

          endif;
        endif;

        //
        // Anulacion o Arrepentimiento pendientes
        //
        if SPVSPO_anulaArrepEnProceso( peBase.peEmpr
                                     : peBase.peSucu
                                     : peArcd
                                     : peSpol         );
          clear @@Repl;
          %subst(@@repl:01:07) = %trim(%char(pePoli));
          %subst(@@repl:08:10) = 'AUTOGEST.';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0018'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;
        endif;

        return *on;

      /end-free

     p COWVEH_chkEndosoPoliza...
     p                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkEndosoComponente() Valida si componente de la      *
      *                              poliza a modificar aplica para  *
      *                              endoso Patente - Chasis - Motor *
      * Input :                                                      *
      *         peBase          - Base                               *
      *         peUser          - Usuario                            *
      *         peArcd          - Codigo Articulo                    *
      *         peSpol          - Numero Superpoliza                 *
      *         peRama          - Codigo Rama                        *
      *         peArse          - Numero Polizas por Rama            *
      *         peOper          - Numero Operacion                   *
      *         pePoli          - Numero Poliza                      *
      *         pePoco          - Numero Componente                  *
      *         peNmat          - Patente                            *
      *         peChas          - Chasis                             *
      *         peMoto          - Motor                              *
      *         peSuas          - Importe Suma Asegurada             *
      *                                                              *
      * Output :                                                     *
      *         peChgV          - Cambio de Valores Componente       *
      *         peError         - Indicador de Error                 *
      *         peMsgs          - Estructura de Error                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     p COWVEH_chkEndosoComponente...
     p                 B                   export
     d COWVEH_chkEndosoComponente...
     d                 pi              n
     d peBase                              likeds(paramBase) const
     d peUser                        50                      const
     d peArcd                         6  0                   const
     d peSpol                         9  0                   const
     d peRama                         2  0                   const
     d peArse                         2  0                   const
     d peOper                         7  0                   const
     d pePoli                         7  0                   const
     d pePoco                         4  0                   const
     d peNmat                        25                      const
     d peChas                        25                      const
     d peMoto                        25                      const
     d peSuas                        15  2                   const
     d peChgV                          n
     d peError                       10i 0
     d peMsgs                              likeds(paramMsgs)

     d PAR310X3        pr                  extpgm('PAR310X3')
     d  peEmpr                        1a   const
     d  peFema                        4  0
     d  peFemm                        2  0
     d  peFemd                        2  0

     d SPVIG3          pr                  ExtPgm('SPVIG3')
     d  peArcd                        6  0 const
     d  peSpol                        9  0 const
     d  peRama                        2  0 const
     d  peArse                        2  0 const
     d  peOper                        7  0 const
     d  pePoco                        4  0 const
     d  peFvig                        8  0 const
     d  peFemi                        8  0 const
     d  peStat                        1n
     d  peSspo                        3  0
     d  peSuop                        3  0
     d  peFpgm                        3    const
     d  peSpvig2                      1n   options(*nopass) const

     d SP0082          pr                  EXTPGM('SP0082')
     d  peArcd                        6  0 const
     d  peSpol                        9  0 const
     d  peNmat                       25    const
     d  peFdes                        8  0 const
     d  peErr1                        1
     d  peErr2                        1
     d  peEmpr                        1    options(*nopass) const
     d  peSucu                        2    options(*nopass) const
     d  pePoco                        4  0 options(*nopass) const
     d  peArcd_Out                    6  0 options(*nopass)
     d  peSpol_Out                    7  0 options(*nopass)
     d  peRama_Out                    2  0 options(*nopass)
     d  pePoli_Out                    7  0 options(*nopass)
     d  pePoco_Out                    4  0 options(*nopass)
     d  peHast_Out                    8  0 options(*nopass)

     d p@Endp          s              3
     d p@Err1          s              1
     d p@Err2          s              1
     d p@Fema          s              4  0
     d p@Femd          s              2  0
     d p@Femm          s              2  0
     d p@Matc          ds                  likeds(regmatch_t)
     d p@Patt          s             25a   varying
     d p@Rtco          s              7a
     d p@Sspo          s              3  0
     d p@Stat          s              1n
     d p@ValPat        s              1n
     d p@Suop          s              3  0
     d p@Tmat          s              3a
     d p@Vald          s              1a

     d k1tpat          ds                  likerec(s1tpat:*key)

     d @@DsT0          ds                  likeds(dsPahet0_t)
     d @@DsT9          ds                  likeds(dsPahet9_t)
     d @@Femi          s              8  0
     d @@Repl          s          65535a

     d NUMER           c                   '0123456789                 '
     d UPPER           c                   'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ'
     d LOWER           c                   'abcdefghijklmnñopqrstuvwxyz'
     d BLANK           c                   '                           '

      /free

        COWVEH_inz();

        clear peMsgs;
        clear peError;

        PAR310X3( peBase.peEmpr : p@Fema : p@Femm : p@Femd);
        @@Femi = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;

        // Obtiene registro completo del componente - PAHET9
        if not SPVVEH_getPahet9( peBase.peEmpr
                               : peBase.peSucu
                               : peArcd
                               : peSpol
                               : peRama
                               : peArse
                               : pePoco
                               : @@DsT9 );

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'API0004'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Obtiene registro completo del componente - PAHET0
        p@Sspo = @@DsT9.t9sspo;
        if not SPVVEH_getPahet0( peBase.peEmpr
                               : peBase.peSucu
                               : peArcd
                               : peSpol
                               : peRama
                               : peArse
                               : pePoco
                               : p@Sspo
                               : @@DsT0 );

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'API0004'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Validar si vehiculo esta vigente - SPVIG3
        @@Femi = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;
        p@Stat = *Off;
        clear p@Sspo;
        clear p@Suop;
        clear p@Endp;
        SPVIG3( peArcd
              : peSpol
              : peRama
              : peArse
              : peOper
              : pePoco
              : @@Femi
              : @@Femi
              : p@Stat
              : p@Sspo
              : p@Suop
              : p@Endp
              : *off   );
        if not p@Stat;

          clear @@Repl;
          %subst(@@Repl:1:4) = %trim(%char(pePoco));
          %subst(@@Repl:5:25) = %trim(peNmat);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0181'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Patente declarada: Si patente = '-' ==> permite modificar
        p@Stat = *off;
        p@ValPat = *off;
        select;
        when %trim(peNmat) <> '-' and %trim(@@Dst9.t9nmat) = '-';
          p@ValPat = *on;

        when %trim(peNmat) = '-' and %trim(@@Dst9.t9nmat) <> '-';
          p@Stat = *on;

        when %trim(peNmat) <> '-' and %trim(@@Dst9.t9nmat) <> '-' and
           %trim(peNmat) <> %trim(@@Dst9.t9nmat);
          p@Stat = *on;

        endsl;
        if p@Stat;
          clear @@Repl;
          %subst(@@Repl:1:4) = %trim(%char(pePoco));
          %subst(@@Repl:5:25) = %trim(peNmat);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0182'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Validar formatos patente chasis motor
        // -------------------------------------

        // Busco máscara para la patente que llegó
        if p@ValPat = *on;

          clear p@Tmat;
          clear p@Vald;
          clear p@Rtco;
          SPFMTPAT( peBase.peEmpr
                  : peBase.peSucu
                  : peNmat
                  : %char(%date():*ymd)
                  : '2'
                  : 'A'
                  : p@Tmat
                  : p@Vald
                  : p@Rtco             );
          if %trim(p@Rtco) <> 'OK';

            clear @@Repl;
            @@Repl = %trim(%char(pePoco));
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0050'
                         : peMsgs
                         : %trim(@@Repl)
                         : %len(%trim(@@Repl))  );
            peError = -1;
            return *Off;

          endif;

          k1tpat.ptempr = peBase.peEmpr;
          k1tpat.ptsucu = peBase.peSucu;
          k1tpat.ptmcod = p@Tmat;
          chain %kds(k1tpat:3) setpat01;
          if %found(setpat01);

            if ptmbaj <> ' ' or ptmweb <> '1';

              clear @@Repl;
              @@Repl = %trim(%char(pePoco));
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0050'
                           : peMsgs
                           : %trim(@@Repl)
                           : %len(%trim(@@Repl))  );
              peError = -1;
              return *Off;

            endif;

          endif;

          // Valido Si la patente esta duplicada en GAUS
          if p@Vald = 'N';

            @@Femi = (p@Femd * 1000000)
                   + (p@Femm * 10000)
                   +  p@Fema;

            clear p@Err1;
            clear p@Err2;
            SP0082( *Zeros
                  : *Zeros
                  : peNmat
                  : @@Femi
                  : p@Err1
                  : p@Err2
                  : peBase.peEmpr
                  : peBase.peSucu
                  : pePoco );
            if p@Err1 <> *blanks or p@Err2 <> *blanks;

              clear @@Repl;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0042'
                           : peMsgs
                           : %trim(@@Repl)
                           : %len(%trim(@@Repl))  );
              peMsgs.peMsg2 = %trim(peMsgs.peMsg2)
                            + '/' + %trim(%char(pePoco))
                            + '/' + %trim(peNmat);
              peError = -1;
              return *Off;

            endif;

          endif;

        endif;

        // Valido Chasis (no blanco)
        if not SPVVEH_CheckChasis ( peChas );

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0038'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl))  );
          peMsgs.peMsg2 = %trim(peMsgs.peMsg2)
                        + '/' + %trim(%char(pePoco))
                        + '/' + %trim(peNmat);
          peError = -1;
          return *Off;

        endif;

        if %checkr(' ':peChas) <= 5;

          clear @@Repl;
          %subst(@@Repl:1:6) = 'Chasis';
          %subst(@@Repl:7:1) = '6';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0135'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        p@Patt = peChas;
        p@Patt = %xlate( NUMER : BLANK : p@Patt );
        p@Patt = %xlate( UPPER : BLANK : p@Patt );
        p@Patt = %xlate( LOWER : BLANK : p@Patt );
        if %len(%trim(p@Patt)) <> *zeros;

          clear @@Repl;
          %subst(@@Repl:1:6) = 'Chasis';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0136'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peMsgs.peMsg1 = %trim(peMsgs.peMsg1) + ' <' + %trim(peChas) + '>';
          peError = -1;
          return *Off;

        endif;

        // Valido Motor (no blanco)
        if not SPVVEH_CheckMotor ( peMoto );

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0039'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peMsgs.peMsg2 = %trim(peMsgs.peMsg2)
                        + '/' + %trim(%char(pePoco))
                        + '/' + %trim(peNmat);
          peError = -1;
          return *Off;

        endif;

        if %checkr(' ':peMoto) <= 3;

          clear @@Repl;
          %subst(@@Repl:1:6) = 'Motor';
          %subst(@@Repl:7:1) = '4';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0135'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        p@Patt = peMoto;
        p@Patt = %xlate( NUMER : BLANK : p@Patt );
        p@Patt = %xlate( UPPER : BLANK : p@Patt );
        p@Patt = %xlate( LOWER : BLANK : p@Patt );
        if %len(%trim(p@Patt)) <> *zeros;

          clear @@Repl;
          %subst(@@Repl:1:6) = 'Motor';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0136'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peMsgs.peMsg1 = %trim(peMsgs.peMsg1) + ' <' + %trim(peMoto) + '>';
          peError = -1;
          return *Off;

        endif;

        // Validar que cambia algun dato: patente chasis motor
        if peNmat <> @@DsT9.t9nmat or
           peChas <> @@DsT9.t9chas or
           peMoto <> @@DsT9.t9moto;

          peChgV = *On;

        endif;

        return *on;

      /end-free

     p COWVEH_chkEndosoComponente...
     p                 E

      * ------------------------------------------------------------ *
      * COWVEH_setEndosoPoliza() Cambia datos en vehiculo            *
      *                          Patente - Chasis - Motor            *
      * Input :                                                      *
      *         peBase          - Base                               *
      *         peUser          - Usuario                            *
      *         peArcd          - Codigo Articulo                    *
      *         peSpol          - Numero Superpoliza                 *
      *         peRama          - Codigo Rama                        *
      *         peArse          - Numero Polizas por Rama            *
      *         peOper          - Numero Operacion                   *
      *         pePoli          - Numero Poliza                      *
      *                                                              *
      * Output :                                                     *
      *         NroCotizacion   - Numero Cotizacion generada         *
      *         peVfde          - Vigencia Fecha Desde               *
      *         peVfha          - Vigencia Fecha Hasta               *
      *         peError         - Indicador de Error                 *
      *         peMsgs          - Estructura de Error                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     p COWVEH_setEndosoPoliza...
     p                 B                   export
     d COWVEH_setEndosoPoliza...
     d                 pi              n
     d peBase                              likeds(paramBase)       const
     d peUser                        50                            const
     d peArcd                         6  0                         const
     d peSpol                         9  0                         const
     d peRama                         2  0                         const
     d peArse                         2  0                         const
     d peOper                         7  0                         const
     d pePoli                         7  0                         const
     d peNctw                         7  0
     d peVfde                         8  0
     d peVfha                         8  0
     d peError                       10i 0
     d peMsgs                              likeds(paramMsgs)

     d PAR310X3        pr                  extpgm('PAR310X3')
     d  peEmpr                        1a   const
     d  peFema                        4  0
     d  peFemm                        2  0
     d  peFemd                        2  0

     d PRWASE8         pr                  ExtPgm('PRWASE8')
     d  peBase                             likeds(paramBase)       const
     d  peNctw                        7  0                         const
     d  peAsen                        7  0                         const
     d  peNomb                       40a                           const
     d  peDomi                             likeds(prwaseDomi_t)    const
     d  peDocu                             likeds(prwaseDocu_t)    const
     d  peNtel                             likeds(prwaseTele_t)    const
     d  peTiso                        2  0                         const
     d  peNaci                             likeds(prwaseNaco_t)    const
     d  peCprf                        3  0                         const
     d  peSexo                        1  0                         const
     d  peEsci                        1  0                         const
     d  peRaae                        3  0                         const
     d  peMail                             likeds(prwaseEmail_t)   const
     d  peAgpe                        1a                           const
     d  peTarc                             likeds(prwaseTarc_t)    const
     d  peNcbu                       22  0                         const
     d  peCbus                       22  0                         const
     d  peRuta                       16  0                         const
     d  peCiva                        2  0                         const
     d  peInsc                             likeds(prwaseInsc_t)    const
     d  peError                      10i 0
     d  peMsgs                             likeds(paramMsgs)

     d COWGRA1         pr                  extpgm('COWGRA1')
     d  peBase                             likeds(paramBase)       const
     d  peArcd                        6  0                         const
     d  peMone                        2                            const
     d  peTiou                        1  0                         const
     d  peStou                        2  0                         const
     d  peStos                        2  0                         const
     d  peSpo1                        7  0                         const
     d  peNctw                        7  0
     d  peError                      10i 0
     d  peMsgs                             likeds(paramMsgs)

     d p@Fdes          s              8  0
     d p@Fhas          s              8  0
     d p@Mone          s              2
     d p@Nctw          s              7  0
     d p@Spo1          s              7  0
     d p@Stos          s              2  0
     d p@Stou          s              2  0
     d p@Tiou          s              1  0

     d p@Fema          s              4  0
     d p@Femd          s              2  0
     d p@Femm          s              2  0
     d @@Femi          s              8  0

      * Parametros SVPDAF_getDatoFiliatorio
     d p@Nrdf          s              7  0
     d p@NombDAF       ds                  likeDs(dsNomb_t)
     d p@DomiDAF       ds                  likeDs(dsDomi_t)
     d p@DocuDAF       ds                  likeDs(dsDocu_t)
     d p@Cont          ds                  likeDs(dsCont_t)
     d p@NaciDAF       ds                  likeDs(dsNaci_t)
     d p@Marc          ds                  likeDs(dsMarc_t)
     d p@CbuSDAF       ds                  likeDs(dsCbuS_t)
     d p@Dape          ds                  likeDs(dsDape_t)
     d p@Clav          ds                  likeDs(dsClav_t)
     d p@Text          s             79    dim(999)
     d p@TextC         s             10i 0
     d p@Prov          ds                  likeDs(dsProI_t) dim(999)
     d p@ProvC         s             10i 0
     d p@MailDAF       ds                  likeds(Mailaddr_t) dim(100)
     d p@MailC         s             10i 0

      * Parametros PRWASE
     d p@Asen          s              7  0
     d p@NombPRW       s             40a
     d p@DomiPRW       ds                  likeds(prwaseDomi_t)
     d p@DocuPRW       ds                  likeds(prwaseDocu_t)
     d p@Ntel          ds                  likeds(prwaseTele_t)
     d p@Tiso          s              2  0
     d p@NaciPRW       ds                  likeds(prwaseNaco_t)
     d p@Cprf          s              3  0
     d p@Sexo          s              1  0
     d p@Esci          s              1  0
     d p@Raae          s              3  0
     d p@MailPRW       ds                  likeds(prwaseEmail_t)
     d p@Agpe          s              1a
     d p@Tarc          ds                  likeds(prwaseTarc_t)
     d p@Ncbu          s             22  0
     d p@CbusPRW       s             22  0
     d p@Ruta          s             16  0
     d p@Civa          s              2  0
     d p@Insc          ds                  likeds(prwaseInsc_t)

     d k1hec0          ds                  likerec(p1hec0:*key)
     d k1hec3          ds                  likerec(p1hec3:*key)
     d k1hdtc          ds                  likerec(g1hdtc:*key)

     d dsHec0Tmp       ds                  likerec(p1hec0:*input)
     d dsHec1Tmp       ds                  likerec(p1hec1:*input)
     d dsHec3Tmp       ds                  likerec(p1hec3:*input)
     d dsHaseTmp       ds                  likerec(s1hase:*input)

     d @@DsCtw         ds                  likeds( dsctw000_t )
     d @@Nuse          s                   like( dsctw000_t.w0nuse )
     d @@Fvtc          s              6  0
     d @@Cuii          s             11
     d @@CbuTxt        s             22
     d @@Iidx          s             10i 0
     d @@Repl          s          65535a
     d @@Tipe          s              1

     d k1w000          ds                  likerec(c1w000:*key)

      /free

        COWVEH_inz();

        clear peMsgs;
        clear peError;

        PAR310X3( peBase.peEmpr : p@Fema : p@Femm : p@Femd);
        @@Femi = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;

        // Obtiene Datos de la Superpoliza
        k1hec0.c0empr = peBase.peEmpr;
        k1hec0.c0sucu = peBase.peSucu;
        k1hec0.c0arcd = peArcd;
        k1hec0.c0spol = peSpol;
        chain %kds(k1hec0) pahec0 dsHec0Tmp;
        if not %found (pahec0);

          clear @@Repl;
          %subst(@@Repl:1:6) = %char(peArcd);
          %subst(@@Repl:7:9) = %char(peSpol);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0017'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Obtiene Datos de la Superpoliza
        setgt %kds(k1hec0:4) pahec1;
        readpe %kds(k1hec0:4) pahec1 dsHec1Tmp;
        if %eof(pahec1);

          clear @@Repl;
          %subst(@@Repl:1:6) = %char(peArcd);
          %subst(@@Repl:7:9) = %char(peSpol);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0017'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Obtiene Datos del plan de pagos
        k1hec3.c3empr = dsHec1Tmp.c1empr;
        k1hec3.c3sucu = dsHec1Tmp.c1sucu;
        k1hec3.c3arcd = dsHec1Tmp.c1arcd;
        k1hec3.c3spol = dsHec1Tmp.c1spol;
        k1hec3.c3sspo = dsHec1Tmp.c1sspo;
        chain %kds(k1hec3) pahec3 dsHec3Tmp;
        if not %found (pahec3);

          clear @@Repl;
          %subst(@@Repl:1:6) = %char(peArcd);
          %subst(@@Repl:7:9) = %char(peSpol);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0017'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Obtiene bloque datos filiatorios
        clear p@NombDAF;
        clear p@DomiDAF;
        clear p@DocuDAF;
        clear p@Cont;
        clear p@NaciDAF;
        clear p@Marc;
        clear p@CbuSDAF;
        clear p@Dape;
        clear p@Clav;
        clear p@Text;
        clear p@TextC;
        clear p@Prov;
        clear p@ProvC;
        clear p@MailDAF;
        clear p@MailC;
        SVPDAF_getDatoFiliatorio( dsHec1Tmp.c1asen
                                : p@NombDAF
                                : p@DomiDAF
                                : p@DocuDAF
                                : p@Cont
                                : p@NaciDAF
                                : p@Marc
                                : p@CbuSDAF
                                : p@Dape
                                : p@Clav
                                : p@Text
                                : p@TextC
                                : p@Prov
                                : p@ProvC
                                : p@MailDAF
                                : p@MailC );

        p@Asen = dsHec1Tmp.c1asen;

        p@NombPRW = p@NombDAF.Nomb;

        p@DomiPRW.Domi = p@DomiDAF.Domi;
        p@DomiPRW.Copo = p@DomiDAF.Copo;
        p@DomiPRW.Cops = p@DomiDAF.Cops;

        p@DocuPRW.Tido = p@DocuDAF.Tido;
        p@DocuPRW.Nrdo = p@DocuDAF.Nrdo;
        p@DocuPRW.Cuil = p@DocuDAF.Cuil;
        clear p@DocuPRW.Cuit;
        if %trim(p@DocuDAF.Cuit) <> *blanks;
          monitor;
            p@DocuPRW.Cuit = %dec(%trim(p@DocuDAF.Cuit):11:0);
          on-error;
            clear p@DocuPRW.Cuit;
          endmon;
        endif;

        p@Ntel.Nte1 = p@Cont.Tpa1;
        p@Ntel.Nte2 = p@Cont.Ttr1;
        p@Ntel.Nte3 = p@Cont.Tcel;
        p@Ntel.Pweb = p@Cont.Pweb;

        p@Tiso = p@DocuDAF.Tiso;
        if p@Tiso = 98;
          @@Tipe = 'F';
        else;
          @@Tipe = 'J';
        endif;

        p@NaciPRW.Fnac = p@NaciDAF.Fnac;
        p@NaciPRW.Lnac = p@NaciDAF.Lnac;
        p@NaciPRW.Pain = p@NaciDAF.Pain;
        p@NaciPRW.Cnac = p@NaciDAF.Cnac;

        p@Cprf = p@Dape.Cprf;
        p@Sexo = p@Dape.Sexo;
        p@Esci = p@Dape.Esci;
        p@Raae = p@Dape.Raae;

        p@MailPRW.Ctce = p@MailDAF(1).Tipo;
        p@MailPRW.Mail = p@MailDAF(1).Mail;

        p@Agpe = 'N';

        clear p@Tarc;
        if dsHec1Tmp.c1cfpg = 1;
          p@Tarc.ctcu = dsHec1Tmp.c1ctcu;
          p@Tarc.nrtc = dsHec1Tmp.c1nrtc;
          k1hdtc.dfnrdf = dsHec1Tmp.c1asen;
          k1hdtc.dfctcu = dsHec1Tmp.c1ctcu;
          k1hdtc.dfnrtc = dsHec1Tmp.c1nrtc;
          chain %kds(k1hdtc) gnhdtc;
          if %found;
            p@Tarc.ffta = dfffta;
            p@Tarc.fftm = dffftm;
          endif;
        endif;

        clear p@Ncbu;
        clear p@CbusPRW;
        @@CbuTxt = *zeros;
        if dsHec1Tmp.c1cfpg = 2 or  dsHec1Tmp.c1cfpg = 3;
          evalr @@CbuTxt = %trim(@@CbuTxt)
                         + %trim(SPVCBU_getCbuEntero( dsHec1Tmp.c1ivbc
                                                    : dsHec1Tmp.c1ivsu
                                                    : dsHec1Tmp.c1tcta
                                                    : dsHec1Tmp.c1ncta ) );
        endif;
        p@Ncbu = %dec(@@CbuTxt:22:0);

        p@civa = dsHec1Tmp.c1civa;

        clear p@Ruta;
        clear p@Insc;
        clear dsHaseTmp;
        chain dsHec1Tmp.c1asen sehase dsHaseTmp;
        if %found(sehase);
          p@Ruta = dsHaseTmp.asruta;
          p@Insc.Fein = dsHaseTmp.asfein;
          p@Insc.Nrin = dsHaseTmp.asnrin;
          p@Insc.Feco = dsHaseTmp.asfeco;
        endif;

        p@Fdes = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;
        p@Fhas = (dsHec1Tmp.c1fvoa * 10000)
               + (dsHec1Tmp.c1fvom * 100)
               +  dsHec1Tmp.c1fvod;

        p@Mone = SPVSPO_getMone( peBase.peEmpr
                               : peBase.peSucu
                               : peArcd
                               : peSpol
                               : *omit);
        p@Tiou = 3;
        p@Stou = 7;
        p@Stos = 4;
        p@Spo1 = peSpol;
        clear p@Nctw;
        COWGRA1( peBase
               : peArcd
               : p@Mone
               : p@Tiou
               : p@Stou
               : p@Stos
               : p@Spo1
               : p@Nctw
               : peError
               : peMsgs );
        if peError <> *zeros;

          return *Off;

        endif;

        // Actualizo datos de la cabecera CTW000...
        COWGRAI_updCotizacion( peBase
                             : p@Nctw
                             : dsHec1Tmp.c1civa
                             : @@Tipe
                             : p@DomiPRW.Copo
                             : p@DomiPRW.Cops
                             : dsHec1Tmp.c1cfpg
                             : dsHec3Tmp.c3nrpp
                             : p@Fdes
                             : p@Fhas );

        // Upd Datos CTW000 que no son actualizados por "COWGRAI_updCotizacion"
        @@Femi = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;
        @@fvtc = ( p@Tarc.ffta * 100 ) + p@Tarc.fftm;
        clear @@Cuii;
        select;
        when p@DocuPRW.Cuil > *zeros;
          @@Cuii = %editc(p@DocuPRW.Cuil:'X');
        when p@DocuPRW.Cuit > *zeros;
          @@Cuii = %editc(p@DocuPRW.Cuit:'X');
        endsl;
        if %len(%trim(peUser)) > %size(@@Nuse);
           @@Nuse = %subst( %trim(peUser) : 1 : %size(@@Nuse) );
        else;
           @@Nuse = %trim(peUser);
        endif;

        clear @@DsCtw;
        if COWGRAI_getCtw000( peBase
                            : p@Nctw
                            : @@DsCtw );

          @@DsCtw.w0nomb = p@NombPRW;
          @@DsCtw.w0fpro = @@Femi;
          @@DsCtw.w0ncbu = p@Ncbu;
          @@DsCtw.w0ctcu = p@Tarc.ctcu;
          @@DsCtw.w0nrtc = p@Tarc.nrtc;
          @@DsCtw.w0fvtc = @@fvtc;
          @@DsCtw.w0asen = dsHec1Tmp.c1asen;
          if @@DsCtw.w0cuii = *blanks;
            @@DsCtw.w0cuii = @@Cuii;
          endif;
          @@DsCtw.w0nuse = @@Nuse;
          if not COWGRAI_updCtw000( @@DsCtw );

            peError = -1;

          endif;

        else;

            peError = -1;

        endif;

        if peError = -1;

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0132'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          return *Off;

        endif;

        PRWASE8( peBase
               : p@Nctw
               : p@Asen
               : p@NombPRW
               : p@DomiPRW
               : p@DocuPRW
               : p@Ntel
               : p@Tiso
               : p@NaciPRW
               : p@Cprf
               : p@Sexo
               : p@Esci
               : p@Raae
               : p@MailPRW
               : p@Agpe
               : p@Tarc
               : p@Ncbu
               : p@CbusPRW
               : p@Ruta
               : p@Civa
               : p@Insc
               : peError
               : peMsgs );
        if peError <> *zeros;

          return *Off;

        endif;

        p@Fdes = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;
        p@Fhas = (dsHec1Tmp.c1fvoa * 10000)
               + (dsHec1Tmp.c1fvom * 100)
               +  dsHec1Tmp.c1fvod;

        peVfde = p@Fdes;
        peVfha = p@Fhas;
        peNctw = p@Nctw;

        return *on;

      /end-free

     p COWVEH_setEndosoPoliza...
     p                 E

      * ------------------------------------------------------------ *
      * COWVEH_setEndosoComponente() Graba componente de la poliza   *
      *                              endoso Patente - Chasis - Motor *
      * Input :                                                      *
      *         peBase          - Base                               *
      *         peUser          - Usuario                            *
      *         peArcd          - Codigo Articulo                    *
      *         peSpol          - Numero Superpoliza                 *
      *         peRama          - Codigo Rama                        *
      *         peArse          - Numero Polizas por Rama            *
      *         peOper          - Numero Operacion                   *
      *         pePoli          - Numero Poliza                      *
      *         peNctw          - Numero Cotizacion Web              *
      *         pePoco          - Numero Componente                  *
      *         peNmat          - Patente                            *
      *         peChas          - Chasis                             *
      *         peMoto          - Motor                              *
      *         peSuas          - Importe Suma Asegurada             *
      *                                                              *
      * Output :                                                     *
      *         peError         - Indicador de Error                 *
      *         peMsgs          - Estructura de Error                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     p COWVEH_setEndosoComponente...
     p                 B                   export
     d COWVEH_setEndosoComponente...
     d                 pi              n
     d peBase                              likeds(paramBase)    const
     d peUser                        50                         const
     d peArcd                         6  0                      const
     d peSpol                         9  0                      const
     d peRama                         2  0                      const
     d peArse                         2  0                      const
     d peOper                         7  0                      const
     d pePoli                         7  0                      const
     d peNctw                         7  0                      const
     d pePoco                         4  0                      const
     d peNmat                        25                         const
     d peChas                        25                         const
     d peMoto                        25                         const
     d peSuas                        15  2                      const
     d peError                       10i 0
     d peMsgs                              likeds(paramMsgs)

     d PAR310X3        pr                  extpgm('PAR310X3')
     d  peEmpr                        1a   const
     d  peFema                        4  0
     d  peFemm                        2  0
     d  peFemd                        2  0

     d p@Fema          s              4  0
     d p@Femd          s              2  0
     d p@Femm          s              2  0
     d p@Sspo          s              3  0

     d @@DsT0          ds                  likeds(dsPahet0_t)
     d @@DsT9          ds                  likeds(dsPahet9_t)
     d @@Femi          s              8  0
     d @@Repl          s          65535a

      * Parametros para COWVEH_saveCabecera
     D p@Vhan          s              4
     D p@Vhmc          s              3
     D p@Vhmo          s              3
     D p@Vhcs          s              3
     D p@Vhvu          s             15  2
     D p@Mgnc          s              1
     D p@Rgnc          s              7  2
     D p@Copo          s              5  0
     D p@Cops          s              1  0
     D p@Scta          s              1  0
     D p@Clin          s              1
     D p@Bure          s              1  0
     D p@Cfpg          s              1  0
     D p@Tipe          s              1
     D p@Ctre          s              5  0
     d p@Vald          s              1a
     d p@Rtco          s              7a

     d k1wet0          ds                  likerec( c1wet0 : *key )

      /free

        COWVEH_inz();

        clear peMsgs;
        clear peError;

        PAR310X3( peBase.peEmpr : p@Fema : p@Femm : p@Femd);
        @@Femi = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;

        // Obtiene registro completo del componente - PAHET9
        if not SPVVEH_getPahet9( peBase.peEmpr
                               : peBase.peSucu
                               : peArcd
                               : peSpol
                               : peRama
                               : peArse
                               : pePoco
                               : @@DsT9 );

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'API0004'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Obtiene registro completo del componente - PAHET0
        p@Sspo = @@DsT9.t9sspo;
        if not SPVVEH_getPahet0( peBase.peEmpr
                               : peBase.peSucu
                               : peArcd
                               : peSpol
                               : peRama
                               : peArse
                               : pePoco
                               : p@Sspo
                               : @@DsT0 );

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'API0004'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peError = -1;
          return *Off;

        endif;

        // Solo se endosan los componentes que cambian...
        if peNmat = @@DsT9.t9nmat and
           peChas = @@DsT9.t9chas and
           peMoto = @@DsT9.t9moto;

          return *on;

        endif;

        p@Vhan = %editc(@@Dst0.t0vhaÑ:'X');
        p@Vhmc = @@Dst0.t0vhmc;
        p@Vhmo = @@Dst0.t0vhmo;
        p@Vhcs = @@Dst0.t0vhcs;
        p@Vhvu = @@Dst0.t0vhvu;
        p@Mgnc = 'N';
        clear p@Rgnc;
        if @@Dst0.t0rgnc > *zeros;
          p@Mgnc = 'S';
          p@Rgnc += @@Dst0.t0rgnc;
        endif;

        if not SVPDAF_getLocalidad( SPVSPO_getAsen( peBase.peEmpr
                                                  : peBase.peSucu
                                                  : peArcd
                                                  : peSpol )
                                  : p@Copo
                                  : p@Cops );
          clear p@Copo;
          clear p@Cops;
        endif;

        p@Scta = @@Dst0.t0scta;
        if SVPREN_getClienteIntegral( peBase.peEmpr
                                    : peBase.peSucu
                                    : peArcd
                                    : peSpol
                                    : peRama
                                    : peArse
                                    : pePoco );
          p@Clin = 'S';
        else;
          p@Clin = 'N';
        endif;

        p@Bure = SVPREN_getBuenResultado( peBase.peEmpr
                                        : peBase.peSucu
                                        : peArcd
                                        : peSpol
                                        : peRama
                                        : peArse
                                        : pePoco );

        p@Sspo = @@DsT9.t9sspo;
        p@Cfpg = SPVSPO_getFormaDePago( peBase.peEmpr
                                      : peBase.peSucu
                                      : peArcd
                                      : peSpol
                                      : p@sspo );

        p@Tipe = COWGRAI_getTipoPersona( peBase
                                       : peNctw );

        p@Ctre = @@Dst0.t0ctre;

        COWVEH_saveCabecera( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : pePoco
                           : p@Vhan
                           : p@Vhmc
                           : p@Vhmo
                           : p@Vhcs
                           : p@Vhvu
                           : p@Mgnc
                           : p@Rgnc
                           : p@Copo
                           : p@Cops
                           : p@Scta
                           : p@Clin
                           : p@Bure
                           : p@Cfpg
                           : p@Tipe
                           : p@Ctre
                           : 0      );

        // Actualizo Datos del endoso: Patente - Chasis - Motor
        k1wet0.t0empr = peBase.peEmpr;
        k1wet0.t0sucu = peBase.peSucu;
        k1wet0.t0nivt = peBase.peNivt;
        k1wet0.t0nivc = peBase.peNivc;
        k1wet0.t0nctw = peNctw;
        k1wet0.t0rama = peRama;
        k1wet0.t0poco = pePoco;
        k1wet0.t0arse = peArse;
        chain %kds( k1wet0 : 8 ) ctwet0;
        if %found( ctwet0 );
          t0nmat = peNmat;
          t0chas = peChas;
          t0moto = peMoto;
          t0vhuv = @@DsT0.t0vhuv;
          t0aver = @@DsT0.t0mar1;
          t0nmer = @@DsT9.t9nmer;

          clear p@Vald;
          clear p@Rtco;
          SPFMTPAT( peBase.peEmpr
                  : peBase.peSucu
                  : t0nmat
                  : %char(%date():*ymd)
                  : '2'
                  : 'A'
                  : t0tmat
                  : p@Vald
                  : p@Rtco             );

          if %trim(p@Rtco) <> 'OK';
             t0tmat = 'MER';
          endif;

          update c1wet0;
        endif;

        clear c1wetc;

          t0empr = peBase.peEmpr;
          t0sucu = peBase.peSucu;
          t0nivt = peBase.peNivt;
          t0nivc = peBase.peNivc;
          t0nctw = peNctw;
          t0rama = peRama;
          t0arse = peArse;
          t0poco = pePoco;
          t0cobl = @@Dst0.t0cobl;
          t0prrc = 0;
          t0prac = 0;
          t0prin = 0;
          t0prro = 0;
          t0pacc = 0;
          t0praa = 0;
          t0prsf = 0;
          t0prce = 0;
          t0prap = 0;
          t0rras = 'N';
          t0cras = 0;
          t0rins = 'N';
          t0cobs = '1';
          t0mar1 = '0';
          t0mar2 = '0';
          t0mar3 = '0';
          t0mar4 = '0';
          t0mar5 = '0';
          t0ifra = @@Dst0.t0ifra;
          t0prim = t0prrc + t0prac + t0prro + t0prin + t0prce + t0prap;
          t0seri = 0;
          t0seem = 0;
          t0impi = 0;
          t0sers = 0;
          t0tssn = 0;
          t0ipr1 = 0;
          t0ipr4 = 0;
          t0ipr3 = 0;
          t0ipr6 = 0;
          t0ipr7 = 0;
          t0ipr8 = 0;
          t0ipr9 = 0;
          t0prem = 0;
          t0rcle = @@Dst0.t0rcle;
          t0rcco = @@Dst0.t0rcco;
          t0rcac = @@Dst0.t0rcac;
          t0lrce = @@Dst0.t0lrce;
          t0claj = @@Dst0.t0claj;



        write c1wetc;

        return *on;

      /end-free

     p COWVEH_setEndosoComponente...
     p                 E

      * ---------------------------------------------------------------- *
      * COWVEH_getCoberturasGaus():Busca posibles coberturas para el auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Nro. Cotizacion                        *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peScta  -  Zona de Riesgo                         *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *        Output:                                                   *
      *                peCveh  -  Coberturas                             *
      *                peccob  -  Cant de coberturas                     *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWVEH_getCoberturasGaus...
     P                 B
     D COWVEH_getCoberturasGaus...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peScta                       1  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D   peCveh                            likeds(cob225) dim(99)
     D   peCcob                       2  0

     D x               s              2  0
     D p@Vhca          s              2  0
     D p@Vhv1          s              1  0
     D p@Vhv2          s              1  0
     D p@Mtdf          s              1
     D p@Cobd          s              2

     D @cveh           ds                  likeds(cob225) dim(99)
     D @ccob           s              2  0
     D @@ccob          s              2  0

      /free

       COWVEH_inz();

       clear pecveh;
       clear peccob;

       SPVVEH_getClasificacion( peVhmc :
                                peVhmo :
                                peVhcs :
                                p@Vhca :
                                p@Vhv1 :
                                p@Vhv2 :
                                p@Mtdf );

       CZWUTL_getCobertD ( p@Vhca :
                           p@Vhv1 :
                           p@Vhv2 :
                           p@Mtdf :
                           peScta :
                           p@Cobd );

       setll *start set225;
       read set225;
       dow not %eof(set225);

         if s225_t@cobl = 'D2' or s225_t@cobl = 'D3';//saber cual D usar

           if s225_t@cobl = p@Cobd;

             peccob += 1;
             peCveh(peccob).cobc = s225_t@cobl;
             peCveh(peccob).coss = s225_t@coss;
             peCveh(peccob).ccrc = s225_t@ccrc;

           endif;

         else;

           peccob += 1;
           peCveh(peccob).cobc = s225_t@cobl;
           peCveh(peccob).coss = s225_t@coss;
           peCveh(peccob).ccrc = s225_t@ccrc;

         endif;

         read set225;
       enddo;

       return *on;

      /end-free

     P COWVEH_getCoberturasGaus...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_deletePocoScoring(): Elimina registro en ctwet3       *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Componente                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWVEH_deletePocoScoring...
     P                 B                   export
     D COWVEH_deletePocoScoring...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yet3        ds                  likerec( c1wet3 : *key )

      /free

       COWVEH_inz();

       k1yet3.t3Empr = peBase.peEmpr;
       k1yet3.t3Sucu = peBase.peSucu;
       k1yet3.t3Nivt = peBase.peNivt;
       k1yet3.t3Nivc = peBase.peNivc;
       k1yet3.t3Nctw = peNctw;
       k1yet3.t3Rama = peRama;
       k1yet3.t3Arse = peArse;
       k1yet3.t3Poco = pePoco;
       setll %kds( k1yet3 : 8 ) ctwet3;
       reade %kds( k1yet3 : 8 ) ctwet3;
       dow not %eof( ctwet3 );
         delete c1wet3;
         reade %kds( k1yet3 : 8 ) ctwet3;
       enddo;

      /end-free

     P COWVEH_deletePocoScoring...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_getCtwet3(): Retorna registro ctwet3.                 *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNivt   ( input  ) Nivel de Intermediario               *
      *     peNivc   ( input  ) Código de Intermediario              *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                      (Opcional) *
      *     peArse   ( input  ) Cant. Pólizas por Rama    (Opcional) *
      *     pePoco   ( input  ) Número de Bien Asegurado  (Opcional) *
      *     peTaaj   ( input  ) Código de Cuestionario    (Opcional) *
      *     peCosg   ( input  ) Código de Pregunta        (Opcional) *
      *     peDst3   ( output ) Estru. de ctwet3                     *
      *     peDst3C  ( output ) Cant. de registros                   *
      *     peForm   ( input  ) Formatear Valores                    *
      *                                                              *
      * Retorna: *on = Si existe /  *off = No existe                 *
      * ------------------------------------------------------------ *
     P COWVEH_getCtwet3...
     P                 B                   export
     D COWVEH_getCtwet3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peTaaj                       2  0 options( *nopass : *omit ) const
     D   peCosg                       4    options( *nopass : *omit ) const
     D   peDst3                            likeds ( dsctwet3_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDst3C                     10i 0 options( *nopass : *omit )
     D   peForm                       1    options( *nopass : *omit )

     D   k1yet3        ds                  likerec( c1wet3 : *key )
     D   @@DsIt3       ds                  likerec( c1wet3 : *input )
     D   @@Dst3        ds                  likeds ( dsctwet3_t ) dim( 999 )
     D   @@Dst3C       s             10i 0

      /free

       COWVEH_inz();

       k1yet3.t3Empr = peEmpr;
       k1yet3.t3Sucu = peSucu;
       k1yet3.t3Nivt = peNivt;
       k1yet3.t3Nivc = peNivc;
       k1yet3.t3Nctw = peNctw;

       select;
         when %parms >= 10 and %addr(peRama) <> *null
                           and %addr(peArse) <> *null
                           and %addr(pePoco) <> *null
                           and %addr(peTaaj) <> *null
                           and %addr(peCosg) <> *null;

           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           k1yet3.t3Poco = pePoco;
           k1yet3.t3Taaj = peTaaj;
           k1yet3.t3Cosg = peCosg;
           setll %kds( k1yet3 : 10 ) ctwet3;
           if not %equal( ctwet3 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 10 ) ctwet3 @@DsIt3;
           dow not %eof( ctwet3 );
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
             reade(n) %kds( k1yet3 : 10 ) ctwet3 @@DsIt3;
           enddo;

         when %parms >= 9 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) <> *null
                          and %addr(peTaaj) <> *null
                          and %addr(peCosg) =  *null;

           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           k1yet3.t3Poco = pePoco;
           k1yet3.t3Taaj = peTaaj;
           setll %kds( k1yet3 : 9 ) ctwet3;
           if not %equal( ctwet3 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 9 ) ctwet3 @@DsIt3;
           dow not %eof( ctwet3 );
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
             reade(n) %kds( k1yet3 : 9 ) ctwet3 @@DsIt3;
           enddo;

         when %parms >= 8 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) <> *null
                          and %addr(peTaaj) =  *null
                          and %addr(peCosg) =  *null;

           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           k1yet3.t3Poco = pePoco;
           setll %kds( k1yet3 : 8 ) ctwet3;
           if not %equal( ctwet3 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 8 ) ctwet3 @@DsIt3;
           dow not %eof( ctwet3 );
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
             reade(n) %kds( k1yet3 : 8 ) ctwet3 @@DsIt3;
           enddo;

         when %parms >= 7 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) =  *null
                          and %addr(peTaaj) =  *null
                          and %addr(peCosg) =  *null;

           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           setll %kds( k1yet3 : 7 ) ctwet3;
           if not %equal( ctwet3 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 7 ) ctwet3 @@DsIt3;
           dow not %eof( ctwet3 );
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
             reade(n) %kds( k1yet3 : 7 ) ctwet3 @@DsIt3;
           enddo;

         when %parms >= 6 and %addr(peRama) <> *null
                          and %addr(peArse) =  *null
                          and %addr(pePoco) =  *null
                          and %addr(peTaaj) =  *null
                          and %addr(peCosg) =  *null;

           k1yet3.t3Rama = peRama;
           setll %kds( k1yet3 : 6 ) ctwet3;
           if not %equal( ctwet3 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 6 ) ctwet3 @@DsIt3;
           dow not %eof( ctwet3 );
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
             reade(n) %kds( k1yet3 : 6 ) ctwet3 @@DsIt3;
           enddo;

         other;

           setll %kds( k1yet3 : 5 ) ctwet3;
           if not %equal( ctwet3 );
             return *off;
           endif;
           reade(n) %kds( k1yet3 : 5 ) ctwet3 @@DsIt3;
           dow not %eof( ctwet3 );
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
             reade(n) %kds( k1yet3 : 5 ) ctwet3 @@DsIt3;
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

     P COWVEH_getCtwet3...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkCtwet3(): Valida que exista registro en ctwet3.    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNivt   ( input  ) Nivel de Intermediario               *
      *     peNivc   ( input  ) Código de Intermediario              *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                      (Opcional) *
      *     peArse   ( input  ) Cant. Pólizas por Rama    (Opcional) *
      *     pePoco   ( input  ) Número de Bien Asegurado  (Opcional) *
      *     peTaaj   ( input  ) Código de Cuestionario    (Opcional) *
      *     peCosg   ( input  ) Código de Pregunta        (Opcional) *
      *                                                              *
      * Retorna: *on = Si existe /  *off = No existe                 *
      * ------------------------------------------------------------ *
     P COWVEH_chkCtwet3...
     P                 B                   export
     D COWVEH_chkCtwet3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peTaaj                       2  0 options( *nopass : *omit ) const
     D   peCosg                       4    options( *nopass : *omit ) const

     D   k1yet3        ds                  likerec( c1wet3 : *key )

      /free

       COWVEH_inz();

       k1yet3.t3Empr = peEmpr;
       k1yet3.t3Sucu = peSucu;
       k1yet3.t3Nivt = peNivt;
       k1yet3.t3Nivc = peNivc;
       k1yet3.t3Nctw = peNctw;

       select;
         when %parms >= 10 and %addr(peRama) <> *null
                           and %addr(peArse) <> *null
                           and %addr(pePoco) <> *null
                           and %addr(peTaaj) <> *null
                           and %addr(peCosg) <> *null;
           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           k1yet3.t3Poco = pePoco;
           k1yet3.t3Taaj = peTaaj;
           k1yet3.t3Cosg = peCosg;
           setll %kds( k1yet3 : 10 ) ctwet3;

         when %parms >= 9 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) <> *null
                          and %addr(peTaaj) <> *null
                          and %addr(peCosg) =  *null;
           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           k1yet3.t3Poco = pePoco;
           k1yet3.t3Taaj = peTaaj;
           setll %kds( k1yet3 : 9 ) ctwet3;

         when %parms >= 8 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) <> *null
                          and %addr(peTaaj) =  *null
                          and %addr(peCosg) =  *null;
           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           k1yet3.t3Poco = pePoco;
           setll %kds( k1yet3 : 8 ) ctwet3;

         when %parms >= 7 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) =  *null
                          and %addr(peTaaj) =  *null
                          and %addr(peCosg) =  *null;
           k1yet3.t3Rama = peRama;
           k1yet3.t3Arse = peArse;
           setll %kds( k1yet3 : 7 ) ctwet3;

         when %parms >= 6 and %addr(peRama) <> *null
                          and %addr(peArse) =  *null
                          and %addr(pePoco) =  *null
                          and %addr(peTaaj) =  *null
                          and %addr(peCosg) =  *null;

           k1yet3.t3Rama = peRama;
           setll %kds( k1yet3 : 6 ) ctwet3;
         other;
           setll %kds( k1yet3 : 5 ) ctwet3;
       endsl;

       return %equal();

      /end-free

     P COWVEH_chkCtwet3...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_setCtwet3(): Grabar registro en ctwet3.               *
      *                                                              *
      *     peDst3   ( input  ) Estructura de ctwet3.                *
      *                                                              *
      * Retorna: *on = Si existe /  *off = No existe                 *
      * ------------------------------------------------------------ *
     P COWVEH_setCtwet3...
     P                 B                   export
     D COWVEH_setCtwet3...
     D                 pi              n
     D   peDst3                            likeds( dsctwet3_t ) const

     D   @@DsOt3       ds                  likerec( c1wet3 : *output )

      /free

       COWVEH_inz();

       if COWVEH_chkCtwet3( peDst3.t3Empr
                          : peDst3.t3Sucu
                          : peDst3.t3Nivt
                          : peDst3.t3Nivc
                          : peDst3.t3Nctw
                          : peDst3.t3Rama
                          : peDst3.t3Arse
                          : peDst3.t3Poco
                          : peDst3.t3Taaj
                          : peDst3.t3Cosg );
         return *off;
       endif;

       eval-corr @@DsOt3 = peDst3;
       monitor;
         write c1wet3 @@DsOt3;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_setCtwet3...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_updCtwet3(): Actualiza registro en ctwet3.            *
      *                                                              *
      *     peDst3   ( input  ) Estructura de ctwet3.                *
      *                                                              *
      * Retorna: *on = Si actualizo /  *off = No actualizo           *
      * ------------------------------------------------------------ *
     P COWVEH_updCtwet3...
     P                 B                   export
     D COWVEH_updCtwet3...
     D                 pi              n
     D   peDst3                            likeds( dsctwet3_t ) const

     D k1yet3          ds                  likerec( c1wet3 : *key )
     D @@DsOt3         ds                  likerec( c1wet3 : *output )

      /free

       COWVEH_inz();

       k1yet3.t3Empr = peDst3.t3Empr;
       k1yet3.t3Sucu = peDst3.t3Sucu;
       k1yet3.t3Nivt = peDst3.t3Nivt;
       k1yet3.t3Nivc = peDst3.t3Nivc;
       k1yet3.t3Nctw = peDst3.t3Nctw;
       k1yet3.t3Rama = peDst3.t3Rama;
       k1yet3.t3Arse = peDst3.t3Arse;
       k1yet3.t3Poco = peDst3.t3Poco;
       k1yet3.t3Taaj = peDst3.t3Taaj;
       k1yet3.t3Cosg = peDst3.t3Cosg;
       chain %kds ( k1yet3 : 10 ) ctwet3;
       if %found( ctwet3 );
         eval-corr @@DsOt3 = peDst3;
         update c1wet3 @@DsOt3;
         return *on;
       endif;

       return *off;

      /end-free

     P COWVEH_updCtwet3...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_saveScoring(): Graba Cabecera de Scoring WEB.         *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Componente                 *
      *     peTaaj   ( input  ) Código de Cuestionario               *
      *     peScor   ( input  ) Estructura de preguntas              *
      *                                                              *
      * Retorna: *on = Si grabo /  *off = No grabo                   *
      * ------------------------------------------------------------ *
     P COWVEH_saveScoring...
     P                 B                   export
     D COWVEH_saveScoring...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const

     D x               s             10i 0
     D p1Arse          s              2  0
     D peDst3          ds                  likeds( dsctwet3_t )
     D @@DsCu          ds                  likeds( set2370_t )

      /free

       COWVEH_inz();

       if peArse = 0;
         p1Arse = 1;
       else;
         p1Arse = peArse;
       endif;

       for x = 1 to 200;
         if peScor(x).Cosg <> *blanks;

           peDst3.t3Empr = peBase.peEmpr;
           peDst3.t3Sucu = peBase.peSucu;
           peDst3.t3Nivt = peBase.peNivt;
           peDst3.t3Nivc = peBase.peNivc;
           peDst3.t3Nctw = peNctw;
           peDst3.t3Rama = peRama;
           peDst3.t3Arse = p1Arse;
           peDst3.t3Poco = pePoco;
           peDst3.t3Taaj = peTaaj;
           peDst3.t3Cosg = peScor(x).Cosg;

           if SVPTAB_getCuestionario( peTaaj
                                    : @@DsCu );

             peDst3.t3Tiaj = @@DsCu.t@Tiaj;
             peDst3.t3Tiac = @@DsCu.t@Tiac;

           endif;

           select;
             when peScor(x).Vefa = 'V';
               peDst3.t3Vefa = '1';
             when peScor(x).Vefa = 'F';
               peDst3.t3Vefa = '0';
           endsl;

           peDst3.t3Corc = 0;
           peDst3.t3Coca = 0;
           peDst3.t3Mar1 = '0';
           peDst3.t3Mar2 = '0';
           peDst3.t3Mar3 = '0';
           peDst3.t3Mar4 = '0';
           peDst3.t3Mar5 = '0';
           peDst3.t3Strg = '0';
           peDst3.t3User = @PsDs.CurUsr;
           peDst3.t3Time = %dec(%time);
           peDst3.t3Date = %dec(%date);
           peDst3.t3Cant = peScor(x).Cant;

           if not COWVEH_setCtwet3( peDst3 );
             return *off;
           endif;

         endif;
       endfor;

       return *on;

      /end-free

     P COWVEH_saveScoring...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_validaPreguntas: Valida preguntas de Scoring.         *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Componente                 *
      *     peTaaj   ( input  ) Código de Cuestionario               *
      *     peScor   ( input  ) Estructura de preguntas              *
      *     peErro   ( output ) Indicador de Error                   *
      *     peMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P COWVEH_validaPreguntas...
     P                 B                   export
     D COWVEH_validaPreguntas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D peArcd          s              6  0
     D @@Darc          s             30
     D @@Cosg          s              4
     D @@Coex          s              4
     D @@Scor          ds                  likeds( items_t) dim(200)
     D @@ScorC         s             10i 0

     D signo           c                   const('(')

      /free

       COWVEH_inz();

       // -----------------------------------------
       // Valida que el código de Cuestionario y
       // los datos de preguntas esten correctos.
       // -----------------------------------------

       // Obtener artículo.
       clear peArcd;
       peArcd = COWGRAI_getArticulo( peBase
                                   : peNctw );

       // Calcula la cantidad de preguntas.

       clear @@ScorC;

       for i = 1 to 200;
         if peScor(i).Cosg = *blanks;
           leave;
         endif;
         @@ScorC += 1;
       endfor;

       eval-corr @@Scor = peScor;

       if not SPVVEH_validaPreguntas( peArcd
                                    : peRama
                                    : peArse
                                    : peTaaj
                                    : @@Scor
                                    : @@ScorC );

           ErrText = SPVVEH_Error(ErrCode);

           select;
             when SPVVEH_VTAAJ = ErrCode;

               %subst(wrepl:1:2) =  %editc( peTaaj : 'X' );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0188'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_VCOSG = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0189'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_VVEFA = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0190'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_VCANT = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0191'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_VDCOS = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0192'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_VDCOX = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Coex = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Coex );

               i = %scan( signo : ErrText : i );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:5:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0193'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_VOBLI = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0194'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_VSECU = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0195'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_ARCSC = ErrCode;

               @@Darc = SVPDES_articulo( peArcd );
               %subst(wrepl:1:6) =  %trim(%char( peArcd ));
               %subst(wrepl:7:30) = %trim( @@Darc );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0196'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

             when SPVVEH_ARCNS = ErrCode;

               @@Darc = SVPDES_articulo( peArcd );
               %subst(wrepl:1:6) =  %trim(%char( peArcd ));
               %subst(wrepl:7:30) = %trim( @@Darc );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0197'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

           endsl;

           peErro = -1;
           return *off;

       endif;

       return *on;

      /end-free

     P COWVEH_validaPreguntas...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_updScoring(): Actualiza Cabecera de Scoring WEB.      *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Componente                 *
      *     peTaaj   ( input  ) Código de Cuestionario               *
      *     peItem   ( input  ) Estructura de preguntas              *
      *                                                              *
      * Retorna: *on = Si Actualizo / *off = No Actualizo            *
      * ------------------------------------------------------------ *
     P COWVEH_updScoring...
     P                 B                   export
     D COWVEH_updScoring...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peTaaj                       2  0 const
     D   peItem                            likeds(items_t) dim(200) const

     D x               s             10i 0
     D p1Arse          s              2  0
     D peDst3          ds                  likeds( dsctwet3_t )
     D @@DsCu          ds                  likeds( set2370_t )

      /free

       COWVEH_inz();

       if peArse = 0;
         p1Arse = 1;
       else;
         p1Arse = peArse;
       endif;

       for x = 1 to 200;
         if peItem(x).Cosg <> *blanks;

           peDst3.t3Empr = peBase.peEmpr;
           peDst3.t3Sucu = peBase.peSucu;
           peDst3.t3Nivt = peBase.peNivt;
           peDst3.t3Nivc = peBase.peNivc;
           peDst3.t3Nctw = peNctw;
           peDst3.t3Rama = peRama;
           peDst3.t3Arse = p1Arse;
           peDst3.t3Poco = pePoco;
           peDst3.t3Taaj = peTaaj;
           peDst3.t3Cosg = peItem(x).Cosg;
           peDst3.t3Tiaj = peItem(x).Tiaj;
           peDst3.t3Tiac = peItem(x).Tiac;

           select;
             when peItem(x).Vefa = 'V';
               peDst3.t3Vefa = '1';
             when peItem(x).Vefa = 'F';
               peDst3.t3Vefa = '0';
           endsl;

           peDst3.t3Corc = peItem(x).Corc;
           peDst3.t3Coca = peItem(x).Coca;
           peDst3.t3Mar1 = '0';
           peDst3.t3Mar2 = '0';
           peDst3.t3Mar3 = '0';
           peDst3.t3Mar4 = '0';
           peDst3.t3Mar5 = '0';
           peDst3.t3Strg = '0';
           peDst3.t3User = @PsDs.CurUsr;
           peDst3.t3Time = %dec(%time);
           peDst3.t3Date = %dec(%date);
           peDst3.t3Cant = peItem(x).Cant;

           if not COWVEH_updCtwet3( peDst3 );
             return *off;
           endif;

         endif;
       endfor;

       return *on;

      /end-free

     P COWVEH_updScoring...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_getPrimasXCoberturas() : Retorna datos de la tabla    *
      *                                 CTWETC.                      *
      *                                                              *
      *        Input :                                               *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peNivt  -  Nivel de Intermediario             *
      *                peNivc  -  Código de Intermediario            *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                    (Opcional) *
      *                peArse  -  Cant. Pólizas por Rama  (Opcional) *
      *                pePoco  -  Nro de Componente       (Opcional) *
      *                peCobl  -  Código de Cobertura     (Opcional) *
      *        Output:                                               *
      *                peDsTc  -  Est. Primas por Coberturas         *
      *                peDsTcC -  Cant. Primas por Coberturas        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = No Encontro              *
      * -------------------------------------------------------------*
     P COWVEH_getPrimasXCoberturas...
     P                 B                   export
     D COWVEH_getPrimasXCoberturas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peCobl                       2    options( *nopass : *omit ) const
     D   peDsTc                            likeds( dsCtwetc_t ) dim( 99 )
     D                                     options( *nopass : *omit )
     D   peDsTcC                     10i 0 options( *nopass : *omit )

     D k1yetc          ds                  likerec( c1wetc : *key )
     D @@DsItc         ds                  likerec( c1wetc : *input )
     D @@DsTc          ds                  likeds ( dsCtwetc_t ) dim( 99 )
     D @@DsTcC         s             10i 0

      /free

       COWVEH_inz();

       k1yetc.t0Empr = peEmpr;
       k1yetc.t0Sucu = peSucu;
       k1yetc.t0Nivt = peNivt;
       k1yetc.t0Nivc = peNivc;
       k1yetc.t0Nctw = peNctw;

       select;
         when %parms >= 9 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) <> *null
                          and %addr(peCobl) <> *null;

           k1yetc.t0Rama = peRama;
           k1yetc.t0Arse = peArse;
           k1yetc.t0Poco = pePoco;
           k1yetc.t0Cobl = peCobl;
           setll %kds( k1yetc : 9 ) ctwetc;
           if not %equal( ctwetc );
             return *off;
           endif;
           reade(n) %kds( k1yetc : 9 ) ctwetc @@DsItc;
           dow not %eof( ctwetc );
             @@DstcC += 1;
             eval-corr @@Dstc( @@DstcC ) = @@DsItc;
             reade(n) %kds( k1yetc : 9 ) ctwetc @@DsItc;
           enddo;

         when %parms >= 8 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) <> *null
                          and %addr(peCobl) =  *null;

           k1yetc.t0Rama = peRama;
           k1yetc.t0Arse = peArse;
           k1yetc.t0Poco = pePoco;
           setll %kds( k1yetc : 8 ) ctwetc;
           if not %equal( ctwetc );
             return *off;
           endif;
           reade(n) %kds( k1yetc : 8 ) ctwetc @@DsItc;
           dow not %eof( ctwetc );
             @@DstcC += 1;
             eval-corr @@Dstc( @@DstcC ) = @@DsItc;
             reade(n) %kds( k1yetc : 8 ) ctwetc @@DsItc;
           enddo;

         when %parms >= 7 and %addr(peRama) <> *null
                          and %addr(peArse) <> *null
                          and %addr(pePoco) =  *null
                          and %addr(peCobl) =  *null;

           k1yetc.t0Rama = peRama;
           k1yetc.t0Arse = peArse;
           setll %kds( k1yetc : 7 ) ctwetc;
           if not %equal( ctwetc );
             return *off;
           endif;
           reade(n) %kds( k1yetc : 7 ) ctwetc @@DsItc;
           dow not %eof( ctwetc );
             @@DstcC += 1;
             eval-corr @@Dstc( @@DstcC ) = @@DsItc;
             reade(n) %kds( k1yetc : 7 ) ctwetc @@DsItc;
           enddo;

         when %parms >= 6 and %addr(peRama) <> *null
                          and %addr(peArse) =  *null
                          and %addr(pePoco) =  *null
                          and %addr(peCobl) =  *null;

           k1yetc.t0Rama = peRama;
           setll %kds( k1yetc : 6 ) ctwetc;
           if not %equal( ctwetc );
             return *off;
           endif;
           reade(n) %kds( k1yetc : 6 ) ctwetc @@DsItc;
           dow not %eof( ctwetc );
             @@DstcC += 1;
             eval-corr @@Dstc( @@DstcC ) = @@DsItc;
             reade(n) %kds( k1yetc : 6 ) ctwetc @@DsItc;
           enddo;

         other;

           setll %kds( k1yetc : 5 ) ctwetc;
           if not %equal( ctwetc );
             return *off;
           endif;
           reade(n) %kds( k1yetc : 5 ) ctwetc @@DsItc;
           dow not %eof( ctwetc );
             @@DstcC += 1;
             eval-corr @@Dstc( @@DstcC ) = @@DsItc;
             reade(n) %kds( k1yetc : 5 ) ctwetc @@DsItc;
           enddo;

       endsl;

       if %addr( peDstc ) <> *null;
         eval-corr peDstc = @@Dstc;
       endif;

       if %addr( peDstcC ) <> *null;
         eval peDstcC = @@DstcC;
       endif;

       return *on;

      /end-free

     P COWVEH_getPrimasXCoberturas...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_updPrimasXCoberturas() : Actualiza datos de la tabla  *
      *                                 CTWETC.                      *
      *                                                              *
      *           peDsTc  -  Est. Primas por Coberturas              *
      *                                                              *
      * Retorna: *on = Actualizo   / *off = No Actualizo             *
      * -------------------------------------------------------------*
     P COWVEH_updPrimasXCoberturas...
     P                 B                   export
     D COWVEH_updPrimasXCoberturas...
     D                 pi              n
     D   peDsTc                            likeds( dsCtwetc_t ) const

     D k1yetc          ds                  likerec( c1wetc : *key )
     D @@DsOtc         ds                  likerec( c1wetc : *output )

      /free

       COWVEH_inz();

       k1yetc.t0Empr = peDsTc.t0Empr;
       k1yetc.t0Sucu = peDsTc.t0Sucu;
       k1yetc.t0Nivt = peDsTc.t0Nivt;
       k1yetc.t0Nivc = peDsTc.t0Nivc;
       k1yetc.t0Nctw = peDsTc.t0Nctw;
       k1yetc.t0Rama = peDsTc.t0Rama;
       k1yetc.t0Arse = peDsTc.t0Arse;
       k1yetc.t0Poco = peDsTc.t0Poco;
       k1yetc.t0Cobl = peDsTc.t0Cobl;
       chain %kds( k1yetc : 9 ) ctwetc;
       if not %found( ctwetc );
         return *off;
       endif;

       eval-corr @@DsOtc = peDsTc;
       monitor;
         update c1wetc @@DsOtc;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_updPrimasXCoberturas...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_aplicaScoring: Aplica prima de Scoring.               *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Componente                 *
      *     peTaaj   ( input  ) Código de Cuestionario               *
      *     peScor   ( input  ) Estructura de preguntas              *
      *     peErro   ( output ) Indicador de Error                   *
      *     peMsgs   ( output ) Estructura de Error                  *
      *     peCobl   ( input  ) Código de Cobertura      (Opcional)  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P COWVEH_aplicaScoring...
     P                 B                   export
     D COWVEH_aplicaScoring...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   peCobl                       2    options(*nopass:*omit)

     D x               s             10i 0
     D i               s             10i 0
     D peArcd          s              6  0
     D p1Arse          s              2  0
     D @@Item          ds                  likeds( items_t ) dim(200)
     D @@ItemC         s             10i 0
     D @@DsTc          ds                  likeds ( dsCtwetc_t ) dim( 99 )
     D @@DsTcC         s             10i 0
     D @@Tiou          s              1  0
     D @@Stou          s              2  0
     D @@Stos          s              2  0
     D @@Actu          s              1    inz('1')
     D @@Cosg          s              4
     D @@imp           s             15  2
     D signo           c                   const('(')

      /free

       COWVEH_inz();

       clear @@Item;
       clear @@ItemC;

       eval-corr @@Item = peScor;
       for x = 1 to 200;
         if peScor(x).Cosg = *blanks;
           leave;
         endif;
         @@ItemC += 1;
       endfor;

       COWGRAI_getTipoDeOperacion(peBase : peNctw : @@tiou : @@stou : @@stos);

       //Valido ParmBase
       if not SVPWS_chkParmBase ( peBase : peMsgs );

         peErro = -1;
         return;

       endif;

       //Valido Cotización
       if not COWGRAI_chkCotizacion ( peBase : peNctw );

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

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama que pueda emitir en web
       if not SVPVAL_ramaWeb ( peRama );

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_RAMNW = ErrCode;

           %subst(wrepl:1:2) = %editc(peRama:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido Componente <> 0
       if pePoco = *Zeros;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0118'
                      : peMsgs );

         peErro = -1;
         return;

       endif;

       if peArse = 0;
         p1Arse = 1;
       else;
         p1Arse = peArse;
       endif;

       clear @@DsTc;
       clear @@DsTcC;

       if %parms >= 10 and %addr( peCobl ) <> *null;
         if COWVEH_getPrimasXCoberturas( peBase.peEmpr
                                       : peBase.peSucu
                                       : peBase.peNivt
                                       : peBase.peNivc
                                       : peNctw
                                       : peRama
                                       : p1Arse
                                       : pePoco
                                       : peCobl
                                       : @@DsTc
                                       : @@DsTcC       );
         endif;
       else;
         if COWVEH_getPrimasXCoberturas( peBase.peEmpr
                                       : peBase.peSucu
                                       : peBase.peNivt
                                       : peBase.peNivc
                                       : peNctw
                                       : peRama
                                       : p1Arse
                                       : pePoco
                                       : *omit
                                       : @@DsTc
                                       : @@DsTcC       );
         endif;
       endif;

       for x = 1 to @@DsTcC;
         if SPVVEH_aplicaScoring( @@DsTc(x).t0Prrc
                                : @@DsTc(x).t0Prac
                                : @@DsTc(x).t0Prin
                                : @@DsTc(x).t0Prro
                                : @@DsTc(x).t0Pacc
                                : @@DsTc(x).t0Praa
                                : @@DsTc(x).t0Prsf
                                : @@DsTc(x).t0Prce
                                : @@DsTc(x).t0Prap
                                : @@Actu
                                : peTaaj
                                : @@Item
                                : @@ItemC
                                : @@DsTc(x).t0Prrc
                                : @@DsTc(x).t0Prac
                                : @@DsTc(x).t0Prin
                                : @@DsTc(x).t0Prro
                                : @@DsTc(x).t0Pacc
                                : @@DsTc(x).t0Praa
                                : @@DsTc(x).t0Prsf
                                : @@DsTc(x).t0Prce
                                : @@DsTc(x).t0Prap );

           if not COWVEH_updPrimasXCoberturas( @@DsTc(x) );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0198'
                          : peMsgs );

             peErro = -1;
             return;
           endif;
         else;

           ErrText = SPVVEH_Error(ErrCode);

           select;
             when SPVVEH_VTAAJ = ErrCode;

               %subst(wrepl:1:2) =  %editc( peTaaj : 'X' );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0188'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

               peErro = -1;
               return;

             when SPVVEH_VCOSG = ErrCode;

               i = %scan( signo : ErrText );
               i += 1;
               @@Cosg = %subst( ErrText : i : 4 );
               %subst(wrepl:1:4) =  %trim( @@Cosg );

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0189'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

               peErro = -1;
               return;
           endsl;
         endif;
       endfor;

       if not COWVEH_updScoring( peBase
                               : peNctw
                               : peRama
                               : p1Arse
                               : pePoco
                               : peTaaj
                               : @@Item );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'EMI0000'
                      : peMsgs );

         peErro = -1;
         return;
       endif;

       return;

      /end-free

     P COWVEH_aplicaScoring...
     P                 E

      * ---------------------------------------------------------------- *
      * COWVEH_cotizarWeb3(): Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones.                            *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peNrpp  -  Plan de Pago                           *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de Iva                          *
      *                peAcce  -  Lista de Accesorios                    *
      *                peDesE  -  Descuento Especial                     *
      *                peTaaj  -  Código de Cuestionario                 *
      *                peScor  -  Estructura de Preguntas                *
      *        Output:                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  Bonificaciones por cobertura           *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_cotizarWeb3...
     P                 B                   export
     D COWVEH_cotizarWeb3...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peNrpp                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peDesE                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0

     D @@Cfpg          s              1  0

      /free

       COWVEH_inz();

       peErro = *Zeros;

       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ):'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl)) );

           peErro = -1;
           return;

       endif;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase
                                                             : peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrpp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;
       endif;

       COWVEH_chkCotizar ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco
                         : peVhan
                         : peVhmc
                         : peVhmo
                         : peVhcs
                         : peVhvu
                         : peMgnc
                         : peRgnc
                         : peCopo
                         : peCops
                         : peScta
                         : peClin
                         : peBure
                         : @@Cfpg
                         : peTipe
                         : peCiva
                         : peImpu
                         : peAcce
                         : peDesE
                         : peTaaj
                         : peScor
                         : peErro
                         : peMsgs );

       if peErro <> *Zeros;
         return;
       endif;

       //Elimino info de la cotización.
       COWGRAI_deletePoco ( peBase : peNctw : peRama : peArse : pePoco );

       COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );

       //Cotizamos
       clear peCtre;
       clear pePaxc;
       clear peBoni;

       COWVEH_cotizador  ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco
                         : peVhan
                         : peVhmc
                         : peVhmo
                         : peVhcs
                         : peVhvu
                         : peMgnc
                         : peRgnc
                         : peCopo
                         : peCops
                         : peScta
                         : peClin
                         : peBure
                         : @@Cfpg
                         : peTipe
                         : peCiva
                         : peNrpp
                         : peAcce
                         : peDesE
                         : peTaaj
                         : peScor
                         : peCtre
                         : pePaxc
                         : peBoni
                         : peImpu
                         : peErro
                         : peMsgs );

       return;

      /end-free

     P COWVEH_cotizarWeb3...
     P                 E

      * ---------------------------------------------------------------- *
      * COWVEH_reCotizarWeb3: Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones.                            *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peNrpp  -  Plan de Pago                           *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de Iva                          *
      *                peAcce  -  Lista de Accesorios                    *
      *                peDesE  -  Descuento Especial                     *
      *                peTaaj  -  Código de Cuestionario                 *
      *                peScor  -  Estructura de Preguntas                *
      *        Output:                                                   *
      *                peCtre  -  Código de Tarifa                       *
      *                pePaxc  -  Coberturas Prima a Premio              *
      *                peBoni  -  Bonificaciones por cobertura           *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_reCotizarWeb3...
     P                 B                   export
     D COWVEH_reCotizarWeb3...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peNrpp                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peAcce                            likeds( AccVeh_t ) dim(100) const
     D   peDesE                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh)  dim(20)
     D   peBoni                            likeds(bonVeh)  dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2

     D @@Cfpg          s              1  0

      /free

       COWVEH_inz();

       //Valido Estado ReCotización
       if COWGRAI_chkEstCotizacion ( peBase : peNctw ) = *off;
         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTTR = ErrCode;

           %subst(wrepl:1:7)  = %editc(peNctw:'X');
           %subst(wrepl:9:1)  = %editc(peBase.peNivt:'X');
           %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0037'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl)) );

         endif;
         return;
       endif;

       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ):'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl)) );

           peErro = -1;
           return;

       endif;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase
                                                             : peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc( peNrpp : 'X' );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );

           peErro = -1;
           return;
       endif;

       COWVEH_chkCotizar ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco
                         : peVhan
                         : peVhmc
                         : peVhmo
                         : peVhcs
                         : peVhvu
                         : peMgnc
                         : peRgnc
                         : peCopo
                         : peCops
                         : peScta
                         : peClin
                         : peBure
                         : @@Cfpg
                         : peTipe
                         : peCiva
                         : peImpu
                         : peAcce
                         : peDesE
                         : peTaaj
                         : peScor
                         : peErro
                         : peMsgs );


       if peErro <> *Zeros;
         return;
       endif;


       //Elimino info de la cotización.

       COWGRAI_deletePoco ( peBase : peNctw : peRama : peArse : pePoco );


       //Cotizamos

       COWVEH_cotizador ( peBase
                        : peNctw
                        : peRama
                        : peArse
                        : pePoco
                        : peVhan
                        : peVhmc
                        : peVhmo
                        : peVhcs
                        : peVhvu
                        : peMgnc
                        : peRgnc
                        : peCopo
                        : peCops
                        : peScta
                        : peClin
                        : peBure
                        : @@Cfpg
                        : peTipe
                        : peCiva
                        : peNrpp
                        : peAcce
                        : peDesE
                        : peTaaj
                        : peScor
                        : peCtre
                        : pePaxc
                        : peBoni
                        : peImpu
                        : peErro
                        : peMsgs );

       return;

      /end-free

     P COWVEH_reCotizarWeb3...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkScoringEnCotizacion(): Retorna si existe Cotizaci- *
      *                                  ón guardada o vigente de    *
      *                                  Scoring.                    *
      *                                                              *
      *        Input :                                               *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peTaaj  -  Código de Cuestionario             *
      *                peCosg  -  Código de Pregunta      (Opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = No Encontro              *
      * -------------------------------------------------------------*
     P COWVEH_chkScoringEnCotizacion...
     P                 B                   export
     D COWVEH_chkScoringEnCotizacion...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTaaj                       2  0 const
     D   peCosg                       4    options( *nopass : *omit ) const

     D k1yet3          ds                  likerec( c1wet301 : *key )
     D @@DsCtw         ds                  likeds(dsctw000_t)
     D peBase          ds                  likeds(paramBase)
     D @@Fech          s              8  0

      /free

       COWVEH_inz();

       clear @@DsCtw;
       @@Fech = %dec(%date);

       k1yet3.t3Empr = peEmpr;
       k1yet3.t3Sucu = peSucu;
       k1yet3.t3Taaj = peTaaj;

       if %parms >= 4 and %addr(peCosg) <> *null;
         k1yet3.t3Cosg = peCosg;
         setll %kds( k1yet3 : 4 ) ctwet301;
         reade %kds( k1yet3 : 4 ) ctwet301;
       else;
         setll %kds( k1yet3 : 3 ) ctwet301;
         reade %kds( k1yet3 : 3 ) ctwet301;
       endif;

       dow not %eof( ctwet301 );

         peBase.peEmpr = peEmpr;
         peBase.peSucu = peSucu;
         peBase.peNivt = t3Nivt;
         peBase.peNivc = t3Nivc;
         peBase.peNit1 = t3Nivt;
         peBase.peNiv1 = t3Nivc;

         if COWGRAI_getCtw000( peBase
                             : t3Nctw
                             : @@DsCtw );

           select;
             when @@Dsctw.w0Cest = 1 and @@Dsctw.w0Cses = 2;
               return *on;
             when @@Dsctw.w0Cest = 1 and @@Dsctw.w0Cses = 1 and
                  @@Fech = @@Dsctw.w0Fctw;
               return *on;
             other;
               return *off;
           endsl;
         endif;

         if %parms >= 4 and %addr(peCosg) <> *null;
           reade %kds( k1yet3 : 4 ) ctwet301;
         else;
           reade %kds( k1yet3 : 3 ) ctwet301;
         endif;
       enddo;

       return *off;

      /end-free

     P COWVEH_chkScoringEnCotizacion...
     P                 E

      * ---------------------------------------------------------------- *
      * COWVEH_getPorcCob2():devuelve dependiendo de la letra el % de    *
      *                     cobertura de accidente, incendio y Robo.     *
      *        Input :                                                   *
      *                                                                  *
      *                peTair  -  número de tabla air                    *
      *                peScta  -  sub-tabla air                          *
      *                peMone  -  codigo de moneda                       *
      *                peVhan  -  año del vehículo                       *
      *                peVhca  -  capitulo del vehículo                  *
      *                peVhv2  -  capitulo variante air                  *
      *                peCobl  -  Cobertura                              *
      *                pePcox  -  0/00 cobertura                         *
      *                pePacx  -  % accidentes                           *
      *                pePinx  -  % incendio                             *
      *                peProx  -  % robo                                 *
      *                peIfrx  -  Franquicia                             *
      *                peCtre  -  Codigo de Tarifa                       *
      *                peMtdf  -  Marca de Tarifa Diferencial            *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWVEH_getPorcCob2...
     P                 B                   export
     D COWVEH_getPorcCob2...
     D                 pi              n
     D   peTair                       2  0 const
     D   peScta                       1  0 const
     D   peMone                       2    const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const
     D   peCobl                       2    const
     D   peCoss                       2    const
     D   pePcox                       7  4
     D   pePacx                       7  4
     D   pePinx                       7  4
     D   peProx                       7  4
     D   peiFrx                      15  2
     D   peCtre                       5  0 const
     D   peMtdf                       1a   const

      /free

       COWVEH_inz();

       if COWVEH_getPorceCob( peTair
                            : peScta
                            : peMone
                            : peVhan
                            : peVhvu
                            : peVhca
                            : peVhv1
                            : peVhv2
                            : peCobl
                            : peCoss
                            : pePcox
                            : pePacx
                            : pePinx
                            : peProx
                            : peiFrx
                            : peCtre
                            : peMtdf );
         return *on;
       endif;

       return *off;

      /end-free

     P COWVEH_getPorcCob2...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkEndoso(): Valida si poliza a modificar aplica      *
      *                     para ser endosada                        *
      *                                                              *
      *     peBase  ( input  )  Parametros Base                      *
      *     peArcd  ( input  )  Codigo Articulo                      *
      *     peSpol  ( input  )  Numero Superpoliza                   *
      *     peRama  ( input  )  Codigo Rama                          *
      *     peArse  ( input  )  Numero Polizas por Rama              *
      *     peOper  ( input  )  Numero Operacion                     *
      *     pePoli  ( input  )  Numero Poliza                        *
      *     peUser  ( input  )  Usuario                              *
      *     peTiou  ( input  )  Tipo de operacion                    *
      *     peStou  ( input  )  Subtipo Usuario                      *
      *     peStos  ( input  )  subtipo Sistema                      *
      *     peErro  ( output )  Indicador de Error                   *
      *     peMsgs  ( output )  Estructura de Error                  *
      *                                                              *
      * Retorna *off = Error / *on = Valida Ok                       *
      * -------------------------------------------------------------*
     p COWVEH_chkEndoso...
     p                 B                   export
     d COWVEH_chkEndoso...
     d                 pi              n
     d  peBase                             const likeds(paramBase)
     d  peArcd                        6  0 const
     d  peSpol                        9  0 const
     d  peRama                        2  0 const
     d  peArse                        2  0 const
     d  peOper                        7  0 const
     d  pePoli                        7  0 const
     d  peUser                       50    const
     d  peTiou                        1  0 const
     d  peStou                        2  0 const
     d  peStos                        2  0 const
     d  peErro                       10i 0
     d  peMsgs                             likeds(paramMsgs)

     d  @@a            s              4  0
     d  @@m            s              2  0
     d  @@d            s              2  0
     d  @@femi         s              8  0
     d  wsrepl         s          65535a
     d  @@erro         s               n
     d  @@mens         s            512
     d  peVsys         s            512
     d  @@valweb       s              1
     d  @@msgID        s              7
     d  @@nrpp         s              3  0

     d  k1w00003       ds                  likerec(c1w00003:*key)

      /free

        COWVEH_inz();

        clear peMsgs;
        clear peErro;

        PAR310X3( peBase.peEmpr : @@a : @@m : @@d);
        @@femi = (@@a * 10000) + (@@m * 100) + @@d;

        if SVPVLS_getValSys( 'HEASVALWEB' : *omit : peVsys);
           @@valweb = %subst(%trim(peVsys):1:1);
        endif;

        //Valido ParmBase
        if not SVPWS_chkParmBase ( peBase : peMsgs );
           peErro = -1;
           return *off;
        endif;

        if not SVPVAL_rama( peRama );

          ErrText = SVPVAL_Error(ErrCode);
          clear wsrepl;
          %subst(wsrepl:1:2) = %editc(peRama:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0019'
                       : peMsgs
                       : %trim(wsrepl)
                       : %len(%trim(wsrepl))  );

          peErro = -1;
          return *off;

        endif;

        if not SVPVAL_articulo( peArcd );

          if SVPVAL_ARTNE = ErrCode;
             ErrText = SVPVAL_Error(ErrCode);
             clear wsrepl;
             %subst(wrepl:1:6) = %editc(peArcd:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0000'
                          : peMsgs
                          : %trim(wsrepl)
                          : %len(%trim(wsrepl))  );

             peErro = -1;
             return *off;
          endif;

          if SVPVAL_ARTBL = ErrCode;
             ErrText = SVPVAL_Error(ErrCode);
             clear wsrepl;
             %subst(wsrepl:1:6)  = %editc(peArcd:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0001'
                          : peMsgs
                          : %trim(wsrepl)
                          : %len(%trim(wsrepl))  );

             peErro = -1;
             return *off;
          endif;
        endif;

        if not SVPVAL_arcdRamaArse( peArcd : peRama : peArse );
          clear wsrepl;
          %subst( wsrepl : 1 : 6 ) = %editc( peArcd : 'X' );
          %subst( wsrepl : 7 : 2 ) = %editc( peRama : 'X' );
          %subst( wsrepl : 9 : 2 ) = %editc( peArse : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0111'
                       : peMsgs
                       : %trim(wsrepl)
                       : %len(%trim(wsrepl)) );
          peErro = -1;
          return *off;

        endif;

        if not SVPVAL_tipoDeOperacion( peTiou : peStou : peStos );
          clear wsrepl;
          %subst( wsrepl : 1 : 1 ) = %editc( peTiou : 'X' );
          %subst( wsrepl : 2 : 2 ) = %editc( peStou : 'X' );
          %subst( wsrepl : 4 : 2 ) = %editc( peStos : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0006'
                       : peMsgs
                       : %trim(wsrepl)
                       : %len(%trim(wsrepl)) );
          peErro = -1;
          return *off;

        endif;

        if not SPVSPO_chkSpol( peBase.peEmpr
                             : peBase.peSucu
                             : peArcd
                             : peSpol );
          clear wsrepl;
          %subst( wsrepl : 1 :  6 ) = %editc( peArcd : 'X' );
          %subst( wsrepl : 7 : 15 ) = %editc( peSpol : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0017'
                       : peMsgs
                       : %trim(wsrepl)
                       : %len(%trim(wsrepl)) );
          peErro = -1;
          return *off;

        endif;

        // Validar poliza vigente - SPVIG2
        if not SPVSPO_chkVig( peBase.peEmpr
                            : peBase.peSucu
                            : peArcd
                            : peSpol
                            : @@femi
                            : @@femi         );
          clear wsrepl;
          %subst(wsrepl:1:6) = %char(peArcd);
          %subst(wsrepl:7:9) = %char(peSpol);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0016'
                       : peMsgs
                       : %trim(wsrepl)
                       : %len(%trim(wsrepl)) );
          peErro = -1;
          return *Off;

        endif;

        // Validar si poliza tiene movimientos pendientes - PAR317V
        @@erro = *off;
        clear @@mens;
        PAR317V( peBase.peEmpr
               : peBase.peSucu
               : peArcd
               : peSpol
               : peRama
               : pePoli
               : @@erro
               : @@mens );

        if not @@erro;
           clear wsrepl;
           Select;
             when %subst(%trim(@@mens) :1 :4) = '0001';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  %subst(wrepl:8:17) = 'GAUS';
                  @@msgID = 'POL0018';

             when %subst(%trim(@@mens):1 :4) = '0002';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  %subst(wrepl:8:17) = 'SPEEDWAY';
                  @@msgID = 'POL0018';

             when %subst(%trim(@@mens):1 :4) = '0003';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  @@msgID = 'POL0019';

             when %subst(%trim(@@mens):1 :4) = '0004';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  @@msgID = 'POL0020';

             when %subst(%trim(@@mens):1 :4) = '0005';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  @@nrpp = SPVSPO_getCodPlanDePago( peBase.peEmpr
                                                  : peBase.peSucu
                                                  : peArcd
                                                  : peSpol        );

                  %subst(wrepl:8:47) =
                  %subst(%trim(SVPDES_planDePago( @@nrpp )):1 : 30);
                  @@msgID = 'POL0021';

             when %subst(%trim(@@mens):1 :4) = '0006';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  @@msgID = 'POL0022';

             when %subst(%trim(@@mens):1 :4) = '0007';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  @@msgID = 'POL0023';

             when %subst(%trim(@@mens):1 :4) = '0008';
                  %subst(wrepl:1:7) = %editc( pePoli :'X');
                  @@msgID = 'POL0024';

           other;
             @@msgID = 'POL0017';
           endsl;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : @@msgID
                       : peMsgs
                       : %trim(wsrepl)
                       : %len(%trim(wsrepl)) );
          peErro = -1;
          return *Off;

        endif;

        // Validar si poliza tiene movimientos pendientes en CTW00003
        k1w00003.w0arcd = peArcd;
        k1w00003.w0spol = peSpol;
        k1w00003.w0empr = peBase.peEmpr;
        k1w00003.w0sucu = peBase.peSucu;
        k1w00003.w0nivt = peBase.peNivt;
        k1w00003.w0nivc = peBase.peNivc;
        setgt %kds(k1w00003:6) ctw00003;
        readpe %kds(k1w00003:6) ctw00003;
        if not %eof( ctw00003 );
          if ( w0cest = 1 and w0cses  = 1 ) or
             ( w0cest = 1 and w0cses  = 2 ) or
             ( w0cest = 5 and w0cses  = 3 ) or
             ( w0cest = 5 and w0cses  = 4 ) or
             ( w0cest = 7 and w0cses  = 4 ) or
             ( w0cest = 7 and w0cses  = 5 );

            clear wsrepl;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0180'
                         : peMsgs
                         : %trim(wsrepl)
                         : %len(%trim(wsrepl)) );
            peErro = -1;
            return *off;

          endif;
        endif;



       if @@valweb <> 'N';

          if not SVPVAL_articuloWeb ( peArcd );

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

          if not SVPVAL_tipoDeOperacionWeb ( peTiou : peStou : peStos );

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

       endif;

       return *on;

      /end-free

     p COWVEH_chkEndoso...
     p                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkCtwet4(): Valida si existen Descuentos             *
      *                                                              *
      *    peBase   ( input  )  Base                                 *
      *    peNctw   ( input  )  Nro. Cotización                      *
      *    peRama   ( input  )  Rama                    ( opcional ) *
      *    peArse   ( input  )  Secuencia articulo rama ( opcional ) *
      *    pePoco   ( input  )  Nro de Componente       ( opcional ) *
      *    peCobl   ( input  )  Codigo de Cobertura     ( opcional ) *
      *    peCcbp   ( input  )  Codigo de descuento     ( opcional ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWVEH_chkCtwet4...
     P                 B                   export
     D COWVEH_chkCtwet4...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   pePoco                       4  0 options( *omit : *nopass ) const
     D   peCobl                       2    options( *omit : *nopass ) const
     D   peCcbp                       3  0 options( *omit : *nopass ) const

     D   k1yet4        ds                  likerec( c1wet4 : *key )

      /free

       COWVEH_inz();

       k1yet4.t4empr = peBase.peEmpr;
       k1yet4.t4sucu = peBase.peSucu;
       k1yet4.t4nivt = peBase.peNivt;
       k1yet4.t4nivc = peBase.peNivc;
       k1yet4.t4nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peCobl ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCcbp ) <> *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;
                  k1yet4.t4poco = pePoco;
                  k1yet4.t4cobl = peCobl;
                  k1yet4.t4ccbp = peCcbp;

                  setll %kds( k1yet4 : 10 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCobl ) <> *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;
                  k1yet4.t4poco = pePoco;
                  k1yet4.t4cobl = peCobl;

                  setll %kds( k1yet4 : 9 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCobl ) =  *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;
                  k1yet4.t4poco = pePoco;

                  setll %kds( k1yet4 : 8 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCobl ) =  *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;

                  setll %kds( k1yet4 : 7 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCobl ) =  *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;

                  setll %kds( k1yet4 : 6 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
            other;
                  setll %kds( k1yet4 : 5 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
          endsl;
       else;
         setll %kds( k1yet4 : 5 ) ctwet4;
         if not %equal ( ctwet4 );
            return *off;
         endif;
       endif;

       return *on;

      /end-free

     P COWVEH_chkCtwet4...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_getCtwet4(): Obtener Listado de Descuentos            *
      *                                                              *
      *    peBase   ( input  )  Base                                 *
      *    peNctw   ( input  )  Nro. Cotización                      *
      *    peRama   ( input  )  Rama                    ( opcional ) *
      *    peArse   ( input  )  Secuencia articulo rama ( opcional ) *
      *    pePoco   ( input  )  Nro de Componente       ( opcional ) *
      *    peCobl   ( input  )  Codigo de Cobertura     ( opcional ) *
      *    peCcbp   ( input  )  Codigo de descuento     ( opcional ) *
      *    peDsT4   ( input  )  Estructura descuentos   ( opcional ) *
      *    peDsT4c  ( input  )  cantidad de descuentos  ( opcional ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWVEH_getCtwet4...
     P                 B                   export
     D COWVEH_getCtwet4...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   pePoco                       4  0 options( *omit : *nopass ) const
     D   peCobl                       2    options( *omit : *nopass ) const
     D   peCcbp                       3  0 options( *omit : *nopass ) const
     D   peDsT4                            likeds( dsCtwet4_t ) dim( 9999 )
     D                                     options( *omit : *nopass )
     D   peDsT4c                     10i 0 options( *omit : *nopass )

     D   @@DsT4        ds                  likeds( dsCtwet4_t ) dim( 9999 )
     D   @@DsT4C       s             10i 0
     D   @@DsIt4       ds                  likerec( c1wet4 : *input )
     D   k1yet4        ds                  likerec( c1wet4 : *key )

      /free

       COWVEH_inz();

       clear @@DsT4;
       clear @@DsT4C;
       clear @@DsIt4;

       k1yet4.t4empr = peBase.peEmpr;
       k1yet4.t4sucu = peBase.peSucu;
       k1yet4.t4nivt = peBase.peNivt;
       k1yet4.t4nivc = peBase.peNivc;
       k1yet4.t4nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peCobl ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCcbp ) <> *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;
                  k1yet4.t4poco = pePoco;
                  k1yet4.t4cobl = peCobl;
                  k1yet4.t4ccbp = peCcbp;

                  setll %kds( k1yet4 : 10 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet4 : 10 ) ctwet4 @@DsIT4;
                  dow not %eof( ctwet4 );
                    @@DsT4C +=1;
                    eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
                   reade(n) %kds( k1yet4 : 10 ) ctwet4 @@DsIT4;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCobl ) <> *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;
                  k1yet4.t4poco = pePoco;
                  k1yet4.t4cobl = peCobl;

                  setll %kds( k1yet4 : 9 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet4 : 9 ) ctwet4 @@DsIT4;
                  dow not %eof( ctwet4 );
                    @@DsT4C +=1;
                    eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
                   reade(n) %kds( k1yet4 : 9 ) ctwet4 @@DsIT4;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCobl ) =  *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;
                  k1yet4.t4poco = pePoco;

                  setll %kds( k1yet4 : 8 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet4 : 8 ) ctwet4 @@DsIT4;
                  dow not %eof( ctwet4 );
                    @@DsT4C +=1;
                    eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
                   reade(n) %kds( k1yet4 : 8 ) ctwet4 @@DsIT4;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCobl ) =  *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;
                  k1yet4.t4arse = peArse;

                  setll %kds( k1yet4 : 7 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet4 : 7 ) ctwet4 @@DsIT4;
                  dow not %eof( ctwet4 );
                    @@DsT4C +=1;
                    eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
                   reade(n) %kds( k1yet4 : 7 ) ctwet4 @@DsIT4;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCobl ) =  *null and
                  %addr( peCcbp ) =  *null;

                  k1yet4.t4rama = peRama;

                  setll %kds( k1yet4 : 6 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet4 : 6 ) ctwet4 @@DsIT4;
                  dow not %eof( ctwet4 );
                    @@DsT4C +=1;
                    eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
                   reade(n) %kds( k1yet4 : 6 ) ctwet4 @@DsIT4;
                  enddo;
            other;
                  setll %kds( k1yet4 : 5 ) ctwet4;
                  if not %equal ( ctwet4 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet4 : 5 ) ctwet4 @@DsIT4;
                  dow not %eof( ctwet4 );
                    @@DsT4C +=1;
                    eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
                   reade(n) %kds( k1yet4 : 5 ) ctwet4 @@DsIT4;
                  enddo;
          endsl;
       else;
         setll %kds( k1yet4 : 5 ) ctwet4;
         if not %equal ( ctwet4 );
            return *off;
         endif;
         reade(n) %kds( k1yet4 : 5 ) ctwet4 @@DsIT4;
         dow not %eof( ctwet4 );
           @@DsT4C +=1;
           eval-corr @@DsT4( @@DsT4C ) = @@DsIT4;
          reade(n) %kds( k1yet4 : 5 ) ctwet4 @@DsIT4;
         enddo;
       endif;

       if %parms >= 3 and %addr( peDsT4 ) <> *null;
          eval-corr peDst4 = @@DsT4 ;
       endif;

       if %parms >= 3 and %addr( peDsT4C ) <> *null;
          peDst4C = @@Dst4C;
       endif;

       return *on;

      /end-free

     P COWVEH_getCtwet4...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_setCtwet4(): Grabar informacion de descuentos         *
      *                                                              *
      *    peDsT4   ( input  )  Estructura descuentos   ( opcional ) *
      *                                                              *
      * Retorna *on = Grabo OK / *off = No Grabo                     *
      * ------------------------------------------------------------ *
     P COWVEH_setCtwet4...
     P                 B                   export
     D COWVEH_setCtwet4...
     D                 pi              n
     D   peDsT4                            likeds ( dsCtwet4_t ) const
     D   @@DsOt4       ds                  likerec( c1wet4 : *output )
     D   @@base        ds                  likeds ( paramBase )

      /free

       COWVEH_inz();
       clear @@base;
       @@base.peEmpr = peDst4.t4empr;
       @@base.peSucu = peDst4.t4sucu;
       @@base.peNivt = peDst4.t4nivt;
       @@base.peNivc = peDst4.t4nivc;

       if COWVEH_chkCtwet4( @@base
                          : peDsT4.t4nctw
                          : peDsT4.t4rama
                          : peDsT4.t4arse
                          : peDsT4.t4poco
                          : peDsT4.t4cobl
                          : peDsT4.t4ccbp  );
         return *off;
       endif;

       eval-corr @@DsOT4 = peDsT4;
       monitor;
         write c1wet4 @@DsOT4;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_setCtwet4...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_updCtwet4(): Actualiza informacion de descuentos      *
      *                                                              *
      *    peDsT4   ( input  )  Estructura descuentos   ( opcional ) *
      *                                                              *
      * Retorna *on = Grabo OK / *off = No Grabo                     *
      * ------------------------------------------------------------ *
     P COWVEH_updCtwet4...
     P                 B                   export
     D COWVEH_updCtwet4...
     D                 pi              n
     D   peDsT4                            likeds( dsCtwet4_t ) const

     D   @@DsOt4       ds                  likerec( c1wet4 : *output )
     D   k1yet4        ds                  likerec( c1wet4 : *key    )

      /free

       COWVEH_inz();

       k1yet4.t4empr = peDsT4.t4empr;
       k1yet4.t4sucu = peDsT4.t4sucu;
       k1yet4.t4nivt = peDsT4.t4nivt;
       k1yet4.t4nivc = peDsT4.t4nivc;
       k1yet4.t4nctw = peDsT4.t4nctw;
       k1yet4.t4rama = peDsT4.t4rama;
       k1yet4.t4arse = peDsT4.t4arse;
       k1yet4.t4poco = peDsT4.t4poco;
       k1yet4.t4cobl = peDsT4.t4cobl;
       k1yet4.t4ccbp = peDsT4.t4ccbp;
       chain %kds( k1yet4 : 10 ) ctwet4;
       if not %found( ctwet4 );
         return *off;
       endif;

       eval-corr @@DsOT4 = peDsT4;

       monitor;
         update c1wet4 @@DsOT4;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_updCtwet4...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkCtwet0(): Valida si existen Vehiculo               *
      *                                                              *
      *    peBase   ( input  )  Base                                 *
      *    peNctw   ( input  )  Nro. Cotización                      *
      *    peRama   ( input  )  Rama                    ( opcional ) *
      *    pePoco   ( input  )  Nro de Componente       ( opcional ) *
      *    peArse   ( input  )  Secuencia articulo rama ( opcional ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWVEH_chkCtwet0...
     P                 B                   export
     D COWVEH_chkCtwet0...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   pePoco                       4  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const

     D   k1yet0        ds                  likerec( c1wet0 : *key )

      /free

       COWVEH_inz();

       k1yet0.t0empr = peBase.peEmpr;
       k1yet0.t0sucu = peBase.peSucu;
       k1yet0.t0nivt = peBase.peNivt;
       k1yet0.t0nivc = peBase.peNivc;
       k1yet0.t0nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peArse ) <> *null;

                  k1yet0.t0rama = peRama;
                  k1yet0.t0poco = pePoco;
                  k1yet0.t0arse = peArse;

                  setll %kds( k1yet0 : 8 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peArse ) =  *null ;

                  k1yet0.t0rama = peRama;
                  k1yet0.t0poco = pePoco;

                  setll %kds( k1yet0 : 7 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( pePoco ) =  *null and
                  %addr( peArse ) =  *null ;

                  k1yet0.t0rama = peRama;

                  setll %kds( k1yet0 : 6 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;
            other;
                  setll %kds( k1yet0 : 5 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;
          endsl;
       else;
         setll %kds( k1yet0 : 5 ) ctwet0;
         if not %equal ( ctwet0 );
            return *off;
         endif;
       endif;

       return *on;

      /end-free

     P COWVEH_chkCtwet0...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_getCtwet0(): Obtener Listado de Vehiculos             *
      *                                                              *
      *    peBase   ( input  )  Base                                 *
      *    peNctw   ( input  )  Nro. Cotización                      *
      *    peRama   ( input  )  Rama                    ( opcional ) *
      *    pePoco   ( input  )  Nro de Componente       ( opcional ) *
      *    peArse   ( input  )  Secuencia articulo rama ( opcional ) *
      *    peDsT0   ( input  )  Estructura vehiculos    ( opcional ) *
      *    peDsT0c  ( input  )  cantidad de vehiculos   ( opcional ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWVEH_getCtwet0...
     P                 B                   export
     D COWVEH_getCtwet0...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   pePoco                       4  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   peDsT0                            likeds( dsCtwet0_t ) dim( 9999 )
     D                                     options( *omit : *nopass )
     D   peDsT0c                     10i 0 options( *omit : *nopass )

     D   @@DsT0        ds                  likeds( dsCtwet0_t ) dim( 9999 )
     D   @@DsT0C       s             10i 0
     D   @@DsIt0       ds                  likerec( c1wet0 : *input )
     D   k1yet0        ds                  likerec( c1wet0 : *key )

      /free

       COWVEH_inz();

       clear @@DsT0;
       clear @@DsT0C;
       clear @@DsIt0;

       k1yet0.t0Empr = peBase.peEmpr;
       k1yet0.t0Sucu = peBase.peSucu;
       k1yet0.t0Nivt = peBase.peNivt;
       k1yet0.t0Nivc = peBase.peNivc;
       k1yet0.t0Nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peArse ) <> *null;

                  k1yet0.t0rama = peRama;
                  k1yet0.t0poco = pePoco;
                  k1yet0.t0arse = peArse;

                  setll %kds( k1yet0 : 8 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet0 : 8 ) ctwet0 @@DsIT0;
                  dow not %eof( ctwet0 );
                    @@DsT0C +=1;
                    eval-corr @@DsT0( @@DsT0C ) = @@DsIT0;
                   reade(n) %kds( k1yet0 : 8 ) ctwet0 @@DsIT0;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peArse ) =  *null ;

                  k1yet0.t0rama = peRama;
                  k1yet0.t0poco = pePoco;

                  setll %kds( k1yet0 : 7 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet0 : 7 ) ctwet0 @@DsIT0;
                  dow not %eof( ctwet0 );
                    @@DsT0C +=1;
                    eval-corr @@DsT0( @@DsT0C ) = @@DsIT0;
                   reade(n) %kds( k1yet0 : 7 ) ctwet0 @@DsIT0;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( pePoco ) =  *null and
                  %addr( peArse ) =  *null ;

                  k1yet0.t0rama = peRama;

                  setll %kds( k1yet0 : 6 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet0 : 6 ) ctwet0 @@DsIT0;
                  dow not %eof( ctwet0 );
                    @@DsT0C +=1;
                    eval-corr @@DsT0( @@DsT0C ) = @@DsIT0;
                   reade(n) %kds( k1yet0 : 6 ) ctwet0 @@DsIT0;
                  enddo;
            other;
                  setll %kds( k1yet0 : 5 ) ctwet0;
                  if not %equal ( ctwet0 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet0 : 5 ) ctwet0 @@DsIT0;
                  dow not %eof( ctwet0 );
                    @@DsT0C +=1;
                    eval-corr @@DsT0( @@DsT0C ) = @@DsIT0;
                   reade(n) %kds( k1yet0 : 5 ) ctwet0 @@DsIT0;
                  enddo;
          endsl;
       else;
         setll %kds( k1yet0 : 5 ) ctwet0;
         if not %equal ( ctwet0 );
            return *off;
         endif;
         reade(n) %kds( k1yet0 : 5 ) ctwet0 @@DsIT0;
         dow not %eof( ctwet0 );
           @@DsT0C +=1;
           eval-corr @@DsT0( @@DsT0C ) = @@DsIT0;
          reade(n) %kds( k1yet0 : 5 ) ctwet0 @@DsIT0;
         enddo;

       endif;

       if %parms >= 3 and %addr( peDsT0 ) <> *null;
          eval-corr peDst0 = @@DsT0 ;
       endif;

       if %parms >= 3 and %addr( peDsT0C ) <> *null;
          peDst0C = @@Dst0C;
       endif;

       return *on;

      /end-free

     P COWVEH_getCtwet0...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_setCtwet0(): Grabar informacion de Vehiculos          *
      *                                                              *
      *    peDsT0   ( input  )  Estructura descuentos   ( opcional ) *
      *                                                              *
      * Retorna *on = Grabo OK / *off = No Grabo                     *
      * ------------------------------------------------------------ *
     P COWVEH_setCtwet0...
     P                 B                   export
     D COWVEH_setCtwet0...
     D                 pi              n
     D   peDsT0                            likeds ( dsCtwet0_t ) const
     D   @@DsOt0       ds                  likerec( c1wet0 : *output )
     D   @@base        ds                  likeds ( paramBase )

      /free

       COWVEH_inz();
       clear @@base;
       @@base.peEmpr = peDst0.t0empr;
       @@base.peSucu = peDst0.t0sucu;
       @@base.peNivt = peDst0.t0nivt;
       @@base.peNivc = peDst0.t0nivc;

       if COWVEH_chkCtwet0( @@base
                          : peDsT0.t0nctw
                          : peDsT0.t0rama
                          : peDsT0.t0poco
                          : peDsT0.t0arse  );
         return *off;
       endif;

       eval-corr @@DsOT0 = peDsT0;
       monitor;
         write c1wet0 @@DsOT0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_setCtwet0...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_updCtwet0(): Actualiza informacion de Vehiculo        *
      *                                                              *
      *    peDsT0   ( input  )  Estructura descuentos   ( opcional ) *
      *                                                              *
      * Retorna *on = Grabo OK / *off = No Grabo                     *
      * ------------------------------------------------------------ *
     P COWVEH_updCtwet0...
     P                 B                   export
     D COWVEH_updCtwet0...
     D                 pi              n
     D   peDsT0                            likeds( dsCtwet0_t ) const

     D   @@DsOt0       ds                  likerec( c1wet0 : *output )
     D   k1yet0        ds                  likerec( c1wet0 : *key    )

      /free

       COWVEH_inz();

       k1yet0.t0empr = peDsT0.t0empr;
       k1yet0.t0sucu = peDsT0.t0sucu;
       k1yet0.t0nivt = peDsT0.t0nivt;
       k1yet0.t0nivc = peDsT0.t0nivc;
       k1yet0.t0nctw = peDsT0.t0nctw;
       k1yet0.t0rama = peDsT0.t0rama;
       k1yet0.t0poco = peDsT0.t0poco;
       k1yet0.t0arse = peDsT0.t0arse;
       chain %kds( k1yet0 : 8 ) ctwet0;
       if not %found( ctwet0 );
         return *off;
       endif;

       eval-corr @@DsOT0 = peDsT0;

       monitor;
         update c1wet0 @@DsOT0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_updCtwet0...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkCtwetc(): Valida si existen Cobertura por Vehiculo *
      *                                                              *
      *    peBase   ( input  )  Base                                 *
      *    peNctw   ( input  )  Nro. Cotización                      *
      *    peRama   ( input  )  Rama                    ( opcional ) *
      *    pePoco   ( input  )  Nro de Componente       ( opcional ) *
      *    peArse   ( input  )  Secuencia articulo rama ( opcional ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWVEH_chkCtwetc...
     P                 B                   export
     D COWVEH_chkCtwetc...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   pePoco                       4  0 options( *omit : *nopass ) const
     D   peCobl                       2    options( *omit : *nopass ) const

     D   k1yetc        ds                  likerec( c1wetc : *key )

      /free

       COWVEH_inz();

       k1yetc.t0empr = peBase.peEmpr;
       k1yetc.t0sucu = peBase.peSucu;
       k1yetc.t0nivt = peBase.peNivt;
       k1yetc.t0nivc = peBase.peNivc;
       k1yetc.t0nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pepoco ) <> *null and
                  %addr( pecobl ) <> *null;

                  k1yetc.t0rama = peRama;
                  k1yetc.t0arse = peArse;
                  k1yetc.t0poco = pePoco;
                  k1yetc.t0cobl = peCobl;

                  setll %kds( k1yetc : 9 ) ctwetc;
                  if not %equal ( ctwetc );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pepoco ) <> *null and
                  %addr( pecobl ) =  *null;

                  k1yetc.t0rama = peRama;
                  k1yetc.t0arse = peArse;
                  k1yetc.t0poco = pePoco;

                  setll %kds( k1yetc : 8 ) ctwetc;
                  if not %equal ( ctwetc );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pepoco ) =  *null and
                  %addr( pecobl ) =  *null;

                  k1yetc.t0rama = peRama;
                  k1yetc.t0arse = peArse;

                  setll %kds( k1yetc : 7 ) ctwetc;
                  if not %equal ( ctwetc );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( pepoco ) =  *null and
                  %addr( pecobl ) =  *null;

                  k1yetc.t0rama = peRama;

                  setll %kds( k1yetc : 6 ) ctwetc;
                  if not %equal ( ctwetc );
                     return *off;
                  endif;
            other;
                  setll %kds( k1yetc : 5 ) ctwetc;
                  if not %equal ( ctwetc );
                     return *off;
                  endif;
          endsl;
       else;
         setll %kds( k1yetc : 5 ) ctwetc;
         if not %equal ( ctwetc );
            return *off;
         endif;
       endif;

       return *on;

      /end-free

     P COWVEH_chkCtwetc...
     P                 E
      * ------------------------------------------------------------ *
      * COWVEH_setCtwetc(): Grabar informacion de Cobertura por      *
      *                     vehiculo                                 *
      *                                                              *
      *    peDsTC   ( input  )  Estructura Cob. x Vehic.( opcional ) *
      *                                                              *
      * Retorna *on = Grabo OK / *off = No Grabo                     *
      * ------------------------------------------------------------ *
     P COWVEH_setCtwetc...
     P                 B                   export
     D COWVEH_setCtwetc...
     D                 pi              n
     D   peDsTC                            likeds ( dsCtwetC_t ) const
     D   @@DsOtC       ds                  likerec( c1wetc : *output )
     D   @@base        ds                  likeds ( paramBase )

      /free

       COWVEH_inz();
       clear @@base;
       @@base.peEmpr = peDsTc.t0empr;
       @@base.peSucu = peDsTc.t0sucu;
       @@base.peNivt = peDsTc.t0nivt;
       @@base.peNivc = peDsTc.t0nivc;

       if COWVEH_chkCtwetc( @@base
                          : peDsTc.t0nctw
                          : peDsTc.t0rama
                          : peDsTc.t0arse
                          : peDsTc.t0poco
                          : peDsTc.t0cobl );
         return *off;
       endif;

       eval-corr @@DsOTc = peDsTc;
       monitor;
         write c1wetc @@DsOTc;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_setCtwetc...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_chkCtwet5(): Valida si existen Carta de daños/restri- *
      *                     ciones de cobertura                      *
      *                                                              *
      *    peBase   ( input  )  Base                                 *
      *    peNctw   ( input  )  Nro. Cotización                      *
      *    peRama   ( input  )  Rama                    ( opcional ) *
      *    peArse   ( input  )  Secuencia articulo rama ( opcional ) *
      *    pePoco   ( input  )  Nro de Componente       ( opcional ) *
      *    peCdañ   ( input  )  Código de Daño          ( opcional ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWVEH_chkCtwet5...
     P                 B                   export
     D COWVEH_chkCtwet5...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   pePoco                       4  0 options( *omit : *nopass ) const
     D   peCdaÑ                       4  0 options( *omit : *nopass ) const

     D   k1yet5        ds                  likerec( c1wet5 : *key )

      /free

       COWVEH_inz();

       k1yet5.t5empr = peBase.peEmpr;
       k1yet5.t5sucu = peBase.peSucu;
       k1yet5.t5nivt = peBase.peNivt;
       k1yet5.t5nivc = peBase.peNivc;
       k1yet5.t5nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCdaÑ ) <> *null;

                  k1yet5.t5Rama = peRama;
                  k1yet5.t5Arse = peArse;
                  k1yet5.t5Poco = pePoco;
                  k1yet5.t5CdaÑ = peCdaÑ;

                  setll %kds( k1yet5 : 9 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCdaÑ ) =  *null;

                  k1yet5.t5Rama = peRama;
                  k1yet5.t5Arse = peArse;
                  k1yet5.t5Poco = pePoco;

                  setll %kds( k1yet5 : 8 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCdaÑ ) =  *null;

                  k1yet5.t5Rama = peRama;
                  k1yet5.t5Arse = peArse;

                  setll %kds( k1yet5 : 7 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCdaÑ ) =  *null;

                  k1yet5.t5Rama = peRama;

                  setll %kds( k1yet5 : 6 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;
            other;
                  setll %kds( k1yet5 : 5 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;
          endsl;
       else;
         setll %kds( k1yet5 : 5 ) ctwet5;
         if not %equal ( ctwet5 );
            return *off;
         endif;
       endif;

       return *on;

      /end-free

     P COWVEH_chkCtwet5...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_setCtwet5(): Grabar informacion de Carta de daño y    *
      *                     restriccione de cobertura                *
      *                                                              *
      *    peDsT5   ( input  )  Estructura de Daños.    ( opcional ) *
      *                                                              *
      * Retorna *on = Grabo OK / *off = No Grabo                     *
      * ------------------------------------------------------------ *
     P COWVEH_setCtwet5...
     P                 B                   export
     D COWVEH_setCtwet5...
     D                 pi              n
     D   peDsT5                            likeds ( dsCtwet5_t ) const

     D   @@DsOt5       ds                  likerec( c1wet5 : *output )
     D   @@base        ds                  likeds ( paramBase )

      /free

       COWVEH_inz();

       clear @@base;
       @@base.peEmpr = peDsT5.t5empr;
       @@base.peSucu = peDsT5.t5sucu;
       @@base.peNivt = peDsT5.t5nivt;
       @@base.peNivc = peDsT5.t5nivc;

       if COWVEH_chkCtwet5( @@base
                          : peDsT5.t5nctw
                          : peDsT5.t5rama
                          : peDsT5.t5arse
                          : peDsT5.t5poco
                          : peDsT5.t5cdaÑ );
         return *off;
       endif;

       eval-corr @@DsOT5 = peDsT5;
       monitor;
         write c1wet5 @@DsOT5;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_setCtwet5...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_getCtwet5(): Obtener datos de carta de daños y restri-*
      *                     cciones de cobertura
      *                                                              *
      *    peBase   ( input  )  Base                                 *
      *    peNctw   ( input  )  Nro. Cotización                      *
      *    peRama   ( input  )  Rama                    ( opcional ) *
      *    peArse   ( input  )  Secuencia articulo rama ( opcional ) *
      *    pePoco   ( input  )  Nro de Componente       ( opcional ) *
      *    peCdaÑ   ( input  )  Código de Daño          ( opcional ) *
      *    peDsT5   ( input  )  Estructura de Daños     ( opcional ) *
      *    peDsT5c  ( input  )  cantidad de Daños       ( opcional ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     P COWVEH_getCtwet5...
     P                 B                   export
     D COWVEH_getCtwet5...
     D                 pi              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   pePoco                       4  0 options( *omit : *nopass ) const
     D   peCdaÑ                       4  0 options( *omit : *nopass ) const
     D   peDsT5                            likeds( dsCtwet5_t ) dim( 9999 )
     D                                     options( *omit : *nopass )
     D   peDsT5c                     10i 0 options( *omit : *nopass )

     D   @@DsT5        ds                  likeds( dsCtwet5_t ) dim( 9999 )
     D   @@DsT5C       s             10i 0
     D   @@DsIt5       ds                  likerec( c1wet5 : *input )
     D   k1yet5        ds                  likerec( c1wet5 : *key )

      /free

       COWVEH_inz();

       clear @@DsT5;
       clear @@DsT5C;
       clear @@DsIt5;

       k1yet5.t5Empr = peBase.peEmpr;
       k1yet5.t5Sucu = peBase.peSucu;
       k1yet5.t5Nivt = peBase.peNivt;
       k1yet5.t5Nivc = peBase.peNivc;
       k1yet5.t5Nctw = peNctw;

       if %parms >= 3;
          Select;
            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCdaÑ ) <> *null;

                  k1yet5.t5rama = peRama;
                  k1yet5.t5arse = peArse;
                  k1yet5.t5poco = pePoco;
                  k1yet5.t5CdaÑ = peCdaÑ;

                  setll %kds( k1yet5 : 9 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet5 : 9 ) ctwet5 @@DsIT5;
                  dow not %eof( ctwet5 );
                    @@DsT5C +=1;
                    eval-corr @@DsT5( @@DsT5C ) = @@DsIT5;
                   reade(n) %kds( k1yet5 : 9 ) ctwet5 @@DsIT5;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) <> *null and
                  %addr( peCdaÑ ) =  *null;

                  k1yet5.t5rama = peRama;
                  k1yet5.t5Arse = peArse;
                  k1yet5.t5poco = pePoco;

                  setll %kds( k1yet5 : 8 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet5 : 8 ) ctwet5 @@DsIT5;
                  dow not %eof( ctwet5 );
                    @@DsT5C +=1;
                    eval-corr @@DsT5( @@DsT5C ) = @@DsIT5;
                   reade(n) %kds( k1yet5 : 8 ) ctwet5 @@DsIT5;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCdaÑ ) =  *null;

                  k1yet5.t5rama = peRama;
                  k1yet5.t5Arse = peArse;

                  setll %kds( k1yet5 : 7 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet5 : 7 ) ctwet5 @@DsIT5;
                  dow not %eof( ctwet5 );
                    @@DsT5C +=1;
                    eval-corr @@DsT5( @@DsT5C ) = @@DsIT5;
                   reade(n) %kds( k1yet5 : 7 ) ctwet5 @@DsIT5;
                  enddo;

            when  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( pePoco ) =  *null and
                  %addr( peCdaÑ ) =  *null;

                  k1yet5.t5rama = peRama;

                  setll %kds( k1yet5 : 6 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet5 : 6 ) ctwet5 @@DsIT5;
                  dow not %eof( ctwet5 );
                    @@DsT5C +=1;
                    eval-corr @@DsT5( @@DsT5C ) = @@DsIT5;
                   reade(n) %kds( k1yet5 : 6 ) ctwet5 @@DsIT5;
                  enddo;
            other;
                  setll %kds( k1yet5 : 5 ) ctwet5;
                  if not %equal ( ctwet5 );
                     return *off;
                  endif;
                  reade(n) %kds( k1yet5 : 5 ) ctwet5 @@DsIT5;
                  dow not %eof( ctwet5 );
                    @@DsT5C +=1;
                    eval-corr @@DsT5( @@DsT5C ) = @@DsIT5;
                   reade(n) %kds( k1yet5 : 5 ) ctwet5 @@DsIT5;
                  enddo;
          endsl;
       else;
         setll %kds( k1yet5 : 5 ) ctwet5;
         if not %equal ( ctwet5 );
            return *off;
         endif;
         reade(n) %kds( k1yet5 : 5 ) ctwet5 @@DsIT5;
         dow not %eof( ctwet5 );
           @@DsT5C +=1;
           eval-corr @@DsT5( @@DsT5C ) = @@DsIT5;
          reade(n) %kds( k1yet5 : 5 ) ctwet5 @@DsIT5;
         enddo;

       endif;

       if %parms >= 3 and %addr( peDsT5 ) <> *null;
          eval-corr peDst5 = @@DsT5 ;
       endif;

       if %parms >= 3 and %addr( peDsT5C ) <> *null;
          peDst5C = @@Dst5C;
       endif;

       return *on;

      /end-free

     P COWVEH_getCtwet5...
     P                 E

      * ------------------------------------------------------------ *
      * COWVEH_updCtwet5(): Actualiza informacion de Daños           *
      *                                                              *
      *    peDsT5   ( input  )  Estructura descuentos   ( opcional ) *
      *                                                              *
      * Retorna *on = Actualizo OK / *off = No Actualizo             *
      * ------------------------------------------------------------ *
     P COWVEH_updCtwet5...
     P                 B                   export
     D COWVEH_updCtwet5...
     D                 pi              n
     D   peDsT5                            likeds( dsCtwet5_t ) const

     D   @@DsOt5       ds                  likerec( c1wet5 : *output )
     D   k1yet5        ds                  likerec( c1wet5 : *key    )

      /free

       COWVEH_inz();

       k1yet5.t5empr = peDsT5.t5empr;
       k1yet5.t5sucu = peDsT5.t5sucu;
       k1yet5.t5nivt = peDsT5.t5nivt;
       k1yet5.t5nivc = peDsT5.t5nivc;
       k1yet5.t5nctw = peDsT5.t5nctw;
       k1yet5.t5rama = peDsT5.t5rama;
       k1yet5.t5arse = peDsT5.t5arse;
       k1yet5.t5poco = peDsT5.t5poco;
       k1yet5.t5CdaÑ = peDsT5.t5CdaÑ;
       chain %kds( k1yet5 : 9 ) ctwet5;
       if not %found( ctwet5 );
         return *off;
       endif;

       eval-corr @@DsOT5 = peDsT5;

       monitor;
         update c1wet5 @@DsOT5;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P COWVEH_updCtwet5...
     P                 E

