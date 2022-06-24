     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ***
      * WSPIVT : Servicio Siniestro - Insertar Vehiculo de Tercero   *
      * ------------------------------------------------------------ *
      * Valeria Marquez                      09/12/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      * -- Copy H --
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspivt_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
      * -- Variables de Arquitectura --
     D request         ds                  likeds(wspIvt_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D @@MsgF          s             10a
     D*
      * -- Variables Validador Caratula --
     D  peRama         s              2  0
     D  peSini         s              7  0
     D  peNops         s              7  0
     D  peMsgf         s              6a
     D  peIdms         s              7a
      *
      * -- Variables Validador Patente  --
     D  peTmat         s              3a
     D  peVald         s              1a
     D  peRtco         s              7a
      *
      * -- Variables Fechas --
     D @@Fech          s              8  0
     D*
      * -- Variables de conversion
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D*
      * Parametros de Vehiculos de Terceros
     D @@Dsb4          ds                  likeds ( dsPahsb4_t )
      *
      * Parametros de Beneficiarios del Siniestro
     D @@DsBe          ds                  likeds ( dsPahsbe_t ) dim(9999)
     D @@DsBeC         s             10i 0
     D*
      * Parametros de Pahssp
     D @@DsSp          ds                  likeds ( dsPahssp_t ) dim(9999)
     D @@DsSpC         s             10i 0
     D*
     D @@CodM          s              7    inz
     D x               s             10i 0
     D f               s             10i 0
     D @ok             s              1
      *
      * -- Prototipo Validador Caratula --
     D WSPVST          pr                  ExtPgm('WSPVST')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  peMsgf                        6a
     D  peIdms                        7a
      *
      * -- Prototipo Validador Patente  --
     D SPFMTPAT        pr                  ExtPgm('SPFMTPAT')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNmat                       25a   const
     D  peFech                        8a   const
     D  peTval                        1a   const
     D  peCuso                        1a   const
     D  peTmat                        3a
     D  peVald                        1a
     D  peRtco                        7a
      *
       // -------------------------------------
       /free
       *inlr = *on;


       // -------------------------------------
       // Inicio
       // -------------------------------------


       options = 'path=insertarVehiculoTercero +
                  allowmissing=yes allowextra=yes case=any';

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

       // -------------------------------------
       // Lectura y Parseo
       // -------------------------------------

        if REST_getEnvVar('WSPIVT_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPIVT_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

       monitor;
          xml-into request %xml(buffer : options);
       on-error;
          @@repl = 'wspIvt_t';
          rc1 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'RPG0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'RPG0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endmon;


       // -------------------------------------
       // Control sobre los parámetros enviados
       // -------------------------------------

       // *-----------------------------*
       // Valido parseo Fecha de Vigencia
       // *-----------------------------*

       monitor;
          @@fech = %dec(%date(request.vigHasta) : *iso);
       on-error;
        //@@repl = request.vigHasta;
          @@MsgF = 'PROMSG';
          @@CodM = 'PRO0002';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
          return;
       endmon;

       // *--------------------*
       // Convierto a Mayusculas
       // *--------------------*

       request.empresa        = %xlate( min : may
                                      : request.empresa);
       request.sucursal       = %xlate( min : may
                                      : request.sucursal);
       request.marcaVehiculo  = %xlate( min : may
                                      : request.marcaVehiculo);
       request.modeloVehiculo = %xlate( min : may
                                      : request.modeloVehiculo);
       request.subModVehiculo = %xlate( min : may
                                      : request.subModVehiculo);
       request.carroceria     = %xlate( min : may
                                      : request.carroceria);
       request.origen         = %xlate( min : may
                                      : request.origen);
       request.patente        = %xlate( min : may
                                      : request.patente);
       request.nroMotor       = %xlate( min : may
                                      : request.nroMotor);
       request.chasis         = %xlate( min : may
                                      : request.chasis);
       request.color          = %xlate( min : may
                                      : request.color);
       request.usuario        = %xlate( min : may
                                      : request.usuario);

       // *------------------------------------*
       // Debe existir beneficiario de siniestro
       // *------------------------------------*

          if SVPSI1_getPahsbe( request.empresa
                             : request.sucursal
                             : request.rama
                             : request.siniestro
                             : request.nroOperStro
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : @@DsBe
                             : @@DsBeC) = *on;

          f = *zeros;
          for x = 1 to @@DsBeC;
              if @@DsBe(x).beNrdf = request.filiatorio;
                 f = x;
                 x = @@DsBeC;
              endif;
          endfor;

          //No encontro el filiatorio

          if f = *zeros;
             @@MsgF = 'SINMSG';
             @@CodM = 'SIN0055';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;
       // *------------------------------------*
       // Debe ser Tipo Beneficiario 2 (Tercero)
       // *------------------------------------*

             if @@DsBe(f).bemar2 <> '2';
                @@MsgF = 'PROMSG';
                @@CodM = 'PRO0010';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

          else;
             @@MsgF = 'SINMSG';
             @@CodM = 'SIN0055';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *----------------------*
       // La caratula debe existir
       // *----------------------*

       perama = request.rama;
       pesini = request.siniestro;
       penops = request.nroOperStro;

       WSPVST( request.empresa
             : request.sucursal
             : perama
             : pesini
             : penops
             : peMsgf
             : peIdms );

       if peMsgf <> *blanks ;
          select;
             when peIdms = 'COW0113';
                @@repl = request.empresa;
             when peIdms = 'COW0114';
                @@repl = request.sucursal;
             when peIdms = 'RAM0001';
                @@repl = %char(request.rama);
             when peIdms = 'SIN0001';
                %subst(@@repl:1:2) = %char(request.rama);
                %subst(@@repl:3:7) = %char(request.siniestro);
          endsl;
          @@MsgF = 'WSVMSG';
          @@CodM = peIdms;
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
          return;
       endif;

       // *---------------------------*
       // Valido Siniestro no terminado
       // *---------------------------*

       if SVPSIN_chkFinSini( request.empresa
                           : request.sucursal
                           : request.rama
                           : request.siniestro
                           : request.nroOperStro) = *on;
          @@MsgF = 'WSVMSG';
          %subst(@@repl:1:2) = %char(request.rama);
          %subst(@@repl:3:7) = %char(request.nroOperStro);
          @@CodM = 'SIN0052';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
          return;
       endif;

       // *----------------------------------------*
       // Valido Estado habilitado para modificacion
       // *----------------------------------------*

       if SVPSIN_chkSinModificable( request.empresa
                                  : request.sucursal
                                  : request.rama
                                  : request.nroOperStro) = *off;

          @@MsgF = 'WSVMSG';
          %subst(@@repl:1:2) = %char(request.rama);
          %subst(@@repl:3:7) = %char(request.nroOperStro);
          @@CodM = 'SIN0052';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
          return;
       endif;

       // *-------------*
       // Valido Vehiculo
       // *-------------*

          if SPVVEH_CheckMarca( request.marcaVehiculo ) = *off;
             @@MsgF = 'WSVMSG';
             @@repl = request.marcaVehiculo;
             @@CodM = 'COW0084';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

          if SPVVEH_CheckMod( request.modeloVehiculo ) = *off;
             @@MsgF = 'WSVMSG';
             @@repl = request.modeloVehiculo;
             @@CodM = 'COW0085';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

          if SPVVEH_CheckSubMod( request.subModVehiculo ) = *off;
             @@MsgF = 'WSVMSG';
             @@repl = request.subModVehiculo;
             @@CodM = 'COW0086';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *---------------*
       // Valido Carroceria
       // *---------------*

          if SPVVEH_CheckCarroceria( request.carroceria
                                   : *omit              ) = *off;
             @@MsgF = 'PROMSG';
             @@CodM = 'PRO0018';
             @@repl = request.carroceria;
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *--------*
       // Valido Uso
       // *--------*

          if SPVVEH_CheckCodUso( request.uso
                               : *omit       ) = *off;
             @@MsgF = 'WSVMSG';
             @@CodM = 'COW0072';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *---------*
       // Valido Tipo
       // *---------*

          if SPVVEH_CheckTipoVeh( request.tipo
                                : *omit        ) = *off;
             @@MsgF = 'PROMSG';
             @@CodM = 'PRO0017';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *-----------*
       // Valido Origen
       // *-----------*

          if SPVVEH_CheckOrigen( request.origen ) = *off;
             @@MsgF = 'PROMSG';
             @@CodM = 'PRO0019';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *-------------------------*
       // Valido Compania Aseguradora
       // *-------------------------*

          if request.nroPoliza <> *zeros or request.ciaAseg <> *zeros;

             if SVPVAL_chkCiaCoaseg( request.ciaAseg ) = *off;
                @@MsgF = 'REAMSG';
                @@CodM = 'REA0043';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

          endif;

       // *-------------------------*
       // Valido Fecha Vigencia Hasta
       // *-------------------------*

          if SPVFEC_FechaValida8( @@Fech ) = *off;
             @@MsgF = 'WSVMSG';
             @@CodM = 'GEN0002';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *-----------------------*
       // Valido Cobertura Afectada
       // *-----------------------*

          if request.cobAfectada <> *zeros;

             if SVPVAL_chkCobAfec( request.cobAfectada ) = *off;
                @@MsgF = 'PROMSG';
                @@CodM = 'PRO0170';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

          endif;

       // *---------------------*
       // Obtengo Tipo de Patente
       // *---------------------*

          SPFMTPAT( request.empresa
                  : request.sucursal
                  : request.patente
                  : %char(%date():*ymd)
                  : '2'
                  : 'T'
                  : peTmat
                  : peVald
                  : peRtco             );
          if %trim(peRtco) <> 'OK';
             @@MsgF = 'WSVMSG';
             @@CodM = 'COW0050';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;


       // -------------------------------------
       // Ok - Cargo Estructuras
       // -------------------------------------

       clear @@Dsb4;
       @@Dsb4.b4Empr = request.empresa;
       @@Dsb4.b4Sucu = request.sucursal;
       @@Dsb4.b4Rama = request.rama;
       @@Dsb4.b4Sini = request.siniestro;
       @@Dsb4.b4Nops = request.nroOperStro;
       @@Dsb4.b4Poco = @@DsBe(f).bePoco;
       @@Dsb4.b4Paco = @@DsBe(f).bePaco;
       @@Dsb4.b4Riec = @@DsBe(f).beRiec;
       @@Dsb4.b4Xcob = @@DsBe(f).beXcob;
       @@Dsb4.b4Nrdf = request.filiatorio;
       @@Dsb4.b4Sebe = @@DsBe(f).beSebe;
       @@Dsb4.b4vhmc = request.marcaVehiculo;
       @@Dsb4.b4vhmo = request.modeloVehiculo;
       @@Dsb4.b4vhcs = request.subModVehiculo;
       @@Dsb4.b4vhaÑ = request.anioVehiculo;
       @@Dsb4.b4vhcr = request.carroceria;
       @@Dsb4.b4vhuv = request.uso;
       @@Dsb4.b4vhct = request.tipo;
       @@Dsb4.b4vhni = request.origen;
       //@@Dsb4.b4patl = a;
       //@@Dsb4.b4patn = a;
       //@@Dsb4.b4panl = a;
       //@@Dsb4.b4pann = a;
       @@Dsb4.b4moto = request.nroMotor;
       @@Dsb4.b4chas = request.chasis;
       @@Dsb4.b4mar1 = *blanks;
       @@Dsb4.b4mar2 = *blanks;
       @@Dsb4.b4mar3 = *blanks;
       @@Dsb4.b4mar4 = *blanks;
       @@Dsb4.b4mar5 = *blanks;
       @@Dsb4.b4user = request.usuario;
       @@Dsb4.b4date = %dec(%date():*dmy);
       @@Dsb4.b4time = %dec(%time():*iso);
       @@Dsb4.b4ncoc = request.ciaAseg;
       @@Dsb4.b4npza = request.nroPoliza;
       @@Dsb4.b4npoc = request.nroItem;
       @@Dsb4.b4nend = request.nroEndo;
       @@Dsb4.b4vght = @@Fech;
       @@Dsb4.b4xcot = request.cobAfectada;
       @@Dsb4.b4colo = request.color;
       @@Dsb4.b4tmat = peTmat;
       @@Dsb4.b4nmat = request.patente;


       // -------------------------------------
       // Realizo Alta o Modificacion
       // -------------------------------------

       if SVPSI1_chkPahsb4( @@Dsb4.b4Empr
                          : @@Dsb4.b4Sucu
                          : @@Dsb4.b4Rama
                          : @@Dsb4.b4Sini
                          : @@Dsb4.b4Nops
                          : @@Dsbe(f).bePoco
                          : @@Dsbe(f).bePaco
                          : @@Dsbe(f).beRiec
                          : @@Dsbe(f).beXcob
                          : @@Dsbe(f).beNrdf
                          : @@Dsbe(f).beSebe ) = *on;

          if SVPSI1_updPahsb4(@@Dsb4) = *on;
             REST_writeHeader( 201
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit );
          else;
             REST_writeHeader( 400
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit );
          endif;

       else;

          if SVPSI1_setPahsb4(@@Dsb4) = *on;
             REST_writeHeader( 201
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit );
          else;
             REST_writeHeader( 400
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit
                             : *omit );
          endif;
       endif;

       return;

      * ------------------------------------------------- *
      *  Funcion Error Salida
     PfinErr           b
      * Interfaz Procedimiento...
     Dfinerr           pi
     D p1repl                     65535a
     D p1CodM                         7
     D p1Msgs                              likeds(paramMsgs)
     D p1MsgF                        10a
      *

          rc1 = SVPWS_getMsgs( '*LIBL'
                             : p1MsgF
                             : p1CodM
                             : peMsgs
                             : %trim(p1repl)
                             : %len(%trim(p1repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : p1CodM
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
     PfinErr           e

