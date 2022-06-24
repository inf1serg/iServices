     H nomain
     H datedit(*DMY/)
     H alwnull(*usrctl)
     H option(*nodebugio : *srcstmt : *nounref)
      * ************************************************************ *
      * APIGRAI: Cotizacion API - Manejo de Datos Generales          *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        19-Jun-2017             *
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
      *> TEXT('Prorama de Servicio: Cotizacion API - General')  <*   *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                           <*   *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((APIGRAI))  <*   *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((APIGRAI))       <*   *
      *> IGN: DLTSPLF FILE(APIGRAI)                             <*   *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 27/12/17 : se modifica envio de email                    *
      *                                                              *
      * ************************************************************ *
     Fset915    uf a e           k disk    usropn
     Fctw00016  if   e           k disk    usropn rename( c1w000 : c1w00016)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/apigrai_h.rpgle'

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
     D   pgmname                     10a   overlay(@PsDs:1)

     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D qCmdExc         pr                  ExtPgm('QCMDEXC')
     D  peCmd                     65535a   const options(*varsize)
     D  peLen                        15  5 const
     D cmd             s            512a

      // Get Cotizacion Web //
     D  COWGRA1        pr                  ExtPgm('COWGRA1')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peMone                       2      const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
     D   peSpo1                       7  0   const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      // Get limites EPV    //
     D  COWGRA9        pr                  ExtPgm('COWGRA9')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peEpvm                        3  0
     D  peEpvx                        3  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)
      *
     D p@Cprc          s             20a   inz('MSJ_ERROR_APIS')
     D p@Sprc          s             20a   inz('GETVALSIS')

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * APIGRAI_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P APIGRAI_inz     B
     D APIGRAI_inz     pi

      /free

       if not %open(set915);
         open set915;
       endif;

       if not %open(ctw00016);
         open ctw00016;
       endif;

       if (initialized);
          return;
       endif;

       initialized = *ON;
       return;

      /end-free

     P APIGRAI_inz     E

      * ------------------------------------------------------------ *
      * APIGRAI_End(): Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P APIGRAI_End     B
     D APIGRAI_End     pi

      /free

       close(E) *all;
       initialized = *OFF;

       return;

      /end-free

     P APIGRAI_End     E

      * ------------------------------------------------------------ *
      * APIGRAI_ERROR():Retorna el último error del servicio.        *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P APIGRAI_Error   B
     D APIGRAI_Error   pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P APIGRAI_Error   E
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
      * APIGRAI_getNroCotizacion: Retorna Nro de Cotizacion Nueva    *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *                                                              *
      * Retorna Nro de Cotizacion                                    *
      * -------------------------------------------------------------*
     p APIGRAI_getNroCotizacion...
     p                 b                   export
     D APIGRAI_getNroCotizacion...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

     D k1y915          ds                  likerec(s1t915:*key)

      /free

       APIGRAI_inz();

       k1y915.t@empr = peEmpr;
       k1y915.t@sucu = peSucu;
       k1y915.t@tnum = 'NA';

       chain %kds( k1y915 : 3 ) set915;
       if %found( set915 );

         //si llego al tope no sigo sumando y retorno ese valor para
         //dar el error.

         if t@nres = 9999999;
           return 0;
         endif;

         t@nres += 1;
         t@user  = @PsDs.CurUsr;
         t@date  = %dec(%date);
         t@time  = %dec(%time);
         update s1t915;

        else;

         t@empr  = peEmpr;
         t@sucu  = peSucu;
         t@tnum  = 'NA';
         t@nres  = 1;
         t@user  = @PsDs.CurUsr;
         t@date  = %dec(%date);
         t@time  = %dec(%time);
         write  s1t915;

       endif;

       return t@nres;

      /end-free

     P APIGRAI_getNroCotizacion...
     P                 E

      * -------------------------------------------------------------*
      * APIGRAI_getNroCotizacionWeb: Retorna Nro de Cotizacion Nueva *
      *                                                              *
      *     peNcta   ( input  ) Nro de Cotizacion API                *
      *     peNivc   ( input  ) Codigo de Intermediario              *
      *     peArcd   ( input  ) Articulo                             *
      *     peMone   ( input  ) Moneda                               *
      *     peTiou   ( input  ) Tipo de Operacion                    *
      *     peStou   ( input  ) Sub-Tipo de Operacion Usuario        *
      *     peStos   ( input  ) Sub-Tipo de Operacion Sistema        *
      *     peSpo1   ( input  ) Poliza Anterior                      *
      *     peErro   ( output ) Indicador de Error                   *
      *     peMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna Nro de Cotizacion WEB                                *
      * -------------------------------------------------------------*
     P APIGRAI_getNroCotizacionWeb...
     P                 B                   export
     D APIGRAI_getNroCotizacionWeb...
     D                 pi             7  0
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peMone                       2    const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D   peSpo1                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@nctw        s              7  0
     D   @@nivc        s             20

      /free

       APIGRAI_INZ();

       // Recupera Parametros Base
       if not APIGRAI_getParamBase( peNivc
                                  : @@base
                                  : peErro
                                  : peMsgs );
         return *zeros;
       endif;

       // Obtiene nro de Cotizacion Web...
       COWGRA1( @@base
              : peArcd
              : peMone
              : peTiou
              : peStou
              : peStos
              : peSpo1
              : @@nctw
              : peErro
              : peMsgs );

       if peErro = -1;
         return *Zeros;
       endif;

        if not APIGRAI_setNroCotizacionAPI( peNivc
                                          : @@nctw
                                          : peNcta
                                          : peErro
                                          : peMsgs );
         return *Zeros;
        endif;

        return @@nctw;
      /end-free
     P APIGRAI_getNroCotizacionWeb...
     P                 E
      * ------------------------------------------------------------ *
      * APIGRAI_getPolizasxPropuesta: Obtener Nro. de Poliza por rama*
      *                               asociado a una Propuesta.      *
      *      peNivc ( input  ) Codigo de Productor                   *
      *      peSoln ( input  ) Nro de Propuesta                      *
      *      pePoli ( output ) Estructura de Poliza ( RAMA/POLIZA )  *
      *      pePoliC( output ) Cantidad de Polizas                   *
      *      peErro ( output ) Indicador de Error                    *
      *      peMsgs ( output ) Estructura de Error                   *
      *      peCest ( output ) Estado de Propuesta ( opcional )      *
      *      peCses ( output ) Sub. Estado         ( opcional )      *
      *      peDest ( output ) Descripcion         ( opcional )      *
      *                                                              *
      * Retorna *On=Propuesta Correcta/*Off=Propuesta Inexistente    *
      * ------------------------------------------------------------ *
     P APIGRAI_getPolizasxPropuesta...
     P                 B                   export
     D APIGRAI_getPolizasxPropuesta...
     D                 pi              n
     D   peNivc                       5  0 const
     D   peSoln                       7  0 const
     D   pePoli                            likeds(spolizas) Dim(100)
     D   pePoliC                     10i 0
     D   peCest                       1  0
     D   peCses                       2  0
     D   peDest                      20
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
      /free

       if not APIGRAI_getParamBase( peNivc : @@base : peErro : peMsgs );
         //error
          return *off;
       endif;

       return COWGRAI_getPolizasxPropuesta( @@base
                                          : peSoln
                                          : pePoli
                                          : pePoliC
                                          : peErro
                                          : peMsgs
                                          : peCest
                                          : peCses
                                          : peDest );

      /end-free
     P APIGRAI_getPolizasxPropuesta...
     P                 E
      * ------------------------------------------------------------ *
      * APIGRAI_getParamBase: Obtiene parametros Base desde nro de   *
      *                       Productor.                             *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peBase   ( output ) Parametros Base                 *
      *          peErro   ( output ) Cod.de Error                    *
      *          peMsgs   ( output ) Estructura de Mensajes          *
      *                                                              *
      * Retorna: *On = Armado Correcto / *off = Armado incorrecto    *
      * ------------------------------------------------------------ *
     P APIGRAI_getParamBase...
     P                 B                   export
     D APIGRAI_getParamBase...
     D                 pi              n
     D   peNivc                       5  0 const
     D   peBase                            likeds( paramBase )
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@cade        s              5  0 dim(9)
     D   @@nivc        s              5  0
     D   @@VALSYS      S            512
     D   @@Cval        s             10a
     D   @@Cmsg        s              7a
     D   @@Msgs        ds                  likeds(paramMsgs)

      /free

       //Empresa...
       if not SVPVLS_getValSys( 'HAPIEMPR':*omit :@@ValSys );
         wrepl = 'Empresa';
         @@Cval = 'HAPIEMPR';
         peErro = -1;
       else;
         peBase.peEmpr = %trim( @@ValSys );
       endif;

       //Sucural...
       if peErro = *zeros;
         if not SVPVLS_getValSys( 'HAPISUCU':*omit :@@ValSys );
           wrepl = 'Sucursal';
           @@Cval = 'HAPISUCU';
           peErro = -1;
         else;
           peBase.peSucu = %trim( @@ValSys );
         endif;
       endif;

       //Cadena de intermediarios...
       if peErro = *zeros;
         if SVPINT_GetCadena( peBase.peEmpr
                            : peBase.peSucu
                            : 1
                            : peNivc
                            : @@cade );
          //error...
           wrepl  = 'Cadena de Intermediarios';
           peErro = -1;
         endif;
       endif;

       //Organizador...
       if peErro = *zeros;
         if not SVPVLS_getValSys( 'HAPIAUNIV3':*omit :@@ValSys );
           //error...
           wrepl  = 'Nivel de Organizador';
           @@Cval = 'HAPIAUNIV3';
           peErro = -1;
         endif;

         if peErro = *Zeros;
           monitor;
             peBase.peNit1 = %int(%trim( @@ValSys ));
           on-error;
             wrepl  = 'Nivel de Organizador';
             peErro = -1;
            //error;
           endmon;
           peBase.peNiv1 = @@cade(3);
         endif;

       endif;

       //Productor...
       if peErro = *zeros;
         if not SVPVLS_getValSys( 'HAPIAUNIV1':*omit :@@ValSys );
           wrepl  = 'Nivel de Productor';
           @@Cval = 'HAPIAUNIV1';
           peErro = -1;
         endif;
       endif;

       if peErro = *zeros;
         monitor;
           peBase.peNivt = %int(%trim( @@ValSys ));
         on-error;
           wrepl  = 'Nivel de Productor';
           peErro = -1;
         endmon;
         peBase.peNivc = peNivc;
       endif;

       if peErro = -1;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'API0003'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         if  @@Cval <> *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : @@Msgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           APIGRAI_sndMail( p@Cprc
                          : p@sprc
                          : @@Msgs.peMsg2
                          : @@Cval
                          : *omit
                          : *omit         );
         endif;
         return *off;
       endif;

       return *on;
      /end-free
     P APIGRAI_getParamBase...
     P                 E
      * ------------------------------------------------------------ *
      * APIGRAI_getCotizacionApixWeb: Obtiene nro de cotizacion API  *
      *                               de un nro de cotiacion WEB     *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peNcta   ( input  ) Nro. de Cotizacion API          *
      *          peErro   ( output ) Cod.de Error                    *
      *          peMsgs   ( output ) Estructura de Mensajes          *
      *                                                              *
      * Retorna: *On = No existe / *off = Existe                     *
      * ------------------------------------------------------------ *
     P APIGRAI_getCotizacionApixWeb...
     P                 B                   export
     D APIGRAI_getCotizacionApixWeb...
     D                 pi             7  0
     D   peNivc                       5  0 const
     D   peNcta                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)

     D   k1y000        ds                  likerec( c1w00016 : *key )
      /free

       if not APIGRAI_getParamBase( peNivc : @@base : peErro : peMsgs );
         //error
          return *zeros;
       endif;
       k1y000.w0empr = @@base.peEmpr;
       k1y000.w0sucu = @@base.peSucu;
       k1y000.w0nivt = @@base.peNivt;
       k1y000.w0nivc = @@base.peNivc;
       k1y000.w0ncta = peNcta;
       chain %kds( k1y000 : 5 ) ctw00016;
       if not %found( ctw00016 );
       //error
       peErro = -1;
       return *zeros;
       endif;

       return w0nctw;

      /end-free
     P APIGRAI_getCotizacionApixWeb...
     P                 E
      * ------------------------------------------------------------ *
      * APIGRAI_getCotizacionWebxApi: Obtiene nro de cotizacion WEB  *
      *                               de un nro de cotiacion API     *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *          peErro   ( output ) Cod.de Error                    *
      *          peMsgs   ( output ) Estructura de Mensajes          *
      *                                                              *
      * Retorna: *On = No existe / *off = Existe                     *
      * ------------------------------------------------------------ *
     P APIGRAI_getCotizacionWebxApi...
     P                 B                   export
     D APIGRAI_getCotizacionWebxApi...
     D                 pi             7  0
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@dsCtw       ds                  likeds(dsctw000_t)

      /free

       if not APIGRAI_getParamBase( peNivc : @@base : peErro : peMsgs );
         //error
         peErro = -1;
         return *zeros;
       endif;
       if not COWGRAI_getCtw000( @@base : peNctw : @@DsCtw );
         //error
         peErro = -1;
         return *zeros;
       endif;

       return @@dsCtw.w0Ncta;

      /end-free
     P APIGRAI_getCotizacionWebxApi...
     P                 E
      * ------------------------------------------------------------ *
      * APIGRAI_setNroCotizacionAPI: Asocia Nro de cotizacion API a  *
      *                              cotizacion WEB                  *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peNctw   ( input  ) Nro. de Cotizacion WEB         *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: *On = Actualizacion OK / *off = Error               *
      * ------------------------------------------------------------ *
     P APIGRAI_setNroCotizacionAPI...
     P                 B                   export
     D APIGRAI_setNroCotizacionAPI...
     D                 pi              n
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peNcta                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@ncta        s              7  0

      /free

       // Recupera Parametros Base
       if not APIGRAI_getParamBase( peNivc
                                  : @@base
                                  : peErro
                                  : peMsgs );
         return *off;
       endif;

       @@ncta = peNcta;
       COWGRAI_updCabecera( @@base
                          : peNctw
                          : peErro
                          : peMsgs
                          : @@ncta
                          : *omit
                          : *omit
                          : *omit  );

       return *on;
      /end-free
     P APIGRAI_setNroCotizacionAPI...
     P                 E

      * ------------------------------------------------------------ *
      * APIGRAI_setCuitIntermediario: Graba CUIT de un intermediario *
      *                                                              *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peCuii   ( input  ) Cuit del Intermediario         *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: PeErro = -1 no gabo / PeErro = ' ' ok               *
      * ------------------------------------------------------------ *
     P APIGRAI_setCuitIntermediario...
     P                 B                   export
     D APIGRAI_setCuitIntermediario...
     D                 pi
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@cuit        s             11
     D   @@nctw        s              7  0
      /free

       APIGRAI_inz();
       clear wrepl;
       // Recupera Parametros Base
       if not APIGRAI_getParamBase( peNivc
                                  : @@base
                                  : peErro
                                  : peMsgs );

         return;
       endif;

       //Valida  cuit del intermediario...
       clear @@cuit;
       @@cuit = svpint_getCuit( @@base.peEmpr
                              : @@base.peSucu
                              : @@base.peNivt
                              : @@base.peNivc );
       if peCuii <> @@cuit;
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

       @@nctw = APIGRAI_getCotizacionApixWeb( peNivc
                                            : peNcta
                                            : peErro
                                            : peMsgs );

       COWGRAI_updCabecera( @@base
                          : @@nctw
                          : peErro
                          : peMsgs
                          : *omit
                          : @@Cuit
                          : *omit
                          : *omit  );
       return;
      /end-free
     P APIGRAI_setCuitIntermediario...
     P                 E

      * ------------------------------------------------------------ *
      * APIGRAI_setSitemaRemoto: Graba Nombre de Sistema Remoto.     *
      *                                                              *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peNsys   ( input  ) Nombre de Sistema Remoto       *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: PeErro = -1 no gabo / PeErro = ' ' ok               *
      * ------------------------------------------------------------ *
     P APIGRAI_setSitemaRemoto...
     P                 B                   export
     D APIGRAI_setSitemaRemoto...
     D                 pi
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peNsys                      20    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@nctw        s              7  0
     D   @@nsys        s             20
      /free

       APIGRAI_inz();

       // Recupera Parametros Base
       if not APIGRAI_getParamBase( peNivc
                                  : @@base
                                  : peErro
                                  : peMsgs );

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

       @@nctw = APIGRAI_getCotizacionApixWeb( peNivc
                                            : peNcta
                                            : peErro
                                            : peMsgs );
       @@nsys = peNsys;
       COWGRAI_updCabecera( @@base
                          : @@nctw
                          : peErro
                          : peMsgs
                          : *omit
                          : *omit
                          : @@nsys
                          : *omit  );
       return;
      /end-free
     P APIGRAI_setSitemaRemoto...
     P                 E

      * ------------------------------------------------------------ *
      * APIGRAI_getCondicionesComerciales: Calcula condiciones       *
      *                                    Comerciales a partir de   *
      *                                    una Comision enviada.-    *
      *                                                              *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peRama   ( input  ) Rama                           *
      *           pePcom   ( input  ) Comision Solicitada            *
      *           peXopr   ( output ) Comision                       *
      *           peXrea   ( output ) Extra Prima Variable           *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: PeErro = -1 Error / PeErro = ' ' ok                 *
      * ------------------------------------------------------------ *
     P APIGRAI_getCondicionesComerciales...
     P                 B                   export
     D APIGRAI_getCondicionesComerciales...
     D                 pi
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 const
     D   pePcom                       5  2 const
     D   peXopr                       5  2
     D   peXrea                       5  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@nctw        s              7  0
     D   @@dife        s              5  2
     D   @1xopr        s              5  2
     D   @1xrea        s              5  2
     D   @@xopr        s              5  2
     D   @@xrea        s              5  2
     D   @@epvm        s              3  0
     D   @@epvx        s              3  0


      /free
       APIGRAI_inz();

       // Recupera Parametros Base
       clear @@base;
       if not APIGRAI_getParamBase( peNivc
                                  : @@base
                                  : peErro
                                  : peMsgs );

         return;
       endif;

       //Cotizacion Web...
       clear @@nctw;
       @@nctw = APIGRAI_getCotizacionApixWeb( peNivc
                                            : peNcta
                                            : peErro
                                            : peMsgs );
       if peErro = -1;
         return;
       endif;

       clear @@dife;
       clear @1xopr;
       clear @1xrea;
       clear @@xopr;
       clear @@xrea;
       clear @@epvm;
       clear @@epvx;
       // Obtener Condiciones Comerciales de un Intermediario...
       COWGRAI_getCondComerciales( @@base
                                 : @@nctw
                                 : peRama
                                 : @1xrea
                                 : @1xopr );

       // Obtener Topes de extra prima variables de un Intermediario...
       COWGRA9( @@base
              : @@nctw
              : peRama
              : @@epvm
              : @@epvx
              : peErro
              : peMsgs );

       if peErro = -1;
         return;
       endif;
       @@epvx *= -1;
       @@dife  = pePcom - @1xopr;
       @@xrea  = @1xrea + @@dife;
       @@dife  = @1xrea - @@xrea;
       if ( @1xopr - @@dife ) < 0 or
          ( @@dife > @@epvm or @@dife < @@epvx );

          peErro = -1;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0129'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          return;
       endif;
       peXopr = PePcom;
       peXrea = @@xrea;
       return;
      /end-free
     P APIGRAI_getCondicionesComerciales...
     P                 E

      * ------------------------------------------------------------ *
      * APIGRAI_sndMail: Envia Mail                                  *
      *                                                              *
      *           peCprc   ( input  ) Proceso                        *
      *           peCspr   ( input  ) SubProceso                     *
      *           peDmsg   ( input  ) Descripción de Mensaje         *
      *           peNcta   ( input  ) Nro. de Cotización API         *
      *           peVapi   ( input  ) Valor Api                      *
      *           peNctw   ( input  ) Nro de cotización              *
      *                                                              *
      * Retorna: PeErro = -1 no envió mail/ PeErro = ' ' envió mail  *
      * ------------------------------------------------------------ *
     P APIGRAI_sndMail...
     P                 B                   export
     D APIGRAI_sndMail...
     D                 pi
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peDmsg                    3000a   const
     D   peVapi                      10a   options(*nopass:*omit)
     D   peNcta                       7  0 options(*nopass:*omit)
     D   peNctw                       7  0 options(*nopass:*omit)

     D num             s              2  0
     D rc              s             10i 0
     D Body            s           5000a
     D Asunto          s            270a   varying
     D tmpBody         s            512a   varying
     D tmpAsu          s             70a   varying
     D Destinat_Nomb   s             50a   dim(100)
     D Destinat_mail   s            256a   dim(100)
     D Destinat_tipo   s             10i 0 dim(100)
     D Dire            ds                  likeds(DireEnt_t)
     D peRprp          ds                  likeds(recprp_t) dim(100)
     D peRemi          ds                  likeds(Remitente_t)
     D @@contMsg       s             30a
     D @@Nctw          s              7a
     D @@Ncta          s              7a

      /free

       APIGRAI_inz();

       clear tmpBody;
       clear tmpAsu;
       rc = MAIL_getFrom( peCprc
                        : peCspr
                        : peRemi );

       rc = MAIL_getReceipt( peCprc
                           : peCspr
                           : peRprp
                           : *ON    );

       for num = 1 to rc;

         Destinat_nomb(num) = peRprp(num).rpnomb;
         Destinat_mail(num) = peRprp(num).rpmail;

         select;
           when peRprp(num).rpma01 = '1';
             Destinat_tipo(num) = MAIL_NORMAL;
           when peRprp(num).rpma01 = '2';
             Destinat_tipo(num) = MAIL_CC;
           when peRprp(num).rpma01 = '3';
             Destinat_tipo(num) = MAIL_CCO;
           other;
             Destinat_tipo(num) = MAIL_NORMAL;
         endsl;

       endfor;

       rc = MAIL_getSubject( peCprc
                           : peCspr
                           : tmpAsu);

       Asunto = %trim(tmpAsu);
       if %parms >= 5 and %addr( peNcta ) <> *Null;
         if peCspr = 'GETVALSIS';
           Asunto  = %trim( Asunto ) + ' en el Nro. Cotización API: %%NCTA%%';
         endif;
         @@Ncta = %editw( peNcta : '     0 ');
         Asunto = %scanrpl( '%%NCTA%%' : %trim( @@ncta ) : Asunto );
       endif;

       rc = MAIL_getbody( peCprc
                        : peCspr
                        : tmpBody );

       body = %trim(tmpBody);

       body = %scanrpl( '%%ERRMSG%%' : %trim(peDmsg)  : body );

       if %parms >= 4 and %addr( peVapi ) <> *Null;
         body = %scanrpl( '%%VALAPIS%%' : %trim (peVapi)   : body );
       endif;

       if %parms >= 6 and %addr( peNctw ) <> *Null;
         @@contMsg = 'El número de cotización es: ';
         body  = %scanrpl( '%%CONTMSG%%' : @@contmsg  : body );
         @@Nctw= %editw( peNctw : '     0 ' );
         body  = %scanrpl( '%%NCTW%%' : %trim( @@Nctw ) : body );
       else;
         @@contMsg = *blanks;
         @@Nctw = *blanks;
         body  = %scanrpl( '%%CONTMSG%%' : @@contmsg  : body );
         body  = %scanrpl( '%%NCTW%%' : @@Nctw : body );
       endif;

       rc = MAIL_SndLmail( peRemi.From
                         : peRemi.Fadr
                         : Asunto
                         : Body
                         : 'H'
                         : Destinat_Nomb
                         : Destinat_mail
                         : Destinat_tipo );

       return;

      /end-free
     P APIGRAI_sndMail...
     P                 E
