     H nomain
      * ************************************************************ *
      * SVPIAU:    Programa de Servicio                              *
      *            Accesos a tabla de INFOAUTO                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *20-May-2016            *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 26/12/17  : Se argega nuevo procedimiento :              *
      *                 getDescModelo()                              *
      * ************************************************************ *
     Fiautos    uf a e           k disk    usropn

     D Initialized     s              1N
     D SVPIAU_errn     s             10i 0
     D SVPIAU_errm     s             80a

     D SetError        pr
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /copy './qcpybooks/svpiau_h.rpgle'

      * ------------------------------------------------------------ *
      * inz():         Inicializar Módulo                            *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPIAU_inz      B                   Export
     D SVPIAU_inz      pi

      /free

       if Initialized;
          return;
       endif;

       if not %open(iautos);
          open iautos;
       endif;

       Initialized = *ON;

       return;

      /end-free

     P SVPIAU_inz      E

      * ------------------------------------------------------------ *
      * end():         Finalizar   Módulo                            *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPIAU_end      B                   Export
     D SVPIAU_end      pi

      /free

       close *all;
       Initialized = *OFF;

       return;

      /end-free

     P SVPIAU_end      E

      * ------------------------------------------------------------ *
      * error():       Retornar último error del módulo              *
      *                                                              *
      *     peErrn  (output) Código de Error                         *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPIAU_error    B                   Export
     D SVPIAU_error    pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit )

      /free

       if %parms >= 1 and %addr(peErrn) <> *NULL;
          peErrn = SVPIAU_errn;
       endif;

       return SVPIAU_errm;

      /end-free

     P SVPIAU_error    E

      * ------------------------------------------------------------ *
      * chkVehiculo(): Verifica existencia de vehículo               *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (input)  Código de Modelo                        *
      *                                                              *
      * Retorna: *on existe, *off no existe                          *
      * ------------------------------------------------------------ *
     P SVPIAU_chkVehiculo...
     P                 B                   Export
     D SVPIAU_chkVehiculo...
     D                 pi             1N
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const

     D k1iuto          ds                  likerec(i1utos:*key)

      /free

        SVPIAU_inz();

        k1iuto.i@cmar = peCmar;
        k1iuto.i@cmod = peCmod;

        setll %kds(k1iuto) iautos;
        if not %equal;
           SetError( SVPIAU_VHNE
                   : 'El Vehículo no existe' );
           return *OFF;
        endif;

        return *ON;

      /end-free

     P SVPIAU_chkVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * chkMarca():    Verifica existencia de una marca              *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *                                                              *
      * Retorna: *on existe, *off no existe                          *
      * ------------------------------------------------------------ *
     P SVPIAU_chkMarca...
     P                 B                   export
     D SVPIAU_chkMarca...
     D                 pi             1N
     D  peCmar                        9  0 const

     D k1iuto          ds                  likerec(i1utos:*key)

      /free

        SVPIAU_inz();

        k1iuto.i@cmar = peCmar;

        setll %kds(k1iuto:1) iautos;
        if not %equal;
           SetError( SVPIAU_MANE
                   : 'Marca no existe' );
           return *OFF;
        endif;

        return *ON;

      /end-free

     P SVPIAU_chkMarca...
     P                 E

      * ------------------------------------------------------------ *
      * getMarca():    Retorna descripción de Marca                  *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peDmar  (output) Descripción de Marca                    *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPIAU_getMarca...
     P                 B                   export
     D SVPIAU_getMarca...
     D                 pi            10i 0
     D  peCmar                        9  0 const
     D  peDmar                       15a

     D k1iuto          ds                  likerec(i1utos:*key)

      /free

        SVPIAU_inz();

        if SVPIAU_chkMarca( peCmar ) = *OFF;
           return -1;
        endif;

        k1iuto.i@cmar = peCmar;

        chain(n) %kds(k1iuto:1) iautos;
        if not %found;
           SetError( SVPIAU_MANE
                   : 'Marca no existe' );
           return -1;
        endif;

        peDmar = i@dmar;
        return 0;

      /end-free

     P SVPIAU_getMarca...
     P                 E

      * ------------------------------------------------------------ *
      * getVehiculo(): Retorna registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (input)  Código de Modelo                        *
      *     peVehi  (output) Registro                                *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPIAU_getVehiculo...
     P                 B                   export
     D SVPIAU_getVehiculo...
     D                 pi            10i 0
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const
     D  peVehi                             likeds(IAUTOS_t)

     D inVehi          ds                  likeds(IAUTO2_t)
     D rc              s             10i 0

      /free

        clear inVehi;

        rc = SVPIAU_getVehicul2( peCmar : peCmod : inVehi );

        if rc = 0;
           eval-corr peVehi = inVehi;
        endif;

        return rc;

      /end-free

     P SVPIAU_getVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * getVehicul2(): Retorna registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (input)  Código de Modelo                        *
      *     peVehi  (output) Registro                                *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPIAU_getVehicul2...
     P                 B                   export
     D SVPIAU_getVehicul2...
     D                 pi            10i 0
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const
     D  peVehi                             likeds(IAUTO2_t)

     D k1iuto          ds                  likerec(i1utos:*key)
     D inVehi          ds                  likerec(i1utos:*input)

      /free

        SVPIAU_inz();

        clear peVehi;

        if SVPIAU_chkVehiculo( peCmar: peCmod ) = *OFF;
           return -1;
        endif;

        k1iuto.i@cmar = peCmar;
        k1iuto.i@cmod = peCmod;

        chain(n) %kds(k1iuto) iautos inVehi;
        if %found;
           eval-corr peVehi = inVehi;
        endif;

        return 0;

      /end-free

     P SVPIAU_getVehicul2...
     P                 E

      * ------------------------------------------------------------ *
      * setVehiculo(): Inserta registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peVehi  (input)  Registro a insertar                     *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPIAU_setVehiculo...
     P                 B                   Export
     D SVPIAU_setVehiculo...
     D                 pi            10i 0
     D  peVehi                             likeds(IAUTOS_t)

     D ouVehi          ds                  likeds(IAUTO2_t)

      /free

       clear ouVehi;
       eval-corr ouVehi = peVehi;

       return SVPIAU_setVehicul2(ouVehi);

      /end-free

     P SVPIAU_setVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * setVehicul2(): Inserta registro INFOAUTO de un vehículo      *
      *                                                              *
      *     peVehi  (input)  Registro a insertar                     *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPIAU_setVehicul2...
     P                 B                   Export
     D SVPIAU_setVehicul2...
     D                 pi            10i 0
     D  peVehi                             likeds(IAUTO2_t)

     D k1iuto          ds                  likerec(i1utos:*key)

      /free

       SVPIAU_inz();

       if peVehi.i@cmar <= 0;
          SetError( SVPIAU_MAM0
                  : 'Marca debe ser mayor a cero' );
          return -1;
       endif;

       if peVehi.i@dmar = *blanks;
          SetError( SVPIAU_MBLK
                  : 'Marca no puede ser blanco' );
          return -1;
       endif;

       if peVehi.i@cmod <= 0;
          SetError( SVPIAU_MOM0
                  : 'Modelo debe ser mayor a cero' );
          return -1;
       endif;

       if peVehi.i@dmod = *blanks;
          SetError( SVPIAU_MONB
                  : 'Modelo no puede ser blanco' );
          return -1;
       endif;

       eval-corr k1iuto = peVehi;

       if SVPIAU_chkVehiculo( peVehi.i@cmar: peVehi.i@cmod ) = *ON;
          chain %kds(k1iuto) iautos;
          i@dmar = peVehi.i@dmar;
          i@dmod = peVehi.i@dmod;
          i@cinf = peVehi.i@cinf;
          i@grup = peVehi.i@grup;
          i@core = peVehi.i@core;
          i@ano0 = peVehi.i@ano0;
          i@va99 = peVehi.i@va99;
          i@va01 = peVehi.i@va01;
          i@va02 = peVehi.i@va02;
          i@va03 = peVehi.i@va03;
          i@va04 = peVehi.i@va04;
          i@va05 = peVehi.i@va05;
          i@va06 = peVehi.i@va06;
          i@va07 = peVehi.i@va07;
          i@va08 = peVehi.i@va08;
          i@va09 = peVehi.i@va09;
          i@va10 = peVehi.i@va10;
          i@va11 = peVehi.i@va11;
          i@va12 = peVehi.i@va12;
          i@va13 = peVehi.i@va13;
          i@va14 = peVehi.i@va14;
          i@va15 = peVehi.i@va15;
          i@va16 = peVehi.i@va16;
          i@va17 = peVehi.i@va17;
          i@va18 = peVehi.i@va18;
          i@va19 = peVehi.i@va19;
          i@comb = peVehi.i@comb;
          i@alim = peVehi.i@alim;
          i@moto = peVehi.i@moto;
          i@puer = peVehi.i@puer;
          i@clas = peVehi.i@clas;
          i@cabi = peVehi.i@cabi;
          i@carg = peVehi.i@carg;
          i@peso = peVehi.i@peso;
          i@velo = peVehi.i@velo;
          i@pote = peVehi.i@pote;
          i@dire = peVehi.i@dire;
          i@aire = peVehi.i@aire;
          i@trac = peVehi.i@trac;
          i@impo = peVehi.i@impo;
          i@caja = peVehi.i@caja;
          i@fabs = peVehi.i@fabs;
          i@airb = peVehi.i@airb;
          i@clim = peVehi.i@clim;
          i@fant = peVehi.i@fant;
          i@tcor = peVehi.i@tcor;
          i@sest = peVehi.i@sest;
          i@alat = peVehi.i@alat;
          i@acab = peVehi.i@acab;
          i@acor = peVehi.i@acor;
          i@arod = peVehi.i@arod;
          i@fiso = peVehi.i@fiso;
          i@ctra = peVehi.i@ctra;
          i@cest = peVehi.i@cest;
          i@cdes = peVehi.i@cdes;
          i@sape = peVehi.i@sape;
          i@dina = peVehi.i@dina;
          i@bdif = peVehi.i@bdif;
          i@rele = peVehi.i@rele;
          i@afre = peVehi.i@afre;
          i@rpar = peVehi.i@rpar;
          i@larg = peVehi.i@larg;
          i@anch = peVehi.i@anch;
          i@alto = peVehi.i@alto;
          i@tapc = peVehi.i@tapc;
          i@aele = peVehi.i@aele;
          i@cabo = peVehi.i@cabo;
          i@fxen = peVehi.i@fxen;
          i@lale = peVehi.i@lale;
          i@tpan = peVehi.i@tpan;
          i@sllu = peVehi.i@sllu;
          i@scre = peVehi.i@scre;
          i@ipne = peVehi.i@ipne;
          i@vlev = peVehi.i@vlev;
          i@blue = peVehi.i@blue;
          i@ater = peVehi.i@ater;
          i@rfla = peVehi.i@rfla;
          update i1utos;
        else;
          i@cmar = peVehi.i@cmar;
          i@dmar = peVehi.i@dmar;
          i@cmod = peVehi.i@cmod;
          i@dmod = peVehi.i@dmod;
          i@cinf = peVehi.i@cinf;
          i@grup = peVehi.i@grup;
          i@core = peVehi.i@core;
          i@ano0 = peVehi.i@ano0;
          i@va99 = peVehi.i@va99;
          i@va01 = peVehi.i@va01;
          i@va02 = peVehi.i@va02;
          i@va03 = peVehi.i@va03;
          i@va04 = peVehi.i@va04;
          i@va05 = peVehi.i@va05;
          i@va06 = peVehi.i@va06;
          i@va07 = peVehi.i@va07;
          i@va08 = peVehi.i@va08;
          i@va09 = peVehi.i@va09;
          i@va10 = peVehi.i@va10;
          i@va11 = peVehi.i@va11;
          i@va12 = peVehi.i@va12;
          i@va13 = peVehi.i@va13;
          i@va14 = peVehi.i@va14;
          i@va15 = peVehi.i@va15;
          i@va16 = peVehi.i@va16;
          i@va17 = peVehi.i@va17;
          i@va18 = peVehi.i@va18;
          i@va19 = peVehi.i@va19;
          i@comb = peVehi.i@comb;
          i@alim = peVehi.i@alim;
          i@moto = peVehi.i@moto;
          i@puer = peVehi.i@puer;
          i@clas = peVehi.i@clas;
          i@cabi = peVehi.i@cabi;
          i@carg = peVehi.i@carg;
          i@peso = peVehi.i@peso;
          i@velo = peVehi.i@velo;
          i@pote = peVehi.i@pote;
          i@dire = peVehi.i@dire;
          i@aire = peVehi.i@aire;
          i@trac = peVehi.i@trac;
          i@impo = peVehi.i@impo;
          i@caja = peVehi.i@caja;
          i@fabs = peVehi.i@fabs;
          i@airb = peVehi.i@airb;
          i@clim = peVehi.i@clim;
          i@fant = peVehi.i@fant;
          i@tcor = peVehi.i@tcor;
          i@sest = peVehi.i@sest;
          i@alat = peVehi.i@alat;
          i@acab = peVehi.i@acab;
          i@acor = peVehi.i@acor;
          i@arod = peVehi.i@arod;
          i@fiso = peVehi.i@fiso;
          i@ctra = peVehi.i@ctra;
          i@cest = peVehi.i@cest;
          i@cdes = peVehi.i@cdes;
          i@sape = peVehi.i@sape;
          i@dina = peVehi.i@dina;
          i@bdif = peVehi.i@bdif;
          i@rele = peVehi.i@rele;
          i@afre = peVehi.i@afre;
          i@rpar = peVehi.i@rpar;
          i@larg = peVehi.i@larg;
          i@anch = peVehi.i@anch;
          i@alto = peVehi.i@alto;
          i@tapc = peVehi.i@tapc;
          i@aele = peVehi.i@aele;
          i@cabo = peVehi.i@cabo;
          i@fxen = peVehi.i@fxen;
          i@lale = peVehi.i@lale;
          i@tpan = peVehi.i@tpan;
          i@sllu = peVehi.i@sllu;
          i@scre = peVehi.i@scre;
          i@ipne = peVehi.i@ipne;
          i@vlev = peVehi.i@vlev;
          i@blue = peVehi.i@blue;
          i@ater = peVehi.i@ater;
          i@rfla = peVehi.i@rfla;
          write i1utos;
       endif;

       return 0;

      /end-free

     P SVPIAU_setVehicul2...
     P                 E

      * ------------------------------------------------------------ *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       SVPIAU_errn = peErrn;
       SVPIAU_errm = peErrm;

      /end-free

     P SetError        E

      * ------------------------------------------------------------ *
      * getDescModelo: Retorna descripción de Modelo                 *
      *                                                              *
      *     peCmar  (input)  Código de Marca                         *
      *     peCmod  (output) Código de Modelo                        *
      *                                                              *
      * Retorna: Descripcion si encuentra / Blanco si no encuentra   *
      * ------------------------------------------------------------ *
     P SVPIAU_getDescModelo...
     P                 B                   export
     D SVPIAU_getDescModelo...
     D                 pi            40
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const

     D  @@vehi         ds                  likeds(IAUTOS_t)

      /free

        SVPIAU_inz();

        clear @@vehi;

        if SVPIAU_getVehiculo( peCmar : peCmod : @@vehi ) = -1;
          return *blanks;
        endif;

        return @@vehi.i@dmod;

      /end-free

     P SVPIAU_getDescModelo...
     P                 E

