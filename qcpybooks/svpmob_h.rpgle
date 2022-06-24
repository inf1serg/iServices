      /if defined(SVPMOB_H)
      /eof
      /endif
      /define SVPMOB_H

      // Estructura de PAHMOB
     D dspahmob_t      ds                  qualified template
     D   obempr                       1
     D   obsucu                       2
     D   obpoli                       7
     D   obmoto                      25
     D   obncel                      20
     D   obmail                      50
     D   obfnac                       8p 0
     D   obtusr                      10
     D   obnomb                      40
     D   obfech                      25
     D   obresu                       1
     D   obobse                     512
     D   obmp01                       1
     D   obmp02                       1
     D   obmp03                       1
     D   obmp04                       1
     D   obmp05                       1
     D   obmp06                       1
     D   obmp07                       1
     D   obmp08                       1
     D   obmp09                       1
     D   obmp10                       1

      *-- Copy's ----------------------------------------------------*
       /copy './qcpybooks/dtaq_h.rpgle'
       /copy './qcpybooks/svpvls_h.rpgle'
       /copy './qcpybooks/qusec_h.rpgle'

      * ------------------------------------------------------------ *
      * SVPMOB_getAuditoria: Retorna informacion de auditoria        *
      *                                                              *
      *     peEmpr   ( input  ) Código de Empresa                    *
      *     peSucu   ( input  ) Código de sucursal                   *
      *     peFech   ( input  ) Fecha de alta                        *
      *     peDsmo   ( output ) Estructura Datos Mobile              *
      *                                                              *
      * Retorna: *on = Obtiene datos.-                               *
      *          *off= No obtiene datos.-                            *
      * ------------------------------------------------------------ *

     D SVPMOB_getAuditoria...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFech                      25    const
     D   peDsmo                            likeds( DsPahmob_t )

      * ------------------------------------------------------------ *
      * SVPMOB_setAuditoria: Graba datos de Auditoria.-              *
      *                                                              *
      *     peDsmo   (input)   Estructura Datos Mobile               *
      *                                                              *
      * Retorna: *on = Se inserto correctamente.-                    *
      *          *off= Error al insertar.-                           *
      * ------------------------------------------------------------ *

     D SVPMOB_setAuditoria...
     D                 pr              n
     D   peDsmo                            likeds( DsPahmob_t ) const

      * ------------------------------------------------------------ *
      * SVPMOB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPMOB_inz      pr

      * ------------------------------------------------------------ *
      * SVPMOB_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPMOB_end      pr

      * ------------------------------------------------------------ *
      * SVPMOB_setDataq() : Envia datos a cola.-                     *
      *                                                              *
      *     peEmpr   ( input )  Empresa                              *
      *     peSucu   ( input )  Sucursal                             *
      *     peFech   ( input )  Fecha y Hora                         *
      *     peDtaq   ( input )  Nombre de Cola. ( opcional )         *
      *                                                              *
      * Retorna: *on = Se insertó correctamente.-                    *
      *          *off= Error al insertar.-                           *
      * ------------------------------------------------------------ *

     D SVPMOB_setDataq...
     D                 pr              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peFech                      25      const
     D   peAcci                      10      options(*omit:*nopass)
     D   peDtaq                      10      options(*omit:*nopass)

