     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ***
      * WSPIFR : Servicio Siniestro - Generar Franquicia             *
      * ------------------------------------------------------------ *
      * David Tilatti        08/11/2021                              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      * -- Copy H --
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspIrf_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
      * -- Variables de Arquitectura --
     D request         ds                  likeds(wspIrf_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D*
     D @@CodM          s              7    inz
      * -- Variables Fechas --
     D @@Fech          s              8  0
     D @@Fema          s              4  0
     D @@Femm          s              2  0
     D @@Femd          s              2  0
     d @@DS456         ds                  likeds (DsSet456_t)
     D @@F456          s              8  0
      * -- Variables de Calculo --
     D @@Psec          s              2  0
     D @@Imco          s             15  6
     D @@Imau          s             15  2
      * -- Estructura Franquicia--
     D @@Dsfr          ds                  likeds(DsPahsfr_t)
      * -- Estructura Moneda --
     d peDSMon         ds                  likeds(dsgntmon_t)
      *
      * -- Prototipo Validador Caratula --
     D WSPVST          pr                  ExtPgm('WSPVST')
     D  peEmpr                        1a
     D  peSucu                        2a
     D  peRama                        2  0
     D  peSini                        7  0
     D  peNops                        7  0
     D  peMsgf                        6a
     D  peIdms                        7a
      * -- Variables Validador Caratula --
     D  peRama         s              2  0
     D  peSini         s              7  0
     D  peNops         s              7  0
     D  peMsgf         s              6a
     D  peIdms         s              7a
      * -- Prototipos de comunicación - Funciones internas --
      * Campos Locales...
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      // -------------------------------------

      /free

       *inlr = *on;

       // -------------------------------------
       // Inicio
       // -------------------------------------

       options = 'path=insertarFranquicia +
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
        if REST_getEnvVar('WSPIFR_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPIFR_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

       monitor;
          xml-into request %xml(buffer : options);
       on-error;
          @@repl = 'wspIrf_t';
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

       // -------------------
       // valido parseo fecha Movimiento
       monitor;
          @@fech = %dec(%date(request.fechaMovi) : *iso);
       on-error;
        //@@repl = request.fechaMovi;
          @@CodM = 'RPG0001';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endmon;

       // Pasa todo a Mayusculas lo que pueda venir Caracter en el request
       // Caratula.Empresa y Sucursal, BienSiniestrado.riesgo, Beneficiario.marEstado y marTipo
       // IdentProveedor.codMayAux, monto.moneda, usuario.
       request.caratula.empresa = %xlate(min : may : request.caratula.empresa);
       request.caratula.sucursal = %xlate(min : may :request.caratula.sucursal);
       request.bienSiniestrado.riesgo =
                             %xlate(min : may : request.bienSiniestrado.riesgo);
       request.beneficiario.marEstado =
                             %xlate(min : may : request.beneficiario.marEstado);
       request.beneficiario.marTipo =
                             %xlate(min : may : request.beneficiario.marTipo);
       request.identProveedor.codMayAux=%xlate
                                 (min : may : request.identProveedor.codMayAux);
       request.monto.moneda = %xlate(min : may : request.monto.moneda);
       request.usuario = %xlate(min : may : request.usuario);
       // -------------------
       // La caratula debe existir
       perama = request.caratula.rama           ;
       pesini = request.caratula.siniestro      ;
       penops = request.caratula.nroOperStro    ;

       WSPVST( request.caratula.empresa
             : request.caratula.sucursal
             : perama
             : pesini
             : penops
             : peMsgf
             : peIdms );

       if peMsgf <> *blanks ;
          select;
             when peIdms = 'COW0113';
                @@repl = request.caratula.empresa;
             when peIdms = 'COW0114';
                @@repl = request.caratula.sucursal;
             when peIdms = 'RAM0001';
                @@repl = %char(request.caratula.rama);
             when peIdms = 'SIN0001';
                %subst(@@repl:1:2) = %char(request.caratula.rama);
                %subst(@@repl:3:7) = %char(request.caratula.siniestro);
          endsl;
          @@CodM = peIdms;
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       select;

          // Valida El Siniestro/Caratula tiene Estado inhabilitado para modificacion
          when SVPSIN_chkSinModificable( request.caratula.empresa
                                       : request.caratula.sucursal
                                       : request.caratula.rama
                                       : request.caratula.nroOperStro) = *off;

               %subst(@@repl:1:2) = %char(request.caratula.rama);
               %subst(@@repl:3:7) = %char(request.caratula.nroOperStro);
               @@CodM = 'SIN0052';
               FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
               return;

          // Valida siniestro terminado
          when SVPSIN_chkFinSini( request.caratula.empresa
                                : request.caratula.sucursal
                                : request.caratula.rama
                                : request.caratula.siniestro
                                : request.caratula.nroOperStro)= *on;
             peMsgs = SVPSIN_Error();
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
          return;

          // -------------------
          // Los pasos necesarios deben estar completos
          when SVPSI1_chkPasoDeTrabajo( request.caratula.empresa
                                      : request.caratula.sucursal
                                      : request.caratula.rama
                                      : request.caratula.siniestro
                                      : request.caratula.nroOperStro)= *off;
             @@CodM = 'SIN1004';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;

       // El Bien Siniestrado no exite en el siniestro
          when SVPSI1_chkPahsbs( request.caratula.empresa
                               : request.caratula.sucursal
                               : request.caratula.rama
                               : request.caratula.siniestro
                               : request.caratula.nroOperStro
                               : request.bienSiniestrado.componente
                               : request.bienSiniestrado.parentesco
                               : request.bienSiniestrado.riesgo
                               : request.bienSiniestrado.cobertura ) = *off;

               %subst(@@repl:1:2) = %char(request.caratula.rama);
               %subst(@@repl:3:7) = %char(request.caratula.nroOperStro);
               @@CodM = 'SIN0060';
               FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
               return;

          // -------------------
          // El beneficiario del siniestro debe existir
          when SVPSI1_chkPahsbe( request.caratula.empresa
                               : request.caratula.sucursal
                               : request.caratula.rama
                               : request.caratula.siniestro
                               : request.caratula.nroOperStro
                               : request.bienSiniestrado.componente
                               : request.bienSiniestrado.parentesco
                               : request.bienSiniestrado.riesgo
                               : request.bienSiniestrado.cobertura
                               : request.beneficiario.filiatorio
                               : request.beneficiario.beneficiario ) = *off;
             %subst(@@repl:1:7) = %char(request.beneficiario.filiatorio);
             %subst(@@repl:8:13) = %char(request.beneficiario.beneficiario);
             %subst(@@repl:14:20) = %char(request.caratula.siniestro);
             @@CodM = 'SIN0038';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
          when request.beneficiario.marTipo <> '1';
             @@CodM = 'SIN0061';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;

          // -------------------
          // Codigo de moneda debe existir
          when SVPVAL_moneda( request.monto.moneda ) = *off;
             @@repl = request.monto.moneda;
             @@CodM = 'COW0003';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;

       endsl;

       // -------------------
       // Recupero y valido fechaMovi set456
       SVPSIN_getSet456( request.caratula.empresa
                       : request.caratula.sucursal
                       : @@Ds456);
       @@F456 = (@@Ds456.t@fema * 10000)
              + (@@Ds456.t@femm *   100)
              +  @@Ds456.t@femd;
       if @@Fech <> @@F456;
          %subst(@@repl:1:10) = %char(%date(request.fechaMovi) : *iso);
          %subst(@@repl:11:10) = %char(%date(@@F456) : *iso);
          @@CodM = 'SIN0039';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Recupero y valido nro secuencia
       @@Psec = SVPSIN_getSecSfr ( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro
                                 : request.bienSiniestrado.componente
                                 : request.bienSiniestrado.parentesco
                                 : request.beneficiario.filiatorio
                                 : request.beneficiario.beneficiario
                                 : request.bienSiniestrado.riesgo
                                 : request.bienSiniestrado.cobertura
                                 : @@Fech);
       if @@Psec = -1;
          @@repl = %char(@@Psec);
          @@CodM = 'SIN0040';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Recupero y valido codigo de mayor auxiliar
       //  Si no se informo cuenta del Mayor Auxiliar, el Nro.
       //  del Dato Filiatorio debe ser igual al Dato Filiatorio.
       if request.identProveedor.codMayAux = *blanks or
          request.identProveedor.codMayAux = '**'    or
          request.identProveedor.codMayAux = '*1';
          if request.beneficiario.filiatorio <>
          request.identProveedor.NumMayAux;
          %subst(@@repl:1:2) = request.identProveedor.codMayAux;
          %subst(@@repl:3:7) = %char(request.identProveedor.numMayAux);
          @@CodM = 'SIN0041';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
          endif;
       else;
          if SVPVAL_chkMayorAuxiliar( request.caratula.empresa
                                    : request.caratula.sucursal
                                    : request.identProveedor.codMayAux
                                    : request.identProveedor.numMayAux
                                    ) = *off;
          %subst(@@repl:1:2) = request.identProveedor.codMayAux;
          %subst(@@repl:3:7) = %char(request.identProveedor.numMayAux);
          @@CodM = 'SIN0041';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
          endif;
       endif;

          // -------------------
          // Verifico que la Franquicia que quiero insertar no me deje El neto franquicia global en
          // negativo. a la fecha solicitada(-FRA)-(nueva FRA a insertar)
          if (SVPSIN_getFraStro( request.caratula.empresa
                               : request.caratula.sucursal
                               : request.caratula.rama
                               : request.caratula.siniestro
                               : request.caratula.nroOperStro
                               : @@Fech) + (request.monto.importe)) < *zero;

             @@CodM = 'SIN0059';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
             endif;

          // -------------------
          // Verifico que la Franquicia que quiero insertar no me deje El neto Reserva - Franquicias
          // - Pagos en negativo. a la fecha solicitada(+RVA -FRA -PAG)+(nueva FRA a insertar)
          if (SVPSIN_getRvaAct( request.caratula.empresa
                               : request.caratula.sucursal
                               : request.caratula.rama
                               : request.caratula.siniestro
                               : request.caratula.nroOperStro
                               : request.beneficiario.filiatorio
                               : @@Fech) - (request.monto.importe)) < *zero;

             @@CodM = 'SIN0053';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs);
             return;
             endif;

       // -------------------------------------
       // Calculos sobre los parámetros enviados
       // -------------------------------------

       // -------------------
       // Calcula campos fechas
       @@Fema = SPVFEC_ObtAÑoFecha8 ( @@Fech );
       @@Femm = SPVFEC_ObtMesFecha8 ( @@Fech );
       @@Femd = SPVFEC_ObtDiaFecha8 ( @@Fech );

       // -------------------
       // Importes y monedas de Franquicia
       @@Imco = *zeros;
       // Recupero Registro moneda
          SVPTAB_getGntmon( peDSMon
                          : request.monto.moneda
                          : *omit  );

       if peDSMon.moMoeq <> 'AU';
          // Busco Cotizacion de moneda si equiv. no es AU
          @@Imco = SVPTAB_cotizaMoneda( request.monto.moneda
                                      : @@Fech );
       endif;
       if @@Imco = *zeros;    // No tiene Cotizacion
          @@Imco = 1;
       endif;

       // -------------------
       // Calcula Importe Moneda Cte.
       @@Imau = request.monto.importe * @@Imco;

       // -------------------------------------
       // Ok
       // -------------------------------------

       clear @@Dsfr;
       @@dsfr.frEmpr = request.caratula.empresa;
       @@dsfr.frSucu = request.caratula.sucursal;
       @@dsfr.frRama = request.caratula.rama;
       @@dsfr.frSini = request.caratula.siniestro;
       @@dsfr.frNops = request.caratula.nroOperStro;
       @@dsfr.frPoco = request.bienSiniestrado.componente;
       @@dsfr.frPaco = request.bienSiniestrado.parentesco;
       @@dsfr.frNrdf = request.beneficiario.filiatorio;
       @@dsfr.frSebe = request.beneficiario.beneficiario;
       @@dsfr.frRiec = request.bienSiniestrado.riesgo;
       @@dsfr.frXcob = request.bienSiniestrado.cobertura;
       @@dsfr.frFmoa = @@Fema;
       @@dsfr.frFmom = @@Femm;
       @@dsfr.frFmod = @@Femd;
       @@dsfr.frPsec = @@Psec;
       @@dsfr.frNupe = *zeros;
       @@dsfr.frNroc = *zeros;
       @@dsfr.frComa = request.identProveedor.codMayAux;
       @@dsfr.frNrma = request.identProveedor.numMayAux;
       @@dsfr.frEsma = *zeros;
       @@dsfr.frMonr = request.monto.moneda;
       @@dsfr.frImmr = request.monto.importe;
       @@dsfr.frImnr = *zeros;
       @@dsfr.frMoeq = peDSMon.moMoeq;
       @@dsfr.frImco = @@Imco;
       @@dsfr.frImau = @@Imau;
       @@dsfr.frImna = *zeros;
       @@dsfr.frMar1 = request.beneficiario.marEstado;
       @@dsfr.frMar2 = request.beneficiario.marTipo;
       @@dsfr.frMar3 = 'N';
       @@dsfr.frMar4 = '0';
       @@dsfr.frMar5 = '0';
       @@dsfr.frUser = request.usuario;
       @@dsfr.frTime = %dec(%time():*iso);
       @@dsfr.frFera = *year;
       @@dsfr.frFerm = *month;
       @@dsfr.frFerd = *day;

       if SVPSI1_setPahsfr(@@Dsfr) = *on;
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
       return;

      * ------------------------------------------------- *
      *  Funcion Error Salida
     PfinErr           b
      * Interfaz Procedimiento...
     Dfinerr           pi
     D p1repl                     65535a
     D p1CodM                         7
     D p1Msgs                              likeds(paramMsgs)
      *

          rc1 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
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

