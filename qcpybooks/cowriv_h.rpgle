      /if defined(COWRIV_H)
      /eof
      /endif
      /define COWRIV_H

      /copy './qcpybooks/cowrgv_h.rpgle'

      * ------------------------------------------------------------ *
      * COWRIV_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWRIV_inz      pr
      * ------------------------------------------------------------ *
      * COWRIV_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWRIV_end      pr
      * ------------------------------------------------------------ *
      * COWRIV_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D COWRIV_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWRIV_cotizarWeb:  Cotiza un Bien Asegurado de una Rama de  *
      *                     <<<<<<<<<<<<RIESGOS VARIOS>>>>>>>>>>>>>  *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peCfpg (input)  Plan de Pago                          *
      *        peClie (input)  Estructura de Cliente                 *
      *        pePoco (in/ou)  Array de componentes                  *
      *        pePocoC(input)  Cantidad de entradas en pePoco        *
      *        peXrea (input)  Epv                                   *
      *        peImpu (output) Estructura de impuestos total         *
      *        peSuma (output) Suma Asegurada total                  *
      *        pePrim (output) Prima total                           *
      *        pePrem (output) Premio total                          *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRIV_cotizarWeb...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0 const
     D  peXrea                        5  2 const
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      * ------------------------------------------------------------------ *
      * COWRIV_chkRenovacion(): Valida campos antes de realizar renovación *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peErro ( output )  Indicador                                   *
      *     peMsgs ( output )  Estructura de Error                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     D COWRIV_chkRenovacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

