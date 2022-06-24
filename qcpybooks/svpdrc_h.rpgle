      /if defined(SVPDRC_H)
      /eof
      /endif
      /define SVPDRC_H

      * ------------------------------------------------------------ *
      * SVPDRC_getDescCob(): Retorna Descuentos de Cobertura         *
      * Retornar para la cobertura, todos los descuentos de cada     *
      * nivel segun los descuentos que se grabaron durante la        *
      * Cotizacion Web.                                              *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peXcob   (input)   Cobertura                             *
      *     peLdes   (output)  Lista de Descuentos                   *
      *     peLdesC  (output)  Cant. Lista de Descuentos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_getDescCob...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pecobe                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(999)
     D   peLdesC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDRC_setDesc(): Graba Descuentos. Segun caracteristicas del*
      *                   bien asegurado.                            *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     pexpro   (input)   Código de Plan                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_setDesc...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pexpro                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRC_dltDesc(): Elimina Descuentos                         *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDRC_dltDesc...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * SVPDRC_updDesc(): Actualiza Tasa y Prima                     *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura (Prima)                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_updDesc...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRC_updNoDesc(): Actualiza Tasa y Prima cuando no hay     *
      *                                                              *
      *     PeBase   (input)   Parámetros Base                       *
      *     PeNctw   (input)   Nro. de Cotización                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_updNoDesc...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRC_getLcob(): Retorna lista de Coberturas                *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peLcob   (output)  Lista de Coberturas                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_getLcob...
     D                 pr            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peLcob                            likeds(descCo_t) dim(20)

      * ------------------------------------------------------------ *
      * SVPDRC_chkCob(): Existe cobertrua en Er2                     *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de cotización                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant.polizas por rama                 *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_chkCob...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRC_updDescAnt(): Vuelve valores anteriores a CTWER2      *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura(Prima)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_updDescAnt...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRC_chkDesc(): Cheque si se realizaron Descuentos         *
      *                                                              *
      *     peBase   (input)   Parámetros Base                       *
      *     peNctw   (input)   Nro. de Cotizacion                    *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     peCobe   (input)   Cobertura(Prima)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_chkDesc...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRC_chkImpactoDesc(): Chequea si se impactaron Descuentos *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Componente                            *
      *     prCobe   (input)   Cobertura (Prima)                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRC_chkImpactoDesc...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDRC_inz      pr

      * ------------------------------------------------------------ *
      * SVPDRC_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDRC_end      pr

      * ------------------------------------------------------------ *
      * SVPDRC_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPDRC_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

