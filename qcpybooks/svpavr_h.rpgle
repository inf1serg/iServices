      /if defined(SVPAVR_H)
      /eof
      /endif
      /define SVPAVR_H

      ****************************************************************
      *  Recuperar si una póliza es o no renovable.
      *  Pedido de desarrollo 3303
      *
      *  Inf1Marc  17/01/2014
      ****************************************************************

      * ------------------------------------------------------------ *
      * Archivo de Reposicion                                        *
      * ------------------------------------------------------------ *
     D DsCnhopl_t      ds                  qualified template
     D   plempr                       1
     D   plsucu                       2
     D   plartc                       2p 0
     D   plpacp                       6p 0
     D   plfasa                       4p 0
     D   plfasm                       2p 0
     D   plfasd                       2p 0
     D   plrama                       2p 0
     D   plpoli                       7p 0
     D   plarcd                       6p 0
     D   plspol                       9p 0
     D   plasen                       7p 0
     D   plnivt                       1p 0
     D   plnivc                       5p 0
     D   plsini                       7p 0
     D   plcoma                       2
     D   plnrma                       7p 0
     D   plimau                      15p 2
     D   plivcv                       2p 0
     D   plcopt                      25
     D   pltipo                       1
     D   plsts1                       1
     D   plsts2                       1

      * Estructura de Informacion por Componente *
     D DsPoco_t        ds                  qualified template
     D  poco                          6p 0
     D  paco                          3p 0
     D  fpaa                          4p 0
     D  fpam                          2p 0
     D  fpad                          2p 0
     D  riec                          3
     D  xcob                          3p 0
     D  mont                         15p 2
     D  acci                          2

     * --- Copy H ---------------------------------------------- *
      /copy './qcpybooks/svpsin_h.rpgle'

     D SVPAVR_EsIndemnizacion...
     D                 pr             1n
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   peartc                       2  0 const
     D   pepacp                       6  0 const
     D   perama                       2  0 const
     D   peSINI                       7  0
     D   peNOPS                       7  0
     D   pexcob                       3  0
      *
     D SVPAVR_CorrespondeAvisoPRamaCobMont...
     D                 pr             1n
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   Pefech                       8  0 const
     D   perama                       2  0 const
     D   pecobc                       3  0 const
     D   pemont                      15  2 const
     D   pearcd                       6  0 const
      *
     D SVPAVR_ExistenReglasVigentes...
     D                 pr             7  0
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   Pefech                       8  0 const
      *
     D SVPAVR_ObtieneDatosPoliza...
     D                 pr
     D Peempr                         1    const
     D Pesucu                         2    const
     D perama                         2  0 const
     D pesini                         7  0 const
     D penops                         7  0 const
     D pepoli                         7  0
     D pearcd                         6  0
     D pespol                         9  0
     D penivt                         1  0
     D penivc                         5  0
     D peasen                         7  0
     D pevige                          n
     D pefincontrato                  8  0
      *
     D SVPAVR_VerificaSuspendida...
     D                 pr              n
     D Peempr                         1    const
     D Pesucu                         2    const
     D pearcd                         6  0 const
     D pespol                         9  0 const
      *
     D SVPAVR_VerificaSuspendidaSPWY...
     D                 pr              n
     D pearcd                         6  0 const
     D pespol                         9  0 const
     D pepoli                         7  0 const
      *
     D SVPAVR_inz      pr              n
      *
     D SVPAVR_end      pr
      *
     D SVPAVR_ObtieneCondParaRama...
     D                 pr             1n
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   Pefech                       8  0 const
     D   perama                       2  0 const
     d   pediap                       2  0
     d   pecoev                       1
      *
     D SVPAVR_VerificaAnulEnCurso...
     D                 pr              n
     D Peempr                         1    const
     D Pesucu                         2    const
     D pearcd                         6  0 const
     D pespol                         9  0 const
      *****************************************************************
      *
      * Tratamiento de errores.
      *
      *****************************************************************

     D SVPAVR_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPAVR_getAccion: Retorna Tipo de Accion a tomar             *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peFech   (input)   Fecha de Asiento                      *
     *     peRama   (input)   Rama                                  *
     *     peCobc   (input)   Cobertura                             *
     *     peMont   (input)   Monto                                 *
     *     peArcd   (input)   Aticulo                               *
     *                                                              *
     * Retorna: -1 = No contiene Accion                             *
     * ------------------------------------------------------------ *
     D SVPAVR_getAccion...
     D                 pr             2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFech                       8  0 const
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
     D   peMont                      15  2 const
     D   peArcd                       6  0 const

     * ------------------------------------------------------------ *
     * SVPAVR_getReposicion : Retorna Datos de Reposicion           *
     *                                                              *
     *     peEmpr ( input  )  Empresa                               *
     *     peSucu ( input  )  Sucursal                              *
     *     peArtc ( input  )  Código area tecnica                   *
     *     pePacp ( input  )  Nro. de comprobante de pago           *
     *     peDsRp ( output )  Estructura de Archivo de Reposicion   *
     *                                                              *
     * Retorna:  *on = Encontro / *off = No encontro                *
     * ------------------------------------------------------------ *
     D SVPAVR_getReposicion...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsRp                            likeds( DsCnhopl_t )

     * ------------------------------------------------------------ *
     * SVPAVR_getParamReposicion : Retorna parámetros para realizar *
     *                             endoso de Reposicion o Baja Suma *
     *     peEmpr ( input  )  Empresa                               *
     *     peSucu ( input  )  Sucursal                              *
     *     peArtc ( input  )  Código area tecnica                   *
     *     pePacp ( input  )  Nro. de comprobante de pago           *
     *     peDsRp ( output )  Estructura de Archivo de Reposicion   *
     *     peDsPs ( output )  Estructura de Pagos por Componente    *
     *     peDsPsC( output )  Cantidad elementos de Pagos           *
     *                                                              *
     * Retorna:  *on = Encontro / *off = No encontro                *
     * ------------------------------------------------------------ *
     D SVPAVR_getParamReposicion...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsRp                            likeds( DsCnhopl_t )
     D   peDsPs                            likeds( DsPoco_t   ) dim( 999 )
     D   peDsPsC                     10i 0

