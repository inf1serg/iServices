      /if defined(COWREN_H)
      /eof
      /endif
      /define COWREN_H

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpren_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svpbue_h.rpgle'

      * Cotizacion Inexistente...
     D COWREN_COTNE    c                   const(0001)
      * Cotizacion no es Renovacion...
     D COWREN_COTNR    c                   const(0002)

     D dsVeh_t         ds                  qualified based(template)
     D   base                              likeds(paramBase)
     D   nctw                         7  0
     D   rama                         2  0
     D   arse                         2  0
     D   poco                         4  0
     D   vhan                         4
     D   vhmc                         3
     D   vhmo                         3
     D   vhcs                         3
     D   vhvu                        15  2
     D   mgnc                         1
     D   rgnc                         7  2
     D   copo                         5  0
     D   cops                         1  0
     D   scta                         1  0
     D   clin                         1
     D   bure                         1  0
     D   cfpg                         3  0
     D   tipe                         1
     D   civa                         2  0
     D   mar1                         1
     D   nmat                        25
     D   moto                        25
     D   chas                        25
     D   ruta                        16  0
     D   vhuv                         2  0
     D   aver                         1a
     D   nmer                        40a
     D   acrc                         7  0
     D   acce                              likeds(AccVeh_t) dim(100)
     D   msgs                              likeds(paramMsgs) dim(20)

     D dsVeh2_t        ds                  qualified based(template)
     D   base                              likeds(paramBase)
     D   nctw                         7  0
     D   rama                         2  0
     D   arse                         2  0
     D   poco                         4  0
     D   vhan                         4
     D   vhmc                         3
     D   vhmo                         3
     D   vhcs                         3
     D   vhvu                        15  2
     D   mgnc                         1
     D   rgnc                        15  2
     D   copo                         5  0
     D   cops                         1  0
     D   scta                         1  0
     D   clin                         1
     D   bure                         1  0
     D   cfpg                         3  0
     D   tipe                         1
     D   civa                         2  0
     D   mar1                         1
     D   nmat                        25
     D   moto                        25
     D   chas                        25
     D   ruta                        16  0
     D   vhuv                         2  0
     D   aver                         1a
     D   nmer                        40a
     D   acrc                         7  0
     D   acce                              likeds(AccVeh_t) dim(100)
     D   taaj                         2  0
     D   scor                              likeds(preguntas_t) dim(200)
     D   msgs                              likeds(paramMsgs) dim(20)

      * ------------------------------------------------------------ *
      * COWREN_getLlamadas(): Retorna Llamadas para COWVEH           *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_getLlamadas...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0

      * ------------------------------------------------------------ *
      * COWREN_getDsLlamadas(): Retorna Ds con Llamadas para COWVEH  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_getDsLlamadas...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0

      * ------------------------------------------------------------ *
      * COWREN_getCodigoDeMensajes():Retorna código de error para    *
      *                              envío de MSG                    *
      *                                                              *
      *     peMsge   (input)   Mensaje                               *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Poliza                          *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *     peRepl   (output)  Parametros de Error                   *
      *                                                              *
      * Retorna: Retorna Código / -1                                 *
      * ------------------------------------------------------------ *
     D COWREN_getCodigoDeMensajes...
     D                 pr             7
     D   peMsge                      10i 0 const
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options(*nopass:*omit)
     D   peArse                       2  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)
     D   peRepl                   65535    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWREN_setLlamadas(): LLama COWVEH2                          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_setLlamadas...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t)  dim(20)
     D   peDsVhC                     10i 0

      * ------------------------------------------------------------ *
      * COWREN_chkGeneral(): Chequeos Generales                      *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Estructura de Error                   *
      *     peMsgsC  (output)  Cantidad de Errores                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_chkGeneral...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs) dim(20)
     D   peMsgsC                     10i 0

      * ------------------------------------------------------------ *
      * COWREN_getListaBuenResultado: Lista cod. de Buen Resultado   *
      *                               Increiblemente !!! se          *
      *                               solicitó que un servicio       *
      *                               devuelva una lista resultante  *
      *                               de la resta por -1 de un Nro   *
      *                               hasta llegar a Cero.           *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Nro. de Cotizacion                    *
      *     peBure   (input)   Cod. de Buen Resultado                *
      *     peLbure  (output)  Lista de Cod. de buen resultado       *
      *     peLbureC (output)  Cantidad                              *
      *     peErro   (output)  Error                                  *
      *     peMsgs   (output)  Mensaje de Error                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_getListaBuenResultado...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peBure                       1  0 const
     D   peLbure                           likeds(dsBure_t) dim(99)
     D   peLbureC                    10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWREN_getListaFormasDePago: Retorna una lista de todas las  *
      *                              formas de pago que tuvo una     *
      *                              SuperPóliza.                    *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Nro. de Cotizacion                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   SuperPóliza                           *
      *     peCfpg   (input)   Forma de Pago                         *
      *     peLfpg   (output)  Lista de Formas de Pago               *
      *     peLfpgC  (output)  Cantidad de entradas en peLfpg        *
      *     peErro   (output)  Error                                 *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_getListaFormasDePago...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCfpg                       1  0 const
     D   peLfpg                            likeds(dsCfpg_t) dim(999)
     D   peLfpgC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWREN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWREN_inz      pr

      * ------------------------------------------------------------ *
      * COWREN_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWREN_end      pr

      * ------------------------------------------------------------ *
      * COWREN_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D COWREN_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWREN_chkErrores(): Retorna si hay errores en las estructuras
      *                                                              *
      *     peMsgs   (input)   Estructura de Error                   *
      *     peMsgsC  (input)   Cantidad de Errores                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_chkErrores...
     D                 pr              n
     D   peDsVh                            likeds(dsVeh_t) dim(20) const
     D   peDsVhC                     10i 0 const

      * ------------------------------------------------------------ *
      * COWREN_getLlamadas2(): Retorna Llamadas para COWVEH          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_getLlamadas2...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh2_t) dim(20)
     D   peDsVhC                     10i 0

      * ------------------------------------------------------------ *
      * COWREN_getDsLlamadas2(): Retorna Ds con Llamadas para COWVEH *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_getDsLlamadas2...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh2_t) dim(20)
     D   peDsVhC                     10i 0

      * ------------------------------------------------------------ *
      * COWREN_chkErrores2(): Retorna si hay errores en las          *
      *                       estructuras                            *
      *                                                              *
      *     peMsgs   (input)   Estructura de Error                   *
      *     peMsgsC  (input)   Cantidad de Errores                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWREN_chkErrores2...
     D                 pr              n
     D peDsVh                              likeds(dsVeh2_t) dim(20) const
     D peDsVhC                       10i 0 const
