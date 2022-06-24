     H nomain
     H datedit(*DMY/)
     * ************************************************************ *
     * SVPDAU: Programa de Servicio.                                *
     *         Descuentos Autos                                     *
     * ------------------------------------------------------------ *
     * Gomez Luis Roberto                   24-04-2017              *
     *------------------------------------------------------------- *
     * Modificaciones:                                              *
     * LRG ** 07/08/2917**: Se obiene còdigo de descuento desde     *
     *                      un código equivalente                   *
     * JSN ** 20/05/2019**: Se obtiene estructura por código de     *
     *                      descuento. SVPDAU_getXCodDescuento      *
     * JSN ** 21/01/2020**: Se agrega nuevos procedimientos:        *
     *                      _setDescuento                           *
     *                      _getPermiteCero                         *
     *                      _getPorcentajeBonif                     *
     *                      _getPermiteCambioPorc                   *
     * JSN ** 09/02/2022**: Se agrega los procedimientos:           *
     *                      _visualizarWeb                          *
     *                      _getXCodDescuento                       *
     *                                                              *
     * ************************************************************ *
     Fset25006  if   e           k disk    usropn rename ( s1t250 : s1t25006 )
     Fset250    if a e           k disk    usropn

     *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpdau_h.rpgle'

     * ------------------------------------------------------------ *
     * Setea error global                                           *
     * ------------------------------------------------------------ *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     *--- PR Externos --------------------------------------------- *

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     *--- Definicion de Procedimiento ----------------------------- *

     * ------------------------------------------------------------ *
     * SVPDAU_chkDescxEquivalente: Valida si Cod. de Descuento se   *
     *                             se encuentra asociado a un       *
     *                             determinado Cod. Equivalente.    *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbe   (input)   Cod. Descuento Equivalente            *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peCcbp   (input)   Cod. Descuento                        *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_chkDescxEquivalente...
     P                 b                   export
     D SVPDAU_chkDescxEquivalente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbe                       3    const
     D   peMar1                       1    const
     D   peCcbp                       3  0 const

     D   k1y250        ds                  likerec( s1t25006 : *key )

      /free

       SVPDAU_inz();

       k1y250.stempr = peEmpr;
       k1y250.stsucu = peSucu;
       k1y250.starcd = peArcd;
       k1y250.strama = peRama;
       k1y250.stccbe = peCcbe;
       k1y250.stmar1 = peMar1;
       setll %kds( k1y250 : 6 ) set25006;
         if not %equal( set25006 );
           return *off;
         endif;
       reade(n) %kds( k1y250 : 6 ) set25006;
         dow not %eof( set25006 );
           if peCcbp = stccbp;
              return *on;
           endif;
           reade(n) %kds( k1y250 : 6 ) set25006;
         enddo;

         return *off;

      /end-free

     P SVPDAU_chkDescxEquivalente...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_getDescxEquivalente: Retorna datos de Descuento que   *
     *                             se encuentra asociado a un       *
     *                             determinado Cod. Equivalente.    *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbe   (input)   Cod. Descuento Equivalente            *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peDesc   (output)  Estructura de Descuento( set250 )     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_getDescxEquivalente...
     P                 b                   export
     D SVPDAU_getDescxEquivalente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbe                       3    const
     D   peMar1                       1    const
     D   peDesc                            likeds( dsset250_t )

     D   k1y250        ds                  likerec( s1t25006 : *key )
     D   dsE250        ds                  likerec( s1t25006 : *input)

      /free

       SVPDAU_inz();

       k1y250.stempr = peEmpr;
       k1y250.stsucu = peSucu;
       k1y250.starcd = peArcd;
       k1y250.strama = peRama;
       k1y250.stccbe = peCcbe;
       k1y250.stmar1 = peMar1;
       chain %kds( k1y250 : 6 ) set25006 dsE250;
       if %found( set25006 );
         eval-corr peDesc = dsE250;
         return *on;
       endif;
       return *off;
      /end-free

     P SVPDAU_getDescxEquivalente...
     P                 e
     * ------------------------------------------------------------ *
     * SVPDAU_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     P SVPDAU_inz      B                   export
     D SVPDAU_inz      pi

      /free

       if not %open(set25006);
          open set25006;
       endif;

       if not %open(set250);
          open set250;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPDAU_inz      E

     * ------------------------------------------------------------ *
     * SVPDAU_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     P SVPDAU_End      B                   export
     D SVPDAU_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPDAU_End      E

     * ------------------------------------------------------------ *
     * SVPDAU_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     P SVPDAU_Error    B                   export
     D SVPDAU_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

      if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
     endif;

       return ErrM;

      /end-free

     P SVPDAU_Error    E

     * ------------------------------------------------------------ *
     * SetError(): Setea último error y mensaje.                    *
     *                                                              *
     *     peErrn   (input)   Número de error a setear.             *
     *     peErrm   (input)   Texto del mensaje.                    *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *

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

     * ------------------------------------------------------------ *
     * SVPDAU_isVigente(): Verifica si un descuento/recargo está    *
     *                     vigente a una determinada fecha.         *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Nivel (C=Componente/P=Poliza)         *
     *     peFech   (input)   Fecha a la cual chequear              *
     *                                                              *
     * Retorna: *on si está vigente, *off si no.                    *
     * ------------------------------------------------------------ *
     P SVPDAU_isVigente...
     P                 b                   export
     D SVPDAU_isVigente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1a   const
     D   peFech                       8  0 const options(*nopass:*omit)

     D k1t250          ds                  likerec(s1t250:*key)
     D @@fech          s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0

      /free

       SVPDAU_inz();

       if %parms >= 7 and %addr(peFech) <> *null;
          @@fech = peFech;
        else;
          PAR310X3( peEmpr : peFema : peFemm : peFemd );
          @@fech = (peFema * 10000) + (peFemm * 100) + peFemd;
       endif;

       k1t250.stempr = peEmpr;
       k1t250.stsucu = peSucu;
       k1t250.starcd = peArcd;
       k1t250.strama = peRama;
       k1t250.stccbp = peCcbp;
       k1t250.stmar1 = peMar1;
       chain %kds(k1t250) set250;
       if not %found;
          return *off;
       endif;

       if stffbp <= 0;
          stffbp = 99999999;
       endif;

       if @@fech >= stfcbp and
          @@fech <= stffbp;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPDAU_isVigente...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_getCodigoEquivalente(): Obtiene descuento equivalente *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Nivel (C=Componente/P=Poliza)         *
     *                                                              *
     * Retorna: Código Equivalente                                  *
     * ------------------------------------------------------------ *
     P SVPDAU_getCodigoEquivalente...
     P                 b                   export
     D SVPDAU_getCodigoEquivalente...
     D                 pi             3a
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1a   const

     D k1t250          ds                  likerec(s1t250:*key)

      /free

       SVPDAU_inz();

       k1t250.stempr = peEmpr;
       k1t250.stsucu = peSucu;
       k1t250.starcd = peArcd;
       k1t250.strama = peRama;
       k1t250.stccbp = peCcbp;
       k1t250.stmar1 = peMar1;
       chain %kds(k1t250) set250;
       if not %found;
          return *blanks;
       endif;

       return stccbe;

      /end-free

     P SVPDAU_getCodigoEquivalente...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_getXCodDescuento:  Retorna datos que se encuentre     *
     *                           asociado a un determinado Cod.     *
     *                           descuento.                         *
     * ********************** Deprecated ************************** *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peDesc   (output)  Estructura de Descuento( set250 )     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_getXCodDescuento...
     P                 b                   export
     D SVPDAU_getXCodDescuento...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const
     D   peDesc                            likeds( dsset250_t )

     D   k1y250        ds                  likerec( s1t250 : *key )
     D   dsE250        ds                  likerec( s1t250 : *input)
     D   @@Desc        ds                  likeds( dsset250_t2 )

      /free

       SVPDAU_inz();

       clear @@Desc;

       if SVPDAU_getXCodDescuento2( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peRama
                                  : peCcbp
                                  : peMar1
                                  : @@Desc );

         eval-corr peDesc = @@Desc;
         return *on;
       endif;
       return *off;

      /end-free

     P SVPDAU_getXCodDescuento...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_setDescuento(): Graba datos de componentes de         *
     *                        Bonificación de Prima.                *
     *                                                              *
     *     peDesc   ( input )  Estructura de Descuento( set250 )    *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_setDescuento...
     P                 b                   export
     D SVPDAU_setDescuento...
     D                 pi              n
     D   peDesc                            likeds( dsset250_t ) const

     D @@Desc          ds                  likeds( dsset250_t )
     D DsO250          ds                  likerec( s1t250 : *output )

      /free

       SVPDAU_inz();

       clear @@Desc;

       if SVPDAU_getXCodDescuento( peDesc.stEmpr
                                 : peDesc.stSucu
                                 : peDesc.stArcd
                                 : peDesc.stRama
                                 : peDesc.stCcbp
                                 : peDesc.stMar1
                                 : @@Desc        );
         return *off;
       endif;

       eval-corr DsO250 = peDesc;
       monitor;
         write s1t250 DsO250;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPDAU_setDescuento...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_getPermiteCero():  Retorna si permite grabar en cero. *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_getPermiteCero...
     P                 b                   export
     D SVPDAU_getPermiteCero...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     D @@Desc          ds                  likeds( dsset250_t )

      /free

       SVPDAU_inz();

       clear @@Desc;

       if SVPDAU_getXCodDescuento( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peRama
                                 : peCcbp
                                 : peMar1
                                 : @@Desc );

         if @@Desc.stMar3 = '1';
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SVPDAU_getPermiteCero...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_getPorcentajeBonif(): Retorna Porcentaje de Bonifica- *
     *                              ción.                           *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: PCBP / *zeros                                       *
     * ------------------------------------------------------------ *
     P SVPDAU_getPorcentajeBonif...
     P                 b                   export
     D SVPDAU_getPorcentajeBonif...
     D                 pi             5  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     D @@Desc          ds                  likeds( dsset250_t )

      /free

       SVPDAU_inz();

       clear @@Desc;

       if SVPDAU_getXCodDescuento( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peRama
                                 : peCcbp
                                 : peMar1
                                 : @@Desc );

         return @@Desc.stPcbp;
       endif;

       return *zeros;

      /end-free

     P SVPDAU_getPorcentajeBonif...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_getPermiteCambioPorc(): Retorna si permite cambio de  *
     *                                porcentaje.                   *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_getPermiteCambioPorc...
     P                 b                   export
     D SVPDAU_getPermiteCambioPorc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     D @@Desc          ds                  likeds( dsset250_t )

      /free

       SVPDAU_inz();

       clear @@Desc;

       if SVPDAU_getXCodDescuento( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peRama
                                 : peCcbp
                                 : peMar1
                                 : @@Desc );

         if @@Desc.stMcbp = 'S';
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SVPDAU_getPermiteCambioPorc...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_visualizarWeb(): Retorna si permite visualizar en la  *
     *                        consulta Web.                         *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_visualizarWeb...
     P                 b                   export
     D SVPDAU_visualizarWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     D @@Desc          ds                  likeds( dsset250_t2 )

      /free

       SVPDAU_inz();

       clear @@Desc;

       if SVPDAU_getXCodDescuento2( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peRama
                                  : peCcbp
                                  : peMar1
                                  : @@Desc );

         if @@Desc.stMar7 = '1';
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SVPDAU_visualizarWeb...
     P                 e

     * ------------------------------------------------------------ *
     * SVPDAU_getXCodDescuento2: Retorna datos que se encuentre     *
     *                           asociado a un determinado Cod.     *
     *                           descuento.                         *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peDesc   (output)  Estructura de Descuento( set250 )     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPDAU_getXCodDescuento2...
     P                 b                   export
     D SVPDAU_getXCodDescuento2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const
     D   peDesc                            likeds( dsset250_t2 )

     D   k1y250        ds                  likerec( s1t250 : *key )
     D   dsE250        ds                  likerec( s1t250 : *input)

      /free

       SVPDAU_inz();

       k1y250.stEmpr = peEmpr;
       k1y250.stSucu = peSucu;
       k1y250.stArcd = peArcd;
       k1y250.stRama = peRama;
       k1y250.stCcbp = peCcbp;
       k1y250.stMar1 = peMar1;
       chain %kds( k1y250 : 6 ) set250 dsE250;
       if %found( set250 );
         eval-corr peDesc = dsE250;
         return *on;
       endif;
       return *off;

      /end-free

     P SVPDAU_getXCodDescuento2...
     P                 e

