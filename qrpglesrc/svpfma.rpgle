     H nomain
      * ************************************************************ *
      * SVPFMA: Programa de Servicio.                                *
      *         Factores Multiplicativos de Autos                    *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                  *04-Nov-2021               *
      * ************************************************************ *
     Fset287    if   e           k disk    usropn
     Fset286    if   e           k disk    usropn

      /copy './qcpybooks/svpfma_h.rpgle'

     D ErrN            s             10i 0
     D ErrM            s             80a
     D Initialized     s              1N

      * ------------------------------------------------------------ *
      * SVPFMA_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPFMA_inz      B                   export
     D SVPFMA_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set287);
         open set287;
       endif;

       if not %open(set286);
         open set286;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPFMA_inz      E

      * ------------------------------------------------------------ *
      * SVPFMA_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPFMA_End      B                   export
     D SVPFMA_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPFMA_End      E

      * ------------------------------------------------------------ *
      * SVPFMA_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     P SVPFMA_Error    B                   export
     D SVPFMA_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPFMA_Error    E

      * ------------------------------------------------------------ *
      * SVPFMA_antiguedad(): Aplica factor por antigüedad            *
      *                                                              *
      *     peCtre   (input)   Tarifa                                *
      *     peVhan   (input)   Año del Vehiculo                      *
      *     peFema   (input)   Año actual                            *
      *     peCobl   (input)   Cobertura                             *
      *     peScta   (input)   Zona                                  *
      *     peM0km   (input)   Marca de 0 KM PRIMER AÑO              *
      *     peM0k2   (input)   Marca de 0 KM SEGUNDO AÑO             *
      *     peVhca   (input)   Capítulo                              *
      *     peVhv1   (input)   Variante RC                           *
      *     peVhv2   (input)   Variante AIR                          *
      *     peMtdf   (input)   Marca de Tarifa Diferencial           *
      *     pePrii   (input)   Primas Base                           *
      *     pePrio   (output)  Primas Salida                         *
      *     peCoef   (output)  Coeficiente Aplicado                  *
      *     peMar2   (output)  Sobre qué aplicó el coeficiente:      *
      *                        '0' RC                                *
      *                        '1' Casco                             *
      *                        '2' Ambos                             *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPFMA_antiguedad...
     P                 b                   export
     D SVPFMA_antiguedad...
     D                 pi
     D  peCtre                        5  0 const
     D  peVhan                        4  0 const
     D  peFema                        4  0 const
     D  peCobl                        2a   const
     D  peScta                        1  0 const
     D  peM0km                        1a   const
     D  peM0k2                        1a   const
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1a   const
     D  pePrii                             likeds(primasAutos_t) const
     D  pePrio                             likeds(primasAutos_t)
     D  peCoef                        7  4
     D  peMar2                        1a

     D antig           s              2  0
     D mar2            s              1a

     D aux             s             29  9

     D k1t287          ds                  likerec(s1t287:*key)

      /free

       SVPFMA_inz();

       pePrio = pePrii;
       peCoef = 1;
       peMar2 = '2';

       if (peCtre < SVPFMA_tarifaDesdeAntig() );
          return;
       endif;

       antig = (peFema - peVhan);
       if peM0km = '1' or peM0k2 = '1'; // Si es 0km posta, fuerzo
          antig = 0;
       endif;

       k1t287.t@ctre = peCtre;
       k1t287.t@anti = antig;
       k1t287.t@cobl = peCobl;
       k1t287.t@scta = peScta;
       k1t287.t@vhca = peVhca;
       k1t287.t@vhv1 = peVhv1;
       k1t287.t@vhv2 = peVhv2;
       k1t287.t@mtdf = peMtdf;
       select;
        when peM0km = '1';
             k1t287.t@mar1 = '0';
        when peM0k2 = '1';
             k1t287.t@mar1 = '1';
        other;
             k1t287.t@mar1 = '2';
       endsl;
       chain %kds(k1t287) set287;
       if %found;
          if t@mar2 = '0' or t@mar2 = '2';
             aux = pePrio.prrc * t@coef;
             pePrio.prrc = %dech(aux:15:2);
             aux = pePrio.prce * t@coef;
             pePrio.prce = %dech(aux:15:2);
             aux = pePrio.prap * t@coef;
             pePrio.prap = %dech(aux:15:2);
             peCoef       = t@coef;
             peMar2       = t@mar2;
          endif;
          if t@mar2 = '1' or t@mar2 = '2';
             aux = pePrio.prac * t@coef;
             pePrio.prac = %dech(aux:15:2);
             aux = pePrio.prin * t@coef;
             pePrio.prin = %dech(aux:15:2);
             aux = pePrio.prro * t@coef;
             pePrio.prro = %dech(aux:15:2);
             aux = pePrio.pacc * t@coef;
             pePrio.pacc = %dech(aux:15:2);
             aux = pePrio.praa * t@coef;
             pePrio.praa = %dech(aux:15:2);
             aux = pePrio.prsf * t@coef;
             pePrio.prsf = %dech(aux:15:2);
             peCoef       = t@coef;
             peMar2       = t@mar2;
          endif;
       endif;

       return;

      /end-free

     P SVPFMA_antiguedad...
     P                 e

      * ------------------------------------------------------------ *
      * SVPFMA_marcaModelo(): Aplica factor por marca/modelo         *
      *                                                              *
      *     peCtre   (input)   Tarifa                                *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   Submodelo                             *
      *     pePrii   (input)   Primas Base                           *
      *     pePrio   (output)  Primas Salida                         *
      *     peCoef   (output)  Coeficiente Aplicado                  *
      *     peMar2   (output)  Sobre qué aplicó el coeficiente:      *
      *                        '0' RC                                *
      *                        '1' Casco                             *
      *                        '2' Ambos                             *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPFMA_marcaModelo...
     P                 b                   export
     D SVPFMA_marcaModelo...
     D                 pi
     D  peCtre                        5  0 const
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  pePrii                             likeds(primasAutos_t) const
     D  pePrio                             likeds(primasAutos_t)
     D  peCoef                        7  4
     D  peMar2                        1a

     D mar2            s              1a
     D pePcbp          s              5  2
     D @@Vhmc          s              3a
     D @@Vhmo          s              3a
     D @@Vhcs          s              3a
     D aux             s             29  9

      /free

       SVPFMA_inz();

       pePrio = pePrii;
       peCoef = 1;
       peMar2 = '2';

       @@Vhmc = peVhmc;
       @@Vhmo = peVhmo;
       @@Vhcs = peVhcs;

       if (peCtre < SVPFMA_tarifaDesdeMarMo() );
          return;
       endif;

       pePcbp = CZWUTL_getDescMarcaModelo( @@vhmc
                                         : @@vhmo
                                         : @@vhcs
                                         : *omit  );
       if pePcbp = 0;
          return;
       endif;

       peCoef = (1-(pePcbp/100));

       aux = pePrio.prrc * peCoef;
       pePrio.prrc = %dech(aux:15:2);
       aux = pePrio.prce * peCoef;
       pePrio.prce = %dech(aux:15:2);
       aux = pePrio.prap * peCoef;
       pePrio.prap = %dech(aux:15:2);
       aux = pePrio.prac * peCoef;
       pePrio.prac = %dech(aux:15:2);
       aux = pePrio.prin * peCoef;
       pePrio.prin = %dech(aux:15:2);
       aux = pePrio.prro * peCoef;
       pePrio.prro = %dech(aux:15:2);
       aux = pePrio.pacc * peCoef;
       pePrio.pacc = %dech(aux:15:2);
       aux = pePrio.praa * peCoef;
       pePrio.praa = %dech(aux:15:2);
       aux = pePrio.prsf * peCoef;
       pePrio.prsf = %dech(aux:15:2);

       return;

      /end-free

     P SVPFMA_marcaModelo...
     P                 e

      * ------------------------------------------------------------ *
      * SVPFMA_getDescripcion(): Obtiene descripcion                 *
      *                                                              *
      *     peCcoe   (input)   Codigo de Coeficiente                 *
      *                                                              *
      * Retorna: Descripcion o blanco                                *
      * ------------------------------------------------------------ *
     P SVPFMA_getDescripcion...
     P                 b                   export
     D SVPFMA_getDescripcion...
     D                 pi            25a
     D  peCcoe                        3  0 const

      /free

       SVPFMA_inz();
       chain peCcoe set286;
       if %found;
          return t@dcbp;
       endif;

       return *blanks;

      /end-free

     P SVPFMA_getDescripcion...
     P                 e

      * ------------------------------------------------------------ *
      * SVPFMA_getEquivalente(): Obtiene codigo equivalente          *
      *                                                              *
      *     peCcoe   (input)   Codigo de Coeficiente                 *
      *                                                              *
      * Retorna: Equivalente o blanco                                *
      * ------------------------------------------------------------ *
     P SVPFMA_getEquivalente...
     P                 b                   export
     D SVPFMA_getEquivalente...
     D                 pi             3a
     D  peCcoe                        3  0 const

      /free

       SVPFMA_inz();
       chain peCcoe set286;
       if %found;
          return t@cceq;
       endif;

       return *blanks;

      /end-free

     P SVPFMA_getEquivalente...
     P                 e

      * ------------------------------------------------------------ *
      * SVPFMA_tarifaDesdeAntig(): Obtiene tarifa a partir de la     *
      *                            cual arranca antigüedad.          *
      *                                                              *
      * Retorna: Tarifa desde antigüedad                             *
      * ------------------------------------------------------------ *
     P SVPFMA_tarifaDesdeAntig...
     P                 b                   export
     D SVPFMA_tarifaDesdeAntig...
     D                 pi             5  0

     D vsys            s            512a
     D TarDes          s              5  0

      /free

       SVPFMA_inz();

       TarDes = 999;

       if SVPVLS_getValSys( 'HTARDESANT'
                          : *omit
                          : vsys         );
          TarDes = %dec(vsys:5:0);
       endif;

       return TarDes;

       /end-free

     P SVPFMA_tarifaDesdeAntig...
     P                 e

      * ------------------------------------------------------------ *
      * SVPFMA_tarifaDesdeMarMo(): Obtiene tarifa a partir de la     *
      *                            cual arranca marca/modelo.        *
      *                                                              *
      * Retorna: Tarifa desde marca/modelo                           *
      * ------------------------------------------------------------ *
     P SVPFMA_tarifaDesdeMarMo...
     P                 b                   export
     D SVPFMA_tarifaDesdeMarMo...
     D                 pi             5  0

     D vsys            s            512a
     D TarDes          s              5  0

      /free

       SVPFMA_inz();

       TarDes = 999;

       if SVPVLS_getValSys( 'HTARDESMMO'
                          : *omit
                          : vsys         );
          TarDes = %dec(vsys:5:0);
       endif;

       return TarDes;

       /end-free

     P SVPFMA_tarifaDesdeMarMo...
     P                 e

      * ------------------------------------------------------------ *
      * SVPFMA_getAplicadA(): Obtiene a qué componente de prima se   *
      *                       aplicó.                                *
      *                                                              *
      *     peMar2   (input)   Codigo de Aplicacion                  *
      *                                                              *
      * Retorna: Descripcion o blanco                                *
      * ------------------------------------------------------------ *
     P SVPFMA_getAplicadoA...
     P                 b                   export
     D SVPFMA_getAplicadoA...
     D                 pi             5a
     D  peMar2                        1a   const

      /free

       SVPFMA_inz();

       select;
        when peMar2 = '0';
             return 'RC';
        when peMar2 = '1';
             return 'CASCO';
        when peMar2 = '2';
             return 'AMBOS';
       endsl;

       return *blanks;

       /end-free

     P                 e

      * ------------------------------------------------------------ *
      * SVPFMA_visualizarWeb(): Recupera si se visualiza o no en la  *
      *                         web.                                 *
      *                                                              *
      *     peCcoe   (input)   Codigo de Factor                      *
      *                                                              *
      * Retorna: *on se visualiza/*off no se visualiza               *
      * ------------------------------------------------------------ *
     P SVPFMA_visualizarWeb...
     P                 b                   export
     D SVPFMA_visualizarWeb...
     D                 pi             1n
     D  peCcoe                        3  0 const

      /free

       SVPFMA_inz();

       chain peCcoe set286;
       if %found;
          return t@mar1;
       endif;

       return *off;

       /end-free

     P                 e

