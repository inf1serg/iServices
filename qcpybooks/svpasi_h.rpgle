      /if defined(SVPASI_H)
      /eof
      /endif
      /define SVPASI_H

      /copy './qcpybooks/wsstruc_h.rpgle'

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     d SVPASI_ERDS_T   ds                  qualified
     d                                     based(template)
     d   Errno                        4s 0
     d   Msg                         80a


      * Archivo General de Asientos Contables
     d DsCnhAsi_t      ds                  qualified template
     d   asempr                       1
     d   assucu                       2
     d   asfasa                       4S 0
     d   asfasm                       2S 0
     d   asfasd                       2S 0
     d   aslibr                       1S 0
     d   astico                       2S 0
     d   asnras                       6S 0
     d   ascomo                       2
     d   asseas                       4S 0
     d   asnrlo                       4S 0
     d   asfata                       4S 0
     d   asfatm                       2S 0
     d   asfatd                       2S 0
     d   ascore                       2
     d   asnrcm                      11S 0
     d   asdvcm                       1
     d   ascoma                       2
     d   asnrma                       7S 0
     d   asdvna                       1
     d   asesma                       1S 0
     d   ascopt                      25
     d   asnrrf                       9S 0
     d   asfera                       4S 0
     d   asferm                       2S 0
     d   asferd                       2S 0
     d   asimco                      15S 6
     d   asimme                      15S 2
     d   asimau                      15S 2
     d   asdeha                       1S 0
     d   assuc2                       2
     d   astic2                       2S 0
     d   asnrr2                       9S 0
     d   astias                       1
     d   asstas                       1
     d   asatsd                       1
     d   asatdg                       1
     d   asmoas                       1
     d   asinad                       2S 0
     d   asabcv                       1
     d   asuser                      10
     d   asafhc                      13S 0
     d   asuaut                      10
     d   asfaut                       6S 0
     d   ashaut                       6S 0
     d   aswaut                      10
     d   aspaut                      10
     d   aseaut                       1

      * Archivo General de Asientos Interfase
     d DsCnwNin_t      ds                  qualified template
     d   niempr                       1
     d   nifasa                       4S 0
     d   nifasm                       2S 0
     d   nifasd                       2S 0
     d   nilibr                       1S 0
     d   ninras                       6S 0
     d   nicomo                       2
     d   niseas                       4S 0
     d   niscor                       4S 0
     d   ninrlo                       4S 0
     d   nifata                       4S 0
     d   nifatm                       2S 0
     d   nifatd                       2S 0
     d   ninrcm                      11  0
     d   nidvcm                       1
     d   nicoma                       2
     d   ninrma                       7  0
     d   nidvna                       1
     d   niesma                       1S 0
     d   nicopt                      25
     d   ninrrf                       9  0
     d   nifera                       4S 0
     d   niferm                       2S 0
     d   niferd                       2S 0
     d   niimco                      15  6
     d   niimme                      15  2
     d   niimau                      15  2
     d   nideha                       1
     d   nisuc2                       2
     d   nitic2                       2  0
     d   nistas                       1
     d   nimoas                       1
     d   niinad                       2S 0
     d   nican1                       5S 0
     d   nican2                       5S 0
     d   nicaa1                       5S 3
     d   nicaa2                       5S 3
     d   niuser                      10
     d   niuaut                      10
     d   nifaut                       6P 0
     d   nihaut                       6P 0
     d   niwaut                      10
     d   nipaut                      10
     d   nieaut                       1

      * ------------------------------------------------------------ *
      * SVPASI_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     d SVPASI_inz      pr

      * ------------------------------------------------------------ *
      * SVPASI_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     d SVPASI_end      pr

      * ------------------------------------------------------------ *
      * SVPASI_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     d SVPASI_error    pr            80a
     d   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPASI_GetCnhAsi: Retorna CNHASI                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *     peHasi   (output)  DS con los registros de Asientos      *
      *     peHasic  (output)  Cantidad de Registros de Asientos     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     d SVPASI_GetCnhAsi...
     d                 pr              n
     d   peEmpr                       1    const
     d   peSucu                       2    const
     d   peFasa                       4S 0 const
     d   peFasm                       2S 0 const
     d   peFasd                       2S 0 const
     d   peLibr                       1S 0 const
     d   peTico                       2  0 const
     d   peNras                       6S 0 const
     d   peComo                       2    const
     d   peSeas                       4S 0 const options(*nopass:*omit)
     d   peHasi                            likeds(DsCnhAsi_t) dim(999)
     d                                     options(*nopass:*omit)
     d   pehasic                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPASI_ChkCnhAsi: Chequea si existe Cnhasi                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     d SVPASI_ChkCnhAsi...
     d                 pr              n
     d   peEmpr                       1    const
     d   peSucu                       2    const
     d   peFasa                       4S 0 const
     d   peFasm                       2S 0 const
     d   peFasd                       2S 0 const
     d   peLibr                       1S 0 const
     d   peTico                       2  0 const
     d   peNras                       6S 0 const
     d   peComo                       2    const
     d   peSeas                       4S 0 options(*nopass:*omit) const

      * ------------------------------------------------------------ *
      * SVPASI_UpdCnhAsi: Actualiza Datos en CnhAsi                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *     peHasi   (output)  DS con el registro del Asiento        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     d SVPASI_UpdCnhAsi...
     d                 pr              n
     d   peEmpr                       1    const
     d   peSucu                       2    const
     d   peFasa                       4S 0 const
     d   peFasm                       2S 0 const
     d   peFasd                       2S 0 const
     d   peLibr                       1S 0 const
     d   peTico                       2  0 const
     d   peNras                       6S 0 const
     d   peComo                       2    const
     d   peSeas                       4S 0 const
     d   peHasi                            likeds(DsCnhAsi_t)

      * ------------------------------------------------------------ *
      * SVPASI_SetCnhAsi: Grabo Datos en CnhAsi                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *     peHasi   (output)  DS con el registro del Asiento        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     d SVPASI_SetCnhAsi...
     d                 pr              n
     d   peEmpr                       1    const
     d   peSucu                       2    const
     d   peFasa                       4S 0 const
     d   peFasm                       2S 0 const
     d   peFasd                       2S 0 const
     d   peLibr                       1S 0 const
     d   peTico                       2  0 const
     d   peNras                       6S 0 const
     d   peComo                       2    const
     d   peSeas                       4S 0 const
     d   peHasi                            likeds(DsCnhAsi_t)

      * ------------------------------------------------------------ *
      * SVPASI_BalanceoAsiento: Balanceo Asiento en CNWNIN           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peNrcm   (input)   Numero de Cuenta de Mayor a Ajustar   *
      *                                                              *
      * Retorna: *on = Balanceó  / *off = No Balanceó                *
      * ------------------------------------------------------------ *
     D SVPASI_BalanceoAsiento...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     d   pefasa                       4S 0 const
     d   pefasm                       2S 0 const
     d   pefasd                       2S 0 const
     d   pelibr                       1S 0 const
     d   petic2                       2  0 const
     d   penras                       6S 0 const
     d   pecomo                       2    const
     d   peNrcm                      11S 0 const

