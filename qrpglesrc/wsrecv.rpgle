
     H option(*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR') debug(*yes)

      * ************************************************************ *
      * WSRECV: Endoso Poliza Vehiculos: Patente - Chasis - Motor    *
      *         RM#03835 Desarrollo Servicio REST WSRECV             *
      * ------------------------------------------------------------ *
      * Gio Nicolini                                   * 21-Mar-2019 *
      * ------------------------------------------------------------ *
      *                                                              *
      * Request:                                                     *
      * --------                                                     *
      *                                                              *
      * <cambioDatosVehiculos>                                       *
      *   <base>                                                     *
      *     <empr></empr>                                            *
      *     <sucu></sucu>                                            *
      *     <nivt></nivt>                                            *
      *     <nivc></nivc>                                            *
      *     <nit1></nit1>                                            *
      *     <niv1></niv1>                                            *
      *   </base>                                                    *
      *   <usuario></usuario>                                        *
      *   <articulo></articulo>                                      *
      *   <superpoliza></superpoliza>                                *
      *   <rama></rama>                                              *
      *   <arse></arse>                                              *
      *   <nroOperacion></nroOperacion>                              *
      *   <nroPoliza></nroPoliza>                                    *
      *   <vehiculos>                                                *
      *     <vehiculo>                                               *
      *       <nroComponente></nroComponente>                        *
      *       <patente></patente>                                    *
      *       <chasis></chasis>                                      *
      *       <motor></motor>                                        *
      *       <sumaAsegurada></sumaAsegurada>                        *
      *     </vehiculo>                                              *
      *   </vehiculos>                                               *
      * </cambioDatosVehiculos>                                      *
      *                                                              *
      * Response:                                                    *
      * ---------                                                    *
      *                                                              *
      * <cambioDatosVehiculos>                                       *
      *   <nroCotizacion></nroCotizacion>                            *
      *   <nroSolicitud></nroSolicitud>                              *
      * </cambioDatosVehiculos>                                      *
      *                                                              *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'

     d psds           sds                  qualified
     d  this                         10a   overlay(psds:1)
     d  job                          26a   overlay(psds:244)
     d  CurUsr                       10a   overlay(PsDs:358)

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

     d PRWSND4         pr                  ExtPgm('PRWSND4')
     d  peBase                             likeds(paramBase)       const
     d  peNctw                        7  0                         const
     d  peFdes                        8  0                         const
     d  peNuse                       50                            const
     d  peFhas                        8  0
     d  peSoln                        7  0
     d  peError                      10i 0
     d  peMsgs                             likeds(paramMsgs)

     d dsPahet0      e ds                  extname(pahet0)

      * Parámetros de URL
     d buffer          s          65535a
     d rc              s             10i 0
     d peValu          s           1024a

     d cambioDatosVehiculos_t...
     d                 ds                  qualified based(template)
     d  base                               likeds(base_t)
     d  usuario                      50
     d  articulo                           like(t0arcd)
     d  superpoliza                        like(t0spol)
     d  rama                               like(t0rama)
     d  arse                               like(t0arse)
     d  nroOperacion                       like(t0oper)
     d  nroPoliza                          like(t0poli)
     d  vehiculos                          likeds(vehiculo_t)

     d base_t          ds                  qualified based(template)
     d  empr                          1a
     d  sucu                          2a
     d  nivt                          1  0
     d  nivc                          5  0
     d  nit1                          1  0
     d  niv1                          5  0

     d vehiculo_t      ds                  qualified based(template)
     d  vehiculo                           likeds(vehi_t) dim(999)

     d cambioDatosVehiculos...
     d                 ds                  likeds(cambioDatosVehiculos_t) inz

     d options         s            100a

     d @@Base          ds                  likeds(paramBase)
     d @@Usuario       s             50
     d @@Articulo      s                   like(t0arcd)
     d @@Superpoliza   s                   like(t0spol)
     d @@Rama          s                   like(t0rama)
     d @@Arse          s                   like(t0arse)
     d @@NroOperacion  s                   like(t0oper)
     d @@NroPoliza     s                   like(t0poli)
     d @@Vehiculo      ds                  likeds(vehi_t) dim(999)
     d @@VehiculoC     s             10i 0
     d @@NroCotizacion...
     d                 s              7  0
     d @@NroSolicitud  s              7  0
     d @@Error         s             10i 0
     d @@Msgs          ds                  likeds(paramMsgs)
     d @@repl          s          65535a
     d @@ChgVal        s               n

     d @@NroComponente...
     d                 s                   like(t0poco)
     d @@Patente       s                   like(t0nmat)
     d @@Chasis        s                   like(t0chas)
     d @@Motor         s                   like(t0moto)
     d @@SumaAsegurada...
     d                 s                   like(t0vhvu)

     d @@Iidx          s              4  0
     d @@VigFecDes     s              8  0
     d @@VigFecHas     s              8  0

     d UPPER           c                   'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ'
     d LOWER           c                   'abcdefghijklmnñopqrstuvwxyz'

      /free

        *inlr = *on;

        options = 'doc=string path=cambioDatosVehiculos +
                   case=any allowextra=yes allowmissing=yes';

        REST_getEnvVar('REQUEST_METHOD':peValu);

        if %trim(peValu) <> 'POST';
           REST_writeHeader( 405
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit  );
           REST_end();
           SVPREST_end();
           return;
        endif;

        rc = REST_readStdInput( %addr(buffer): %len(buffer) );

        clear cambioDatosVehiculos.vehiculos.vehiculo;

        monitor;
          xml-into cambioDatosVehiculos %xml(buffer : options);
        on-error;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : 'RPG0000'
                          : 40
                          : 'Se encontro un error en el requerimiento'
                          : 'Comunicarse con SISTEMAS' );
          REST_end();
          SVPREST_end();
          return;
        endmon;

        @@Base.peEmpr = cambioDatosVehiculos.base.empr;
        @@Base.peSucu = cambioDatosVehiculos.base.sucu;

        @@Usuario = %trim(cambioDatosVehiculos.usuario);

        monitor;
          @@Base.peNivt = cambioDatosVehiculos.base.nivt;
        on-error;
          @@Base.peNivt = 0;
        endmon;

        monitor;
          @@Base.peNivc = cambioDatosVehiculos.base.nivc;
        on-error;
          @@Base.peNivc = 0;
        endmon;

        monitor;
          @@Base.peNit1 = cambioDatosVehiculos.base.nit1;
        on-error;
          @@Base.peNit1 = 0;
        endmon;

        monitor;
          @@Base.peNiv1 = cambioDatosVehiculos.base.niv1;
        on-error;
          @@Base.peNiv1 = 0;
        endmon;

        monitor;
          @@Articulo = cambioDatosVehiculos.articulo;
        on-error;
          @@Articulo = 0;
        endmon;

        monitor;
          @@Superpoliza = cambioDatosVehiculos.superpoliza;
        on-error;
          @@Superpoliza = 0;
        endmon;

        monitor;
          @@Rama = cambioDatosVehiculos.rama;
        on-error;
          @@Rama = 0;
        endmon;

        monitor;
          @@Arse = cambioDatosVehiculos.arse;
        on-error;
          @@Arse = 0;
        endmon;

        monitor;
          @@NroOperacion = cambioDatosVehiculos.nroOperacion;
        on-error;
          @@NroOperacion = 0;
        endmon;

        monitor;
          @@NroPoliza = cambioDatosVehiculos.nroPoliza;
        on-error;
          @@NroPoliza = 0;
        endmon;

        in lda;
        lda.empr = @@Base.peEmpr;
        lda.sucu = @@Base.peSucu;
        out lda;

        // Valida Parametros de Base
        if not SVPREST_chkBase( @@Base.peEmpr
                              : @@Base.peSucu
                              : %editc(@@Base.peNivt:'X')
                              : %editc(@@Base.peNivc:'X')
                              : %editc(@@Base.peNit1:'X')
                              : %editc(@@Base.peNiv1:'X')
                              : @@Msgs );

          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : @@Msgs.peMsid
                          : @@Msgs.peMsev
                          : @@Msgs.peMsg1
                          : @@Msgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;

        endif;


        // Carga array de componenentes
        clear @@Vehiculo;
        clear @@VehiculoC;
        for @@Iidx = 1 to 999;

          monitor;
            @@NroComponente =
                  cambioDatosVehiculos.vehiculos.vehiculo(@@Iidx).nroComponente;
          on-error;
            @@NroComponente = 0;
          endmon;

          if @@NroComponente = 0;
            leave;
          endif;

          @@Patente =
                 %trim(cambioDatosVehiculos.vehiculos.vehiculo(@@Iidx).patente);
          @@Chasis =
                  %trim(cambioDatosVehiculos.vehiculos.vehiculo(@@Iidx).chasis);
          @@Motor =
                   %trim(cambioDatosVehiculos.vehiculos.vehiculo(@@Iidx).motor);

          @@Patente = %xlate( LOWER : UPPER : @@Patente );
          @@Chasis = %xlate( LOWER : UPPER : @@Chasis );
          @@Motor = %xlate( LOWER : UPPER : @@Motor );

          monitor;
            @@SumaAsegurada =
                  cambioDatosVehiculos.vehiculos.vehiculo(@@Iidx).sumaAsegurada;
          on-error;
            @@SumaAsegurada = 0;
          endmon;

          @@Vehiculo(@@Iidx).nroComponente = @@NroComponente;
          @@Vehiculo(@@Iidx).patente = @@Patente;
          @@Vehiculo(@@Iidx).chasis = @@Chasis;
          @@Vehiculo(@@Iidx).motor = @@Motor;
          @@Vehiculo(@@Iidx).sumaAsegurada = @@SumaAsegurada;
          @@VehiculoC += 1;

        endfor;

        // Llegó al menos un componente
        if @@VehiculoC = 0;
          clear @@repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SND0003'
                       : @@Msgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SND0003'
                          : @@Msgs.peMsev
                          : @@Msgs.peMsg1
                          : @@Msgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida poliza
        clear @@Error;
        clear @@Msgs;
        if not COWVEH_chkEndosoPoliza( @@Base
                                     : @@Usuario
                                     : @@Articulo
                                     : @@Superpoliza
                                     : @@Rama
                                     : @@Arse
                                     : @@NroOperacion
                                     : @@NroPoliza
                                     : @@Error
                                     : @@Msgs );

          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : @@Msgs.peMsid
                          : @@Msgs.peMsev
                          : @@Msgs.peMsg1
                          : @@Msgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;

        endif;

        // Validar componentes de la poliza
        @@ChgVal = *Off;
        for @@Iidx = 1 to @@VehiculoC;

          if not COWVEH_chkEndosoComponente( @@Base
                                           : @@Usuario
                                           : @@Articulo
                                           : @@Superpoliza
                                           : @@Rama
                                           : @@Arse
                                           : @@NroOperacion
                                           : @@NroPoliza
                                           : @@Vehiculo(@@Iidx).nroComponente
                                           : @@Vehiculo(@@Iidx).patente
                                           : @@Vehiculo(@@Iidx).chasis
                                           : @@Vehiculo(@@Iidx).motor
                                           : @@Vehiculo(@@Iidx).sumaAsegurada
                                           : @@ChgVal
                                           : @@Error
                                           : @@Msgs );

            REST_writeHeader( 204
                            : *omit
                            : *omit
                            : @@Msgs.peMsid
                            : @@Msgs.peMsev
                            : @@Msgs.peMsg1
                            : @@Msgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;

          endif;

        endfor;

        // Cambiaron los datos de al menos un componente
        if @@ChgVal = *Off;

          clear @@Repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0183'
                       : @@Msgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );

          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : @@Msgs.peMsid
                          : @@Msgs.peMsev
                          : @@Msgs.peMsg1
                          : @@Msgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;

        endif;

        // Graba cabecera del endoso
        clear @@NroCotizacion;
        clear @@VigFecDes;
        clear @@VigFecHas;
        if not COWVEH_setEndosoPoliza( @@Base
                                     : @@Usuario
                                     : @@Articulo
                                     : @@Superpoliza
                                     : @@Rama
                                     : @@Arse
                                     : @@NroOperacion
                                     : @@NroPoliza
                                     : @@NroCotizacion
                                     : @@VigFecDes
                                     : @@VigFecHas
                                     : @@Error
                                     : @@Msgs );

          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : @@Msgs.peMsid
                          : @@Msgs.peMsev
                          : @@Msgs.peMsg1
                          : @@Msgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;

        endif;

        // Graba componentes del endoso
        for @@Iidx = 1 to @@VehiculoC;

          if not COWVEH_setEndosoComponente( @@Base
                                           : @@Usuario
                                           : @@Articulo
                                           : @@Superpoliza
                                           : @@Rama
                                           : @@Arse
                                           : @@NroOperacion
                                           : @@NroPoliza
                                           : @@NroCotizacion
                                           : @@Vehiculo(@@Iidx).nroComponente
                                           : @@Vehiculo(@@Iidx).patente
                                           : @@Vehiculo(@@Iidx).chasis
                                           : @@Vehiculo(@@Iidx).motor
                                           : @@Vehiculo(@@Iidx).sumaAsegurada
                                           : @@Error
                                           : @@Msgs );

            REST_writeHeader( 204
                            : *omit
                            : *omit
                            : @@Msgs.peMsid
                            : @@Msgs.peMsev
                            : @@Msgs.peMsg1
                            : @@Msgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;

          endif;

        endfor;

        // Confirma Operacion
        clear @@NroSolicitud;
        PRWSND4( @@Base
               : @@NroCotizacion
               : @@VigFecDes
               : @@Usuario
               : @@VigFecHas
               : @@NroSolicitud
               : @@Error
               : @@Msgs );
        if @@Error <> *zeros;

          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : @@Msgs.peMsid
                          : @@Msgs.peMsev
                          : @@Msgs.peMsg1
                          : @@Msgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;

        endif;

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'cambioDatosVehiculos' );

          REST_writeXmlLine( 'nroCotizacion' : %trim(%char(@@NroCotizacion)) );
          REST_writeXmlLine( 'nroSolicitud'  : %trim(%char(@@NroSolicitud)) );

        REST_endArray( 'cambioDatosVehiculos' );

        REST_end();
        SVPREST_end();
        return;

        begsr *inzsr;

          clear buffer;

        endsr;

      /end-free

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'

