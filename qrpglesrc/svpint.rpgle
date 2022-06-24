     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPINT: Devolver datos de Intermediarios                     *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                   31-Mar-2017             *
      * ------------------------------------------------------------ *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      * GIO 22/01/2018 Agregado de Nuevos procedimientos:            *
      *                - SVPINT_getIntermediario                     *
      *                - SVPINT_getNroDaf                            *
      *                Modificacion de procedimientos:               *
      *                - SVPINT_GetNombre                            *
      *                - SVPINT_GetCuit                              *
      * JSN 26/01/2018 Nuevos Procedimientos:                        *
      *                - SVPINT_getTelefonos                         *
      *                - SVPINT_getTelefonosWeb                      *
      * JSN 11/07/2018 Nuevos Procedimientos:                        *
      *                - SVPINT_setMostrarDatosContacto              *
      *                - SVPINT_setMostrarTelefonos                  *
      *                - SVPINT_setMostrarMails                      *
      *                - SVPINT_isMostrarTelefonos                   *
      *                - SVPINT_isMostrarMails                       *
      * LRG 18/07/2018 Nuevos Procedimientos:                        *
      *                - SVPINT_getMaILWeb                           *
      * EXT 20/07/2018 Modicacion Procedimientos:                    *
      *                - SVPINT_isMostrarTelefonos                   *
      *                - SVPINT_isMostrarMails                       *
      * EXT 12/11/2018 Nuevos Procedimientos:                        *
      *                - SVPINT_chkDescuentoWeb                      *
      *                - SVPINT_getDescuentoWeb                      *
      * JSN 21/03/2019 Nuevo procedimiento:                          *
      *                - SVPINT_isCabeceraEspecial                   *
      * EXT 04/01/2019 RM#03689 Requerimiento SSN. Nuevos            *
      *                Procedimientos:                               *
      *                - SVPINT_getMatricula                         *
      * NWN 06/08/2020 Nuevo procedimiento:                          *
      *                - SVPINT_getMayorAuxiliar                     *
      * SGF 04/07/2021 Nuevo procedimiento:                          *
      *                - SVPINT_bloquearVoucher.                     *
      *                                                              *
      * ************************************************************ *
     Fsehni2    if   e           k disk    usropn
     Fset290    if   e           k disk    usropn
     Fsehni4d   uf a e           k disk    usropn
     Fsehni4e   uf a e           k disk    usropn prefix(nn:2)

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpint_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
      * --------------------------------------------------- *
     D SPCADCOM        pr                  extpgm('SPCADCOM')
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1  0
     D  nivc                          5  0
     D  cade                          5  0 dim(9)
     D  erro                           n
     D  endp                          3a
     D  nrdf                          7  0 dim(9) options(*nopass)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  Empresa                       1a   const
     D  AÑo                           4  0
     D  Mes                           2  0
     D  Dia                           2  0

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPINT_GetNombre: Recupera Nombre de Intermediario.          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: Nombre / *blanks                                    *
      * ------------------------------------------------------------ *

     P SVPINT_GetNombre...
     P                 B                   export
     D SVPINT_GetNombre...
     D                 pi            40
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D @@DsInte        ds                  likeds( DsSehni2_t )

      /free

        SVPINT_inz();

        if SVPINT_getIntermediario( peEmpr   :
                                    peSucu   :
                                    peNivt   :
                                    peNivc   :
                                    @@DsInte ) = 0;

          return SVPDAF_getNombre( @@DsInte.n2nrdf );

        endif;

        return *blanks;

      /end-free

     P SVPINT_GetNombre...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_GetCadena: Recupera Cadena de Intermediario.          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peNrdf   (input)   Nro de Cliente                        *
      *                                                              *
      * Retorna: *On= Encontro / *off = Error                        *
      * ------------------------------------------------------------ *

     P SVPINT_GetCadena...
     P                 B                   export
     D SVPINT_GetCadena...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peCade                       5  0 dim(9)
     D   peNrdf                       7  0 dim(9) options(*nopass)

     D   @@empr        s              1
     D   @@sucu        s              2
     D   @@nivt        s              1  0
     D   @@nivc        s              5  0
     D   @@cade        s              5  0 dim(9)
     D   @@erro        s               n
     D   @@nrdf        s              7  0 dim(9)
     D   @@finp        s              3a

      /free

       SVPINT_inz();
       @@empr = peEmpr;
       @@sucu = peSucu;
       @@nivt = peNivt;
       @@nivc = peNivc;
       @@cade = peCade;
       clear peCade;
       if %parms >=6 and %addr(peNrdf) <>*Null;
         @@nrdf = peNrdf;
         SPCADCOM ( @@empr
                  : @@sucu
                  : @@nivt
                  : @@nivc
                  : @@cade
                  : @@erro
                  : @@finp
                  : @@nrdf );
       else;
         SPCADCOM ( @@empr
                  : @@sucu
                  : @@nivt
                  : @@nivc
                  : @@cade
                  : @@erro
                  : @@finp );
       endif;
       eval peCade = @@cade;
       return @@erro;

      /end-free
     P SVPINT_GetCadena...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_GetCuit: Recuopera CUIT de un Intermediario.          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: CUIT / *blanks                                      *
      * ------------------------------------------------------------ *

     P SVPINT_GetCuit...
     P                 B                   export
     D SVPINT_GetCuit...
     D                 pi            11
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D @@DsInte        ds                  likeds( DsSehni2_t )
     D   @@cuit        s             11

      /free

        SVPINT_inz();

        clear @@cuit;

        if SVPINT_getIntermediario( peEmpr   :
                                    peSucu   :
                                    peNivt   :
                                    peNivc   :
                                    @@DsInte ) = 0;

          SVPDAF_getDocumento( @@DsInte.n2nrdf
                             : *omit
                             : *omit
                             : @@cuit
                             : *omit
                             : *omit );

        endif;

        return @@cuit;

      /end-free

     P SVPINT_GetCuit...
     P                 E


      * ------------------------------------------------------------ *
      * SVPINT_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPINT_inz      B                   export
     D SVPINT_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(sehni2);
         open sehni2;
       endif;

       if not %open(sehni4d);
         open sehni4d;
       endif;

       if not %open(set290);
         open set290;
       endif;

       if not %open(sehni4e);
         open sehni4e;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPINT_inz      E

      * ------------------------------------------------------------ *
      * SVPINT_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPINT_End      B                   export
     D SVPINT_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPINT_End      E

      * ------------------------------------------------------------ *
      * SVPINT_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPINT_Error    B                   export
     D SVPINT_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPINT_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_getIntermediario: Obtiene la informacion del          *
      *                          Intermediario.-                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peDsInte (output)  Estructura Intermediario              *
      *                                                              *
      * Retorna: 0 = Si coincide la Clave / -1 = Si no coincide      *
      * ------------------------------------------------------------ *
     P SVPINT_getIntermediario...
     P                 B                   export
     D SVPINT_getIntermediario...
     D                 pi             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peDsInte                          likeds( DsSehni2_t )

     D   k1yni2        ds                  likerec( s1hni2 : *key )
     D   dseni2        ds                  likerec( s1hni2 : *input)

      /free

        SVPINT_inz();

        clear peDsInte;
        clear dseni2;
        clear k1yni2;

        k1yni2.n2empr = peEmpr;
        k1yni2.n2sucu = peSucu;
        k1yni2.n2nivt = peNivt;
        k1yni2.n2nivc = peNivc;
        chain %kds( k1yni2 : 4 ) sehni2 dseni2;
        if %found( sehni2 );
          eval-corr peDsInte = dseni2;
          return 0;
        endif;

        return -1;

      /end-free
     P SVPINT_getIntermediario...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_getNroDaf: Obtiene el numero de persona del           *
      *                   Intermediario.-                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: Numero de persona / -1 ... Si encuentra en archivo  *
      * ------------------------------------------------------------ *
     P SVPINT_getNroDaf...
     P                 B                   export
     D SVPINT_getNroDaf...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D @@DsInte        ds                  likeds( DsSehni2_t )

      /free

        SVPINT_inz();

        clear @@DsInte;

        if SVPINT_getIntermediario( peEmpr   :
                                    peSucu   :
                                    peNivt   :
                                    peNivc   :
                                    @@DsInte ) = 0;

          return @@DsInte.n2nrdf;

        endif;

        return -1;

      /end-free
     P SVPINT_getNroDaf...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_getTelefonos: Obtiene los números telefónico del      *
      *                      Intermediario.-                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peCont   (output)  Estructura Telefonos/Pagina Web       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_getTelefonos...
     P                 B                   export
     D SVPINT_getTelefonos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peCont                            likeDs(dsCont_t)

     D @@Nrdf          s              7  0

      /free

        SVPINT_inz();

        clear @@Nrdf;
        clear peCont;

        @@Nrdf = SVPINT_getNroDaf( peEmpr
                                 : peSucu
                                 : peNivt
                                 : peNivc );
        if @@Nrdf > *zeros;

          SVPDAF_getDa6 ( @@Nrdf
                        : peCont.tpa1
                        : peCont.tpa2
                        : peCont.ttr1
                        : peCont.ttr2
                        : peCont.tcel
                        : peCont.tpag
                        : peCont.tfa1
                        : peCont.tfa2
                        : peCont.tfa3
                        : peCont.pweb );

        else;
          return *off;
        endif;

        return *on;

      /end-free
     P SVPINT_getTelefonos...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_getTelefonosWeb: Obtiene los números telefónico del   *
      *                         Intermediario que se puedan mostrar  *
      *                         en la Web.-                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peDsTl   (output)  Estructura Telefonos en la Web        *
      *     peDsTlC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_getTelefonosWeb...
     P                 B                   export
     D SVPINT_getTelefonosWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peDsTl                            likeds ( DsTelPublic_t )
     D                                     dim(10)
     D   peDsTlC                     10i 0

     D @@Nrdf          s              7  0

      /free

        SVPINT_inz();

        clear @@Nrdf;
        clear peDsTl;
        clear peDsTlc;

        @@Nrdf = SVPINT_getNroDaf( peEmpr
                                 : peSucu
                                 : peNivt
                                 : peNivc );

        if @@Nrdf > *Zeros;

          SVPDAF_getDa9 ( @@Nrdf
                        : peDsTl
                        : peDsTlC
                        : *omit   );

        else;
          return *off;
        endif;

        return *on;

      /end-free
     P SVPINT_getTelefonosWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_setMostrarDatosContacto: Graba mostrar datos del      *
      *                                 contacto del intermediario.- *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peTipo   (input)   Tipo de Contacto                      *
      *     peMar1   (input)   Mostrar Si o No                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_setMostrarDatosContacto...
     P                 B                   export
     D SVPINT_setMostrarDatosContacto...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peTipo                       1    const
     D   peMar1                       1    const

     D k1yi4d          ds                  likerec( s1hni4d: *key )

     D @@AÑo           s              4  0
     D @@Mes           s              2  0
     D @@Dia           s              2  0
     D @@Fech          s              8  0
     D @@Mar1          s              1
     D @@Secu          s             10i 0

      /free

        SVPINT_inz();

        // Valida valores para "Tipo de Contacto"

        if peTipo <> 'T' and peTipo <> 'M';
          return *off;
        endif;

        // Retorna fecha de Hoy

        PAR310X3 ( peEmpr
                 : @@AÑo
                 : @@Mes
                 : @@Dia  );

        @@Fech = (@@AÑo * 10000) + (@@Mes * 100) + @@Dia;
        @@Secu = 1;

        // Mostrar "Si" o "No" el Contacto del Intermediario

        if peMar1 = 'S';
          @@Mar1 = '1';
        else;
          @@Mar1 = '0';
        endif;

        // Verifica Si ya existe un registro para EMPR/SUCU/NIVT/NIVC/TIPO/FECH
        // sumar 1 a la secuencia

        k1yi4d.n4Empr = peEmpr;
        k1yi4d.n4Sucu = peSucu;
        k1yi4d.n4Nivt = peNivt;
        k1yi4d.n4Nivc = peNivc;
        k1yi4d.n4Tipo = peTipo;
        k1yi4d.n4Fech = @@Fech;
        chain %kds( k1yi4d : 6 ) sehni4d;
        if %found( sehni4d );
          @@Secu = n4Secu + @@Secu;
        endif;

        n4Empr = peEmpr;
        n4Sucu = peSucu;
        n4Nivt = peNivt;
        n4Nivc = peNivc;
        n4Tipo = peTipo;
        n4Fech = @@Fech;
        n4Secu = @@Secu;
        n4Mar1 = @@Mar1;
        n4Mar2 = '0';
        n4Mar3 = '0';
        n4Mar4 = '0';
        n4Mar5 = '0';
        n4Mar6 = '0';
        n4Mar7 = '0';
        n4Mar8 = '0';
        n4Mar9 = '0';
        n4Mar0 = '0';
        n4Date = %dec(%date);
        n4Time = %dec(%time);
        n4User = @PsDs.CurUsr;

        write s1hni4d;
        return *on;

      /end-free
     P SVPINT_setMostrarDatosContacto...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_setMostrarTelefonos: Graba si se puede mostrar        *
      *                             teléfono de intermediario.-      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peMar1   (input)   Mostrar Si o No                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_setMostrarTelefonos...
     P                 B                   export
     D SVPINT_setMostrarTelefonos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMar1                       1    const

      /free

        SVPINT_inz();

        if SVPINT_setMostrarDatosContacto( peEmpr
                                         : peSucu
                                         : peNivt
                                         : peNivc
                                         : 'T'
                                         : peMar1 );
          return *on;
        endif;

        return *off;

      /end-free
     P SVPINT_setMostrarTelefonos...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_setMostrarMails: Graba si se puede mostrar mails      *
      *                         de intermediario.-                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peMar1   (input)   Mostrar Si o No                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_setMostrarMails...
     P                 B                   export
     D SVPINT_setMostrarMails...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMar1                       1    const

      /free

        SVPINT_inz();

        if SVPINT_setMostrarDatosContacto( peEmpr
                                         : peSucu
                                         : peNivt
                                         : peNivc
                                         : 'M'
                                         : peMar1 );
          return *on;
        endif;

        return *off;

      /end-free
     P SVPINT_setMostrarMails...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_isMostrarTelefonos: Retorna si se puede mostrar       *
      *                            teléfono de intermediario.-       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peFech   (input)   Fecha (Opcional)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_isMostrarTelefonos...
     P                 B                   export
     D SVPINT_isMostrarTelefonos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 options(*nopass:*omit) const

     D k1yi4d          ds                  likerec( s1hni4d: *key )

     D @@AÑo           s              4  0
     D @@Mes           s              2  0
     D @@Dia           s              2  0
     D @@Fech          s              8  0

      /free

        SVPINT_inz();

        k1yi4d.n4Empr = peEmpr;
        k1yi4d.n4Sucu = peSucu;
        k1yi4d.n4Nivt = peNivt;
        k1yi4d.n4Nivc = peNivc;
        k1yi4d.n4Tipo = 'T';

        if %parms >= 5 and %addr(peFech) <> *NULL;
          k1yi4d.n4Fech = peFech;
        else;
          // Retorna fecha de Hoy
          PAR310X3 ( peEmpr
                   : @@AÑo
                   : @@Mes
                   : @@Dia  );
          @@Fech = (@@AÑo * 10000) + (@@Mes * 100) + @@Dia;
          k1yi4d.n4Fech = @@Fech;
        endif;
        setll %kds( k1yi4d : 6 ) sehni4d;
        reade %kds( k1yi4d : 5 ) sehni4d;

        if not %eof( sehni4d );
          if n4Mar1 = '1';
            return *on;
          else;
            return *off;
          endif;
        endif;

        return *off;

      /end-free
     P SVPINT_isMostrarTelefonos...
     P                 E
      * ------------------------------------------------------------ *
      * SVPINT_isMostrarMails: Retorna si se puede mostrar Mails     *
      *                        de intermediario.-                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peFech   (input)   Fecha (Opcional)                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_isMostrarMails...
     P                 B                   export
     D SVPINT_isMostrarMails...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 options(*nopass:*omit) const

     D k1yi4d          ds                  likerec( s1hni4d: *key )

     D @@AÑo           s              4  0
     D @@Mes           s              2  0
     D @@Dia           s              2  0
     D @@Fech          s              8  0

      /free

        SVPINT_inz();

        k1yi4d.n4Empr = peEmpr;
        k1yi4d.n4Sucu = peSucu;
        k1yi4d.n4Nivt = peNivt;
        k1yi4d.n4Nivc = peNivc;
        k1yi4d.n4Tipo = 'M';

        if %parms >= 5 and %addr(peFech) <> *NULL;
          k1yi4d.n4Fech = peFech;
        else;
          // Retorna fecha de Hoy
          PAR310X3 ( peEmpr
                   : @@AÑo
                   : @@Mes
                   : @@Dia  );
          @@Fech = (@@AÑo * 10000) + (@@Mes * 100) + @@Dia;
          k1yi4d.n4Fech = @@Fech;
        endif;
        setll %kds( k1yi4d : 6 ) sehni4d;
        reade %kds( k1yi4d : 5 ) sehni4d;

        if not %eof( sehni4d );
          if n4Mar1 = '1';
            return *on;
          else;
            return *off;
          endif;
        endif;

        return *off;

      /end-free
     P SVPINT_isMostrarMails...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_getmaILWeb: Obtiene los correos Electronicos Web      *
      *                    de un Intermediario.-                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peMail   (output)  DS con los mails                      *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_getMaILWeb...
     P                 B                   export
     D SVPINT_getMaILWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

     D @@Nrdf          s              7  0

      /free
       SVPINT_inz();

       @@Nrdf = SVPINT_getNroDaf( peEmpr
                                : peSucu
                                : peNivt
                                : peNivc );

       if not SVPDAF_getMailWeb( @@nrdf
                               : peMail
                               : peMailC );
         return *off;
       endif;

       return *off;
      /end-free

     P SVPINT_getMaILWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_chkDescuentoWeb(): Retorna si existe en SET290        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peRama   (input)   Rama                                  *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_chkDescuentoWeb...
     P                 B                   export
     D SVPINT_chkDescuentoWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 Const
     D   peFech                       8  0 Options( *Nopass : *Omit ) Const

     D k1y290          ds                  likerec( s1t290 : *Key )

     D @@AÑo           s              4  0
     D @@Mes           s              2  0
     D @@Dia           s              2  0
     D @@fech          s              8  0

       SVPINT_inz();

       if %parms >= 6 and %addr( peFech ) <> *Null;
         @@fech = peFech;
       else;
         PAR310X3 ( peEmpr : @@AÑo : @@Mes : @@Dia  );
         @@Fech = (@@AÑo * 10000) + (@@Mes * 100) + @@Dia;
       endif;

       k1y290.t@empr = peEmpr;
       k1y290.t@sucu = peSucu;
       k1y290.t@nivt = peNivt;
       k1y290.t@nivc = peNivc;
       k1y290.t@rama = peRama;
       k1y290.t@fech = @@fech;
       setll %kds( k1y290 : 6 ) set290;
       reade %kds( k1y290 : 5 ) set290;

       select;
         when %eof( set290 );
           return *Off;
         when ( t@mar2 = '1' );
           return *Off;
         when ( t@defe = *Zeros ) and ( t@porc = *Zeros );
           return *Off;
         other;
           return *On;
       endsl;


     P SVPINT_chkDescuentoWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_getDescuentoWeb(): Retorna registro de SET290         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peRama   (input)   Rama                                  *
      *     peFech   (input)   Fecha                                 *
      *     peDeRe   (output)  DS con Descuento/Recargo              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_getDescuentoWeb...
     P                 B                   export
     D SVPINT_getDescuentoWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 Const
     D   peFech                       8  0 Options( *Omit ) Const
     D   peDeRe                            Likeds(dsSet290_t)

     D k1y290          ds                  likerec( s1t290 : *Key )

     D @@AÑo           s              4  0
     D @@Mes           s              2  0
     D @@Dia           s              2  0
     D @@fech          s              8  0
     D set290Ds        ds                  likerec( s1t290 : *Input)

       SVPINT_inz();
       clear peDeRe;

       if %parms >= 6 and %addr( peFech ) <> *Null;
         @@fech = peFech;
       else;
         PAR310X3 ( peEmpr : @@AÑo : @@Mes : @@Dia  );
         @@Fech = (@@AÑo * 10000) + (@@Mes * 100) + @@Dia;
       endif;

       if not SVPINT_chkDescuentoWeb( peEmpr : peSucu : peNivt
                                    : peNivc : peRama : @@fech );
         return *Off;
       endif;

       k1y290.t@empr = peEmpr;
       k1y290.t@sucu = peSucu;
       k1y290.t@nivt = peNivt;
       k1y290.t@nivc = peNivc;
       k1y290.t@rama = peRama;
       k1y290.t@fech = @@fech;
       setll %kds( k1y290 : 6 ) set290;
       reade %kds( k1y290 : 5 ) set290 set290Ds;
       eval-corr peDeRe = set290Ds;
       return *On;

     P SVPINT_getDescuentoWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_isCabeceraEspecial: Retorna Cabecera Especial         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peCcbp   (output)  Código de Componente                  *
      *     pePcbp   (output)  Porcentaje Bonificación               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPINT_isCabeceraEspecial...
     P                 B                   export
     D SVPINT_isCabeceraEspecial...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peCcbp                       3  0 options( *Nopass : *Omit )
     D   pePcbp                       5  2 options( *Nopass : *Omit )

     D @CNivt          s              1  0
     D @CNivc          s              5  0
     D @@Cade          s              5  0 dim(9)
     D @@VALSYS        s            512

      /free

       SVPINT_inz();

       clear @Cnivt;
       clear @Cnivc;
       clear @@Cade;
       SVPINT_GetCadena( peEmpr
                       : peSucu
                       : peNivt
                       : peNivc
                       : @@Cade );

       @CNivt = 9;
       @CNivc = @@Cade(9);


       if @Cnivc = 78751;

         if %parms >= 5 and %addr( peCcbp ) <> *Null;
           if SVPVLS_getValSys( 'HCODRECCAB':*omit :@@ValSys );
             peCcbp = %dec(@@ValSys:3:0);
           else;
             peCcbp = *zeros;
             return *off;
           endif;
         endif;

         if %parms >= 6 and %addr( pePcbp ) <> *Null;
           if SVPVLS_getValSys( 'HPORRECCAB':*omit :@@ValSys );
             pePcbp = %dec(@@ValSys:5:2);
             pePcbp = pePcbp * (-1);
           else;
             pePcbp = *zeros;
             return *off;
           endif;
         endif;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPINT_isCabeceraEspecial...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_getMatricula: Recupera Matricula de Intermediario.    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *                                                              *
      * Retorna: Matricula / 0 = no tiene cargada                    *
      * ------------------------------------------------------------ *

     P SVPINT_getMatricula...
     P                 B                   export
     D SVPINT_getMatricula...
     D                 pi             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D @@DsInte        ds                  likeds( DsSehni2_t )

      /free

        SVPINT_inz();

        if SVPINT_getIntermediario( peEmpr   :
                                    peSucu   :
                                    peNivt   :
                                    peNivc   :
                                    @@DsInte ) = 0;

          return @@DsInte.n2matr;

        endif;

        return *zeros;

      /end-free

     P SVPINT_getMatricula...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_getMayorAuxiliar : Recupera Códgio y Número de Mayor  *
      *                           Auxiliar                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peComa   (output)  Cod. de Mayor Auxiliar                *
      *     peNrma   (output)  Nro. de Mayor Auxiliar                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPINT_getMayorAuxiliar...
     P                 B                   export
     D SVPINT_getMayorAuxiliar...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peComa                       2
     D   penrma                       7  0

     D @@DsInte        ds                  likeds( DsSehni2_t )

      /free

        SVPINT_inz();

        if SVPINT_getIntermediario( peEmpr   :
                                    peSucu   :
                                    peNivt   :
                                    peNivc   :
                                    @@DsInte ) = 0;

          peComa = @@DsInte.n2coma;
          peNrma = @@DsInte.n2nrma;

         return *on;

        endif;

         return *off;

      /end-free

     P SVPINT_getMayorAuxiliar...
     P                 E

      * ------------------------------------------------------------ *
      * SVPINT_bloquearVoucher: Determina si bloquea o no voucher.   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Nivel de Intermediarios               *
      *     peNivc   (input)   Cod. de Intermediarios                *
      *     peFech   (input)   Fecha (opcional)                      *
      *                                                              *
      * Retorna: *On bloquea / *off no bloquea                       *
      * ------------------------------------------------------------ *
     P SVPINT_bloquearVoucher...
     P                 B                   export
     D SVPINT_bloquearVoucher...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 const Options( *Nopass : *Omit )

     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D @@fech          s              8  0
     D @@mar1          s              1a

     D k1hni4e         ds                  likerec(s1hni4e:*key)

      /free

        SVPINT_inz();

        PAR310X3( peEmpr : peFema : peFemm : peFemd );
        @@fech = (peFema * 10000)
               + (peFemm *   100)
               +  peFemd;

        if %parms >= 5 and %addr(peFech) <> *null;
           @@fech = peFech;
        endif;

        @@mar1 = 'N';

        k1hni4e.nnempr = peEmpr;
        k1hni4e.nnsucu = peSucu;
        k1hni4e.nnnivt = peNivt;
        k1hni4e.nnnivc = peNivc;

        setll %kds(k1hni4e:4) sehni4e;
        reade %kds(k1hni4e:4) sehni4e;
        dow not %eof;
            if nnfech <= @@fech;
               @@mar1 = nnmar1;
               leave;
            endif;
         reade %kds(k1hni4e:4) sehni4e;
        enddo;

        return (@@mar1 = 'S');

      /end-free

     P SVPINT_bloquearVoucher...
     P                 E

