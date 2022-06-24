     H nomain
     H datedit(*DMY/)
     H option(*noshowcpy)
      * ************************************************************ *
      * SVPCOB: Validaciones de Cobertura.-                          *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                   23-Dic-2015             *
      *                                                              *
      * ************************************************************ *
     * Modificaciones:                                              *
     * LRG 05/10/16  Replanteo SVPCOB_ValListCobExcluyentes         *
     *               Se mejora inf. de Mensajes de Error en:        *
     *               SVPCOB_GetListCobReglas                        *
     *               SVPCOB_ValListCobExcluyentes                   *
     * GIO 09/08/19  RM#5396 Se reajusta la suma asegurada en       *
     *               funcion de la dependencia entre coberturas     *
     *               Retorna Array de Dependencias por Coberturas   *
     *               Cob + Cob Dependiente + Suma Aseg + % Aplicar  *
     * LRG 11/10/19  Nuevo procedimiendo _getCoberturasAutos        *
     * JSN 02/03/19  Se agrega el procedimiento:                    *
     *               _getCoberturaEquiva()                          *
     * SGF 11/05/20  Agrego _getLimiteCobertura(),                  *
     *               _getLimiteCoberturas() y _topearCoberturas().  *
     *                                                              *
     * ************************************************************ *
     Fset1033   if   e           k disk    usropn prefix( t1 : 2 )
     Fset1034   if   e           k disk    usropn prefix( t2 : 2 )
     Fset10301  if   e           k disk    usropn prefix( t3 : 2 )
     Fset1031   if   e           k disk    usropn
     Fctwev2    if   e           k disk    usropn
     Fpahev2    if   e           k disk    usropn
     Fset225    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpcob_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                       3000a   const

     D ErrN            s             10i 0
     D ErrM            s           3000a
     D Errmsg          s           3000a

     D Initialized     s              1N

     Is1t1031
     I              t@date                      t4date

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * SVPCOB_GetListCobExcluyentes : Devuelve lista de Coberturas  *
      *                                Excluyentes.                  *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peCobc   (input)  Cobertura                              *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (output) Lista de Coberturas Excluyentes        *
      *     peLCobc  (output) Cant. Lista de Coberturas Excluyentes  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_GetListCobExcluyentes...
     P                 B                   export
     D SVPCOB_GetListCobExcluyentes...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)
     D   peLcobC                     10i 0

     D   k1y133        ds                  likerec( s1t1033 : *key )

      /free

       SVPCOB_inz();

      *- Inicializo campos de salida
       clear peLcob;
       peLcobC = *Zeros;

       k1y133.t1rama = peRama;
       k1y133.t1xpro = peXpro;
       k1y133.t1riec = peRiec;
       k1y133.t1cobc = peCobc;
       k1y133.t1mone = peMone;
       setll %kds( k1y133 : 5 ) set1033;
       reade %kds( k1y133 : 5 ) set1033;
         dow not %eof ( set1033 );

         peLcobC += 1;
         peLcob( peLcobC ) = t1cobe;

        reade %kds( k1y133 : 5 ) set1033;
         enddo;

         if pelcobc > 0;
           return *on;
         else;
           return *off;
         endif;

      /end-free

     P SVPCOB_GetListCobExcluyentes...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_ValListCobExcluyentes : Valida Si coberturas son      *
      *                                Excluyentes entre Si.         *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (input) Lista de Coberturas Excluyentes         *
      *     peLCobc  (input) Cant. Lista de Coberturas Excluyentes   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_ValListCobExcluyentes...
     P                 B                   export
     D SVPCOB_ValListCobExcluyentes...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)
     D   peLcobC                     10i 0

     D   x             s             10i 0 inz
     D   y             s             10i 0 inz
     D   z             s             10i 0 inz
     D   rc            s              1N

     D peLco1          s              3  0 dim(20)
     D peLco1C         s             10i 0

     D   k1y133        ds                  likerec( s1t1033 : *key )

      /free

       SVPCOB_inz();

       for x = 1 to peLcobc;
           rc = SVPCOB_GetListCobExcluyentes( peRama
                                            : peXpro
                                            : peRiec
                                            : peLcob(x)
                                            : peMone
                                            : peLco1
                                            : peLco1C );
           for y = 1 to peLco1C;
             z = %lookup( peLco1(y) : peLcob );
             if z > 0;
               SetError( SVPCOB_COBEX
                       : 'Si Ud. desea seleccionar la Cobertura ' +
                       %trim( SVPDES_cobLargo( peRama : peLcob( x ) ) ) +
                       ' no puede seleccionar la Cobertura '+
                       %trim( SVPDES_cobLargo( peRama : peLco1( y ) ) ) );
                  return *off;
               endif;
           endfor;
       endfor;

       return *on;

      /end-free

     P SVPCOB_ValListCobExcluyentes...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_GetListCobReglas : Devuelve lista de Reglas de        *
      *                                Coberturas.                   *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peCobc   (input)  Cobertura                              *
      *     peMone   (input)  Moneda                                 *
      *     peLCobR  (output) Lista de Reglas de Coberturas          *
      *     peLCobc  (output) Cant. Lista de Reglas de Coberturas    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_GetListCobReglas...
     P                 B                   export
     D SVPCOB_GetListCobReglas...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peLcobR                           likeds(ListCobR) dim(20)
     D   peLcobC                     10i 0

     D   k1y134        ds                  likerec( s1t1034 : *key )

      /free

       SVPCOB_inz();

      *- Inicializo campos de salida
       clear peLcobR;
       peLcobC = *Zeros;

       k1y134.t2rama = peRama;
       k1y134.t2xpro = peXpro;
       k1y134.t2riec = peRiec;
       k1y134.t2cobc = peCobc;
       k1y134.t2mone = peMone;
       setll %kds( k1y134 : 5 ) set1034;
       reade %kds( k1y134 : 5 ) set1034;
         dow not %eof ( set1034 );

         peLcobC += 1;
         peLcobR( peLcobC ).cob1 = t2cob1;
         peLcobR( peLcobC ).cob2 = t2cob2;
         peLcobR( peLcobC ).cob3 = t2cob3;

        reade %kds( k1y134 : 5 ) set1034;
         enddo;

         if pelcobc > 0;
           return *on;
         else;
           return *off;
         endif;

      /end-free

     P SVPCOB_GetListCobReglas...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_ValListCobReglas : Valida coberturas en Lista de      *
      *                                Reglas.                       *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (output) Lista de Coberturas                    *
      *     peLCobc  (output) Cant. Lista de Reglas de Coberturas    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_ValListCobReglas...
     P                 B                   export
     D SVPCOB_ValListCobReglas...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)
     D   peLcobC                     10i 0

     D   @@LcobR       ds                  likeds(ListCobR) dim(20)
     D   @@LcobC       s             10i 0
     D   x             s             10i 0
     D   y             s             10i 0
     D   esta_ok       s              1n
     D   esta_ok_1     s              1n
     D   esta_ok_2     s              1n
     D   esta_ok_3     s              1n

      /free

       SVPCOB_inz();

       for x = 1 to peLcobC;
           esta_ok = *off;
           clear @@LcobR;
           clear @@LcobC;
           if SVPCOB_GetListCobReglas( peRama
                                     : peXpro
                                     : peRiec
                                     : peLcob(x)
                                     : peMone
                                     : @@LcobR
                                     : @@LcobC );
             for y = 1 to @@LcobC;
               if not esta_ok;
                 esta_ok_1 = *on;
                 esta_ok_2 = *on;
                 esta_ok_3 = *on;
                 // 1ero //
                  if @@LcobR(y).cob1 <> *Zeros;
                    if not SVPCOB_ValReglaCob( @@LCobR(y).cob1
                                             : peLcob          );
                       esta_ok_1 = *off;
                 endif;
                  endif;
               endif;

               if @@LcobR(y).cob2 <> *Zeros;
               // 2da //
                 if not SVPCOB_ValReglaCob( @@LCobR(y).cob2
                                          : peLcob           );
                   esta_ok_2 = *off;
                 endif;
               endif;

               if @@LcobR(y).cob3 <> *Zeros;
               // 3era //
                 if not SVPCOB_ValReglaCob( @@LCobR(y).cob3
                                          : peLcob          );
                   esta_ok_3 = *off;
                 endif;
               endif;

               if esta_ok_1 = *on and
                  esta_ok_2 = *on and
                  esta_ok_3 = *on;

                  esta_ok = *on;

               endif;
             endfor;

             if not esta_ok;

               clear errmsg;
               for y = 1 to @@LcobC;

                 if y > 1;
                   Errmsg = %trim( Errmsg ) + ' o ' +
                     %trim( SVPDES_cobLargo( peRama : @@LCobR(y).cob1 ));

                 else;
                   Errmsg = %trim( SVPDES_cobLargo( peRama : @@LCobR(y).cob1));
                 endif;

                 if @@LCobR(y).cob2 <> *Zeros;
                  Errmsg = %trim( Errmsg ) +
                           ' y ' +
                           %trim( SVPDES_cobLargo( peRama : @@LCobR(y).cob2));
                 endif;

                 if @@LCobR(y).cob3 <> *Zeros;
                  Errmsg = %trim( Errmsg ) +
                           ' y ' +
                           %trim( SVPDES_cobLargo( peRama : @@LCobR(y).cob3));
                 endif;

               endfor;
                 SetError( SVPCOB_COBNA
                         : 'Si Ud. desea seleccionar la Cobertura ' +
                         %trim( SVPDES_cobLargo( peRama : peLcob(x) ) ) +
                         ' tambien debe seleccionar : ' +
                           %trim( errmsg ) );
                 return *off;
             endif;

           endif;
       endfor;
       return *on;
      /end-free

     P SVPCOB_ValListCobReglas...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_ValReglaCob :    Valida Regla de Cobertura en Lista   *
      *                                de Cob.                       *
      *     peCobc   (input)  Cobertura                              *
      *     peLCob   (input)  Lista de Coberturas                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_ValReglaCob...
     P                 B                   export
     D SVPCOB_ValReglaCob...
     D                 pi              n
     D   peCobc                       3  0 const
     D   peLcob                       3  0 dim(20)

      /free

       SVPCOB_inz();

       if %lookup( peCobC : peLcob : 1 ) <> 0 ;

         return *on;

       endif;

        return *off;

      /end-free
     P SVPCOB_ValReglaCob...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_ValCoberturasBasicas: Valida si se enviaron Coberturas*
      *                                Básicas.                      *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (input)  Lista de Coberturas                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_ValCoberturasBasicas...
     P                 B                   export
     D SVPCOB_ValCoberturasBasicas...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)

     D   esta_ok       s               n
     D   vcobc         s              3  0 dim(20)
     D   x             s             10i 0
     D   y             s             10i 0
     D   k1y103        ds                  likerec( s1t10301 : *key )
      /free

       SVPCOB_inz();

       esta_ok = *on;
       clear vcobc;

       k1y103.t3rama = peRama;
       k1y103.t3xpro = peXpro;
       k1y103.t3mone = peMone;
       k1y103.t3riec = peRiec;
       setll %kds( k1y103 : 4 ) set10301;
       reade %kds( k1y103 : 4 ) set10301;
         dow not %eof( set10301 );
           if t3baop = 'B';
             if %lookup( t3cobC : peLcob : 1 ) = 0 ;
                x +=1;
                vcobc(x)= t3cobC;
                esta_ok = *off;
             endif;
           endif;
         reade %kds( k1y103 : 4 ) set10301;
         enddo;

         if esta_ok;
          return *on;
         endif;

         clear errmsg;
         for y = 1 to x;
           if x > 1;
             errmsg = %trim( errmsg ) + ',';
           endif;

           errmsg = %trim( errmsg ) + ' ' +
                    %editw(vcobc(x) : ' 0 ');
         endfor;

         SetError( SVPCOB_COBBA
                 : 'El Plan ' +
                 %editw(peXpro:' 0 ') +
                 ' debe contener las siguientes coberturas basicas '+
                 %trim( errmsg ) );
         return *off;

      /end-free
     P SVPCOB_ValCoberturasBasicas...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_getListaCoberturasCot:Retorna coberturas de la cotiza-*
      *                              ción.                           *
      *     peBase   (input)  Rama                                   *
      *     peNctw   (input)  Nro.de Cotización                      *
      *     peRama   (input)  Riesgo                                 *
      *     peArse   (input)  Artículo                               *
      *     pePoco   (input)  Nro.de Componente                      *
      *     peCobe   (output) Lista de Coberturas                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_getListaCoberturasCot...
     P                 B                   export
     D SVPCOB_getListaCoberturasCot...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)

     D   k1yev2        ds                  likerec( c1wev2 : *key )
     D   x             s             10i 0
      /free

       SVPCOB_inz();

       clear peCobe;
       clear x;

       k1yev2.v2empr = PeBase.peEmpr;
       k1yev2.v2sucu = PeBase.peSucu;
       k1yev2.v2nivt = PeBase.peNivt;
       k1yev2.v2nivc = PeBase.peNivc;
       k1yev2.v2nctw = peNctw;
       k1yev2.v2rama = peRama;
       k1yev2.v2arse = peArse;
       k1yev2.v2poco = pePoco;

       setll %kds( k1yev2 : 8 ) ctwev2;
       reade %kds( k1yev2 : 8 ) ctwev2;
       dow not %eof();

         x += 1;
         peCobe(x).riec = v2riec;
         peCobe(x).xcob = v2xcob;
         peCobe(x).sac1 = v2saco;

         reade %kds( k1yev2 : 8 ) ctwev2;
       enddo;

       if x > 0;
         return *on;
       else;
         return *off;
       endif;


      /end-free

     P SVPCOB_getListaCoberturasCot...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_getListaCoberturasSpol:Retorna coberturas de la Super *
      *                               póliza                         *
      *     peBase   (input)  Rama                                   *
      *     peNctw   (input)  Nro.de Cotización                      *
      *     peSpol   (input)  Riesgo                                 *
      *     pePoco   (input)  Artículo                               *
      *     peCobe   (input)  Nro.de Componente                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_getListaCoberturasSpol...
     P                 B                   export
     D SVPCOB_getListaCoberturasSpol...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   pePoco                       4  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)

     D   k1yev2        ds                  likerec( p1hev2 : *key )
     D   x             s             10i 0
      /free

       SVPCOB_inz();

       clear peCobe;
       clear x;

       k1yev2.v2empr = PeBase.peEmpr;
       k1yev2.v2sucu = PeBase.peSucu;
       k1yev2.v2arcd = peArcd;
       k1yev2.v2spol = peSpol;

       setll %kds( k1yev2 : 8 ) pahev2;
       reade %kds( k1yev2 : 8 ) pahev2;
       dow not %eof();

         x += 1;
         peCobe(x).riec = v2riec;
         peCobe(x).xcob = v2xcob;
         peCobe(x).sac1 = v2saco;

         reade %kds( k1yev2 : 8 ) pahev2;
       enddo;

       if x > 0;
         return *on;
       else;
         return *off;
       endif;


      /end-free

     P SVPCOB_getListaCoberturasSpol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCOB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPCOB_inz      B                   export
     D SVPCOB_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set1033);
         open set1033;
       endif;

       if not %open(set1034);
         open set1034;
       endif;

       if not %open(set10301);
         open set10301;
       endif;

       if not %open(set1031);
         open set1031;
       endif;

       if not %open(ctwev2);
         open ctwev2;
       endif;

       if not %open(pahev2);
         open pahev2;
       endif;

       if not %open(set225);
         open set225;
       endif;

       initialized = *ON;
       return;


      /end-free

     P SVPCOB_inz      E

      * ------------------------------------------------------------ *
      * SVPCOB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPCOB_End      B                   export
     D SVPCOB_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPCOB_End      E

      * ------------------------------------------------------------ *
      * SVPCOB_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPCOB_Error    B                   export
     D SVPCOB_Error    pi          3000a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPCOB_Error    E

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
     D  peErrm                     3000a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------ *
      * SVPCOB_GetListCobDepend : Devuelve lista de dependencias de  *
      *                           la cobertura.                      *
      *                                                              *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peCobc   (input)  Cobertura                              *
      *     peMone   (input)  Moneda                                 *
      *     peLcobD  (output) Lista de coberturas dependientes       *
      *     peLcobDC (output) Cantidad elementos de la lista         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPCOB_GetListCobDepend...
     P                 B                   export
     D SVPCOB_GetListCobDepend...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peLcobD                           likeds(ListCDep) dim(20)
     D   peLcobDC                    10i 0

     d   k1y131        ds                  likerec( s1t1031 : *key )

      /free

        SVPCOB_inz();

        // Inicializo campos de salida
        clear peLcobD;
        clear peLcobDC;

        k1y131.t@rama = peRama;
        k1y131.t@xpro = peXpro;
        k1y131.t@riec = peRiec;
        k1y131.t@cobc = peCobc;
        k1y131.t@mone = peMone;
        setll %kds( k1y131 ) set1031;
        dou %eof ( set1031 );
          reade %kds( k1y131 ) set1031;
          if not %eof ( set1031 );
            if t@cobcx > *zeros;

              peLcobDC += 1;
              peLcobD( peLcobDC ).xcob1 = peCobc;
              peLcobD( peLcobDC ).xcob2 = t@cobcx;
              peLcobD( peLcobDC ).saco = t@sacox;
              peLcobD( peLcobDC ).prsa = t@prsax;

            endif;
          endif;
        enddo;

        if peLcobDC > *zeros;
          return *on;
        else;
          return *off;
        endif;

      /end-free

     P SVPCOB_GetListCobDepend...
     P                 E

      * ------------------------------------------------------------ *
      * SVPCOB_getCoberturasAutos : Retorna estructura de Coberturas *
      *                             de Autos.                        *
      *     peLCob   (output) Lista de Coberturas                    *
      *     peLCobc  (output) Cant. de Coberturas                    *
      *                                                              *
      * Retorna: *on = Tiene / *off = No tiene                       *
      * ------------------------------------------------------------ *
     P SVPCOB_getCoberturasAutos...
     P                 B                   export
     D SVPCOB_getCoberturasAutos...
     D                 pi              n
     D   peLcob                            likeds( dsSet225_t ) dim( 9999 )
     D   peLcobC                     10i 0

     D   k1y225        ds                  likerec( s1t225 : *key   )
     D   dsI225        ds                  likerec( s1t225 : *input )

      /free

       SVPCOB_inz();

       setll *loval set225;
       read set225 dsI225;
       if %eof();
         return *off;
       endif;

       dow not %eof();
         peLcobC +=1;
         eval-corr peLcob( peLcobC ) = dsI225;
        read set225 dsI225;
       enddo;

       return *on;
      /end-free

     P SVPCOB_getCoberturasAutos...
     P                 E

      * ------------------------------------------------------------ *
      * SVPCOB_getCoberturaEquiva : Retorna Cobertura Equivalente    *
      *                             SSN.                             *
      *     peCobl  ( input ) Código de Cobertura.                   *
      *                                                              *
      * Retorna: Coss si exíste / Blanco si no exíste                *
      * ------------------------------------------------------------ *
     P SVPCOB_getCoberturaEquiva...
     P                 B                   export
     D SVPCOB_getCoberturaEquiva...
     D                 pi             2
     D   peCobl                       2    Const

     D @@Lcob          ds                  likeds( dsSet225_t ) dim( 9999 )
     D @@LcobC         s             10i 0
     D x               s             10i 0

      /free

       SVPCOB_inz();

       if SVPCOB_getCoberturasAutos( @@Lcob
                                   : @@LcobC );

         for x = 1 to @@LcobC;
           if @@Lcob(x).t@Cobl = peCobl;
             return @@Lcob(x).t@Coss;
           endif;
         endfor;

       endif;

       return *blanks;

      /end-free

     P SVPCOB_getCoberturaEquiva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPCOB_getLimiteCobertura: Retorna limite de cobertura de RV *
      *                                                              *
      *     peRama  ( input ) Rama.                                  *
      *     peXpro  ( input ) Codigo de producto.                    *
      *     peMone  ( input ) Codigo de moneda.                      *
      *     peRiec  ( input ) Codigo de riesgo.                      *
      *     peXcob  ( input ) Codigo de cobertura.                   *
      *     peR1031 ( input ) Registro SET1031.                      *
      *                                                              *
      * Retorna: *ON registro encontrado/*OFF registro no encontrado *
      * ------------------------------------------------------------ *
     P SVPCOB_getLimiteCobertura...
     P                 b                   export
     D SVPCOB_getLimiteCobertura...
     D                 pi              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peMone                        2a   const
     D  peRiec                        3a   const
     D  peXcob                        3  0 const
     D  peR1031                            likeds(dsSet1031_t)

     D k1t1031         ds                  likerec(s1t1031:*key)
     D int1031         ds                  likerec(s1t1031:*input)

      /free

       SVPCOB_inz();

       clear peR1031;

       k1t1031.t@rama = peRama;
       k1t1031.t@xpro = peXpro;
       k1t1031.t@riec = peRiec;
       k1t1031.t@cobc = peXcob;
       k1t1031.t@mone = peMone;
       chain %kds(k1t1031:5) set1031 int1031;
       if not %found;
          SetError( SVPCOB_COBSL
                  : 'No se ha encontrado limite para la cobertura' );
          return *off;
       endif;

       eval-corr peR1031 = int1031;

       return *on;

      /end-free

     P SVPCOB_getLimiteCobertura...
     P                 e

      * ------------------------------------------------------------ *
      * SVPCOB_getLimiteCoberturas:Retorna limite de coberturas de RV*
      *                                                              *
      *     peRama  ( input ) Rama.                                  *
      *     peXpro  ( input ) Codigo de producto.                    *
      *     peMone  ( input ) Codigo de moneda.                      *
      *     peR1031 ( input ) Registro SET1031.                      *
      *     peR1031C( input ) Cantidad de registros en peR1031.      *
      *                                                              *
      * Retorna: *ON registro encontrado/*OFF registro no encontrado *
      * ------------------------------------------------------------ *
     P SVPCOB_getLimiteCoberturas...
     P                 b                   export
     D SVPCOB_getLimiteCoberturas...
     D                 pi              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peMone                        2a   const
     D  peR1031                            likeds(dsSet1031_t) dim(999)
     D  peR1031C                     10i 0

     D k1t1031         ds                  likerec(s1t1031:*key)
     D peT1031         ds                  likeds(dsSet1031_t)

      /free

       SVPCOB_inz();

       clear peR1031;
       clear peT1031;
       peR1031C = 0;

       k1t1031.t@rama = peRama;
       k1t1031.t@xpro = peXpro;
       setll %kds(k1t1031:2) set1031;
       reade %kds(k1t1031:2) set1031;
       dow not %eof;
           if t@mone = peMone;
              if SVPCOB_getLimiteCobertura( peRama
                                          : peXpro
                                          : peMone
                                          : t@riec
                                          : t@cobc
                                          : peT1031 );
                 peR1031C += 1;
                 eval-corr peR1031(peR1031C) = peT1031;
              endif;
           endif;
        reade %kds(k1t1031:2) set1031;
       enddo;

       return *on;

      /end-free

     P SVPCOB_getLimiteCoberturas...
     P                 e

      * ------------------------------------------------------------ *
      * SVPCOB_topearCoberturas: Fuerza suma asegurada maxima a las  *
      *                          coberturas.                         *
      *                                                              *
      *     peRama  ( input ) Rama.                                  *
      *     peXpro  ( input ) Codigo de producto.                    *
      *     peMone  ( input ) Codigo de moneda.                      *
      *     peCobe  ( input/output) Array con coberturas.            *
      *     peArcd  ( input ) Articulo (opcional).                   *
      *                                                              *
      * Retorna: *ON topea alguna/*off no topeo ninguna.             *
      * ------------------------------------------------------------ *
     P SVPCOB_topearCoberturas...
     P                 b                   export
     D SVPCOB_topearCoberturas...
     D                 pi              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peMone                        2a   const
     D  peCobe                             likeds(cobPrima) dim(20)
     D  peArcd                        6  0 const options(*omit:*nopass)

     D x               s              5i 0
     D z               s              5i 0
     D ret             s              1n
     D @valsys         s            512a
     D @cval           s             10a   inz('HTOPCOBExx')
     D @rico           s              6a
     D @max            s             15  2
     D peR1031         ds                  likeds(dsSet1031_t)

     D cobFijas        ds                  qualified dim(20)
     D  rico                          6a
     D  saco                         15  2

      /free

       SVPCOB_inz();

       ret = *off;

       // ------------------------------------------
       // ValSys me dice si la rama debe o no topear
       // ------------------------------------------
       @cval = %scanrpl( 'xx' : %editc(peRama:'X') : @cval );
       if not SVPVLS_getValSys( @cval : *omit : @valsys );
          return *off;
       endif;
       if %trim(@valsys) = 'N';
          return *off;
       endif;

       // ---------------------------------------------
       // Si el articulo llego, vemos que dice valsys
       // En este caso, el articulo pisa a la rama pero
       // si no hay valsys, entonces la rama actua
       // ---------------------------------------------
       if %parms >= 5 and %addr(peArcd) <> *null;
          @valsys = *blanks;
          @cval = 'HTOPxxxxxx';
          @cval = %scanrpl( 'xxxxxx' : %editc(peArcd:'X') : @cval );
          if SVPVLS_getValSys( @cval : *omit : @valsys );
             if %trim(@valsys) = 'N';
                return *off;
             endif;
          endif;
       endif;

       // ------------------------------------------
       // Primera ejecucion: solo las que son con
       // limite fijo.
       // ------------------------------------------
       for x = 1 to %elem(peCobe);
           if peCobe(x).riec = *blanks;
              leave;
           endif;
           if SVPCOB_getLimiteCobertura( peRama
                                       : peXpro
                                       : peMone
                                       : peCobe(x).riec
                                       : peCobe(x).xcob
                                       : peR1031         );
              if peR1031.t@riecx = *blanks and
                 peR1031.t@cobcx = 0;
                 @rico = %trim(peCobe(x).riec)
                       + %editc(peCobe(x).xcob:'X');
                 z = %lookup(@rico : cobFijas(*).rico);
                 if z = 0;
                    z = %lookup(*blanks:cobFijas(*).rico);
                 endif;
                 cobFijas(z).rico = @rico;
                 cobFijas(z).saco = peCobe(x).sac1;
                 if peCobe(x).sac1 < peR1031.t@lmin;
                    peCobe(x).sac1 = peR1031.t@lmin;
                    cobFijas(z).saco = peCobe(x).sac1;
                    ret = *on; // Marco para devolver
                 endif;
                 if peCobe(x).sac1 > peR1031.t@sacox;
                    peCobe(x).sac1 = peR1031.t@sacox;
                    cobFijas(z).saco = peCobe(x).sac1;
                    ret = *on; // Marco para devolver
                 endif;
              endif;
           endif;
       endfor;

       // ------------------------------------------
       // Ahora ya tengo ajustadas aquellas que son
       // con limite fijo; debo ver aquellas que
       // son con limite porcentual de otras
       // ------------------------------------------
       for x = 1 to %elem(peCobe);
           if peCobe(x).riec = *blanks;
              leave;
           endif;
           if SVPCOB_getLimiteCobertura( peRama
                                       : peXpro
                                       : peMone
                                       : peCobe(x).riec
                                       : peCobe(x).xcob
                                       : peR1031         );
              if peR1031.t@riecx <> *blanks and
                 peR1031.t@cobcx <> 0;
                 @rico = %trim(peR1031.t@riecx)
                       + %editc(peR1031.t@cobcx:'X');
                 z = %lookup(@rico:cobFijas(*).rico);
                 if z <> 0;
                    if peR1031.t@prsax <> 0;
                       @max = (cobFijas(z).saco * peR1031.t@prsax)/100;
                       if peCobe(x).sac1 <> @max;
                          peCobe(x).sac1 = @max;
                          ret = *on; // Marco para devolver
                       endif;
                    endif;
                 endif;
              endif;
           endif;
       endfor;

       return ret;

      /end-free

     P SVPCOB_topearCoberturas...
     P                 e

