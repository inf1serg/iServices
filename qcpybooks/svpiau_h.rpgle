      /if defined(SVPIAU_H)
      /eof
      /endif
      /define SVPIAU_H

      * ------------------------------------------------------------ *
      * Errores
      * ------------------------------------------------------------ *
      * Vehiculo no existe
     D SVPIAU_VHNE     C                   const(1)
      * Vehiculo ya existe
     D SVPIAU_VHEX     C                   const(2)
      * Marca no existe
     D SVPIAU_MANE     C                   const(3)
      * Marca Debe ser mayor a cero
     D SVPIAU_MAM0     C                   const(4)
      * Marca no puede ser blanco
     D SVPIAU_MBLK     C                   const(5)
      * Modelo Debe ser mayor a cero
     D SVPIAU_MOM0     C                   const(6)
      * Modelo no puede ser blanco
     D SVPIAU_MONB     C                   const(7)

      * ------------------------------------------------------------ *
      * Formato de registro
      * ------------------------------------------------------------ *
     D IAUTOS_t        ds                  qualified template
     D  i@cmar                        9  0
     D  i@dmar                       15a
     D  i@cmod                        9  0
     D  i@dmod                       40a
     D  i@cinf                        7  0
     D  i@grup                        3  0
     D  i@core                        6  0
     D  i@ano0                        4  0
     D  i@va99                        6  1
     D  i@va01                        6  1
     D  i@va02                        6  1
     D  i@va03                        6  1
     D  i@va04                        6  1
     D  i@va05                        6  1
     D  i@va06                        6  1
     D  i@va07                        6  1
     D  i@va08                        6  1
     D  i@va09                        6  1
     D  i@va10                        6  1
     D  i@va11                        6  1
     D  i@va12                        6  1
     D  i@va13                        6  1
     D  i@va14                        6  1
     D  i@va15                        6  1
     D  i@va16                        6  1
     D  i@va17                        6  1
     D  i@va18                        6  1
     D  i@va19                        6  1

      * ------------------------------------------------------------ *
      * Formato de registro
      * ------------------------------------------------------------ *
     D IAUTO2_t        ds                  qualified template
     D  i@cmar                        9  0
     D  i@dmar                       15a
     D  i@cmod                        9  0
     D  i@dmod                       40a
     D  i@cinf                        7  0
     D  i@grup                        3  0
     D  i@core                        7  0
     D  i@ano0                        4  0
     D  i@va99                        6  1
     D  i@va01                        6  1
     D  i@va02                        6  1
     D  i@va03                        6  1
     D  i@va04                        6  1
     D  i@va05                        6  1
     D  i@va06                        6  1
     D  i@va07                        6  1
     D  i@va08                        6  1
     D  i@va09                        6  1
     D  i@va10                        6  1
     D  i@va11                        6  1
     D  i@va12                        6  1
     D  i@va13                        6  1
     D  i@va14                        6  1
     D  i@va15                        6  1
     D  i@va16                        6  1
     D  i@va17                        6  1
     D  i@va18                        6  1
     D  i@va19                        6  1
     D  i@comb                        3a
     D  i@alim                        3a
     D  i@moto                       10  0
     D  i@puer                        1a
     D  i@clas                        3a
     D  i@cabi                        4a
     D  i@carg                        1a
     D  i@peso                       10  0
     D  i@velo                       10  0
     D  i@pote                       10  0
     D  i@dire                        3a
     D  i@aire                        2a
     D  i@trac                        3a
     D  i@impo                        2a
     D  i@caja                        3a
     D  i@fabs                        2a
     D  i@airb                        2a
     D  i@clim                        2a
     D  i@fant                        2a
     D  i@tcor                        2a
     D  i@sest                        2a
     D  i@alat                        2a
     D  i@acab                        2a
     D  i@acor                        2a
     D  i@arod                        2a
     D  i@fiso                        2a
     D  i@ctra                        2a
     D  i@cest                        2a
     D  i@cdes                        2a
     D  i@sape                        2a
     D  i@dina                        2a
     D  i@bdif                        2a
     D  i@rele                        2a
     D  i@afre                        2a
     D  i@rpar                        2a
     D  i@larg                        5  2
     D  i@anch                        5  2
     D  i@alto                        5  2
     D  i@tapc                        2a
     D  i@aele                        2a
     D  i@cabo                        2a
     D  i@fxen                        2a
     D  i@lale                        2a
     D  i@tpan                        2a
     D  i@sllu                        2a
     D  i@scre                        2a
     D  i@ipne                        2a
     D  i@vlev                        2a
     D  i@blue                        2a
     D  i@ater                        2a
     D  i@rfla                        2a

      * ------------------------------------------------------------ *
      * inz():         Inicializar Módulo                            *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPIAU_inz      pr

      * ------------------------------------------------------------ *
      * end():         Finalizar   Módulo                            *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPIAU_end      pr

      * ------------------------------------------------------------ *
      * error():       Retornar último error del módulo              *
      *                                                              *
      *     peErrn  (output) Código de Error                         *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPIAU_error    pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit )

      * ------------------------------------------------------------ *
      * chkVehiculo(): Verifica existencia de vehículo               *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (input)  Código de Modelo                        *
      *                                                              *
      * Retorna: *on existe, *off no existe                          *
      * ------------------------------------------------------------ *
     D SVPIAU_chkVehiculo...
     D                 pr             1N
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const

      * ------------------------------------------------------------ *
      * chkMarca():    Verifica existencia de una marca              *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *                                                              *
      * Retorna: *on existe, *off no existe                          *
      * ------------------------------------------------------------ *
     D SVPIAU_chkMarca...
     D                 pr             1N
     D  peCmar                        9  0 const

      * ------------------------------------------------------------ *
      * getMarca():    Retorna descripción de Marca                  *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peDmar  (output) Descripción de Marca                    *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPIAU_getMarca...
     D                 pr            10i 0
     D  peCmar                        9  0 const
     D  peDmar                       15a

      * ------------------------------------------------------------ *
      * getVehiculo(): Retorna registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (input)  Código de Modelo                        *
      *     peVehi  (output) Registro                                *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPIAU_getVehiculo...
     D                 pr            10i 0
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const
     D  peVehi                             likeds(IAUTOS_t)

      * ------------------------------------------------------------ *
      * getVehicul2(): Retorna registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (input)  Código de Modelo                        *
      *     peVehi  (output) Registro                                *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPIAU_getVehicul2...
     D                 pr            10i 0
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const
     D  peVehi                             likeds(IAUTO2_t)

      * ------------------------------------------------------------ *
      * setVehiculo(): Inserta registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peVehi  (input)  Registro a insertar                     *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPIAU_setVehiculo...
     D                 pr            10i 0
     D  peVehi                             likeds(IAUTOS_t)

      * ------------------------------------------------------------ *
      * setVehicul2(): Inserta registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peVehi  (input)  Registro a insertar                     *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPIAU_setVehicul2...
     D                 pr            10i 0
     D  peVehi                             likeds(IAUTO2_t)

      * ------------------------------------------------------------ *
      * getDescModelo: Retorna descripción de Modelo                 *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (output) Código de Modelo                        *
      *                                                              *
      * Retorna: Descripcion si encuentra / Blanco si no encuentra   *
      * ------------------------------------------------------------ *
     D SVPIAU_getDescModelo...
     D                 pr            40
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const

