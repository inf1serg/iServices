     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPVIV: Programa de Servicio.                                *
      *         Tipos de Vivienda                                    *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     10-Nov-2014             *
      * ************************************************************ *
      * Modificaciones:                                              *
      * NGF   20/08/2015        Procedimientos agregados:            *
      *                          SVPVIV_webViv                       *
      *                          SVPVIV_chkWebViv                    *
      *                         Procedimientos modificados:          *
      *                          SVPVIV_setViv                       *
      * SFA   04/09/2015        Procedimientos agregados:            *
      *                          SVPVIV_chkVivProducto               *
      *                          SVPVIV_getVivProducto               *
      * ************************************************************ *
     Fset162    uf a e           k disk    usropn
     Fpaher004  if   e           k disk    usropn
     Fset1021   if   e           k disk    usropn
     Fset102101 if   e           k disk    usropn rename(s1t1021:s1t102101)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/SVPVIV_h.rpgle'

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
     D getSec          pr             3  0
     D   peCviv                       3  0 const

      *--- PR Externos --------------------------------------------- *

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPVIV_chkViv(): Chequea Tipo de Vivienda                    *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVIV_chkViv...
     P                 B                   export
     D SVPVIV_chkViv...
     D                 pi              n
     D   peCviv                       3  0 const

     D k1y162          ds                  likerec(s1t162:*key)

      /free

       SVPVIV_inz();

       k1y162.t@cviv = peCviv;
       setll %kds(k1y162:1) set162;

       if %equal(set162);
         return *On;
       else;
         SetError( SVPVIV_VIVIN
                 : 'Tipo de Vivienda Inexistente' );
         return *Off;
       endif;

      /end-free

     P SVPVIV_chkViv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_getDescViv(): Retorna Descripcion Tipo de Vivienda    *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: Descripcion / Blanco en caso de error               *
      * ------------------------------------------------------------ *

     P SVPVIV_getDescViv...
     P                 B                   export
     D SVPVIV_getDescViv...
     D                 pi            60
     D   peCviv                       3  0 const

     D k1y162          ds                  likerec(s1t162:*key)

      /free

       SVPVIV_inz();

       k1y162.t@cviv = peCviv;

       chain(n) %kds(k1y162:1) set162;

       return t@dviv;

      /end-free

     P SVPVIV_getDescViv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_chkBloqViv(): Chequea Tipo de Vivienda Bloqueada      *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVIV_chkBloqViv...
     P                 B                   export
     D SVPVIV_chkBloqViv...
     D                 pi              n
     D   peCviv                       3  0 const

     D k1y162          ds                  likerec(s1t162:*key)

      /free

       SVPVIV_inz();

       k1y162.t@cviv = peCviv;

       setgt %kds(k1y162:1) set162;
       readpe(n) %kds(k1y162:1) set162;

       if t@mar1 = 'S';
         return *On;
         SetError( SVPVIV_VIVBL
                 : 'Tipo de Vivienda Bloqueada' );
       else;
         return *Off;
       endif;

      /end-free

     P SVPVIV_chkBloqViv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_chkWebViv(): Chequea Tipo de Vivienda Inc/Exc Web     *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVIV_chkWebViv...
     P                 B                   export
     D SVPVIV_chkWebViv...
     D                 pi              n
     D   peCviv                       3  0 const

     D k1y162          ds                  likerec(s1t162:*key)

      /free

       SVPVIV_inz();

       k1y162.t@cviv = peCviv;

       setgt %kds(k1y162:1) set162;
       readpe(n) %kds(k1y162:1) set162;

       if t@mar2 = '1';
         return *On;
       else;
         return *Off;
       endif;

      /end-free

     P SVPVIV_chkWebViv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_setViv(): Graba Tipo de Vivienda                      *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *     peDviv   (input)   Descripcion de Tipo de Vivienda       *
      *     peUser   (input)   Usuario                               *
      *     peBloq   (input)   Marca de Bloqueo                      *
      *     peMweb   (input)   Incluye/Excluye Web                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVIV_setViv...
     P                 B                   export
     D SVPVIV_setViv...
     D                 pi              n
     D   peCviv                       3  0 const
     D   peDviv                      60    const
     D   peUser                      10    const
     D   peBloq                       1    options(*nopass:*omit)
     D   peMweb                       1    options(*nopass:*omit)

     D k1y162          ds                  likerec(s1t162:*key)

     D min             c                   const('abcdefghijklmnopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       SVPVIV_inz();

       t@cviv = peCviv;
       t@fech = *Year*10000+*Month*100+*Day;
       t@secu = getSec(peCviv);
       t@dviv = %trim(%xlate(min:may:peDviv));
       if %parms >= 4 and %addr(peBloq) <> *Null;
         t@mar1 = peBloq;
       endif;
       if %parms >= 5 and %addr(peMweb) <> *Null;
          if peMweb = 'I';
             t@mar2 = '1';
          endif;
          if peMweb = 'E';
             t@mar2 = '0';
          endif;
       endif;
       t@mar3 = *Blanks;
       t@mar4 = *Blanks;
       t@mar5 = *Blanks;
       t@user = peUser;
       t@time = %dec(%time():*iso);

       write s1t162;

       return *On;

      /end-free

     P SVPVIV_setViv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_updViv(): Bloquea/Desbloquea Tipo de Vivienda         *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVIV_updViv...
     P                 B                   export
     D SVPVIV_updViv...
     D                 pi              n
     D   peCviv                       3  0 const
     D   peUser                      10    const

     D @@Bloq          s              1

     D k1y162          ds                  likerec(s1t162:*key)

      /free

       SVPVIV_inz();

       if SVPVIV_chkBloqViv( peCviv );
         @@Bloq = 'N';
       else;
         @@Bloq = 'S';
       endif;

       SVPVIV_setViv(peCviv : SVPVIV_getDescViv(peCviv) : peUser : @@Bloq);

       return *On;

      /end-free

     P SVPVIV_updViv...
     P                 E
      * ------------------------------------------------------------ *
      * SVPVIV_webViv(): Incluye/Excluye en Web Tipo de Vivienda     *
      *                                                              *
      *     peMweb   (input)   Codigo de Tipo de Vivienda            *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVIV_webViv...
     P                 B                   export
     D SVPVIV_webViv...
     D                 pi              n
     D   peCviv                       3  0 const
     D   peUser                      10    const

     D k1y162          ds                  likerec(s1t162:*key)

     D @@web           s              1

      /free

       SVPVIV_inz();

       if SVPVIV_chkWebViv(peCviv);
          @@web = 'E';
       else;
          @@web = 'I';
       endif;

       SVPVIV_setViv(peCviv : SVPVIV_getDescViv(peCviv) : peUser :
                     *omit:@@web);

       return *On;

      /end-free

     P SVPVIV_webViv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_dltViv(): Elimina Tipo de Vivienda                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPVIV_dltViv...
     P                 B                   export
     D SVPVIV_dltViv...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCviv                       3  0 const

     D k1y162          ds                  likerec(s1t162:*key)
     D k1yer0          ds                  likerec(p1her004:*key)

      /free

       SVPVIV_inz();

       k1yer0.r0empr = peEmpr;
       k1yer0.r0sucu = peSucu;
       k1yer0.r0cviv = peCviv;
       setll %kds(k1yer0:3) paher004;
       if %equal(paher004);
         SetError( SVPVIV_VIVUT
                 : 'Tipo de Vivienda Utilizada' );
         return *Off;
       endif;

       k1y162.t@cviv = peCviv;

       setll %kds(k1y162:1) set162;
       reade %kds(k1y162:1) set162;

       if %eof (set162);
         SetError( SVPVIV_VIVIN
                 : 'Tipo de Vivienda Inexistente' );
         return *Off;
       endif;

       dow not %eof (set162);
         delete set162;
         reade %kds(k1y162:1) set162;
       enddo;

       return *On;

      /end-free

     P SVPVIV_dltViv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPVIV_inz      B                   export
     D SVPVIV_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set162);
         open set162;
       endif;

       if not %open(paher004);
         open paher004;
       endif;

       if not %open(set1021);
         open set1021;
       endif;

       if not %open(set102101);
         open set102101;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPVIV_inz      E

      * ------------------------------------------------------------ *
      * SVPVIV_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPVIV_End      B                   export
     D SVPVIV_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPVIV_End      E

      * ------------------------------------------------------------ *
      * SVPVIV_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPVIV_Error    B                   export
     D SVPVIV_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPVIV_Error    E

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
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: Secuencia                                           *
      * void                                                         *
      * ------------------------------------------------------------ *

     P getSec          B                   export
     D getSec          pi             3  0
     D   peCviv                       3  0 const

     D k1y162          ds                  likerec(s1t162:*key)

      /free

       k1y162.t@cviv = peCviv;
       k1y162.t@fech = *year*10000+*month*100+*day;

       setgt %kds(k1y162:2) set162;
       readpe(n) %kds(k1y162:2) set162;

       if %eof;
         return 1;
       else;
         return t@secu + 1;
       endif;

      /end-free

     P getSec...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_chkVivProducto(): Retorna si el Codigo de Vivienda    *
      *                          esta relacionado al Producto        *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *     peRama   (input)   Codigo de Rama                        *
      *     peXpro   (input)   Codigo de Producto                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVIV_chkVivProducto...
     P                 B                   export
     D SVPVIV_chkVivProducto...
     D                 pi              n
     D   peCviv                       3  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const

     D k1y102          ds                  likerec(s1t1021:*key)

      /free

       SVPVIV_inz();

       k1y102.t@rama = peRama;
       k1y102.t@xpro = peXpro;
       k1y102.t@cviv = peCviv;
       setll %kds( k1y102 ) set1021;
       reade %kds( k1y102 ) set1021;

       dow not %eof ( set1021 );

         if ( t@cviv = peCviv );
           return *On;
         endif;

         reade %kds( k1y102 ) set1021;

       enddo;

       SetError( SVPVIV_VIVNR
               : 'Tipo de Vivienda No Relacionada al Producto' );

       return *Off;

      /end-free

     P SVPVIV_chkVivProducto...
     P                 E

      * ------------------------------------------------------------ *
      * SVPVIV_getVivProducto(): Retorna Codigo de Vivienda por      *
      *                          defecto relacionado al Producto     *
      *                                                              *
      *     peRama   (input)   Codigo de Rama                        *
      *     peXpro   (input)   Codigo de Producto                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPVIV_getVivProducto...
     P                 B                   export
     D SVPVIV_getVivProducto...
     D                 pi             3  0
     D   peRama                       2  0 const
     D   peXpro                       3  0 const

     D k1y102          ds                  likerec(s1t1021:*key)

      /free

       SVPVIV_inz();

       k1y102.t@rama = peRama;
       k1y102.t@xpro = peXpro;
       chain %kds( k1y102 : 2 ) set102101;

       if not %found( set102101 );

         chain %kds( k1y102 : 2 ) set1021;

       endif;

       return t@cviv;

      /end-free

     P SVPVIV_getVivProducto...
     P                 E
