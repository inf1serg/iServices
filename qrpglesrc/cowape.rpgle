     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * COWAPE: Cotización AP                                        *
      * ------------------------------------------------------------ *
      * Julio César Barranco                 23-Dic-2015             *
      * ------------------------------------------------------------ *
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
      *> TEXT('Programa de Servicio: Cotización Vehículos') <*       *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWAPE)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWAPE)) <*         *
      *> IGN: DLTSPLF FILE(COWAPE)                           <*     *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * 15/12/15 - Se realizaron cambios de parametros            *  *
      * SFA 31/08/16 - Cambio procedimiento COWGRAI_deleteImpuestos  *
      *                por COWGRAI_deleteImpuesto                    *
      * SGF 26/01/17 - Agrego parámetro opcional en _saveCategorias. *
      * JSN 08/03/17 - Se agrego validación de rango de fecha en el  *
      *                procedimiento COWAPE_chkCotizar               *
      *     10/03/17 - se corrige como aplica el coeficiente en el   *
      *                procedimiento de COWAPE_RecuperaTasaSumAseg   *
      * JSN 21/03/17 - Se Agregaron los procedimientos               *
      *                COWAPE_cotizarWeb2                            *
      *                COWAPE_reCotizarWeb2                          *
      * LRG 22/03/17 - Se agrego procedimiento para obtener Prima    *
      *                minima _setPrimaMinima                        *
      *                Nuevos procedimientos asociados:              *
      *                _setPormilajePrima                            *
      *                _getPrimaActividad                            *
      *                _GetSumaAsegActividad                         *
      *                _getCantidadTotalDePersonas                   *
      * JSN 17/11/17 - En el procedimiento COWAPE_chkCotizar2 se     *
      *                agrego la validación de código postal         *
      *                SVPVAL_codigoPostal                           *
      * NWN 27/11/18 - En el procedimiento COWAPE_saveCoberturasAp   *
      *                se deja solamente que el pormilaje de prima   *
      *                no se multiplique por el porcentaje de        *
      *                tabla de periodo corto.(SET111).              *
      *                A su vez en el procedimiento -                *
      *                COWAPE_RecuperaTasaSumAseg   se modifica que  *
      *                la tasa de prima (peXpri) se multiplique por  *
      *                el coeficiente de la Actividad (SET027).      *
      * JSN 26/04/21 - Se agrega los procedimiento _planesCerrados   *
      *                                            _cargaActividad   *
      * ************************************************************ *
     Fctw000    if   e           k disk    usropn
     Fctwev1    uf a e           k disk    usropn
     Fctwev101  uf a e           k disk    usropn rename (c1wev1 : c1wev101)
     Fctwev2    uf a e           k disk    usropn
     Fctwev201  uf a e           k disk    usropn rename (c1wev2 : c1wev201)
     Fctwevc    uf a e           k disk    usropn
     Ftab009    if   e           k disk    usropn
     Fset1031   if   e           k disk    usropn
     Fset250    if   e           k disk    usropn
     Fset160    if   e           k disk    usropn
     Fsettar    if   e           k disk    usropn
     Fset204    if   e           k disk    usropn
     Fset227    if   e           k disk    usropn
     Fset625    if   e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fset015    if   e           k disk    usropn  prefix (s015_)
     Fset01601  if   e           k disk    usropn  prefix (s016_)
     Fset027    if   e           k disk    usropn
     Fset068    if   e           k disk    usropn
     Fset103    if   e           k disk    usropn
     Fset111    if   e           k disk    usropn
     Fset220    if   e           k disk    usropn
     Fset225    if   e           k disk    usropn  prefix (s225_)
     Fset215    if   e           k disk    usropn
     Fset621    if   e           k disk    usropn
     Fset2221   if   e           k disk    usropn
     Fset225303 if   e           k disk    usropn
     Fset22531  if   e           k disk    usropn
     Fset22223  if   e           k disk    usropn
     Fsetbre    if   e           k disk    usropn
     Fpahed003  if   e           k disk    usropn
     Fpahet0    if   e           k disk    usropn
     Fctw001    uf   e           k disk    usropn
     Fctw001c   uf   e           k disk    usropn
     Fset100    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowape_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D cleanUp         pr             1N
     D  peMsid                        7a   const

     D par314c1        pr                  extpgm('PAR314C1')
     D                                2  0 const
     D                                3  0 const
     D                                3a   const
     D                                3  0 const
     D                                2a   const
     D                               15  2 const
     D                                9  6
     D                               15  2
     D                                2a
     D                                3a   dim(200)
     D                               15  2 options(*omit:*nopass)

     D PRO401U3        pr                  extpgm('PRO401U3')
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2

     D PRO401U1        pr                  extpgm('PRO401U1')
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     Is1t160
     I              t@date                      z@date
     Is1ttar
     I              t@date                      w@date
     Is1t027
     I              t@date                      x@date

      *--- Definicion de Procedimiento --------------------------------- *
      * ---------------------------------------------------------------- *
      * COWAPE_cotizarWeb():  Recibe todos los datos para la póliza de AP*
      *                       Retorna la prima y el premio.              *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                peActi  -  Actividad                              *
      *                peSecu  -  Secuencia                              *
      *                peCant  -  Cantidad                               *
      *                peTipe  -  Tipo de persona                        *
      *                peCiva  -  Codigo de Iva                          *
      *                peNrpp  -  Plan de Pago                           *
      *                peVdes  -  Fecha desde                            *
      *                peVhas  -  Fecha hasta                            *
      *                peXpro  -  Codigo de plan                         *
      *                peRaed  -  Rango de Edad                          *
      *                peCobe  -  Coberturas                             *
      *                peImpu  -  Impuestos                              *
      *        Output:                                                   *
      *                pePrim  -  Prima                                  *
      *                pePrem  -  Premio                                 *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWAPE_cotizarWeb...
     P                 B                   export
     D COWAPE_cotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0
     D p@Poco          s              6  0
     D @@Cfpg          s              1  0
     D @@Impu          ds                  likeds( Impuesto )
     D @@Poco          s              6  0

      /free

       COWAPE_inz();

       peErro = *Zeros;

       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ):'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase :
                                                               peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrpp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       COWAPE_chkCotizar ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : peActi
                         : peSecu
                         : peCant
                         : peTipe
                         : peCiva
                         : @@Cfpg
                         : peVdes
                         : peVhas
                         : peXpro
                         : peCopo
                         : peCops
                         : peRaed
                         : peCobe
                         : peErro
                         : peMsgs );

       if peErro <> *Zeros;
         return;
       endif;

       //Elimino info de la cotización.
       COWGRAI_deleteSecuAct ( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              peActi :
                              peSecu );

       COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );


       COWAPE_cotizador  ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePaco
                         : peActi
                         : peSecu
                         : peCant
                         : peTipe
                         : peCiva
                         : peNrpp
                         : @@Cfpg
                         : peVdes
                         : peVhas
                         : peXpro
                         : peCopo
                         : peCops
                         : peRaed
                         : peCobe
                         : pePrim
                         : pePrem
                         : peErro
                         : peMsgs );

       //busco el ultimo componente que tengo

       @@Poco = COWAPE_GetSecuenciaPoco ( peBase :
                                          peNctw :
                                          peRama :
                                          peArse );
       // Devuelve Impuestos Por Coberturas
       clear @@Impu;
       COWGRAI_getImpuestos( peBase
                           : peNctw
                           : peRama
                           : COWGRAI_getPrimaRamaArse ( peBase :
                                                        peNctw :
                                                        peRama )
                           : COWAPE_GetSumaAsegCobertura( peBase
                                                        : peNctw
                                                        : peRama
                                                        : peArse
                                                        : @@Poco )
                           : peCopo
                           : peCops
                           : @@Impu );

       peImpu(1) = @@Impu;
       peImpu(1).cobl = *all'X';

       return;

      /end-free

     P COWAPE_cotizarWeb...
     P                 E
      * ---------------------------------------------------------------- *
      * COWAPE_reCotizarWeb():  Recibe todos los datos para la póliza de AP*
      *                       Retorna la prima y el premio.              *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                peActi  -  Actividad                              *
      *                peSecu  -  Secuencia                              *
      *                peCant  -  Cantidad                               *
      *                peTipe  -  Tipo de persona                        *
      *                peCiva  -  Codigo de Iva                          *
      *                peNrpp  -  Plan de Pago                           *
      *                peVdes  -  Fecha desde                            *
      *                peVhas  -  Fecha hasta                            *
      *                peXpro  -  Codigo de plan                         *
      *                peRaed  -  Rango de Edad                          *
      *                peCobe  -  Coberturas                             *
      *                peImpu  -  Impuestos                              *
      *        Output:                                                   *
      *                pePrim  -  Prima                                  *
      *                pePrem  -  Premio                                 *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWAPE_reCotizarWeb...
     P                 B                   export
     D COWAPE_reCotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0
     D p@Poco          s              6  0
     D @@Impu          ds                   likeds(Impuesto)
     D @@Poco          s              6  0

     D @@Cfpg          s              1  0

      /free

       COWAPE_inz();

       peErro = *Zeros;

       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ):'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase :
                                                               peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrpp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       COWAPE_chkCotizar ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : peActi
                         : peSecu
                         : peCant
                         : peTipe
                         : peCiva
                         : @@Cfpg
                         : peVdes
                         : peVhas
                         : peXpro
                         : peCopo
                         : peCops
                         : peRaed
                         : peCobe
                         : peErro
                         : peMsgs );

       if peErro <> *Zeros;
         return;
       endif;

       //Elimino info de la cotización.
       COWGRAI_deleteSecuAct ( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              peActi :
                              peSecu );

       COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );

       COWAPE_cotizador  ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : pePaco
                         : peActi
                         : peSecu
                         : peCant
                         : peTipe
                         : peCiva
                         : peNrpp
                         : @@Cfpg
                         : peVdes
                         : peVhas
                         : peXpro
                         : peCopo
                         : peCops
                         : peRaed
                         : peCobe
                         : pePrim
                         : pePrem
                         : peErro
                         : peMsgs );

       //busco el ultimo componente que tengo

       @@Poco = COWAPE_GetSecuenciaPoco ( peBase :
                                          peNctw :
                                          peRama :
                                          peArse );
       // Devuelve Impuestos Por Coberturas
       clear @@Impu;
       COWGRAI_getImpuestos( peBase
                           : peNctw
                           : peRama
                           : COWGRAI_getPrimaRamaArse ( peBase :
                                                        peNctw :
                                                        peRama )
                           : COWAPE_GetSumaAsegCobertura( peBase
                                                        : peNctw
                                                        : peRama
                                                        : peArse
                                                        : @@Poco )
                           : peCopo
                           : peCops
                           : @@Impu );

       peImpu(1) = @@Impu;
       peImpu(1).cobl = *all'X';

       return;

      /end-free

     P COWAPE_reCotizarWeb...
     P                 E
      *--- Definicion de Procedimiento --------------------------------- *
      * ---------------------------------------------------------------- *
      * COWAPE_cotizador ():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                peActi  -  Actividad                              *
      *                peSecu  -  Secuencia                              *
      *                peCant  -  Cantidad                               *
      *                peTipe  -  Tipo de persona                        *
      *                peCiva  -  Codigo de Iva                          *
      *                peNrpp  -  Plan de Pago                           *
      *                peCfpg  -  Forma de Pago                          *
      *                peVdes  -  Fecha desde                            *
      *                peVhas  -  Fecha hasta                            *
      *                peXpro  -  Codigo de plan                         *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peRaed  -  Rango de Edad                          *
      *                peCobe  -  Coberturas                             *
      *        Output:                                                   *
      *                pePrim  -  Prima                                  *
      *                pePrem  -  Premio                                 *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWAPE_cotizador...
     P                 B                   export
     D COWAPE_cotizador...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D k1wev1          ds                  likerec(c1wev1:*key)
     D k1wev2          ds                  likerec(c1wev2:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0
     D p@Scta          s              1  0
     D x               s             10i 0
     D y               s             10i 0
     D p@Poco          s              6  0
     D @@Poco          s              6  0

     D i               s             10i 0
     D s               s              6a
     D idx             s              6a   dim(10)
     D @cobe           ds                  qualified dim(10)
     D  ptco                         15  2
     D  xpri                          9  6

     D   @@Impu        ds                  likeds(Impuesto)
     D   @@xpri        s              9  6
     D   @@prim        s             15  2
     D   p@Seri        s             15  2
     D   p@Seem        s             15  2
     D   p@Impi        s             15  2
     D   p@Sers        s             15  2
     D   p@Tssn        s             15  2
     D   p@Ipr1        s             15  2
     D   p@Ipr4        s             15  2
     D   p@Ipr3        s             15  2
     D   p@Ipr6        s             15  2
     D   p@Ipr7        s             15  2
     D   p@Ipr8        s             15  2
     D   p@Ipr9        s             15  2
      /free

       COWAPE_inz();

       peErro = *Zeros;

       //Actualizo Informacion del CTW000

       COWGRAI_updCotizacion( peBase
                            : peNctw
                            : peCiva
                            : peTipe
                            : peCopo
                            : peCops
                            : peCfpg
                            : peNrpp
                            : peVdes
                            : peVhas );



       //busco el ultimo componente que tengo

       @@Poco = COWAPE_GetSecuenciaPoco ( peBase :
                                          peNctw :
                                          peRama :
                                          peArse );


       //Grabo Archivos
       p@Poco = @@poco;

       for y = 1 to peCant;

         p@Poco += 1;

         COWAPE_saveCabecera ( peBase :
                               peNctw :
                               peRama :
                               peArse :
                               p@Poco :
                               pePaco :
                               peActi :
                               peSecu :
                               peCopo :
                               peCops :
                               peXpro );

       endfor;

       p@Poco = @@poco;

       for y = 1 to peCant;

         p@Poco += 1;

         for x = 1 to 20;

           if peCobe(x).xcob <> 0;

             //Graba Coberturas Riesgos Varios - CTWEV2

             COWAPE_saveCoberturasAp( peBase
                                    : peNctw
                                    : peRama
                                    : pexPro
                                    : peArse
                                    : p@Poco
                                    : peSecu
                                    : pePaco
                                    : peActi
                                    : peCobe(x).riec
                                    : peCobe(x).xcob
                                    : peCobe(x).sac1
                                    : peRaed
                                    : peVdes
                                    : peVhas);
           endif;

         endfor;

       endfor;

       // ----------------------------------------
       // Buscar pormilaje y prima
       // ----------------------------------------
        COWAPE_setPormilajePrima( peBase
                                : peNctw
                                : peActi
                                : peSecu
                                : peCobe );

       // Graba Impuestos - CTW001
       COWGRAI_SaveImpuestos( peBase
                            : peNctw
                            : peRama
                            : peArse );

       // Graba Archivo de Categorias
       COWAPE_saveCategorias( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              peSecu :
                              peActi :
                              peCant :
                              peCopo :
                              peCops :
                              peRaed );

        // Premio final
        COWGRAI_getPremioFinal ( peBase : peNctw );

        pePrim = COWAPE_getPrimaActividad( peBase
                                         : peNctw
                                         : peRama
                                         : peArse
                                         : peActi
                                         : peSecu);

        pePrem = COWAPE_GetSumaAsegActividad( peBase
                                            : peNctw
                                            : peRama
                                            : peArse
                                            : peActi
                                            : peSecu);

       Return;

      /end-free

     P COWAPE_cotizador...
     P                 E
      * ---------------------------------------------------------------- *
      * COWAPE_chkCotizar():  Valida Cotizacion                          *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                peVhan  -  Año del Vehículo                       *
      *                peVhmc  -  Marca del Vehículo                     *
      *                peVhmo  -  Modelo del Vehículo                    *
      *                peVhcs  -  SubModelo del Vehículo                 *
      *                peVhvu  -  Suma Asegurada                         *
      *                peMgnc  -  Marca de GNC(S o N)                    *
      *                peRgnc  -  Valor del GNC                          *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peScta  -  Zona de Riesgo                         *
      *                peClin  -  Cliente Integral                       *
      *                peBure  -  Código de Buen Resultado               *
      *                peCfpg  -  Código Forma de Pago                   *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de IVA                          *
      *                peCtre  -  Tarifa                                 *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWAPE_chkCotizar...
     P                 B                   export
     D COWAPE_chkCotizar...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peCfpg                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)

     D p@Tiou          s              1  0
     D p@Stou          s              2  0
     D p@Stos          s              2  0
     D x               s             10i 0
     D y               s             10i 0
     D p@Poco          s              6  0
     D @@Lcob          s              3  0 dim(20)
     D @@LcobC         s             10i 0
     D p@Lcob          s              3  0 dim(20)
     D p@LcobC         s             10i 0
     D @@fch1          s               d   datfmt(*iso) inz
     D @@fch2          s              8  0

      /free

       COWAPE_inz();

       peErro = *Zeros;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return;

       endif;

       //Valido Cotización
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %editc(peNctw:'X');
           %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama que pueda emitir en web
       if SVPVAL_ramaWeb ( peRama ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_RAMNW = ErrCode;

           %subst(wrepl:1:2) = %editc(peRama:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama de Vida
       if SVPWS_getGrupoRama ( peRama ) <> 'V';

         %subst(wrepl:1:2) = %editc ( peRama : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0067'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;

       endif;

       //Valido Forma de Pago
       if SVPVAL_formaDePagoWeb ( peCfpg ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_FDPNW = ErrCode;

           %subst(wrepl:1:1) =  %editc ( peCfpg : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0026'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Persona
       if SVPVAL_tipoPersona ( peTipe ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_TPENV = ErrCode;

           %subst(wrepl:1:1) =  peTipe;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0015'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Persona
       if SVPVAL_ivaWeb ( peCiva ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_IVANE = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_IVANW = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         endif;

         peErro = -1;
         return;
       endif;

       //Valido Fecha de Inicio
       test(DE) *iso peVdes;
       if %error;

         %subst(wrepl:1:8) = %editc(peVdes :'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0010'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Valido Fecha Hasta
       test(DE) *iso peVhas;
       if %error;

         %subst(wrepl:1:8) = %editc(peVhas : 'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0010'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Valido que la fecha hasta no sea mayor a la fecha desde
       if peVhas < peVdes;

         peErro = -1;
         return;

       endif;

       //Valido que la diferencia entre fecha desde y hasta no sea mayor
       //a un año

       Monitor;

         @@Fch1 = %date( %char ( peVdes ) : *iso0);
         @@Fch1 += %years(1);
         @@Fch2 = %int( %char( @@Fch1 : *iso0) );

       on-error;
         cleanUp( 'RNX0112' );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;
       endmon;

       if pevhas > @@Fch2;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0046'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Coberturas(Prima)...
       for x = 1 to 20;
        if peCobe(x).xcob <> 0;
         if not SVPVAL_chkCobPrima( peRama
                                  : peXpro
                                  : peCobe(x).riec
                                  : peCobe(x).xcob
                                  : COWGRAI_monedaCotizacion( peBase
                                                            : peNctw));

           %subst(wrepl:1:3) =  peCobe(x).riec;
           %subst(wrepl:3:5) =  %editc( peCobe(x).xcob : 'X' );
           %subst(wrepl:6:7) =  %editc( peRama : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0036'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
         endif;
        endif;
       endfor;

       // Valida la suma asegurada ingresada por cobertura
       for x = 1 to 20;
        if peCobe(x).xcob <> 0;
         if not SVPVAL_CHKCobSumMaxMin( peRama
                                      : peXpro
                                      : peCobe(x).riec
                                      : peCobe(x).xcob
                                      : COWGRAI_monedaCotizacion( peBase
                                                                : peNctw)
                                      : peCobe(x).sac1
                                      : peCobe );

           %subst(wrepl:1:40) =  %trim( SVPDES_cobLargo ( peRama :
                                                          peCobe(x).xcob));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0021'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;
         endif;
        endif;
       endfor;

       // Valida coberturas excluyentes entre si
       clear p@Lcob;

       for y = 1 to 20;

        if peCobe(y).xcob <> 0;

          p@Lcob(y) = peCobe(y).xcob;
          p@LcobC += 1;

        endif;

       endfor;


       if not SVPCOB_ValCoberturasBasicas( peRama
                                         : peXpro
                                         : peCobe(1).riec
                                         : COWGRAI_monedaCotizacion( peBase
                                                                   : peNctw)
                                         : p@Lcob  );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0123'
                      : peMsgs     );
         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;


       if not SVPCOB_ValListCobExcluyentes ( peRama :
                                             peXpro :
                                             peCobe(1).riec :
                                             COWGRAI_monedaCotizacion( peBase
                                                                     : peNctw):
                                             p@Lcob  :
                                             p@LcobC );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0121'
                      : peMsgs     );

         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;


       if not SVPCOB_ValListCobReglas ( peRama :
                                        peXpro :
                                        peCobe(1).riec :
                                        COWGRAI_monedaCotizacion( peBase
                                                                : peNctw):
                                        p@Lcob  :
                                        p@LcobC );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0122'
                      : peMsgs     );

         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;

       return;

      /end-free

     P COWAPE_chkCotizar...
     P                 E
      * ---------------------------------------------------------------- *
      * COWAPE_saveCabecera   (): Graba cabecera de la cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                pePaco  -  Código de Parentesco                   *
      *                peActi  -  Actividad                              *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  Sufijo                                 *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWAPE_saveCabecera...
     P                 B
     D COWAPE_saveCabecera...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peXpro                       3  0 const

     D p@Impu          ds                  likeds(Impuesto)
     D x               s             10i 0

      /free

       COWAPE_inz();

       clear c1wev1;

       v1empr = PeBase.peEmpr;
       v1sucu = PeBase.peSucu;
       v1nivt = PeBase.peNivt;
       v1nivc = PeBase.peNivc;
       v1nctw = peNctw;
       v1rama = peRama;
       v1arse = peArse;
       v1poco = pePoco;
       v1paco = pePaco;
       v1acti = peActi;
       v1secu = peSecu;
       v1cate = COWGRAI_getCategoria( peActi );
       v1mar1 = '0';
       v1mar2 = '0';
       v1mar3 = '0';
       v1mar4 = '0';
       v1mar5 = '0';
       v1Xpro = peXpro;
       v1user = @PsDs.CurUsr;
       v1time = %dec(%time);
       v1date = udate;

       write c1wev1;

       return *on;

      /end-free

     P COWAPE_saveCabecera...
     P                 E

      * ---------------------------------------------------------------- *
      * COWAPE_saveCategorias (): Graba cabecera de la cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                peSecu  -  Secuencia                              *
      *                peActi  -  Actividad                              *
      *                peCant  -  Categoria                              *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  Sufijo                                 *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWAPE_saveCategorias...
     P                 B
     D COWAPE_saveCategorias...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peActi                       5  0 const
     D   peCant                       2  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const options(*nopass:*omit)

     D p@Impu          ds                  likeds(Impuesto)
     D p@Poco          s              6  0
     D k1yev1          ds                  likerec(c1wev101:*key)
     D pritot          s             15  2
     D sumtot          s             15  2
     D actualiza       s               n
     D @raed           s              2  0
     D @@form          s              1    inz('A')
     D @@Subt          s             15  2

     D k1yevc          ds                  likerec(c1wevc:*key)

      /free

       COWAPE_inz();

       if %parms >= 10 and %addr(peRaed) <> *null;
          @raed = peRaed;
       endif;

       COWAPE_GetSumayPrima ( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              peSecu :
                              peActi :
                              sumtot :
                              pritot );


       k1yevc.v0empr = PeBase.peEmpr;
       k1yevc.v0sucu = PeBase.peSucu;
       k1yevc.v0nivt = PeBase.peNivt;
       k1yevc.v0nivc = PeBase.peNivc;
       k1yevc.v0nctw = peNctw;
       k1yevc.v0Rama = peRama;
       k1yevc.v0Arse = peArse;
       k1yevc.v0secu = peSecu;
       k1yevc.v0acti = peActi;

       chain %kds ( k1yevc : 9 ) ctwevc;
       if %found;
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       v0empr = PeBase.peEmpr;
       v0sucu = PeBase.peSucu;
       v0nivt = PeBase.peNivt;
       v0nivc = PeBase.peNivc;
       v0nctw = peNctw;
       v0rama = peRama;
       v0arse = peArse;
       v0acti = peActi;
       v0secu = peSecu;
       v0cate = COWGRAI_getCategoria( peActi );
       v0cant = peCant;

       COWGRAI_setDerechoEmi( peBase
                            : peNctw
                            : peRama
                            : pritot );

       Clear p@Impu;
       COWGRAI_getImpuestos( peBase
                           : peNctw
                           : peRama
                           : pritot
                           : sumtot
                           : peCopo
                           : peCops
                           : p@Impu );

       @@Subt = COWGRAI_GetPrimaSubtot( peBase
                                      : peNctw
                                      : peRama
                                      : priTot
                                      : @@form );

        eval(h) v0prem = @@Subt
                       + p@Impu.seri
                       + p@Impu.seem
                       + p@Impu.impi
                       + p@Impu.sers
                       + p@Impu.tssn
                       + p@Impu.ipr1
                       + p@Impu.ipr4
                       + p@Impu.ipr3
                       + p@Impu.ipr6;

       v0prim = pritot;
       v0suas = sumtot;
       v0seri = p@impu.seri;
       v0seem = p@impu.seem;
       v0impi = p@impu.impi;
       v0sers = p@impu.sers;
       v0tssn = p@impu.tssn;
       v0ipr1 = p@impu.ipr1;
       v0ipr4 = p@impu.ipr4;
       v0ipr3 = p@impu.ipr3;
       v0ipr6 = p@impu.ipr6;
       v0ipr7 = p@impu.ipr7;
       v0ipr8 = p@impu.ipr8;

       v0mar1 = '0';
       v0mar2 = '0';
       v0mar3 = '0';
       v0mar4 = '0';
       v0mar5 = '0';
       v0user = @PsDs.CurUsr;
       v0time = %dec(%time);
       v0date = udate;
       v0raed = @raed;

       if actualiza;
         update c1wevc;
       else;
         write c1wevc;
       endif;

       return *on;

      /end-free

     P COWAPE_saveCategorias...
     P                 E

      * ------------------------------------------------------------ *
      * COWAPE_saveCoberturasAp(): Graba Coberturas                  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peSecu   (input)   Secuencia                             *
      *     pePaco   (input)   Parentesco                            *
      *     peActi   (input)   Actividad                             *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_saveCoberturasAp...
     P                 B                   export
     D COWAPE_saveCoberturasAp...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peSecu                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peSaco                      13  2 const
     D   peRaed                       2  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const

     D  @@Xpri         s              9  6 inz
     D  @@Ptco         s             15  2 inz
     D  @@Cls          s              3a   dim(5) inz
     D  @@Tpcd         s              2a          inz
     D  @@porc         s              7  4
     D  p@Dias         s              5  0

     D   k1yev2        ds                  likerec( c1wev2 : *key )
      /free

       COWAPE_inz();

       k1yev2.v2empr = peBase.peEmpr;
       k1yev2.v2sucu = peBase.peSucu;
       k1yev2.v2nivt = peBase.peNivt;
       k1yev2.v2nivc = peBase.peNivc;
       k1yev2.v2nctw = peNctw;
       k1yev2.v2rama = peRama;
       k1yev2.v2arse = peArse;
       k1yev2.v2poco = pePoco;
       k1yev2.v2paco = pePaco;
       k1yev2.v2riec = peRiec;
       k1yev2.v2xcob = peCobe;
       chain %kds( k1yev2 : 11 ) ctwev2;
       if %found( ctwev2 );
        return;
       endif;

       v2empr = peBase.peEmpr;
       v2sucu = peBase.peSucu;
       v2nivt = peBase.peNivt;
       v2nivc = peBase.peNivc;
       v2nctw = peNctw;
       v2rama = peRama;
       v2arse = peArse;
       v2poco = pePoco;
       v2paco = pePaco;
       v2riec = peRiec;
       v2xcob = peCobe;
       v2Saco = peSaco;
       v2Secu = peSecu;

       COWAPE_RecuperaTasaSumAseg( peRama
                                 : peXpro
                                 : peRiec
                                 : peCobe
                                 : COWGRAI_monedaCotizacion( peBase
                                                           : peNctw )
                                 : peActi
                                 : peSaco
                                 : peRaed
                                 : @@Xpri
                                 : @@Ptco
                                 : @@Tpcd
                                 : @@Cls  );

       v2ptco = @@Ptco;

       // busco el porcentaje por la cantidad de dias de vigencia que tiene
       // la cotización.

       p@dias = %Diff(%date(peVhas) : %date(peVdes) : *days);
       @@porc = COWAPE_getporcperiodo( peRama :
                                       peXpro :
                                       COWGRAI_monedaCotizacion( peBase
                                                              : peNctw ) :
                                       p@Dias );
       eval(h) v2ptco = v2ptco * @@porc/100;
       //v2xpri = @@Xpri * @@porc/100;
       // Arreglo Pormilaje de Prima por cobertura...
       // Esta debe ser la que viene desde la tabla de mortalidad mas
       // el coeficiente que esta en la tabla SET027.
       v2xpri = @@Xpri;

       v2prsa = *zeros;
       v2ecob = '0';
       v2mar1 = '0';
       v2mar2 = '0';
       v2mar3 = '0';
       v2mar4 = '0';
       v2mar5 = '0';
       v2user = @PsDs.CurUsr;
       v2time = %dec(%time);
       v2date = udate;

       write c1wev2;

       return;

      /end-free

     P COWAPE_saveCoberturasAp...
     P                 E

      * ------------------------------------------------------------ *
      * COWAPE_RecuperaTasaSumAseg...                                *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura                             *
      *     peMone   (input)   Moneda                                *
      *     peActi   (input)   Actividad                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Prima por milaje                      *
      *     pePtco   (output)  Prima                                 *
      *     peTpcd   (output)  Codigo de Texto Preseteado            *
      *     peCls    (output)  Clausula                              *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWAPE_RecuperaTasaSumAseg...
     P                 B                   export
     D COWAPE_RecuperaTasaSumAseg...
     D                 pi
     D   peRama                       3  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3a   const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peActi                       5  0 const
     D   peSaco                      15  2 const
     D   peRaed                       2  0 const
     D   peXpri                       9  6
     D   pePtco                      15  2
     D   peTpcd                       2a
     D   peCls                        3a   dim(5)

     D   k1y103        ds                  likerec( s1t103 : *key )
     D   k1y068        ds                  likerec( s1t068 : *key )
     D   prima         s             15  2
     D   coefCt        s              5  2
     D   p@cate        s              2  0
     D   porcen        s              9  6

       /free

       COWAPE_inz();

       k1y103.t@rama = peRama;
       k1y103.t@xpro = peXpro;
       k1y103.t@riec = peRiec;
       k1y103.t@cobc = peCobc;
       k1y103.t@mone = peMone;

       clear prima;

       chain %kds ( k1y103 : 5 ) set103;
       if %found();

         if t@xpri <> 0;

           eval(h) prima = peSaco * t@xpri / 1000;
           porcen = t@xpri;

         elseif t@ptco <> 0;

           prima = t@ptco;

         elseif t@tamu <> 0;

           k1y068.t@tamu = t@tamu;

           //rangos de edades

           if peRaed = 1;
             k1y068.t@edad = 7;
           elseif peRaed = 2;
             k1y068.t@edad = 35;
           elseif peRaed = 3;
             k1y068.t@edad = 75;
           endif;

           chain %kds ( k1y068 : 2 ) set068;
           if %found();

             eval(h) prima = peSaco * t@xpr0/1000;
             porcen = t@xpr0;

           endif;

         endif;

         peXpri = porcen;
         pePtco = prima;

         //Si tiene S en tabla de categoría busco el coeficiente
         if t@mar1 = 'S';

           p@cate = COWGRAI_getCategoria ( peActi );
           CoefCt = COWAPE_getporcencat( p@cate : %dec(%date) );

           if CoefCt <> *zeros;
             prima  = prima  * CoefCt;
             peXpri = peXpri * CoefCt;
           else;
             prima  = prima  * 1;
             peXpri = peXpri * 1;
           endif;

           pePtco = prima;

         endif;

         peTpcd = t@tpcd;

       endif;

       return;

       /end-free
     P COWAPE_RecuperaTasaSumAseg...
     P                 E

      * ------------------------------------------------------------ *
      * COWAPE_GetPormilajePrima(): Graba Coberturas Riesgos Varios  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Pormilaje                             *
      *     pePrim   (output)  Prima                                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWAPE_GetPormilajePrima...
     P                 B                   export
     D COWAPE_GetPormilajePrima...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peXpri                       9  6
     D   pePrim                      15  2

     D   k1yev2        ds                  likerec( c1wev2 : *key )
      /free

       COWAPE_inz();

       k1yev2.v2empr = peBase.peEmpr;
       k1yev2.v2sucu = peBase.peSucu;
       k1yev2.v2nivt = peBase.peNivt;
       k1yev2.v2nivc = peBase.peNivc;
       k1yev2.v2nctw = peNctw;
       k1yev2.v2rama = peRama;
       k1yev2.v2arse = peArse;
       k1yev2.v2poco = pePoco;
       k1yev2.v2paco = pePaco;
       k1yev2.v2riec = peRiec;
       k1yev2.v2xcob = peCobe;

       chain(N) %kds( k1yev2 : 11 ) ctwev2;
       if %found ( ctwev2 );
        peXpri = v2xpri;
        pePrim = v2ptco;
       endif;

       return;

      /end-free
     P COWAPE_GetPormilajePrima...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_GetSumayPrima()                                      *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PeSecu   (input)  Secuencia                              *
      *     PeActi   (input)  Actividad                              *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_GetSumayPrima...
     P                 B                   export
     D COWAPE_GetSumayPrima...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peActi                       5  0 const
     D   peSuma                      15  2
     D   pePrim                      15  2

     D   @@Suas        s             15  2 inz

     D k1yev1          ds                  likerec(c1wev101:*key)

      /free

       COWAPE_inz();

       k1yev1.v1empr = PeBase.peEmpr;
       k1yev1.v1sucu = PeBase.peSucu;
       k1yev1.v1nivt = PeBase.peNivt;
       k1yev1.v1nivc = PeBase.peNivc;
       k1yev1.v1nctw = peNctw;
       k1yev1.v1Rama = peRama;
       k1yev1.v1Arse = peArse;
       k1yev1.v1secu = peSecu;
       k1yev1.v1acti = peActi;

       setll %kds ( k1yev1 : 9 ) ctwev101;
       reade %kds ( k1yev1 : 9 ) ctwev101;
       dow not %eof;

         peSuma += COWAPE_GetSumaAsegCobertura( peBase
                                              : peNctw
                                              : peRama
                                              : peArse
                                              : v1Poco );

         pePrim += COWAPE_GetPrima( peBase
                                   : peNctw
                                   : peRama
                                   : peArse
                                   : v1Poco );

         reade %kds ( k1yev1 : 9 ) ctwev101;
       enddo;

       return;


      /end-free

     P COWAPE_GetSumayPrima...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_GetSumaAsegCobertura...                               *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_GetSumaAsegCobertura...
     P                 B                   export
     D COWAPE_GetSumaAsegCobertura...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const

     D   @@Suas        s             15  2 inz

     D   k1yev2        ds                  likerec( c1wev2 : *key )

      /free

       COWAPE_inz();

       k1yev2.v2empr = peBase.peEmpr;
       k1yev2.v2sucu = peBase.peSucu;
       k1yev2.v2nivt = peBase.peNivt;
       k1yev2.v2nivc = peBase.peNivc;
       k1yev2.v2nctw = peNctw;
       k1yev2.v2rama = peRama;
       k1yev2.v2arse = peArse;
       k1yev2.v2poco = pePoco;

       setll %kds( k1yev2 : 8 ) ctwev2;
       reade %kds( k1yev2 : 8 ) ctwev2;
       dow not %eof( ctwev2 );

         @@Suas += v2saco;

        reade %kds( k1yev2 : 8 ) ctwev2;
       enddo;

       return @@suas;

      /end-free
     P COWAPE_GetSumaAsegCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_GetSecuenciaPoco()                                    *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_GetSecuenciaPoco...
     P                 B                   export
     D COWAPE_GetSecuenciaPoco...
     D                 pi             6  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1yev1          ds                  likerec(c1wev101:*key)

      /free

       COWAPE_inz();

       k1yev1.v1empr = PeBase.peEmpr;
       k1yev1.v1sucu = PeBase.peSucu;
       k1yev1.v1nivt = PeBase.peNivt;
       k1yev1.v1nivc = PeBase.peNivc;
       k1yev1.v1nctw = peNctw;
       k1yev1.v1Rama = peRama;
       k1yev1.v1Arse = peArse;

       setgt %kds ( k1yev1 : 7 ) ctwev1;
       readpe %kds ( k1yev1 : 7 ) ctwev1;
       if not %eof();

         return v1Poco;

       endif;

       return *zeros;


      /end-free

     P COWAPE_GetSecuenciaPoco...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_GetPrima()...                                         *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_GetPrima...
     P                 B                   export
     D COWAPE_GetPrima...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const

     D   @@ptco        s             15  2 inz

     D   k1yev2        ds                  likerec( c1wev2 : *key )

      /free

       COWAPE_inz();

       k1yev2.v2empr = peBase.peEmpr;
       k1yev2.v2sucu = peBase.peSucu;
       k1yev2.v2nivt = peBase.peNivt;
       k1yev2.v2nivc = peBase.peNivc;
       k1yev2.v2nctw = peNctw;
       k1yev2.v2rama = peRama;
       k1yev2.v2arse = peArse;
       k1yev2.v2poco = pePoco;

       setll %kds( k1yev2 : 8 ) ctwev2;
       reade %kds( k1yev2 : 8 ) ctwev2;
       dow not %eof( ctwev2 );

         @@ptco += v2ptco;

        reade %kds( k1yev2 : 8 ) ctwev2;
       enddo;

       return @@ptco;

      /end-free
     P COWAPE_GetPrima...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_GetPremio()                                           *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_GetPremio...
     P                 B                   export
     D COWAPE_GetPremio...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

     D   @@ptco        s             15  2 inz

     D   k1yevc        ds                  likerec( c1wevc : *key )

      /free

       COWAPE_inz();

       k1yevc.v0empr = peBase.peEmpr;
       k1yevc.v0sucu = peBase.peSucu;
       k1yevc.v0nivt = peBase.peNivt;
       k1yevc.v0nivc = peBase.peNivc;
       k1yevc.v0nctw = peNctw;
       k1yevc.v0rama = peRama;

       setll %kds( k1yevc : 5 ) ctwevc;
       reade %kds( k1yevc : 5 ) ctwevc;
       dow not %eof( ctwevc );

         @@ptco += v0prem;

        reade %kds( k1yevc : 5 ) ctwevc;
       enddo;

       return @@ptco;

      /end-free
     P COWAPE_GetPremio...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_getporcperiodo()                                      *
      *                                                              *
      *     PeRama   (input)  Parametros Base                        *
      *     PeXpro   (input)  Nro de Cotizacion                      *
      *     PeMone   (input)  Moneda                                 *
      *     PeDias   (input)  Cantidad de Días                       *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_getporcperiodo...
     P                 B                   export
     D COWAPE_getporcperiodo...
     D                 pi             7  4
     D   PeRama                       2  0 const
     D   PeXpro                       3  0 const
     D   PeMone                       2    const
     D   PeDias                       5  0 const

     D   @@ptco        s             15  2 inz

     D   k1y111        ds                  likerec( s1t111 : *key )

      /free

       COWAPE_inz();

       k1y111.t@rama = PeRama;
       k1y111.t@xpro = PeXpro;
       k1y111.t@mone = PeMone;
       k1y111.t@xdia = PeDias;

       chain %kds( k1y111 : 4 ) set111;
       if %found();

         return t@ippe;

       endif;

       return 100;

      /end-free

     P COWAPE_getporcperiodo...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_getporcencat():                                       *
      *                                                              *
      *     PeCate   (input)  Categoria                              *
      *     peFech   (input)  Fecha                                  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_getporcencat...
     P                 B                   export
     D COWAPE_getporcencat...
     D                 pi             5  2
     D   PeCate                       2  0 const
     D   peFech                       8  0 const

     D   @@ptco        s             15  2 inz

     D   k1y027        ds                  likerec( s1t027 : *key )

      /free

       COWAPE_inz();

       k1y027.t@cate = PeCate;
       k1y027.t@fini = PeFech;

       setgt %kds( k1y027 : 2 ) set027;
       readpe %kds( k1y027 : 1 ) set027;
       if not %eof();

         return t@coef;

       endif;

       return 1;

      /end-free

     P COWAPE_getporcencat...
     P                 E
      * ------------------------------------------------------------ *
      * COWAPE_ordenaComponentes():                                  *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWAPE_ordenaComponentes...
     P                 B                   export
     D COWAPE_ordenaComponentes...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D   k1yev1        ds                  likerec( c1wev1 : *key )
     D   k1yev2        ds                  likerec( c1wev2 : *key )
     D   @@poco        s             10  0

      /free

       COWAPE_inz();

       clear @@poco;
       k1yev1.v1empr = peBase.peEmpr;
       k1yev1.v1sucu = peBase.peSucu;
       k1yev1.v1nivt = peBase.peNivt;
       k1yev1.v1nivc = peBase.peNivc;
       k1yev1.v1nctw = peNctw;

       //blanqueo todos
       setll %kds( k1yev1 : 5 ) ctwev101;
       reade %kds( k1yev1 : 5 ) ctwev101;
       dow not %eof();

         k1yev2.v2empr = peBase.peEmpr;
         k1yev2.v2sucu = peBase.peSucu;
         k1yev2.v2nivt = peBase.peNivt;
         k1yev2.v2nivc = peBase.peNivc;
         k1yev2.v2nctw = peNctw;
         k1yev2.v2rama = v1Rama;
         k1yev2.v2arse = v1Arse;
         k1yev2.v2poco = v1secu;

         setll %kds( k1yev2 : 8 ) ctwev201;
         reade %kds( k1yev2 : 8 ) ctwev201;
         dow not %eof();

           v2poco = 0;
           update c1wev201;

           reade %kds( k1yev2 : 8 ) ctwev201;
         enddo;

           v1poco = 0;
           update c1wev101;

         reade %kds( k1yev1 : 5 ) ctwev101;
       enddo;

       return;

      /end-free

     P COWAPE_ordenaComponentes...
     P                 E

      * ------------------------------------------------------------ *
      * COWAPE_listaComPorActi(): Lista los componentes de una       *
      *                           actividad/secuencia                *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNctw   (input)  Nro de Cotizacion                      *
      *     peActi   (input)  Actividad                              *
      *     peSecu   (input)  Secuencia para la actividad            *
      *     peLcom   (input)  Listado de componentes                 *
      *     peLcomC  (input)  Cantidad para peLcom                   *
      *     peErro   (input)  Código de Error                        *
      *     peMsgs   (input)  Mensajes                               *
      *                                                              *
      * Void                                                         *
      * ------------------------------------------------------------ *
     P COWAPE_listaComPorActi...
     P                 B                   export
     D COWAPE_listaComPorActi...
     D                 pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peActi                        5  0 const
     D  peSecu                        2  0 const
     D  peLcom                             likeds(compActi_t) dim(999999)
     D  peLcomC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D k1wev1          ds                  likerec(c1wev101:*key)

      /free

       COWAPE_inz();

       k1wev1.v1empr = peBase.peEmpr;
       k1wev1.v1sucu = peBase.peSucu;
       k1wev1.v1nivt = peBase.peNivt;
       k1wev1.v1nivc = peBase.peNivc;
       k1wev1.v1nctw = peNctw;
       k1wev1.v1rama = peRama;
       k1wev1.v1arse = peArse;
       k1wev1.v1acti = peActi;
       k1wev1.v1secu = peSecu;
       setll %kds(k1wev1:9) ctwev101;
       reade(n) %kds(k1wev1:9) ctwev101;
       dow not %eof;
           peLcomC += 1;
           peLcom(peLcomC).poco = v1poco;
           peLcom(peLcomC).paco = v1paco;
        reade(n) %kds(k1wev1:9) ctwev101;
       enddo;

       return;

      /end-free

     P COWAPE_listaComPorActi...
     P                 E

      * ------------------------------------------------------------ *
      * COWAPE_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWAPE_inz      B
     D COWAPE_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(ctw000);
         open ctw000;
       endif;

       if not %open(ctwev1);
         open ctwev1;
       endif;

       if not %open(ctwev101);
         open ctwev101;
       endif;

       if not %open(ctwev2);
         open ctwev2;
       endif;

       if not %open(ctwev201);
         open ctwev201;
       endif;

       if not %open(ctwevc);
         open ctwevc;
       endif;

       if not %open(tab009);
         open tab009;
       endif;

       if not %open(set1031);
         open set1031;
       endif;

       if not %open(set250);
         open set250;
       endif;

       if not %open(set160);
         open set160;
       endif;

       if not %open(settar);
         open settar;
       endif;

       if not %open(set204);
         open set204;
       endif;

       if not %open(set227);
         open set227;
       endif;

       if not %open(set625);
         open set625;
       endif;

       if not %open(gntloc);
         open gntloc;
       endif;

       if not %open(set015);
         open set015;
       endif;

       if not %open(set01601);
         open set01601;
       endif;

       if not %open(set103);
         open set103;
       endif;

       if not %open(set027);
         open set027;
       endif;

       if not %open(set068);
         open set068;
       endif;

       if not %open(set225);
         open set225;
       endif;

       if not %open(set220);
         open set220;
       endif;

       if not %open(set2221);
         open set2221;
       endif;

       if not %open(set22223);
         open set22223;
       endif;

       if not %open(set22531);
         open set22531;
       endif;

       if not %open(set225303);
         open set225303;
       endif;

       if not %open(setbre);
         open setbre;
       endif;

       if not %open(set215);
         open set215;
       endif;

       if not %open(set621);
         open set621;
       endif;

       if not %open(pahed003);
         open pahed003;
       endif;

       if not %open(pahet0);
         open pahet0;
       endif;

       if not %open(set111);
         open set111;
       endif;

       if not %open(ctw001);
         open ctw001;
       endif;

       if not %open(ctw001c);
         open ctw001c;
       endif;

       if not %open(set100);
          open set100;
       endif;

       initialized = *ON;
       return;

      /end-free

     P COWAPE_inz      E

      * ------------------------------------------------------------ *
      * COWAPE_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWAPE_End      B
     D COWAPE_End      pi

      /free

       close(E) *all;
       initialized = *OFF;

       return;

      /end-free

     P COWAPE_End      E

      * ------------------------------------------------------------ *
      * COWAPE_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWAPE_Error    B
     D COWAPE_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P COWAPE_Error    E

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
      * cleanUp():  Elimina mensajes controlados del Joblog.         *
      *                                                              *
      *     peMsid (input)  ID de mensaje a eliminar.                *
      *                                                              *
      * retorna: *void                                               *
      * ------------------------------------------------------------ *
     P cleanUp         B
     D cleanUp         pi             1N
     D  peMsid                        7a   const

     D QMHRCVPM        pr                  ExtPgm('QMHRCVPM')
     D   MsgInfo                  32766a   options(*varsize)
     D   MsgInfoLen                  10i 0 const
     D   Format                       8a   const
     D   StackEntry                  10a   const
     D   StackCount                  10i 0 const
     D   MsgType                     10a   const
     D   MsgKey                       4a   const
     D   WaitTime                    10i 0 const
     D   MsgAction                   10a   const
     D   ErrorCode                32766a   options(*varsize)

     D RCVM0100_t      ds                  qualified based(TEMPLATE)
     D  BytesRet                     10i 0
     D  BytesAva                     10i 0
     D  MessageSev                   10i 0
     D  MessageId                     7a
     D  MessageType                   2a
     D  MessageKey                    4a
     D  Reserved1                     7a
     D  CCSID_st                     10i 0
     D  CCSID                        10i 0
     D  DataLen                      10i 0
     D  DataAva                      10i 0
     D  Data                        256a

     D RCVM0100        ds                  likeds(RCVM0100_t)

     D ErrorCode       ds
     D  EC_BytesPrv                  10i 0 inz(0)
     D  EC_BytesAva                  10i 0 inz(0)

     D StackCnt        s             10i 0 inz(1)
     D MsgKey          s              4a

      /free

       MsgKey = *ALLx'00';

       QMHRCVPM( RCVM0100
               : %size(RCVM0100)
               : 'RCVM0100'
               : '*'
               : StackCnt
               : '*PRV'
               : MsgKey
               : 0
               : '*SAME'
               : ErrorCode        );

       if ( RCVM0100.MessageId <> peMsid );
          return *OFF;
       endif;

       MsgKey = RCVM0100.MessageKey;

       QMHRCVPM( RCVM0100
               : %size(RCVM0100)
               : 'RCVM0100'
               : '*'
               : StackCnt
               : '*ANY'
               : MsgKey
               : 0
               : '*REMOVE'
               : ErrorCode        );

       return *ON;

      /end-free

     P cleanUp         E

      * ---------------------------------------------------------------- *
      * COWAPE_cotizarWeb2(): Recibe todos los datos para la póliza de   *
      *                       AP Retorna la prima y el premio.           *
      *                                                                  *
      *       peBase ( input )  -  Base                                  *
      *       peNctw ( input )  -  Nro. de Cotización                    *
      *       peRama ( input )  -  Rama                                  *
      *       peArse ( input )  -  Cant. Pólizas por Rama                *
      *       peNrpp ( input )  -  Plan de Pago                          *
      *       peVdes ( input )  -  Fecha desde                           *
      *       peVhas ( input )  -  Fecha hasta                           *
      *       peXpro ( input )  -  Codigo de plan                        *
      *       peClie ( input )  -  Datos del Cliente                     *
      *       peActi ( input )  -  Actividad                             *
      *       peActiC( input )  -  Can. de Actividades                   *
      *       peImpu ( input )  -  Impuestos                             *
      *       pePrim ( output ) -  Prima                                 *
      *       pePrem ( output ) -  Premio                                *
      *       peErro ( output ) -  Indicador de Error                    *
      *       peMsgs ( output ) -  Estructura de Error                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWAPE_cotizarWeb2...
     P                 B                   export
     D COWAPE_cotizarWeb2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec( c1w000 : *key )
     D k1wevc          ds                  likerec( c1wevc : *key )

     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0
     D p@Poco          s              6  0
     D @@Cfpg          s              1  0
     D @@Impu          ds                  likeds( Impuesto )
     D @@Poco          s              6  0
     D y               s             10i 0
     D @@arcd          s              6  0 inz(0)
     D @@pmin          s             15  2 inz(0)
     D @@prim          s             15  2 inz(0)
     D @1prim          s             15  2 inz(0)
     D @1prem          s             15  2 inz(0)

      /free

       COWAPE_inz();

       clear peErro;

       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ):'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase :
                                                               peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrpp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       //Eliminar todos los datos de la Cotizacion...
       COWAPE_delCotizacion( peBase : peNctw );

       for y = 1 to peActiC;

         COWAPE_chkCotizar2( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : peActi(y).Acti
                           : peActi(y).Secu
                           : peActi(y).Cant
                           : peClie.tipe
                           : peClie.civa
                           : @@Cfpg
                           : peVdes
                           : peVhas
                           : peXpro
                           : peClie.Copo
                           : peClie.Cops
                           : peActi(y).Raed
                           : peActi(y).Cobe
                           : peActi(y).CobeC
                           : peErro
                           : peMsgs );

         if peErro <> *Zeros;
           return;
         endif;

         COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );

         COWGRAI_setCondComerciales( peBase : peNctw :peRama :peArse );
         clear @1prim;
         clear @1prem;
         COWAPE_cotizador2 ( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : peActi(y).Paco
                           : peActi(y).Acti
                           : peActi(y).Secu
                           : peActi(y).Cant
                           : peClie.tipe
                           : peClie.civa
                           : peNrpp
                           : @@Cfpg
                           : peVdes
                           : peVhas
                           : peXpro
                           : peClie.Copo
                           : peClie.Cops
                           : peActi(y).raed
                           : peActi(y).cobe
                           : peActi(y).cobeC
                           : @1prim
                           : @1prem
                           : peErro
                           : peMsgs );

         peActi(y).prim =  @1prim;
         peActi(y).prem =  @1prem;

         //busco el ultimo componente que tengo

         @@Poco = COWAPE_GetSecuenciaPoco ( peBase :
                                            peNctw :
                                            peRama :
                                            peArse );

         // Devuelve Impuestos Por Coberturas
         clear @@Impu;
         COWGRAI_getImpuestos( peBase
                             : peNctw
                             : peRama
                             : COWAPE_getPrimaActividad( peBase
                                                       : peNctw
                                                       : peRama
                                                       : peArse
                                                       : peActi(y).acti
                                                       : peActi(y).secu )
                             : COWAPE_GetSumaAsegActividad( peBase
                                                          : peNctw
                                                          : peRama
                                                          : peArse
                                                          : peActi(y).acti
                                                          : peActi(y).secu)
                             : peClie.Copo
                             : peClie.Cops
                             : @@Impu );

         @@Impu.cobl = *all'X';
         peActi(y).Impu = @@Impu;

       endfor;

       // Valido si es necesario ajustar por prima minima...
       @@prim = COWGRAI_getPrimaRamaArse ( peBase
                                         : peNctw
                                         : peRama );

       @@arcd = COWGRAI_getArticulo( peBase : peNctw );
       @@pmin = COWGRAI_getImpPrimaMinima( peBase
                                         : peNctw
                                         : peRama
                                         : @@arcd );

       if @@prim < @@pmin;

         COWAPE_setPrimaMinima( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : peActi
                              : peActiC );

       endif;

         // Devuelve Impuestos Por Coberturas
         clear @@Impu;
         clear peImpu;
         COWGRAI_getImpuestos( peBase
                             : peNctw
                             : peRama
                             : COWGRAI_getPrimaRamaArse ( peBase
                                                        : peNctw
                                                        : peRama )
                             : COWGRAI_getSumaAseguradaRamaArse( peBase
                                                               : peNctw
                                                               : peRama
                                                               : peArse )
                             : peClie.Copo
                             : peClie.Cops
                             : @@Impu );

         @@Impu.cobl = *all'X';
         peImpu = @@Impu;

       // Calcula montos finales...
       pePrim = COWGRAI_getPrimaRamaArse ( peBase
                                         : peNctw
                                         : peRama );
       pePrem = COWAPE_getPremio ( peBase
                                 : peNctw
                                 : peRama );

       return;

      /end-free

     P COWAPE_cotizarWeb2...
     P                 E
      * ---------------------------------------------------------------- *
      * COWAPE_reCotizarWeb2(): Recibe todos los datos para la póliza de *
      *                         AP Retorna la prima y el premio.         *
      *                                                                  *
      *       peBase ( input )  -  Base                                  *
      *       peNctw ( input )  -  Nro. de Cotización                    *
      *       peRama ( input )  -  Rama                                  *
      *       peArse ( input )  -  Cant. Pólizas por Rama                *
      *       peTipe ( input )  -  Tipo de persona                       *
      *       peCiva ( input )  -  Codigo de Iva                         *
      *       peNrpp ( input )  -  Plan de Pago                          *
      *       peVdes ( input )  -  Fecha desde                           *
      *       peVhas ( input )  -  Fecha hasta                           *
      *       peXpro ( input )  -  Codigo de plan                        *
      *       peClie ( input )  -  Datos del Cliente                     *
      *       peActi ( input )  -  Actividad                             *
      *       peActiC( input )  -  Can. de Actividades                   *
      *       peImpu ( input )  -  Impuestos                             *
      *       pePrim ( output ) -  Prima                                 *
      *       pePrem ( output ) -  Premio                                *
      *       peErro ( output ) -  Indicador de Error                    *
      *       peMsgs ( output ) -  Estructura de Error                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P COWAPE_reCotizarWeb2...
     P                 B                   export
     D COWAPE_reCotizarWeb2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0
     D p@Poco          s              6  0
     D @@Impu          ds                   likeds(Impuesto)
     D @@Poco          s              6  0
     D @@arcd          s              6  0
     D @@pmin          s             15  2
     D @@prim          s             15  2
     D @1prim          s             15  2
     D @1prem          s             15  2

     D @@Cfpg          s              1  0
     D y               s             10i 0

      /free

       COWAPE_inz();

       clear peErro;

       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ):'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase :
                                                               peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrpp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       //Eliminar todos los datos de la Cotizacion...
       COWAPE_delCotizacion( peBase : peNctw );

       for y = 1 to peActiC;

         COWAPE_chkCotizar2( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : peActi(y).Acti
                           : peActi(y).Secu
                           : peActi(y).Cant
                           : peClie.tipe
                           : peClie.civa
                           : @@Cfpg
                           : peVdes
                           : peVhas
                           : peXpro
                           : peClie.Copo
                           : peClie.Cops
                           : peActi(y).Raed
                           : peActi(y).Cobe
                           : peActi(y).CobeC
                           : peErro
                           : peMsgs );

         if peErro <> *Zeros;
           return;
         endif;

         COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );

         COWGRAI_updCondComerciales( peBase
                                   : peNctw
                                   : peRama
                                   : peImpu.Xrea );
         //clear peImpu;
         clear @1prim;
         clear @1prem;
         COWAPE_cotizador2 ( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : peActi(y).Paco
                           : peActi(y).Acti
                           : peActi(y).Secu
                           : peActi(y).Cant
                           : peClie.tipe
                           : peClie.civa
                           : peNrpp
                           : @@Cfpg
                           : peVdes
                           : peVhas
                           : peXpro
                           : peClie.Copo
                           : peClie.Cops
                           : peActi(y).raed
                           : peActi(y).cobe
                           : peActi(y).cobeC
                           : @1prim
                           : @1prem
                           : peErro
                           : peMsgs );

         peActi(y).prim = @1prim;
         peActi(y).prem = @1prem;

         //busco el ultimo componente que tengo

         @@Poco = COWAPE_GetSecuenciaPoco ( peBase :
                                            peNctw :
                                            peRama :
                                            peArse );

         // Devuelve Impuestos Por Coberturas
         clear @@Impu;
         COWGRAI_getImpuestos( peBase
                             : peNctw
                             : peRama
                             : COWAPE_getPrimaActividad( peBase
                                                       : peNctw
                                                       : peRama
                                                       : peArse
                                                       : peActi(y).acti
                                                       : peActi(y).secu )
                             : COWAPE_GetSumaAsegActividad( peBase
                                                          : peNctw
                                                          : peRama
                                                          : peArse
                                                          : peActi(y).acti
                                                          : peActi(y).secu )
                             : peClie.Copo
                             : peClie.Cops
                             : @@Impu );

         @@Impu.cobl = *all'X';
         peActi(y).Impu = @@Impu;

       endfor;

       // Valido si es necesario ajustar por prima minima...
       @@prim = COWGRAI_getPrimaRamaArse ( peBase
                                         : peNctw
                                         : peRama );

       @@arcd = COWGRAI_getArticulo( peBase : peNctw );
       @@pmin = COWGRAI_getImpPrimaMinima( peBase
                                         : peNctw
                                         : peRama
                                         : @@arcd );
       if @@prim < @@pmin;

         COWAPE_setPrimaMinima( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : peActi
                              : peActiC );

       endif;

         // Devuelve Impuestos Por Coberturas
         clear @@Impu;
         clear peImpu;
         COWGRAI_getImpuestos( peBase
                             : peNctw
                             : peRama
                             : COWGRAI_getPrimaRamaArse ( peBase
                                                        : peNctw
                                                        : peRama )
                             : COWGRAI_getSumaAseguradaRamaArse( peBase
                                                               : peNctw
                                                               : peRama
                                                               : peArse )
                             : peClie.Copo
                             : peClie.Cops
                             : @@Impu );

         @@Impu.cobl = *all'X';
         peImpu = @@Impu;


       // Calcula montos finales...
       pePrim = COWGRAI_getPrimaRamaArse ( peBase
                                         : peNctw
                                         : peRama );
       pePrem = COWAPE_getPremio ( peBase
                                 : peNctw
                                 : peRama );

       return;

      /end-free

     P COWAPE_reCotizarWeb2...
     P                 E

      * ---------------------------------------------------------------- *
      * COWAPE_setPrimaMinima(): Graba prima mínima                      *
      *                          Inicialmente solo aplica a Cobertura de *
      *                          Muerte ( 28 )                           *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *

     P COWAPE_setPrimaMinima...
     P                 b                   export
     D COWAPE_setPrimaMinima...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                            likeds( activ_t ) dim( 99 )
     D   peActiC                     10i 0

     D   @@arcd        s              6  0
     D   @@pmin        s             15  2
     D   @@mini        s             15  2
     D   @@ptco        s             15  2
     D   @@prima       s             15  2
     D   @@canper      s             10i 0
     D   @@ajusta      s             29  9
     D   @@ajuste      s             15  2
     D   @@copo        s              5  0
     D   @@cops        s              1  0
     D   x             s             10i 0

     D   k1yev2        ds                  likerec( c1wev2 : *key )

      /free

        COWAPE_inz();

        @@prima  = COWGRAI_getPrimaRamaArse ( peBase
                                            : peNctw
                                            : peRama );
        @@arcd   = COWGRAI_getArticulo( peBase : peNctw );
        @@pmin   = COWGRAI_getImpPrimaMinima( peBase
                                            : peNctw
                                            : peRama
                                            : @@arcd );

        @@canper = COWAPE_getCantidadTotalDePersonas( peBase
                                                    : peNctw
                                                    : peRama
                                                    : peArse  );

        COWGRAI_GetCopoCops( peBase
                           : peNctw
                           : @@copo
                           : @@cops );

        clear @@ajusta;
        clear @@ajuste;
        clear @@mini;
        @@mini = @@pmin - @@prima;
        if @@canper > 0;
          @@ajusta = @@mini / @@canper;
          @@ajuste = %dech( @@ajusta : 15 : 2 );
        endif;

        k1yev2.v2empr = peBase.peEmpr;
        k1yev2.v2sucu = peBase.peSucu;
        k1yev2.v2nivt = peBase.peNivt;
        k1yev2.v2nivc = peBase.peNivc;
        k1yev2.v2nctw = peNctw;
        k1yev2.v2rama = peRama;
        k1yev2.v2arse = peArse;
        setll %kds( k1yev2 : 7 ) ctwev2;
        reade %kds( k1yev2 : 7 ) ctwev2;
        dow not %eof( ctwev2 );
          if v2xcob = 28;
            v2ptco  += @@ajuste;
            update c1wev2;
          endif;
          @@ptco  += v2ptco;
         reade %kds( k1yev2 : 7 ) ctwev2;
        enddo;

        if @@ptco <> @@pmin;
          setgt %kds( k1yev2 : 7 ) ctwev2;
          readpe %kds( k1yev2 : 7 ) ctwev2;
          dow not %eof( ctwev2 );
            if v2xcob = 28;
              v2ptco += @@pmin - @@ptco;
              update c1wev2;
              leave;
            endif;
           readpe %kds( k1yev2 : 7 ) ctwev2;
          enddo;
        endif;

        for x = 1 to peActiC;
           COWAPE_setPormilajePrima( peBase
                                   : peNctw
                                   : peActi(x).acti
                                   : peActi(x).secu
                                   : peActi(x).cobe );

          // Actualiza Archivo de Categorias
          COWAPE_saveCategorias( peBase
                               : peNctw
                               : peRama
                               : peArse
                               : peActi(x).Secu
                               : peActi(x).acti
                               : peActi(x).Cant
                               : @@copo
                               : @@cops
                               : peActi(x).Raed );

           COWGRAI_getImpuestos( peBase
                              : peNctw
                              : peRama
                              : COWAPE_getPrimaActividad( peBase
                                                        : peNctw
                                                        : peRama
                                                        : peArse
                                                        : peActi(x).acti
                                                        : peActi(x).secu )
                              : COWAPE_GetSumaAsegActividad( peBase
                                                          : peNctw
                                                          : peRama
                                                          : peArse
                                                          : peActi(x).acti
                                                          : peActi(x).secu )
                               : @@copo
                               : @@cops
                               : peActi(x).Impu );

          peacti(x).Prim = COWAPE_getPrimaActividad( peBase
                                                   : peNctw
                                                   : peRama
                                                   : peArse
                                                   : peActi(x).acti
                                                   : peActi(x).secu );

          peActi(x).Prem = COWAPE_getPremioActividad( peBase
                                                    : peNctw
                                                    : peRama
                                                    : peArse
                                                    : peActi(x).acti
                                                    : peActi(x).secu );
          endfor;

          // Premio final
          COWGRAI_getPremioFinal ( peBase : peNctw );

       return *on;
      /end-free

     P COWAPE_setPrimaMinima...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_setPormilajePrima(): Graba Pormilajes prima               *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *       peCobe ( output ) - Estructura de Cobertura                *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *

     P COWAPE_setPormilajePrima...
     P                 b                   export
     D COWAPE_setPormilajePrima...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)

     D   x             s             10i 0
     D   idx           s              6a   dim(10)
     D   @cobe         ds                  qualified dim(10)
     D    ptco                       15  2
     D    xpri                        9  6
     D   i             s             10i 0
     D   s             s              6a

     D   k1yev1        ds                  likerec( c1wev1 : *key )
     D   k1yev2        ds                  likerec( c1wev2 : *key )

      /free

        COWAPE_inz();

        clear idx;
        clear @cobe;
        i = 0;

        k1yev1.v1empr = peBase.peEmpr;
        k1yev1.v1sucu = peBase.peSucu;
        k1yev1.v1nivt = peBase.peNivt;
        k1yev1.v1nivc = peBase.peNivc;
        k1yev1.v1nctw = peNctw;
        setll %kds(k1yev1:5) ctwev1;
        reade(n) %kds(k1yev1:5) ctwev1;
        dow not %eof( ctwev1 );
           if v1acti = peActi and v1secu = peSecu;
              k1yev2.v2empr = v1empr;
              k1yev2.v2sucu = v1sucu;
              k1yev2.v2nivt = v1nivt;
              k1yev2.v2nivc = v1nivc;
              k1yev2.v2nctw = v1nctw;
              k1yev2.v2rama = v1rama;
              k1yev2.v2arse = v1arse;
              k1yev2.v2poco = v1poco;
              k1yev2.v2paco = v1paco;
              setll %kds(k1yev2:9) ctwev2;
              reade(n) %kds(k1yev2:9) ctwev2;
              dow not %eof( ctwev2 );
                  s = %trim(v2riec)
                    + %editc(v2xcob:'X');
                  i = %lookup(s:idx);
                  if i = 0;
                     i = %lookup(*blanks:idx);
                     idx(i) = s;
                 endif;
                 @cobe(i).ptco += v2ptco;
                 @cobe(i).xpri  = v2xpri;
               reade(n) %kds(k1yev2:9) ctwev2;
              enddo;
           endif;
        reade(n) %kds(k1yev1:5) ctwev1;
       enddo;

       for x = 1 to 20;
         if peCobe(x).xcob <> 0;
           s = %trim(peCobe(x).riec)
             + %editc(peCobe(x).xcob:'X');
           i = %lookup(s:idx);
           if i <> 0;
             peCobe(x).xpri = @cobe(i).xpri;
             peCobe(x).prim = @cobe(i).ptco;
           endif;
         endif;
       endfor;

       return *on;

      /end-free

     P COWAPE_setPormilajePrima...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_getPrimaActividad(): Obtiene Prima de una determinada     *
      *                             Actividad                            *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *                                                                  *
      * Retorna Prima / *Zeros                                           *
      * ---------------------------------------------------------------- *

     P COWAPE_getPrimaActividad...
     P                 b                   export
     D COWAPE_getPrimaActividad...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

     D   k1yevc        ds                  likerec( c1wevc : *key )

      /free

       COWAPE_inz();

       k1yevc.v0empr = peBase.peEmpr;
       k1yevc.v0sucu = peBase.peSucu;
       k1yevc.v0nivt = peBase.peNivt;
       k1yevc.v0nivc = peBase.peNivc;
       k1yevc.v0nctw = peNctw;
       k1yevc.v0rama = peRama;
       k1yevc.v0arse = peArse;
       k1yevc.v0acti = peActi;
       k1yevc.v0secu = peSecu;
       chain %kds( k1yevc : 9 ) ctwevc;
       if %found( ctwevc );
         return v0prim;
       endif;

         return *zeros;

      /end-free

     P COWAPE_getPrimaActividad...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_getPremioctividad(): Obtiene Premio de una determinada    *
      *                             Actividad                            *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *                                                                  *
      * Retorna Premio / *zeros                                          *
      * ---------------------------------------------------------------- *

     P COWAPE_getPremioActividad...
     P                 b                   export
     D COWAPE_getPremioActividad...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

     D   k1yevc        ds                  likerec( c1wevc : *key )

      /free

       COWAPE_inz();

       k1yevc.v0empr = peBase.peEmpr;
       k1yevc.v0sucu = peBase.peSucu;
       k1yevc.v0nivt = peBase.peNivt;
       k1yevc.v0nivc = peBase.peNivc;
       k1yevc.v0nctw = peNctw;
       k1yevc.v0rama = peRama;
       k1yevc.v0arse = peArse;
       k1yevc.v0acti = peActi;
       k1yevc.v0secu = peSecu;
       chain %kds( k1yevc : 9 ) ctwevc;
       if %found( ctwevc );
         return v0prem;
       endif;

       return *zeros;

      /end-free

     P COWAPE_getPremioActividad...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_GetSumaAsegActividad() : Obtiene Suma Asegurada de una    *
      *                                 determinada Actividad            *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *                                                                  *
      * Retorna Suma / *Zeros                                            *
      * ---------------------------------------------------------------- *

     P COWAPE_GetSumaAsegActividad...
     P                 b                   export
     D COWAPE_GetSumaAsegActividad...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

     D   k1yevc        ds                  likerec( c1wevc : *key )

      /free

       COWAPE_inz();

       k1yevc.v0empr = peBase.peEmpr;
       k1yevc.v0sucu = peBase.peSucu;
       k1yevc.v0nivt = peBase.peNivt;
       k1yevc.v0nivc = peBase.peNivc;
       k1yevc.v0nctw = peNctw;
       k1yevc.v0rama = peRama;
       k1yevc.v0arse = peArse;
       k1yevc.v0acti = peActi;
       k1yevc.v0secu = peSecu;
       chain %kds( k1yevc : 9 ) ctwevc;
       if %found( ctwevc );
         return v0suas;
       endif;

       return *zeros;

      /end-free

     P COWAPE_GetSumaAsegActividad...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_getCantidadTotalDePersonas(): Retorna cantidad total de   *
      *                                      personas a cotizar          *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *

     P COWAPE_getCantidadTotalDePersonas...
     P                 b                   export
     D COWAPE_getCantidadTotalDePersonas...
     D                 pi            10  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D   @@cant        s             10i 0 inz(0)

     D   k1yev1        ds                  likerec( c1wev1 : *key )

      /free

       COWAPE_inz();

       k1yev1.v1empr = peBase.peEmpr;
       k1yev1.v1sucu = peBase.peSucu;
       k1yev1.v1nivt = peBase.peNivt;
       k1yev1.v1nivc = peBase.peNivc;
       k1yev1.v1nctw = peNctw;
       k1yev1.v1rama = peRama;
       k1yev1.v1arse = peArse;
       setll %kds(k1yev1:7) ctwev1;
       reade(n) %kds(k1yev1:7) ctwev1;
       dow not %eof( ctwev1 );

         @@cant += 1;

         reade(n) %kds(k1yev1:7) ctwev1;
       enddo;

        return @@cant;

      /end-free

     P COWAPE_getCantidadTotalDePersonas...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_chkCotizar2():  Valida Cotizacion                         *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Actividades                            *
      *       peSecu ( input )  - Secuencia                              *
      *       peCant ( input )  - Cantidad                               *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha desde                            *
      *       peVhas ( input )  - Fecha Hasta                            *
      *       peXpro ( input )  - Producto                               *
      *       peCopo ( input )  - Codigo Postal                          *
      *       peCops ( input )  - Sub. Codigo Postal                     *
      *       peRaed ( input )  - Rango de Edad                          *
      *       peCobe ( input )  - Coberturas                             *
      *       peCobeC( input )  - Cant. de Coberturas                    *
      *       peErro ( output ) - Marca de Erorr                         *
      *       peMsgs ( output ) - Mensaje de Error                       *
      *                                                                  *
      * Retorna: peErro = '0' / '-1'                                     *
      * ---------------------------------------------------------------- *
     P COWAPE_chkCotizar2...
     P                 B                   export
     D COWAPE_chkCotizar2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peCfpg                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peCobeC                     10i 0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)

     D p@Tiou          s              1  0
     D p@Stou          s              2  0
     D p@Stos          s              2  0
     D x               s             10i 0
     D y               s             10i 0
     D p@Poco          s              6  0
     D @@Lcob          s              3  0 dim(20)
     D @@LcobC         s             10i 0
     D p@Lcob          s              3  0 dim(20)
     D p@LcobC         s             10i 0
     D @@fch1          s               d   datfmt(*iso) inz
     D @@fch2          s              8  0

      /free

       COWAPE_inz();

       peErro = *Zeros;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return;

       endif;

       //Valido Cotización
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %editc(peNctw:'X');
           %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama que pueda emitir en web
       if SVPVAL_ramaWeb ( peRama ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_RAMNW = ErrCode;

           %subst(wrepl:1:2) = %editc(peRama:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama de Vida
       if SVPWS_getGrupoRama ( peRama ) <> 'V';

         %subst(wrepl:1:2) = %editc ( peRama : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0067'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;

       endif;

       //Valido Forma de Pago
       if SVPVAL_formaDePagoWeb ( peCfpg ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_FDPNW = ErrCode;

           %subst(wrepl:1:1) =  %editc ( peCfpg : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0026'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Persona
       if SVPVAL_tipoPersona ( peTipe ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_TPENV = ErrCode;

           %subst(wrepl:1:1) =  peTipe;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0015'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Persona
       if SVPVAL_ivaWeb ( peCiva ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_IVANE = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_IVANW = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         endif;

         peErro = -1;
         return;
       endif;

       //Valido Fecha de Inicio
       test(DE) *iso peVdes;
       if %error;

         %subst(wrepl:1:8) = %editc(peVdes :'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0010'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Valido Fecha Hasta
       test(DE) *iso peVhas;
       if %error;

         %subst(wrepl:1:8) = %editc(peVhas : 'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0010'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Valido que la fecha hasta no sea mayor a la fecha desde
       if peVhas < peVdes;

         peErro = -1;
         return;

       endif;

       //Valido que la diferencia entre fecha desde y hasta no sea mayor
       //a un año

       Monitor;

         @@Fch1 = %date( %char ( peVdes ) : *iso0);
         @@Fch1 += %years(1);
         @@Fch2 = %int( %char( @@Fch1 : *iso0) );

       on-error;
         cleanUp( 'RNX0112' );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;
       endmon;

       if pevhas > @@Fch2;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0046'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Coberturas(Prima)...
       for x = 1 to peCobeC;
         if not SVPVAL_chkCobPrima( peRama
                                  : peXpro
                                  : peCobe(x).riec
                                  : peCobe(x).xcob
                                  : COWGRAI_monedaCotizacion( peBase
                                                            : peNctw));

           %subst(wrepl:1:3) =  peCobe(x).riec;
           %subst(wrepl:3:5) =  %editc( peCobe(x).xcob : 'X' );
           %subst(wrepl:6:7) =  %editc( peRama : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0036'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
        endif;
       endfor;

       // Valida la suma asegurada ingresada por cobertura
       for x = 1 to peCobeC;
         if not SVPVAL_CHKCobSumMaxMin( peRama
                                      : peXpro
                                      : peCobe(x).riec
                                      : peCobe(x).xcob
                                      : COWGRAI_monedaCotizacion( peBase
                                                                : peNctw)
                                      : peCobe(x).sac1
                                      : peCobe );

           %subst(wrepl:1:40) =  %trim( SVPDES_cobLargo ( peRama :
                                                          peCobe(x).xcob));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0021'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;
         endif;
       endfor;

       // Valida coberturas excluyentes entre si
       clear p@Lcob;

       for y = 1 to peCobeC;

          p@Lcob(y) = peCobe(y).xcob;
          p@LcobC += 1;

       endfor;

       if not SVPCOB_ValCoberturasBasicas( peRama
                                         : peXpro
                                         : peCobe(1).riec
                                         : COWGRAI_monedaCotizacion( peBase
                                                                   : peNctw)
                                         : p@Lcob  );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0123'
                      : peMsgs     );
         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;


       if not SVPCOB_ValListCobExcluyentes ( peRama :
                                             peXpro :
                                             peCobe(1).riec :
                                             COWGRAI_monedaCotizacion( peBase
                                                                     : peNctw):
                                             p@Lcob  :
                                             p@LcobC );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0121'
                      : peMsgs     );

         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;


       if not SVPCOB_ValListCobReglas ( peRama :
                                        peXpro :
                                        peCobe(1).riec :
                                        COWGRAI_monedaCotizacion( peBase
                                                                : peNctw):
                                        p@Lcob  :
                                        p@LcobC );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0122'
                      : peMsgs     );

         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;

       //Valido Código Postal
       if SVPVAL_codigoPostal ( peCopo
                              : peCops ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_COPNE = ErrCode;

           %subst(wrepl:1:5) = %editc(peCopo:'X');
           %subst(wrepl:7:1) = %editc(peCops:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       return;

      /end-free

     P COWAPE_chkCotizar2...
     P                 E
      * ---------------------------------------------------------------- *
      * COWAPE_cotizador2():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. de Polizas por rama              *
      *       pePaco ( input )  - Parentesco                             *
      *       peActi ( input )  - Actividad                              *
      *       peSecu ( input )  - Secuencia                              *
      *       peCant ( input )  - Cantidad                               *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peNrpp ( input )  - Plan de pago                           *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha Desde                            *
      *       peVhas ( input )  - Fechas Hasta                           *
      *       peXpro ( input )  - Producto                               *
      *       peCopo ( input )  - Codigo Postal                          *
      *       peCops ( input )  - Subfijo de Codigo Postal               *
      *       peRaed ( input )  - Rango de Edad                          *
      *       peCobe ( input )  - Coberturas                             *
      *       peCobeC( input )  - Cantidad de Coberturas                 *
      *       pePrim ( output ) - Prima                                  *
      *       pePrem ( output ) - Premio                                 *
      *       peErro ( output ) - Marca de Error                         *
      *       peMsgs ( output ) - Mensaje de Error                       *
      *                                                                  *
      * Retorna: peError = '0' / '-1'                                    *
      * ---------------------------------------------------------------- *

     P COWAPE_cotizador2...
     P                 B                   export
     D COWAPE_cotizador2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peCobeC                     10i 0
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y000          ds                  likerec(c1w000:*key)
     D k1wev1          ds                  likerec(c1wev1:*key)
     D k1wev2          ds                  likerec(c1wev2:*key)
     D samin           s             15  2
     D samax           s             15  2
     D f@emi           s              8  0
     D p@Scta          s              1  0
     D x               s             10i 0
     D y               s             10i 0
     D p@Poco          s              6  0
     D @@Poco          s              6  0

     D i               s             10i 0
     D s               s              6a
     D idx             s              6a   dim(10)
     D @cobe           ds                  qualified dim(10)
     D  ptco                         15  2
     D  xpri                          9  6

     D   @@Impu        ds                  likeds(Impuesto)
     D   @@xpri        s              9  6
     D   @@prim        s             15  2
     D   p@Seri        s             15  2
     D   p@Seem        s             15  2
     D   p@Impi        s             15  2
     D   p@Sers        s             15  2
     D   p@Tssn        s             15  2
     D   p@Ipr1        s             15  2
     D   p@Ipr4        s             15  2
     D   p@Ipr3        s             15  2
     D   p@Ipr6        s             15  2
     D   p@Ipr7        s             15  2
     D   p@Ipr8        s             15  2
     D   p@Ipr9        s             15  2
      /free

       COWAPE_inz();

       peErro = *Zeros;

       //Actualizo Informacion del CTW000

       COWGRAI_updCotizacion( peBase
                            : peNctw
                            : peCiva
                            : peTipe
                            : peCopo
                            : peCops
                            : peCfpg
                            : peNrpp
                            : peVdes
                            : peVhas );



       //busco el ultimo componente que tengo

       @@Poco = COWAPE_GetSecuenciaPoco ( peBase :
                                          peNctw :
                                          peRama :
                                          peArse );


       //Grabo Archivos
       p@Poco = @@poco;

       for y = 1 to peCant;

         p@Poco += 1;

         COWAPE_saveCabecera ( peBase :
                               peNctw :
                               peRama :
                               peArse :
                               p@Poco :
                               pePaco :
                               peActi :
                               peSecu :
                               peCopo :
                               peCops :
                               peXpro );

       endfor;

       p@Poco = @@poco;

       for y = 1 to peCant;

         p@Poco += 1;

         for x = 1 to peCobeC;

           //Graba Coberturas Riesgos Varios - CTWEV2

           COWAPE_saveCoberturasAp( peBase
                                  : peNctw
                                  : peRama
                                  : pexPro
                                  : peArse
                                  : p@Poco
                                  : peSecu
                                  : pePaco
                                  : peActi
                                  : peCobe(x).riec
                                  : peCobe(x).xcob
                                  : peCobe(x).sac1
                                  : peRaed
                                  : peVdes
                                  : peVhas);

         endfor;

       endfor;

       // ----------------------------------------
       // Buscar pormilaje y prima
       // ----------------------------------------
        COWAPE_setPormilajePrima( peBase
                                : peNctw
                                : peActi
                                : peSecu
                                : peCobe );

       // Graba Impuestos - CTW001
       COWGRAI_SaveImpuestos2( peBase
                             : peNctw
                             : peRama
                             : peArse );

       // Graba Archivo de Categorias
       COWAPE_saveCategorias( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              peSecu :
                              peActi :
                              peCant :
                              peCopo :
                              peCops :
                              peRaed );

        // Premio final
        COWGRAI_getPremioFinal ( peBase : peNctw );
        if SVPVAL_chkPlanCerrado( peRama
                                : peXpro
                                : COWGRAI_monedaCotizacion( peBase
                                                          : peNctw));

          COWAPE_planesCerrados ( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : p@Poco );
        endif;

        pePrim = COWAPE_getPrimaActividad( peBase
                                         : peNctw
                                         : peRama
                                         : peArse
                                         : peActi
                                         : peSecu);

        pePrem = COWAPE_getPremioActividad( peBase
                                          : peNctw
                                          : peRama
                                          : peArse
                                          : peActi
                                          : peSecu);

       Return;

      /end-free

     P COWAPE_cotizador2...
     P                 E

      * ---------------------------------------------------------------- *
      * COWAPE_delCotizacion(): Elimina todos los datos cargados de la   *
      *                         Cotizacion.                              *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWAPE_delCotizacion...
     P                 B                   export
     D COWAPE_delCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      /free

       //CTWEV2...
       if not COWAPE_delCobertura( peBase : peNctw );
         return *off;
         //error
       endif;

       //CTWEVC...
       if not COWAPE_delCategoria( peBase : peNctw );
         //error
         return *off;
       endif;

       //CTWEV1...
       if not COWAPE_delCabecera( peBase  : peNctw );
         return *off;
         //error
       endif;

       return *on;
      /end-free

     P COWAPE_delCotizacion...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_delCobertura(): Elimina coberturas de una cotizacion.     *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                      ( opcional ) *
      *       peArse ( input )  - Cant. de Polizas por Rama ( opcional ) *
      *       pePoco ( input )  - Nro de Componente         ( opcional ) *
      *       pePaco ( input )  - Parentesco                ( opcional ) *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWAPE_delCobertura...
     P                 b                   export
     D COWAPE_delCobertura...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   pePoco                       6  0 const options(*nopass:*omit)
     D   pePaco                       3  0 const options(*nopass:*omit)

     D   k1yev2        ds                  likerec( c1wev2 : *key )

      /free

       COWAPE_inz();

       k1yev2.v2empr = peBase.peEmpr;
       k1yev2.v2sucu = peBase.peSucu;
       k1yev2.v2nivt = peBase.peNivt;
       k1yev2.v2nivc = peBase.peNivc;
       k1yev2.v2nctw = peNctw;

       if %parms = 2;
         setll %kds( k1yev2 : 5 ) ctwev2;
         reade %kds( k1yev2 : 5 ) ctwev2;
         dow not %eof( ctwev2 );
           delete c1wev2;
          reade %kds( k1yev2 : 5 ) ctwev2;
         enddo;
         return *on;
       endif;

       if %parms >= 3 and %addr( peRama ) <> *null
                      and %addr( peArse ) <> *null
                      and %addr( pePoco ) <> *null
                      and %addr( pePaco ) <> *null;

         k1yev2.v2rama = peRama;
         k1yev2.v2arse = peArse;
         k1yev2.v2poco = pePoco;
         k1yev2.v2paco = pePaco;
         setll %kds( k1yev2 : 9 ) ctwev2;
         reade %kds( k1yev2 : 9 ) ctwev2;
         dow not %eof( ctwev2 );
           delete c1wev2;
          reade %kds( k1yev2 : 9 ) ctwev2;
         enddo;
         return *on;
       endif;

       return *off;
      /end-free

     P COWAPE_delCobertura...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_delCategoria(): Elimina categorias de una cotizacion.     *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                      ( opcional ) *
      *       peArse ( input )  - Cant. de Polizas por Rama ( opcional ) *
      *       peActi ( input )  - Actividad                 ( opcional ) *
      *       peSecu ( input )  - Secuencia                 ( opcional ) *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWAPE_delCategoria...
     P                 b                   export
     D COWAPE_delCategoria...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peActi                       5  0 const options(*nopass:*omit)
     D   peSecu                       2  0 const options(*nopass:*omit)

     D   k1yevc        ds                  likerec( c1wevc : *key )

      /free

       COWAPE_inz();

       k1yevc.v0empr = peBase.peEmpr;
       k1yevc.v0sucu = peBase.peSucu;
       k1yevc.v0nivt = peBase.peNivt;
       k1yevc.v0nivc = peBase.peNivc;
       k1yevc.v0nctw = peNctw;

       if %parms = 2;
         setll %kds( k1yevc : 5 ) ctwevc;
         reade %kds( k1yevc : 5 ) ctwevc;
         dow not %eof( ctwevc );
           delete c1wevc;
          reade %kds( k1yevc : 5 ) ctwevc;
         enddo;
         return *on;
       endif;

       if %parms >= 3 and %addr( peRama ) <> *null
                      and %addr( peArse ) <> *null
                      and %addr( peActi ) <> *null
                      and %addr( peSecu ) <> *null;

         k1yevc.v0rama = peRama;
         k1yevc.v0arse = peArse;
         k1yevc.v0acti = peActi;
         k1yevc.v0secu = peSecu;
         setll %kds( k1yevc : 9 ) ctwevc;
         reade %kds( k1yevc : 9 ) ctwevc;
         dow not %eof( ctwevc );
           delete c1wevc;
          reade %kds( k1yevc : 9 ) ctwevc;
         enddo;
         return *on;
       endif;

       return *on;
      /end-free

     P COWAPE_delCategoria...
     P                 e
      * ---------------------------------------------------------------- *
      * COWAPE_delCabecera(): Elimina cabecera de una cotizacion.        *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                      ( opcional ) *
      *       peArse ( input )  - Cant. de Polizas por Rama ( opcional ) *
      *       pePoco ( input )  - Nro de Componente         ( opcional ) *
      *       pePaco ( input )  - Parentesco                ( opcional ) *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWAPE_delCabecera...
     P                 b                   export
     D COWAPE_delCabecera...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   pePoco                       6  0 const options(*nopass:*omit)
     D   pePaco                       3  0 const options(*nopass:*omit)

     D   k1yev1        ds                  likerec( c1wev1 : *key )

      /free

       COWAPE_inz();

       k1yev1.v1empr = peBase.peEmpr;
       k1yev1.v1sucu = peBase.peSucu;
       k1yev1.v1nivt = peBase.peNivt;
       k1yev1.v1nivc = peBase.peNivc;
       k1yev1.v1nctw = peNctw;

       if %parms = 2;
         setll %kds( k1yev1 : 5 ) ctwev1;
         reade %kds( k1yev1 : 5 ) ctwev1;
         dow not %eof( ctwev1 );
           delete c1wev1;
          reade %kds( k1yev1 : 5 ) ctwev1;
         enddo;
         return *on;
       endif;

       if %parms >= 3 and %addr( peRama ) <> *null
                      and %addr( peArse ) <> *null
                      and %addr( pePoco ) <> *null
                      and %addr( pePaco ) <> *null;

         k1yev1.v1rama = peRama;
         k1yev1.v1arse = peArse;
         k1yev1.v1poco = pePoco;
         k1yev1.v1paco = pePaco;
         setll %kds( k1yev1 : 9 ) ctwev1;
         reade %kds( k1yev1 : 9 ) ctwev1;
         dow not %eof( ctwev1 );
           delete c1wev1;
          reade %kds( k1yev1 : 9 ) ctwev1;
         enddo;
         return *on;
       endif;

       return *on;

      /end-free

     P COWAPE_delCabecera...
     P                 e
      * ------------------------------------------------------------ *
      * COWAPE_planesCerrados(): Calcula Planes Cerrados             *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWAPE_planesCerrados...
     P                 B                     export
     D COWAPE_planesCerrados...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const

     D k1yev1          ds                   likerec(c1wev1:*key)
     D k1yev2          ds                   likerec(c1wev2:*key)
     D k1y000          ds                   likerec(c1w000:*key)
     D k1y001          ds                   likerec(c1w001:*key)
     D k1yevc          ds                   likerec(c1wevc:*key)
     D k1y100          ds                   likerec(s1t100:*key)

     D @@prec          s              5  2
     D @@bpep          s              5  2
     D @@bpip          s              5  2
     D @@bpri          s             15  2
     D @@prim          s             15  2
     D @@subt          s             15  2
     D @@ivat          s             15  2

     D @@prem          s             15  2
     D @@impu          s             15  2

     D @@dere          s             15  2
     D @@refi          s             15  2
     D @@impi          s             15  2
     D @@sers          s             15  2
     D @@tssn          s             15  2
     D @@ipr1          s             15  2
     D @@ipr2          s             15  2
     D @@ipr3          s             15  2
     D @@ipr4          s             15  2
     D @@ipr5          s             15  2
     D @@ipr6          s             15  2
     D @@ipr7          s             15  2
     D @@ipr8          s             15  2
     D @@ipr9          s             15  2

     D @@form          s              1    inz ('A')

     D @@xpri          s              9  6
     D @@ptco          s             15  2
     D @@tpcd          s              2a
     D @@cls           s              3a   dim(200)
     D @1prem          s             15  2
     D @2prem          s             15  2
     D @3prem          s             15  2
     D xxprem          s             29  9
     D @@suma          s             15  2

     D veces           s             10i 0

       COWAPE_inz();

       @@suma = COWGRAI_getSumaAseguradaRamaArse( peBase
                                                : peNctw
                                                : peRama
                                                : peArse );

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds( k1y000 ) ctw000;

       k1yev1.v1Empr = peBase.peEmpr;
       k1yev1.v1Sucu = peBase.peSucu;
       k1yev1.v1Nivt = peBase.peNivt;
       k1yev1.v1Nivc = peBase.peNivc;
       k1yev1.v1Nctw = peNctw;
       k1yev1.v1Rama = peRama;
       k1yev1.v1Arse = peArse;
       k1yev1.v1Poco = pePoco;
       chain(n) %kds( k1yev1 : 8 ) ctwev1;

       k1y100.t@rama = peRama;
       k1y100.t@xpro = v1xpro;
       k1y100.t@mone = w0mone;
       chain(n) %kds( k1y100 ) set100;

       if ( t@Prem = *Zeros );
         return *On;
       else;
         @@prem = *Zeros;
         @1prem = t@prem;

         k1yev2.v2empr = peBase.peEmpr;
         k1yev2.v2sucu = peBase.peSucu;
         k1yev2.v2nivt = peBase.peNivt;
         k1yev2.v2nivc = peBase.peNivc;
         k1yev2.v2nctw = peNctw;
         k1yev2.v2rama = peRama;
         k1yev2.v2arse = peArse;
         k1yev2.v2poco = pePoco;
         setll %kds( k1yev2 : 8 ) ctwev2;
         reade(n) %kds( k1yev2 : 8 ) ctwev2;

         dow not %eof ( ctwev2 );
           PAR314C1 ( v2rama : v1xpro : v2riec : v2xcob : w0mone : v2saco
                    : @@xpri : @@ptco : @@tpcd : @@cls  : @2prem );
           @@prem += @2prem;

           reade(n) %kds( k1yev2 : 8 ) ctwev2;
         enddo;

         @1prem += @@prem;
       endif;


       dou @1prem = @3prem or veces = 10;

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         k1y001.w1rama = peRama;
         chain %kds( k1y001 ) ctw001;

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         k1y001.w1rama = peRama;
         chain %kds( k1y001 ) ctw001c;

         @@prec = *Zeros;
         @@bpep = *Zeros;
         @@bpip = *Zeros;
         @@bpri = *Zeros;

         @@ivat = w1ipr1 + w1ipr3 + w1ipr4;
         @@dere = w1dere;

         @@prim = COWGRAI_getPrimaRamaArse ( peBase :
                                             peNctw :
                                             peRama );

         @@subt = COWGRAI_GetPrimaSubtot ( peBase
                                         : peNctw
                                         : peRama
                                         : @@prim
                                         : @@form );

         if ( t@mar1 = 'D' );
           PRO401U3 ( @1prem : w1prem : @@prec : w1pssn : w1psso : w1pimi
                    : w1seri : w1seem : w1ipr6 : w1ipr2 : w1ipr7 : w1ipr8
                    : w1dere : w1xref : w1xrea : @@bpep : @@prim : @@subt
                    : @@ivat : @@bpip : w1refi : w1read : @@bpri );
         else;
           PRO401U1 ( @1prem : w1prem : @@prec : w1pssn : w1psso : w1pimi
                    : w1seri : w1seem : w1ipr6 : w1ipr2 : w1ipr7 : w1ipr8
                    : @@dere : w1xref : w1xrea : @@bpep : @@prim : @@subt
                    : @@ivat : @@bpip );
         endif;

         update c1w001;
         update c1w001c;

         k1yevc.v0empr = PeBase.peEmpr;
         k1yevc.v0sucu = PeBase.peSucu;
         k1yevc.v0nivt = PeBase.peNivt;
         k1yevc.v0nivc = PeBase.peNivc;
         k1yevc.v0nctw = peNctw;
         k1yevc.v0Rama = peRama;
         k1yevc.v0Arse = peArse;
         k1yevc.v0secu = v1Secu;
         k1yevc.v0acti = v1Acti;
         chain %kds( k1yevc : 9 ) ctwevc;
         if %found( ctwevc );
           v0Seri = w1Seri;
           v0Seem = w1Seem;
           v0Impi = w1Impi;
           v0Sers = w1Sers;
           v0Tssn = w1Tssn;
           v0Ipr1 = w1Ipr1;
           v0Ipr3 = w1Ipr3;
           v0Ipr4 = w1Ipr4;
           v0Ipr6 = w1Ipr6;
           v0Ipr7 = w1Ipr7;
           v0Ipr8 = w1Ipr8;
           v0Ipr9 = w1Ipr9;
           v0Prem = w1Prem;
           update c1wevc;
         endif;

         COWGRAI_getPremioFinal ( peBase : peNctw );

         @3prem = COWGRAI_getPremio( peBase
                                   : peNctw
                                   : peRama
                                   : peArse
                                   : pePoco  );

         veces += 1;

       enddo;

       return *On;

     P COWAPE_planesCerrados...
     P                 E
      * ---------------------------------------------------------------- *
      * COWAPE_cargaActividad(): Carga y retorna actividad para AP       *
      *                                                                  *
      *       peRama  ( input  )  - Rama                                 *
      *       peXpro  ( input  )  - Producto/Plan                        *
      *       peMone  ( input  )  - Moneda                               *
      *       peActi  ( output )  - Estructura de Actividad              *
      *       peActiC ( output )  - Cantidad de Actividad                *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWAPE_cargaActividad...
     P                 b                   export
     D COWAPE_cargaActividad...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peMone                       2    const
     D   peActi                            likeds(Activ_t) dim(99)
     D   peActiC                     10i 0

     D i               s             10i 0
     D x               s             10i 0
     D @@Rama          s              2  0
     D @@Xpro          s              3  0
     D @@Mone          s              2
     D peXcob          ds                  likeds(cobert_t) dim(999)
     D peXcobC         s             10i 0

      /free

       COWAPE_inz();

       i = 0;
       clear peXcob;
       clear peXcobC;

       @@Rama = peRama;
       @@Xpro = peXpro;
       @@Mone = peMone;

       WSLTAB_coberturasPorPlan( @@Rama
                               : @@Xpro
                               : @@Mone
                               : peXcob
                               : peXcobC );

       peActi(1).acti = 999;
       peActi(1).cant = 1;
       peActi(1).Paco = 1;
       peActi(1).Secu = 1;
       peActi(1).Cate = 1;
       peActi(1).Raed = 1;

       for x = 1 to peXcobC;
         i += 1;
         peActi(1).cobe(i).riec = peXcob(x).riec;
         peActi(1).cobe(i).xcob = peXcob(x).xcob;
         peActi(1).cobe(i).sac1 = peXcob(x).saco;
       endfor;

       peActi(1).cobec = peXcobC;
       peActiC = 1;

       return *on;

      /end-free

     P COWAPE_cargaActividad...
     P                 e
