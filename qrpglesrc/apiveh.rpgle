     H nomain
     H datedit(*DMY/)
     H alwnull(*usrctl)
     H option(*nodebugio : *srcstmt : *nounref)
      * ************************************************************ *
      * APIVEHI: Cotizacion API de vehiculos                         *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        07-May-2017             *
      *------------------------------------------------------------- *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                           <*   *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                           <*   *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                           <*   *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -             <*   *
      *>           DBGVIEW(&DV)                                 <*   *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                             <*   *
      *>           MODULE(QTEMP/&N) -                           <*   *
      *>           EXPORT(*SRCFILE) -                           <*   *
      *>           SRCFILE(HDIILE/QSRVSRC) -                    <*   *
      *>           BNDDIR(HDIILE/HDIBDIR) -                     <*   *
      *> TEXT('Prorama de Servicio: Cotizacion API - Vehiculos')<*   *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                           <*   *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((APIVEH))   <*   *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((APIVEH))        <*   *
      *> IGN: DLTSPLF FILE(APIVEH)                              <*   *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 27/12/17 : Se modifica el envio de email por Infoauto    *
      * LRG 02/01/18 : Se modifica el pasaje de bonificaciones al    *
      *                recotizar                                     *
      *                                                              *
      * LRG 12/01/18 : Se corrige marca de cobertura seleccionada    *
      *                Si el vehiculo tiene una sola cobertura       *
      *                esta no se esta seleccionando.-               *
      *                                                              *
      * LRG 03/05/18 : Se corrige envío de comisión.-                *
      * LRG 21/05/18 : Se corrige calculo de zona de Riesgo.         *
      * LRG 22/08/18 : Se agrega validacion de condiciones           *
      *                comerciales.-                                 *
      * EXT 26/09/18 : Se modifica rutina de Buen Resultado          *
      *                Se agrega mensaje API0017 y API0018           *
      * EXT 16/01/19 : Se modifica _cotizar por Descuento Especial   *
      * LRG 14/03/19 : Se modifica chkCotizacion, se cambia envío    *
      *                de intermediario por cabecera para validar    *
      *                asociacion con Asegurado                      *
      * JSN 18/10/19 : Se agrega el procedimiento:                   *
      *                _cotizar2                                     *
      *                                                              *
      * ************************************************************ *
      *--- Definicion de Variables --------------------------------- *
     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrN            s             10i 0
     D ErrM            s             80a
     D cmd             s            512a

      *--- Definicion de Estructuras ------------------------------- *

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:402)

     D*Condcome        ds                  qualified based(template)
     D*  rama                         2  0
     D*  xrea                         5  2

      *--- Definicion de Procedimiento ----------------------------- *

     D APIVALSYS       pr
     D  peCval                       10a   const
     D  peVsys                      512a

     D qCmdExc         pr                  ExtPgm('QCMDEXC')
     D  peCmd                     65535a   const options(*varsize)
     D  peLen                        15  5 const

     D COWVEH10        pr                  ExtPgm('COWVEH10')
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
     D   peDesE                       5  2 const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWVEH11        pr                  ExtPgm('COWVEH11')
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
     D   peDesE                       5  2 const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWVEH14        pr                  ExtPgm('COWVEH14')
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
     D   peDesE                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWVEH15        pr                  ExtPgm('COWVEH15')
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
     D   peDesE                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   peCtre                       5  0
     D   pePaxc                            likeds(cobVeh) dim(20)
     D   peBoni                            likeds(bonVeh) dim(99)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DCOWGRA3          pr                  extpgm('COWGRA3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40      const
     D   peCiva                       2  0   const
     D   peTipe                       1      const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCuit                      11a     const
     D   peTido                       1  0   const
     D   peNrdo                       8  0   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWGRA9         pr                  extpgm('COWGRA9')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peEpvm                        3  0
     D  peEpvx                        3  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)
      *
     D COWVEH3         pr                  ExtPgm('COWVEH3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobl                       2    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWGRA8         pr                  extpgm('COWGRA8')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
     D   peCond                            likeds(Condcome) dim(99) const
     D   peCondC                     10i 0 const
     D   peImpu                            likeds(primPrem) dim(99)
     D   peImpuC                     10i 0
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      *
     D p@Cprc          s             20a   inz('MSJ_ERROR_APIS')
     D p@Sprc          s             20a   inz('GETVALSIS')
     D p@Sprc2         s             20a   inz('COTIZACION')
     D ErrCode         s             10i 0
     D ErrText         s             80A

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/apiveh_h.rpgle'

      * ------------------------------------------------------------ *
      * APIVEH_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P APIVEH_inz      B                   export
     D APIVEH_inz      pi

      /free

       if (initialized);
          return;
       endif;

       initialized = *ON;

       return;

      /end-free

     P APIVEH_inz      E

      * ------------------------------------------------------------ *
      * APIVEH_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P APIVEH_end      B                   export
     D APIVEH_end      pi

      /free

       //close *all;
       initialized = *OFF;

       return;

      /end-free

     P APIVEH_End      E

      * ------------------------------------------------------------ *
      * APIVEH_Error(): Retorna el último error del servicio.        *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P APIVEH_Error    B
     D APIVEH_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P APIVEH_Error    E
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

      * -------------------------------------------------------------*
      * APIVEH_cotizar : Cotiza Vehiculo API                         *
      * ********************** Deprecated ************************** *
      *                                                              *
      *          peNcta   ( input  ) Nro. Cotizacion Api             *
      *          peNsys   ( input  ) Nombre del Sistema Remoto       *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peCuii   ( input  ) Cuit del Intermediario          *
      *          peinfo   ( input  ) Codigo de Infoauto              *
      *          peVhan   ( input  ) Año del vehiculo                *
      *          peVhvu   ( input  ) Valor del vehiculo              *
      *          peMgnc   ( input  ) Marca de G.N.C                  *
      *          peRgnc   ( input  ) Valor de G.N.C                  *
      *          peLoca   ( input  ) Localidad                       *
      *          peCfpg   ( input  ) Forma de Pago                   *
      *          peTipe   ( input  ) Tipo de Persona                 *
      *          peCiva   ( input  ) Condicion de I.V.A              *
      *          peTdoc   ( input  ) Tipo de Documento               *
      *          peNdoc   ( input  ) Nro. de Documento               *
      *          peAcce   ( input  ) Estructura de Accesorios        *
      *          pePcom   ( input  ) Porcentaje de Comisión          *
      *          pePbon   ( input  ) Porcentaje de Bonificacion      *
      *          pePreb   ( input  ) Porcentaje de Rebaja            *
      *          pePrec   ( input  ) Porcentaje de Recargo           *
      *          pePaxc   ( output ) Coberturas Prima a Premio       *
      *          pePaxcC  ( output ) Cantidad de Coberturas          *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estructura de Mensaje           *
      *                                                              *
      * Retorna peErro = ' '  Cotizacion Correcta                    *
      *         peErro = '-1' Cotizacion Erronea                     *
      * -------------------------------------------------------------*
     P APIVEH_cotizar...
     P                 B                   Export
     D APIVEH_cotizar...
     D                 pi
     D   peNcta                       7  0 const
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peinfo                       7  0 const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peLoca                       6  0 const
     D   peCfpg                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   peAcce                            likeds(AccVehaAPI_t)dim(10) const
     D   pePcom                       5  2 const
     D   pePbon                       5  2 const
     D   pePreb                       5  2 const
     D   pePrec                       5  2 const
     D   pePaxc                            likeds(CobVehAPI_t) dim(20)
     D   pePaxcC                     10i 0
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@rama        s              2  0
     D   @@arse        s              2  0
     D   @@arcd        s              6  0
     D   @@poco        s              4  0
     D   @@vhmc        s              3
     D   @@vhmo        s              3
     D   @@vhcs        s              3
     D   @@copo        s              5  0
     D   @@cops        s              1  0
     D   @@scta        s              1  0
     D   @@clin        s              1
     D   @@bure        s              1  0
     D   @@acce        ds                  likeds(AccVeh_t) dim(100)
     D   @@ctre        s              5  0
     D   @@paxc        ds                  likeds(cobVeh) dim(20)
     D   @@boni        ds                  likeds(bonVeh) dim(99)
     D   @1boni        ds                  likeds(bonVeh) dim(99)
     D   @@impu        ds                  likeds(Impuesto) dim(99)
     D   @@valsys      S            512
     D   x             S             10i 0
     D   y             S             10i 0
     D   @@cmar        s              9  0
     D   @@cmod        s              9  0
     D   @@cuii        s             11
     D   @@ndoc        s              8  0
     D   @@fech        s              8  0
     D   @@xopr        s              5  2
     D   @@xrea        s              5  2
     D   Recotizar     s               n
     D   Primera       s               n
     D   @@tacce       s             15  2
     D   @@mone        s              2
     D   @@tiou        s              1  0
     D   @@stou        s              2  0
     D   @@stos        s              2  0
     D   @@spo1        s              7  0
     D   BureEspecial  s               n
     D   TieneRecargo  s               n
     D   @@mbon        s              5  2
     D   DsEdesc       ds                  likeds( dsset250_t )
     D   @@bon         s              5  2
     D   @@tot         s              5  2
     D   @@pbon        s              5  2
     D   @@preb        s              5  2
     D   @@prec        s              5  2
     D   @@cobl        s              2
     D   @1cobl        s              2
     D   @@prim        s             15  2
     D   @@prem        s             15  2
     D   @1cond        ds                  likeds(Condcome) dim(99)
     D   @1condC       s             10i 0
     D   @1impu        ds                  likeds(primPrem) dim(99)
     D   @1impuC       s             10i 0
     D   @@ccbp        s              3  0
     D   @@asen        s              7  0
     D   @@nomb        s             40
     D   @@cuit        s             11
     D   @@tdoc        s              1  0
     D   @@vhan        s              4  0
     D   @@Dsiau       ds                  likeds(IAUTOS_t)
     D   @@vhvu        s             15  2
     D   @@dese        s              5  2
     D   @@Vsys        s            512
     D   @@proc        s             20
     D   @@Scor        ds                  likeds(preguntas_t) dim(200)

      /free

       APIVEH_inz();

         clear @@Scor;

         APIVEH_cotizar2( peNcta
                        : peNsys
                        : peNivc
                        : peCuii
                        : *zeros
                        : peinfo
                        : peVhan
                        : peVhvu
                        : peMgnc
                        : peRgnc
                        : peLoca
                        : peCfpg
                        : peTipe
                        : peCiva
                        : peTdoc
                        : peNdoc
                        : peAcce
                        : pePcom
                        : pePbon
                        : pePreb
                        : pePrec
                        : *zeros
                        : @@Scor
                        : pePaxc
                        : pePaxcC
                        : peNctw
                        : peErro
                        : peMsgs  );

       return;
      /end-free

     P APIVEH_cotizar...
     P                 E

      * -------------------------------------------------------------*
      * APIVEH_getValoresDelSistema: Obtener valores del sistema     *
      *                              para APIVEH                     *
      *                                                              *
      *          peNivc   ( input  ) Codigo Intermediario            *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estructura de Mensajes          *
      *          peBase   ( output ) Parametros Base     ( opcional )*
      *          peRama   ( output ) Rama                ( opcional )*
      *          peArse   ( output ) Cant.Ramas x poliza ( opcional )*
      *          peArcd   ( output ) Articulo            ( opcional )*
      *          pePoco   ( output ) Cant. de Componentes( opcional )*
      *          peMone   ( output ) Moneda              ( opcional )*
      *          peTiou   ( output ) Tipo Operacion      ( opcional )*
      *          peStou   ( output ) SubTipo Oper.Usuario( opcional )*
      *          peStos   ( output ) SubTipo Oper.Sistema( opcional )*
      *          peMbon   ( output ) Maximo % de Bonific.( opcional )*
      *                                                              *
      * Retorna peErro = ' '  Devuelve Valor ok                      *
      *         peErro = '-1' Problemas con los valores              *
      * -------------------------------------------------------------*
     P APIVEH_getValoresDelSistema...
     P                 B                   Export
     D APIVEH_getValoresDelSistema...
     D                 pi
     D   peNivc                       5  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds ( paramMsgs )
     D   peBase                            likeds ( paramBase)
     D                                     options( *nopass : *omit )
     D   peRama                       2  0 options( *nopass : *omit )
     D   peArse                       2  0 options( *nopass : *omit )
     D   peArcd                       6  0 options( *nopass : *omit )
     D   pePoco                       4  0 options( *nopass : *omit )
     D   peMone                       2    options( *nopass : *omit )
     D   peTiou                       1  0 options( *nopass : *omit )
     D   peStou                       2  0 options( *nopass : *omit )
     D   peStos                       2  0 options( *nopass : *omit )
     D   peMbon                       5  2 options( *nopass : *omit )

     D   @@valsys      S            512
     D   @@Msgs        ds                  likeds ( paramMsgs )
     D   @@Vapi        s             10a

      /free

      // Parametros Base...
       if %parms >= 1 and %addr(peBase) <> *NULL;
         if not APIGRAI_getParamBase( peNivc
                                    : peBase
                                    : peErro
                                    : peMsgs );
           return;
         endif;
       endif;

      // Rama...
       if %parms >= 2 and %addr(peRama) <> *NULL;
         @@Vapi = 'HAPIAURAMA';
         if not SVPVLS_getValSys( 'HAPIAURAMA':*omit :@@ValSys );
           wrepl = 'Rama';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );

           return;
         endif;
         monitor;
           peRama = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Rama';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endmon;
       endif;

       // Arse...
       if %parms >= 3 and %addr(peArse) <> *NULL;
         @@Vapi = 'HAPIAUARSE';
         if not SVPVLS_getValSys( 'HAPIAUARSE':*omit :@@ValSys );
           wrepl = 'Cant.Polizas por Rama Articulo';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endif;
         monitor;
           peArse = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Cant.Polizas por Rama Articulo';
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           peErro = -1;
           return;
         endmon;
       endif;

       //Articulo...
       if %parms >= 4 and %addr(peArcd) <> *NULL;

         if proceso = 'APIVEH2';
            @@Vapi = 'HAPISCARCD';
         else;
            @@Vapi = 'HAPIAUARCD';
         endif;

         if not SVPVLS_getValSys( 'HAPIAUARCD':*omit :@@ValSys );
           wrepl = 'Artículo';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endif;
         monitor;
           peArcd = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Artículo';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endmon;
       endif;

       // Poco...
       if %parms >= 5 and %addr(pePoco) <> *NULL;
         @@Vapi = 'HAPIAUPOCO';
         if not SVPVLS_getValSys( 'HAPIAUPOCO':*omit :@@ValSys );
           wrepl = 'Numero de Componente';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endif;
         monitor;
           pePoco = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Numero de Componente';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endmon;
       endif;

       //Moneda...
       if %parms >= 6 and %addr(peMone) <> *NULL;
         @@Vapi = 'HAPIAUMONE';
         if not SVPVLS_getValSys( 'HAPIAUMONE':*omit :@@ValSys );
           wrepl = 'Código de Moneda';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endif;
         peMone = %trim( @@ValSys );
       endif;

       //Tipo de Operacion...
       if %parms >= 7 and %addr(peTiou) <> *NULL;
         @@Vapi = 'HAPIAUTIOU';
         if not SVPVLS_getValSys( 'HAPIAUTIOU':*omit :@@ValSys );
           wrepl = 'Tipo de Operación';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endif;
         monitor;
           peTiou = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Tipo de Operación';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endmon;
       endif;

       //Sub-Tipo de Operacion Usuario...
       if %parms >= 8 and %addr(peStou) <> *NULL;
         @@Vapi = 'HAPIAUSTOU';
         if not SVPVLS_getValSys( 'HAPIAUSTOU':*omit :@@ValSys );
           wrepl = 'Sub-Tipo de Operacion Usuario';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
        endif;
         monitor;
           peStou = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Sub-Tipo de Operacion Usuario';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endmon;
       endif;

       //Sub-Tipo de Operacion Sistema...
       if %parms >= 9 and %addr(peStos) <> *NULL;
         @@Vapi = 'HAPIAUSTOS';
         if not SVPVLS_getValSys( 'HAPIAUSTOS':*omit :@@ValSys );
           wrepl = 'Sub-Tipo de Operacion Sistema';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

            APIGRAI_sndMail( p@Cprc
                           : p@Sprc
                           : @@Msgs.peMsg2
                           : @@Vapi
                           : *omit
                           : *omit         );
           return;
         endif;
         monitor;
           peStos = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Sub-Tipo de Operacion Sistema';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

            APIGRAI_sndMail( p@Cprc
                           : p@Sprc
                           : @@Msgs.peMsg2
                           : @@Vapi
                           : *omit
                           : *omit         );
           return;
         endmon;
       endif;

       if %parms >= 10 and %addr(peMbon) <> *NULL;
         @@Vapi = 'HAPIAUMBON';
         if not SVPVLS_getValSys( 'HAPIAUMBON':*omit :@@ValSys );
           wrepl = 'Máximo % de Bonificación';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endif;
         monitor;
           peMbon = %int(%trim( @@ValSys ));
         on-error;
           wrepl = 'Máximo % de Bonificación';
           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@Sprc
                          : @@Msgs.peMsg2
                          : @@Vapi
                          : *omit
                          : *omit         );
           return;
         endmon;
       endif;

       return;
      /end-free
     P APIVEH_getValoresDelSistema...
     P                 e
      * -------------------------------------------------------------*
      * APIVEH_chkCotizacion: Valida datos de entrada para           *
      *                       cotizacion.                            *
      *                                                              *
      *          peNcta   ( input  ) Nro de Cotizacion Api           *
      *          peNsys   ( input  ) Nombre del Sistema Remoto       *
      *          peNivc   ( input  ) Còdigo Intermediario            *
      *          peCuii   ( input  ) Cuit del Intermediario          *
      *          peInfo   ( input  ) Codigo infoauto.                *
      *          peVhan   ( input  ) Año del Vehiculo                *
      *          peTipe   ( input  ) Tipo de persona.                *
      *          peTdoc   ( input  ) Tipo de Documento.              *
      *          peNdoc   ( input  ) Nro de doc/cuit.                *
      *          pePcom   ( input  ) Porcentaje de Comisión          *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estructura de Mensaje           *
      *                                                              *
      * Retorna peErro = ' '  Validacion ok                          *
      *         peErro = '-1' Encontro un error                      *
      * -------------------------------------------------------------*
     P APIVEH_chkCotizacion...
     P                 B
     D APIVEH_chkCotizacion...
     D                 pi
     D   peNcta                       7  0 const
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peInfo                       7  0 const
     D   peVhan                       4    const
     D   peTipe                       1    const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   pePcom                       5  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@cuii        s             11
     D   @@cmar        s              9  0
     D   @@cmod        s              9  0
     D   @@ndoc        s              8  0
     D   @@vhmc        s              3
     D   @@vhmo        s              3
     D   @@vhcs        s              3
     D   @@vhan        s              4  0
     D   @@Dsiau       ds                  likeds(IAUTOS_t)
     D   @@Ncta        s              7  0
     D   @@Msgs        ds                  likeds(paramMsgs)
     D   @@Tdoc        S              2  0
     D   @@Cuit        S             11
     D   @@Cade        S              5  0 dim(9)

      /free
       APIVEH_inz();

       @@Ncta = peNcta;
       if not APIGRAI_getParamBase( peNivc
                                  : @@base
                                  : peErro
                                  : peMsgs );

         return;
       endif;

       //Valida cuit del intermediario...
       clear @@cuii;
       @@cuii = svpint_getCuit( @@base.peEmpr
                              : @@base.peSucu
                              : @@base.peNivt
                              : @@base.peNivc );
       if peCuii <> @@cuii;
         //error...
         %subst( wrepl : 1 : 13 ) = %subst( peCuii : 1  : 2 ) + '-' +
                                    %subst( peCuii : 3  : 8 ) + '-' +
                                    %subst( peCuii : 11 : 1 );

         %subst( wrepl : 14 : 5 ) = %editc( peNivc : 'X');
         %subst( wrepl : 19 : 40) = %trim( SVPINT_GetNombre( @@base.peEmpr
                                                           : @@base.peSucu
                                                           : @@base.peNivt
                                                           : @@base.peNivc));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;
       endif;

       //Valida  nombre del Sistema Remoto...
       if peNsys = *blank;
         wrepl = %trim( peNsys );
         //error...
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0002'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;
       endif;

       // Marca/Modelo IAUTOS...
       clear @@cmar;
       clear @@cmod;
       monitor;
       @@cmar = %int( %subst( %editc( peinfo :'X' ) : 1 : 3 )  );
       @@cmod = %int( %subst( %editc( peinfo :'X')  : 4     )  );
       on-error;
         //wrepl = %editc( peInfo : 'X' );
         clear @@DsIau;
         if SVPIAU_getVehiculo( @@cmar : @@cmod : @@DsIau ) = -1;
            clear @@DsIau;
         endif;
         %subst( wrepl : 1 : 73 ) = 'Marca : ' +
               %trim(%editw( @@cmar : '       0 ' )) +
               ' ' +
               %trim( @@DsIau.i@dmar ) + ' Modelo : '  +
               %trim( %editw( @@cmod : '       0 ' )) +
               ' ' +
               %trim( @@DsIau.i@dmod );

         clear peMsgs;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0004'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         // Enviar mail por error de variable
         clear @@Msgs;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0014'
                      : @@Msgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         APIGRAI_sndMail( p@Cprc
                        : p@sprc2
                        : @@Msgs.peMsg2
                        : *omit
                        : @@Ncta
                        : *omit         );
         peErro = -1;
         return;
       endmon;

       if not SVPIAU_chkVehiculo( @@cmar : @@cmod );
         clear @@DsIau;
         if SVPIAU_getVehiculo( @@cmar : @@cmod : @@DsIau ) = -1;
            clear @@DsIau;
         endif;
         %subst( wrepl : 1 : 73 ) = 'Marca : ' +
               %trim( %editw( @@cmar : '       0 ' )) +
               ' ' +
               %trim( @@DsIau.i@dmar ) + ' Modelo : '  +
               %trim( %editw( @@cmod : '       0 ' )) +
               ' ' +
               %trim( @@DsIau.i@dmod );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0004'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         // Enviar mail por error de variable
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0014'
                      : @@Msgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         APIGRAI_sndMail( p@Cprc
                        : p@sprc2
                        : @@Msgs.peMsg2
                        : *omit
                        : @@Ncta
                        : *omit         );
         peErro = -1;
         return;
       endif;

       // Marca/Modelo WEB...
       if not SVPVAL_chkInfoAutoWeb( @@cmar : @@cmod );
         clear @@DsIau;
         if SVPIAU_getVehiculo( @@cmar : @@cmod : @@DsIau ) = -1;
            clear @@DsIau;
         endif;
         %subst( wrepl : 1 : 73 ) = 'Marca : ' +
               %trim( %editw( @@cmar : '       0 ' )) +
               ' ' +
               %trim( @@DsIau.i@dmar ) + ' Modelo : '  +
               %trim( %editw( @@cmod : '       0 ' )) +
               ' ' +
               %trim( @@DsIau.i@dmod );
         clear peMsgs;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0005'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         // Enviar mail por error de variable
         clear @@Msgs;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0016'
                      : @@Msgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         APIGRAI_sndMail( p@Cprc
                        : p@sprc2
                        : @@Msgs.peMsg2
                        : *omit
                        : @@Ncta
                        : *omit         );
         peErro = -1;
         return;
       endif;

       clear @@vhmc;
       clear @@vhmo;
       clear @@vhcs;

       if CZWUTL_getVehiculoGAU1( @@cmar
                                : @@cmod
                                : @@vhmc
                                : @@vhmo
                                : @@vhcs ) = -1;

         wrepl = %editc( peInfo : 'X' );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0005'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         // Enviar mail por error de variable
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0016'
                      : @@Msgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         APIGRAI_sndMail( p@Cprc
                        : p@sprc2
                        : @@Msgs.peMsg2
                        : *omit
                        : @@Ncta
                        : *omit         );
         peErro = -1;
         return;
       endif;
       //Año del Vehiculo...
       if APIVEH_chk0km( peVhan );
         if not SPVVEH_chkVehiculo0km( @@vhmc
                                     : @@vhmo
                                     : @@vhcs );
           clear @@DsIau;
           if SVPIAU_getVehiculo( @@cmar : @@cmod : @@DsIau ) = -1;
              clear @@DsIau;
           endif;

           %subst( wrepl : 1 : 55 ) = %trim( @@DsIau.i@dmar) + ' ' +
                                      %trim( @@DsIau.i@dmod);
           %subst( wrepl : 56 : 4 ) = peVhan;
           peErro = -1;

           //El vehiculo no puede ser cotizado como 0km...
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0012'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
         endif;
       else;
         monitor;
         @@vhan = %int(peVhan);
         on-error;
         @@vhan = *zeros;
         endmon;
         if not SPVVEH_chkaÑoVehiculo( @@vhmc
                                     : @@vhmo
                                     : @@vhcs
                                     : @@vhan );

           clear @@DsIau;
           if SVPIAU_getVehiculo( @@cmar : @@cmod : @@DsIau ) = -1;
              clear @@DsIau;
           endif;

           %subst( wrepl : 1 : 55 ) = %trim( @@DsIau.i@dmar) + ' ' +
                                      %trim( @@DsIau.i@dmod);
           %subst( wrepl : 56 : 4 ) = peVhan;

           //El vehiculo no puede ser cotizado para el año...
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0012'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
         endif;
       endif;


       //Validacion de Documento...
       if peTdoc = 98;
         //Valida Cuit;
         if peTipe = 'J';
           if peNdoc <= 0;
             wrepl = *blanks;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0006'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
           endif;
           if SVPVAL_CuitCuil ( %editc( peNdoc : 'Z') ) = *off;
             %subst(wrepl:1:11) = %editc( peNdoc : 'X' );
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0009'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
           endif;
         else;
           //Error..
           wrepl = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0010'
                        : peMsgs
                        : %trim(wrepl)
                         : %len(%trim(wrepl))  );
            peErro = -1;
            return;
         endif;
       else;
        if peTipe = 'F';
          //Valida que el número de documento no sea cero;
          if peNdoc <= 0;
            wrepl = *blanks;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PRW0005'
                         : peMsgs
                         : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
           endif;
           //Valida Tipo de Documento...
           if SVPVAL_tipoDeDocumento ( peTdoc ) = *off;
             %subst(wrepl:1:2) = %editc(peTdoc:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0004'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
           endif;
         else;
           //error...
           wrepl = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0011'
                        : peMsgs
                        : %trim(wrepl)
                         : %len(%trim(wrepl))  );
            peErro = -1;
            return;
         endif;
       endif;

       // Valida que el asegurado pueda ser asociado al productor
       clear @@Cade;
       SVPINT_GetCadena( @@base.peEmpr
                       : @@base.peSucu
                       : @@base.peNivt
                       : @@base.peNivc
                       : @@Cade        );
       if peTdoc = 98;
         // Validacion por CUIT
         @@Cuit = %editc( peNdoc : 'X' );
         if not SVPVAL_chkProductorAsegurado( 9
                                            : @@Cade(9)
                                            : *omit
                                            : *omit
                                            : @@Cuit );
           //error...
           wrepl = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0015'
                        : peMsgs
                        : %trim(wrepl)
                         : %len(%trim(wrepl))  );
           peErro = -1;
           return;
         endif;
       else;
         // Validacion por Tipo y Numero de Documento
         @@Tdoc = peTdoc;
         @@Ndoc = peNdoc;
         if not SVPVAL_chkProductorAsegurado( 9
                                            : @@Cade(9)
                                            : @@Tdoc
                                            : @@Ndoc
                                            : *omit     );
           //error...
           wrepl = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0015'
                        : peMsgs
                        : %trim(wrepl)
                         : %len(%trim(wrepl))  );
           peErro = -1;
           return;
         endif;
       endif;
       return;
      /end-free
     P APIVEH_chkCotizacion...
     P                 E
      * ------------------------------------------------------------ *
      * APIVEH_chk0km: Validar si campo de entrada es 0km            *
      *                                                              *
      *          peVhna   ( input  ) Año del Vehículo                *
      *                                                              *
      * Retorna : *on = 0km / *off = No 0km                          *
      * ------------------------------------------------------------ *
     P APIVEH_chk0km   B                   export
     D APIVEH_chk0km   pi              n
     D peVhan                         4    const

      /free

       if %trim(peVhan) = '0km' or %trim(peVhan) = '0Km' or
          %trim(peVhan) = '0KM' or %trim(peVhan) = '0kM';
         return *on;
       endif;

       return *off;

      /end-free
     P APIVEH_chk0km   E

      * ------------------------------------------------------------ *
      * Proceso(): Retorna proceso que realiza la llamada            *
      *                                                              *
      * retorna  Nombre del Proceso invocador                        *
      *          "APIVEH1"    = Cotizador 1203                       *
      *          "APIVEH2"    = Cotizador Scoring                    *
      *          "ERROR"      = Llamada inesperada                   *
      * ------------------------------------------------------------ *
     P proceso         B
     D proceso         pi            20a

	    D QMHRCVPM        PR                  ExtPgm('QMHRCVPM')
	    D   MsgInfo                  32767A   options(*varsize)
	    D   MsgInfoLen                  10I 0 const
	    D   Format                       8A   const
	    D   StackEntry                  10A   const
	    D   StackCount                  10I 0 const
	    D   MsgType                     10A   const
	    D   MsgKey                       4A   const
	    D   WaitTime                    10I 0 const
	    D   MsgAction                   10A   const
	    D   ErrorCode                 8000A   options(*varsize)

	    D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
	    D   MessageID                    7A   const
	    D   QualMsgF                    20A   const
	    D   MsgData                  32767A   const options(*varsize)
	    D   MsgDtaLen                   10I 0 const
	    D   MsgType                     10A   const
	    D   CallStkEnt                  10A   const
	    D   CallStkCnt                  10I 0 const
	    D   MessageKey                   4A
	    D   ErrorCode                 8000A   options(*varsize)

	    D RCVM0200        DS                  qualified
	    D  Receiver             111    120A

	    D ErrorCode       ds                  qualified
	    D   BytesProv                   10I 0 inz(%size(ErrorCode))
	    D   BytesAvail                  10I 0 inz(0)

	    D MsgKey          s              4A
	    D stack_entry     s             10I 0
	    D startCnt        s             10I 0

      /free

       StartCnt = 1;

		     for stack_entry = StartCnt to 50;
		         QMHSNDPM( ''
		           : ''
		           : 'TEST'
		           : %len('TEST')
		           : '*RQS'
		           : '*'
		           : stack_entry
		           : MsgKey
		           : ErrorCode  );

           QMHRCVPM( RCVM0200
                   : %size(RCVM0200)
                   : 'RCVM0200'
                   : '*'
                   : stack_entry
                   : '*RQS'
                   : MsgKey
                   : 0
                   : '*REMOVE'
                   : ErrorCode );
          select;
           when ( RCVM0200.Receiver = 'APIVEH1' );
                return 'APIVEH1';
           when ( RCVM0200.Receiver = 'APIVEH2' );
                return 'APIVEH2';
          endsl;
		      endfor;
                return 'ERROR';
      /end-free

     P proceso         E

      * -------------------------------------------------------------*
      * APIVEH_cotizar2 : Cotiza Vehiculo API                        *
      *                                                              *
      *          peNcta   ( input  ) Nro. Cotizacion Api             *
      *          peNsys   ( input  ) Nombre del Sistema Remoto       *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peCuii   ( input  ) Cuit del Intermediario          *
      *          peArcd   ( input  ) Código de Artículo              *
      *          peinfo   ( input  ) Codigo de Infoauto              *
      *          peVhan   ( input  ) Año del vehiculo                *
      *          peVhvu   ( input  ) Valor del vehiculo              *
      *          peMgnc   ( input  ) Marca de G.N.C                  *
      *          peRgnc   ( input  ) Valor de G.N.C                  *
      *          peLoca   ( input  ) Localidad                       *
      *          peCfpg   ( input  ) Forma de Pago                   *
      *          peTipe   ( input  ) Tipo de Persona                 *
      *          peCiva   ( input  ) Condicion de I.V.A              *
      *          peTdoc   ( input  ) Tipo de Documento               *
      *          peNdoc   ( input  ) Nro. de Documento               *
      *          peAcce   ( input  ) Estructura de Accesorios        *
      *          pePcom   ( input  ) Porcentaje de Comisión          *
      *          pePbon   ( input  ) Porcentaje de Bonificacion      *
      *          pePreb   ( input  ) Porcentaje de Rebaja            *
      *          pePrec   ( input  ) Porcentaje de Recargo           *
      *          peTaaj   ( input  ) Código de Cuestionario          *
      *          peScor   ( input  ) Estructura de Preguntas         *
      *          pePaxc   ( output ) Coberturas Prima a Premio       *
      *          pePaxcC  ( output ) Cantidad de Coberturas          *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estructura de Mensaje           *
      *                                                              *
      * Retorna peErro = ' '  Cotizacion Correcta                    *
      *         peErro = '-1' Cotizacion Erronea                     *
      * -------------------------------------------------------------*
     P APIVEH_cotizar2...
     P                 B                   Export
     D APIVEH_cotizar2...
     D                 pi
     D   peNcta                       7  0 const
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peArcd                       6  0 const
     D   peinfo                       7  0 const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peLoca                       6  0 const
     D   peCfpg                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   peAcce                            likeds(AccVehaAPI_t)dim(10) const
     D   pePcom                       5  2 const
     D   pePbon                       5  2 const
     D   pePreb                       5  2 const
     D   pePrec                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   pePaxc                            likeds(CobVehAPI_t) dim(20)
     D   pePaxcC                     10i 0
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@rama        s              2  0
     D   @@Arcd        s              6  0
     D   @@arse        s              2  0
     D   @@poco        s              4  0
     D   @@vhmc        s              3
     D   @@vhmo        s              3
     D   @@vhcs        s              3
     D   @@copo        s              5  0
     D   @@cops        s              1  0
     D   @@scta        s              1  0
     D   @@clin        s              1
     D   @@bure        s              1  0
     D   @@acce        ds                  likeds(AccVeh_t) dim(100)
     D   @@ctre        s              5  0
     D   @@paxc        ds                  likeds(cobVeh) dim(20)
     D   @@boni        ds                  likeds(bonVeh) dim(99)
     D   @1boni        ds                  likeds(bonVeh) dim(99)
     D   @@impu        ds                  likeds(Impuesto) dim(99)
     D   @@valsys      S            512
     D   x             S             10i 0
     D   y             S             10i 0
     D   @@cmar        s              9  0
     D   @@cmod        s              9  0
     D   @@cuii        s             11
     D   @@ndoc        s              8  0
     D   @@fech        s              8  0
     D   @@xopr        s              5  2
     D   @@xrea        s              5  2
     D   Recotizar     s               n
     D   Primera       s               n
     D   @@tacce       s             15  2
     D   @@mone        s              2
     D   @@tiou        s              1  0
     D   @@stou        s              2  0
     D   @@stos        s              2  0
     D   @@spo1        s              7  0
     D   BureEspecial  s               n
     D   TieneRecargo  s               n
     D   @@mbon        s              5  2
     D   DsEdesc       ds                  likeds( dsset250_t )
     D   @@bon         s              5  2
     D   @@tot         s              5  2
     D   @@pbon        s              5  2
     D   @@preb        s              5  2
     D   @@prec        s              5  2
     D   @@cobl        s              2
     D   @1cobl        s              2
     D   @@prim        s             15  2
     D   @@prem        s             15  2
     D   @1cond        ds                  likeds(Condcome) dim(99)
     D   @1condC       s             10i 0
     D   @1impu        ds                  likeds(primPrem) dim(99)
     D   @1impuC       s             10i 0
     D   @@ccbp        s              3  0
     D   @@asen        s              7  0
     D   @@nomb        s             40
     D   @@cuit        s             11
     D   @@tdoc        s              1  0
     D   @@vhan        s              4  0
     D   @@Dsiau       ds                  likeds(IAUTOS_t)
     D   @@vhvu        s             15  2
     D   @@dese        s              5  2
     D   @@Vsys        s            512
     D   @@proc        s             20

      /free

       APIVEH_inz();
       // Paso 1 - Obtener Valores del Sistema...
       clear @@base;
       clear @@rama;
       clear @@arcd;
       clear @@arse;
       clear @@poco;
       clear @@mone;
       clear @@tiou;
       clear @@stou;
       clear @@stos;
       clear @@mbon;
       clear @@ndoc;
       Recotizar = *off;

       APIVEH_getValoresDelSistema( peNivc
                                  : peErro
                                  : peMsgs
                                  : @@base
                                  : @@rama
                                  : @@arse
                                  : @@arcd
                                  : @@poco
                                  : @@mone
                                  : @@tiou
                                  : @@stou
                                  : @@stos
                                  : @@mbon );

       if peErro = -1;
         return;
       endif;

       if peArcd <> *zeros;
         @@Arcd = peArcd;
       endif;

       // Paso 2 - Obtener Nro. de Cotizacion WEB...
       peNctw = APIGRAI_getNroCotizacionWeb( peNcta
                                           : peNivc
                                           : @@Arcd
                                           : @@mone
                                           : @@tiou
                                           : @@stou
                                           : @@stos
                                           : @@spo1
                                           : peErro
                                           : peMsgs );

       if peErro = -1;
         return;
       endif;

       // Guarda cuit del intermediario...
       APIGRAI_setCuitIntermediario( peNcta
                                   : peNivc
                                   : peCuii
                                   : peErro
                                   : peMsgs );
       if peErro = -1;
         return;
       endif;

       // Guarda nombre de sistema remoto...
       APIGRAI_setSitemaRemoto( peNcta
                              : peNivc
                              : peNsys
                              : peErro
                              : peMsgs );
       if peErro = -1;
         return;
       endif;

       // Paso 3 - Validar Datos de Entrada...
       APIVEH_chkCotizacion( peNcta
                           : peNsys
                           : peNivc
                           : peCuii
                           : peInfo
                           : peVhan
                           : peTipe
                           : peTdoc
                           : peNdoc
                           : pePcom
                           : peErro
                           : peMsgs );

       if peErro = -1;
         return;
       endif;

       // ...... - Obtener Datos para Llamada a Cotizacion WEB...

       @@cmar = %int( %subst( %editc( peinfo :'X' ) : 1 : 3 )  );
       @@cmod = %int( %subst( %editc( peinfo :'X')  : 4     )  );
       clear @@vhmc;
       clear @@vhmo;
       clear @@vhcs;
       if CZWUTL_getVehiculoGAU1( @@cmar
                                : @@cmod
                                : @@vhmc
                                : @@vhmo
                                : @@vhcs ) = -1;

       endif;

       // Localidad...
       @@copo = %int( %subst( %editc( peLoca : 'X' ) : 1 : 5 ) );
       @@cops = %int( %subst( %editc( peLoca : 'X' ) : 6     ) );
       if SVPVAL_codigoPostal ( @@copo : @@cops ) = *off;
         ErrText = SVPVAL_Error(ErrCode);
         if SVPVAL_COPNE = ErrCode;
           %subst(wrepl:1:5) = %editc(@@copo:'X');
           %subst(wrepl:6:1) = %editc(@@cops:'X');
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0013'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
         endif;
         return;
       endif;

       // Zona... @@scta...
       @@scta = COWVEH_codigoZona( @@copo
                                 : @@cops);

       // Accesorios...
       clear @@acce;
       clear @@tacce;
       x = 1;
       dow peAcce(x).desc <> *blanks;
         @@acce(x).secu = x;
         @@acce(x).accd = %trim( peAcce(x).desc );
         @@acce(x).accv = peAcce(x).valor ;
         @@acce(x).mar1 = '0';
         @@tacce += @@acce(x).accv;
         x += 1;
       enddo;

       // Validar Bonificaciones y Recargos
       //Verificar si intermediario tiene buen resultado especial...
       BureEspecial = *off;
       if @@tiou = 1;
         BureEspecial = SVPBUE_chkProductorEspecial( @@base.peEmpr
                                                   : @@base.peSucu
                                                   : @@base.peNivt
                                                   : @@base.peNivc );
       endif;

       // Valida maximo % de descuento que se puede aplicar...
       @@pbon = pePbon;
       @@preb = pePreb;
       @@prec = pePrec;
       clear @@bure;
       clear @@clin;
       clear @@bon;
       clear @@tot;
       @@bon = @@pbon + @@preb;
       TieneRecargo = *off;
       if @@prec > 0;//tengo un recargo...
         if not SVPDAU_getDescxEquivalente( @@base.peEmpr
                                          : @@base.peSucu
                                          : @@arcd
                                          : @@rama
                                          : 'AUD'
                                          : 'C'
                                          : DsEdesc          );
           //no se encontro recargo...
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0006'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
         endif;

         if @@prec < DsEdesc.steppd or @@prec > DsEdesc.stepph;
           //error... recargo supera limites parametrizados...
           wrepl = %editw( DsEdesc.stepph :' 0 ,  ') + '%';
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0007'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
         endif;
         // mover a DESC/REC COMERCIAL...
         @@ccbp       = DsEdesc.stccbp;
         TieneRecargo = *on;
       endif;

       //tengo un descuento...
       if @@preb - 5 > 0 and @@preb <> 0;
         if @@pbon = 0;
           @@preb = 5;
           @@pbon = @@preb - 5;
         endif;
       endif;

       if @@pbon <> *zeros; // si se envió directamente Buen Resultado...
         if @@tiou = 1 and not BureEspecial;
           // error...el intermediario no puede aplicar Buen Resultado...
           %subst( wrepl : 1 : 1 ) = %editc( @@base.peNivt : 'X');
           %subst( wrepl : 2 : 6 ) = %editc( @@base.peNivc : 'X');
           %subst( wrepl : 7 : 40) = %trim( SVPINT_GetNombre( @@base.peEmpr
                                                            : @@base.peSucu
                                                            : @@base.peNivt
                                                            : @@base.peNivc));


           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro  = -1;
           return;
         endif;
         select;
           when @@pbon = 0;
             @@bure = 0;
           when @@pbon = 10;
             @@bure = 1;
           when @@pbon = 15;
             @@bure = 2;
           when @@pbon = 20;
             @@bure = 3;
           other;
             if @@pbon = 5;
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'API0018'
                            : peMsgs );
               peErro = -1;
               return;
             endif;
         endsl;

       endif;

       Select;
         when @@preb = 0;
           @@clin = 'N';
         when @@preb = 5;
           @@clin = 'S';
         other;
           //error...Se envió % de descuento incompatible...
           wrepl = %char( @@preb );
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0017'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
       endsl;

       if @@bon > @@mbon;
         //error...
         wrepl = ' 25,00%';
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0009'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;
       endif;

       // Validar Descuento Especial y Buen Resultado
       SVPVLS_getValSys( 'HAPIDESWEB' : *Omit : @@Vsys );
       if ( @@Vsys = 'N' );
         @@dese = *Zeros;
       else;
         @@bure = *Zeros;
       endif;


       // Valida Topes EPV...
       clear @@xopr;
       clear @@xrea;
       APIGRAI_getCondicionesComerciales( peNcta
                                        : peNivc
                                        : @@rama
                                        : pePcom
                                        : @@xopr
                                        : @@xrea
                                        : peErro
                                        : peMsgs );

       if peErro = -1;
         return;
       endif;

       // Paso 4 - Cotizacion WEB...
       clear @@ctre;
       clear @@paxc;
       clear pePaxcC;
       clear @@boni;
       clear @@impu;
       @@vhvu = peVhvu + peRgnc + @@tacce;
       COWVEH14( @@base
               : peNctw
               : @@rama
               : @@arse
               : @@poco
               : peVhan
               : @@vhmc
               : @@vhmo
               : @@vhcs
               : @@vhvu
               : peMgnc
               : peRgnc
               : @@copo
               : @@cops
               : @@scta
               : @@clin
               : @@bure
               : peCfpg
               : peTipe
               : peCiva
               : @@acce
               : @@dese
               : peTaaj
               : peScor
               : @@ctre
               : @@paxc
               : @@boni
               : @@impu
               : peErro
               : peMsgs  );

       if peErro = -1;
         return;
       endif;

       clear y;
       clear @@cobl;
       x = 1;
         dow @@paxc(x).cobl <> *blanks;
           y += 1;
           pePaxc(x).cobl = @@paxc(x).cobl;
           pePaxc(x).cobd = @@paxc(x).cobd;
           pePaxc(x).rast = @@paxc(x).rast;
           pePaxc(x).insp = @@paxc(x).insp;
           pePaxc(x).prim = @@paxc(x).prim;
           pePaxc(x).prem = @@paxc(x).prem;
           pePaxc(x).ifra = @@paxc(x).ifra;
           pePaxc(x).rcle = @@paxc(x).rcle;
           pePaxc(x).rcco = @@paxc(x).rcco;
           pePaxc(x).rcac = @@paxc(x).rcac;
           pePaxc(x).lrce = @@paxc(x).lrce;
           pePaxc(x).claj = @@paxc(x).claj;
           pePaxc(x).vase = @@vhvu;
           if pePaxc(x).cobl = 'A';
             pePaxc(x).vase = *Zeros;
           endif;
           pePaxc(x).dere = @@impu(x).dere;
           //pePaxc(x).epva = @@paxc(x).prim * @@impu(x).xrea;
           pePaxc(x).epva = @@impu(x).read;
           pePaxc(x).read = @@impu(x).refi;
           pePaxc(x).impu = @@impu(x).impi + @@impu(x).sers +
                            @@impu(x).tssn + @@impu(x).ipr1 +
                            @@impu(x).ipr3 + @@impu(x).ipr4 +
                            @@impu(x).ipr6 + @@impu(x).seri;
           pePaxc(x).copr = @@impu(x).copr;
           if @@paxc(x).cdft = 'S';
             @@cobl = @@paxc(x).cobl;
           endif;
           x += 1;
         enddo;
         pePaxcC = y;
         // Se aplica seleccion de Cobertura...
         COWVEH3( @@base
                : peNctw
                : @@rama
                : @@arse
                : @@poco
                : @@cobl
                : peErro
                : peMsgs );

       // Se Impacta en Tablas impuestos Gaus...
       clear @@prim;
       clear @@prem;
       clear @1cond;
       clear @1impu;
       clear @1impuc;
       @1cond(1).rama = @@rama;
       @1cond(1).xrea = @@xrea;
       @1condc = 1;
       COWGRA8( @@base
              : peNctw
              : peCfpg
              : @1cond
              : @1condC
              : @1impu
              : @1impuC
              : @@prem
              : peErro
              : peMsgs );

       //Si comision es diferente a la inicial...Recotizar.-
       if @@impu(1).xopr <> @@xopr;
         for x = 1 to 99;
           if @@impu(x).cobl <> *blank;
              @@impu(x).xopr = @@xopr;
              @@impu(x).xrea = @@xrea;
           endif;
         endfor;
         recotizar = *on;
       endif;

       if TieneRecargo;
         clear @@cobl;
         clear @1cobl;
         clear @1boni;
         clear y;
         primera = *on;
         for x = 1 to 99;
           if @@boni(x).cobl <> *blanks;
             if primera;
               @@cobl = @@boni(x).cobl;
               @1cobl = @@boni(x).cobl;
               primera = *off;
             endif;
             y +=1;
             if @@cobl = @@boni(x).cobl;
               @1boni(y) = @@boni(x);
             else;
               @1boni(y).cobl = @1cobl;
               @1boni(y).ccbp = DsEdesc.stccbp;
               @1boni(y).dcbp = DsEdesc.stdcbp;
               @1boni(y).pcbp = pePrec;
               @1boni(y).pcbm = DsEdesc.stEppd;
               @1boni(y).pcbx = DsEdesc.stEpph;
               @1boni(y).modi = DsEdesc.stmar6;
               @1cobl = @@boni(x).cobl;
               y +=1;
               @1boni(y) = @@boni(x);
             endif;
             @@cobl = @@boni(x).cobl;
           endif;
         endfor;
         @@boni = @1boni;
         Recotizar = *on;
       endif;

       if Recotizar;
         COWVEH15( @@base
                 : peNctw
                 : @@rama
                 : @@arse
                 : @@poco
                 : peVhan
                 : @@vhmc
                 : @@vhmo
                 : @@vhcs
                 : @@vhvu
                 : peMgnc
                 : peRgnc
                 : @@copo
                 : @@cops
                 : @@scta
                 : @@clin
                 : @@bure
                 : peCfpg
                 : peTipe
                 : peCiva
                 : @@acce
                 : @@dese
                 : peTaaj
                 : peScor
                 : @@ctre
                 : @@paxc
                 : @@boni
                 : @@impu
                 : peErro
                 : peMsgs  );

         if peErro = -1;
           return;
         endif;

         clear y;
         clear @@cobl;
         x = 1;
         dow @@paxc(x).cobl <> *blanks;
           y += 1;
           pePaxc(x).cobl = @@paxc(x).cobl;
           pePaxc(x).cobd = @@paxc(x).cobd;
           pePaxc(x).rast = @@paxc(x).rast;
           pePaxc(x).insp = @@paxc(x).insp;
           pePaxc(x).prim = @@paxc(x).prim;
           pePaxc(x).prem = @@paxc(x).prem;
           pePaxc(x).ifra = @@paxc(x).ifra;
           pePaxc(x).rcle = @@paxc(x).rcle;
           pePaxc(x).rcco = @@paxc(x).rcco;
           pePaxc(x).rcac = @@paxc(x).rcac;
           pePaxc(x).lrce = @@paxc(x).lrce;
           pePaxc(x).claj = @@paxc(x).claj;
           pePaxc(x).vase = @@vhvu;
           if pePaxc(x).cobl = 'A';
             pePaxc(x).vase = *Zeros;
           endif;
           pePaxc(x).dere = @@impu(x).dere;
           //pePaxc(x).epva = @@paxc(x).prim * @@impu(x).xrea;
           pePaxc(x).epva = @@impu(x).read;
           pePaxc(x).read = @@impu(x).refi;
           pePaxc(x).impu = @@impu(x).impi + @@impu(x).sers +
                            @@impu(x).tssn + @@impu(x).ipr1 +
                            @@impu(x).ipr3 + @@impu(x).ipr4 +
                            @@impu(x).ipr6 + @@impu(x).seri;
           pePaxc(x).copr = @@impu(x).copr;
           x += 1;
           if @@paxc(x).cdft = 'S';
             @@cobl = @@paxc(x).cobl;
           endif;
         enddo;
         pePaxcC = y;
         // Se aplica seleccion de Cobertura...
         COWVEH3( @@base
                : peNctw
                : @@rama
                : @@arse
                : @@poco
                : @@cobl
                : peErro
                : peMsgs );

       // Se Impacta en Tablas impuestos Gaus...
       clear @@prim;
       clear @@prem;
       clear @1cond;
       clear @1impu;
       clear @1impuc;
       @1cond(1).rama = @@rama;
       @1cond(1).xrea = @@xrea;
       @1condc = 1;
       COWGRA8( @@base
              : peNctw
              : peCfpg
              : @1cond
              : @1condC
              : @1impu
              : @1impuC
              : @@prem
              : peErro
              : peMsgs );
       endif;

       if peErro = *zeros;
         clear @@ndoc;
         clear @@cuit;
         @@nomb  = '** API Vehiculos **';
         if peTdoc = 98;
           @@cuit = %editc( peNdoc : 'X' );
           @@asen = SVPDAF_getAseguradoxCuit( @@cuit );
           @@nomb = SVPDAF_getNombre( @@asen );
           clear @@tdoc;
         else;
           @@ndoc = peNdoc;
           @@asen = SVPDAF_getAseguradoxDoc( peTdoc
                                           : @@ndoc );
           @@nomb = SVPDAF_getNombre( @@asen );
           @@tdoc = peTdoc;
         endif;
         if @@nomb = *blanks;
           @@nomb  = '** API Vehiculos **';
         endif;
         // Guarda Cotización...
         COWGRA3( @@base
                : peNctw
                : @@asen
                : @@nomb
                : peCiva
                : peTipe
                : @@copo
                : @@cops
                : @@cuit
                : @@tdoc
                : @@ndoc
                : peErro
                : peMsgs );
       endif;
       return;
      /end-free

     P APIVEH_cotizar2...
     P                 E

