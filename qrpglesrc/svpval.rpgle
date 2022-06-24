     H nomain
     H option(*noshowcpy)
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPVAL: Validar Datos Varios.                                *
      * ------------------------------------------------------------ *
      * Barranco Julio                       12-Ago-2015             *
      *------------------------------------------------------------- *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 07/09/15  Agrega procedimiento SVPVAL_chkRamaPlan        *
      *                                    SVPVAL_chkCodBuenR        *
      *                                    SVPVAL_chkCaracBien       *
      *                                    SVPVAL_chkCobPrima        *
      *                                    SVPVAL_chkCobSumMaxMinima *
      * SFA 23/12/15  Agrega procedimiento SVPVAL_arcdRamaArse       *
      * SFA 29/12/15  Agrega procedimiento SVPVAL_empresa            *
      *               Agrega procedimiento SVPVAL_sucursal           *
      * LRG 09/05/16  Agrega procedimiento SVPVAL_chkProvincia       *
      * SFA 07/06/16  Agrega procedimiento SVPVAL_articuloRenovacion *
      *                                SVPVAL_productorRenoAutomatica*
      *                                    SVPVAL_productorCbaMza    *
      *                                    SVPVAL_aseguradoCbaMza    *
      *                                    SVPVAL_productorBloqueado *
      *                                    SVPVAL_codigoDeAjuste     *
      *                                                              *
      * LRG 22/05/16  Agrega procedimiento SVPVAL_chkPlanCerrado     *
      * LRG 24/07/17  Agrega procedimiento SVPVAL_chkInfoAtoWeb      *
      *                                    SVPVAL_chkClienteIntegral *
      * GIO 04/12/2017 Agregado de Nuevos procedimientos:            *
      *                - SVPVAL_chkProductorAsegurado                *
      * JSN 02/07/2018 Se corrige el procedimiento _chkCondCarac, se *
      *                repite la condición peAnio = 2, dos veces, se *
      *                cambia una de ellas por peAnio = 3.           *
      * JSN 19/07/2018 Se agrega procedimiento:                      *
      *                - SVPVAL_chkAseguradoProdAs1                  *
      * JSN 15/02/2019 Se agrega procedimiento:                      *
      *                - SVPVAL_chkTipoDocHabWeb                     *
      *                - SVPVAL_chkCodIvaHabWeb                      *
      * JSN 26/02/2019 Se agrega SVPINT_getCadena para buscar cabe-  *
      *                cera de Intermediario en el procedimiento     *
      *                SVPVAL_chkProductorAsegurado                  *
      * JSN 10/06/2019 Se agrega procedimiento _chkEdadVida.         *
      * LRG 15/10/2019 Se agrega procedimiento _chkPlanesHabilWeb    *
      *                Se incorpora llamada a PAR310X3               *
      *                                                              *
      * SPV 23/04/2020 Agrega procedimiento                          *
      *                 - SVPVAL_productorRenoAutomatica2            *
      * SGF 08/05/2020 Cambio campo en articuloHabilitadoWeb y en    *
      *                _iva.                                         *
      * JSN 14/08/2020 Se agrega procedimiento _chkMayorAuxiliar     *
      * JSN 03/02/2021 Se agrega procedimiento _monedaV2             *
      * SGF 08/02/2021 Se agrega:                                    *
      *                _chkCapituloTarifa                            *
      *                _chkCapituloTarifaArticulo                    *
      *                _chkCapituloTarifaPlan                        *
      *                _chkCapituloTarifaWeb                         *
      * JSN 19/03/2021 Se modifica el procedimiento _tipoPersona     *
      * SGF 31/05/2021 En SVPVAL_chkCobSumMaxMin() agrego soporte pa-*
      *                ra tener doble limite de suma.                *
      *                Hasta ahora los limites por valor y por porcen*
      *                taje eran exlucyentes entre si.               *
      *                Ahora se pueden tener los dos.                *
      *                Por ejemplo:                                  *
      *                Cobertura B tiene limite min $100.000 y max   *
      *                $150.000 pero a su vez un 50% de la Cobertura *
      *                A.                                            *
      * SGF 23/02/2022 Agrego _chkCapituloVariante() y               *
      *                chkTarifaDiferencial().                       *
      * VCM 02/03/2022 Agrego _productoWeb()                         *
      *                       _planDePagoWeb()                       *
      * ************************************************************ *
     Fgntmon    if   e           k disk    usropn
     Fgntiv1    if   e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fgntfpg    if   e           k disk    usropn
     Fgntfpg02  if   e           k disk    usropn  prefix(g2_)
     F                                             rename(g1tfpg:g1tfpg2)
     Fctw000    if   e           k disk    usropn
     Fctw003    if   e           k disk    usropn
     Fset001    if   e           k disk    usropn
     Fset100    if   e           k disk    usropn
     Fset102    if   e           k disk    usropn
     Fset102w   if   e           k disk    usropn
     Fset103    if   e           k disk    usropn
     Fset104    if   e           k disk    usropn
     Fset106    if   e           k disk    usropn
     Fset107    if   e           k disk    usropn
     Fset160    if   e           k disk    usropn
     Fset200    if   e           k disk    usropn
     Fset204    if   e           k disk    usropn  prefix(s4_)
     Fset20493  if   e           k disk    usropn  prefix(s4_)
     F                                             rename(s1t204:s1t20493)
     Fset207    if   e           k disk    usropn  prefix(s7_)
     Fset22501  if   e           k disk    usropn
     Fset239    if   e           k disk    usropn  prefix(s9_)
     Fset23901  if   e           k disk    usropn  prefix(s91_)
     F                                             rename(s1t239:s1t2391)
     Fset620    if   e           k disk    usropn
     Fset621    if   e           k disk    usropn
     Fset630w   if   e           k disk    usropn
     Fset901    if   e           k disk    usropn
     Fsettar    if   e           k disk    usropn
     Fgnttdo    if   e           k disk    usropn
     Fgnhdaf05  if   e           k disk    usropn
     Fgnhdaf06  if   e           k disk    usropn
     Fsehase    if   e           k disk    usropn
     Fset1031   if   e           k disk    usropn prefix( t1 : 2 )

     Fgntprf02  if   e           k disk    usropn
     Fgntsex02  if   e           k disk    usropn
     Fgntesc02  if   e           k disk    usropn
     Fgntrae02  if   e           k disk    usropn
     Fgntpai    if   e           k disk    usropn
     Fgnttis    if   e           k disk    usropn
     Fctwet0    if   e           k disk    usropn
     Fgntemp    if   e           k disk    usropn
     Fgntsuc    if   e           k disk    usropn
     Fgntpro    if   e           k disk    usropn
     Fgnttce    if   e           k disk    usropn
     Fgntnac    if   e           k disk    usropn
     Fset63002  if   e           k disk    usropn
     Fsehni2    if   e           k disk    usropn
     Fsehni4c   if   e           k disk    usropn
     Fpahas1    if   e           k disk    usropn
     Fcntnau01  if   e           k disk    usropn
     Fset101    if   e           k disk    usropn prefix(t1:2)
     Fset6261   if   e           k disk    usropn
     Fset101c   if   e           k disk    usropn prefix(t2:2)
     Fset208    if   e           k disk    usropn
     Fset215    if   e           k disk    usropn
     Fset60802  if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpval_h.rpgle'
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N
      * --------------------------------------------------- *
      * Validación de Nro de CUIT
      * --------------------------------------------------- *
     DSP0083           pr                  extpgm('SP0083')
     D  cuitsp83                     14
     D  Errsp83                       1

     D  cuitsp83       s             14    inz(' ')
     D  Errsp83        s              1    inz(' ')

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

     Dspcliint         pr                  extpgm('SPCLIINT')
     D  codi                          3
     D  asen                          7  0
     D  fech                          8  0
     D  reto                           n
     D  fpgm                          3

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     Is1t901
     I              t@date                      x@date
     Is1t630w
     I              t@date                      w@date
     Is1t225
     I              t@date                      q@date
     Is1ttar
     I              t@date                      p@date
     Is1t107
     I              t@cobl                      x@cobl
     Is1t160
     I              t@date                      a@date
     Is1t102w
     I              t@date                      r@date

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPVAL_articulo: Valida el Código de Articulo                *
      *                                                              *
      *     peArcd   (input)   Código de Articulo                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_articulo...
     P                 B                   export
     D SVPVAL_articulo...
     D                 pi              n
     D   peArcd                       6  0 const

     D k1y620          ds                  likerec(s1t620:*key)

      /free

       SVPVAL_inz();

       k1y620.t@arcd = peArcd;
       chain(n) %kds( k1y620 ) set620;

       if not %found( set620 );

         SetError( SVPVAL_ARTNE
                 : 'Artículo Inexistente' );
         return *Off;

       else;

         if t@bloq = '1';
           SetError( SVPVAL_ARTBL
                   : 'Artículo Bloqueado' );
           return *Off;
         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_articulo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVAL_articuloWeb(): Valida código Articulo para Web.       *
      *                                                              *
      *     peArcd   (input)   Código de Articulo                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVAL_articuloWeb...
     P                 B                   export
     D SVPVAL_articuloWeb...
     D                 pi              n
     D   peArcd                       6  0 const
     D

      /free

       if not articuloHabilitadoWeb(peArcd);

         SetError( SVPVAL_ARTNW
                 : 'Articulo no valido para la Web');
         return *Off;

       endif;

       return *On;

      /end-free

     P SVPVAL_articuloWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVAL_moneda(): Validar Moneda.                             *
      *                                                              *
      *     peComo   (input)   Código de Moneda                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_moneda...
     P                 B                   export
     D SVPVAL_moneda...
     D                 pi              n
     D   peComo                       2    const
     D
     D k1yMon          ds                  likerec(g1tmon:*key)
     D

      /free

       SVPVAL_inz();

       k1ymon.mocomo = peComo;

       chain(n) %kds( k1ymon ) gntmon;
       if not %found( gntmon );

         SetError( SVPVAL_MONNE
                 : 'Moneda Inexistente' );
         return *Off;

       else;

         if mobloq = '1';

           SetError( SVPVAL_MONBL
                   : 'Moneda Bloqueada' );
           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_moneda...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_monedaWeb(): Validar Moneda para Web.                 *
      *                                                              *
      *     peComo   (input)   Código de Moneda                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_monedaWeb...
     P                 B                   export
     D SVPVAL_monedaWeb...
     D                 pi              n
     D   peComo                       2    const
     D
     D k1yMon          ds                  likerec(g1tmon:*key)
     D

      /free

       SVPVAL_inz();

       k1ymon.mocomo = peComo;

       chain(n) %kds( k1ymon ) gntmon;
       if not %found( gntmon );
         SetError( SVPVAL_MONNE
                 : 'Moneda Inexistente' );
         return *Off;

       else;

         if momweb = '0';

           SetError( SVPVAL_MONNW
                   : 'Moneda no válida para la Web' );
           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_monedaWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_tipoDeOperacion(): Validar tipo de operacion.         *
      *                                                              *
      *     peTiou   (input)   Tipo Operaciónda                      *
      *     peStou   (input)   SubTipo Operación                     *
      *     peStos   (input)   SubTipo Sistema                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_tipoDeOperacion...
     P                 B                   export
     D SVPVAL_tipoDeOperacion...
     D                 pi              n
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D
     D k1y901          ds                  likerec(s1t901:*key)
     D indexs          s               n
     D

      /free

       SVPVAL_inz();

       indexs = *off;
       k1y901.t@tiou = peTiou;
       k1y901.t@stou = peStou;

       setll %kds( k1y901 ) set901;
       reade %kds( k1y901 ) set901;
       dow not %eof( set901 );

         if t@stos = peStos;

           return *On;

         endif;

         reade %kds( k1y901 ) set901;
       enddo;


       SetError( SVPVAL_TOPNE
               : 'Tipo de Operacion Inexistente' );
       return *Off;


      /end-free

     P SVPVAL_tipoDeOperacion...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_tipoDeOperacionWeb(): Validar tipo de operacion para  *
      *                              Web                             *
      *                                                              *
      *     peTiou   (input)   Tipo Operaciónda                      *
      *     peStou   (input)   SubTipo Operación                     *
      *     peStos   (input)   SubTipo Sistema                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_tipoDeOperacionWeb...
     P                 B                   export
     D SVPVAL_tipoDeOperacionWeb...
     D                 pi              n
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D
     D k1y901          ds                  likerec(s1t901:*key)
     D indexs          s               n
     D

      /free

       SVPVAL_inz();

       indexs = *off;
       k1y901.t@tiou = peTiou;
       k1y901.t@stou = peStou;

       setll %kds( k1y901 ) set901;
       reade %kds( k1y901 ) set901;
       dow not %eof( set901 );

         if t@stos = peStos;

           if t@mweb = '0';

             SetError( SVPVAL_TOPNW
                     : 'Tipo de Operacion No Valido para Web' );
             return *Off;

           else;

             return *On;

           endif;

         endif;

         reade %kds( k1y901 ) set901;
       enddo;


       SetError( SVPVAL_TOPNE
               : 'Tipo de Operacion Inexistente' );
       return *Off;



      /end-free

     P SVPVAL_tipoDeOperacionWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_nombreCliente(): Validar que no este en blanco el     *
      *                         nombre.                              *
      *                                                              *
      *     peNomb   (input)   Nombre Cliente                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_nombreCliente...
     P                 B                   export
     D SVPVAL_nombreCliente...
     D                 pi              n
     D   peNomb                      40    const
     D

      /free

       SVPVAL_inz();

       if peNomb = *blanks;

         SetError( SVPVAL_NOMBL
                 : 'Nombre en Blanco' );
         return *Off;

       endif;

       return *On;

      /end-free

     P SVPVAL_nombreCliente...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_domiCliente(): Validar domicilio                      *
      *                                                              *
      *     peDomi   (input)   Domicilio                             *
      *     peNdom   (input)   Numero de Domicilio                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_domiCliente...
     P                 B                   export
     D SVPVAL_domiCliente...
     D                 pi              n
     D   peDomi                      35    const
     D   peNdom                       5  0 const

      /free

       SVPVAL_inz();

       if peDomi = *Blanks;

         SetError( SVPVAL_DOMBL
                 : 'Domicilio en Blanco' );
         return *Off;

       endif;

       if peDomi = *Zeros;

         SetError( SVPVAL_NDOCE
                 : 'Nro Domicilio en Cero' );
         return *Off;

       endif;

       return *On;

      /end-free

     P SVPVAL_domiCliente...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_iva(): Valida codigo de Iva y Bloqueo.                *
      *                                                              *
      *     peCiva   (input)   Código de Iva                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_iva...
     P                 B                   export
     D SVPVAL_iva...
     D                 pi              n
     D   peCiva                       2  0 const
     D
     D k1yiv1          ds                  likerec(g1tiv1:*key)

      /free

       SVPVAL_inz();

       k1yiv1.i1civa = peCiva;

       chain(n) %kds( k1yiv1 ) gntiv1;
       if not %found( gntiv1 );

         SetError( SVPVAL_IVANE
                 : 'Código de Iva Inexistente' );
         return *Off;

       else;

         if i1bloq <> 'N';

           SetError( SVPVAL_IVABL
                   : 'Código de Iva Bloqueado' );
           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_iva...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_ivaWeb(): Valida codigo de Iva y Uso Web.             *
      *                                                              *
      *     peCiva   (input)   Código de Iva                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_ivaWeb...
     P                 B                   export
     D SVPVAL_ivaWeb...
     D                 pi              n
     D   peCiva                       2  0 const
     D
     D k1yiv1          ds                  likerec(g1tiv1:*key)

      /free

       SVPVAL_inz();

       k1yiv1.i1civa = peCiva;

       chain(n) %kds( k1yiv1 ) gntiv1;
       if not %found( gntiv1 );

         SetError( SVPVAL_IVANE
                 : 'Código de Iva Inexistente' );
         return *Off;

       else;

         if i1mweb = '0';

           SetError( SVPVAL_IVANW
                   : 'IVA no valido para la Web' );
           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_ivaWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_codigoPostal():  Valida código postal.                *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubFijo Postal                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_codigoPostal...
     P                 B                   export
     D SVPVAL_codigoPostal...
     D                 pi              n
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D
     D k1yloc          ds                  likerec(g1tloc:*key)

      /free

       SVPVAL_inz();

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;

       setll %kds( k1yloc ) gntloc;
       if not %equal ( gntloc );

         SetError( SVPVAL_COPNE
                 : 'Código Postal Inexistente' );
         return *Off;

       endif;

       return *On;

      /end-free

     P SVPVAL_codigoPostal...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_codigoPostalWeb():  Valida código postal y Web.       *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubFijo Postal                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_codigoPostalWeb...
     P                 B                   export
     D SVPVAL_codigoPostalWeb...
     D                 pi              n
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D
     D k1yloc          ds                  likerec(g1tloc:*key)

      /free

       SVPVAL_inz();

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;

       setll %kds( k1yloc ) gntloc;
       if not %equal( gntloc );

         SetError( SVPVAL_COPNE
                 : 'Código Postal Inexistente' );
         return *Off;

       else;

         if lomweb = '0';

           SetError( SVPVAL_COPNE
                   : 'Código Postal Inexistente' );
           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_codigoPostalWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_tipoPersona(): Valida el tipo de persona.     .       *
      *                                                              *
      *     peTipe   (input)   Tipo de Persona                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_tipoPersona...
     P                 B                   export
     D SVPVAL_tipoPersona...
     D                 pi              n
     D   peTipe                       1    const
     D
     D k1yloc          ds                  likerec(g1tloc:*key)

      /free

       SVPVAL_inz();

       if peTipe <> 'F' and peTipe <> 'J' and peTipe <> 'C';

         SetError( SVPVAL_TPENV
                 : 'Tipo de Persona debe ser F/J/C' );
         return *Off;

       endif;

       return *On;

      /end-free

     P SVPVAL_tipoPersona...
     P                 E
     P
      * ------------------------------------------------------------ *
      * SVPVAL_spolRenovacion(): Valida el tipo de persona.          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   SuperPóliza                           *
      *     peTiou   (input)   Tipo Operación                        *
      *     peStou   (input)   SubTipo Operación                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_spolRenovacion...
     P                 B                   export
     D SVPVAL_spolRenovacion...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       7  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D

      /free

       SVPVAL_inz();

       if peTiou = 2 and peStou = 0;

         if peSpol = 0;

           SetError( SVPVAL_SPOCE
                   : 'Super poliza en Cero' );
           return *Off;

         else;

           if SPVSPO_chkSpol( peEmpr : peSucu : peArcd : peSpol ) = *off;

             SetError( SVPVAL_SPONE
                     : 'Super poliza Inexistente' );
             return *Off;

           endif;

         endif;

       endif;


       return *On;


      /end-free

     P SVPVAL_spolRenovacion...
     P                 E
     P
      * --------------------------------------------------------------*
      * SVPVAL_chkDeleteBienAsegurado(): Ver si se puede o no eliminar*
      *                                  el bien asegurado            *
      *                                                               *
      *     peBase   (input)   Parametro Base                         *
      *     peNctw   (input)   Número de Cotización                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *

     P SVPVAL_chkDeleteBienAsegurado...
     P                 B                   export
     D SVPVAL_chkDeleteBienAsegurado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D
     D k1y000          ds                  likerec(c1w000:*key)

      /free

       SVPVAL_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );

         if w0cest = 1 and w0cses = 1;

           return *On;

         else;

             SetError( SVPVAL_CTWNT
                     : 'No se puede Eliminar Bien Asegurado de Cotización');
             return *Off;

         endif;

       else;

         return *Off;

       endif;


      /end-free

     P SVPVAL_chkDeleteBienAsegurado...
     P                 E
     P
      * --------------------------------------------------------------*
      * SVPVAL_rama(): Valida la rama                                 *
      *                                                               *
      *     peRama   (input)   Código rama                            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *

     P SVPVAL_rama     B                   export
     P
     D SVPVAL_rama     pi              n
     D
     D   peRama                       2  0 const
     D
     D k1y001          ds                  likerec(s1t001:*key)

      /free

       SVPVAL_inz();

       k1y001.t@rama = peRama;

       setll %kds( k1y001 ) set001;
       if not %equal ( set001 );

         SetError( SVPVAL_RAMNE
                 : 'Rama no Existe');
         return *Off;

       endif;

       return *On;

      /end-free

     P SVPVAL_rama     E
     P
      * --------------------------------------------------------------*
      * SVPVAL_ramaWeb(): Valida la rama en la Web                    *
      *                                                               *
      *     peRama   (input)   Código rama                            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_ramaWeb  B                   export
     P
     D SVPVAL_ramaWeb  pi              n
     D
     D   peRama                       2  0 const
     D
     D k1y001          ds                  likerec(s1t001:*key)

      /free

       SVPVAL_inz();

       k1y001.t@rama = peRama;

       chain(n) %kds( k1y001 ) set001;
       if %found(set001);

         if t@mweb = '0';

           SetError( SVPVAL_RAMNW
                   : 'Rama no Incluye Web');
           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_ramaWeb  E
      * --------------------------------------------------------------*
      * SVPVAL_sumaAsegurada(): Validar Suma asegurada.               *
      *                                                               *
      *     peRama   (input)   Código rama                            *
      *     peVhmc   (input)   Marca                                  *
      *     peVhmo   (input)   Modelo                                 *
      *     peVhcs   (input)   SubModelo                              *
      *     peAnio   (input)   Año                                    *
      *     peMone   (input)   Moneda                                 *
      *     peSuma   (input)   Suma Asegurada                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *

     P SVPVAL_sumaAsegurada...
     P                 B                   export
     D SVPVAL_sumaAsegurada...
     D                 pi              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peAnio                       4  0 const
     D   peMone                       2    const
     D   peSuma                      13  2 const
     D
     D vmin            s             13  2
     D vmax            s             13  2
     D
     D k1y200          ds                  likerec(s1t200:*key)
     D k1y204          ds                  likerec(s1t204:*key)
     D k1y207          ds                  likerec(s1t207:*key)

      /free

       SVPVAL_inz();

       k1y204.s4_t@vhmc = peVhmc;
       k1y204.s4_t@vhmo = peVhmo;
       k1y204.s4_t@vhcs = peVhcs;

       chain(n) %kds( k1y204 ) set204;
       if %found( set204 );

         k1y207.s7_t@vhmc = peVhmc;
         k1y207.s7_t@vhmo = peVhmo;
         k1y207.s7_t@vhcs = peVhcs;
         k1y207.s7_t@vhcr = s4_t@vhcr;
         k1y207.s7_t@vhaÑ = peAnio;

         chain(n) %kds( k1y207 ) set207;
         if %found( set207 );

           k1y200.t@mone = peMone;
           k1y200.t@sumh = s7_t@vhvu;

           setll %kds( k1y200 ) set200;
           reade %kds( k1y200 : 1 ) set200;

           vmin = s7_t@vhvu - (s7_t@vhvu * (t@mini/100));
           vmax = s7_t@vhvu + (s7_t@vhvu * (t@maxi/100));

           if peSuma >= vmin and peSuma <= vmax;

             return *On;

           else;

             SetError( SVPVAL_SUMFV
                     : 'Suma Asegurada Fuera de Valor');
             return *off;

           endif;

         endif;

       endif;

       return *Off;

      /end-free

     P SVPVAL_sumaAsegurada...
     P                 E
     P
      * --------------------------------------------------------------*
      * SVPVAL_sumaGnc(): Valida Suma GNC.                            *
      *                                                               *
      *     peSuma   (input)   Suma Asegurado                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_sumaGnc  B                   export
     P
     D SVPVAL_sumaGnc  pi              n
     D
     D   peSuma                      13  2 const
     D
     D vmin            s             13  2
     D vmax            s             13  2
     D
     D k1y239          ds                  likerec(s1t239:*key)

      /free

       SVPVAL_inz();

       setll *start set239;
       read set239;

       vmin = s9_t@rgnc;
       vmax = s9_t@rgnc * (1+s9_t@pora/100);

       if peSuma >= vmin and peSuma <= vmax;

         return *On;

       else;

         SetError( SVPVAL_GNCFV
                  : 'Suma GNC Fuera de Valor');
         return *off;

       endif;


       return *Off;

      /end-free

     P SVPVAL_sumaGnc  E
      * --------------------------------------------------------------*
      * SVPVAL_sumaGncWeb(): Valida Suma GNC para WEB                 *
      *                                                               *
      *     peSuma   (input)   Suma Asegurado                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_sumaGncWeb...
     P                 b                   export
     D SVPVAL_sumaGncWeb...
     D                 pi              n
     D
     D   peSuma                      13  2 const
     D
     D vmin            s             13  2
     D vmax            s             13  2
     D
     D k1y239          ds                  likerec(s1t2391:*key)

      /free

       SVPVAL_inz();

       setll *start set23901;
       read set23901;

       vmin = s91_t@rgnc;
       vmax = s91_t@rgnc * (1+s91_t@pora/100);

       if peSuma >= vmin and peSuma <= vmax;

         return *On;

       else;

         SetError( SVPVAL_GNCFV
                  : 'Suma GNC Fuera de Valor');
         return *off;

       endif;


       return *Off;

      /end-free

     P SVPVAL_sumaGncWeb...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_zonaDeRiego(): Valida zona de riesgo.                  *
      *                                                               *
      *     peScta   (input)   Zona de Riesgo                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_zonaDeRiego...
     P                 b                   export
     D SVPVAL_zonaDeRiego...
     D                 pi              n
     D
     D   peScta                       1  0 const
     D
     D vmin            s             13  2
     D vmax            s             13  2
     D

      /free

       SVPVAL_inz();

       if peScta >= 0 and peScta <= 9;

         return *On;

       else;

         SetError( SVPVAL_ZONFV
                  : 'Zona de Riesgo Fuera de Valor');
         return *off;

       endif;

       return *Off;

      /end-free

     P SVPVAL_zonaDeRiego...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_clienteIntegral():Valida Cliente integral.             *
      *                                                               *
      *     peClin   (input)   Cliente Integral                       *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_clienteIntegral...
     P                 b                   export
     D SVPVAL_clienteIntegral...
     D                 pi              n
     D
     D   peClin                       1    const
     D

      /free

       SVPVAL_inz();

       if peClin = 'S' or peClin = 'N';

         return *On;

       else;

         SetError( SVPVAL_CLIFV
                  : 'Cliente Fuera de Valor');
         return *off;

       endif;

       return *Off;

      /end-free

     P SVPVAL_clienteIntegral...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_marcaGNC():Valida la marca GNC.                        *
      *                                                               *
      *     peMgnc   (input)   Marca de GNC.                          *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_marcaGNC...
     P                 b                   export
     D SVPVAL_marcaGNC...
     D                 pi              n
     D
     D   peMgnc                       1    const
     D

      /free

       SVPVAL_inz();

       if peMgnc = 'S' or peMgnc = 'N';

         return *On;

       else;

         SetError( SVPVAL_GNCNV
                  : 'Marca de GNC no Válida');
         return *off;

       endif;

       return *Off;

      /end-free

     P SVPVAL_marcaGNC...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_formaDePago(): Valida forma de Pago.                   *
      *                                                               *
      *     peCfpg   (input)   Forma de Pago                          *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_formaDePago...
     P                 b                   export
     D SVPVAL_formaDePago...
     D                 pi              n
     D
     D   peCfpg                       1  0 const
     D
     D k1yfpg          ds                  likerec(g1tfpg:*key)

      /free

       SVPVAL_inz();

       k1yfpg.fpcfpg = peCfpg;

       setll %kds( k1yfpg ) gntfpg;
       if %equal( gntfpg );

         return *on;

       else;

         SetError( SVPVAL_FDPNE
                  : 'Forma de Pago No Existe');
         return *off;

       endif;

       return *Off;

      /end-free

     P SVPVAL_formaDePago...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_formaDePagoWeb():Valida forma de Pago Web.             *
      *                                                               *
      *     peCfpg   (input)   Forma de Pago                          *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_formaDePagoWeb...
     P                 b                   export
     D SVPVAL_formaDePagoWeb...
     D                 pi              n
     D
     D   peCfpg                       1  0 const
     D
     D k1yfpg          ds                  likerec(g1tfpg2:*key)

      /free

       SVPVAL_inz();

       k1yfpg.g2_fpcfpg = peCfpg;

       setll %kds( k1yfpg ) gntfpg02;
       if %equal( gntfpg02 );

         return *on;

       else;

         SetError( SVPVAL_FDPNW
                  : 'Forma de Pago no Valida para Web' );
         return *off;

       endif;

       return *Off;

      /end-free

     P SVPVAL_formaDePagoWeb...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_tarifa(): Valida tarifa.                               *
      *                                                               *
      *     peFech   (input)   Fecha                                  *
      *     peCtre   (input)   Codigo de Tarifa                       *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_tarifa...
     P                 b                   export
     D SVPVAL_tarifa...
     D                 pi              n
     D
     D   peFech                       8  0 const
     D   peCtre                       5  0 const
     D
     D k1ytar          ds                  likerec(s1ttar:*key)

      /free

       SVPVAL_inz();

       k1ytar.t@fini = peFech;

       setll %kds( k1ytar : 1 ) settar;
       read settar;
       dow not %eof;

         if t@ctre = peCtre;

           return *on;

         endif;

         read settar;
       enddo;

       //si no encontro nada anteriormente sale con este error.

       SetError( SVPVAL_TARIV
                : 'Tarifa no Válida' );
       return *off;


      /end-free

     P SVPVAL_tarifa...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_coberturaWeb() Valida cobertura para web.              *
      *                                                               *
      *     peCobl   (input)   Cobertura                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_coberturaWeb...
     P                 b                   export
     D SVPVAL_coberturaWeb...
     D                 pi              n
     D
     D   peCobl                       2    const
     D
     D k1y225          ds                  likerec(s1t225:*key)

      /free

       SVPVAL_inz();

       k1y225.t@cobl = peCobl;

       setll %kds( k1y225 ) set22501;
       if %equal (set22501);

         return *on;

       else;

         SetError( SVPVAL_COBNW
                  : 'Cobertura no Valida para Web' );
         return *off;

       endif;

       return *off;

      /end-free

     P SVPVAL_coberturaWeb...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_estadoCotizacion(): Valida estado de cotización.       *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_estadoCotizacion...
     P                 b                   export
     D SVPVAL_estadoCotizacion...
     D                 pi              n
     D
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D
     D k1y000          ds                  likerec(c1w000:*key)

      /free

       SVPVAL_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );

         if w0cest = 1 and w0cses <> 9;

           return *on;

         else;

           SetError( SVPVAL_CTWNC
                    : 'Estado de Cotización No Valido');
           return *off;

         endif;

       endif;

       return *off;

      /end-free

     P SVPVAL_estadoCotizacion...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkReCotizacion(): Valida estado de cotización.        *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkReCotizacion...
     P                 b                   export
     D SVPVAL_chkReCotizacion...
     D                 pi              n
     D
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D

      /free

       SVPVAL_inz();

       if SVPVAL_estadoCotizacion ( peBase : peNctw ) = *off;

         SetError( SVPVAL_CTWNR
                  : 'Detalle de prima no generado');
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkReCotizacion...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_tipoDeDocumento(): Valida estado de cotización.        *
      *                                                               *
      *     peTido   (input)   Tipo de Documento                      *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_tipoDeDocumento...
     P                 b                   export
     D SVPVAL_tipoDeDocumento...
     D                 pi              n
     D   peTido                       2  0 const
     D
     D k1ytdo          ds                  likerec(g1ttdo:*key)

      /free

       SVPVAL_inz();

       k1ytdo.gntido = peTido;

       setll %kds( k1ytdo ) gnttdo;
       if %equal (gnttdo);

         return *on;

       else;

         SetError( SVPVAL_TDONE
                  : 'Tipo de Documento no Existe');
         return *off;

       endif;


      /end-free

     P SVPVAL_tipoDeDocumento...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_nroDeDocumento(): Nro de Documento                     *
      *                                                               *
      *     peNrdo   (input)   Nro. de Documento                      *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_nroDeDocumento...
     P                 b                   export
     D SVPVAL_nroDeDocumento...
     D                 pi              n
     D   peNrdo                       8  0 const

       SVPVAL_inz();

       if peNrdo = *Zeros;

         SetError( SVPVAL_NROBL
                  : 'Nro. de Documento en Cero');
         return *off;

       endif;

       return *on;

     P SVPVAL_nroDeDocumento...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkBlkDocumento():Valida si el asegurado esta bloqueado*
      *                          por el número de documento.          *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peTido   (input)   Tipo de Documento                      *
      *     peNrdo   (input)   Número de Documento                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkBlkDocumento...
     P                 b                   export
     D SVPVAL_chkBlkDocumento...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTido                       2  0 const
     D   peNrdo                       9  0 const
     D
     D k1yf05          ds                  likerec(g1hdaf05:*key)
     D k1y000          ds                  likerec(c1w000:*key)
     D tipope          s              1  0

      /free

       SVPVAL_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );
         tipope = w0tiou;
       endif;

       k1yf05.dftido = peTido;
       k1yf05.dfnrdo = peNrdo;

       setll %kds( k1yf05 : 2 ) gnhdaf05;
       reade %kds( k1yf05 : 2 ) gnhdaf05;
       dow not %eof;

         chain(n) ( dfnrdf ) sehase;
         if %found;
           if asbloq >= %editc(tipope:'X');

             SetError( SVPVAL_ASBLK
                      : 'Número de Asegurado Bloqueado');
             return *off;

           endif;
         endif;

         reade %kds( k1yf05 : 2 ) gnhdaf05;
       enddo;

       return *on;

      /end-free

     P SVPVAL_chkBlkDocumento...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkBlkCuit():Valida si el asegurado esta bloqueado por *
      *                     número de CUIT y CUIL.                    *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peCuit   (input)   Numero Cuit/Cuil                       *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkBlkCuit...
     P                 b                   export
     D SVPVAL_chkBlkCuit...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCuit                      11  0 const
     D
     D k1yf06          ds                  likerec(g1hdaf06:*key)
     D k1y000          ds                  likerec(c1w000:*key)
     D tipope          s              1  0

      /free

       SVPVAL_inz();

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;
       if %found( ctw000 );
         tipope = w0tiou;
       endif;

       k1yf06.dfcuit = %editc(peCuit:'X');

       setll %kds( k1yf06 : 1 ) gnhdaf06;
       reade %kds( k1yf06 : 1 ) gnhdaf06;
       dow not %eof;

         chain(n) ( dfnrdf ) sehase;
         if %found;
           if asbloq >= %editc(tipope:'X');

             SetError( SVPVAL_ASBLK
                      : 'Número de Asegurado Bloqueado');
             return *off;

           endif;
         endif;

         reade %kds( k1yf06 : 1 ) gnhdaf06;
       enddo;

       return *on;

      /end-free

     P SVPVAL_chkBlkCuit...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_ramaRiesgo():Valida si el riesgo corresponde a la rama *
      *                     ingresada.                                *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peRiec   (input)   Código del Riesgo                      *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_ramaRiesgo...
     P                 b                   export
     D SVPVAL_ramaRiesgo...
     D                 pi              n
     D   peRama                       2  0 const
     D   peRiec                       3    const
     D
     D k1y104          ds                  likerec(s1t104:*key)

      /free

       SVPVAL_inz();

       k1y104.t@rama = PeRama;
       k1y104.t@riec = peRiec;

       setll %kds( k1y104 : 2 ) set104;
       if not %equal( set104 );

         SetError( SVPVAL_RIENV
                  : 'Código de Riesgo No Valido Para Rama' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_ramaRiesgo...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_ramaCobertura(): Valida si la cobertura corresponde a  *
      *                         la rama.                              *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCobc   (input)   Código de Cobertura                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_ramaCobertura...
     P                 b                   export
     D SVPVAL_ramaCobertura...
     D                 pi              n
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
     D
     D k1y107          ds                  likerec(s1t107:*key)

      /free

       SVPVAL_inz();

       k1y107.t@rama = PeRama;
       k1y107.t@cobc = peCobc;

       setll %kds( k1y107 : 2 ) set107;
       if not %equal( set107 );

         SetError( SVPVAL_COBNV
                  : 'Cobertura no Valida para Para Rama' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_ramaCobertura...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_ramaRiesgoCob(): Valida Rama  Riesgo y Cobertura       *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peRiec   (input)   Código del Riesgo                      *
      *     peCobc   (input)   Código de Cobertura                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_ramaRiesgoCob...
     P                 b                   export
     D SVPVAL_ramaRiesgoCob...
     D                 pi              n
     D   peRama                       2  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D
     D k1y106          ds                  likerec(s1t106:*key)

      /free

       SVPVAL_inz();

       k1y106.t@rama = PeRama;
       k1y106.t@riec = peRiec;
       k1y106.t@cobc = peCobc;

       setll %kds( k1y106 : 3 ) set106;
       if not %equal( set106 );

         SetError( SVPVAL_RCRNV
                  : 'Riesgo y Cobertura No Validos Para Rama' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_ramaRiesgoCob...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_CuitCuil(): Valida el numero de cuil y cuit            *
      *                                                               *
      *     peCuit   (input)   Numero de Cuil o Cuit                  *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_CuitCuil...
     P                 b                   export
     D SVPVAL_CuitCuil...
     D                 pi              n
     D   peCuit                      14    const
     D

      /free

       SVPVAL_inz();

       cuitsp83 = peCuit;

       sp0083 (cuitsp83 :
               Errsp83 );

       if Errsp83 = '1';

         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_CuitCuil...
     P                 E
      * ------------------------------------------------------------ *
      * articuloHabilitadoWeb(): Utilidad de este programa de servi- *
      *                      cio para determinar si artículo está    *
      *                      habilitado para la web.                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P articuloHabilitadoWeb...
     P                 B
     D articuloHabilitadoWeb...
     D                 pi             1N
     D  peArcd                        6  0 const

      /free

       SVPVAL_inz();

       setgt  peArcd set630w;
       readpe peArcd set630w;
       dow not %eof;

         if t@fech <= %dec(%date());
           if t@mp01 = 'S';
             return *on;
           else;
             return *off;
           endif;
         endif;

         readpe peArcd set630w;

       enddo;

       return *off;

      /end-free

     P articuloHabilitadoWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_chkRamaPlan(): Valida Rama Plan                       *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     pePlan   (input)   Plan                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVAL_chkRamaPlan...
     P                 B                   export
     D SVPVAL_chkRamaPlan...
     D                 pi              n
     D  peRama                        2  0 const
     D  pePlan                        3  0 const

     D  k1y102         ds                  likerec(s1t102:*key)
      /free

       SVPVAL_inz();

       k1y102.t@rama = peRama;
       k1y102.t@xpro = peplan;

       setll %kds( k1y102 : 2 ) set102;
       if not %equal (set102);

         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkRamaPlan...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_chkCaracBien() Valida Característica del Bien         *
      *                                                              *
      *     peBase   (input)   Parametro Base                        *
      *     peRama   (input)   Rama                                  *
      *     peCara   (input)   Características                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVAL_chkCaracBien...
     P                 B                     export
     D SVPVAL_chkCaracBien...
     D                 pi             1N
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  peCara                        3  0 const

     D  k1y160         ds                  likerec(s1t160:*key)
      /free

       SVPVAL_inz();

       k1y160.t@empr = peBase.peEmpr;
       k1y160.t@sucu = peBase.peSucu;
       k1y160.t@rama = peRama;
       k1y160.t@ccba = peCara;

       setll %kds( k1y160 ) set160;
       if  not %equal;

         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkCaracBien...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_chkCondCarac() Valida valor de Caracteristicas que    *
      *                       dependen de alguna condición.          *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubFijo Postal                        *
      *     peCara   (input)   Código de característica              *
      *     peMa01   (input)   Marca tiene o no tiene                *
      *     peMa02   (input)   marca Aplica o no Aplica              *
      *     peAnio   (input)   Año de Buen Reasultado                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVAL_chkCondCarac...
     P                 B                     export
     D SVPVAL_chkCondCarac...
     D                 pi              n
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peCara                        3  0 const
     D  peMa01                        1    const
     D  peMa02                        1    const
     D  peAnio                        2  0 const
     D  peEmpr                        1a   const options(*nopass:*omit)
     D  peSucu                        2a   const options(*nopass:*omit)
     D  peNivt                        1  0 const options(*nopass:*omit)
     D  peNivc                        5  0 const options(*nopass:*omit)

     D  k1yloc         ds                  likerec(g1tloc:*key)
     D  p@Arcd         s              6  0
     D  p@Anio         s              2  0
     D  p@Pbre         s              5  2
     D  p@Bure         s              1  0
     D  bajoRies       s               n
     D  buenRes1       s               n
     D  buenRes2       s               n
     D  buenRes3       s               n
     D  p@Copo         s              5  0
     D  p@Cops         s              1  0

     D validarBR       s              1n
     D productor_especial...
     D                 s              1n

      /free

       SVPVAL_inz();

       validarBR =  %parms >= 10 and %addr(peEmpr) <> *null and
                                     %addr(peSucu) <> *null and
                                     %addr(peNivt) <> *null and
                                     %addr(peNivc) <> *null;

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;

       chain(n) %kds( k1yloc ) gntloc;
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

       //Valida valor de Caracteristicas que dependen de alguna condicion//

       //Bajo Riesgo
       if peCara = 996;
         if bajories;
           if peMa01 = 'N';
             SetError( SVPVAL_BRIES
                      : 'Tiene Bajo Riesgo debe ser "S"' );
             return *off;
           endif;
         else;
           if peMa01 = 'S';
             SetError( SVPVAL_BRIEN
                      : 'Tiene Bajo Riesgo debe ser "N"' );
             return *off;
           endif;
           if peMa02 = 'S';
             SetError( SVPVAL_RIEBN
                      : 'Aplica 996 Bajo Riesgo debe ser "N"' );
             return *off;
           endif;
         endif;
       endif;

       // --------------------------------------
       // Buen Resultado especial
       // --------------------------------------
       productor_especial = *off;
       if validarBR;
          productor_especial = SVPBUE_chkProductorEspecial( peEmpr
                                                          : peSucu
                                                          : peNivt
                                                          : peNivc );
       endif;

       //Buen Resultado 1er Año
       if peCara = 997 and productor_especial = *off;
         if buenRes1;
           if peMa01 = 'N';
             SetError( SVPVAL_BRESS
                      : 'Tiene Buen Res. 1 Año debe ser "S"');
             return *off;
           endif;
         else;
           if peMa01 = 'S';
             SetError( SVPVAL_BRESN
                      : 'Tiene Buen Res. 1 Año debe ser "N"');
             return *off;
           endif;
           if peMa02 = 'S';
             SetError( SVPVAL_ABRES
                      : 'Aplica Buen Res. 1 Año debe ser "N"');
             return *off;
           endif;
         endif;
       endif;

       //Buen Resultado 2do Año
       if peCara = 998 and productor_especial = *off;
         if buenRes2;
           if peMa01 = 'N';
             SetError( SVPVAL_BRESS
                      : 'Tiene Buen Res. 2 Año debe ser "S"');
             return *off;
           endif;
         else;
           if peMa01 = 'S';
             SetError( SVPVAL_BRESN
                      : 'Tiene Buen Res. 2 Año debe ser "N"');
             return *off;
           endif;
           if peMa02 = 'S';
             SetError( SVPVAL_ABRES
                      : 'Aplica Buen Res. 2 Años debe ser "N"');
             return *off;
           endif;
         endif;
       endif;

       //Buen Resultado 3er Año
       if peCara = 999 and productor_especial = *off;
         if buenRes3;
           if peMa01 = 'N';
             SetError( SVPVAL_BRESS
                      : 'Tiene Buen Res. 3 Año debe ser "S"');
             return *off;
           endif;
         else;
           if peMa01 = 'S';
             SetError( SVPVAL_BRESN
                      : 'Tiene Buen Res. 3 Año debe ser "N"');
             return *off;
           endif;
           if peMa02 = 'S';
             SetError( SVPVAL_ABRES
                      : 'Aplica Buen Res. 3 Años debe ser "N"');
             return *off;
           endif;
         endif;
       endif;

       return *on;

      /end-free

     P SVPVAL_chkCondCarac...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_chkCobPrima()= Valida Coberturas de Primas            *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura(Prima)                      *
      *     peMone   (input)   Moneda                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVAL_chkCobPrima...
     P                 B                     export
     D SVPVAL_chkCobPrima...
     D                 pi              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peRiec                        3    const
     D  peCobc                        3  0 const
     D  peMone                        2    const
      *
     D  k1y103         ds                  likerec(s1t103:*key)

      /free

       SVPVAL_inz();

       k1y103.t@rama = peRama;
       k1y103.t@xpro = peXpro;
       k1y103.t@riec = peRiec;
       k1y103.t@cobc = peCobc;
       k1y103.t@mone = peMone;

       setll %kds( k1y103 : 5 ) set103;
       if not %equal;

         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkCobPrima...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_chkCodBuenR(): Valida Código de Buen Resultado.       *
      *     peBure   (input)   Código de Buen Resultado              *
      *                                                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVAL_chkCodBuenR...
     P                 B                     export
     D SVPVAL_chkCodBuenR...
     D                 pi             1N
     D   peBure                       1  0   const

      /free

       SVPVAL_inz();

          if peBure < 0 or peBure > 3;
             return *off;
          endif;

       return *on;

     P SVPVAL_chkCodBuenR...
     P                 E
      * ------------------------------------------------------------- *
      * SVPVAL_CHKCobSumMaxMin(): Valida Suma Máxima y Mínima por -   *
      *                            Cobertura.                         *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peXpro   (input)   Plan                                   *
      *     peRiec   (input)   Cod. Riesgo                            *
      *     peCobc   (input)   Cod. Cobertura                         *
      *     peMone   (input)   Moneda                                 *
      *     peSaco   (input)   Suma asegurada                         *
      *     peLcob   (input)   Lista de Coberturas                    *
      *                                                               *
      * Return *on / *off                                             *
      * ------------------------------------------------------------- *
     P SVPVAL_CHKCobSumMaxMin...
     P                 B                   export
     D SVPVAL_CHKCobSumMaxMin...
     D                 pi              n
     D   peRama                       2  0   const
     D   peXpro                       3  0   const
     D   peRiec                       3      const
     D   peCobc                       3  0   const
     D   peMone                       2      const
     D   peSaco                      15  2   const
     D   peLcob                              likeds(cobPrima) dim(20) const

     D   k1y1031       ds                   likerec( s1t1031 : *key )

     D x               s             10i 0

      /free

       SVPVAL_inz();

       k1y1031.t1Rama = peRama;
       k1y1031.t1Xpro = peXpro;
       k1y1031.t1Riec = peRiec;
       k1y1031.t1Cobc = peCobc;
       k1y1031.t1Mone = peMone;
       chain(n) %kds( k1y1031 ) set1031;

       if %found( set1031 );

         //
         // Los dos máximos (importe y porcentaje) en cero
         // me voy con error
         //
         if t1sacox = 0 and t1prsax = 0;
             return *off;
         endif;

         //
         // Si hay al menos un limite por valor, entonces
         // la suma debe estar en el entorno
         //
         if t1sacox <> 0 or t1lmin <> 0;
            if peSaco < t1lmin or pesaco > t1sacox;
               return *off;
            endif;
         endif;

         //
         // Por último controlo los límites cuando sean por porcentajes
         //
           for x = 1 to 20;
             if peLcob(x).riec <> *blanks and peLcob(x).xcob <> 0;
                if peLcob(x).riec = t1riecx and peLcob(x).xcob = t1cobcx;
                  if peSaco > ( ( peLcob(x).sac1 * t1prsax ) / 100 );
                     return *off;
                  endif;
                  return *on;
                endif;
             endif;
           endfor;

       else;

         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_CHKCobSumMaxMin...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkProfesion(): Valida el código de profesión          *
      *                                                               *
      *     peCprf   (input)   Código de profesión                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkProfesion...
     P                 b                   export
     D SVPVAL_chkProfesion...
     D                 pi              n
     D   peCprf                       3  0 const
     D
     D k1yf02          ds                  likerec(g1tprf02:*key)

      /free

       SVPVAL_inz();

       k1yf02.prcprf = peCprf;

       setll %kds ( k1yf02 : 1 ) gntprf02;
       if not %equal();

         SetError( SVPVAL_PRFNV
                  : 'Profesión no Valida' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkProfesion...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkProfesionWeb(): Valida el código de profesión       *
      *                                                               *
      *     peCprf   (input)   Código de profesión                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkProfesionWeb...
     P                 b                   export
     D SVPVAL_chkProfesionWeb...
     D                 pi              n
     D   peCprf                       3  0 const
     D
     D k1yf02          ds                  likerec(g1tprf02:*key)

      /free

       SVPVAL_inz();

       if SVPVAL_chkProfesion ( peCprf );

         k1yf02.prcprf = peCprf;
         chain(n) %kds ( k1yf02 ) gntprf02;

           if prmweb = '0';

             SetError( SVPVAL_PRFNW
                      : 'Profesión no Valida para Web' );
             return *off;

           endif;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkProfesionWeb...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkSexo     (): Valida el código de sexo               *
      *                                                               *
      *     peSexo   (input)   Código de Sexo                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkSexo...
     P                 b                   export
     D SVPVAL_chkSexo...
     D                 pi              n
     D   peSexo                       1  0 const
     D
     D k1ysex          ds                  likerec(g1tsex:*key)

      /free

       SVPVAL_inz();

       k1ysex.secsex = peSexo;

       setll %kds ( k1ysex : 1 ) gntsex02;
       if not %equal();

         SetError( SVPVAL_SEXNV
                  : 'Sexo no Valido' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkSexo...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkSexoWeb(): Valida el código de sexo                 *
      *                                                               *
      *     peSexo   (input)   Código de Sexo                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkSexoWeb...
     P                 b                   export
     D SVPVAL_chkSexoWeb...
     D                 pi              n
     D   peSexo                       1  0 const
     D
     D k1ysex          ds                  likerec(g1tsex:*key)

      /free

       SVPVAL_inz();

       if SVPVAL_chkSexo ( peSexo );

         k1ysex.secsex = peSexo;

         chain(n) %kds ( k1ysex : 1 ) gntsex02;

         if semweb = '0';

           SetError( SVPVAL_SEXNW
                    : 'Sexo no Valido para Web' );
           return *off;

         endif;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkSexoWeb...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkEdoCivil (): Valida el código de estado civil       *
      *                                                               *
      *     peEsci   (input)   Código de estado Civil                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkEdoCivil...
     P                 b                   export
     D SVPVAL_chkEdoCivil...
     D                 pi              n
     D   peEsci                       1  0 const
     D
     D k1yesc          ds                  likerec(g1tesc:*key)

      /free

       SVPVAL_inz();

       k1yesc.escesc = peEsci;

       setll %kds ( k1yesc : 1 ) gntesc02;
       if not %equal();

         SetError( SVPVAL_ESCNV
                  : 'Estado Civil no Valido' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkEdoCivil...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkEdoCivilWeb(): Valida el código de estado civil     *
      *                                                               *
      *     peEsci   (input)   Código de estado Civil                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkEdoCivilWeb...
     P                 b                   export
     D SVPVAL_chkEdoCivilWeb...
     D                 pi              n
     D   peEsci                       1  0 const
     D
     D k1yesc          ds                  likerec(g1tesc:*key)

      /free

       SVPVAL_inz();


       if SVPVAL_chkEdoCivil ( peEsci );

         k1yesc.escesc = peEsci;

         chain(n) %kds ( k1yesc : 1 ) gntesc02;

         if esmweb = '0';

           SetError( SVPVAL_ESCNW
                    : 'Estado Civil no Valido para Web' );
           return *off;

         endif;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkEdoCivilWeb...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_CodRamaActE (): Valida el código de Rama de Actividad  *
      *                        económica.                             *
      *                                                               *
      *     peRaae   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkRamaActE...
     P                 b                   export
     D SVPVAL_chkRamaActE...
     D                 pi              n
     D   peRaae                       3  0 const
     D
     D k1yrae          ds                  likerec(g1trae02:*key)

      /free

       SVPVAL_inz();

       k1yrae.aeraae = peRaae;

       setll %kds ( k1yrae : 1 ) gntrae02;
       if not %equal();

         SetError( SVPVAL_RAENV
                  : 'Cod.Rama Actividad Económica No Válida' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkRamaActE...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkRamaActEWeb(): Valida el código de Rama de Actividad*
      *                        económica para web.                    *
      *                                                               *
      *     peRaae   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkRamaActEWeb...
     P                 b                   export
     D SVPVAL_chkRamaActEWeb...
     D                 pi              n
     D   peRaae                       3  0 const
     D
     D k1yrae          ds                  likerec(g1trae02:*key)

      /free

       SVPVAL_inz();

       if SVPVAL_chkRamaActE ( peRaae );

         k1yrae.aeraae = peRaae;

         chain(n) %kds ( k1yrae : 1 ) gntrae02;
         if aemweb = '0';

           SetError( SVPVAL_RAENW
                    : 'Cod.Rama Actividad Económica No Válida para Web' );
           return *off;

         endif;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkRamaActEWeb...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkPaisNac(): Valida el código del pais de nacimiento  *
      *                                                               *
      *     pePain   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkPaisNac...
     P                 b                   export
     D SVPVAL_chkPaisNac...
     D                 pi              n
     D   pePain                       5  0 const
     D
     D k1ypai          ds                  likerec(g1tpai:*key)

      /free

       SVPVAL_inz();

       k1ypai.papain = pePain;

       setll %kds ( k1ypai : 1 ) gntpai;
       if not %equal();

         SetError( SVPVAL_PAINV
                  : 'Código de País no Válido' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkPaisNac...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkAsegurado (): Valida que no exista ya el asegurado  *
      *                         titular.                              *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peNase   (input)   Número de Asegurado                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkAsegurado...
     P                 b                   export
     D SVPVAL_chkAsegurado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNase                       6  0 const
     D
     D k1y003          ds                  likerec(c1w003:*key)

      /free

       SVPVAL_inz();

       k1y003.w3empr = PeBase.peEmpr;
       k1y003.w3sucu = PeBase.peSucu;
       k1y003.w3nivt = PeBase.peNivt;
       k1y003.w3nivc = PeBase.peNivc;
       k1y003.w3nctw = peNctw;
       k1y003.w3Nase = peNase;

       setll %kds ( k1y003 : 6 ) ctw003;
       if %equal();

         SetError( SVPVAL_ASENV
                  : 'Numero de Asegurado Ya Existe' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkAsegurado...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkTipoPersona(): Valida que sea un tipo de persona    *
      *                          valida.                              *
      *                                                               *
      *     peTiso   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkTipoPersona...
     P                 b                   export
     D SVPVAL_chkTipoPersona...
     D                 pi              n
     D   peTiso                       2  0 const
     D
     D k1ytis          ds                  likerec(g1ttis:*key)

      /free

       SVPVAL_inz();

       k1ytis.gntiso = peTiso;

       setll %kds ( k1ytis : 1 ) gnttis;
       if not %equal();

         SetError( SVPVAL_TIPNV
                  : 'Tipo de Persona no Válido' );
         return *off;

       endif;

       return *on;

      /end-free

     P SVPVAL_chkTipoPersona...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkNroDeRuta(): Verifico si algun vehículo tiene numero*
      *                        de ruta.                               *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkNroDeRuta...
     P                 b                   export
     D SVPVAL_chkNroDeRuta...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D
     D k1yet0          ds                  likerec(c1wet0:*key)

      /free

       SVPVAL_inz();

       k1yet0.t0empr = PeBase.peEmpr;
       k1yet0.t0sucu = PeBase.peSucu;
       k1yet0.t0nivt = PeBase.peNivt;
       k1yet0.t0nivc = PeBase.peNivc;
       k1yet0.t0nctw = peNctw;

       setll %kds( k1yet0 : 5 ) ctwet0;
       reade %kds( k1yet0 : 5 ) ctwet0;
       dow not %eof( ctwet0 );

         if t0ruta <> 0;

           return *on;

         endif;

         reade %kds( k1yet0 : 5 ) ctwet0;
       enddo;

       return *off;

      /end-free

     P SVPVAL_chkNroDeRuta...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_urlIsValid  (): Valido que sea una página web Valida   *
      *                                                               *
      *     url      (input)   Dirección                              *
      *     len      (input)   tamaño                                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_urlIsValid...
     P                 b                   export
     D SVPVAL_urlIsValid...
     D                 pi              n
     D   url                      65535    const options(*varsize)
     D   len                         10i 0 const
     D
     D exp             s             66a   varying
     D reg             ds                  likeds(regex_t)
     D match           ds                  likeds(regmatch_t)
     D rc              s             10i 0
     D m               s             10i 0

      /free

       SVPVAL_inz();

       // ---------------------------------
       // Expresion regular
       // ---------------------------------

       exp = '^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w '
             + '\?=.-]*)*\/?$';

       // ---------------------------------
       // compilo la ER
       // ---------------------------------

       if regcomp( reg
                  : exp
                  : REG_EXTENDED + REG_ICASE + REG_NOSUB) <> 0;

         regfree(reg);
         return *off;

       endif;

       // ---------------------------------
       // Ejecuto
       // ---------------------------------

       if regexec(  reg
                  : %trim(url)
                  : 0
                  : match
                  : 0) = *zeros;

         regfree(reg);
         return *off;

       else;

         regfree(reg);
         return *on;

       endif;

      /end-free

     P SVPVAL_urlIsValid...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_nivelProductor():Verifico el nivel del productor, si   *
      *                         no es nivel 1 no debe permitir emitir *
      *                         cotización.                           *
      *                                                               *
      *     peNivt   (input)   Nivel Productor                        *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_nivelProductor...
     P                 b                   export
     D SVPVAL_nivelProductor...
     D                 pi              n
     D   peNivt                       1  0 const
     D
     D k1yet0          ds                  likerec(c1wet0:*key)

      /free

       SVPVAL_inz();


       if peNivt = 1;

         return *on;

       endif;

       return *off;

      /end-free

     P SVPVAL_nivelProductor...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_arcdRamaArse():Verifico que exista                     *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   Arse                                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_arcdRamaArse...
     P                 b                   export
     D SVPVAL_arcdRamaArse...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1y621          ds                  likerec(s1t621:*key)

      /free

       SVPVAL_inz();

       k1y621.t@arcd = peArcd;
       k1y621.t@rama = peRama;
       k1y621.t@arse = peArse;

       setll %kds ( k1y621 ) set621;

       if %equal ( set621 );

         return *on;

       endif;

       return *off;

      /end-free

     P SVPVAL_arcdRamaArse...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_empresa():Verifico que exista empresa                  *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_empresa...
     P                 b                   export
     D SVPVAL_empresa...
     D                 pi              n
     D   peEmpr                       1    const

       SVPVAL_inz();

       setll peEmpr gntemp;

       if %equal ( gntemp );

         return *on;

       endif;

       return *off;

     P SVPVAL_empresa...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_sucursal():Verifico que exista sucursal                *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_sucursal...
     P                 b                   export
     D SVPVAL_sucursal...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const

     D k1ysuc          ds                  likerec(g1tsuc:*key)

       SVPVAL_inz();

       k1ysuc.suempr = peEmpr;
       k1ysuc.susucu = peSucu;

       setll %kds ( k1ysuc ) gntsuc;

       if %equal ( gntsuc );

         return *on;

       endif;

       return *off;

     P SVPVAL_sucursal...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkProvincia():Verifica que la sucursal exista         *
      *                                                               *
      *     peProc   (input)   Provincia                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkProvinciaInder...
     P                 b                   export
     D SVPVAL_chkProvinciaInder...
     D                 pi              n
     D   peProc                       2  0 const

       SVPVAL_inz();

       setll *Start gntpro;
       read gntpro;

       dow not %eof ( gntpro );

         if prrpro = peProc;
           return *On;
         endif;

         read gntpro;

       enddo;

       SetError( SVPVAL_NPROV
               : 'Provincia Inexistente' );
       return *Off;

     P SVPVAL_chkProvinciaInder...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_tipoMail(): Verifica tipo de mail                      *
      *                                                               *
      *     peCtce   (input)   Tipo de mail                           *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_tipoMail...
     P                 b                   export
     D SVPVAL_tipoMail...
     D                 pi              n
     D   peCtce                       2  0 const

       SVPVAL_inz();

       setll peCtce gnttce;

       if not %equal ( gnttce );
         SetError( SVPVAL_TMINE
                 : 'Tipo de Mail Inexistente' );
         return *Off;
       endif;

       return *On;

     P SVPVAL_tipoMail...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_nacionalidad(): Verifica tipo de mail                  *
      *                                                               *
      *     peCnac   (input)   Nacionalidad                           *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_nacionalidad...
     P                 b                   export
     D SVPVAL_nacionalidad...
     D                 pi              n
     D   peCnac                       3  0 const

       SVPVAL_inz();

       setll peCnac gntnac;

       if not %equal ( gntnac );
         SetError( SVPVAL_NAINE
                 : 'Nacionalidad Inexistente' );
         return *Off;
       endif;

       return *On;

     P SVPVAL_nacionalidad...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVAL_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPVAL_inz      B                   export
     D SVPVAL_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set620);
         open set620;
       endif;

       if not %open(set621);
         open set621;
       endif;

       if not %open(gntmon);
         open gntmon;
       endif;

       if not %open(set901);
         open set901;
       endif;

       if not %open(gntiv1);
         open gntiv1;
       endif;

       if not %open(gntloc);
         open gntloc;
       endif;

       if not %open(set630w);
         open set630w;
       endif;

       if not %open(ctw000);
         open ctw000;
       endif;

       if not %open(ctw003);
         open ctw003;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(set100);
         open set100;
       endif;

       if not %open(set102);
         open set102;
       endif;

       if not %open(set102w);
         open set102w;
       endif;

       if not %open(set103);
         open set103;
       endif;

       if not %open(set160);
         open set160;
       endif;

       if not %open(set200);
         open set200;
       endif;

       if not %open(set204);
         open set204;
       endif;

       if not %open(set207);
         open set207;
       endif;

       if not %open(set239);
         open set239;
       endif;

       if not %open(set23901);
         open set23901;
       endif;

       if not %open(gntfpg);
         open gntfpg;
       endif;

       if not %open(gntfpg02);
         open gntfpg02;
       endif;

       if not %open(set22501);
         open set22501;
       endif;

       if not %open(settar);
         open settar;
       endif;

       if not %open(gnttdo);
         open gnttdo;
       endif;

       if not %open(gnhdaf05);
         open gnhdaf05;
       endif;

       if not %open(gnhdaf06);
         open gnhdaf06;
       endif;

       if not %open(sehase);
         open sehase;
       endif;

       if not %open(set104);
         open set104;
       endif;

       if not %open(set107);
         open set107;
       endif;

       if not %open(set106);
         open set106;
       endif;

       if not %open(set1031);
         open set1031;
       endif;

       if not %open(gntprf02);
         open gntprf02;
       endif;

       if not %open(gntsex02);
         open gntsex02;
       endif;

       if not %open(gntesc02);
         open gntesc02;
       endif;

       if not %open(gntrae02);
         open gntrae02;
       endif;

       if not %open(gntpai);
         open gntpai;
       endif;

       if not %open(gnttis);
         open gnttis;
       endif;

       if not %open(ctwet0);
         open ctwet0;
       endif;

       if not %open(gntemp);
         open gntemp;
       endif;

       if not %open(gntsuc);
         open gntsuc;
       endif;

       if not %open(gntpro);
         open gntpro;
       endif;

       if not %open(gnttce);
         open gnttce;
       endif;

       if not %open(gntnac);
         open gntnac;
       endif;

       if not %open(set63002);
         open set63002;
       endif;

       if not %open(sehni4c);
         open sehni4c;
       endif;

       if not %open(sehni2);
         open sehni2;
       endif;

       if not %open(set20493);
         open set20493;
       endif;

       if not %open(pahas1);
         open pahas1;
       endif;

       if not %open(cntnau01);
         open cntnau01;
       endif;

       if not %open(set101);
         open set101;
       endif;

       if not %open(set6261);
         open set6261;
       endif;

       if not %open(set101c);
         open set101c;
       endif;

       if not %open(set208);
         open set208;
       endif;

       if not %open(set215);
         open set215;
       endif;

       if not %open(set60802);
         open set60802;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPVAL_inz      E

      * ------------------------------------------------------------ *
      * SVPVAL_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPVAL_End      B                   export
     D SVPVAL_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPVAL_End      E

      * ------------------------------------------------------------ *
      * SVPVAL_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPVAL_Error    B                   export
     D SVPVAL_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPVAL_Error    E

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

      * --------------------------------------------------------------*
      * SVPVAL_articuloRenovacion(): Articulo Valido para Reno Autom  *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_articuloRenovacion...
     P                 b                   export
     D SVPVAL_articuloRenovacion...
     D                 pi              n
     D   peArcd                       6  0 const

       SVPVAL_inz();

       setll peArcd set63002;

       if not %equal ( set63002 );
         SetError( SVPVAL_ARNOR
                 : 'Articulo no Valido Para Renovacion Automatica' );
         return *Off;
       endif;

       return *On;

     P SVPVAL_articuloRenovacion...
     P                 E

      * ------------------------------------------------------------- *
      * SVPVAL_productorRenoAutomatica() Productor Habilitado         *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_productorRenoAutomatica...
     P                 b                   export
     D SVPVAL_productorRenoAutomatica...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D k1yni4          ds                  likeRec(s1hni4c:*key)

       SVPVAL_inz();

       return SVPVAL_productorRenoAutomatica2(peEmpr:
                                              peSucu:
                                              peNivt:
                                              PeNivc:
                                              0);

     P SVPVAL_productorRenoAutomatica...
     P                 E
      * ------------------------------------------------------------- *
      * SVPVAL_productorCbaMza() Productor de Cba o Mza               *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_productorCbaMza...
     P                 b                   export
     D SVPVAL_productorCbaMza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D @@copo          s              5  0
     D @@cops          s              1  0

     D k1yni2          ds                  likeRec(s1hni2:*key)
     D k1yloc          ds                  likeRec(g1tloc:*Key)

       SVPVAL_inz();

       k1yni2.n2empr = peEmpr;
       k1yni2.n2sucu = peSucu;
       k1yni2.n2nivt = peNivt;
       k1yni2.n2nivc = peNivc;

       chain %kds( k1yni2 ) sehni2;

       SVPDAF_getLocalidad ( n2nrdf : @@copo : @@cops );

       k1yloc.locopo = @@copo;
       k1yloc.locops = @@cops;

       chain %kds( k1yloc ) gntloc;

       if not %found or loproc = 'CBA' or loproc = 'MZA';
         SetError( SVPVAL_PCBMZ
                 : 'Productor Cba o Mza' );
         return *On;
       endif;

       return *Off;

     P SVPVAL_productorCbaMza...
     P                 E

      * ------------------------------------------------------------- *
      * SVPVAL_aseguradoCbaMza() Asegurado de Cba o Mza               *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNrdf   (input)   Numero de Asegurado                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_aseguradoCbaMza...
     P                 b                   export
     D SVPVAL_aseguradoCbaMza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNrdf                       7  0 const

     D @@copo          s              5  0
     D @@cops          s              1  0

     D k1yloc          ds                  likeRec(g1tloc:*Key)

       SVPVAL_inz();

       SVPDAF_getLocalidad ( peNrdf : @@copo : @@cops );

       k1yloc.locopo = @@copo;
       k1yloc.locops = @@cops;

       chain %kds( k1yloc ) gntloc;

       if not %found or loproc = 'CBA' or loproc = 'MZA';
         SetError( SVPVAL_ACBMZ
                 : 'Asegurado Cba o Mza' );
         return *On;
       endif;

       return *Off;

     P SVPVAL_aseguradoCbaMza...
     P                 E

      * ------------------------------------------------------------- *
      * SVPVAL_productorBloqueado(): Productor Bloqueado para Operacion
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *     peTiou   (input)   Tipo de Operacion                      *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_productorBloqueado...
     P                 b                   export
     D SVPVAL_productorBloqueado...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peTiou                       1  0 const

     D k1yni2          ds                  likeRec(s1hni2:*key)

       SVPVAL_inz();

       k1yni2.n2empr = peEmpr;
       k1yni2.n2sucu = peSucu;
       k1yni2.n2nivt = peNivt;
       k1yni2.n2nivc = peNivc;

       chain %kds( k1yni2 ) sehni2;

       if %int( n2bloq ) >= peTiou;

         SetError( SVPVAL_PRBLO
                 : 'Productor Bloqueado Para Operacion');
         return *On;

       endif;

       return *Off;

     P SVPVAL_productorBloqueado...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_codigoDeAjuste(): Codigo de Ajuste Articulo            *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_codigoDeAjuste...
     P                 b                   export
     D SVPVAL_codigoDeAjuste...
     D                 pi              n
     D   peArcd                       6  0 const

       SVPVAL_inz();

       chain peArcd set63002;

       select;
         when t@3mar2 = 'C' or t@3mar2 = 'X';
         when t@3mar2 = 'I' or t@3mar2 = 'R';
         when t@3mar2 = 'T' or t@3mar2 = 'Y';
         other;
           return *Off;
       endsl;

       return *On;

     P SVPVAL_codigoDeAjuste...
     P                 E

      * --------------------------------------------------------------*
      * SVPVAL_chkPlanCerrado(): Verifica si Plan es Cerrado          *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peXpro   (input)   Plan                                   *
      *     peMone   (input)   Moneda                                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkPlanCerrado...
     P                 b                   export
     D SVPVAL_chkPlanCerrado...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peMone                       2    const

     D   k1y100        ds                  likerec( s1t100 : *key )

       SVPVAL_inz();

       k1y100.t@rama = peRama;
       k1y100.t@xpro = peXpro;
       k1y100.t@mone = peMone;
       chain %kds( k1y100 ) set100;
       if %found( set100 );
         if t@prem <> *zeros;
           return *on;
         endif;
       endif;

       return *off;

     P SVPVAL_chkPlanCerrado...
     P                 E
      * --------------------------------------------------------------*
      * SVPVAL_chkInfoAutoWeb(): Verifica si Marca/Modelo es WEB      *
      *                                                               *
      *     peCmar   (input)   Marca Infoauto                         *
      *     peCmod   (input)   Modelo infoauto                        *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkInfoAutoWeb...
     P                 b                   export
     D SVPVAL_chkInfoAutoWeb...
     D                 pi              n
     D   peCmar                       9  0 const
     D   peCmod                       9  0 const

     D   @@cant        s             10i 0
     D   k1y204        ds                  likerec( s1t20493 : *key )
      /free
       SVPVAL_inz();

       // Marca/Modelo Infoauto en Gaus...
       k1y204.s4_t@cma1 = peCmar;
       k1y204.s4_t@cmo1 = peCmod;
       setll %kds( k1y204 : 2) set20493;
       if not %equal( set20493 );
         SetError( SVPVAL_IANOE
                 : 'Codigo InfoAuto no se encuentra asociado a un Vehiculo +
                  Gaus ');
         return *off;
       endif;
       reade %kds( k1y204 ) set20493;
         dow not %eof( set20493 );
           if s4_t@mar1 = 'I';
             @@cant+=1;
           endif;
          reade %kds( k1y204 ) set20493;
         enddo;

         if @@cant = 0;
         SetError( SVPVAL_IANOE
                 : 'Codigo de Infoauto no se encuentra Habilitado para la   +
                  WEB ');
           return *off;
         endif;
         if @@cant > 1;
         SetError( SVPVAL_IANOE
                 : 'Existen mas de un Vehiculo habilitado para la WEB +
                  asociado a un mismo InfoAuto');
          return *off;
         endif;

         return *on;

      /end-free
     P SVPVAL_chkInfoAutoWeb...
     P                 e

      * --------------------------------------------------------------*
      * SVPVAL_chkClienteIntegral(): Valia si el Cliente es Integral  *
      *                                                               *
      *     peCodi   (input)   Codigo                                 *
      *     peAsen   (input)   Nro de Asegurado                       *
      *     peFech   (input)   Fecha de Vigencia                      *
      *     peFpgm   (input)   Fin de PGM                             *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_chkClienteIntegral...
     P                 b                   export
     D SVPVAL_chkClienteIntegral...
     D                 pi              n
     D   peCodi                       3
     D   peAsen                       7  0
     D   peFech                       8  0
     D   peFpgm                       3    options( *omit : *nopass )

     D   @@reto        s               n
     D   @@fpgm        s              3
      /free

       SVPVAL_inz();
       clear @@fpgm;
       if %parms >= 4 and %addr(peFpgm)<> *NULL;
         @@fpgm = peFpgm;
       endif;

       spcliint( peCodi
               : peAsen
               : peFech
               : @@reto
               : @@fpgm  );

        return @@reto;

      /end-free
     P SVPVAL_chkClienteIntegral...
     P                 e

      * ------------------------------------------------------------ *
      * SVPVAL_chkProductorAsegurado: Verifica que el productor se   *
      *             encuentre habilitado a operar con el asegurado.- *
      *                                                              *
      *     peNivt   (input)   Tipo Nivel Intermediario              *
      *     peNivc   (input)   Codigo Nivel Intermediario            *
      *     peTido   (input)   Tipo de Documento ( opcional )        *
      *     peNrdo   (input)   Nro de Documento  ( opcional )        *
      *     peCuit   (input)   Nro CUIT          ( opcional )        *
      *                                                              *
      * Retorna: *on = Si habilitado / *off = Si no esta habilitado  *
      * ------------------------------------------------------------ *
     P SVPVAL_chkProductorAsegurado...
     P                 B                   export
     D SVPVAL_chkProductorAsegurado...
     D                 pi              n
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)
     D   peCuit                      11    options(*nopass:*omit)

     d   @@Flag        s               n
     d   @@Iidx        s              3  0
     d   @@Tido        s              2  0
     d   @@Nrdo        s              8  0
     d   @@Cuit        s             11
     d   @@Nrdf        s              7  0 dim( 100 )
     d   @@NrdfC       s             10i 0
     d   @@Nivt        s              1  0
     d   @@Nivc        s              5  0
     d   @CNivt        s              1  0
     d   @CNivc        s              5  0
     d   @@Cade        s              5  0 dim(9)

      /free

       SVPVAL_inz();
       @@Flag = *Off;
       clear @@Nrdf;
       clear @@NrdfC;

       Select;
       When %parms >= 3 and %addr( peTido ) <> *null
                        and %addr( peNrdo ) <> *null;
         @@Tido = peTido;
         @@Nrdo = peNrdo;
         @@Flag = SVPDAF_getListaAseguradoxDoc(
                          @@Tido
                        : @@Nrdo
                        : @@Nrdf
                        : @@NrdfC
                  );

       When %parms >= 3 and %addr( peCuit ) <> *null;
         @@Cuit = peCuit;
         @@Flag = SVPDAF_getListaAseguradoxCuit(
                          @@Cuit
                        : @@Nrdf
                        : @@NrdfC
                  );

       endsl;

       for @@Iidx = 1 to @@NrdfC;
         clear @@Nivt;
         clear @@Nivc;
         clear @@Cade;
         clear @CNivt;
         clear @CNivc;

         if SVPASE_getProductorAsegurado( @@Nrdf(@@Iidx) :
                                          @@Nivt :
                                          @@Nivc );
           SVPINT_GetCadena( 'A'
                           : 'CA'
                           : @@Nivt
                           : @@Nivc
                           : @@Cade );

           @CNivt = 9;
           @CNivc = @@cade(9);

           if @CNivt <> peNivt or @CNivc <> peNivc;
             SetError( SVPVAL_PNASA :
                   'Codigo de Productor no se encuentra asociado al asegurado'
             );
             return *off;
           endif;
         endif;
       endfor;
       return *on;

      /end-free
     P SVPVAL_chkProductorAsegurado...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVAL_chkAseguradoProdAs1: Verifica que el asegurado se     *
      *           encuentre relacionado con el productor leer Pahas1 *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Codigo de Sucursal                    *
      *     peNivt   (input)   Tipo Nivel Intermediario              *
      *     peNivc   (input)   Código Nivel Intermediario            *
      *     peAsen   (input)   Número de Asegurado                   *
      *                                                              *
      * Retorna: *on = Relacionado   / *off = No esta relacionado    *
      * ------------------------------------------------------------ *
     P SVPVAL_chkAseguradoProdAs1...
     P                 B                   export
     D SVPVAL_chkAseguradoProdAs1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peAsen                       7  0 const

     D k1yas1          ds                  likerec( p1has1 : *key )

      /Free

       SVPVAL_inz();

       k1yas1.asEmpr = peEmpr;
       k1yas1.asSucu = peSucu;
       k1yas1.asNivt = peNivt;
       k1yas1.asNivc = peNivc;
       k1yas1.asAsen = peAsen;
       chain %kds( k1yas1 : 5 ) pahas1;
       if %found( pahas1 );
         return *on;
       endif;

       return *off;

      /end-free
     P SVPVAL_chkAseguradoProdAs1...
     P                 E

      * ------------------------------------------------------------------ *
      * SVPVAL_chkTipoDocHabWeb(): Chequea que el tipo de documento este   *
      *                            habilitado para la web                  *
      *                                                                    *
      *     peTido ( input )  Tipo de Documento                            *
      *                                                                    *
      * Retorna *on = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     P SVPVAL_chkTipoDocHabWeb...
     P                 B                    export
     D SVPVAL_chkTipoDocHabWeb...
     D                 pi              n
     D   peTido                       2  0 const

      /free

       SVPVAL_inz();

       chain peTido gnttdo;
       if %found( gnttdo );

         if gnmweb = '1';
           return *on;
         endif;

       endif;

       return *off;

      /end-free

     P SVPVAL_chkTipoDocHabWeb...
     P                 E

      * ------------------------------------------------------------------ *
      * SVPVAL_chkCodIvaHabWeb(): Chequea que el Código de IVA este habi-  *
      *                           litado para la Web                       *
      *                                                                    *
      *     peCiva ( input )  Código IVA                                   *
      *                                                                    *
      * Retorna *on = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     P SVPVAL_chkCodIvaHabWeb...
     P                 B                    export
     D SVPVAL_chkCodIvaHabWeb...
     D                 pi              n
     D   peCiva                       2  0 const

      /free

       SVPVAL_inz();

       chain peCiva gntiv1;
       if %found( gntiv1 );

         if i1mweb = '1';
           return *on;
         endif;

       endif;

       return *off;

      /end-free

     P SVPVAL_chkCodIvaHabWeb...
     P                 E

      * ------------------------------------------------------------------ *
      * SVPVAL_chkEdadVida(): Chequea Edad Minima y Maxima de Vida.        *
      *                                                                    *
      *     peArcd ( input  ) Código de Articulo                           *
      *     peRama ( input  ) Código de Rama                               *
      *     peArse ( input  ) Cant. Pólizas por Rama/Art                   *
      *     peXpro ( input  ) Código de Producto                           *
      *     peEdad ( input  ) Edad del Asegurado                           *
      *                                                                    *
      * Retorna *on = Permitida  / *off = No Permitida                     *
      * ------------------------------------------------------------------ *
     P SVPVAL_chkEdadVida...
     P                 B                    export
     D SVPVAL_chkEdadVida...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       3  0 const
     D   peEdad                       2  0 const

     D rc              s               n
     D @@Edma          s              2  0
     D @@Edmi          s              2  0
     D @@Msg           s            100

      /free

       SVPVAL_inz();

       clear @@Edmi;
       clear @@Edma;

       rc = SVPVID_getEdadMinimaDeVida( peArcd : peRama :peArse : peXpro :
                                        @@Edmi );

       rc = SVPVID_getEdadMaximaDeVida( peArcd : peRama :peArse : peXpro :
                                        @@Edma );

       if peEdad > @@Edma or peEdad < @@Edmi;
         @@Msg = 'Edad fuera de los rangos '
               + %editc( @@Edmi : 'X' )
               + ' y '
               + %editc( @@Edma : 'X' )
               + ' permitidos.';

         SetError( SVPVAL_EDNOP : %trim(@@Msg) );
         return *off;
       endif;

       return *on;

      /end-free

     P SVPVAL_chkEdadVida...
     P                 E

      * ------------------------------------------------------------------ *
      * SVPVAL_chkPlanesHabilWeb(): Chequea si hay planes habilitados para *
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
     P SVPVAL_chkPlanesHabilWeb...
     P                 B                    export
     D SVPVAL_chkPlanesHabilWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)

     D   @@DsR9        ds                  likeds( dsPaher9_t ) dim( 999 )
     D   @@DsR9C       s             10i 0
     D   @@DsR0        ds                  likeds( dsPaher0_t ) dim( 999 )
     D   @@DsR0C       s             10i 0
     D   k1y02w        ds                  likerec( s1t102w : *key )

     D  Habilitado     s               n
     D  @@Fech         s              8  0
     D  @@Year         s              4  0
     D  @@Month        s              2  0
     D  @@Day          s              2  0
     D  rc             s               n
     D  x              s             10i 0

      /free

       SVPVAL_inz();

       Habilitado = *off;
       clear @@DsR9;
       clear @@DsR9C;

       PAR310X3( peEmpr : @@Year : @@Month : @@Day);
       @@Fech = (@@Year * 10000)
              + (@@Month *  100)
              +  @@Day;

       select;
         when %parms >= 6 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) =  *NULL
                          and %addr( pePoco ) =  *NULL;

           rc = SVPRIV_getComponentes( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peRama
                                     : peArse
                                     : *omit
                                     : *omit
                                     : @@DsR9
                                     : @@DsR9C );

         when %parms >= 7 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) =  *NULL;

           rc =  SVPRIV_getComponentes( peEmpr
                                      : peSucu
                                      : peArcd
                                      : peSpol
                                      : peRama
                                      : peArse
                                      : peOper
                                      : *omit
                                      : @@DsR9
                                      : @@DsR9C );

         when %parms >= 8 and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) <> *NULL;

           rc =  SVPRIV_getComponentes( peEmpr
                                      : peSucu
                                      : peArcd
                                      : peSpol
                                      : peRama
                                      : peArse
                                      : peOper
                                      : pePoco
                                      : @@DsR9
                                      : @@DsR9C );

         other;

           rc = SVPRIV_getComponentes( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peRama
                                     : *omit
                                     : *omit
                                     : *omit
                                     : @@DsR9
                                     : @@DsR9C );


       endsl;

       for x = 1 to @@DsR9C;
         if @@DsR9(x).r9strg = '0';
           clear @@DsR0;
           clear @@DsR0C;
           if SVPRIV_getSuplementos( @@DsR9(x).r9Empr
                                   : @@DsR9(x).r9Sucu
                                   : @@DsR9(x).r9Arcd
                                   : @@DsR9(x).r9Spol
                                   : @@DsR9(x).r9Sspo
                                   : @@DsR9(x).r9Rama
                                   : @@DsR9(x).r9Arse
                                   : @@DsR9(x).r9Oper
                                   : @@DsR9(x).r9Poco
                                   : *omit
                                   : @@DsR0
                                   : @@DsR0C          );

             k1y02w.t@Rama = @@DsR0(@@DsR0C).r0Rama;
             k1y02w.t@Xpro = @@DsR0(@@DsR0C).r0Xpro;
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
       endfor;

       if Habilitado;
         return *on;
       else;
         return *off;
       endif;

      /end-free

     P SVPVAL_chkPlanesHabilWeb...
     P                 E

      * ------------------------------------------------------------- *
      * SVPVAL_productorRenoAutomatica2() Productor Habilitado        *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *     peRama   (input)   Rama                                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_productorRenoAutomatica2...
     P                 b                   export
     D SVPVAL_productorRenoAutomatica2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 const

     D k1yni4          ds                  likeRec(s1hni4c:*key)

       SVPVAL_inz();

       k1yni4.s1empr = peEmpr;
       k1yni4.s1sucu = peSucu;
       k1yni4.s1nivt = peNivt;
       k1yni4.s1nivc = peNivc;
       k1yni4.s1rama = peRama;

       setll %kds( k1yni4 ) sehni4c;

       if %equal ( sehni4c );
         SetError( SVPVAL_PRNOR
                 : 'Productor no Valido Para Renovacion Automatica' );
         return *Off;
       endif;

       return *On;

     P SVPVAL_productorRenoAutomatica2...
     P                 E

      * ------------------------------------------------------------- *
      * SVPVAL_chkMayorAuxiliar(): Chequea Mayor Auxiliar             *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peComa   (input)   Cod. Mayor Auxiliar                    *
      *     peNrma   (input)   Nro. Mayor Auxiliar                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_chkMayorAuxiliar...
     P                 b                   export
     D SVPVAL_chkMayorAuxiliar...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const

     D k1ynau          ds                  likerec( c1tnau01 : *key )

       SVPVAL_inz();

       k1ynau.naEmpr = peEmpr;
       k1ynau.naSucu = peSucu;
       k1ynau.naComa = peComa;
       k1ynau.naNrma = peNrma;
       chain(n) %kds( k1ynau : 4 ) cntnau01;
       if not %found( cntnau01 );
         SetError( SVPVAL_MAYAX
                 : 'Mayor Auxiliar no existe' );
         return *Off;
       endif;

       return *On;

     P SVPVAL_chkMayorAuxiliar...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVAL_monedaV2(): Validar Moneda.                           *
      *                                                              *
      *     peComo   (input)   Código de Moneda                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVAL_monedaV2...
     P                 B                   export
     D SVPVAL_monedaV2...
     D                 pi              n
     D   peComo                       2    const
     D
     D k1yMon          ds                  likerec(g1tmon:*key)
     D

      /free

       SVPVAL_inz();

       k1ymon.mocomo = peComo;

       chain(n) %kds( k1ymon ) gntmon;
       if not %found( gntmon );

         SetError( SVPVAL_MONNE
                 : 'Moneda Inexistente' );
         return *Off;

       else;

         if mobloq = '1';

           SetError( SVPVAL_MONBL
                   : 'Moneda Bloqueada' );
           return *Off;

         endif;

         if momoeq <> 'AU';

           SetError( SVPVAL_MONLC
                   : 'Moneda Local, No Tiene Cotizacion' );
           return *Off;

         endif;

       endif;

       return *On;

      /end-free

     P SVPVAL_monedaV2...
     P                 E

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifa(): Chequea Capitulo de Tarifa        *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_chkCapituloTarifa...
     P                 b                   export
     D SVPVAL_chkCapituloTarifa...
     D                 pi              n
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const

     D k1t101          ds                  likerec(s1t101 : *key )

       SVPVAL_inz();

       k1t101.t1rama = peRama;
       k1t101.t1ctar = pectar;
       k1t101.t1cta1 = pecta1;
       k1t101.t1cta2 = pecta2;
       setll %kds( k1t101 : 4 ) set101;
       if not %equal;
         SetError( SVPVAL_CTANE
                 : 'Capitulo de Tarifa no existe.');
         return *Off;
       endif;

       return *On;

     P SVPVAL_chkCapituloTarifa...
     P                 e

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifaArticulo(): Chequea Relacion entre    *
      *                    Capitulo de Tarifa y Articulo              *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   Secuencia de Rama en articulo          *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_chkCapituloTarifaArticulo...
     P                 b                   export
     D SVPVAL_chkCapituloTarifaArticulo...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const

     D k1t626          ds                  likerec(s1t6261:*key)

       SVPVAL_inz();

       k1t626.t@arcd = peArcd;
       k1t626.t@rama = peRama;
       k1t626.t@arse = peArse;
       k1t626.t@ctar = peCtar;
       k1t626.t@cta1 = peCta1;
       k1t626.t@cta2 = peCta2;
       setll %kds( k1t626 : 6 ) set6261;
       if not %equal;
         SetError( SVPVAL_CTAAR
                 : 'Capitulo de Tarifa no relacionado al articulo.');
         return *Off;
       endif;

       return *On;

     P SVPVAL_chkCapituloTarifaArticulo...
     P                 e

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifaPlan(): Chequea relacion entre Capitu-*
      *                    lo de Tarifa y Plan.                       *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *     peXpro   (input)   Codigo de Plan/Producto                *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_chkCapituloTarifaPlan...
     P                 b                   export
     D SVPVAL_chkCapituloTarifaPlan...
     D                 pi              n
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const
     D   peXpro                       3  0 const

     D k1t101          ds                  likerec(s1t101c:*key)

       SVPVAL_inz();

       k1t101.t2rama = peRama;
       k1t101.t2ctar = pectar;
       k1t101.t2cta1 = pecta1;
       k1t101.t2cta2 = pecta2;
       k1t101.t2xpro = peXpro;
       setll %kds( k1t101 : 5 ) set101c;
       if not %equal;
         SetError( SVPVAL_CTAPR
                 : 'Capitulo de Tarifa no relacionado al plan.');
         return *Off;
       endif;

       return *On;

     P SVPVAL_chkCapituloTarifaPlan...
     P                 e

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifaWeb(): Chequea Capitulo de Tarifa web *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_chkCapituloTarifaWeb...
     P                 b                   export
     D SVPVAL_chkCapituloTarifaWeb...
     D                 pi              n
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const

     D k1t101          ds                  likerec(s1t101 : *key )

       SVPVAL_inz();

       if SVPVAL_chkCapituloTarifa( peRama
                                  : peCtar
                                  : peCta1
                                  : peCta2 ) = *off;
          return *off;
       endif;

       k1t101.t1rama = peRama;
       k1t101.t1ctar = pectar;
       k1t101.t1cta1 = pecta1;
       k1t101.t1cta2 = pecta2;
       chain %kds( k1t101 : 4 ) set101;
       if %found;
          if t1mweb <> '1';
             SetError( SVPVAL_CTANW
                     : 'Capitulo de Tarifa no habilitado para web.');
             return *Off;
          endif;
       endif;

       return *On;

     P SVPVAL_chkCapituloTarifaWeb...
     P                 e

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloVariante(): Chequea Capitulo/Variante de    *
      *                               autos.                          *
      *                                                               *
      *     peVhca   (input)   Capitulo                               *
      *     peVhv1   (input)   Variante RC                            *
      *     peVhv2   (input)   Variante AIR                           *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_chkCapituloVariante...
     P                 b                   export
     D SVPVAL_chkCapituloVariante...
     D                 pi              n
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const

       SVPVAL_inz();

       setll (peVhca:peVhv1:peVhv2) set215;
       if not %equal;
          SetError( SVPVAL_CVANE
                  : 'Capitulo/Variante Autos no existe.');
          return *Off;
       endif;

       return *On;

     P                 e

      * ------------------------------------------------------------- *
      * SVPVAL_chkTarifaDiferencial():Chequea marca de tarifa diferen-*
      *                               cial de autos.                  *
      *                                                               *
      *     peMtdf   (input)   Marca de Tarifa Diferencial            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     P SVPVAL_chkTarifaDiferencial...
     P                 b                   export
     D SVPVAL_chkTarifaDiferencial...
     D                 pi              n
     D   peMtdf                       1a   const

       SVPVAL_inz();

       setll peMtdf set208;
       if not %equal;
          SetError( SVPVAL_MTDNE
                  : 'Marca Tarifa Diferencial no existe.');
          return *Off;
       endif;

       return *On;

     P                 e

      * --------------------------------------------------------------*
      * SVPVAL_productoWeb(): Valida el Producto en la Web            *
      *                                                               *
      *     peRama   (input)   Código Rama                            *
      *     peXpro   (input)   Código Producto                        *
      *     peFech   (input)   Fecha                                  *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_productoWeb...
     P                 B                   export
     D SVPVAL_productoWeb...
     D                 pi              n
     D
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)
     D
     D k1y102          ds                  likerec(s1t102w:*key)

     D  @@mar          s               n
     D  @@fech         s              8  0

      /free

       SVPVAL_inz();

       @@mar = '';
       if peFech <> *zeros;
          @@fech = peFech;
       else;
          @@fech = %dec(%date():*iso);
       endif;

       k1y102.t@rama = peRama;
       k1y102.t@xpro = peXpro;

       setll %kds( k1y102 : 2 ) set102w;
       reade %kds( k1y102 : 2 ) set102w;
       dow not %eof( set102w );

           if t@date <= @@fech;
              @@mar = t@mp01;
           endif;

           reade %kds( k1y102 : 2 ) set102w;

       enddo;

       if @@mar <> 'S';
          SetError( SVPVAL_PRONW
                  : 'Producto no Incluye Web');
          return *Off;
       endif;

       return *On;

      /end-free

     P SVPVAL_productoWeb...
     P                 E

      * --------------------------------------------------------------*
      * SVPVAL_planDePagoWeb(): Valida el Plan de Pago Web            *
      *                                                               *
      *     peArcd   (input)   Código Articulo                        *
      *     peCfpg   (input)   Código Forma de Pago                   *
      *     peNrpp   (input)   Numero de Plan de Pago                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPVAL_planDePagoWeb...
     P                 B                   export
     D SVPVAL_planDePagoWeb...
     D                 pi              n
     D
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const
     D   peNrpp                       3  0 const
     D
     D k1t608          ds                  likerec(s1t608:*key)


      /free

       SVPVAL_inz();

       k1t608.t@arcd = peArcd;
       k1t608.t@cfpg = peCfpg;
       k1t608.t@nrpp = peNrpp;

       setll %kds( k1t608 ) set60802;
       reade %kds( k1t608 ) set60802;
       if not %equal;

          return *Off;

       endif;


       return *On;

      /end-free

     P SVPVAL_planDePagoWeb...
     P                 E


