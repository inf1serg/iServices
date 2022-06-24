     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ***
      * WSPDAL : Servicio Siniestro - Insertar Datos Ad. Lesiones    *
      * ------------------------------------------------------------ *
      * Valeria Marquez                      16/12/2021              *
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
      *           La ds (en este caso wspdal_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
      * -- Variables de Arquitectura --
     D request         ds                  likeds(wspDal_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D @@MsgF          s             10a
     D x               s             10i 0
     D f               s             10i 0
     D*
      * -- Variables Validador Caratula --
     D  peRama         s              2  0
     D  peSini         s              7  0
     D  peNops         s              7  0
     D  peMsgf         s              6a
     D  peIdms         s              7a
      *
      * -- Variables Utilizadas --
     D  @@Loca         s              2  0
      *
      * -- Variables Fechas --
     D @@FeNa          s              8  0
     D @@ReVe          s              8  0
     D*
      * -- Variables de conversion
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D*
      *
      * Parametros de Beneficiarios del Siniestro
     D @@DsBe          ds                  likeds ( dsPahsbe_t ) dim(9999)
     D @@DsBeC         s             10i 0
      *
      * Parametros de Stros. -Benef.-Adicional Conductores.
     D @@DsB2          ds                  likeds ( dsPahsb2_t )
     D @@DsB2C         s             10i 0
     D*
     D @@CodM          s              7    inz
     D @x              s             10i 0
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
       // -------------------------------------
       /free
       *inlr = *on;


       // -------------------------------------
       // Inicio
       // -------------------------------------


       options = 'path=insertarDatosAdicionalesLesiones +
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

        if REST_getEnvVar('WSPDAL_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPDAL_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

       monitor;
          xml-into request %xml(buffer : options);
       on-error;
          @@repl = 'wspDal_t';
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

       // *-------------------------------*
       // Valido parseo Fecha de Nacimiento
       // *-------------------------------*

          if request.fechaNacimiento <> *blanks;
             monitor;
                @@feNa = %dec(%date(request.fechaNacimiento) : *iso);
             on-error;
                @@MsgF = 'WSVMSG';
                @@CodM = 'MOB0005';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endmon;
          endif;

          if request.registroVencimiento <> *blanks;
             monitor;
                @@reVe = %dec(%date(request.registroVencimiento) : *iso);
             on-error;
                @@MsgF = 'SINMSG';
                @@CodM = 'SIN0008';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endmon;
          endif;

       // *--------------------*
       // Convierto a Mayusculas
       // *--------------------*

       request.empresa   = %xlate( min : may
                                 : request.empresa);
       request.sucursal  = %xlate( min : may
                                 : request.sucursal);
       request.nombre    = %xlate( min : may
                                 : request.nombre);
       request.telefono  = %xlate( min : may
                                 : request.telefono);
       request.domicilio = %xlate( min : may
                                 : request.domicilio);
       request.habitual          = %xlate( min : may
                                         : request.habitual);
       request.examenAlcoholemia   = %xlate( min : may
                                           : request.examenAlcoholemia);
       request.centroAsistencial   = %xlate( min : may
                                           : request.centroAsistencial);
       request.usuario             = %xlate( min : may
                                           : request.usuario);
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
       // Valido Nombre
       // *-------------*

          if request.nombre = *blanks;
             @@MsgF = 'WSVMSG';
             @@CodM = 'COW0009';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *--------------------*
       // Valido Dato Filiatorio
       // *--------------------*

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
                @@MsgF = 'WSVMSG';
                @@CodM = 'DAF0001';
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
                @@MsgF = 'WSVMSG';
                @@CodM = 'DAF0001';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;
       // *---------*
       // Valido Sexo
       // *---------*

          if request.sexo <> *zeros;

             if SVPVAL_chkSexo(request.sexo) = *off;
                @@MsgF = 'WSVMSG';
                @@CodM = 'PRW0012';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

          endif;

       // *-----------------------*
       // Valido Tipo Documento
       // *-----------------------*

          if request.documentoTipo <> *zeros;

             if not SVPVAL_tipoDeDocumento( request.documentoTipo );
                @@MsgF = 'WSVMSG';
                @@CodM = 'AAG0001';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

           endif;

       // *------------------------*
       // Valido Cod Postal / Sufijo
       // *------------------------*

          if request.codigoPostal <> *zeros;

           @@loca = SVPDES_getProvinciaPorLocalidad( request.codigoPostal
                                                   : request.sufijoCodPostal);
           if @@loca = *zeros;
              @@MsgF = 'WSVMSG';
              @@CodM = 'LOC0001';
              FinErr ( @@repl
                     : @@CodM
                     : peMsgs
                     : @@MsgF);
              return;
           endif;

          endif;

       // *---------*
       // Valido Pais
       // *---------*

          if request.pais <> *zeros;

             if not SVPVAL_chkPaisNac( request.pais );
                @@MsgF = 'WSVMSG';
                @@CodM = 'PRW0015';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
              endif;

          endif;

       // *-----------------*
       // Valido Estado Civil
       // *-----------------*

          if request.estadoCivil <> *zeros;

             if not SVPVAL_chkEdoCivil( request.estadoCivil );
                @@MsgF = 'WSVMSG';
                @@CodM = 'PRW0013';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

          endif;

       // *-------------------*
       // Valido Cond. Habitual   S/N**
       // *-------------------*

          if request.habitual <> *blanks and
             request.habitual <> 'N' and
             request.habitual <> 'S';

             @@MsgF = 'WSVMSG';
             @@CodM = 'SIN0035';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;

          endif;

       // *--------------------*
       // Valido Ex. Alcoholemia
       // *--------------------*

          if request.examenAlcoholemia <> *blanks and
             request.examenAlcoholemia <> 'S'     and
             request.examenAlcoholemia <> 'N'     and
             request.examenAlcoholemia <> 'X';

             @@MsgF = 'WSVMSG';
             @@CodM = 'SIN0034';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;

          endif;

       // *-----------------*
       // Valido Relac.C/Aseg
       // *-----------------*

          if request.relacionAsegurado <> *zeros;

             if SVPVAL_relacionAsegurado( request.empresa
                                        : request.sucursal
                                        : request.relacionAsegurado) = *off;
                @@MsgF = 'WSVMSG';
                @@CodM = 'SIN0033';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

          endif;

       // -------------------------------------
       // Ok - Cargo Estructuras
       // -------------------------------------

       clear @@Dsb2;
       @@Dsb2.b2empr = request.empresa;
       @@Dsb2.b2sucu = request.sucursal;
       @@Dsb2.b2rama = request.rama;
       @@Dsb2.b2sini = request.siniestro;
       @@Dsb2.b2nops = request.nroOperStro;
       @@Dsb2.b2poco = @@Dsbe(f).bePoco;
       @@Dsb2.b2paco = @@Dsbe(f).bePaco;
       @@Dsb2.b2riec = @@Dsbe(f).beRiec;
       @@Dsb2.b2xcob = @@Dsbe(f).beXcob;
       @@Dsb2.b2sebe = @@Dsbe(f).besebe;
       @@Dsb2.b2nrdf = request.filiatorio;
       @@Dsb2.b2nrd1 = *zeros;
       @@Dsb2.b2nomb = request.nombre;
       @@Dsb2.b2csex = request.sexo;
       @@Dsb2.b2tido = request.documentoTipo;
       @@Dsb2.b2nrdo = request.documentoNro;
       @@Dsb2.b2ntel = request.telefono;
       @@Dsb2.b2domi = request.domicilio;
       @@Dsb2.b2copo = request.codigoPostal;
       @@Dsb2.b2cops = request.sufijoCodPostal;
       @@Dsb2.b2pain = request.pais;
       @@Dsb2.b2cesc = request.estadoCivil;
       @@Dsb2.b2fena = @@FeNa;
       @@Dsb2.b2mar1 = request.habitual;
       @@Dsb2.b2nrcv = request.registroNro;
       @@Dsb2.b2frcv = @@ReVe;
       @@Dsb2.b2mar2 = request.examenAlcoholemia;
       @@Dsb2.b2mar3 = *blanks;
       @@Dsb2.b2mar4 = *blanks;
       @@Dsb2.b2mar5 = *blanks;
       @@Dsb2.b2rela = request.relacionAsegurado;
       @@Dsb2.b2ctro = request.centroAsistencial;
       @@Dsb2.b2user = request.usuario;
       @@Dsb2.b2date = %dec(%date():*dmy);
       @@Dsb2.b2time = %dec(%time():*iso);


       // -------------------------------------
       // Realizo Alta o Modificacion
       // -------------------------------------

       if SVPSI1_chkPahsb2( @@Dsb2.b2Empr
                          : @@Dsb2.b2Sucu
                          : @@Dsb2.b2Rama
                          : @@Dsb2.b2Sini
                          : @@Dsb2.b2Nops
                          : @@Dsb2.b2Poco
                          : @@Dsb2.b2Paco
                          : @@Dsb2.b2Riec
                          : @@Dsb2.b2Xcob
                          : @@Dsb2.b2Nrdf
                          : @@Dsb2.b2Sebe ) = *on;

          if SVPSI1_updPahsb2(@@Dsb2) = *on;
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

          if SVPSI1_setPahsb2(@@Dsb2) = *on;
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
          //'WSVMSG'
          rc1 = SVPWS_getMsgs( '*LIBL'
                             : p1Msgf
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

