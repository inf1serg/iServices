     H nomain
      * ************************************************************ *
      * SPVFEC: Programa de Servicio.                                *
      *         Administracion de Fechas.                            *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     02-Sep-2013             *
      * ************************************************************ *

      *--- Copy H -------------------------------------------------- *
     D/copy './qcpybooks/spvfec_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrCode         s             10i 0
     D ErrText         s             80a

      *--- PR Externos --------------------------------------------- *
     D PAR310X3        pr                  extpgm('PAR310X3')
     D    Empr                        1    const
     D    @aÑo                        4  0
     D    @mes                        2  0
     D    @dia                        2  0

     D SPDFEC          pr                  extpgm('SPDFEC')
     D    fiod                        2  0 const
     D    fiom                        2  0 const
     D    fioa                        4  0 const
     D    fhfd                        2  0 const
     D    fhfm                        2  0 const
     D    fhfa                        4  0 const
     D    dife                        5  0

     D SPDFECH         pr                  extpgm('SPDFECH')
     D    fecd                        8  0 const
     D    fech                        8  0 const
     D    dife                        6  0

     D SPFHAB          pr                  extpgm('SPFHAB')
     D    fech                        8  0 const
     D    hafe                        1

     D SPFINT          pr                  extpgm('SPFINT')
     D    Desd                        8  0 const
     D    Hast                        8  0 const
     D    Fech                        8  0 const
     D    hafe                        1

     D SPMFEC          pr                  extpgm('SPMFEC')
     D    dia1                        2  0 const
     D    mes1                        2  0 const
     D    aÑo1                        4  0 const
     D    dia2                        2  0 const
     D    mes2                        2  0 const
     D    aÑo2                        4  0 const
     D    mayo                        1

     D SPOPFECH        pr                  extpgm('SPOPFECH')
     D  fech                          8  0 const
     D  sign                          1a   const
     D  tipo                          1a   const
     D  cant                          5  0 const
     D  fech                          8  0
     D  erro                          1a
     D  ffec                          3a   options(*nopass)

     D SPULDI          pr                  extpgm('SPULDI')
     D  fech                          8    const

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SPVFEC_FecDeHoy8(): Fecha de Hoy 8 Digitos                   *
      *                                                              *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha de Hoy 8 Digitos                              *
      * ------------------------------------------------------------ *

     P SPVFEC_FecDeHoy8...
     P                 B                   export
     D SPVFEC_FecDeHoy8...
     D                 pi             8  0
     D   peTipo                       3a   const options(*RIGHTADJ)

     D@Fech            s              8  0
     D@aÑo             s              4  0
     D@mes             s              2  0
     D@dia             s              2  0

      /free

       SPVFEC_Inz();

       PAR310X3( 'A'
               : @aÑo
               : @mes
               : @dia );
       @fech = @aÑo*10000+@mes*100+@dia;

       select;
       when peTipo = 'AMD';
         return @fech;
       when peTipo = 'DMA';
         return SPVFEC_GiroFecha8 ( @fech
                                  : peTipo );
       other;
         SetError( SPVFEC_TGINV
                 : 'Tipo de Giro Invalido' );
         return 0;
       endsl;

      /end-free

     P SPVFEC_FecDeHoy8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FecDeHoy6(): Fecha de Hoy 6 Digitos                   *
      *                                                              *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha de Hoy 6 Digitos                              *
      * ------------------------------------------------------------ *

     P SPVFEC_FecDeHoy6...
     P                 B                   export
     D SPVFEC_FecDeHoy6...
     D                 pi             6  0
     D   peTipo                       3a   const options(*RIGHTADJ)

     D@Fech            s              8  0

      /free

       SPVFEC_Inz();

       @fech = SPVFEC_FecDeHoy8 ( 'AMD' );

       select;
       when peTipo = 'AMD';
         return SPVFEC_Convert8a6 ( @fech );
       when peTipo = 'DMA';
         @fech = SPVFEC_Convert8a6 ( @fech );
         return SPVFEC_GiroFecha6 ( @fech
                                   : peTipo );
       other;
         SetError( SPVFEC_TGINV
                 : 'Tipo de Giro Invalido' );
         return 0;
       endsl;

      /end-free

     P SPVFEC_FecDeHoy6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_GiroFecha8(): Gira Fecha de 8 Digitos a AMD/DMA       *
      *                                                              *
      *     peFein   (input)   Fecha Input (AAAAMMDD/DDMMAAAA)       *
      *     peTipo   (input)   Tipo de Giro (DMA/AMD)                *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     P SPVFEC_GiroFecha8...
     P                 B                   export
     D SPVFEC_GiroFecha8...
     D                 pi             8  0
     D   peFein                       8  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

     D                 ds                  inz
     Dp@famd                  01     08  0
     D@@aÑo                   01     04  0
     D@@mes                   05     06  0
     D@@dia                   07     08  0
     D                 ds                  inz
     Dp@fdma                  01     08  0
     D$$dia                   01     02  0
     D$$mes                   03     04  0
     D$$aÑo                   05     08  0

      /free

       SPVFEC_Inz();

       select;
       when peTipo = 'AMD';
         p@fdma = peFein;
         @@mes = $$mes;
         @@aÑo = $$aÑo;
         @@dia = $$dia;
         return p@famd;
       when peTipo = 'DMA';
         p@famd = peFein;
         $$aÑo = @@aÑo;
         $$mes = @@mes;
         $$dia = @@dia;
         return p@fdma;
       other;
         SetError( SPVFEC_TGINV
                 : 'Tipo de Giro Invalido' );
         return 0;
       endsl;

      /end-free

     P SPVFEC_GiroFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_GiroFecha6(): Gira Fecha de 6 Digitos a AMD/DMA       *
      *                                                              *
      *     peFein   (input)   Fecha Input (AAMMDD/DDMMAA)           *
      *     peTipo   (input)   Tipo de Giro (DMA/AMD)                *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     P SPVFEC_GiroFecha6...
     P                 B                   export
     D SPVFEC_GiroFecha6...
     D                 pi             6  0
     D   peFein                       6  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

     D                 ds                  inz
     Dp@famd                  01     06  0
     D@@aÑo                   01     02  0
     D@@mes                   03     04  0
     D@@dia                   05     06  0
     D                 ds                  inz
     Dp@fdma                  01     06  0
     D$$dia                   01     02  0
     D$$mes                   03     04  0
     D$$aÑo                   05     06  0

      /free

       SPVFEC_Inz();

       select;
       when peTipo = 'AMD';
         p@fdma = peFein;
         @@aÑo = $$aÑo;
         @@mes = $$mes;
         @@dia = $$dia;
         return p@famd;
       when peTipo = 'DMA';
         p@famd = peFein;
         $$aÑo = @@aÑo;
         $$mes = @@mes;
         $$dia = @@dia;
         return p@fdma;
       other;
         SetError( SPVFEC_TGINV
                 : 'Tipo de Giro Invalido' );
         return 0;
       endsl;

      /end-free

     P SPVFEC_GiroFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_Convert8a6(): Modifica Fecha de 8 Digitos a 6         *
      *                                                              *
      *     peFech   (input)   Fecha 8 Digitos AAAAMMDD              *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     P SPVFEC_Convert8a6...
     P                 B                   export
     D SPVFEC_Convert8a6...
     D                 pi             6  0
     D   peFech                       8  0 const

     D                 ds                  inz
     Dp@famd                  01     08  0
     D@@aÑo                   01     04  0
     D@@mes                   05     06  0
     D@@dia                   07     08  0
     D                 ds                  inz
     Dp6famd                  01     06  0
     D$$aÑo                   01     02  0
     D$$mes                   03     04  0
     D$$dia                   05     06  0
     D                 ds                  inz
     Dp@aaaa                  01     04  0
     D$$aad                   01     02  0
     D$$aaa                   03     04  0

      /free

       SPVFEC_Inz();

       p@famd = peFech;
       $$dia = @@dia;
       $$mes = @@mes;
       p@aaaa = @@aÑo;
       $$aÑo = $$aaa;

       return p6famd;

      /end-free

     P SPVFEC_Convert8a6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_Convert6a8(): Modifica Fecha de 6 Digitos a 8         *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha 6 Digitos AAMMDD                *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     P SPVFEC_Convert6a8...
     P                 B                   export
     D SPVFEC_Convert6a8...
     D                 pi             8  0
     D   peFech                       6  0 const

     D@@fech           s              8  0
     D@@aaaa           s              4  0
     D                 ds                  inz
     Dp@fdma                  01     06  0
     D$$aÑo                   01     02  0
     D$$mes                   03     04  0
     D$$dia                   05     06  0

      /free

       SPVFEC_Inz();

       p@fdma = peFech;
       @@aaaa = 2000 + $$aÑo;
       @@fech = @@aaaa*10000+$$mes*100+$$dia;

       return @@fech;

      /end-free

     P SPVFEC_Convert6a8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreFecha8(): Calcula Dias Entre Fechas 8 Digitos*
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAAAMMDD)                *
      *     peFech   (input)   Fecha Hasta (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Dias entre las fechas                               *
      * ------------------------------------------------------------ *

     P SPVFEC_DiasEntreFecha8...
     P                 B                   export
     D SPVFEC_DiasEntreFecha8...
     D                 pi             5  0
     D   peFecd                       8  0 const
     D   peFech                       8  0 options(*nopass:*omit)

     D @@diff          s              5  0
     D                 ds                  inz
     Dp1famd                  01     08  0
     D@1aÑo                   01     04  0
     D@1mes                   05     06  0
     D@1dia                   07     08  0
     D                 ds                  inz
     Dp2famd                  01     08  0
     D@2aÑo                   01     04  0
     D@2mes                   05     06  0
     D@2dia                   07     08  0

      /free

       SPVFEC_Inz();

       p1famd = peFecd;

       if %parms >= 2 and %addr(peFech) <> *null;
         p2famd = peFech;
       else;
         p2famd = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       SPDFEC ( @1Dia
              : @1Mes
              : @1AÑo
              : @2Dia
              : @2Mes
              : @2AÑo
              : @@diff );

       return @@diff;

      /end-free

     P SPVFEC_DiasEntreFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreFecha6(): Calcula Dias Entre Fechas 6 Digitos*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAMMDD)                  *
      *     peFech   (input)   Fecha Hasta (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Dias entre las fechas                               *
      * ------------------------------------------------------------ *

     P SPVFEC_DiasEntreFecha6...
     P                 B                   export
     D SPVFEC_DiasEntreFecha6...
     D                 pi             5  0
     D   peFecd                       6  0 const
     D   peFech                       6  0 options(*nopass:*omit)

     D @@fecd          s              8  0
     D @@fech          s              8  0
     D @@diff          s              5  0

      /free

       SPVFEC_Inz();

       @@fecd = SPVFEC_Convert6a8 ( peFecd );

       if %parms >= 2 and %addr(peFech) <> *null;
         @@fech = SPVFEC_Convert6a8 ( peFech );
       else;
         @@fech = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@diff = SPVFEC_DiasEntreFecha8( @@fecd
                                      : @@fech );
       return @@diff;

      /end-free

     P SPVFEC_DiasEntreFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreHabFecha8(): Calcula Dias Habiles Entre      *
      *                             Fechas de 8 Digitos              *
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAAAMMDD)                *
      *     peFech   (input)   Fecha Hasta (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Dias habiles entre las fechas                       *
      * ------------------------------------------------------------ *

     P SPVFEC_DiasEntreHabFecha8...
     P                 B                   export
     D SPVFEC_DiasEntreHabFecha8...
     D                 pi             6  0
     D   peFecd                       8  0 const
     D   peFech                       8  0 options(*nopass:*omit)

     D @@dife          s              6  0
     D @@fech          s              8  0

      /free

       SPVFEC_Inz();

       if %parms >= 2 and %addr(peFech) <> *null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       SPDFECH ( peFecd
               : @@Fech
               : @@dife );
       return @@dife;

      /end-free

     P SPVFEC_DiasEntreHabFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreHabFecha6(): Calcula Dias Habiles Entre      *
      *                             Fechas de 6 Digitos              *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAMMDD)                  *
      *     peFech   (input)   Fecha Hasta (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Dias habiles entre las fechas                       *
      * ------------------------------------------------------------ *

     P SPVFEC_DiasEntreHabFecha6...
     P                 B                   export
     D SPVFEC_DiasEntreHabFecha6...
     D                 pi             6  0
     D   peFecd                       6  0 const
     D   peFech                       6  0 options(*nopass:*omit)

     D @@dife          s              6  0
     D @@Fecd          s              8  0
     D @@Fech          s              8  0

      /free

       SPVFEC_Inz();

       @@Fecd = SPVFEC_Convert6a8 ( peFecd );

       if %parms >= 2 and %addr(peFech) <> *null;
         @@Fech = SPVFEC_Convert6a8 ( peFech );
       else;
         @@Fech = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@dife = SPVFEC_DiasEntreHabFecha8( @@Fecd
                                        : @@Fech );
       return @@dife;

      /end-free

     P SPVFEC_DiasEntreHabFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaValida8(): Valida Fecha 8                        *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD)                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaValida8...
     P                 B                   export
     D SPVFEC_FechaValida8...
     D                 pi              n
     D   peFech                       8  0 const

     D p@fech          ds
     D  p@flap                01     05  0
     D  p@ffec                06     13  0

      /free

       SPVFEC_Inz();

       p@ffec = peFech;

       p@flap = *zeros;

      /end-free

C    C                   call      'SPFECH'
     C                   parm                    p@fech

      /free

       if p@flap = *zeros;
         SetError( SPVFEC_FEINV
                 : 'Fecha Invalida' );
         return *off;
       else;
         return *on;
       endif;

      /end-free

     P SPVFEC_FechaValida8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaValida6(): Valida Fecha 6                        *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD)                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaValida6...
     P                 B                   export
     D SPVFEC_FechaValida6...
     D                 pi              n
     D   peFech                       6  0 const

     D @@Fech          s              8  0

      /free

       SPVFEC_Inz();

       @@Fech = SPVFEC_Convert6a8 ( peFech );

       if not SPVFEC_FechaValida8 ( @@Fech );
         return *off;
       else;
         return *on;
       endif;

      /end-free

     P SPVFEC_FechaValida6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaHabil8(): Valida si la Fecha es Habil            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *     peHabi   (input)   Prox. Habil (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaHabil8...
     P                 B                   export
     D SPVFEC_FechaHabil8...
     D                 pi              n
     D   peFech                       8  0 options(*nopass:*omit)
     D   peHabi                       8  0 options(*nopass:*omit)

     D @@fech          s              8  0
     D @@hafe          s              1
     D @2fech          s              8  0
     D @2hafe          s              1

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       SPFHAB( @@Fech
             : @@hafe );

       if @@hafe = 'F';
         if %parms >= 2 and %addr(peHabi) <> *null;
           @2hafe = @@hafe;
           @2Fech = @@Fech;
           dow @2hafe = 'F';
             @2Fech = SPVFEC_SumResFecha8 ( @2Fech
                                          : '+'
                                          : 'D'
                                          : 1      );
             SPFHAB( @2Fech
                   : @2hafe );
           enddo;
           peHabi = @2Fech;
         endif;
         SetError( SPVFEC_FENHA
                 : 'Fecha No Habil' );
         return *off;
       else;
         return *on;
       endif;

      /end-free

     P SPVFEC_FechaHabil8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaHabil6(): Valida si la Fecha es Habil            *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *     peHabi   (input)   Prox. Habil (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaHabil6...
     P                 B                   export
     D SPVFEC_FechaHabil6...
     D                 pi              n
     D   peFech                       6  0 options(*nopass:*omit)
     D   peHabi                       6  0 options(*nopass:*omit)

     D @@Fech          s              8  0
     D @@Habi          s              8  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         @@Fech = peFech;
       else;
         @@Fech = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       if %parms >= 2 and %addr(peHabi) <> *null;
         if not SPVFEC_FechaHabil8( @@Fech
                                  : @@Habi );
           peHabi = SPVFEC_Convert8a6 ( @@Habi );
           return *off;
         endif;
       else;
         if not SPVFEC_FechaHabil8( @@Fech );
           return *off;
         endif;
       endif;

       return *on;

      /end-free

     P SPVFEC_FechaHabil6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaRango8(): Valida Fecha 8 Digitos Dentro del Rango*
      *                                                              *
      *     peDesd   (input)   Fecha Desde (AAAAMMDD)                *
      *     peFech   (input)   Fecha (AAAAMMDD)                      *
      *     peHast   (input)   Fecha Hasta (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaRango8...
     P                 B                   export
     D SPVFEC_FechaRango8...
     D                 pi              n
     D   peDesd                       8  0 const
     D   peFech                       8  0 const
     D   peHast                       8  0 options(*nopass:*omit)

     D @@Desd          s              8  0
     D @@Hast          s              8  0
     D @@Fech          s              8  0
     D @@resu          s              1

      /free

       SPVFEC_Inz();

       if %parms >= 3 and %addr(peHast) <> *null;
         @@Hast = SPVFEC_GiroFecha8 ( peHast
                                    : 'DMA' );
       else;
         @@Hast = SPVFEC_FecDeHoy8 ( 'DMA' );
       endif;

       @@Desd = SPVFEC_GiroFecha8 ( peDesd
                                  : 'DMA' );

       @@Fech = SPVFEC_GiroFecha8 ( peFech
                                  : 'DMA' );

       SPFINT( @@Desd
             : @@Hast
             : @@Fech
             : @@resu );

       if @@resu = '1';
         SetError( SPVFEC_FEFRA
                 : 'Fecha Fuera de Rango' );
         return *off;
       else;
         return *on;
       endif;

      /end-free

     P SPVFEC_FechaRango8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaRango6(): Valida Fecha 6 Digitos Dentro del Rango*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peDesd   (input)   Fecha Desde (AAMMDD)                  *
      *     peFech   (input)   Fecha (AAMMDD)                        *
      *     peHast   (input)   Fecha Hasta (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaRango6...
     P                 B                   export
     D SPVFEC_FechaRango6...
     D                 pi              n
     D   peDesd                       6  0 const
     D   peFech                       6  0 const
     D   peHast                       6  0 options(*nopass:*omit)

     D @@Desd          s              8  0
     D @@Hast          s              8  0
     D @@Fech          s              8  0

      /free

       SPVFEC_Inz();

       if %parms >= 3 and %addr(peHast) <> *null;
         @@Hast = SPVFEC_Convert6a8 ( peHast );
       else;
         @@Hast = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@Desd = SPVFEC_Convert6a8 ( peDesd );

       @@Fech = SPVFEC_Convert6a8 ( peFech );

       if not SPVFEC_FechaRango8 ( @@Desd
                                 : @@Fech
                                 : @@Hast );
         return *off;
       else;
         return *on;
       endif;

      /end-free

     P SPVFEC_FechaRango6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMayor8(): Devuelve Fecha 8 Digitos Mayor el Rango*
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAAAMMDD)                    *
      *     peFec2   (input)   Fecha 2 (AAAAMMDD)                    *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Mayor / 2 = Fecha 2 Mayor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaMayor8...
     P                 B                   export
     D SPVFEC_FechaMayor8...
     D                 pi             1  0
     D   peFec1                       8  0 const
     D   peFec2                       8  0 const

     D @@resu          s              1
     D                 ds                  inz
     Dp1famd                  01     08  0
     Dp1aÑo                   01     04  0
     Dp1mes                   05     06  0
     Dp1dia                   07     08  0
     D                 ds                  inz
     Dp2famd                  01     08  0
     Dp2aÑo                   01     04  0
     Dp2mes                   05     06  0
     Dp2dia                   07     08  0

      /free

       SPVFEC_Inz();

       p1famd = peFec1;
       p2famd = peFec2;

       SPMFEC( p1dia
             : p1mes
             : p1aÑo
             : p2dia
             : p2mes
             : p2aÑo
             : @@resu );

       select;
       when @@resu = '0';
         return 0;
       when @@resu = '1';
         return 1;
       when @@resu = '2';
         return 2;
       other;
         SetError( SPVFEC_FEINV
                 : 'Fecha Invalida' );
         return 3;
       endsl;

      /end-free

     P SPVFEC_FechaMayor8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMayor6(): Devuelve Fecha 6 Digitos Mayor el Rango*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAMMDD)                      *
      *     peFec2   (input)   Fecha 2 (AAMMDD)                      *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Mayor / 2 = Fecha 2 Mayor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaMayor6...
     P                 B                   export
     D SPVFEC_FechaMayor6...
     D                 pi             1  0
     D   peFec1                       6  0 const
     D   peFec2                       6  0 const

     D @@Fec1          s              8  0
     D @@Fec2          s              8  0

      /free

       SPVFEC_Inz();

       @@Fec1 = SPVFEC_Convert6a8 ( peFec1 );
       @@Fec2 = SPVFEC_Convert6a8 ( peFec2 );

       return SPVFEC_FechaMayor8 ( @@Fec1
                                 : @@Fec2 );

      /end-free

     P SPVFEC_FechaMayor6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMenor8(): Devuelve Fecha 8 Digitos Menor el Rango*
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAAAMMDD)                    *
      *     peFec2   (input)   Fecha 2 (AAAAMMDD)                    *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Menor / 2 = Fecha 2 Menor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaMenor8...
     P                 B                   export
     D SPVFEC_FechaMenor8...
     D                 pi             1  0
     D   peFec1                       8  0 const
     D   peFec2                       8  0 const

      /free

       SPVFEC_Inz();

       if SPVFEC_FechaValida8 ( peFec1 ) and SPVFEC_FechaValida8 ( peFec2 );
         select;
         when peFec1 < peFec2;
           return 1;
         when peFec2 < peFec1;
           return 2;
         other;
           return 0;
         endsl;
       else;
         SetError( SPVFEC_FEINV
                 : 'Fecha Invalida' );
         return 3;
       endif;

      /end-free

     P SPVFEC_FechaMenor8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMenor6(): Devuelve Fecha 6 Digitos Menor el Rango*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAMMDD)                      *
      *     peFec2   (input)   Fecha 2 (AAMMDD)                      *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Menor / 2 = Fecha 2 Menor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     P SPVFEC_FechaMenor6...
     P                 B                   export
     D SPVFEC_FechaMenor6...
     D                 pi             1  0
     D   peFec1                       6  0 const
     D   peFec2                       6  0 const

     D @@Fec1          s              8  0
     D @@Fec2          s              8  0

      /free

       SPVFEC_Inz();

       @@Fec1 = SPVFEC_Convert6a8 ( peFec1 );
       @@Fec2 = SPVFEC_Convert6a8 ( peFec2 );

       return SPVFEC_FechaMenor8 ( @@Fec1
                                 : @@Fec2 );

      /end-free

     P SPVFEC_FechaMenor6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_SumResFecha8(): Suma/Resta Años/Meses/Días a una Fecha*
      *                                                              *
      *     peFech   (input)   Fecha (AAAAMMDD)                      *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peTipo   (input)   Tiempo (A = Años/M = Meses/D = Días)  *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     P SPVFEC_SumResFecha8...
     P                 B                   export
     D SPVFEC_SumResFecha8...
     D                 pi             8  0
     D   peFech                       8  0 const
     D   peSign                       1a   const
     D   peTipo                       1a   const
     D   peCant                       5  0 const

     D @@resu          s              8  0
     D @@erro          s              1a
     D amd             s              3a   inz('AMD')

      /free

       SPVFEC_Inz();

       SPOPFECH ( peFech
                : peSign
                : peTipo
                : peCant
                : @@Resu
                : @@erro
                : amd );

       select;
       when @@erro = 'F';
         SetError( SPVFEC_FEINV
                 : 'Fecha Invalida' );
       when @@erro = 'S';
         SetError( SPVFEC_SGINV
                 : 'Signo Invalido' );
       when @@erro = 'T';
         SetError( SPVFEC_TIINV
                 : 'Tiempo Invalido' );
       when @@erro = 'V';
         SetError( SPVFEC_CAINV
                 : 'Cantidad Invalido' );
       when @@erro = 'R';
         SetError( SPVFEC_TGINV
                 : 'Tipo de Giro Invalido' );
       other;
         return @@resu;
       endsl;

       return 0;

      /end-free

     P SPVFEC_SumResFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_SumResFecha6(): Suma/Resta Años/Meses/Días a una Fecha*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha (AAMMDD)                        *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peTipo   (input)   Tiempo (A = Años/M = Meses/D = Días)  *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     P SPVFEC_SumResFecha6...
     P                 B                   export
     D SPVFEC_SumResFecha6...
     D                 pi             6  0
     D   peFech                       6  0 const
     D   peSign                       1a   const
     D   peTipo                       1a   const
     D   peCant                       5  0 const

     D @@fech          s              8  0
     D @@resu          s              8  0

      /free

       SPVFEC_Inz();

       @@Fech = SPVFEC_Convert6a8 ( peFech );

       @@Resu = SPVFEC_SumResFecha8 ( @@Fech
                                    : peSign
                                    : peTipo
                                    : peCant );

       if @@resu = 0;
         return 0;
       else;
         return SPVFEC_Convert8a6 ( @@Resu );
       endif;

      /end-free

     P SPVFEC_SumResFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_SumResDiaHabF8(): Suma/Resta Dia                      *
      *                                                              *
      *     peFech   (input)   Fecha (AAAAMMDD)                      *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     P SPVFEC_SumResDiaHabF8...
     P                 B                   export
     D SPVFEC_SumResDiaHabF8...
     D                 pi             8  0
     D   peFech                       8  0 const
     D   peSign                       1a   const
     D   peCant                       3  0 const

     D i               s              5  0 inz(00000)
     D @@fech          s              8  0
     D @@erro          s              5  0

      /free

       SPVFEC_Inz();

       select;
       when peSign = '+';
         @@Fech = peFech;
         dow i < peCant;
           @@Fech = SPVFEC_SumResFecha8 ( @@Fech
                                        : '+'
                                        : 'D'
                                        : 1      );
           if SPVFEC_FechaHabil8( @@Fech );
             i = i+1;
           endif;
         enddo;
       when peSign = '-';
         @@Fech = peFech;
         dow i < peCant;
           @@Fech = SPVFEC_SumResFecha8 ( @@Fech
                                        : '-'
                                        : 'D'
                                        : 1      );
           if SPVFEC_FechaHabil8( @@Fech );
             i = i+1;
           endif;
         enddo;
       other;
         SetError( SPVFEC_SGINV
                 : 'Signo Invalido' );
         return 0;
       endsl;

       return @@Fech;


      /end-free

     P SPVFEC_SumResDiaHabF8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_SumResDiaHabF6(): Suma/Resta Años/Meses/Días Habiles  *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha (AAMMDD)                        *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     P SPVFEC_SumResDiaHabF6...
     P                 B                   export
     D SPVFEC_SumResDiaHabF6...
     D                 pi             6  0
     D   peFech                       6  0 const
     D   peSign                       1a   const
     D   peCant                       3  0 const

     D @@fech          s              8  0

      /free

       SPVFEC_Inz();

       @@Fech = SPVFEC_Convert6a8 ( peFech );

       @@Fech = SPVFEC_SumResDiaHabF8 ( @@Fech
                                      : peSign
                                      : peCant );

       return SPVFEC_Convert8a6 ( @@Fech );

      /end-free

     P SPVFEC_SumResDiaHabF6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ObtDiaFecha8(): Obtiene el dia de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Dia                                                 *
      * ------------------------------------------------------------ *

     P SPVFEC_ObtDiaFecha8...
     P                 B                   export
     D SPVFEC_ObtDiaFecha8...
     D                 pi             2  0
     D   peFech                       8  0 options(*nopass:*omit)

     D                 ds                  inz
     Dp@famd                  01     08  0
     Dp@aÑo                   01     04  0
     Dp@mes                   05     06  0
     Dp@dia                   07     08  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         p@famd = peFech;
       else;
         p@famd = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       return p@dia;

      /end-free

     P SPVFEC_ObtDiaFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ObtDiaFecha6(): Obtiene el dia de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Dia                                                 *
      * ------------------------------------------------------------ *

     P SPVFEC_ObtDiaFecha6...
     P                 B                   export
     D SPVFEC_ObtDiaFecha6...
     D                 pi             2  0
     D   peFech                       6  0 options(*nopass:*omit)

     D                 ds                  inz
     Dp@famd                  01     06  0
     Dp@aÑo                   01     02  0
     Dp@mes                   03     04  0
     Dp@dia                   05     06  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         p@famd = peFech;
       else;
         p@famd = SPVFEC_FecDeHoy6 ( 'AMD' );
       endif;

       return p@dia;

      /end-free

     P SPVFEC_ObtDiaFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ObtMesFecha8(): Obtiene el dia de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Mes                                                 *
      * ------------------------------------------------------------ *

     P SPVFEC_ObtMesFecha8...
     P                 B                   export
     D SPVFEC_ObtMesFecha8...
     D                 pi             2  0
     D   peFech                       8  0 options(*nopass:*omit)

     D                 ds                  inz
     Dp@famd                  01     08  0
     Dp@aÑo                   01     04  0
     Dp@mes                   05     06  0
     Dp@dia                   07     08  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         p@famd = peFech;
       else;
         p@famd = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       return p@mes;

      /end-free

     P SPVFEC_ObtMesFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ObtMesFecha6(): Obtiene el dia de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Mes                                                 *
      * ------------------------------------------------------------ *

     P SPVFEC_ObtMesFecha6...
     P                 B                   export
     D SPVFEC_ObtMesFecha6...
     D                 pi             2  0
     D   peFech                       6  0 options(*nopass:*omit)

     D                 ds                  inz
     Dp@famd                  01     06  0
     Dp@aÑo                   01     02  0
     Dp@mes                   03     04  0
     Dp@dia                   05     06  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         p@famd = peFech;
       else;
         p@famd = SPVFEC_FecDeHoy6 ( 'AMD' );
       endif;

       return p@mes;

      /end-free

     P SPVFEC_ObtMesFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ObtAÑoFecha8(): Obtiene el aÑo de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: AÑo                                                 *
      * ------------------------------------------------------------ *

     P SPVFEC_ObtAÑoFecha8...
     P                 B                   export
     D SPVFEC_ObtAÑoFecha8...
     D                 pi             4  0
     D   peFech                       8  0 options(*nopass:*omit)

     D                 ds                  inz
     Dp@famd                  01     08  0
     Dp@aÑo                   01     04  0
     Dp@mes                   05     06  0
     Dp@dia                   07     08  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         p@famd = peFech;
       else;
         p@famd = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       return p@aÑo;

      /end-free

     P SPVFEC_ObtAÑoFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ObtAÑoFecha6(): Obtiene el aÑo de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: AÑo                                                 *
      * ------------------------------------------------------------ *

     P SPVFEC_ObtAÑoFecha6...
     P                 B                   export
     D SPVFEC_ObtAÑoFecha6...
     D                 pi             2  0
     D   peFech                       6  0 options(*nopass:*omit)

     D                 ds                  inz
     Dp@famd                  01     06  0
     Dp@aÑo                   01     02  0
     Dp@mes                   03     04  0
     Dp@dia                   05     06  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         p@famd = peFech;
       else;
         p@famd = SPVFEC_FecDeHoy6 ( 'AMD' );
       endif;

       return p@aÑo;

      /end-free

     P SPVFEC_ObtAÑoFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_AÑoBisiestoFecha8(): Obtiene si aÑo Bisiesto          *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_AÑoBisiestoFecha8...
     P                 B                   export
     D SPVFEC_AÑoBisiestoFecha8...
     D                 pi              n
     D   peFech                       8  0 options(*nopass:*omit)

     D @@aÑo           s              4  0
     D @@fech          s              8  0

      /free

       SPVFEC_Inz();

       if %parms >= 1 and %addr(peFech) <> *null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@aÑo = SPVFEC_ObtAÑoFecha8 ( @@fech );

       return %rem(@@aÑo:4) = *zeros;

      /end-free

     P SPVFEC_AÑoBisiestoFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_AÑoBisiestoFecha6(): Obtiene si aÑo Bisiesto          *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD)                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFEC_AÑoBisiestoFecha6...
     P                 B                   export
     D SPVFEC_AÑoBisiestoFecha6...
     D                 pi              n
     D   peFech                       6  0 const

     D @@aÑo           s              4  0
     D @@fech          s              8  0

      /free

       SPVFEC_Inz();

       @@fech= SPVFEC_Convert6a8 ( peFech );

       return SPVFEC_AÑoBisiestoFecha8 (@@fech);

      /end-free

     P SPVFEC_AÑoBisiestoFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ArmarFecha8(): Arma la Fecha AAAAMMDD/DDMMAAAA        *
      *                                                              *
      *     peAÑo    (input)   AÑo                                   *
      *     peMes    (input)   Mes                                   *
      *     peDia    (input)   Dia                                   *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha AAAAMMDD/DDMMAAAA                             *
      * ------------------------------------------------------------ *

     P SPVFEC_ArmarFecha8...
     P                 B                   export
     D SPVFEC_ArmarFecha8...
     D                 pi             8  0
     D   peAÑo                        4  0 const
     D   peMes                        2  0 const
     D   peDia                        2  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

     D @@fech          s              8  0

      /free

       SPVFEC_Inz();

       @@fech = peAÑo*10000+peMes*100+peDia;

       if peTipo = 'AMD';
         return @@fech;
       else;
         return SPVFEC_GiroFecha8 ( @@fech
                                  : peTipo );
       endif;

      /end-free

     P SPVFEC_ArmarFecha8...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_ArmarFecha6(): Arma la Fecha AAMMDD/DDMMAA            *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peAÑo    (input)   AÑo                                   *
      *     peMes    (input)   Mes                                   *
      *     peDia    (input)   Dia                                   *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha AAMMDD/DDMMAA                                 *
      * ------------------------------------------------------------ *

     P SPVFEC_ArmarFecha6...
     P                 B                   export
     D SPVFEC_ArmarFecha6...
     D                 pi             6  0
     D   peAÑo                        2  0 const
     D   peMes                        2  0 const
     D   peDia                        2  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

     D @@fech          s              6  0

      /free

       SPVFEC_Inz();

       @@fech = peAÑo*10000+peMes*100+peDia;

       if peTipo = 'AMD';
         return @@fech;
       else;
         return SPVFEC_GiroFecha6 ( @@fech
                                  : peTipo );
       endif;

      /end-free

     P SPVFEC_ArmarFecha6...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFEC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVFEC_inz      B                   export
     D SPVFEC_inz      pi

      /free

      /end-free

     P SPVFEC_inz      E

      * ------------------------------------------------------------ *
      * SPVFEC_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVFEC_End      B                   export
     D SPVFEC_End      pi

      /free

      /end-free

     P SPVFEC_End      E

      * ------------------------------------------------------------ *
      * SPVFEC_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SPVFEC_Error    B                   export
     D SPVFEC_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SPVFEC_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peEnum   (input)   Número de error a setear.             *
      *     peEtxt   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peEnum                       10i 0 const
     D  peEtxt                       80a   const

      /free

       ErrCode = peEnum;
       ErrText = peEtxt;

      /end-free

     P SetError...
     P                 E
