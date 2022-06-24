     H nomain
     H datfmt(*ymd)
      * *************************************************************** *
      * SVPWEB: Programa de Servicio.                                   *
      *         Tabla de Parametros                                     *
      * --------------------------------------------------------------- *
      * JORGE GRONDA- Norberto Franqueira    16-Jun-2015                *
      * *************************************************************** *
      * Modificaciones:                                                 *
      * Gio Nicolini 07 12 2017 Habilita Marca T@MAR2 para indicar Tipo *
      *                         de Calculo de la Fecha-Hasta en cotizac *
      *                         Agrega Nuevos Procedimientos:           *
      *                         - SVPWEB_getParametrosWeb               *
      *                         - SVPWEB_getCalculoFechaHasta           *
      * Gio Nicolini 14 12 2017 -Habilita Marca T@MAR3 para Convertir   *
      *                          Articulo en emision                    *
      *                         -Incluye Campo Tope Vigenc Hasta T@TVHA *
      *                         Agrega Nuevos Procedimientos:           *
      *                        - SVPWEB_getTopeVigenciaHasta            *
      *                        - SVPWEB_getConvertirArticuloRamaEmision *
      * NWN NWN - 01/10/2018  - Agregado de Archivo SET102W             *
      * NWN NWN - 28/11/2019  - Agregado de SVPWEB_chkPar.              *
      * JSN JSN - 14/04/2021  - Recompilación del programa por los      *
      *                         campos nuevos en el setweb Show, Path y *
      *                         link, se agrega los procedimientos:     *
      *                         _setParametrosWeb                       *
      *                         _getParametrosWeb2                      *
      * JSN JSN - 27/04/2021  - Recompilación                           *
      * *************************************************************** *
     Fsetweb    if a e           k disk    usropn
     Fset620    if   e           k disk    usropn
     Fset102w   if   e           k disk    usropn prefix(t2:2)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/SVPWEB_h.rpgle'

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
      * Void
      * --------------------------------------------------- *
     D getSec          pr             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0 const

      *--- PR Externos --------------------------------------------- *

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPWEB_chkArt(): Chequea Codigo de Articulo                  *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWEB_chkArt...
     P                 B                   export
     D SVPWEB_chkArt...
     D                 pi              n
     D   peArcd                       6  0 const

     D k1yweb          ds                  likerec(s1tweb:*key)

      /free

       SVPWEB_inz();

       setll (peArcd) set620;

       if %equal(set620);
         return *On;
       else;
         SetError( SVPWEB_ARTIN
                 : 'Codigo de Articulo Inexistente' );
         return *Off;
       endif;

      /end-free

     P SVPWEB_chkArt...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWEB_getDescArt(): Retorna Descripcion Codigo de Articulo  *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *                                                              *
      * Retorna: Descripcion / Blanco en caso de error               *
      * ------------------------------------------------------------ *

     P SVPWEB_getDescArt...
     P                 B                   export
     D SVPWEB_getDescArt...
     D                 pi            30
     D   peArcd                       6  0 const

     D k1y620          ds                  likerec(s1t620:*key)

      /free

       SVPWEB_inz();

       k1y620.t@arcd = peArcd;

       chain %kds(k1y620:1) set620;
       if not %found(set620);
         clear t@arno;
       endif;

       return t@arno;

      /end-free

     P SVPWEB_getDescArt...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWEB_setPar(): Graba Parametros                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peFech   (input)   Fecha                                 *
      *     peSecu   (input)   Secuencia                             *
      *     peUemi   (input)   Unidad para Fecha Emision             *
      *     peCemi   (input)   Cantidad para Fecha Emision           *
      *     peSald   (input)   Saldo Maximo                          *
      *     peUpas   (input)   Unidad para Pago Siniestros           *
      *     peCpas   (input)   Cantidad Pago Siniestros              *
      *     peUdes   (input)   Unidad Denuncia Siniestros            *
      *     peCdes   (input)   Cantidad Denuncia Siniestros          *
      *     peTvha   (input)   Tope Vigencia Hasta                   *
      *     peMar1   (input)   Marca Proceso 1                       *
      *     peMar2   (input)   Marca Proceso 2                       *
      *     peMar3   (input)   Marca Proceso 3                       *
      *     peMar4   (input)   Marca Proceso 4                       *
      *     peMar5   (input)   Marca Proceso 5                       *
      *     peRams   (input)   Convertir desde Rama                  *
      *     peArcc   (input)   Convertir hacia Articulo              *
      *     peRamc   (input)   Convertir hacia Rama                  *
      *     peUser   (input)   Usuario Proceso                       *
      *     peDate   (input)   Fecha  Proceso                        *
      *     peTime   (input)   Hora Proceso                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWEB_setPar...
     P                 B                   export
     D SVPWEB_setPar...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0 const
     D   peUemi                       1    const
     D   peCemi                       5  0 const
     D   peSald                      15  2 const
     D   peUpas                       1    const
     D   pecpas                       5  0 const
     D   peUdes                       1    const
     D   peCdes                       5  0 const
     D   peTvha                       3  0 const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peMar5                       1    const
     D   peRams                       2  0 const
     D   peArcc                       6  0 const
     D   peRamc                       2  0 const
     D   peUser                      10    const
     D   peDate                       6  0 const
     D   peTime                       6  0 const

      /free

       SVPWEB_inz();

       t@empr = peEmpr;
       t@sucu = peSucu;
       t@arcd = peArcd;
       t@fech = peFech;
       t@secu = getSec(peEmpr:
                       peSucu:
                       peArcd:
                       peFech);
       t@uemi = peUemi;
       t@cemi = peCemi;
       t@sald = peSald;
       t@upas = peUpas;
       t@cpas = peCpas;
       t@udes = peUdes;
       t@cdes = peCdes;
       t@tvha = peTvha;
       t@mar1 = peMar1;
       t@mar2 = peMar2;
       t@mar3 = peMar3;
       t@mar4 = peMar4;
       t@mar5 = peMar5;
       t@rams = peRams;
       t@arcc = peArcc;
       t@ramc = peRamc;
       t@user = peUser;
       t@date = peDate;
       t@time = peTime;

       write(e) s1tweb;

       if not %error;
          return *On;
       else;
          return *Off;
       endif;

      /end-free

     P SVPWEB_setPar...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWEB_getPar(): Recupera  Parametros                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWEB_getPar...
     P                 B                   export
     D SVPWEB_getPar...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0
     D   pSecu                        5  0
     D   pUemi                        1
     D   pCemi                        5  0
     D   pSald                       15  2
     D   pUpas                        1
     D   pcpas                        5  0
     D   pUdes                        1
     D   pCdes                        5  0
     D   pTvha                        3  0
     D   pMar1                        1
     D   pMar2                        1
     D   pMar3                        1
     D   pMar4                        1
     D   pMar5                        1
     D   pRams                        2  0
     D   pArcc                        6  0
     D   pRamc                        2  0
     D   pUser                       10
     D   pDate                        6  0
     D   pTime                        6  0

     D k1yweb          ds                  likerec(s1tweb:*key)

      /free

       SVPWEB_inz();

       k1yweb.t@empr = peEmpr;
       k1yweb.t@sucu = peSucu;
       k1yweb.t@arcd = peArcd;
       k1yweb.t@fech = peFech;

       setgt  %kds( k1yweb : 4 ) setweb;
       readpe %kds( k1yweb : 3 ) setweb;

       if not %eof( setweb );

       peFech = t@fech;
       pSecu = t@secu;
       pUemi = t@uemi;
       pCemi = t@cemi;
       pSald = t@sald;
       pUpas = t@upas;
       pCpas = t@cpas;
       pUdes = t@udes;
       pCdes = t@cdes;
       pTvha = t@tvha;
       pMar1 = t@mar1;
       pMar2 = t@mar2;
       pMar3 = t@mar3;
       pMar4 = t@mar4;
       pMar5 = t@mar5;
       pRams = t@rams;
       pArcc = t@arcc;
       pRamc = t@ramc;
       pUser = t@user;
       pDate = t@date;
       pTime = t@time;

       return *On;

       else;

       return *Off;

       endif;

      /end-free

     P SVPWEB_getPar...
     P                 E


      * ------------------------------------------------------------ *
      * SVPWEB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPWEB_inz      B                   export
     D SVPWEB_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(setweb);
         open setweb;
       endif;

       if not %open(set620);
         open set620;
       endif;

       if not %open(set102w);
         open set102w;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPWEB_inz      E

      * ------------------------------------------------------------ *
      * SVPWEB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPWEB_End      B                   export
     D SVPWEB_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPWEB_End      E

      * ------------------------------------------------------------ *
      * SVPWEB_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPWEB_Error    B                   export
     D SVPWEB_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPWEB_Error    E

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
      * getSec(): Obtiene Secuencia de nuevo registro                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Secuencia                                           *
      * ------------------------------------------------------------ *

     P getSec          B                   export
     D getSec          pi             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0 const

     D k1yweb          ds                  likerec(s1tweb:*key)

      /free

       k1yweb.t@empr = peEmpr;
       k1yweb.t@sucu = peSucu;
       k1yweb.t@arcd = peArcd;
       k1yweb.t@fech = peFech;


       setgt  %kds(k1yweb:4) setweb;
       readpe %kds(k1yweb:4) setweb;

       if %eof(setweb);
         return 1;
       else;
         return t@secu + 1;
       endif;

      /end-free

     P getSec...
     P                 E
      * ------------------------------------------------------------ *
      * SVPWEB_getParametrosWeb: Obtiene informacion para el proceso *
      *                          Web del tipo de Articulo.-          *
      *                                                              *
      *  ****DEPRECATED****    usar _getParametrosWeb2               *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peDsPweb (output)  Estructura Parametros Web             *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPWEB_getParametrosWeb...
     P                 B                   export
     D SVPWEB_getParametrosWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peDsPweb                          likeds( dsParamWeb_t )

     D   k1yweb        ds                  likerec( s1tweb : *key )
     D   dsIweb        ds                  likerec( s1tweb : *input)

      /free

       SVPWEB_inz();

       clear peDsPweb;

       if SVPWEB_getParametrosWeb2( peEmpr
                                  : peSucu
                                  : peArcd
                                  : *omit
                                  : peDsPweb );

         return *on;
       endif;

       return *off;

      /end-free
     P SVPWEB_getParametrosWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SVPWEB_getCalculoFechaHasta: Obtiene la forma de calculo     *
      *          de la Fecha Hasta para el tipo de Articulo.-        *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *                                                              *
      * Retorna: *on = Si calculo automatico / *off = Si no autom.   *
      * ------------------------------------------------------------ *
     P SVPWEB_getCalculoFechaHasta...
     P                 B                   export
     D SVPWEB_getCalculoFechaHasta...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const

     D   @@DsPweb      ds                  likeds( dsParamWeb_t )

      /free

       SVPWEB_inz();

       clear @@DsPweb;
       if SVPWEB_getParametrosWeb( peEmpr : peSucu : peArcd : @@DsPweb );
         return @@DsPweb.t@mar2;
       endif;

       return *Off;

      /end-free
     P SVPWEB_getCalculoFechaHasta...
     P                 E
      * ------------------------------------------------------------ *
      * SVPWEB_getTopeVigenciaHasta: Obtiene la cantidad de dias     *
      *                         del tope de vigencia en la emision.- *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peTvha   (output)  Tope Vigencia Hasta                   *
      *                                                              *
      * Retorna: *on = Si obtiene valor / *off = Si error            *
      * ------------------------------------------------------------ *
     P SVPWEB_getTopeVigenciaHasta...
     P                 B                   export
     D SVPWEB_getTopeVigenciaHasta...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peTvha                       3  0

     D   @@DsPweb      ds                  likeds( dsParamWeb_t )

      /free

       SVPWEB_inz();

       clear @@DsPweb;
       if SVPWEB_getParametrosWeb( peEmpr : peSucu : peArcd : @@DsPweb );
         if @@DsPweb.t@tvha > *zeros;
            peTvha = @@DsPweb.t@tvha;
            return *On;
         endif;
       endif;

       clear peTvha;
       return *Off;

      /end-free
     P SVPWEB_getTopeVigenciaHasta...
     P                 E
      * ------------------------------------------------------------ *
      * SVPWEB_getConvertirArticuloRamaEmision: Obtiene combinacion  *
      * Articulo-Rama (T@ARCC-T@RAMC) si Marca habilitada (T@MAR3).- *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peRams   (output)  Convertir desde Rama                  *
      *     peArcc   (output)  Convertir a Articulo                  *
      *     peRamc   (output)  Convertir a Rama                      *
      *                                                              *
      * Retorna: *on = Si obtiene valores / *off = Si error          *
      * ------------------------------------------------------------ *
     P SVPWEB_getConvertirArticuloRamaEmision...
     P                 B                   export
     D SVPWEB_getConvertirArticuloRamaEmision...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRams                       2  0
     D   peArcc                       6  0
     D   peRamc                       2  0

     D   @@DsPweb      ds                  likeds( dsParamWeb_t )

      /free

       SVPWEB_inz();

       clear @@DsPweb;
       if SVPWEB_getParametrosWeb( peEmpr : peSucu : peArcd : @@DsPweb );
         if @@DsPweb.t@mar3 = *On;
           peRams = @@DsPweb.t@rams;
           peArcc = @@DsPweb.t@arcc;
           peRamc = @@DsPweb.t@ramc;
           return *On;
         endif;
       endif;

       clear peRams;
       clear peArcc;
       clear peRamc;
       return *Off;

      /end-free
     P SVPWEB_getConvertirArticuloRamaEmision...
     P                 E
      * ------------------------------------------------------------ *
      * SVPWEB_okWeb  : Verifica web                                 *
      *                                                              *
      *      peRama   (input)    Código de Rama.                     *
      *      peXpro   (input)    Código de Producto.                 *
      *                                                              *
      * retorna: *ON si está habilitado para web, *OFF si no         *
      * ------------------------------------------------------------ *
     P SVPWEB_okWeb    B                   export
     D SVPWEB_okWeb    pi             1N
     D  peRama                        2  0 const
     D  peXpro                        3  0 const

     D k1t102w         ds                  likerec(s1t102w:*key)

     D hab             s              1N   inz(*OFF)

      /free

       SVPWEB_inz();

       k1t102w.t2rama = peRama;
       k1t102w.t2xpro = peXpro;
       setgt  %kds(k1t102w:2) set102w;
       readpe %kds(k1t102w:2) set102w;
       dow not %eof;
           if t2fech <= %dec(%date());
              if t2mp01 = 'S';
                 return *on;
              endif;
            leave;
           endif;
        readpe %kds(k1t102w:2) set102w;
       enddo;

       return *off;

      /end-free

     P SVPWEB_okWeb    E
      * ------------------------------------------------------------ *
      * SVPWEB_chkPar(): Cheque Parámetros                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWEB_chkPar...
     P                 B                   export
     D SVPWEB_chkPar...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const

     D k1yweb          ds                  likerec(s1tweb:*key)

       SVPWEB_inz();

       k1yweb.t@empr = peEmpr;
       k1yweb.t@sucu = peSucu;
       k1yweb.t@arcd = peArcd;

       setll  %kds( k1yweb : 3 ) setweb;
       return %equal;

      /end-free

     P SVPWEB_chkPar...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWEB_setParametrosWeb(): Graba datos para la web de los    *
      *                            articulos.                        *
      *                                                              *
      *     peDsWb   ( input  ) Estructura de SETWEB                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPWEB_setParametrosWeb...
     P                 B                   export
     D SVPWEB_setParametrosWeb...
     D                 pi              n
     D   peDsWb                            likeds( dsParamWeb_t )
     D                                     options( *nopass : *omit ) const

     D @@DsOWb         ds                  likerec( s1tweb : *output )

      /free

       SVPWEB_inz();

       eval-corr @@DsOWb = peDsWb;
       monitor;
         write s1tweb @@DsOWb;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPWEB_setParametrosWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWEB_getParametrosWeb2: Obtiene informacion para el proceso*
      *                          Web del tipo de Articulo.-          *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peFech   (input)   Fecha                                 *
      *     peDsWb   (output)  Estructura Parametros Web             *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPWEB_getParametrosWeb2...
     P                 B                   export
     D SVPWEB_getParametrosWeb2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0 options( *nopass : *omit ) const
     D   peDsWb                            likeds( dsParamWeb_t )
     D                                     options( *nopass : *omit )

     D   k1yweb        ds                  likerec( s1tweb : *key )
     D   dsIweb        ds                  likerec( s1tweb : *input)

      /free

       SVPWEB_inz();

       clear peDsWb;
       clear dsIweb;
       clear k1yweb;

       k1yweb.t@empr = peEmpr;
       k1yweb.t@sucu = peSucu;
       k1yweb.t@arcd = peArcd;

       if %parms >= 4 and %addr(peFech) <> *NULL;
         k1yweb.t@fech = peFech;
       else;
         k1yweb.t@fech = %dec(%date():*iso);
       endif;

       setgt  %kds(k1yweb:4) setweb;
       readpe %kds(k1yweb:3) setweb dsIweb;
       if not %eof(setweb);
         eval-corr peDsWb = dsIweb;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPWEB_getParametrosWeb2...
     P                 E

