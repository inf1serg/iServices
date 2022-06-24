     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPRVS: Programa de Servicio.                                *
      *         Reserva Automatica de Siniestros.                    *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     30-Sep-2014             *
      *------------------------------------------------------------- *
      * Compilacion: Debe tener enlazado el SRVPGM - SPVFEC          *
      * CRTSRVPGM SRVPGM(SVPRVS) MODULE(SVPRVS) SRCFILE(QSRVSRC)     *
      * MBR(SVPRVS) BNDSRVPGM(SPVFEC)                                *
      * ************************************************************ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fset001    if   e           k disk    usropn
     Fpahet0    if   e           k disk    usropn
     Fset446    if   e           k disk    usropn
     Fpahsfr01  if   e           k disk    usropn
     Fpahsbe05  if   e           k disk    usropn
     Fpahsfr    if a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svprvs_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPRVS_chkRamaAuto(): Valida rama se automoviles             *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPRVS_chkRamaAuto...
     P                 B                   export
     D SVPRVS_chkRamaAuto...
     D                 pi              n
     D   peRama                       2  0 const


      /free

       SVPRVS_inz();

       chain peRama set001;

       if not %found(set001);
         SetError( SVPRVS_RAMNE
                 : 'Rama Inexistente' );
         return *Off;
       endif;

       if t@rame <> 4;
         SetError( SVPRVS_RAMIN
                 : 'Rama Invalida Para Este Proceso' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPRVS_chkRamaAuto...
     P                 E

      * ------------------------------------------------------------ *
      * SVPRVS_chkTipoBenef(): Valida tipo de beneficiario           *
      *                                                              *
      *     peTipo   (input)   Tipo de Beneficiario                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPRVS_chkTipoBenef...
     P                 B                   export
     D SVPRVS_chkTipoBenef...
     D                 pi              n
     D   peTipo                       1    const

      /free

       SVPRVS_inz();

       if peTipo <> '1' and peTipo <> '2';
         SetError( SVPRVS_BENIN
                 : 'Beneficiario Invalido Para Este Proceso' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPRVS_chkTipoBenef...
     P                 E

      * ------------------------------------------------------------ *
      * SVPRVS_chkFecEnvio(): Valida fecha de envio                  *
      *                                                              *
      *     peFech   (input)   Fecha de Envio (AAAAMMDD)             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPRVS_chkFecEnvio...
     P                 B                   export
     D SVPRVS_chkFecEnvio...
     D                 pi              n
     D   peFech                       8  0 const

     D @@fech          s              8  0

      /free

       SVPRVS_inz();

       if not SPVFEC_FechaValida8 ( peFech );
         return *Off;
       endif;

       @@fech = *year*10000+*month*100+*day;
       if SPVFEC_FechaMayor8 ( peFech : @@fech ) = 1;
         SetError( SVPRVS_FEMHY
                 : 'Fecha Mayor a Hoy' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPRVS_chkFecEnvio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPRVS_getFranquicia(): Recupera importe de franquicia       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: < 0, Franquicia desde PAHSFR (ya grabada)           *
      *          = 0, No corresponde franquicia                      *
      *          > 0, Franquicia desde PAHET0 (no grabada)           *
      * ------------------------------------------------------------ *

     P SVPRVS_getFranquicia...
     P                 B                   export
     D SVPRVS_getFranquicia...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

     D k1yet0          ds                  likerec(p1het0:*key)
     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1ysfr          ds                  likerec(p1hsfr01:*key)

     D @@suma          s             15  2

      /free

       SVPRVS_inz();
       @@suma = *Zeros;

       k1ysfr.frempr = peEmpr;
       k1ysfr.frsucu = peSucu;
       k1ysfr.frrama = peRama;
       k1ysfr.frsini = peSini;
       k1ysfr.frnops = peNops;
       k1ysfr.frnrdf = peNrdf;
       setll %kds(k1ysfr:6) pahsfr01;
       if %equal(pahsfr01);
         reade %kds(k1ysfr:6) pahsfr01;
         dow not %eof(pahsfr01);
           @@suma += frimau;
           reade %kds(k1ysfr:6) pahsfr01;
         enddo;
         return @@suma * -1;
       endif;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       k1yet0.t0empr = beempr;
       k1yet0.t0sucu = besucu;
       k1yet0.t0arcd = bearcd;
       k1yet0.t0spol = bespol;
       k1yet0.t0sspo = besspo;
       k1yet0.t0rama = berama;
       k1yet0.t0arse = bearse;
       k1yet0.t0oper = beoper;
       k1yet0.t0poco = bepoco;
       chain %kds(k1yet0:9) pahet0;

       if not %found(pahet0);
         return *Zeros;
       else;
         return t0ifra;
       endif;

      /end-free

     P SVPRVS_getFranquicia...
     P                 E

      * ------------------------------------------------------------ *
      * SVPRVS_chkTopeImp(): Controla tope de importe                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peHecg   (input)   Hecho Generador                       *
      *     peImau   (input)   Importe                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPRVS_chkTopeImp...
     P                 B                   export
     D SVPRVS_chkTopeImp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peHecg                       1    const
     D   peImau                      15  2 const

     D k1y446          ds                  likerec(s1t446:*key)
     D k1yet0          ds                  likerec(p1het0:*key)
     D k1ysbe          ds                  likerec(p1hsbe05:*key)

      /free

       SVPRVS_inz();

       setll *Start set446;
       read(n) set446;

       k1y446.t@fech = t@fech;
       k1y446.t@secu = t@secu;
       k1y446.t@hecg = peHecg;
       chain %kds(k1y446) set446;

       if not %found;
         SetError( SVPRVS_IMNOE
                 : 'No se Econtro Importe para Hec. Gen.' );
         return *Off;
       endif;

       if t@mar1 = '1';
         if peImau > t@imau;
           SetError( SVPRVS_IMMAY
                   : 'Importe Mayor a Permitido' );
           return *Off;
         endif;
       endif;

       if t@mar1 = '2' or t@mar1 = '3';
         k1ysbe.beempr = peEmpr;
         k1ysbe.besucu = peSucu;
         k1ysbe.berama = peRama;
         k1ysbe.besini = peSini;
         k1ysbe.benops = peNops;
         k1ysbe.benrdf = peNrdf;
         chain %kds(k1ysbe:6) pahsbe05;

         k1yet0.t0empr = beempr;
         k1yet0.t0sucu = besucu;
         k1yet0.t0arcd = bearcd;
         k1yet0.t0spol = bespol;
         k1yet0.t0sspo = besspo;
         k1yet0.t0rama = berama;
         k1yet0.t0arse = bearse;
         k1yet0.t0oper = beoper;
         k1yet0.t0poco = bepoco;
         chain %kds(k1yet0:9) pahet0;

         if t@mar1 = '2';
           if peImau > t0vhvu;
             SetError( SVPRVS_IMMAY
                     : 'Importe Mayor a Permitido' );
             return *Off;
           endif;
         else;
           if peImau > (t0vhvu + ((t0claj * t0vhvu)/100));
             SetError( SVPRVS_IMMAY
                     : 'Importe Mayor a Permitido' );
             return *Off;
           endif;
         endif;
       endif;

       return *On;

      /end-free

     P SVPRVS_chkTopeImp...
     P                 E

      * ------------------------------------------------------------ *
      * SVPRVS_chkAjustarRva(): Controla si se tiene que ajustar Rva *
      *                                                              *
      *     peTiac   (input)   Tipo de Accion                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPRVS_chkAjustarRva...
     P                 B                   export
     D SVPRVS_chkAjustarRva...
     D                 pi              n
     D   peTiac                       1  0 const

      /free

       SVPRVS_inz();

       if peTiac = 1;
         SetError( SVPRVS_AJRVA
                 : 'Procesado - Se Ajusto Rva' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPRVS_chkAjustarRva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPRVS_chkImporte(): Controla Valor Importe                  *
      *                                                              *
      *     peTiim   (input)   Tipo Importe                          *
      *     peImau   (input)   Importe                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPRVS_chkImporte...
     P                 B                   export
     D SVPRVS_chkImporte...
     D                 pi              n
     D   peTiim                       2    const
     D   peImau                      15  2 const

      /free

       SVPRVS_inz();

       if peTiim <> 'FR' and peImau = *Zeros;
         SetError( SVPRVS_IMCER
                 : 'Importe en Cero' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPRVS_chkImporte...
     P                 E

      * ------------------------------------------------------------ *
      * SVPRVS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPRVS_inz      B                   export
     D SVPRVS_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(pahsfr01);
         open pahsfr01;
       endif;

       if not %open(pahsbe05);
         open pahsbe05;
       endif;

       if not %open(pahsfr);
         open pahsfr;
       endif;

       if not %open(pahet0);
         open pahet0;
       endif;

       if not %open(set446);
         open set446;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPRVS_inz      E

      * ------------------------------------------------------------ *
      * SVPRVS_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPRVS_End      B                   export
     D SVPRVS_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPRVS_End      E

      * ------------------------------------------------------------ *
      * SVPRVS_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPRVS_Error    B                   export
     D SVPRVS_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPRVS_Error    E

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
