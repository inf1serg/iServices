     H actgrp(*caller) dftactgrp(*no) datedit(*dmy/)
     H option(*nodebugio:*srcstmt:*noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ********************************************************** *
      * COW310: Emision Automatica Desde Web                       *
      * ---------------------------------------------------------- *
      * Alvarez Fernando                     29-Sep-2015           *
      * ---------------------------------------------------------- *
      * Modificaciones:                                            *
      * SFA 13/05/16 - Obtengo limites de RC desde tablas de CTW   *
      * SGF 30/07/16 - Obtengo XREA y READ desde CTW001C y lo gra- *
      *                bo en PAHED0.                               *
      * SFA 01/08/16 - Obtengo tipo de calculo importe GNC         *
      * SGF 02/08/16 - Cambio el %eof() del dow para grabar el     *
      *                CTWER1B.                                    *
      * SFA 04/08/16 - Grabo Rastreador si corresponde             *
      * SFA 04/08/16 - Grabo comisiones nivel 1 desde CTW001C      *
      * SGF 06/08/16 - Recompilo por ASEN en CTW000.               *
      * SGF 08/08/16 - Cuando barre CTWET0 para grabar PAHET0, sal-*
      *                vo el nombre del Mercosur (NMER) y luego lo *
      *                uso al grabar PAHET9.                       *
      * SGF 12/10/16 - Marco como suspendida especial.             *
      * SGF 19/10/16 - Acreedor prendario en et0.                  *
      *                Grabo marca de pasos en pawpc0.             *
      * SGF 20/10/16 - PAWP310 y marcas en PAWPD0.                 *
      * SGF 25/10/16 - Grabo correctamente datos de forma de pago. *
      * SGF 27/10/16 - Actualiza rastreador en CTWINS.             *
      * SGF 01/12/16 - Uso t0poco para getPoco() cuando se graba   *
      *                rastreador en ET4.                          *
      * SGF 13/12/16 - Valor 0KM en cero para cobertura A.         *
      * JSN 06/01/17 - Se recompila por cambio de estructura del   *
      *                archivo ctwins                              *
      * SGF 07/03/17 - Grabo correctamente categoría en Vida.      *
      *                Grabo fecha de ingreso a la nómina en todos *
      *                los archivos (ET9, ER0, ER9 y EV0).         *
      * LRG 07/03/17 - Se agrega marca Z0WP04, Z0WP05 del PAWPD0   *
      *                                z0wp04lk, z0wp05lk PAWP310  *
      *                Se agregan clausulas/Anexos del SET103      *
      *                Se crea busqueda en Nuevo Procedimiento     *
      *                GetClausulas, GetAnexos.-                   *
      * SGF 13/03/17 - Es necesario grabar ED0 *ANTES* de graber el*
      *                EC3 ya que PAR312I usa datos del primero.   *
      *                Al estar al revés, se calculaban mal las    *
      *                fechas de las cuotas.                       *
      * SGF 16/03/17 - Faltaba control de Hasta Facturado y Anuali-*
      *                dad vs Vigencia Hasta.                      *
      *                Si Hasta Facturada > Vigencia Hasta, fuerzo *
      *                Vigencia Hasta.                             *
      *                Si Anualidad > Vigencia Hasta, fuerzo Vigen-*
      *                cia Hasta.                                  *
      * SGF 29/03/17 - R0MAR1 en "S" para que la suma total se     *
      *                obtenga desde la sumatoria de rie/cob.      *
      * SGF 05/04/17 - Reestructuro GrabAse: estaba dejando el DCB *
      *                y el DTC con el número de DAF en cero.      *
      *                Elimino archivo de estados al finalizar.    *
      * SGF 12/04/17 - Este programa es una vergüenza.             *
      *                No se estaba grabando PAHER8. Quedaban todas*
      *                las coberturas sin franquicia.              *
      * LRG 18/04/14 - Se cambia busqueda de Requiere Inspeccion   *
      *                en Hogar _GetRequiereInspeccion             *
      * SGF 25/04/17 - Llamo a COW312 para determinar plan de pagos*
      *                para la llamada a PAR312I pero no actualizo *
      *                CTW000 porque los especiales no están en Web*
      *                y cancela la consulta de cotizaciones.      *
      * LRG 10/05/17 - Se corrige la carga del archivo PAHER2      *
      *                moviendo los campos reales.                 *
      * SGF 18/05/17 - Mal grabado el Pagador en EC0 y EC1.        *
      * LRG 29/05/17 - Se corrige llamada a SPVTCR_setTcr, como    *
      *                inicio de vigencia se utliza MMAAAA actual  *
      *                del sistema.-                               *
      * JSN 21/07/17 - Eliminar la carga obligatoria del dato de   *
      *                DNI en las personas jurídicas, se modifico  *
      *                la subrutina grabAse                        *
      * LRG 15/08/2017: Se recompila por cambios en CTW000:        *
      *                          º Número de Cotización API        *
      *                          º Nombre de Sistema Remoto        *
      *                          º CUIT del productor              *
      * LRG 13/10/2017: Se recompila por cambios en CTW000:        *
      *                          º Nombre de Usuario               *
      * NWN 18/09/2018: Se modificaron los archivos PAHEV0/EV1.    *
      *                 Se cambio la definición de los campos de   *
      *                 Categorias (de alfa a numérico).           *
      * GIO 12/02/2019: Acondicionar PAR313F para 0 Kms 2 Años     *
      *                                                            *
      * LRG 24/09/2018: Se modifia procedimiento chkConfirma().    *
      *                 Nueva logica para determinar si requiere   *
      *                 inspeccion. COWVEH_confirmarInspeccion     *
      * SGF 19/03/2019: Agrego tratamiento de endosos.             *
      *                 Por el momento es sólo cambio de vehículo  *
      *                 es decir:                                  *
      *                 TIOU = 3, STOU = 7 and STOS = 4 que se usa *
      *                 para corregir patente, motor y chasis.     *
      *                 IMPORTANTE: otros endosos habrá que verlos.*
      * GIO 07/06/2019: RM#5147 Agrega validacion para el          *
      *                 vencimiento de la Tarjeta de Credito       *
      * JSN 27/05/2019: Se agrega llamada al procedimiento         *
      *                 COWGRAI_isFlota para determinar si requie- *
      *                 re inspeccion.                             *
      * JSN 10/07/2019: Se agrega en la rutina grabAse llamar al   *
      *                 procedimiento SVPASE_chkASE si no existe   *
      *                 el asegurado, grabarlo en SEHASE.          *
      * JSN 28/08/2019: Se agrega en la rutina grabEt4 llamar al   *
      *                 procedimiento SPVVEH_getRastreadorXSpol si *
      *                 es una renovación y el vehículo tiene      *
      *                 rastreador.                                *
      * JSN 18/09/2019: Se agrega la rutina grabEt3, la cual graba-*
      *                 los datos del archivo CTWET3 hacia PAHET3. *
      * SGF 24/03/2020: Incorporo Mascotas (CTWERA - PAHERA).      *
      * JSN 06/04/2020: Se agrega en la rutina grabEc4 llamar al   *
      *                 procedimiento PRWBIEN_copiaPoliza para     *
      *                 grabar en el campo C4RA07 si es una copia  *
      *                 de poliza.                                 *
      * JSN 05/05/2020: Se agrega filtro antes de ejecutar el pro- *
      *                 cedimiento SPVVEH_getRastreadorXSpol       *
      *                                                            *
      * LRG 08/05/2020: Se agrega archivo de carta de daoñs        *
      *                 CTWET5 y PAHET5                            *
      *                 GRABET5 --> t@ma54                         *
     *                 t4mcbp se modifica para colocar siempre 'N'*
      * SGF 03/06/2021: Este programa asumía (como era de esperar) *
     *                 que el nivel 6 se usaba solo para pagar un *
     *                 fijo. Bueno, resulta que Comercial empezó  *
     *                 a usarlo para pagar también porcentaje.    *
     *                 Ahora este programa se banca ambos comporta*
     *                 mientos.                                   *
     *                 Un verdadero quilombo.                     *
      * NWN 03/06/2021  Cambio de DIM para las Clausulas.          *
      *                 Antes de 5 , ahora de 200 - PAR314C1       *
      * JSN 25/06/2021: Se cambiar el parm peSaco por r2Saco para  *
      *                 ejecutar PAR314C1                          *
      * JSN 01/07/2021: Se agrega consulta al archivo de relación  *
      *                 ctw099 para ejecutar la propuesta          *
      * SGF 29/12/2021: Llamar a COW314.                           *
      * SGF 19/01/2022: Grabo DFNCBU en GNHDCB.                    *
      * SGF 23/01/2022: Recompilo por COPO/COPS en PAHET0.         *
      *                                                            *
      * ********************************************************** *
     Fctw000    uf   e           k disk
     Fctw001    if   e           k disk
     Fctw001c   if   e           k disk    prefix(wc:2)
     Fctw003    uf a e           k disk
     Fctw004    uf a e           k disk
     Fctwest    uf a e           k disk
     Fctwins    uf   e           k disk
     Fctweg3    if   e           k disk
     Fctwet0    if   e           k disk
     Fctwet1    if   e           k disk
     Fctwet4    if   e           k disk
     Fctwet5    if   e           k disk
     Fctwetc01  if   e           k disk
     Fctwer0    if   e           k disk
     Fctwer1    if   e           k disk
     Fctwer1b   if   e           k disk
     Fctwer2    if   e           k disk
     Fctwer4    if   e           k disk
     Fctwer6    if   e           k disk
     Fctwer7    if   e           k disk
     Fset105    if   e           k disk
     Fset12003  if   e           k disk
     Fset001    if   e           k disk
     Fset206    if   e           k disk
     Fset210    if   e           k disk
     Fset211    if   e           k disk
     Fset225    if   e           k disk
     Fset227    if   e           k disk
     Fset243    if   e           k disk
     Fset606    if   e           k disk
     Fset608    if   e           k disk
     Fset609    if   e           k disk
     Fset6091   if   e           k disk
     Fset610    if   e           k disk
     Fset611    if   e           k disk
     Fset6118   if   e           k disk
     Fset615    if   e           k disk
     Fset620    if   e           k disk
     Fset621    if   e           k disk    prefix(t1:2)
     Fset623    if   e           k disk
     Fset630    if   e           k disk
     Fset6302   if   e           k disk
     Fset6303   if   e           k disk
     Fset901    if   e           k disk
     Fset912    if   e           k disk
     Fsehni2    if   e           k disk
     Fsehni3    if   e           k disk
     Fsehni4    if   e           k disk
     Fgntloc    if   e           k disk
     Fgntpro    if   e           k disk
     Fsehase    if a e           k disk
     Fpaheg3    uf a e           k disk
     Fpaheg3p   uf a e           k disk
     Fpahec0    uf a e           k disk
     Fpahec1    uf a e           k disk
     Fpahec2    uf a e           k disk
     Fpahec3    if a e           k disk
     Fpahec4    uf a e           k disk
     Fpahec5    uf a e           k disk
     Fpahcc2    uf a e           k disk
     Fpahcd5    uf a e           k disk
     Fpahcd502  if   e           k disk
     Fpahed0    uf a e           k disk
     Fpahed1    uf a e           k disk
     Fpahed2    uf a e           k disk
     Fpahed3    uf a e           k disk
     Fpahed4    uf a e           k disk
     Fpahed5    uf a e           k disk
     Fpahet0    uf a e           k disk
     Fpahet1    uf a e           k disk
     Fpahet4    uf a e           k disk
     Fpahet5    uf a e           k disk
     Fpahet9    uf a e           k disk
     Fpaher0    uf a e           k disk
     Fpaher1    uf a e           k disk
     Fpaher1b   uf a e           k disk
     Fpaher2    uf a e           k disk
     Fpaher4    uf a e           k disk
     Fpaher6    uf a e           k disk
     Fpaher7    uf a e           k disk
     Fpaher8    uf a e           k disk
     Fpaher9    uf a e           k disk
     Fpaheg0    uf a e           k disk
     Fpaheg1    uf a e           k disk
     Fpawpc0    uf a e           k disk    prefix(ww:2)
     Fpawpd0    uf a e           k disk
     Fpawp310   uf a e           k disk
     Fset106    uf a e           k disk
     Fset013    uf a e           k disk
     Fgntmsg    uf a e           k disk
     Fctwev1    if   e           k disk
     Fctwev2    if   e           k disk
     Fctwevb    if   e           k disk
     Fpahev0    uf a e           k disk
     Fpahev1    uf a e           k disk
     Fpahev91   uf a e           k disk
     Fpahev2    uf a e           k disk
     Fset628    if   e           k disk
     Fset103    if   e           k disk
     Fctwmsg    if a e           k disk
     Fset916    if   e           k disk    prefix(t6:2)
     Fgti98007  uf   e           k disk
     Fgnhdtc    if a e           k disk
     Fgnhdcb    if a e           k disk
     Fset124    if   e           k disk    prefix(tx:2)
     Fpahet3    uf a e           k disk
     Fctwera    if   e           k disk
     Fpahera    uf a e           k disk
     Fctw099    if   e           k disk

     D COW310          pr                  extpgm('COW310')
     D  empr                          2a   const
     D  sucu                          3a   const
     D  nivt                          2a   const
     D  nivc                          6a   const
     D  nit1                          2a   const
     D  niv1                          6a   const
     D  nctw                          8a   const

     D COW310          pi
     D  p@Empr                        2a   const
     D  p@Sucu                        3a   const
     D  p@Nivt                        2a   const
     D  p@Nivc                        6a   const
     D  p@Nit1                        2a   const
     D  p@Niv1                        6a   const
     D  p@Nctw                        8a   const

      /copy './qcpybooks/COWVEH_H.rpgle'
      /copy './qcpybooks/SVPLRC_H.rpgle'
      /copy './qcpybooks/SPVSPO_H.rpgle'
      /copy './qcpybooks/SPVCBU_H.rpgle'
      /copy './qcpybooks/SPVFEC_H.rpgle'
      /copy './qcpybooks/SPVVEH_H.rpgle'
      /copy './qcpybooks/SPVTCR_H.rpgle'
      /copy './qcpybooks/SPVCBU_H.rpgle'
      /copy './qcpybooks/SVPDAF_H.rpgle'
      /copy './qcpybooks/SVPMAIL_H.rpgle'
      /copy './qcpybooks/SVPWS_H.rpgle'
      /copy './qcpybooks/PRWBIEN_H.rpgle'
      /copy './qcpybooks/PRWSND_H.rpgle'

     D SP0001          pr                  extpgm('SP0001')
     D  fech                          8  0
     D  cant                          2  0
     D  fpgm                          3a   options(*nopass)

     D SPCADCOM        pr                  extpgm('SPCADCOM')
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1  0
     D  nivc                          5  0
     D  cade                          5  0 dim(9)
     D  erro                           n
     D  endp                          3a
     D  nrdf                          7  0 dim(9) options(*nopass)

     D COW310_log      pr
     D  peMsg                       256a   const

     D SPT902          pr                  extpgm('SPT902')
     D  tnum                          1
     D  nres                          7  0

     D PAR310X         pr                  extpgm('PAR310X')
     D  empr                          1
     D  sucu                          2
     D  arcd                          6  0
     D  spo1                          9  0
     D  spol                          9  0
     D  sspo                          3  0
     D  modo                          3a
     D  epgm                          3a
     D  spo2                          9  0 options(*nopass)

     D PAR312I         pr                  extpgm('PAR312I')
     D  empr                          1
     D  sucu                          2
     D  arcd                          6  0
     D  spo1                          9  0
     D  spol                          9  0
     D  sspo                          3  0
     D  endp                          3
     D  nrpp                          3  0 const options(*Nopass)

     D PAR313F         pr                  extpgm('PAR313F')
     D  rama                          2  0
     D  vhmc                          3
     D  vhmo                          3
     D  vhcs                          3
     D  cobl                          2
     D  vhca                          2  0
     D  vhc1                          1  0
     D  vhc2                          1  0
     D  claj                          3  0
     D  rebr                          1  0
     D  lrce                         15  2
     D  saap                         15  2
     D  cfas                          1
     D  acrc                          7  0
     D  mone                          2
     D  dupe                          2  0
     D  acct                         15  2
     D  aver                          1
     D  gbco                          3
     D  scta                          1  0
     D  ctra                          3
     D  v0km                          1
     D  tiou                          1  0
     D  stou                          2  0
     D  vhct                          2  0
     D  vhvu                         15  2
     D  v0km2a                        1
     D  cl                            3    dim(30)
     D  an                            1    dim(30)

     D PAR313F1        pr                  extpgm('PAR313F1')
     D  rama                          2  0
     D  arcd                          6  0
     D  spol                          9  0
     D  cobl                          2
     D  vhaÑ                          4  0
     D  vhvu                         15  2
     D  tiou                          1  0
     D  stou                          2  0
     D  cl                            3    dim(30)
     D  an                            1    dim(30)

     D PAR310Y         pr                  ExtPgm('PAR310Y')
     D  empr                          1a
     D  sucu                          2a
     D  arcd                          6  0
     D  spo1                          9  0
     D  spol                          9  0
     D  sspo                          3  0
     D  endp                          3a
     D  spdw                          1a   options(*nopass)

     D PAR314CZ1       pr                  ExtPgm('PAR314CZ1')
     D  empr                          1a
     D  sucu                          2a
     D  arcd                          6  0
     D  spol                          9  0
     D  sspo                          3  0
     D  rama                          2  0
     D  arse                          2  0
     D  oper                          7  0
     D  suop                          3  0
     D  soln                          7  0
     D  retu                          4a

     D PAR312E         pr                  ExtPgm('PAR312E')
     D  prem                         15  2
     D  ccuo                          2  0
     D  ci1c                          1  0
     D  dv1c                          2  0
     D  cimc                          1  0
     D  immc                         15  2
     D  dfv1                          2  0
     D  dfm1                          2  0
     D  dfv2                          2  0
     D  dfm2                          2  0
     D  ivat                         15  2
     D  fdia                          2  0
     D  fmes                          2  0
     D  faÑo                          4  0
     D  come                         15  6
     D  fech                          8  0 dim(30)
     D  impo                         15  2 dim(30)
     D  nrpp                          3  0 options(*nopass:*omit)

     D PAR310X3        pr                  ExtPgm('PAR310X3')
     D  empr                          1
     D  fema                          4  0
     D  femm                          2  0
     D  femd                          2  0

     D PAR314CY        pr                  ExtPgm('PAR314CY')
     D  empr                          1
     D  sucu                          2
     D  arcd                          6s 0
     D  spol                          9s 0
     D  sspo                          3s 0
     D  rama                          2s 0
     D  arse                          2s 0
     D  oper                          7s 0
     D  poco                          4s 0
     D  suop                          3s 0
     D  riec                          3
     D  xcob                          3s 0
     D  cert                          9s 0
     D  poli                          7s 0
     D  xpro                          3s 0
     D  mone                          2
     D  clof                          1
     D  saco                         15  2

     D COW311          pr                  ExtPgm('COW311')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D COW312          pr                  ExtPgm('COW312')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const
     D  peNrpp                        3  0

     D PAR314F         pr                  ExtPgm('PAR314F')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peSuop                        3  0 const
     D  pePoco                        4  0 const
     D  peXpro                        3  0 const
     D  peMone                        2a   const
     D  cl                            3a   dim(30)
     D  an                            1a   dim(30)

     D SPEXCODE        pr                  extpgm('SPEXCODE')
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peFemi                       8  0 const
     D   peFpgm                       3a   const
     D   peTien                       1n
     D   peValo                      15  2 options(*nopass)
     D   peTipv                       1a   options(*nopass)
     D   peForm                       1a   options(*nopass)
     D   peDias                       5  0 options(*nopass)
     D   peDere                      15  2 options(*nopass)

     D actMarca        pr
     D  empr                          6    const
     D  sucu                          1    const

     D getPoco         pr             4  0
     D  poco                          4  0
     D  arra                          4  0 dim (9999)

     D getPocoV        pr             6  0
     D  poco                          6  0
     D  arra                          6  0 dim (999999)

     D getClausulas    pr              n
     D  peBase                             likeDs(paramBase) const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNctw                        7  0 const
     D  peMone                        2    const
     D  peClau                             likeds( dsClau_t )

     D getAnexos       pr              n
     D  peBase                             likeDs(paramBase) const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNctw                        7  0 const
     D  peMone                        2    const
     D  peAnex                             likeds( dsAnex_t )

     D random          pr                  extproc('CEERAN0')
     D  seed                         10u 0
     D  floater                       8f
     D  feedback                     12    options(*omit)

     D COW313          pr                  ExtPgm('COW313')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNit1                        1  0 const
     D  peNiv1                        5  0 const
     D  peNctw                        7  0 const

     D PAR314C1        pr                  ExtPgm('PAR314C1')
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peRiec                        3a   const
     D  peCobc                        3  0 const
     D  peMone                        2a   const
     D  peSaco                       15  2 const
     D  peXpri                        9  6
     D  pePtco                       15  2
     D  peTpcd                        2a
     D  peCls                         3a   dim(200)
     D  pePrem                       15  2 options(*omit:*nopass)
     D  peFran                             likeds(fran_t) options(*omit:*nopass)

     D COW314          pr                  ExtPgm('COW314')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNit1                        1  0 const
     D  peNiv1                        5  0 const
     D  peNctw                        7  0 const

     D @@Empr          s              1a
     D @@Sucu          s              2a
     D @@Nivt          s              1a
     D @@Nivc          s              5a
     D @@Nit1          s              1a
     D @@Niv1          s              5a
     D @@Nctw          s              7a

     D peBase          ds                  likeDs(paramBase)
     D peNctw          s              7  0
     D peClau          ds                  likeds( dsClau_t )
     D peAnex          ds                  likeds( dsAnex_t )
     D dsCtw           ds                  likeds(dsctw000_t)
     D DsAseg          ds                  likeds(Asegurado_t) dim(999)
     D DsAsegC         s             10i 0

     D @@stos          s              1  0
     D @@dupf          s              2  0
     D @@dupe          s              2  0
     D @@secu          s              2  0
     D @@femm          s              2  0
     D @@fmes          s              2  0
     D @@nrcu          s              2  0
     D @@fdia          s              2  0
     D @@femd          s              2  0
     D @@dup1          s              2  0
     D @@cont          s              3  0
     D @@cplc          s              3  0
     D @@sspo          s              3  0
     D @@pecu          s              3  0
     D codRas          s              3  0
     D @@fema          s              4  0
     D @@faÑo          s              4  0
     D @@ncoc          s              5  0
     D @@poco          s              6  0
     D @@nord          s              6  0
     D @@asen          s              7  0
     D @@nrco          s              7  0
     D @@oper          s              7  0
     D @@nrdf          s              7  0
     D @@hafa          s              8  0
     D @@anua          s              8  0
     D @@fdes          s              8  0
     D @@fech          s              8  0
     D @@femi          s              8  0
     D @@desd          s              8  0
     D @@spol          s              9  0
     D @@spo1          s              9  0
     D @@spo2          s              9  0
     D @@Ccbp          s              3  0

     D noExisteRas     s               n
     D Primera_Cuota   s               n
     D @@erro          s               n

     D @@ivat          s             15  2
     D @@cero          s             15  2 inz(0)

     D @@exdu          s              1
     D @@mar1          s              1
     D @@forz          s              1
     D @@spee          s              1
     D @@sues          s              1
     D @@free          s              1
     D @@envi          s              1
     D @@comi          s              1
     D @@strg          s              1
     D @@ciap          s              1
     D @@redo          s              1
     D @@m0km2a        s              1
     D @@m0km          s              1
     D @@clof          s              1    inz('0')
     D @@finp          s              3
     D @@cras          s              3
     D @@ncbu          s             25
     D @@ncta          s             25
     D ALFABETO        s             26    inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D ran             s             30
     D @@txt           s             79
     D moti            s             80

     D @@cade          s              5  0 dim(9)
     D fac             s              1    dim(9)
     D pd              s              5  2 dim(9)
     D pc              s              5  2 dim(9)
     D pf              s              5  2 dim(9)
     D pg              s              5  2 dim(9)
     D an              s              1    dim(30)
     D cl              s              3    dim(30)
     D fec             s              8  0 dim(30)
     D imp             s             15  2 dim(30)

     D x               s             10i 0
     D y               s             10i 0
     D k               s             10i 0
     D cantMail        s             10i 0

     D seed            s             10u 0
     D floater         s              8f

     D p@arcd          s              6s 0
     D p@spol          s              9s 0
     D p@sspo          s              3s 0
     D p@rama          s              2s 0
     D p@arse          s              2s 0
     D p@oper          s              7s 0
     D p@poco          s              4s 0
     D p@suop          s              3s 0
     D p@xcob          s              3s 0
     D p@cert          s              9s 0
     D p@poli          s              7s 0
     D p@xpro          s              3s 0

     D arrPoco         s              4  0 dim(9999)
     D arrPocoV        s              6  0 dim(999999)
     D arrNmer         s             40a   dim(9999)
     D todoRC          s              1N
     D qtyRamas        s             10i 0
     D @@cate          s              1a
     D tomador         s              7  0
     D @@ivtc          s              6  0
     D @@fvtc          s              6  0

     D zzcfra          s              2  0
     D zziffi          s             15  2
     D zzpfva          s              5  2
     D zzpftf          s              5  2
     D zziatf          s             15  2
     D zziitf          s             15  2
     D zzpftv          s              5  2
     D zzpatv          s              5  2
     D zzpitv          s              5  2
     D @@tpcd          s              2a

     D SI              c                   const('1')
     D NO              c                   const('0')

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      *- Alta de Dato Filiatorio
     D dsNomb          ds                  likeDs(dsNomb_t)
     D dsDomi          ds                  likeDs(dsDomi_t)
     D dsDocu          ds                  likeDs(dsDocu_t)
     D dsCont          ds                  likeDs(dsCont_t)
     D dsNaci          ds                  likeDs(dsNaci_t)
     D dsMarc          ds                  likeDs(dsMarc_t)
     D dsCbuS          ds                  likeDs(dsCbuS_t)
     D dsProv          ds                  likeDs(dsProI_t)
     D dsClav          ds                  likeDs(dsClav_t)
     D dsDape          ds                  likeDs(dsDape_t)
     D dsMail          ds                  likeDs(mailaddr_t)
     D peFran          ds                  likeDs(fran_t)

      *- Agrupación día mes año en un solo campo...
     D                 ds
     D  p@fdma                01     08  0
     D  p@fdia                01     02  0
     D  p@fmes                03     04  0
     D  p@faÑo                05     08  0

      *- Agrupación día mes año en un solo campo cálculo de 1ra cuota...
     D                 ds
     D  p@1dma                01     08  0
     D  p@fe1d                01     02  0
     D  p@fe1m                03     04  0
     D  p@fe1a                05     08  0

      *- Agrupación día mes año en un solo campo cálculo de 2da cuota...
     D                 ds
     D  p@2dma                01     08  0
     D  p@fe2d                01     02  0
     D  p@fe2m                03     04  0
     D  p@fe2a                05     08  0

      *- Agrupación día mes año en un solo campo cálculo de 3ra cuota...
     D                 ds
     D  p@3dma                01     08  0
     D  p@fe3d                01     02  0
     D  p@fe3m                03     04  0
     D  p@fe3a                05     08  0

      *- Agrupación año mes día en un solo campo cálculo de 1ra cuota...
     D                 ds
     D  p@1amd                01     08  0
     D  d@fe1a                01     04  0
     D  d@fe1m                05     06  0
     D  d@fe1d                07     08  0

      *- Agrupación año mes día en un solo campo cálculo de 2da cuota...
     D                 ds
     D  p@2amd                01     08  0
     D  d@fe2a                01     04  0
     D  d@fe2m                05     06  0
     D  d@fe2d                07     08  0

      *- Agrupación año mes día en un solo campo cálculo de 3ra cuota...
     D                 ds
     D  p@3amd                01     08  0
     D  d@fe3a                01     04  0
     D  d@fe3m                05     06  0
     D  d@fe3d                07     08  0

      *- CLausulas
     DdsClau_t         ds                  qualified based(template)
     D  ca01                          3
     D  ca02                          3
     D  ca03                          3
     D  ca04                          3
     D  ca05                          3
     D  ca06                          3
     D  ca07                          3
     D  ca08                          3
     D  ca09                          3
     D  ca10                          3
     D  ca11                          3
     D  ca12                          3
     D  ca13                          3
     D  ca14                          3
     D  ca15                          3
     D  ca16                          3
     D  ca17                          3
     D  ca18                          3
     D  ca19                          3
     D  ca20                          3
     D  ca21                          3
     D  ca22                          3
     D  ca23                          3
     D  ca24                          3
     D  ca25                          3
     D  ca26                          3
     D  ca27                          3
     D  ca28                          3
     D  ca29                          3
     D  ca30                          3

     DdsAnex_t         ds                  qualified based(template)
     D  an01                          1
     D  an02                          1
     D  an03                          1
     D  an04                          1
     D  an05                          1
     D  an06                          1
     D  an07                          1
     D  an08                          1
     D  an09                          1
     D  an10                          1
     D  an11                          1
     D  an12                          1
     D  an13                          1
     D  an14                          1
     D  an15                          1
     D  an16                          1
     D  an17                          1
     D  an18                          1
     D  an19                          1
     D  an20                          1
     D  an21                          1
     D  an22                          1
     D  an23                          1
     D  an24                          1
     D  an25                          1
     D  an26                          1
     D  an27                          1
     D  an28                          1
     D  an29                          1
     D  an30                          1

     D fran_t          ds                  qualified based(template)
     D  cfra                          2  0
     D  iffi                         15  2
     D  pfva                          5  2
     D  pftf                          5  2
     D  iitf                         15  2
     D  iatf                         15  2
     D  pftv                          5  2
     D  pitv                          5  2
     D  patv                          5  2

     D k1y000          ds                  likerec(c1w000:*key)
     D k1y001          ds                  likerec(c1w001:*key)
     D k2y001          ds                  likerec(c1w001c:*key)
     D k1y003          ds                  likerec(c1w003:*key)
     D k1y004          ds                  likerec(c1w004:*key)
     D k1yins          ds                  likerec(c1wins:*key)
     D k1yec0          ds                  likerec(p1hec0:*key)
     D k1yec1          ds                  likerec(p1hec1:*key)
     D k1yec2          ds                  likerec(p1hec2:*key)
     D k1yec3          ds                  likerec(p1hec3:*key)
     D k1yec4          ds                  likerec(p1hec4:*key)
     D k1yec5          ds                  likerec(p1hec5:*key)
     D k1yest          ds                  likerec(c1west:*key)
     D k1yed0          ds                  likerec(p1hed0:*key)
     D k1yed1          ds                  likerec(p1hed1:*key)
     D k1yed3          ds                  likerec(p1hed3:*key)
     D k1yed4          ds                  likerec(p1hed4:*key)
     D k1yed5          ds                  likerec(p1hed5:*key)
     D k1yeg3          ds                  likerec(c1weg3:*key)
     D k2yeg3          ds                  likerec(p1heg3:*key)
     D k1ycd5          ds                  likerec(p1hcd5:*key)
     D k1ycd52         ds                  likerec(p1hcd502:*key)
     D k1yet0          ds                  likerec(c1wet0:*key)
     D k2yet0          ds                  likerec(p1het0:*key)
     D k1yet1          ds                  likerec(c1wet1:*key)
     D k2yet1          ds                  likerec(p1het1:*key)
     D k1yet4          ds                  likerec(c1wet4:*key)
     D k2yet4          ds                  likerec(p1het4:*key)
     D k1yet5          ds                  likerec(c1wet5:*key)
     D k2yet5          ds                  likerec(p1het5:*key)
     D k2yet9          ds                  likerec(p1het9:*key)
     D k1het9          ds                  likerec(p1het9:*key)
     D k1yer0          ds                  likerec(c1wer0:*key)
     D k2yer0          ds                  likerec(p1her0:*key)
     D k1yer2          ds                  likerec(c1wer2:*key)
     D k2yer2          ds                  likerec(p1her2:*key)
     D k1yer4          ds                  likerec(c1wer4:*key)
     D k2yer4          ds                  likerec(p1her4:*key)
     D k1yer6          ds                  likerec(c1wer6:*key)
     D k2yer6          ds                  likerec(p1her6:*key)
     D k1yer7          ds                  likerec(c1wer7:*key)
     D k2yer7          ds                  likerec(p1her7:*key)
     D k1her9          ds                  likerec(p1her9:*key)
     D k1yetc          ds                  likerec(c1wetc:*key)
     D k1yni2          ds                  likerec(s1hni2:*key)
     D k1yni3          ds                  likerec(s1hni3:*key)
     D k1yni4          ds                  likerec(s1hni4:*key)
     D k1yloc          ds                  likerec(g1tloc:*key)
     D k1y105          ds                  likerec(s1t105:*key)
     D k1y120          ds                  likerec(s1t12003:*key)
     D k1y206          ds                  likerec(s1t206:*key)
     D k1y227          ds                  likerec(s1t227:*key)
     D k1y606          ds                  likerec(s1t606:*key)
     D k1y608          ds                  likerec(s1t608:*key)
     D k1y609          ds                  likerec(s1t609:*key)
     D k1y611          ds                  likerec(s1t611:*key)
     D k1y6118         ds                  likerec(s1t6118:*key)
     D k1y621          ds                  likerec(s1t621:*key)
     D k1y623          ds                  likerec(s1t623:*key)
     D k1y901          ds                  likerec(s1t901:*key)
     D k1y912          ds                  likerec(s1t912:*key)
     D k1ypc0          ds                  likerec(p1wpc0:*key)
     D k1ypd0          ds                  likerec(p1wpd0:*key)
     D k1ymsg          ds                  likerec(g1tmsg:*key)
     D k2ymsg          ds                  likerec(c1wmsg:*key)
     D k1t916          ds                  likerec(s1t916:*key)
     D k1i980          ds                  likerec(g1i980:*key)
     D k1wpd0          ds                  likerec(p1wpd0:*key)
     D k1hdcb          ds                  likerec(g1hdcb:*key)
     D k1hdtc          ds                  likerec(g1hdtc:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1w001          ds                  likerec(c1w001:*key)
     D k1her0          ds                  likerec(p1her0:*key)
     D k1heg0          ds                  likerec(p1heg0:*key)
     D k1heg1          ds                  likerec(p1heg1:*key)
     D k1her8          ds                  likerec(p1her8:*key)
     D k1her2          ds                  likerec(p1her2:*key)
     D k1hec4          ds                  likerec(p1hec4:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1t124          ds                  likerec(s1t124:*key)
     D k1yera          ds                  likerec(c1wera:*key)
     D k2yera          ds                  likerec(p1hera:*key)
     D k1y099          ds                  likerec(c1w099:*key)

     D condCom         ds                  likerec(c1w001c:*input)
     D ultEd0          ds                  likerec(p1hed0:*input)

     D $$nu12          s              2  0 inz(12)
     D $$endp          s              3    inz('   ')
     D $$mod1          s              3    inz('BCH')
     D $$grab          s              1    inz('S')
     D $$tnum          s              1    inz('2')
     D @@gram          s              1a
     D peNrpp          s              3  0
     D @@aux1          s              5  2
     D @@base          ds                  likeDs(paramBase)
     D @@Dst3          ds                  likeds(dsctwet3_t) dim( 999 )
     D @@Dst3C         s             10i 0
     D p1Poco          s              4  0
     D hoy             s              8  0
     D peTien          s              1n
     D peValo          s             15  2
     D peTval          s              1a
     D peFacc          s              1a
     D peDias          s              5  0
     D peDere          s             15  2
     D aux29           s             29  9
     D tot_prim        s             15  2
     D rc              s              1n
     D @@prem          s             15  2
     D  peSaco         s             15  2
     D  peXpri         s              9  6
     D  pePtco         s             15  2
     D  peTpcd         s              2a
     D  peCls          s              3a   dim(200)
     D  cfra           s              2  0
     D  iffi           s             15  2
     D  pfva           s              5  2
     D  pftf           s              5  2
     D  iitf           s             15  2
     D  iatf           s             15  2
     D  pftv           s              5  2
     D  pitv           s              5  2
     D  patv           s              5  2

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     Is1t210
     I              t@date                      tadate
     Is1t211
     I              t@date                      tbdate
     Is1t225
     I              t@date                      tcdate
     Is1t901
     I              t@date                      tddate
     Is1t243
     I              t@date                      tedate
     Ip1hev1
     I              v1cate                      vxcate
     Ic1wevb
     I              v0date                      vbdate
     Ip1het3
     I              t3date                      txdate

       *inlr = *on;

       // Paso datos de Entrada
       @@empr = %str(%addr(p@Empr));
       @@sucu = %str(%addr(p@Sucu));
       @@nivt = %str(%addr(p@Nivt));
       @@nivc = %str(%addr(p@Nivc));
       @@nit1 = %str(%addr(p@Nit1));
       @@niv1 = %str(%addr(p@Niv1));
       @@nctw = %str(%addr(p@Nctw));

       COW310_log( 'Comienza Cotización: ' + %trim(@@nctw) );

       peBase.peEmpr = @@Empr;
       peBase.peSucu = @@Sucu;
       peBase.peNivt = %dec( @@Nivt : 1 : 0 );
       peBase.peNivc = %dec( @@Nivc : 5 : 0 );
       peBase.peNit1 = %dec( @@Nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( @@Niv1 : 5 : 0 );

       peNctw = %dec( @@Nctw : 7 : 0 );

       // ------------------------------------------------------
       // Antes que nada, si todos los vehículos son cobertura
       // "A" y no es multirama, cambio artículo por 1006
       // (Qué negrada Dios!)
       // ------------------------------------------------------
       COW311( peBase.peEmpr
             : peBase.peSucu
             : peBase.peNivt
             : peBase.peNivc
             : peNctw        );

       // ------------------------------------------------------
       // Determino Plan de Pagos
       // ------------------------------------------------------
       COW312( peBase.peEmpr
             : peBase.peSucu
             : peBase.peNivt
             : peBase.peNivc
             : peNctw
             : peNrpp        );

       // ------------------------------------------------------
       // Completo para endosos
       // ------------------------------------------------------
       COW313( peBase.peEmpr
             : peBase.peSucu
             : peBase.peNivt
             : peBase.peNivc
             : peBase.peNit1
             : peBase.peNiv1
             : peNctw        );


       // Obtengo globales datos necesarios para grabar campos
       exsr obtDato;

       // Grabo en Archivo de Suspendidas
       exsr grabPc0;

       // Grabo Detalle de SuperPoliza en Proceso
       exsr grabPd0;

       // Graba en Archivo Paso a Paso
       exsr grabEst;

       // Grabo Archivos de Asegurados
       exsr grabAse;

       // Grabo Cabecera de SuperPoliza
       if w0tiou <= 2;
          exsr grabEc0;
       endif;

       // Grabo Suplemento de SuperPoliza
       exsr grabEc1;
       exsr grabEc2;
       exsr grabEc4;

       // Grabo Asegurados Adicionales
       exsr grabEc5;

       k1ypc0.wwempr = peBase.peEmpr;
       k1ypc0.wwsucu = peBase.peSucu;
       k1ypc0.wwarcd = w0arcd;
       if w0tiou = 1;
          k1ypc0.wwspo1 = @@spol;
        else;
          k1ypc0.wwspo1 = w0spo1;
       endif;
       chain %kds(k1ypc0) pawpc0;
       if %found;
          wwwp01 = 1;
          wwwp03 = 1;
          update p1wpc0;
       endif;

       // Grabo Comisiones
       exsr grabEg3;

       // Grabo datos Rama-Poliza
       exsr grabEd0;

       // Calculo comisiones
       exsr grabEd1;

       // Grabo Textos
       exsr grabEd2;

       // Calculo comisiones
       exsr grabEd3;

       // Grabo datos Clausulas
       exsr grabEd4;

       // Grabo datos Anexos
       exsr grabEd5;

       // Grabo componentes Vehivulos
       clear arrPoco;
       arrNmer(*) = *blanks;
       exsr grabEt0;
       exsr grabEt1;
       exsr grabEt4;
       exsr grabEt5;
       exsr grabEt9;
       exsr grabEt3;

       // Grabo componentes Hogar
       clear arrPoco;
       exsr grabEr0;
       exsr grabEr1;
       exsr grabEr1b;
       exsr grabEr2;
       exsr grabEr4;
       exsr grabEr6;
       exsr grabEr7;
       exsr grabEr8;
       exsr grabEr9;
       exsr grabEg0;
       exsr grabEra;

       // Grabo componentes Vida
       clear arrPoco;
       exsr grabEv0;
       exsr grabEv1;
       exsr grabEv2;
       exsr grabEvb;

       // Cálculo Cuotas Unificadas
       exsr grabEc3;
       exsr grabCd5;
       exsr grabCc2;

       k1ypc0.wwempr = peBase.peEmpr;
       k1ypc0.wwsucu = peBase.peSucu;
       k1ypc0.wwarcd = w0arcd;
       k1ypc0.wwspo1 = w0spo1;
       chain %kds(k1ypc0) pawpc0;
       if %found;
          wwwp02 = 1;
          update p1wpc0;
       endif;

       // Confirmo Poliza
       $$endp = *Blanks;
       $$mod1 = 'BCH';

       chain %kds(k1y000) ctw000;
       w0cest = 7;

       if chkConfirma or w0tiou = 2 or w0tiou = 3;

          w0cses = 7;

         actMarca ( 't@ma99' : '9' );

         if ( @@spee = '2' );

           @@spo2 = *Zeros;
           PAR310X ( w0empr : w0sucu : w0arcd : @@spo1
                   : @@spol : @@sspo : $$mod1 : $$endp : @@spo2 );

           k1i980.g0empr = w0empr;
           k1i980.g0sucu = w0sucu;
           k1i980.g0arcd = w0arcd;
           k1i980.g0spol = @@spol;
           k1i980.g0sspo = @@sspo;
           setll %kds(k1i980:5) gti98007;
           reade %kds(k1i980:5) gti98007;
           dow not %eof;
               g0sgmp = peNctw;
               g0nctz = w0soln;
               g0mar2 = '1';
               g0mar8 = 'W';
               update g1i980;
            reade %kds(k1i980:5) gti98007;
           enddo;

         else;

           PAR310X ( w0empr : w0sucu : w0arcd : @@spol
                   : @@spol : @@sspo : $$mod1 : $$endp );

         endif;

         // Elimino cabecera
         k1ypc0.wwempr = peBase.peEmpr;
         k1ypc0.wwsucu = peBase.peSucu;
         k1ypc0.wwarcd = w0arcd;
         if w0tiou = 1;
            k1ypc0.wwspo1 = @@spol;
          else;
            k1ypc0.wwspo1 = w0spo1;
         endif;
         chain %kds(k1ypc0) pawpc0;
         if %found;
            delete p1wpc0;
         endif;

         sgbody = 'Se ha emitido la Póliza ' + %char (d0poli)
                  + ' perteneciente a la Rama: ' + %editc ( d0rama : 'X')
                  + ' ' + %trim( GetNombreRama() )
                  +' del Asegurado Nro: ' + %char (@@asen) + ' '
                  + %trim(dsNomb.nomb);

         mstxmg = 'Se ha emitido el Nro. de Cotización '
                + %char ( peNctw );

         Exsr grabmsg;

         actMarca ( 't@ma99' : '1' );

       else;

         w0cses = 5;

         sgbody = 'Ha quedado suspendida la cotización ' + %char (w0Nctw)
                  + ' perteneciente a la Rama: ' + %editc ( d0rama : 'X')
                  + ' ' + %trim( GetNombreRama() )
                  +' del Asegurado Nro: ' + %char (@@asen) + ' '
                  + %trim(dsNomb.nomb);

         mstxmg = 'La emisión del Nro. de Cotización '
                + %char ( peNctw );

         Exsr grabmsg;

       endif;

       k1t916.t6cest = w0cest;
       k1t916.t6cses = w0cses;
       chain %kds(k1t916) set916;
       w0dest = t6dest;
       if %found;
          update c1w000;
       endif;

       // -------------------------------
       // La dejo como suspendida normal
       // -------------------------------
       k1ypc0.wwempr = peBase.peEmpr;
       k1ypc0.wwsucu = peBase.peSucu;
       k1ypc0.wwarcd = w0arcd;
       if w0tiou = 1;
          k1ypc0.wwspo1 = @@spol;
        else;
          k1ypc0.wwspo1 = w0spo1;
       endif;
       chain %kds(k1ypc0) pawpc0;
       if %found;
          wwmarp = '0';
          update p1wpc0;
       endif;

       // -------------------------------
       // Elimino archivo de estados
       // -------------------------------
       k1yest.t@empr = peBase.peEmpr;
       k1yest.t@sucu = peBase.peSucu;
       k1yest.t@nivt = peBase.peNivt;
       k1yest.t@nivc = peBase.peNivc;
       k1yest.t@nctw = peNctw;
       chain %kds ( k1yest ) ctwest;
       if %found;
          delete c1west;
       endif;

       k1y099.w9Empr = peBase.peEmpr;
       k1y099.w9Sucu = peBase.peSucu;
       k1y099.w9Nivt = peBase.peNivt;
       k1y099.w9Nivc = peBase.peNivc;
       k1y099.w9nctw = peNctw;
       chain %kds( k1y099 : 5 ) ctw099;
       if %found( ctw099 );
         clear DsAseg;
         DsAsegC = 0;
         if COWRTV_getAsegurado( peBase : peNctw : DsAseg : DsAsegC );

           if w9Nctx > *zeros;
             k1y003.w3empr = peBase.peEmpr;
             k1y003.w3sucu = peBase.peSucu;
             k1y003.w3nivt = peBase.peNivt;
             k1y003.w3nivc = peBase.peNivc;
             k1y003.w3nctw = w9Nctx;
             setll %kds ( k1y003 : 5) ctw003;
             reade %kds ( k1y003 : 5 ) ctw003;
             dow not %eof ( ctw003 );
               w3Asen = DsAseg(DsAsegC).w3Asen;
               update c1w003;
               reade %kds ( k1y003 : 5 ) ctw003;
             enddo;

             clear DsCtw;
             if COWGRAI_getCtw000( peBase : w9Nctx : DsCtw );
               PRWSND_sndDtaQ( peBase
                             : w9Nctx  );
               PRWSND_sndMail( peBase : w9Nctx : DsCtw.w0Soln );
             endif;
           endif;

           if w9Ncty > *zeros;
             k1y003.w3empr = peBase.peEmpr;
             k1y003.w3sucu = peBase.peSucu;
             k1y003.w3nivt = peBase.peNivt;
             k1y003.w3nivc = peBase.peNivc;
             k1y003.w3nctw = w9Ncty;
             setll %kds ( k1y003 : 5) ctw003;
             reade %kds ( k1y003 : 5 ) ctw003;
             dow not %eof ( ctw003 );
               w3Asen = DsAseg(DsAsegC).w3Asen;
               update c1w003;
               reade %kds ( k1y003 : 5 ) ctw003;
             enddo;
             clear DsCtw;
             if COWGRAI_getCtw000( peBase : w9Ncty : DsCtw );
               PRWSND_sndDtaQ( peBase
                             : w9Ncty  );
               PRWSND_sndMail( peBase : w9Ncty : DsCtw.w0soln );
             endif;
           endif;
         endif;
       endif;

       COW314 ( peBase.peEmpr
              : peBase.peSucu
              : peBase.peNivt
              : peBase.peNivc
              : peBase.peNit1
              : peBase.peNiv1
              : peNctw        );

       return;

       begsr obtDato;

         // Accedo a Archivo Cabecera de Cotizacion
         k1y000.w0empr = peBase.peEmpr;
         k1y000.w0sucu = peBase.peSucu;
         k1y000.w0nivt = peBase.peNivt;
         k1y000.w0nivc = peBase.peNivc;
         k1y000.w0nctw = peNctw;
         chain %kds ( k1y000 ) ctw000;

         if not %found ( ctw000 );

           return;

         endif;

         // Si Tiene Numero de SuperPoliza, Elimino de Suspendida
         if ( w0spol <> *Zeros );

           $$endp = 'BCH';
           PAR310Y ( w0empr : w0sucu : w0arcd : w0spo1
                   : w0spol : w0sspo : $$endp );

           w0spol = *Zeros;

         endif;

         // Obtengo numero de SuperPoliza y Suplemento
         if ( w0spol = *Zeros );

           select;

             when ( w0tiou = 1 );

               @@spol = SPVSPO_getSpol(w0empr:w0sucu:w0arcd:$$grab);
               w0spol = @@spol;
               w0spo1 = @@spol;
               @@spo1 = @@spol;
               @@sspo = *Zeros;
               w0sspo = *Zeros;

             when ( w0tiou = 2 );

               @@spol = SPVSPO_getSpol(w0empr:w0sucu:w0arcd:$$grab);
               w0spol = @@spol;
               @@sspo = *Zeros;
               w0sspo = *Zeros;
               @@spo1 = w0spo1;

             other;

               w0spol = w0spo1;
               @@spol = w0spo1;
               @@spo1 = w0spo1;

               k1yec1.c1empr = w0empr;
               k1yec1.c1sucu = w0sucu;
               k1yec1.c1arcd = w0arcd;
               k1yec1.c1spol = w0spol;

               setgt %kds ( k1yec1 : 4 ) pahec1;
               readpe %kds ( k1yec1 : 4 ) pahec1;

               @@sspo = c1sspo + 1;
               w0sspo = @@sspo;

           endsl;

           // --------------------------------------
           // Cambio SubEstado para que quede como
           // "PROPUESTA EN EMISION".... aunque ya
           // es SUPERPOLIZA a esta altura
           // --------------------------------------
           w0cest = 5;
           w0cses = 4;
           k1t916.t6cest = w0cest;
           k1t916.t6cses = w0cses;
           chain %kds(k1t916) set916;
           if %found;
              w0dest = t6dest;
            else;
              w0dest = *all'*';
           endif;
           update c1w000;

         endif;

         // Obtengo operacion de sistema
         k1y901.t@tiou = w0tiou;
         k1y901.t@stou = w0stou;
         chain %kds ( k1y901 ) set901;
         @@stos = w0stos;

         chain w0arcd set620;
         // Obtengo duracion de periodo
         @@dupe = t@dupe;

         // Obtengo forma de expresion duracion de periodo
         @@exdu = t@mar1;

         // Obtengo si es articulo libre
         @@free = t@free;

         // Obtengo marca Artículos Suspendidos Especiales
         @@sues = t@mar2;
         select;
           when t@mar2 = '0';
             @@strg = 'N';
           when t@mar2 = '1';
             @@strg = 'S';
           when t@mar2 = '2';
             @@strg = 'N';
         endsl;

         // Obtengo compania de coaseguro
         chain w0arcd set621;
         @@ncoc = t1ncoc;
         @@dupf = t1dupe;

         // Obtengo hasta facturado
         @@hafa = SPVFEC_GiroFecha8 ( w0vdes : 'DMA' );
         sp0001 ( @@hafa : t1dupe );
         @@hafa = SPVFEC_GiroFecha8 ( @@hafa : 'AMD' );
         if @@hafa > w0vhas;
            @@hafa = w0vhas;
         endif;

         // Obtengo anualidad
         @@anua = SPVFEC_GiroFecha8 ( w0vdes : 'DMA' );
         SP0001 ( @@anua : $$nu12 );
         @@anua = SPVFEC_GiroFecha8 ( @@anua : 'AMD' );
         if @@anua > w0vhas;
            @@anua = w0vhas;
         endif;

         // ---------------------------------------
         // Anualidad y hasta facturado en los
         // endosos, es la última
         // ---------------------------------------
         if w0tiou = 3;
            k1hed0.d0empr = w0empr;
            k1hed0.d0sucu = w0sucu;
            k1hed0.d0arcd = w0arcd;
            k1hed0.d0spol = @@spol;
            setgt  %kds(k1hed0:4) pahed0;
            readpe %kds(k1hed0:4) pahed0 ultEd0;
            if not %eof;
               @@hafa = (ultEd0.d0fhfa * 10000)
                      + (ultEd0.d0fhfm *   100)
                      +  ultEd0.d0fhfd;
               @@anua = (ultEd0.d0fvaa * 10000)
                      + (ultEd0.d0fvam *   100)
                      +  ultEd0.d0fvad;
            endif;
         endif;

         // Marca de compania propia
         k1y120.t@empr = w0empr;
         k1y120.t@sucu = w0sucu;
         k1y120.t@ncoc = @@ncoc;
         chain %kds ( k1y120 ) set12003;
         if %found ( set12003 );
           @@ciap = t@ciap;
         else;
           @@ciap = '0';
         endif;

         // Obtengo entorno de la vigencia
         chain w0arcd set630;
         @@envi = t@ma16;
         @@forz = t@ma20;
         @@comi = t@ma26;
         @@redo = t@ma35;

         // Marca SpeedWay
         @@spee = t@ma44;

         // Obtengo cadena comercial
         SPCADCOM( w0empr : w0sucu : w0nivt :
                   w0nivc : @@cade : @@erro : @@finp );

         // Obtengo numero de operacion
         if w0tiou <= 2;
            SPT902 ( $$tnum : @@oper );
          else;
            @@oper = ultEd0.d0oper;
         endif;

         // Obtengo numero de persona de cobrador
         k1yni3.n3empr = w0empr;
         k1yni3.n3sucu = w0sucu;
         k1yni3.n3cbrn = w0nivc;
         chain %kds ( k1yni3 ) sehni3;
         @@nrco = n3nrdf;

         // Obtengo codigo de plan de cobranza
         k1yni4.n4empr = w0empr;
         k1yni4.n4sucu = w0sucu;
         k1yni4.n4cbrn = w0nivc;
         k1yni4.n4czco = 9999999;
         k1yni4.n4mone = w0mone;
         chain %kds ( k1yni4 ) sehni4;
         @@cplc = n4cplc;

         // Obtengo Marca de Refa/Reno para C0MAR1
         @@mar1 = '0';

         chain w0arcd set6303;
         if %found ( set6303 );
           @@mar1 = '9';
         endif;

         chain w0arcd set6302;
         if %found ( set6302 );
           @@mar1 = '1';
         endif;

         // Guardo CBU
         @@ncbu = %char( w0ncbu );

       endsr;

       begsr grabPc0;

         wwempr = peBase.peEmpr;
         wwsucu = peBase.peSucu;
         wwarcd = w0arcd;
         if w0tiou = 1;
            wwspo1 = @@spol;
          else;
            wwspo1 = w0spo1;
         endif;
         wwspol = @@spol;
         wwsspo = @@sspo;
         wwtiou = w0tiou;
         wwstou = w0stou;
         wwstos = @@sspo;

         wwwp01 = *Zeros;
         wwwp02 = *Zeros;
         wwwp03 = *Zeros;
         wwwp04 = *Zeros;
         wwwp05 = *Zeros;
         wwwp06 = *Zeros;
         wwwp07 = *Zeros;
         wwwp08 = *Zeros;
         wwwp09 = *Zeros;
         wwwp10 = *Zeros;
         wwwp11 = *Zeros;
         wwwp12 = *Zeros;
         wwwp13 = *Zeros;
         wwwp14 = *Zeros;
         wwwp15 = *Zeros;
         wwwipa = *Year;
         wwnpro = *Zeros;
         wwwipm = umonth;
         wwwipd = uday;
         wwmarp = '3';

         wwuser = @PsDs.CurUsr;
         wwdate = udate;
         wwtime = %dec(%time():*iso);

         write p1wpc0;

       endsr;

       begsr grabPd0;


         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctw001;
         reade %kds ( k1y001 : 5 ) ctw001;

         dow not %eof ( ctw001 );

           z0empr = peBase.peEmpr;
           z0sucu = peBase.peSucu;
           z0arcd = w0arcd;
           if w0tiou = 1;
              z0spo1 = @@spol;
            else;
              z0spo1 = w0spo1;
           endif;
           z0spol = @@spol;
           z0sspo = @@sspo;
           z0rama = w1rama;
           z0arse = 1;
           z0oper = @@oper;
           z0suop = @@sspo;
           z0tiou = w0tiou;
           z0stou = w0stou;
           z0stos = w0stos;
           z0ncoc = @@ncoc;
           z0ciap = @@ciap;
           z0wp01 = *Zeros;
           z0wp02 = *Zeros;
           z0wp03 = *Zeros;
           z0wp04 = 1;
           z0wp05 = 1;
           z0wp06 = *Zeros;
           z0wp07 = *Zeros;
           z0wp08 = *Zeros;
           z0wp09 = *Zeros;
           z0wp10 = *Zeros;
           z0wp11 = *Zeros;
           z0wp12 = *Zeros;
           z0wp13 = *Zeros;
           z0wp14 = *Zeros;
           z0wp15 = *Zeros;
           z0copc = '0';
           z0marp = '0';
           z0cpar = '1';
           z0part = 100;
           z0copg = *Zeros;
           z0gpil = *Zeros;
           z0user = @PsDs.CurUsr;
           z0date = udate;
           z0time = %dec(%time():*iso);
           write p1wpd0;

           z0emprlk = peBase.peEmpr;
           z0suculk = peBase.peSucu;
           z0arcdlk = w0arcd;
           if w0tiou = 1;
              z0spo1lk = @@spol;
            else;
              z0spo1lk = w0spo1;
           endif;
           z0spollk = @@spol;
           z0sspolk = @@sspo;
           z0ramalk = w1rama;
           z0arselk = 1;
           z0operlk = @@oper;
           z0suoplk = @@sspo;
           z0wp01lk = *Zeros;
           z0wp02lk = *Zeros;
           z0wp03lk = *Zeros;
           z0wp04lk = 1;
           z0wp05lk = 1;
           z0wp06lk = *Zeros;
           z0wp07lk = *Zeros;
           z0wp08lk = *Zeros;
           z0wp09lk = *Zeros;
           z0wp10lk = *Zeros;
           z0wp11lk = *Zeros;
           z0wp12lk = *Zeros;
           z0wp13lk = *Zeros;
           z0wp14lk = *Zeros;
           z0wp15lk = *Zeros;
           z0userlk = @PsDs.CurUsr;
           z0datelk = udate;
           z0timelk = %dec(%time():*iso);
           write p1wp310;

           reade %kds ( k1y001 : 5 ) ctw001;

         enddo;

       endsr;

       begsr grabEst;

         k1yest.t@empr = peBase.peEmpr;
         k1yest.t@sucu = peBase.peSucu;
         k1yest.t@nivt = peBase.peNivt;
         k1yest.t@nivc = peBase.peNivc;
         k1yest.t@nctw = peNctw;
         chain %kds ( k1yest ) ctwest;

         if not %found ( ctwest );

           t@empr = w0empr;
           t@sucu = w0sucu;
           t@nivt = w0nivt;
           t@nivc = w0nivc;
           t@nctw = w0nctw;

           t@ma00 = '0';
           t@ma01 = '0';
           t@ma02 = '0';
           t@ma03 = '0';
           t@ma04 = '0';
           t@ma05 = '0';
           t@ma06 = '0';
           t@ma07 = '0';
           t@ma08 = '0';
           t@ma09 = '0';
           t@ma10 = '0';
           t@ma11 = '0';
           t@ma12 = '0';
           t@ma13 = '0';
           t@ma14 = '0';
           t@ma15 = '0';
           t@ma16 = '0';
           t@ma17 = '0';
           t@ma18 = '0';
           t@ma19 = '0';
           t@ma20 = '0';
           t@ma21 = '0';
           t@ma22 = '0';
           t@ma23 = '0';
           t@ma24 = '0';
           t@ma25 = '0';
           t@ma26 = '0';
           t@ma27 = '0';
           t@ma28 = '0';
           t@ma29 = '0';
           t@ma30 = '0';
           t@ma31 = '0';
           t@ma32 = '0';
           t@ma33 = '0';
           t@ma34 = '0';
           t@ma35 = '0';
           t@ma36 = '0';
           t@ma37 = '0';
           t@ma38 = '0';
           t@ma39 = '0';
           t@ma40 = '0';
           t@ma41 = '0';
           t@ma42 = '0';
           t@ma43 = '0';
           t@ma44 = '0';
           t@ma45 = '0';
           t@ma46 = '0';
           t@ma47 = '0';
           t@ma48 = '0';
           t@ma49 = '0';
           t@ma50 = '0';
           t@ma51 = '0';
           t@ma52 = '0';
           t@ma53 = '0';
           t@ma54 = '0';
           t@ma55 = '0';
           t@ma56 = '0';
           t@ma57 = '0';
           t@ma58 = '0';
           t@ma59 = '0';
           t@ma60 = '0';
           t@ma61 = '0';
           t@ma62 = '0';
           t@ma63 = '0';
           t@ma64 = '0';
           t@ma65 = '0';
           t@ma66 = '0';
           t@ma67 = '0';
           t@ma68 = '0';
           t@ma69 = '0';
           t@ma70 = '0';
           t@ma71 = '0';
           t@ma72 = '0';
           t@ma73 = '0';
           t@ma74 = '0';
           t@ma75 = '0';
           t@ma76 = '0';
           t@ma77 = '0';
           t@ma78 = '0';
           t@ma79 = '0';
           t@ma80 = '0';
           t@ma81 = '0';
           t@ma82 = '0';
           t@ma83 = '0';
           t@ma84 = '0';
           t@ma85 = '0';
           t@ma86 = '0';
           t@ma87 = '0';
           t@ma88 = '0';
           t@ma89 = '0';
           t@ma90 = '0';
           t@ma91 = '0';
           t@ma92 = '0';
           t@ma93 = '0';
           t@ma94 = '0';
           t@ma95 = '0';
           t@ma96 = '0';
           t@ma97 = '0';
           t@ma98 = '0';
           t@ma99 = '0';

           write c1west;

         endif;

       endsr;

       begsr grabAse;

         // -----------------------------------
         // Doy de alta todos los dafs que
         // hagan falta
         // -----------------------------------
         k1y003.w3empr = peBase.peEmpr;
         k1y003.w3sucu = peBase.peSucu;
         k1y003.w3nivt = peBase.peNivt;
         k1y003.w3nivc = peBase.peNivc;
         k1y003.w3nctw = peNctw;
         setll %kds ( k1y003 : 5) ctw003;
         reade %kds ( k1y003 : 5 ) ctw003;
         dow not %eof ( ctw003 );
             if w3asen = 0;
                clear dsNomb;
                clear dsDomi;
                clear dsDocu;
                clear dsNaci;
                clear dsDape;
                clear dsCont;
                clear dsClav;
                clear dsCbuS;
                clear dsProv;
                clear dsMail;
                dsNomb.nomb = w3nomb;
                dsDomi.domi = w3domi;
                dsDomi.copo = w3copo;
                dsDomi.cops = w3cops;
                if w3Tiso <> 98 and w3Nrdo = 0;
                  dsDocu.tido = 0;
                else;
                  dsDocu.tido = w3tido;
                endif;
                dsDocu.nrdo = w3nrdo;
                dsDocu.tiso = w3tiso;
                if w3cuit = *all'0';
                  dsDocu.cuit = *blanks;
                else;
                  dsDocu.cuit = w3cuit;
                endif;
                dsDocu.cuil = w3njub;
                dsNaci.fnac = w3fnac;
                dsNaci.pain = w3pain;
                dsNaci.cnac = w3cnac;
                dsDape.sexo = w3csex;
                dsDape.esci = w3cesc;
                dsDape.raae = w3raae;
                dsDape.cprf = w3cprf;
                dsCont.tpa1 = w3telp;
                dsCont.tcel = w3telc;
                dsCont.ttr1 = w3telt;

                cantMail = *Zeros;
                k1y004.w4empr = peBase.peEmpr;
                k1y004.w4sucu = peBase.peSucu;
                k1y004.w4nivt = peBase.peNivt;
                k1y004.w4nivc = peBase.peNivc;
                k1y004.w4nctw = peNctw;
                k1y004.w4nase = w3nase;
                k1y004.w4asen = w3asen;
                setll %kds ( k1y004 : 7 ) ctw004;
                reade %kds ( k1y004 : 7 ) ctw004;
                dow not %eof ( ctw004 );
                    dsMail.mail = w4mail;
                    dsMail.tipo = w4ctce;
                    cantMail += 1;
                  reade %kds ( k1y004 : 7 ) ctw004;
                enddo;
                @@nrdf = SVPDAF_setDatoFiliatorio ( dsNomb
                                                  : dsDomi
                                                  : dsDocu
                                                  : dsCont
                                                  : dsNaci
                                                  : dsMarc
                                                  : dsCbuS
                                                  : dsDape
                                                  : dsClav
                                                  : @@txt
                                                  : *Zeros
                                                  : dsProv
                                                  : *Zeros
                                                  : dsMail
                                                  : cantMail );
                exsr grabHas;
                w3asen = @@nrdf;
                update c1w003;

             else;
               if not SVPASE_chkASE( w3Asen );
                 @@Nrdf = w3Asen;
                 exsr grabHas;
               endif;
             endif;

          reade %kds ( k1y003 : 5 ) ctw003;
         enddo;

         // -------------------------------------
         // Actualizo numero de daf en CTW004
         // -------------------------------------
         k1y004.w4empr = peBase.peEmpr;
         k1y004.w4sucu = peBase.peSucu;
         k1y004.w4nivt = peBase.peNivt;
         k1y004.w4nivc = peBase.peNivc;
         k1y004.w4nctw = peNctw;
         setll %kds ( k1y004 : 5 ) ctw004;
         reade %kds ( k1y004 : 5 ) ctw004;
         dow not %eof ( ctw004 );
             if w4asen = 0;
                k1y003.w3empr = w4empr;
                k1y003.w3sucu = w4sucu;
                k1y003.w3nivt = w4nivt;
                k1y003.w3nivc = w4nivc;
                k1y003.w3nctw = w4nctw;
                k1y003.w3nase = w4nase;
                chain(n) %kds(k1y003:6) ctw003;
                if %found;
                   if w3asen <> 0;
                      w4asen = w3asen;
                      update c1w004;
                   endif;
                endif;
             endif;
         reade %kds ( k1y004 : 5 ) ctw004;
         enddo;

         // -------------------------------------
         // Para el tomador, debo grabar cuentas
         // y tarjetas si se paga con alguna de
         // esas formas de pago
         // -------------------------------------
         tomador = 0;
         k1y003.w3empr = peBase.peEmpr;
         k1y003.w3sucu = peBase.peSucu;
         k1y003.w3nivt = peBase.peNivt;
         k1y003.w3nivc = peBase.peNivc;
         k1y003.w3nctw = peNctw;
         k1y003.w3nase = 0;
         chain(n) %kds(k1y003:6) ctw003;
         if %found;
            tomador = w3asen;
            select;
             when w0cfpg = 1;
                  if w0ctcu <> 0 and w0nrtc <> 0;
                     @@ivtc = *month * 10000 + *year;
                     monitor;
                     @@fvtc  = %int( %subst( %char ( w0fvtc ) : 5 : 2 ) )
                             * 10000 +
                               %int( %subst( %char ( w0fvtc ) : 1 : 4 ));
                     on-error;
                     @@fvtc = @@ivtc;
                     endmon;
                     if @@fvtc = @@ivtc;
                        if *month = 1;
                           @@ivtc = (12 * 10000) + ( *year - 1);
                        else;
                           @@ivtc = ( (*month-1) * 10000) + *year;
                        endif;
                     endif;
                     SPVTCR_setTcr ( w3asen : w0ctcu : w0nrtc
                                   : @@ivtc : @@fvtc : @PsDs.CurUsr) ;
                  endif;
             when w0cfpg = 2 or w0cfpg = 3;
                  if w0ncbu <> 0;
                     SPVCBU_SetCBUEntero( %editc(w0ncbu:'X')
                                        : w3asen            );
                  endif;
            endsl;
         endif;

       endsr;

       begsr grabHas;

         // Grabo SEHASE
         setll @@nrdf sehase;

         if not %equal ( sehase );

           asasen = @@nrdf;
           asempr = w3empr;
           assucu = w3sucu;
           asciva = w3civa;
           asnivt = w3nivt;
           asnivc = w3nivc;
           ascbrn = w3nivc;
           asrpro = w3rpro;
           asnaci = *Blanks;
           asfein = w3fein;
           asnrin = w3nrin;
           asfeco = w3feco;
           asntel = w3telp;
           asruta = w3ruta;

           asczco = 9999999;

           asbloq = *Zeros;
           asasrp = *Zeros;
           ascpro = *Zeros;
           ascorg = *Zeros;
           ascpr1 = *Zeros;
           ascpr2 = *Zeros;
           ascaps = *Zeros;
           ascapc = *Zeros;
           asaccs = *Zeros;
           asacci = *Zeros;
           assocn = *Zeros;
           asainn = *Zeros;
           asminn = *Zeros;
           asdinn = *Zeros;
           asaegn = *Zeros;
           asmegn = *Zeros;
           asdegn = *Zeros;
           asczge = *Zeros;
           asivrs = *Zeros;

           asuser = @PsDs.CurUsr;
           asdate = udate;
           astime = %dec(%time():*iso);

           write s1hase;

         endif;

       endsr;

       begsr grabEc0;

         actMarca ( 't@ma05' : '9' );

         c0empr = w0empr;
         c0sucu = w0sucu;
         c0arcd = w0arcd;
         c0spol = @@spol;
         c0mone = w0mone;

         c0asen = tomador;
         c0cfpg = w0cfpg;
         c0opag = tomador;
         c0ctcu = w0ctcu;
         c0nrtc = w0nrtc;
         if SPVCBU_GetCBUSeparado(@@ncbu : c0ivbc : c0ivsu : c0tcta : c0ncta);
         endif;

         c0cbrn = w0nivt;
         c0czco = 9999999;
         c0nivt = w0nivt;
         c0nivc = w0nivc;

         c0fipa = SPVFEC_ObtaÑoFecha8 ( w0fpro );
         c0fipm = SPVFEC_ObtMesFecha8 ( w0fpro );
         c0fipd = SPVFEC_ObtDiaFecha8 ( w0fpro );
         c0fioa = SPVFEC_ObtaÑoFecha8 ( w0vdes );
         c0fiom = SPVFEC_ObtMesFecha8 ( w0vdes );
         c0fiod = SPVFEC_ObtDiaFecha8 ( w0vdes );
         c0fvoa = SPVFEC_ObtaÑoFecha8 ( w0vhas );
         c0fvom = SPVFEC_ObtMesFecha8 ( w0vhas );
         c0fvod = SPVFEC_ObtDiaFecha8 ( w0vhas );

         c0dupe = @@dupe;
         c0mar5 = @@exdu;
         c0mar2 = @@sues;
         c0mar3 = @@envi;
         c0mar1 = @@mar1;

         c0wcoa = 0;
         c0cocp = '0';
         c0mar4 = '0';
         c0strg = '0';
         c0econ = '0';
         c0nrct = *Zeros;
         c0nrln = *Zeros;
         h0nivt = *Zeros;
         h0nivc = *Zeros;
         c0ncre = *Zeros;
         c0ffca = *Zeros;
         c0ffcm = *Zeros;
         c0ffcd = *Zeros;
         c0ccuo = *Zeros;
         c0ivr2 = *Zeros;
         c0nrrt = *Zeros;
         c0nrlo = *Zeros;
         c0fboa = *Zeros;
         c0fbom = *Zeros;
         c0fbod = *Zeros;
         c0cert = *Zeros;
         c0suas = *Zeros;
         c0saca = *Zeros;
         c0sacr = *Zeros;
         c0sast = *Zeros;
         c0fema = *Zeros;
         c0femm = *Zeros;
         c0femd = *Zeros;
         c0spoa = *Zeros;
         c0spon = *Zeros;
         c0sema = *Zeros;
         c0xpro = *Zeros;
         c0fhfa = *Zeros;
         c0fhfm = *Zeros;
         c0fhfd = *Zeros;
         c0nrla = *Blanks;

         c0user = @PsDs.CurUsr;
         c0date = udate;
         c0time = %dec(%time():*iso);

         select;
          when c0cfpg = 1;
               c0nrct = 0;
               c0cbrn = 0;
               c0cocp = '0';
               c0nrla = *blanks;
               c0nrln = 0;
               c0ivbc = 0;
               c0ivsu = 0;
               c0tcta = 0;
               c0ncta = *blanks;
               c0czco = 0;
          when c0cfpg = 2 or c0cfpg = 3;
               c0cbrn = 0;
               c0czco = 0;
               c0cocp = '0';
               c0ctcu = 0;
               c0nrtc = 0;
               c0nrct = 0;
               c0nrla = *blanks;
               c0nrln = 0;
          when c0cfpg = 4;
               c0ctcu = 0;
               c0nrtc = 0;
               c0nrtc = 0;
               c0nrla = *blanks;
               c0nrln = 0;
               c0ivbc = 0;
               c0ivsu = 0;
               c0tcta = 0;
               c0ncta = *blanks;
         endsl;

         write p1hec0;

         actMarca ( 't@ma05' : '1' );

       endsr;

       begsr grabEc1;

         actMarca ( 't@ma06' : '9' );

         c1empr = w0empr;
         c1sucu = w0sucu;
         c1arcd = w0arcd;
         c1spol = @@spol;
         c1sspo = @@sspo;
         c1mone = w0mone;
         c1come = w0come;
         c1tiou = w0tiou;
         c1stou = w0stou;
         c1stos = @@stos;

         c1asen = tomador;
         c1cfpg = w0cfpg;
         c1opag = tomador;
         c1ctcu = w0ctcu;
         c1nrtc = w0nrtc;
         c1cbrn = w0nivc;
         c1czco = 9999999;
         c1nivt = w0nivt;
         c1nivc = w0nivc;
         c1civa = w0civa;
         if SPVCBU_GetCBUSeparado(@@ncbu : c1ivbc : c1ivsu : c1tcta : c1ncta);
         endif;

         c1fioa = SPVFEC_ObtaÑoFecha8 ( w0vdes );
         c1fiom = SPVFEC_ObtMesFecha8 ( w0vdes );
         c1fiod = SPVFEC_ObtDiaFecha8 ( w0vdes );
         c1fvoa = SPVFEC_ObtaÑoFecha8 ( w0vhas );
         c1fvom = SPVFEC_ObtMesFecha8 ( w0vhas );
         c1fvod = SPVFEC_ObtDiaFecha8 ( w0vhas );

         c1dupe = @@dupe;
         c1mar5 = @@exdu;
         c1free = @@free;
         c1strg = @@strg;
         c1niv1 = @@cade(1);
         c1niv2 = @@cade(2);
         c1niv3 = @@cade(3);
         c1niv4 = @@cade(4);
         c1niv5 = @@cade(5);
         c1niv6 = @@cade(6);
         c1niv7 = @@cade(7);
         c1niv8 = @@cade(8);
         c1niv9 = @@cade(9);

         c1wcoa = 0;
         c1mar1 = '0';
         c1mar2 = '0';
         c1mar3 = '0';
         c1mar4 = '0';
         c1cocp = '0';
         c1econ = '0';
         c1ivsi = '1';

         c1conr = *Zeros;
         c1ivr2 = *Zeros;
         c1nrrt = *Zeros;
         c1nrlo = *Zeros;
         c1nrct = *Zeros;
         c1nrln = *Zeros;
         c1xcco = *Zeros;
         h1nivt = *Zeros;
         h1nivc = *Zeros;
         h1xopr = *Zeros;
         h1copr = *Zeros;
         c1ncre = *Zeros;
         c1ffca = *Zeros;
         c1ffcm = *Zeros;
         c1ffcd = *Zeros;
         c1ccuo = *Zeros;
         c1fboa = *Zeros;
         c1fbom = *Zeros;
         c1fbod = *Zeros;
         c1cert = *Zeros;
         c1fema = *Zeros;
         c1femm = *Zeros;
         c1femd = *Zeros;
         c1prco = *Zeros;
         c1depp = *Zeros;
         c1ruta = *Zeros;
         c1nrla = *Blanks;

         c1prim = *Zeros;
         c1bpri = *Zeros;
         c1refi = *Zeros;
         c1read = *Zeros;
         c1dere = *Zeros;
         c1seri = *Zeros;
         c1seem = *Zeros;
         c1impi = *Zeros;
         c1sers = *Zeros;
         c1tssn = *Zeros;
         c1ipr1 = *Zeros;
         c1ipr2 = *Zeros;
         c1ipr3 = *Zeros;
         c1ipr4 = *Zeros;
         c1ipr5 = *Zeros;
         c1ipr6 = *Zeros;
         c1ipr7 = *Zeros;
         c1ipr8 = *Zeros;
         c1ipr9 = *Zeros;
         c1prem = *Zeros;
         c1bpre = *Zeros;

         c1user = @PsDs.CurUsr;
         c1date = udate;
         c1time = %dec(%time():*iso);

         select;
          when c1cfpg = 1;
               c1nrct = 0;
               c1cbrn = 0;
               c1cocp = '0';
               c1nrla = *blanks;
               c1nrln = 0;
               c1ivbc = 0;
               c1ivsu = 0;
               c1tcta = 0;
               c1ncta = *blanks;
               c1czco = 0;
               k1hdtc.dfnrdf = c1asen;
               k1hdtc.dfctcu = c1ctcu;
               k1hdtc.dfnrtc = c1nrtc;
               setll %kds(k1hdtc) gnhdtc;
               if not %equal;
                  dfnrdf = c1asen;
                  dfctcu = c1ctcu;
                  dfnrtc = c1nrtc;
                  dffita = *year;
                  dffitm = *month;
                  dfffta = 0;
                  dffftm = 0;
                  dfgrab = *blanks;
                  dfbloq = 'N';
                  dffbta = 0;
                  dffbtm = 0;
                  dffbtd = 0;
                  dfuser = @PsDs.CurUsr;
                  write g1hdtc;
               endif;
          when c1cfpg = 2 or c1cfpg = 3;
               c1cbrn = 0;
               c1czco = 0;
               c1cocp = '0';
               c1ctcu = 0;
               c1nrtc = 0;
               c1nrct = 0;
               c1nrla = *blanks;
               c1nrln = 0;
               k1hdcb.dfnrdf = c1asen;
               k1hdcb.dfivbc = c1ivbc;
               k1hdcb.dfivsu = c1ivsu;
               k1hdcb.dftcta = c1tcta;
               k1hdcb.dfncta = c1ncta;
               setll %kds(k1hdcb) gnhdcb;
               if not %equal;
                  dfnrdf = c1asen;
                  dfivbc = c1ivbc;
                  dfivsu = c1ivsu;
                  dftcta = c1tcta;
                  dfncta = c1ncta;
                  dfbloq = 'N';
                  dffita = *year;
                  dffitm = *month;
                  dfffta = 0;
                  dffftm = 0;
                  dfgrab = *blanks;
                  dffbta = 0;
                  dffbtm = 0;
                  dffbtd = 0;
                  dfcmoi = '00';
                  dfmb01 = *blanks;
                  dfmb02 = 'N';
                  dfncbu = %editc(w0ncbu:'X');
                  write g1hdcb;
               endif;
          when c1cfpg = 4;
               c1ctcu = 0;
               c1nrtc = 0;
               c1nrtc = 0;
               c1nrla = *blanks;
               c1nrln = 0;
               c1ivbc = 0;
               c1ivsu = 0;
               c1tcta = 0;
               c1ncta = *blanks;
         endsl;

         write p1hec1;

         actMarca ( 't@ma06' : '1' );

       endsr;

       begsr grabEc2;

         actMarca ( 't@ma07' : '9' );

         c2empr = w0empr;
         c2sucu = w0sucu;
         c2arcd = w0arcd;
         c2spol = @@spol;
         c2sspo = @@sspo;
         c2cbrn = w0nivc;
         c2czco = 9999999;
         c2mone = w0mone;
         c2nrdf = n4nrdf;
         c2cplc = n4cplc;
         c2xcco = n4xcco;
         c2xfno = n4xfno;
         c2xfnn = n4xfnn;
         c2imvi = n4imvi;
         c2bloq = n4bloq;

         if ( c2xcco = *Zeros );
           chain c2cplc set615;

           if %found ( set615 );
             c2xcco = t@xcco;
           endif;

         endif;

         c2cert = *Zeros;

         c2mar1 = *Blanks;
         c2mar2 = *Blanks;
         c2mar3 = *Blanks;
         c2mar4 = *Blanks;
         c2mar5 = *Blanks;

         c2user = @PsDs.CurUsr;
         c2date = udate;
         c2time = %dec(%time():*iso);

         write p1hec2;

         actMarca ( 't@ma07' : '1' );

       endsr;

       begsr grabEc3;

         actMarca ( 't@ma08' : '9' );

         $$endp = 'BCH';
         PAR312I ( peBase.peEmpr : peBase.peSucu : w0arcd
                 : w0spo1 : @@spol : @@sspo : $$endp : peNrpp );

         actMarca ( 't@ma08' : '1' );

       endsr;

       begsr grabEc4;

         actMarca ( 't@ma09' : '9' );

         if w0tiou = 3;
            k1hec4.c4empr = w0empr;
            k1hec4.c4sucu = w0sucu;
            k1hec4.c4arcd = w0arcd;
            k1hec4.c4spol = @@spol;
            k1hec4.c4sspo = ultEd0.d0sspo;
            chain %kds(k1hec4:5) pahec4;
            if %found;
               if PRWBIEN_copiaPoliza( peBase : peNctw : 'I' );
                 c4Ra07 = 'S';
               else;
                 c4Ra07 = 'N';
               endif;
               c4sspo = @@sspo;
               c4user = @PsDs.CurUsr;
               c4date = udate;
               c4time = %dec(%time():*iso);
               write p1hec4;
            endif;
            actMarca ( 't@ma09' : '1' );
            leavesr;
         endif;

         c4empr = w0empr;
         c4sucu = w0sucu;
         c4arcd = w0arcd;
         c4spol = @@spol;
         c4sspo = @@sspo;

         c4mar1 = '0';
         c4mar2 = '0';
         c4mar3 = '0';
         c4mar4 = '0';
         c4mar5 = '0';
         c4strg = '0';
         c4ra06 = 'N';

         c4cert = *Zeros;
         c4cobn = *Zeros;
         c4soln = *Zeros;
         c4sarc = *Zeros;
         c4ref1 = *Zeros;
         c4ref2 = *Zeros;
         c4ref3 = *Blanks;
         c4ref4 = *Blanks;

         c4user = @PsDs.CurUsr;
         c4date = udate;
         c4time = %dec(%time():*iso);

         if PRWBIEN_copiaPoliza( peBase : peNctw : 'I' );
           c4Ra07 = 'S';
         else;
           c4Ra07 = 'N';
         endif;

         write p1hec4;

         actMarca ( 't@ma09' : '1' );

       endsr;

       begsr grabEc5;

         actMarca ( 't@ma10' : '9' );

         k1y003.w3empr = peBase.peEmpr;
         k1y003.w3sucu = peBase.peSucu;
         k1y003.w3nivt = peBase.peNivt;
         k1y003.w3nivc = peBase.peNivc;
         k1y003.w3nctw = peNctw;
         k1y003.w3nase = 1;

         setll %kds ( k1y003 : 6 ) ctw003;
         reade %kds ( k1y003 : 5 ) ctw003;

         @@nord = *Zeros;

         dow not %eof ( ctw003 );

           c5empr = w0empr;
           c5sucu = w0sucu;
           c5arcd = w0arcd;
           c5spol = @@spol;
           c5sspo = @@sspo;

           @@nord += 1;
           c5nord = @@nord;

           c5cert = *Zeros;
           c5asen = w3asen;

           c5mar1 = *Blanks;
           c5mar2 = *Blanks;
           c5mar3 = *Blanks;
           c5mar4 = *Blanks;
           c5mar5 = *Blanks;
           c5strg = *Blanks;

           c5user = @PsDs.CurUsr;
           c5date = udate;
           c5time = %dec(%time():*iso);

           write p1hec5;

           reade %kds ( k1y003 : 5 ) ctw003;

         enddo;

         actMarca ( 't@ma10' : '1' );

       endsr;

       begsr grabEg3;

         actMarca ( 't@ma15' : '9' );

         k1yeg3.g3empr = peBase.peEmpr;
         k1yeg3.g3sucu = peBase.peSucu;
         k1yeg3.g3nivt = peBase.peNivt;
         k1yeg3.g3nivc = peBase.peNivc;
         k1yeg3.g3nctw = peNctw;

         setll %kds ( k1yeg3 : 5 ) ctweg3;
         reade %kds ( k1yeg3 : 5 ) ctweg3;

         dow not %eof ( ctweg3 );

           g3empr = w0empr;
           g3sucu = w0sucu;
           g3arcd = w0arcd;
           g3spol = @@spol;
           g3sspo = @@sspo;
           g3rama = g3rama;
           g3arse = g3arse;
           g3oper = @@oper;
           g3suop = @@sspo;
           g3rpro = g3rpro;
           g3cert = *Zeros;
           g3poli = *Zeros;
           g3mone = w0mone;
           g3come = w0come;
           g3suas = g3suas;
           g3saca = *Zeros;
           g3sacr = *Zeros;
           g3sast = g3sast;
           g3prim = g3prim;
           g3bpri = g3bpri;
           g3refi = g3refi;
           g3read = g3read;
           g3dere = g3dere;
           g3seri = g3seri;
           g3seem = g3seem;
           g3ipr6 = g3ipr6;
           g3ipr7 = g3ipr7;
           g3ipr8 = g3ipr8;
           g3prem = g3prem;
           g3mar1 = g3mar1;
           g3mar2 = g3mar2;
           g3mar3 = g3mar3;
           g3mar4 = g3mar4;
           g3mar5 = g3mar5;
           g3strg = g3strg;
           g3ipr1 = g3ipr1;
           g3ipr3 = g3ipr3;
           g3ipr4 = g3ipr4;
           g3sefr = g3sefr;
           g3sefe = g3sefe;

           g3user = @PsDs.CurUsr;
           g3date = udate;
           g3time = %dec(%time():*iso);

           write p1heg3;

           reade %kds ( k1yeg3 : 5 ) ctweg3;

         enddo;

         actMarca ( 't@ma15' : '1' );

       endsr;

       begsr grabEd0;

         actMarca ( 't@ma20' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctw001;
         reade %kds ( k1y001 : 5 ) ctw001;

         dow not %eof ( ctw001 );

             // -------------------------------------
             // Registro de condiciones comerciales
             // -------------------------------------
             k2y001.wcempr = w1empr;
             k2y001.wcsucu = w1sucu;
             k2y001.wcnivt = w1nivt;
             k2y001.wcnivc = w1nivc;
             k2y001.wcrama = w1rama;
             k2y001.wcnctw = w1nctw;
             chain %kds(k2y001) ctw001c condCom;
             if not %found;
                condCom.wcxrea = 0;
                condCom.wcread = 0;
             endif;

           // Obtengo Periodo en Curso
           if ( w0tiou = 3 and w0stos = 1 );

             k1yed0.d0empr = w0empr;
             k1yed0.d0sucu = w0sucu;
             k1yed0.d0arcd = w0arcd;
             k1yed0.d0spol = @@spol;
             k1yed0.d0sspo = @@sspo;
             k1yed0.d0rama = w1rama;
             k1yed0.d0arse = 1;

             setgt %kds ( k1yed0 : 7 ) pahed0;
             reade %kds ( k1yed0 : 7 ) pahed0;

             @@pecu = d0pecu + 1;

           else;

             if w0tiou = 1 or w0tiou = 2;
                @@pecu = 1;
              else;
                @@pecu = ultEd0.d0pecu;
             endif;

           endif;

           d0empr = w0empr;
           d0sucu = w0sucu;
           d0arcd = w0arcd;
           d0spol = @@spol;
           d0sspo = @@sspo;
           d0rama = w1rama;
           d0arse = 1;
           d0oper = @@oper;
           d0suop = @@sspo;
           d0cert = *Zeros;
           d0poli = *Zeros;
           d0endo = *Zeros;
           d0mone = w0mone;
           d0come = w0come;
           d0tiou = w0tiou;
           d0stou = w0stou;
           d0stos = @@stos;
           d0plac = getPlanC();

           d0fioa = SPVFEC_ObtaÑoFecha8 ( w0vdes );
           d0fiom = SPVFEC_ObtMesFecha8 ( w0vdes );
           d0fiod = SPVFEC_ObtDiaFecha8 ( w0vdes );
           d0fvoa = SPVFEC_ObtaÑoFecha8 ( w0vhas );
           d0fvom = SPVFEC_ObtMesFecha8 ( w0vhas );
           d0fvod = SPVFEC_ObtDiaFecha8 ( w0vhas );
           d0fhfa = SPVFEC_ObtaÑoFecha8 ( @@hafa );
           d0fhfm = SPVFEC_ObtMesFecha8 ( @@hafa );
           d0fhfd = SPVFEC_ObtDiaFecha8 ( @@hafa );
           d0fvaa = SPVFEC_ObtaÑoFecha8 ( @@anua );
           d0fvam = SPVFEC_ObtMesFecha8 ( @@anua );
           d0fvad = SPVFEC_ObtDiaFecha8 ( @@anua );

           d0mar5 = @@exdu;
           d0dup1 = @@dupe;
           d0dup2 = @@dupf;
           d0ncoc = @@ncoc;
           d0ciap = @@ciap;
           d0pecu = @@pecu;

           d0part = 100;
           d0strg = '0';
           d0copc = '0';
           d0mar1 = '0';
           d0mar2 = '0';
           d0mar3 = '0';
           d0cpar = '1';
           d0mar4 = 'N';

           d0copg = *Zeros;
           d0gpil = *Zeros;
           d0conr = *Zeros;
           d0sacr = *Zeros;
           d0bpri = *Zeros;
           d0ipr9 = *Zeros;
           d0bpre = *Zeros;
           d0prco = *Zeros;
           d0depp = *Zeros;
           d0bpip = *Zeros;
           d0bpep = *Zeros;
           d0saca = *Zeros;

           d0copg = *Zeros;
           d0gpil = *Zeros;

           d0xrea = condCom.wcxrea;
           d0read = condCom.wcread;
           d0dere = w1dere;
           d0xref = w1xref;
           d0refi = w1refi;
           d0pimi = w1pimi;
           d0psso = w1psso;
           d0pssn = w1pssn;
           d0pivi = w1pivi;
           d0pivn = w1pivn;
           d0pivr = w1pivr;

           d0seri = w1seri;
           d0seem = w1seem;
           d0impi = w1impi;
           d0tssn = w1tssn;
           d0sers = w1sers;
           d0ipr1 = w1ipr1;
           d0ipr2 = w1ipr2;
           d0ipr3 = w1ipr3;
           d0ipr4 = w1ipr4;
           d0ipr5 = w1ipr5;
           d0ipr6 = w1ipr6;
           d0ipr7 = w1ipr7;
           d0ipr8 = w1ipr8;
           d0ipr9 = w1ipr9;

           d0suas = COWGRAI_getSumaAseguradaRamaArse ( peBase : peNctw
                                                     : w1rama : 1 );

           d0sast = COWGRAI_getSumaAsSiniRamaArse ( peBase : peNctw
                                                  : w1rama : 1 );

           d0prim = COWGRAI_getPrimaRamaArse ( peBase : peNctw
                                             : w1rama : 1 );

           d0prem = w1prem;

           d0siva = *zeros;

           d0poan = *Zeros;
           d0ponu = *Zeros;

           d0user = @PsDs.CurUsr;
           d0date = udate;
           d0time = %dec(%time():*iso);
           d0vacc = w1vacc;

           write p1hed0;

           reade %kds ( k1y001 : 5 ) ctw001;

         enddo;

         actMarca ( 't@ma20' : '1' );

       endsr;

       begsr grabEd1;

         actMarca ( 't@ma21' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctw001;
         reade %kds ( k1y001 : 5 ) ctw001;

         dow not %eof ( ctw001 );

           d1empr = w0empr;
           d1sucu = w0sucu;
           d1arcd = w0arcd;
           d1spol = @@spol;
           d1sspo = @@sspo;
           d1rama = w1rama;
           d1arse = 1;
           d1oper = @@oper;
           d1suop = @@sspo;
           d1plac = getPlanC();
           d1cert = *Zeros;
           d1poli = *Zeros;
           d1endo = *Zeros;
           d1mone = w0mone;
           d1come = w0come;
           d1copr = *Zeros;
           d1ccob = *Zeros;
           d1cfno = *Zeros;

           k1y611.t@plac = d1plac;
           k1y611.t@mone = w0mone;

           chain %kds( k1y611 : 2 ) set611;

           if ( @@comi = '1' );

             k1y6118.t@empr = w0empr;
             k1y6118.t@sucu = w0sucu;
             k1y6118.t@nivt = w0nivt;
             k1y6118.t@nivc = w0nivc;
             k1y6118.t@rama = w1rama;

             chain %kds( k1y6118 : 5 ) set6118;

           endif;

           d1xmes = t@xmes;
           d1xopr = t@xopr;
           d1xcco = t@xcco;
           d1xfno = t@xfno;
           d1xfnn = t@xfnn;
           d1cfnn = t@cfnn;
           d1bas1 = t@bas1;
           d1bas2 = t@bas2;
           d1bas3 = t@bas3;
           d1bas4 = t@bas4;
           d1fac1 = t@fac1;
           d1fac2 = t@fac2;
           d1fac3 = t@fac3;
           d1fac4 = t@fac4;
           d1fac5 = t@fac5;
           d1fac6 = t@fac6;
           d1fac7 = t@fac7;
           d1fac8 = t@fac8;
           d1fac9 = t@fac9;
           d1pdn1 = t@pdn1;
           d1pdn2 = t@pdn2;
           d1pdn3 = t@pdn3;
           d1pdn4 = t@pdn4;
           d1pdn5 = t@pdn5;
           d1pdn6 = t@pdn6;
           d1pdn7 = t@pdn7;
           d1pdn8 = t@pdn8;
           d1pdn9 = t@pdn9;
           d1pdc1 = t@pdc1;
           d1pdc2 = t@pdc2;
           d1pdc3 = t@pdc3;
           d1pdc4 = t@pdc4;
           d1pdc5 = t@pdc5;
           d1pdc6 = t@pdc6;
           d1pdc7 = t@pdc7;
           d1pdc8 = t@pdc8;
           d1pdc9 = t@pdc9;
           d1pdf1 = t@pdf1;
           d1pdf2 = t@pdf2;
           d1pdf3 = t@pdf3;
           d1pdf4 = t@pdf4;
           d1pdf5 = t@pdf5;
           d1pdf6 = t@pdf6;
           d1pdf7 = t@pdf7;
           d1pdf8 = t@pdf8;
           d1pdf9 = t@pdf9;
           d1pdg1 = t@pdg1;
           d1pdg2 = t@pdg2;
           d1pdg3 = t@pdg3;
           d1pdg4 = t@pdg4;
           d1pdg5 = t@pdg5;
           d1pdg6 = t@pdg6;
           d1pdg7 = t@pdg7;
           d1pdg8 = t@pdg8;
           d1pdg9 = t@pdg9;
           d1ndc1 = t@ndc1;
           d1ndc2 = t@ndc2;
           d1ndc3 = t@ndc3;
           d1ndc4 = t@ndc4;
           d1ndc5 = t@ndc5;
           d1ndc6 = t@ndc6;
           d1ndc7 = t@ndc7;
           d1ndc8 = t@ndc8;
           d1ndc9 = t@ndc9;
           d1tarc = t@tarc;
           d1tair = t@tair;
           d1scta = t@scta;
           d1prec = t@prec;

           k1y606.t@arcd = w0arcd;
           k1y606.t@rama = w1rama;
           k1y606.t@arse = 1;
           k1y606.t@empr = w0empr;
           k1y606.t@sucu = w0sucu;
           k1y606.t@ncoc = @@ncoc;
           chain %kds(k1y606) set606;
           if %found (set606);
             d1bbrk = t@bbrk;
             d1xbrk = t@xbrk;
           else;
             d1bbrk = *Blanks;
             d1xbrk = *Zeros;
           endif;

           select;
             when d1bbrk = '1';
               d1cbrk = ((d1xbrk * (d0prim - d0bpri)) / 100);
             when d1bbrk = '2';
               d1cbrk = ((d1xbrk * d0prem) / 100);
             other;
               d1cbrk = *Zeros;
           endsl;

           d1mar1 = '0';
           d1mar2 = '0';
           d1mar3 = '0';
           d1mar4 = '0';
           d1mar5 = '0';
           d1strg = '0';

           d1user = @PsDs.CurUsr;
           d1date = udate;
           d1time = %dec(%time():*iso);

           write p1hed1;

           reade %kds ( k1y001 : 5 ) ctw001;

         enddo;

         actMarca ( 't@ma21' : '1' );

       endsr;

       begsr grabEd2;

        if w0tiou <> 3;
           leavesr;
        endif;

        @@tpcd = *blanks;
        if (w0stou = 4 and w0stos = 7);
           @@tpcd = 'CA';
        endif;
        if (w0stou = 1 and w0stos = 5);
           @@tpcd = '35';
        endif;

        if @@tpcd = *blanks;
           leavesr;
        endif;

        k1y001.w1empr = peBase.peEmpr;
        k1y001.w1sucu = peBase.peSucu;
        k1y001.w1nivt = peBase.peNivt;
        k1y001.w1nivc = peBase.peNivc;
        k1y001.w1nctw = peNctw;

        setll %kds ( k1y001 : 5 ) ctw001;
        reade %kds ( k1y001 : 5 ) ctw001;
        dow not %eof ( ctw001 );
            chain w1rama set001;
            if %found;
               if t@rame = 4;
                  d2nrre = 0;
                  k1t124.txrama = w1rama;
                  k1t124.txtpcd = @@tpcd;
                  setll %kds(k1t124:2) set124;
                  reade %kds(k1t124:2) set124;
                  dow not %eof;
                      d2empr = w1empr;
                      d2sucu = w1sucu;
                      d2arcd = w0arcd;
                      d2spol = w0spol;
                      d2sspo = @@sspo;
                      d2rama = w1rama;
                      d2arse = 1;
                      d2oper = @@oper;
                      d2suop = @@sspo;
                      d2nrre += 1;
                      d2retx = txtpds;
                      d2cert = 0;
                      d2poli = 0;
                      d2marp = '0';
                      d2strg = '0';
                      d2user = @PsDs.CurUsr;
                      d2time = %dec(%time():*iso);
                      d2date = %dec(%date():*ymd);
                      write p1hed2;
                   reade %kds(k1t124:2) set124;
                  enddo;
               endif;
            endif;
         reade %kds ( k1y001 : 5 ) ctw001;
        enddo;

       endsr;

       begsr grabEd3;

           PAR310X3( @@empr : @@fema : @@femm : @@femd );
           hoy = (@@fema * 10000)
               + (@@femm *   100)
               +  @@femd;
           peTien = *off;
           peValo = 0;
           peTval = *blank;
           peFacc = *blank;
           peDias = 0;
           peDere = 0;
          if @@cade(6) <> 0;
             SPEXCODE( w0empr
                     : w0sucu
                     : 6
                     : @@cade(6)
                     : w1rama
                     : w0tiou
                     : w0stou
                     : hoy
                     : *blanks
                     : peTien
                     : peValo
                     : peTval
                     : peFacc
                     : peDias
                     : peDere  );
          endif;

           pd ( 01 ) = t@pdn1;
           pd ( 02 ) = t@pdn2;
           pd ( 03 ) = t@pdn3;
           pd ( 04 ) = t@pdn4;
           pd ( 05 ) = t@pdn5;
           pd ( 06 ) = t@pdn6;
           pd ( 07 ) = t@pdn7;
           pd ( 08 ) = t@pdn8;
           pd ( 09 ) = t@pdn9;

           pc ( 01 ) = t@pdc1;
           pc ( 02 ) = t@pdc2;
           pc ( 03 ) = t@pdc3;
           pc ( 04 ) = t@pdc4;
           pc ( 05 ) = t@pdc5;
           pc ( 06 ) = t@pdc6;
           pc ( 07 ) = t@pdc7;
           pc ( 08 ) = t@pdc8;
           pc ( 09 ) = t@pdc9;

           pf ( 01 ) = t@pdf1;
           pf ( 02 ) = t@pdf2;
           pf ( 03 ) = t@pdf3;
           pf ( 04 ) = t@pdf4;
           pf ( 05 ) = t@pdf5;
           pf ( 06 ) = t@pdf6;
           pf ( 07 ) = t@pdf7;
           pf ( 08 ) = t@pdf8;
           pf ( 09 ) = t@pdf9;

           pg ( 01 ) = t@pdg1;
           pg ( 02 ) = t@pdg2;
           pg ( 03 ) = t@pdg3;
           pg ( 04 ) = t@pdg4;
           pg ( 05 ) = t@pdg5;
           pg ( 06 ) = t@pdg6;
           pg ( 07 ) = t@pdg7;
           pg ( 08 ) = t@pdg8;
           pg ( 09 ) = t@pdg9;

           fac ( 01 ) = t@fac1;
           fac ( 02 ) = t@fac2;
           fac ( 03 ) = t@fac3;
           fac ( 04 ) = t@fac4;
           fac ( 05 ) = t@fac5;
           fac ( 06 ) = t@fac6;
           fac ( 07 ) = t@fac7;
           fac ( 08 ) = t@fac8;
           fac ( 09 ) = t@fac9;

           @@secu = *Zeros;

           for x = 1 to 8;

             if @@cade( x ) <> *Zeros;

               k2yeg3.g3empr = w0empr;
               k2yeg3.g3sucu = w0sucu;
               k2yeg3.g3arcd = w0arcd;
               k2yeg3.g3spol = @@spol;
               k2yeg3.g3sspo = @@sspo;
               k2yeg3.g3rama = w1rama;
               k2yeg3.g3arse = 1;
               k2yeg3.g3oper = @@oper;
               k2yeg3.g3suop = @@sspo;

               setll %kds( k2yeg3 : 9 ) paheg3;
               reade %kds( k2yeg3 : 9 ) paheg3;

               dow not %eof ( paheg3 );

                 d3empr = w0empr;
                 d3sucu = w0sucu;
                 d3arcd = w0arcd;
                 d3spol = @@spol;
                 d3sspo = @@sspo;
                 d3rama = w1rama;
                 d3arse = 1;
                 d3oper = @@oper;
                 d3suop = @@sspo;
                 d3nivt = x;
                 d3nivc = @@cade( x );
                 d3rpro = g3rpro;
                 d3mone = w0mone;
                 d3cert = *Zeros;
                 d3poli = *Zeros;
                 d3plac = getPlanC();
                 d3copc = '0';
                 d3ncoc = @@ncoc;

                 k1yni2.n2empr = w0empr;
                 k1yni2.n2sucu = w0sucu;
                 k1yni2.n2nivt = x;
                 k1yni2.n2nivc = @@cade( x );
                 chain %kds( k1yni2 ) sehni2;

                 if %found ( sehni2 );

                   d3inta = n2inta;
                   d3inna = n2inna;

                 endif;

                 if d3inta = 4;

                   @@secu += 1;
                   d3secu = @@secu;

                  else;

                   d3secu = 1;

                 endif;

                 d3facc = fac( x );

                 d3xopr = ((pd ( x ) / 100) * t@xopr);
                 d3xcco = ((pc ( x ) / 100) * t@xcco);
                 d3xfno = ((pf ( x ) / 100) * t@xfno);
                 d3xfnn = ((pg ( x ) / 100) * t@cfnn);
                 d3cfnn = ((pg ( x ) / 100) * t@copr);
                 select;
                   when x = 1;
                     d3xopr = condCom.wcxopr;
                   when x = 6;
                     if peTien;
                        d3facc = peFacc;
                        tot_prim = g3prim - g3bpri;
                        aux29  = ( peValo / tot_prim ) * 100;
                        d3xopr = %dech(aux29:5:2);
                     endif;
                 endsl;

                 select;
                   when t@bas1 = '1';
                     aux29  = (((g3prim - g3bpri) * d3xopr ) / 100);
                     d3copr = %dech(aux29:15:2);
                   when t@bas1 = '2';
                     d3copr = ((g3prem * d3xopr) / 100);
                   when t@bas1 = '3';
                     d3copr = ((g3dere * d3xopr) / 100);
                   when t@bas1 = '4';
                     d3copr = ((g3sast * d3xopr) / 100);
                   when t@bas1 = '5';
                     d3copr = *Zeros;
                   when t@bas1 = '6';
                     d3copr = (((g3prim - g3bpri + g3read) * d3xopr) / 100);
                   when t@bas1 = '7';
                     d3copr = (((g3prim - g3bpri + g3read + g3refi)
                                 * d3xopr) / 100);
                   when t@bas1 = '8';
                     d3copr = (((g3prim - g3bpri + g3read + g3refi + g3dere)
                                 * d3xopr) / 100);
                   when t@bas1 = '9';
                     d3copr = ((g3read * d3xopr) / 100);
                   when t@bas1 = 'A';
                     d3copr = ((g3refi * d3xopr) / 100);
                   when t@bas1 = 'B';
                     d3copr = (((g3prim - g3bpri + g3refi) * d3xopr) / 100);
                   when t@bas1 = 'C';
                     d3copr = (((g3read + g3refi) * d3xopr) / 100);
                 endsl;

                 select;
                   when t@bas2 = '1';
                     d3ccob = (((g3prim - g3bpri) * d3xcco ) / 100);
                   when t@bas2 = '2';
                     d3ccob = ((g3prem * d3xcco) / 100);
                   when t@bas2 = '3';
                     d3ccob = ((g3dere * d3xcco) / 100);
                   when t@bas2 = '4';
                     d3ccob = *Zeros;
                   when t@bas2 = '5';
                     d3ccob = *Zeros;
                   when t@bas2 = '6';
                     d3ccob = (((g3prim - g3bpri + g3read) * d3xcco) / 100);
                   when t@bas2 = '7';
                     d3ccob = (((g3prim - g3bpri + g3read + g3refi)
                                 * d3xcco) / 100);
                   when t@bas2 = '8';
                     d3ccob = (((g3prim - g3bpri + g3read + g3refi + g3dere)
                                 * d3xcco) / 100);
                   when t@bas2 = '9';
                     d3ccob = ((g3read * d3xcco) / 100);
                   when t@bas2 = 'A';
                     d3ccob = ((g3refi * d3xcco) / 100);
                   when t@bas2 = 'B';
                     d3ccob = (((g3prim - g3bpri + g3refi) * d3xcco) / 100);
                   when t@bas2 = 'C';
                     d3ccob = (((g3read + g3refi) * d3xcco) / 100);
                 endsl;

                 select;
                   when t@bas3 = '1';
                     d3cfno = (((g3prim - g3bpri) * d3xfno ) / 100);
                   when t@bas3 = '2';
                     d3cfno = ((g3prem * d3xfno) / 100);
                   when t@bas3 = '3';
                     d3cfno = ((g3dere * d3xfno) / 100);
                   when t@bas3 = '4';
                     d3cfno = *Zeros;
                   when t@bas3 = '5';
                     d3cfno = *Zeros;
                   when t@bas3 = '6';
                     d3cfno = (((g3prim - g3bpri + g3read) * d3xfno) / 100);
                   when t@bas3 = '7';
                     d3cfno = (((g3prim - g3bpri + g3read + g3refi)
                                 * d3xfno) / 100);
                   when t@bas3 = '8';
                     d3cfno = (((g3prim - g3bpri + g3read + g3refi + g3dere)
                                 * d3xfno) / 100);
                   when t@bas3 = '9';
                     d3cfno = ((g3read * d3xfno) / 100);
                   when t@bas3 = 'A';
                     d3cfno = ((g3refi * d3xfno) / 100);
                   when t@bas3 = 'B';
                     d3cfno = (((g3prim - g3bpri + g3refi) * d3xfno) / 100);
                   when t@bas3 = 'C';
                     d3cfno = (((g3read + g3refi) * d3xfno) / 100);
                 endsl;

                 select;
                   when t@bas4 = '1';
                     d3cfnn = (((g3prim - g3bpri) * d3xfnn ) / 100);
                   when t@bas4 = '2';
                     d3cfnn = ((g3prem * d3xfnn) / 100);
                   when t@bas4 = '3';
                     d3cfnn = ((g3dere * d3xfnn) / 100);
                   when t@bas4 = '4';
                     d3cfnn = *Zeros;
                   when t@bas4 = '5';
                     d3cfnn = *Zeros;
                   when t@bas4 = '6';
                     d3cfnn = (((g3prim - g3bpri + g3read) * d3xfnn) / 100);
                   when t@bas4 = '7';
                     d3cfnn = (((g3prim - g3bpri + g3read + g3refi)
                                 * d3xfnn) / 100);
                   when t@bas4 = '8';
                     d3cfnn = (((g3prim - g3bpri + g3read + g3refi + g3dere)
                                 * d3xfnn) / 100);
                   when t@bas4 = '9';
                     d3cfnn = ((g3read * d3xfnn) / 100);
                   when t@bas4 = 'A';
                     d3cfnn = ((g3refi * d3xfnn) / 100);
                   when t@bas4 = 'B';
                     d3cfnn = (((g3prim - g3bpri + g3refi) * d3xfnn) / 100);
                   when t@bas4 = 'C';
                     d3cfnn = (((g3read + g3refi) * d3xfnn) / 100);
                 endsl;

                 if d0prem = *Zeros;

                   if d3copr <> *Zeros or d3ccob <> *Zeros or
                      d3cfno <> *Zeros or d3cfnn <> *Zeros;

                     if d3facc <> 'A';

                       d3mar1 = 'A';

                     endif;

                   endif;

                 endif;

                 if n2mar1 = '2' and d3mar1 <> 'A'  and d3facc <> 'A';

                     d3mar1 = 'A';
                     @@forz = '0';

                 endif;

                 d3mar2 = n2mar1;

                 if @@forz = 'E' or @@forz = 'A';

                   d3facc = @@forz;
                   d3mar2 = '0';

                 endif;

                 d3mar1 = '0';
                 d3mar3 = '0';
                 d3mar4 = '0';
                 d3mar5 = '0';
                 d3strg = '0';

                 d3user = @PsDs.CurUsr;
                 d3date = udate;
                 d3time = %dec(%time():*iso);

                 write p1hed3;

                 reade %kds( k2yeg3 : 9 ) paheg3;

               enddo;

             endif;

           endfor;

       endsr;

       begsr grabEd4;

         actMarca ( 't@ma24' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctw001;
         reade %kds ( k1y001 : 5 ) ctw001;

         dow not %eof ( ctw001 );

           d4empr = w0empr;
           d4sucu = w0sucu;
           d4arcd = w0arcd;
           d4spol = @@spol;
           d4sspo = @@sspo;
           d4rama = w1rama;
           d4arse = 1;
           d4oper = @@oper;
           d4suop = @@sspo;

           d4marp = '0';
           d4strg = '0';
           d4cert = *Zeros;
           d4poli = *Zeros;

           clear peClau;
           if getClausulas( peBase
                          : w0arcd
                          : d4rama
                          : d4arse
                          : peNctw
                          : w0mone
                          : peClau  );

             d4ca01 = peClau.ca01;
             d4ca02 = peClau.ca02;
             d4ca03 = peClau.ca03;
             d4ca04 = peClau.ca04;
             d4ca05 = peClau.ca05;
             d4ca06 = peClau.ca06;
             d4ca07 = peClau.ca07;
             d4ca08 = peClau.ca08;
             d4ca09 = peClau.ca09;
             d4ca10 = peClau.ca10;
             d4ca11 = peClau.ca11;
             d4ca12 = peClau.ca12;
             d4ca13 = peClau.ca13;
             d4ca14 = peClau.ca14;
             d4ca15 = peClau.ca15;
             d4ca16 = peClau.ca16;
             d4ca17 = peClau.ca17;
             d4ca18 = peClau.ca18;
             d4ca19 = peClau.ca19;
             d4ca20 = peClau.ca20;
             d4ca21 = peClau.ca21;
             d4ca22 = peClau.ca22;
             d4ca23 = peClau.ca23;
             d4ca24 = peClau.ca24;
             d4ca25 = peClau.ca25;
             d4ca26 = peClau.ca26;
             d4ca27 = peClau.ca27;
             d4ca28 = peClau.ca28;
             d4ca29 = peClau.ca29;
             d4ca30 = peClau.ca30;

             d4user = @PsDs.CurUsr;
             d4date = udate;
             d4time = %dec(%time():*iso);

             write p1hed4;
           endif;

           reade %kds ( k1y001 : 5 ) ctw001;

         enddo;

         actMarca ( 't@ma24' : '1' );

       endsr;

       begsr grabEd5;

         actMarca ( 't@ma25' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctw001;
         reade %kds ( k1y001 : 5 ) ctw001;

         dow not %eof ( ctw001 );

           d5empr = w0empr;
           d5sucu = w0sucu;
           d5arcd = w0arcd;
           d5spol = @@spol;
           d5sspo = @@sspo;
           d5rama = w1rama;
           d5arse = 1;
           d5oper = @@oper;
           d5suop = @@sspo;

           d5marp = '0';
           d5strg = '0';
           d5cert = *Zeros;
           d5poli = *Zeros;

           clear peAnex;
           if getAnexos( peBase
                       : w0arcd
                       : d4rama
                       : d4arse
                       : peNctw
                       : w0mone
                       : peAnex  );

             d5an01 = peAnex.an01;
             d5an02 = peAnex.an02;
             d5an03 = peAnex.an03;
             d5an04 = peAnex.an04;
             d5an05 = peAnex.an05;
             d5an06 = peAnex.an06;
             d5an07 = peAnex.an07;
             d5an08 = peAnex.an08;
             d5an09 = peAnex.an09;
             d5an10 = peAnex.an10;
             d5an11 = peAnex.an11;
             d5an12 = peAnex.an12;
             d5an13 = peAnex.an13;
             d5an14 = peAnex.an14;
             d5an15 = peAnex.an15;
             d5an16 = peAnex.an16;
             d5an17 = peAnex.an17;
             d5an18 = peAnex.an18;
             d5an19 = peAnex.an19;
             d5an20 = peAnex.an20;
             d5an21 = peAnex.an21;
             d5an22 = peAnex.an22;
             d5an23 = peAnex.an23;
             d5an24 = peAnex.an24;
             d5an25 = peAnex.an25;
             d5an26 = peAnex.an26;
             d5an27 = peAnex.an27;
             d5an28 = peAnex.an28;
             d5an29 = peAnex.an29;
             d5an30 = peAnex.an30;

             d5user = @PsDs.CurUsr;
             d5date = udate;
             d5time = %dec(%time():*iso);

             write p1hed5;

           endif;

           reade %kds ( k1y001 : 5 ) ctw001;

         enddo;

         actMarca ( 't@ma25' : '1' );

       endsr;

       begsr grabEt0;

         actMarca ( 't@ma30' : '9' );

         k1yet0.t0empr = peBase.peEmpr;
         k1yet0.t0sucu = peBase.peSucu;
         k1yet0.t0nivt = peBase.peNivt;
         k1yet0.t0nivc = peBase.peNivc;
         k1yet0.t0nctw = peNctw;

         setll %kds ( k1yet0 : 5 ) ctwet0;
         reade %kds ( k1yet0 : 5 ) ctwet0;

         dow not %eof ( ctwet0 );

           t0empr = w0empr;
           t0sucu = w0sucu;
           t0arcd = w0arcd;
           t0spol = @@spol;
           t0sspo = @@sspo;
           t0rama = t0rama;
           t0arse = 1;
           t0oper = @@oper;
           t0suop = @@sspo;

           t0vhmc = t0vhmc;
           t0vhmo = t0vhmo;
           t0vhcs = t0vhcs;
           t0vhcr = t0vhcr;
           t0vhaÑ = t0vhan;
           t0vhni = t0vhni;
           t0moto = %xlate(min:may:t0moto);
           t0chas = %xlate(min:may:t0chas);
           t0vhca = t0vhca;
           t0vhv1 = t0vhv1;
           t0vhv2 = t0vhv2;
           t0vhct = t0vhct;
           t0vhuv = t0vhuv;
           t0vhvu = t0vhvu;
           t0claj = t0claj;
           t0rebr = 0;
           t0scta = t0scta;
           t0mar4 = '0';
           t0ctre = t0ctre;
           t0ruta = t0ruta;
           t0mtdf = t0mtdf;
           t0tmat = t0tmat;
           t0nmat = %xlate(min:may:t0nmat);
           t0vhde = t0vhde;
           t0rgnc = t0rgnc;

           t0cert = *Zeros;
           t0poli = *Zeros;
           t0rdep = *Zeros;
           t0rloc = *Zeros;
           t0taaj = *Zeros;
           t0patn = *Zeros;
           t0pann = *Zeros;

           t0patl = *Blanks;
           t0gbco = *Blanks;

           t0esco = '0';

           t0coca = 1;
           t0corc = 1;

           if t0rgnc = *Zeros;
             t0mar6 = *Blanks;
           else;
             if SPVVEH_getValGnc ( t0empr : t0sucu ) = t0rgnc;
               t0mar6 = 'T';
             else;
               t0mar6 = 'M';
             endif;
           endif;

           t0mar0 = *Blanks;
           t0mar2 = '0';
           t0mar3 = '0';
           t0mar5 = '0';
           t0mar7 = *Blanks;
           t0mar8 = *Blanks;
           t0mar9 = *Blanks;
           t0strg = '0';

           k1yloc.locopo = t0copo;
           k1yloc.locops = t0cops;
           chain %kds( k1yloc ) gntloc;

           chain loproc gntpro;

           t0rpro = prrpro;

           k1yetc.t0empr = peBase.peEmpr;
           k1yetc.t0sucu = peBase.peSucu;
           k1yetc.t0nivt = peBase.peNivt;
           k1yetc.t0nivc = peBase.peNivc;
           k1yetc.t0nctw = peNctw;
           k1yetc.t0rama = t0rama;
           k1yetc.t0arse = t0arse;
           k1yetc.t0poco = t0poco;

           chain %kds ( k1yetc : 8 ) ctwetc01;

           t0cobl = t0cobl;
           t0prrc = t0prrc;
           t0prac = t0prac;
           t0prin = t0prin;
           t0prro = t0prro;
           t0pacc = t0pacc;
           t0pacc = t0pacc;
           t0prsf = t0prsf;
           t0prce = t0prce;
           t0prap = t0prap;
           t0ifra = t0ifra;

           t0user = @PsDs.CurUsr;
           t0date = udate;
           t0time = %dec(%time():*iso);

           PAR310X3( t0empr : @@fema : @@femm : @@femd );
           hoy = (@@fema * 10000)
               + (@@femm *   100)
               +  @@femd;
           COWVEH_getTablaRC ( t0ctre
                             : t0scta
                             : w0mone
                             : t0mgnc
                             : t0vhni
                             : t0vhca
                             : t0vhv1
                             : t0vhv2
                             : hoy
                             : t0mtdf
                             : t0tarc
                             : t0tair );

           t0poco = getPoco( t0poco : arrPoco );
           arrNmer(t0poco) = t0nmer;

           // Obtengo Valor 0km
           if ( t0vhaÑ <> *Zeros );

             k1y206.t@vhmc = t0vhmc;
             k1y206.t@vhmo = t0vhmo;
             k1y206.t@vhcs = t0vhcs;
             k1y206.t@vhcr = t0vhcr;

             chain %kds ( k1y206 ) set206;

             if %found ( set206 );

               t0vh0k = t@vh0k;

             else;

               t0vh0k = *Zeros;

             endif;

           else;
           endif;

           if t0cobl = 'A';
              t0vh0k = 0;
           endif;

           if ( t0cras <> *Zeros );

             @@cras = %char ( t0cras );

           else;

             @@cras = *Blanks;

           endif;

           if ( t0m0km = 'S' );

             @@m0km = '1';

           else;

             @@m0km = '0';

           endif;

           @@m0km2a = '0';

           if t0ma05 = '1';

             @@m0km2a = '1';

           endif;

           t0cfas = 'M';
           PAR313F ( t0rama
                   : t0vhmc
                   : t0vhmo
                   : t0vhcs
                   : t0cobl
                   : t0vhca
                   : t0vhv1
                   : t0vhv2
                   : t0claj
                   : t0rebr
                   : t0lrce
                   : t0saap
                   : t0cfas
                   : t0acrc
                   : w0mone
                   : @@dupf
                   : @@cero
                   : t0mar1
                   : t0gbco
                   : t0scta
                   : @@cras
                   : @@m0km
                   : w0tiou
                   : w0stou
                   : t0vhct
                   : t0vhvu
                   : @@m0km2a
                   : cl
                   : an );

           PAR313F1 ( t0rama
                    : t0arcd
                    : t0spol
                    : t0cobl
                    : t0vhaÑ
                    : t0vhvu
                    : w0tiou
                    : w0stou
                    : cl
                    : an );

           t0ca01 = cl(001);
           t0ca02 = cl(002);
           t0ca03 = cl(003);
           t0ca04 = cl(004);
           t0ca05 = cl(005);
           t0ca06 = cl(006);
           t0ca07 = cl(007);
           t0ca08 = cl(008);
           t0ca09 = cl(009);
           t0ca10 = cl(010);
           t0ca11 = cl(011);
           t0ca12 = cl(012);
           t0ca13 = cl(013);
           t0ca14 = cl(014);
           t0ca15 = cl(015);
           t0ca16 = cl(016);
           t0ca17 = cl(017);
           t0ca18 = cl(018);
           t0ca19 = cl(019);
           t0ca20 = cl(020);
           t0ca21 = cl(021);
           t0ca22 = cl(022);
           t0ca23 = cl(023);
           t0ca24 = cl(024);
           t0ca25 = cl(025);
           t0ca26 = cl(026);
           t0ca27 = cl(027);
           t0ca28 = cl(028);
           t0ca29 = cl(029);
           t0ca30 = cl(030);

           t0an01 = an(001);
           t0an02 = an(002);
           t0an03 = an(003);
           t0an04 = an(004);
           t0an05 = an(005);
           t0an06 = an(006);
           t0an07 = an(007);
           t0an08 = an(008);
           t0an09 = an(009);
           t0an10 = an(010);
           t0an11 = an(011);
           t0an12 = an(012);
           t0an13 = an(013);
           t0an14 = an(014);
           t0an15 = an(015);
           t0an16 = an(016);
           t0an17 = an(017);
           t0an18 = an(018);
           t0an19 = an(019);
           t0an20 = an(020);
           t0an21 = an(021);
           t0an22 = an(022);
           t0an23 = an(023);
           t0an24 = an(024);
           t0an25 = an(025);
           t0an26 = an(026);
           t0an27 = an(027);
           t0an28 = an(028);
           t0an29 = an(029);
           t0an30 = an(030);
           t0mar1 = t0aver;

           t0esco = '0';
           t0mar2 = '0';
           t0mar3 = '0';
           t0mar4 = '0';
           t0mar5 = '0';
           t0strg = '0';

           write p1het0;

           reade %kds ( k1yet0 : 5 ) ctwet0;

         enddo;

         actMarca ( 't@ma30' : '1' );

       endsr;

       begsr grabEt1;

         actMarca ( 't@ma31' : '9' );

         k1yet1.t1empr = peBase.peEmpr;
         k1yet1.t1sucu = peBase.peSucu;
         k1yet1.t1nivt = peBase.peNivt;
         k1yet1.t1nivc = peBase.peNivc;
         k1yet1.t1nctw = peNctw;

         setll %kds ( k1yet1 : 5 ) ctwet1;
         reade %kds ( k1yet1 : 5 ) ctwet1;

         dow not %eof ( ctwet1 );

           t1empr = w0empr;
           t1sucu = w0sucu;
           t1arcd = w0arcd;
           t1spol = @@spol;
           t1sspo = @@sspo;
           t1rama = t1rama;
           t1arse = 1;
           t1oper = @@oper;
           t1suop = @@sspo;
           t1poco = getPoco( t1poco : arrPoco );

           t1secu = t1secu;
           t1accd = %xlate(min:may:t1accd);
           t1accv = t1accv;

           t1cert = *Zeros;
           t1poli = *Zeros;

           t1mar1 = t1mar1;
           t1mar2 = t1mar2;
           t1mar3 = t1mar3;
           t1mar4 = t1mar4;
           t1mar5 = t1mar5;

           t1strg = *Blanks;

           t1user = @PsDs.CurUsr;
           t1date = udate;
           t1time = %dec(%time():*iso);

           write p1het1;

           reade %kds ( k1yet1 : 5 ) ctwet1;

         enddo;

         actMarca ( 't@ma31' : '1' );

       endsr;

       begsr grabEt4;

         actMarca ( 't@ma32' : '9' );

         k1yet0.t0empr = peBase.peEmpr;
         k1yet0.t0sucu = peBase.peSucu;
         k1yet0.t0nivt = peBase.peNivt;
         k1yet0.t0nivc = peBase.peNivc;
         k1yet0.t0nctw = peNctw;

         setll %kds ( k1yet0 : 5 ) ctwet0;
         reade %kds ( k1yet0 : 5 ) ctwet0;

         dow not %eof ( ctwet0 );

           k1yetc.t0empr = peBase.peEmpr;
           k1yetc.t0sucu = peBase.peSucu;
           k1yetc.t0nivt = peBase.peNivt;
           k1yetc.t0nivc = peBase.peNivc;
           k1yetc.t0nctw = peNctw;
           k1yetc.t0rama = t0rama;
           k1yetc.t0arse = t0arse;
           k1yetc.t0poco = t0poco;

           chain %kds ( k1yetc : 8 ) ctwetc01;

           k1yet4.t4empr = peBase.peEmpr;
           k1yet4.t4sucu = peBase.peSucu;
           k1yet4.t4nivt = peBase.peNivt;
           k1yet4.t4nivc = peBase.peNivc;
           k1yet4.t4nctw = peNctw;
           k1yet4.t4rama = t0rama;
           k1yet4.t4arse = t0arse;
           k1yet4.t4poco = t0poco;
           k1yet4.t4cobl = t0cobl;

           setll %kds ( k1yet4 : 9 ) ctwet4;
           reade %kds ( k1yet4 : 9 ) ctwet4;

           dow not %eof ( ctwet4 );

             t4empr = w0empr;
             t4sucu = w0sucu;
             t4arcd = w0arcd;
             t4spol = @@spol;
             t4sspo = @@sspo;
             t4rama = t4rama;
             t4arse = 1;
             t4oper = @@oper;
             t4suop = @@sspo;
             t4poco = getPoco( t4poco : arrPoco );

             t4ccbp = t4ccbp;
             t4pcbp = t4pcbp;

             t4cert = *Zeros;
             t4poli = *Zeros;

             t4prim = *Zeros;
             t4pori = *Zeros;

             t4mcbp = 'N';

             t4user = @PsDs.CurUsr;
             t4date = udate;
             t4time = %dec(%time():*iso);

             write p1het4;

             reade %kds ( k1yet4 : 9 ) ctwet4;

           enddo;

         reade %kds ( k1yet0 : 5 ) ctwet0;

         enddo;

         if t0rras = 'S';
            k1yins.inempr = peBase.peEmpr;
            k1yins.insucu = peBase.peSucu;
            k1yins.innivt = peBase.peNivt;
            k1yins.innivc = peBase.peNivc;
            k1yins.innctw = peNctw;
            k1yins.intipo = 'R';
            k1yins.inrama = t0rama;
            k1yins.inpoco = t0poco;
            k1yins.inarse = t0arse;
            chain %kds ( k1yins : 9 ) ctwins;
            if %found;
               if ( incras <> *Zeros );
                 codRas = incras;
               else;
                 codRas = SPVVEH_getRastreador( t0cobl
                                              : w0tiou
                                              : w0stou
                                              : w0stos
                                              : t0scta );
               endif;
               chain codRas set243;
               select;
                 when ( not %found ( set243 ) );
                   noExisteRas = *on;
                 when ( t@ccbp <> *Zeros );
                   t4empr = w0empr;
                   t4sucu = w0sucu;
                   t4arcd = w0arcd;
                   t4spol = @@spol;
                   t4sspo = @@sspo;
                   t4rama = t4rama;
                   t4arse = 1;
                   t4oper = @@oper;
                   t4suop = @@sspo;
                   t4poco = getPoco( t0poco : arrPoco );
                   t4ccbp = t@ccbp;

                   if w0tiou = 2 or ( w0Tiou = 3 and w0Stou = 1 and
                      w0Stos = 5 );
                     @@Ccbp = SPVVEH_getRastreadorXSpol( w0Empr
                                                       : w0Sucu
                                                       : w0Arcd
                                                       : w0Spo1
                                                       : t4Rama );
                     if @@Ccbp > *zeros;
                       t4Ccbp = @@Ccbp;
                     endif;
                   endif;

                   t4pcbp = *Zeros;
                   t4cert = *Zeros;
                   t4prim = *Zeros;
                   t4pori = *Zeros;
                   t4mcbp = *Blanks;
                   t4user = @PsDs.CurUsr;
                   t4date = udate;
                   t4time = %dec(%time():*iso);
                   write p1het4;
                   incras = codras;
                   update c1wins;
               endsl;
            endif;
         else;
           if w0tiou = 2 or ( w0Tiou = 3 and w0Stou = 1 and
              w0Stos = 5 );
             @@Ccbp = SPVVEH_getRastreadorXSpol( w0Empr
                                               : w0Sucu
                                               : w0Arcd
                                               : w0Spo1
                                               : t4Rama );
             if @@Ccbp > *zeros;
               t4empr = w0empr;
               t4sucu = w0sucu;
               t4arcd = w0arcd;
               t4spol = @@spol;
               t4sspo = @@sspo;
               t4rama = t4rama;
               t4arse = 1;
               t4oper = @@oper;
               t4suop = @@sspo;
               t4poco = getPoco( t0poco : arrPoco );
               t4Ccbp = @@Ccbp;
               t4pcbp = *Zeros;
               t4cert = *Zeros;
               t4prim = *Zeros;
               t4pori = *Zeros;
               t4mcbp = *Blanks;
               t4user = @PsDs.CurUsr;
               t4date = udate;
               t4time = %dec(%time():*iso);
               write p1het4;
             endif;
           endif;
         endif;

         actMarca ( 't@ma32' : '1' );

       endsr;

       begsr grabEt5;

         actMarca ( 't@ma54' : '9' );

         k1yet5.t5empr = peBase.peEmpr;
         k1yet5.t5sucu = peBase.peSucu;
         k1yet5.t5nivt = peBase.peNivt;
         k1yet5.t5nivc = peBase.peNivc;
         k1yet5.t5nctw = peNctw;

         setll %kds ( k1yet5 : 5 ) ctwet5;
         reade %kds ( k1yet5 : 5 ) ctwet5;

         dow not %eof ( ctwet5 );

           t5empr = w0empr;
           t5sucu = w0sucu;
           t5arcd = w0arcd;
           t5spol = @@spol;
           t5sspo = @@sspo;
           t5rama = t5rama;
           t5arse = 1;
           t5oper = @@oper;
           t5suop = @@sspo;
           t5poco = getPoco( t5poco : arrPoco );

           t5cert = *Zeros;
           t5poli = *Zeros;

           t5user = @PsDs.CurUsr;
           t5date = udate;
           t5time = %dec(%time():*iso);

           write p1het5;

           reade %kds ( k1yet5 : 5 ) ctwet5;

         enddo;

         actMarca ( 't@ma54' : '1' );

       endsr;

       begsr grabEt9;

         actMarca ( 't@ma33' : '9' );

         k2yet0.t0empr = w0empr;
         k2yet0.t0sucu = w0sucu;
         k2yet0.t0arcd = w0arcd;
         k2yet0.t0spol = @@spol;
         k2yet0.t0sspo = @@sspo;

         setll %kds ( k2yet0 : 5 ) pahet0;
         reade %kds ( k2yet0 : 5 ) pahet0;

         dow not %eof ( pahet0 );

           if w0tiou = 3 and w0stos = 4 or
              w0Tiou = 3 and w0Stou = 1 and w0stos = 5;
              k1het9.t9empr = t0empr;
              k1het9.t9sucu = t0sucu;
              k1het9.t9arcd = t0arcd;
              k1het9.t9spol = t0spol;
              k1het9.t9rama = t0rama;
              k1het9.t9arse = t0arse;
              k1het9.t9oper = t0oper;
              k1het9.t9poco = t0poco;
              chain %kds(k1het9:8) pahet9;
              if %found;
                 t9patl = t0patl;
                 t9panl = t0panl;
                 t9pann = t0pann;
                 t9moto = %xlate(min:may:t0moto);
                 t9chas = %xlate(min:may:t0chas);
                 t9sspo = t0sspo;
                 t9user = @PsDs.CurUsr;
                 t9date = udate;
                 t9time = %dec(%time():*iso);
                 t9nmat = t0nmat;
                 t9tmat = t0tmat;
                 update p1het9;
              endif;
           else;

           t9empr = t0empr;
           t9sucu = t0sucu;
           t9arcd = t0arcd;
           t9spol = t0spol;
           t9rama = t0rama;
           t9arse = t0arse;
           t9oper = t0oper;
           t9poco = t0poco;

           t9vhmc = t0vhmc;
           t9vhmo = t0vhmo;
           t9vhcs = t0vhcs;
           t9vhcr = t0vhcr;
           t9vhni = t0vhni;
           t9patl = t0patl;
           t9panl = t0panl;
           t9pann = t0pann;
           t9moto = %xlate(min:may:t0moto);
           t9chas = %xlate(min:may:t0chas);
           t9vhca = t0vhca;
           t9vhv1 = t0vhv1;
           t9vhv2 = t0vhv2;
           t9vhct = t0vhct;
           t9vhuv = t0vhuv;
           t9vhaÑ = t0vhaÑ;

           t9mar1 = t0aver;
           t9mar4 = '0';
           t9ruta = t0ruta;
           t9mtdf = t0mtdf;
           t9tmat = t0tmat;
           t9nmat = %xlate(min:may:t0nmat);
           t9vhde = t0vhde;
           t9rgnc = t0rgnc;
           t9acrc = t0acrc;
           t9ruta = t0ruta;
           t9mtdf = t0mtdf;
           t9ifra = t0ifra;
           t9vhde = t0vhde;

           t9cert = *Zeros;
           t9poli = *Zeros;
           t9suin = *Zeros;
           t9ainn = SPVFEC_ObtaÑoFecha8 ( w0vdes );
           t9minn = SPVFEC_ObtMesFecha8 ( w0vdes );
           t9dinn = SPVFEC_ObtDiaFecha8 ( w0vdes );
           t9aegn = *Zeros;
           t9megn = *Zeros;
           t9degn = *Zeros;

           t9mar0 = *Blanks;
           t9mar2 = '0';
           t9mar3 = '0';
           t9mar5 = '0';
           t9mar6 = *Blanks;
           t9mar7 = *Blanks;
           t9mar8 = *Blanks;
           t9mar9 = *Blanks;
           t9strg = '0';

           t9nmer = arrNmer(t0poco);

           t9user = @PsDs.CurUsr;
           t9date = udate;
           t9time = %dec(%time():*iso);

           write p1het9;

           endif;

           reade %kds ( k2yet0 : 5 ) pahet0;

         enddo;

         actMarca ( 't@ma33' : '1' );

       endsr;

       begsr grabEt3;

         actMarca ( 't@ma34' : '9' );

         clear @@Dst3;
         clear @@Dst3C;

         if COWVEH_getCtwet3( peBase.peEmpr
                            : peBase.peSucu
                            : peBase.peNivt
                            : peBase.peNivc
                            : peNctw
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : @@Dst3
                            : @@Dst3C       );

           for x = 1 to @@Dst3C;

             t3Empr = w0Empr;
             t3Sucu = w0Sucu;
             t3Arcd = w0Arcd;
             t3Spol = @@Spol;
             t3Sspo = @@Sspo;
             t3Rama = @@Dst3(x).t3Rama;
             t3Arse = 1;
             t3Oper = @@Oper;
             t3Suop = @@Sspo;

             clear p1Poco;
             p1Poco = @@Dst3(x).t3Poco;
             t3Poco = getPoco( p1Poco : arrPoco );

             t3Taaj = @@Dst3(x).t3Taaj;
             t3Cosg = @@Dst3(x).t3Cosg;
             t3Cert = *Zeros;
             t3Poli = *Zeros;
             t3Tiaj = @@Dst3(x).t3Tiaj;
             t3Tiac = @@Dst3(x).t3Tiac;
             t3Vefa = @@Dst3(x).t3Vefa;
             t3Corc = @@Dst3(x).t3Corc;
             t3Coca = @@Dst3(x).t3Coca;
             t3Mar1 = @@Dst3(x).t3Mar1;
             t3Mar2 = @@Dst3(x).t3Mar2;
             t3Mar3 = @@Dst3(x).t3Mar3;
             t3Mar4 = @@Dst3(x).t3Mar4;
             t3Mar5 = @@Dst3(x).t3Mar5;
             t3Cant = @@Dst3(x).t3Cant;
             t3Strg = @@Dst3(x).t3Strg;
             t3user = @PsDs.CurUsr;
             txdate = udate;
             t3time = %dec(%time():*iso);

             write p1het3;

           endfor;

         endif;

         actMarca ( 't@ma34' : '1' );

       endsr;

       begsr grabEr0;

         actMarca ( 't@ma40' : '9' );

         k1yer0.r0empr = peBase.peEmpr;
         k1yer0.r0sucu = peBase.peSucu;
         k1yer0.r0nivt = peBase.peNivt;
         k1yer0.r0nivc = peBase.peNivc;
         k1yer0.r0nctw = peNctw;

         setll %kds ( k1yer0 : 5 ) ctwer0;
         reade %kds ( k1yer0 : 5 ) ctwer0;

         dow not %eof ( ctwer0 );

           r0empr = w0empr;
           r0sucu = w0sucu;
           r0arcd = w0arcd;
           r0spol = @@spol;
           r0sspo = @@sspo;
           r0rama = r0rama;
           r0arse = 1;
           r0oper = @@oper;
           r0suop = @@sspo;
           r0poco = getPoco( r0poco : arrPoco );

           r0rpro = r0rpro;
           r0rdep = r0rdep;
           r0rloc = r0rloc;
           r0blck = r0blck;
           if r0blck = *blanks;
             r0blck = '0000000';
           endif;
           r0rdes = %xlate(min:may:r0rdes);
           r0nrdm = r0nrdm;
           r0copo = r0copo;
           r0cops = r0cops;
           r0suas = r0suas;
           r0samo = r0samo;
           r0xpro = r0xpro;
           r0clfr = r0clfr;
           r0cagr = r0cagr;
           r0psmp = r0psmp;
           r0crea = r0crea;
           r0ctar = r0ctar;
           r0cta1 = r0cta1;
           r0cta2 = r0cta2;
           r0cviv = r0cviv;

           r0suin = @@sspo;
           r0ainn = SPVFEC_ObtaÑoFecha8 ( w0vdes );
           r0minn = SPVFEC_ObtMesFecha8 ( w0vdes );
           r0dinn = SPVFEC_ObtDiaFecha8 ( w0vdes );

           r0cert = *Zeros;
           r0poli = *Zeros;
           r0acrc = *Zeros;
           r0suen = *Zeros;
           r0aegn = *Zeros;
           r0megn = *Zeros;
           r0degn = *Zeros;
           r0sacm = r0suas;
           r0prbp = *Zeros;
           r0prgp = *Zeros;

           r0acrn = *Blanks;

           r0mar1 = 'S';
           r0mar2 = '0';
           r0mar3 = '0';
           r0mar4 = '0';
           r0mar5 = '0';
           r0strg = '0';

           r0user = @PsDs.CurUsr;
           r0date = udate;
           r0time = %dec(%time():*iso);

           write p1her0;

           reade %kds ( k1yer0 : 5 ) ctwer0;

         enddo;

         actMarca ( 't@ma40' : '1' );

       endsr;


       begsr grabEr2;

         actMarca ( 't@ma41' : '9' );

         k1yer2.r2empr = peBase.peEmpr;
         k1yer2.r2sucu = peBase.peSucu;
         k1yer2.r2nivt = peBase.peNivt;
         k1yer2.r2nivc = peBase.peNivc;
         k1yer2.r2nctw = peNctw;

         setll %kds ( k1yer2 : 5 ) ctwer2;
         reade %kds ( k1yer2 : 5 ) ctwer2;

         dow not %eof ( ctwer2 );

           r2empr = w0empr;
           r2sucu = w0sucu;
           r2arcd = w0arcd;
           r2spol = @@spol;
           r2sspo = @@sspo;
           r2rama = r2rama;
           r2arse = 1;
           r2oper = @@oper;
           r2suop = @@sspo;
           r2poco = getPoco( r2poco : arrPoco );
           r2riec = r2riec;
           r2xcob = r2xcob;

           r2saco = r2saco;
           r2ptco = r2ptco;
           r2xpri = r2xpri;
           r2prsa = r2prsa;
           // ----------------------------------------
           // OJO con lo que se hace con PTCA y XPRA
           // en endosos
           // ----------------------------------------
           r2ptca = r2ptca;
           r2xpra = r2xpra;

           r2cert = *Zeros;
           r2poli = *Zeros;
           r2cagr = *Zeros;
           r2psmp = *Zeros;

           r2ecob = *Blanks;
           r2clfr = *Blanks;
           r2crea = *Blanks;

           r2mar1 = *Blanks;
           r2mar2 = *Blanks;
           r2mar3 = *Blanks;
           r2mar4 = *Blanks;
           r2mar5 = *Blanks;
           r2strg = *Blanks;

           r2user = @PsDs.CurUsr;
           r2date = udate;
           r2time = %dec(%time():*iso);

           write p1her2;

           exsr texter3;

           reade %kds ( k1yer2 : 5 ) ctwer2;

         enddo;

         actMarca ( 't@ma41' : '1' );

       endsr;

       begsr grabEr4;

         actMarca ( 't@ma42' : '9' );

         k1yer4.r4empr = peBase.peEmpr;
         k1yer4.r4sucu = peBase.peSucu;
         k1yer4.r4nivt = peBase.peNivt;
         k1yer4.r4nivc = peBase.peNivc;
         k1yer4.r4nctw = peNctw;

         setll %kds ( k1yer4 : 5 ) ctwer4;
         reade %kds ( k1yer4 : 5 ) ctwer4;

         dow not %eof ( ctwer4 );

           r4empr = w0empr;
           r4sucu = w0sucu;
           r4arcd = w0arcd;
           r4spol = @@spol;
           r4sspo = @@sspo;
           r4rama = r4rama;
           r4arse = 1;
           r4oper = @@oper;
           r4suop = @@sspo;
           r4poco = getPoco( r4poco : arrPoco );
           r4xcob = r4xcob;
           r4nive = r4nive;
           r4ccbp = r4ccbp;
           r4reca = r4reca;
           r4boni = r4boni;

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

           r4user = @PsDs.CurUsr;
           r4date = udate;
           r4time = %dec(%time():*iso);

           write p1her4;

           reade %kds ( k1yer4 : 5 ) ctwer4;

         enddo;

         actMarca ( 't@ma42' : '1' );

       endsr;

       begsr grabEr6;

         actMarca ( 't@ma43' : '9' );

         k1yer6.r6empr = peBase.peEmpr;
         k1yer6.r6sucu = peBase.peSucu;
         k1yer6.r6nivt = peBase.peNivt;
         k1yer6.r6nivc = peBase.peNivc;
         k1yer6.r6nctw = peNctw;

         setll %kds ( k1yer6 : 5 ) ctwer6;
         reade %kds ( k1yer6 : 5 ) ctwer6;

         dow not %eof ( ctwer6 );

           r6empr = w0empr;
           r6sucu = w0sucu;
           r6arcd = w0arcd;
           r6spol = @@spol;
           r6sspo = @@sspo;
           r6rama = r6rama;
           r6arse = 1;
           r6oper = @@oper;
           r6suop = @@sspo;
           r6poco = getPoco( r6poco : arrPoco );
           r6ccba = r6ccba;
           r6mar1 = r6ma01;
           r6ma01 = r6ma02;

           r6cert = *Zeros;
           r6poli = *Zeros;

           r6ma02 = *Blanks;
           r6ma03 = *Blanks;
           r6ma04 = *Blanks;
           r6ma05 = *Blanks;
           r6ma06 = *Blanks;
           r6ma07 = *Blanks;
           r6ma08 = *Blanks;
           r6ma09 = *Blanks;

           r6user = @PsDs.CurUsr;
           r6date = udate;
           r6time = %dec(%time():*iso);

           write p1her6;

           reade %kds ( k1yer6 : 5 ) ctwer6;

         enddo;

         actMarca ( 't@ma43' : '1' );

       endsr;

       begsr grabEr7;

         actMarca ( 't@ma44' : '9' );

         k1yer7.r7empr = peBase.peEmpr;
         k1yer7.r7sucu = peBase.peSucu;
         k1yer7.r7nivt = peBase.peNivt;
         k1yer7.r7nivc = peBase.peNivc;
         k1yer7.r7nctw = peNctw;

         setll %kds ( k1yer7 : 5 ) ctwer7;
         reade %kds ( k1yer7 : 5 ) ctwer7;

         dow not %eof ( ctwer7 );

           r7empr = w0empr;
           r7sucu = w0sucu;
           r7arcd = w0arcd;
           r7spol = @@spol;
           r7sspo = @@sspo;
           r7rama = r7rama;
           r7arse = 1;
           r7oper = @@oper;
           r7suop = @@sspo;
           r7poco = getPoco( r7poco : arrPoco );
           r7riec = r7riec;
           r7xcob = r7xcob;
           r7osec = r7osec;
           r7obje = r7obje;
           r7marc = r7marc;
           r7mode = r7mode;
           r7nser = r7nser;
           r7suas = r7suas;
           r7det1 = r7det1;
           r7det2 = r7det2;
           r7det3 = r7det3;
           r7det4 = r7det4;
           r7det5 = r7det5;
           r7det6 = r7det6;

           r7cert = *Zeros;
           r7poli = *Zeros;

           r7mar1 = *Blanks;
           r7mar2 = *Blanks;
           r7mar3 = *Blanks;
           r7mar4 = *Blanks;
           r7mar5 = *Blanks;
           r7mar6 = *Blanks;
           r7mar7 = *Blanks;
           r7mar8 = *Blanks;
           r7mar9 = *Blanks;
           r7strg = *Blanks;

           r7user = @PsDs.CurUsr;
           r7date = udate;
           r7time = %dec(%time():*iso);

           write p1her7;

           reade %kds ( k1yer7 : 5 ) ctwer7;

         enddo;

         actMarca ( 't@ma44' : '1' );

       endsr;

       begsr grabEra;

         actMarca ( 't@ma53' : '9' );

         k1yera.raempr = peBase.peEmpr;
         k1yera.rasucu = peBase.peSucu;
         k1yera.ranivt = peBase.peNivt;
         k1yera.ranivc = peBase.peNivc;
         k1yera.ranctw = peNctw;

         setll %kds ( k1yera : 5 ) ctwera;
         reade %kds ( k1yera : 5 ) ctwera;

         dow not %eof ( ctwera );

           raarcd = w0arcd;
           raspol = @@spol;
           rasspo = @@sspo;
           raarse = 1;
           raoper = @@oper;
           rasuop = @@sspo;
           rapoco = getPoco( rapoco : arrPoco );

           racert = *Zeros;
           rapoli = *Zeros;

           ramar1 = '0';
           ramar2 = '0';
           ramar3 = '0';
           ramar4 = '0';
           ramar5 = '0';
           ramar6 = '0';
           ramar7 = '0';
           ramar8 = '0';
           ramar9 = '0';
           rastrg = '0';

           rauser = @PsDs.CurUsr;
           radate = %dec(%date():*iso);
           ratime = %dec(%time():*iso);

           write p1hera;

           reade %kds ( k1yera : 5 ) ctwera;

         enddo;

         actMarca ( 't@ma53' : '1' );

       endsr;

       begsr grabEr8;
        k1her2.r2empr = w0empr;
        k1her2.r2sucu = w0sucu;
        k1her2.r2arcd = w0arcd;
        k1her2.r2spol = @@spol;
        k1her2.r2sspo = @@sspo;
        setll %kds(k1her2:5) paher2;
        reade(n) %kds(k1her2:5) paher2;
        dow not %eof;

            zzcfra = 0;
            zziffi = 0;
            zzpfva = 0;
            zzpftf = 0;
            zziatf = 0;
            zziitf = 0;
            zzpftv = 0;
            zzpatv = 0;
            zzpitv = 0;

            k1yer0.r0empr = w0empr;
            k1yer0.r0sucu = w0sucu;
            k1yer0.r0nivt = peBase.peNivt;
            k1yer0.r0nivc = peBase.peNivc;
            k1yer0.r0nctw = peNctw;
            chain(n) %kds(k1yer0:5) ctwer0;
            if %found;
                   par314c1 ( r2Rama
                            : r0Xpro
                            : r2Riec
                            : r2Xcob
                            : w0Mone
                            : r2Saco
                            : peXpri
                            : pePtco
                            : peTpcd
                            : peCls
                            : @@Prem
                            : peFran );
                      zzcfra = peFran.cfra;
                      zziffi = peFran.iffi;
                      zzpfva = peFran.pfva;
                      zzpftf = peFran.pftf;
                      zziatf = peFran.iatf;
                      zziitf = peFran.iitf;
                      zzpftv = peFran.pftv;
                      zzpatv = peFran.patv;
                      zzpitv = peFran.pitv;
               k1her8.r8empr = r2empr;
               k1her8.r8sucu = r2sucu;
               k1her8.r8arcd = r2arcd;
               k1her8.r8spol = r2spol;
               k1her8.r8sspo = r2sspo;
               k1her8.r8rama = r2rama;
               k1her8.r8arse = r2arse;
               k1her8.r8oper = r2oper;
               k1her8.r8poco = r2poco;
               k1her8.r8suop = r2suop;
               k1her8.r8xpro = r0xpro;
               k1her8.r8riec = r2riec;
               k1her8.r8cobc = r2xcob;
               k1her8.r8mone = w0mone;
               k1her8.r8saha = r2saco;
               setll %kds(k1her8) paher8;
               if not %equal;
                  r8empr = r2empr;
                  r8sucu = r2sucu;
                  r8arcd = r2arcd;
                  r8spol = r2spol;
                  r8sspo = r2sspo;
                  r8rama = r2rama;
                  r8arse = r2arse;
                  r8oper = r2oper;
                  r8poco = r2poco;
                  r8suop = r2suop;
                  r8xpro = r0xpro;
                  r8riec = r2riec;
                  r8cobc = r2xcob;
                  r8mone = w0mone;
                  r8saha = r2saco;
                  r8cert = 0;
                  r8poli = 0;
                  r8cfra = zzcfra;
                  r8iffi = zziffi;
                  r8pfva = zzpfva;
                  r8pftf = zzpftf;
                  r8iitf = zziitf;
                  r8iatf = zziatf;
                  r8pftv = zzpftv;
                  r8pitv = zzpitv;
                  r8patv = zzpatv;
                  r8mar1 = '0';
                  r8user = @PsDs.CurUsr;
                  r8date = %dec(%date():*iso);
                  r8time = %dec(%time():*iso);
                  write p1her8;
               endif;
            endif;
         reade(n) %kds(k1her2:5) paher2;
        enddo;
       endsr;

       begsr grabEr1;

         actMarca ( 't@ma45' : '9' ); //ver marca

         k1yer0.r0empr = peBase.peEmpr;
         k1yer0.r0sucu = peBase.peSucu;
         k1yer0.r0nivt = peBase.peNivt;
         k1yer0.r0nivc = peBase.peNivc;
         k1yer0.r0nctw = peNctw;

         setll %kds ( k1yer0 : 5 ) ctwer1;
         reade %kds ( k1yer0 : 5 ) ctwer1;

         dow not %eof ( ctwer1 );

           r1empr = w0empr;
           r1sucu = w0sucu;
           r1arcd = w0arcd;
           r1spol = @@spol;
           r1sspo = @@sspo;
           r1rama = r1rama;
           r1arse = r1arse;
           r1oper = @@oper;
           r1poco = getPoco( r1poco : arrPoco );
           r1suop = @@sspo;
           r1riec = r1riec;
           r1xcob = r1xcob;
           r1secu = r1secu;
           r1nomb = %xlate(min:may:r1nomb);
           r1tido = r1tido;
           r1nrdo = r1nrdo;
           r1fnac = r1fnac;
           r1suas = r1suas;
           r1smue = r1smue;
           r1sinv = r1sinv;
           r1mar1 = *blanks;
           r1mar2 = *blanks;
           r1mar3 = *blanks;
           r1mar4 = *blanks;
           r1mar5 = *blanks;
           r1user = @PsDs.CurUsr;
           r1time = udate;
           r1date = %dec(%time():*iso);

           write p1her1;

           reade %kds ( k1yer0 : 5 ) ctwer1;

         enddo;

         actMarca ( 't@ma45' : '1' );

       endsr;

       begsr grabEr1b;

         actMarca ( 't@ma46' : '9' ); //ver marca

         k1yer0.r0empr = peBase.peEmpr;
         k1yer0.r0sucu = peBase.peSucu;
         k1yer0.r0nivt = peBase.peNivt;
         k1yer0.r0nivc = peBase.peNivc;
         k1yer0.r0nctw = peNctw;

         setll %kds ( k1yer0 : 5 ) ctwer1b;
         reade %kds ( k1yer0 : 5 ) ctwer1b;

         dow not %eof ( ctwer1b );

           b1empr = w0empr;
           b1sucu = w0sucu;
           b1arcd = w0arcd;
           b1spol = @@spol;
           b1sspo = @@sspo;
           b1rama = b1rama;
           b1arse = b1arse;
           b1oper = @@oper;
           b1poco = getPoco( b1poco : arrPoco );
           b1riec = b1riec;
           b1xcob = b1xcob;
           b1secu = b1secu;
           b1sebe = b1sebe;
           b1nomb = %xlate(min:may:b1nomb);
           b1tido = b1tido;
           b1nrdo = b1nrdo;
           b1mar1 = *blanks;
           b1mar2 = *blanks;
           b1mar3 = *blanks;
           b1mar4 = *blanks;
           b1mar5 = *blanks;
           b1user = @PsDs.CurUsr;
           b1time = udate;
           b1date = %dec(%time():*iso);

           write p1her1b;

           reade %kds ( k1yer0 : 5 ) ctwer1b;

         enddo;

         actMarca ( 't@ma46' : '1' );

       endsr;

       begsr grabEr9;

         actMarca ( 't@ma47' : '9' );

         k2yer0.r0empr = w0empr;
         k2yer0.r0sucu = w0sucu;
         k2yer0.r0arcd = w0arcd;
         k2yer0.r0spol = @@spol;
         k2yer0.r0sspo = @@sspo;

         setll %kds ( k2yer0 : 5 ) paher0;
         reade %kds ( k2yer0 : 5 ) paher0;

         dow not %eof ( paher0 );

           if w0tiou = 3 and w0stos = 4 or
              w0Tiou = 3 and w0Stou = 1 and w0stos = 5;

              k1her9.r9empr = r0empr;
              k1her9.r9sucu = r0sucu;
              k1her9.r9arcd = r0arcd;
              k1her9.r9spol = r0spol;
              k1her9.r9rama = r0rama;
              k1her9.r9arse = r0arse;
              k1her9.r9oper = r0oper;
              k1her9.r9poco = r0poco;
              chain %kds(k1her9:8) paher9;
              if %found;
                 r9sspo = r0sspo;
                 update p1her9;
              endif;
           else;

              r9empr = r0empr;
              r9sucu = r0sucu;
              r9arcd = r0arcd;
              r9spol = r0spol;
              r9sspo = r0sspo;
              r9rama = r0rama;
              r9arse = r0arse;
              r9oper = r0oper;
              r9poco = r0poco;

              r9cert = r0cert;
              r9poli = r0poli;
              r9acrc = r0acrc;
              r9acrn = r0acrn;
              r9rpro = r0rpro;
              r9rdep = r0rdep;
              r9rloc = r0rloc;
              r9blck = r0blck;
              if r9blck = *blanks;
                r9blck = '0000000';
              endif;
              r9rdes = %xlate(min:may:r0rdes);
              r9nrdm = r0nrdm;
              r9copo = r0copo;
              r9cops = r0cops;
              r9suin = r0suin;
              r9ainn = r0ainn;
              r9minn = r0minn;
              r9dinn = r0dinn;
              r9suen = r0suen;
              r9aegn = r0aegn;
              r9megn = r0megn;
              r9degn = r0degn;
              r9mar1 = '0';
              r9mar2 = '0';
              r9mar3 = '0';
              r9mar4 = '0';
              r9mar5 = '0';

              r9strg = r0strg;
              r9user = @PsDs.CurUsr;
              r9time = %dec(%time():*iso);
              r9date = udate;
              r9clfr = r0clfr;
              r9cagr = r0cagr;
              r9psmp = r0psmp;
              r9crea = r0crea;

              write p1her9;

           endif;

           reade %kds ( k2yer0 : 5 ) paher0;

         enddo;

         actMarca ( 't@ma47' : '1' );

       endsr;

       begsr grabEg0;

         actMarca ( 't@ma48' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         setll %kds ( k1y001 : 5 ) ctw001;
         reade %kds ( k1y001 : 5 ) ctw001;
         dow not %eof ( ctw001 );
             @@gram = SVPWS_getGrupoRama(w1rama);
             if @@gram <> 'T' and
                @@gram <> 'M' and
                @@gram <> 'A' and
                @@gram <> 'V';
                k1her0.r0empr = w1empr;
                k1her0.r0sucu = w1sucu;
                k1her0.r0arcd = w0arcd;
                k1her0.r0spol = @@spol;
                k1her0.r0sspo = @@sspo;
                setll %kds(k1her0:5) paher0;
                reade %kds(k1her0:5) paher0;
                dow not %eof;
                    PAR314F( r0empr
                           : r0sucu
                           : r0arcd
                           : r0spol
                           : r0sspo
                           : r0rama
                           : r0arse
                           : r0oper
                           : r0sspo
                           : r0poco
                           : r0xpro
                           : COWGRAI_monedaCotizacion(peBase:peNctw)
                           : cl
                           : an                                       );

                     k1heg0.g0empr = r0empr;
                     k1heg0.g0sucu = r0sucu;
                     k1heg0.g0arcd = r0arcd;
                     k1heg0.g0spol = r0spol;
                     k1heg0.g0sspo = r0sspo;
                     k1heg0.g0rama = r0rama;
                     k1heg0.g0arse = r0arse;
                     k1heg0.g0oper = r0oper;
                     k1heg0.g0poco = r0poco;
                     k1heg0.g0suop = r0suop;
                     setll %kds(k1heg0) paheg0;
                     if not %equal;
                        g0empr = k1heg0.g0empr;
                        g0sucu = k1heg0.g0sucu;
                        g0arcd = k1heg0.g0arcd;
                        g0spol = k1heg0.g0spol;
                        g0sspo = k1heg0.g0sspo;
                        g0rama = k1heg0.g0rama;
                        g0arse = k1heg0.g0arse;
                        g0oper = k1heg0.g0oper;
                        g0poco = k1heg0.g0poco;
                        g0suop = k1heg0.g0suop;
                        g0cert = r0cert;
                        g0poli = r0poli;
                        g0ca01 = cl(01);
                        g0ca02 = cl(02);
                        g0ca03 = cl(03);
                        g0ca04 = cl(04);
                        g0ca05 = cl(05);
                        g0ca06 = cl(06);
                        g0ca07 = cl(07);
                        g0ca08 = cl(08);
                        g0ca09 = cl(09);
                        g0ca10 = cl(10);
                        g0ca11 = cl(11);
                        g0ca12 = cl(12);
                        g0ca13 = cl(13);
                        g0ca14 = cl(14);
                        g0ca15 = cl(15);
                        g0ca16 = cl(16);
                        g0ca17 = cl(17);
                        g0ca18 = cl(18);
                        g0ca19 = cl(19);
                        g0ca20 = cl(20);
                        g0ca21 = cl(21);
                        g0ca22 = cl(22);
                        g0ca23 = cl(23);
                        g0ca24 = cl(24);
                        g0ca25 = cl(25);
                        g0ca26 = cl(26);
                        g0ca27 = cl(27);
                        g0ca28 = cl(28);
                        g0ca29 = cl(29);
                        g0ca30 = cl(30);
                        g0marp = '0';
                        g0strg = '0';
                        g0user = @psds.curusr;
                        g0time = %dec(%time():*iso);
                        g0date = %dec(%date():*ymd);
                        write p1heg0;
                     endif;

                     k1heg1.g1empr = r0empr;
                     k1heg1.g1sucu = r0sucu;
                     k1heg1.g1arcd = r0arcd;
                     k1heg1.g1spol = r0spol;
                     k1heg1.g1sspo = r0sspo;
                     k1heg1.g1rama = r0rama;
                     k1heg1.g1arse = r0arse;
                     k1heg1.g1oper = r0oper;
                     k1heg1.g1poco = r0poco;
                     k1heg1.g1suop = r0suop;
                     setll %kds(k1heg1) paheg1;
                     if not %equal;
                        g1empr = k1heg1.g1empr;
                        g1sucu = k1heg1.g1sucu;
                        g1arcd = k1heg1.g1arcd;
                        g1spol = k1heg1.g1spol;
                        g1sspo = k1heg1.g1sspo;
                        g1rama = k1heg1.g1rama;
                        g1arse = k1heg1.g1arse;
                        g1oper = k1heg1.g1oper;
                        g1poco = k1heg1.g1poco;
                        g1suop = k1heg1.g1suop;
                        g1cert = r0cert;
                        g1poli = r0poli;
                        g1an01 = an(01);
                        g1an02 = an(02);
                        g1an03 = an(03);
                        g1an04 = an(04);
                        g1an05 = an(05);
                        g1an06 = an(06);
                        g1an07 = an(07);
                        g1an08 = an(08);
                        g1an09 = an(09);
                        g1an10 = an(10);
                        g1an11 = an(11);
                        g1an12 = an(12);
                        g1an13 = an(13);
                        g1an14 = an(14);
                        g1an15 = an(15);
                        g1an16 = an(16);
                        g1an17 = an(17);
                        g1an18 = an(18);
                        g1an19 = an(19);
                        g1an20 = an(20);
                        g1an21 = an(21);
                        g1an22 = an(22);
                        g1an23 = an(23);
                        g1an24 = an(24);
                        g1an25 = an(25);
                        g1an26 = an(26);
                        g1an27 = an(27);
                        g1an28 = an(28);
                        g1an29 = an(29);
                        g1an30 = an(30);
                        g1marp = '0';
                        g1strg = '0';
                        g1user = @psds.curusr;
                        g1time = %dec(%time():*iso);
                        g1date = %dec(%date():*ymd);
                        write p1heg1;
                     endif;

                 reade %kds(k1her0:5) paher0;
                enddo;
             endif;
           reade %kds ( k1y001 : 5 ) ctw001;
         enddo;

         actMarca ( 't@ma48' : '1' );

       endsr;

       begsr grabEv0;

         actMarca ( 't@ma49' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctwev1;
         reade %kds ( k1y001 : 5 ) ctwev1;

         dow not %eof ( ctwev1 );

           clear p1hev0;

           v0empr = v1empr;
           v0sucu = v1sucu;
           v0arcd = w0arcd;
           v0spol = @@spol;
           v0rama = v1rama;
           v0arse = v1arse;
           v0oper = @@oper;
           v0poco = getPocoV( v1poco : arrPocoV );
           v0paco = v1paco;
           v0cert = *zeros;
           v0poli = *zeros;
           v0sspo = @@sspo;
           v0nomb = %xlate(min:may:v1nomb);
           v0tido = v1tido;
           v0nrdo = v1nrdo;
           v0fnaa = %int(%subst(%editc( v1fnac : 'X' ):1:4));
           v0fnam = %int(%subst(%editc( v1fnac : 'X' ):5:2));
           v0fnad = %int(%subst(%editc( v1fnac : 'X' ):7:2));
           v0fiea = *zeros;
           v0fiem = *zeros;
           v0fied = *zeros;
           v0nrla = *blanks;
           v0nrln = *zeros;
           v0suin = *zeros;
           v0ainn = SPVFEC_ObtaÑoFecha8 ( w0vdes );
           v0minn = SPVFEC_ObtMesFecha8 ( w0vdes );
           v0dinn = SPVFEC_ObtDiaFecha8 ( w0vdes );
           v0suen = *zeros;
           v0aegn = *zeros;
           v0megn = *zeros;
           v0degn = *zeros;
           v0mar1 = '0';
           v0mar2 = '0';
           v0mar3 = '0';
           v0mar4 = '0';
           v0mar5 = '0';
           v0strg = '0';
           v0naci = v1naci;
           v0acti = v1acti;
           v0cate = v1cate;
           v0user = @PsDs.CurUsr;
           v0time = udate;
           v0date = %dec(%time():*iso);

           write p1hev0;

           reade %kds ( k1y001 : 5 ) ctwev1;

         enddo;

         actMarca ( 't@ma49' : '1' );

       endsr;

       begsr grabEv1;

         actMarca ( 't@ma50' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctwev1;
         reade %kds ( k1y001 : 5 ) ctwev1;

         dow not %eof ( ctwev1 );

           //@@cate = '0';
           //if v1cate >= 1 and v1cate <= 9;
           //   @@cate = %char(v1cate);
           //endif;

           v1poco = getPocoV( v1poco : arrPocoV );
           v1spol = @@spol;
           v1sspo = @@sspo;
           v1arcd = w0arcd;
           v1oper = @@oper;
           v1sacm = GetSumaTotalVida;
           v1pcap = GetCapitalParientes;
           v1suas = GetSumaTotalVida;
           v1samo = GetSumaTotalVida;
           v1cant = 0;
           v1suel = 0;
           v1user = @PsDs.CurUsr;
           v1time = udate;
           v1date = %dec(%time():*iso);
           vxcate = v1cate;

           write p1hev1;

           reade %kds ( k1y001 : 5 ) ctwev1;

         enddo;

         actMarca ( 't@ma50' : '1' );

       endsr;

       begsr grabEv2;

         actMarca ( 't@ma51' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctwev2;
         reade %kds ( k1y001 : 5 ) ctwev2;

         dow not %eof ( ctwev2 );

           v2poco = getPocoV( v2Poco : arrPocoV );
           v2spol = @@spol;
           v2sspo = @@sspo;
           v2arcd = w0arcd;
           v2oper = @@oper;
           v2user = @PsDs.CurUsr;
           v2time = udate;
           v2date = %dec(%time():*iso);

           write p1hev2;

           reade %kds ( k1y001 : 5 ) ctwev2;

         enddo;

         actMarca ( 't@ma51' : '1' );

       endsr;

       begsr grabEvb;

         actMarca ( 't@ma52' : '9' );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctwevb;
         reade %kds ( k1y001 : 5 ) ctwevb;

         dow not %eof ( ctwevb );

           v9empr = v0empr;
           v9sucu = v0sucu;
           v9arcd = w0arcd;
           v9spol = @@spol;
           v9rama = v0rama;
           v9arse = v0arse;
           v9oper = @@oper;
           v9suop = @@sspo;
           v9spol = @@spol;
           v9arcd = w0arcd;
           v9oper = @@oper;
           v9secu = v0secu;
           v9nomb = v0nomb;

           monitor;
             v9cuil = %int(v0cuit);
           on-error;
             v9cuil = 0;
           endmon;

           v9mar1 = v0mar1;
           v9mar2 = v0mar2;
           v9mar3 = v0mar3;
           v9mar4 = v0mar4;
           v9mar5 = v0mar5;

           v9user = @PsDs.CurUsr;
           v9time = udate;
           v9date = %dec(%time():*iso);

           write p1hev9;

           reade %kds ( k1y001 : 5 ) ctwevb;

         enddo;

         actMarca ( 't@ma52' : '1' );

       endsr;

       begsr grabCd5;

        k1yec3.c3empr = peBase.peEmpr;
        k1yec3.c3sucu = peBase.peSucu;
        k1yec3.c3arcd = w0arcd;
        k1yec3.c3spol = @@spol;
        k1yec3.c3sspo = @@sspo;
        chain %kds( k1yec3 : 5 ) pahec3;
        if %found( pahec3 );

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;

         setll %kds ( k1y001 : 5 ) ctw001;
         reade %kds ( k1y001 : 5 ) ctw001;
         dow not %eof( ctw001 );

          exsr calcuo;

          reade %kds ( k1y001 : 5 ) ctw001;
         enddo;
        endif;

       endsr;

        BegSr Calcuo;

         //Fecha tentativa de emision...
         @@fema = *zeros;
         @@femm = *zeros;
         @@femd = *zeros;

         PAR310X3( w0empr
                 : @@fema
                 : @@femm
                 : @@femd );
         @@ivat = 0;
         @@ivat = w1ipr1 + w1ipr3;

         //Definir la fecha base de calculo de cuotas...
          Select;
           when c3fb1c = 0  or c3fb1c = 3;
            @@faÑo = SPVFEC_ObtaÑoFecha8 ( w0vdes );
            @@fmes = SPVFEC_ObtMesFecha8 ( w0vdes );
            @@fdia = SPVFEC_ObtDiaFecha8 ( w0vdes );

           when c3fb1c = 1  or c3fb1c = 4;
            @@faÑo = @@fema;
            @@fmes = @@femm;
            @@fdia = @@femd;

           when c3fb1c = 2  or c3fb1c = 5;
            @@fdes = ( SPVFEC_ObtaÑoFecha8 ( w0vdes ) * 10000 )   +
                     ( SPVFEC_ObtMesFecha8 ( w0vdes ) * 100 )     +
                     ( SPVFEC_ObtDiaFecha8 ( w0vdes ) );
            @@femi = ( @@fema * 10000 ) + ( @@femm * 100 ) + ( @@femd );
            if @@fdes >= @@femi;
             @@faÑo = SPVFEC_ObtaÑoFecha8 ( w0vdes );
             @@fmes = SPVFEC_ObtMesFecha8 ( w0vdes );
             @@fdia = SPVFEC_ObtDiaFecha8 ( w0vdes );
            else;
             @@faÑo = @@fema;
             @@fmes = @@femm;
             @@fdia = @@femd;
            endif;
           endsl;

           fec = *zeros;
           imp = *zeros;

           //El código de fecha base para vto.de primer cuota
           //cuando contiene 3/4/5 condiciona también el vto.
           //de la segunda cuota...
           if c3fb1c = 3 and fec(02) = *zeros  or
            c3fb1c = 4 and fec(02) = *zeros  or
            c3fb1c = 5 and fec(02) = *zeros ;
            @@desd = *zeros;
            @@dup1 = 2;
            @@desd = SPVFEC_GiroFecha8 ( w0vdes : 'DMA' );
            SP0001 ( @@desd
                   : @@dup1 );
            fec(02) = @@desd;
           endif;

         //el código de valor de primera cuota 8 condiciona
         //el valor de la primera cuota de la siguiente forma
         //16% para consumidores finales y 20% para otras
         //categorias...
          if c3ci1c = 8  and c3ccuo > 1  and
           imp(01) = *zeros;

           select;
            when w0civa = 05;
     c     w1prem        mult(h)   0,16          imp(01)
            other;
     c     w1prem        mult(h)   0,20          imp(01)
           endsl;
          endif;

         //Redondeo de cuotas...
         exsr srredo;

        //ejecutar el càlculo...
          PAR312E ( w1prem
                  : c3ccuo
                  : c3ci1c
                  : c3dv1c
                  : c3cimc
                  : c3immc
                  : c3dfv1
                  : c3dfm1
                  : c3dfv2
                  : c3dfm2
                  : @@ivat
                  : @@fdia
                  : @@fmes
                  : @@faÑo
                  : w0come
                  : fec
                  : imp
                  : c3nrpp );
        //Verifica cuotas fuera de vigencia...
         y = *zeros;
         for x=1 to 30;
          if fec(x) <> *zeros;
           @@fech = SPVFEC_GiroFecha8 ( fec(x) : 'AMD' );
           if @@fech <= @@hafa;
           y +=1;
           endif;
          endif;
         endfor;
        //si la cantidad de cuotas validas es menor mandar
        //recalculo de cuotas...
         if y < c3ccuo;
          c3ccuo = y;
          imp = *zeros;
          fec = *zeros;
          imp(1) = *zeros;

        //el código de fecha base para vto.de primer cuota
        //cuando contiene 3/4/5 condiciona también el vto.
        //de la segunda cuota...
          if c3fb1c = 3  and fec(02) = *zeros  or
             c3fb1c = 4  and fec(02) = *zeros  or
             c3fb1c = 5  and fec(02) = *zeros;
           @@dup1 = 2;
           @@desd = SPVFEC_GiroFecha8 ( w0vdes : 'DMA' );
           SP0001 ( @@desd
                  : @@dup1 );
           fec(02) = @@desd;
          endif;

        //el código de valor de primera cuota 8 condiciona
        //el valor de la primera cuota de la siguiente forma
        //16% para consumidores finales y 20% para otras
        //categorias...
          if c3ci1c = 8 and imp(01) = *zeros;
           select;
            when w0civa = 05;
     c     w1prem        mult(h)   0,16          imp(01)
            other;
     c     w1prem        mult(h)   0,20          imp(01)
           endsl;
          endif;
        //Redondeo de cuotas...
          exsr srredo;
          PAR312E( w1prem
                 : c3ccuo
                 : c3ci1c
                 : c3dv1c
                 : c3cimc
                 : c3immc
                 : c3dfv1
                 : c3dfm1
                 : c3dfv2
                 : c3dfm2
                 : @@ivat
                 : @@fdia
                 : @@fmes
                 : @@faÑo
                 : w0come
                 : fec
                 : imp
                 : c3nrpp );
         endif;

        //grabacion de nuevas cuotas...
         d5empr = w0empr;
         d5sucu = w0sucu;
         d5arcd = w0arcd;
         d5spol = @@spol;
         d5sspo = @@sspo;
         d5rama = w1rama;
         d5arse = 1;
         d5oper = @@oper;
         d5suop = @@sspo;
         d5mone = w0mone;

         for k = 1 to 30;
          if fec(k) <> *zeros;

           //Si es la cuota 1 graba fecha...
           if k = 1;
            p@1dma = fec(k);
            d@fe1d = p@fe1d;
            d@fe1m = p@fe1m;
            d@fe1a = p@fe1a;
           endif;

           //Si es la cuota 2 graba fecha
           if k = 2;
            p@2dma = fec(k);
            d@fe2d = p@fe2d;
            d@fe2m = p@fe2m;
            d@fe2a = p@fe2a;
           endif;

           //Si es la cuota 3 graba fecha
           if k = 3;
            p@3dma = fec(k);
            d@fe3d = p@fe3d;
            d@fe3m = p@fe3m;
            d@fe3a = p@fe3a;
           endif;

           //Si es la cuota 2 pregunta si la fecha es menor a la fecha de
           // la primera cuota...
           if k = 2;
            if p@2amd < p@1amd;
             fec(k) = p@1dma;
             p@2dma = p@1dma;
             d@fe2d = p@fe2d;
             d@fe2m = p@fe2m;
             d@fe2a = p@fe2a;
            endif;
           endif;

           //Si es la cuota 3 pregunta si la fecha es menor a la fecha de la
           //segunda cuota...
           if k = 3;
            if p@3amd < p@2amd;
             fec(k) = p@2dma;
            endif;
           endif;
           d5nrcu = k;
           d5nrsc = *zeros;
           p@fdma = fec(k);
           d5fvcd = p@fdia;
           d5fvcm = p@fmes;
           d5fvca = p@faÑo;
           d5imcu = imp(k);
           d5ctcu = w0ctcu;
           d5nrct = *zeros;
           d5ivr2 = *zeros;
           d5nrrt = *zeros;
           d5nrlo = *zeros;
           d5nrcc = *zeros;
           d5cbrn = w0nivc;
           d5czco = 9999999;
           d5nrla = *blank;
           d5nrln = *zeros;
           d5cert = *zeros;
           d5poli = *zeros;
           d5cfpg = w0cfpg;
           exsr srsttc;
           d5marp = '0';
           d5mar2 = '0';
           d5strg = '0';
           d5user = @PsDs.CurUsr;
           d5time = udate;
           d5date = %dec(%time():*iso);
           if SPVCBU_GetCBUSeparado( @@ncbu
                                   : d5ivbc
                                   : d5ivsu
                                   : d5tcta
                                   : @@ncta );
           endif;
           d5mar3 = *off;
           d5mar4 = *off;
           d5cn02 = *zeros;
           d5imau = *zeros;
           write p1hcd5;
          else;
           leavesr;
          endif;
         endfor;

       endsr;

       begsr grabCc2;

        Primera_Cuota = Si;
        @@nrcu = *all'9';

        k1ycd5.d5empr = w0empr;
        k1ycd5.d5sucu = w0sucu;
        k1ycd5.d5arcd = w0arcd;
        k1ycd5.d5spol = @@spol;
        k1ycd5.d5sspo = @@sspo;
        setll %kds(k1ycd5:5) pahcd502;
        reade %kds(k1ycd5:5) pahcd502;
        dow not %eof(pahcd502);

          if Primera_Cuota;
           @@nrcu = d5nrcu;
           clear p1hcc2;
           Primera_Cuota = No;
          endif;

          c2empr = w0empr;
          c2sucu = w0sucu;
          c2arcd = w0arcd;
          c2spol = @@spol;
          c2sspo = @@sspo;
          c2nrcu = d5nrcu;
          c2nrsc = d5nrsc;
          c2fvca = d5fvca;
          c2fvcm = d5fvcm;
          c2fvcd = d5fvcd;
          c2mone = d5mone;
          c2ctcu = d5ctcu;
          c2nrct = d5nrct;
          c2ivr2 = d5ivr2;
          c2nrrt = d5nrrt;
          c2nrlo = d5nrlo;
          c2nrcc = d5nrcc;
          c2cbrn = w0nivc;
          c2czco = 9999999;
          c2nrla = d5nrla;
          c2nrln = d5nrln;
          c2cert = d5cert;
          c2cfpg = w0cfpg;
          c2sttc = d5sttc;
          c2marp = d5marp;
          c2mar2 = d5mar2;
          c2strg = d5strg;
          c2ivbc = d5ivbc;
          c2ivsu = d5ivsu;
          c2tcta = d5tcta;
          c2mar3 = d5mar3;
          c2mar4 = d5mar4;
          c2cn02 = d5cn02;
          c2imau = d5imau;
          c2imcu += d5imcu;

          c2user = @PsDs.CurUsr;
          c2date = udate;
          c2time = %dec(%time():*iso);

          reade %kds(k1ycd5:5) pahcd502;

          if %eof( pahcd502 ) or
           d5nrcu <> @@nrcu;
           write p1hcc2;
           @@nrcu = d5nrcu;
           clear p1hcc2;
          endif;

        enddo;

       endsr;

       begsr srredo;

       // Definir forma de redondeo de cuotas
       select;
        when w0cfpg = 1 and @@redo = '1';
         imp(30) = 0,99;

        when w0cfpg = 2 and @@redo = '2';
         imp(30) = 0,99;

        when w0cfpg = 3 and @@redo = '3';
         imp(30) = 0,99;

        when w0cfpg = 4 and @@redo = '4';
         imp(30) = 0,99;

        when w0cfpg = 5 and @@redo = '5';
         imp(30) = 0,99;

        when w0cfpg = 6 and @@redo = '6';
         imp(30) = 0,99;

        when w0cfpg = 7 and @@redo = '7';
         imp(30) = 0,99;

        when w0cfpg = 1 and @@redo = 'A'  or
             w0cfpg = 2 and @@redo = 'A'  or
             w0cfpg = 3 and @@redo = 'A';
         imp(30) = 0,99;

        when w0cfpg = 4 and @@redo = 'B'  or
             w0cfpg = 5 and @@redo = 'B'  or
             w0cfpg = 6 and @@redo = 'B'  or
             w0cfpg = 7 and @@redo = 'B';
         imp(30) = 0,99;

        when @@redo = 'C';
         imp(30) = 0,99;

       endsl;

       endsr;

       begsr srsttc;
       // Código de estado de cuota...
        select;
        when w0cfpg = 1;
         d5sttc = '1';
        when w0cfpg = 2;
         d5sttc = '1';
        when w0cfpg = 3;
         d5sttc = '1';
        when w0cfpg = 4;
         d5sttc = '0';
        when w0cfpg = 5;
         d5sttc = '0';
        when c1cfpg = 6;
         d5sttc = '6';
        when w0cfpg = 7;
         d5sttc = '7';
        other;
         d5sttc = '0';
        endsl;

       endsr;

       begsr texter3;

         p@arcd = w0arcd;
         p@spol = w0spol;
         p@sspo = @@sspo;
         p@rama = r2rama;
         p@arse = r2arse;
         p@oper = @@oper;
         p@poco = r2poco;
         p@suop = @@sspo;
         p@xcob = r2xcob;
         p@cert = r0cert;
         p@poli = r0poli;
         p@xpro = r0xpro;

         PAR314CY ( r2empr :
                    r2sucu :
                    p@arcd :
                    p@spol :
                    p@sspo :
                    p@rama :
                    p@arse :
                    p@oper :
                    p@poco :
                    p@suop :
                    r2riec :
                    p@xcob :
                    p@cert :
                    p@poli :
                    p@xpro :
                    w0mone :
                    @@clof :
                    r2saco );

       endsr;

       begsr grabmsg;

         leavesr;

         k1yed0.d0empr = w0empr;
         k1yed0.d0sucu = w0sucu;
         k1yed0.d0arcd = w0arcd;
         k1yed0.d0spol = @@spol;

         setll %kds ( k1yed0 : 4 ) pahed0;
         reade %kds ( k1yed0 : 4 ) pahed0;
         dow not %eof;

           K1ymsg.sgempr = peBase.peEmpr;
           K1ymsg.sgsucu = peBase.peSucu;
           K1ymsg.sgnivt = peBase.peNivt;
           K1ymsg.sgnivc = peBase.peNivc;
           K1ymsg.sgmsid = @@msid;

           chain %kds(k1ymsg) gntmsg;
           if not %found(gntmsg);

             sgempr = peBase.peEmpr;
             sgsucu = peBase.peSucu;
             sgnivt = peBase.peNivt;
             sgnivc = peBase.peNivc;
             sgmsid = @@msid;
             sgfmsg = %date;
             sgimpo = 0;
             sgread = '0';
             sgmar1 = '0';
             sgmar2 = '0';
             sgmar3 = '0';
             sgmar4 = '0';
             sgmar5 = '0';
             sgmar6 = '0';
             sgmar7 = '0';
             sgmar8 = '0';
             sgmar9 = '0';
             sgmar0 = '0';
             sguser = @PsDs.CurUsr;
             sgdate = %dec(%date);
             sgtime = %dec(%time():*iso);
             write g1tmsg;

           endif;

           reade %kds ( k1yed0 : 4 ) pahed0;
         enddo;

         k2ymsg.msempr = peBase.peEmpr;
         k2ymsg.mssucu = peBase.peSucu;
         k2ymsg.msnivt = peBase.peNivt;
         k2ymsg.msnivc = peBase.peNivc;
         k2ymsg.msnctw = peNctw;

         setgt %kds ( k2ymsg : 5 ) ctwmsg;
         readpe %kds ( k2ymsg : 5 ) ctwmsg;

         if %eof ( ctwmsg );
           msivse = 1;
         else;
           msivse += 1;
         endif;

         msempr = peBase.peEmpr;
         mssucu = peBase.peSucu;
         msnivt = peBase.peNivt;
         msnivc = peBase.peNivc;
         msnctw = peNctw;
         mscpgm = 'COW310';
         mstxmg = %trim( mstxmg ) + ' ' + %trim ( moti );
         msmar1 = '0';
         msmar2 = '0';
         msmar3 = '0';
         msmar4 = '0';
         msmar5 = '0';
         msuser = @PsDs.CurUsr;
         msdate = %dec(%date():*iso);
         mstime = %dec(%time():*iso);

         write c1wmsg;

       endsr;

     P actMarca        b
     D actMarca        pi
     D   peCamp                       6    const
     D   peMarc                       1    const

       k1yest.t@empr = peBase.peEmpr;
       k1yest.t@sucu = peBase.peSucu;
       k1yest.t@nivt = peBase.peNivt;
       k1yest.t@nivc = peBase.peNivc;
       k1yest.t@nctw = peNctw;
       chain %kds ( k1yest ) ctwest;

       select;

         when ( peCamp = 't@ma00' );
           t@ma00 = peMarc;
         when ( peCamp = 't@ma01' );
           t@ma01 = peMarc;
         when ( peCamp = 't@ma02' );
           t@ma02 = peMarc;
         when ( peCamp = 't@ma03' );
           t@ma03 = peMarc;
         when ( peCamp = 't@ma04' );
           t@ma04 = peMarc;
         when ( peCamp = 't@ma05' );
           t@ma05 = peMarc;
         when ( peCamp = 't@ma06' );
           t@ma06 = peMarc;
         when ( peCamp = 't@ma07' );
           t@ma07 = peMarc;
         when ( peCamp = 't@ma08' );
           t@ma08 = peMarc;
         when ( peCamp = 't@ma09' );
           t@ma09 = peMarc;
         when ( peCamp = 't@ma10' );
           t@ma10 = peMarc;
         when ( peCamp = 't@ma11' );
           t@ma11 = peMarc;
         when ( peCamp = 't@ma12' );
           t@ma12 = peMarc;
         when ( peCamp = 't@ma13' );
           t@ma13 = peMarc;
         when ( peCamp = 't@ma14' );
           t@ma14 = peMarc;
         when ( peCamp = 't@ma15' );
           t@ma15 = peMarc;
         when ( peCamp = 't@ma16' );
           t@ma16 = peMarc;
         when ( peCamp = 't@ma17' );
           t@ma17 = peMarc;
         when ( peCamp = 't@ma18' );
           t@ma18 = peMarc;
         when ( peCamp = 't@ma19' );
           t@ma19 = peMarc;
         when ( peCamp = 't@ma20' );
           t@ma20 = peMarc;
         when ( peCamp = 't@ma21' );
           t@ma21 = peMarc;
         when ( peCamp = 't@ma22' );
           t@ma22 = peMarc;
         when ( peCamp = 't@ma23' );
           t@ma23 = peMarc;
         when ( peCamp = 't@ma24' );
           t@ma24 = peMarc;
         when ( peCamp = 't@ma25' );
           t@ma25 = peMarc;
         when ( peCamp = 't@ma26' );
           t@ma26 = peMarc;
         when ( peCamp = 't@ma27' );
           t@ma27 = peMarc;
         when ( peCamp = 't@ma28' );
           t@ma28 = peMarc;
         when ( peCamp = 't@ma29' );
           t@ma29 = peMarc;
         when ( peCamp = 't@ma30' );
           t@ma30 = peMarc;
         when ( peCamp = 't@ma31' );
           t@ma31 = peMarc;
         when ( peCamp = 't@ma32' );
           t@ma32 = peMarc;
         when ( peCamp = 't@ma33' );
           t@ma33 = peMarc;
         when ( peCamp = 't@ma34' );
           t@ma34 = peMarc;
         when ( peCamp = 't@ma35' );
           t@ma35 = peMarc;
         when ( peCamp = 't@ma36' );
           t@ma36 = peMarc;
         when ( peCamp = 't@ma37' );
           t@ma37 = peMarc;
         when ( peCamp = 't@ma38' );
           t@ma38 = peMarc;
         when ( peCamp = 't@ma39' );
           t@ma39 = peMarc;
         when ( peCamp = 't@ma40' );
           t@ma40 = peMarc;
         when ( peCamp = 't@ma41' );
           t@ma41 = peMarc;
         when ( peCamp = 't@ma42' );
           t@ma42 = peMarc;
         when ( peCamp = 't@ma43' );
           t@ma43 = peMarc;
         when ( peCamp = 't@ma44' );
           t@ma44 = peMarc;
         when ( peCamp = 't@ma45' );
           t@ma45 = peMarc;
         when ( peCamp = 't@ma46' );
           t@ma46 = peMarc;
         when ( peCamp = 't@ma47' );
           t@ma47 = peMarc;
         when ( peCamp = 't@ma48' );
           t@ma48 = peMarc;
         when ( peCamp = 't@ma49' );
           t@ma49 = peMarc;
         when ( peCamp = 't@ma50' );
           t@ma50 = peMarc;
         when ( peCamp = 't@ma51' );
           t@ma51 = peMarc;
         when ( peCamp = 't@ma52' );
           t@ma52 = peMarc;
         when ( peCamp = 't@ma53' );
           t@ma53 = peMarc;
         when ( peCamp = 't@ma54' );
           t@ma54 = peMarc;
         when ( peCamp = 't@ma55' );
           t@ma55 = peMarc;
         when ( peCamp = 't@ma56' );
           t@ma56 = peMarc;
         when ( peCamp = 't@ma57' );
           t@ma57 = peMarc;
         when ( peCamp = 't@ma58' );
           t@ma58 = peMarc;
         when ( peCamp = 't@ma59' );
           t@ma59 = peMarc;
         when ( peCamp = 't@ma60' );
           t@ma60 = peMarc;
         when ( peCamp = 't@ma61' );
           t@ma61 = peMarc;
         when ( peCamp = 't@ma62' );
           t@ma62 = peMarc;
         when ( peCamp = 't@ma63' );
           t@ma63 = peMarc;
         when ( peCamp = 't@ma64' );
           t@ma64 = peMarc;
         when ( peCamp = 't@ma65' );
           t@ma65 = peMarc;
         when ( peCamp = 't@ma66' );
           t@ma66 = peMarc;
         when ( peCamp = 't@ma67' );
           t@ma67 = peMarc;
         when ( peCamp = 't@ma68' );
           t@ma68 = peMarc;
         when ( peCamp = 't@ma69' );
           t@ma69 = peMarc;
         when ( peCamp = 't@ma70' );
           t@ma70 = peMarc;
         when ( peCamp = 't@ma71' );
           t@ma71 = peMarc;
         when ( peCamp = 't@ma72' );
           t@ma72 = peMarc;
         when ( peCamp = 't@ma73' );
           t@ma73 = peMarc;
         when ( peCamp = 't@ma74' );
           t@ma74 = peMarc;
         when ( peCamp = 't@ma75' );
           t@ma75 = peMarc;
         when ( peCamp = 't@ma76' );
           t@ma76 = peMarc;
         when ( peCamp = 't@ma77' );
           t@ma77 = peMarc;
         when ( peCamp = 't@ma78' );
           t@ma78 = peMarc;
         when ( peCamp = 't@ma79' );
           t@ma79 = peMarc;
         when ( peCamp = 't@ma80' );
           t@ma80 = peMarc;
         when ( peCamp = 't@ma81' );
           t@ma81 = peMarc;
         when ( peCamp = 't@ma82' );
           t@ma82 = peMarc;
         when ( peCamp = 't@ma83' );
           t@ma83 = peMarc;
         when ( peCamp = 't@ma84' );
           t@ma84 = peMarc;
         when ( peCamp = 't@ma85' );
           t@ma85 = peMarc;
         when ( peCamp = 't@ma86' );
           t@ma86 = peMarc;
         when ( peCamp = 't@ma87' );
           t@ma87 = peMarc;
         when ( peCamp = 't@ma88' );
           t@ma88 = peMarc;
         when ( peCamp = 't@ma89' );
           t@ma89 = peMarc;
         when ( peCamp = 't@ma90' );
           t@ma90 = peMarc;
         when ( peCamp = 't@ma91' );
           t@ma91 = peMarc;
         when ( peCamp = 't@ma92' );
           t@ma92 = peMarc;
         when ( peCamp = 't@ma93' );
           t@ma93 = peMarc;
         when ( peCamp = 't@ma94' );
           t@ma94 = peMarc;
         when ( peCamp = 't@ma95' );
           t@ma95 = peMarc;
         when ( peCamp = 't@ma96' );
           t@ma96 = peMarc;
         when ( peCamp = 't@ma97' );
           t@ma97 = peMarc;
         when ( peCamp = 't@ma98' );
           t@ma98 = peMarc;
         when ( peCamp = 't@ma99' );
           t@ma99 = peMarc;

       endsl;

       update c1west;

       return;

     P actMarca        e

     P getPlanC        b
     D getPlanC        pi             3  0

     D @@plac          s              3  0

       if ( @@ncoc <> *Zeros );

         k1y606.t@arcd = w0arcd;
         k1y606.t@rama = w1rama;
         k1y606.t@arse = 1;
         k1y606.t@empr = w0empr;
         k1y606.t@sucu = w0sucu;
         k1y606.t@ncoc = @@ncoc;

         chain %kds ( k1y606 ) set606;

         @@plac = t@plac;

       else;

         @@plac = *Zeros;

       endif;

       if ( @@plac = *Zeros );

         k1yec4.c4empr = w0empr;
         k1yec4.c4sucu = w0sucu;
         k1yec4.c4arcd = w0arcd;
         k1yec4.c4spol = @@spol;
         k1yec4.c4sspo = @@sspo;

         chain(n) %kds ( k1yec4 : 4 ) pahec4;

         k1y609.t@arcd = w0arcd;
         k1y609.t@rama = w1rama;
         k1y609.t@arse = 1;
         k1y609.t@nivt = w0nivt;
         k1y609.t@nivc = w0nivc;
         k1y609.t@cfpg = w0cfpg;
         k1y609.t@sarc = c4sarc;

         chain %kds ( k1y609 ) set609;

         @@plac = t@plac;

       endif;

       if ( @@plac = *Zeros );

         k1y609.t@arcd = w0arcd;
         k1y609.t@rama = w1rama;
         k1y609.t@arse = 1;
         k1y609.t@nivt = w0nivt;
         k1y609.t@nivc = w0nivc;
         k1y609.t@cfpg = w0cfpg;
         k1y609.t@sarc = *Zeros;

         chain %kds ( k1y609 ) set609;

         @@plac = t@plac;

       endif;

       chain w0arcd set621;
       @@plac = t1plac;

       return @@plac;

     P getPlanC        e


       //---------------------------------------------------------------
       // Veo si se cumplen las condiciones para que se pueda confirmar
       //---------------------------------------------------------------

     P chkConfirma     b
     D chkConfirma     pi              n


       if COWVEH_confirmarInspeccion( peBase : peNctw );
         if not COWGRAI_isFlota( peBase : peNctw );
           moti = ' - Algún Componente requiere Inspección';
           return *off;
         endif;
       endif;

       //busco si algun componente de hogar requiere inspección

       if GetRequiereInspeccion = 'S';

           moti = ' - Algún Componente requiere Inspección';

           return *off;

       endif;

       //La fecha de emision de emisión no puede ser menor a la del set103

       PAR310X3( peBase.peEmpr
               : @@fema
               : @@femm
               : @@femd );

       @@femi = ( @@fema * 10000 ) + ( @@femm * 100 ) + ( @@femd );

       k1yetc.t0empr = peBase.peEmpr;
       k1yetc.t0sucu = peBase.peSucu;
       k1yetc.t0nivt = peBase.peNivt;
       k1yetc.t0nivc = peBase.peNivc;
       k1yetc.t0nctw = peNctw;

       setll %kds ( k1yetc : 5 ) ctwet1;
       reade %kds ( k1yetc : 5 ) ctwet1;
       dow not %eof();

         chain (w1rama) set013;
         if %found();

           if @@femi < t@fech;

             moti = ' - Módulo de Textos Automáticos Desactivados';

             return *off;

           endif;

         endif;

         reade %kds ( k1yetc : 5 ) ctwet1;
       enddo;

       if noExisteRas;

         moti = 'No Existe Código de Rastreador';

         return *off;

       endif;

       return *on;

     P chkConfirma     e

       //---------------------------------------------------------------
       // Verifico si la cobertura requiere inspeccion o no
       //---------------------------------------------------------------

     P GetRequiereInspeccion...
     P                 B                    export
     D GetRequiereInspeccion...
     D                 pi             1

     D   k1yer0        ds                  likerec( c1wer0 : *key )

      /free

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       setll %kds( k1yer0 : 5 ) ctwer0;
       reade(n) %kds( k1yer0 : 5 ) ctwer0;
       dow not %eof( ctwer0 );
         if r0ma01 = '1';
           return 'S';
         endif;
        reade(n) %kds( k1yer0 : 5 ) ctwer0;
       enddo;

       return 'N';

      /end-free

     P GetRequiereInspeccion...
     P                 E
      //---------------------------------------------------------------
      // Armado de Id de mensaje para grabar en GNTMSG
      //---------------------------------------------------------------
     P @@msid          b
     D @@msid          pi            25a
     D @@msid          s             25a
     D x               s              2s 0

       for x = 1 to 25;
          random( seed
                : Floater
                : *omit);
          %subst(ran:x:1) = %subst(ALFABETO:%Int(floater*26+1):1);
       endfor;
       return ran;

     P @@msid          e

       //---------------------------------------------------------------
       // Busco el nombre que tiene el asegurado en el gnhdaf
       //---------------------------------------------------------------

     P GetNombreRama...
     P                 B                    export
     D GetNombreRama...
     D                 pi            20

     D   k1ys01        ds                  likerec( s1t001 : *key )

      /free

       k1ys01.t@rama = d0rama;

       chain %kds ( k1ys01 : 1 ) set001;
       if %found();

         return t@ramd;

       endif;

       return *blanks;

      /end-free

     P GetNombreRama...
     P                 E
       //---------------------------------------------------------------
       // Suma asegurada Total de Vida
       //---------------------------------------------------------------

     P GetSumaTotalVida...
     P                 B                    export
     D GetSumaTotalVida...
     D                 pi            15  0

     D   k1yev2        ds                  likerec( c1wev2 : *key )
     D   k1y103        ds                  likerec( s1t103 : *key )
     D   sumtot        s             15  0


      /free

       k1yev2.v2empr = peBase.peEmpr;
       k1yev2.v2sucu = peBase.peSucu;
       k1yev2.v2nivt = peBase.peNivt;
       k1yev2.v2nivc = peBase.peNivc;
       k1yev2.v2nctw = peNctw;
       k1yev2.v2rama = v1rama;
       k1yev2.v2Arse = v1arse;
       k1yev2.v2Poco = v1Poco;

       setll %kds ( k1yev2 : 8 ) ctwev2;
       reade %kds ( k1yev2 : 8 ) ctwev2;
       dow not %eof();

         k1y103.t@rama = v2rama;
         k1y103.t@xpro = v1xpro;
         k1y103.t@riec = v2riec;
         k1y103.t@cobc = v2xcob;
         k1y103.t@mone = w0mone;

         chain %kds( k1y103 : 5 ) set103;
         if %found();

           if t@baop = 'B';

             sumtot += v2saco;

           endif;

         endif;

         reade %kds ( k1yev2 : 8 ) ctwev2;
       enddo;

       return sumtot;

      /end-free

     P GetSumaTotalVida...
     P                 E
       //---------------------------------------------------------------
       // Porcentaje Capital Parientes
       //---------------------------------------------------------------

     P GetCapitalParientes...
     P                 B                    export
     D GetCapitalParientes...
     D                 pi            15  0

     D   k1y628        ds                  likerec( s1t628 : *key )


      /free

       k1y628.t@arcd = v1Arcd;
       k1y628.t@rama = v1Rama;
       k1y628.t@arse = v1Arse;
       k1y628.t@xpro = v1Xpro;
       k1y628.t@paco = v1paco;

       chain %kds ( k1y628 : 5 ) set628;
       if %found();

         return t@pcap;

       endif;

       return *zeros;

      /end-free

     P GetCapitalParientes...
     P                 E

     P COW310_log...
     P                 B                   export
     D COW310_log...
     D                 pi
     D  peMsg                       256a   const

     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                  32767A   const options(*varsize)
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                32767A   options(*varsize)

     D wwMsgLen        s             10i 0
     D wwTheKey        s              4a
     D MsgText         s            256a

     D APIEscape       ds
     D  AE_Prov                      10i 0 inz(0)
     D  AE_Avail                     10i 0 inz(0)

      /free

        wwMsgLen = %checkr( ' ': peMsg);
        if (wwMsgLen < 1);
         return;
        endif;

        MsgText = peMsg;

        QMHSNDPM( 'CPF9897'
                : 'QCPFMSG   *LIBL'
                : MsgText
                : wwMsgLen
                : '*DIAG'
                : '*'
                : 1
                : wwTheKey
                : ApiEscape );

      /end-free

     P COW310_log...
     P                 E

     P getPoco         B                   export
     D getPoco         pi             4  0
     D  pePoco                        4  0
     D  peArra                        4  0 dim(9999)

     D x               s              4  0

       if w0tiou = 3;
          return pePoco;
       endif;

       x = %lookup( pePoco : peArra );

       if x = *Zeros;
         x = %lookup( *Zeros : peArra );
         peArra ( x ) = pePoco;
       endif;

       return x;

     P getPoco         E

     P getPocoV        B                   export
     D getPocoV        pi             6  0
     D  pePoco                        6  0
     D  peArra                        6  0 dim(999999)

     D x               s              6  0

       if w0tiou = 3;
          return pePoco;
       endif;

       x = %lookup( pePoco : peArra );

       if x = *Zeros;
         x = %lookup( *Zeros : peArra );
         peArra ( x ) = pePoco;
       endif;

       return x;

     P getPocoV        E
      *********************************************************************
      * getClausulas : Retorna Clausulas.-                                *
      *                                                                   *
      *     peBase    (input)  Parametros Base                            *
      *     peArcd    (input)  Cod. Artículo                              *
      *     peRama    (input)  Rama                                       *
      *     peArse    (input)  Cant. Poliza por Rama/Art                  *
      *     peNctw    (input)  Nro de Cotizacion                          *
      *     peMone    (output) Moneda                                     *
      *     peClau    (output) Cod. de Clausulas                          *
      *     peClauC   (output) Cantidad de Clausulas                      *
      *                                                                   *
      * Retorna : *On / *Off                                              *
      *********************************************************************
     P getClausulas    B
     D getClausulas    pi              n
     D  peBase                             likeDs(paramBase) const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNctw                        7  0 const
     D  peMone                        2    const
     D  peClau                             likeds( dsClau_t )
     D  x              s             10i 0
     D  y              s             10i 0

     D  k1y623         ds                  likeRec( s1t623 : *key )
     D  k1y103         ds                  likeRec( s1t103 : *key )
     D  k1yev1         ds                  likeRec( c1wev1 : *key )
     D  k1yev2         ds                  likeRec( c1wev2 : *key )
     D  @@clau         s              3    dim(99)

      /free

       clear peClau;
       clear x;

       @@clau(*) = '999';

       k1y623.t@arcd = peArcd;
       k1y623.t@rama = peRama;
       k1y623.t@arse = peArse;
       chain %kds( k1y623 : 3 ) set623;
       if %found( set623 );

         if t@cl01 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl01;
         endif;

         if t@cl02 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl02;
         endif;

         if t@cl03 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl03;
         endif;

         if t@cl04 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl04;
         endif;

         if t@cl05 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl05;
         endif;

         if t@cl06 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl06;
         endif;

         if t@cl07 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl07;
         endif;

         if t@cl08 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl08;
         endif;

         if t@cl09 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl09;
         endif;

         if t@cl10 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl10;
         endif;

         if t@cl11 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl11;
         endif;

         if t@cl12 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl12;
         endif;

         if t@cl13 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl13;
         endif;

         if t@cl14 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl14;
         endif;

         if t@cl15 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl15;
         endif;

         if t@cl16 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl16;
         endif;

         if t@cl17 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl17;
         endif;

         if t@cl18 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl18;
         endif;

         if t@cl19 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl19;
         endif;

         if t@cl20 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl20;
         endif;

         if t@cl21 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl21;
         endif;

         if t@cl22 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl22;
         endif;

         if t@cl23 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl23;
         endif;

         if t@cl24 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl24;
         endif;

         if t@cl25 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl25;
         endif;

         if t@cl26 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl26;
         endif;

         if t@cl27 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl27;
         endif;

         if t@cl28 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl28;
         endif;

         if t@cl29 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl29;
         endif;

         if t@cl30 <> *blanks;
           x        += 1;
           @@clau(x) = t@cl30;
         endif;
       endif;

       // Vida...
       k1yev1.v1empr = peBase.peEmpr;
       k1yev1.v1sucu = peBase.peSucu;
       k1yev1.v1nivt = peBase.peNivt;
       k1yev1.v1nivc = peBase.peNivc;
       k1yev1.v1nctw = peNctw;
       setll %kds( k1yev1 : 5 ) ctwev1;
       reade %kds( k1yev1 : 5 ) ctwev1;
       dow not %eof( ctwev1 );
         k1yev2.v2empr = v1empr;
         k1yev2.v2sucu = v1sucu;
         k1yev2.v2nivt = v1nivt;
         k1yev2.v2nivc = v1nivc;
         k1yev2.v2nctw = v1nctw;
         k1yev2.v2rama = v1rama;
         k1yev2.v2arse = v1arse;
         k1yev2.v2poco = v1poco;
         k1yev2.v2paco = v1paco;
         setll %kds( k1yev2 : 9 ) ctwev2;
         reade %kds( k1yev2 : 9 ) ctwev2;
         dow not %eof( ctwev2 );

           k1y103.t@rama = v2rama;
           k1y103.t@xpro = v1xpro;
           k1y103.t@riec = v2riec;
           k1y103.t@cobc = v2xcob;
           k1y103.t@mone = peMone;
           chain %kds( k1y103 : 5 ) set103;
           if %found( set103 );
             if t@cl01 <> *blanks;
               if %lookup(t@cl01 : @@clau : 1) = *Zeros;
                 x          += 1;
                 @@clau( x ) = t@cl01 ;
               endif;
             endif;

             if t@cl02 <> *blanks;
               if %lookup(t@cl02 : @@clau : 1) = *Zeros;
                 x          += 1;
                 @@clau( x ) = t@cl02 ;
               endif;
             endif;

             if t@cl03 <> *blanks;
               if %lookup(t@cl03 : @@clau : 1) = *Zeros;
                 x          += 1;
                 @@clau( x ) = t@cl03 ;
               endif;
             endif;

             if t@cl04 <> *blanks;
               if %lookup(t@cl04 : @@clau : 1) = *Zeros;
                 x          += 1;
                 @@clau( x ) = t@cl04;
               endif;
             endif;

             if t@cl05 <> *blanks;
               if %lookup(t@cl05 : @@clau : 1) = *Zeros;
                 x          += 1;
                 @@clau( x ) = t@cl05;
               endif;
             endif;

           endif;

          reade %kds( k1yev2 : 9 ) ctwev2;
         enddo;

        reade %kds( k1yev1 : 5 ) ctwev1;
       enddo;

       if x = 0;
          return *off;
       endif;

       sorta @@clau;
       x = %lookup('999':@@clau);
       for y = x to 99;
           @@clau(y) = *blanks;
       endfor;

       peClau.ca01 = @@clau(1);
       peClau.ca02 = @@clau(2);
       peClau.ca03 = @@clau(3);
       peClau.ca04 = @@clau(4);
       peClau.ca05 = @@clau(5);
       peClau.ca06 = @@clau(6);
       peClau.ca07 = @@clau(7);
       peClau.ca08 = @@clau(8);
       peClau.ca09 = @@clau(9);
       peClau.ca10 = @@clau(10);
       peClau.ca11 = @@clau(11);
       peClau.ca12 = @@clau(12);
       peClau.ca13 = @@clau(13);
       peClau.ca14 = @@clau(14);
       peClau.ca15 = @@clau(15);
       peClau.ca16 = @@clau(16);
       peClau.ca17 = @@clau(17);
       peClau.ca18 = @@clau(18);
       peClau.ca19 = @@clau(19);
       peClau.ca20 = @@clau(20);
       peClau.ca21 = @@clau(21);
       peClau.ca22 = @@clau(22);
       peClau.ca23 = @@clau(23);
       peClau.ca24 = @@clau(24);
       peClau.ca25 = @@clau(25);
       peClau.ca26 = @@clau(26);
       peClau.ca27 = @@clau(27);
       peClau.ca28 = @@clau(28);
       peClau.ca29 = @@clau(29);
       peClau.ca30 = @@clau(30);

       return *on;

      /end-free

     P getClausulas    e
      *********************************************************************
      * getAnexos : Retorna Anexos.-                                      *
      *                                                                   *
      *     peBase    (input)  Parametros Base                            *
      *     peArcd    (input)  Cod. Artículo                              *
      *     peRama    (input)  Rama                                       *
      *     peArse    (input)  Cant. Poliza por Rama/Art                  *
      *     peNctw    (input)  Nro de Cotizacion                          *
      *     peMone    (input)  Moneda                                     *
      *     peAnex    (output) Cod. de Anexos                             *
      *                                                                   *
      * Retorna : *On / *Off                                              *
      *********************************************************************
     P getAnexos       B
     D getAnexos       pi              n
     D  peBase                             likeDs(paramBase) const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNctw                        7  0 const
     D  peMone                        2    const
     D  peAnex                             likeds( dsAnex_t )

     D  x              s             10i 0
     D  y              s             10i 0
     D  z              s             10i 0
     D  @@anex         s              1    dim(99)
     D  @2anex         s              1    dim(99)

     D  k1y623         ds                  likeRec( s1t623 : *key )
     D  k1y103         ds                  likeRec( s1t103 : *key )
     D  k1yev1         ds                  likeRec( c1wev1 : *key )
     D  k1yev2         ds                  likeRec( c1wev2 : *key )

      /free

       clear peAnex;
       clear x;

       k1y623.t@arcd = peArcd;
       k1y623.t@rama = peRama;
       k1y623.t@arse = peArse;
       chain %kds( k1y623 : 3 ) set623;
       if %found( set623 );

         if t@an01 <> *blanks;
           x        += 1;
           @@anex(x) = t@an01;
         endif;

         if t@an02 <> *blanks;
           x        += 1;
           @@anex(x) = t@an02;
         endif;

         if t@an03 <> *blanks;
           x        += 1;
           @@anex(x) = t@cl03;
         endif;

         if t@an04 <> *blanks;
           x        += 1;
           @@anex(x) = t@an04;
         endif;

         if t@an05 <> *blanks;
           x        += 1;
           @@anex(x) = t@an05;
         endif;

         if t@an06 <> *blanks;
           x        += 1;
           @@anex(x) = t@an06;
         endif;

         if t@an07 <> *blanks;
           x        += 1;
           @@anex(x) = t@an07;
         endif;

         if t@an08 <> *blanks;
           x        += 1;
           @@anex(x) = t@an08;
         endif;

         if t@an09 <> *blanks;
           x        += 1;
           @@anex(x) = t@an09;
         endif;

         if t@an10 <> *blanks;
           x        += 1;
           @@anex(x) = t@an10;
         endif;

         if t@an11 <> *blanks;
           x        += 1;
           @@anex(x) = t@an11;
         endif;

         if t@an12 <> *blanks;
           x        += 1;
           @@anex(x) = t@an12;
         endif;

         if t@an13 <> *blanks;
           x        += 1;
           @@anex(x) = t@an13;
         endif;

         if t@an14 <> *blanks;
           x        += 1;
           @@anex(x) = t@an14;
         endif;

         if t@an15 <> *blanks;
           x        += 1;
           @@anex(x) = t@an15;
         endif;

         if t@an16 <> *blanks;
           x        += 1;
           @@anex(x) = t@an16;
         endif;

         if t@an17 <> *blanks;
           x        += 1;
           @@anex(x) = t@an17;
         endif;

         if t@an18 <> *blanks;
           x        += 1;
           @@anex(x) = t@an18;
         endif;

         if t@an19 <> *blanks;
           x        += 1;
           @@anex(x) = t@an19;
         endif;

         if t@an20 <> *blanks;
           x        += 1;
           @@anex(x) = t@an20;
         endif;

         if t@an21 <> *blanks;
           x        += 1;
           @@anex(x) = t@an21;
         endif;

         if t@an22 <> *blanks;
           x        += 1;
           @@anex(x) = t@an22;
         endif;

         if t@an23 <> *blanks;
           x        += 1;
           @@anex(x) = t@an23;
         endif;

         if t@an24 <> *blanks;
           x        += 1;
           @@anex(x) = t@an24;
         endif;

         if t@an25 <> *blanks;
           x        += 1;
           @@anex(x) = t@an25;
         endif;

         if t@an26 <> *blanks;
           x        += 1;
           @@anex(x) = t@an26;
         endif;

         if t@an27 <> *blanks;
           x        += 1;
           @@anex(x) = t@an27;
         endif;

         if t@an28 <> *blanks;
           x        += 1;
           @@anex(x) = t@an28;
         endif;

         if t@an29 <> *blanks;
           x        += 1;
           @@anex(x) = t@an29;
         endif;

         if t@an30 <> *blanks;
           x        += 1;
           @@anex(x) = t@an30;
         endif;
       endif;

       // Vida...
       k1yev1.v1empr = peBase.peEmpr;
       k1yev1.v1sucu = peBase.peSucu;
       k1yev1.v1nivt = peBase.peNivt;
       k1yev1.v1nivc = peBase.peNivc;
       k1yev1.v1nctw = peNctw;
       setll %kds( k1yev1 : 5 ) ctwev1;
       reade %kds( k1yev1 : 5 ) ctwev1;
       dow not %eof( ctwev1 );
         k1yev2.v2empr = v1empr;
         k1yev2.v2sucu = v1sucu;
         k1yev2.v2nivt = v1nivt;
         k1yev2.v2nivc = v1nivc;
         k1yev2.v2nctw = v1nctw;
         k1yev2.v2rama = v1rama;
         k1yev2.v2arse = v1arse;
         k1yev2.v2poco = v1poco;
         k1yev2.v2paco = v1paco;
         setll %kds( k1yev2 : 9 ) ctwev2;
         reade %kds( k1yev2 : 9 ) ctwev2;
         dow not %eof( ctwev2 );

           k1y103.t@rama = v2rama;
           k1y103.t@xpro = v1xpro;
           k1y103.t@riec = v2riec;
           k1y103.t@cobc = v2xcob;
           k1y103.t@mone = peMone;
           chain %kds( k1y103 : 5 ) set103;
           if %found( set103 );
             if t@an01 <> *blanks;
               if %lookup(t@an01 : @@anex : 1) = *Zeros;
                 x          += 1;
                 @@anex( x ) = t@an01 ;
               endif;
             endif;

             if t@an02 <> *blanks;
               if %lookup(t@an02 : @@anex : 1) = *Zeros;
                 x          += 1;
                 @@anex( x ) = t@an02 ;
               endif;
             endif;

             if t@an03 <> *blanks;
               if %lookup(t@an03 : @@anex : 1) = *Zeros;
                 x          += 1;
                 @@anex( x ) = t@an03 ;
               endif;
             endif;

             if t@an04 <> *blanks;
               if %lookup(t@an04 : @@anex : 1) = *Zeros;
                 x          += 1;
                 @@anex( x ) = t@an04;
               endif;
             endif;

             if t@an05 <> *blanks;
               if %lookup(t@an05 : @@anex : 1) = *Zeros;
                 x          += 1;
                 @@Anex( x ) = t@an05;
               endif;
             endif;

           endif;

          reade %kds( k1yev2 : 9 ) ctwev2;
         enddo;

        reade %kds( k1yev1 : 5 ) ctwev1;
       enddo;

       if x = *zeros;
          return *off;
       endif;

       sorta @@anex;
       for y = 1 to 99;
           if @@anex(y) <> ' ';
              z += 1;
              @2anex(z) = @@anex(y);
           endif;
       endfor;

       @@anex = @2anex;

       peAnex.an01 = @@anex(1);
       peAnex.an02 = @@anex(2);
       peAnex.an03 = @@anex(3);
       peAnex.an04 = @@anex(4);
       peAnex.an05 = @@anex(5);
       peAnex.an06 = @@anex(6);
       peAnex.an07 = @@anex(7);
       peAnex.an08 = @@anex(8);
       peAnex.an09 = @@anex(9);
       peAnex.an10 = @@anex(10);
       peAnex.an11 = @@anex(11);
       peAnex.an12 = @@anex(12);
       peAnex.an13 = @@anex(13);
       peAnex.an14 = @@anex(14);
       peAnex.an15 = @@anex(15);
       peAnex.an16 = @@anex(16);
       peAnex.an17 = @@anex(17);
       peAnex.an18 = @@anex(18);
       peAnex.an19 = @@anex(19);
       peAnex.an20 = @@anex(20);
       peAnex.an21 = @@anex(21);
       peAnex.an22 = @@anex(22);
       peAnex.an23 = @@anex(23);
       peAnex.an24 = @@anex(24);
       peAnex.an25 = @@anex(25);
       peAnex.an26 = @@anex(26);
       peAnex.an27 = @@anex(27);
       peAnex.an28 = @@anex(28);
       peAnex.an29 = @@anex(29);
       peAnex.an30 = @@anex(30);

       return *on;

      /end-free

     P getAnexos       e
