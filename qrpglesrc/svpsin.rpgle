     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPSIN: Programa de Servicio.                                *
      *         Siniestros.                                          *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     30-Sep-2014             *
      *------------------------------------------------------------- *
      * Compilacion: Debe tener enlazado el SRVPGM - SPVFEC          *
      * CRTSRVPGM SRVPGM(SVPSIN) MODULE(SVPSIN) SRCFILE(QSRVSRC)     *
      * MBR(SVPSIN) BNDSRVPGM(SPVFEC)                                *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SFA 11/03/15 - Agrego nuevo procedimiento SVPSIN_getSumAsComp*
      *                                           SVPSIN_getIndem    *
      * SFA 15/05/15 - Agrego nuevo procedimiento SVPSIN_getEstSin   *
      *                                           SVPSIN_getEstRec   *
      *                                           SVPSIN_getEstJui   *
      * LRG 08/06/15 - Agrego nuevo procedimiento SVPSIN_chkSiniPend *
      *                                           SVPSIN_chkSiniPag  *
      *                                           SVPSIN_chkSiniDen  *
      * LRG 01/07/15 - Agrego nuevo Procedimiento SVPSIN_chkWeb      *
      * SFA 15/05/15 - Agrego nuevo procedimiento SVPSIN_getPagosJui *
      * NWN 25/07/16 - Agrego Control en SVPSIN_chkFinSini.          *
      *                Si HETERM = 'T' es Stro.Terminado.            *
      * LRG 01/06/15 - Agrego nuevo Procedimiento SVPSIN_getSpol     *
      *                                           SVPSIN_getPol      *
      * SFA 08/06/16 - Agrego nuevo Procedimiento SVPSIN_chkCausaReno*
      * JSN 09/01/19 - Agrego nuevos Procedimientos                  *
      *                SVPSIN_getFechaDelDia                         *
      *                SVPSIN_getConfiguracionVoucherRuedasCristales *
      *                SVPSIN_getCantidadSiniestrosRuedasPorVehiculo *
      *                SVPSIN_getCantidadSiniestrosCristalesPorVehiculo
      *                SVPSIN_getNumeroVoucher                       *
      *                SVPSIN_setNumeroVoucher                       *
      * GIO 22/04/19 - Por tarea RM#04725 se detecto error en la app *
      *                original. Se cambia el formato de la fecha de *
      *                entrada en SP0052 por el formato DDMMAAAA     *
      * GIO 26/06/19 - RM#5219 Incluir a las predenuncias en el      *
      *                conteo de siniestros                          *
      * JSN 03/07/19 - Se modifica Longitud de Parametro Rama en los *
      *                procedimientos:                               *
      *                SVPSIN_getCantidadSiniestrosRuedasPorVehiculo *
      *                SVPSIN_getCantidadSiniestrosCristalesPorVehiculo
      * JSN 10/12/19 - Se agrega nuevos procedimientos:              *
      *                SVPSIN_getCaratula                            *
      *                SVPSIN_getVehiculo                            *
      *     17/12/19 - SVPSIN_getBeneficiarios                       *
      *                SVPSIN_Subsiniestros                          *
      *     19/12/19 - SVPSIN_getUltimoSubsiniestro                  *
      *     02/01/20 - SVPSIN_getConductorTercero                    *
      *                SVPSIN_getVehiculoTercero                     *
      *     08/01/20 - SVPSIN_getUltFechaPago                        *
      * NWN 15/03/21 - Se agrega nuevos procedimientos:              *
      *              - SVPSIN_terminarSiniestro                      *
      *              - SVPSIN_terminarReclamo                        *
      *              - SVPSIN_nivelarRvaStro                         *
      *              - SVPSIN_terminarCaratula                       *
      *              - SVPSIN_getSet402                              *
      *              - SVPSIN_getSet456                              *
      *              - SVPSIN_wrtEstSin                              *
      *              - SVPSIN_getRvaStro                             *
      *              - SVPSIN_getFraStro                             *
      *              - SVPSIN_getPagStro                             *
      *              - SVPSIN_getRvaActStro                          *
      *              - SVPSIN_chkStroEnJuicio                        *
      *              - SVPSIN_nivelarRvaStroBenef                    *
      *              - SVPSIN_terminarReclamoStro                    *
      *              - SVPSIN_nivelarFraStro                         *
      *              - SVPSIN_nivelarFraStroBenef                    *
      * NWN 17/06/21 - Se agrega nuevos procedimientos:              *
      *              - SVPSIN_getCaratula2                           *
      *              - SVPSIN_getPahSc1                              *
      *              - SVPSIN_getPahSd1                              *
      *              - SVPSIN_getPahSd2                              *
      * NWN 13/07/21 - Se agrega nuevos procedimientos:              *
      *              - SVPSIN_getPahStc                              *
      *                                                              *
      * NWN 05/08/21 - Se agrega chkstroenjuicio en terminarSiniestro*
      *              - Se agrega chkstroenjuicio en terminarReclamo  *
      *                No se puede terminar un siniestro que tenga   *
      *                Juicio.                                       *
      *                                                              *
      * ************************************************************ *
     Fpahscd    uf   e           k disk    usropn
     Fpahjhp    if   e           k disk    usropn
     Fpahjcr    if   e           k disk    usropn
     Fpahjc1    if   e           k disk    usropn
     Fgntmon    if   e           k disk    usropn
     Fset402    if   e           k disk    usropn
     Fset4021   if   e           k disk    usropn
     Fpahsb1    uf a e           k disk    usropn
     Fpahsb102  if   e           k disk    usropn
     Fpahsfr01  if   e           k disk    usropn
     Fpahshe04  if   e           k disk    usropn
     Fpahshe    if   e           k disk    usropn
     Fpahshe01  if a e           k disk    usropn
     Fpahsbe05  if   e           k disk    usropn
     Fpahscd03  if   e           k disk    usropn
     Fpahscd11  if   e           k disk    usropn
     Fpahshp    if   e           k disk    usropn
     Fpahshp04  if   e           k disk    usropn
     Fpahsfr    if a e           k disk    usropn
     Fpahshr    if a e           k disk    usropn
     Fpahet0    if   e           k disk    usropn
     Fpaher0    if   e           k disk    usropn
     Fpahev1    if   e           k disk    usropn
     Fset001    if   e           k disk    usropn
     Fpahshp01  if   e           k disk    usropn rename( p1hshp : p1hshp01 )
     Fset475    if   e           k disk    usropn prefix(t475_)
     Fpahsva06  if   e           k disk    usropn rename( p1hsva : p1hsva06 )
     Fpds00007  if   e           k disk    usropn rename( p1ds00 : p1ds0007 )
     F                                            prefix(s007_)
     Fpds000    uf   e           k disk    usropn
     Fpahsva    if   e           k disk    usropn
     Fpahsbe    if   e           k disk    usropn
     Fpahsb2    if   e           k disk    usropn
     Fpahsb4    if   e           k disk    usropn
     Fset456    if   e           k disk    usropn
     Fpahsc1    if   e           k disk    usropn
     Fpahsd1    if   e           k disk    usropn
     Fpahsd2    if   e           k disk    usropn
     Fpahstc    if   e           k disk    usropn
     Fpahsd0    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svppds_h.rpgle'

      *- Area Local del Sistema. -------------------------- *
     D                sds
     D  ususer               254    263
     D  ususr2               358    367
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *
     D DBA456R         pr                  extpgm('DBA456R')
     D    a                           4  0
     D    m                           2  0
     D    d                           2  0

     D SP0052          pr                  extpgm('SP0052')
     D   como                         2
     D   fech                         8  0
     D   cotc                        15  6
     D   tipo                         1a
     D   erro                         1n   options(*nopass)

     D SAR902          pr                  extpgm('SAR902')
     D   rama                         2  0
     D   sini                         7  0
     D   nops                         7  0

     D SPT902          pr                  extpgm('SPT902')
     D   tnum                         1a   const
     D   nres                         7  0

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPSIN_chkFinSini(): Valida si siniestro terminado           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkFinSini...
     P                 B                   export
     D SVPSIN_chkFinSini...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1y402          ds                  likerec(s1t402:*key)
     D k1yshe          ds                  likerec(p1hshe04:*key)

      /free

       SVPSIN_inz();

       k1yshe.heempr = peEmpr;
       k1yshe.hesucu = peSucu;
       k1yshe.herama = peRama;
       k1yshe.hesini = peSini;
       k1yshe.henops = peNops;
       setll %kds(k1yshe:5) pahshe04;
       reade %kds(k1yshe:5) pahshe04;

       k1y402.t@empr = peEmpr;
       k1y402.t@sucu = peSucu;
       k1y402.t@rama = peRama;
       k1y402.t@cesi = hecesi;
       chain %kds(k1y402) set402;

       if not %found(set402) or t@cese = 'TR';
         SetError( SVPSIN_SINTE
                 : 'Siniestro Terminado' );
         return *On;
       endif;

       if heterm = 'T';
         SetError( SVPSIN_SINTE
                 : 'Siniestro Terminado' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkFinSini...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSini(): Valida si existe siniestro                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSini...
     P                 B                   export
     D SVPSIN_chkSini...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1yscd          ds                  likerec(p1hscd:*key)

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;
       k1yscd.cdnops = peNops;
       setll %kds(k1yscd) pahscd;

       if not %equal(pahscd);
         SetError( SVPSIN_SINNE
                 : 'Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkSini...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkBeneficiario(): Valida si existe beneficiario en el*
      *                           siniestro                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkBeneficiario...
     P                 B                   export
     D SVPSIN_chkBeneficiario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

     D @@cant          s              1  0

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

      /free

       SVPSIN_inz();

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       setll %kds(k1ysbe:6) pahsbe05;

       if not %equal(pahsbe05);
         SetError( SVPSIN_BENES
                 : 'Beneficiario no Existe en Siniestro' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkBeneficiario...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkBenefVariasCob(): Valida si existe beneficiario    *
      *                             en varias coberturas             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkBenefVariasCob...
     P                 B                   export
     D SVPSIN_chkBenefVariasCob...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

     D @@cant          s              1  0

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

      /free

       SVPSIN_inz();

       @@cant = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       setll %kds(k1ysbe:6) pahsbe05;
       reade %kds(k1ysbe:6) pahsbe05;
       dow not %eof and @@cant <= 1;
         @@cant += 1;
         reade %kds(k1ysbe:6) pahsbe05;
       enddo;

       if @@cant > 1;
         SetError( SVPSIN_BEMCO
                 : 'Beneficiario en Varias Coberturas' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkBenefVariasCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkBenefJuicio(): Valida si beneficiario en juicio    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkBenefJuicio...
     P                 B                   export
     D SVPSIN_chkBenefJuicio...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

     D k1yjcr          ds                  likerec(p1hjcr:*key)

      /free

       SVPSIN_inz();

       k1yjcr.jcempr = peEmpr;
       k1yjcr.jcsucu = peSucu;
       k1yjcr.jcrama = peRama;
       k1yjcr.jcsini = peSini;
       k1yjcr.jcnops = peNops;
       k1yjcr.jcnrdf = peNrdf;
       setll %kds(k1yjcr:6) pahjcr;

       if %equal(pahjcr);
         SetError( SVPSIN_BEJUI
                 : 'Beneficiario en Juicio' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkBenefJuicio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkReclamo(): Valida reclamo - hecho generador        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peHecg   (input)   Hecho Generador                       *
      *     peRecl   (input)   Numero de Reclamo                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkReclamo...
     P                 B                   export
     D SVPSIN_chkReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peHecg                       1    const
     D   peRecl                       3s 0 const

     D k1y4021         ds                  likerec(s1t4021:*key)
     D k1ysb1          ds                  likerec(p1hsb102:*key)

      /free

       SVPSIN_inz();

       k1ysb1.b1empr = peEmpr;
       k1ysb1.b1sucu = peSucu;
       k1ysb1.b1rama = peRama;
       k1ysb1.b1sini = peSini;
       k1ysb1.b1nops = peNops;
       k1ysb1.b1nrdf = peNrdf;
       setll %kds(k1ysb1:6) pahsb102;
       reade %kds(k1ysb1:6) pahsb102;

       if not %eof(pahsb102);
         if b1recl = peRecl and b1hecg = peHecg;
           return *On;
         endif;
       endif;

       if b1recl <> peRecl;
         SetError( SVPSIN_RECIN
                 : 'Reclamo Inexistente' );
       else;
         SetError( SVPSIN_HECIN
                 : 'Hecho Generador Inexistente' );
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSecShr(): Obtiene secuencia                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peRiec   (input)   Riesgo                                *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Secuencia                                           *
      * ------------------------------------------------------------ *

     P SVPSIN_getSecShr...
     P                 B                   export
     D SVPSIN_getSecShr...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peCobl                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1yshr          ds                  likerec(p1hshr:*key)

     D @@secu          s              2  0
     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0

      /free

       SVPSIN_inz();

       if %parms >= 12 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return -1;
         endif;
         @@a = SPVFEC_ObtAÑoFecha8 ( peFech );
         @@m = SPVFEC_ObtMesFecha8 ( peFech );
         @@d = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         DBA456R ( @@a : @@m : @@d );
       endif;

       k1yshr.hrempr = peEmpr;
       k1yshr.hrsucu = peSucu;
       k1yshr.hrrama = peRama;
       k1yshr.hrsini = peSini;
       k1yshr.hrnops = peNops;
       k1yshr.hrpoco = pePoco;
       k1yshr.hrpaco = pePaco;
       k1yshr.hrnrdf = peNrdf;
       k1yshr.hrsebe = peSebe;
       k1yshr.hrriec = peRiec;
       k1yshr.hrxcob = peCobl;
       k1yshr.hrfmoa = @@a;
       k1yshr.hrfmom = @@m;
       k1yshr.hrfmod = @@d;
       setll %kds(k1yshr:14) pahshr;
       reade(n) %kds(k1yshr:14) pahshr;

       @@secu = 1;
       dow not %eof(pahshr);
         @@secu += 1;
         reade(n) %kds(k1yshr:14) pahshr;
       enddo;

       return @@secu;

      /end-free

     P SVPSIN_getSecShr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setPahshr(): Graba PAHSHR                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peImau   (input)   Importe                               *
      *     peUser   (input)   Usuario                               *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setPahshr...
     P                 B                   export
     D SVPSIN_setPahshr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peImau                      15  2 const
     D   peUser                      10    const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

     D @@fech          s              8  0
     D @@tipo          s              1

      /free

       SVPSIN_inz();

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       if %parms >= 9 and %addr(peFech) <> *Null;
         hrpsec = SVPSIN_getSecShr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob : peFech );
         if hrpsec = -1;
           return *Off;
         endif;
         hrfmoa = SPVFEC_ObtAÑoFecha8 ( peFech );
         hrfmom = SPVFEC_ObtMesFecha8 ( peFech );
         hrfmod = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         hrpsec = SVPSIN_getSecShr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob );
         DBA456R ( hrfmoa : hrfmom : hrfmod );
       endif;

       hrempr = peEmpr;
       hrsucu = pesucu;
       hrrama = perama;
       hrsini = pesini;
       hrnops = penops;
       hrnrdf = penrdf;
       hrimmr = peImau;
       hruser = peUser;

       hrpoco = bepoco;
       hrpaco = bepaco;
       hrsebe = besebe;
       hrriec = beriec;
       hrxcob = bexcob;
       hrcoma = becoma;
       hrnrma = benrma;
       hresma = beesma;
       hrmonr = bemonr;
       hrmar2 = bemar2;
       hrmar3 = bemar3;
       hrmar4 = bemar4;
       hrmar5 = bemar5;

       chain bemonr gntmon;
       if %found(gntmon);
         hrmoeq = momoeq;
       else;
         hrmoeq = *Blanks;
       endif;

       if momoeq <> 'AU';
         @@fech = (*day*1000000)+(*month*10000)+*year;
         @@tipo = 'V';
         SP0052 ( bemonr : @@fech : hrimco : @@tipo );
         if hrimco = *zeros;
           hrimco = 1;
         endif;
       else;
         hrimco = 1;
       endif;
       hrimau = hrimmr * hrimco;

       hrnupe = *Zeros;
       hrnroc = *Zeros;
       hrimnr = *Zeros;
       hrimna = *Zeros;
       hrmar1 = *Off;
       hrtime = %dec(%time():*iso);
       hrfera = *year;
       hrferm = *month;
       hrferd = *day;
       hrtifa = *Zeros;
       hrnrsf = *Zeros;
       hrnrfa = *Zeros;

       write p1hshr;

       return *On;

      /end-free

     P SVPSIN_setPahshr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSecSfr(): Obtiene secuencia                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peRiec   (input)   Riesgo                                *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Secuencia                                           *
      * ------------------------------------------------------------ *

     P SVPSIN_getSecSfr...
     P                 B                   export
     D SVPSIN_getSecSfr...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peCobl                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1ysfr          ds                  likerec(p1hsfr:*key)

     D @@secu          s              2  0
     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0

      /free

       SVPSIN_inz();

       @@secu = *zeros;

       if %parms >= 12 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return -1;
         endif;
         @@a = SPVFEC_ObtAÑoFecha8 ( peFech );
         @@m = SPVFEC_ObtMesFecha8 ( peFech );
         @@d = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         DBA456R ( @@a : @@m : @@d );
       endif;

       k1ysfr.frempr = peEmpr;
       k1ysfr.frsucu = peSucu;
       k1ysfr.frrama = peRama;
       k1ysfr.frsini = peSini;
       k1ysfr.frnops = peNops;
       k1ysfr.frpoco = pePoco;
       k1ysfr.frpaco = pePaco;
       k1ysfr.frnrdf = peNrdf;
       k1ysfr.frsebe = peSebe;
       k1ysfr.frriec = peRiec;
       k1ysfr.frxcob = peCobl;
       k1ysfr.frfmoa = @@a;
       k1ysfr.frfmom = @@m;
       k1ysfr.frfmod = @@d;
       setgt %kds(k1ysfr:14) pahsfr;
       readpe(n) %kds(k1ysfr:14) pahsfr;
       if %found(pahsfr);
         @@secu = frpsec;
       endif;
         @@secu += 1;

       return @@secu;

      /end-free

     P SVPSIN_getSecSfr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setPahsfr(): Graba PAHSFR                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peImau   (input)   Importe                               *
      *     peUser   (input)   Usuario                               *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setPahsfr...
     P                 B                   export
     D SVPSIN_setPahsfr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peImau                      15  2 const
     D   peUser                      10    const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

     D @@fech          s              8  0
     D @@tipo          s              1

      /free

       SVPSIN_inz();

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       if %parms >= 9 and %addr(peFech) <> *Null;
         frpsec = SVPSIN_getSecSfr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob : peFech );
         if frpsec = -1;
           return *Off;
         endif;
         hrfmoa = SPVFEC_ObtAÑoFecha8 ( peFech );
         hrfmom = SPVFEC_ObtMesFecha8 ( peFech );
         hrfmod = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         frpsec = SVPSIN_getSecSfr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob );
         DBA456R ( hrfmoa : hrfmom : hrfmod );
       endif;

       frempr = peEmpr;
       frsucu = pesucu;
       frrama = perama;
       frsini = pesini;
       frnops = penops;
       frnrdf = penrdf;
       frimmr = peImau;
       fruser = peUser;

       frpoco = bepoco;
       frpaco = bepaco;
       frsebe = besebe;
       frriec = beriec;
       frxcob = bexcob;
       frcoma = becoma;
       frnrma = benrma;
       fresma = beesma;
       frmonr = bemonr;
       frmar2 = bemar2;

       chain bemonr gntmon;
       if %found(gntmon);
         frmoeq = momoeq;
       else;
         frmoeq = *Blanks;
       endif;

       if momoeq <> 'AU';
         @@fech = (*day*1000000)+(*month*10000)+*year;
         @@tipo = 'V';
         SP0052 ( bemonr : @@fech : frimco : @@tipo );
         if frimco = *zeros;
           frimco = 1;
         endif;
       else;
         frimco = 1;
       endif;
       frimau = frimmr * frimco;

       frnupe = *Zeros;
       frnroc = *Zeros;
       frimnr = *Zeros;
       frimna = *Zeros;
       frmar1 = *Off;
       frmar3 = *Off;
       frmar4 = *Off;
       frmar5 = *Off;
       frtime = %dec(%time():*iso);
       frfera = *year;
       frferm = *month;
       frferd = *day;

       write p1hsfr;

       return *On;

      /end-free

     P SVPSIN_setPahsfr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_updCtaCte(): Actualiza cuenta corriente               *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_updCtaCte...
     P                 B                   export
     D SVPSIN_updCtaCte...
     D                 pi              n
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D @@rama          s              2  0
     D @@sini          s              7  0
     D @@nops          s              7  0

      /free

       SVPSIN_inz();

       @@rama = peRama;
       @@sini = peSini;
       @@nops = peNops;

       SAR902 ( @@rama : @@sini : @@nops );

       return *On;

      /end-free

     P SVPSIN_updCtaCte...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getRva(): Retorna Rva Sola                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     P SVPSIN_getRva...
     P                 B                   export
     D SVPSIN_getRva...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshr          ds                  likerec(p1hshr:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       k1yshr.hrempr = beempr;
       k1yshr.hrsucu = besucu;
       k1yshr.hrrama = berama;
       k1yshr.hrsini = besini;
       k1yshr.hrnops = benops;
       k1yshr.hrpoco = bepoco;
       k1yshr.hrpaco = bepaco;
       k1yshr.hrnrdf = benrdf;

       setll %kds(k1yshr:8) pahshr;
       reade %kds(k1yshr:8) pahshr;
       dow not %eof and
           SPVFEC_ArmarFecha8 (hrfmoa : hrfmom : hrfmod: 'AMD' ) <= @@fech;
         @@mact += hrimau;
         reade %kds(k1yshr:8) pahshr;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getRva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFra(): Franquicia Sola                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Franquicia                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getFra...
     P                 B                   export
     D SVPSIN_getFra...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1ysfr          ds                  likerec(p1hsfr:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       k1ysfr.frempr = beempr;
       k1ysfr.frsucu = besucu;
       k1ysfr.frrama = berama;
       k1ysfr.frsini = besini;
       k1ysfr.frnops = benops;
       k1ysfr.frpoco = bepoco;
       k1ysfr.frpaco = bepaco;
       k1ysfr.frnrdf = benrdf;

       setll %kds(k1ysfr:8) pahsfr;
       reade %kds(k1ysfr:8) pahsfr;
       dow not %eof and
           SPVFEC_ArmarFecha8 (frfmoa : frfmom : frfmod: 'AMD' ) <= @@fech;
         @@mact += frimau;
         reade %kds(k1ysfr:8) pahsfr;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getFra...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPag(): Retorna Pagos solos                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Pagos                                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getPag...
     P                 B                   export
     D SVPSIN_getPag...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshp          ds                  likerec(p1hshp:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain(n) %kds(k1ysbe:6) pahsbe05;

       k1yshp.hpempr = beempr;
       k1yshp.hpsucu = besucu;
       k1yshp.hprama = berama;
       k1yshp.hpsini = besini;
       k1yshp.hpnops = benops;
       k1yshp.hppoco = bepoco;
       k1yshp.hppaco = bepaco;
       k1yshp.hpnrdf = benrdf;
       setll %kds(k1yshp:8) pahshp;
       reade %kds(k1yshp:8) pahshp;
       dow not %eof and
           SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
         @@mact += hpimau;
         reade %kds(k1yshp:8) pahshp;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getPag...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaAct(): Retorna Rva Actual                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Rva Actual                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getRvaAct...
     P                 B                   export
     D SVPSIN_getRvaAct...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D  @@fech         s              8  0
     D  @@rva          s             15  2
     D  @@fra          s             15  2
     D  @@pag          s             15  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@RVA =  SVPSIN_getRva (peEmpr
                              :peSucu
                              :peRama
                              :peSini
                              :peNops
                              :peNrdf
                              :@@fech);

       @@FRA =  SVPSIN_getFra (peEmpr
                              :peSucu
                              :peRama
                              :peSini
                              :peNops
                              :peNrdf
                              :@@fech);

       @@PAG =  SVPSIN_getPag (peEmpr
                              :peSucu
                              :peRama
                              :peSini
                              :peNops
                              :peNrdf
                              :@@fech);

       @@RVA = @@RVA - @@FRA - @@PAG;

       return @@RVA;

      /end-free

     P SVPSIN_getRvaAct...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCantSin(): Retorna cantidad de sinistros           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Pagos                                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getCantSin...
     P                 B                   export
     D SVPSIN_getCantSin...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yscd          ds                  likerec(p1hscd03:*key)

     D  @@fech         s              8  0
     D  @@cant         s              9  0

      /free

       SVPSIN_inz();

       @@cant = *Zeros;

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = pesucu;
       k1yscd.cdrama = perama;
       k1yscd.cdpoli = pepoli;
       setll %kds(k1yscd:4) pahscd03;
       reade %kds(k1yscd:4) pahscd03;
       dow not %eof and
           SPVFEC_ArmarFecha8 (cdfsia : cdfsim : cdfsid: 'AMD' ) <= @@fech;
         if cdsini <> 0;
           @@cant += 1;
         endif;
         reade %kds(k1yscd:4) pahscd03;
       enddo;

       return @@cant;

      /end-free

     P SVPSIN_getCantSin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPSIN_inz      B                   export
     D SVPSIN_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahscd);
         open pahscd;
       endif;

       if not %open(pahjhp);
         open pahjhp;
       endif;

       if not %open(pahjcr);
         open pahjcr;
       endif;

       if not %open(pahjc1);
         open pahjc1;
       endif;

       if not %open(set402);
         open set402;
       endif;

       if not %open(set4021);
         open set4021;
       endif;

       if not %open(pahsb1);
         open pahsb1;
       endif;

       if not %open(pahsb102);
         open pahsb102;
       endif;

       if not %open(pahsfr01);
         open pahsfr01;
       endif;

       if not %open(pahshe04);
         open pahshe04;
       endif;

       if not %open(pahsbe05);
         open pahsbe05;
       endif;

       if not %open(pahshr);
         open pahshr;
       endif;

       if not %open(pahsfr);
         open pahsfr;
       endif;

       if not %open(gntmon);
         open gntmon;
       endif;

       if not %open(pahshp);
         open pahshp;
       endif;

       if not %open(pahscd03);
         open pahscd03;
       endif;

       if not %open(pahet0);
         open pahet0;
       endif;

       if not %open(paher0);
         open paher0;
       endif;

       if not %open(pahev1);
         open pahev1;
       endif;

       if not %open(pahscd11);
         open pahscd11;
       endif;

       if not %open(pahshp04);
         open pahshp04;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(pahshp01);
         open pahshp01;
       endif;

       if not %open(set475);
         open set475;
       endif;

       if not %open(pahsva06);
         open pahsva06;
       endif;

       if not %open(pds00007);
         open pds00007;
       endif;

       if not %open(pds000);
         open pds000;
       endif;

       if not %open(pahsva);
         open pahsva;
       endif;

       if not %open(pahsbe);
         open pahsbe;
       endif;

       if not %open(pahsb2);
         open pahsb2;
       endif;

       if not %open(pahsb4);
         open pahsb4;
       endif;

       if not %open(pahshe01);
         open pahshe01;
       endif;

       if not %open(set456);
         open set456;
       endif;

       if not %open(pahshe);
         open pahshe;
       endif;

       if not %open(pahsc1);
         open pahsc1;
       endif;

       if not %open(pahsd1);
         open pahsd1;
       endif;

       if not %open(pahsd2);
         open pahsd2;
       endif;

       if not %open(pahstc);
         open pahstc;
       endif;

       if not %open(pahsd0);
         open pahsd0;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPSIN_inz      E

      * ------------------------------------------------------------ *
      * SVPSIN_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPSIN_End      B                   export
     D SVPSIN_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPSIN_End      E

      * ------------------------------------------------------------ *
      * SVPSIN_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPSIN_Error    B                   export
     D SVPSIN_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPSIN_Error    E

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
      * SVPSIN_getSumAsComp(): Retorna Suma Asegurada de Componente  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *                                                              *
      * Retorna: Suma Asegurada de Componente / -1 Error             *
      * ------------------------------------------------------------ *

     P SVPSIN_getSumAsComp...
     P                 B                   export
     D SVPSIN_getSumAsComp...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 options(*Nopass:*Omit)

     D k1yscd          ds                  likerec(p1hscd:*key)
     D k1yet0          ds                  likerec(p1het0:*key)
     D k1yer0          ds                  likerec(p1her0:*key)
     D k1yev1          ds                  likerec(p1hev1:*key)

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;
       k1yscd.cdnops = peNops;
       chain %kds ( k1yscd ) pahscd;

       if not %found ( pahscd );
         SetError( SVPSIN_SINNE
                 : 'Siniestro Inexistente' );
         return -1;
       endif;

       if pePoco < 9999;
         k1yet0.t0empr = cdempr;
         k1yet0.t0sucu = cdsucu;
         k1yet0.t0arcd = cdarcd;
         k1yet0.t0spol = cdspol;
         k1yet0.t0sspo = cdsspo;
         k1yet0.t0rama = cdrama;
         k1yet0.t0arse = cdarse;
         k1yet0.t0oper = cdoper;
         k1yet0.t0poco = pePoco;
         setll %kds ( k1yet0 : 9 ) pahet0;
         if %equal ( pahet0 );
           reade %kds ( k1yet0 : 9 ) pahet0;
           return t0vhvu;
         endif;

         k1yer0.r0empr = cdempr;
         k1yer0.r0sucu = cdsucu;
         k1yer0.r0arcd = cdarcd;
         k1yer0.r0spol = cdspol;
         k1yer0.r0sspo = cdsspo;
         k1yer0.r0rama = cdrama;
         k1yer0.r0arse = cdarse;
         k1yer0.r0oper = cdoper;
         k1yer0.r0poco = pePoco;
         setll %kds ( k1yer0 : 9 ) paher0;
         if %equal ( paher0 );
           reade %kds ( k1yer0 : 9 ) paher0;
           return r0sacm;
         endif;

       else;

         if not ( %parms >= 7 and %addr ( pePaco ) <> *Null );
           SetError( SVPSIN_PAREN
                   : 'Debe Informarse Parentesco' );
           return -1;
         endif;
         k1yev1.v1empr = cdempr;
         k1yev1.v1sucu = cdsucu;
         k1yev1.v1arcd = cdarcd;
         k1yev1.v1spol = cdspol;
         k1yev1.v1sspo = cdsspo;
         k1yev1.v1rama = cdrama;
         k1yev1.v1arse = cdarse;
         k1yev1.v1oper = cdoper;
         k1yev1.v1poco = pePoco;
         k1yev1.v1paco = pePaco;
         setll %kds ( k1yev1 : 10) pahev1;
         if %equal ( pahev1 );
           reade %kds ( k1yev1 : 10) pahev1;
           return v1sacm;
         endif;

       endif;

       return -1;

      /end-free

     P SVPSIN_getSumAsComp...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getIndem(): Retorna Pagos de tipo Indemnizacion       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Indemnizaciones                                     *
      * ------------------------------------------------------------ *

     P SVPSIN_getIndem...
     P                 B                   export
     D SVPSIN_getIndem...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshp          ds                  likerec(p1hshp:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       k1yshp.hpempr = beempr;
       k1yshp.hpsucu = besucu;
       k1yshp.hprama = berama;
       k1yshp.hpsini = besini;
       k1yshp.hpnops = benops;
       k1yshp.hppoco = bepoco;
       k1yshp.hppaco = bepaco;
       k1yshp.hpnrdf = benrdf;

       setll %kds(k1yshp:8) pahshp;
       reade %kds(k1yshp:8) pahshp;
       dow not %eof and
           SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
         if hpmar1 = 'I';
           @@mact += hpimau;
         endif;
         reade %kds(k1yshp:8) pahshp;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getIndem...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getEstSin(): Retorna Estado del Siniestro             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Siniestro                                *
      * ------------------------------------------------------------ *

     P SVPSIN_getEstSin...
     P                 B                   export
     D SVPSIN_getEstSin...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yshe          ds                  likerec(p1hshe04:*key)

      /free

       SVPSIN_inz();

       k1yshe.heempr = peEmpr;
       k1yshe.hesucu = peSucu;
       k1yshe.herama = peRama;
       k1yshe.hesini = peSini;
       k1yshe.henops = peNops;

       if ( ( %parms >= 6 ) and ( %addr( peFech ) <> *Null ) );
         k1yshe.hefema = SPVFEC_ObtAÑoFecha8 ( peFech );
         k1yshe.hefemm = SPVFEC_ObtMesFecha8 ( peFech );
         k1yshe.hefemd = SPVFEC_ObtDiaFecha8 ( peFech );
         setll %kds( k1yshe : 8 ) pahshe04;
       else;
         setll %kds( k1yshe : 5 ) pahshe04;
       endif;

       reade %kds( k1yshe : 5 ) pahshe04;

       if %eof ( pahshe04 );
         return *Zeros;
       endif;

       return hecesi;

      /end-free

     P SVPSIN_getEstSin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getEstRec(): Retorna Estado del Reclamo               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componenete                           *
      *     pePaco   (input)   Parentesco                            *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Reclamo                                  *
      * ------------------------------------------------------------ *

     P SVPSIN_getEstRec...
     P                 B                   export
     D SVPSIN_getEstRec...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSebe                       6  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysb1          ds                  likerec(p1hsb1:*key)

      /free

       SVPSIN_inz();

       k1ysb1.b1empr = peEmpr;
       k1ysb1.b1sucu = peSucu;
       k1ysb1.b1rama = peRama;
       k1ysb1.b1sini = peSini;
       k1ysb1.b1nops = peNops;
       k1ysb1.b1poco = pePoco;
       k1ysb1.b1paco = pePaco;
       k1ysb1.b1riec = peRiec;
       k1ysb1.b1xcob = peXcob;
       k1ysb1.b1nrdf = peNrdf;
       k1ysb1.b1sebe = peSebe;

       if ( ( %parms >= 12 ) and ( %addr( peFech ) <> *Null ) );
         k1ysb1.b1fema = SPVFEC_ObtAÑoFecha8 ( peFech );
         k1ysb1.b1femm = SPVFEC_ObtMesFecha8 ( peFech );
         k1ysb1.b1femd = SPVFEC_ObtDiaFecha8 ( peFech );
         setll %kds( k1ysb1 : 14 ) pahsb1;
       else;
         setll %kds( k1ysb1 : 11 ) pahsb1;
       endif;

       reade %kds( k1ysb1 : 11 ) pahsb1;

       if %eof( pahsb1 );
         return *Zeros;
       endif;

       return b1cesi;

      /end-free

     P SVPSIN_getEstRec...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getEstJui(): Retorna Estado del Juicio                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peNrcj   (input)   Carpeta de Juicio                     *
      *     peJuin   (input)   Numero de Juicio                      *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Juicio                                   *
      * ------------------------------------------------------------ *

     P SVPSIN_getEstJui...
     P                 B                   export
     D SVPSIN_getEstJui...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peNrcj                       6  0 const
     D   peJuin                       6  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yjc1          ds                  likerec(p1hjc1:*key)

      /free

       SVPSIN_inz();

       k1yjc1.j1empr = peEmpr;
       k1yjc1.j1sucu = peSucu;
       k1yjc1.j1rama = peRama;
       k1yjc1.j1sini = peSini;
       k1yjc1.j1nops = peNops;
       k1yjc1.j1nrdf = peNrdf;
       k1yjc1.j1sebe = peSebe;
       k1yjc1.j1nrcj = peNrcj;
       k1yjc1.j1juin = peJuin;

       if ( ( %parms >= 10 ) and ( %addr( peFech ) <> *Null ) );
         k1yjc1.j1fema = SPVFEC_ObtAÑoFecha8 ( peFech );
         k1yjc1.j1femm = SPVFEC_ObtMesFecha8 ( peFech );
         k1yjc1.j1femd = SPVFEC_ObtDiaFecha8 ( peFech );
         setll %kds( k1yjc1 : 12 ) pahjc1;
       else;
         setll %kds( k1yjc1 : 9 ) pahjc1;
       endif;

       reade %kds( k1yjc1 : 9 ) pahjc1;

       if %eof( pahjc1 );
         return *Zeros;
       endif;

       return j1cesi;

      /end-free

     P SVPSIN_getEstJui...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniPend(): Retorna si siniestro esta pendiente    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSiniPend...
     P                 B                   export
     D SVPSIN_chkSiniPend...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1y402          ds                  likerec(s1t402:*key)

      /free

       SVPSIN_inz();

       k1y402.t@empr = peEmpr;
       k1y402.t@sucu = peSucu;
       k1y402.t@rama = peRama;
       k1y402.t@cesi = SVPSIN_getEstSin ( peEmpr : peSucu :
                                          peRama : peSini : peNops );

       chain %kds ( k1y402 ) set402;

       if t@cese = 'TR' or t@cese = 'RC';
         setError(SVPSIN_NOTER:'El Siniestro ya esta terminado');
         return *Off;
       else;
         return *On;
       endif;

      /end-free

     P SVPSIN_chkSiniPend...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniPag(): Retorna si siniestro tiene un pagos e/  *
      *                      determiandas fechas                     *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFdes   (input)   Fecha Desde                           *
      *     peFhas   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSiniPag...
     P                 B                   export
     D SVPSIN_chkSiniPag...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 options (*Omit:*Nopass)

     D @@fdes          s              8  0
     D @@fhas          s              8  0

     D k1yh04          ds                  likerec(p1hshp04:*key)

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr ( peFhas ) <> *Null;
         @@fhas = peFhas;
       else;
         @@fhas = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@fdes = peFdes;

       k1yh04.hpempr = peEmpr;
       k1yh04.hpsucu = peSucu;
       k1yh04.hprama = peRama;
       k1yh04.hpsini = peSini;
       k1yh04.hpnops = peNops;
       k1yh04.hpfmoa = SPVFEC_ObtAÑoFecha8 ( @@fdes );
       k1yh04.hpfmom = SPVFEC_ObtMesFecha8 ( @@fdes );
       k1yh04.hpfmod = SPVFEC_ObtDiaFecha8 ( @@fdes );

       setll %kds( k1yh04 : 8 ) p1hshp04;
       reade %kds( k1yh04 : 5 ) p1hshp04;

       select;
         when %eof ( pahshp04 );
           return *Off;
         when SPVFEC_ArmarFecha8 ( hpfmoa : hpfmom : hpfmod : 'AMD' )
                                 <= @@fhas;
           return *On;
         other;
           return *Off;
       endsl;

      /end-free

     P SVPSIN_chkSiniPag...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniDen(): Retorna si siniestro tiene denuncia e/  *
      *                      determinadas fechas                     *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Póliza                          *
      *     peFdes   (input)   Fecha Desde                           *
      *     peFhas   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSiniDen...
     P                 B                   export
     D SVPSIN_chkSiniDen...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 options (*Omit:*Nopass)

     D @@fdes          s              8  0
     D @@fhas          s              8  0

     D k1yd11          ds                  likerec(p1hscd11:*key)

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr ( peFhas ) <> *Null;
         @@fhas = peFhas;
       else;
         @@fhas = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@fdes = peFdes;

       k1yd11.cdempr = peEmpr;
       k1yd11.cdsucu = peSucu;
       k1yd11.cdarcd = peArcd;
       k1yd11.cdspol = peSpol;

       setll %kds( k1yd11 : 4 ) p1hscd11;
       reade %kds( k1yd11 : 4 ) p1hscd11;

       dow not %eof ( pahscd11 );
         if SPVFEC_ArmarFecha8 (cdfdea : cdfdem : cdfded: 'AMD' ) >= @@fdes
         and SPVFEC_ArmarFecha8 (cdfdea : cdfdem : cdfded: 'AMD' ) <= @@fhas;
           return *On;
         endif;
         reade %kds( k1yd11 : 4 ) p1hscd11;
       enddo;

       return *Off;

      /end-free

     P SVPSIN_chkSiniDen...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSini(): Retorna si tiene siniestros                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Póliza                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getSini...
     P                 B                   export
     D SVPSIN_getSini...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yd11          ds                  likerec(p1hscd11:*key)

      /free

       SVPSIN_inz();

       k1yd11.cdempr = peEmpr;
       k1yd11.cdsucu = peSucu;
       k1yd11.cdarcd = peArcd;
       k1yd11.cdspol = peSpol;

       setll %kds( k1yd11 : 4 ) p1hscd11;

       if %equal;
         SetError( SVPSIN_GETSI
                 : 'Poliza con Siniestros' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_getSini...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkWeb(): Devuelve si viaja a Web                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Nro de Operacion                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkWeb...
     P                 B                   export
     D SVPSIN_chkWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      /free

       SVPSIN_inz();

      * Existencia de Rama
       setll peRama set001;

       if not %equal (set001);
          SetError( SVPSIN_RAMAI
                  : 'Rama Inexistente' );
          return *Off;
       endif;

      * Existencia de Siniestro
       if not SVPSIN_chksini ( peEmpr : peSucu : peRama : peSini
                             : peNops);
          return *Off;
       endif;

       return *on;
      /end-free

     P SVPSIN_chkWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPagosJui(): Retorna Pagos de Juicio                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Indemnizaciones                                     *
      * ------------------------------------------------------------ *

     P SVPSIN_getPagosJui...
     P                 B                   export
     D SVPSIN_getPagosJui...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yjhp          ds                  likerec(p1hjhp:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1yjhp.jpempr = peEmpr;
       k1yjhp.jpsucu = peSucu;
       k1yjhp.jprama = peRama;
       k1yjhp.jpsini = peSini;
       k1yjhp.jpnops = peNops;
       setll %kds( k1yjhp : 5 ) pahjhp;
       reade %kds( k1yjhp : 5 ) pahjhp;

       dow not %eof and
           SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
         if jpmar1 = 'I';
           @@mact += jpimmr;
         endif;
         reade %kds( k1yjhp : 5 ) pahjhp;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getPagosJui...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSpol(): Retorna  Superpoliza/Suplemento/Articulo   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peArcd   (output)  Articulo                              *
      *     peSpol   (output)  Super Poliza                          *
      *     peSspo   (output)  Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1                                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getSpol...
     P                 B                   export
     D SVPSIN_getSpol...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 options( *omit : *nopass )
     D   peArcd                       6  0 options( *omit : *nopass )
     D   peSpol                       9  0 options( *omit : *nopass )
     D   peSspo                       3  0 options( *omit : *nopass )

     D k1yscd          ds                  likerec( p1hscd : *key )

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;

       if %parms >= 5 and %addr(peNops) <> *Null;
         k1yscd.cdnops = peNops;
         chain(n) %kds( k1yscd : 5 ) pahscd;
           if not %found( pahscd );
             return -1;
           endif;
       else;
         setgt     %kds( k1yscd : 4 ) pahscd;
         readpe(n) %kds( k1yscd : 4 ) pahscd;
            if not %eof( pahscd );
              return -1;
            endif;
       endif;

       if %parms >= 6 and %addr(peArcd) <> *Null;
         peArcd = cdarcd;
       endif;

       if %parms >= 7 and %addr(peSpol) <> *Null;
         peSpol = cdspol;
       endif;
       if %parms >= 8 and %addr(peSspo) <> *Null;
         peSspo = cdsspo;
       endif;

       return 0;

     P SVPSIN_getSpol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPSIN_getPol(): Retorna  Poliza                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: Poliza / -1                                         *
      * ------------------------------------------------------------ *

     P SVPSIN_getPol...
     P                 B                   export
     D SVPSIN_getPol...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 options( *omit : *nopass )

     D k1yscd          ds                  likerec( p1hscd : *key )

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;

       if %parms >= 5 and %addr(peNops) <> *Null;
         k1yscd.cdnops = peNops;
         chain(n) %kds( k1yscd : 5 ) pahscd;
           if not %found( pahscd );
             return -1;
           endif;
       else;
         setgt     %kds( k1yscd : 4 ) pahscd;
         readpe(n) %kds( k1yscd : 4 ) pahscd;
            if not %eof( pahscd );
              return -1;
            endif;
       endif;

       return cdpoli;

     P SVPSIN_getPol...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCausaReno(): Verifica si tiene Siniestros con      *
      * causa: 5-Rono Unidad / 7-Incendio Total / 9-Destrucción Total*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCausaReno...
     P                 B                   export
     D SVPSIN_chkCausaReno...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D k1yscd          ds                  likerec( p1hscd03 : *key )

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdpoli = pePoli;
       setll %kds( k1yscd : 4 ) pahscd03;
       reade %kds( k1yscd : 4 ) pahscd03;

       dow not %eof ( pahscd03 );

         if cdcauc = 5 or cdcauc = 7 or cdcauc = 9;
           SetError( SVPSIN_POLSI
                   : 'Polizas con Siniestros' );
           return *Off;
         endif;

         reade %kds( k1yscd : 4 ) pahscd03;

       enddo;

       return *On;

     P SVPSIN_chkCausaReno...
     P                 E
      * ------------------------------------------------------------ *
      * SVPSIN_getPagos:Retorna Pagos Historicos de una poliza por   *
      *                 Codigo de Area Tecnica y Nro de Comprobante  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Codigo Area Tecnica                  *
      *     pePacp   ( input  ) Nro. de Comprobante de Pago          *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsSi   ( output ) Estructura de Pagos                  *
      *     peDsSiC  ( output ) Cantidad de Pagos                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getPagos...
     P                 B                   export
     D SVPSIN_getPagos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsSi                            likeds ( DsPahshp01_t ) dim(999)
     D   peDsSiC                     10i 0

     D   k1ish1        ds                  likerec( p1hshp01 : *key   )
     D   @@DsISi       ds                  likerec( p1hshp01 : *input )

      /free

       SVPSIN_inz();

       clear peDsSi;
       clear peDsSiC;
       k1ish1.hpempr = peEmpr;
       k1ish1.hpsucu = peSucu;
       k1ish1.hpartc = peArtc;
       k1ish1.hppacp = pePacp;
       k1ish1.hprama = peRama;
       k1ish1.hpsini = peSini;
       setll %kds( k1ish1 : 6 ) pahshp01;
       if not %equal;
         return *off;
       endif;
       reade %kds( k1ish1 : 6 ) pahshp01 @@DsISi;
       dow not %eof( pahshp01 );
         peDsSiC += 1;
         eval-corr peDsSi( peDsSiC ) = @@DsISi;
        reade %kds( k1ish1 : 6 ) pahshp01 @@DsISi;
       enddo;

       return *on;

      /end-free

     P SVPSIN_getPagos...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFechaDelDia: Retorna fecha de día de hoy           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *                                                              *
      * Retorna: Fecha                                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getFechaDelDia...
     P                 B                   export
     D SVPSIN_getFechaDelDia...
     D                 pi             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0
     D @@Fech          s              8  0

      /free

       SVPSIN_inz();

       DBA456R ( @@a : @@m : @@d );

       @@Fech = ( @@a * 10000 + @@m * 100 + @@d );

       return @@Fech;

      /end-free

     P SVPSIN_getFechaDelDia...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getConfiguracionVoucherRuedasCristales: Retorna Con-  *
      *                                    fiuracion de Voucher de   *
      *                                    Ruedas y Cristales        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peQrev   ( output ) Cantidad de Ruedas por Evento        *
      *     peFrue   ( output ) Frecuencia de Ruedas                 *
      *     peFcri   ( output ) Frecuencia de Cristales              *
      *     peFech   ( input  ) Fecha                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getConfiguracionVoucherRuedasCristales...
     P                 B                   export
     D SVPSIN_getConfiguracionVoucherRuedasCristales...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peQrev                       1  0
     D   peFrue                       3  0
     D   peFcri                       3  0
     D   peFech                       8  0 options( *omit : *nopass ) const

     D @@Fech          s              8  0
     D k1y475          ds                  likerec( s1t475 : *key )

      /free

       SVPSIN_inz();

       if %parms >= 3 and %addr(peFech) = *Null;

         @@Fech = SVPSIN_getFechaDelDia( peEmpr
                                       : peSucu );
       else;
         @@Fech = peFech;
       endif;

       k1y475.t475_t@Empr = peEmpr;
       k1y475.t475_t@Sucu = peSucu;
       k1y475.t475_t@Fech = @@Fech;
       setll    %kds( k1y475 : 3 ) set475;
       reade(n) %kds( k1y475 : 2 ) set475;
       if not %eof( set475 );
         peQrev = t475_t@Qrev;
         peFrue = t475_t@Frue;
         peFcri = t475_t@Fcri;
         return *on;
       else;
         return *off;
       endif;

      /end-free

     P SVPSIN_getConfiguracionVoucherRuedasCristales...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCantidadSiniestrosRuedasPorVehiculo: Retorna Can-  *
      *                                    tidad de Siniestros de    *
      *                                    Ruedas por Vehiculo       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNmat   ( input  ) Matricula/Patente                    *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *                                                              *
      * Retorna: Cantidad de Siniestros                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getCantidadSiniestrosRuedasPorVehiculo...
     P                 B                   export
     D SVPSIN_getCantidadSiniestrosRuedasPorVehiculo...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D @@Cant          s             10i 0
     D k1yscd          ds                  likerec( p1hscd03 : *key )
     D k1ysva          ds                  likerec( p1hsva06 : *key )
     D k1s007          ds                  likerec( p1ds0007 : *key )

      /free

       SVPSIN_inz();

       clear @@Cant;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdPoli = pePoli;
       setll %kds( k1yscd:4 ) pahscd03;
       reade %kds( k1yscd:4 ) pahscd03;
       dow not %eof( pahscd03 );
         if cdsini <> 0 and cdCauc = 12;

           k1ysva.vaEmpr = peEmpr;
           k1ysva.vaSucu = peSucu;
           k1ysva.vaNmat = peNmat;
           k1ysva.vaRama = peRama;
           k1ysva.vaSini = cdSini;
           chain %kds( k1ysva : 5 ) pahsva06;
           if %found( pahsva06 );
             @@cant += 1;
           endif;

         endif;
         reade %kds( k1yscd:4 ) pahscd03;
       enddo;

       k1s007.s007_p0empr = peEmpr;
       k1s007.s007_p0sucu = peSucu;
       k1s007.s007_p0pate = peNmat;
       setll %kds( k1s007 : 3 ) pds00007;
       dou %eof(pds00007);
         reade %kds( k1s007 : 3 ) pds00007;
         if not %eof(pds00007);
           if s007_p0caus = 12;
             if s007_p0sini = *zeros;
               @@cant += 1;
             endif;
           endif;
         endif;
       enddo;

       return @@cant;

      /end-free

     P SVPSIN_getCantidadSiniestrosRuedasPorVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCantidadSiniestrosCristalesPorVehiculo: Retorna    *
      *                                    Cantidad de Siniestros de *
      *                                    Ruedas por Vehiculo       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNmat   ( input  ) Matricula/Patente                    *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *                                                              *
      * Retorna: Cantidad de Siniestros                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getCantidadSiniestrosCristalesPorVehiculo...
     P                 B                   export
     D SVPSIN_getCantidadSiniestrosCristalesPorVehiculo...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D @@Cant          s             10i 0
     D k1yscd          ds                  likerec( p1hscd03 : *key )
     D k1ysva          ds                  likerec( p1hsva06 : *key )
     D k1s007          ds                  likerec( p1ds0007 : *key )

      /free

       SVPSIN_inz();

       clear @@Cant;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdPoli = pePoli;
       setll %kds( k1yscd:4 ) pahscd03;
       reade %kds( k1yscd:4 ) pahscd03;
       dow not %eof( pahscd03 );
         if cdsini <> 0 and cdCauc = 15;

           k1ysva.vaEmpr = peEmpr;
           k1ysva.vaSucu = peSucu;
           k1ysva.vaNmat = peNmat;
           k1ysva.vaRama = peRama;
           k1ysva.vaSini = cdSini;
           chain %kds( k1ysva : 5 ) pahsva06;
           if %found( pahsva06 );
             @@cant += 1;
           endif;

         endif;
         reade %kds( k1yscd:4 ) pahscd03;
       enddo;

       k1s007.s007_p0empr = peEmpr;
       k1s007.s007_p0sucu = peSucu;
       k1s007.s007_p0pate = peNmat;
       setll %kds( k1s007 : 3 ) pds00007;
       dou %eof(pds00007);
         reade %kds( k1s007 : 3 ) pds00007;
         if not %eof(pds00007);
           if s007_p0caus = 15;
             if s007_p0sini = *zeros;
               @@cant += 1;
             endif;
           endif;
         endif;
       enddo;

       return @@cant;

      /end-free

     P SVPSIN_getCantidadSiniestrosCristalesPorVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getNumeroVoucher: Retorna Número de Voucher           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *                                                              *
      * Retorna: Número                                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getNumeroVoucher...
     P                 B                   export
     D SVPSIN_getNumeroVoucher...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

     D @@Nres          s              7  0

      /free

       SVPSIN_inz();

       SPT902 ('!': @@Nres );

       return @@Nres;

      /end-free

     P SVPSIN_getNumeroVoucher...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setNumeroVoucher: Retorna Número de Voucher           *
      *                                                              *
      *     peBase   ( input  ) Parametros Base                      *
      *     peNpds   ( input  ) Número de Pre-Denuncia               *
      *     peNore   ( input  ) Número de Voucher ó Orden Reposición *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setNumeroVoucher...
     P                 B                   export
     D SVPSIN_setNumeroVoucher...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peNore                       7  0 const

     D k1s000          ds                  likerec(p1ds00:*key)
     D peMsgs          ds                  likeds(paramMsgs)
     D @repl           s          65535a

      /free

       SVPSIN_inz();

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
         return *off;
       endif;

       k1s000.p0empr = peBase.peEmpr;
       k1s000.p0sucu = peBase.peSucu;
       k1s000.p0nivt = peBase.peNivt;
       k1s000.p0nivc = peBase.peNivc;
       k1s000.p0npds = peNpds;
       chain %kds( k1s000:5 ) pds000;
       if %found( pds000 );
         p0User = ususr2;
         p0Date = (*year * 10000)
                + (*month *  100)
                +  *day;
         p0Time = %dec(%time():*iso);
         p0Nore = peNore;
         update p1ds00;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_setNumeroVoucher...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCaratula(): Retorna Carátula de Denuncia de        *
      *                       Siniestro.-                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     peDsCd   ( output ) Estructura de Carátula de Siniestro  *
      *     peDsCdC  ( output ) Cantidad de Carátula de Siniestro    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getCaratula...
     P                 B                   export
     D SVPSIN_getCaratula...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsCd                            likeds ( DsPahscd_t )

     D   k1yscd        ds                  likerec( p1hscd : *key   )
     D   @@DsIcd       ds                  likerec( p1hscd : *input )

      /free

       SVPSIN_inz();

       clear peDsCd;
       clear @@DsIcd;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdSini = peSini;
       k1yscd.cdNops = peNops;
       chain %kds( k1yscd : 5 ) pahscd @@DsIcd;
       if not %found( pahscd );
         return *off;
       endif;

       eval-corr peDsCd = @@DsIcd;

       return *on;

      /end-free

     P SVPSIN_getCaratula...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getVehiculo(): Retorna Siniestro de Vehículo del      *
      *                       Asegurado.-                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peVhmc   ( input  ) Marca de Vehículo                    *
      *     peVhmo   ( input  ) Código de Modelo                     *
      *     peVhcs   ( input  ) Código de Submodelo                  *
      *     pePsec   ( input  ) Nro de Secuencia                     *
      *     peDsCd   ( output ) Estructura de Siniestro de Vehículo  *
      *     peDsCdC  ( output ) Cantidad de Siniestro de Vehículo    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getVehiculo...
     P                 B                   export
     D SVPSIN_getVehiculo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peVhmc                       3    options(*nopass:*omit) const
     D   peVhmo                       3    options(*nopass:*omit) const
     D   peVhcs                       3    options(*nopass:*omit) const
     D   pePsec                       2  0 options(*nopass:*omit) const
     D   peDsVa                            likeds ( DsPahsva_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsVaC                     10i 0 options(*nopass:*omit)

     D   k1ysva        ds                  likerec( p1hsva : *key   )
     D   @@DsIva       ds                  likerec( p1hsva : *input )
     D   @@DsVa        ds                  likeds ( DsPahsva_t ) dim(999)
     D   @@DsVaC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsVa;
       clear @@DsVaC;

       k1ysva.vaEmpr = peEmpr;
       k1ysva.vaSucu = peSucu;
       k1ysva.vaRama = peRama;
       k1ysva.vaSini = peSini;
       k1ysva.vaNops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peVhmc ) <> *null
                           and %addr( peVhmo ) <> *null
                           and %addr( peVhcs ) <> *null
                           and %addr( pePsec ) <> *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           k1ysva.vaVhmo =  peVhmo;
           k1ysva.vaVhcs =  peVhcs;
           k1ysva.vaPsec =  pePsec;
           setll %kds( k1ysva : 11 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 11 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 11 ) pahsva @@DsIva;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peVhmc ) <> *null
                           and %addr( peVhmo ) <> *null
                           and %addr( peVhcs ) <> *null
                           and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           k1ysva.vaVhmo =  peVhmo;
           k1ysva.vaVhcs =  peVhcs;
           setll %kds( k1ysva : 10 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 10 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 10 ) pahsva @@DsIva;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peVhmc ) <> *null
                          and %addr( peVhmo ) <> *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           k1ysva.vaVhmo =  peVhmo;
           setll %kds( k1ysva : 9 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 9 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 9 ) pahsva @@DsIva;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peVhmc ) <> *null
                          and %addr( peVhmo ) =  *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           setll %kds( k1ysva : 8 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 8 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 8 ) pahsva @@DsIva;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peVhmc ) =  *null
                          and %addr( peVhmo ) =  *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           setll %kds( k1ysva : 7 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 7 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 7 ) pahsva @@DsIva;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peVhmc ) =  *null
                          and %addr( peVhmo ) =  *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           setll %kds( k1ysva : 6 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 6 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 6 ) pahsva @@DsIva;
           enddo;

         other;

           setll %kds( k1ysva : 5 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 5 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 5 ) pahsva @@DsIva;
           enddo;

       endsl;

       if %addr( peDsVa ) <> *null;
         eval-corr peDsVa = @@DsVa;
       endif;

       if %addr( peDsVaC ) <> *null;
         peDsVaC = @@DsVaC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getBeneficiarios(): Retorna Beneficiarios del         *
      *                            Siniestro.-                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsBe   ( output ) Estructura de Beneficiarios de Sini. *
      *     peDsBeC  ( output ) Cantidad de Beneficiario de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getBeneficiarios...
     P                 B                   export
     D SVPSIN_getBeneficiarios...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsBe                            likeds ( DsPahsbe_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsBeC                     10i 0 options(*nopass:*omit)

     D   k1ysbe        ds                  likerec( p1hsbe : *key   )
     D   @@DsIbe       ds                  likerec( p1hsbe : *input )
     D   @@DsBe        ds                  likeds ( DsPahsbe_t ) dim(999)
     D   @@DsBeC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsBe;
       clear @@DsBeC;

       k1ysbe.beEmpr = peEmpr;
       k1ysbe.beSucu = peSucu;
       k1ysbe.beRama = peRama;
       k1ysbe.beSini = peSini;
       k1ysbe.beNops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           k1ysbe.beNrdf =  peNrdf;
           k1ysbe.beSebe =  peSebe;
           setll %kds( k1ysbe : 11 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 11 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 11 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           k1ysbe.beNrdf =  peNrdf;
           setll %kds( k1ysbe : 10 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 10 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 10 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           setll %kds( k1ysbe : 9 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 9 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 9 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           setll %kds( k1ysbe : 8 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 8 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 8 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           setll %kds( k1ysbe : 7 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 7 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 7 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           setll %kds( k1ysbe : 6 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 6 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 6 ) pahsbe @@DsIbe;
           enddo;

         other;

           setll %kds( k1ysbe : 5 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 5 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 5 ) pahsbe @@DsIbe;
           enddo;

       endsl;

       if %addr( peDsBe ) <> *null;
         eval-corr peDsBe = @@DsBe;
       endif;

       if %addr( peDsBeC ) <> *null;
         peDsBeC = @@DsBeC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getBeneficiarios...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSubsiniestros(): Retorna Subsiniestros del         *
      *                            Siniestro.-                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peFema   ( input  ) Fecha de Emisión Año                 *
      *     peFemm   ( input  ) Fecha de Emisión Mes                 *
      *     peFemd   ( input  ) Fecha de Emisión Día                 *
      *     peDsBe   ( output ) Estructura de Subsiniestros de Sini. *
      *     peDsBeC  ( output ) Cantidad de Subsiniestro de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getSubsiniestros...
     P                 B                   export
     D SVPSIN_getSubsiniestros...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peFema                       4  0 options(*nopass:*omit) const
     D   peFemm                       2  0 options(*nopass:*omit) const
     D   peFemd                       2  0 options(*nopass:*omit) const
     D   peDsB1                            likeds ( DsPahsb1_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB1C                     10i 0 options(*nopass:*omit)

     D   k1ysb1        ds                  likerec( p1hsb1 : *key   )
     D   @@DsIb1       ds                  likerec( p1hsb1 : *input )
     D   @@DsB1        ds                  likeds ( DsPahsb1_t ) dim(999)
     D   @@DsB1C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB1;
       clear @@DsB1C;

       k1ysb1.b1Empr = peEmpr;
       k1ysb1.b1Sucu = peSucu;
       k1ysb1.b1Rama = peRama;
       k1ysb1.b1Sini = peSini;
       k1ysb1.b1Nops = peNops;

       select;
         when %parms >= 14 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) <> *null
                           and %addr( peFemm ) <> *null
                           and %addr( peFemd ) <> *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           k1ysb1.b1Fema =  peFema;
           k1ysb1.b1Femm =  peFemm;
           k1ysb1.b1Femd =  peFemd;
           setll %kds( k1ysb1 : 14 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 14 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 14 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 13 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) <> *null
                           and %addr( peFemm ) <> *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           k1ysb1.b1Fema =  peFema;
           k1ysb1.b1Femm =  peFemm;
           setll %kds( k1ysb1 : 13 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 13 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 13 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 12 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) <> *null
                           and %addr( peFemm ) =  *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           k1ysb1.b1Fema =  peFema;
           setll %kds( k1ysb1 : 12 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 12 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 12 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) =  *null
                           and %addr( peFemm ) =  *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           setll %kds( k1ysb1 : 11 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 11 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 11 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null
                           and %addr( peFema ) =  *null
                           and %addr( peFemm ) =  *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           setll %kds( k1ysb1 : 10 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 10 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 10 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           setll %kds( k1ysb1 : 9 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 9 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 9 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           setll %kds( k1ysb1 : 8 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 8 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 8 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           setll %kds( k1ysb1 : 7 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 7 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 7 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           setll %kds( k1ysb1 : 6 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 6 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 6 ) pahsb1 @@DsIb1;
           enddo;

         other;

           setll %kds( k1ysb1 : 5 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 5 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 5 ) pahsb1 @@DsIb1;
           enddo;

       endsl;

       if %addr( peDsB1 ) <> *null;
         eval-corr peDsB1 = @@DsB1;
       endif;

       if %addr( peDsB1C ) <> *null;
         peDsB1C = @@DsB1C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getSubsiniestros...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getUltimoSubsiniestro(): Retorna Ultimo estado del    *
      *                                 Subsiniestro.-               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsb1   ( output ) Estructura de Subsiniestro           *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getUltimoSubsiniestro...
     P                 B                   export
     D SVPSIN_getUltimoSubsiniestro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peDsb1                            likeds( DsPahsb1_t )

     D   @@DsB1        ds                  likeds( DsPahsb1_t ) dim(999)
     D   @@DsB1C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB1;
       clear @@DsB1C;

       if SVPSIN_getSubsiniestros( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : pePoco
                                 : pePaco
                                 : peRiec
                                 : peXcob
                                 : peNrdf
                                 : peSebe
                                 : *omit
                                 : *omit
                                 : *omit
                                 : @@DsB1
                                 : @@DsB1C );

         eval-corr peDsB1 = @@DsB1(1);
         return *on;

       endif;

       return *off;

       /end-free

     P SVPSIN_getUltimoSubsiniestro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getConductorTercero(): Retorna Datos del Conductor    *
      *                               Tercero del Siniestros.-       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsB2   ( output ) Estructura de Conductor Tercero      *
      *     peDsB2C  ( output ) Cantidad de Conductor Tercero        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getConductorTercero...
     P                 B                   export
     D SVPSIN_getConductorTercero...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsB2                            likeds ( DsPahsb2_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB2C                     10i 0 options(*nopass:*omit)

     D   k1ysb2        ds                  likerec( p1hsb2 : *key   )
     D   @@DsIb2       ds                  likerec( p1hsb2 : *input )
     D   @@DsB2        ds                  likeds ( DsPahsb2_t ) dim(999)
     D   @@DsB2C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB2;
       clear @@DsB2C;

       k1ysb2.b2Empr = peEmpr;
       k1ysb2.b2Sucu = peSucu;
       k1ysb2.b2Rama = peRama;
       k1ysb2.b2Sini = peSini;
       k1ysb2.b2Nops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           k1ysb2.b2Xcob =  peXcob;
           k1ysb2.b2Nrdf =  peNrdf;
           k1ysb2.b2Sebe =  peSebe;
           setll %kds( k1ysb2 : 11 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 11 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 11 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           k1ysb2.b2Xcob =  peXcob;
           k1ysb2.b2Nrdf =  peNrdf;
           setll %kds( k1ysb2 : 10 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 10 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 10 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           k1ysb2.b2Xcob =  peXcob;
           setll %kds( k1ysb2 : 9 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 9 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 9 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           setll %kds( k1ysb2 : 8 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 8 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 8 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           setll %kds( k1ysb2 : 7 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 7 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 7 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           setll %kds( k1ysb2 : 6 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 6 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 6 ) pahsb2 @@DsIb2;
           enddo;

         other;

           setll %kds( k1ysb2 : 5 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 5 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 5 ) pahsb2 @@DsIb2;
           enddo;

       endsl;

       if %addr( peDsB2 ) <> *null;
         eval-corr peDsB2 = @@DsB2;
       endif;

       if %addr( peDsB2C ) <> *null;
         peDsB2C = @@DsB2C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getConductorTercero...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getVehiculoTercero(): Retorna Datos del Vehiculo del  *
      *                              Tercero del Siniestro.-         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsB4   ( output ) Estructura de Conductor Tercero      *
      *     peDsB4C  ( output ) Cantidad de Conductor Tercero        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getVehiculoTercero...
     P                 B                   export
     D SVPSIN_getVehiculoTercero...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsB4                            likeds ( DsPahsb4_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB4C                     10i 0 options(*nopass:*omit)

     D   k1ysb4        ds                  likerec( p1hsb4 : *key   )
     D   @@DsIb4       ds                  likerec( p1hsb4 : *input )
     D   @@DsB4        ds                  likeds ( DsPahsb4_t ) dim(999)
     D   @@DsB4C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB4;
       clear @@DsB4C;

       k1ysb4.b4Empr = peEmpr;
       k1ysb4.b4Sucu = peSucu;
       k1ysb4.b4Rama = peRama;
       k1ysb4.b4Sini = peSini;
       k1ysb4.b4Nops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           k1ysb4.b4Xcob =  peXcob;
           k1ysb4.b4Nrdf =  peNrdf;
           k1ysb4.b4Sebe =  peSebe;
           setll %kds( k1ysb4 : 11 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 11 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 11 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           k1ysb4.b4Xcob =  peXcob;
           k1ysb4.b4Nrdf =  peNrdf;
           setll %kds( k1ysb4 : 10 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 10 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 10 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           k1ysb4.b4Xcob =  peXcob;
           setll %kds( k1ysb4 : 9 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 9 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 9 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           setll %kds( k1ysb4 : 8 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 8 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 8 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           setll %kds( k1ysb4 : 7 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 7 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 7 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           setll %kds( k1ysb4 : 6 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 6 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 6 ) pahsb4 @@DsIb4;
           enddo;

         other;

           setll %kds( k1ysb4 : 5 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 5 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 5 ) pahsb4 @@DsIb4;
           enddo;

       endsl;

       if %addr( peDsB4 ) <> *null;
         eval-corr peDsB4 = @@DsB4;
       endif;

       if %addr( peDsB4C ) <> *null;
         peDsB4C = @@DsB4C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getVehiculoTercero...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getUltFechaPago(): Retorna Ultima Fecha de Pago       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peNrdf   ( input  ) Filiatorio de Beneficiario           *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peFech   ( output ) Fecha de Pago                        *
      *     peMone   ( output ) Moneda                               *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getUltFechaPago...
     P                 B                   export
     D SVPSIN_getUltFechaPago...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peMone                       2    options(*omit:*nopass)

     D k1yshp          ds                  likerec(p1hshp:*key)

      /free

       SVPSIN_inz();

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpRama = peRama;
       k1yshp.hpSini = peSini;
       k1yshp.hpNops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           k1yshp.hpSebe =  peSebe;
           k1yshp.hpRiec =  peRiec;
           k1yshp.hpXcob =  peXcob;
           setgt %kds( k1yshp : 11 ) pahshp;
           readpe(n) %kds( k1yshp : 11 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           k1yshp.hpSebe =  peSebe;
           k1yshp.hpRiec =  peRiec;
           setgt %kds( k1yshp : 10 ) pahshp;
           readpe(n) %kds( k1yshp : 10 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peNrdf ) <> *null
                          and %addr( peSebe ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           k1yshp.hpSebe =  peSebe;
           setgt %kds( k1yshp : 9 ) pahshp;
           readpe(n) %kds( k1yshp : 9 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peNrdf ) <> *null
                          and %addr( peSebe ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           setgt %kds( k1yshp : 8 ) pahshp;
           readpe(n) %kds( k1yshp : 8 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           setgt %kds( k1yshp : 7 ) pahshp;
           readpe(n) %kds( k1yshp : 7 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           setgt %kds( k1yshp : 6 ) pahshp;
           readpe(n) %kds( k1yshp : 6 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         other;

           setgt %kds( k1yshp : 5 ) pahshp;
           readpe(n) %kds( k1yshp : 5 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

       endsl;

       if %addr( peFech ) <> *null;
         peFech = ( hpFasa * 10000 )
                + ( hpFasm * 100   )
                +   hpFasd;
       endif;

       if %addr( peMone ) <> *null;
         peMone = hpMonr;
       endif;

       return *on;

      /end-free

     P SVPSIN_getUltFechaPago...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarSiniestro(): Finaliza Siniestro               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_terminarSiniestro...
     P                 B                   export
     D SVPSIN_terminarSiniestro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D @@ds456         ds                  likeds( DsSet456_t )
     D @@Ds402         ds                  likeds( DsSet402_t )

     D @@chks          s                   like(*in50)
     D rc              s               n
     D rc1             s               n
     D rc2             s               n
     D rc3             s               n

      /free

       SVPSIN_inz();

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *on;
            return *off;
         endif;

       if SVPSIN_chkSiniPend(peEmpr
                            :peSucu
                            :peRama
                            :peSini
                            :peNops) = *off ;
          return *off;

        else;

         if SVPSIN_getSet456( peEmpr
                            : peSucu
                            : @@Ds456) = *off;
            return *off;
         endif;

         if SVPSIN_getSet402( peEmpr
                            : peSucu
                            : peRama
                            : 2
                            : @@Ds402) = *off;
            return *off;
         endif;


         if SVPSIN_wrtEstSin( peEmpr
                             : peSucu
                             : peRama
                             : peSini
                             : peNops
                             : @@Ds456.t@fema
                             : @@Ds456.t@femm
                             : @@Ds456.t@femd
                             : @@Ds402.t@cesi
                             : @@Ds402.t@cese
                             : @@Ds402.t@mar1) = *off;
            return *off;
         endif;

         if SVPSIN_terminarCaratula( peEmpr
                                   : peSucu
                                   : peRama
                                   : peSini
                                   : peNops
                                   : @@Ds402.t@cesi
                                   : @@Ds402.t@cese
                                   : @@Ds402.t@mar1) = *off;
          return *off;
         endif;
       endif;

       return *on;

      /end-free

     P SVPSIN_terminarSiniestro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamo(): Finaliza los Reclamos de un        *
      *                            Siniestro                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_terminarReclamo...
     P                 B                   export
     D SVPSIN_terminarReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ysbe          ds                  likerec(p1hsbe:*key)
     D k1ysb1          ds                  likerec(p1hsb102:*key)
     D k1y456          ds                  likerec(s1t456:*key)
     D @@ds456         ds                  likeds( DsSet456_t )


      /free

       SVPSIN_inz();

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *on;
            return *off;
         endif;

        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *off;
          return *off;
        endif;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       setll %kds(k1ysbe:5) pahsbe;
       reade %kds(k1ysbe:5) pahsbe;
       dow not %eof;

          k1ysb1.b1empr = beEmpr;
          k1ysb1.b1sucu = beSucu;
          k1ysb1.b1rama = beRama;
          k1ysb1.b1sini = beSini;
          k1ysb1.b1nops = beNops;
          k1ysb1.b1nrdf = beNrdf;
          setll %kds(k1ysb1:6) pahsb102;
          reade %kds(k1ysb1:6) pahsb102;
          if not %eof(pahsb102);
           if SVPSIN_terminarReclamoStro( peEmpr
                                        : peSucu
                                        : peRama
                                        : peSini
                                        : peNops
                                        : bePoco
                                        : bePaco
                                        : beRiec
                                        : beXcob
                                        : beNrdf
                                        : beSebe
                                        : b1Cesi
                                        : b1Recl
                                        : b1Ctle
                                        : b1Hecg
                                        : @@Ds456.t@fema
                                        : @@Ds456.t@femm
                                        : @@Ds456.t@femd ) = *on;
           endif;
          endif;
       reade %kds(k1ysbe:5) pahsbe;
       enddo;

       return *on;

      /end-free

     P SVPSIN_terminarReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarRvaStro() : Nivelar las Reservas de un         *
      *                           Siniestro.                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarRvaStro...
     P                 B                   export
     D SVPSIN_nivelarRvaStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *off;



            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                  if SVPSIN_nivelarRvaStroBenef( peEmpr
                                               : peSucu
                                               : peRama
                                               : peSini
                                               : peNops
                                               : @@DsBe(x).beNrdf
                                               : @@Fech ) = *on;
                  endif;

              endfor;

            endif;

         endif;

       return *on;

      /end-free

     P SVPSIN_nivelarRvaStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarCaratula(): Finaliza Carátula                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peCese   (input)   Estado Siniestro Equivalente          *
      *     peTerm   (input)   Codigo Terminado                      *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_terminarCaratula...
     P                 B                   export
     D SVPSIN_terminarCaratula...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peCesi                       2  0 const
     D   peCese                       2    const
     D   peTerm                       1    const

     D k1yscd          ds                  likerec( p1hscd : *key )

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;
       k1yscd.cdnops = peNops;
       chain %kds(k1yscd) pahscd;
         if %found;
           cdcesi = peCesi;
           cdcese = peCese;
           cdterm = peTerm;
          update p1hscd;
         else;
         SetError( SVPSIN_CARNE
                 : 'Caratula no encontrada' );
          return *off;
         endif;

       return *on;

      /end-free

     P SVPSIN_terminarCaratula...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSet402() : Obtiene Set402                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peDs402  (output)  Estructura SET402                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getSet402...
     P                 B                   export
     D SVPSIN_getSet402...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peCesi                       2  0 const
     D   peDs402                           likeds ( DsSET402_t )

     D k1y402          ds                  likerec( s1t402 : *key )
     D @@Ds402         ds                  likerec( s1t402 : *input )

      /free

       SVPSIN_inz();

       clear peDs402;
       k1y402.t@empr = peEmpr;
       k1y402.t@sucu = peSucu;
       k1y402.t@rama = peRama;
       k1y402.t@cesi = peCesi;
       chain %kds(k1y402) set402 @@Ds402;
       if %found(set402);
         eval-corr peDs402 = @@Ds402;
        else;
         SetError( SVPSIN_402NE
                 : 'SET402 no encontrado' );
         return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getSet402...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSet456() : Obtiene SET456                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peDs456  (output)  Estructura SET456                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getSet456...
     P                 B                   export
     D SVPSIN_getSet456...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs456                           likeds ( DsSET456_t )

     D k1y456          ds                  likerec( s1t456 : *key )
     D @@Ds456         ds                  likerec( s1t456 : *input )

      /free

       SVPSIN_inz();

       clear peDs456;
       k1y456.t@empr = peEmpr;
       k1y456.t@sucu = peSucu;
       chain %kds(k1y456) set456 @@Ds456;
       if %found(set456);
         eval-corr peDs456 = @@Ds456;
        else;
         SetError( SVPSIN_456NE
                 : 'SET456 no encontrado' );
         return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getSet456...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_wrtEstSin() : Grabo Estado Siniestro                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFema   (input)   Fecha Año Movimiento                  *
      *     peFemm   (input)   Fecha Mes Movimiento                  *
      *     peFemd   (input)   Fecha Día Movimiento                  *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peCese   (input)   Estado Siniestro Equivalente          *
      *     peTerm   (input)   Codigo Terminado                      *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_wrtEstSin...
     P                 B                   export
     D SVPSIN_wrtEstSin...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   peCesi                       2  0 const
     D   peCese                       2    const
     D   peTerm                       1    const

     D k1yshe          ds                  likerec(p1hshe01:*key)
     D @@ds456         ds                  likeds( DsSet456_t )

     D wwpsec          s                   like(hepsec)

      /free
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *off;
          return *off;
        endif;

       SVPSIN_inz();

       k1yshe.heEmpr = peEmpr;
       k1yshe.heSucu = peSucu;
       k1yshe.heRama = peRama;
       k1yshe.heNops = peNops;
       k1yshe.heSini = peSini;
       setgt %kds( k1yshe : 5 ) pahshe01;
       readpe(n) %kds( k1yshe : 5 ) pahshe01;
         if %eof;
           wwpsec = 1 ;
            else;
           wwpsec = hepsec + 1 ;
         endif;
          heempr = peempr;
          hesucu = pesucu;
          herama = perama;
          hesini = pesini;
          henops = penops;
          hefema = @@Ds456.t@fema;
          hefemm = @@Ds456.t@femm;
          hefemd = @@Ds456.t@femd;
          hepsec = wwpsec;
          hecesi = pecesi;
          hecese = pecese;
          heterm = peterm;
          hemar1 = *off  ;
          hemar2 = *off  ;
          hemar3 = *off  ;
          hemar4 = *off  ;
          hemar5 = *off  ;
          heuser = ususer;
          hetime = %dec(%time():*iso);
          hefera = *year ;
          heferm = umonth;
          heferd = uday  ;

         write p1hshe01 ;

       return *on;

      /end-free

     P SVPSIN_wrtEstSin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaStro() : Obtengo Reserva del Siniestro          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Reserva                                  *
      * ------------------------------------------------------------ *

     P SVPSIN_getRvaStro...
     P                 B                   export
     D SVPSIN_getRvaStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

            clear @@DsBe;
            clear @@DsBeC;
            @@mact = *Zeros;
            @1mact = *Zeros;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 @@mact = SVPSIN_getRva( peEmpr
                                       : peSucu
                                       : peRama
                                       : peSini
                                       : peNops
                                       : @@DsBe(x).beNrdf
                                       : @@Fech );
                 @1mact += @@mact;
              endfor;
            endif;

        return @1mact;

      /end-free

     P SVPSIN_getRvaStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFraStro() : Obtengo Franquicia del Siniestro       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Franquicia                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getFraStro...
     P                 B                   export
     D SVPSIN_getFraStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@DsBeC         s             10i 0
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

            clear @@DsBe;
            clear @@DsBeC;
            @@mact = *Zeros;
            @1mact = *Zeros;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 @@mact = SVPSIN_getFra( peEmpr
                                       : peSucu
                                       : peRama
                                       : peSini
                                       : peNops
                                       : @@DsBe(x).beNrdf
                                       : @@Fech );
                 @1mact += @@mact;

              endfor;

            endif;

        return @1mact;

      /end-free

     P SVPSIN_getFraStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPagStro() : Obtengo Pagos del Siniestro            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Pagos                                    *
      * ------------------------------------------------------------ *

     P SVPSIN_getPagStro...
     P                 B                   export
     D SVPSIN_getPagStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

            clear @@DsBe;
            clear @@DsBeC;
            @@mact = *Zeros;
            @1mact = *Zeros;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 @@mact = SVPSIN_getPag( peEmpr
                                       : peSucu
                                       : peRama
                                       : peSini
                                       : peNops
                                       : @@DsBe(x).beNrdf
                                       : @@Fech );
                 @1mact += @@mact;
              endfor;
            endif;

        return @1mact;

      /end-free

     P SVPSIN_getPagStro...
     P                 E


      * ------------------------------------------------------------ *
      * SVPSIN_getRvaActStro() : Obtengo Reserva Actual del          *
      *                          Siniestro                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe Reserva Neta de Franquicias y Pagos.(SAP)   *
      * ------------------------------------------------------------ *

     P SVPSIN_getRvaActStro...
     P                 B                   export
     D SVPSIN_getRvaActStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@fech          s              8  0

     D @@Rva           s             15  2
     D @@Fra           s             15  2
     D @@Pag           s             15  2

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

        @@Rva = SVPSIN_getRvaStro( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : @@Fech );
        @@Fra = SVPSIN_getFraStro( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : @@Fech );
        @@Pag = SVPSIN_getPagStro( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : @@Fech );

        @@Rva = @@Rva - @@Fra - @@Pag;
        Return @@Rva;

      /end-free

     P SVPSIN_getRvaActStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkStroEnJuicio() : Chequeo si el Siniestro esta en   *
      *                          Juicio                              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkStroEnJuicio...
     P                 B                   export
     D SVPSIN_chkStroEnJuicio...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 if SVPSIN_chkbenefJuicio( peEmpr
                                         : peSucu
                                         : peRama
                                         : peSini
                                         : peNops
                                         : @@DsBe(x).beNrdf) = *on;
                        SetError( SVPSIN_BEJUI
                                : 'Beneficiario en Juicio' );
                        return *on;
                 endif;

              endfor;
            endif;

       return *off;
      /end-free

     P SVPSIN_chkStroEnJuicio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarRvaStroBenef() :  Nivelar las reservas de un   *
      *                                 Beneficiario.                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off  *on = Nivelo Ok / *off = No nivelo      *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarRvaStroBenef...
     P                 B                   export
     D SVPSIN_nivelarRvaStroBenef...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@ds456         ds                  likeds( DsSet456_t )
     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

          @@mact = SVPSIN_getRvaAct( peEmpr
                                   : peSucu
                                   : peRama
                                   : peSini
                                   : peNops
                                   : peNrdf
                                   : @@Fech );
         if @@mact <> *zeros;

          @@mact = @@mact * -1;

           if SVPSIN_setPahshr( peEmpr : peSucu : peRama : peSini :
                                peNops : peNrdf : @@mact : ususer ) = *on;
            return *on;
           endif;

         endif;

       return *off;

      /end-free

     P SVPSIN_nivelarRvaStroBenef...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamoStro(): Finaliza un Reclamo de         *
      *                               Siniestro                      *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Nro de Componente                     *
      *     pePaco   (input)   Código de Parentesco                  *
      *     periec   (input)   Código de Riesgo                      *
      *     pexcob   (input)   Código de Cobertura                   *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Sec. Benef. Siniestros                *
      *     peCesi   (input)   Estado del Siniestro                  *
      *     peRecl   (input)   Número de Reclamo                     *
      *     peCtle   (input)   Tipo de Lesiones                      *
      *     peHecg   (input)   Hecho Generador                       *
      *     peFema   (input)   Fecha Año Movimiento                  *
      *     peFemm   (input)   Fecha Mes Movimiento                  *
      *     peFemd   (input)   Fecha Día Movimiento                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_terminarReclamoStro...
     P                 B                   export
     D SVPSIN_terminarReclamoStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peCesi                       2  0 const
     D   peRecl                       3  0 const
     D   peCtle                       2    const
     D   peHecg                       1    const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const

     D k1ysb1          ds                  likerec(p1hsb1:*key)
     D k1y456          ds                  likerec(s1t456:*key)
     D @@ds456         ds                  likeds( DsSet456_t )


      /free

       SVPSIN_inz();


       k1ysb1.b1empr = peEmpr;
       k1ysb1.b1sucu = peSucu;
       k1ysb1.b1rama = peRama;
       k1ysb1.b1sini = peSini;
       k1ysb1.b1nops = peNops;
       k1ysb1.b1poco = pePoco;
       k1ysb1.b1paco = pePaco;
       k1ysb1.b1riec = peRiec;
       k1ysb1.b1xcob = peXcob;
       k1ysb1.b1nrdf = peNrdf;
       k1ysb1.b1sebe = peSebe;
       k1ysb1.b1fema = peFema;
       k1ysb1.b1femm = peFemm;
       k1ysb1.b1femd = peFemd;
       chain %kds(k1ysb1) pahsb1;

           b1empr = peEmpr;
           b1sucu = peSucu;
           b1rama = peRama;
           b1sini = peSini;
           b1nops = peNops;
           b1poco = pePoco;
           b1paco = pePaco;
           b1riec = peRiec;
           b1xcob = peXcob;
           b1nrdf = peNrdf;
           b1sebe = peSebe;
           b1fema = pefema;
           b1femm = pefemm;
           b1femd = pefemd;
           b1cesi = peCesi;
           if peCesi = 01;
           b1cesi = 05;
           endif;
           b1user = ususer;
           b1fera = pefema;
           b1ferm = pefemm;
           b1ferd = pefemd;
           b1recl = peRecl;
           b1ctle = peCtle;
           b1hecg = peHecg;

         if not %found(pahsb1);
          write p1hsb1;
           else;
          update p1hsb1;
         endif;

       return *on;

      /end-free

     P SVPSIN_TerminarReclamoStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarFraStro() : Nivelar las Franquicias de un      *
      *                           Siniestro.                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarFraStro...
     P                 B                   export
     D SVPSIN_nivelarFraStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *off;



            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                  if SVPSIN_nivelarFraStroBenef( peEmpr
                                               : peSucu
                                               : peRama
                                               : peSini
                                               : peNops
                                               : @@DsBe(x).beNrdf
                                               : @@Fech ) = *on;
                  endif;

              endfor;

            endif;

         endif;

       return *on;

      /end-free

     P SVPSIN_nivelarFraStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarFraStroBenef() :  Nivelar las Franquicias de   *
      *                                 un Beneficiario.             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off  *on = Nivelo Ok / *off = No nivelo      *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarFraStroBenef...
     P                 B                   export
     D SVPSIN_nivelarFraStroBenef...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@ds456         ds                  likeds( DsSet456_t )
     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

          @@mact = SVPSIN_getFra( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : peNops
                                : peNrdf
                                : @@Fech );
         if @@mact <> *zeros;

          @@mact = @@mact * -1;

           if SVPSIN_setPahsfr( peEmpr : peSucu : peRama : peSini :
                                peNops : peNrdf : @@mact : ususer ) = *on;
            return *on;
           endif;

         endif;

       return *off;

      /end-free

     P SVPSIN_nivelarFraStroBenef...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCaratula2():Retorna Carátula de Denuncia de        *
      *                       Siniestro (sin NOPS).                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsCd   ( output ) Estructura de Carátula de Siniestro  *
      *     peDsCdC  ( output ) Cantidad de Carátula de Siniestro    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getCaratula2...
     P                 B                   export
     D SVPSIN_getCaratula2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsCd                            likeds ( DsPahscd_t )

     D k1hscd          ds                  likerec( p1hscd : *key   )

      /free

       SVPSIN_inz();

       k1hscd.cdEmpr = peEmpr;
       k1hscd.cdSucu = peSucu;
       k1hscd.cdRama = peRama;
       k1hscd.cdSini = peSini;
       chain %kds( k1hscd : 4 ) pahscd;
       if not %found( pahscd );
          return *off;
       endif;

       return SVPSIN_getCaratula( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : cdnops
                                : peDscd );

      /end-free

     P SVPSIN_getCaratula2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSc1():   Retorna registro de PAHSC1.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsC1   ( output ) Estructura de PAHSC1                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSc1...
     P                 B                   export
     D SVPSIN_getPahSc1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsC1                            likeds ( DsPahsc1_t )

     D k1hsc1          ds                  likerec( p1hsc1 : *key   )
     D inSc1           ds                  likerec( p1hsc1 : *input )

      /free

       SVPSIN_inz();

       clear peDsC1;

       k1hsc1.cd1Empr = peEmpr;
       k1hsc1.cd1Sucu = peSucu;
       k1hsc1.cd1Rama = peRama;
       k1hsc1.cd1Sini = peSini;
       chain %kds( k1hsc1 : 4 ) pahsc1 inSc1;
       if not %found( pahsc1 );
          return *off;
       endif;

       eval-corr peDsC1 = inSc1;

       return *on;

      /end-free

     P SVPSIN_getPahSc1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSd1():   Retorna registro de PAHSD1.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsC1   ( output ) Estructura de PAHSD1                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSd1...
     P                 B                   export
     D SVPSIN_getPahSd1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsD1                            likeds ( DsPahsd1_t )

     D k1hsd1          ds                  likerec( p1hsd1 : *key   )
     D inSd1           ds                  likerec( p1hsd1 : *input )

      /free

       SVPSIN_inz();

       clear peDsD1;

       k1hsd1.d1Empr = peEmpr;
       k1hsd1.d1Sucu = peSucu;
       k1hsd1.d1Rama = peRama;
       k1hsd1.d1Sini = peSini;
       chain %kds( k1hsd1 : 4 ) pahsd1 inSd1;
       if not %found( pahsd1 );
          return *off;
       endif;

       eval-corr peDsD1 = inSd1;

       return *on;

      /end-free

     P SVPSIN_getPahSd1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSd2():   Retorna registro de PAHSD2.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsC1   ( output ) Estructura de PAHSD2                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSd2...
     P                 B                   export
     D SVPSIN_getPahSd2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsD2                            likeds ( DsPahsd2_t )

     D k1hsd2          ds                  likerec( p1hsd2 : *key   )
     D inSd2           ds                  likerec( p1hsd2 : *input )

      /free

       SVPSIN_inz();

       clear peDsD2;

       k1hsd2.d2Empr = peEmpr;
       k1hsd2.d2Sucu = peSucu;
       k1hsd2.d2Rama = peRama;
       k1hsd2.d2Sini = peSini;
       chain %kds( k1hsd2 : 4 ) pahsd2 inSd2;
       if not %found( pahsd2 );
          return *off;
       endif;

       eval-corr peDsD2 = inSd2;

       return *on;

      /end-free

     P SVPSIN_getPahSd2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahStc():   Retorna registro de PAHSTC.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsT1   ( output ) Estructura de PAHSTC                 *
      *     peDsT1c  ( output ) Contador de PAHSTC                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahStc...
     P                 B                   export
     D SVPSIN_getPahStc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsTc                            likeds ( DsPahstc_t ) dim(999)
     D   peDsTcC                     10i 0

     D k1hstc          ds                  likerec( p1hstc : *key   )
     D inStc           ds                  likerec( p1hstc : *input )

      /free

       SVPSIN_inz();

       clear peDsTc;
       pedstcc = *zeros ;

       k1hstc.stEmpr = peEmpr;
       k1hstc.stSucu = peSucu;
       k1hstc.stRama = peRama;
       k1hstc.stSini = peSini;
        setll %kds( k1hstc : 4 ) pahstc;
        reade %kds( k1hstc : 4 ) pahstc inStc;
        dow not %eof( pahstc );
          pedstcc = peDsTcC + 1;
          eval-corr peDsTc ( peDsTcC ) = inStc;
        reade %kds( k1hstc : 4 ) pahstc inStc;
        enddo;

       if pedstcc =*zeros;
          return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getPahStc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSD0():   Retorna registro de PAHSD0.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDss0   ( output ) Estructura de PAHSD0                 *
      *     peDss0c  ( output ) Contador de PAHSD0                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSd0...
     P                 B                   export
     D SVPSIN_getPahSd0...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsD0                            likeds ( DsPahsd0_t ) dim(999)
     D   peDsD0C                     10i 0

     D k1hsd0          ds                  likerec( p1hsd0 : *key   )
     D inSd0           ds                  likerec( p1hsd0 : *input )

      /free

       SVPSIN_inz();

       clear peDsd0;
       clear inSd0;
       pedsd0c = *zeros ;

       k1hsd0.d0empr = peEmpr;
       k1hsd0.d0sucu = peSucu;
       k1hsd0.d0rama = peRama;
       k1hsd0.d0sini = peSini;
       setll %kds( k1hsd0 : 4 ) pahsd0;
       reade %kds( k1hsd0 : 4 ) pahsd0 inSd0;
       dow not %eof( pahsd0 );
           peDsD0c += 1;
           eval-corr peDsD0(peDsD0C) = inSd0;
       reade %kds( k1hsd0 : 4 ) pahsd0 inSd0;
       enddo;

       if peDsd0C = *zeros;
          return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getPahSd0...
     P                 E

