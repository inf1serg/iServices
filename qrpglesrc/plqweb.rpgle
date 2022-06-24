      * ------------------------------------------------------------ *
     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * PLQWEB: Programa de Servicio: Preliquidaciones.              *
      *                                                              *
      * Norberto Franqueira                  04-Sep-2015             *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * SGF 24/08/2016: Eliminar de la preli todas las cuotas que    *
      *                 tienen cero en todas las cuotas.             *
      * SGF 07/09/2016: Convertir a PESOS (Vendedor a hoy).          *
      * SGF 28/09/2016: No incluir suspendidas.                      *
      * SGF 04/10/2016: Calcular correctamente las fechas.           *
      * SGF 05/10/2016: Al marcar saldo, marcar todo hacia atrás.    *
      * LRG 21/11/2016: Se corrige busqueda de Intermediario para    *
      *                 envio de mail.PLQWEB_enviarPreliquidacion()  *
      * NWN 14/12/2016: Se agrega control sobre cantidad de facturas *
      *                 pendientes que tenga un productor.           *
      *                 A su vez se envia mensaje de Error por si    *
      *                 tiene mas facturas que las permitidas.       *
      * NWN 23/12/2016: Se agrega ademas que controle facturas sobre *
      *                 Tipo de Pago = Neto.                         *
      * SGF 24/04/2017: Agrego _listaValores().                      *
      * SGF 17/05/2017: Controlo PAHCC2 con CERT y no controlo PAWPC0*
      * LRG 14/06/2017: Se cambia lectura de pahcc209 por join       *
      *                 PAHCC214 dentro del procedimiento            *
      *                 PLQWEB_nuevaPreliquidacio                    *
      * NWN 21/09/2017: Se agrega control sobre Archivo CNTCDC.      *
      * EXT 18/02/2020: Modificacion de procedimiento.               *
      *                 PLQWEB_insertarDepositoBancario              *
      *                 peFdep --> Fecha de Deposito                 *
      * SGF 30/06/2020: Separa Deuda Anterior de Quincena Anterior.  *
      *                 El Productor puede pagar la Deuda anterior y *
      *                 no pagar la quincena anterior.               *
      *                 Permito guardar.                             *
      * SGF 18/07/2020: Rediseño en _nuevaPreliquidacion().          *
      *                 Llega parametro que indica si quiere o no las*
      *                 de debito automatico.                        *
      *                 Agrego: marcarComoProcesada()                *
      *                         tieneCheques()                       *
      *                         tieneEfectivo()                      *
      *                         tieneBancoGalicia()                  *
      * NWN 17/09/2020: Se agrega llamada a SVPSPO y SVPDAF en       *
      *                 _totalPoliza.                                *
      * NWN 18/09/2020: Se agrega PLQWEB_tieneRedondeo().            *
      * NWN 12/05/2021: Recompilación por agregado de campos en      *
      *                 archivos PAHPQP y PAHPQS.                    *
      *                                                              *
      * FAS 17/02/2021: se agrega PLQWEB_insertarEcheq()             *
      *                           PLQWEB_eliminarEcheq()             *
      *                                                              *
      * ************************************************************ *
     Fpahcc214  if   e           k disk    usropn
     Fpahcd502  if   e           k disk    usropn
     Fpahec0    if   e           k disk    usropn
     Fpahec1    if   e           k disk    usropn
     Fpahed0    if   e           k disk    usropn
     Fpahed3    if   e           k disk    usropn
     Fpahpqd    uf a e           k disk    usropn
     Fpahpqd01  if   e           k disk    usropn rename(p1hpqd:pqd01)
     Fpahpqd02  if   e           k disk    usropn rename(p1hpqd:pqd02)
     Fpahpqd03  if   e           k disk    usropn rename(p1hpqd:pqd03)
     Fpahpqd04  if   e           k disk    usropn rename(p1hpqd:pqd04)
     Fpahpqd05  if   e           k disk    usropn rename(p1hpqd:pqd05)
     Fpahpqd06  if   e           k disk    usropn rename(p1hpqd:pqd06)
     Fpahpq1    uf a e           k disk    usropn
     Fpahpq101  if   e           k disk    usropn rename(p1hpq1:pq101)
     Fpahpq102  if   e           k disk    usropn rename(p1hpq1:pq102)
     Fpahpq103  if   e           k disk    usropn rename(p1hpq1:pq103)
     Fpahpq104  if   e           k disk    usropn rename(p1hpq1:pq104)
     Fpahpq105  if   e           k disk    usropn rename(p1hpq1:pq105)
     Fpahpq106  if   e           k disk    usropn rename(p1hpq1:pq106)
     Fpahpqc    uf a e           k disk    usropn
     Fpahpqp    uf a e           k disk    usropn
     Fpahpqp01  if   e           k disk    usropn rename(p1hpqp:p1hpqp01)
     Fpahpqp02  if   e           k disk    usropn rename(p1hpqp:p1hpqp02)
     Fpahpqs    uf a e           k disk    usropn
     Fpahpqv    uf a e           k disk    usropn
     Fcntbco    if   e           k disk    usropn
     Fsehni201  if   e           k disk    usropn
     Fgnhdaf    if   e           k disk    usropn
     Fgntmon    if   e           k disk    usropn
     Fpawpc002  if   e           k disk    usropn
     Fpahiva    if   e           k disk    usropn
     Fcntfpp    if   e           k disk    usropn
     Fcntcdc    if   e           k disk    usropn
     Fpahec186  if   e           k disk    usropn rename(p1hec1:p1hec186)
     Fpahec187  if   e           k disk    usropn rename(p1hec1:p1hec187)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/plqweb_h.rpgle'

     D getNombreAsegurado...
     D                 pr            40a
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

     D calculaFechas   pr
     D  peFeda                        8  0
     D  peFeqa                        8  0
     D  peFeqt                        8  0
     D  peFeqs                        8  0
     D  peFeqp                        8  0

     D gira_fecha      pr             8  0
     D  peFeve                        8  0 const
     D  peTipo                        3a   const

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     D SP0052          pr                  ExtPgm('SP0052')
     D  peComo                        2a   const
     D  peFech                        8  0
     D  peCoti                       15  6
     D  pePart                        1a   const

     D DXP021          pr                  ExtPgm('DXP021')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peFemd                        2  0 const
     D  peAnul                        1a
     D  peFpgm                        3a   const

     D k1hcdc          ds                  likerec(c1tcdc:*key)
     D k1hiva          ds                  likerec(p1hiva:*key)
     D khni201         ds                  likerec(s1hni201:*key)

     D initialized     s               n

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D  peCant         s              3  0
     D  peCanp         s              3  0


     *- Area de datos local...
     Dcontrol_fact     ds                  dtaara(dtacanfact) qualified
     D  contfact                      3  0

      *--- PR Externos --------------------------------------------- *
     D SPT902          pr                  extpgm('SPT902')
     D   peTnum                       1    const
     D   peNres                       7  0

      * ------------------------------------------------------------ *
      * PLQWEB_updateCuota(): Marca/desmarca una cuota a nivel Super *
      *                       Póliza. Marca/desmarca una cuota a ni- *
      *                       vel Póliza.                            *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Pólizas por Rama/Articulo             *
      *     peOper   (input)   Operación                             *
      *     pePoli   (input)   Póliza                                *
      *     peSuop   (input)   Suplemento operación                  *
      *     peNrcu   (input)   Cuota                                 *
      *     peNrsc   (input)   SubCuota                              *
      *     peMarc   (input)   Marca/desmarca                        *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_updateCuota...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   peMarc                       1    const

      * ------------------------------------------------------------ *
      * PLQWEB_updateImportes():          Actualiza los importes bru-*
      *                       to y neto en cabecera de Preliquidacio-*
      *                       nes.                                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peMarc   (input)   Marca/desmarca                        *
      *     peCodi   (input)   Código de Deuda
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_updateImportes...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peMarc                       1    const
     D   peCodi                       2    const
     D   peImpn                      15  2
     D   peImpb                      15  2

      * ------------------------------------------------------------ *
      * PLQWEB_updateImportesSuperPolizaEndoso():                    *
      *                                   Actualiza los importes bru-*
      *                       to y neto en cabecera de Preliquidacio-*
      *                       nes.                                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peMarc   (input)   Marca/desmarca                        *
      *     peCodi   (input)   Código de Deuda
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_updateImportesSuperPolizaEndoso...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peMarc                       1    const
     D   peCodi                       2    const
     D   peImpn                      15  2
     D   peImpb                      15  2

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnteriorI():   marca p/pagar toda la Deuda *
      *                               Anterior de la preliquidación. *
      *                               (Interno).                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarDeudaAnteriorI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnteriorI():   Desmarca p/pagar toda la *
      *                                  Deuda Anterior de la Preli- *
      *                                  quidación. (Interno).       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarDeudaAnteriorI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnteriorI(): marca para pagar toda la   *
      *                                  Quincena Anterior de la     *
      *                                  Preliquidación. (Interno).  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaAnteriorI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnteriorI():   Desmarca p/pagar toda *
      *                                     la Quincena Anterior de  *
      *                                     la prequidación.         *
      *                                     (Interno).               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaAnteriorI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI():              *
      *                                  marca p/pagar toda la Deuda *
      *                               Anterior de la preliquidación. *
      *                               (Interno).                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI():           *
      *                                     Desmarca p/pagar toda la *
      *                                  Deuda Anterior de la Preli- *
      *                                  quidación. (Interno).       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI():           *
      *                                   marca para pagar toda la   *
      *                                  Quincena Anterior de la     *
      *                                  Preliquidación. (Interno).  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnteriorSuperPlozaEndosoI():         *
      *                                        Desmarca p/pagar toda *
      *                                     la Quincena Anterior de  *
      *                                     la prequidación.         *
      *                                     (Interno).               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndosoI...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_validaPreliquidacion(): Cheque la existencia de la    *
      *                                Preliquidación y que la misma *
      *                                no haya ya sido enviada.      *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_validaPreliquidacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_validaSuperpóliza():    Cheque la existencia de la    *
      *                                Superpóliza y el Suplemento   *
      *                                solicitados.                  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     D PLQWEB_validaSuperpoliza...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PLQWEB_sndEmail(): Enviar email de recepcion.                *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_sndEmail...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const

      * ------------------------------------------------------------ *
      * PLQWEB_cleanUp(): Clean Up Final luego de en enviar.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * ------------------------------------------------------------ *
     D PLQWEB_cleanUp...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * PLQWEB_nuevaPreliquidacion(): genera cuotas pendientes de    *
      *                               pago para el productor.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (output)  Número de Preliquidación              *
      *     peFhas   (output)  Fecha Hasta de Cuotas (aaaammdd)      *
      *     peDaut   (input)   Incluir Debito Automatico (S/N)       *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_nuevaPreliquidacion...
     P                 b                   export

     D PLQWEB_nuevaPreliquidacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0
     D   peFhas                       8  0
     D   peDaut                       1a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hcd5          ds                  likerec(p1hcd502:*key)
     D k1hec1          ds                  likerec(p1hec186:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hpq1          ds                  likerec(p1hpq1:*key)
     D k1hpqd          ds                  likerec(p1hpqd:*key)

     D fechada         s              8  0
     D fechaqa         s              8  0
     D fechaqt         s              8  0
     D fechaqs         s              8  0
     D fechaqp         s              8  0
     D fecdesde        s              8  0

     D penres          s              7  0
     D p               s             30 15
     D r               s             30 15
     D @@copr          s             15  2

       PLQWEB_inz();

       // -------------------------------------
       // Validar parametro base
       // -------------------------------------
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       // -------------------------------------
       // Solo permitidas para nivel 1
       // -------------------------------------
       if peBase.peNivt <> 1;
          @@Repl = %editw ( peBase.peNivt  : '0' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL'
                        : 'WSVMSG'
                        : 'PQW0010'
                        : peMsgs
                        : @@Repl
                        : @@Leng    );
          peErro = -1;
          return;
       endif;

       calculaFechas( fechada
                    : fechaqa
                    : fechaqt
                    : fechaqs
                    : fechaqp );

       // ---------------------------------------
       // Polizas de Cobrador
       // ---------------------------------------
       k1hec1.c1empr = peBase.peEmpr;
       k1hec1.c1sucu = peBase.peSucu;
       k1hec1.c1nivt = peBase.peNivt;
       k1hec1.c1nivc = peBase.peNivc;

       // ----------------------------------------------------
       // Si solicita incluir debito automatico (daut = 'S')
       // leemos ec186
       // si no, leemos ec187
       // ----------------------------------------------------
       if (peDaut = 'S');
          setll %kds(k1hec1:4) pahec186;
          reade %kds(k1hec1:4) pahec186;
        else;
          setll %kds(k1hec1:4) pahec187;
          reade %kds(k1hec1:4) pahec187;
       endif;
       dow not %eof;
           if SPVSPO_chkAnuladaV2( c1empr
                                 : c1sucu
                                 : c1arcd
                                 : c1spol
                                 : *omit  ) = *off;
              c2imcu = PLQWEB_cotiza( c2mone
                                    : c2imcu
                                    : 'V'
                                    : *omit  );
              c1prem = PLQWEB_cotiza( c1mone
                                    : c1prem
                                    : 'V'
                                    : *omit  );
              if peNres <= 0;
                 SPT902( 'Q' : peNres );
                 fecDesde = c2fvto;
              endif;
              @@copr = PLQWEB_comisionSuperpoliza( c1empr
                                                 : c1sucu
                                                 : peBase.peNivt
                                                 : peBase.peNivc
                                                 : c1mone
                                                 : c1arcd
                                                 : c1spol
                                                 : c1sspo );
              if c1prem <> 0;
                 p = (c2imcu / c1prem) * 100;
                 r = (@@copr *p) / 100;
                 eval(h) q1comi = r * 0,9;
              endif;
              k1hpq1.q1empr = peBase.peEmpr;
              k1hpq1.q1sucu = peBase.peSucu;
              k1hpq1.q1nivt = peBase.peNivt;
              k1hpq1.q1nivc = peBase.peNivc;
              k1hpq1.q1nrpl = peNres;
              k1hpq1.q1arcd = c1arcd;
              k1hpq1.q1spol = c1spol;
              k1hpq1.q1sspo = c1sspo;
              k1hpq1.q1nrcu = c2nrcu;
              k1hpq1.q1nrsc = c2nrsc;
              setll %kds(k1hpq1) pahpq1;
              if not %equal;
                 q1empr = c1empr;
                 q1sucu = c1sucu;
                 q1nivt = c1nivt;
                 q1nivc = c1nivc;
                 q1nrpl = peNres;
                 q1arcd = c1arcd;
                 q1spol = c1spol;
                 q1sspo = c1sspo;
                 q1nrcu = c2nrcu;
                 q1nrsc = c2nrsc;
                 q1fvto = c2fvto;
                 q1imcu = c2imcu;
                 q1codi = PLQWEB_codigoDeColumna( fechada
                                                : fechaqa
                                                : fechaqt
                                                : fechaqs
                                                : fechaqp
                                                : q1fvto  );
                 q1marp = '0';
                 q1fera = *year;
                 q1ferm = *month;
                 q1ferd = *day;
                 q1time = %dec(%time():*iso);
                 q1nomb = SVPDAF_getNombre( c1asen : *omit );
                 // -----------------------------------------
                 // Grabo superpoliza, solo si tiene poliza
                 // -----------------------------------------
                 k1hcd5.d5empr = c1empr;
                 k1hcd5.d5sucu = c1sucu;
                 k1hcd5.d5arcd = c1arcd;
                 k1hcd5.d5spol = c1spol;
                 k1hcd5.d5sspo = c1sspo;
                 k1hcd5.d5nrcu = c2nrcu;
                 k1hcd5.d5nrsc = c2nrsc;
                 setll %kds(k1hcd5:7) pahcd502;
                 if %equal(pahcd502);
                    write p1hpq1;
                    PLQWEB_totalSuperpoliza( q1empr
                                           : q1sucu
                                           : q1nivt
                                           : q1nivc
                                           : q1nrpl
                                           : q1arcd
                                           : q1spol
                                           : q1sspo
                                           : q1codi
                                           : q1imcu );
                 endif;
              endif;
           endif;
        if (peDaut = 'S');
           reade %kds(k1hec1:4) pahec186;
         else;
           reade %kds(k1hec1:4) pahec187;
        endif;
       enddo;

       peFhas = c2fvto;

       // -------------------------------------------
       // Expandir polizas
       // -------------------------------------------
       k1hpq1.q1empr = peBase.peEmpr;
       k1hpq1.q1sucu = peBase.peSucu;
       k1hpq1.q1nivt = peBase.peNivt;
       k1hpq1.q1nivc = peBase.peNivc;
       k1hpq1.q1nrpl = peNres;
       setll %kds(k1hpq1:5) pahpq1;
       reade %kds(k1hpq1:5) pahpq1;
       dow not %eof;
           k1hcd5.d5empr = q1empr;
           k1hcd5.d5sucu = q1sucu;
           k1hcd5.d5arcd = q1arcd;
           k1hcd5.d5spol = q1spol;
           k1hcd5.d5sspo = q1sspo;
           k1hcd5.d5nrcu = q1nrcu;
           k1hcd5.d5nrsc = q1nrsc;
           setll %kds(k1hcd5:7) pahcd502;
           reade %kds(k1hcd5:7) pahcd502;
           dow not %eof;
               k1hed0.d0empr = d5empr;
               k1hed0.d0sucu = d5sucu;
               k1hed0.d0arcd = d5arcd;
               k1hed0.d0spol = d5spol;
               k1hed0.d0sspo = d5sspo;
               k1hed0.d0rama = d5rama;
               k1hed0.d0arse = d5arse;
               k1hed0.d0oper = d5oper;
               k1hed0.d0suop = d5suop;
               chain %kds(k1hed0:9) pahed0;
               if %found;
                  d0prem = PLQWEB_cotiza( d0mone
                                        : d0prem
                                        : 'V'
                                        : *omit  );
                  d5imcu = PLQWEB_cotiza( d0mone
                                        : d5imcu
                                        : 'V'
                                        : *omit  );
                  @@copr = PLQWEB_comisionPoliza( d5empr
                                                : d5sucu
                                                : peBase.peNivt
                                                : peBase.peNivc
                                                : d0mone
                                                : d5arcd
                                                : d5spol
                                                : d5sspo
                                                : d5rama
                                                : d5suop );
                  if d0prem <> 0;
                     p = (d5imcu / d0prem) * 100;
                     r = (@@copr *p) / 100;
                     eval(h) qdcomi = r * 0,9;
                  endif;
                  k1hpqd.qdempr = d5empr;
                  k1hpqd.qdsucu = d5sucu;
                  k1hpqd.qdnivt = peBase.peNivt;
                  k1hpqd.qdnivc = peBase.peNivc;
                  k1hpqd.qdnrpl = peNres;
                  k1hpqd.qdarcd = d5arcd;
                  k1hpqd.qdspol = d5spol;
                  k1hpqd.qdsspo = d5sspo;
                  k1hpqd.qdrama = d5rama;
                  k1hpqd.qdarse = d5arse;
                  k1hpqd.qdoper = d5oper;
                  k1hpqd.qdpoli = d5poli;
                  k1hpqd.qdsuop = d5suop;
                  k1hpqd.qdnrcu = d5nrcu;
                  k1hpqd.qdnrsc = d5nrsc;
                  setll %kds(k1hpqd) pahpqd;
                  if not %equal;
                     qdempr = d5empr;
                     qdsucu = d5sucu;
                     qdnivt = peBase.peNivt;
                     qdnivc = peBase.peNivc;
                     qdnrpl = peNres;
                     qdarcd = d5arcd;
                     qdspol = d5spol;
                     qdsspo = d5sspo;
                     qdrama = d5rama;
                     qdarse = d5arse;
                     qdoper = d5oper;
                     qdpoli = d5poli;
                     qdsuop = d5suop;
                     qdnrcu = d5nrcu;
                     qdnrsc = d5nrsc;
                     qdimcu = d5imcu;
                     qdfvto = (d5fvca * 10000)
                            + (d5fvcm *  100)
                            +  d5fvcd;
                     qdcodi = PLQWEB_codigoDeColumna( fechada
                                                    : fechaqa
                                                    : fechaqt
                                                    : fechaqs
                                                    : fechaqp
                                                    : qdfvto  );
                     qdmarp = '0';
                     qdfera = *year;
                     qdferm = *month;
                     qdferd = *day;
                     qdtime = %dec(%time():*iso);
                     write p1hpqd;
                     PLQWEB_totalPoliza( qdempr
                                       : qdsucu
                                       : qdnivt
                                       : qdnivc
                                       : qdnrpl
                                       : qdarcd
                                       : qdspol
                                       : qdsspo
                                       : qdrama
                                       : qdarse
                                       : qdoper
                                       : qdsuop
                                       : qdpoli
                                       : qdcodi
                                       : qdimcu  );
                  endif;

               endif;
            reade %kds(k1hcd5:7) pahcd502;
           enddo;
        reade %kds(k1hpq1:5) pahpq1;
       enddo;

       PLQWEB_generaCabecera( peBase.peEmpr
                            : peBase.peSucu
                            : peBase.peNivt
                            : peBase.peNivc
                            : peNres
                            : fecDesde
                            : peFhas         );

       peNrpl = penres;

       return;

     P PLQWEB_nuevaPreliquidacion...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnterior(): marca para pagar toda la Deuda *
      *                               Anterior de la preliquidación. *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarDeudaAnterior...
     P                 b                   export

     D PLQWEB_marcarDeudaAnterior...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@vsys          s            512a
     D @@sepa          s              1a

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_marcarDeudaAnteriorI(@@base:
                                   @@nrpl:
                                   peImpn:
                                   peImpb:
                                   peErro:
                                   peMsgs);

       @@sepa = 'N';
       if SVPVLS_getValSys( 'HDEUANTQAN'
                          : *omit
                          : @@vsys       );
          @@sepa = @@vsys;
       endif;

       if @@sepa = 'N';
          PLQWEB_marcarQuincenaAnteriorI(@@base:
                                         @@nrpl:
                                         peImpn:
                                         peImpb:
                                         peErro:
                                         peMsgs);
       endif;

       return;

     P PLQWEB_marcarDeudaAnterior...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnterior(): Desmarca para pagar toda la *
      *                                  Deuda Anterior de la Preli- *
      *                                  quidación.                  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarDeudaAnterior...
     P                 b                   export

     D PLQWEB_desmarcarDeudaAnterior...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@vsys          s            512a
     D @@sepa          s              1a

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_desmarcarDeudaAnteriorI(@@base:
                                      @@nrpl:
                                      peImpn:
                                      peImpb:
                                      peErro:
                                      peMsgs);

       @@sepa = 'N';
       if SVPVLS_getValSys( 'HDEUANTQAN'
                          : *omit
                          : @@vsys       );
          @@sepa = @@vsys;
       endif;

       if @@sepa = 'N';
          PLQWEB_desmarcarQuincenaAnteriorI(@@base:
                                            @@nrpl:
                                            peImpn:
                                            peImpb:
                                            peErro:
                                            peMsgs);
       endif;

       return;

     P PLQWEB_desmarcarDeudaAnterior...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnterior(): marca para pagar toda la    *
      *                                  Quincena Anterior de la     *
      *                                  Preliquidación.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaAnterior...
     P                 b                   export

     D PLQWEB_marcarQuincenaAnterior...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_marcarQuincenaAnteriorI(@@base:
                                      @@nrpl:
                                      peImpn:
                                      peImpb:
                                      peErro:
                                      peMsgs);

       PLQWEB_marcarDeudaAnteriorI(@@base:
                                   @@nrpl:
                                   peImpn:
                                   peImpb:
                                   peErro:
                                   peMsgs);

       return;

     P PLQWEB_marcarQuincenaAnterior...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnterior(): Desmarca para pagar toda *
      *                                     la Quincena Anterior de  *
      *                                     la prequidación.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaAnterior...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaAnterior...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_desmarcarQuincenaAnteriorI(@@base:
                                         @@nrpl:
                                         peImpn:
                                         peImpb:
                                         peErro:
                                         peMsgs);

       PLQWEB_desmarcarDeudaAnteriorI(@@base:
                                      @@nrpl:
                                      peImpn:
                                      peImpb:
                                      peErro:
                                      peMsgs);

       return;

     P PLQWEB_desmarcarQuincenaAnterior...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaActual():   marca para pagar toda la    *
      *                                  Quincena Actual de la       *
      *                                  Preliquidación.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaActual...
     P                 b                   export

     D PLQWEB_marcarQuincenaActual...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd03         ds                  likerec(pqd03:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QT')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd03.qdempr = peBase.peEmpr;
       khpqd03.qdsucu = peBase.peSucu;
       khpqd03.qdnivt = peBase.peNivt;
       khpqd03.qdnivc = peBase.peNivc;
       khpqd03.qdnrpl = peNrpl;

       setll %kds(khpqd03:5) pahpqd03;
       reade %kds(khpqd03:5) pahpqd03;

       dow not %eof(pahpqd03);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd03:5) pahpqd03;
       enddo;

       PLQWEB_marcarQuincenaAnterior(@@base:
                                     @@nrpl:
                                     peImpn:
                                     peImpb:
                                     peErro:
                                     peMsgs);

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_marcarQuincenaActual...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaActual():   Desmarca para pagar toda *
      *                                     la Quincena Actual de    *
      *                                     la prequidación.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaActual...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaActual...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd03         ds                  likerec(pqd03:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QT')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd03.qdempr = peBase.peEmpr;
       khpqd03.qdsucu = peBase.peSucu;
       khpqd03.qdnivt = peBase.peNivt;
       khpqd03.qdnivc = peBase.peNivc;
       khpqd03.qdnrpl = peNrpl;

       setll %kds(khpqd03:5) pahpqd03;
       reade %kds(khpqd03:5) pahpqd03;

       dow not %eof(pahpqd03);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd03:5) pahpqd03;
       enddo;

       PLQWEB_desmarcarQuincenaAnterior(@@base:
                                        @@nrpl:
                                        peImpn:
                                        peImpb:
                                        peErro:
                                        peMsgs);

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_desmarcarQuincenaActual...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaSiguiente(): marca para pagar toda la   *
      *                                   Quincena Siguiente de la   *
      *                                   Preliquidación.            *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaSiguiente...
     P                 b                   export

     D PLQWEB_marcarQuincenaSiguiente...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd04         ds                  likerec(pqd04:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QS')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd04.qdempr = peBase.peEmpr;
       khpqd04.qdsucu = peBase.peSucu;
       khpqd04.qdnivt = peBase.peNivt;
       khpqd04.qdnivc = peBase.peNivc;
       khpqd04.qdnrpl = peNrpl;

       setll %kds(khpqd04:5) pahpqd04;
       reade %kds(khpqd04:5) pahpqd04;

       dow not %eof(pahpqd04);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd04:5) pahpqd04;
       enddo;

       PLQWEB_marcarQuincenaActual(@@base:
                                   @@nrpl:
                                   peImpn:
                                   peImpb:
                                   peErro:
                                   peMsgs);

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_marcarQuincenaSiguiente...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaSiguiente(): Desmarca para pagar to- *
      *                                      da la Quincena Siguien- *
      *                                      te de la prequidación.  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaSiguiente...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaSiguiente...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd04         ds                  likerec(pqd04:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QS')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd04.qdempr = peBase.peEmpr;
       khpqd04.qdsucu = peBase.peSucu;
       khpqd04.qdnivt = peBase.peNivt;
       khpqd04.qdnivc = peBase.peNivc;
       khpqd04.qdnrpl = peNrpl;

       setll %kds(khpqd04:5) pahpqd04;
       reade %kds(khpqd04:5) pahpqd04;

       dow not %eof(pahpqd04);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd04:5) pahpqd04;
       enddo;

       PLQWEB_desmarcarQuincenaActual(@@base:
                                      @@nrpl:
                                      peImpn:
                                      peImpb:
                                      peErro:
                                      peMsgs);

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_desmarcarQuincenaSiguiente...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarSaldo(): marca para pagar todo en Saldo de la   *
      *                       preliquidación.                        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarSaldo...
     P                 b                   export

     D PLQWEB_marcarSaldo...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd05         ds                  likerec(pqd05:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('SA')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd05.qdempr = peBase.peEmpr;
       khpqd05.qdsucu = peBase.peSucu;
       khpqd05.qdnivt = peBase.peNivt;
       khpqd05.qdnivc = peBase.peNivc;
       khpqd05.qdnrpl = peNrpl;

       setll %kds(khpqd05:5) pahpqd05;
       reade %kds(khpqd05:5) pahpqd05;

       dow not %eof(pahpqd05);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd05:5) pahpqd05;
       enddo;

       PLQWEB_marcarQuincenaPosterior( peBase
                                     : peNrpl
                                     : peImpn
                                     : peImpb
                                     : peErro
                                     : peMsgs );

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_marcarSaldo...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarSaldo(): Desmarca para pagar todo el Saldo   *
      *                          de la Preliquidación                *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarSaldo...
     P                 b                   export

     D PLQWEB_desmarcarSaldo...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd05         ds                  likerec(pqd05:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('SA')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd05.qdempr = peBase.peEmpr;
       khpqd05.qdsucu = peBase.peSucu;
       khpqd05.qdnivt = peBase.peNivt;
       khpqd05.qdnivc = peBase.peNivc;
       khpqd05.qdnrpl = peNrpl;

       setll %kds(khpqd05:5) pahpqd05;
       reade %kds(khpqd05:5) pahpqd05;

       dow not %eof(pahpqd05);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd05:5) pahpqd05;
       enddo;

       PLQWEB_desmarcarQuincenaPosterior( peBase
                                        : peNrpl
                                        : peImpn
                                        : peImpb
                                        : peErro
                                        : peMsgs );

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_desmarcarSaldo...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnteriorSuperPolizaEndoso(): marca para    *
      *                                                pagar la Deu- *
      *                                                da Anterior   *
      *                                                de una Póliza *
      *                                                /Endoso.      *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarDeudaAnteriorSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_marcarDeudaAnteriorSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@vsys          s            512a
     D @@sepa          s              1a

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI(@@base:
                                                    @@nrpl:
                                                    @@arcd:
                                                    @@spol:
                                                    @@sspo:
                                                    peImpn:
                                                    peImpb:
                                                    peErro:
                                                    peMsgs);

       @@sepa = 'N';
       if SVPVLS_getValSys( 'HDEUANTQAN'
                          : *omit
                          : @@vsys       );
          @@sepa = @@vsys;
       endif;

       if @@sepa = 'N';
          PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI(@@base:
                                                          @@nrpl:
                                                          @@arcd:
                                                          @@spol:
                                                          @@sspo:
                                                          peImpn:
                                                          peImpb:
                                                          peErro:
                                                          peMsgs);
       endif;


       return;

     P PLQWEB_marcarDeudaAnteriorSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndoso(): desmarca   *
      *                                                   para pagar *
      *                                                   la Deuda   *
      *                                                   Anterior   *
      *                                                   de una Pó- *
      *                                                   liza/Endo- *
      *                                                   so.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@vsys          s            512a
     D @@sepa          s              1a

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI(@@base:
                                                       @@nrpl:
                                                       @@arcd:
                                                       @@spol:
                                                       @@sspo:
                                                       peImpn:
                                                       peImpb:
                                                       peErro:
                                                       peMsgs);

       @@sepa = 'N';
       if SVPVLS_getValSys( 'HDEUANTQAN'
                          : *omit
                          : @@vsys       );
          @@sepa = @@vsys;
       endif;

       if @@sepa = 'N';
       PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndosoI(@@base:
                                                          @@nrpl:
                                                          @@arcd:
                                                          @@spol:
                                                          @@sspo:
                                                          peImpn:
                                                          peImpb:
                                                          peErro:
                                                          peMsgs);
       endif;

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnteriorSuperPolizaEndoso(): marca para *
      *                                                  pagar la    *
      *                                                  Quincena    *
      *                                                  Anterior de *
      *                                                  una Póliza/ *
      *                                                  Endoso.     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaAnteriorSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_marcarQuincenaAnteriorSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI(@@base:
                                                       @@nrpl:
                                                       @@arcd:
                                                       @@spol:
                                                       @@sspo:
                                                       peImpn:
                                                       peImpb:
                                                       peErro:
                                                       peMsgs);

       PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI(@@base:
                                                    @@nrpl:
                                                    @@arcd:
                                                    @@spol:
                                                    @@sspo:
                                                    peImpn:
                                                    peImpb:
                                                    peErro:
                                                    peMsgs);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_marcarQuincenaAnteriorSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndoso(): desmar- *
      *                                                      ca para *
      *                                                      pagar la*
      *                                                      Quincena*
      *                                                      Anterior*
      *                                                      de una  *
      *                                                      Póliza/ *
      *                                                      Endoso. *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndosoI(@@base:
                                                          @@nrpl:
                                                          @@arcd:
                                                          @@spol:
                                                          @@sspo:
                                                          peImpn:
                                                          peImpb:
                                                          peErro:
                                                          peMsgs);

       PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI(@@base:
                                                       @@nrpl:
                                                       @@arcd:
                                                       @@spol:
                                                       @@sspo:
                                                       peImpn:
                                                       peImpb:
                                                       peErro:
                                                       peMsgs);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaActualSuperPolizaEndoso(): marca para   *
      *                                                 pagar la     *
      *                                                 Quincena Ac- *
      *                                                 tual de una  *
      *                                                 Póliza/Endo- *
      *                                                 so.          *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaActualSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_marcarQuincenaActualSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd03         ds                  likerec(pqd03:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QT')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd03.qdempr = peBase.peEmpr;
       khpqd03.qdsucu = peBase.peSucu;
       khpqd03.qdnivt = peBase.peNivt;
       khpqd03.qdnivc = peBase.peNivc;
       khpqd03.qdnrpl = peNrpl;
       khpqd03.qdarcd = peArcd;
       khpqd03.qdspol = peSpol;
       khpqd03.qdsspo = peSspo;

       setll %kds(khpqd03:8) pahpqd03;
       reade %kds(khpqd03:8) pahpqd03;

       dow not %eof(pahpqd03);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd03:8) pahpqd03;
       enddo;

       PLQWEB_marcarQuincenaAnteriorSuperPolizaEndoso(@@base:
                                                      @@nrpl:
                                                      @@arcd:
                                                      @@spol:
                                                      @@sspo:
                                                      peImpn:
                                                      peImpb:
                                                      peErro:
                                                      peMsgs);

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_marcarQuincenaActualSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaActualSuperPolizaEndoso(): desmarca  *
      *                                                    para pagar*
      *                                                    la Quince-*
      *                                                    na Actual *
      *                                                    de una Pó-*
      *                                                    liza/Endo-*
      *                                                    so.       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaActualSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaActualSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd03         ds                  likerec(pqd03:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QT')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd03.qdempr = peBase.peEmpr;
       khpqd03.qdsucu = peBase.peSucu;
       khpqd03.qdnivt = peBase.peNivt;
       khpqd03.qdnivc = peBase.peNivc;
       khpqd03.qdnrpl = peNrpl;
       khpqd03.qdarcd = peArcd;
       khpqd03.qdspol = peSpol;
       khpqd03.qdsspo = peSspo;

       setll %kds(khpqd03:8) pahpqd03;
       reade %kds(khpqd03:8) pahpqd03;

       dow not %eof(pahpqd03);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd03:8) pahpqd03;
       enddo;

       PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndoso(@@base:
                                                         @@nrpl:
                                                         @@arcd:
                                                         @@spol:
                                                         @@sspo:
                                                         peImpn:
                                                         peImpb:
                                                         peErro:
                                                         peMsgs);

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_desmarcarQuincenaActualSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso() marca para *
      *                                                   pagar la   *
      *                                                   Quincena   *
      *                                                   Siguiente  *
      *                                                   de una Pó- *
      *                                                   liza/Endo- *
      *                                                   so.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd04         ds                  likerec(pqd04:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QS')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd04.qdempr = peBase.peEmpr;
       khpqd04.qdsucu = peBase.peSucu;
       khpqd04.qdnivt = peBase.peNivt;
       khpqd04.qdnivc = peBase.peNivc;
       khpqd04.qdnrpl = peNrpl;
       khpqd04.qdarcd = peArcd;
       khpqd04.qdspol = peSpol;
       khpqd04.qdsspo = peSspo;

       setll %kds(khpqd04:8) pahpqd04;
       reade %kds(khpqd04:8) pahpqd04;

       dow not %eof(pahpqd04);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd04:8) pahpqd04;
       enddo;

       PLQWEB_marcarQuincenaActualSuperPolizaEndoso(@@base:
                                                    @@nrpl:
                                                    @@arcd:
                                                    @@spol:
                                                    @@sspo:
                                                    peImpn:
                                                    peImpb:
                                                    peErro:
                                                    peMsgs);

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaSiguienteSuperPolizaEndoso(): des-   *
      *                                                       marca  *
      *                                                       para   *
      *                                                       pagar  *
      *                                                       la Quin*
      *                                                       cena   *
      *                                                       siguien*
      *                                                       te de  *
      *                                                       una Pó-*
      *                                                       liza/  *
      *                                                       Endoso.*
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaSiguienteSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaSiguienteSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd04         ds                  likerec(pqd04:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QS')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd04.qdempr = peBase.peEmpr;
       khpqd04.qdsucu = peBase.peSucu;
       khpqd04.qdnivt = peBase.peNivt;
       khpqd04.qdnivc = peBase.peNivc;
       khpqd04.qdnrpl = peNrpl;
       khpqd04.qdarcd = peArcd;
       khpqd04.qdspol = peSpol;
       khpqd04.qdsspo = peSspo;

       setll %kds(khpqd04:8) pahpqd04;
       reade %kds(khpqd04:8) pahpqd04;

       dow not %eof(pahpqd04);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd04:8) pahpqd04;
       enddo;

       PLQWEB_desmarcarQuincenaActualSuperPolizaEndoso(@@base:
                                                       @@nrpl:
                                                       @@arcd:
                                                       @@spol:
                                                       @@sspo:
                                                       peImpn:
                                                       peImpb:
                                                       peErro:
                                                       peMsgs);

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_desmarcarQuincenaSiguienteSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarSaldosSuperPolizaEndoso(): marca para pagar el  *
      *                                         saldo de una Póliza/ *
      *                                         Endoso.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarSaldosSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_marcarSaldosSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd05         ds                  likerec(pqd05:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('SA')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd05.qdempr = peBase.peEmpr;
       khpqd05.qdsucu = peBase.peSucu;
       khpqd05.qdnivt = peBase.peNivt;
       khpqd05.qdnivc = peBase.peNivc;
       khpqd05.qdnrpl = peNrpl;
       khpqd05.qdarcd = peArcd;
       khpqd05.qdspol = peSpol;
       khpqd05.qdsspo = peSspo;

       setll %kds(khpqd05:8) pahpqd05;
       reade %kds(khpqd05:8) pahpqd05;

       dow not %eof(pahpqd05);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd05:8) pahpqd05;
       enddo;

       PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso( peBase
                                                      : peNrpl
                                                      : peArcd
                                                      : peSpol
                                                      : peSspo
                                                      : peImpn
                                                      : peImpb
                                                      : peErro
                                                      : peMsgs );

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_marcarSaldosSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarSaldosSuperPolizaEndoso(): desmarca para pa- *
      *                                            gar el Saldo de   *
      *                                            una Póliza/Endo-  *
      *                                            so.               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarSaldosSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_desmarcarSaldosSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hpqd          ds                  likerec(p1hpqd:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('SA')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       k1hpqd.qdempr = peBase.peEmpr;
       k1hpqd.qdsucu = peBase.peSucu;
       k1hpqd.qdnivt = peBase.peNivt;
       k1hpqd.qdnivc = peBase.peNivc;
       k1hpqd.qdnrpl = peNrpl;
       k1hpqd.qdarcd = peArcd;
       k1hpqd.qdspol = peSpol;
       k1hpqd.qdsspo = peSspo;

       setll %kds(k1hpqd:8) pahpqd;
       reade %kds(k1hpqd:8) pahpqd;

       dow not %eof(pahpqd);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(k1hpqd:8) pahpqd;
       enddo;

       PLQWEB_desmarcarQuincenaPosteriorSuperPolizaEndoso( peBase
                                                         : peNrpl
                                                         : peArcd
                                                         : peSpol
                                                         : peSspo
                                                         : peImpn
                                                         : peImpb
                                                         : peErro
                                                         : peMsgs  );

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_desmarcarSaldosSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_updateCuota(): Marca/desmarca una cuota a nivel Super *
      *                       Póliza. Marca/desmarca una cuota a ni- *
      *                       vel Póliza.                            *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Pólizas por Rama/Articulo             *
      *     peOper   (input)   Operación                             *
      *     pePoli   (input)   Póliza                                *
      *     peSuop   (input)   Suplemento operación                  *
      *     peNrcu   (input)   Cuota                                 *
      *     peNrsc   (input)   SubCuota                              *
      *     peMarc   (input)   Marca/desmarca                        *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_updateCuota...
     P                 b

     D PLQWEB_updateCuota...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   peMarc                       1    const

     D khpq1           ds                  likerec(p1hpq1:*key)
     D khpqd           ds                  likerec(p1hpqd:*key)

       PLQWEB_inz();

       khpq1.q1empr = peBase.peEmpr;
       khpq1.q1sucu = peBase.peSucu;
       khpq1.q1nivt = peBase.peNivt;
       khpq1.q1nivc = peBase.peNivc;
       khpq1.q1nrpl = peNrpl;
       khpq1.q1arcd = peArcd;
       khpq1.q1spol = peSpol;
       khpq1.q1sspo = peSspo;
       khpq1.q1nrcu = peNrcu;
       khpq1.q1nrsc = peNrsc;

       chain %kds(khpq1:10) pahpq1;
       if %found(pahpq1);
          if q1marp <> peMarc;
             q1marp = peMarc;
             update p1hpq1;
          else;
             unlock pahpq1;
          endif;
       endif;

       khpqd.qdempr = peBase.peEmpr;
       khpqd.qdsucu = peBase.peSucu;
       khpqd.qdnivt = peBase.peNivt;
       khpqd.qdnivc = peBase.peNivc;
       khpqd.qdnrpl = peNrpl;
       khpqd.qdarcd = peArcd;
       khpqd.qdspol = peSpol;
       khpqd.qdsspo = peSspo;
       khpqd.qdrama = peRama;
       khpqd.qdarse = peArse;
       khpqd.qdoper = peOper;
       khpqd.qdpoli = pePoli;
       khpqd.qdsuop = peSuop;
       khpqd.qdnrcu = peNrcu;
       khpqd.qdnrsc = peNrsc;

       chain %kds(khpqd:15) pahpqd;
       if %found(pahpqd);
          if qdmarp <> peMarc;
             qdmarp = peMarc;
             update p1hpqd;
             else;
             unlock pahpqd;
          endif;
       endif;

       return;

     P PLQWEB_updateCuota...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_updateImportes()           Actualiza los importes bru-*
      *                       to y neto en cabecera de Preliquidacio-*
      *                       nes.                                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peMarc   (input)   Marca/desmarca                        *
      *     peCodi   (input)   Código de Deuda
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_updateImportes...
     P                 b

     D PLQWEB_updateImportes...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peMarc                       1    const
     D   peCodi                       2    const
     D   peImpn                      15  2
     D   peImpb                      15  2

     D khpq1           ds                  likerec(p1hpq1:*key)
     D khpqc           ds                  likerec(p1hpqc:*key)

     D @@ok            s               n   inz(*Off)

     D @@imcu          s             15  2
     D @@comi          s             15  2

       PLQWEB_inz();

       clear @@imcu;
       clear @@comi;

       peImpn = 0;
       peImpb = 0;

       khpq1.q1empr = peBase.peEmpr;
       khpq1.q1sucu = peBase.peSucu;
       khpq1.q1nivt = peBase.peNivt;
       khpq1.q1nivc = peBase.peNivc;
       khpq1.q1nrpl = peNrpl;

       setll %kds(khpq1:5) pahpq1;
       reade %kds(khpq1:5) pahpq1;
       dow not %eof;
           if q1marp = '1';
              @@imcu = @@imcu + q1imcu;
              @@comi = @@comi + q1comi;
           endif;
        reade %kds(khpq1:5) pahpq1;
       enddo;

       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;
       chain %kds(khpqc:5) pahpqc;
       if %found(pahpqc);
          qcimpn = @@imcu - @@comi;
          qcimpb = @@imcu;
          update p1hpqc;
       endif;

       peImpn = @@imcu - @@comi;
       peImpb = @@imcu;

       return;

     P PLQWEB_updateImportes...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_updateImportesSuperPolizaEndoso():                    *
      *                                   Actualiza los importes bru-*
      *                       to y neto en cabecera de Preliquidacio-*
      *                       nes.                                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peMarc   (input)   Marca/desmarca                        *
      *     peCodi   (input)   Código de Deuda
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_updateImportesSuperPolizaEndoso...
     P                 b

     D PLQWEB_updateImportesSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peMarc                       1    const
     D   peCodi                       2    const
     D   peImpn                      15  2
     D   peImpb                      15  2

     D khpq1           ds                  likerec(p1hpq1:*key)
     D khpqc           ds                  likerec(p1hpqc:*key)

     D @@ok            s               n   inz(*Off)

     D @@imcu          s             15  2
     D @@comi          s             15  2

       PLQWEB_inz();

       clear @@imcu;
       clear @@comi;

       khpq1.q1empr = peBase.peEmpr;
       khpq1.q1sucu = peBase.peSucu;
       khpq1.q1nivt = peBase.peNivt;
       khpq1.q1nivc = peBase.peNivc;
       khpq1.q1nrpl = peNrpl;
       khpq1.q1arcd = peArcd;
       khpq1.q1spol = peSpol;
       khpq1.q1sspo = peSspo;

       select;

       when peCodi = 'DA';

          setll %kds(khpq1:8) pahpq101;
          reade %kds(khpq1:8) pahpq101;
          dow not %eof(pahpq101);
             if peMarc = '1'
                and q1marp = '1';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             if peMarc = '0'
                and q1marp = '0';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             reade %kds(khpq1:8) pahpq101;
          enddo;
          @@ok = *On;

       when peCodi = 'QA';

          setll %kds(khpq1:8) pahpq102;
          reade %kds(khpq1:8) pahpq102;
          dow not %eof(pahpq102);
             if peMarc = '1'
                and q1marp = '1';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             if peMarc = '0'
                and q1marp = '0';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             reade %kds(khpq1:8) pahpq102;
          enddo;
          @@ok = *On;

       when peCodi = 'QT';

          setll %kds(khpq1:8) pahpq103;
          reade %kds(khpq1:8) pahpq103;
          dow not %eof(pahpq103);
             if peMarc = '1'
                and q1marp = '1';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             if peMarc = '0'
                and q1marp = '0';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             reade %kds(khpq1:8) pahpq103;
          enddo;
          @@ok = *On;

       when peCodi = 'QS';

          setll %kds(khpq1:8) pahpq104;
          reade %kds(khpq1:8) pahpq104;
          dow not %eof(pahpq104);
             if peMarc = '1'
                and q1marp = '1';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             if peMarc = '0'
                and q1marp = '0';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             reade %kds(khpq1:8) pahpq104;
          enddo;
          @@ok = *On;

       when peCodi = 'SA';

          setll %kds(khpq1:8) pahpq105;
          reade %kds(khpq1:8) pahpq105;
          dow not %eof(pahpq105);
             if peMarc = '1'
                and q1marp = '1';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             if peMarc = '0'
                and q1marp = '0';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             reade %kds(khpq1:8) pahpq105;
          enddo;
          @@ok = *On;

       when peCodi = 'QP';

          setll %kds(khpq1:8) pahpq106;
          reade %kds(khpq1:8) pahpq106;
          dow not %eof(pahpq106);
             if peMarc = '1'
                and q1marp = '1';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             if peMarc = '0'
                and q1marp = '0';
                @@imcu = @@imcu + q1imcu;
                @@comi = @@comi + q1comi;
             endif;
             reade %kds(khpq1:8) pahpq106;
          enddo;
          @@ok = *On;

       endsl;

       if @@ok;

          khpqc.qcempr = peBase.peEmpr;
          khpqc.qcsucu = peBase.peSucu;
          khpqc.qcnivt = peBase.peNivt;
          khpqc.qcnivc = peBase.peNivc;
          khpqc.qcnrpl = peNrpl;

          chain %kds(khpqc:5) pahpqc;
          if %found(pahpqc);

             select;

             when peMarc = '1';

                qcimpn = qcimpn + @@imcu - @@comi;
                qcimpb = qcimpb + @@imcu;

             when peMarc = '0';

                qcimpn = qcimpn - (@@imcu - @@comi);
                qcimpb = qcimpb - @@imcu;

             endsl;

             update p1hpqc;

             peImpn = qcimpn;
             peImpb = qcimpb;

          endif;

       endif;

       return;

     P PLQWEB_updateImportesSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_tipoDePago(): indica el Tipo de Pago que va a hacer-  *
      *                      se para la Preliquidación.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peTipo   (input)   Tipo de Pago                          *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_tipoDePago...
     P                 b                   export

     D PLQWEB_tipoDePago...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peTipo                       2    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@fech          s              8  0
     D @@d             s              2  0
     D @@m             s              2  0
     D @@a             s              4  0

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       PAR310X3 ( peBase.peEmpr : @@a : @@m : @@d );

       @@fech = (@@a * 10000) + (@@m * 100) + @@d;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
       if peTipo <> 'PN' and peTipo <> 'PB';

          @@Repl =   peTipo +
                     %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0009' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      * Aca agrego controles sobre Cantidad de Facturas Pendientes
      * Es la misma lógica aplicada sobre las preliquidaciones de GAUS.
      * Agrego que solo lo haga con Tipo de Pago = Neto.

      *- Valido Cantidad de facturas
       if (PLQWEB_canfacpend(peBase) >= PLQWEB_canfacperm(peBase))
        and peTipo = 'PN';

       khni201.n2empr = peBase.peEmpr;
       khni201.n2sucu = peBase.peSucu;
       khni201.n2nivt = peBase.peNivt;
       khni201.n2nivc = peBase.peNivc;
       chain %kds(khni201:4) sehni201;
       if not %found(sehni201);
          clear dfnomb;
       endif;

         %subst(@@repl:1:40) = %trim(dfNomb);
         %subst(@@repl:41:3) = %trim(%char(PLQWEB_canfacpend(peBase)));
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0011' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;
       endif;

       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain %kds(khpqc:5) pahpqc;
       if %found(pahpqc);

          qctipo = peTipo;
          update p1hpqc;

       endif;

      * Aca agrego controles sobre Archivo CNTCDC.
      * Si la tabla tiene por fecha que no se pueden hacer preliquidaciones
      * Netas de Comisiones , es error y se muestra el mensaje.

       k1hcdc.cdempr = peBase.peEmpr;
       k1hcdc.cdsucu = peBase.peSucu;
       k1hcdc.cdfer8 = @@fech;
       setll %kds(k1hcdc:3) cntcdc;
       reade %kds(k1hcdc:2) cntcdc;
       dow not %eof(cntcdc);
          if @@fech >= cdfer8;
            if cdptpn = 'N' and peTipo ='PN';
             @@Leng = %len ( %trimr ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0014' :
                           peMsgs : @@Repl  : @@Leng );
             peErro = -1;
             return;
             leave;
              else;
             leave;
            endif;
          endif;
       reade %kds(k1hcdc:2) cntcdc;
       enddo;

       return;

     P PLQWEB_tipoDePago...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_listarPreliquidacion(): recupera la Preliquidación.   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peCant   (input)   Cantidad de Líneas                    *
      *     peRoll   (input)   Forma de Paginado                     *
      *     peOrde   (input)   Ordenamiento                          *
      *     pePosi   (input)   Posicionamiento                       *
      *     pePreg   (output)  Primer Registro Leído                 *
      *     peUreg   (output)  Último Registro Leído                 *
      *     peLdet   (output)  Lista de Detalle                      *
      *     peLdetC  (output)  Cantidad de registros                 *
      *     peMore   (output)  Hay/No hay más registros              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_listarPreliquidacion...
     P                 b                   export

     D PLQWEB_listarPreliquidacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypliq_t) const
     D   pePreg                            likeds(keypliq_t)
     D   peUreg                            likeds(keypliq_t)
     D   peLdet                            likeds(listpliq_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k0ypqp          ds                  likerec(p1hpqp:*key)
     D k1ypqp          ds                  likerec(p1hpqp:*key)
     D k2ypqp          ds                  likerec(p1hpqp01:*key)
     D k3ypqp          ds                  likerec(p1hpqp02:*key)
     D khpqc           ds                  likerec(p1hpqc:*key)

     D @@cant          s             10i 0

     D @@more          s               n

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

       PLQWEB_inz();

       clear peErro;
       clear peMsgs;

       peLdetC = 0;

       @@more = *On;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

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

       @@base = peBase;
       @@nrpl = pePosi.nrpl;

      *- Valido Preliquidación
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = pePosi.nrpl;

       chain(n) %kds(khpqc:5) pahpqc;
       if not %found(pahpqc);

          @@Repl =   %editw ( pePosi.nrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0001' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Posicionamiento de Archivo. Segun peOrde, pePosi, peRoll
       k0ypqp.qpempr = peBase.peEmpr;
       k0ypqp.qpsucu = peBase.peSucu;
       k0ypqp.qpnivt = peBase.peNivt;
       k0ypqp.qpnivc = peBase.peNivc;
       k0ypqp.qpnrpl = pePosi.nrpl;

       select;
         when ( peOrde = 'OPERACUOTA' );
           k1ypqp.qpempr = peBase.peEmpr;
           k1ypqp.qpsucu = peBase.peSucu;
           k1ypqp.qpnivt = peBase.peNivt;
           k1ypqp.qpnivc = peBase.peNivc;
           k1ypqp.qpnrpl = pePosi.nrpl;
           k1ypqp.qparcd = pePosi.arcd;
           k1ypqp.qpspol = pePosi.spol;
           k1ypqp.qpsspo = pePosi.sspo;
           k1ypqp.qprama = pePosi.rama;
           k1ypqp.qparse = pePosi.arse;
           k1ypqp.qpoper = pePosi.oper;
           k1ypqp.qpsuop = pePosi.suop;
           k1ypqp.qppoli = pePosi.poli;
           if ( peRoll = 'F' );
             setgt %kds ( k1ypqp : 13 ) pahpqp;
           else;
             setll %kds ( k1ypqp : 13 ) pahpqp;
           endif;
         when ( peOrde = 'ASEGURADO' );
           k2ypqp.qpempr = peBase.peEmpr;
           k2ypqp.qpsucu = peBase.peSucu;
           k2ypqp.qpnivt = peBase.peNivt;
           k2ypqp.qpnivc = peBase.peNivc;
           k2ypqp.qpnrpl = pePosi.nrpl;
           k2ypqp.qpnomb = pePosi.nomb;
           if ( peRoll = 'F' );
             setgt %kds ( k2ypqp : 6 ) pahpqp01;
           else;
             setll %kds ( k2ypqp : 6 ) pahpqp01;
           endif;
         when ( peOrde = 'RAMAPOLIZA' );
           k3ypqp.qpempr = peBase.peEmpr;
           k3ypqp.qpsucu = peBase.peSucu;
           k3ypqp.qpnivt = peBase.peNivt;
           k3ypqp.qpnivc = peBase.peNivc;
           k3ypqp.qpnrpl = pePosi.nrpl;
           k3ypqp.qprama = pePosi.rama;
           k3ypqp.qppoli = pePosi.poli;
           if ( peRoll = 'F' );
             setgt %kds ( k3ypqp : 7 ) pahpqp02;
           else;
             setll %kds ( k3ypqp : 7 ) pahpqp02;
           endif;
       endsl;

      *- Retrocedo si es paginado 'R'
       if ( peRoll = 'R' );
         select;
           when ( peOrde = 'OPERACUOTA' );
             readpe %kds ( k0ypqp : 5 ) pahpqp;
           when ( peOrde = 'ASEGURADO' );
             readpe %kds ( k0ypqp : 5 ) pahpqp01;
           when ( peOrde = 'RAMAPOLIZA' );
             readpe %kds ( k0ypqp : 5 ) pahpqp02;
         endsl;
         dow ( ( not %eof ) and ( @@cant > 0 ) );
           @@cant -= 1;
           select;
             when ( peOrde = 'OPERACUOTA' );
               readpe %kds ( k0ypqp : 5 ) pahpqp;
             when ( peOrde = 'ASEGURADO' );
               readpe %kds ( k0ypqp : 5 ) pahpqp01;
             when ( peOrde = 'RAMAPOLIZA' );
               readpe %kds ( k0ypqp : 5 ) pahpqp02;
           endsl;
         enddo;
         if %eof;
           @@more = *Off;
           select;
             when ( peOrde = 'OPERACUOTA' );
               setll %kds ( k0ypqp : 5 ) pahpqp;
             when ( peOrde = 'ASEGURADO' );
               setll %kds ( k0ypqp : 5 ) pahpqp01;
             when ( peOrde = 'RAMAPOLIZA' );
               setll %kds ( k0ypqp : 5 ) pahpqp02;
           endsl;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       select;
         when ( peOrde = 'OPERACUOTA' );
           reade %kds ( k0ypqp : 5 ) pahpqp;
         when ( peOrde = 'ASEGURADO' );
           reade %kds ( k0ypqp : 5 ) pahpqp01;
         when ( peOrde = 'RAMAPOLIZA' );
           reade %kds ( k0ypqp : 5 ) pahpqp02;
       endsl;

       pePreg.nrpl = qpnrpl;
       pePreg.arcd = qparcd;
       pePreg.spol = qpspol;
       pePreg.sspo = qpsspo;
       pePreg.rama = qprama;
       pePreg.arse = qparse;
       pePreg.oper = qpoper;
       pePreg.suop = qpsuop;
       pePreg.poli = qppoli;
       pePreg.nomb = qpnomb;

       dow ( ( not %eof ) and ( peLdetC < @@cant ) );

         peLdetC += 1;

         peLdet(peLdetC).arcd = qparcd;
         peLdet(peLdetC).spol = qpspol;
         peLdet(peLdetC).sspo = qpsspo;
         peLdet(peLdetC).rama = qprama;
         peLdet(peLdetC).arse = qparse;
         peLdet(peLdetC).oper = qpoper;
         peLdet(peLdetC).suop = qpsuop;
         peLdet(peLdetC).poli = qppoli;
         peLdet(peLdetC).dant = qpdant;
         peLdet(peLdetC).qant = qpqant;
         peLdet(peLdetC).qact = qpqact;
         peLdet(peLdetC).qsig = qpqsig;
         peLdet(peLdetC).qpos = qpqpos;
         peLdet(peLdetC).sald = qpsald;
         peLdet(peLdetC).nomb = qpnomb;

         peUreg.nrpl = qpnrpl;
         peUreg.arcd = qparcd;
         peUreg.spol = qpspol;
         peUreg.sspo = qpsspo;
         peUreg.rama = qprama;
         peUreg.arse = qparse;
         peUreg.oper = qpoper;
         peUreg.suop = qpsuop;
         peUreg.poli = qppoli;
         peUreg.nomb = qpnomb;

         select;
           when ( peOrde = 'OPERACUOTA' );
             reade %kds ( k0ypqp : 5 ) pahpqp;
           when ( peOrde = 'ASEGURADO' );
             reade %kds ( k0ypqp : 5 ) pahpqp01;
           when ( peOrde = 'RAMAPOLIZA' );
             reade %kds ( k0ypqp : 5 ) pahpqp02;
         endsl;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof;
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

     P PLQWEB_listarPreliquidacion...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_listarCuotas(): recupera todas las cuotas de una Pre- *
      *                                liquidación.                  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peCant   (input)   Cantidad de Líneas                    *
      *     peRoll   (input)   Forma de Paginado                     *
      *     pePosi   (input)   Posicionamiento                       *
      *     pePreg   (output)  Primer Registro Leído                 *
      *     peUreg   (output)  Último Registro Leído                 *
      *     peLdet   (output)  Lista de Detalle                      *
      *     peLdetC  (output)  Cantidad de registros                 *
      *     peMore   (output)  Hay/No hay más registros              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_listarCuotas...
     P                 b                   export

     D PLQWEB_listarCuotas...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keycmar_t) const
     D   pePreg                            likeds(keycmar_t)
     D   peUreg                            likeds(keycmar_t)
     D   peLdet                            likeds(listcmar_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd           ds                  likerec(p1hpqd:*key)
     D khpqc           ds                  likerec(p1hpqc:*key)

     D @@cant          s             10i 0

     D @@more          s               n

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

       PLQWEB_inz();

       clear peErro;
       clear peMsgs;

       peLdetC = 0;

       @@more = *On;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       @@base = peBase;
       @@nrpl = pePosi.nrpl;

      *- Valido Preliquidación
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = pePosi.nrpl;

       chain(n) %kds(khpqc:5) pahpqc;
       if not %found(pahpqc);

          @@Repl =   %editw ( pePosi.nrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0001' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

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

       khpqd.qdempr = peBase.peEmpr;
       khpqd.qdsucu = peBase.peSucu;
       khpqd.qdnivt = peBase.peNivt;
       khpqd.qdnivc = peBase.peNivc;
       khpqd.qdnrpl = pePosi.nrpl;
       khpqd.qdarcd = pePosi.arcd;
       khpqd.qdspol = pePosi.spol;
       khpqd.qdsspo = pePosi.sspo;
       khpqd.qdrama = pePosi.rama;
       khpqd.qdarse = pePosi.arse;
       khpqd.qdoper = pePosi.oper;
       khpqd.qdsuop = pePosi.suop;
       khpqd.qdpoli = pePosi.poli;
       khpqd.qdnrcu = pePosi.nrcu;
       khpqd.qdnrsc = pePosi.nrsc;

       if ( peRoll = 'F' );
          setgt %kds ( khpqd : 15 ) pahpqd;
       else;
          setll %kds ( khpqd : 15 ) pahpqd;
       endif;

       if ( peRoll = 'R' );
         readpe %kds ( khpqd : 5 ) pahpqd;
         dow ( ( not %eof(pahpqd) ) and ( @@cant > 0 ) );
            @@cant -= 1;
            readpe %kds ( khpqd : 5 ) pahpqd;
         enddo;
         if %eof(pahpqd);
           @@more = *Off;
           setll %kds ( khpqd : 5 ) pahpqd;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       reade %kds ( khpqd : 5 ) pahpqd;

       dow ( ( not %eof(pahpqd) ) and ( peLdetC < @@cant ) );

         peLdetC += 1;

         if peLdetC = 1;

            pePreg.nrpl = qdnrpl;
            pePreg.arcd = qdarcd;
            pePreg.spol = qdspol;
            pePreg.sspo = qdsspo;
            pePreg.rama = qdrama;
            pePreg.arse = qdarse;
            pePreg.oper = qdoper;
            pePreg.suop = qdsuop;
            pePreg.poli = qdpoli;
            pePreg.nrcu = qdnrcu;
            pePreg.nrsc = qdnrsc;

         endif;

         peLdet(peLdetC).arcd = qdarcd;
         peLdet(peLdetC).spol = qdspol;
         peLdet(peLdetC).sspo = qdsspo;
         peLdet(peLdetC).rama = qdrama;
         peLdet(peLdetC).arse = qdarse;
         peLdet(peLdetC).oper = qdoper;
         peLdet(peLdetC).suop = qdsuop;
         peLdet(peLdetC).poli = qdpoli;
         peLdet(peLdetC).nrcu = qdnrcu;
         peLdet(peLdetC).nrsc = qdnrsc;
         peLdet(peLdetC).fvto = qdfvto;
         peLdet(peLdetC).imcu = qdimcu;
         peLdet(peLdetC).comi = qdcomi;

         peLdet(peLdetC).nomb = getNombreAsegurado( qdempr
                                                  : qdsucu
                                                  : qdarcd
                                                  : qdspol
                                                  : qdsspo );

         peUreg.nrpl = qdnrpl;
         peUreg.arcd = qdarcd;
         peUreg.spol = qdspol;
         peUreg.sspo = qdsspo;
         peUreg.rama = qdrama;
         peUreg.arse = qdarse;
         peUreg.oper = qdoper;
         peUreg.suop = qdsuop;
         peUreg.poli = qdpoli;
         peUreg.nrcu = qdnrcu;
         peUreg.nrsc = qdnrsc;

         reade %kds ( khpqd : 5 ) pahpqd;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahpqd );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

     P PLQWEB_listarCuotas...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_listarCuotasMarcadas(): recupera Cuotas seleccionadas *
      *                                para pagar.                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peCant   (input)   Cantidad de Líneas                    *
      *     peRoll   (input)   Forma de Paginado                     *
      *     pePosi   (input)   Posicionamiento                       *
      *     pePreg   (output)  Primer Registro Leído                 *
      *     peUreg   (output)  Último Registro Leído                 *
      *     peLdet   (output)  Lista de Detalle                      *
      *     peLdetC  (output)  Cantidad de registros                 *
      *     peMore   (output)  Hay/No hay más registros              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_listarCuotasMarcadas...
     P                 b                   export

     D PLQWEB_listarCuotasMarcadas...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keycmar_t) const
     D   pePreg                            likeds(keycmar_t)
     D   peUreg                            likeds(keycmar_t)
     D   peLdet                            likeds(listcmar_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd           ds                  likerec(p1hpqd:*key)
     D khpqc           ds                  likerec(p1hpqc:*key)

     D @@cant          s             10i 0

     D @@more          s               n

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

       PLQWEB_inz();

       clear peErro;
       clear peMsgs;

       peLdetC = 0;

       @@more = *On;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       @@base = peBase;
       @@nrpl = pePosi.nrpl;

      *- Valido Preliquidación
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = pePosi.nrpl;

       chain(n) %kds(khpqc:5) pahpqc;
       if not %found(pahpqc);

          @@Repl =   %editw ( pePosi.nrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0001' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       else;

      *- Valido Tipo de Pago
      //    if qctipo <> 'PN'
      //    and qctipo <> 'PB';
      //       @@Repl =   %editw ( pePosi.nrpl  : '0      ' );
      //       @@Leng = %len ( %trimr ( @@repl ) );
      //       SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0008' :
      //                   peMsgs : @@Repl  : @@Leng );
      //       peErro = -1;
      //       return;
      //    endif;
         endif;

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

       khpqd.qdempr = peBase.peEmpr;
       khpqd.qdsucu = peBase.peSucu;
       khpqd.qdnivt = peBase.peNivt;
       khpqd.qdnivc = peBase.peNivc;
       khpqd.qdnrpl = pePosi.nrpl;
       khpqd.qdarcd = pePosi.arcd;
       khpqd.qdspol = pePosi.spol;
       khpqd.qdsspo = pePosi.sspo;
       khpqd.qdrama = pePosi.rama;
       khpqd.qdarse = pePosi.arse;
       khpqd.qdoper = pePosi.oper;
       khpqd.qdsuop = pePosi.suop;
       khpqd.qdpoli = pePosi.poli;
       khpqd.qdnrcu = pePosi.nrcu;
       khpqd.qdnrsc = pePosi.nrsc;

       if ( peRoll = 'F' );
          setgt %kds ( khpqd : 15 ) pahpqd;
       else;
          setll %kds ( khpqd : 15 ) pahpqd;
       endif;

       if ( peRoll = 'R' );
         readpe %kds ( khpqd : 5 ) pahpqd;
         dow ( ( not %eof(pahpqd) ) and ( @@cant > 0 ) );
            if qdmarp = '1';
               @@cant -= 1;
            endif;
            readpe %kds ( khpqd : 5 ) pahpqd;
         enddo;
         if %eof(pahpqd);
           @@more = *Off;
           setll %kds ( khpqd : 5 ) pahpqd;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       reade %kds ( khpqd : 5 ) pahpqd;

       dow ( ( not %eof(pahpqd) ) and ( peLdetC < @@cant ) );

         if qdmarp = '1';

            peLdetC += 1;

            if peLdetC = 1;

               pePreg.nrpl = qdnrpl;
               pePreg.arcd = qdarcd;
               pePreg.spol = qdspol;
               pePreg.sspo = qdsspo;
               pePreg.rama = qdrama;
               pePreg.arse = qdarse;
               pePreg.oper = qdoper;
               pePreg.suop = qdsuop;
               pePreg.poli = qdpoli;
               pePreg.nrcu = qdnrcu;
               pePreg.nrsc = qdnrsc;

            endif;

            peLdet(peLdetC).arcd = qdarcd;
            peLdet(peLdetC).spol = qdspol;
            peLdet(peLdetC).sspo = qdsspo;
            peLdet(peLdetC).rama = qdrama;
            peLdet(peLdetC).arse = qdarse;
            peLdet(peLdetC).oper = qdoper;
            peLdet(peLdetC).suop = qdsuop;
            peLdet(peLdetC).poli = qdpoli;
            peLdet(peLdetC).nrcu = qdnrcu;
            peLdet(peLdetC).nrsc = qdnrsc;
            peLdet(peLdetC).fvto = qdfvto;
            peLdet(peLdetC).imcu = qdimcu;
            peLdet(peLdetC).comi = qdcomi;

            peLdet(peLdetC).nomb = getNombreAsegurado( qdempr
                                                     : qdsucu
                                                     : qdarcd
                                                     : qdspol
                                                     : qdsspo );

            peUreg.nrpl = qdnrpl;
            peUreg.arcd = qdarcd;
            peUreg.spol = qdspol;
            peUreg.sspo = qdsspo;
            peUreg.rama = qdrama;
            peUreg.arse = qdarse;
            peUreg.oper = qdoper;
            peUreg.suop = qdsuop;
            peUreg.poli = qdpoli;
            peUreg.nrcu = qdnrcu;
            peUreg.nrsc = qdnrsc;

         endif;

         reade %kds ( khpqd : 5 ) pahpqd;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahpqd );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

     P PLQWEB_listarCuotasMarcadas...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_insertarMontoEfectivo(): ingresa el importe que va a  *
      *                                 pagarse en efectivo.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peEfvo   (input)   Importe en Efectivo                   *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_insertarMontoEfectivo...
     P                 b                   export

     D PLQWEB_insertarMontoEfectivo...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

     D @@timpo         s             15  2 inz(*Zeros)
     D @@simpo         s             15  2 inz(*Zeros)
     D hay_efectivo    s              1N

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;

       if %found(pahpqc)
          and qctipo <> 'PN'
          and qctipo <> 'PB';

          @@Repl =   %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0008' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 2;
       setll %kds(khpqv:6) pahpqv;
       hay_efectivo = %equal(pahpqv);

      *- Valido Monto Insertado
       if peEfvo <= *Zeros;

          if not hay_efectivo;
             @@Repl =   %editw ( peEfvo : '           0 ,  -' );
             @@Leng = %len ( %trimr ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1000' :
                            peMsgs : @@Repl  : @@Leng );
             peErro = -1;
             return;
          endif;

          setll %kds(khpqv:6) pahpqv;
          reade %kds(khpqv:6) pahpqv;
          dow not %eof;
              delete p1hpqv;
           reade %kds(khpqv:6) pahpqv;
          enddo;
          return;

       endif;

      *- Valido Monto Total
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          select;
          when qctipo = 'PN';
             @@timpo = qcimpn;
          when qctipo = 'PB';
             @@timpo = qcimpb;
          endsl;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;

       setll    %kds ( khpqv : 5 ) pahpqv;
       reade(n) %kds ( khpqv : 5 ) pahpqv;
       dow not %eof(pahpqv);

          if qvivcv <> 2;
             @@simpo = @@simpo + qvimcu;
          endif;

          reade(n) %kds ( khpqv : 5 ) pahpqv;
       enddo;

       @@simpo = @@simpo + peEfvo;

       if @@simpo > @@timpo;

          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1022' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 2;
       khpqv.qvivbc = *Zeros;
       khpqv.qvivch = *Blanks;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          qvfech = %dec(%date():*iso);
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          update p1hpqv;
       else;
          qvempr = peBase.peEmpr;
          qvsucu = peBase.peSucu;
          qvnivt = peBase.peNivt;
          qvnivc = peBase.peNivc;
          qvnrpl = peNrpl;
          qvivcv = 2;
          qvivbc = *Zeros;
          qvivch = *Blanks;
          qvfech = %dec(%date():*iso);
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          write p1hpqv;
       endif;

       return;

     P PLQWEB_insertarMontoEfectivo...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_insertarCheque(): ingresa un cheque a la Preliquida-  *
      *                          ción.                               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNche   (input)   Número de Cheque                      *
      *     peFche   (input)   Fecha del Cheque (aaaammdd)           *
      *     peEfvo   (input)   Importe                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_insertarCheque...
     P                 b                   export

     D PLQWEB_insertarCheque...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

     D wchqval         s               n   inz(*Off)
     D i               s             10i 0

     D @@timpo         s             15  2 inz(*Zeros)
     D @@simpo         s             15  2 inz(*Zeros)

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;

       if %found(pahpqc)
          and qctipo <> 'PN'
          and qctipo <> 'PB';

          @@Repl =   %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0008' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Monto Insertado
       if peEfvo < *Zeros;

          @@Repl =   %editw ( peEfvo : '           0 ,  -' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1000' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Código de Banco
       setll (peIvbc) cntbco;
       if not %equal(cntbco);

          @@Repl =   %editw ( peIvbc : '0  ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1010' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Número de Cheque
       for i = 1 to 30;
          if %subst(peNche:i:1) <> *Blanks
             and %subst(peNche:i:1) <> '0';
             wchqval = *On;
             leave;
          endif;
       endfor;

       if not wchqval;

          @@Repl = peNche;
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1011' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Monto Total
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          select;
          when qctipo = 'PN';
             @@timpo = qcimpn;
          when qctipo = 'PB';
             @@timpo = qcimpb;
          endsl;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;

       setll    %kds ( khpqv : 5 ) pahpqv;
       reade(n) %kds ( khpqv : 5 ) pahpqv;
       dow not %eof(pahpqv);

          if qvivcv = 1
             and qvivbc = peIvbc
             and qvivch = peNche;
          else;
             @@simpo = @@simpo + qvimcu;
          endif;

          reade(n) %kds ( khpqv : 5 ) pahpqv;
       enddo;

       @@simpo = @@simpo + peEfvo;

       if @@simpo > @@timpo;

          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1022' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 1;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNche;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          qvfech = peFche;
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          update p1hpqv;
       else;
          qvempr = peBase.peEmpr;
          qvsucu = peBase.peSucu;
          qvnivt = peBase.peNivt;
          qvnivc = peBase.peNivc;
          qvnrpl = peNrpl;
          qvivcv = 1;
          qvivbc = peIvbc;
          qvivch = peNche;
          qvfech = peFche;
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          write p1hpqv;
       endif;

       return;

     P PLQWEB_insertarCheque...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_borrarCheque(): elimina un cheque de una Preliquida-  *
      *                          ción.                               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNche   (input)   Número de Cheque                      *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_borrarCheque...
     P                 b                   export

     D PLQWEB_borrarCheque...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Cheque

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 1;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNche;

       setll %kds ( khpqv : 8 ) pahpqv;
       if not %equal(pahpqv);

          @@Repl = peNche + %editw(peNrpl:'0      ');
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1012' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          delete pahpqv;
       endif;

       return;

     P PLQWEB_borrarCheque...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_insertarDepositoBancario(): ingresa los datos de un   *
      *                                    depósito bancario a la    *
      *                                    Preliquidación.           *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNros   (input)   Número Secuencial                     *
      *     peImpo   (input)   Importe                               *
      *     peFdep   (input)   Fecha de Deposito                     *
      *     peArch   (input)   Nombre de archivo                     *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_insertarDepositoBancario...
     P                 b                   export

     D PLQWEB_insertarDepositoBancario...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNros                      30a   const
     D   peImpo                      15  2 const
     D   peFdep                       8  0 const
     D   peArch                     512a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

     D wdepval         s               n   inz(*Off)
     D i               s             10i 0

     D @@timpo         s             15  2 inz(*Zeros)
     D @@simpo         s             15  2 inz(*Zeros)

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;

       if %found(pahpqc)
          and qctipo <> 'PN'
          and qctipo <> 'PB';

          @@Repl =   %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0008' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Monto Insertado
       if peImpo < *Zeros;

          @@Repl =   %editw ( peImpo : '           0 ,  -' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1000' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Código de Banco
       setll (peIvbc) cntbco;
       if not %equal(cntbco);

          @@Repl =   %editw ( peIvbc : '0  ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1010' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Número de Depósito
       for i = 1 to 30;
          if %subst(peNros:i:1) <> *Blanks
             and %subst(peNros:i:1) <> '0';
             wdepval = *On;
             leave;
          endif;
       endfor;

       if not wdepval;

          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1020' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Monto Total
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          select;
          when qctipo = 'PN';
             @@timpo = qcimpn;
          when qctipo = 'PB';
             @@timpo = qcimpb;
          endsl;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;

       setll    %kds ( khpqv : 5 ) pahpqv;
       reade(n) %kds ( khpqv : 5 ) pahpqv;
       dow not %eof(pahpqv);

          if qvivcv = 4
             and qvivbc = peIvbc
             and qvivch = peNros;
          else;
             @@simpo = @@simpo + qvimcu;
          endif;

          reade(n) %kds ( khpqv : 5 ) pahpqv;
       enddo;

       @@simpo = @@simpo + peImpo;

       if @@simpo > @@timpo;

          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1022' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 4;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNros;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          qvfech = peFdep;
          qvimcu = peImpo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          qvarch = peArch;
          update p1hpqv;
       else;
          qvempr = peBase.peEmpr;
          qvsucu = peBase.peSucu;
          qvnivt = peBase.peNivt;
          qvnivc = peBase.peNivc;
          qvnrpl = peNrpl;
          qvivcv = 4;
          qvivbc = peIvbc;
          qvivch = peNros;
          qvfech = peFdep;
          qvimcu = peImpo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          qvarch = peArch;
          write p1hpqv;
       endif;

       return;

     P PLQWEB_insertarDepositoBancario...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_borrarDepositoBancario(): elimina un depósito ingre-  *
      *                                  sado.                       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNdep   (input)   Número de Depósito                    *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_borrarDepositoBancario...
     P                 b                   export

     D PLQWEB_borrarDepositoBancario...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNdep                      30a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Depósito

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 4;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNdep;

       setll %kds ( khpqv : 8 ) pahpqv;
       if not %equal(pahpqv);

          @@Repl = peNdep + %editw(peNrpl:'0      ');
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1021' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          delete pahpqv;
       endif;

       return;

     P PLQWEB_borrarDepositoBancario...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_enviarPreliquidacion(): envía la Preliquidación a la  *
      *                                Compañía.                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_enviarPreliquidacion...
     P                 b                   export

     D PLQWEB_enviarPreliquidacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

     D @@timpo         s             15  2 inz(*Zeros)
     D @@simpo         s             15  2 inz(*Zeros)
     D @@vsys          s            512a
     D @@impu          s              1a

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc)
          and qctipo <> 'PN'
          and qctipo <> 'PB';

          @@Repl =   %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0008' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Monto Total
       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          select;
          when qctipo = 'PN';
             @@timpo = qcimpn;
          when qctipo = 'PB';
             @@timpo = qcimpb;
          endsl;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;

       setll    %kds ( khpqv : 5 ) pahpqv;
       reade(n) %kds ( khpqv : 5 ) pahpqv;
       dow not %eof(pahpqv);

          @@simpo = @@simpo + qvimcu;

          reade(n) %kds ( khpqv : 5 ) pahpqv;
       enddo;

       if @@simpo > @@timpo;

          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1022' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       if @@timpo > @@simpo;

          @@Repl =   %editw ( @@timpo - @@simpo : '0              ,  -' ) +
                     %editw ( peNrpl : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW9000' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       chain %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          qcmarp = '9';
          update p1hpqc;
       endif;

       PLQWEB_cleanUp( peBase : peNrpl );

       @@impu = 'N';
       if SVPVLS_getValSys( 'HPQWIMPAUT' : *omit : @@vsys );
          @@impu = @@vsys;
       endif;

       if (@@impu = 'S');
          PLQWEB_sndDataQueue( peBase.peEmpr
                             : peBase.peSucu
                             : peBase.peNivt
                             : peBase.peNivc
                             : peNrpl        );
       endif;

       PLQWEB_sndEmail( peBase : peNrpl );

       return;

     P PLQWEB_enviarPreliquidacion...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnteriorI():   marca p/pagar toda la Deuda *
      *                               Anterior de la preliquidación. *
      *                               (Interno).                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarDeudaAnteriorI...
     P                 b

     D PLQWEB_marcarDeudaAnteriorI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd01         ds                  likerec(pqd01:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('DA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

       khpqd01.qdempr = peBase.peEmpr;
       khpqd01.qdsucu = peBase.peSucu;
       khpqd01.qdnivt = peBase.peNivt;
       khpqd01.qdnivc = peBase.peNivc;
       khpqd01.qdnrpl = peNrpl;

       setll %kds(khpqd01:5) pahpqd01;
       reade %kds(khpqd01:5) pahpqd01;

       dow not %eof(pahpqd01);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd01:5) pahpqd01;
       enddo;

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_marcarDeudaAnteriorI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnteriorI():   Desmarca p/pagar toda la *
      *                                  Deuda Anterior de la Preli- *
      *                                  quidación. (Interno).       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarDeudaAnteriorI...
     P                 b

     D PLQWEB_desmarcarDeudaAnteriorI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd01         ds                  likerec(pqd01:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('DA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

       khpqd01.qdempr = peBase.peEmpr;
       khpqd01.qdsucu = peBase.peSucu;
       khpqd01.qdnivt = peBase.peNivt;
       khpqd01.qdnivc = peBase.peNivc;
       khpqd01.qdnrpl = peNrpl;

       setll %kds(khpqd01:5) pahpqd01;
       reade %kds(khpqd01:5) pahpqd01;

       dow not %eof(pahpqd01);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd01:5) pahpqd01;
       enddo;

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_desmarcarDeudaAnteriorI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnteriorI(): marca para pagar toda la   *
      *                                  Quincena Anterior de la     *
      *                                  Preliquidación. (Interno).  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaAnteriorI...
     P                 b

     D PLQWEB_marcarQuincenaAnteriorI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd02         ds                  likerec(pqd02:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

       khpqd02.qdempr = peBase.peEmpr;
       khpqd02.qdsucu = peBase.peSucu;
       khpqd02.qdnivt = peBase.peNivt;
       khpqd02.qdnivc = peBase.peNivc;
       khpqd02.qdnrpl = peNrpl;

       setll %kds(khpqd02:5) pahpqd02;
       reade %kds(khpqd02:5) pahpqd02;

       dow not %eof(pahpqd02);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd02:5) pahpqd02;
       enddo;

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_marcarQuincenaAnteriorI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnteriorI():   Desmarca p/pagar toda *
      *                                     la Quincena Anterior de  *
      *                                     la prequidación.         *
      *                                     (Interno).               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaAnteriorI...
     P                 b

     D PLQWEB_desmarcarQuincenaAnteriorI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd02         ds                  likerec(pqd02:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

       khpqd02.qdempr = peBase.peEmpr;
       khpqd02.qdsucu = peBase.peSucu;
       khpqd02.qdnivt = peBase.peNivt;
       khpqd02.qdnivc = peBase.peNivc;
       khpqd02.qdnrpl = peNrpl;

       setll %kds(khpqd02:5) pahpqd02;
       reade %kds(khpqd02:5) pahpqd02;

       dow not %eof(pahpqd02);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd02:5) pahpqd02;
       enddo;

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_desmarcarQuincenaAnteriorI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI():              *
      *                                  marca p/pagar toda la Deuda *
      *                               Anterior de la preliquidación. *
      *                               (Interno).                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI...
     P                 b

     D PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd01         ds                  likerec(pqd01:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('DA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

       khpqd01.qdempr = peBase.peEmpr;
       khpqd01.qdsucu = peBase.peSucu;
       khpqd01.qdnivt = peBase.peNivt;
       khpqd01.qdnivc = peBase.peNivc;
       khpqd01.qdnrpl = peNrpl;
       khpqd01.qdarcd = peArcd;
       khpqd01.qdspol = peSpol;
       khpqd01.qdsspo = peSspo;

       setll %kds(khpqd01:8) pahpqd01;
       reade %kds(khpqd01:8) pahpqd01;

       dow not %eof(pahpqd01);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd01:8) pahpqd01;
       enddo;

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       return;

     P PLQWEB_marcarDeudaAnteriorSuperPolizaEndosoI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI():           *
      *                                     Desmarca p/pagar toda la *
      *                                  Deuda Anterior de la Preli- *
      *                                  quidación. (Interno).       *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI...
     P                 b

     D PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd01         ds                  likerec(pqd01:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('DA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

       khpqd01.qdempr = peBase.peEmpr;
       khpqd01.qdsucu = peBase.peSucu;
       khpqd01.qdnivt = peBase.peNivt;
       khpqd01.qdnivc = peBase.peNivc;
       khpqd01.qdnrpl = peNrpl;
       khpqd01.qdarcd = peArcd;
       khpqd01.qdspol = peSpol;
       khpqd01.qdsspo = peSspo;

       setll %kds(khpqd01:8) pahpqd01;
       reade %kds(khpqd01:8) pahpqd01;

       dow not %eof(pahpqd01);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd01:8) pahpqd01;
       enddo;

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       return;

     P PLQWEB_desmarcarDeudaAnteriorSuperPolizaEndosoI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI():           *
      *                                   marca para pagar toda la   *
      *                                  Quincena Anterior de la     *
      *                                  Preliquidación. (Interno).  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI...
     P                 b

     D PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd02         ds                  likerec(pqd02:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

       khpqd02.qdempr = peBase.peEmpr;
       khpqd02.qdsucu = peBase.peSucu;
       khpqd02.qdnivt = peBase.peNivt;
       khpqd02.qdnivc = peBase.peNivc;
       khpqd02.qdnrpl = peNrpl;
       khpqd02.qdarcd = peArcd;
       khpqd02.qdspol = peSpol;
       khpqd02.qdsspo = peSspo;

       setll %kds(khpqd02:8) pahpqd02;
       reade %kds(khpqd02:8) pahpqd02;

       dow not %eof(pahpqd02);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd02:8) pahpqd02;
       enddo;

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       return;

     P PLQWEB_marcarQuincenaAnteriorSuperPolizaEndosoI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaAnteriorSuperPlozaEndosoI():         *
      *                                        Desmarca p/pagar toda *
      *                                     la Quincena Anterior de  *
      *                                     la prequidación.         *
      *                                     (Interno).               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndosoI...
     P                 b

     D PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndosoI...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd02         ds                  likerec(pqd02:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QA')

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

       khpqd02.qdempr = peBase.peEmpr;
       khpqd02.qdsucu = peBase.peSucu;
       khpqd02.qdnivt = peBase.peNivt;
       khpqd02.qdnivc = peBase.peNivc;
       khpqd02.qdnrpl = peNrpl;
       khpqd02.qdarcd = peArcd;
       khpqd02.qdspol = peSpol;
       khpqd02.qdsspo = peSspo;

       setll %kds(khpqd02:8) pahpqd02;
       reade %kds(khpqd02:8) pahpqd02;

       dow not %eof(pahpqd02);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd02:8) pahpqd02;
       enddo;

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       return;

     P PLQWEB_desmarcarQuincenaAnteriorSuperPolizaEndosoI...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_validaPreliquidacion(): Cheque la existencia de la    *
      *                                Preliquidación y que la misma *
      *                                no haya ya sido enviada.      *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     P PLQWEB_validaPreliquidacion...
     P                 b
     D PLQWEB_validaPreliquidacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)

       PLQWEB_inz();

       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds(khpqc:5) pahpqc;
       if not %found(pahpqc);

          @@Repl =   %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0001' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       else;

          if qcmarp = '9';

             @@Repl =   %editw ( peNrpl  : '0      ' );
             @@Leng = %len ( %trimr ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0002' :
                            peMsgs : @@Repl  : @@Leng );
             peErro = -1;
             return;

          endif;

       endif;

       return;

     P PLQWEB_validaPreliquidacion...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_validaSuperpóliza():    Cheque la existencia de la    *
      *                                Superpóliza y el Suplemento   *
      *                                solicitados.                  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *

     P PLQWEB_validaSuperpoliza...
     P                 b
     D PLQWEB_validaSuperpoliza...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khec0           ds                  likerec(p1hec0:*key)
     D khec1           ds                  likerec(p1hec1:*key)
     D khpqs           ds                  likerec(p1hpqs:*key)

       peErro = *Zeros;

       PLQWEB_inz();

       khec0.c0empr = peBase.peEmpr;
       khec0.c0sucu = peBase.peSucu;
       khec0.c0arcd = peArcd;
       khec0.c0spol = peSpol;

       setll %kds(khec0:4) pahec0;
       if not %equal(pahec0);

          @@Repl =   %editw ( peArcd  : '0     ' ) +
                     %editw ( peSpol  : '0        ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0003' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khec1.c1empr = peBase.peEmpr;
       khec1.c1sucu = peBase.peSucu;
       khec1.c1arcd = peArcd;
       khec1.c1spol = peSpol;
       khec1.c1sspo = peSspo;

       setll %kds(khec1:5) pahec1;
       if not %equal(pahec1);

          @@Repl =   %editw ( peArcd  : '0     ' ) +
                     %editw ( peSpol  : '0        ' ) +
                     %editw ( peSspo  : '0  ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0004' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khpqs.qsempr = peBase.peEmpr;
       khpqs.qssucu = peBase.peSucu;
       khpqs.qsnivt = peBase.peNivt;
       khpqs.qsnivc = peBase.peNivc;
       khpqs.qsnrpl = peNrpl;
       khpqs.qsarcd = peArcd;
       khpqs.qsspol = peSpol;

       setll %kds(khpqs:7) pahpqs;
       if not %equal(pahpqs);

          @@Repl =   %editw ( peArcd  : '0     ' ) +
                     %editw ( peSpol  : '0        ' ) +
                     %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0005' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khpqs.qsempr = peBase.peEmpr;
       khpqs.qssucu = peBase.peSucu;
       khpqs.qsnivt = peBase.peNivt;
       khpqs.qsnivc = peBase.peNivc;
       khpqs.qsnrpl = peNrpl;
       khpqs.qsarcd = peArcd;
       khpqs.qsspol = peSpol;
       khpqs.qssspo = peSspo;

       setll %kds(khpqs:8) pahpqs;
       if not %equal(pahpqs);

          @@Repl =   %editw ( peArcd  : '0     ' ) +
                     %editw ( peSpol  : '0        ' ) +
                     %editw ( peNrpl  : '0      ' ) +
                     %editw ( peSspo  : '0  ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0006' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       return;

     P PLQWEB_validaSuperpoliza...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P PLQWEB_inz      b                   export
     D PLQWEB_inz      pi

       if initialized;
          return;
       endif;

       if not %open(pahcc214);
          open pahcc214;
       endif;

       if not %open(pahcd502);
          open pahcd502;
       endif;

       if not %open(pahec0);
          open pahec0;
       endif;

       if not %open(pahec1);
          open pahec1;
       endif;

       if not %open(pahed0);
          open pahed0;
       endif;

       if not %open(pahed3);
          open pahed3;
       endif;

       if not %open(pahpqd);
          open pahpqd;
       endif;

       if not %open(pahpqd01);
          open pahpqd01;
       endif;

       if not %open(pahpqd02);
          open pahpqd02;
       endif;

       if not %open(pahpqd03);
          open pahpqd03;
       endif;

       if not %open(pahpqd04);
          open pahpqd04;
       endif;

       if not %open(pahpqd05);
          open pahpqd05;
       endif;

       if not %open(pahpq1);
          open pahpq1;
       endif;

       if not %open(pahpq101);
          open pahpq101;
       endif;

       if not %open(pahpq102);
          open pahpq102;
       endif;

       if not %open(pahpq103);
          open pahpq103;
       endif;

       if not %open(pahpq104);
          open pahpq104;
       endif;

       if not %open(pahpq105);
          open pahpq105;
       endif;

       if not %open(pahpqc);
          open pahpqc;
       endif;

       if not %open(pahpqp);
          open pahpqp;
       endif;

       if not %open(pahpqp01);
          open pahpqp01;
       endif;

       if not %open(pahpqp02);
          open pahpqp02;
       endif;

       if not %open(pahpqs);
          open pahpqs;
       endif;

       if not %open(pahpqv);
          open pahpqv;
       endif;

       if not %open(cntbco);
          open cntbco;
       endif;

       if not %open(sehni201);
          open sehni201;
       endif;

       if not %open(gnhdaf);
          open gnhdaf;
       endif;

       if not %open(gntmon);
          open gntmon;
       endif;

       if not %open(pawpc002);
          open pawpc002;
       endif;

       if not %open(pahiva);
          open pahiva;
       endif;

       if not %open(cntfpp);
          open cntfpp;
       endif;

       if not %open(cntcdc);
          open cntcdc;
       endif;

       if not %open(pahec186);
          open pahec186;
       endif;

       if not %open(pahec187);
          open pahec187;
       endif;

       if not %open(pahpqd06);
          open pahpqd06;
       endif;

       if not %open(pahpq106);
          open pahpq106;
       endif;

       initialized = *On;

       return;

     P PLQWEB_inz      e

      * ------------------------------------------------------------ *
      * PLQWEB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P PLQWEB_End      b                   export
     D PLQWEB_End      pi


       if initialized;
          close *All;
          initialized = *Off;
       endif;

       return;

     P PLQWEB_End      e

      * ------------------------------------------------------------ *

     P getNombreAsegurado...
     P                 B
     D getNombreAsegurado...
     D                 pi            40a
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

     D k1hec1          ds                  likerec(p1hec1:*key)

      /free

       k1hec1.c1empr = peEmpr;
       k1hec1.c1sucu = peSucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       k1hec1.c1sspo = peSspo;
       chain %kds(k1hec1) pahec1;
       if not %found;
          return *all'*';
       endif;

       chain c1asen gnhdaf;
       if not %found;
          return *all'*';
       endif;

       return dfnomb;

      /end-free

     P getNombreAsegurado...
     P                 E

      * ------------------------------------------------------------ *
      * calculaFechas(): Calcula las fechas de cada quincena         *
      *                                                              *
      *    peFeda     (output)    Fecha Deuda Anterior               *
      *    peFeqa     (output)    Fecha Quincena Anterior            *
      *    peFeqt     (output)    Fecha Quincena Actual              *
      *    peFeqs     (output)    Fecha Quincena Siguiente           *
      *    peFeqp     (output)    Fecha Posterior                    *
      *    peFesa     (output)    Fecha Saldo                        *
      *                                                              *
      * ------------------------------------------------------------ *
     P calculaFechas   B
     D calculaFechas   pi
     D  peFeda                        8  0
     D  peFeqa                        8  0
     D  peFeqt                        8  0
     D  peFeqs                        8  0
     D  peFeqp                        8  0

     D SPLSTDAY        pr                  extpgm('SPLSTDAY')
     D  peFemm                        2  0 const
     D  peFema                        4  0 const
     D  peFemd                        2  0

     D peDia           s              2  0
     D @dia            s              2  0
     D @mes            s              2  0
     D @aÑo            s              4  0

      /free

       @dia = *day;
       @mes = *month;
       @aÑo = *year;

       // ------------------------------------
       // Hoy es segunda quincena del mes
       // ------------------------------------
       if @dia >= 16;
          if @mes = 1;
             peFeda = ( (@aÑo - 1) * 10000 ) + 1231;
           else;
             SPLSTDAY( @mes-1: @aÑo: peDia);
             peFeda = (@aÑo * 10000 ) + ((@mes-1)*100) + peDia;
          endif;
          peFeqa = (@aÑo*10000) + (@mes*100) + 15;
          SPLSTDAY( @mes : @aÑo: peDia );
          peFeqt = (@aÑo * 10000) + (@mes * 100) + peDia;
          if @mes = 12;
             peFeqs = ((@aÑo+1)*10000) + 0115;
             peFeqp = ((@aÑo+1)*10000) + 0131;
           else;
             peFeqs = (@aÑo*10000) + ((@mes+1)*100) + 15;
             peFeqp = (@aÑo*10000) + ((@mes+1)*100) + peDia;
          endif;
       endif;

       // ------------------------------------
       // Hoy es primera quincena del mes
       // ------------------------------------
       if @dia <= 15;
          if @mes = 1;
             peFeda = ((@aÑo-1)*10000) + 1215;
           else;
             peFeda = (@aÑo*10000) + ((@mes-1)*100) + 15;
          endif;
          if @mes = 1;
             peFeqa = ((@aÑo-1)*10000) + 1231;
           else;
             SPLSTDAY( @mes-1: @aÑo: peDia );
             peFeqa = (@aÑo*10000) + ((@mes-1)*100) + peDia;
          endif;
          peFeqt = (@aÑo * 10000) + (@mes * 100) + 15;
          SPLSTDAY( @mes: @aÑo: peDia );
          peFeqs = (@aÑo*10000) + (@mes*100) + peDia;
          peFeqp = (@aÑo*10000) + ((@mes+1)*100) + 15;
       endif;

      /end-free

     P calculaFechas   E

      * ------------------------------------------------------------ *
      * PLQWEB_canfacpend: Cantidad de Facturas pendientes que tiene *
      *                    un productor.                             *
      *                                                              *
      *     peEmpr   (input)   Parametros Base                       *
      *     peSucu   (input)   Número de Preliquidación              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Número de Intermediario               *
      *     peCant   (output)  Cantidad de Facturas Pendientes       *
      *                                                              *
      * ------------------------------------------------------------ *

     P PLQWEB_canfacpend...
     P                 b                   export
     D PLQWEB_canfacpend...
     D                 pi             3  0
     D   peBase                            likeds(paramBase) const

      /free

       peCant = 0;

       khni201.n2empr = peBase.peEmpr;
       khni201.n2sucu = peBase.peSucu;
       khni201.n2nivt = peBase.peNivt;
       khni201.n2nivc = peBase.peNivc;
       chain %kds(khni201:4) sehni201;
        if %found(sehni201);
       k1hiva.ivempr = peBase.peEmpr;
       k1hiva.ivsucu = peBase.peSucu;
       k1hiva.ivcoma = n2coma;
       k1hiva.ivnrma = n2nrma;
       setll %kds(k1hiva:4) pahiva;
       reade %kds(k1hiva:4) pahiva;
       dow not %eof;
        if ivmarp = '4';
          peCant += 1;
        endif;
       reade %kds(k1hiva:4) pahiva;
       enddo;
       endif;

       return peCant;

      /end-free

     P PLQWEB_canfacpend...
     P                 E
      * ------------------------------------------------------------ *
      * PLQWEB_canfacperm: Cantidad de Facturas permitidas           *
      *                                                              *
      *     peEmpr   (input)   Parametros Base                       *
      *     peSucu   (input)   Número de Preliquidación              *
      *     peCanp   (input)   Cantidad de Facturas Pendientes       *
      *                                                              *
      * ------------------------------------------------------------ *

     P PLQWEB_canfacperm...
     P                 b                   export
     D PLQWEB_canfacperm...
     D                 pi             3  0
     D   peBase                            likeds(paramBase) const

       peCanp = 0;

       in control_fact;
       unlock control_fact;
       peCanp = control_fact.contfact;
       return peCanp;

     P PLQWEB_canfacperm...
     P                 E

      * ------------------------------------------------------------ *
      * PLQWEB_listaValores(): Lista Valores ingresados.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peLval   (output)  Lista de Valores                      *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_listaValores...
     P                 B                   Export
     D PLQWEB_listaValores...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peLval                            likeds(listaValores_t) dim(99)
     D   peLvalC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hpqv          ds                  likerec(p1hpqv:*key)
     D fecha           s             10d

      /free

       PLQWEB_inz();

       k1hpqv.qvempr = peBase.peEmpr;
       k1hpqv.qvsucu = peBase.peSucu;
       k1hpqv.qvnivt = peBase.peNivt;
       k1hpqv.qvnivc = peBase.peNivc;
       k1hpqv.qvnrpl = peNrpl;

       setll %kds(k1hpqv:5) pahpqv;
       reade(n) %kds(k1hpqv:5) pahpqv;
       dow not %eof;

           if peLvalC < 99;
              peLvalC += 1;
              peLval(peLvalC).ivcv = qvivcv;
              peLval(peLvalC).imcu = qvimcu;
              peLval(peLvalC).ivch = qvivch;
              peLval(peLvalC).fech = qvfech;
              peLval(peLvalC).ivbc = qvivbc;

              chain qvivcv cntfpp;
              if not %found;
                 pfivdv = *blanks;
              endif;
              peLval(peLvalC).ivdv  = pfivdv;
              if qvimcu = 0;
                 peLval(peLvalC).imcua = '$0,00';
               else;
                 peLval(peLvalC).imcua = '$'
                       + %trim(%editw(qvimcu:' .   .   .   . 0 ,  '));
              endif;
              if qvfech <> 0;
                 qvfech = gira_fecha(qvfech:'DMA');
                 fecha = %date(qvfech:*eur);
                 peLval(peLvalC).fecha = %char(fecha:*eur);
                 peLval(peLvalC).fecha = %scanrpl( '.'
                                                 : '/'
                                                 : peLval(peLvalC).fecha);
               else;
                 peLval(peLvalC).fecha = '00/00/0000';
              endif;

              chain qvivbc cntbco;
              if not %found;
                 bcnomb = *blanks;
              endif;
              peLval(peLvalC).nomb = bcnomb;

           endif;

        reade(n) %kds(k1hpqv:5) pahpqv;
       enddo;

      /end-free

     P PLQWEB_listaValores...
     P                 E

      * ------------------------------------------------------------ *
      * PLQWEB_guardar(): Guarda Preliquidacion.                     *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_guardar...
     P                 B                   Export
     D PLQWEB_guardar...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hpqc          ds                  likerec(p1hpqc:*key)

      /free

       PLQWEB_inz();

       PLQWEB_validaPreliquidacion( peBase
                                  : peNrpl
                                  : peErro
                                  : peMsgs );

       if peErro = -1;
          return;
       endif;

       k1hpqc.qcempr = peBase.peEmpr;
       k1hpqc.qcsucu = peBase.peSucu;
       k1hpqc.qcnivt = peBase.peNivt;
       k1hpqc.qcnivc = peBase.peNivc;
       k1hpqc.qcnrpl = peNrpl;
       chain %kds(k1hpqc:5) pahpqc;
       if %found;
          qcmarp = 'G';
          update p1hpqc;
       endif;

       return;

      /end-free

     P PLQWEB_guardar...
     P                 E

      * ------------------------------------------------------------ *
      * PLQWEB_marcarEnviadaPorMail(): Marcar como enviada por mail  *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarEnviadaPorMail...
     P                 b                   export
     D PLQWEB_marcarEnviadaPorMail...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hpqc          ds                  likerec(p1hpqc:*key)

      /free

       PLQWEB_inz();

       k1hpqc.qcempr = peBase.peEmpr;
       k1hpqc.qcsucu = peBase.peSucu;
       k1hpqc.qcnivt = peBase.peNivt;
       k1hpqc.qcnivc = peBase.peNivc;
       k1hpqc.qcnrpl = peNrpl;
       chain %kds(k1hpqc:5) pahpqc;
       if %found;
          qcmenv = '1';
          update p1hpqc;
       endif;

       return;

      /end-free

     P PLQWEB_marcarEnviadaPorMail...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_cotiza(): Cotizar cuota                               *
      *                                                              *
      *     peMone   (input)   Moneda                                *
      *     peImcu   (input)   Importe                               *
      *     peTipo   (input)   Tipo de Cotizacion                    *
      *     peFech   (input)   Fecha de cotizacion (aaaammdd)        *
      *                                                              *
      * Retorna: Cuota cotizada                                      *
      * ------------------------------------------------------------ *
     P PLQWEB_cotiza   b
     D PLQWEB_cotiza   pi            15  2
     D  peMone                        2a   const
     D  peImcu                       15  2 const
     D  peTipo                        1a   const
     D  peFech                        8  0 const options(*omit:*nopass)

     D @@fech          s              8  0
     D @@coti          s             15  6

      /free

       chain peMone gntmon;
       if not %found;
          return peImcu * 1;
       endif;

       if momoeq = 'AU';
          return peImcu * 1;
       endif;

       if %parms >= 4 and %addr(peFech) <> *null;
          @@fech = gira_fecha(peFech : 'DMA' );
        else;
          @@fech = (*day * 1000000)
                 + (*month * 10000)
                 +  *year;
       endif;

       SP0052( peMone
             : @@fech
             : @@coti
             : peTipo );

       if @@coti <= 0;
          @@coti = 1;
       endif;

       return peImcu * @@coti;

      /end-free

     P PLQWEB_cotiza   e

      * ------------------------------------------------------------ *
      * PLQWEB_codigoDeColumna(): Retorna codigo de columna          *
      *                                                              *
      *     peFeda   (input)   Fecha Deuda Anterior                  *
      *     peFeqa   (input)   Fecha Quincena Anterior               *
      *     peFeqt   (input)   Fecha Quincena Actual                 *
      *     peFeqs   (input)   Fecha Quincena Siguiente              *
      *     peFeqp   (input)   Fecha Quincena Posterior              *
      *     peFvto   (input)   Fecha Vencimiento                     *
      *     peFepp   (input)   Pronto Pago                           *
      *                                                              *
      * Retorna: Codigo de columna                                   *
      *          DA = Deuda Anterior                                 *
      *          QA = Quincena Anterior                              *
      *          QT = Quincena Actual                                *
      *          QS = Quincena Siguiente                             *
      *          QP = Quincena Posterior                             *
      *          PP = Pronto Pago                                    *
      * ------------------------------------------------------------ *
     P PLQWEB_codigoDeColumna...
     P                 b
     D PLQWEB_codigoDeColumna...
     D                 pi             2a
     D  peFeda                        8  0 const
     D  peFeqa                        8  0 const
     D  peFeqt                        8  0 const
     D  peFeqs                        8  0 const
     D  peFeqp                        8  0 const
     D  peFvto                        8  0 const

      /free

       select;
        when peFvto <= peFeda;
             return 'DA';
        when peFvto <= peFeqa;
             return 'QA';
        when peFvto <= peFeqt;
             return 'QT';
        when peFvto <= peFeqs;
             return 'QS';
        when peFvto <= peFeqp;
             return 'QP';
        other;
             return 'SA';
       endsl;

      /end-free

     P PLQWEB_codigoDeColumna...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_totalSuperpoliza(): Totaliza superpoliza              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peNrpl   (input)   Numero de Preliquidacion              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peCodi   (input)   Columna                               *
      *     peImcu   (input)   Importe                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PLQWEB_totalSuperpoliza...
     P                 b
     D PLQWEB_totalSuperpoliza...
     D                 pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNrpl                        7  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peCodi                        2a   const
     D  peImcu                       15  2 const

     D k1hpqs          ds                  likerec(p1hpqs:*key)

      /free

       k1hpqs.qsempr = peEmpr;
       k1hpqs.qssucu = peSucu;
       k1hpqs.qsnivt = peNivt;
       k1hpqs.qsnivc = peNivc;
       k1hpqs.qsnrpl = peNrpl;
       k1hpqs.qsarcd = peArcd;
       k1hpqs.qsspol = peSpol;
       k1hpqs.qssspo = peSspo;
       chain %kds(k1hpqs) pahpqs;
       if %found;
          select;
           when peCodi = 'DA';
                qsdant += peImcu;
           when peCodi = 'QA';
                qsqant += peImcu;
           when peCodi = 'QT';
                qsqact += peImcu;
           when peCodi = 'QS';
                qsqsig += peImcu;
           when peCodi = 'QP';
                qsqpos += peImcu;
           when peCodi = 'SA';
                qssald += peImcu;
          endsl;
          qsfera = *year;
          qsferm = *month;
          qsferd = *day;
          qstime = %dec(%time():*iso);
          update p1hpqs;
        else;
          qsempr = peEmpr;
          qssucu = peSucu;
          qsnivt = peNivt;
          qsnivc = peNivc;
          qsnrpl = peNrpl;
          qsarcd = peArcd;
          qsspol = peSpol;
          qssspo = peSspo;
          qsdant = 0;
          qsqant = 0;
          qsqact = 0;
          qsqsig = 0;
          qsqpos = 0;
          qssald = 0;
          select;
           when peCodi = 'DA';
                qsdant = peImcu;
           when peCodi = 'QA';
                qsqant = peImcu;
           when peCodi = 'QT';
                qsqact = peImcu;
           when peCodi = 'QS';
                qsqsig = peImcu;
           when peCodi = 'QP';
                qsqpos = peImcu;
           when peCodi = 'SA';
                qssald = peImcu;
          endsl;
          qsfera = *year;
          qsferm = *month;
          qsferd = *day;
          qstime = %dec(%time():*iso);
          write p1hpqs;
       endif;

       return;

      /end-free

     P PLQWEB_totalSuperpoliza...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_totalPoliza(): Totaliza poliza                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peNrpl   (input)   Numero de Preliquidacion              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Secuencia de Articulo/Rama            *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento                            *
      *     pePoli   (input)   Poliza                                *
      *     peCodi   (input)   Columna                               *
      *     peImcu   (input)   Importe                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PLQWEB_totalPoliza...
     P                 b
     D PLQWEB_totalPoliza...
     D                 pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNrpl                        7  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peSuop                        3  0 const
     D  pePoli                        7  0 const
     D  peCodi                        2a   const
     D  peImcu                       15  2 const

     D k1hpqp          ds                  likerec(p1hpqp:*key)
     D @@asen          s              7  0
     D @@nomb          s             40
     D @@sspo          s              3  0

      /free

        @@sspo = peSspo;

        @@asen = SPVSPO_getAsen ( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol
                                : @@Sspo);

        @@nomb = SVPDAF_getNombre( @@asen );

       k1hpqp.qpempr = peEmpr;
       k1hpqp.qpsucu = peSucu;
       k1hpqp.qpnivt = peNivt;
       k1hpqp.qpnivc = peNivc;
       k1hpqp.qpnrpl = peNrpl;
       k1hpqp.qparcd = peArcd;
       k1hpqp.qpspol = peSpol;
       k1hpqp.qpsspo = peSspo;
       k1hpqp.qprama = peRama;
       k1hpqp.qparse = peArse;
       k1hpqp.qpoper = peOper;
       k1hpqp.qpsuop = peSuop;
       k1hpqp.qppoli = pePoli;
       chain %kds(k1hpqp) pahpqp;
       if %found;
          select;
           when peCodi = 'DA';
                qpdant += peImcu;
           when peCodi = 'QA';
                qpqant += peImcu;
           when peCodi = 'QT';
                qpqact += peImcu;
           when peCodi = 'QS';
                qpqsig += peImcu;
           when peCodi = 'QP';
                qpqpos += peImcu;
           when peCodi = 'SA';
                qpsald += peImcu;
          endsl;
          qpfera = *year;
          qpferm = *month;
          qpferd = *day;
          qptime = %dec(%time():*iso);
          update p1hpqp;
        else;
          qpempr = peEmpr;
          qpsucu = peSucu;
          qpnivt = peNivt;
          qpnivc = peNivc;
          qpnrpl = peNrpl;
          qparcd = peArcd;
          qpspol = peSpol;
          qpsspo = peSspo;
          qprama = peRama;
          qparse = peArse;
          qpoper = peOper;
          qpsuop = peSuop;
          qppoli = pePoli;
          qpnomb = @@nomb;
          qpdant = 0;
          qpqant = 0;
          qpqact = 0;
          qpqsig = 0;
          qpqpos = 0;
          qpsald = 0;
          select;
           when peCodi = 'DA';
                qpdant = peImcu;
           when peCodi = 'QA';
                qpqant = peImcu;
           when peCodi = 'QT';
                qpqact = peImcu;
           when peCodi = 'QS';
                qpqsig = peImcu;
           when peCodi = 'QP';
                qpqpos = peImcu;
           when peCodi = 'SA';
                qpsald = peImcu;
          endsl;
          qpfera = *year;
          qpferm = *month;
          qpferd = *day;
          qptime = %dec(%time():*iso);
          write p1hpqp;
       endif;

       return;

      /end-free

     P PLQWEB_totalPoliza...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_comisionSuperpoliza(): Obtiene comisiones de Spol     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Importe de comision de produccion                   *
      * ------------------------------------------------------------ *
     P PLQWEB_comisionSuperpoliza...
     P                 b
     D PLQWEB_comisionSuperpoliza...
     D                 pi            15  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peMone                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

     D k1hed3          ds                  likerec(p1hed3:*key)
     D @@copr          s             15  2

      /free

       @@copr = 0;

       k1hed3.d3empr = peempr;
       k1hed3.d3sucu = pesucu;
       k1hed3.d3arcd = pearcd;
       k1hed3.d3spol = pespol;
       k1hed3.d3sspo = pesspo;

       setll %kds(k1hed3:5) pahed3;
       reade %kds(k1hed3:5) pahed3;
       dow not %eof;
           if d3nivt = peNivt and d3nivc = peNivc;
              @@copr += PLQWEB_cotiza( pemone
                                     : d3copr
                                     : 'V'
                                     : *omit  );
           endif;
        reade %kds(k1hed3:5) pahed3;
       enddo;

       return @@copr;

      /end-free

     P PLQWEB_comisionSuperpoliza...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_comisionPoliza(): Obtiene comisiones de rama/sec      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peSuop   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Importe de comision de produccion                   *
      * ------------------------------------------------------------ *
     P PLQWEB_comisionPoliza...
     P                 b
     D PLQWEB_comisionPoliza...
     D                 pi            15  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peMone                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peSuop                        3  0 const

     D k1hed3          ds                  likerec(p1hed3:*key)
     D @@copr          s             15  2

      /free

       @@copr = 0;

       k1hed3.d3empr = peempr;
       k1hed3.d3sucu = pesucu;
       k1hed3.d3arcd = pearcd;
       k1hed3.d3spol = pespol;
       k1hed3.d3sspo = pesspo;
       k1hed3.d3rama = perama;

       setll %kds(k1hed3:6) pahed3;
       reade %kds(k1hed3:6) pahed3;
       dow not %eof;
           if d3nivt = peNivt and d3nivc = peNivc;
              @@copr += PLQWEB_cotiza( pemone
                                     : d3copr
                                     : 'V'
                                     : *omit  );
           endif;
        reade %kds(k1hed3:6) pahed3;
       enddo;

       return @@copr;

      /end-free

     P PLQWEB_comisionPoliza...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_generaCabecera(): Generar PAHPQC                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediario                *
      *     peNivc   (input)   Codigo de Intermediario               *
      *     peNrpl   (input)   Nro de Preliquidacion                 *
      *     peFdes   (input)   Fecha Desde                           *
      *     peFhas   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PLQWEB_generaCabecera...
     P                 b
     D PLQWEB_generaCabecera...
     D                 pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNrpl                        7  0 const
     D  peFdes                        8  0 const
     D  peFhas                        8  0 const

     D k1hpqc          ds                  likerec(p1hpqc:*key)

      /free

       k1hpqc.qcempr = peEmpr;
       k1hpqc.qcsucu = peSucu;
       k1hpqc.qcnivt = peNivt;
       k1hpqc.qcnivc = peNivc;
       k1hpqc.qcnrpl = peNrpl;
       setll %kds(k1hpqc:5) pahpqc;
       if not %equal;
          qcempr = peEmpr;
          qcsucu = peSucu;
          qcnivt = peNivt;
          qcnivc = peNivc;
          qcnrpl = peNrpl;
          qcfech = %dec(%date():*iso);
          qcfdes = peFdes;
          qcfhas = peFhas;
          qcimpb = 0;
          qcimpn = 0;
          qcmarp = '0';
          qctipo = *blanks;
          qcfera = *year;
          qcferm = *month;
          qcferd = *day;
          qctime = %dec(%time():*iso);
          qcmenv = ' ';
          write p1hpqc;
       endif;

       return;

      /end-free

     P PLQWEB_generaCabecera...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarComoProcesada(): Marcar preli como procesada    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarComoProcesada...
     P                 b                   export
     D PLQWEB_marcarComoProcesada...
     D                 pi
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D k1hpqc          ds                  likerec(p1hpqc:*key)

      /free

       PLQWEB_inz();

       k1hpqc.qcempr = peEmpr;
       k1hpqc.qcsucu = peSucu;
       k1hpqc.qcnivt = peNivt;
       k1hpqc.qcnivc = peNivc;
       k1hpqc.qcnrpl = peNrpl;
       chain %kds(k1hpqc:5) pahpqc;
       if %found;
          qcmarp = '8';
          update p1hpqc;
       endif;

       return;

      /end-free

     P PLQWEB_marcarComoProcesada...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_tieneCheques(): Retorna si tiene cheques cargados.    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene cheques / *OFF no tiene cheques        *
      * ------------------------------------------------------------ *
     P PLQWEB_tieneCheques...
     P                 b                   export
     D PLQWEB_tieneCheques...
     D                 pi             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D k1hpqv          ds                  likerec(p1hpqv:*key)

      /free

       PLQWEB_inz();

       k1hpqv.qvempr = peEmpr;
       k1hpqv.qvsucu = peSucu;
       k1hpqv.qvnivt = peNivt;
       k1hpqv.qvnivc = peNivc;
       k1hpqv.qvnrpl = peNrpl;
       setll %kds(k1hpqv:5) pahpqv;
       reade(n) %kds(k1hpqv:5) pahpqv;
       dow not %eof;
           chain qvivcv cntfpp;
           if %found;
              if pfivce = 'CH';
                 return *on;
              endif;
           endif;
        reade(n) %kds(k1hpqv:5) pahpqv;
       enddo;

       return *off;

      /end-free

     P PLQWEB_tieneCheques...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_tieneEfectivo(): Retorna si tiene cheques cargados.   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene efectivo / *OFF no tiene efectivo      *
      * ------------------------------------------------------------ *
     P PLQWEB_tieneEfectivo...
     P                 b                   export
     D PLQWEB_tieneEfectivo...
     D                 pi             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D k1hpqv          ds                  likerec(p1hpqv:*key)

      /free

       PLQWEB_inz();

       k1hpqv.qvempr = peEmpr;
       k1hpqv.qvsucu = peSucu;
       k1hpqv.qvnivt = peNivt;
       k1hpqv.qvnivc = peNivc;
       k1hpqv.qvnrpl = peNrpl;
       setll %kds(k1hpqv:5) pahpqv;
       reade(n) %kds(k1hpqv:5) pahpqv;
       dow not %eof;
           chain qvivcv cntfpp;
           if %found;
              if pfivce = 'EF';
                 return *on;
              endif;
           endif;
        reade(n) %kds(k1hpqv:5) pahpqv;
       enddo;

       return *off;

      /end-free

     P PLQWEB_tieneEfectivo...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_tieneCobranzaIntegradaGalicia(): Retorna si tiene     *
      *                             Valores de Cobranza Integrada de *
      *                             Banco Galicia.                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene / *OFF no tiene                        *
      * ------------------------------------------------------------ *
     P PLQWEB_tieneCobranzaIntegradaGalicia...
     P                 b                   export
     D PLQWEB_tieneCobranzaIntegradaGalicia...
     D                 pi             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D k1hpqv          ds                  likerec(p1hpqv:*key)

      /free

       PLQWEB_inz();

       k1hpqv.qvempr = peEmpr;
       k1hpqv.qvsucu = peSucu;
       k1hpqv.qvnivt = peNivt;
       k1hpqv.qvnivc = peNivc;
       k1hpqv.qvnrpl = peNrpl;
       setll %kds(k1hpqv:5) pahpqv;
       reade(n) %kds(k1hpqv:5) pahpqv;
       dow not %eof;
           chain qvivcv cntfpp;
           if %found;
              if pfivce = 'CI';
                 return *on;
              endif;
           endif;
        reade(n) %kds(k1hpqv:5) pahpqv;
       enddo;

       return *off;

      /end-free

     P PLQWEB_tieneCobranzaIntegradaGalicia...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_tieneBancoGalicia(): Retorna si tiene depositos del   *
      *                             Banco Galicia.                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene / *OFF no tiene                        *
      * ------------------------------------------------------------ *
     P PLQWEB_tieneBancoGalicia...
     P                 b                   export
     D PLQWEB_tieneBancoGalicia...
     D                 pi             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D k1hpqv          ds                  likerec(p1hpqv:*key)

      /free

       PLQWEB_inz();

       k1hpqv.qvempr = peEmpr;
       k1hpqv.qvsucu = peSucu;
       k1hpqv.qvnivt = peNivt;
       k1hpqv.qvnivc = peNivc;
       k1hpqv.qvnrpl = peNrpl;
       setll %kds(k1hpqv:5) pahpqv;
       reade(n) %kds(k1hpqv:5) pahpqv;
       dow not %eof;
           chain qvivcv cntfpp;
           if %found;
              if pfivce = 'DB';
                 if qvivbc = 7;
                    return *on;
                 endif;
              endif;
           endif;
        reade(n) %kds(k1hpqv:5) pahpqv;
       enddo;

       return *off;

      /end-free

     P PLQWEB_tieneBancoGalicia...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarComoEliminada(): Marcar preli como eliminada    *
      *                                                              *
      *     peBase   (input)   Parametro Base                        *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarComoEliminada...
     P                 b                   export
     D PLQWEB_marcarComoEliminada...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hpqc          ds                  likerec(p1hpqc:*key)

      /free

       PLQWEB_inz();

       PLQWEB_validaPreliquidacion( peBase
                                  : peNrpl
                                  : peErro
                                  : peMsgs );

       if (peErro = -1);
          return;
       endif;

       k1hpqc.qcempr = peBase.peEmpr;
       k1hpqc.qcsucu = peBase.peSucu;
       k1hpqc.qcnivt = peBase.peNivt;
       k1hpqc.qcnivc = peBase.peNivc;
       k1hpqc.qcnrpl = peNrpl;
       chain %kds(k1hpqc:5) pahpqc;
       if %found;
          if qcmarp = 'G';
             qcmarp = '4';
             update p1hpqc;
           else;
             @@Repl =   %editw ( peNrpl  : '0      ' );
             @@Leng = %len ( %trimr ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0015' :
                            peMsgs : @@Repl  : @@Leng );
             update p1hpqc;
             peErro = -1;
          endif;
       endif;

       return;

      /end-free

     P PLQWEB_marcarComoEliminada...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_sndEmail(): Enviar email de recepcion.                *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_sndEmail...
     P                 b
     D PLQWEB_sndEmail...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const

     D Body            s           5000a
     D Asunto          s             70a   varying
     D tmpBody         s            512a   varying
     D Destinat_Nomb   s             50a   dim(100)
     D Destinat_mail   s            256a   dim(100)
     D Destinat_tipo   s             10i 0 dim(100)
     D Num             s              2  0
     D rc              s             10i 0
     D peCprc          s             20a   inz('PRELIQUIDACION')
     D peCspr          s             20a   inz('ENVIAR')
     D peRprp          ds                  likeds(recprp_t) dim(100)
     D peRemi          ds                  likeds(Remitente_t)

      /free

       PLQWEB_inz();

       rc = MAIL_getFrom( peCprc
                        : peCspr
                        : peRemi );

       rc = MAIL_getReceipt( peCprc
                           : peCspr
                           : peRprp
                           : *ON    );
       if rc <= 0;
          return;
       endif;

       for num = 1 to rc;
           Destinat_nomb(num) = peRprp(num).rpnomb;
           Destinat_mail(num) = peRprp(num).rpmail;
           select;
           when peRprp(num).rpma01 = '1';
              Destinat_tipo(num) = MAIL_NORMAL;
           when peRprp(num).rpma01 = '2';
              Destinat_tipo(num) = MAIL_CC;
           when peRprp(num).rpma01 = '3';
             Destinat_tipo(num) = MAIL_CCO;
           other;
              Destinat_tipo(num) = MAIL_NORMAL;
           endsl;
       endfor;

       Asunto = 'Aviso de Preliquidación';
       rc = MAIL_getbody( peCprc
                        : peCspr
                        : tmpBody );

       khni201.n2empr = peBase.peEmpr;
       khni201.n2sucu = peBase.peSucu;
       khni201.n2nivt = peBase.peNivt;
       khni201.n2nivc = peBase.peNivc;

       chain %kds(khni201:4) sehni201;
       if not %found(sehni201);
          clear dfnomb;
       endif;

       body = %trim(tmpBody);

       body = %scanrpl( '%NIVT%' : %char(peBase.peNivt)       : body );
       body = %scanrpl( '%NIVC%' : %char(peBase.peNivc)       : body );
       body = %scanrpl( '%NOMB%' : %trim(dfnomb)              : body );
       body = %scanrpl( '%NRPL%' : %char(peNrpl)              : body );

       if MAIL_SndLmail( peRemi.From
                       : peRemi.Fadr
                       : Asunto
                       : Body
                       : 'H'
                       : Destinat_Nomb
                       : Destinat_mail
                       : Destinat_tipo ) = 0;
       endif;

       return;

      /end-free

     P PLQWEB_sndEmail...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_sndDataQueue(): Enviar preli a cola de datos para que *
      *                        se aplique automaticamente.           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PLQWEB_sndDataQueue...
     P                 b                   export
     D PLQWEB_sndDataQueue...
     D                 pi
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D Data            ds                  qualified
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1a
     D  nivc                          5a
     D  nrpl                          7a
     D  keyw                         10a

      /free

       PLQWEB_inz();

       Data.empr = peEmpr;
       Data.sucu = peSucu;
       Data.nivt = %editc( peNivt : 'X' );
       Data.nivc = %editc( peNivc : 'X' );
       Data.nrpl = %editc( peNrpl : 'X' );
       Data.keyw = 'IMPUTAR   ';

       QSNDDTAQ( 'QUOMCUO03'
               : '*LIBL'
               : %len(%trim(data))
               : Data                    );

       return;

      /end-free

     P PLQWEB_sndDataQueue...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_cleanUp(): Clean Up final luego de enviar.            *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_cleanUp...
     P                 b
     D PLQWEB_cleanUp...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const

     D khpqd           ds                  likerec(p1hpqd:*key)
     D khpq1           ds                  likerec(p1hpq1:*key)
     D khpqp           ds                  likerec(p1hpqp:*key)
     D khpqs           ds                  likerec(p1hpqs:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

      /free

       PLQWEB_inz();

       khpqd.qdempr = peBase.peEmpr;
       khpqd.qdsucu = peBase.peSucu;
       khpqd.qdnivt = peBase.peNivt;
       khpqd.qdnivc = peBase.peNivc;
       khpqd.qdnrpl = peNrpl;
       setll %kds ( khpqd : 5 ) pahpqd;
       reade %kds ( khpqd : 5 ) pahpqd;
       dow not %eof(pahpqd);
          if qdmarp = '0';
             delete pahpqd;
          endif;
        reade %kds ( khpqd : 5 ) pahpqd;
       enddo;

       khpq1.q1empr = peBase.peEmpr;
       khpq1.q1sucu = peBase.peSucu;
       khpq1.q1nivt = peBase.peNivt;
       khpq1.q1nivc = peBase.peNivc;
       khpq1.q1nrpl = peNrpl;
       setll %kds ( khpq1 : 5 ) pahpq1;
       reade %kds ( khpq1 : 5 ) pahpq1;
       dow not %eof(pahpq1);
          if q1marp = '0';
             delete pahpq1;
          endif;
        reade %kds ( khpq1 : 5 ) pahpq1;
       enddo;

       khpqp.qpempr = peBase.peEmpr;
       khpqp.qpsucu = peBase.peSucu;
       khpqp.qpnivt = peBase.peNivt;
       khpqp.qpnivc = peBase.peNivc;
       khpqp.qpnrpl = peNrpl;
       setll %kds ( khpqp : 5 ) pahpqp;
       reade %kds ( khpqp : 5 ) pahpqp;
       dow not %eof(pahpqp);
          delete pahpqp;
        reade %kds ( khpqp : 5 ) pahpqp;
       enddo;

       khpqs.qsempr = peBase.peEmpr;
       khpqs.qssucu = peBase.peSucu;
       khpqs.qsnivt = peBase.peNivt;
       khpqs.qsnivc = peBase.peNivc;
       khpqs.qsnrpl = peNrpl;
       setll %kds ( khpqs : 5 ) pahpqs;
       reade %kds ( khpqs : 5 ) pahpqs;
       dow not %eof(pahpqs);
          delete pahpqs;
        reade %kds ( khpqs : 5 ) pahpqs;
       enddo;

       return;

      /end-free

     P PLQWEB_cleanUp...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_insertarCobranzaIntegrada(): Inserta Cobranza Integra *
      *                                     da Banco Galicia.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNros   (input)   Número Secuencial                     *
      *     peImpo   (input)   Importe                               *
      *     peFdep   (input)   Fecha de Deposito                     *
      *     peArch   (input)   Archivo                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_insertarCobranzaIntegrada...
     P                 b                   export
     D PLQWEB_insertarCobranzaIntegrada...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNros                      30a   const
     D   peImpo                      15  2 const
     D   peFdep                       8  0 const
     D   peArch                     512a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

     D wdepval         s               n   inz(*Off)
     D i               s             10i 0

     D @@timpo         s             15  2 inz(*Zeros)
     D @@simpo         s             15  2 inz(*Zeros)

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;

       if %found(pahpqc)
          and qctipo <> 'PN'
          and qctipo <> 'PB';

          @@Repl =   %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0008' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Monto Insertado
       if peImpo < *Zeros;

          @@Repl =   %editw ( peImpo : '           0 ,  -' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1000' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Código de Banco
       setll (peIvbc) cntbco;
       if not %equal(cntbco);

          @@Repl =   %editw ( peIvbc : '0  ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1010' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Número de Depósito
       for i = 1 to 30;
          if %subst(peNros:i:1) <> *Blanks
             and %subst(peNros:i:1) <> '0';
             wdepval = *On;
             leave;
          endif;
       endfor;

       if not wdepval;

          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1020' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

      *- Valido Monto Total
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          select;
          when qctipo = 'PN';
             @@timpo = qcimpn;
          when qctipo = 'PB';
             @@timpo = qcimpb;
          endsl;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;

       setll    %kds ( khpqv : 5 ) pahpqv;
       reade(n) %kds ( khpqv : 5 ) pahpqv;
       dow not %eof(pahpqv);

          if qvivcv = 8
             and qvivbc = peIvbc
             and qvivch = peNros;
          else;
             @@simpo = @@simpo + qvimcu;
          endif;

          reade(n) %kds ( khpqv : 5 ) pahpqv;
       enddo;

       @@simpo = @@simpo + peImpo;

       if @@simpo > @@timpo;

          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1022' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 8;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNros;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          qvfech = peFdep;
          qvimcu = peImpo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          qvarch = peArch;
          update p1hpqv;
       else;
          qvempr = peBase.peEmpr;
          qvsucu = peBase.peSucu;
          qvnivt = peBase.peNivt;
          qvnivc = peBase.peNivc;
          qvnrpl = peNrpl;
          qvivcv = 8;
          qvivbc = peIvbc;
          qvivch = peNros;
          qvfech = peFdep;
          qvimcu = peImpo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          qvarch = peArch;
          write p1hpqv;
       endif;

       return;

     P PLQWEB_insertarCobranzaIntegrada...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_eliminarCobranzaIntegrada(): Elimina Cobranza Integra *
      *                                     da Banco Galicia.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNdep   (input)   Número de Depósito                    *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_eliminarCobranzaIntegrada...
     P                 b                   export
     D PLQWEB_eliminarCobranzaIntegrada...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNdep                      30a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Depósito

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 8;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNdep;

       setll %kds ( khpqv : 8 ) pahpqv;
       if not %equal(pahpqv);

          @@Repl = peNdep + %editw(peNrpl:'0      ');
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1021' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;

       endif;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          delete pahpqv;
       endif;

       return;

     P PLQWEB_eliminarCobranzaIntegrada...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_insertarRedondeo(): Insertar redondeo.                *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peEfvo   (input)   Importe de redondeo                   *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_insertarRedondeo...
     P                 b                   export
     D PLQWEB_insertarRedondeo...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peEfvo                      15  2 const
     D   peArch                     512a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

     D @@timpo         s             15  2 inz(*Zeros)
     D @@simpo         s             15  2 inz(*Zeros)
     D hay_redondeo    s              1N

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
         if PLQWEB_getTipoDePago( @@Base.peEmpr
                                : @@Base.peSucu
                                : @@Base.peNivt
                                : @@Base.peNivc
                                : @@Nrpl        ) <> 'PN'
                    and
         PLQWEB_getTipoDePago( @@Base.peEmpr
                             : @@Base.peSucu
                             : @@Base.peNivt
                             : @@Base.peNivc
                             : @@Nrpl        ) <> 'PB';
          @@Repl =   %editw ( peNrpl  : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW0008' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;
       endif;

       // Borro anterior
       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 3;
       setll %kds(khpqv:6) pahpqv;
       reade %kds(khpqv:6) pahpqv;
       dow not %eof;
           delete p1hpqv;
        reade %kds(khpqv:6) pahpqv;
       enddo;

       if peEfvo = 0;
          return;
       endif;

      *- Valido Monto Total
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;
       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          select;
          when qctipo = 'PN';
             @@timpo = qcimpn;
          when qctipo = 'PB';
             @@timpo = qcimpb;
          endsl;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       setll    %kds ( khpqv : 5 ) pahpqv;
       reade(n) %kds ( khpqv : 5 ) pahpqv;
       dow not %eof(pahpqv);
          if qvivcv <> 3;
             @@simpo = @@simpo + qvimcu;
          endif;
          reade(n) %kds ( khpqv : 5 ) pahpqv;
       enddo;

       @@simpo = @@simpo + peEfvo;

       if @@simpo > @@timpo;
          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PQW1022' :
                         peMsgs : @@Repl  : @@Leng );
          peErro = -1;
          return;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 3;
       khpqv.qvivbc = -1;
       khpqv.qvivch = *Blanks;
       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          qvfech = %dec(%date():*iso);
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          qvarch = peArch;
          update p1hpqv;
       else;
          qvempr = peBase.peEmpr;
          qvsucu = peBase.peSucu;
          qvnivt = peBase.peNivt;
          qvnivc = peBase.peNivc;
          qvnrpl = peNrpl;
          qvivcv = 3;
          qvivbc = -1;
          qvivch = *Blanks;
          qvfech = %dec(%date():*iso);
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          qvarch = peArch;
          write p1hpqv;
       endif;

       return;

     P PLQWEB_insertarRedondeo...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_getTipoDeValor(): Obtiene tipo de valor.              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: tipo de valor.                                      *
      * ------------------------------------------------------------ *
     P PLQWEB_getTipoDeValor...
     P                 b                   export
     D PLQWEB_getTipoDeValor...
     D                 pi             2a
     D   peIvcv                       2  0 const

      /free

       PLQWEB_inz();

       chain peIvcv cntfpp;
       if not %found;
          return *blanks;
       endif;

       return pfivce;

      /end-free

     P PLQWEB_getTipoDeValor...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_getTipoDePago():  Obtiene tipo de pago.               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: tipo de pago.                                       *
      * ------------------------------------------------------------ *
     P PLQWEB_getTipoDePago...
     P                 b                   export
     D PLQWEB_getTipoDePago...
     D                 pi             2a
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D k1hpqc          ds                  likerec(p1hpqc:*key)

      /free

       PLQWEB_inz();

       k1hpqc.qcempr = peEmpr;
       k1hpqc.qcsucu = peSucu;
       k1hpqc.qcnivt = peNivt;
       k1hpqc.qcnivc = peNivc;
       k1hpqc.qcnrpl = peNrpl;
       chain(n) %kds(k1hpqc:5) pahpqc;
       if not %found;
          return *blanks;
       endif;

       return qctipo;

      /end-free

     P PLQWEB_getTipoDePago...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_tieneRedondeo(): Retorna si tiene Redondeo como       *
      *                         forma de Pago.                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel                                 *
      *     peNivc   (input)   Codigo                                *
      *     peNrpl   (input)   Número de Preliquidación              *
      *                                                              *
      * Retorna: *ON Si tiene / *OFF no tiene                        *
      * ------------------------------------------------------------ *
     P PLQWEB_tieneRedondeo...
     P                 b                   export
     D PLQWEB_tieneRedondeo...
     D                 pi             1n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNrpl                       7  0 const

     D k1hpqv          ds                  likerec(p1hpqv:*key)

      /free

       PLQWEB_inz();

       k1hpqv.qvempr = peEmpr;
       k1hpqv.qvsucu = peSucu;
       k1hpqv.qvnivt = peNivt;
       k1hpqv.qvnivc = peNivc;
       k1hpqv.qvnrpl = peNrpl;
       setll %kds(k1hpqv:5) pahpqv;
       reade(n) %kds(k1hpqv:5) pahpqv;
       dow not %eof;
           if (PLQWEB_getTipoDeValor(qvivcv) = 'RE');
             return *on;
           endif;
        reade(n) %kds(k1hpqv:5) pahpqv;
       enddo;

       return *off;

      /end-free

     P PLQWEB_tieneRedondeo...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaPosterior() : Marcar para pagar toda la *
      *                                    deuda de la quincena pos_ *
      *                                    terior.                   *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaPosterior...
     P                 b                   export

     D PLQWEB_marcarQuincenaPosterior...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)


     D khpqd06         ds                  likerec(pqd06:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QP')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd06.qdempr = peBase.peEmpr;
       khpqd06.qdsucu = peBase.peSucu;
       khpqd06.qdnivt = peBase.peNivt;
       khpqd06.qdnivc = peBase.peNivc;
       khpqd06.qdnrpl = peNrpl;

       setll %kds(khpqd06:5) pahpqd06;
       reade %kds(khpqd06:5) pahpqd06;

       dow not %eof(pahpqd06);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd06:5) pahpqd06;
       enddo;

       PLQWEB_marcarQuincenaSiguiente(@@base:
                                      @@nrpl:
                                      peImpn:
                                      peImpb:
                                      peErro:
                                      peMsgs);

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_marcarQuincenaPosterior...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaPosterior():Desmarca para pagar toda *
      *                                     la Quincena Posterior de *
      *                                     la prequidación.         *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaPosterior...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaPosterior...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd06         ds                  likerec(pqd06:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QP')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd06.qdempr = peBase.peEmpr;
       khpqd06.qdsucu = peBase.peSucu;
       khpqd06.qdnivt = peBase.peNivt;
       khpqd06.qdnivc = peBase.peNivc;
       khpqd06.qdnrpl = peNrpl;

       setll %kds(khpqd06:5) pahpqd06;
       reade %kds(khpqd06:5) pahpqd06;

       dow not %eof(pahpqd06);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd06:5) pahpqd06;
       enddo;

       PLQWEB_desmarcarQuincenaSiguiente(@@base:
                                         @@nrpl:
                                         peImpn:
                                         peImpb:
                                         peErro:
                                         peMsgs);

       PLQWEB_updateImportes(@@Base:
                             @@nrpl:
                             @@marc:
                             @@codi:
                             peImpn:
                             peImpb);

       return;

     P PLQWEB_desmarcarQuincenaPosterior...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_marcarQuincenaPosteriorSuperPolizaEndoso() marca para *
      *                                                   pagar la   *
      *                                                   Quincena   *
      *                                                   Posterior  *
      *                                                   de una Pó- *
      *                                                   liza/Endo- *
      *                                                   so.        *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_marcarQuincenaPosteriorSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_marcarQuincenaPosteriorSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd06         ds                  likerec(pqd06:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('1')
     D @@codi          s              2    inz('QP')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd06.qdempr = peBase.peEmpr;
       khpqd06.qdsucu = peBase.peSucu;
       khpqd06.qdnivt = peBase.peNivt;
       khpqd06.qdnivc = peBase.peNivc;
       khpqd06.qdnrpl = peNrpl;
       khpqd06.qdarcd = peArcd;
       khpqd06.qdspol = peSpol;
       khpqd06.qdsspo = peSspo;

       setll %kds(khpqd06:8) pahpqd06;
       reade %kds(khpqd06:8) pahpqd06;

       dow not %eof(pahpqd06);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd06:8) pahpqd06;
       enddo;

       PLQWEB_marcarQuincenaSiguienteSuperPolizaEndoso(@@base:
                                                       @@nrpl:
                                                       @@arcd:
                                                       @@spol:
                                                       @@sspo:
                                                       peImpn:
                                                       peImpb:
                                                       peErro:
                                                       peMsgs);


       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_marcarQuincenaPosteriorSuperPolizaEndoso...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_desmarcarQuincenaPosteriorSuperPolizaEndoso(): des-   *
      *                                                       marca  *
      *                                                       para   *
      *                                                       pagar  *
      *                                                       la Quin*
      *                                                       cena   *
      *                                                       Posteri*
      *                                                       or de  *
      *                                                       una Pó-*
      *                                                       liza/  *
      *                                                       Endoso.*
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peSspo   (input)   Suplemento SuperPóliza                *
      *     peImpn   (output)  Importe Neto                          *
      *     peImpb   (output)  Importe Bruto                         *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_desmarcarQuincenaPosteriorSuperPolizaEndoso...
     P                 b                   export

     D PLQWEB_desmarcarQuincenaPosteriorSuperPolizaEndoso...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqd06         ds                  likerec(pqd06:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@sspo          s              3  0
     D @@marc          s              1    inz('0')
     D @@codi          s              2    inz('QP')

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       PLQWEB_inz();

       @@base = peBase;
       @@nrpl = peNrpl;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);

       if peErro = -1;
          return;
       endif;

      *- Valido Superpóliza
       PLQWEB_validaSuperpoliza(@@base:
                                @@nrpl:
                                @@arcd:
                                @@spol:
                                @@sspo:
                                peErro:
                                peMsgs);

       if peErro = -1;
          return;
       endif;

       khpqd06.qdempr = peBase.peEmpr;
       khpqd06.qdsucu = peBase.peSucu;
       khpqd06.qdnivt = peBase.peNivt;
       khpqd06.qdnivc = peBase.peNivc;
       khpqd06.qdnrpl = peNrpl;
       khpqd06.qdarcd = peArcd;
       khpqd06.qdspol = peSpol;
       khpqd06.qdsspo = peSspo;

       setll %kds(khpqd06:8) pahpqd06;
       reade %kds(khpqd06:8) pahpqd06;

       dow not %eof(pahpqd06);

          PLQWEB_updateCuota(@@base:
                             @@nrpl:
                             qdarcd:
                             qdspol:
                             qdsspo:
                             qdrama:
                             qdarse:
                             qdoper:
                             qdpoli:
                             qdsuop:
                             qdnrcu:
                             qdnrsc:
                             @@marc);

          reade %kds(khpqd06:8) pahpqd06;
       enddo;

       PLQWEB_desmarcarQuincenaSiguienteSuperPolizaEndoso(@@base:
                                                          @@nrpl:
                                                          @@arcd:
                                                          @@spol:
                                                          @@sspo:
                                                          peImpn:
                                                          peImpb:
                                                          peErro:
                                                          peMsgs);

       PLQWEB_updateImportesSuperPolizaEndoso(@@Base:
                                              @@nrpl:
                                              @@arcd:
                                              @@spol:
                                              @@sspo:
                                              @@marc:
                                              @@codi:
                                              peImpn:
                                              peImpb);

       PLQWEB_updateImportes( peBase
                            : peNrpl
                            : *blanks
                            : *blanks
                            : peImpn
                            : peImpb   );

       return;

     P PLQWEB_desmarcarQuincenaPosteriorSuperPolizaEndoso...
     P                 e

      * ************************************************************ *

     P gira_fecha      B
     D gira_fecha      PI             8  0
     D @@feve                         8  0 CONST
     D @@tipo                         3A   CONST
     * Local fields
     D retField        S              8  0
     * AÑO-MES-DIA...
     D                 ds                  inz
     Dp@famd                  01     08  0
     D@@aÑo                   01     04  0
     D@@mes                   05     06  0
     D@@dia                   07     08  0
     * DIA-MES-AÑO...
     D                 ds                  inz
     Dp@fdma                  01     08  0
     D$$dia                   01     02  0
     D$$mes                   03     04  0
     D$$aÑo                   05     08  0
     *
     * Girar según como se pida...
     C                   select
     * Pasar a AÑO-MES-DIA...
     C                   when      @@tipo = 'AMD'
     C                   eval      p@fdma = @@feve
     C                   eval      @@aÑo = $$aÑo
     C                   eval      @@mes = $$mes
     C                   eval      @@dia = $$dia
     C                   eval      retfield = p@famd
     * Pasar a DIA-MES-AÑO...
     C                   when      @@tipo = 'DMA'
     C                   eval      p@famd = @@feve
     C                   eval      $$aÑo = @@aÑo
     C                   eval      $$mes = @@mes
     C                   eval      $$dia = @@dia
     C                   eval      retfield = p@fdma
     C                   endsl
     C                   RETURN    retField
     P gira_fecha      E

      * ------------------------------------------------------------ *
      * PLQWEB_insertarECheque(): ingresa un cheque electronico      *
      *                           a la Preliquidación.               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNech   (input)   Número de Cheque Electronico          *
      *     peFche   (input)   Fecha del Cheque Electronico(aaaammdd)*
      *     peEfvo   (input)   Importe                               *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_insertarECheque...
     P                 b                   export

     D PLQWEB_insertarECheque...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqc           ds                  likerec(p1hpqc:*key)
     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

     D wchqval         s               n   inz(*Off)
     D i               s             10i 0

     D @@timpo         s             15  2 inz(*Zeros)
     D @@simpo         s             15  2 inz(*Zeros)

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);
       if peErro = -1;
          return;
       endif;

      *- Valido Tipo de Pago
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc)
        and qctipo <> 'PN'
        and qctipo <> 'PB';

          @@Repl =   %editw ( peNrpl
                            : '0      ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL'
                        : 'WSVMSG'
                        : 'PQW0008'
                        : peMsgs
                        : @@Repl
                        : @@Leng );
          peErro = -1;
          return;
       endif;

      *- Valido Monto Insertado
       if peEfvo < *Zeros;
          @@Repl =   %editw ( peEfvo
                            : '           0 ,  -' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL'
                        : 'WSVMSG'
                        : 'PQW1000'
                        : peMsgs
                        : @@Repl
                        : @@Leng );
          peErro = -1;
          return;
       endif;

      *- Valido Código de Banco
       setll (peIvbc) cntbco;
       if not %equal(cntbco);
          @@Repl =   %editw ( peIvbc
                            : '0  ' );
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL'
                        : 'WSVMSG'
                        : 'PQW1010'
                        : peMsgs
                        : @@Repl
                        : @@Leng );
          peErro = -1;
          return;
       endif;

      *- Valido Número de Cheque Electronico no Blanco
       for i = 1 to 30;
          if  %subst(peNech:i:1) <> *Blanks
          and %subst(peNech:i:1) <> '0';
             wchqval = *On;
             leave;
          endif;
       endfor;

       if not wchqval;
          @@Repl = peNech;
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL'
                        : 'WSVMSG'
                        : 'PQW1011'
                        : peMsgs
                        : @@Repl
                        : @@Leng );
          peErro = -1;
          return;
       endif;

      *- Valido Monto Total
       khpqc.qcempr = peBase.peEmpr;
       khpqc.qcsucu = peBase.peSucu;
       khpqc.qcnivt = peBase.peNivt;
       khpqc.qcnivc = peBase.peNivc;
       khpqc.qcnrpl = peNrpl;

       chain(n) %kds ( khpqc : 5 ) pahpqc;
       if %found(pahpqc);
          select;
          when qctipo = 'PN';
             @@timpo = qcimpn;
          when qctipo = 'PB';
             @@timpo = qcimpb;
          endsl;
       endif;

       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;

       setll    %kds ( khpqv : 5 ) pahpqv;
       reade(n) %kds ( khpqv : 5 ) pahpqv;
       dow not %eof(pahpqv);
          if qvivcv <> 1
           or qvivbc <> peIvbc
           or qvivch <> peNech;
             @@simpo = @@simpo + qvimcu;
          endif;
          reade(n) %kds ( khpqv : 5 ) pahpqv;
       enddo;

       @@simpo = @@simpo + peEfvo;
       if @@simpo > @@timpo;
          @@Repl = *Blanks;
          @@Leng = *Zeros;
          SVPWS_getMsgs ( '*LIBL'
                        : 'WSVMSG'
                        : 'PQW1022'
                        : peMsgs
                        : @@Repl
                        : @@Leng );
          peErro = -1;
          return;
       endif;

      *- Graba / Actualiza
       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 5;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNech;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          qvfech = peFche;
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          update p1hpqv;
       else;
          qvempr = peBase.peEmpr;
          qvsucu = peBase.peSucu;
          qvnivt = peBase.peNivt;
          qvnivc = peBase.peNivc;
          qvnrpl = peNrpl;
          qvivcv = 5;
          qvivbc = peIvbc;
          qvivch = peNech;
          qvfech = peFche;
          qvimcu = peEfvo;
          qvfera = *Year;
          qvferm = *Month;
          qvferd = *Day;
          qvtime = %dec(%time():*iso);
          write p1hpqv;
       endif;

       return;

     P PLQWEB_insertarECheque...
     P                 e

      * ------------------------------------------------------------ *
      * PLQWEB_borrarECheque(): elimina un cheque electronico        *
      *                         de una Preliquidación.               *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNrpl   (input)   Número de Preliquidación              *
      *     peIvbc   (input)   Código de Banco                       *
      *     peNech   (input)   Número de Cheque Electronico          *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P PLQWEB_borrarECheque...
     P                 b                   export

     D PLQWEB_borrarECheque...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D khpqv           ds                  likerec(p1hpqv:*key)

     D @@base          ds                  likeds(paramBase)
     D @@nrpl          s              7  0

       PLQWEB_inz();

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       @@base = peBase;
       @@nrpl = peNrpl;

      *- Valido Preliquidación
       PLQWEB_validaPreliquidacion(@@Base:
                                   @@Nrpl:
                                   peErro:
                                   peMsgs);
       if peErro = -1;
          return;
       endif;

      *- Valido Cheque Electronico
       khpqv.qvempr = peBase.peEmpr;
       khpqv.qvsucu = peBase.peSucu;
       khpqv.qvnivt = peBase.peNivt;
       khpqv.qvnivc = peBase.peNivc;
       khpqv.qvnrpl = peNrpl;
       khpqv.qvivcv = 5;
       khpqv.qvivbc = peIvbc;
       khpqv.qvivch = peNech;

       setll %kds ( khpqv : 8 ) pahpqv;
       if not %equal(pahpqv);
          @@Repl = peNech + %editw( peNrpl
                                  :'0      ');
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL'
                        : 'WSVMSG'
                        : 'PQW1012'
                        : peMsgs
                        : @@Repl
                        : @@Leng );
          peErro = -1;
          return;
       endif;

       chain %kds ( khpqv : 8 ) pahpqv;
       if %found(pahpqv);
          delete pahpqv;
       endif;

       return;

     P PLQWEB_borrarECheque...
     P                 e
      * ------------------------------------------------------------ *

