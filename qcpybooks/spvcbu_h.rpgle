      /if defined(SPVCBU_H)
      /eof
      /endif
      /define SPVCBU_H

      * Error de Banco...
     D SPVCBU_BCINV    c                   const(0001)
      * Error de Sucursal...
     D SPVCBU_BSINV    c                   const(0002)
      * Error de Tipo de Cuenta...
     D SPVCBU_CTINV    c                   const(0003)
      * Error de Numero de Cuenta...
     D SPVCBU_NCINV    c                   const(0004)
      * Error de Digito Verificador 1...
     D SPVCBU_D1INV    c                   const(0005)
      * Error de Digito Verificador 2...
     D SPVCBU_D2INV    c                   const(0006)
      * Banco Inexistente...
     D SPVCBU_BCONF    c                   const(0007)
      * Sucursal Inexistente...
     D SPVCBU_BSUNF    c                   const(0008)
      * Tipo de Cuenta en Blanco...
     D SPVCBU_TCTBL    c                   const(0009)
      * Registro Duplicado...
     D SPVCBU_CBUDU    c                   const(0010)
      * CBU incorrecto.......
     D SPVCBU_CBUHDI   c                   const(0011)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVCBU_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SPVCBU_CheckCodBanco(): Valida Codigo de Banco               *
      *                                                              *
      *     peIvbc   (input)   Codigo de Banco                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVCBU_CheckCodBanco...
     D                 pr              n
     D   peIvbc                       3  0 const

      * ------------------------------------------------------------ *
      * SPVCBU_CheckCodSucBanco(): Valida Codigo de Sucursal         *
      *                                                              *
      *     peIvbc   (input)   Codigo de Banco                       *
      *     peIvsu   (input)   Codigo de Sucursal                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVCBU_CheckCodSucBanco...
     D                 pr              n
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 const

      * ------------------------------------------------------------ *
      * SPVCBU_CheckTipoCuenta(): Valida Tipo de Cuenta              *
      *                                                              *
      *     peTcta   (input)   Tipo de Cuenta                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVCBU_CheckTipoCuenta...
     D                 pr              n
     D   peTcta                       2  0 const

      * ------------------------------------------------------------ *
      * SPVCBU_Check1erDigVerif(): Valida Digito Verificador 1       *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVCBU_Check1erDigVerif...
     D                 pr              n
     D   peNcbu                      25    const

      * ------------------------------------------------------------ *
      * SPVCBU_Check2doDigVerif(): Valida Digito Verificador 2       *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVCBU_Check2doDigVerif...
     D                 pr              n
     D   peNcbu                      25    const

      * ------------------------------------------------------------ *
      * SPVCBU_GetDigitosVerif(): Retorna Digitos Verificadores      *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *     peVer1   (output)  1er Digito Verificador                *
      *     peVer2   (output)  2do Digito Verificador                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVCBU_GetDigitosVerif...
     D                 pr              n
     D   peNcbu                      25    const
     D   peVer1                       1  0
     D   peVer2                       1  0

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

     D SPVCBU_GetCBUEntero...
     D                 pr            25
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 const
     D   peTcta                       2  0 const
     D   peNcta                      25    const

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

     D SPVCBU_GetCBUSeparado...
     D                 pr              n
     D   peNcbu                      25    const
     D   peIvbc                       3  0
     D   peIvsu                       3  0
     D   peTcta                       2  0
     D   peNcta                      25

      * ------------------------------------------------------------ *
      * SPVCBU_SetCBUEntero(): Graba CBU Desde un Solo Campo         *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *     peNrdf   (input)   Numero de Persona                     *
      *     peUser   (input)   Usuario                               *
      *     peMar1   (input)   '2' Ahorro '3' Cta Cte                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVCBU_SetCBUEntero...
     D                 pr              n
     D   peNcbu                      25    const
     D   peNrdf                       7  0 const
     D   peUser                      10    options(*nopass:*omit)
     D   peMar1                       1    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVCBU_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVCBU_inz      pr

      * ------------------------------------------------------------ *
      * SPVCBU_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVCBU_End      pr

      * ------------------------------------------------------------ *
      * SPVCBU_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPVCBU_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVCBU_checkCbu(): Valida una CBU                            *
      *                                                              *
      *     peNcbu   (input)   Número de CBU                         *
      *                                                              *
      * Retorna: 0 si ok                                             *
      *          1 error en DV 1                                     *
      *          2 error en DV 2                                     *
      *          9 error en CBU                                      *
      * ------------------------------------------------------------ *
     D SPVCBU_checkCbu...
     D                 pr             1  0
     D  peNcbu                       22  0 const

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

     D SPVCBU_GetCuenta...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peIvbc                       3  0
     D   peIvsu                       3  0
     D   peTcta                       2  0
     D   peNcta                      25

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
     D SPVCBU_setBloqueo...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peIvbc                       3  0
     D   peIvsu                       3  0
     D   peTcta                       2  0
     D   peNcta                      25
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVCBU_enmascararNumero(): Enmascarar número de CBU          *
      *                                                              *
      *     peNcbu   (input)   Numero de CBU                         *
      *     peCara   (input)   Caracter Sustituto                    *
      *     peCant   (input)   Cantidad de Nro. visibles             *
      *                                                              *
      * Retorna: Número de CBU con Mascara                           *
      * ------------------------------------------------------------ *

     D SPVCBU_enmascararNumero...
     D                 pr            25
     D   peNcbu                      25    const
     D   peCara                       1    const
     D   peCant                      25  0 const

      * ------------------------------------------------------------ *
      * SPVCBU_getCbu25a22() : Muevo de CBU de 25 Caracteres a       *
      *                        CBU de 22 Caracteres                  *
      *                                                              *
      *   peNcbu25 (input)   Numero de CBU de 25 Caracteres          *
      *   peNcbu22 (Output)  Numero de CBU de 22 Caracteres          *
      *                                                              *
      * Retorna: Número de CBU                                       *
      * ------------------------------------------------------------ *

     D SPVCBU_getCbu25a22...
     D                 pr            22
     D   peNcbu                      25    const

