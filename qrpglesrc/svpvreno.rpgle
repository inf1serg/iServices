      ****************************************************************
      *  Recuperar si una póliza es o no renovable.
      *  Pedido de desarrollo 3303
      *
      *  Inf1Marc  17/01/2014
      ****************************************************************
      * SGF 03/11/2014: Agrego Auditoría como parámetro opcional.
      *                 La auditoría implica: usuario, fecha, hora y
      *                 motivo.
      *
      ****************************************************************
     H nomain
      /if defined(*CRTBNDRPG)
     H dftactgrp(*no) actgrp(*CALLER)
      /endif
     H Debug(*yes) option(*nodebugio:*srcstmt)
     H EXPROPTS(*RESDECPOS) ALWNULL(*USRCTL)COPYRIGHT('HDI Seguros S.A.')
     fpahav1    if   e           k disk    usropn
     fpahavv02  if   e           k disk    usropn
      /copy HDIILE/qcpybooks,SVPVRENO_H
     D Initialized     s               n
     D FechaEmi        s              8P 0
     D PAR310X3        pr                  extpgm('PAR310X3')
     D    Empr                        1    const
     D    @aÑo                        4  0
     D    @mes                        2  0
     D    @dia                        2  0
     D DTAAVTO01       ds                  DTAARA(DTAAVTO01)
     D  Activo                        1
      *-------------------------------------------------------------
      * SVPVRENO_SuperPolizaRenovable()
      *          Obtiene si la super-poliza es renovable
      *
      * peempr      Input   Empresa
      * pesucu      Input   Sucursal
      * pearcd      Input   Artículo
      * pespol      Input   Super-poliza
      *
      * Devuelve '1' si la super-póliza es renovable.
      *
      *-------------------------------------------------------------
     P SVPVRENO_SuperPolizaRenovable...
     P                 B                   export
     D SVPVRENO_SuperPolizaRenovable...
     D                 pi             1n
     D   peempr                       1    const
     D   pesucu                       2    const
     D   pearcd                       6P 0 const
     D   pespol                       9P 0 const
     D   peAudi                            likeds(Audit_t)
     D                                     options(*nopass:*omit)
     D   retorno       s               n
     c     k_pahavv02    Klist
     c                   kfld                    VVEMPR
     c                   kfld                    VVSUCU
     c                   kfld                    VVARCD
     c                   kfld                    VVSPOL
     c                   if        not Initialized
     c                   callp     SVPVRENO_inz
     c                   endif
     c                   if        Activo <> 'S'
     c                   eval      retorno = '1'
     c                   else
      **
     c                   if        not %open(pahavv02)
     c                   open(e)   pahavv02
     c                   endif
     c                   if        not %error
     c                   eval      VVEMPR = peempr
     c                   eval      VVSUCU = pesucu
     c                   eval      VVARCD = pearcd
     c                   eval      VVSPOL = pespol
     c                   eval      retorno = '1'
     c     k_pahavv02    setll     p1havv
     c     k_pahavv02    reade     p1havv
     c                   dow       not %eof and retorno = '1'
     C                   if        %parms >= 5 and %addr(peAudi) <> *null
     c                   eval      retorno = SVPVRENO_PolizaRenovable(
     c                                                              VVEMPR:
     c                                                              VVSUCU:
     c                                                              VVRAMA:
     c                                                              VVPOLI:
     C                                                              *omit :
     C                                                              peAudi)
     C                   else
     c                   eval      retorno = SVPVRENO_PolizaRenovable(
     c                                                              VVEMPR:
     c                                                              VVSUCU:
     c                                                              VVRAMA:
     c                                                              VVPOLI)
     C                   endif
     c     k_pahavv02    reade     p1havv
     c                   enddo
     c                   endif
      **
     c                   endif
     c                   return    retorno
     P SVPVRENO_SuperPolizaRenovable...
     P                 E
      *-------------------------------------------------------------
      * SVPVRENO_PolizaRenovable(): Obtiene si la poliza es renovable
      *
      * peempr      Input   Empresa
      * pesucu      Input   Sucursal
      * perama      Input   Rama
      * pepoli      Input   Póliza
      * pefchamd    Input(*nopass:*omit)
      *               Opcionalmente se recibe Fecha a la cual chequear.
      *               Si no se recibe fecha usa PAR310X3.
      *
      *
      * Devuelve '1' si la super-póliza es renovable.
      *
      *-------------------------------------------------------------
     P SVPVRENO_PolizaRenovable...
     P                 B                   export
     D SVPVRENO_PolizaRenovable...
     D                 pi             1n
     D   peempr                       1    const
     D   pesucu                       2    const
     D   perama                       2P 0 const
     D   pepoli                       7P 0 const
     D   pefchamd                     8P 0 const options(*nopass:*omit)
     D   peAudi                            likeds(Audit_t)
     D                                     options(*nopass:*omit)
     D   retorno       s               n
     c     k_pahav1      Klist
     c                   kfld                    V1EMPR
     c                   kfld                    V1SUCU
     c                   kfld                    V1RAMA
     c                   kfld                    V1POLI
     c                   if        not Initialized
     c                   Callp     SVPVRENO_inz
     c                   endif
     c                   if        Activo <> 'S'
     c                   eval      retorno = '1'
     c                   else
     c                   if        %parms >= 5  and %addr(pefchamd)<> *NULL
     c                   eval      FechaEmi = pefchamd
     c                   else
     c                   eval      FechaEmi = SVPVRENO_Fecha_de_emision(
     c                                                 peempr)
     c                   endif
     c                   eval      V1EMPR = peempr
     c                   eval      V1SUCU = pesucu
     c                   eval      V1RAMA = perama
     c                   eval      V1POLI = pepoli
     c                   if        not %open(pahav1)
     c                   open(e)   pahav1
     c                   endif
     c                   if        not %error
     c     k_pahav1      setgt     p1hav1
     c     k_pahav1      readpe    p1hav1
     c                   dow       not %eof and V1FECH > FechaEmi
     c     k_pahav1      readpe    p1hav1
     c                   enddo
     c                   if        not %eof
     c                   if        V1MAR1 = 'S'
     c                   eval      retorno = '1'
     c                   else
     c                   eval      retorno = '0'
     c                   endif

     C                   if        %parms >= 6 and %addr(peAudi) <> *null
     C                   eval      peAudi.Moti = v1moti
     C                   eval      peAudi.User = v1user
     C                   eval      peAudi.Fech = v1fech
     C                   eval      peAudi.Hora = v1time
     C                   endif

     c                   else
     c                   eval      retorno = '1'
     c                   endif
     c                   endif
     c                   endif
     c                   return    retorno
     P SVPVRENO_PolizaRenovable...
     P                 E
      *-------------------------------------------------------------
      * SVPVRENO_Fecha_de_emision(): Busca Fecha de Emisión de Gaus.
      *
      * peempr      Input   Empresa
      *
      *          Devuelve la fecha de actual de emisión que está
      *         utilizado GAUS
      *
      *-------------------------------------------------------------
     P SVPVRENO_Fecha_de_emision...
     P                 B                   export
     D SVPVRENO_Fecha_de_emision...
     D                 pi             8P 0
     D   peempr                       1    const
     D   pefchamd      s              8P 0
     D   @aÑo          s              4  0
     D   @mes          s              2  0
     D   @dia          s              2  0
     C                   callp     PAR310X3(peEmpr
     C                                      :@aÑo
     C                                      :@mes
     C                                      :@dia )
     c                   eval      pefchamd=(@aÑo * 10000 + @mes * 100 + @dia)
     C                   return    pefchamd
     P SVPVRENO_Fecha_de_emision...
     P                 E
      *-------------------------------------------------------------
      * SVPVRENO__inz(): Inicializa Service Program.
      *
      * Devuelve '1' Indicando que se ejecutó.
      *
      *  La variable "Activo" es global y tendrá el valor de la DATAARA
      * DTAAVTO01 indicando si está o no activo el módulo de administra-
      * ción de Avisos de vencimiento.
      *-------------------------------------------------------------
     P SVPVRENO_inz    B                   export
     D SVPVRENO_inz    pi
     c                   if        not Initialized
     c                   in        DTAAVTO01
     c                   unlock    DTAAVTO01
     c                   if        Activo <> 'S'
     c                   eval      Activo  = 'N'
     c                   endif
     c                   eval      Initialized = *on
     c                   endif
     c                   return
     P SVPVRENO_inz    E
      *-------------------------------------------------------------
      * SVPVRENO_End()  Cierre de archivos y programa.
      *
      *-------------------------------------------------------------
     P SVPVRENO_End    B                   export
     D SVPVRENO_End    pi
     c                   if        %open(pahav1)
     c                   Close     pahav1
     c                   endif
     c                   if        %open(pahavv02)
     c                   Close     pahavv02
     c                   endif
     c                   eval      Initialized = *off
     c*                  seton                                        lr
     c                   return
     P SVPVRENO_End    E


      **********************************************************************
      *
      *
      *  Manejo de errores
      *
      *
      **********************************************************************
      * ------------------------------------------------------------ *
      * SVPVRENO_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPVRENO_Error  B                   export
     D SVPVRENO_Error  pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SVPVRENO_Error  E

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

