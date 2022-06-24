     H nomain
      * ************************************************************ *
      * PRWFPG: Programa de Servicio.                                *
      *         Propuesta Web - Insertar Forma de Pago               *
      *                                                              *
      * Este programa debe enlazarse a:                              *
      *      - SVPWS:  Servicios Web                                 *
      *      - SVPVAL: Validaciones Cotizaciones/Propuestas Web      *
      *      - SPVCBU: Operaciones con CBU                           *
      *      - SPVTCR: Operaciones con Tarjetas de Crédito           *
      *                                                              *
      *  Script de compilación (para INF1SERG/BUILD)                 *
      *                                                              *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) -       <*           *
      *>                 OBJ((&N))
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *> TEXT('Programa de Servicio: Forma de Pago Prop. Web') <*    *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) -       <*           *
      *>                 OBJ((&N))                      <*           *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                                             *
      * ------------------------------------------------------------ *
      * SGF 06/08/2016: Recompilo por ASEN en CTW000.                *
      * SGF 03/01/2017: Valida fecha de vencimiento de tarjeta de    *
      *                 acuerdo a lo que diga CNTVTC.                *
      * LRG 15/08/2017: Se recompila por cambios en CTW000:          *
      *                          º Número de Cotización API          *
      *                          º Nombre de Sistema Remoto          *
      *                          º CUIT del productor                *
      * LRG 13/10/2017: Se recompila por cambios en CTW000:          *
      *                          º Nombre de Usuario                 *
      * NWN 11/03/2019 - Se agrega nuevo mensaje de validación en    *
      *                  COWGRAI_chkTarjCredito (TCR0005).           *
      * GIO 07/06/2019: RM#5147 Agrega validacion para el            *
      *                 vencimiento de la Tarjeta de Credito         *
      *                                                              *
      * ERC 09/11/2020: Se agrega el control de CBU para que no in-  *
      *                 grese el de HDI.                             *
      *                                                              *
      * ERC 26/07/2021: Se controla que no ingrese el CBU del Banco  *
      *                 Brubank.(Cod.143)                            *
      *                                                              *
      * ERC1 21/12/2021:Se controla que no ingrese el CBU del Banco  *
      *                 Del Sol.(Cod.310)                            *
      *                                                              *
      * ERC2 10/02/2022:Se habilita que pueda ingresar el CBU del    *
      *                 banco Brubank.(Cod.143)                      *
      *                                                              *
      * ************************************************************ *
     Fctw000    uf a e           k disk    usropn
     Fgntfpg    uf a e           k disk    usropn
     Fcntvtc    if   e           k disk    usropn

      /copy './qcpybooks/prwfpg_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'

     D SetError        pr
     D  peErrn                       10i 0
     D  peErrm                       80a

     D Initialized     s              1N
     D Errn            s             10i 0
     D Errm            s             80a

      * ------------------------------------------------------------ *
      * PRWFPG_insertFormaPago(): Insertar/Actualizar forma de pago  *
      *                           para una propuesta Web.            *
      *                                                              *
      *    peBase   (input)   Parámetro Base                         *
      *    peNctw   (input)   Número de Cotización                   *
      *    peCfpg   (input)   Código de Forma de Pago                *
      *    peNcbu   (input)   Número de CBU                          *
      *    peCtcu   (input)   Empresa Tarjeta de Crédito             *
      *    peNrtc   (input)   Número de Tarjeta de Crédito           *
      *    peFema   (input)   Año Vencimiento de Tarjeta de Crédito  *
      *    peFemm   (input)   Mes Vencimiento de Tarjeta de Crédito  *
      *    peErro   (output)  Indicador de Error                     *
      *    peMsgs   (output)  Estructura Mensaje de Error            *
      *                                                              *
      * Retorna: Void                                                *
      * ------------------------------------------------------------ *
     P PRWFPG_insertFormaDePago...
     P                 B                   Export
     D PRWFPG_insertFormaDePago...
     D                 pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peCfpg                        1  0 const
     D  peNcbu                       22  0 const
     D  peCtcu                        3  0 const
     D  peNrtc                       20  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D k1w000          ds                  likerec(c1w000:*key)
     D k1tvtc          ds                  likerec(c1tvtc:*key)
     D rc              s              1N
     D rc2             s             10i 0
     D hoy             s              6  0
     D @ncbu           s             25
     D peIvbc          s              3  0
     D peIvsu          s              3  0
     D peTcta          s              2  0
     D peNcta          s             25
     D fvto            s              6  0
     D wrepl           s          65535a
     D @cfpg           s              1  0
     D fdp             s              1N
     D @id             s              7a

      /free

       PRWFPG_inz();

       hoy  = (*year  * 100) + *month;
       fvto = (peFema * 100) + peFemm;

       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain(n) %kds(k1w000:5) ctw000;
       fdp   = COWGRAI_getFormaDePagoPdP( peBase
                                        : peNctw
                                        : w0arcd
                                        : w0nrpp
                                        : @cfpg   );

       // -----------------------------
       // Valido parámetro base
       // -----------------------------
       rc = SVPWS_chkParmBase( peBase : peMsgs );
       if ( rc = *OFF );
          peErro = -1;
          return;
       endif;

       // -----------------------------
       // Valida cotización existente
       // -----------------------------
       rc = COWGRAI_chkCotizacion( peBase : peNctw);
       if ( rc = *OFF );
          %subst(wrepl:1:7) = %editc(peNctw:'X');
          %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
          %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // --------------------------------------------------------
       // Valida que forma de pago ingresada sea la misma cotizada
       // --------------------------------------------------------
       //rc = COWGRAI_formaDePagoCot( peBase :
       //                             peNctw :
       //                             @Cfpg );
       //if ( rc = *OFF );
       //   SVPWS_getMsgs( '*LIBL'
       //                : 'WSVMSG'
       //                : 'COW0109'
       //                : peMsgs
       //                : %trim(wrepl)
       //                : %len(%trim(wrepl))  );
       //   peErro = -1;
       //   return;
       //endif;

       // -----------------------------
       // Valida forma de pago
       // -----------------------------
       rc = SVPVAL_formaDePago( @Cfpg );
       if ( rc = *OFF );
          %subst(wrepl:1:1) = %editc(@Cfpg:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0025'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // -----------------------------
       // Valida forma de pago web
       // -----------------------------
       rc = SVPVAL_formaDePagoWeb( @Cfpg );
       if ( rc = *OFF );
          %subst(wrepl:1:1) = %editc(@Cfpg:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0026'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // -----------------------------
       // Valida coherencia de parms
       // Pedirle mensajes a SFA
       // -----------------------------
       select;
        when @Cfpg = 1;
             rc2 = COWGRAI_chkTarjCredito(peBase:penctw:peCtcu:peNrtc);
             if rc2 <> 0;
                select;
                 when rc2 = -1;
                      @id = 'TCR0001';
                 when rc2 = -2;
                      @id = 'TCR0003';
                 when rc2 = -3;
                      @id = 'TCR0004';
                 when rc2 = -4;
                      @id = 'TCR0005';
                endsl;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : @id
                             : peMsgs      );
                peErro = -1;
                return;
             endif;
             k1tvtc.tcfini = %dec(%date():*iso);
             setll %kds(k1tvtc:1) cntvtc;
             read  cntvtc;
             if %eof;
                tcmar1 = 'S';
             endif;
             if fvto <= *zeros;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0187'
                             : peMsgs      );
                peErro = -1;
                return;
             endif;
             if fvto < hoy and tcmar1 = 'S';
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0078'
                             : peMsgs      );
                peErro = -1;
                return;
             endif;
        when @Cfpg = 2 or @Cfpg = 3;
             if peNcbu <= 0;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0079'
                             : peMsgs      );
                peErro = -1;
                return;
             endif;

             if peNcbu >  0;
             if peNcbu = 0150931502000004416050 or
                peNcbu = 0070999020000051878944 or
                peNcbu = 0270100010000490110013 or
                peNcbu = 2850000330000800745601 or
                peNcbu = 0720420720000000000240;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0079'
                             : peMsgs      );
                peErro = -1;
                return;
             endif;
     ***     if %subst(%editc(peNcbu:'X'):1:3) = '143';
     ***        SVPWS_getMsgs( '*LIBL'
     ***                     : 'WSVMSG'
     ***                     : 'COW0079'
     ***                     : peMsgs      );
     ***        peErro = -1;
     ***        return;
     ***     endif;
             if %subst(%editc(peNcbu:'X'):1:3) = '310';
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0079'
                             : peMsgs      );
                peErro = -1;
                return;
             endif;
             endif;

             @ncbu = %editc(peNcbu:'X');
             rc = SPVCBU_getCBUSeparado( @ncbu
                                       : peIvbc
                                       : peIvsu
                                       : peTcta
                                       : peNcta );
             if rc = *OFF;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0079'
                             : peMsgs      );
                peErro = -1;
                return;
             endif;
       endsl;

       // -----------------------------
       // Actualizo y me las tomo
       // -----------------------------
       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain %kds(k1w000:5) ctw000;
       if %found;
          w0cfpg = @Cfpg;
          select;
           when @Cfpg = 1;
                w0ctcu = peCtcu;
                w0nrtc = peNrtc;
                w0fvtc = (peFema * 100) + peFemm;
                w0ncbu = 0;
           when @Cfpg = 2 or peCfpg = 3;
                w0ncbu = peNcbu;
                w0ctcu = 0;
                w0nrtc = 0;
                w0fvtc = 0;
           when @Cfpg = 4;
                w0ncbu = 0;
                w0ctcu = 0;
                w0nrtc = 0;
                w0fvtc = 0;
          endsl;
          chain @Cfpg gntfpg;
          if not %found;
             fpdefp = *all'*';
          endif;
          w0defp = fpdefp;
          update c1w000;
       endif;

       return;

      /end-free

     P PRWFPG_insertFormaDePago...
     P                 E

      * ------------------------------------------------------------ *
      * PRWFPG_inz(): Inicializa Módulo                              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWFPG_inz      B                   Export
     D PRWFPG_inz      pi

      /free

       if Initialized;
          return;
       endif;

       if not %open(ctw000);
          open ctw000;
       endif;

       if not %open(gntfpg);
          open gntfpg;
       endif;

       if not %open(cntvtc);
          open cntvtc;
       endif;

       Initialized = *ON;
       return;

      /end-free

     P PRWFPG_inz      E

      * ------------------------------------------------------------ *
      * PRWFPG_end(): Finaliza  Módulo                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWFPG_end      B                   Export
     D PRWFPG_end      pi

      /free

       Initialized = *OFF;
       close *all;
       return;

      /end-free

     P PRWFPG_end      E

      * ------------------------------------------------------------ *
      * PRWFPG_error(): Retorna último error del módulo.             *
      *                                                              *
      *      peErrn  (input)  Número de error (opcional)             *
      *                                                              *
      * Retorna: mensaje de error                                    *
      * ------------------------------------------------------------ *
     P PRWFPG_error    B                   Export
     D PRWFPG_error    pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *NULL;
          peErrn = Errn;
       endif;

       return Errm;

      /end-free

     P PRWFPG_error    E

      * ------------------------------------------------------------ *
      * SetError(): Establece error global.                          *
      *                                                              *
      *      peErrn  (input)  Número de error                        *
      *      peErrm  (input)  Mensaje de Error                       *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0
     D  peErrm                       80a

      /free

       Errn = peErrn;
       Errm = peErrm;

       return;

      /end-free

     P SetError        E

