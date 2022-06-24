      /if defined(SVPISO_H)
      /eof
      /endif
      /define SVPISO_H

      * ------------------------------------------------------------ *
      * SVPISO_getCoberturaIsol :                                    *
      *                                                              *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peCobc   (input)   Código de Cobertura                   *
      *     peCeis   (output)  Código de Cobertura Equivalente iSOL  *
      *     peCedi   (output)  Descripción Cobertura Equivalente iSOL*
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getCoberturaIsol...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
     D   peCeis                       9  0
     D   peCedi                      50
      * ------------------------------------------------------------ *
      * SVPISO_getProductoIsol :                                     *
      *                                                              *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peXpro   (input)   Código de Producto                    *
      *     pePeis   (output)  Código de Producto Equivalente iSOL   *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getProductoIsol...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   pePeis                       9  0
      * ------------------------------------------------------------ *
      * SVPISO_getPaisIsol:                                          *
      *                                                              *
      *                                                              *
      *     pePain   (input)   Código de Pais                        *
      *     pePais   (output)  Código de Pais Equivalente iSOL       *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getPaisIsol...
     D                 pr              n
     D   pePain                       5  0 const
     D   pePais                       9  0
      * ------------------------------------------------------------ *
      * SVPISO_getSolicitudIsol:                                     *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Código de Superpóliza                 *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Código de Pólizas por Rama            *
      *     peOper   (input)   Número de Operación                   *
      *     pepoli   (input)   Número de Póliza                      *
      *     peSoln   (output)  Número Solicitud ISOL                 *
      *     peFech   (output)  Fecha Solicitud ISOL                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getSolicitudIsol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSoln                      18  0
     D   peFech                       8  0
      * ------------------------------------------------------------ *
      * SVPISO_setSolicitudIsol:                                     *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Código de Superpóliza                 *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Código de Pólizas por Rama            *
      *     peOper   (input)   Número de Operación                   *
      *     pepoli   (input)   Número de Póliza                      *
      *     peSoln   (input)   Número Solicitud ISOL                 *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_setSolicitudIsol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSoln                      18  0 const
      * ------------------------------------------------------------ *
      * SVPISO_updSolicitudIsol:                                     *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Código de Superpóliza                 *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Código de Pólizas por Rama            *
      *     peOper   (input)   Número de Operación                   *
      *     pepoli   (input)   Número de Póliza                      *
      *     peSoln   (update)  Número Solicitud ISOL                 *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_updSolicitudIsol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSoln                      18  0 const
      * ------------------------------------------------------------ *
      * SVPISO_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPISO_inz      pr
      * ------------------------------------------------------------ *
      * SVPISO_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPISO_End      pr
      * ------------------------------------------------------------ *
      * SVPISO_getFormaPagoIsol...                                   *
      *                                                              *
      *     peFpga   (input)   Código de Forma de Pago GAUS          *
      *     peFpis   (output)  Código de Forma de Pago iSOL          *
      *     peFpdi   (output)  Descripción Forma de Pago iSOL        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getFormaPagoIsol...
     D                 pr              n
     D   peFpga                       2  0 const
     D   peFpis                       4  0
     D   peFpdi                      80
      * ------------------------------------------------------------ *
      * SVPISO_getCodigoIvaIsol...                                   *
      *                                                              *
      *     peCiga   (input)   Código de Iva GAUS                    *
      *     peCiis   (output)  Código de Iva iSOL                    *
      *     peCidi   (output)  Descripción Código de Iva iSOL        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getCodigoIvaIsol...
     D                 pr              n
     D   peCiga                       2  0 const
     D   peCiis                      30
     D   peCidi                      30
      * ------------------------------------------------------------ *
      * SVPISO_getTipoDocumIsol...                                   *
      *                                                              *
      *     peTdga   (input)   Tipo de Documento GAUS                *
      *     peTdis   (output)  Tipo de Documento iSOL                *
      *     peTddi   (output)  Descripción Tipo de Documento iSOL    *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getTipoDocumIsol...
     D                 pr              n
     D   peTdga                       2  0 const
     D   peTdis                      30
     D   peTddi                      30
      * ------------------------------------------------------------ *
      * SVPISO_getSexoIsol...                                        *
      *                                                              *
      *     peSega   (input)   Código de Sexo GAUS                   *
      *     peSeis   (output)  Código de Sexo iSOL                   *
      *     peSedi   (output)  Descripción Código de Sexo iSOL       *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getSexoIsol...
     D                 pr              n
     D   peSega                       1  0 const
     D   peSeis                      30
     D   peSedi                      30
      * ------------------------------------------------------------ *
      * SVPISO_getEstCivilIsol...                                    *
      *                                                              *
      *     peEcga   (input)   Código de Estado Civil GAUS           *
      *     peEcis   (output)  Código de Estado Civil iSOL           *
      *     peEcdi   (output)  Descripción Código Estado Civil iSOL  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getEstCivilIsol...
     D                 pr              n
     D   peEcga                       1  0 const
     D   peEcis                      30
     D   peEcdi                      30
      * ------------------------------------------------------------ *
      * SVPISO_getProvinciaIsol...                                   *
      *                                                              *
      *     pePvga   (input)   Código de Provincia GAUS              *
      *     pePvis   (output)  Código de Provincia iSOL              *
      *     pePvdi   (output)  Descripción Código de Provincia iSOL  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getProvinciaIsol...
     D                 pr              n
     D   pePvga                       2  0 const
     D   pePvis                      30
     D   pePvdi                      30
      * ------------------------------------------------------------ *
      * SVPISO_getCodTarjCredIsol...                                 *
      *                                                              *
      *     peTcga   (input)   Código de Tarjeta de Crédito GAUS     *
      *     peTcis   (output)  Código de Tarjeta de Crédito iSOL     *
      *     peTcdi   (output)  Descripción Tarjeta de Crédito iSOL   *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getCodTarjCredIsol...
     D                 pr              n
     D   peTcga                       3  0 const
     D   peTcis                       9  0
     D   peTcdi                      50
      * ------------------------------------------------------------ *
      * SVPISO_getPlanesIsol...                                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivt   (input)   Código de Intermediario               *
      *     pePlis   (output)  Código de Plan iSOL                   *
      *     pePldi   (output)  Descrición Código de Plan iSOL        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getPlanesIsol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   pePlis                       9  0
     D   pePldi                      60
      * ------------------------------------------------------------ *
      * SVPISO_getMotivoAnulacionIsol...                             *
      *                                                              *
      *     peStou   (input)   Subtipo Operacion Usuario GAUS        *
      *     peCman   (output)  Codigo Motivo de Anulacion iSol       *
      *     peDman   (output)  Descripcion Motivo de Anulacion iSol  *
      *                                                              *
      * Retorna: *on = Si coincide la Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPISO_getMotivoAnulacionIsol...
     D                 pr              n
     D   peStou                       2  0 const
     D   peCman                      30
     D   peDman                     100
