      /if defined(WSLCER_H)
      /eof
      /endif
      /define WSLCER_H

      /copy './qcpybooks/svpws_h.rpgle'
      * ------------------------------------------------------------ *
      * Lista de Coberturas
      * ------------------------------------------------------------ *
     D listCob_t       ds                  qualified template
     D   cobd                        40a
     D   suma                        15  2

      * ------------------------------------------------------------ *
      * Parametros Comunes para Certificaso de Coberturas
      * ------------------------------------------------------------ *
     D certCom_t       ds                  qualified template
     D   ramd                        20a
     D   ivig                         8  0
     D   fvig                         8  0
     D   asno                        40a
     D   domi                        25a
     D   copo                         5  0
     D   cops                         1  0
     D   loca                        25a
     D   neml                        50a
     D   endo                         7  0

      * ------------------------------------------------------------ *
      * Parametros Autos para Certificaso de Coberturas
      * ------------------------------------------------------------ *
     D certComAut_t    ds                  qualified template
     D   vhde                        40a
     D   vhaÑ                         4  0
     D   moto                        25a
     D   chas                        25a
     D   nmat                        25a
     D   vhvu                        15  2
     D   ifra                        15p 2
     D   vhcd                        15
     D   cobl                         2a
     D   apno                        40a
     D   cvde                        20a
     D   vhdu                        15a

      * ------------------------------------------------------------ *
      * Parametros Embarcaciones para Certificaso de Coberturas
      * ------------------------------------------------------------ *
     D certComEmb_t    ds                  qualified template
     D   emcn                        50a
     D   emcm                        10a
     D   emcf                        20a
     D   emca                         4  0
     D   emsc                        15  2
     D   emsm                        15  2
     D   emcd                        25a

      * ------------------------------------------------------------ *
      * Parametros RV para Certificaso de Coberturas
      * ------------------------------------------------------------ *
     D certComRvs_t    ds                  qualified template
     D   ubic                        36a
     D   copo                         5  0
     D   cops                         1  0
     D   loca                        25a
     D   dviv                        60a
     D   ctds                        20a

      * ------------------------------------------------------------ *
      * Parametros Autos para Certificaso de Coberturas
      * ------------------------------------------------------------ *
     D certAut_t       ds                  qualified template
     D   ramd                        20a
     D   ivig                         8  0
     D   fvig                         8  0
     D   asno                        40a
     D   domi                        25a
     D   copo                         5  0
     D   cops                         1  0
     D   loca                        25a
     D   neml                        50a
     D   endo                         7  0
     D   vhde                        40a
     D   vhaÑ                         4  0
     D   moto                        25a
     D   chas                        25a
     D   nmat                        25a
     D   vhvu                        15  2
     D   ifra                        15p 2
     D   vhcd                        15
     D   cobl                         2a
     D   apno                        40a
     D   cvde                        20a
     D   vhdu                        15a

      * ------------------------------------------------------------ *
      * Parametros Embarcaciones para Certificaso de Coberturas
      * ------------------------------------------------------------ *
     D certEmb_t       ds                  qualified template
     D   ramd                        20a
     D   ivig                         8  0
     D   fvig                         8  0
     D   asno                        40a
     D   domi                        25a
     D   copo                         5  0
     D   cops                         1  0
     D   loca                        25a
     D   neml                        50a
     D   endo                         7  0
     D   emcn                        50a
     D   emcm                        10a
     D   emcf                        20a
     D   emca                         4  0
     D   emsc                        15  2
     D   emsm                        15  2
     D   emcd                        25a

      * ------------------------------------------------------------ *
      * Parametros RV para Certificaso de Coberturas
      * ------------------------------------------------------------ *
     D certRvs_t       ds                  qualified template
     D   ramd                        20a
     D   ivig                         8  0
     D   fvig                         8  0
     D   asno                        40a
     D   domi                        25a
     D   acop                         5  0
     D   acos                         1  0
     D   aloc                        25a
     D   ubic                        36a
     D   copo                         5  0
     D   cops                         1  0
     D   loca                        25a
     D   neml                        50a
     D   endo                         7  0
     D   dviv                        60a
     D   ctds                        20a


      * ------------------------------------------------------------ *
      * WSLCER_autos():         Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Automoviles                     *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos de Automoviles                *
      *                peDcob  -  Textos de Cobertura                *
      *                peDcobC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_autos...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certAut_t)
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_autosI():        Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Automoviles (Uso interno)       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos de Automoviles               *
      *                peDcob  -  Textos de Cobertura                *
      *                peDcobC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_autosI...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certAut_t)
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_embarcaciones()  Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Embarcaciones                   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi -  Datos de Embarcaciones              *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_embarcaciones...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certEmb_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_embarcacionesI() Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Embarcaciones (Uso interno)     *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos de Embarcaciones             *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_embarcacionesI...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certEmb_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_cofli()          Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Combinado Familiar              *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi -  Datos Combinado Familiar            *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_cofli...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_cofliI()         Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Combinado Familiar (Uso interno)*
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos Combinado Familiar           *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_cofliI...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_incon()          Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Integral Consorcios             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                pe
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi -  Datos Integral Consorcios           *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_incon...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t)  dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_inconI()         Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Integral Consorcios (Uso interno)
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi -  Datos Integral Consorcios           *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_inconI...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t)  dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_valParametros(): Valida Parametros de Entrada para    *
      *                         generacion de Certificados de Co-    *
      *                         bertura.                             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peMsgs  -  Mensaje de Error                   *
      *                peGrupo -  Grupo de la Rama                   *
      *                                                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D WSLCER_valParametros...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peMsgs                            likeds(paramMsgs)
     D   peGrupo                      1    options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * WSLCER_getDatos Comunes() Obtiene datos en comun para todo   *
      *                           tipo de Certificados de Cobertura. *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsCo  -  Datos Comunes                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getDatosComunes...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const options(*omit)
     D   peDsCo                            likeds(certCom_t)
      * ------------------------------------------------------------ *
      * WSLCER_getDatosAutos()    Obtiene datos de Automoviles para  *
      *                           Certificados de Cobertura.         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsAu  -  Datos de Automoviles               *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getDatosAutos...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsAu                            likeds(certComAut_t)
      * ------------------------------------------------------------ *
      * WSLCER_getDatosEmbarcaciones() Obtiene datos de Embarcacio-  *
      *                                nes para Certif.de Cobertura. *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsEm  -  Datos de Embarcaciones             *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getDatosEmbarcaciones...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsEm                            likeds(certComEmb_t)
      * ------------------------------------------------------------ *
      * WSLCER_getCoberturasRv()     Obtiene coberturas de Riesgos   *
      *                              Varios para Certificados de Co- *
      *                              bertura.                        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsLc  -  Cobertura de Riesgos Varios        *
      *                peDsLcC -  Cantidad de Elementos              *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getCoberturasRv...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
      * ------------------------------------------------------------ *
      * WSLCER_getDatosRv()          Obtiene Datos de Riesgos Varios *
      *                              para Certificados de Cobertura  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsRv  -  Datos de Riesgos Varios            *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getDatosRv...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsRv                            likeds(certComRvs_t)
      * ------------------------------------------------------------ *
      * WSLCER_getTxtAutos()         Obtiene Texto Cobertura para Au-*
      *                              tomoviles.                      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDcob  -  Textos de Cobertura                *
      *                peDcobC -  Cantidad de Elementos              *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getTxtAutos...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
      * ------------------------------------------------------------ *
      * WSLCER_getClausulas()        Obtiene Clausulas y Anexos      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getClausulas...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*nopass:*omit)
     D   peClanC                     10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * WSLCER_certCobertura()       Obtiene Datos para Certificados *
      *                              de Cobertura                    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsCo  -  Datos Comunes                      *
      *                peDsAu  -  Datos de Automoviles               *
      *                peDsEm  -  Datos de Embarcaciones             *
      *                peDsRv  -  Datos de Riesgos Varios            *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_certCobertura...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsCo                            likeds(certCom_t)
     D   peDsAu                            likeds(certComAut_t)
     D                                     options(*omit)
     D   peDsEm                            likeds(certComEmb_t)
     D                                     options(*omit)
     D   peDsRv                            likeds(certComRvs_t)
     D                                     options(*omit)
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * WSLCER_getUltSspo():    Retorna el ultimo suplemento de      *
      *                         Superpoliza afectado por el Compo-   *
      *                         nente.                               *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *                                                              *
      * Retorna: Ultimo Suplemento Superpoliza/ -1 si error          *
      * ------------------------------------------------------------ *
     D WSLCER_getUltSspo...
     D                 pr             3  0
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * WSLCER_getParmBase():   Retorna Parametros Base para el ca-  *
      *                         so de ser invocados los procedimien- *
      *                         tos en forma interna.                *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D WSLCER_getParmBase...
     D                 pr
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peBase                            likeds(paramBase)
      * ------------------------------------------------------------ *
      * WSLCER_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D WSLCER_inz      pr
      * ------------------------------------------------------------ *
      * WSLCER_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D WSLCER_end      pr
      * ------------------------------------------------------------ *
