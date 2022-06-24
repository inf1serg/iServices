     H nomain debug(*YES)
      * ************************************************************ *
      * COWHOG: Cotización Hogar                                     *
      * ------------------------------------------------------------ *
      * Luis Roberto Gómez                   08-Sep-2015             *
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
      *> TEXT('Prorama de Servicio: Cotización Hogar') <*        *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWHOG)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWHOG)) <*         *
      *> IGN: DLTSPLF FILE(COWHOG)                           <*     *
      * ************************************************************ *
      * Modificaciones:                                              *
      * 15/12/15 - Se realizaron cambios de parametros               *
      * 18/01/16 - Se agregan Validaciones de Coberturas             *
      * SGF 05/08/2016: Recompilo por ACRC en CTWET0/ER0.            *
      * SFA 18/08/2016: Recompilo por cambios en el BND              *
      * SGF 18/08/2016: Agrego _calculaCaracteristicas() como dummy. *
      * SFA 19/08/2016: Agrego _calculaCaracteristicas() con logica. *
      * SFA 31/08/2016: Cambio procedimiento COWGRAI_deleteImpuestos *
      *                 por COWGRAI_deleteImpuesto                   *
      * LRG 22/09/2016: Si plan es Cerrado no Requiere Inspeccion    *
      * SGF 04/10/2016: Reglas de Inspección:                        *
      *                 Incendio Edificio > 10.000.000               *
      *                 Robo (en conjunto)> 250.000                  *
      * SGF 01/11/2016: Depreco _caracIsValid() y la reemplazo por   *
      *                 _caracIsValid2().                            *
      * LRG 06/12/2016: Modifico COWHOG_calculaCaracteristicas:      *
      *                 Si Caracteristica no tiene marca por defecto *
      *                 ma01 = 'N' y no se permite tildar ma03 ='N'  *
      *                 la misma no se muestra                       *
      * SGF 09/01/2017: Modifica _cobCombinado, no se permiten       *
      *                 coberturas con suma asegurada en Cero.-      *
      * LRG 23/01/2017: _calculaCaracteristicas: Buen resultado      *
      *                 especial, se valida que para un determinado  *
      *                 productor se le permita o no seleccionar     *
      *                 dicha característica aunque esta no le       *
      *                 corresponda.-                                *
      * LRG 24/03/2017: Se corrige clave de acceso al set107 dentro  *
      *                 del procedimiento COWHOG_cobCombinado        *
      * SGF 27/03/2017: Grabo R2PRSA rescatandola de SET1031.        *
      * LRG 04/04/2017: Se corrige calculo de Impuestos en Hogar     *
      *                 Cerrados.                                    *
      * LRG 18/04/2017: Se graba marca de Requiere Inspeccion en     *
      *                 ctwer0 --> r0ma01 = '1' ==> 'S'              *
      *                            r0ma01 = '0' ==> 'N'              *
      * JSN 14/02/2018: Ajustar sumas, segun manual operativo, los   *
      *                 cambios se realizaron en el procedimiento    *
      *                 _GetRequiereInspeccion                       *
      * JSN 02/05/2018: Agrego procedimientos: _chkRenovacion        *
      *                                        _chkPlanesHabilWeb    *
      *                                        _cantidadUbicacRies   *
      *                                        _chkPlandePagoHabWeb  *
      *                                        _getInfoHogar         *
      *                                        _cotizarWeb2          *
      * JSN 02/07/2018: Se modifica procedimiento _caracIsValid2, si *
      *                 el tipo de operación es renovación, busca    *
      *                 Superpóliza Relacionada.                     *
      * SGF 17/09/2018: Renovación no requiere inspeccion.           *
      * EXT 26/09/2018: Recompilo por SVPVIV                         *
      * EXT 16/10/2018: Se modifica COWHOG_chkRenovacion,            *
      *                 SPVSPO_chkCuotasPendientes se reemplaza con  *
      *                 SPVSPO_getCuotasImpagas.                     *
      * EXT 02/11/2018: Se modifica COWHOG_chkRenovacion,            *
      *                 SPVSPO_getCuotasImpagas se reemplaza por     *
      *                 SPVSPO_getCuotasImpagasMes                   *
      * LRG 29/10/2018. Recompilacion por cambio en servicio svpriv  *
      * JSN 28/02/2019  Recompilacion por cambio en la estructura    *
      *                 PAHASE_T                                     *
      * JSN 18/02/2019  Se agrega en el procedimiento _chkRenovacion *
      *                 las validaciones: - Moneda habilitada Web    *
      *                 - Tipo de Documento habilitado Web (cuando   *                 
      *                 es Persona Fisica).                          *
      *                 - CUIT valido (cuando es Persona Juridica).  *
      *                 - Código de Iva de asegurado habilitado Web. *
      *                 - Código de Iva de superpóliza habilitado    *
      *                 Web.                                         *
      *                 - Modificación en la validación de asegurado *
      *                 este relacionado al productor.               *
      * JSN 25/03/2019  Se actualiza el límite de inspección, en el  *
      *                 procedimiento _getRequiereInspeccion de la   *
      *                 cobertura de Incendio Edificio a $20.000.000.*
      * SGF 02/05/2019: Cuando es un productor con buen resultado    *
      *                 especial, debo aumentar un tramo en la reno  *
      *                 siempre que siga en el período anterior no   *
      *                 haya tenido siniestros.                      *
      * SGF 11/06/2019: Sumar BURE anterior sólo cuando era nueva.   *
      * JSN 14/06/2019: Se actualiza el límite de inspección, en el  *
      *                 procedimiento _getRequiereInspeccion para la *
      *                 cobertura de Robo a 1.000.000. Modificacion  *
      *                 en COWHOG_cotizarWeb2                        *
      *                                                              *
      * LRG 26/06/2019: Se recompila por cambio en CTW001, campo vacc*
      * GIO 09/08/2019: RM#5396 Se reajusta la suma asegurada en     *
      *                 funcion de la dependencia entre coberturas   *
      * SGF 11/05/2020: Agrego _topearCoberturas().                  *
      * JSN 29/05/2020: Se agrega modificaciones en el procedimiento *
      *                 _GetRequiereInspeccion, Se aumenta los limi- *
      *                 tes de los montos y se agrega condición en   *
      *                 las coberturas 59 y 60.                      *
      * LRG 11/05/2020: Incorpora validacion de coberturas dadas     *
      *                 de baja para no incorporar la misma en la    *
      *                 renovacion                                   *
      * JSN 22/03/2021: Se modifica los procedimientos _getInfo2 y   *
      *                 _chkRenovacion, para condicionar consorcio   *
      * SGF 23/04/2021: Parametrizo limites de inspeccion en SET117. *
      * NWN 02/06/2021  Cambio de DIM para las Clausulas.            *
      *                 Antes de 5 , ahora de 200                    *
      *                 RecuperaTasaSumAseg - PAR314C1               *
      * JSN 09/08/2021: Se movio el llamado al programa COWRTV4, se  *
      *                 agrega condiciones.                          *
      * ************************************************************ *
     Fctw000    if   e           k disk    usropn
     Fctw001    uf   e           k disk    usropn
     Fctw001c   uf   e           k disk    usropn
     Fctwer0    uf a e           k disk    usropn
     Fctwer2    uf a e           k disk    usropn
     Fctwer4    if   e           k disk    usropn
     Fctwer6    uf a e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fpahed003  if   e           k disk    usropn
     Fpaher0    if   e           k disk    usropn
     Fset100    if   e           k disk    usropn
     Fset106    if   e           k disk    usropn
     Fset160    if   e           k disk    usropn
     Fset123    if   e           k disk    usropn
     Fset107    if   e           k disk    usropn prefix(t7:2)
     Fset1031   if   e           k disk    usropn prefix(t3:2)
     Fset102w   if   e           k disk    usropn
     Fpaher9    if   e           k disk    usropn
     Fset117    if   e           k disk    usropn
      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/cowhog_h.rpgle'

     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrN            s             10i 0
     D ErrM            s             80a

     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

     D COWGRA8         pr                  extpgm('COWGRA8')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peNrpp                        3  0 const
     D  peCond                             likeds(Condcome) dim(99) const
     D  peCondC                      10i 0 const
     D  peImpu                             likeds(primPrem) dim(99)
     D  peImpuC                      10i 0
     D  pePrem                       15  2
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWRTV4         pr                  ExtPgm('COWRTV4')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peCond                             likeds(condCome2_t) dim(99)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)


     D*SetError        pr
     D* peErrn                       10i 0 const
     D* peErrm                       80a   const

     D par314c1        pr                  extpgm('PAR314C1')
     D                                2  0 const
     D                                3  0 const
     D                                3a   const
     D                                3  0 const
     D                                2a   const
     D                               15  2 const
     D                                9  6
     D                               15  2
     D                                2a
     D                                3a   dim(200)
     D                               15  2 options(*omit:*nopass)

     DSPBRRV           pr                  extpgm('SPBRRV')
     D  empr                          1    const
     D  sucu                          2    const
     D  arcd                          6  0 const
     D  spol                          9  0 const
     D  rama                          2  0 const
     D  arse                          2  0 const
     D  poco                          4  0 const
     D  anio                          2  0
     D  pbre                          5  2
     D  rdes                         40    options (*Omit:*Nopass)
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

     D PRO401U3        pr                  extpgm('PRO401U3')
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2

     D PRO401U1        pr                  extpgm('PRO401U1')
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2

     D WSLUBP          pr                  extpgm('WSLUBP')
     D  peBase                             likeds(parambase) const
     D  peCant                       10i 0 const
     D  peRoll                        1    const
     D  pePosi                             likeds(keyubp_t) const
     D  pePreg                             likeds(keyubp_t)
     D  peUreg                             likeds(keyubp_t)
     D  peLubi                             likeds(pahrsvs_t) dim(99)
     D  peLubic                      10i 0
     D  peMore                         n
     D  peErro                             like(paramerro)
     D  peMsgs                             likeds(parammsgs)

     D WSLUBT          pr                  ExtPgm('WSLUBT')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyubt_t) const
     D   pePreg                            likeds(keyubt_t)
     D   peUreg                            likeds(keyubt_t)
     D   peCubi                            likeds(pahrsvs6_t) dim(99)
     D   peCubiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUBR          pr                  ExtPgm('WSLUBR')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peSpol                        9  0 const
     D  pePoco                        4  0 const
     D  peLryc                             likeds(pahrsvs1_t) dim(99)
     D  peLrycC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D DXP021          pr                  ExtPgm('DXP021')
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peFemd                        2  0 const
     D  peAnul                        1
     D  peFpgm                        3    const

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     DSPGETPSUA        pr                  extpgm('SPGETPSUA')
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peRetu                        2  0

     D WSLASE          pr                  ExtPgm('WSLASE')
     D  peBase                             likeds(paramBase) const
     D  peAsen                        7  0 const
     D  peDase                             likeds(pahase_t)
     D  peMase                             likeds(dsMail_t) dim(100)
     D  peMaseC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D   peImpu7       ds                  likeds(primPrem) dim(99)
     D   peImpuC       s             10i 0
     D   pePrem7       s             15  2

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * COWHOG_cotizarWeb: Cotiza un Bien Asegurado de una Rama de   *
      *                    Hogar.                                    *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePoco (input)  Nro. de Componente                    *
      *        peXpro (input)  Código de Plan(Producto)              *
      *        peTviv (input)  Tipo de Vivienda                      *
      *        peCara (input)  Características de Bien               *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peScta (input)  Zona de Riesgo                        *
      *        peBure (input)  Código de Buen Resultado              *
      *        peNrrp (input)  Plan de Pago                          *
      *        peTipe (input)  Tipo de Forma de Pago                 *
      *        peCiva (input)  Condicion de IVA                      *
      *        peCobe (input)  Coberturas (Primas)                   *
      *        peSuma (output) Suma Asegurada Total                  *
      *        peInsp (output) Requiere Inspección                   *
      *        peBoni (output) Bonificaciones por Coberturas         *
      *        peImpu (output) Impuestos                             *
      *        pePrem (output) Premio                                *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_cotizarWeb...
     P                 B                    export
     D COWHOG_cotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peNrrp                       3  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peSuma                      13  2
     D   peInsp                       1
     D   peBoni                            likeds(Bonific) dim(200)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrem                      13  2
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   X             s             10i 0
     D   @@Boni        ds                  likeds(Bonific) dim(99999)inz
     D   @@BoniC       s             10i 0
     D   @@Impu        ds                  likeds(Impuesto)
     D   @@xpri        s              9  6
     D   @@prim        s             15  2
     D   @@prit        s             15  2
     D   p@Seri        s             15  2
     D   p@Seem        s             15  2
     D   p@Impi        s             15  2
     D   p@Sers        s             15  2
     D   p@Tssn        s             15  2
     D   p@Ipr1        s             15  2
     D   p@Ipr4        s             15  2
     D   p@Ipr3        s             15  2
     D   p@Ipr6        s             15  2
     D   p@Ipr7        s             15  2
     D   p@Ipr8        s             15  2
     D   p@Ipr9        s             15  2

     D   p@Anio        s              2  0
     D   p@Pbre        s              5  2
     D   p@Arcd        s              6  0
     D   @@Cfpg        s              1  0

      /free

       COWHOG_inz();

       peError = *zeros;

       //ArcdRamaArse
       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ) : 'X' );
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peError = -1;
           return;

        endif;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase
                                                             : peNctw )
                                       : peNrrp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrrp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peError = -1;
           return;
       endif;

       clear peBoni;
       COWHOG_chkcotizarWeb ( peBase
                            : peNctw
                            : peRama
                            : peArse
                            : pePoco
                            : peXpro
                            : peTviv
                            : peCara
                            : peCopo
                            : peCops
                            : peScta
                            : peBure
                            : @@Cfpg
                            : peTipe
                            : peCiva
                            : peCobe
                            : peError
                            : peMsgs  );

       if peError <> *Zeros;
         return;
       endif;

       //Elimino info de la cotización.

       COWGRAI_deletePoco ( peBase : peNctw : peRama : peArse : pePoco );

       COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );

       COWGRAI_updCotizacion ( peBase
                             : peNctw
                             : peCiva
                             : peTipe
                             : peCopo
                             : peCops
                             : @@Cfpg
                             : peNrrp );

       //Graba Cabecera de Riesgos Varios. CTWER0
       COWHOG_saveCabeceraRV( peBase
                            : peNctw
                            : peRama
                            : peArse
                            : pePoco
                            : peCopo
                            : peCops
                            : peXpro
                            : peTviv );

       for x = 1 to 20;
        if peCobe(x).xcob <> 0;
         //Graba Coberturas Riesgos Varios - CTWER2
         COWHOG_saveCoberturasRv( peBase
                                : peNctw
                                : peRama
                                : pexPro
                                : peArse
                                : pePoco
                                : peCobe(x).riec
                                : peCobe(x).xcob
                                : peCobe(x).sac1 );
        endif;
       endfor;

       for x = 1 to 50;
        //Graba Características Riesgos Varios - CTWER6
        if peCara(x).ccba <> 0;

         //actualizo las caracteristicas como deben estar

         p@arcd = COWGRAI_getArticulo ( peBase : peNctw );

         SPBRRV ( peBase.peEmpr : peBase.peSucu : p@Arcd : 0 :
                  peRama : peArse : pePoco : p@anio : p@pbre );

         COWHOG_SaveCaracteristicas( PeBase
                                   : PeNctw
                                   : PeRama
                                   : PeArse
                                   : PePoco
                                   : PeCara(x).ccba
                                   : peCara(x).ma01m
                                   : peCara(x).ma02m );
        endif;
       endfor;

       //Graba Descuentos - CTWER4
       SVPDRC_setDesc( peBase
                     : peNctw
                     : peRama
                     : peArse
                     : pePoco
                     : pexpro );

       // Graba Impuestos - CTW001
       COWGRAI_SaveImpuestos( peBase
                            : peNctw
                            : peRama
                            : peArse );


       for x = 1 to 20;
        if peCobe(x).xcob <> 0;
        //Actualiza Tasa y Prima - CTWER2
         SVPDRC_updDesc( peBase
                       : peNctw
                       : peRama
                       : peArse
                       : pePoco
                       : peCobe(x).xcob );
        endif;
       endfor;

       @@prit = *zeros;

       // Devuelve Pormilaje / Prima
       for x = 1 to 20;
        if peCobe(x).xcob <> 0;

         @@xpri = *zeros;
         @@prim = *zeros;

         COWHOG_GetPormilajePrima( peBase
                                 : peNctw
                                 : peRama
                                 : pexPro
                                 : peArse
                                 : pePoco
                                 : peCobe(x).riec
                                 : peCobe(x).xcob
                                 : @@xpri
                                 : @@prim );
         peCobe(x).xpri = @@xpri;
         peCobe(x).prim = @@prim;
         @@prit = @@prit + @@prim;
        endif;
       endfor;

       COWGRAI_setDerechoEmi ( peBase :
                               peNctw :
                               peRama :
                               @@prit );

       //Actualiza importes - CTWER0
       COWHOG_UpdCabeceraRV( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : pePoco );

       // Devuelve Suma Asegurada Total
       peSuma = COWHOG_GetSumaAsegCobertura( peBase
                                           : peNctw
                                           : peRama
                                           : peArse
                                           : pePoco );

       // Determina Si se Requiere Inspección...
       COWHOG_setRequiereInspeccion( peBase
                                   : peNctw
                                   : peRama
                                   : peArse
                                   : pePoco
                                   : peXpro
                                   : peCobe );
       //...
       peInsp = COWHOG_GetInspeccion( peBase
                                    : peNctw
                                    : peRama
                                    : peArse
                                    : pePoco );
       clear @@Boni;
       // Devuelve Bonificaciones Por Coberturas
       if COWHOG_GetBoniCobertura( peBase
                                 : peNctw
                                 : peRama
                                 : peArse
                                 : pePoco
                                 : @@Boni
                                 : @@BoniC );

        peBoni = @@boni;
       endif;

       COWGRAI_getPremioFinal ( peBase : peNctw );
       if SVPVAL_chkPlanCerrado( peRama
                               : peXpro
                               : COWGRAI_monedaCotizacion( peBase
                                                         : peNctw));

         COWHOG_planesCerrados ( peBase
                               : peNctw
                               : peRama
                               : peArse
                               : pePoco );
       endif;

       clear @@Impu;
       // Devuelve Impuestos Por Coberturas
       COWGRAI_getImpuestos( peBase
                           : peNctw
                           : peRama
                           : COWHOG_GetPrima( peBase
                                            : peNctw
                                            : peRama
                                            : peArse
                                            : pePoco )
                           : COWHOG_GetSumaAsegCobertura( peBase
                                                        : peNctw
                                                        : peRama
                                                        : peArse
                                                        : pePoco )
                           : peCopo
                           : peCops
                           : @@Impu );

       peImpu(1) = @@Impu;
       peImpu(1).cobl = *all'X';

       // Graba Importes de Impuestos - CTW002
       p@Seri = peImpu(1).Seri;
       p@Seem = peImpu(1).Seem;
       p@Impi = peImpu(1).Impi;
       p@Sers = peImpu(1).Sers;
       p@Tssn = peImpu(1).Tssn;
       p@Ipr1 = peImpu(1).Ipr1;
       p@Ipr4 = peImpu(1).Ipr4;
       p@Ipr3 = peImpu(1).Ipr3;
       p@Ipr6 = peImpu(1).Ipr6;
       p@Ipr7 = peImpu(1).Ipr7;
       p@Ipr8 = peImpu(1).Ipr8;
       p@Ipr9 = *zeros;

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


       // Devuelve Premio...
       pePrem = COWHOG_getPremio( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : pePoco );

       clear peImpu7;

     P COWHOG_cotizarWeb...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_chkcotizarWeb: Chequear datos ingresados en una solic-*
      *                        itud de Cotizacion de Hogar.          *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePoco (input)  Nro. de Componente                    *
      *        peXpro (input)  Código de Plan(Producto)              *
      *        peTviv (input)  Tipo de Vivienda                      *
      *        peCara (input)  Características de Bien               *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peScta (input)  Zona de Riesgo                        *
      *        peBure (input)  Código de Buen Resultado              *
      *        peCfpg (input)  Código de Forma de pago               *
      *        peTipe (input)  Tipo de Forma de Pago                 *
      *        peCiva (input)  Condicion de IVA                      *
      *        peCobe (input)  Coberturas (Primas)                   *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_chkcotizarWeb...
     P                 B                    export
     D COWHOG_chkcotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peCfpg                       1  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   X             s             10i 0
     D   p@Anio        s              2  0
     D   p@Pbre        s              5  2
     D   p@Arcd        s              6  0

     D   p@Lcob        s              3  0 dim(20)
     D   p@LcobC       s             10i 0
     D sumTot          s             15  2

     D k1t100          ds                  likerec(s1t100:*key)

      /free


       COWHOG_inz();


       //Validaciones...
        //ParmBase...
         if not SVPWS_chkParmBase ( peBase : peMsgs );
            peError = -1;
            return;
         endif;

        //Valido Cotización
          if not COWGRAI_chkCotizacion ( peBase : peNctw );
            ErrM = COWGRAI_Error(ErrN);
             if COWGRAI_COTNP    = ErrN;

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

            peError = -1;
            return;
          endif;

        //Rama...
          if not SVPVAL_ramaWeb(peRama);
            ErrM = COWGRAI_Error(ErrN);
             if COWGRAI_COTNP   = ErrN;
              %subst(wrepl:1:2) = %editc(peRama:'X');

              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0020'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );
             endif;
             peError = -1;
             return;
          endif;

       //Valido Componente <> 0
       if pePoco = *Zeros;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0118'
                      : peMsgs );

         peError = -1;
         return;

       endif;

       //Valido que sea una rama de Hogar
       if SVPWS_getGrupoRama ( peRama ) <> 'C' and
          SVPWS_getGrupoRama ( peRama ) <> 'H' and
          SVPWS_getGrupoRama ( peRama ) <> 'R' and
          SVPWS_getGrupoRama ( peRama ) <> 'O';

         %subst(wrepl:1:2) = %editc(peRama:'X');

         SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0073'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

        //Código de Plan...
          if not SVPVAL_chkRamaPlan( peRama
                                   : peXpro );

          %subst(wrepl:1:2) = %editc(peRama:'X');
          %subst(wrepl:3:6) = %editc(peXpro:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0080'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peError = -1;
           return;
          endif;

         // Si es Plan Cerrado debe ser unico.-
         if not COWGRAI_ValPlanCerradoUnico( peBase
                                           : peNctw
                                           : peRama
                                           : pePoco
                                           : peXpro );

         ErrM = COWGRAI_Error(ErrN);

         if  COWGRAI_PLANCP = ErrN;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0125'
                        : peMsgs     );
         endif;

         if  COWGRAI_PLANCE =  ErrN;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0126'
                        : peMsgs     );
         endif;

           peError = -1;
           return;
         endif;

        // ---------------------------------------
        // Si es plan cerrado, sólo puede ser
        // para Consumidor Final
        // Pedido por Claudio Medina
        // ---------------------------------------
        k1t100.t@rama = peRama;
        k1t100.t@xpro = peXpro;
        k1t100.t@mone = COWGRAI_monedaCotizacion( peBase : peNctw );
        chain %kds(k1t100) set100;
        if %found;
           if t@prem <> 0;
              if peCiva <> 5;
                 SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'COW0139'
                              : peMsgs     );
                 peError = -1;
                 return;
              endif;
           endif;
        endif;

        //Tipo de vivienda Web...
          if not SVPVIV_chkWebViv( peTviv );

            %subst(wrepl:1:3) = %editc(peTviv:'X');

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0081'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
           peError = -1;
           return;
          endif;


        //Características del Bien...
          for x = 1 to 50;
           if Pecara(x).ccba <> 0;
            if not SVPVAL_chkCaracBien( peBase
                                      : peRama
                                      : Pecara(x).ccba );

              %subst(wrepl:1:3) = %editc(Pecara(x).ccba : 'X');
              %subst(wrepl:4:5) = %editc(Perama : 'X');

              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0082'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );
             peError = -1;
             return;
            endif;


           endif;
          endfor;

        //Valida que las caracteristicas pertenezcan al Plan.-
          if not COWHOG_ValSelCaracPlan ( peBase
                                        : peNctw
                                        : peRama
                                        : peXpro
                                        : peCara
                                        : peError
                                        : peMsgs );

            return;
          endif;

        //Validamos todas las caracteristicas y que no tengan errores

          if not COWHOG_caracIsValid2( peBase :
                                       peNctw :
                                       peRama :
                                       pePoco :
                                       peCopo :
                                       peCops :
                                       peCara :
                                       peErroR:
                                       peMsgs );

            peError = -1;
            return;

          endif;

        //Código Postal...
          if not SVPVAL_codigoPostalWeb ( peCopo : peCops );
           ErrM = SVPVAL_Error(ErrN);

            if SVPVAL_COPNE = ErrN;

             %subst(wrepl:1:5) = %editc( peCopo : 'X' );
             %subst(wrepl:7:1) = %editc( peCops : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0014'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
            endif;
            peError = 1;
            return;
           endif;

        //Zona de Riesgo...
          if not SVPVAL_zonaDeRiego( peScta );

           ErrM = SVPVAL_Error(ErrN);

            if SVPVAL_ZONFV    = ErrN;
             %subst(wrepl:1:1) = %editc( peScta : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0023'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
            endif;
             peError = 1;
             return;
           endif;

        //Código de Buen Resultado...
          if not SVPVAL_chkCodBuenR( peBure );

            %subst(wrepl:1:1) = %editc( peBure : 'X' );

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0083'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
            peError = -1;
            return;

          endif;

        //Forma de Pago...
          if not SVPVAL_formaDePagoWeb ( peCfpg );

           ErrM = SVPVAL_Error(ErrN);

           if SVPVAL_FDPNW     = ErrN;

             %subst(wrepl:1:1) =  %editc ( peCfpg : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0026'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
           endif;

            peError = -1;
            return;
          endif;

        //Tipo de Persona...
          if not SVPVAL_tipoPersona ( peTipe );

           ErrM = SVPVAL_Error(ErrN);

            if SVPVAL_TPENV    = ErrN;

             %subst(wrepl:1:1) =  peTipe;

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0015'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
            endif;
             peError = -1;
             return;
           endif;

       //Valida IVA
       if SVPVAL_ivaWeb ( peCiva ) = *off;

         ErrM = SVPVAL_Error(ErrN);

         if SVPVAL_IVANE = ErrN;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_IVANW = ErrN;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0012'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         endif;

         peError = -1;
         return;
       endif;

       //Coberturas Combinado...

         if COWHOG_cobCombinado ( peRama : peCobe : peMsgs ) = *off;
           peError = -1;
           return;
         endif;

         // ------------------------------------
         // Sumatoria de coberturas
         // ------------------------------------
         sumTot = 0;
         for x = 1 to 20;
             if peCobe(x).xcob <> 0;
                sumTot += peCobe(x).sac1;
             endif;
         endfor;
         k1t100.t@rama = peRama;
         k1t100.t@xpro = peXpro;
         k1t100.t@mone = COWGRAI_monedaCotizacion(peBase:peNctw);
         chain %kds(k1t100) set100;
         if %found;
            if sumTot < t@sac1 or sumTot > t@sac2;
               %subst(wrepl:01:20) = %editw(t@sac1:' .   .   .   . 0 ,  ');
               %subst(wrepl:21:20) = %editw(t@sac2:' .   .   .   . 0 ,  ');
               %subst(wrepl:41:20) = %editw(sumTot:' .   .   .   . 0 ,  ');
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0141'
                            : peMsgs   );
               peError = -1;
               return;
            endif;
         endif;

       //Coberturas(Prima)...
         for x = 1 to 20;
          if peCobe(x).xcob <> 0;
           if not SVPVAL_chkCobPrima( peRama
                                    : peXpro
                                    : peCobe(x).riec
                                    : peCobe(x).xcob
                                    : COWGRAI_monedaCotizacion( peBase
                                                              : peNctw));

             %subst(wrepl:1:3) =  peCobe(x).riec;
             %subst(wrepl:4:3) =  %editc( peCobe(x).xcob : 'X' );
             %subst(wrepl:7:2) =  %editc( peRama : 'X' );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0036'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peError = -1;
             return;
           endif;
          endif;
         endfor;

       // Valida coberturas excluyentes - Reglas - Cob. Básicas.-
       clear p@Lcob;
       clear p@LcobC;

       for x = 1 to 20;

        if peCobe(x).xcob <> 0;

          p@Lcob(x) = peCobe(x).xcob;
          p@LcobC += 1;

        endif;

       endfor;

       if not SVPCOB_ValCoberturasBasicas( peRama
                                         : peXpro
                                         : peCobe(1).riec
                                         : COWGRAI_monedaCotizacion( peBase
                                                                   : peNctw)
                                         : p@Lcob  );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0123'
                      : peMsgs     );
         peMsgs.peMsg2 = SVPCOB_Error();

         peError = -1;
         return;

       endif;

       if not SVPCOB_ValListCobExcluyentes ( peRama :
                                             peXpro :
                                             peCobe(1).riec :
                                             COWGRAI_monedaCotizacion( peBase
                                                                     : peNctw):
                                             p@Lcob  :
                                             p@LcobC );


         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0121'
                      : peMsgs     );
         peMsgs.peMsg2 = SVPCOB_Error();

         peError = -1;
         return;
       endif;

       if not SVPCOB_ValListCobReglas ( peRama :
                                        peXpro :
                                        peCobe(1).riec :
                                        COWGRAI_monedaCotizacion( peBase
                                                                : peNctw):
                                        p@Lcob  :
                                        p@LcobC );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0122'
                      : peMsgs     );
         peMsgs.peMsg2 = SVPCOB_Error();

         peError = -1;
         return;
       endif;

         // Valida la suma asegurada ingresada por cobertura
         for x = 1 to 20;
          if peCobe(x).xcob <> 0;
           if not SVPVAL_CHKCobSumMaxMin( peRama
                                        : peXpro
                                        : peCobe(x).riec
                                        : peCobe(x).xcob
                                        : COWGRAI_monedaCotizacion( peBase
                                                                  : peNctw)
                                        : peCobe(x).sac1
                                        : peCobe         );

             %subst(wrepl:1:40) =  %trim( SVPDES_cobLargo ( peRama :
                                                            peCobe(x).xcob));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0021'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             peError = -1;
             return;
           endif;
          endif;
         endfor;
       /end-free

     P COWHOG_chkcotizarWeb...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_ReCotizarWeb: ReCotiza un Bien Asegurado de una Rama  *
      *                      de Hogar.                               *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePoco (input)  Nro. de Componente                    *
      *        peXpro (input)  Código de Plan(Producto)              *
      *        peTviv (input)  Tipo de Vivienda                      *
      *        peCara (input)  Características de Bien               *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peScta (input)  Zona de Riesgo                        *
      *        peBure (input)  Código de Buen Resultado              *
      *        peNrpp (input)  Plan de Pagos                         *
      *        peTipe (input)  Tipo de Forma de Pago                 *
      *        peCiva (input)  Condicion de IVA                      *
      *        peCobe (input)  Coberturas (Primas)                   *
      *        peSuma (output) Suma Asegurada Total                  *
      *        peInsp (output) Requiere Inspección                   *
      *        peBoni (output) Bonificaciones por Coberturas         *
      *        peImpu (output) Impuestos                             *
      *        pePrem (output) Premio                                *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_ReCotizarWeb...
     P                 B                    export
     D COWHOG_ReCotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peNrrp                       3  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peSuma                      13  2
     D   peInsp                       1
     D   peBoni                            likeds(Bonific)  dim(200)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrem                      13  2
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   X             s             10i 0
     D   @@Cfpg        s              1  0

      /free

       COWHOG_inz();

       //Valido Estado ReCotización
       if COWGRAI_chkEstCotizacion ( peBase : peNctw ) = *off;
         ErrM = COWGRAI_Error(ErrN);

         if COWGRAI_COTTR = ErrN;

           %subst(wrepl:1:7) = %editc(peNctw:'X');
           %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0037'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;
         return;
       endif;

       peError = *zeros;
       //ArcdRamaArse
       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ) : 'X' );
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peError = -1;
           return;

        endif;
       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase
                                                             : peNctw )
                                       : peNrrp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrrp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peError = -1;
           return;
       endif;

       //Limpia variables de salida...
       for x = 1 to 20;
        peCobe(x).xpri = *zeros;
        peCobe(x).prim = *zeros;
       endfor;

       peInsp = 'N';
       pePrem = *zeros;

       COWHOG_cotizarWeb ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco
                         : peXpro
                         : peTviv
                         : peCara
                         : peCopo
                         : peCops
                         : peScta
                         : peBure
                         : peNrrp
                         : peTipe
                         : peCiva
                         : peCobe
                         : peSuma
                         : peInsp
                         : peBoni
                         : peImpu
                         : pePrem
                         : peError
                         : peMsgs );

      /end-free

     P COWHOG_ReCotizarWeb...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_saveCabeceraRV(): Cabecera Riesgos Varios             *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peCopo   (input)   Código Postal                         *
      *     peCops   (input)   Sufijo del Codigo Postal              *
      *     peXpro   (input)   Código de Plan(Producto)              *
      *     peTviv   (input)   Tipo de Vivienda                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_saveCabeceraRV...
     P                 B                   export
     D COWHOG_saveCabeceraRV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const

     D k1yer0          ds                  likerec( c1wer0 : *Key )
     D k1yloc          ds                  likerec( g1tloc : *Key )

      /free

       COWHOG_inz();

       k1yer0.r0empr = peBase.peempr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.penivt;
       k1yer0.r0nivc = peBase.penivC;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0poco = pePoco;
       k1yer0.r0arse = peArse;
       chain %kds( k1yer0 ) ctwer0;
        if %found( ctwer0 );
         return;
        endif;

        r0empr = peBase.peempr;
        r0sucu = peBase.peSucu;
        r0nivt = peBase.penivt;
        r0nivc = peBase.penivC;
        r0nctw = peNctw;
        r0rama = peRama;
        r0poco = pePoco;
        r0arse = peArse;
        r0xpro = peXpro;
        r0rpro = COWGRAI_GetCodProInd ( peCopo
                                      : peCops );
        r0rloc = COWGRAI_GetCodProInd ( peCopo
                                      : peCops );
        r0rdep = *zeros;
        r0blck = *blanks;
        r0rdes = *blanks;
        r0nrdm = *zeros;
        r0copo = peCopo;
        r0cops = peCops;
        r0suas = *zeros;
        r0samo = *zeros;
        r0cviv = peTviv;
        COWGRAI_getDatosCapituloHogar ( peRama :
                                        peXpro :
                                        r0ctar :
                                        r0cta1 :
                                        r0clfr :
                                        r0cagr );

        chain ( peRama ) set123;
        if t@mar1 = '1';
          r0psmp = 100;
        else;
          r0psmp = *zeros;
        endif;

        r0ma01 = *blanks;
        r0ma02 = *blanks;
        r0ma03 = *blanks;
        r0ma04 = *blanks;
        r0ma05 = *blanks;
        r0crea = 'N ';
        write c1wer0;

        return;

      /end-free
     P COWHOG_saveCabeceraRV...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_saveCoberturasRv(): Graba Coberturas Riesgos Varios   *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_saveCoberturasRv...
     P                 B                   export
     D COWHOG_saveCoberturasRv...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peSaco                      13  2 const

     D  @@Xpri         s              9  6 inz
     D  @@Ptco         s             15  2 inz
     D  @@Cls          s              3a   dim(200) inz
     D  @@Tpcd         s              2a          inz

     D   k1yer2        ds                  likerec( c1wer2 : *key )
     D k1t103          ds                  likerec( s1t1031: *key )

      /free

       COWHOG_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = peRiec;
       k1yer2.r2xcob = peCobe;
       chain %kds( k1yer2 ) ctwer2;
       if %found( ctwer2 );
        return;
       endif;

       r2empr = peBase.peEmpr;
       r2sucu = peBase.peSucu;
       r2nivt = peBase.peNivt;
       r2nivc = peBase.peNivc;
       r2nctw = peNctw;
       r2rama = peRama;
       r2arse = peArse;
       r2poco = pePoco;
       r2riec = peRiec;
       r2xcob = peCobe;
       r2Saco = peSaco;

       COWHOG_RecuperaTasaSumAseg( peRama
                                 : peXpro
                                 : peRiec
                                 : peCobe
                                 : COWGRAI_monedaCotizacion( peBase
                                                           : peNctw )
                                 : peSaco
                                 : @@Xpri
                                 : @@Ptco
                                 : @@Tpcd
                                 : @@Cls  );

       if @@Ptco = *zeros;
        r2ptco = ( ( peSaco * @@Xpri ) / 1000 );
       else;
        r2ptco = @@Ptco;
       endif;

       r2xpri = @@Xpri;
       k1t103.t3rama = peRama;
       k1t103.t3xpro = peXpro;
       k1t103.t3riec = peRiec;
       k1t103.t3cobc = peCobe;
       k1t103.t3mone = COWGRAI_monedaCotizacion( peBase : peNctw );
       chain %kds(k1t103) set1031;
       if not %found;
          t3prsax = 0;
       endif;
       r2prsa = t3prsax;
       r2ma01 = *blanks;
       r2ma02 = *blanks;
       r2ma03 = *blanks;
       r2ma04 = *blanks;

       write c1wer2;

       return;

      /end-free
     P COWHOG_saveCoberturasRv...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_GetPormilajePrima(): Graba Coberturas Riesgos Varios  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Pormilaje                             *
      *     pePrim   (output)  Prima                                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_GetPormilajePrima...
     P                 B                   export
     D COWHOG_GetPormilajePrima...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peXpri                       9  6
     D   pePrim                      15  2

     D   k1yer2        ds                  likerec( c1wer2 : *key )
      /free

       COWHOG_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       k1yer2.r2riec = peRiec;
       k1yer2.r2xcob = peCobe;
       chain(N) %kds( k1yer2 ) ctwer2;
       if %found ( ctwer2 );
        peXpri = r2xpri;
        pePrim = r2ptco;
       endif;
        return;

      /end-free
     P COWHOG_GetPormilajePrima...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_RecuperaTasaSumAseg...                                *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura                             *
      *     peMone   (input)   Moneda                                *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Prima por milaje                      *
      *     pePtco   (output)  Prima                                 *
      *     peTpcd   (output)  Codigo de Texto Preseteado            *
      *     peCls    (output)  Clausula                              *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_RecuperaTasaSumAseg...
     P                 B                   export
     D COWHOG_RecuperaTasaSumAseg...
     D                 pi
     D   peRama                       3  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3a   const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peSaco                      15  2 const
     D   peXpri                       9  6
     D   pePtco                      15  2
     D   peTpcd                       2a
     D   peCls                        3a   dim(200)

       /free

       COWHOG_inz();

        par314c1 ( peRama
                 : peXpro
                 : peRiec
                 : peCobc
                 : peMone
                 : peSaco
                 : peXpri
                 : pePtco
                 : peTpcd
                 : peCls  );

       /end-free
     P COWHOG_RecuperaTasaSumAseg...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_DltCaracteristicas...                                 *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_DltCaracteristicas...
     P                 B                   export
     D COWHOG_DltCaracteristicas...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yer6        ds                  likerec( c1wer6 : *key )

       /free

        COWHOG_inz();

        k1yer6.r6empr = PeBase.peEmpr;
        k1yer6.r6sucu = PeBase.peSucu;
        k1yer6.r6nivt = PeBase.peNivt;
        k1yer6.r6nivc = PeBase.peNivc;
        k1yer6.r6nctw = PeNctw;
        k1yer6.r6rama = PeRama;
        k1yer6.r6arse = PeArse;
        k1yer6.r6poco = PePoco;
        setll %kds( k1yer6 : 8 ) ctwer6;
        reade %kds( k1yer6 : 8 ) ctwer6;
        dow not %eof;
         delete c1wer6;
         reade %kds( k1yer6 : 8 ) ctwer6;
        enddo;

       /end-free

     P COWHOG_DltCaracteristicas...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_SaveCaracteristicas...                                *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *     PeCara   (input)  Cod. Caracteristica                    *
      *     PeMa01   (input)  Tiene o no tiene                       *
      *     PeMa02   (input)  Aplica o no Bonif/Rec                  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_SaveCaracteristicas...
     P                 B                   export
     D COWHOG_SaveCaracteristicas...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCara                       3  0 const
     D   PeMa01                       1    const
     D   PeMa02                       1    const

     D   k1yer6        ds                  likerec( c1wer6 : *key )

      /free

         k1yer6.r6empr = PeBase.peEmpr;
         k1yer6.r6sucu = PeBase.peSucu;
         k1yer6.r6nivt = PeBase.peNivt;
         k1yer6.r6nivc = PeBase.peNivc;
         k1yer6.r6nctw = PeNctw;
         k1yer6.r6rama = PeRama;
         k1yer6.r6arse = PeArse;
         k1yer6.r6poco = PePoco;
         k1yer6.r6ccba = PeCara;
         chain %kds( k1yer6 ) ctwer6;
         if %found( ctwer6 );
            return;
         endif;

         r6empr = PeBase.peEmpr;
         r6sucu = PeBase.peSucu;
         r6nivt = PeBase.peNivt;
         r6nivc = PeBase.peNivc;
         r6nctw = PeNctw;
         r6rama = PeRama;
         r6arse = PeArse;
         r6poco = PePoco;
         r6ccba = PeCara;
         r6ma01 = PeMa01;
         r6ma02 = PeMa02;
         write c1wer6;
         return;

      /end-free

     P COWHOG_SaveCaracteristicas...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_GetSumaAsegCobertura...                               *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_GetSumaAsegCobertura...
     P                 B                   export
     D COWHOG_GetSumaAsegCobertura...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   @@Suas        s             15  2 inz

     D   k1yer2        ds                  likerec( c1wer2 : *key )

      /free

       COWHOG_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       setll %kds( k1yer2 : 8 ) ctwer2;
       reade %kds( k1yer2 : 8 ) ctwer2;
       dow not %eof( ctwer2 );
         @@Suas += r2saco;
        reade %kds( k1yer2 : 8 ) ctwer2;
       enddo;
       return @@suas;

      /end-free
     P COWHOG_GetSumaAsegCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_UpdCabeceraRV...                                      *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNctw   (input)  Nro de Cotizacion                      *
      *     peRama   (input)  Rama                                   *
      *     peArse   (input)  Cant. de Articulos                     *
      *     pePoco   (input)  Componente                             *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_UpdCabeceraRV...
     P                 B                   export
     D COWHOG_UpdCabeceraRV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yer0        ds                  likerec( c1wer0 : *key )

      /free

       COWHOG_inz();

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivC;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0poco = pePoco;
       k1yer0.r0arse = peArse;
       chain %kds( k1yer0 ) ctwer0;
       if %found( ctwer0 );
        r0suas = COWHOG_GetSumaAsegCobertura( peBase
                                            : peNctw
                                            : peRama
                                            : peArse
                                            : pePoco );

        update c1wer0;
       endif;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivC;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0poco = pePoco;
       k1yer0.r0arse = peArse;
       chain %kds( k1yer0 ) ctwer0;
       if %found( ctwer0 );

        r0sast = COWHOG_getSumaSiniestrablePoco ( peBase
                                                : peNctw
                                                : peRama
                                                : peArse
                                                : pePoco );
        r0prim = COWHOG_GetPrima( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : pePoco ) ;
        update c1wer0;
       endif;

        return;

      /end-free
     P COWHOG_UpdCabeceraRV...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_GetBoniCobertura...                                   *
      *                                                              *
      *     peNctw   (input)  Parametros Base                        *
      *     peRama   (input)  Rama                                   *
      *     peArse   (input)  Cant Articulos                         *
      *     pePoco   (input)  Nro Componente                         *
      *     peBoni   (input)  Bonificiacion                          *
      *     peBonC   (input)  Cant. Bonificaciones                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_GetBoniCobertura...
     P                 B                   export
     D COWHOG_GetBoniCobertura...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peBoni                            likeds(Bonific) dim(200)
     D   peBoniC                     10i 0

     D   @@Boni        ds                  likeds(Bonific) dim(99999)
     D   @@BoniC       s             10i 0

     D   k1yer4        ds                  likerec( c1wer4 : *key )

      /free

       COWHOG_inz();
       clear @@Boni;
       @@BoniC = *zeros;

      *- Obtiene Bonificaciones;
       k1yer4.r4empr = peBase.peEmpr;
       k1yer4.r4sucu = peBase.peSucu;
       k1yer4.r4nivt = peBase.peNivt;
       k1yer4.r4nivc = peBase.peNivc;
       k1yer4.r4nctw = peNctw;
       k1yer4.r4rama = peRama;
       k1yer4.r4arse = peArse;
       k1yer4.r4poco = pePoco;
       setll %kds( k1yer4 : 8 ) ctwer4;
        if not %equal( ctwer4 );
         return *off;
        endif;

       reade %kds( k1yer4 : 8 ) ctwer4;
       dow not %eof( ctwer4 );

         @@BoniC += 1;
         @@Boni(@@BoniC).xcob = r4xcob;
         @@Boni(@@BoniC).ccbp = r4ccbp;
         @@Boni(@@BoniC).dcbp = SVPDES_codBonificacionRV( peBase.peEmpr
                                                        : peBase.peSucu
                                                        : r4Ccbp );
         @@Boni(@@BoniC).nive = r4nive;
         @@Boni(@@BoniC).pbon = r4boni;
         @@Boni(@@BoniC).prec = r4reca;

        reade %kds( k1yer4 : 8 ) ctwer4;
       enddo;

       peBoni  =  @@Boni;
       peBoniC =  @@BoniC;
       return *on;

      /end-free

     P COWHOG_GetBoniCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_GetPrima(): Obtener Prima Total                       *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_GetPrima...
     P                 B                   export
     D COWHOG_GetPrima...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   @@ptco        s             15  2 inz

     D   k1yer2        ds                  likerec( c1wer2 : *key )

      /free

       COWHOG_inz();

       k1yer2.r2empr = peBase.peEmpr;
       k1yer2.r2sucu = peBase.peSucu;
       k1yer2.r2nivt = peBase.peNivt;
       k1yer2.r2nivc = peBase.peNivc;
       k1yer2.r2nctw = peNctw;
       k1yer2.r2rama = peRama;
       k1yer2.r2arse = peArse;
       k1yer2.r2poco = pePoco;
       setll %kds( k1yer2 : 8 ) ctwer2;
       reade %kds( k1yer2 : 8 ) ctwer2;
       dow not %eof( ctwer2 );
         @@ptco += r2ptco;
        reade %kds( k1yer2 : 8 ) ctwer2;
       enddo;
       return @@ptco;

      /end-free
     P COWHOG_GetPrima...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_getPremio(): Obtener Premio                           *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_getPremio...
     P                 B                   export
     D COWHOG_getPremio...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1y001        ds                    likerec( c1w001 : *key )

       COWHOG_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds ( k1y001 : 6 ) ctw001;

       return w1prem;

     P COWHOG_getPremio...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_getSumaSiniestrablePoco: Suma Siniestrable            *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * Retorna Suma / 0                                             *
      * ------------------------------------------------------------ *
     P COWHOG_getSumaSiniestrablePoco...
     P                 B                    export
     D COWHOG_getSumaSiniestrablePoco...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const

     D   k1y000        ds                    likerec( c1w000 : *key )
     D   k1yer0        ds                    likerec( c1wer0 : *key )
     D   k1yhr0        ds                    likerec( p1her0 : *key )
     D   k1yed0        ds                    likerec( p1hed003 : *key )

      /free

       COWHOG_inz();

       // Obtengo Tipo de Operacion
       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds( k1y000 : 5 ) ctw000;

       // Obtengo Cabecera de Componente
       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0poco = pePoco;
       chain %kds( k1yer0 : 7 ) ctwer0;
       if not %found( ctwer0 ) ;
        return 0;
       else;
        select;
         when ( w0tiou = 1 );
          return r0suas;
         when ( w0tiou = 2 );
           return r0suas;
         when ( w0tiou = 3 );
          // Obtengo Suma de Endoso Anterior
          k1yed0.d0empr = peBase.peEmpr;
          k1yed0.d0sucu = peBase.peSucu;
          k1yed0.d0arcd = w0arcd;
          k1yed0.d0spol = w0spol;
          k1yed0.d0rama = r0rama;
          k1yed0.d0arse = r0arse;

          setgt %kds( k1yed0 : 6 ) pahed003;
          readpe %kds( k1yed0 : 6 ) pahed003;

          dow not %eof ( pahed003 );

           // Tomo el Endoso que Corresponde
           if ( d0tiou = 1 or d0tiou = 2 or d0tiou = 3 ) and
              ( d0stos <> 08 and d0stos <> 09 );

           // Voy al PAHER0
           k1yhr0.r0empr = r0empr;
           k1yhr0.r0sucu = r0sucu;
           k1yhr0.r0arcd = r0arcd;
           k1yhr0.r0spol = r0spol;
           k1yhr0.r0sspo = r0sspo;
           k1yhr0.r0rama = r0rama;
           k1yhr0.r0arse = r0arse;
           k1yhr0.r0oper = r0oper;
           k1yhr0.r0poco = pePoco;
           chain %kds( k1yhr0 : 9 ) paher0;

           // el primero es el actual menos el anterior
           return r0suas - r0suas;

          endif;

          readpe %kds( k1yed0 : 6 ) pahed003;

         enddo;

        endsl;

       endif;

       return *Zeros;

      /end-free

     P COWHOG_getSumaSiniestrablePoco...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_GetRequiereInspeccion(): Devuelve si requiere Inspec- *
      *                                 cion.                        *
      *     peRama (input)  Rama                                     *
      *     peCobe (input)  Coberturas                               *
      *                                                              *
      * Retorna S/ N                                                 *
      * ------------------------------------------------------------ *
     P COWHOG_GetRequiereInspeccion...
     P                 B                    export
     D COWHOG_GetRequiereInspeccion...
     D                 pi             1
     D   peRama                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)const

     D Inspeccion      ds
     D  @@insp                             dim(99)
     D   rmrs                         2  0 overlay( @@insp : *NEXT )
     D   impo                        15  2 overlay( @@insp : *NEXT )

     D   k1y106        ds                  likerec( s1t106 : *key )
     D   x             s             10i 0
     D   y             s             10i 0
     D   z             s             10i 0

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D sum1            s             15  2
     D sum2            s             15  2
     D sum3            s             15  2
     D hoy             s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0

      /free

       COWHOG_inz();

       //
       // Me voy a buscar los parametros
       //
       sum1 = 9999999999999,99;
       sum2 = 9999999999999,99;
       sum3 = 9999999999999,99;
       PAR310X3( 'A' : peFema : peFemm : peFemd );
       hoy = (peFema * 10000)
           + (peFemm *   100)
           +  peFemd;

       setll hoy set117;
       read set117;
       dow not %eof;
           if t@fech <= hoy;
              sum1 = t@sum1;
              sum2 = t@sum2;
              sum3 = t@sum3;
              leave;
           endif;
        read set117;
       enddo;

       clear Inspeccion;
       for x = 1 to 20;
        if peCobe(x).xcob <> 0;

           if peCobe(x).xcob = 13 and peCobe(x).sac1 > sum1;
              return 'S';
           endif;

           if ( peCobe(x).xcob = 59 or peCobe(x).xcob = 60 ) and
                peCobe(x).sac1 >= sum2;
              return 'S';
           endif;

         k1y106.t@rama = peRama;
         k1y106.t@riec = peCobe(x).riec;
         k1y106.t@cobc = peCobe(x).xcob;
         chain %kds( k1y106 ) set106;
         if %found( set106 );
          z = %lookup(t@rmrs : rmrs );
          if z = 0;
           z = %lookup( 0 : rmrs );
           rmrs(z) = t@rmrs;
           impo(z) = peCobe(x).sac1;
          else;
           impo(z) += peCobe(x).sac1;
          endif;
         endif;
        endif;
       endfor;

       z = %lookup( 9 : rmrs );
       if z <> 0;
         if impo(z) > sum3;
           return 'S';
         endif;
       endif;

       return 'N';

      /end-free

     P COWHOG_GetRequiereInspeccion...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_setCondCarac() Valida valor de Caracteristicas que    *
      *                       dependen de alguna condición.          *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubFijo Postal                        *
      *     peAnio   (input)   Año de Buen Reasultado                *
      *     peCara   (input)   Código de característica              *
      *     peMa01   (input)   Marca tiene o no tiene                *
      *     peMa02   (input)   marca Aplica o no Aplica              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWHOG_setCondCarac...
     P                 B                     export
     D COWHOG_setCondCarac...
     D                 pi              n
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peAnio                        2  0 const
     D  peCara                        3  0 const
     D  peMa01                        1
     D  peMa02                        1

     D  k1yloc         ds                  likerec(g1tloc:*key)
     D  bajoRies       s               n
     D  buenRes1       s               n
     D  buenRes2       s               n
     D  buenRes3       s               n
      /free

       COWHOG_inz();

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;

       chain %kds( k1yloc ) gntloc;
       if lozrrv = 3;
         bajoRies = *On;
       else;
         bajoRies = *Off;
       endif;

       if peAnio = 0;

         buenRes1 = *Off;
         buenRes2 = *Off;
         buenRes3 = *Off;

       elseif peAnio = 1;

         buenRes1 = *On;
         buenRes2 = *Off;
         buenRes3 = *Off;

       elseif peAnio = 2;

         buenRes1 = *On;
         buenRes2 = *On;
         buenRes3 = *Off;

       elseif peAnio = 3;

         buenRes1 = *On;
         buenRes2 = *On;
         buenRes3 = *On;

       endif;

       if peCara = 996;
         if bajoRies;
           peMa01 = 'S';
           peMa02 = 'S';
         else;
           peMa01 = 'N';
           peMa02 = 'N';
         endif;
       endif;

       if peCara = 997;
         if buenRes1;
           peMa01 = 'S';
         else;
           peMa01 = 'N';
         endif;

         if buenRes1 and not buenRes2 and not buenRes3;
           peMa02 = 'S';
         else;
           peMa02 = 'N';
         endif;
       endif;

       if peCara = 998;
         if buenRes2;
           peMa01 = 'S';
         else;
           peMa01 = 'N';
         endif;

         if buenRes2 and not buenRes3;
           peMa02 = 'S';
         else;
           peMa02 = 'N';
         endif;
       endif;

       if peCara = 999;
         if buenRes3;
           peMa01 = 'S';
         else;
           peMa01 = 'N';
         endif;

         if buenRes3;
           peMa02 = 'S';
         else;
           peMa02 = 'N';
         endif;
       endif;

       return *on;

      /end-free

     P COWHOG_setCondCarac...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_caracIsValid() Verifica que las Caracteristicas sean  *
      *                       validas.                               *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        pePoco (input)  Nro. de Componente                    *
      *        peCara (input)  Características de Bien               *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWHOG_caracIsValid...
     P                 B                     export
     D COWHOG_caracIsValid...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D  k1yloc         ds                  likerec(g1tloc:*key)
     D  bajoRies       s               n
     D  buenRes1       s               n
     D  buenRes2       s               n
     D  buenRes3       s               n
     D  p@Anio         s              2  0
     D  p@Pbre         s              5  2
     D  p@Arcd         s              6  0
     D  p@Copo         s              5  0
     D  p@Cops         s              1  0
     D  x              s             10i 0
     D  p@Spol         s              9  0

      /free

       COWHOG_inz();

       COWGRAI_GetCopoCops ( peBase : peNctw : p@Copo : p@Cops );

       p@arcd = COWGRAI_getArticulo ( peBase : peNctw );

       p@Spol = COWGRAI_getSuperpoliza ( peBase : peNctw );

       SPBRRV ( peBase.peEmpr : peBase.peSucu : p@Arcd : p@spol :
                peRama : 1 : pePoco : p@Anio : p@pbre );


       //Valida valor de Caracteristicas que dependen de alguna condicion//

       for x = 1 to 50;

         if not SVPVAL_chkCondCarac ( p@Copo
                                    : p@Cops
                                    : peCara(x).ccba
                                    : peCara(x).ma01m
                                    : peCara(x).ma02m
                                    : p@Anio
                                    : peBase.peEmpr
                                    : peBase.peSucu
                                    : peBase.peNivt
                                    : peBase.peNivc    );

           ErrM = SVPVAL_Error(ErrN);

           if SVPVAL_BRIES = ErrN;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0088'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRIEN = ErrN;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0089'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_RIEBN = ErrN;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0090'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESS = ErrN and p@Anio <= 1;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0091'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESN = ErrN and p@Anio <= 1;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0092'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_ABRES = ErrN and p@Anio <= 1;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0093'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESS = ErrN and p@Anio = 2;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0094'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESN = ErrN and p@Anio = 2;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0095'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_ABRES = ErrN and p@Anio = 2;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0096'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESS = ErrN and p@Anio = 3;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0097'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESN = ErrN and p@Anio = 3;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0098'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_ABRES = ErrN and p@Anio = 3;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0099'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           endif;

           peError = -1;
           return *off;

         endif;

       endfor;

       if COWHOG_validaCarac ( peBase : peRama : peCara ) = *off;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0104'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return *off;

       endif;

       return *on;

      /end-free

     P COWHOG_caracIsValid...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_caracIsValid2()Verifica que las Caracteristicas sean  *
      *                       validas.                               *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        pePoco (input)  Nro. de Componente                    *
      *        peCara (input)  Características de Bien               *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWHOG_caracIsValid2...
     P                 B                     export
     D COWHOG_caracIsValid2...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D  k1yloc         ds                  likerec(g1tloc:*key)
     D  @@DsPo         ds                  likeds(dsPahed0_t) dim(999)
     D  @@DsPoC        s             10i 0
     D  @@DsR9         ds                  likeds(dsPaher9_t) dim(999)
     D  @@DsR9C        s             10i 0
     D  bajoRies       s               n
     D  buenRes1       s               n
     D  buenRes2       s               n
     D  buenRes3       s               n
     D  p@Anio         s              2  0
     D  p@Pbre         s              5  2
     D  p@Arcd         s              6  0
     D  x              s             10i 0
     D  p@Spol         s              9  0
     D  p@Poli         s              7  0
     D  p@Oper         s              7  0
     D  @@Tiou         s              1  0
     D  @@Stou         s              2  0
     D  @@Stos         s              2  0
     D  p@Rdes         s             40

      /free

       COWHOG_inz();

       p@arcd = COWGRAI_getArticulo ( peBase : peNctw );

       COWGRAI_getTipodeOperacion ( peBase : peNctw : @@Tiou : @@Stou : @@Stos);

       if ( @@Tiou = 2 and @@Stou = 0 );

         clear @@DsPo;
         clear @@DsPoC;
         clear @@DsR9;
         clear @@DsR9C;

         p@Spol = COWGRAI_getSuperPolizaReno( peBase : peNctw );

         // Retorna Nro. de Póliza

         p@Poli = SPVSPO_getPoliza( peBase.peEmpr
                                  : peBase.peSucu
                                  : p@Arcd
                                  : p@Spol
                                  : *omit         );

         // Retorna datos de de la póliza para obtener Nro. de operación

         if SVPPOL_getPoliza( peBase.peEmpr
                            : peBase.peSucu
                            : peRama
                            : p@Poli
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : @@DsPo
                            : @@DsPoC       );

           p@Oper = @@DsPo(@@DsPoC).d0Oper;
         endif;

         // Retorna datos del Componente

         if SVPRIV_getComponentes( peBase.peEmpr
                                 : peBase.peSucu
                                 : p@Arcd
                                 : p@Spol
                                 : peRama
                                 : 1
                                 : p@Oper
                                 : pePoco
                                 : @@DsR9
                                 : @@DsR9C       );

           clear p@Rdes;
           p@Rdes = @@DsR9(@@DsR9C).r9Rdes;
           %subst(p@Rdes:36:5) = %editc(@@DsR9(@@DsR9C).r9Nrdm : 'X');

         endif;

         SPBRRV ( peBase.peEmpr : peBase.peSucu : p@Arcd : p@spol :
                  peRama : 1 : pePoco : p@Anio : p@pbre : p@Rdes);

       else; // SuperPoliza relacionada para renovación

         p@Spol = COWGRAI_getSuperpoliza ( peBase : peNctw );

         SPBRRV ( peBase.peEmpr : peBase.peSucu : p@Arcd : p@spol :
                  peRama : 1 : pePoco : p@Anio : p@pbre );

       endif;

       //Valida valor de Caracteristicas que dependen de alguna condicion//

       for x = 1 to 50;

         if not SVPVAL_chkCondCarac ( peCopo
                                    : peCops
                                    : peCara(x).ccba
                                    : peCara(x).ma01m
                                    : peCara(x).ma02m
                                    : p@Anio
                                    : peBase.peEmpr
                                    : peBase.peSucu
                                    : peBase.peNivt
                                    : peBase.peNivc   );

           ErrM = SVPVAL_Error(ErrN);

           if SVPVAL_BRIES = ErrN;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0088'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRIEN = ErrN;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0089'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_RIEBN = ErrN;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0090'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESS = ErrN and p@Anio <= 1;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0091'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESN = ErrN and p@Anio <= 1;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0092'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_ABRES = ErrN and p@Anio <= 1;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0093'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESS = ErrN and p@Anio = 2;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0094'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESN = ErrN and p@Anio = 2;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0095'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_ABRES = ErrN and p@Anio = 2;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0096'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESS = ErrN and p@Anio = 3;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0097'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_BRESN = ErrN and p@Anio = 3;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0098'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           elseif SVPVAL_ABRES = ErrN and p@Anio = 3;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0099'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peError = -1;
            return *off;

           endif;

           peError = -1;
           return *off;

         endif;

       endfor;

       if COWHOG_validaCarac ( peBase : peRama : peCara ) = *off;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0104'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return *off;

       endif;

       return *on;

      /end-free

     P COWHOG_caracIsValid2...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_cobCombinado() Valida que tenga al menos tres cobertu *
      *                       ras y que al menos una sea de incendio *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peCobe   (input)   Coberturas  (Primas)                  *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWHOG_cobCombinado...
     P                 B                     export
     D COWHOG_cobCombinado...
     D                 pi              n
     D   peRama                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peMsgs                            likeds(paramMsgs)

     D  k1y106         ds                  likerec(s1t106:*key)
     D  k1t107         ds                  likerec(s1t107:*key)
     D  x              s             10i 0
     D  contcob        s              5  0
     D  continc        s              5  0
     D  contots        s              5  0

     D robCont         s             15  2
     D incCont         s             15  2

      /free

       COWHOG_inz();

       contcob = 0;
       continc = 0;
       contots = 0;

       robCont = 0;
       incCont = 0;

       for x = 1 to 20;

         if peCobe(x).riec <> *blanks and
            peCobe(x).xcob <> 0;

            if peCobe(x).xcob = 59 or
               peCobe(x).xcob = 60;
               incCont += peCobe(x).sac1;
            endif;

            if peCobe(x).xcob = 220;
               robCont += peCobe(x).sac1;
            endif;

         if peCobe(x).sac1 <= 0;
            k1t107.t7rama = peRama;
            k1t107.t7cobc = peCobe(x).xcob;
            chain %kds(k1t107) set107;
            if not %found;
               t7cobl = *blanks;
            endif;
            %subst(wrepl:1:40) = t7cobl;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0142'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
            return *off;
         endif;

         k1y106.t@rama = peRama;
         k1y106.t@riec = peCobe(x).riec;
         k1y106.t@cobc = peCobe(x).xcob;

         chain %kds ( k1y106 : 3 ) set106;
         if %found();

           contcob += 1;

           if t@rmrs = 1;
             continc += 1;
           else;
             contots += 1;
           endif;

         endif;

        endif;

       endfor;

       if contcob < 3;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0100'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         return *off;
       endif;

       if continc = 0;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0101'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         return *off;
       endif;

       if contots < 2;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0102'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         return *off;
       endif;

       if robCont > incCont;
          %subst(wrepl:1:40) = 'ROBO CONTENIDO GENERAL (MOBILIARIO)';
          %subst(wrepl:41:40)= 'INCENDIO CONTENIDO GENERAL';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0140'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          return *off;
       endif;

       return *on;

      /end-free

     P COWHOG_cobCombinado...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_validaCarac() : Valida caracteristicas ingresadas     *
      *                        para que no se repitan las caracteris-*
      *                        ticas equivalentes.                   *
      *                                                              *
      *     peBase   (input)   Rama                                  *
      *     peRama   (input)   Coberturas  (Primas)                  *
      *     peCara   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWHOG_validaCarac...
     P                 B                     export
     D COWHOG_validaCarac...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peCara                            likeds(Caracbien) dim(50) const

     D  k1y160         ds                  likerec(s1t160:*key)
     D  x              s             10i 0
     D  carequ         s              3    dim(50)

      /free

       COWHOG_inz();

       for x = 1 to 50;

         k1y160.t@empr = peBase.peEmpr;
         k1y160.t@sucu = peBase.peSucu;
         k1y160.t@rama = peRama;
         k1y160.t@ccba = peCara(x).ccba;

         if peCara(x).ma02m = 'S';

           chain %kds ( k1y160 ) set160;

           if %lookup( t@cbae : carequ ) = 0;

             carequ(x) = t@cbae;

           else;

             return *off;

           endif;

         endif;

       endfor;

       return *on;

      /end-free

     P COWHOG_validaCarac...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_planesCerrados(): Calcula Planes Cerrados             *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_planesCerrados...
     P                 B                     export
     D COWHOG_planesCerrados...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const

     D k1y100          ds                   likerec(s1t100:*key)
     D k1yer0          ds                   likerec(c1wer0:*key)
     D k1yer2          ds                   likerec(c1wer2:*key)
     D k1y000          ds                   likerec(c1w000:*key)
     D k1y001          ds                   likerec(c1w001:*key)

     D @@prec          s              5  2
     D @@bpep          s              5  2
     D @@bpip          s              5  2
     D @@bpri          s             15  2
     D @@prim          s             15  2
     D @@subt          s             15  2
     D @@ivat          s             15  2

     D @@prem          s             15  2
     D @@impu          s             15  2

     D @@dere          s             15  2
     D @@refi          s             15  2
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

     D @@form          s              1    inz ('A')

     D @@xpri          s              9  6
     D @@ptco          s             15  2
     D @@tpcd          s              2a
     D @@cls           s              3a   dim(200)
     D @1prem          s             15  2
     D @2prem          s             15  2
     D @3prem          s             15  2
     D xxprem          s             29  9
     D @@suma          s             15  2

     D veces           s             10i 0

       COWHOG_inz();

       @@suma = COWGRAI_getSumaAseguradaRamaArse( peBase
                                                : peNctw
                                                : peRama
                                                : peArse );

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds( k1y000 ) ctw000;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivc;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0poco = pePoco;
       k1yer0.r0arse = peArse;
       chain(n) %kds( k1yer0 ) ctwer0;

       k1y100.t@rama = peRama;
       k1y100.t@xpro = r0xpro;
       k1y100.t@mone = w0mone;
       chain(n) %kds( k1y100 ) set100;

       if ( t@prem = *Zeros );
         return *On;
       else;
         @@prem = *Zeros;
         @1prem = t@prem;

         k1yer2.r2empr = peBase.peEmpr;
         k1yer2.r2sucu = peBase.peSucu;
         k1yer2.r2nivt = peBase.peNivt;
         k1yer2.r2nivc = peBase.peNivc;
         k1yer2.r2nctw = peNctw;
         k1yer2.r2rama = peRama;
         k1yer2.r2poco = pePoco;
         k1yer2.r2arse = peArse;
         setll %kds( k1yer2 : 8 ) ctwer2;
         reade(n) %kds( k1yer2 : 8 ) ctwer2;

         dow not %eof ( ctwer2 );
           PAR314C1 ( r2rama : r0xpro : r2riec : r2xcob : w0mone : r2saco
                    : @@xpri : @@ptco : @@tpcd : @@cls  : @2prem );
           @@prem += @2prem;

           reade(n) %kds( k1yer2 : 8 ) ctwer2;
         enddo;

         @1prem += @@prem;
       endif;


       dou @1prem = @3prem or veces = 10;

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         k1y001.w1rama = peRama;
         chain %kds( k1y001 ) ctw001;

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         k1y001.w1rama = peRama;
         chain %kds( k1y001 ) ctw001c;

         @@prec = *Zeros;
         @@bpep = *Zeros;
         @@bpip = *Zeros;
         @@bpri = *Zeros;

         @@ivat = w1ipr1 + w1ipr3 + w1ipr4;
         @@dere = w1dere;

         @@prim = COWGRAI_getPrimaRamaArse ( peBase :
                                             peNctw :
                                             peRama );

         @@subt = COWGRAI_GetPrimaSubtot ( peBase
                                         : peNctw
                                         : peRama
                                         : @@prim
                                         : @@form );

         if ( t@mar1 = 'D' );
           PRO401U3 ( @1prem : w1prem : @@prec : w1pssn : w1psso : w1pimi
                    : w1seri : w1seem : w1ipr6 : w1ipr2 : w1ipr7 : w1ipr8
                    : w1dere : w1xref : w1xrea : @@bpep : @@prim : @@subt
                    : @@ivat : @@bpip : w1refi : w1read : @@bpri );
         else;
           PRO401U1 ( @1prem : w1prem : @@prec : w1pssn : w1psso : w1pimi
                    : w1seri : w1seem : w1ipr6 : w1ipr2 : w1ipr7 : w1ipr8
                    : @@dere : w1xref : w1xrea : @@bpep : @@prim : @@subt
                    : @@ivat : @@bpip );
         endif;

         update c1w001;
         update c1w001c;

         COWGRAI_getPremioFinal ( peBase : peNctw );

         @3prem = COWHOG_getPremio( peBase
                                  : peNctw
                                  : peRama
                                  : peArse
                                  : pePoco  );

         veces += 1;

       enddo;

       return *On;

     P COWHOG_planesCerrados...
     P                 E
      * ------------------------------------------------------------ *
      * COWHOG_ValSelCaracPlan(): Valida Caracteristicas de un Plan  *
      *                           vs Caracteristicas Seleccionadas   *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peXpro (input)  Plan                                     *
      *     pePcara(input)  Caracteristicas                          *
      *     peError(output) Indicador                                *
      *     peMsgs (output) Estructura de Error                      *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_ValSelCaracPlan...
     P                 B                     export
     D COWHOG_ValSelCaracPlan...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXpro                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
  222D   peError                     10i 0
  222D   peMsgs                            likeds(paramMsgs)

     D   p@Lcar        ds                  likeds(set160_t) dim(999)
     D   p@LcarC       s             10i 0
     D   x             s             10i 0 inz
     D   y             s             10i 0 inz
     D   vCara         s              3  0 dim(50)

     D   k1y160        ds                  likerec( s1t160 : *key )
       /free

         COWHOG_inz();
         // por el momento la validacion no es requerida....
         return *on;
         clear vcara;
         clear y;
         for x = 1 to 50;
          if pecara(x).ccba <> *zeros;
           y += 1;
           vcara(y) = pecara(x).ccba;
          endif;
         endfor;

         clear p@Lcar;
         clear p@LcarC;
         WSLTAB_listaCaracteristicasBien( peBase.peEmpr
                                       : peBase.peSucu
                                       : COWGRAI_getArticulo ( peBase : peNctw )
                                       : peRama
                                       : peXpro
                                       : p@Lcar
                                       : p@LcarC );

         for x = 1 to p@Lcarc;
            if not COWHOG_ValCaracPlan( p@Lcar(x).ccba
                                      : vcara    );

              k1y160.t@empr = peBase.peEmpr;
              k1y160.t@sucu = peBase.peSucu;
              k1y160.t@rama = peRama;
              k1y160.t@ccba = p@Lcar(x).ccba;
              chain %kds( k1y160 : 4 ) set160;
              if not %found( set160);
                clear t@dcba;
              endif;

              %subst(wrepl:1:25) = %trim(t@dcba);

              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0124'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );
             peError = -1;
             return *off;
           endif;
         endfor;

       return *On;
       /end-free

     P COWHOG_ValSelCaracPlan...
     P                 E

      * ------------------------------------------------------------ *
      * COWHOG_ValCaracPlan(): Busca Caracteristica dentro de la     *
      *                           lista seleccionada                 *
      *                                                              *
      *     peCarac(input)  Cod. Caracteristica                      *
      *     pePcara(input)  Caracteristicas Seleccionadas            *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWHOG_ValCaracPlan...
     P                 B                     export
     D COWHOG_ValCaracPlan...
     D                 pi              n
     D   peCara                       3  0 const
     D   peVcar                       3  0 dim(50) const

      /free

         if %lookup( peCara : peVcar : 1 ) <> 0 ;

           return *on;

         endif;

         return *off;

      /end-free
     P COWHOG_ValCaracPlan...
     P                 E

      * ------------------------------------------------------------ *
      * COWHOG_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWHOG_inz      B                   export
     D COWHOG_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(ctwer0);
          open ctwer0;
       endif;

       if not %open(ctwer2);
          open ctwer2;
       endif;

       if not %open(ctwer4);
          open ctwer4;
       endif;

       if not %open(ctwer6);
          open ctwer6;
       endif;

       if not %open(gntloc);
          open gntloc;
       endif;

       if not %open(pahed003);
          open pahed003;
       endif;

       if not %open(paher0);
          open paher0;
       endif;

       if not %open(ctw000);
          open ctw000;
       endif;

       if not %open(set106);
          open set106;
       endif;

       if not %open(set160);
          open set160;
       endif;

       if not %open(set123);
          open set123;
       endif;

       if not %open(ctw001);
          open ctw001;
       endif;

       if not %open(ctw001c);
          open ctw001c;
       endif;

       if not %open(set100);
          open set100;
       endif;

       if not %open(set107);
          open set107;
       endif;

       if not %open(set1031);
          open set1031;
       endif;

       if not %open(set102w);
          open set102w;
       endif;

       if not %open(paher9);
          open paher9;
       endif;

       if not %open(set117);
          open set117;
       endif;

       initialized = *ON;
       return;

      /end-free

     P COWHOG_inz      E

      * ------------------------------------------------------------ *
      * COWHOG_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWHOG_End      B                   export
     D COWHOG_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P COWHOG_End      E

      * ------------------------------------------------------------ *
      * COWHOG_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWHOG_Error    B                   export
     D COWHOG_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P COWHOG_Error    E

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
      * COWHOG_calculaCaracteristicas(): Este procedimiento calcula  *
      *                        qué características debe tener una    *
      *                        determinada ubicación, duplicando la  *
      *                        lógica de PAR314L.                    *
      *                                                              *
      *  Fue ideado para poder renderizar el "subfile" de caracterís-*
      *  ticas en el .xhtml de Hogar Abierto, pero puede usarse para *
      *  todas las ramas de RV.                                      *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Secuencia de Rama en Artículo         *
      *        peXpro (input)  Código de Producto                    *
      *        peCopo (input)  Código Postal de la ubicación         *
      *        peCops (input)  Sufijo Código Postal de la ubicación  *
      *        peRdes (input)  Ubicación del Riesgo *blanks en Nueva *
      *        peCara (output) Características de Bien               *
      *        peCaraC(output) Cantidad de entradas en peCara        *
      *        peErro (output) Indicador de Error                    *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * Retorna: Void                                                *
      * ------------------------------------------------------------ *
     P COWHOG_calculaCaracteristicas...
     P                 B                   Export
     D COWHOG_calculaCaracteristicas...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRdes                      40a   const
     D   peCara                            likeds(set160_t) dim(99)
     D   peCaraC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                    likerec( c1w000 : *key )

     D @@cara          ds                  likeds(set160_t) dim(999)

     D @@anio          s              2  0
     D @@pbre          s              5  2
     D @@rdes          s             40
     D x               s             10i 0
     D y               s             10i 0
     D @@LBue          s              3  0 dim(10)
     D @@LBueC         s             10i 0
     D Prod_Especial   s               n

       COWHOG_inz();

      // Obtiene Códigos de Buen Resultado
       clear @@LBue;
       clear @@LBueC;
       if SVPDRV_getCodBuenResultado( peBase.peEmpr
                                    : peBase.peSucu
                                    : @@LBue
                                    : @@LBueC );
       endif;

      //Busca si el Productor tiene tratamiento especial
       Prod_Especial = SVPBUE_chkProductorEspecial( peBase.peEmpr
                                                  : peBase.peSucu
                                                  : peBase.peNivt
                                                  : peBase.peNivc );


       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds( k1y000 : 5 ) ctw000;

       WSLTAB_listaCaracteristicasBienWeb ( w0empr : w0sucu : w0arcd
                                          : peRama : peXpro : @@cara
                                          : peCaraC );

       @@rdes = peRdes;
       SPBRRV ( w0empr : w0sucu : w0arcd : w0spo1 : peRama
              : peArse : 1 : @@anio : @@pbre : @@rdes );

       for x = 1 to peCaraC;

         COWHOG_setCondCarac ( peCopo : peCops : @@anio
                             : @@cara(x).ccba : @@cara(x).ma01
                             : @@cara(x).ma02 );

         if Prod_Especial;
           if %lookup( @@cara(x).ccba : @@LBue ) > *zeros;
              @@cara(x).ma03 = 'S';
           endif;
         endif;

       endfor;
       clear y;
       for x = 1 to 99;
         if @@cara(x).ma01 <> 'S' and
            @@cara(x).ma03 <> 'S';
           iter;
         endif;
           y += 1;
           peCara(y) = @@cara(x);
       endfor;

       peCaraC = y;
       return;

     P COWHOG_calculaCaracteristicas...
     P                 E

      * ------------------------------------------------------------------ *
      * COWHOG_setRequiereInspeccion(): Graba si cobertura requiere        *
      *                                 inspeccion.                        *
      *                                                                    *
      *     peBase ( input )  Parametros Base                              *
      *     peNctw ( input )  Nro. de Cotización                           *
      *     peRama ( input )  Rama                                         *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     pePoco ( input )  Nro de Componente                            *
      *     peXpro ( input )  Producto                                     *
      *     peCobe ( input )  Coberturas                                   *
      *                                                                    *
      * Retorna *On = Operación Exitosa / *off = Operación Fallida         *
      * ------------------------------------------------------------------ *
     P COWHOG_setRequiereInspeccion...
     P                 B                    export
     D COWHOG_setRequiereInspeccion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peXpro                       3  0 const
     D   peCobe                            likeds(Cobprima) dim(20)const

     D   k1yer0        ds                  likerec( c1wer0 : *key )
     D   @@insp        s              1
     D peTiou          s              1  0
     D peStou          s              2  0
     D peStos          s              2  0

      /free
       COWHOG_inz();

       @@insp = COWHOG_GetRequiereInspeccion( peRama : peCobe );

       if SVPVAL_chkPlanCerrado( peRama
                               : peXpro
                               : COWGRAI_monedaCotizacion( peBase
                                                         : peNctw) );
         @@insp = 'N';
       endif;

       if COWGRAI_getTipodeOperacion( peBase
                                    : peNctw
                                    : peTiou
                                    : peStou
                                    : peStos );
          if peTiou = 2;
             @@insp = 'N';
          endif;
       endif;

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivC;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0poco = pePoco;
       k1yer0.r0arse = peArse;
       chain %kds( k1yer0 ) ctwer0;
       if %found( ctwer0 );
         if @@insp = 'S';
           r0ma01 = '1';
         else;
           r0ma01 = '0';
         endif;
         update c1wer0;
       endif;

       return *on;

      /end-free

     P COWHOG_setRequiereInspeccion...
     P                 E

      * ------------------------------------------------------------------ *
      * COWHOG_getInspeccion(): Retoma Marca de Inspeccion de Cabecera     *
      *                                                                    *
      *     peBase ( input )  Parametros Base                              *
      *     peNctw ( input )  Nro. de Cotización                           *
      *     peRama ( input )  Rama                                         *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     pePoco ( input )  Nro de Componente                            *
      *                                                                    *
      * Retorna S = Si / N = No                                            *
      * ------------------------------------------------------------------ *
     P COWHOG_getInspeccion...
     P                 B                    export
     D COWHOG_getInspeccion...
     D                 pi             1
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

     D   k1yer0        ds                  likerec( c1wer0 : *key )

      /free
       COWHOG_inz();

       k1yer0.r0empr = peBase.peEmpr;
       k1yer0.r0sucu = peBase.peSucu;
       k1yer0.r0nivt = peBase.peNivt;
       k1yer0.r0nivc = peBase.peNivC;
       k1yer0.r0nctw = peNctw;
       k1yer0.r0rama = peRama;
       k1yer0.r0poco = pePoco;
       k1yer0.r0arse = peArse;
       chain(n) %kds( k1yer0 ) ctwer0;
       if %found( ctwer0 );
         if r0ma01 = '1';
            return  'S';
         endif;
       endif;

       return  'N';

      /end-free

     P COWHOG_getInspeccion...
     P                 E

      * ------------------------------------------------------------------ *
      * COWHOG_chkPlanesHabilWeb(): Chequea si hay planes habilitados para *
      *                             la web (en todas sus ubicaciones de    *
      *                             riesgo).                               *
      *                                                                    *
      *     peEmpr ( input )  Código de Empresa                            *
      *     peSucu ( input )  Código de Sucursal                           *
      *     peArcd ( input )  Código de Articulo                           *
      *     peSpol ( input )  Nro. de Superpoliza                          *
      *     peRama ( input )  Código de Rama                               *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     peOper ( input )  Nro. Operación                               *
      *     pePoco ( input )  Nro. de Componente                           *
      *                                                                    *
      * Retorna *On = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     P COWHOG_chkPlanesHabilWeb...
     P                 B                    export
     D COWHOG_chkPlanesHabilWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)

     D   k1yer9        ds                  likerec( p1her9  : *key )
     D   k1yer0        ds                  likerec( p1her0  : *key )
     D   k1y02w        ds                  likerec( s1t102w : *key )

     D  Habilitado     s               n
     D  @@Fech         s              8  0
     D  @@Year         s              4  0
     D  @@Month        s              2  0
     D  @@Day          s              2  0

      /free

       COWHOG_inz();

       Habilitado = *off;

       PAR310X3( peEmpr : @@Year : @@Month : @@Day);
       @@Fech = (@@Year * 10000)
              + (@@Month *  100)
              +  @@Day;

       k1yer9.r9Empr = peEmpr;
       k1yer9.r9Sucu = peSucu;
       k1yer9.r9Arcd = peArcd;
       k1yer9.r9Spol = peSpol;
       k1yer9.r9Rama = peRama;

       select;

         when %parms >= 6 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) =  *NULL
                          and %addr( pePoco ) =  *NULL;

           k1yer9.r9Arse = peArse;
           setll %kds( k1yer9 : 6 ) paher9;
           reade %kds( k1yer9 : 6 ) paher9;

         when %parms >= 7 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) =  *NULL;

           k1yer9.r9Arse = peArse;
           k1yer9.r9Oper = peOper;
           setll %kds( k1yer9 : 7 ) paher9;
           reade %kds( k1yer9 : 7 ) paher9;

         when %parms >= 8 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) <> *NULL;

           k1yer9.r9Arse = peArse;
           k1yer9.r9Oper = peOper;
           k1yer9.r9Poco = pePoco;
           setll %kds( k1yer9 : 8 ) paher9;
           reade %kds( k1yer9 : 8 ) paher9;

         other;

           setll %kds( k1yer9 : 5 ) paher9;
           reade %kds( k1yer9 : 5 ) paher9;
       endsl;

       dow not %eof( paher9 );
         if r9Strg = '0';

           k1yer0.r0Empr = r9Empr;
           k1yer0.r0Sucu = r9Sucu;
           k1yer0.r0Arcd = r9Arcd;
           k1yer0.r0Spol = r9Spol;
           k1yer0.r0Sspo = r9Sspo;
           k1yer0.r0Rama = r9Rama;
           k1yer0.r0Arse = r9Arse;
           k1yer0.r0Oper = r9Oper;
           k1yer0.r0Poco = r9Poco;
           chain %kds( k1yer0 : 9 ) paher0;
           if %found( paher0 );

             k1y02w.t@Rama = r0Rama;
             k1y02w.t@Xpro = r0Xpro;
             setll %kds( k1y02w : 2 ) set102w;
             reade %kds( k1y02w : 2 ) set102w;
             dow not %eof( set102w );
               if t@Fech <= @@fech;
                 if t@mp01 = 'S';
                   habilitado = *on;
                 else;
                   habilitado = *off;
                 endif;
               else;
                 leave;
               endif;
               reade %kds( k1y02w : 2 ) set102w;
             enddo;

           endif;

         endif;

         select;

           when %parms >= 6 and %addr( peArse ) <> *NULL
                            and %addr( peOper ) =  *NULL
                            and %addr( pePoco ) =  *NULL;

             reade %kds( k1yer9 : 6 ) paher9;

           when %parms >= 7 and %addr( peArse ) <> *NULL
                            and %addr( peOper ) <> *NULL
                            and %addr( pePoco ) =  *NULL;

             reade %kds( k1yer9 : 7 ) paher9;

           when %parms >= 8 and %addr( peArse ) <> *NULL
                            and %addr( peOper ) <> *NULL
                            and %addr( pePoco ) <> *NULL;

             reade %kds( k1yer9 : 8 ) paher9;

           other;

             reade %kds( k1yer9 : 5 ) paher9;

         endsl;

       enddo;

       if Habilitado;
         return *on;
       else;
         return *off;
       endif;

      /end-free

     P COWHOG_chkPlanesHabilWeb...
     P                 E

      * ------------------------------------------------------------------ *
      * COWHOG_cantidadUbicacRies(): Retorna cantidad de ubicaciones de    *
      *                              riesgos activas.                      *
      *                                                                    *
      *     peEmpr ( input )  Código de Empresa                            *
      *     peSucu ( input )  Código de Sucursal                           *
      *     peArcd ( input )  Código de Articulo                           *
      *     peSpol ( input )  Nro. de Superpoliza                          *
      *     peRama ( input )  Código de Rama                               *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     peOper ( input )  Nro. Operación                               *
      *     pePoco ( input )  Nro. de Componente                           *
      *                                                                    *
      * Retorna @@Cant                                                     *
      * ------------------------------------------------------------------ *
     P COWHOG_cantidadUbicacRies...
     P                 B                    export
     D COWHOG_cantidadUbicacRies...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)

     D   k1yer9        ds                  likerec( p1her9  : *key )

     D @@Cant          s             10i 0

      /free

       COWHOG_inz();

       clear @@Cant;

       k1yer9.r9Empr = peEmpr;
       k1yer9.r9Sucu = peSucu;
       k1yer9.r9Arcd = peArcd;
       k1yer9.r9Spol = peSpol;
       k1yer9.r9Rama = peRama;

       select;

         when %parms >= 6 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) =  *NULL
                          and %addr( pePoco ) =  *NULL;

           k1yer9.r9Arse = peArse;
           setll %kds( k1yer9 : 6 ) paher9;
           reade %kds( k1yer9 : 6 ) paher9;

         when %parms >= 7 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) =  *NULL;

           k1yer9.r9Arse = peArse;
           k1yer9.r9Oper = peOper;
           setll %kds( k1yer9 : 7 ) paher9;
           reade %kds( k1yer9 : 7 ) paher9;

         when %parms >= 8 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) <> *NULL;

           k1yer9.r9Arse = peArse;
           k1yer9.r9Oper = peOper;
           k1yer9.r9Poco = pePoco;
           setll %kds( k1yer9 : 8 ) paher9;
           reade %kds( k1yer9 : 8 ) paher9;

         other;

           setll %kds( k1yer9 : 5 ) paher9;
           reade %kds( k1yer9 : 5 ) paher9;
       endsl;

       dow not %eof( paher9 );

         if r9Strg = '0';
           @@Cant += 1;
         endif;
         select;

           when %parms >= 6 and %addr( peArse ) <> *NULL
                            and %addr( peOper ) =  *NULL
                            and %addr( pePoco ) =  *NULL;

             reade %kds( k1yer9 : 6 ) paher9;

           when %parms >= 7 and %addr( peArse ) <> *NULL
                            and %addr( peOper ) <> *NULL
                            and %addr( pePoco ) =  *NULL;

             reade %kds( k1yer9 : 7 ) paher9;

           when %parms >= 8 and %addr( peArse ) <> *NULL
                            and %addr( peOper ) <> *NULL
                            and %addr( pePoco ) <> *NULL;

             reade %kds( k1yer9 : 8 ) paher9;

           other;

             reade %kds( k1yer9 : 5 ) paher9;

         endsl;

       enddo;

       return @@Cant;

      /end-free

     P COWHOG_cantidadUbicacRies...
     P                 E

      * ------------------------------------------------------------------ *
      * COWHOG_chkRenovacion(): Valida campos antes de realizar renovación *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peErro ( output )  Indicador                                   *
      *     peMsgs ( output )  Estructura de Error                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     P COWHOG_chkRenovacion...
     P                 B                    export
     D COWHOG_chkRenovacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D x               s             10i 0
     D i               s             10i 0
     D c               s             10i 0
     D @@Asen          s              7  0
     D @@Tido          s              2  0
     D @@Civa          s              2  0
     D @@Tiso          s              2  0
     D @@Cuit          s             11
     D @@Poli          s              7  0
     D @@Rama          s              2  0
     D @@Anul          s              1
     D @@Year          s              4  0
     D @@Month         s              2  0
     D @@Day           s              2  0
     D @@Mone          s              2
     D @@Nivt          s              1  0
     D @@Nivc          s              5  0
     D @CNivt          s              1  0
     D @CNivc          s              5  0
     D @@Cade          s              5  0 dim(9)
     D endpgm          s              3
     D fchBja          s              8  0
     D fchSis          s              8  0
     D peOper          s              7  0
     D peRoll          s              1a
     D pePosi          ds                  likeds(keyubp_t)
     D pePreg          ds                  likeds(keyubp_t)
     D peUreg          ds                  likeds(keyubp_t)
     D peLubi          ds                  likeds(pahrsvs_t) dim(99)
     D peLubic         s             10i 0
     D peMore          s               n
     D peCobe          ds                  likeds(Cobprima) dim(20)
     D peErro          s                   like(paramerro)
     D @@DsPo          ds                  likeds(dsPahed0_t) dim(999)
     D @@DsPoC         s             10i 0
     D peLryc          ds                  likeds(pahrsvs1_t) dim(99)
     D peLrycC         s             10i 0

      /free

       COWHOG_inz();

       // Validar que el asegurado no este bloqueado

       // Retorna Nro de asegurado
       @@Asen = SPVSPO_getAsen( peBase.peEmpr
                              : peBase.peSucu
                              : peArcd
                              : peSpol
                              : *omit         );

       if @@Asen <> *zeros;

         if SVPASE_getCodBloqueo( @@Asen ) <> '0';

           //Asegurado Bloqueado

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0033'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peError = -1;
           return;

         endif;

       endif;

       // Validar que no deba existir otra cotizacion de renovacion en proceso o
       // guardada para la misma poliza.

       if COWGRAI_chkRenovProcGuarEm( peBase
                                    : peArcd
                                    : peSpol );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0148'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que no debe existir una propuesta de renovacion en SpeedWay
       // para la misma poliza

       // Retorna Nro. de Póliza

       @@Poli = SPVSPO_getPoliza( peBase.peEmpr
                                : peBase.peSucu
                                : peArcd
                                : peSpol
                                : *omit         );

       if @@Poli <> -1;

         if SVPAVR_VerificaSuspendidaSPWY( peArcd
                                         : peSpol
                                         : @@Poli );
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0149'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peError = -1;
           return;

         endif;

       endif;

       // Validar que la póliza no este renovada

       if SPVSPO_chkSpolRenovada( peBase.peEmpr
                                : peBase.peSucu
                                : peArcd
                                : peSpol        ) <> *zeros;

         %subst(wRepl : 1 : 6)  = %editc( peArcd  : 'X' );
         %subst(wRepl : 7 : 9)  = %editc( peSpol  : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'REN0101'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que la póliza no tenga cuotas sin pagar
       if SPVSPO_getCuotasImpagasMes( peBase.peEmpr
                                    : peBase.peSucu
                                    : peArcd
                                    : peSpol ) > 1;

         %subst( wRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
         %subst( wRepl : 7 : 9 )  = %editc( peSpol  : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'REN0104'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que la póliza no tenga aviso de vencimiento retenido

       if not SVPVRENO_SuperPolizaRenovable( peBase.peEmpr
                                           : peBase.peSucu
                                           : peArcd
                                           : peSpol
                                           : *omit         );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0150'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que en el actualizador de condiciones ( PAX006 ) las marcas de Técnica
       // y Cobranzas deben habilitar la renovación

       // Retorna Rama

       @@Rama = SPVSPO_getRama( peBase.peEmpr
                              : peBase.peSucu
                              : peArcd
                              : peSpol
                              : *omit         );

       if @@Rama <> -1;

         if SVPREN_chkMarcaTecCobRen( peArcd
                                    : peSpol
                                    : @@Rama
                                    : *omit
                                    : *omit  ) = 'N';

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0151'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peError = -1;
           return;

         endif;

       endif;

       // Validar que la póliza deba tener planes habilitados para la wed
       // (en todas sus ubicaciones de riesgo).

       if not COWHOG_chkPlanesHabilWeb( peBase.peEmpr
                                      : peBase.peSucu
                                      : peArcd
                                      : peSpol
                                      : @@Rama
                                      : *omit
                                      : *omit
                                      : *omit         );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0152'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que la políza no tenga mas de seis ubicaciones de riesgo

       if COWHOG_cantidadUbicacRies( peBase.peEmpr
                                   : peBase.peSucu
                                   : peArcd
                                   : peSpol
                                   : @@Rama
                                   : *omit
                                   : *omit
                                   : *omit         ) > 6;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0153'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que el plan de pago de la póliza esté habilitado para la web

       if not COWGRAI_chkPlandePagoHabWeb( peBase.peEmpr
                                         : peBase.peSucu
                                         : peArcd
                                         : peSpol
                                         : *omit         );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0154'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que no exista endosos pendientes para la póliza que se
       // quiere renovar

       if SPVSPO_chkSpolSuspendida ( peBase.peEmpr
                                   : peBase.peSucu
                                   : peArcd
                                   : peSpol        );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0155'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que la póliza no este anulada

       clear @@Anul;
       clear endpgm;

       PAR310X3( peBase.peEmpr : @@Year : @@Month : @@Day);

       DXP021( peBase.peEmpr
             : peBase.peSucu
             : peArcd
             : peSpol
             : @@Year
             : @@Month
             : @@Day
             : @@Anul
             : endpgm        );

       if @@Anul = 'A';

         %subst( wRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
         %subst( wRepl : 7 : 9 )  = %editc( peSpol  : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0156'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que los componente de la póliza tenga al menos tres coberturas
       // y que al menos una sea de incendio

       peRoll = 'I';
       clear pePreg;
       clear peUreg;
       clear pePosi;
       clear peLubi;
       clear peLubiC;

       pePosi.r9Rama = @@Rama;
       pePosi.r9Poli = @@Poli;
       pePosi.r9Spol = peSpol;
       pePosi.r9Arcd = peArcd;

       // Retorna datos de de la póliza para obtener Nro. de operación

       if SVPPOL_getPoliza( peBase.peEmpr
                          : peBase.peSucu
                          : @@Rama
                          : @@Poli
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : @@DsPo
                          : @@DsPoC       );

         peOper = @@DsPo(@@DsPoC).d0Oper;
         pePosi.r9Oper = peOper;
       endif;

       fchSis = (@@year * 10000)
              + (@@month *  100)
              +  @@day;

       dou peMore = *off;

         WSLUBP( peBase
               : 99
               : peRoll
               : pePosi
               : pePreg
               : peUreg
               : peLubi
               : peLubic
               : peMore
               : peErro
               : peMsgs  );

         pePosi = peUreg;
         peRoll = 'F';

         if peErro = 0;
           for x = 1 to peLubiC;
             fchBja = (peLubi(x).rsAegn * 10000)
                    + (peLubi(x).rsMegn * 100)
                    +  peLubi(x).rsDegn;

             if fchBja = *zeros or fchBja > fchSis;

               clear peLryc;
               clear peLrycC;
               clear peErro;
               clear peMsgs;

               WSLUBR( peBase
                     : @@Rama
                     : @@Poli
                     : peSpol
                     : peLubi(x).rsPoco
                     : peLryc
                     : peLrycC
                     : peErro
                     : peMsgs         );

               clear i;
               clear peCobe;
               if peErro = 0;
                 for c = 1 to peLrycC;
                   if not SVPRIV_isCoberturaBaja( peBase.peEmpr
                                                : peBase.peSucu
                                                : peArcd
                                                : peSpol
                                                : @@Rama
                                                : @@DsPo(@@DsPoC).d0arse
                                                : peOper
                                                : peLubi(x).rsPoco
                                                : peLryc(c).rsRiec
                                                : peLryc(c).rsXcob
                                                : *omit
                                                : *omit            );
                      i += 1;
                      peCobe(i).Riec = peLryc(c).rsRiec;
                      peCobe(i).Xcob = peLryc(c).rsXcob;
                      peCobe(i).Sac1 = peLryc(c).rsSaco;
                      peCobe(i).Xpri = peLryc(c).rsXpri;
                      peCobe(i).Prim = peLryc(c).rsPtco;
                    endif;
                 endfor;
               endif;

               if COWHOG_cobCombinado ( @@Rama : peCobe : peMsgs ) = *off;
                 peError = -1;
                 return;
               endif;

             endif;
           endfor;
         endif;
       enddo;

       // Validar que el asegurado este relacionado al productor

       clear @@Cade;
       clear @CNivt;
       clear @CNivc;
       SVPINT_GetCadena( peBase.peEmpr
                       : peBase.peSucu
                       : peBase.peNivt
                       : peBase.peNivc
                       : @@Cade        );

       @CNivt = 9;
       @CNivc = @@Cade(9);

       clear @@Cade;
       clear @@Nivt;
       clear @@Nivc;
       SPVSPO_getProductor( peBase.peEmpr
                          : peBase.peSucu
                          : peArcd
                          : peSpol
                          : *omit
                          : @@Nivt
                          : @@Nivc        );

       SVPINT_GetCadena( peBase.peEmpr
                       : peBase.peSucu
                       : @@Nivt
                       : @@Nivc
                       : @@Cade        );

       @@Nivt = 9;
       @@Nivc = @@Cade(9);

       if @CNivt <> @@Nivt or @CNivc <> @@Nivc;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'ASE0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Validar que la Moneda este habilitada para la Web

       @@Mone = SPVSPO_getMone( peBase.peEmpr
                              : peBase.peSucu
                              : peArcd
                              : peSpol
                              : *omit         );

       if not SVPVAL_monedaWeb( @@Mone );

           %subst(wrepl:1:2) = @@Mone;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0005'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       // Validar que el tipo de documento este habilitado en la Web,
       // cuando sea persona fisica

       @@Tiso = SVPDAF_getTipoSociedad( @@Asen );
       if @@Tiso = 98; // Persona Fisica

         @@Tido = SVPASE_getTipoDoc( @@Asen );

         if not SVPVAL_chkTipoDocHabWeb( @@Tido );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0185'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peError = -1;
           return;
         endif;

       endif;

       // Validar CUIT, cuando sea Persona Juridica

       clear @@Cuit;
       if ( @@Tiso <> 98 and @@Tiso <> 81 );

         @@Cuit = SVPASE_getCuit( @@Asen );
         if not SVPVAL_CuitCuil( @@Cuit);

           %subst(wrepl:1:11) = @@Cuit;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;
         endif;

       endif;

       // Validar si el Código de IVA del asegurado esta habilitado
       // para la Web

       @@Civa = SVPASE_getIva( @@Asen ); // Retorna Cod. Iva Asegurado

       if not SVPVAL_chkCodIvaHabWeb( @@Civa );

         %subst(wrepl:1:1) = %subst(%editc(@@Civa:'X'):2:1);

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0186'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

       // Valida si el Código de Iva de Superpóliza esta habilitado para
       // la Web

       // Retorna Código Iva de Superpóliza
       clear @@Civa;
       @@Civa = SPVSPO_getCodigoIva( peBase.peEmpr
                                   : peBase.peSucu
                                   : peArcd
                                   : peSpol        );

       if not SVPVAL_chkCodIvaHabWeb( @@Civa );

         %subst(wrepl:1:1) = %subst(%editc(@@Civa:'X'):2:1);

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0012'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peError = -1;
         return;

       endif;

      /end-free

     P COWHOG_chkRenovacion...
     P                 E

      * ------------------------------------------------------------------ *
      * COWHOG_getInfoHogar(): Retorna datos para renovar hogar            *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peNctw ( input  )  Número de Cotización                        *
      *     peRama ( output )  Código de Rama                              *
      *     peArse ( output )  Cantidad de Pólizas por Rama                *
      *     peCfpg ( output )  Plan de pago                                *
      *     peClie ( output )  Estructura de Cliente                       *
      *     pePoco ( output )  Estructura de Componente                    *
      *     peXrea ( output )  Epv                                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     P COWHOG_getInfoHogar...
     P                 B                    export
     D COWHOG_getInfoHogar...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNctw                       7  0 const
     D   peRama                       2  0
     D   peArse                       2  0
     D   peCfpg                       3  0
     D   peClie                            likeds(ClienteCot_t)
     D   pePoco                            likeds(UbicPoc_t) dim(10)
     D   peXrea                       5  2

     D x               s             10i 0
     D i               s             10i 0
     D l               s             10i 0
     D c               s             10i 0
     D pePoli          s              7  0
     D peOper          s              7  0
     D peRoll          s              1a
     D pePosi          ds                  likeds(keyubp_t)
     D pePreg          ds                  likeds(keyubp_t)
     D peUreg          ds                  likeds(keyubp_t)
     D peLubi          ds                  likeds(pahrsvs_t) dim(99)
     D peLubic         s             10i 0
     D peMore          s               n
     D peErro          s                   like(paramerro)
     D peMsgs          ds                  likeds(parammsgs)
     D peLryc          ds                  likeds(pahrsvs1_t) dim(99)
     D peLrycC         s             10i 0
     D @@Dec3          ds                  likeds( dsPahec3_t )
     D fchBja          s              8  0
     D fchSis          s              8  0
     D @@Asen          s              7  0
     D @@Dase          ds                  likeds(pahase_t)
     D @@Mase          ds                  likeds(dsMail_t) dim(100)
     D @@MaseC         s             10i 0
     D @@Suaa          s             15  2
     D @@Rdes          s             40
     D @@Mone          s              2
     D @@Xopr          s              5  2
     D @@Year          s              4  0
     D @@Month         s              2  0
     D @@Day           s              2  0
     D @@Sspo          s              3  0 inz(0)

     D @@DsPo          ds                  likeds(dsPahed0_t) dim(999)
     D @@DsPoC         s             10i 0
     D ubtPosi         ds                  likeds(keyubt_t)
     D ubtPreg         ds                  likeds(keyubt_t)
     D ubtUreg         ds                  likeds(keyubt_t)
     D ubtCubi         ds                  likeds(pahrsvs6_t) dim(99)
     D ubtCubic        s             10i 0

     D bure_ant        s              2  0
     D bure_act        s              2  0
     D br_1            s              2  0
     D br_2            s              2  0
     D br_3            s              2  0
     D rc              s              1n
     D peTido          s              2  0
     D peNrdo          s              8  0
     D peCuit          s             11a
     D peCopo          s              5  0
     D peCops          s              1  0
     D tiou_ant        s              1  0
     D stou_ant        s              2  0
     D stos_ant        s              2  0
     D k1tloc          ds                  likerec(g1tloc:*key)

     D @@LcobD         ds                  likeds(ListCDep) dim(20)
     D @@LcobDC        s             10i 0
     D @@LcDep         ds                  likeds(ListCDep) dim(999)
     D @@LCobe         ds                  likeds(ListCobe) dim(999)
     D v               s             10i 0
     D w               s             10i 0
     D y               s             10i 0
     D z               s             10i 0
     D data            s          65535a   varying

     D topCobe         ds                  likeds(CobPrima) dim(20)

      /free

       COWHOG_inz();

       rc = SPVSPO_getTipoOperacion( peBase.peEmpr
                                   : peBase.peSucu
                                   : peArcd
                                   : peSpol
                                   : @@Sspo
                                   : tiou_ant
                                   : stou_ant
                                   : stos_ant );

       // Retorna Nro de asegurado

       @@Asen = SPVSPO_getAsen( peBase.peEmpr
                              : peBase.peSucu
                              : peArcd
                              : peSpol
                              : *omit         );

       // Retorna datos del Cliente

       clear @@Dase;
       clear @@Mase;
       clear @@MaseC;
       clear peErro;
       clear peMsgs;

       WSLASE( peBase
             : @@Asen
             : @@Dase
             : @@Mase
             : @@MaseC
             : peErro
             : peMsgs  );

       peErro = 0;
       @@dase.asnomb = SVPDAF_getNombre( @@asen : *omit );
       @@dase.asdomi = SVPDAF_getDomicilio( @@asen
                                          : *omit
                                          : *omit
                                          : *omit
                                          : *omit
                                          : *omit           );
       rc = SVPDAF_getDocumento( @@asen
                               : peTido
                               : peNrdo
                               : peCuit
                               : *omit
                               : *omit         );
       @@dase.astido = peTido;
       @@dase.asnrdo = peNrdo;
       @@dase.ascuit = peCuit;
       rc = SVPDAF_getLocalidad( @@asen
                               : peCopo
                               : peCops
                               : *omit
                               : *omit
                               : *omit
                               : *omit           );
       @@dase.ascopo = peCopo;
       @@dase.ascops = peCops;
       @@dase.asciva = SVPASE_getIva( @@asen );
       @@dase.astiso = SVPDAF_getTipoSociedad( @@asen : *omit );

       k1tloc.locopo = @@dase.ascopo;
       k1tloc.locops = @@dase.ascops;
       chain %kds(k1tloc:2) gntloc;
       if %found;
          @@dase.asproc = loproc;
       endif;

       if peErro <> -1;
         peClie.Asen = @@Asen;
         peClie.Tido = @@Dase.asTido;
         peClie.Nrdo = @@Dase.asNrdo;
         peClie.Nomb = @@Dase.asNomb;
         peClie.Cuit = @@Dase.asCuit;

         select;
           when @@Dase.asTiso = 80 or @@Dase.asTiso = 81;
             peClie.Tipe = 'C';    // Consorcio
           when @@Dase.asTiso = 98;
             peClie.Tipe = 'F';    // Persona Física
           other;
             peClie.Tipe = 'J';    // Persona Jurídica
         endsl;

         peClie.Proc = @@Dase.asProc;

         peClie.Rpro = COWGRAI_GetCodProInd( @@Dase.asCopo
                                           : @@Dase.asCops );

         peClie.Copo = @@Dase.asCopo;
         peClie.Cops = @@Dase.asCops;
         peClie.Civa = @@Dase.asCiva;
       endif;

       // Retorna lista de ubicaciones de pólizas

       peRoll = 'I';
       clear @@Mone;
       clear pePoco;
       clear pePreg;
       clear peUreg;
       clear pePosi;
       clear peLubi;
       clear peLubiC;

       // Retorna Rama

       peRama = SPVSPO_getRama( peBase.peEmpr
                              : peBase.peSucu
                              : peArcd
                              : peSpol
                              : *omit         );

       if peRama <> -1;
         pePosi.r9Rama = peRama;
       endif;

       // Retorna Nro. de Póliza

       pePoli = SPVSPO_getPoliza( peBase.peEmpr
                                : peBase.peSucu
                                : peArcd
                                : peSpol
                                : *omit         );

       if pePoli <> -1;
         pePosi.r9Poli = pePoli;
       endif;

       pePosi.r9Spol = peSpol;
       pePosi.r9Arcd = peArcd;

       // Retorna datos de de la póliza para obtener Nro. de operación

       if SVPPOL_getPoliza( peBase.peEmpr
                          : peBase.peSucu
                          : peRama
                          : pePoli
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : @@DsPo
                          : @@DsPoC       );

         peOper = @@DsPo(@@DsPoC).d0Oper;
         pePosi.r9Oper = peOper;
       endif;

       PAR310X3( peBase.peEmpr : @@Year : @@Month : @@Day);

       fchSis = (@@Year * 10000)
              + (@@Month *  100)
              +  @@Day;

       // Retorna Moneda

       @@Mone = SPVSPO_getMone( peBase.peEmpr
                              : peBase.peSucu
                              : peArcd
                              : peSpol
                              : *omit         );

       // Retorna Plan de Pago

       if SPVSPO_getPlanDePago( peBase.peEmpr
                              : peBase.peSucu
                              : peArcd
                              : peSpol
                              : *omit
                              : @@Dec3        );

         peCfpg = @@Dec3.c3Nrpp;
       endif;

       // Retorna Epv

       clear peXrea;
       clear @@Xopr;
       COWGRAI_getCondComerciales( peBase
                                 : peNctw
                                 : peRama
                                 : peXrea
                                 : @@Xopr );

       // Retorna datos del Componente

       clear l;
       dou peMore = *off;

         WSLUBP( peBase
               : 99
               : peRoll
               : pePosi
               : pePreg
               : peUreg
               : peLubi
               : peLubic
               : peMore
               : peErro
               : peMsgs  );

         pePosi = peUreg;
         peRoll = 'F';

         if peErro = 0;
           for x = 1 to peLubiC;
             fchBja = (peLubi(x).rsAegn * 10000)
                    + (peLubi(x).rsMegn * 100)
                    +  peLubi(x).rsDegn;

             if fchBja = *zeros or fchBja > fchSis;
               l += 1;
               peArse = peLubi(x).rsArse;
               pePoco(l).Poco = peLubi(x).rsPoco;
               pePoco(l).Xpro = peLubi(x).rsXpro;
               pePoco(l).Tviv = peLubi(x).rsTviv;
               pePoco(l).Copo = peLubi(x).rsCopo;
               pePoco(l).Cops = peLubi(x).rsCops;
               pePoco(l).Scta = peLubi(x).rsZrrv;

               SPGETPSUA( peRama : pePoco(l).Xpro : pePoco(l).Psua );

               clear @@Rdes;

               @@Rdes = peLubi(x).rsRdes;
               %subst(@@Rdes:36:5) = %editc(peLubi(x).rsNrdm : 'X');

               // Caracteristicas Actual

               COWHOG_calculaCaracteristicas( peBase
                                            : peNctw
                                            : peRama
                                            : peArse
                                            : pePoco(l).Xpro
                                            : pePoco(l).Copo
                                            : pePoco(l).Cops
                                            : @@Rdes
                                            : pePoco(l).Cara
                                            : pePoco(l).CaraC
                                            : peErro
                                            : peMsgs         );

               // Caracteristicas Anteriores

               clear ubtPosi;
               clear ubtPreg;
               clear ubtUreg;
               clear ubtCubi;
               ubtPosi.r6Arcd = peArcd;
               ubtPosi.r6Spol = peSpol;
               ubtPosi.r6Sspo = 0;
               ubtPosi.r6Rama = peRama;
               ubtPosi.r6Poli = pePoli;
               ubtPosi.r6Arse = peArse;
               ubtPosi.r6Oper = peOper;
               ubtPosi.r6Poco = pePoco(l).Poco;
               ubtPosi.r6Suop = 0;
               WSLUBT( peBase
                     : 99
                     : 'I'
                     : ubtPosi
                     : ubtPreg
                     : ubtUreg
                     : ubtCubi
                     : ubtCubiC
                     : peMore
                     : peErro
                     : peMsgs    );

               // Compara caracteristicas

               for c = 1 to pePoco(l).CaraC;
                 if pePoco(l).Cara(c).Ccba <> 0;
                   for i = 1 to ubtCubiC;
                     if pePoco(l).Cara(c).Ccba =
                        ubtCubi(i).rsCcba;
                       if ubtCubi(i).rsMar1 <> *blanks;
                         if ubtCubi(i).rsCcba <> 996 and
                            ubtCubi(i).rsCcba <> 997 and
                            ubtCubi(i).rsCcba <> 998 and
                            ubtCubi(i).rsCcba <> 999;
                           pePoco(l).Cara(c).Ma01 = ubtCubi(i).rsMar1;
                         endif;
                       endif;
                       if ubtCubi(i).rsMar2 <> *blanks;
                         if ubtCubi(i).rsCcba <> 996 and
                            ubtCubi(i).rsCcba <> 997 and
                            ubtCubi(i).rsCcba <> 998 and
                            ubtCubi(i).rsCcba <> 999;
                           pePoco(l).Cara(c).Ma02 = ubtCubi(i).rsMar2;
                         endif;
                       endif;
                     endif;
                   endfor;
                 endif;
               endfor;

               // ---------------------------------------------
               // Si se trata de un productor con tratamiento
               // especial para el buen resultado, me fijo que
               // buen resultado tenía el año anterior y se lo
               // sumo al actual, siempre que ahora tenga
               // ---------------------------------------------
               bure_ant = 0;
               bure_act = 0;
               if SVPBUE_chkProductorEspecial( peBase.peEmpr
                                             : peBase.peSucu
                                             : peBase.peNivt
                                             : peBase.peNivc
                                             : *omit         );
                  for i = 1 to ubtCubiC;
                      select;
                       when ubtCubi(i).rsCcba = 997;
                            if ubtCubi(i).rsmar1 = 'S' and
                               ubtCubi(i).rsmar2 = 'S';
                               bure_ant = 1;
                            endif;
                       when ubtCubi(i).rsCcba = 998;
                            if ubtCubi(i).rsmar1 = 'S' and
                               ubtCubi(i).rsmar2 = 'S';
                               bure_ant = 2;
                            endif;
                       when ubtCubi(i).rsCcba = 999;
                            if ubtCubi(i).rsmar1 = 'S' and
                               ubtCubi(i).rsmar2 = 'S';
                               bure_ant = 3;
                            endif;
                      endsl;
                  endfor;
                  br_1  = 0;
                  br_2  = 0;
                  br_3  = 0;
                  for i = 1 to pePoco(l).CaraC;
                      select;
                       when pePoco(l).cara(i).ccba = 997;
                            br_1 = i;
                            if pePoco(l).cara(i).ma01 = 'S' and
                               pePoco(l).cara(i).ma02 = 'S';
                               bure_act = 1;
                            endif;
                       when pePoco(l).cara(i).ccba = 998;
                            br_2 = i;
                            if pePoco(l).cara(i).ma01 = 'S' and
                               pePoco(l).cara(i).ma02 = 'S';
                               bure_act = 2;
                            endif;
                       when pePoco(l).cara(i).ccba = 999;
                            br_3 = i;
                            if pePoco(l).cara(i).ma01 = 'S' and
                               pePoco(l).cara(i).ma02 = 'S';
                               bure_act = 3;
                            endif;
                      endsl;
                  endfor;
                  if tiou_ant <> 1;
                     bure_ant = 0;
                  endif;
                  if bure_act > 0;
                     bure_act += bure_ant;
                     if bure_act >= 3;
                        bure_act = 3;
                     endif;
                     select;
                      when bure_act = 1;
                           pePoco(l).cara(br_1).ma01 = 'S';
                           pePoco(l).cara(br_1).ma02 = 'S';
                           pePoco(l).cara(br_1).ma03 = 'N';
                           pePoco(l).cara(br_2).ma01 = 'N';
                           pePoco(l).cara(br_2).ma02 = 'N';
                           pePoco(l).cara(br_2).ma03 = 'N';
                           pePoco(l).cara(br_3).ma01 = 'N';
                           pePoco(l).cara(br_3).ma02 = 'N';
                           pePoco(l).cara(br_3).ma03 = 'N';
                      when bure_act = 2;
                           pePoco(l).cara(br_1).ma01 = 'N';
                           pePoco(l).cara(br_1).ma02 = 'N';
                           pePoco(l).cara(br_1).ma03 = 'N';
                           pePoco(l).cara(br_2).ma01 = 'S';
                           pePoco(l).cara(br_2).ma02 = 'S';
                           pePoco(l).cara(br_2).ma03 = 'N';
                           pePoco(l).cara(br_3).ma01 = 'N';
                           pePoco(l).cara(br_3).ma02 = 'N';
                           pePoco(l).cara(br_3).ma03 = 'N';
                      when bure_act = 3;
                           pePoco(l).cara(br_1).ma01 = 'N';
                           pePoco(l).cara(br_1).ma02 = 'N';
                           pePoco(l).cara(br_1).ma03 = 'N';
                           pePoco(l).cara(br_2).ma01 = 'N';
                           pePoco(l).cara(br_2).ma02 = 'N';
                           pePoco(l).cara(br_2).ma03 = 'N';
                           pePoco(l).cara(br_3).ma01 = 'S';
                           pePoco(l).cara(br_3).ma02 = 'S';
                           pePoco(l).cara(br_3).ma03 = 'N';
                     endsl;
                  endif;
               endif;

               pePoco(l).Bure = *zeros;

               clear peLryc;
               clear peLrycC;
               clear peErro;
               clear peMsgs;

               WSLUBR( peBase
                     : peRama
                     : pePoli
                     : peSpol
                     : pePoco(l).Poco
                     : peLryc
                     : peLrycC
                     : peErro
                     : peMsgs         );

               // Inicializa arreglos de las dependencias
               clear v;
               clear @@LcDep;
               clear @@LCobe;

               clear i;
               if peErro = 0;
                 for c = 1 to peLrycC;
                 if not SVPRIV_isCoberturaBaja( peBase.peEmpr
                                              : peBase.peSucu
                                              : peArcd
                                              : peSpol
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco(l).Poco
                                              : peLryc(c).rsRiec
                                              : peLryc(c).rsXcob
                                              : *omit
                                              : *omit            );
                   i += 1;
                   pePoco(l).Cobe(i).Riec = peLryc(c).rsRiec;
                   pePoco(l).Cobe(i).Xcob = peLryc(c).rsXcob;
                   pePoco(l).Cobe(i).Sac1 = peLryc(c).rsSaco;
                   pePoco(l).Cobe(i).Xpri = peLryc(c).rsXpri;
                   pePoco(l).Cobe(i).Prim = peLryc(c).rsPtco;

                   if @@Mone <> '-1';

                     clear @@Suaa;
                     @@Suaa = SVPREN_aumentoSumaAsegurada( peRama
                                                         : pePoco(l).Xpro
                                                         : peLryc(c).rsRiec
                                                         : peLryc(c).rsXcob
                                                         : @@Mone
                                                         : peLryc(c).rsSaco );

                     pePoco(l).Cobe(i).Sac1 = peLryc(c).rsSaco + @@Suaa;

                     // Busca dependencias de la cobertura
                     clear @@LcobD;
                     clear @@LcobDC;
                     if SVPCOB_GetListCobDepend( peRama
                                               : pePoco(l).Xpro
                                               : peLryc(c).rsRiec
                                               : peLryc(c).rsXcob
                                               : @@Mone
                                               : @@LcobD
                                               : @@LcobDC );

                       for w = 1 to @@LcobDC;

                         // Acumulo las dependencias
                         v += 1;
                         @@LcDep(v).xcob1 = @@LcobD(w).xcob1;
                         @@LcDep(v).xcob2 = @@LcobD(w).xcob2;
                         @@LcDep(v).saco  = @@LcobD(w).saco;
                         @@LcDep(v).prsa  = @@LcobD(w).prsa;

                       endfor;

                     endif;

                   endif;

                   // Guardo Cobertura y Suma Asegurada
                   @@LCobe(i).xcob = pePoco(l).Cobe(i).Xcob;
                   @@LCobe(i).saco = pePoco(l).Cobe(i).Sac1;
                 endif;
                 endfor;

                 // Reajustar suma asegurada segun dependencias
                 if v > *zeros;

                   clear c;
                   dow c < v;
                     c += 1;

                     clear y; // Cobertura Analizada
                     clear z; // Cobertura Dependiente

                     clear w;
                     dow w < i and (y * z) = *zeros;
                       w += 1;

                       if @@LCobe(w).xcob = @@LcDep(c).xcob1;
                         if y = *zeros;
                           y = w;
                         endif;
                       endif;

                       if @@LCobe(w).xcob = @@LcDep(c).xcob2;
                         if z = *zeros;
                           z = w;
                         endif;
                       endif;

                     enddo;

                     if y > *zeros and z > *zeros;

                       // y = Cobertura Analizada
                       // z = Cobertura Dependiente

                       select;
                       when @@LcDep(c).prsa > *zeros;
                         pePoco(l).Cobe(y).Sac1 = @@LcDep(c).prsa
                                                / 100
                                                * @@LCobe(z).saco;

                       when @@LcDep(c).saco > *zeros;
                         pePoco(l).Cobe(y).Sac1 = @@LcDep(c).saco;

                       endsl;

                     endif;

                   enddo;

                 endif;

               endif;

             endif;

           endfor;
         endif;

       enddo;

       // ------------------------------------------
       // En este punto tenemos todo listo para ver
       // si debemos o no topear las coberturas
       // ------------------------------------------
       @@mone = COWGRAI_monedaCotizacion( peBase : peNctw );
       for l = 1 to %elem(pePoco);
           if pePoco(l).poco <= 0;
              leave;
           endif;
           clear topCobe;
           topCobe = pePoco(l).cobe;
           if SVPCOB_topearCoberturas( peRama
                                     : %dec(pePoco(l).xpro:3:0)
                                     : @@mone
                                     : topCobe
                                     : *omit                    );
              data = '<br><br>COWHOG_getInfoHogar()<br>'
                   + '<b>Se han topeado coberturas en la'
                   + ' ubicacion: '
                   + %char(pePoco(l).poco)
                   + '</b><br><br>';
              COWLOG_log( peBase : peNctw : data);
              for x = 1 to %elem(topCobe);
                  if topCobe(x).riec = *blanks;
                     leave;
                  endif;
                  data = 'Rie/Cob: '
                       + pePoco(l).cobe(x).riec
                       + '/'
                       + %editc(pePoco(l).cobe(x).xcob:'X')
                       + ' ---- '
                       + ' Anterior: '
                       +
                  %editw(pePoco(l).cobe(x).sac1:' .   .   .   . 0 ,  ')
                       + ' ---- '
                       + ' Actual : '
                       + ' ---- '
                       + %editw(topCobe(x).sac1:' .   .   .   . 0 ,  ')
                       + '<br>';
                  COWLOG_log( peBase : peNctw : data );
                  pePoco(l).cobe(x).sac1 = topCobe(x).sac1;
              endfor;
            else;
              data = '<br><br>COWHOG_getInfoHogar()<br>'
                   + '<b>No se han topeado coberturas en la'
                   + 'ubicacion: '
                   + %editc(pePoco(l).poco:'X')
                   + '</b><br>';
              COWLOG_log( peBase : peNctw : data);
           endif;
       endfor;

       return;

      /end-free

     P COWHOG_getInfoHogar...
     P                 E

      * ------------------------------------------------------------ *
      * COWHOG_cotizarWeb2:Cotiza un Bien Asegurado de una Rama de   *
      *                    Hogar.                                    *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peCfpg (input)  Plan de Pago                          *
      *        peClie (input)  Estructura de Cliente                 *
      *        pePoco (in/ou)  Array de componentes                  *
      *        pePocoC(input)  Cantidad de entradas en pePoco        *
      *        peXrea (input)  Epv                                   *
      *        peImpu (output) Estructura de impuestos total         *
      *        peSuma (output) Suma Asegurada total                  *
      *        pePrim (output) Prima total                           *
      *        pePrem (output) Premio total                          *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWHOG_cotizarWeb2...
     P                 B                   export
     D COWHOG_cotizarWeb2...
     D                 pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0 const
     D  peXrea                        5  2 const
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D x               s             10i 0
     D h               s             10i 0
     D i               s             10i 0
     D p2ImpuC         s             10i 0
     D p2Prem          s             15  2
     D Recotizar       s               n
     D p2Impu          ds                  likeds(primPrem)    dim(99)
     D p2Cond          ds                  likeds(condCome2_t) dim(99)
     D @@con1C         s             10i 0
     D @@cond          ds                  likeds(condCome2_t) dim(99)
     D @@con1          ds                  likeds(condCome)    dim(99)
     D @@Cara          ds                  likeds(Caracbien)   dim(50)
     D Ds01C           ds                  likeds(dsCtw001C_t) dim(999)

      /free

       COWHOG_inz();

       if pePocoC <= 0;
          return;
       endif;

       for x = 1 to pePocoC;
         clear i;
         clear @@Cara;
         for h = 1 to pePoco(x).CaraC;
           i += 1;
           @@Cara(i).Ccba  = pePoco(x).Cara(h).Ccba;
           @@Cara(i).Dcba  = pePoco(x).Cara(h).Dcba;
           @@Cara(i).Ma01  = pePoco(x).Cara(h).Ma01;
           @@Cara(i).Ma02  = pePoco(x).Cara(h).Ma02;
           @@Cara(i).Ma01m = pePoco(x).Cara(h).Ma01;
           @@Cara(i).Ma02m = pePoco(x).Cara(h).Ma02;
           @@Cara(i).Cbae  = pePoco(x).Cara(h).Cbae;
         endfor;

         Recotizar = *off;
         clear Ds01C;
         if COWGRAI_getCtw001C( peBase :  peNctw : peRama : Ds01C );
           Recotizar = *on;
         endif;

           COWHOG_cotizarWeb( peBase
                            : peNctw
                            : peRama
                            : peArse
                            : pePoco(x).poco
                            : pePoco(x).xpro
                            : pePoco(x).tviv
                            : @@Cara
                            : pePoco(x).copo
                            : pePoco(x).cops
                            : pePoco(x).scta
                            : pePoco(x).bure
                            : peCfpg
                            : peClie.tipe
                            : peClie.civa
                            : pePoco(x).cobe
                            : pePoco(x).suma
                            : pePoco(x).Insp
                            : pePoco(x).boni
                            : pePoco(x).impu
                            : pePoco(x).prem
                            : peErro
                            : peMsgs          );

         if peErro <> -1;

           peSuma += pePoco(x).Suma;
           for h = 1 to 20;
               if pePoco(x).Cobe(h).Prim <> 0;
                  pePrim += pePoco(x).Cobe(h).Prim;
               endif;
           endfor;

           SPGETPSUA( peRama : pePoco(x).Xpro : pePoco(x).Psua );

           clear i;
           for h = 1 to 50;
             if @@Cara(h).Ccba <> 0;
               i += 1;
               pePoco(x).Cara(i).Ccba  = @@Cara(h).Ccba;
               pePoco(x).Cara(i).Dcba  = @@Cara(h).Dcba;
               pePoco(x).Cara(i).Ma01  = @@Cara(h).Ma01;
               pePoco(x).Cara(i).Ma02  = @@Cara(h).Ma02;
               pePoco(x).Cara(i).Cbae  = @@Cara(h).Cbae;
             endif;
           endfor;

           pePoco(x).CaraC = i;

         else;
           return;
         endif;

       endfor;

       clear peCon1;
       clear @@Con1;
       clear p2Impu;
       clear p2ImpuC;
       clear p2Prem;

       if Recotizar;
         @@Con1C = 1 ;
         @@Con1(@@Con1C).Rama = peRama;
         @@Con1(@@Con1C).Xrea = peXrea;
       else;
         clear @@Cond;
         COWRTV4( peBase
                : peNctw
                : peRama
                : @@Cond
                : peErro
                : peMsgs );

         if peErro <> -1;
           @@Con1C = 1 ;
           @@Con1(@@Con1C).Rama = peRama;
           @@Con1(@@Con1C).Xrea = @@Cond(1).xrea;
         endif;
       endif;

       COWGRA8( peBase
              : peNctw
              : peCfpg
              : @@Con1
              : @@Con1C
              : p2Impu
              : p2ImpuC
              : p2Prem
              : peErro
              : peMsgs );

       if peErro <> -1;

          peCon1.rama = @@con1(1).rama;
          peCon1.xrea = @@con1(1).xrea;

         clear h;
         pePrem = p2Prem;
         for x = 1 to p2ImpuC;
           if p2Impu(x).Rama <> 0;
             h += 1;
             peImpu(h).Rama = p2Impu(x).Rama;
             peImpu(h).Arse = p2Impu(x).Arse;
             peImpu(h).Prim = p2Impu(x).Prim;
             peImpu(h).Xref = p2Impu(x).Xref;
             peImpu(h).Refi = p2Impu(x).Refi;
             peImpu(h).Dere = p2Impu(x).Dere;
             peImpu(h).Subt = p2Impu(x).Subt;
             peImpu(h).Seri = p2Impu(x).Seri;
             peImpu(h).Seem = p2Impu(x).Seem;
             peImpu(h).Pimi = p2Impu(x).Pimi;
             peImpu(h).Impi = p2Impu(x).Impi;
             peImpu(h).Psso = p2Impu(x).Psso;
             peImpu(h).Sers = p2Impu(x).Sers;
             peImpu(h).Pssn = p2Impu(x).Pssn;
             peImpu(h).Tssn = p2Impu(x).Tssn;
             peImpu(h).Pivi = p2Impu(x).Pivi;
             peImpu(h).Ipr1 = p2Impu(x).Ipr1;
             peImpu(h).Pivn = p2Impu(x).Pivn;
             peImpu(h).Ipr4 = p2Impu(x).Ipr4;
             peImpu(h).Pivr = p2Impu(x).Pivr;
             peImpu(h).Ipr3 = p2Impu(x).Ipr3;
             peImpu(h).Ipr5 = p2Impu(x).Ipr5;
             peImpu(h).Ipr6 = p2Impu(x).Ipr6;
             peImpu(h).Ipr7 = p2Impu(x).Ipr7;
             peImpu(h).Ipr8 = p2Impu(x).Ipr8;
             peImpu(h).Ipr9 = p2Impu(x).Ipr9;
             peImpu(h).Prem = p2Impu(x).Prem;
           endif;
         endfor;

       endif;

       return;

      /end-free

     P COWHOG_cotizarWeb2...
     P                 E

