      /if defined(SVPPOW_H)
      /eof
      /endif
      /define SVPPOW_H

      /copy './qcpybooks/wsstruc_h.rpgle'

      * -----------------------------------------------------------
      * DS PAHPOL ( Polizas para consultas Web )
      * -----------------------------------------------------------
     D dsPahpol_t      ds                  qualified template
     D  poempr                        1a
     D  posucu                        2a
     D  porama                        2  0
     D  popoli                        7  0
     D  pocert                        9  0
     D  poarcd                        6  0
     D  pospol                        9  0
     D  poarse                        2  0
     D  pooper                        7  0
     D  poramd                       20a
     D  poramb                        5a
     D  posoln                        9  0
     D  ponivt                        1  0
     D  ponivc                        5  0
     D  ponino                       40a
     D  poasen                        7  0
     D  poasno                       40a
     D  pofemi                         d
     D  pofdes                         d
     D  pofhas                         d
     D  pohafa                         d
     D  poanua                         d
     D  pomone                        2a
     D  ponmoc                        5a
     D  poprim                       15  2
     D  pobpri                       15  2
     D  porefi                       15  2
     D  poread                       15  2
     D  podere                       15  2
     D  poseri                       15  2
     D  poseem                       15  2
     D  poimpi                       15  2
     D  posers                       15  2
     D  potssn                       15  2
     D  poipr1                       15  2
     D  poipr3                       15  2
     D  poipr4                       15  2
     D  poipr2                       15  2
     D  poipr5                       15  2
     D  poipr6                       15  2
     D  poipr7                       15  2
     D  poipr8                       15  2
     D  poipr9                       15  2
     D  poprem                       15  2
     D  poprco                       15  2
     D  posald                       15  2
     D  ponivt1                       1  0
     D  ponivc1                       5  0
     D  pocopr1                      15  2
     D  ponivt2                       1  0
     D  ponivc2                       5  0
     D  pocopr2                      15  2
     D  ponivt3                       1  0
     D  ponivc3                       5  0
     D  pocopr3                      15  2
     D  ponivt4                       1  0
     D  ponivc4                       5  0
     D  pocopr4                      15  2
     D  ponivt5                       1  0
     D  ponivc5                       5  0
     D  pocopr5                      15  2
     D  ponivt6                       1  0
     D  ponivc6                       5  0
     D  pocopr6                      15  2
     D  ponivt7                       1  0
     D  ponivc7                       5  0
     D  pocopr7                      15  2
     D  ponivt8                       1  0
     D  ponivc8                       5  0
     D  pocopr8                      15  2
     D  ponivt9                       1  0
     D  ponivc9                       5  0
     D  pocopr9                      15  2
     D  pomarsin                      1a
     D  pocfpg                        1  0
     D  poctcu                        3  0
     D  ponrtc                       20  0
     D  poivbc                        3  0
     D  poivsu                        3  0
     D  potcta                        2  0
     D  poncta                       25a
     D  popoan                        7  0
     D  poponu                        7  0
     D  popatente                    10a
     D  poecon                        1a
     D  podesanu                     25a
     D  pomar1                        1a
     D  pomar2                        1a
     D  pomar3                        1a
     D  pomar4                        1a
     D  pomar5                        1a
     D  pomar6                        1a
     D  pomar7                        1a
     D  pomar8                        1a
     D  pomar9                        1a
     D  pocuip                       11  0
     D  pofemianu                      d
     D  pofemireh                      d
     D  pots20                       20  0
     D  ponctz                        7  0
     D  poncbu                       22a
     D  poxrea                        5  2
     D  pointeg                       1a
     D  pocobf                        1a
     D  poemcn                       50a
     D  poubic                       50a
     D  potiou                        1  0
     D  postou                        2  0
     D  postos                        2  0
     D  podsop                       20a
     D  poxref                        5  2
     D  popimi                        5  2
     D  popsso                        5  2
     D  popssn                        5  2
     D  popivi                        5  2
     D  popivn                        5  2
     D  popivr                        5  2
      * ------------------------------------------------------------ *
      * SVPPOW_inz(): Inicializa Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPPOW_inz      pr

      * ------------------------------------------------------------ *
      * SVPPOW_end(): Finaliza   Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPPOW_end      pr

      * ------------------------------------------------------------ *
      * SVPPOW_error(): Retornar error del módulo                    *
      *                                                              *
      *    peErrn     (input)    Número de error (opcional)          *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     D SVPPOW_error    pr            80a
     D  peErrn                       10i 0 options(*nopass : *omit)

      * ------------------------------------------------------------ *
      * SVPPOW_getPolizaAsegurado: Retorna datos de la poliza web    *
      *                            por asegurado.                    *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peAsen   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peCert   ( input  ) Certificado                          *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peArse   ( input  ) Cant de Polizas                      *
      *     peOper   ( input  ) Numero de Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPPOW_getPolizaAsegurado...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   pePoli                       7  0 options( *nopass : *omit ) const
     D   peCert                       9  0 options( *nopass : *omit ) const
     D   peArcd                       6  0 options( *nopass : *omit ) const
     D   peSpol                       9  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peDsP8                            likeds ( dsPahpol_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsP8C                     10i 0 options( *nopass : *omit )

