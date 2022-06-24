     H nomain
      * ************************************************************ *
      * SPVCBU: Programa de Servicio.                                *
      *         Mantenimiento de CBU.                                *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     28-Nov-2013             *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SFA 16/12/2013 Numero de cuenta se identa a izquierda        *
      * SFA 23/06/2014 Se corrige SPVCBU_SetCBUEntero                *
      * JSN 06/05/2019 Se agrega procedimiento SPVCBU_getCuenta      *
      * LRG 30/07/2020 Se agrega procedimiento SPVCBU_setBLoqueo     *
      *                Modifica SPVCBU_SetCBUEntero si existe CBU    *
      *                lo habilita.                                  *
      * ERC 11/11/2020 Se controla que no ingrese el CBU de HDI.     *
      * ERC1 26/07/2021 Se controla que no ingrese el CBU del Banco  *
      *                 Brubank.(Cod.143)                            *
      * JSN 22/06/2021 Se agrega el procedimiento _enmascararNumero  *
      * ERC2 21/12/2021 Se controla que no ingrese el CBU del Banco  *
      *                 Del Sol.(Cod.310)                            *
      * SGF  20/01/2022 Grabar DFNCBU en GNHDCB.                     *
      * ERC3 10/02/2022 Se habilita que pueda ingresar el CBU del    *
      *                 Banco Brubank.(Cod.143)                      *
      * NWN  10/03/2022 Se agrega procedimiento SPVCBU_getCbu25a22
      *
      * ************************************************************ *
     Fcntbco    if   e           k disk    usropn
     Fcntbcs    if   e           k disk    usropn
     Fgnhdcb    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
     D/copy './qcpybooks/spvcbu_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrCode         s             10i 0
     D ErrText         s             80a

      * --------------------------------------------------- *
      * Setea cuenta con todos ceros a izquierda
      * --------------------------------------------------- *
     D CerosIzq        pr            25
     D  Numero                       25    const

     D Numero          s             25

      * --------------------------------------------------- *
      * Setea vector para digitos verificadores
      * --------------------------------------------------- *
     D ArrayDig        pr              n
     D  arDig1                        1  0 dim(25)
     D  arDig2                        1  0 dim(25)

     D arDig1          s              1  0 dim(25)
     D arDig2          s              1  0 dim(25)

     D PsDs           sds                  qualified
     D  user                         10a   overlay(psds:358)

      *--- PR Externos --------------------------------------------- *
     D SP0064U         pr                  extpgm('SP0064U')
     D    ivbc                        3  0 const
     D    ivsu                        3  0
     D    tcta                        2  0
     D    ncta                       25
     D    erro                        1

     D SP0066          pr                  extpgm('SP0066')
     D    ivbc                        3  0 const
     D    ivsu                        3  0
     D    tcta                        2  0
     D    ncta                       25
     D    erro                        1

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SPVCBU_CheckCodBanco(): Valida Codigo de Banco               *
      *                                                              *
      *     peIvbc   (input)   Codigo de Banco                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_CheckCodBanco...
     P                 B                   export
     D SPVCBU_CheckCodBanco...
     D                 pi              n
     D   peIvbc                       3  0 const

      /free

       SPVCBU_Inz();

       setll peIvbc cntbco;

       if %equal;
         return *On;
       else;
         SetError( SPVCBU_BCONF
                 : 'Banco Inexistente' );
         return *Off;
       endif;

      /end-free

     P SPVCBU_CheckCodBanco...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_CheckCodSucBanco(): Valida Codigo de Sucursal         *
      *                                                              *
      *     peIvbc   (input)   Codigo de Banco                       *
      *     peIvsu   (input)   Codigo de Sucursal                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_CheckCodSucBanco...
     P                 B                   export
     D SPVCBU_CheckCodSucBanco...
     D                 pi              n
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 const

     D k1ybcs          ds                  likerec(c1tbcs:*key)

      /free

       SPVCBU_Inz();

       if not SPVCBU_CheckCodBanco ( peIvbc );
         return *Off;
       else;
         k1ybcs.sbivbc = peIvbc;
         k1ybcs.sbivsu = peIvsu;
         setll %kds(k1ybcs) cntbcs;

         if %equal;
           return *On;
         else;
           SetError( SPVCBU_BSUNF
                   : 'Sucursal Inexistente' );
           return *Off;
         endif;

       endif;


      /end-free

     P SPVCBU_CheckCodSucBanco...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_CheckTipoCuenta(): Valida Tipo de Cuenta              *
      *                                                              *
      *     peTcta   (input)   Tipo de Cuenta                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_CheckTipoCuenta...
     P                 B                   export
     D SPVCBU_CheckTipoCuenta...
     D                 pi              n
     D   peTcta                       2  0 const

      /free

       SPVCBU_Inz();

       if peTcta = 0;
         SetError( SPVCBU_TCTBL
                 : 'Tipo de Cuenta en Blanco' );
         return *Off;
       else;
         return *On;
       endif;

      /end-free

     P SPVCBU_CheckTipoCuenta...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_Check1erDigVerif(): Valida Digito Verificador 1       *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_Check1erDigVerif...
     P                 B                   export
     D SPVCBU_Check1erDigVerif...
     D                 pi              n
     D   peNcbu                      25    const

     D @@Ncbu          s             25
     D @@dig1          s              1  0
     D @1dig1          s              1  0
     D @1dig2          s              1  0
     D @aDig1          s              1  0 dim(25)
     D @aDig2          s              1  0 dim(25)
     D cbu             s              1    dim(25)
     D @@aux1          s              3  0
     D @@aux2          s              3  0
     D @@cdv1          s              1  0
     D dvr             s              1  0
     D x               s              2  0

      /free

       SPVCBU_Inz();

       @@Ncbu = CerosIzq ( peNcbu );

       ArrayDig ( @aDig1
                : @aDig2 );

      /end-free

     C                   movea     @@Ncbu        cbu

     C                   eval      x = 1
     C                   clear                   @@aux2
     C                   dou       x = 25
     C                   move      cbu(x)        @@cdv1
     C                   eval      @@aux1 = @@cdv1 * @aDig1(x)
     C                   add       @@aux1        @@aux2
     C                   add       1             x
     C                   enddo
     C                   z-add     @@aux2        @@cdv1
     C     10            sub       @@cdv1        @@cdv1
     C                   eval      @@dig1 = @@cdv1

      /free

       SPVCBU_GetDigitosVerif ( peNcbu
                              : @1dig1
                              : @1dig2 );

       if @1dig1 <> @@dig1;
         SetError( SPVCBU_D1INV
                 : 'Error de Digito Verificador 1');
         return *Off;
       else;
         return *On;
       endif;

      /end-free

     P SPVCBU_Check1erDigVerif...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_Check2doDigVerif(): Valida Digito Verificador 2       *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_Check2doDigVerif...
     P                 B                   export
     D SPVCBU_Check2doDigVerif...
     D                 pi              n
     D   peNcbu                      25    const

     D @@Ncbu          s             25
     D @@dig2          s              1  0
     D @1dig1          s              1  0
     D @1dig2          s              1  0
     D @aDig1          s              1  0 dim(25)
     D @aDig2          s              1  0 dim(25)
     D cbu             s              1    dim(25)
     D @@aux1          s              3  0
     D @@aux2          s              3  0
     D @@cdv2          s              1  0
     D dvr             s              1  0
     D x               s              2  0

      /free

       SPVCBU_Inz();

       @@Ncbu = CerosIzq ( peNcbu );

       ArrayDig ( @aDig1
                : @aDig2 );

      /end-free

     C                   movea     @@Ncbu        cbu
     C                   eval      x = 1
     C                   clear                   @@aux2
     C                   dou       x = 25
     C                   move      cbu(x)        @@cdv2
     C                   eval      @@aux1 = @@cdv2 * @aDig2(x)
     C                   add       @@aux1        @@aux2
     C                   add       1             x
     C                   enddo
     C                   z-add     @@aux2        @@cdv2
     C     10            sub       @@cdv2        @@cdv2
     C                   eval      @@dig2 = @@cdv2

      /free

       SPVCBU_GetDigitosVerif ( peNcbu
                              : @1dig1
                              : @1dig2 );

       if @1dig2 <> @@dig2;
         SetError( SPVCBU_D2INV
                 : 'Error de Digito Verificador 2');
         return *Off;
       else;
         return *On;
       endif;

      /end-free

     P SPVCBU_Check2doDigVerif...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_GetDigitosVerif(): Retorna Digitos Verificadores      *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *     peVer1   (output)  1er Digito Verificador                *
      *     peVer2   (output)  2do Digito Verificador                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_GetDigitosVerif...
     P                 B                   export
     D SPVCBU_GetDigitosVerif...
     D                 pi              n
     D   peNcbu                      25    const
     D   peVer1                       1  0
     D   peVer2                       1  0

     D @@Ncbu          s             25

      /free

       SPVCBU_Inz();

       @@Ncbu = CerosIzq ( peNcbu );

       monitor;
         peVer1 = %dec(%subst(@@Ncbu:11:1):1:0);
         peVer2 = %dec(%subst(@@Ncbu:25:1):1:0);
       on-error;
         return *Off;
       endmon;

       return *On;

      /end-free

     P SPVCBU_GetDigitosVerif...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_GetCBUSeparado(): Recupera CBU en Campos Separados    *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *     peIvbc   (Output)  Codigo de Banco                       *
      *     peIvsu   (Output)  Codigo de Sucursal                    *
      *     peTcta   (Output)  Tipo de Cuenta                        *
      *     peNcta   (Output)  Numero de Cuenta                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_GetCBUSeparado...
     P                 B                   export
     D SPVCBU_GetCBUSeparado...
     D                 pi              n
     D   peNcbu                      25    const
     D   peIvbc                       3  0
     D   peIvsu                       3  0
     D   peTcta                       2  0
     D   peNcta                      25

     D @@Ncbu          s             25
     D @@Ncta          s             11

      /free

       SPVCBU_Inz();

       @@Ncbu = CerosIzq ( peNcbu );

       @@Ncta = %subst(@@Ncbu:14:11);
       evalr peNcta = @@Ncta;

       monitor;
         peIvbc = %dec(%subst(@@Ncbu:4:3):3:0);
         peIvsu = %dec(%subst(@@Ncbu:8:3):3:0);
         peTcta = %dec(%subst(@@Ncbu:12:2):2:0);
       on-error;
         return *Off;
       endmon;

       if not SPVCBU_CheckCodBanco ( peIvbc );
         return *off;
       endif;

       if not SPVCBU_CheckCodSucBanco ( peIvbc
                                      : peIvsu );
         return *off;
       endif;

       if not SPVCBU_Check1erDigVerif ( @@Ncbu );
         return *off;
       endif;

       if not SPVCBU_Check2doDigVerif ( @@Ncbu );
         return *off;
       endif;

       return *On;

      /end-free

     P SPVCBU_GetCBUSeparado...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_GetCBUEntero(): Recupera CBU en un Solo Campo         *
      *                                                              *
      *     peIvbc   (input)   Codigo de Banco                       *
      *     peIvsu   (input)   Codigo de Sucursal                    *
      *     peTcta   (input)   Tipo de Cuenta                        *
      *     peNcta   (input)   Numero de CBU                         *
      *                                                              *
      * Retorna: Nro de CBU / -1 en Caso de Error                    *
      * ------------------------------------------------------------ *

     P SPVCBU_GetCBUEntero...
     P                 B                   export
     D SPVCBU_GetCBUEntero...
     D                 pi            25
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 const
     D   peTcta                       2  0 const
     D   peNcta                      25    const

     D@@Ivsu           s              3  0
     D@@Tcta           s              2  0
     D@@Ncta           s             25
     D@error           s              1

      /free

       SPVCBU_Inz();

       @@Ivsu = peIvsu;
       @@Tcta = peTcta;
       @@Ncta = peNcta;

       SP0064U ( peIvbc
               : @@Ivsu
               : @@Tcta
               : @@Ncta
               : @error );

       select;
       when @error = '1';
         SetError( SPVCBU_BCINV
                 : 'Error de Banco' );
         return *Blanks;
       when @error = '2';
         SetError( SPVCBU_BSINV
                 : 'Error de Sucursal' );
         return *Blanks;
       when @error = '3';
         SetError( SPVCBU_CTINV
                 : 'Error en Tipo de Cuenta' );
         return *Blanks;
       when @error = '4';
         SetError( SPVCBU_NCINV
                 : 'Error en Nro. de Cuenta' );
         return *Blanks;
       when @error = '5';
         SetError( SPVCBU_D1INV
                 : 'Error de Digito Verificador 1' );
         return *Blanks;
       when @error = '6';
         SetError( SPVCBU_D2INV
                 : 'Error de Digito Verificador 2' );
         return *Blanks;
       other;
         return @@Ncta;
       endsl;

      /end-free

     P SPVCBU_GetCBUEntero...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_SetCBUEntero(): Graba CBU Desde un Solo Campo         *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *     peNrdf   (input)   Numero de Persona                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_SetCBUEntero...
     P                 B                   export
     D SPVCBU_SetCBUEntero...
     D                 pi              n
     D   peNcbu                      25    const
     D   peNrdf                       7  0 const
     D   peUser                      10    options(*nopass:*omit)
     D   peMar1                       1    options(*nopass:*omit)

     D k1ydcb          ds                  likerec(g1hdcb:*key)

     D@@Ivbc           s              3  0
     D@@Ivsu           s              3  0
     D@@Tcta           s              2  0
     D@@Ncta           s             25
     D @user           s             10a

      /free

       SPVCBU_Inz();

       if %parms >= 3 and %addr(peUser) <> *null;
          @user = peUser;
        else;
          @user = PsDs.user;
       endif;

           if peNcbu = '0150931502000004416050   ' or
              peNcbu = '0070999020000051878944   ' or
              peNcbu = '0270100010000490110013   ' or
              peNcbu = '2850000330000800745601   ' or
              peNcbu = '0720420720000000000240   ';

              SetError( SPVCBU_CBUHDI
                 : 'El número de CBU es inválido.' );
              return *Off;
           endif;

     ***   if %subst(peNcbu:1:3) = '143';
     ***      SetError( SPVCBU_CBUHDI
     ***         : 'El número de CBU es inválido.' );
     ***      return *Off;
     ***   endif;

           if %subst(peNcbu:1:3) = '310';
              SetError( SPVCBU_CBUHDI
                 : 'El número de CBU es inválido.' );
              return *Off;
           endif;

       if SPVCBU_GetCBUSeparado ( peNcbu
                                : @@ivbc
                                : @@ivsu
                                : @@tcta
                                : @@ncta );

         k1ydcb.dfnrdf = peNrdf;
         k1ydcb.dfivbc = @@ivbc;
         k1ydcb.dfivsu = @@ivsu;
         k1ydcb.dftcta = @@tcta;
         k1ydcb.dfncta = @@ncta;

         setll %kds(k1ydcb) gnhdcb;
         if not %equal;
           dfnrdf = peNrdf;
           dfivbc = @@ivbc;
           dfivsu = @@ivsu;
           dftcta = @@tcta;
           dfncta = @@ncta;
           dfuser = @user;
           dfbloq = 'N';
           if %parms >= 4 and %addr(peMar1) <> *NULL;
             dfmb01 = peMar1;
           endif;
           dfncbu = %trim(peNcbu);
           write g1hdcb;
           return *On;
         else;
           chain %kds(k1ydcb) gnhdcb;
           if %found();
              dfbloq = 'N';
              dfncbu = %trim(peNcbu);
              update g1hdcb;
              return *On;
           endif;
         //SetError( SPVCBU_CBUDU
         //        : 'Registro Duplicado' );
         //return *Off;
         endif;
       else;
         return *Off;
       endif;

      /end-free

     P SPVCBU_SetCBUEntero...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVCBU_inz      B                   export
     D SPVCBU_inz      pi

      /free

       if not %open(cntbco);
         open cntbco;
       endif;

       if not %open(cntbcs);
         open cntbcs;
       endif;

       if not %open(gnhdcb);
         open gnhdcb;
       endif;

       return;

      /end-free

     P SPVCBU_inz      E

      * ------------------------------------------------------------ *
      * SPVCBU_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVCBU_End      B                   export
     D SPVCBU_End      pi

      /free

       if %open(cntbco);
         close cntbco;
       endif;

       if %open(cntbcs);
         close cntbcs;
       endif;

       if %open(gnhdcb);
         close gnhdcb;
       endif;

       return;

      /end-free

     P SPVCBU_End      E

      * ------------------------------------------------------------ *
      * SPVCBU_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SPVCBU_Error    B                   export
     D SPVCBU_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SPVCBU_Error    E

      * ------------------------------------------------------------ *
      * CerosIzq(): Rellena con Ceros a Izquierda                    *
      *                                                              *
      *     peNume   (input)   Número                                *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P CerosIzq        B
     D CerosIzq        pi            25
     D  peNume                       25    const

     D wrk             s              1    dim(25)
     D cbu             s              1    dim(25)
     D @cbu            s             25
     D x               s              2  0
     D y               s              2  0

     C                   eval      x = 25
     C                   eval      y = 25
     C                   move      *all'0'       cbu
     C                   movea     peNume        wrk
     C                   dou       x = *zeros
     C                   if        wrk(x) = '0'  or
     C                             wrk(x) = '1'  or
     C                             wrk(x) = '2'  or
     C                             wrk(x) = '3'  or
     C                             wrk(x) = '4'  or
     C                             wrk(x) = '5'  or
     C                             wrk(x) = '6'  or
     C                             wrk(x) = '7'  or
     C                             wrk(x) = '8'  or
     C                             wrk(x) = '9'
     C                   eval      cbu(y) = wrk(x)
     C                   eval      y = y - 1
     C                   endif
     C                   eval      x = x - 1
     C                   enddo
     C                   movea     cbu           @cbu
     C                   return    @cbu

     P CerosIzq...
     P                 E

      * ------------------------------------------------------------ *
      * ArrayDig(): vector para digitos verificadores                *
      *                                                              *
      *     peArra   (input)   Vector                                *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P ArrayDig        B
     D ArrayDig        pi              n
     D  arDig1                        1  0 dim(25)
     D  arDig2                        1  0 dim(25)

      /free

          arDig1(1) = 0;
          arDig1(2) = 0;
          arDig1(3) = 0;
          arDig1(4) = 7;
          arDig1(5) = 1;
          arDig1(6) = 3;
          arDig1(7) = 9;
          arDig1(8) = 7;
          arDig1(9) = 1;
          arDig1(10) = 3;
          arDig1(11) = 0;
          arDig1(12) = 0;
          arDig1(13) = 0;
          arDig1(14) = 0;
          arDig1(15) = 0;
          arDig1(16) = 0;
          arDig1(17) = 0;
          arDig1(18) = 0;
          arDig1(19) = 0;
          arDig1(20) = 0;
          arDig1(21) = 0;
          arDig1(22) = 0;
          arDig1(23) = 0;
          arDig1(24) = 0;
          arDig1(25) = 0;

          arDig2(1) = 0;
          arDig2(2) = 0;
          arDig2(3) = 0;
          arDig2(4) = 0;
          arDig2(5) = 0;
          arDig2(6) = 0;
          arDig2(7) = 0;
          arDig2(8) = 0;
          arDig2(9) = 0;
          arDig2(10) = 0;
          arDig2(11) = 0;
          arDig2(12) = 3;
          arDig2(13) = 9;
          arDig2(14) = 7;
          arDig2(15) = 1;
          arDig2(16) = 3;
          arDig2(17) = 9;
          arDig2(18) = 7;
          arDig2(19) = 1;
          arDig2(20) = 3;
          arDig2(21) = 9;
          arDig2(22) = 7;
          arDig2(23) = 1;
          arDig2(24) = 3;
          arDig2(25) = 0;

          return *On;

      /end-free

     P ArrayDig...
     P                 E
      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peEnum   (input)   Número de error a setear.             *
      *     peText   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peEnum                       10i 0 const
     D  peText                       80a   const

      /free

       ErrCode = peEnum;
       ErrText = peText;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_GetCuenta(): Recupera datos de la cuenta con el Núme- *
      *                     ro de Asegurado                          *
      *                                                              *
      *     peNrdf   (input)   Número de Asegurado                   *
      *     peIvbc   (Output)  Código de Banco                       *
      *     peIvsu   (Output)  Código de Sucursal                    *
      *     peTcta   (Output)  Tipo de Cuenta                        *
      *     peNcta   (Output)  Número de Cuenta                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVCBU_GetCuenta...
     P                 B                   export
     D SPVCBU_GetCuenta...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peIvbc                       3  0
     D   peIvsu                       3  0
     D   peTcta                       2  0
     D   peNcta                      25

     D k1ydcb          ds                  likerec(g1hdcb:*key)

      /free

       SPVCBU_Inz();

       k1ydcb.dfNrdf = peNrdf;
       setll    %kds( k1ydcb : 1 ) gnhdcb;
       reade(n) %kds( k1ydcb : 1 ) gnhdcb;
       dow not %eof( gnhdcb );

         if dfBloq = 'N';
           peIvbc = dfIvbc;
           peIvsu = dfIvsu;
           peTcta = dfTcta;
           peNcta = dfNcta;
           return *on;
         endif;

         reade(n) %kds( k1ydcb : 1 ) gnhdcb;

       enddo;

       return *off;

      /end-free

     P SPVCBU_GetCuenta...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_setBloqueo : Bloquea CBU                              *
      *                                                              *
      *     peNrdf ( input ) Número de Asegurado                     *
      *     peIvbc ( input ) Código de Banco                         *
      *     peIvsu ( input ) Código de Sucursal                      *
      *     peTcta ( input ) Tipo de Cuenta                          *
      *     peNcta ( input ) Número de Cuenta                        *
      *     peUser ( input ) Usuario                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVCBU_setBloqueo...
     P                 B                   export
     D SPVCBU_setBloqueo...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peIvbc                       3  0
     D   peIvsu                       3  0
     D   peTcta                       2  0
     D   peNcta                      25
     D   peUser                      10    const

      /free

       SPVCBU_inz();

       setll peNrdf gnhdcb;
       reade peNrdf gnhdcb;
       dow not %eof( gnhdcb );
4b     if dfbloq <> 'F' and dfbloq <> 'R' and
            ( dfivbc <> peivbc or dfivsu <> peivsu or
              dftcta <> petcta or dfncta <>  pencta   );
           dfbloq = 'F';
4e     endif;

         dffbta = *year;
         dffbtm = *month;
         dffbtd = *day;
         dfuser = peUser;
         monitor;
           update g1hdcb;
         on-error;
           return *off;
         endmon;
         reade peNrdf gnhdcb;
       enddo;

       return *on;

      /end-free

     P SPVCBU_setBloqueo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVCBU_enmascararNumero(): Enmascarar número de CBU          *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *     peCara   (input)   Caracter Sustituto                    *
      *     peCant   (input)   Cantidad de Nro. visibles             *
      *                                                              *
      * Retorna: Número de CBU con Mascara                           *
      * ------------------------------------------------------------ *

     P SPVCBU_enmascararNumero...
     P                 B                   export
     D SPVCBU_enmascararNumero...
     D                 pi            25
     D   peNcbu                      25    const
     D   peCara                       1    const
     D   peCant                      25  0 const

     D i               s             10i 0
     D x               s             10i 0
     D nro_ed          s             25

      /free

       i = 0;
       nro_ed = peNcbu;
       for x = 25 downto 1;
         if %subst(nro_ed:x:1) <> ' ';
           i += 1;
           if i > peCant;
             %subst(nro_ed:x:1) = peCara;
           endif;
         endif;
       endfor;

       return nro_ed;

      /end-free

     P SPVCBU_enmascararNumero...
     P                 E
      * ------------------------------------------------------------ *
      * SPVCBU_getCbu25a22() : Muevo de CBU de 25 Caracteres a       *
      *                        CBU de 22 Caracteres                  *
      *                                                              *
      *   peNcbu25 (input)   Numero de CBU de 25 Caracteres          *
      *   peNcbu22 (Output)  Numero de CBU de 22 Caracteres          *
      *                                                              *
      * Retorna: Número de CBU                                       *
      * ------------------------------------------------------------ *

     P SPVCBU_getCbu25a22...
     P                 B                   export
     D SPVCBU_getCbu25a22...
     D                 pi            22
     D   peNcbu                      25    const

     D nuevoCbu        s             22a
     D arc             s             22a
     D x               s             10i 0

      /free

       x = %check(' ':peNcbu);

       if x = 0;
          return *blanks;
        else;
          nuevoCbu = %subst(peNcbu:x:22);
       endif;

       nuevoCbu = %scanrpl( ' ' : '0' : nuevoCbu);


       return nuevoCbu;

      /end-free

     P SPVCBU_getCbu25a22...
     P                 E
