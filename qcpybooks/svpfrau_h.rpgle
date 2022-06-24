      /if defined(SVPFRAU_H)
      /eof
      /endif
      /define SPVFRAU_H

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     DSVPFRAU_ERDS_T   ds                   qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxFEmi():Siniestro cercano a fecha emision...       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Póliza                                *
      *     peFsin   (input)   Fecha Ocurrencia Siniestro            *
      *     peIFemi  (output)  Indicativo posible Fraude x F.Emision *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPFRAU_OkxFEmi...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFsin                       8  0 const
     D   peIFemi                      1

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxFVig(): Chequea Si corresponde indicativo posible *
      *                    fraude, porque F.Emision posterior a F.Vi-*
      *                    gencia y Fe.Ocurrencia sinietro entre ambas
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peIFVig  (output)  Indicativo posible Fraude x F.Vig.dde.*
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFRAU_OkxFVig...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFsin                       8  0 const
     D   peIFVig                      1

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxFItm(): Chequea si la póliza se esta procesando   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Póliza                                *
      *     pePoco   (input)   Nro. Componente                       *
      *     peFsin   (input)   Fecha Ocurrencia Siniestro            *
      *     peIFIItm (output)  Indicativo posible Fraude x F.Inclus. *
      *                        Item                                  *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPFRAU_OkxFItm...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     d   pePoco                       4  0 const
     d   peFsin                       8  0 const
     D   peIFIItm                     1

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxSumA(): Chequea si la póliza tuvo aumento de Suma *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Póliza                                *
      *     pePoco   (input)   Nro. Componente                       *
      *     peFsin   (input)   Fecha Ocurrencia Siniestro            *
      *     peISumA  (output)  Indicativo Aumento Suma               *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPFRAU_OkxSumA...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     d   pePoco                       4  0 const
     d   peFsin                       8  0 const
     D   peISumA                      1

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxCob(): Chequea Si Hubo Cambio de Cobertura antes  *
      *                   de Siniestro                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Póliza                                *
      *     pePoco   (input)   Nro. Componente                       *
      *     peFsin   (input)   Fecha Ocurrencia Siniestro            *
      *     peICob   (output)  Indicativo Cambio Cobertura           *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPFRAU_OkxCob...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     d   pePoco                       4  0 const
     d   peFsin                       8  0 const
     D   peICob                       1

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxCuo(): Chequea Si Hubo Pago de cuota Vencida antes*
      *                   de Siniestro                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Póliza                                *
      *     pePoco   (input)   Nro. Componente                       *
      *     peFsin   (input)   Fecha Ocurrencia Siniestro            *
      *     peICuo   (output)  Indicativo Cambio Cobertura           *
      *     peICVPag (output)  Indicativo Cambio Cobertura           *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPFRAU_OkxCuo...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     d   pePoco                       4  0 const
     d   peFsin                       8  0 const
     D   peICuo                       1
     D   peICVPag                     1

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxAver(): Chequea si la póliza tenía averia en el   *
      *                    momento                                   *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Póliza                                *
      *     pePoco   (input)   Nro. Componente                       *
      *     peFsin   (input)   Fecha Ocurrencia Siniestro            *
      *     peIAver  (output)  Indicativo Averia                     *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPFRAU_OkxAver...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     d   pePoco                       4  0 const
     d   peFsin                       8  0 const
     D   peIAver                      1

      * ------------------------------------------------------------ *
      * SVPFRAU_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPFRAU_inz     pr

      * ------------------------------------------------------------ *
      * SVPFRAU_End(): Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPFRAU_End     pr

      * ------------------------------------------------------------ *
      * SVPFRAU_Error(): Retorna el último error del service program *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPFRAU_Error   pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPFRAU_Difdias():Calcula diferencia en dias entre 2 fechas  *
      *                                                              *
      *     peFedde  (input)   Fecha Desde                           *
      *     peFehta  (input)   Fecha Hasta                           *
      *     peDias   (output)  cant. dias diferencia entre fechas    *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     DSVPFRAU_DifDias  pr             1n
     D   peFedde                      8  0 const
     D   peFehta                      8  0 const
     D   peDias                      10i 0

      * ------------------------------------------------------------ *
      * SVPFRAU_getPoco(): Busca Componente                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Código Rama                           *
      *     pePoli   (input)   Póliza                                *
      *     pePoco   (input)   Componente                            *
      *     peTipo   (input)   Tipo 0: a Fecha de param. (pahet0)    *
      *                             9: Ult.Estado (pahet9)           *
      *     peFecha  (input)   se usa si peTipo = 0                  *
      *     peFItm   (output)  Fecha Inclusion Itm                   *
      *     peSumA   (output)  Suma Asegurada                        *
      *     peCobAU  (output)  Cobertura (Rama Autos)                *
      *     peCOBRV  (output)  Cobertura (Rama Riesgos Varios)       *
      *     peAver   (output)  Averia    (Rama Autos)                *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPFRAU_getPoco...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peTipo                       1    const
     D   peFecha                      8  0 const
     D   peFItm                       8  0
     d   peSumA                      15  2
     d   peCobAU                      2
     d   peCobRV                      3  0
     d   peAver                       1

