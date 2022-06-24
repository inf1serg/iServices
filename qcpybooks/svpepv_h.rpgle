      /if defined(SPVEPV_H)
      /eof
      /endif
      /define SPVEPV_H

      *  Rama Not Found
     D   SVPEPV_RANF   C                   const(0001)
      *  Aticulo Secuencia Not Found
     D   SVPEPV_ASNF   C                   const(0002)
      *  Extra Prima Variable Fuera de los Limites
     D   SVPEPV_EPVF   C                   const(0003)
      *  Rama sin condiciones comerciales
     D   SVPEPV_RSCC   C                   const(0004)
      *  Productor/Rama sin comisiones
     D   SVPEPV_PRSC   C                   const(0005)

      * ------------------------------------------------------------ *
      * SVPEPV_GETMINMAX(): Accede a Set123 y retorna los campos     *
      *                     de Puntos de EVP de Aumento y Disminución*
      *                                                              *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     pepaed   (ouput)   Puntos de Aumento.                    *
      *     pepded   (ouput)   Puntos de Disminución.                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPEPV_GETMINMAX...
     D                 pr            10i 0
     D   peRama                       2  0 const
     D   pePaed                       2  0
     D   pePded                       2  0

      * ------------------------------------------------------------ *
      * SVPEPV_LIMITEPRODUCTOR(): Accede a set6118 para el productor *
      *                     /rama y calcula peLmin y peLmax con el   *
      *                     valor por default y los recuperados de   *
      *                     GETMINMAX                                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal.                             *
      *     peNivt   (input)   Nivel del Intermediario.              *
      *     peNivc   (input)   Código del Intermediario.             *
      *     peRama   (input)   Rama                                  *
      *     peLmin   (ouput)   Limite Minimo                         *
      *     peLmax   (ouput)   Limite Maximo                         *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPEPV_getlimiteProductor...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 const
     D   peLmin                       5  2
     D   peLmax                       5  2


      * ------------------------------------------------------------ *
      * SVPEPV_GETACCION: Accede a Set621 y recupera campo agregado  *
      *                     en Punto 2.                              *
      *                                                              *
      *     peArcd   (input)   Artículo.                             *
      *     peRama   (input)   Rama.                                 *
      *     peArse   (input)   Artículo/Secuencia.                   *
      *     peAcci   (Output)  Acción.                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPEPV_getAccion...
     D                 pr            10i 0
     D   peArcd                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peAcci                       1

      * ------------------------------------------------------------ *
      * SVPEPV_CHKEPVINGRESADA: Usa todos los procedimientos anteri- *
      *                     ores y verifica que la EPV ingresada sea *
      *                     correcta                                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal.                             *
      *     peNivt   (input)   Nivel del Intermediario.              *
      *     peNivc   (input)   Código del Intermediario.             *
      *     peArcd   (input)   Artículo.                             *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Artículo/Secuencia.                   *
      *     peXrea   (input)   Extra Prima Variable Ingresada        *
      *     peAcci   (output)                                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPEPV_chkEpvIngresada...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXrea                       5  2 const
     D   peAcci                       1
      *

      * ------------------------------------------------------------ *
      * SVPEPV_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPEPV_inz      pr

      * ------------------------------------------------------------ *
      * SVPEPV_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPEPV_End      pr

      * ------------------------------------------------------------ *
      * SVPEPV_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     D SVPEPV_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
