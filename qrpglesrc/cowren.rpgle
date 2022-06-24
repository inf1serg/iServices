     H nomain
     H datedit(*DMY/)
     H option(*noshowcpy)
      * ************************************************************ *
      * COWREN: Renovacion Automatica                                *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     08-Jun-2016             *
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
      *> TEXT('Prgrama de Servicio: Reno. Automatica Cot.')     <*   *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                           <*   *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWREN))   <*   *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWREN))        <*   *
      *> IGN: DLTSPLF FILE(COWREN)                              <*   *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SFA 01/09/16 - Recompilo por cambios en dsVeh_t              *
      *              - Procedimiento _setLlamadas COWVEH1 por COWVEH2*
      * LRG 05/09/16 - Se devuelven los accesorios correctamente     *
      *                COWREN_getDsLlamada                           *
      * LRG 09/09/16 - Se corrige calculo de suma asegurada          *
      * LRG 09/11/16 - Procedimiento. _getListaBuenResultado         *
      * LRG 26/12/16 - Se modifica procedimiendo _getDsLlamadas      *
      *                se cambia getFormaDePago por getCodPlanDePago *
      *                en Componente Auto                            *
      * LRG 09/01/16 - Se modifica _getListaBuenResultado, se mueve  *
      *                lógica para cargar combo al procedimiento     *
      *                SVPBUE_getListaBuenResultado                  *
      * GIO 07/02/18 - Modifica procedimiento _getListaFormasDePago  *
      *                para devolver AAAA/MM de Vencimiento Tarjeta  *
      * JSN 17/10/19 - Se agrega los procedimientos:                 *
      *                _getLlamadas2().                              *
      *                _getDsLlamadas2().                            *
      *     29/10/19   _chkErrores2                                  *
      * LRG 14/07/20 - Se cambia llamada SVPREN_chkGeneral por       *
      *                SVPREN_chkGeneralWeb. Incluye todas las       *
      *                validaciones.                                 *
      * JSN 10/09/21 - Se reconpila por cambio en la longitud del    *
      *                campo en la DS RGNC dsVeh2_t                  *
      * ************************************************************ *
     Fctw000    if   e           k disk    usropn
     Fpahed0    if   e           k disk    usropn
     Fpahet9    if   e           k disk    usropn
     Fpahet002  if   e           k disk    usropn
     Fpaher9    if   e           k disk    usropn
     Fpahec1    if   e           k disk    usropn
     Fgnhdtc    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowren_h.rpgle'

     D ErrN            s             10i 0
     D ErrM            s             80a
     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)
      * Llamadas -----------------------------------------------------------
     D COWVEH2         pr                  ExtPgm('COWVEH2')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peVhan                       4    const
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peScta                       1  0 const
     D   peClin                       1    const
     D   peBure                       1  0 const
     D   peCfpg                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * COWREN_getLlamadas(): Retorna Llamadas para COWVEH           *
      *                                                              *
      * ******************** Deprecated **************************** *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_getLlamadas...
     P                 B                   export
     D COWREN_getLlamadas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0

     D p1DsVh          ds                  likeds(dsVeh2_t) dim(20)
     D p1DsVhC         s             10i 0

       COWREN_inz();

       clear p1DsVh;
       p1DsVhC = *Zeros;

       eval-corr p1DsVh = peDsVh;
       p1DsVhC = peDsVhC;

       if COWREN_getLlamadas2( peBase : peNctw : p1DsVh : p1DsVhC );

         return *On;
       endif;

       return *off;

     P COWREN_getLlamadas...
     P                 E

      * ------------------------------------------------------------ *
      * COWREN_getDsLlamadas(): Retorna Ds con Llamadas para COWVEH  *
      *                                                              *
      * ******************** Deprecated **************************** *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_getDsLlamadas...
     P                 B                   export
     D COWREN_getDsLlamadas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0

     D   p1DsVh        ds                  likeds(dsVeh2_t) dim(20)
     D   p1DsVhC       s             10i 0

       COWREN_inz();

       clear p1DsVh;
       p1DsVhC = *Zeros;

       eval-corr p1DsVh = peDsVh;
       p1DsVhC = peDsVhC;

       if COWREN_getDsLlamadas2( peBase
                               : peNctw
                               : p1DsVh
                               : p1DsVhC );

         return *On;
       endif;

       return *off;

     P COWREN_getDsLlamadas...
     P                 E
      * ------------------------------------------------------------ *
      * COWREN_getCodigoDeMensajes():  Retorna código de error       *
      *                                para envio de mensaje         *
      *                                                              *
      *     peMsge   (input)   Mensaje                               *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Poliza                          *
      *     peNivt   (input)   Tipo nivel intermed.                  *
      *     peNivc   (input)   Cod. nivel intermed.                  *
      *     peRama   (input)   Rama                                  *
      *     peVhca   (input)   Capitulo del Vehiculo                 *
      *     peVhv1   (input)   Capitulo variante R.C.                *
      *     pePoco   (input)   Componente                            *
      *     peRepl   (output)  Parametros de Error                   *
      *                                                              *
      * Retorna: Codigo de Mensaje / -1                              *
      * ------------------------------------------------------------ *
     P COWREN_getCodigoDeMensajes...
     P                 B
     D COWREN_getCodigoDeMensajes...
     D                 pi             7
     D   peMsge                      10i 0 const
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options(*nopass:*omit)
     D   peArse                       2  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)
     D   peRepl                   65535    options(*nopass:*omit)

     D   @@nivt        s              1  0 inz
     D   @@nivc        s              5  0 inz
     D   @@asen        s              7  0 inz
     D   @@DsT9        ds                  likeds(dsPahet9_t)

       COWREN_inz();

       SPVSPO_getProductor ( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol
                           : *Omit
                           : @@nivt
                           : @@nivc );

       @@asen = SPVSPO_getAsen ( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol );

       if %parms >= 6 and %addr(peRama) <> *NULL and
          %parms >= 7 and %addr(peArse) <> *NULL and
          %parms >= 8 and %addr(pePoco) <> *NULL;
          clear @@DsT9;
          SPVVEH_getPahet9 ( peEmpr : peSucu : peArcd : peSpol : peRama
                           : peArse : pePoco : @@DsT9 );
       endif;
       Select;
         when  peMsge  = SVPREN_ARTNE;
           %subst( peRepl: 1 : 6 )  = %editc( peArcd  : 'X' );
           return   'COW0000';
         when peMsge  = SVPREN_ARTNW;
           %subst(peRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
           return   'COW0002';
         when  peMsge  = SVPREN_ARNOR;
           %subst(peRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
           return   'REN0000';
         when peMsge  = SVPREN_SPINH;
           %subst(peRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
           %subst(peRepl : 7 : 9 )  = %editc( peSpol  : 'X' );
           return   'REN0100';
         when peMsge  = SVPREN_SPINE;
           %subst(peRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
           %subst(peRepl : 7 : 9 )  = %editc( peSpol  : 'X' );
           return   'SPO0001';
         when peMsge = SVPREN_SPYRE;
           %subst(PeRepl : 1 : 6)  = %editc( peArcd  : 'X' );
           %subst(peRepl : 7 : 9)  = %editc( peSpol  : 'X' );
           return   'REN0101';
         when peMsge = SVPREN_SPSUS;
           %subst( PeRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
           %subst( PeRepl : 7 : 9 )  = %editc( peSpol  : 'X' );
           return   'REN0102';
         when peMsge = SVPREN_SPPSP;
           %subst( PeRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
           %subst( PeRepl : 7 : 9 )  = %editc( peSpol  : 'X' );
           return   'REN0103';
         when peMsge = SVPREN_PCUOP;
           %subst( PeRepl : 1 : 6 )  = %editc( peArcd  : 'X' );
           %subst( PeRepl : 7 : 9 )  = %editc( peSpol  : 'X' );
           return   'REN0104';
         when  peMsge = SVPREN_PRBLO;
           return 'COW0105';
         when peMsge = SVPREN_PRNOR;
           %subst( PeRepl : 1 : 1 )  = %editc( @@Nivt  : 'X' );
           %subst( PeRepl : 2 : 5 )  = %editc( @@Nivc  : 'X' );
           return   'REN0200';
         when peMsge = SVPREN_ACBMZ;
           %subst( PeRepl : 1 : 7 )  = %editc( @@Asen  : 'X' );
           return   'REN0500';
         when peMsge = SVPREN_EPVFL;
           return   'REN0300';
         when peMsge = SVPREN_RCVIN;
           %subst( PeRepl : 1 : 2 )  = %editc( peRama  : 'X' );
           %subst( PeRepl : 2 : 2 )  = %editc( @@DsT9.t9Vhca  : 'X' );
           %subst( PeRepl : 4 : 1 )  = %editc( @@DsT9.t9Vhv1  : 'X' );
           return   'REN0400';
         when peMsge = SVPREN_SUMNE;
           %subst( PeRepl : 1 : 4 )  = %editc( pePoco  : 'X' );
           return   'REN0401';
         when peMsge = SVPREN_SUMPE;
           return   'COW0133';
         when peMsge = SVPREN_PLANP;
           %subst( PeRepl : 1 : 4 )  = %editc( pePoco  : 'X' );
           return   'REN0402';
         when peMsge = SVPREN_POLSI;
           return   'REN0403';
         when peMsge = SVPREN_NOAIR;
           return   'REN0404';
         when peMsge = SVPREN_VAIRS;
           return   'REN0405';
         when peMsge = SVPREN_VANDU;
           return  'COW0042';
         when peMsge = SVPREN_FRAMA;
           return  'REN0406';
         when peMsge = SVPREN_FPNWB;
           return   'COW0206';
         when peMsge = SVPREN_PLNWB;
           return   'COW0154';
         when peMsge = SVPREN_IVANW;
           return   'COW0012';
         when peMsge = SVPREN_FDPNW;
           return   'COW0206';
         other;
           return '-1';
         endsl;

     P COWREN_getCodigoDeMensajes...
     P                 E


      * ------------------------------------------------------------ *
      * COWREN_setLlamadas(): LLama COWVEH2                          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_setLlamadas...
     P                 B                   export
     D COWREN_setLlamadas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t)  dim(20)
     D   peDsVhC                     10i 0

     D   @@Ctre        s              5  0                           inz
     D   @@Paxc        ds                  likeds(cobVeh)   dim(20)  inz
     D   @@Boni        ds                  likeds(bonVeh)   dim(99)  inz
     D   @@Impu        ds                  likeds(Impuesto) dim(99)  inz
     D   @@Erro        s             10i 0                           inz
     D   @@Msgs        ds                  likeds(paramMsgs)         inz
     D   x             s             10i 0                           inz

       COWREN_inz();

       for x = 1 to peDsVhC;

         COWVEH2( peBase
                : peNctw
                : peDsVh(x).Rama
                : peDsVh(x).Arse
                : peDsVh(x).Poco
                : peDsVh(x).Vhan
                : peDsVh(x).Vhmc
                : peDsVh(x).Vhmo
                : peDsVh(x).Vhcs
                : peDsVh(x).Vhvu
                : peDsVh(x).Mgnc
                : peDsVh(x).Rgnc
                : peDsVh(x).Copo
                : peDsVh(x).Cops
                : peDsVh(x).Scta
                : peDsVh(x).Clin
                : peDsVh(x).Bure
                : peDsVh(x).Cfpg
                : peDsVh(x).Tipe
                : peDsVh(x).Civa
                : peDsVh(x).Acce
                : @@Ctre
                : @@Paxc
                : @@Boni
                : @@Impu
                : @@Erro
                : @@Msgs       );

         if @@erro = *Zeros;
           peDsVh(peDsVhC).mar1  = 'S';
         else;
           peDsVh(x).msgs = @@msgs;
         endif;

         endfor;

       return *On;

     P COWREN_setLlamadas...
     P                 E

      * ------------------------------------------------------------ *
      * COWREN_chkGeneral(): Chequeos Generales                      *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Estructura de Error                   *
      *     peMsgsC  (output)  Cantidad de Errores                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_chkGeneral...
     P                 B                   export
     D COWREN_chkGeneral...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs) dim(20)
     D   peMsgsC                     10i 0

     D x               s             10i 0 inz
     D @@Error         ds                  likeDs(dsErro_t) dim(20)inz
     D @@ErrorC        s             10i 0 inz
     D @@CodM          s              7    inz
     D @@repl          s          65535a   inz

       COWREN_inz();

       // Check General
       if not SVPREN_ChkGeneralWeb( peBase.peEmpr
                                  : peBase.peSucu
                                  : peArcd
                                  : peSpol
                                  : @@Error
                                  : peMsgsC        );
         for x = 1 to peMsgsC;
         clear @@repl;
         @@CodM = COWREN_getCodigoDeMensajes( @@error( x ).errN
                                            : peBase.peEmpr
                                            : peBase.peSucu
                                            : peArcd
                                            : peSpol
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@repl );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : @@CodM
                      : peMsgs(x)
                      : %trim(@@repl)
                      : %len( %trim ( @@repl ) ) );
         endfor;
         peErro = -1;
         return *off;
       endif;
         return *on;

     P COWREN_chkGeneral...
     P                 E

      * ------------------------------------------------------------ *
      * COWREN_getListaBuenResultado: Lista cod. de Buen Resultado   *
      *                               Increiblemente !!! se          *
      *                               solicitó que un servicio       *
      *                               devuelva una lista resultante  *
      *                               de la resta por -1 de un Nro   *
      *                               hasta llegar a Cero.           *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Nro. de Cotizacion                    *
      *     peBure   (input)   Cod. de Buen Resultado                *
      *     peLbure  (output)  Lista de Cod. de buen resultado       *
      *     peLbureC (output)  Cantidad                              *
      *     peErro   (output)  Error                                 *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_getListaBuenResultado...
     P                 B                   export
     D COWREN_getListaBuenResultado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peBure                       1  0 const
     D   peLbure                           likeds(dsBure_t) dim(99)
     D   peLbureC                    10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   k1y000        ds                  likeRec( c1w000 : *Key )

     D   x             s             10i 0
     D   z             s             10i 0
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0

      /free

       COWREN_inz();
       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return *off;

       endif;

       //Valido Cotización
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %trim(%char(peNctw));
           %subst(wrepl:8:1) = %char(peBase.peNivt);
           %subst(wrepl:9:5) = %trim(%char(peBase.peNivc));

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return *off;

       endif;

       COWGRAI_getTipoDeOperacion ( peBase : peNctw : @@tiou : @@stou : @@stos);

       if not ( @@tiou = 2 and @@stou = 0 );
         %subst(wrepl:1:7) = %trim(%char(peNctw));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0138'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return *Off;
       endif;

       clear peLbure;
       clear peLbureC;

       if not SVPBUE_getListaBuenResultado( peBure
                                          : peLbure
                                          : peLbureC );
       // enviar error
       return *off;
       endif;

       return *on;

      /end-free
     P COWREN_getListaBuenResultado...
     P                 e

      * ------------------------------------------------------------ *
      * COWREN_getListaFormasDePago: Retorna una lista de todas las  *
      *                              formas de pago que tuvo una     *
      *                              SuperPóliza.                    *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Nro. de Cotizacion                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   SuperPóliza                           *
      *     peCfpg   (input)   Forma de Pago                         *
      *     peLfpg   (output)  Lista de Formas de Pago               *
      *     peLfpgC  (output)  Cantidad de entradas en peLfpg        *
      *     peErro   (output)  Error                                 *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_getListaFormasDePago...
     P                 B                   Export
     D COWREN_getListaFormasDePago...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCfpg                       1  0 const
     D   peLfpg                            likeds(dsCfpg_t) dim(999)
     D   peLfpgC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1hdtc          ds                  likerec(g1hdtc:*key)
     D Lcfpg           s             55a   dim(999)
     D @cfpg           s             55a
     D Lasen           s              7p 0 dim(999)
     D @fvtc           s              6a   inz(*zeros)
     D x               s             10i 0
     D @nrpp           s              3  0
     D @ncbu           s             22a

     D @repl           s          65535a

      /free

       COWREN_inz();

       peLfpgC = 0;
       peErro   = 0;
       x        = 0;
       clear peMsgs;
       clear @cfpg;
       clear peLfpg;
       clear Lasen;

       if SPVSPO_chkSpol( peBase.peEmpr
                        : peBase.peSucu
                        : peArcd
                        : peSpol        ) = *OFF;
          peErro = -1;
          %subst(@repl:1:6) = %trim(%char(peArcd));
          %subst(@repl:7:9) = %trim(%char(peSpol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0001'
                       : peMsgs
                       : @repl
                       : %len(%trim(@repl)) );
          return *off;
       endif;

       if COWGRAI_chkCotizacion( peBase : peNctw ) = *off;
          peErro = -1;
          %subst(@repl:1:7) = %trim(%char(peNctw));
          %subst(@repl:8:1) = %trim(%char(peBase.peNivt));
          %subst(@repl:9:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : @repl
                       : %len(%trim(@repl)) );
          return *off;
       endif;

       k1hec1.c1empr = peBase.peEmpr;
       k1hec1.c1sucu = peBase.peSucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       setgt  %kds(k1hec1:4) pahec1;
       readpe %kds(k1hec1:4) pahec1;
       dow not %eof;

           @nrpp = SPVSPO_getCodPlanDePago( peBase.peEmpr
                                          : peBase.peSucu
                                          : peArcd
                                          : peSpol
                                          : c1sspo        );
           @ncbu = %trim(SPVCBU_getCBUEntero( c1ivbc
                                            : c1ivsu
                                            : c1tcta
                                            : c1ncta )    );

           if @ncbu = *blanks;
              @ncbu = *all'0';
           endif;

           @cfpg = %editc(c1cfpg:'X')
                 + %editc(@nrpp :'X')
                 + %trim(@ncbu)
                 + %editc(c1ctcu:'X')
                 + %editc(c1nrtc:'X');
           x = %lookup(@cfpg:Lcfpg);
           if x = 0;
              x = %lookup(*blanks:Lcfpg);
           endif;
           Lcfpg(x) = @cfpg;
           Lasen(x) = c1asen;
        readpe %kds(k1hec1:4) pahec1;
       enddo;

       for x = 1 to 999;
        if Lcfpg(x) = *blanks;
           leave;
        endif;
           if %subst(Lcfpg(x):1:1) = %editc(peCfpg:'X') or peCfpg = 0;

              @fvtc = *zeros;
              if Lasen(x) <> *zeros and
                 %subst(Lcfpg(x):27:3) <> *zeros and
                 %subst(Lcfpg(x):30:20) <> *zeros;

                k1hdtc.dfnrdf = Lasen(x);
                k1hdtc.dfctcu = %dec(%subst(Lcfpg(x):27:3):3:0);
                k1hdtc.dfnrtc = %DEC(%subst(Lcfpg(x):30:20):20:0);

                chain %kds(k1hdtc) gnhdtc;
                if %found(gnhdtc);
                  @fvtc = %editc(dfffta:'X') + %editc(dffftm:'X');
                endif;

              endif;

              peLfpgC += 1;
              peLfpg(peLfpgC).cfpg = %subst(Lcfpg(x):1:1);
              peLfpg(peLfpgC).nrpp = %subst(Lcfpg(x):2:3);
              peLfpg(peLfpgC).ncbu = %subst(Lcfpg(x):5:22);
              peLfpg(peLfpgC).ctcu = %subst(Lcfpg(x):27:3);
              peLfpg(peLfpgC).nrtc = %subst(Lcfpg(x):30:20);
              peLfpg(peLfpgC).fvtc = @fvtc;

           endif;
       endfor;

       return *on;

      /end-free

     P COWREN_getListaFormasDePago...
     P                 E

      * ------------------------------------------------------------ *
      * COWREN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWREN_inz      B                   export
     D COWREN_inz      pi

       if (initialized);
          return;
       endif;

       if not %open(ctw000);
          open ctw000;
       endif;

       if not %open(pahed0);
          open pahed0;
       endif;

       if not %open(pahet002);
          open pahet002;
       endif;

       if not %open(pahet9);
          open pahet9;
       endif;

       if not %open(paher9);
          open paher9;
       endif;

       if not %open(pahec1);
          open pahec1;
       endif;

       if not %open(gnhdtc);
          open gnhdtc;
       endif;

       initialized = *ON;
       return;

     P COWREN_inz      E

      * ------------------------------------------------------------ *
      * COWREB_End:   Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWREN_End      B                   export
     D COWREN_End      pi

       close *all;
       initialized = *OFF;

       return;

     P COWREN_End      E

      * ------------------------------------------------------------ *
      * COWREN_Error():Retorna el último error del service program   *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWREN_Error    B                   export
     D COWREN_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

     P COWREN_Error    E

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
      * COWREN_chkErrores(): Retorna si hay errores en las estructuras
      *                                                              *
      * ******************** Deprecated **************************** *
      *                                                              *
      *     peMsgs   (input)   Estructura de Error                   *
      *     peMsgsC  (input)   Cantidad de Errores                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_chkErrores...
     P                 B                   export
     D COWREN_chkErrores...
     D                 pi              n
     D peDsVh                              likeds(dsVeh_t) dim(20) const
     D peDsVhC                       10i 0 const

     D @@DsVh          ds                  likeds(dsVeh2_t) dim(20)

       COWREN_inz();

       clear @@DsVh;
       eval-corr @@DsVh = peDsVh;

       if COWREN_chkErrores2( @@DsVh
                            : peDsVhC );
         return *on;
       endif;

       return *Off;


     P COWREN_chkErrores...
     P                 E

      * ------------------------------------------------------------ *
      * COWREN_getLlamadas2(): Retorna Llamadas para COWVEH          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_getLlamadas2...
     P                 B                   export
     D COWREN_getLlamadas2...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh2_t) dim(20)
     D   peDsVhC                     10i 0

     D k1y000          ds                  likeRec(c1w000:*Key)

      /free

       COWREN_inz();

       clear peDsVh;
       peDsVhC = *Zeros;

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds ( k1y000 ) ctw000;

       if not %found ( ctw000 );
         SetError( COWREN_COTNE
                 : 'Cotizacion Inexistente' );
         return *Off;
       endif;

       if not ( w0tiou = 2 and w0stou = 0 );
         SetError( COWREN_COTNR
                 : 'Cotizacion no es Renovacion' );
         return *Off;
       endif;

       COWREN_getDsLlamadas2( peBase : peNctw : peDsVh : peDsVhC );

       return *On;

      /end-free

     P COWREN_getLlamadas2...
     P                 E

      * ------------------------------------------------------------ *
      * COWREN_getDsLlamadas2(): Retorna Ds con Llamadas para COWVEH *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Numero de Cotizacion                  *
      *     peDsVh   (output)  Ds de COWVEH                          *
      *     peDsVhC  (output)  Ds de COWVEH                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_getDsLlamadas2...
     P                 B                   export
     D COWREN_getDsLlamadas2...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh2_t) dim(20)
     D   peDsVhC                     10i 0

     D k1y000          ds                  likeRec(c1w000:*Key)
     D k1yed0          ds                  likeRec(p1hed0:*Key)
     D k1yet9          ds                  likeRec(p1het9:*Key)
     D k1het0          ds                  likeRec(p1het002:*key)
     D k1yer9          ds                  likeRec(p1her9:*Key)
     D x               s             10i 0 inz
     D i               s             10i 0 inz
     D esAuto          s              1    inz('A')
     D esHogar         s              1    inz('H')
     D @@Error         ds                  likeDs(dsErro_t) dim(20)inz
     D @@ErrorC        s             10i 0 inz
     D @@copo          s              5  0 inz
     D @@cops          s              1  0 inz
     D @@nrdf          s              7  0 inz
     D @@repl          s          65535a   inz
     D @@CodM          s              7    inz
     D @@acce          ds                  likeDs(AccVeh_t) dim(100)
     D @@acceC         s             10i 0 inz
     D @@Taaj          s              2  0
     D @@Scor          ds                  likeds(preguntas_t) dim(200)
     D @@ScorC         s             10i 0

      /free

       COWREN_inz();

       clear @@acce;
       @@acceC = *Zeros;

       clear peDsVh;
       peDsVhC = *Zeros;

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds ( k1y000 ) ctw000;

       // Check General
       if not SVPREN_ChkGeneralWeb( peBase.peEmpr
                                  : peBase.peSucu
                                  : w0arcd
                                  : w0spo1
                                  : @@Error
                                  : @@Errorc );
         peDsVhC+=1;
         peDsVh(peDsVhC).base  = peBase ;
         peDsVh(peDsVhC).Nctw  = peNctw ;
         peDsVh(peDsVhC).rama  = *all'9';
         peDsVh(peDsVhC).arse  = *all'9';
         peDsVh(peDsVhC).poco  = *all'9';
         peDsVh(peDsVhC).vhan  = *all'*';
         peDsVh(peDsVhC).vhmc  = *all'*';
         peDsVh(peDsVhC).vhmo  = *all'*';
         peDsVh(peDsVhC).vhcs  = *all'*';
         peDsVh(peDsVhC).vhvu  = *all'9';
         peDsVh(peDsVhC).mgnc  = *all'*';
         peDsVh(peDsVhC).rgnc  = *all'9';
         peDsVh(peDsVhC).copo  = *all'9';
         peDsVh(peDsVhC).cops  = *all'9';
         peDsVh(peDsVhC).scta  = *all'9';
         peDsVh(peDsVhC).clin  = *all'*';
         peDsVh(peDsVhC).bure  = *all'9';
         peDsVh(peDsVhC).cfpg  = *all'9';
         peDsVh(peDsVhC).tipe  = *all'*';
         peDsVh(peDsVhC).civa  = *all'9';
         peDsVh(peDsVhC).mar1  = 'N';

         for x = 1 to @@Errorc;
         clear @@repl;
         @@CodM = COWREN_getCodigoDeMensajes( @@error( x ).errN
                                            : w0empr
                                            : w0sucu
                                            : w0arcd
                                            : w0spo1
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@repl );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : @@CodM
                      : peDsVh(peDsVhC).Msgs(x)
                      : %trim(@@repl)
                      : %len( %trim ( @@repl ) ) );
         endfor;
       endif;

       //Check Vehiculos / Hogar

       k1yed0.d0empr = peBase.peEmpr;
       k1yed0.d0sucu = peBase.peSucu;
       k1yed0.d0arcd = w0Arcd;
       k1yed0.d0spol = w0Spo1;

       setgt %kds ( k1yed0 : 4 ) pahed0;
       readpe %kds ( k1yed0 : 4 ) pahed0;
       k1yed0.d0sspo = d0sspo;

       setll %kds ( k1yed0 : 5 ) pahed0;
       reade %kds ( k1yed0 : 5 ) pahed0;

       dow not %eof ( pahed0 );

         select;
           when SVPWS_getGrupoRama ( d0rama ) = esAuto;
             if not SVPREN_chkPolizaAuto ( d0empr
                                         : d0sucu
                                         : d0arcd
                                         : d0spol
                                         : d0rama
                                         : d0arse
                                         : @@Error
                                         : @@Errorc );

               peDsVhC+=1;
               peDsVh(peDsVhC).base  = peBase ;
               peDsVh(peDsVhC).Nctw  = peNctw ;
               peDsVh(peDsVhC).rama  = d0rama;
               peDsVh(peDsVhC).arse  = d0arse;
               peDsVh(peDsVhC).poco  = *all'9';
               peDsVh(peDsVhC).vhan  = *all'*';
               peDsVh(peDsVhC).vhmc  = *all'*';
               peDsVh(peDsVhC).vhmo  = *all'*';
               peDsVh(peDsVhC).vhcs  = *all'*';
               peDsVh(peDsVhC).vhvu  = *all'9';
               peDsVh(peDsVhC).mgnc  = *all'*';
               peDsVh(peDsVhC).rgnc  = *all'9';
               peDsVh(peDsVhC).copo  = *all'9';
               peDsVh(peDsVhC).cops  = *all'9';
               peDsVh(peDsVhC).scta  = *all'9';
               peDsVh(peDsVhC).clin  = *all'*';
               peDsVh(peDsVhC).bure  = *all'9';
               peDsVh(peDsVhC).cfpg  = *all'9';
               peDsVh(peDsVhC).tipe  = *all'*';
               peDsVh(peDsVhC).civa  = *all'9';
               peDsVh(peDsVhC).mar1  = 'N';

               for x = 1 to @@Errorc;
               clear @@repl;
               @@CodM = COWREN_getCodigoDeMensajes( @@error( x ).errN
                                                  : w0empr
                                                  : w0sucu
                                                  : w0arcd
                                                  : w0spo1
                                                  : *omit
                                                  : *omit
                                                  : *omit
                                                  : @@repl );
               SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : @@CodM
                           : peDsVh(peDsVhC).Msgs(x)
                           : %trim(@@repl)
                           : %len( %trim ( @@repl ) ) );
               endfor;

             endif;
             // Componente Auto
             k1yet9.t9empr = d0Empr;
             k1yet9.t9sucu = d0Sucu;
             k1yet9.t9arcd = d0Arcd;
             k1yet9.t9spol = d0Spol;
             setll %kds ( k1yet9 : 4 ) pahet9;
             reade %kds ( k1yet9 : 4 ) pahet9;
             dow not %eof ( pahet9 );
               if t9aegn = *Zeros;
                 SVPREN_chkComponenteAuto ( t9empr
                                          : t9sucu
                                          : t9arcd
                                          : t9spol
                                          : t9rama
                                          : t9arse
                                          : t9poco
                                          : @@Error
                                          : @@Errorc );
                  peDsVhC+=1;
                  peDsVh(peDsVhC).base  = peBase ;
                  peDsVh(peDsVhC).Nctw  = peNctw ;
                  peDsVh(peDsVhC).rama  = t9rama;
                  peDsVh(peDsVhC).arse  = t9arse;
                  peDsVh(peDsVhC).poco  = SVPREN_getComponente( t9empr
                                                              : t9sucu
                                                              : t9arcd
                                                              : t9spol
                                                              : t9rama
                                                              : t9arse
                                                              : t9poco );
                  peDsVh(peDsVhC).vhan  =
                                     %editc(SPVVEH_getAÑoVehiculo( t9empr
                                                                 : t9sucu
                                                                 : t9arcd
                                                                 : t9spol
                                                                 : t9rama
                                                                 : t9arse
                                                                 : t9poco   )
                                                                 :'X' );
                  peDsVh(peDsVhC).vhmc  = t9vhmc;
                  peDsVh(peDsVhC).vhmo  = t9vhmo;
                  peDsVh(peDsVhC).vhcs  = t9vhcs;
                  peDsVh(peDsVhC).vhvu  = SVPREN_getAccesoriosComponente
                                          ( t9empr
                                          : t9sucu
                                          : t9arcd
                                          : t9spol
                                          : t9rama
                                          : t9arse
                                          : t9poco
                                          : @@acce
                                          : @@acceC );
                  peDsVh(peDsVhC).vhvu +=
                                  SVPREN_getSumaAseguradaVehiculo( t9empr
                                                                 : t9sucu
                                                                 : t9arcd
                                                                 : t9spol
                                                                 : t9rama
                                                                 : t9arse
                                                                 : t9poco   );
                  peDsVh(peDsVhC).rgnc  = SVPREN_getImporteGnc( t9empr
                                                              : t9sucu
                                                              : t9arcd
                                                              : t9spol
                                                              : t9rama
                                                              : t9arse
                                                              : t9poco);
                  peDsVh(peDsVhC).vhvu +=  peDsVh(peDsVhC).rgnc;

                  if peDsVh(peDsVhC).rgnc = 0;
                    peDsVh(peDsVhC).mgnc  = 'N';
                  else;
                    peDsVh(peDsVhC).mgnc  = 'S';
                  endif;

                  clear @@copo;
                  clear @@cops;
                  @@nrdf = SPVSPO_getAsen( t9empr
                                         : t9sucu
                                         : t9arcd
                                         : t9spol );

                  SVPDAF_getLocalidad( @@nrdf
                                     : @@copo
                                     : @@cops
                                     : *Omit
                                     : *Omit
                                     : *Omit
                                     : *Omit           );

                  peDsVh(peDsVhC).copo  = @@copo;
                  peDsVh(peDsVhC).cops  = @@cops;
                  peDsVh(peDsVhC).scta  = SVPREN_getZona( t9empr
                                                        : t9sucu
                                                        : t9arcd
                                                        : t9spol
                                                        : t9rama
                                                        : t9arse
                                                        : t9poco );
                  if SVPREN_getClienteIntegral( t9empr
                                              : t9sucu
                                              : t9arcd
                                              : t9spol
                                              : t9rama
                                              : t9arse
                                              : t9poco );
                    peDsVh(peDsVhC).clin = 'S';
                  else;
                    peDsVh(peDsVhC).clin = 'N';
                  endif;
                  peDsVh(peDsVhC).bure  = SVPREN_getBuenResultado( t9empr
                                                                 : t9sucu
                                                                 : t9arcd
                                                                 : t9spol
                                                                 : t9rama
                                                                 : t9arse
                                                                 : t9poco )   ;

                  peDsVh(peDsVhC).cfpg  = SVPREN_getPlanDePago( t9Empr
                                                              : t9Sucu
                                                              : t9Arcd
                                                              : t9Spol
                                                              : 'W'    );

                  If peDsVh(peDsVhC).cfpg  = -001;
                     @@Errorc += 1;
                     @@Error(@@ErrorC).errM = SVPREN_Error(ErrCode);
                     @@Error(@@ErrorC).errN = SVPREN_FPNWB;
                  EndIf;

                  if SVPDAF_getTipoSociedad( @@nrdf ) = 98;
                    peDsVh(peDsVhC).tipe = 'F';
                  else;
                    peDsVh(peDsVhC).tipe = 'J';
                  endif;
                  peDsVh(peDsVhC).civa  = SPVSPO_getCodigoIva( t9empr
                                                             : t9sucu
                                                             : t9arcd
                                                             : t9spol );
                  peDsVh(peDsVhC).mar1  = 'N';
                  peDsVh(peDsVhC).nmat  = t9nmat;
                  peDsVh(peDsVhC).moto  = t9moto;
                  peDsVh(peDsVhC).chas  = t9chas;
                  peDsVh(peDsVhC).ruta  = t9ruta;
                  peDsVh(peDsVhC).vhuv  = t9vhuv;
                  peDsVh(peDsVhC).nmer  = t9nmer;
                  peDsVh(peDsVhC).acrc  = t9acrc;
                  peDsVh(peDsVhC).aver  = 'N';

                  clear @@Taaj;
                  clear @@Scor;
                  clear @@ScorC;

                  if SVPREN_getScoring( t9Empr
                                      : t9sucu
                                      : t9arcd
                                      : t9spol
                                      : t9rama
                                      : t9arse
                                      : t9poco
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@Taaj
                                      : @@Scor
                                      : @@ScorC       );

                    peDsVh(peDsVhC).taaj = @@Taaj;
                    i = 0;
                    for x = 1 to @@ScorC;
                      i += 1;
                      peDsVh(peDsVhC).Scor(i).Cosg = @@Scor(x).Cosg;
                      peDsVh(peDsVhC).Scor(i).Vefa = @@Scor(x).Vefa;
                      peDsVh(peDsVhC).Scor(i).Cant = @@Scor(x).Cant;
                    endfor;
                  endif;

                  k1het0.t0empr = t9empr;
                  k1het0.t0sucu = t9sucu;
                  k1het0.t0arcd = t9arcd;
                  k1het0.t0spol = t9spol;
                  k1het0.t0rama = t9rama;
                  k1het0.t0arse = t9arse;
                  k1het0.t0oper = t9oper;
                  k1het0.t0poco = t9poco;
                  chain %kds(k1het0:8) pahet002;
                  if %found;
                     if t0mar1 = '1';
                        peDsVh(peDsVhC).aver  = 'S';
                      else;
                        peDsVh(peDsVhC).aver  = 'N';
                     endif;
                  endif;
                  peDsVh(peDsVhC).acce  = @@acce;
                  for x = 1 to @@Errorc;
                  clear @@repl;
                  @@CodM = COWREN_getCodigoDeMensajes( @@error( x ).errN
                                                     : w0empr
                                                     : w0sucu
                                                     : w0arcd
                                                     : w0spo1
                                                     : t9rama
                                                     : t9arse
                                                     : t9poco
                                                     : @@repl );
                  SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : @@CodM
                               : peDsVh(peDsVhC).Msgs(x)
                               : %trim(@@repl)
                               : %len( %trim ( @@repl ) ) );
                 endfor;
               endif;
                reade %kds ( k1yet9 : 4 ) pahet9;
             enddo;
           when SVPWS_getGrupoRama ( d0rama ) = esHogar;
             SVPREN_chkPolizaHogar ( d0empr
                                   : d0sucu
                                   : d0arcd
                                         : d0spol
                                         : d0rama
                                         : d0arse
                                         : @@Error
                                         : @@Errorc );
              peDsVhC+=1;
              peDsVh(peDsVhC).base  = peBase ;
              peDsVh(peDsVhC).Nctw  = peNctw ;
              peDsVh(peDsVhC).rama  = d0rama;
              peDsVh(peDsVhC).arse  = d0arse;
              peDsVh(peDsVhC).poco  = *all'9';
              peDsVh(peDsVhC).vhan  = *all'*';
              peDsVh(peDsVhC).vhmc  = *all'*';
              peDsVh(peDsVhC).vhmo  = *all'*';
              peDsVh(peDsVhC).vhcs  = *all'*';
              peDsVh(peDsVhC).vhvu  = *all'9';
              peDsVh(peDsVhC).mgnc  = *all'*';
              peDsVh(peDsVhC).rgnc  = *all'9';
              peDsVh(peDsVhC).copo  = *all'9';
              peDsVh(peDsVhC).cops  = *all'9';
              peDsVh(peDsVhC).scta  = *all'9';
              peDsVh(peDsVhC).clin  = *all'*';
              peDsVh(peDsVhC).bure  = *all'9';
              peDsVh(peDsVhC).cfpg  = *all'9';
              peDsVh(peDsVhC).tipe  = *all'*';
              peDsVh(peDsVhC).civa  = *all'9';
              peDsVh(peDsVhC).mar1  = 'N';
              for x = 1 to @@Errorc;
              clear @@repl;
              @@CodM = COWREN_getCodigoDeMensajes( @@error( x ).errN
                                                 : w0empr
                                                 : w0sucu
                                                 : w0arcd
                                                 : w0spo1
                                                 : *omit
                                                 : *omit
                                                 : *omit
                                                 : @@repl );
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : @@CodM
                           : peDsVh(peDsVhC).Msgs(x)
                           : %trim(@@repl)
                           : %len( %trim ( @@repl ) ) );
              endfor;

             // Componente Hogar
               k1yer9.r9empr = d0Empr;
               k1yer9.r9sucu = d0Sucu;
               k1yer9.r9arcd = d0Arcd;
               k1yer9.r9spol = d0Spol;
               setll %kds ( k1yer9 : 4 ) paher9;
               reade %kds ( k1yer9 : 4 ) paher9;
               dow not %eof ( paher9 );
                 reade %kds ( k1yer9 : 4 ) paher9;
              enddo;
         endsl;

         reade %kds ( k1yed0 : 5 ) pahed0;

       enddo;
       return *On;

      /end-free

     P COWREN_getDsLlamadas2...
     P                 E

      * ------------------------------------------------------------ *
      * COWREN_chkErrores2(): Retorna si hay errores en las          *
      *                       estructuras                            *
      *                                                              *
      *     peMsgs   (input)   Estructura de Error                   *
      *     peMsgsC  (input)   Cantidad de Errores                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P COWREN_chkErrores2...
     P                 B                   export
     D COWREN_chkErrores2...
     D                 pi              n
     D peDsVh                              likeds(dsVeh2_t) dim(20) const
     D peDsVhC                       10i 0 const

     D x               s             10i 0 inz
     D y               s             10i 0 inz

      /free

       COWREN_inz();

       for x = 1 to peDsVhC;

         for y = 1 to 20;

           if peDsVh(x).msgs(y).peMsev <> *Zeros;
             return *On;
           endif;

         endfor;

       endfor;

       return *Off;

      /end-free

     P COWREN_chkErrores2...
     P                 E

