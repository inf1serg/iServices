      ****************************************************************
      *  Validaciones Reglas Aviso Reposición de Siniestros
      *  Pedido de desarrollo 3649
      *
      *  Inf1Marc  24/09/2014
      ****************************************************************
     H nomain
      /if defined(*CRTBNDRPG)
     H dftactgrp(*no) actgrp(*CALLER)
      /endif
     H Debug(*yes) option(*nodebugio:*srcstmt)
     H EXPROPTS(*RESDECPOS) ALWNULL(*USRCTL)COPYRIGHT('HDI Seguros S.A.')
     fset17003  if   e           k disk    usropn
     fset171    if   e           k disk    usropn
     fset172    if   e           k disk    usropn
     fset173    if   e           k disk    usropn
     fpahshp01  if   e           k disk    usropn
     fpahscd    if   e           k disk    usropn
     fpahec1    if   e           k disk    usropn
     fpahed0    if   e           k disk    usropn
     fpahec0    if   e           k disk    usropn
     fpawpc0    if   e           k disk    usropn
     fpawkl1    if   e           k disk    usropn
     fgti98202  if   e           k disk    usropn
     fcnhopl    if   e           k disk    usropn
      /copy './qcpybooks/SVPAVR_H.rpgle'
     D PAR310X3        pr                  extpgm('PAR310X3')
     D   empr                         1    const
     D   @aÑo                         4  0
     D   @mes                         2  0
     D   @dia                         2  0
      * Variables Globales
     D Initialized     s               n
     D   SINI          s              7  0
     D   NOPS          s              7  0
     D   nivt          s              1  0
     D   nivc          s              5  0
     D   asen          s              7  0
     D   vige          s               n
     D   fincontrato   s              8  0
      *-------------------------------------------------------------
      * SVPAVR_EsIndemnizacion : Verifica si es indemnización.
      *
      * Peempr      Input   Empresa
      * Pesucu      Input   Sucursal
      * peartc      Input
      * pepacp      Input   Nro de pago
      * perama      Input   Rama
      * peSINI      Output  Nro de siniestro
      * peNOPS      Output  Nro de operación de siniestro
      * pexcob      Output  Codigo de cobertura.
      *
      *-------------------------------------------------------------
     P SVPAVR_EsIndemnizacion...
     P                 B                   export
     D SVPAVR_EsIndemnizacion...
     D                 pi              n
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   peartc                       2  0 const
     D   pepacp                       6  0 const
     D   perama                       2  0 const
     D   peSINI                       7  0
     D   peNOPS                       7  0
     d   pexcob                       3  0
     d   retorno       s               n
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
     C     K_pahshp01    klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    peartc
     C                   kfld                    pepacp
     C                   kfld                    perama
     c                   if        not %open(pahshp01)
     c                   open      pahshp01
     c                   endif
     C     K_pahshp01    setll     pahshp01
     C     K_pahshp01    reade     p1hshp
     C                   if        not %eof and hpmar1 = 'I'
     c                   eval      peSINI = hpSINI
     c                   eval      peNOPS = hpNOPS
     c                   eval      pexcob = hpxcob
     c                   eval      retorno =  *on
     c                   else
     c                   eval      retorno = *off
     c                   endif
     C                   return    retorno
     P SVPAVR_EsIndemnizacion...
     P                 E
      *-------------------------------------------------------------
      * SVPAVR_CorrespondeAvisoPRamaCobMont
      *
      * Peempr      Input   Empresa
      * Pesucu      Input   Sucursal
      * Pefech      Input   Fecha de pago.
      * perama      Input   Rama
      * pecobc      Input   Cobertura
      * pemont      Input   Importe
      *
      *
      *-------------------------------------------------------------
     P SVPAVR_CorrespondeAvisoPRamaCobMont...
     P                 B                   export
     D SVPAVR_CorrespondeAvisoPRamaCobMont...
     D                 pi              n
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   Pefech                       8  0 const
     D   perama                       2  0 const
     D   pecobc                       3  0 const
     D   pemont                      15  2 const
     D   pearcd                       6  0 const
     D
     D   Kf_T@EMPR     s                   like(T@EMPR)
     D   Kf_T@SUCU     s                   like(T@SUCU)
     D   Kf_T@NRES     s                   like(T@NRES)
     D   Kf_T@RAMA     s                   like(T@RAMA)
     D   Kf_T@COBC     s                   like(T@COBC)
     D   Kf_T@ARCD     s                   like(T@ARCD)
     d   retorno       s               n
     d   nres          s              7  0
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
      /FREE
        eval Nres = SVPAVR_ExistenReglasVigentes(Peempr:Pesucu:Pefech);
      /end-free
     c                   if        nres < 0
     c                   eval      retorno = *off
     c                   else
     c                   eval      retorno = *on
     c                   endif
      * Chequea a nivel de rama, cobertura.
     c                   if        retorno = *on
     c                   if        not %open(SET172)
     c                   open      SET172
     c                   endif
     c     k_SET172      Klist
     c                   kfld                    Kf_T@EMPR
     c                   kfld                    Kf_T@SUCU
     c                   kfld                    Kf_T@NRES
     c                   kfld                    Kf_T@RAMA
     c                   kfld                    Kf_T@COBC
     c                   eval      Kf_T@EMPR = Peempr
     c                   eval      Kf_T@SUCU = Pesucu
     c                   eval      Kf_T@NRES = T@NRES
     c                   eval      Kf_T@RAMA = perama
     c                   eval      Kf_T@COBC = pecobc
     c     k_SET172      Chain     s1t172
     c                   if        not %found(SET172)
     c                   eval      retorno = *off
     c                   endif
     c                   endif
     c                   if        retorno = *on
     c                   if        pemont >= T@MG15
     c                   eval      retorno = *on
     c                   else
     C                   eval      retorno = *off
     c                   endif
     c                   endif
      * Verifica que no sea un artículo excluido
     c                   if        retorno = *on
     c                   if        not %open(SET173)
     c                   open      SET173
     c                   endif
     c     k_SET173      Klist
     c                   kfld                    Kf_T@EMPR
     c                   kfld                    Kf_T@SUCU
     c                   kfld                    Kf_T@NRES
     c                   kfld                    Kf_T@ARCD
     c                   eval      Kf_T@EMPR = Peempr
     c                   eval      Kf_T@SUCU = Pesucu
     c                   eval      Kf_T@NRES = T@NRES
     c                   eval      Kf_T@ARCD = pearcd
     c     k_SET173      Chain     s1t173
     c                   if        %found(SET173)
     c                   eval      retorno = *off
     c                   endif
     c                   endif
     c                   return    retorno
     P SVPAVR_CorrespondeAvisoPRamaCobMont...
     P                 E
      *-------------------------------------------------------------
      * SVPAVR_ExistenReglasVigentes
      *          Verifica si hay reglas vigentes.
      *
      * peempr      Input   Empresa
      * pesucu      Input   Sucursal
      * pefech      Input   Fecha de pago.
      *
      * Devuelve nro de lista de reglas si las hay a esa fecha.
      *
      *-------------------------------------------------------------
     P SVPAVR_ExistenReglasVigentes...
     P                 B                   export
     D SVPAVR_ExistenReglasVigentes...
     D                 pi             7  0
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   Pefech                       8  0 const
     D   Kf_T@EMPR     s                   like(T@EMPR)
     D   Kf_T@SUCU     s                   like(T@SUCU)
     D   Kf_T@VIGD     s                   like(T@VIGD)
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
     c                   if        not %open(SET17003)
     c                   open      SET17003
     c                   endif
     c     k_SET17003    Klist
     c                   kfld                    Kf_T@EMPR
     c                   kfld                    Kf_T@SUCU
     c                   kfld                    Kf_T@VIGD
     c                   eval      Kf_T@EMPR = Peempr
     c                   eval      Kf_T@SUCU = Pesucu
     c     *iso          move      Pefech        Kf_T@VIGD
     c     k_SET17003    setgt     s1t170
     c                   readp     s1t170
     c                   if        %eof(SET17003)
     c                   eval      T@NRES = -1
     c                   endif
     c                   return    T@NRES
     P SVPAVR_ExistenReglasVigentes...
     P                 E
      *-------------------------------------------------------------
      * SVPAVR_ObtieneDatosPoliza
      *
      * Peempr      Input   Empresa
      * Pesucu      Input   Sucursal
      * perama      Input   Rama
      * pesini      Input   Siniestro
      * penops      Input   Operarión de siniestro
      * pepoli      Output  Nro de póliza.
      * penivt      Output  Nivel Productor
      * penivc      Output  Código productor
      * peasen      Output  Código asegurado
      * pevige      Output  '1' = vigente
      * pefincontrato  Output  Fecha de fin de contrato.
      *
      *-------------------------------------------------------------
     P SVPAVR_ObtieneDatosPoliza...
     P                 B                   export
     D SVPAVR_ObtieneDatosPoliza...
     D                 pi
     D Peempr                         1    const
     D Pesucu                         2    const
     D perama                         2  0 const
     D pesini                         7  0 const
     D penops                         7  0 const
     D pepoli                         7  0
     D pearcd                         6  0
     D pespol                         9  0
     D penivt                         1  0
     D penivc                         5  0
     D peasen                         7  0
     D pevige                          n
     D pefincontrato                  8  0
     D FechaEmi        s              8  0
     d @aÑo            s              4  0
     d @mes            s              2  0
     d @dia            s              2  0
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
     c                   clear                   pepoli
     c                   clear                   pearcd
     c                   clear                   pespol
     c                   clear                   penivt
     c                   clear                   penivc
     c                   clear                   peasen
     c                   clear                   pevige
     c                   clear                   pefincontrato
     C     k_pahscd      klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    perama
     C                   kfld                    pesini
     C                   kfld                    penops
     c                   if        not %open(pahscd)
     c                   open      pahscd
     c                   endif
     C     k_pahscd      chain     p1hscd
     C                   if        %found(pahscd)
     c                   eval      pearcd   =    cdarcd
     c                   eval      pespol   =    cdspol
     C     k_pahec1      klist
     C                   kfld                    cdempr
     C                   kfld                    cdsucu
     C                   kfld                    cdarcd
     C                   kfld                    cdspol
     C                   kfld                    cdsspo
     C     k_pahed0      klist
     C                   kfld                    cdempr
     C                   kfld                    cdsucu
     C                   kfld                    cdarcd
     C                   kfld                    cdspol
     C                   kfld                    cdsspo
     c                   if        not %open(pahec1)
     c                   open      pahec1
     c                   endif
     C     k_pahec1      chain     p1hec1
     C                   if        %found(pahec1)
     c                   eval      peNIVT =  c1nivt
     c                   eval      peNIVC =  c1nivc
     c                   eval      peasen =  c1asen
     c                   callp     PAR310X3(peEmpr:
     c                                      @aÑo:
     c                                      @mes:
     c                                      @dia)
     c                   eval      FechaEmi=(@aÑo * 10000 + @mes * 100 +
     c                                       @dia)
     c                   if        not %open(pahed0)
     c                   open      pahed0
     c                   endif
     C     k_pahed0      chain     p1hed0
     C                   if        %found(pahed0)
     c                   eval      pepoli = d0poli
     c                   call      'SPVIG2'
     c                   parm                    c1arcd
     c                   parm                    c1spol
     c                   parm                    d0rama
     c                   parm                    d0arse
     c                   parm                    d0oper
     c                   parm                    FechaEmi
     c                   parm                    FechaEmi
     c                   parm      *blanks       pestat            1
     c                   parm      *zeros        pesspo            3 0
     c                   parm      *zeros        pesuop            3 0
     c                   parm      *blanks       pefpgm            3
     c                   if        pestat = '1'
     c                   eval      pevige = *on
     c                   else
     c                   eval      pevige = *off
     c                   endif

     C     k_PAHEC0      klist
     C                   kfld                    cdempr
     C                   kfld                    cdsucu
     C                   kfld                    cdarcd
     C                   kfld                    cdspol
     c                   if        not %open(pahec0)
     c                   open      pahec0
     c                   endif
     C     k_pahec0      chain     p1hec0
     C                   if        %found(pahec0)
     c                   eval      pefincontrato = C0FVOA * 10000 +
     c                                             C0FVOM * 100   +
     c                                             C0FVOD
     c                   endif
     c                   endif
     c                   endif
     c                   endif
     c                   return
     P SVPAVR_ObtieneDatosPoliza...
     P                 E
      *-------------------------------------------------------------
      * SVPAVR_ObtieneCondParaRama...
      *
      * Peempr      Input   Empresa
      * Pesucu      Input   Sucursal
      * Pefech      Input   Fecha de pago.
      * perama      Input   Rama
      * pediap      Output  Dias
      * pecoev      Output  Toma vencidas o no
      *-------------------------------------------------------------
     P SVPAVR_ObtieneCondParaRama...
     P                 B                   export
     D SVPAVR_ObtieneCondParaRama...
     D                 pi              n
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   Pefech                       8  0 const
     D   perama                       2  0 const
     d   pediap                       2  0
     d   pecoev                       1
     d   nres          s              7  0
     D   Kf_T@EMPR     s                   like(T@EMPR)
     D   Kf_T@SUCU     s                   like(T@SUCU)
     D   Kf_T@NRES     s                   like(T@NRES)
     D   Kf_T@RAMA     s                   like(T@RAMA)
     D   Kf_T@COBC     s                   like(T@COBC)
     d   retorno       s               n
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
      /FREE
        eval Nres = SVPAVR_ExistenReglasVigentes(Peempr:Pesucu:Pefech);
      /end-free
     c                   if        nres < 0
     c                   eval      retorno = *off
     c                   else
     c                   eval      retorno = *on
     c                   endif
      * Chequea a nivel de rama, cobertura.
     c                   if        retorno = *on
     c                   if        not %open(SET171)
     c                   open      SET171
     c                   endif
     c     k_SET171      Klist
     c                   kfld                    Kf_T@EMPR
     c                   kfld                    Kf_T@SUCU
     c                   kfld                    Kf_T@NRES
     c                   kfld                    Kf_T@RAMA
     c                   eval      Kf_T@EMPR = Peempr
     c                   eval      Kf_T@SUCU = Pesucu
     c                   eval      Kf_T@NRES = NRES
     c                   eval      Kf_T@RAMA = perama
     c     k_SET171      Chain     s1t171
     c                   if        not %found(SET171)
     c                   eval      retorno = *off
     c                   else
     c                   eval      pediap = T@DIAP
     c                   eval      pecoev = T@COEV
     c                   eval      retorno = *on
     c                   endif
     c                   endif
     c                   return    retorno
     P SVPAVR_ObtieneCondParaRama...
     P                 E

      *-------------------------------------------------------------
      * SVPAVR_VerificaSuspendida....
      *
      * Peempr      Input   Empresa
      * Pesucu      Input   Sucursal
      * pearcd      Input   Artículo
      * pespol      Input   Superpóliza
      *
      * devuelve *on si está suspendida
      *-------------------------------------------------------------
     P SVPAVR_VerificaSuspendida...
     P                 B                   export
     D SVPAVR_VerificaSuspendida...
     D                 pi              n
     D Peempr                         1    const
     D Pesucu                         2    const
     D pearcd                         6  0 const
     D pespol                         9  0 const
     d   retorno       s               n
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
     c                   if        not %open(Pawpc0)
     c                   open      pawpc0
     c                   endif
     c     k_PAWPC0      Klist
     c                   kfld                    Peempr
     c                   kfld                    Pesucu
     c                   kfld                    pearcd
     c                   kfld                    pespol
     c     k_pawpc0      Chain     pawpc0
     c                   if        not %found(pawpc0)
     c                   eval      retorno = *off
     c                   else
     c                   eval      retorno = *on
     c                   endif
     c                   return    retorno
     P SVPAVR_VerificaSuspendida...
     P                 E
      *-------------------------------------------------------------
      * SVPAVR_VerificaSuspendidaSPDWY
      *
      * pearcd      Input   Artículo
      * pespol      Input   Superpóliza
      * Pepoli      Input   Nro de póliza
      *
      * devuelve *on si está suspendida
      *-------------------------------------------------------------
     P SVPAVR_VerificaSuspendidaSPWY...
     P                 B                   export
     D SVPAVR_VerificaSuspendidaSPWY...
     D                 pi              n
     D pearcd                         6  0 const
     D pespol                         9  0 const
     D pepoli                         7  0 const
     d   retorno       s               n
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
     c                   if        not %open(gti98202)
     c                   open      gti98202
     c                   endif
     c     k_gti98202    Klist
     c                   kfld                    pearcd
     c                   kfld                    pespol
     c                   kfld                    pepoli
     c     k_gti98202    Chain     G1T98202
     c                   if        not %found(gti98202)
     c                   eval      retorno = *off
     c                   else
     c                   eval      retorno = *on
     c                   endif
     c                   return    retorno
     P SVPAVR_VerificaSuspendidaSPWY...
     P                 E
      *-------------------------------------------------------------
      * SVPAVR_VerificaAnulEnCurso...
      *
      * Peempr      Input   Empresa
      * Pesucu      Input   Sucursal
      * pearcd      Input   Artículo
      * pespol      Input   Superpóliza
      *
      * devuelve *on si está suspendida
      *-------------------------------------------------------------
     P SVPAVR_VerificaAnulEnCurso...
     P                 B                   export
     D SVPAVR_VerificaAnulEnCurso...
     D                 pi              n
     D Peempr                         1    const
     D Pesucu                         2    const
     D pearcd                         6  0 const
     D pespol                         9  0 const
     d   retorno       s               n
     c                   if        not Initialized
     c                   eval      Initialized = SVPAVR_inz
     c                   endif
     c                   if        not %open(Pawkl1)
     c                   open      pawkl1
     c                   endif
     c     k_PAWKL1      Klist
     c                   kfld                    Peempr
     c                   kfld                    Pesucu
     c                   kfld                    pearcd
     c                   kfld                    pespol
     c     k_pawkl1      Chain     pawkl1
     c                   if        not %found(pawkl1)
     c                   eval      retorno = *off
     c                   else
     c                   eval      retorno = *on
     c                   endif
     c                   return    retorno
     P SVPAVR_VerificaAnulEnCurso...
     P                 E
      *-------------------------------------------------------------
      * SVPAVR__inz(): Inicializa Service Program.
      *
      * Devuelve '1' Indicando que se ejecutó.
      *
      *-------------------------------------------------------------
     P SVPAVR_inz      B                   export
     D SVPAVR_inz      pi              n
     c                   if        not Initialized
     c                   eval      Initialized = *on
     c                   endif
      /free

       if not %open( set172 );
         open set172;
       endif;

       if not %open( set173 );
         open set173;
       endif;

       if not %open( cnhopl );
         open cnhopl;
       endif;

      /end-free
     c                   return    Initialized
     P SVPAVR_inz      E

      *-------------------------------------------------------------
      * SVPVRENO_End()  Cierre de archivos y programa.
      *
      *-------------------------------------------------------------
     P SVPAVR_End      B                   export
     D SVPAVR_End      pi
     c                   if        %open(set17003)
     c                   close     set17003
     c                   endif
     c                   if        %open(set171)
     c                   close     set171
     c                   endif
     c                   if        %open(set172)
     c                   close     set172
     c                   endif
     c                   if        %open(set173)
     c                   close     set173
     c                   endif
     c                   if        %open(pahshp01)
     c                   close     pahshp01
     c                   endif
     c                   if        %open(pahscd)
     c                   close     pahscd
     c                   endif
     c                   if        %open(pahec1)
     c                   close     pahec1
     c                   endif
     c                   if        %open(pahed0)
     c                   close     pahed0
     c                   endif
     c                   if        %open(pahec0)
     c                   close     pahec0
     c                   endif
     c                   if        %open(pawpc0)
     c                   close     pawpc0
     c                   endif
     c                   if        %open(gti98202)
     c                   close     gti98202
     c                   endif
     c                   if        %open(pawkl1)
     c                   close     pawkl1
     c                   endif
     c                   eval      Initialized = *off
     c                   return
     P SVPAVR_End      E


      **********************************************************************
      *
      *
      *  Manejo de errores
      *
      *
      **********************************************************************
      * ------------------------------------------------------------ *
      * SVPAVR_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPAVR_Error    B                   export
     D SVPAVR_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SVPAVR_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peEnum   (input)   Número de error a setear.             *
      *     peEtxt   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peEnum                       10i 0 const
     D  peEtxt                       80a   const

      /free

       ErrCode = peEnum;
       ErrText = peEtxt;

      /end-free

     P SetError        E

     ?* ------------------------------------------------------------ *
     ?* SVPAVR_getAccion: Retorna Tipo de Accion a tomar             *
     ?*                                                              *
     ?*     peEmpr   (input)   Empresa                               *
     ?*     peSucu   (input)   Sucursal                              *
     ?*     peFech   (input)   Fecha de Asiento                      *
     ?*     peRama   (input)   Rama                                  *
     ?*     peCobc   (input)   Cobertura                             *
     ?*     peMont   (input)   Monto                                 *
     ?*     peArcd   (input)   Aticulo                               *
     ?*                                                              *
     ?* Retorna: *blanks = No contiene Accion                        *
     ?* ------------------------------------------------------------ *
     P SVPAVR_getAccion...
     P                 B                   export
     D SVPAVR_getAccion...
     D                 pi             2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFech                       8  0 const
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
     D   peMont                      15  2 const
     D   peArcd                       6  0 const

     D   @@acc         s              2
     D   @@nres        s              7  0
     D   k1y172        ds                  likerec( s1t172 : *key )
     D   k1y173        ds                  likerec( s1t173 : *key )

      /free

        SVPAVR_inz();

        @@nres = SVPAVR_ExistenReglasVigentes( peEmpr :peSucu :peFech );
        if @@nres = -1;
          return *blanks;
        endif;

        k1y173.t@empr = peEmpr;
        k1y173.t@sucu = peSucu;
        k1y173.t@nres = @@nres;
        k1y173.t@arcd = peArcd;
        chain %kds( k1y173 : 4 ) set173;
        if %found( set173 );
          return *blanks;
        endif;

        k1y172.t@empr = peEmpr;
        k1y172.t@sucu = peSucu;
        k1y172.t@nres = @@nres;
        k1y172.t@rama = peRama;
        k1y172.t@cobc = peCobc;
        chain %kds( k1y172 : 5 ) set172;
        if not %found( set172 );
          return *blanks;
        endif;

        if peMont >= t@mg15;
          Select;
            when t@baja = '1';
              @@acc = 'BS';
            when t@repo = '1';
              @@acc = 'RP';
            other;
              @@acc = 'MA';
          endsl;

        endif;

        return @@acc;

      /end-free

     P SVPAVR_getAccion...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SVPAVR_getReposicion : Retorna Datos de Reposicion           *
     ?*                                                              *
     ?*     peEmpr ( input  )  Empresa                               *
     ?*     peSucu ( input  )  Sucursal                              *
     ?*     peArtc ( input  )  Código area tecnica                   *
     ?*     pePacp ( input  )  Nro. de comprobante de pago           *
     ?*     peDsRp ( output )  Estructura de Archivo de Reposicion   *
     ?*                                                              *
     ?* Retorna:  *on = Encontro / *off = No encontro                *
     ?* ------------------------------------------------------------ *
     P SVPAVR_getReposicion...
     p                 B                   export
     D SVPAVR_getReposicion...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsRp                            likeds( DsCnhopl_t )

     D   k1ycnh        ds                  likerec( c1hopl : *key )
     D   DsIRpo        ds                  likerec( c1hopl : *input )

       /free

        SVPAVR_inz();

        k1ycnh.plempr = peEmpr;
        k1ycnh.plsucu = peSucu;
        k1ycnh.plartc = peArtc;
        k1ycnh.plpacp = pePacp;
        chain %kds( k1ycnh : 4 ) cnhopl dsIRpo;
        if not %found( cnhopl );
          return *off;
        endif;
        eval-corr peDsRp = dsIRpo;
        return *on;

       /end-free

     P SVPAVR_getReposicion...
     p                 E

     ?* ------------------------------------------------------------ *
     ?* SVPAVR_getParamReposicion : Retorna parámetros para realizar *
     ?*                             endoso de Reposicion o Baja Suma *
     ?*     peEmpr ( input  )  Empresa                               *
     ?*     peSucu ( input  )  Sucursal                              *
     ?*     peArtc ( input  )  Código area tecnica                   *
     ?*     pePacp ( input  )  Nro. de comprobante de pago           *
     ?*     peDsRp ( output )  Estructura de Archivo de Reposicion   *
     ?*     peDsPs ( output )  Estructura de Pagos por Componente    *
     ?*     peDsPsC( output )  Cantidad elementos de Pagos           *
     ?*                                                              *
     ?* Retorna:  *on = Encontro / *off = No encontro                *
     ?* ------------------------------------------------------------ *
     P SVPAVR_getParamReposicion...
     p                 B                   export
     D SVPAVR_getParamReposicion...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsRp                            likeds( DsCnhopl_t )
     D   peDsPs                            likeds( DsPoco_t   ) dim( 999 )
     D   peDsPsC                     10i 0

     D   x             s             10i 0
     D   y             s             10i 0
     D   @@DsSi        ds                  likeds( DsPahshp01_t ) dim(999)
     D   @@DsSiC       s             10i 0
     D   @@fech        s              8  0
     D   @@poco        s              6  0
     D   @@paco        s              3  0
     D   @@riec        s              3
     D   @@xcob        s              3  0

       /free

       SVPAVR_inz();

       clear peDsPs;
       if not SVPAVR_getReposicion( peEmpr
                                  : peSucu
                                  : peArtc
                                  : pePacp
                                  : peDsRp );
         return *off;
       endif;

       clear @@DsSi;
       clear @@DsSic;
       if not SVPSIN_getPagos( peEmpr
                             : peSucu
                             : peArtc
                             : pePacp
                             : peDsRp.plrama
                             : peDsRp.plsini
                             : @@DsSi
                             : @@DsSiC       );

         return *off;
       endif;

       clear @@poco;
       clear @@paco;
       clear @@riec;
       clear @@xcob;

       for x = 1 to @@DsSiC;

         if @@DsSi( x ).hppoco  = @@poco and
            @@DsSi( x ).hppaco  = @@paco and
            @@DsSi( x ).hpriec  = @@riec and
            @@DsSi( x ).hpxcob  = @@xcob;
              peDsPs( peDsPsC ).mont += @@DsSi( x ).hpimau;
         else;
              peDsPsC +=1;
              peDsPs( peDsPsC ).poco  = @@DsSi( x ).hppoco;
              peDsPs( peDsPsC ).paco  = @@DsSi( x ).hppaco;
              peDsPs( peDsPsC ).fpaa  = @@DsSi( x ).hpfmoa;
              peDsPs( peDsPsC ).fpam  = @@DsSi( x ).hpfmom;
              peDsPs( peDsPsC ).fpad  = @@DsSi( x ).hpfmod;
              peDsPs( peDsPsC ).riec  = @@DsSi( x ).hpriec;
              peDsPs( peDsPsC ).xcob  = @@DsSi( x ).hpxcob;
              peDsPs( peDsPsC ).mont  = @@DsSi( x ).hpimau;

              @@poco = @@DsSi( x ).hppoco;
              @@paco = @@DsSi( x ).hppaco;
              @@riec = @@DsSi( x ).hpriec;
              @@xcob = @@DsSi( x ).hpxcob;
         endif;
       endfor;

       @@fech = peDsRp.plfasa * 10000 + peDsRp.plfasm * 100 + peDsRp.plfasd;
       for x = 1 to peDsPsC;
         peDsPs( x ).acci =  SVPAVR_getAccion( peEmpr
                                             : peSucu
                                             : @@fech
                                             : peDsRp.plrama
                                             : peDsPs(x).xcob
                                             : peDsPs(x).Mont
                                             : peDsRp.plarcd      );
       endfor;

       return *on;
       /end-free

     P SVPAVR_getParamReposicion...
     p                 E
