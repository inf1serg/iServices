     H nomain
      * ************************************************************ *
      * COWLOG:  Loguear acciones sobre cotizaciones                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                    *07-Ene-2016             *
      *------------------------------------------------------------- *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *>           BNDDIR(HDIILE/HDIBDIR) -             <*           *
      *> TEXT('Prorama de Servicio: Log de Cotizaciones') <*         *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN:ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWLOG))  <*     *
      *> IGN: DLTSPLF FILE(COWLOG)                            <*     *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 17-07-2017 - Se agrega Logueo para API                   *
      * GIO 03-07-2018 - Logueo para ejecucion de servicios          *
      * LRG 29-10-2018 - se agrega logueo de para SuperPoliza        *
      * LRG 30-06-2020 - se agrega nuevo archivo para habilitar log  *
      * SGF 23-03-2021 - Agrego loglin().                            *
      * ************************************************************ *
     Flogwbs    if a e           k disk    usropn
     Flogwb1    uf a e           k disk    usropn
     Fsetlog    if   e           k disk    usropn
     Floglin    if a e           k disk    usropn

      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/ifsio_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D isLoguear       pr             1N
     D isLoguearAPI    pr             1N
     D*isLoguearPGM    pr             1N

     D COWLOG_errn     s             10i 0
     D COWLOG_errm     s             80a
     D Initialized     s              1N

     D loguear         ds                  dtaara('DTALOGWF') qualified
     D  log                           1a   overlay(loguear:1)

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

      * ------------------------------------------------------------ *
      * isLoguear(): Recupera si debe o no loguear.                  *
      *                                                              *
      * Retorna: *ON si debe loguear o *OFF si no.                   *
      * ------------------------------------------------------------ *
     P isLoguear       B
     D isLoguear       pi             1N

      /free

       in loguear;
       unlock loguear;
       if loguear.log = 'S';
          return *on;
        else;
          return *off;
       endif;

      /end-free

     P isLoguear       E

      * ------------------------------------------------------------ *
      * COWLOG_create(): Crea archivo de log.                        *
      *                                                              *
      *    peBase     (input)    Base                                *
      *    peNctw     (input)    Número de Cotización                *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_create   B                   Export
     D COWLOG_create   pi             1N
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const

     D file            s            100a
     D fd              s             10i 0
     D Data            s          65535a   varying
     D CRLF            c                   x'0d25'

      /free

       if not isLoguear();
          return COWLOG_SUCCESS;
       endif;

       file = '/tmp/wslog/cotizacion_'
            + %trim(%editc(peNctw:'X'))
            + '.log';

       if access( %trim(file) : F_OK ) = 0;
          return COWLOG_FAIL;
       endif;

       fd = open( %trim(file)
                : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                 +O_TEXTDATA+O_TEXT_CREAT
                : M_RWX
                : 819
                : 0 );
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp close(fd);

       Data = 'Fecha y Hora de creación: '
            + %char(%date():*iso)
            + ' - '
            + %char(%time():*iso)
            + CRLF + CRLF;

       COWLOG_log( peBase : peNctw : Data );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_create   E

      * ------------------------------------------------------------ *
      * COWLOG_log(): Loguea acción                                  *
      *                                                              *
      *    peBase     (input)    Base                                *
      *    peNctw     (input)    Número de Cotización                *
      *    peLog      (input)    Log                                 *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_log      B                   Export
     D COWLOG_log      pi             1N
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peLog                     65535a   varying value

     D file            s            100a   inz('/tmp/cotizacion_%%%%%%%.log')
     D fd              s             10i 0

      /free

       if not isLoguear();
          return COWLOG_SUCCESS;
       endif;

       file = '/tmp/wslog/cotizacion_'
            + %trim(%editc(peNctw:'X'))
            + '.log';

       if access( %trim(file) : F_OK ) = -1;
          COWLOG_create( peBase :peNctw );
       endif;

       fd = open( %trim(file)
                : O_WRONLY+O_TEXTDATA+O_APPEND);
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp write( fd : %addr(peLog)+2: %len(peLog) );
       callp close( fd );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_log      E

      * ------------------------------------------------------------ *
      * COWLOG_logcon(): Loguear ejecución de consulta               *
      *                                                              *
      *    peWebs     (input)    Nombre de WebService                *
      *    peBase     (input)    Base                                *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_logcon   B                   Export
     D COWLOG_logcon   pi             1N
     D  peWebs                      256a   const
     D  peBase                             likeds(paramBase) const

     D key             ds                  likerec(l1gwbs:*key)

      /free

       if not isLoguear();
          return COWLOG_SUCCESS;
       endif;

       COWLOG_inz();

       key.bswebs = peWebs;
       key.bsfech = %dec(%date():*iso);

       setgt  %kds(key:2) logwbs;
       readpe %kds(key:2) logwbs;
       if %eof;
          bssecu = 0;
          bsssec = 0;
        else;
          select;
           when bsssec <= 9999998;
                bsssec += 1;
           other;
                bssecu += 1;
                bsssec  = 0;
          endsl;
       endif;
       bswebs = peWebs;
       bsfech = key.bsfech;
       bshora = %dec(%time():*iso);
       bsempr = peBase.peEmpr;
       bssucu = peBase.peSucu;
       bsnivt = peBase.peNivt;
       bsnivc = peBase.peNivc;
       bsnit1 = peBase.peNit1;
       bsniv1 = peBase.peNiv1;
       write l1gwbs;

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_logcon   E

      * ------------------------------------------------------------ *
      * COWLOG_apilog(): Loguea acción de API                        *
      *                                                              *
      *    peNcta     (input)    Número de Cotización                *
      *    peNivc     (input)    Numero de Intermediario             *
      *    peLog      (input)    Log                                 *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_apilog   B                   Export
     D COWLOG_apilog   pi             1N
     D  peNcta                        7  0 const
     D  peNivc                        5  0 const
     D  peLog                     65535a   varying value

     D file            s            100a   inz('/tmp/APIcotizacion_%%%%%%%.log')
     D fd              s             10i 0

      /free

       if not isLoguearAPI();
          return COWLOG_SUCCESS;
       endif;

       file = '/tmp/wslog/APIcotizacion_'
            + %trim(%editc(peNcta:'X'))
            + '.log';

       if access( %trim(file) : F_OK ) = -1;
          COWLOG_createAPI( peNcta : peNivc );
       endif;

       fd = open( %trim(file)
                : O_WRONLY+O_TEXTDATA+O_APPEND);
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp write( fd : %addr(peLog)+2: %len(peLog) );
       callp close( fd );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_apilog   E
      * ------------------------------------------------------------ *
      * COWLOG_createAPI: Crea archivo de log para API.              *
      *                                                              *
      *    peNcta     (input)    Número de Cotización                *
      *    peNivc     (input)    Codigo de Intermediario             *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_createAPI...
     P                 B                   Export
     D COWLOG_createAPI...
     D                 pi             1n
     D  peNcta                        7  0 const
     D  peNivc                        5  0 const

     D file            s            100a
     D fd              s             10i 0
     D Data            s          65535a   varying
     D CRLF            c                   x'0d25'

      /free

       if not isLoguearAPI();
          return COWLOG_SUCCESS;
       endif;

       file = '/tmp/wslog/APIcotizacion_'
            + %trim(%editc(peNcta:'X'))
            + '.log';

       if access( %trim(file) : F_OK ) = 0;
          return COWLOG_FAIL;
       endif;

       fd = open( %trim(file)
                : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                 +O_TEXTDATA+O_TEXT_CREAT
                : M_RWX
                : 819
                : 0 );
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp close(fd);

       Data = 'Fecha y Hora de creación: '
            + %char(%date():*iso)
            + ' - '
            + %char(%time():*iso)
            + CRLF + CRLF;

       COWLOG_apilog( peNcta : peNivc : Data );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_createAPI...
     P                 E
      * ------------------------------------------------------------ *
      * isLoguearAPI(): Recupera si debe o no loguear API.           *
      *                                                              *
      * Retorna: *ON si debe loguear o *OFF si no.                   *
      * ------------------------------------------------------------ *
     P isLoguearAPI    B
     D isLoguearAPI    pi             1N

     D @@Vsys          s            512
      /free
       clear @@Vsys;
       if not SVPVLS_getValSys( 'HAPILOG'  :*omit :@@Vsys );
         //error
       endif;

       if %trim( @@Vsys ) = 'S';
          return *on;
        else;
          return *off;
       endif;

      /end-free

     P isLoguearAPI    E
      * ------------------------------------------------------------ *
      * COWLOG_inz(): Inicializa Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P COWLOG_inz      B                   Export
     D COWLOG_inz      pi

      /free

       if initialized;
          return;
       endif;

       if not %open(logwbs);
          open logwbs;
       endif;

       if not %open(logwb1);
          open logwb1;
       endif;

       if not %open(setlog);
          open setlog;
       endif;

       if not %open(loglin);
          open loglin;
       endif;

       Initialized = *on;

      /end-free

     P COWLOG_inz      E

      * ------------------------------------------------------------ *
      * COWLOG_end(): Finaliza   Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P COWLOG_end      B                   Export
     D COWLOG_end      pi

      /free

       close *all;
       Initialized = *off;

      /end-free

     P COWLOG_end      E

      * ------------------------------------------------------------ *
      * COWLOG_error(): Retornar error del módulo                    *
      *                                                              *
      *    peErrn     (input)    Número de error (opcional)          *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     P COWLOG_error    B                   Export
     D COWLOG_error    pi            80a
     D  peErrn                       10i 0 options(*nopass : *omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *null;
          peErrn = COWLOG_errn;
       endif;

       return COWLOG_errm;

      /end-free

     P COWLOG_error    E

      * ------------------------------------------------------------ *
      * COWLOG_isLoguearAutoGestion: Determina si loguea por         *
      *                              Autogestion                     *
      *                                                              *
      * retorna: *ON si debe loguear / *OFF si no debe loguear       *
      * ------------------------------------------------------------ *
     P COWLOG_isLoguearAutoGestion...
     P                 B
     D COWLOG_isLoguearAutoGestion...
     D                 pi             1n

     D @@Vsys          s            512

      /free

        clear @@Vsys;
        if not SVPVLS_getValSys( 'HAUTGESLOG' : *omit : @@Vsys );
          //error
        endif;

        if %trim( @@Vsys ) = 'S';
          return *on;
        else;
          return *off;
        endif;

      /end-free

     P COWLOG_isLoguearAutoGestion...
     P                 E

      * ------------------------------------------------------------ *
      * COWLOG_logConAutoGestion: Graba registro en Log Autogestion  *
      *                                                              *
      *    peEmpr     (input)    Empresa                             *
      *    peSucu     (input)    Sucursal                            *
      *    peTdoc     (input)    Tipo Documento                      *
      *    peNdoc     (input)    Numero Documento                    *
      *    peWebs     (input)    Nombre de WebService                *
      *                                                              *
      * retorna: *ON si todo Ok / *OFF si error                      *
      * ------------------------------------------------------------ *
     P COWLOG_logConAutoGestion...
     P                 B                   Export
     D COWLOG_logConAutoGestion...
     D                 pi             1n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peTdoc                        2  0 const
     D  peNdoc                       11  0 const
     D  peWebs                      256a   const

     D kLogwb1         ds                  likerec(l1gwb1:*key)

     D @@Existe        s               n
     D @@FechTS        s               z

      /free

        if not COWLOG_isLoguearAutoGestion();
          return COWLOG_SUCCESS;
        endif;

        COWLOG_inz();

        @@FechTS = %timestamp();
        klogwb1.b1Empr = peEmpr;
        klogwb1.b1Sucu = peSucu;
        klogwb1.b1Tdoc = peTdoc;
        klogwb1.b1Ndoc = peNdoc;
        klogwb1.b1Webs = peWebs;
        klogwb1.b1Tims = %editc(%dec(@@FechTS:*iso):'X');
        setll %kds(klogwb1) logwb1;
        @@Existe = %equal(logwb1);

        if not @@Existe;
          b1Empr = klogwb1.b1Empr;
          b1Sucu = klogwb1.b1Sucu;
          b1Tdoc = klogwb1.b1Tdoc;
          b1Ndoc = klogwb1.b1Ndoc;
          b1Webs = klogwb1.b1Webs;
          b1Tims = klogwb1.b1Tims;
        else;
          read logwb1;
        endif;

        b1fech = ( %subdt(@@FechTS:*Y) * 10000 ) +
                 ( %subdt(@@FechTS:*M) * 100 ) +
                   %subdt(@@FechTS:*D);
        b1time = ( %subdt(@@FechTS:*H) * 10000 ) +
                 ( %subdt(@@FechTS:*MN) * 100 ) +
                   %subdt(@@FechTS:*S);
        b1user = @PsDs.CurUsr;

        if not @@Existe;
          write l1gwb1;
        else;
          update l1gwb1;
        endif;

        return COWLOG_SUCCESS;

      /end-free

     P COWLOG_logConAutoGestion...
     P                 E

      * ------------------------------------------------------------ *
      * COWLOG_spolog(): Loguea acción de SuperPoliza                *
      *                                                              *
      *    peArcd     (input)    Articulo                            *
      *    peSpol     (input)    Super Poliza                        *
      *    peLog      (input)    Log                                 *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_spolog   B                   Export
     D COWLOG_spolog   pi             1N
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peLog                     65535a   varying value

     D file            s            100a   inz('/tmp/spol_.log')
     D fd              s             10i 0

      /free

       if not isLoguearSpol();
          return COWLOG_SUCCESS;
       endif;

       file = '/tmp/wslog/spol_'
            + %trim(%editc(peArcd :'X')) + '_'
            + %trim(%editc(peSpol :'X'))
            + '.log';

       if access( %trim(file) : F_OK ) = -1;
          COWLOG_createSpol( peArcd : peSpol );
       endif;

       fd = open( %trim(file)
                : O_WRONLY+O_TEXTDATA+O_APPEND);
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp write( fd : %addr(peLog)+2: %len(peLog) );
       callp close( fd );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_spolog   E

      * ------------------------------------------------------------ *
      * isLoguearSpol(): Recupera si debe o no loguear SuperPoliza   *
      *                                                              *
      * Retorna: *ON si debe loguear o *OFF si no.                   *
      * ------------------------------------------------------------ *
     P isLoguearSpol   B
     D isLoguearSpol   pi             1N

     D @@Vsys          s            512
      /free
       clear @@Vsys;
       if not SVPVLS_getValSys( 'HSPOLOG'  :*omit :@@Vsys );
         //error
       endif;

       if %trim( @@Vsys ) = 'S';
          return *on;
        else;
          return *off;
       endif;

      /end-free

     P isLoguearSpol   E

      * ------------------------------------------------------------ *
      * COWLOG_createSpol: Crea archivo de log para Superpoliza      *
      *                                                              *
      *    peArcd     (input)    Articulo                            *
      *    peSpol     (input)    SuprPoliza                          *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_createSpol...
     P                 B                   Export
     D COWLOG_createSpol...
     D                 pi             1n
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const

     D file            s            100a
     D fd              s             10i 0
     D Data            s          65535a   varying
     D CRLF            c                   x'0d25'

      /free

       if not isLoguearSpol();
          return COWLOG_SUCCESS;
       endif;

       file = '/tmp/wslog/spol_'
            + %trim(%editc(peArcd :'X')) + '_'
            + %trim(%editc(peSpol :'X'))
            + '.log';

       if access( %trim(file) : F_OK ) = 0;
          return COWLOG_FAIL;
       endif;

       fd = open( %trim(file)
                : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                 +O_TEXTDATA+O_TEXT_CREAT
                : M_RWX
                : 819
                : 0 );
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp close(fd);

       Data = 'Fecha y Hora de creación: '
            + %char(%date():*iso)
            + ' - '
            + %char(%time():*iso)
            + CRLF + CRLF;

       COWLOG_spolog( peArcd : peSpol : Data );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_createSpol...
     P                 E

      * ------------------------------------------------------------ *
      * COWLOG_createPgm : Crea archivo de log para PGM              *
      *                                                              *
      *    peName     (input)    Nombre del Programa                 *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_createPgm...
     P                 B                   Export
     D COWLOG_createPgm...
     D                 pi             1n
     D  peName                       10    const

     D file            s            100a
     D fd              s             10i 0
     D Data            s          65535a   varying
     D CRLF            c                   x'0d25'

      /free

       if not isLoguearPgm(peName);
          return COWLOG_SUCCESS;
       endif;

       file = '/tmp/wslog/'
            + %trim(peName) + '.log';

       if access( %trim(file) : F_OK ) = 0;
          return COWLOG_FAIL;
       endif;

       fd = open( %trim(file)
                : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                 +O_TEXTDATA+O_TEXT_CREAT
                : M_RWX
                : 819
                : 0 );
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp close(fd);

       Data = 'Fecha y Hora de creación: '
            + %char(%date():*iso)
            + ' - '
            + %char(%time():*iso)
            + CRLF + CRLF;

       COWLOG_pgmLog( peName : Data );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_createPgm...
     P                 E

      * ------------------------------------------------------------ *
      * COWLOG_pgmLog (): Loguea acción de Programa                  *
      *                                                              *
      *    peName     (input)    Nombre del servicio                 *
      *    peLog      (input)    Log                                 *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_pgmLog   B                   Export
     D COWLOG_pgmLog   pi             1N
     D  peName                       10    const
     D  peLog                     65535a   varying value

     D file            s            100a   inz('/tmp/spol_.log')
     D fd              s             10i 0

      /free

       if not isLoguearPgm(peName);
          return COWLOG_SUCCESS;
       endif;
        file = '/tmp/wslog/'
             + %trim(peName) + '.log';

       if access( %trim(file) : F_OK ) = -1;
          COWLOG_createPgm( peName );
       endif;

       fd = open( %trim(file)
                : O_WRONLY+O_TEXTDATA+O_APPEND);
       if fd = -1;
          return COWLOG_FAIL;
       endif;

       callp write( fd : %addr(peLog)+2: %len(peLog) );
       callp close( fd );

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_pgmLog   E

      * ------------------------------------------------------------ *
      * isLoguearPgm: Recupera si debe o no loguear.                 *
      *    peName     (input)    Nombre del servicio                 *
      *                                                              *
      * Retorna: *ON si debe loguear o *OFF si no.                   *
      * ------------------------------------------------------------ *
     P isLoguearPgm    B
     D isLoguearPgm    pi             1N
     D  peName                       10    const

      /free
       COWLOG_inz();

       chain peName setlog;
       if %found( setlog );
         if t@habl <> '1' and
            t@habl <> '0';
            t@habl = '0';
         endif;
         return t@habl;
       endif;

       return *off;

      /end-free

     P isLoguearPgm    E

      * ------------------------------------------------------------ *
      * COWLOG_loglin(): Loguear login                               *
      *                                                              *
      *    peEmpr     (input)    Empresa                             *
      *    peSucu     (input)    Sucursal                            *
      *    peCuit     (input)    Cuit                                *
      *    peNrag     (input)    Numero de Agencia                   *
      *    peUsri     (input)    Usuario interno                     *
      *                                                              *
      * retorna: SUCCESS o FAIL                                      *
      * ------------------------------------------------------------ *
     P COWLOG_loglin   B                   Export
     D COWLOG_loglin   pi             1N
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peCuit                       11a   const
     D  peNrag                        5  0 const
     D  peUsri                        1a   const

     D key             ds                  likerec(l1gwbs:*key)

      /free

       COWLOG_inz();

       if not isLoguearPgm( 'WSRLIN' );
          return COWLOG_SUCCESS;
       endif;

       inempr = peEmpr;
       insucu = peSucu;
       incuit = peCuit;
       innrag = peNrag;
       inusri = peUsri;
       indate = %dec(%date():*iso);
       intime = %dec(%time():*iso);
       intimz = %char(%timestamp());
       write l1glin;

       return COWLOG_SUCCESS;

      /end-free

     P COWLOG_loglin   E

