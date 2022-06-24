      /if defined(SVPMPO_H)
      /eof
      /endif
      /define SVPMPO_H

      * -----------------------------------------------------------
      * DS PAHMPO ( Mercado Pago )
      * -----------------------------------------------------------
     D dsPahmpo_t      ds                  qualified template
     D  mpempr                        1a
     D  mpsucu                        2a
     D  mptdoc                        2s 0
     D  mpndoc                        8s 0
     D  mprama                        2s 0
     D  mppoli                        7s 0
     D  mparcd                        6s 0
     D  mpspol                        9s 0
     D  mpsspo                        3s 0
     D  mpimcu                       15s 2
     D  mpfpag                        8s 0
     D  mphpag                        6s 0
     D  mptipo                        1a
     D  mpncuo                       10s 0
     D  mpnrsc                       10s 0
     D  mpfvcu                        8s 0
     D  mporig                        2a
     D  mpclid                      128a
     D  mpclst                      128a
     D  mpexre                      128a
     D  mppaty                      128a
     D  mpmoid                      128a
     D  mpprid                      128a
     D  mpstid                      128a
     D  mppcmo                      128a
     D  mpmaid                      128a
     D  mpproc                        1a
     D  mpivni                        6s 0
     D  mpivop                        7s 0
     D  mpmar1                        1a
     D  mpmar2                        1a
     D  mpmar3                        1a
     D  mpmar4                        1a
     D  mpmar5                        1a
     D  mpuser                       10a
     D  mpfpro                        8  0
     D  mphpro                        6  0
     D  mpobse                      300a

      * ------------------------------------------------------------ *
      * SVPMPO_inz(): Inicializa Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPMPO_inz      pr

      * ------------------------------------------------------------ *
      * SVPMPO_end(): Finaliza   Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPMPO_end      pr

      * ------------------------------------------------------------ *
      * SVPMPO_error(): Retornar error del módulo                    *
      *                                                              *
      *    peErrn     (input)    Número de error (opcional)          *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     D SVPMPO_error    pr            80a
     D  peErrn                       10i 0 options(*nopass : *omit)

      * ------------------------------------------------------------ *
      * SVPMPO_getPahmpo: Retorna datos de mercado pago              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peTdoc   ( input  ) Tipo de Documento                    *
      *     peNrdo   ( input  ) Número de Documento                  *
      *     peRama   ( input  ) Código de Rama            (Opcional) *
      *     pePoli   ( input  ) Mes de Proceso            (Opcional) *
      *     peDsVw   ( output ) Estrutura de Facturas Web (Opcional) *
      *     peDsVwC  ( output ) Cantidad de Facturas Web  (Opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPMPO_getPahmpo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTdoc                       2  0 const
     D   peNrdo                       8  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   pePoli                       7  0 options( *nopass : *omit ) const
     D   peDsMp                            likeds( dsPahmpo_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsMpC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPMPO_setPahmpo: Graba datos de Mercado Pago                *
      *                                                              *
      *     peDsMp   ( input  ) Estructura de PAHMPO                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPMPO_setPahmpo...
     D                 pr              n
     D   peDsMp                            likeds( dsPahmpo_t )
     D                                     options( *nopass : *omit ) const

      * ------------------------------------------------------------ *
      * SVPMPO_updPahmpo: Actualiza datos de Mercado Pago            *
      *                                                              *
      *     peDsMp   ( input  ) Estructura de PAHMPO                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPMPO_updPahmpo...
     D                 pr              n
     D   peDsMp                            likeds( dsPahmpo_t )
     D                                     options( *nopass : *omit ) const
