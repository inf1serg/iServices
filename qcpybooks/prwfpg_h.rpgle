      /if defined(PRWFPG_H)
      /eof
      /endif
      /define PRWFPG_H

      /copy './qcpybooks/wsstruc_h.rpgle'

      * ------------------------------------------------------------ *
      * PRWFPG_insertFormaPago(): Insertar/Actualizar forma de pago  *
      *                           para una propuesta Web.            *
      *                                                              *
      *    peBase   (input)   Parámetro Base                         *
      *    peNctw   (input)   Número de Cotización                   *
      *    peCfpg   (input)   Código de Forma de Pago                *
      *    peNcbu   (input)   Número de CBU                          *
      *    peCtcu   (input)   Empresa Tarjeta de Crédito             *
      *    peNrtc   (input)   Número de Tarjeta de Crédito           *
      *    peFema   (input)   Año Vencimiento de Tarjeta de Crédito  *
      *    peFemm   (input)   Mes Vencimiento de Tarjeta de Crédito  *
      *    peErro   (output)  Indicador de Error                     *
      *    peMsgs   (output)  Estructura Mensaje de Error            *
      *                                                              *
      * Retorna: Void                                                *
      * ------------------------------------------------------------ *
     D PRWFPG_insertFormaDePago...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peCfpg                        1  0 const
     D  peNcbu                       22  0 const
     D  peCtcu                        3  0 const
     D  peNrtc                       20  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)


      * ------------------------------------------------------------ *
      * PRWFPG_inz(): Inicializa Módulo                              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWFPG_inz      pr

      * ------------------------------------------------------------ *
      * PRWFPG_end(): Finaliza  Módulo                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWFPG_end      pr

      * ------------------------------------------------------------ *
      * PRWFPG_error(): Retorna último error del módulo.             *
      *                                                              *
      *      peErrn  (input)  Número de error (opcional)             *
      *                                                              *
      * Retorna: mensaje de error                                    *
      * ------------------------------------------------------------ *
     D PRWFPG_error    pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

