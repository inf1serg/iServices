     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ***
      * WSPMRS : Servicio Siniestro - Modifica Reserva               *
      * ------------------------------------------------------------ *
      * Facundo Astiz                        18/11/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *
     Fcntnau    if   e           k disk

      * -- Copy H --
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspMrs_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
      * -- Variables de Arquitectura --
     D request         ds                  likeds(wspMrs_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D*
      * -- Variables Validador Caratula --
     D  peMsgf         s              6a
     D  peIdms         s              7a
      *
      * -- Variables Fechas --
     D @@Fech          s              8  0
     D @@Fema          s              4  0
     D @@Femm          s              2  0
     D @@Femd          s              2  0
     D @@DS456         ds                  likeds (DsSet456_t)
     D @@F456          s              8  0
     D*
      * -- Variables de Calculo --
     D @@Psec          s              2  0
     D @@imco          s             15  6
     D @@Imau          s             15  2
     D @@Mact          s             15  2
     D @@Ract          s             15  2
     D @@Totl          s             15  2
     D*
      * -- Variables de conversion
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D*
      * -- Estructuras
     D @@Dshr          ds                  likeds(DsPahshr_t)
     D @@Dsbe          ds                  likeds(DsPahsbe_t) dim(9999)
     D @@DSMon         ds                  likeds(dsgntmon_t)
     D k1tnau          ds                  likerec(c1tnau:*key)
     D*
     D @@CodM          s              7    inz
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


       options = 'path=modificarReserva +
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
        if REST_getEnvVar('WSPMRS_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPMRS_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

       monitor;
          xml-into request %xml(buffer : options);
       on-error;
          @@repl = 'wspMrs_t';
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

       // -------------------
       // Mayuscula
       request.caratula.empresa = %xlate(min : may
                                        :request.caratula.empresa);
       request.caratula.sucursal = %xlate(min : may
                                         :request.caratula.sucursal);
       request.bienSiniestrado.riesgo = %xlate(min : may
                                      :request.bienSiniestrado.riesgo);
       request.usuario = %xlate(min : may : request.usuario);

       // -------------------
       // La caratula debe existir

       WSPVST( request.caratula.empresa
             : request.caratula.sucursal
             : %dec(request.caratula.rama:2:0)
             : %dec(request.caratula.siniestro:7:0)
             : %dec(request.caratula.nroOperStro:7:0)
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

       // -------------------
       // El Bien Siniestrado no exite en el siniestro
       if SVPSI1_chkPahsbs( request.caratula.empresa
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
       endif;

       // -------------------
       // Valida siniestro no terminado
       if SVPSIN_chkFinSini( request.caratula.empresa
                           : request.caratula.sucursal
                           : request.caratula.rama
                           : request.caratula.siniestro
                           : request.caratula.nroOperStro)= *on;
          %subst(@@repl:1:2) = %char(request.caratula.rama);
          %subst(@@repl:3:7) = %char(request.caratula.nroOperStro);
          @@CodM = 'SIN0052';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

        // El Siniestro/caratula tiene Estado inhabilitado para modificacion
       if SVPSIN_chkSinModificable( request.caratula.empresa
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
       endif;

       // -------------------
       // Los pasos necesarios deben estar completos
       if SVPSI1_chkPasoDeTrabajo( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro)= *off;
          @@CodM = 'SIN1004';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // El beneficiario del siniestro debe existir
       if SVPSI1_chkPahsbe( request.caratula.empresa
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
          %subst(@@repl:1:7)   = %char(request.beneficiario.filiatorio);
          %subst(@@repl:8:13)  = %char(request.beneficiario.beneficiario);
          %subst(@@repl:14:20) = %char(request.caratula.siniestro);
          @@CodM = 'SIN0042';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

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
       @@Psec = SVPSIN_getSecShr ( request.caratula.empresa
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
       // Codigo de moneda debe existir
       if SVPVAL_moneda( request.monto.moneda ) = *off;
          @@repl = request.monto.moneda;
          @@CodM = 'COW0003';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Importe Distinto a cero
       if request.monto.importe = *zeros;
          @@repl = %char(request.monto.importe);
          @@CodM = 'SIN0064';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Recupero info beneficiario
       SVPSI1_getPahsbe( request.caratula.empresa
                       : request.caratula.sucursal
                       : request.caratula.rama
                       : request.caratula.siniestro
                       : request.caratula.nroOperStro
                       : request.bienSiniestrado.componente
                       : request.bienSiniestrado.parentesco
                       : request.bienSiniestrado.riesgo
                       : request.bienSiniestrado.cobertura
                       : request.beneficiario.filiatorio
                       : request.beneficiario.beneficiario
                       : @@Dsbe
                       : *omit);

       // -------------------
       // Codigo de moneda debe ser el mismo al ingresado anteriormente
       if @@Dsbe(1).beMonr <> request.monto.moneda;
          @@repl = request.monto.moneda;
          @@CodM = 'COW0005';
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
       // Importes y monedas de reserva
       @@Imco = *zeros;
       // Recupero Registro moneda
       SVPTAB_getGntmon( @@DSMon
                       : request.monto.moneda
                       : *omit  );

       // -------------------
       // Busco Cotizacion de moneda
       if @@DSMon.moMoeq <> 'AU';
          @@Imco = SVPTAB_cotizaMoneda( request.monto.moneda : @@Fech );
       else;
          @@Imco = 1;
       endif;

       if @@Imco = *zeros;
          // error en la cotizacion de moneda
          @@repl = @@DSMon.moMoeq;
          @@CodM = 'SIN0058';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Busco Total y Total por Beneficiario
       @@Totl = SVPSIN_getRvaStro( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro);
       @@Mact = SVPSIN_getRva( request.caratula.empresa
                             : request.caratula.sucursal
                             : request.caratula.rama
                             : request.caratula.siniestro
                             : request.caratula.nroOperStro
                             : request.beneficiario.filiatorio
                             : @@fech);

       // -------------------
       // Calcula Importe Moneda Cte.
       if @@Imco = *zeros
       or @@Imco = 1;
          @@Imau = request.monto.importe;
       else;
          @@Imau = (request.monto.importe * @@Imco) - @@Mact;
       endif;

       // -------------------
       // Valido importe neto total negativo
       if (@@Totl + @@Imau) < *zeros;
          @@CodM = 'SIN0059';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Valido importe neto beneficiario negativo

       if (@@Mact + @@Imau) < *zeros;
          @@CodM = 'SIN0059';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs);
          return;
       endif;

       // -------------------
       // Verifico que la Reserva que quiero insertar no me deje El neto    Reserva - Franquicias
       // - Pagos en negativo. a la fecha solicitada
       // (+RVA -FRA -PAG)-( nueva RES a insertar)
       @@Ract = SVPSIN_getRvaAct( request.caratula.empresa
                                 : request.caratula.sucursal
                                 : request.caratula.rama
                                 : request.caratula.siniestro
                                 : request.caratula.nroOperStro
                                 : request.beneficiario.filiatorio
                                 : @@Fech);

         if (@@Ract + request.monto.importe) < *zero;
            @@CodM = 'SIN0053';
            FinErr ( @@repl
                   : @@CodM
                   : peMsgs);
            return;
         endif;



       // -------------------------------------
       // Ok - Cargo Estructura
       // -------------------------------------


       clear @@Dshr;
       @@dshr.hrEmpr = request.caratula.empresa;
       @@dshr.hrSucu = request.caratula.sucursal;
       @@dshr.hrRama = request.caratula.rama;
       @@dshr.hrSini = request.caratula.siniestro;
       @@dshr.hrNops = request.caratula.nroOperStro;
       @@dshr.hrPoco = request.bienSiniestrado.componente;
       @@dshr.hrPaco = request.bienSiniestrado.parentesco;
       @@dshr.hrNrdf = request.beneficiario.filiatorio;
       @@dshr.hrSebe = request.beneficiario.beneficiario;
       @@dshr.hrRiec = request.bienSiniestrado.riesgo;
       @@dshr.hrXcob = request.bienSiniestrado.cobertura;
       @@dshr.hrFmoa = @@Fema;
       @@dshr.hrFmom = @@Femm;
       @@dshr.hrFmod = @@Femd;
       @@dshr.hrPsec = @@Psec;
       @@dshr.hrNupe = *zeros;
       @@dshr.hrNroc = *zeros;
       @@dshr.hrComa = @@Dsbe(1).beComa;
       @@dshr.hrNrma = @@Dsbe(1).beNrma;
       @@dshr.hrEsma = *zeros;
       @@dshr.hrMonr = request.monto.moneda;
       @@dshr.hrImmr = request.monto.importe;
       @@dshr.hrImnr = *zeros;
       @@dshr.hrMoeq = @@DSMon.moMoeq;
       @@dshr.hrImco = @@Imco;
       @@dshr.hrImau = @@Imau;
       @@dshr.hrImna = *zeros;
       @@dshr.hrMar1 = @@Dsbe(1).beMar1;
       @@dshr.hrMar2 = @@Dsbe(1).beMar2;
       @@dshr.hrMar3 = 'N';
       @@dshr.hrMar4 = *off;
       @@dshr.hrMar5 = *off;
       @@dshr.hrUser = request.usuario;
       @@dshr.hrTime = %dec(%time():*iso);
       @@dshr.hrFera = *year;
       @@dshr.hrFerm = *month;
       @@dshr.hrFerd = *day;
       @@dshr.hrTifa = *zeros;
       @@dshr.hrNrsf = *zeros;
       @@dshr.hrNrfa = *zeros;

       if  SVPSI1_chkPahshr( @@dshr.hrEmpr
                           : @@dshr.hrSucu
                           : @@dshr.hrRama
                           : @@dshr.hrSini
                           : @@dshr.hrNops
                           : @@dshr.hrPoco
                           : @@dshr.hrPaco
                           : @@dshr.hrNrdf
                           : @@dshr.hrSebe
                           : @@dshr.hrRiec
                           : @@dshr.hrXcob
                           : @@dshr.hrFmoa
                           : @@dshr.hrFmom
                           : @@dshr.hrFmod
                           : @@dshr.hrPsec) = *on;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit);
          return;
       endif;

       if SVPSI1_setPahshr(@@Dshr) = *off;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit);
          return;
       endif;


       // -------------------------------------
       // Ok - Actualizo Montos Beneficiario
       // -------------------------------------


       // replicando funcionalidad de Gaus NO actualizo
       // cotizacion en pahsbe
       @@DsBe(1).beImmr += request.monto.importe;

       if @@DsBe(1).beImco = *zeros;
          @@DsBe(1).beImau = @@DsBe(1).beImmr;
       else;
          @@DsBe(1).beImau = (@@DsBe(1).beImmr * @@DsBe(1).beImco);
       endif;

       if SVPSI1_updPahsbe( @@DsBe(1)) = *off;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit);
          return;
       endif;

       if SVPSI1_RecalBenef( request.caratula.empresa
                           : request.caratula.sucursal
                           : request.caratula.rama
                           : request.caratula.siniestro
                           : request.caratula.nroOperStro) = *off;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit);
          return;
       endif;

       REST_writeHeader( 201
                       : *omit
                       : *omit
                       : *omit
                       : *omit
                       : *omit
                       : *omit );

       SVPSIN_updCtaCte( request.caratula.rama
                       : request.caratula.siniestro
                       : request.caratula.nroOperStro);
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

