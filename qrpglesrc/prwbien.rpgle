     H nomain
      * ************************************************************ *
      * PRWBIEN: Completa Datos de Bienes                            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *14-Oct-2015            *
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
      *> TEXT('Prorama de Servicio: Trabajar Cotización') <*        *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((PRWBIEN)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((PRWBIEN)) <*         *
      *> IGN: DLTSPLF FILE(PRWBIEN)                           <*     *
      * Enlazar a:                                                   *
      *            COWGRAI                                           *
      *            SPVVEH                                            *
      *            SVPWS                                             *
      *            SVPVAL                                            *
      * ------------------------------------------------------------ *
      * SGF 05/08/2016: Recompilo por ACRC en CTWET0/ER0.            *
      * SGF 08/09/2016: En setVehiculo() invierto validación de motor*
      *                 y chasis.                                    *
      * SGF 19/10/2016: Grabo acreedor prendario.                    *
      * SGF 27/10/2016: Grabo "tiene/no tiene" en CTWINS.            *
      * SGF 30/11/2016: Cuando es renovación la patente duplicada    *
      *                 debe validarse vs fecha de fin de vigencia de*
      *                 la que se renueva.                           *
      * JSN 28/12/2016: Se agrego el campo Fecha de Inspección       *
      *                 INFINS                                       *
      * JSN 17/03/2017: En el procedimiento PRWBIEN_insertAseguradoV *
      *                 se cambio el campo peCate el cual se asignaba*
      *                 a v1cate por COWGRAI_getCategoria            *
      * LRG 28/03/2017: Se valida patente duplicada denttro de las   *
      *                 propuestas WEB                               *
      * LRG 28/03/2017: Se modifica validacion de patente duplicada  *
      *                 denttro de las propuestas WEB                *
      * JSN 14/03/2018: Se agrega validacion de inspeccion en el     *
      *                 servicio _setUbicacion                       *
      * LRG 05/06/2018: Se agrega validacion de Rastreadores, minimo *
      *                 se deben ingresar nombre de contacto y tel   *
      * SGF 12/03/2019: Depreco _setUbicacion() y _setUbicacion2().  *
      *                 Agrego _setUbicacion3() para poder recibir   *
      *                 Número de Puerta (NRDM). El servicio SOAP es *
      *                 PRWBIEN16.                                   *
      * EXT 17/01/2019: Se recompila por cambios en CTWET0           *
      * SGF 22/05/2019: En renovación busco el número de domicilio de*
      *                 la anterior.                                 *
      * JSN 10/06/2019: Se agrega validación de rango de edad en el  *
      *                 procedimiento valAseguradosV y se elimina    *
      *                 el giro de Fecha de Nacimiento valAsegurados *
      * LRG 15/10/2019: Se cambia llamada ed SVPWS_getGrupoRama por  *
      *                 SVPWS_getGrupoRamaArch                       *
      * SGF 04/05/2020: Veo si debo validar patentes duplicadas.     *
      * JSN 23/03/2020: Se agrega los procedimientos:                *
      *                 _setMascotaAsegurada()                       *
      *                 _dltMascotaAsegurada()                       *
      * JSN 17/04/2020: Se agrega monitor a los delete de los proce- *
      *                 dimientos _dltAsegurado()                    *
      *                           _dltObjetoAsegurado()              *
      *                           _dltMascotaAsegurada()             *
      *                                                              *
      * ************************************************************ *
     Fctwet0    uf a e           k disk    usropn
     Fctwins    uf a e           k disk    usropn
     Fctwetc01  if   e           k disk    usropn
     Fctwet1    uf a e           k disk    usropn
     Fssnrut1   if   e           k disk    usropn
     Fset243    if   e           k disk    usropn
     Fset107    if   e           k disk    usropn
     Fgnhda102  if   e           k disk    usropn
     Fctwer0    uf a e           k disk    usropn
     Fctwer1    uf a e           k disk    usropn
     Fctwer1b   uf a e           k disk    usropn
     Fctwer2    if   e           k disk    usropn
     Fctwer7    uf a e           k disk    usropn
     Fctwev1    uf a e           k disk    usropn
     Fctwev2    uf a e           k disk    usropn
     Fpahec0    if   e           k disk    usropn
     Fctw000    if   e           k disk    usropn
     Fsetpat01  if   e           k disk    usropn
     Fctwet003  if   e           k disk    rename (c1wet0:c1wet003) usropn
     Fpaher905  if   e           k disk    usropn
     Fctwera    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/prwbien_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global                                  *
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

      * --------------------------------------------------- *
      * Validaciones generales a todos los procedimientos   *
      * --------------------------------------------------- *
     D valGeneral      pr             1N
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  pePoco                        4  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

      * --------------------------------------------------- *
      * SP0082: Valida patente duplicada                    *
      * --------------------------------------------------- *
     D SP0082          pr                  EXTPGM('SP0082')
     D                                6  0 const
     D                                9  0 const
     D                               25    const
     D                                8  0 const
     D                                1
     D                                1
     D                                1    options(*nopass) const
     D                                2    options(*nopass) const
     D                                4  0 options(*nopass) const
     D                                6  0 options(*nopass)
     D                                7  0 options(*nopass)
     D                                2  0 options(*nopass)
     D                                7  0 options(*nopass)
     D                                4  0 options(*nopass)
     D                                8  0 options(*nopass)

      * --------------------------------------------------- *
      * SPFMTPAT: Recupera formato de patente               *
      * --------------------------------------------------- *
     D SPFMTPAT        pr                  ExtPgm('SPFMTPAT')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNmat                       25a   const
     D  peFech                        8a   const
     D  peTval                        1a   const
     D  peCuso                        1a   const
     D  peMcod                        3a
     D  peVald                        1a
     D  peRtco                        7a

      * -----------------------------------------------------------------*
      * PRWBIEN_setVehiculo(): Graba datos de Vehiculo                   *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePate (input)   Patente                                 *
      *         peChas (input)   Chasis                                  *
      *         peMoto (input)   Motor                                   *
      *         peAver (input)   Averías (S/N)                           *
      *         peNmer (input)   Nombre Tarjeta Circulación              *
      *         peAcrc (input)   Código de Acreedor Prendario            *
      *         peRuta (input)   Número de R.U.T.A.                      *
      *         peCesv (input)   OK CESVI (S/N)                          *
      *         peIris (input)   OK IRIS (S/N)                           *
      *         peInsp (input)   Datos de Inspección                     *
      *         peVhuv (input)   Uso del Vehículo                        *
      *         peRast (input)   Datos de Rastreador                     *
      *         peAcce (input)   Accesorios                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_setVehiculo...
     P                 B                   Export
     D PRWBIEN_setVehiculo...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePate                      25    const
     D   peChas                      25    const
     D   peMoto                      25    const
     D   peAver                       1    const
     D   peNmer                      40    const
     D   peAcrc                       7  0 const
     D   peRuta                      16  0 const
     D   peCesv                       1    const
     D   peIris                       1    const
     D   peVhuv                       2  0 const
     D   peInsp                            likeds(prwbienInsp_t) const
     D   peRast                            likeds(prwbienRast_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1w000          ds                  likerec(c1w000:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1nrut1         ds                  likerec(s1nrut1:*key)
     D k1wins          ds                  likerec(c1wins:*key)
     D k1hec0          ds                  likerec(p1hec0:*key)
     D k1tpat          ds                  likerec(s1tpat:*key)

     D rc              s              1N
     D erro            s              1
     D err2            s              1
     D x               s             10i 0
     D peMcod          s              3a
     D peVald          s              1a
     D peRtco          s              7a
     D peTmat          s              3a
     D @aver           s              1a
     D @cras           s              3  0
     D @pate           s             25a
     D @repl           s          65535a
     D pattern         s             25a   varying
     D fechPat         s              8  0
     D @@valsys        S            512
     D reg             ds                  likeds(regex_t)
     D match           ds                  likeds(regmatch_t)

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de auto
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'A';
            %subst(wrepl:1:2) = %editc(peRama:'X');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0067'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haberse seleccionado una cobertura
       // ------------------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       k1wetc.t0rama = peRama;
       k1wetc.t0arse = peArse;
       k1wetc.t0poco = pePoco;
       chain %kds(k1wetc:8) ctwetc01;
       if not %found;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0066'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       @pate = %xlate( min : may : pePate );

       // ------------------------------------------------
       // Busco máscara para la patente que llegó
       // ------------------------------------------------
       SPFMTPAT( peBase.peEmpr
               : peBase.peSucu
               : @pate
               : %char(%date():*ymd)
               : '2'
               : 'A'
               : peTmat
               : peVald
               : peRtco             );
       if %trim(peRtco) <> 'OK';
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0050'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       k1tpat.ptempr = peBase.peEmpr;
       k1tpat.ptsucu = peBase.peSucu;
       k1tpat.ptmcod = peTmat;
       chain %kds(k1tpat:3) setpat01;
       if %found;
          if ptmbaj <> ' ' or ptmweb <> '1';
             %subst(wrepl:1:6) = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0050'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Valido Patente Duplicada contra GAUS
       // ------------------------------------------------
       fechPat = %dec(%date():*eur);
       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain %kds(k1w000:5) ctw000;
       if %found;
          if w0tiou = 2;
             k1hec0.c0empr = w0empr;
             k1hec0.c0sucu = w0sucu;
             k1hec0.c0arcd = w0arcd;
             k1hec0.c0spol = w0spo1;
             chain %kds(k1hec0) pahec0;
             if %found;
                fechPat = (c0fvod * 1000000)
                        + (c0fvom *   10000)
                        +  c0fvoa;
             endif;
          endif;
       endif;

       // ------------------------------------
       // Veo si debo validar patente dupl
       // 'B' = Valida PRWBIEN
       // 'S' = Valida PRWSND
       // ------------------------------------
       @@ValSys = 'B';
       if SVPVLS_getValsys('HVALPATDUP':*omit:@@ValSys );
          if @@ValSys = 'S';
             peVald = 'S';
          endif;
       endif;
       if peVald = 'N';
          SP0082( *Zeros
                : *Zeros
                : @pate
                : fechPat
                : erro
                : err2
                : peBase.peEmpr
                : peBase.peSucu
                : pePoco );
          if ( erro = 'E' );
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0042'
                          : peMsgs );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Valido Patente Duplicada vs = propuesta
       //
       // ¡¡¡ ATENCION !!!
       // Descartada una duplicidad contra GAUS (SP0082),
       // barro acá la misma propuesta para ver si alguien
       // si quiso pasar de pillo y mandó mas de una vez la
       // misma patente.
       // Ahora bien, sólo barro la MISMA propuesta web, con
       // lo que queda un sólo agujerito: barrer TODAS las
       // otras propuestas que aún no están emitidas. Para
       // no quedarnos a vivir, por el momento no lo implemen-
       // to... pero si vemos que se empiezan a mandar por
       // ahí, se tendrán que bancar el loop...
       //
       // ------------------------------------------------
       k1wet0.t0empr = PeBase.peEmpr;
       k1wet0.t0sucu = PeBase.peSucu;
       k1wet0.t0nivt = PeBase.peNivt;
       k1wet0.t0nivc = PeBase.peNivc;
       k1wet0.t0nctw = peNctw;
       k1wet0.t0rama = peRama;
       setll %kds(k1wet0:6) ctwet0;
       reade(n) %kds(k1wet0:6) ctwet0;
       dow not %eof;

       //
       // Es el mismo componente: no le doy bola
       //
           if t0poco <> pePoco;
              if t0nmat = @pate;
                 if peVald = 'N';
                    //
                    // peVald:
                    // "N" = No se permite duplicado
                    // "S" = Sí se permite duplicado
                    //
                    SVPWS_getMsgs( '*LIBL'
                                 : 'WSVMSG'
                                 : 'COW0042'
                                 : peMsgs );
                    peErro = -1;
                    return;
                 endif;
              endif;
           endif;

        reade(n) %kds(k1wet0:6) ctwet0;
       enddo;

       pattern = '^[a-zA-Z0-9]+$';
       x  = regcomp( reg
                   : pattern
                   : REG_EXTENDED + REG_ICASE + REG_NOSUB);

       // ------------------------------------------------
       // Valido Motor (no blanco)
       // ------------------------------------------------
       if not SPVVEH_CheckMotor ( peMoto );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0039'
                       : peMsgs );
          peErro = -1;
          return;
       endif;
       if %checkr(' ':peMoto) <= 3;
          %subst(wrepl:1:6) = 'Motor';
          %subst(wrepl:7:1) = '4';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0135'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;
       if regexec( reg
                 : %trim(peMoto)
                 : 0
                 : match
                 : 0) <> *zeros;
          %subst(wrepl:1:6) = 'Motor';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0136'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Chasis (no blanco)
       // ------------------------------------------------
       if not SPVVEH_CheckChasis ( peChas );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0038'
                       : peMsgs );
          peErro = -1;
          return;
       endif;
       if %checkr(' ':peChas) <= 5;
          %subst(wrepl:1:6) = 'Chasis';
          %subst(wrepl:7:1) = '6';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0135'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;
       if regexec( reg
                 : %trim(peChas)
                 : 0
                 : match
                 : 0) <> *zeros;
          %subst(wrepl:1:6) = 'Chasis';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0136'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Marca de Averías
       // ------------------------------------------------
       @aver = *blank;
       if peAver = 'S';
          @aver = '1';
       endif;
       if peAver = 'N';
          @aver = '0';
       endif;
       if not SPVVEH_CheckAveria ( @aver  );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0043'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Uso
       // ------------------------------------------------
       if SPVVEH_checkCodUso( peVhuv ) = *OFF;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0072'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Mercosur
       // ------------------------------------------------
       if not SPVVEH_CheckTarjMercosur ( peNmer );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0044'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Acc. Prendario
       // ------------------------------------------------
       if peAcrc <> 0;
          if not SPVVEH_CheckAcPrendario ( peAcrc );
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0045'
                          : peMsgs );
             peErro = -1;
             return;
          endif;
          setll peAcrc gnhda102;
          if not %equal;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0075'
                          : peMsgs );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Valido CESVI
       // ------------------------------------------------
       if peCesv <> 'S' and peCesv <> 'N';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0047'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido IRIS
       // ------------------------------------------------
       if peIris <> 'S' and peIris <> 'N';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0048'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido RUTA
       // ------------------------------------------------
       k1wet0.t0empr = PeBase.peEmpr;
       k1wet0.t0sucu = PeBase.peSucu;
       k1wet0.t0nivt = PeBase.peNivt;
       k1wet0.t0nivc = PeBase.peNivc;
       k1wet0.t0nctw = peNctw;
       k1wet0.t0rama = peRama;
       k1wet0.t0poco = pePoco;
       k1wet0.t0arse = peArse;
       chain(n) %kds(k1wet0:8) ctwet0;
       if %found;
          k1nrut1.s@empr = peBase.peEmpr;
          k1nrut1.s@sucu = peBase.peSucu;
          k1nrut1.s@vhca = t0vhca;
          k1nrut1.s@vhuv = peVhuv;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          setll %kds(k1nrut1) ssnrut1;
          if %equal and peRuta = 0;
             //SVPWS_getMsgs( '*LIBL'
             //             : 'WSVMSG'
             //             : 'COW0070'
             //             : peMsgs
             //             : %trim(wrepl)
             //             : %len(%trim(wrepl))  );
             //peErro = -1;
             //return;
          endif;
          if not %equal and peRuta <> 0;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0071'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Rastreador:
       //   Si Requiere:
       //                Si ya tiene: debe ser válido
       //                Si no tiene: asigna la emisión
       //   Si No requiere:
       //                No carga nada
       // ------------------------------------------------
       PRWBIEN_clearRastreador( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : peErro
                              : peMsgs );
       peErro = 0;
       clear peMsgs;
       wrepl = *blanks;
       if (t0rras = 'S');
          if peRast.have <> 'S' and peRast.have <> 'N';
             %subst(wrepl:1:4) = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0039'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
          if peRast.have = 'S';
             setll peRast.rast set243;
             if not %equal;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0049'
                             : peMsgs );
                peErro = -1;
                return;
             endif;
             k1wins.inempr = peBase.peEmpr;
             k1wins.insucu = peBase.peSucu;
             k1wins.innivt = peBase.peNivt;
             k1wins.innivc = peBase.peNivc;
             k1wins.innctw = peNctw;
             k1wins.intipo = 'R';
             k1wins.inrama = peRama;
             k1wins.inpoco = pePoco;
             k1wins.inarse = peArse;
             chain %kds(k1wins:9) ctwins;
             if %found;
                innomb = peRast.nomb;
                indomi = peRast.domi;
                inntel = peRast.ntel;
                innte1 = peRast.nte1;
                inmail = peRast.mail;
                inhdes = peRast.hdes;
                inhhas = peRast.hhas;
                incras = peRast.rast;
                indras = peRast.dras;
                inma01 = peRast.have;
                update c1wins;
              else;
                inempr = peBase.peEmpr;
                insucu = peBase.peSucu;
                innivt = peBase.peNivt;
                innivc = peBase.peNivc;
                innctw = peNctw;
                inrama = peRama;
                inarse = peArse;
                inpoco = pePoco;
                intipo = 'R';
                innomb = peRast.nomb;
                indomi = peRast.domi;
                inntel = peRast.ntel;
                innte1 = peRast.nte1;
                inmail = peRast.mail;
                inhdes = peRast.hdes;
                inhhas = peRast.hhas;
                incras = peRast.rast;
                indras = peRast.dras;
                inma01 = peRast.have;
                write c1wins;
             endif;
          else;
            // Valida Datos de contacto...
            if peRast.nomb = *blanks and
               peRast.ntel = *blanks;
               %subst(wrepl:1:6) = %trim(%char(pePoco));
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0054'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );
               peMsgs.PEMSG2 = 'Por favor ingresar Nombre y Telefono '
                             + 'de contacto';
               peErro = -1;
               return;
            endif;

            k1wins.inempr = peBase.peEmpr;
            k1wins.insucu = peBase.peSucu;
            k1wins.innivt = peBase.peNivt;
            k1wins.innivc = peBase.peNivc;
            k1wins.innctw = peNctw;
            k1wins.intipo = 'R';
            k1wins.inrama = peRama;
            k1wins.inpoco = pePoco;
            k1wins.inarse = peArse;
            chain %kds(k1wins:9) ctwins;
            if %found;
               innomb = peRast.nomb;
               indomi = peRast.domi;
               inntel = peRast.ntel;
               innte1 = peRast.nte1;
               inmail = peRast.mail;
               inhdes = peRast.hdes;
               inhhas = peRast.hhas;
               incras = 0;
               indras = *blanks;
               inma01 = peRast.have;
               update c1wins;
             else;
               inempr = peBase.peEmpr;
               insucu = peBase.peSucu;
               innivt = peBase.peNivt;
               innivc = peBase.peNivc;
               innctw = peNctw;
               inrama = peRama;
               inarse = peArse;
               inpoco = pePoco;
               intipo = 'R';
               innomb = peRast.nomb;
               indomi = peRast.domi;
               inntel = peRast.ntel;
               innte1 = peRast.nte1;
               inmail = peRast.mail;
               inhdes = peRast.hdes;
               inhhas = peRast.hhas;
               incras = 0;
               indras = *blanks;
               inma01 = peRast.have;
               write c1wins;
            endif;
          endif;
       endif;

       // ------------------------------------------------
       // Inspeccion: si requiere, valido datos mínimos
       // Requiere inspección viene de CTWETC ya que
       // depende de la cobertura
       // ------------------------------------------------
       if (t0rins = 'S');
          if peInsp.nomb = *blanks and
             peInsp.ntel = *blanks and
             peInsp.nte1 = *blanks and
             peInsp.mail = *blanks;
             %subst(wrepl:1:6) = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0053'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       PRWBIEN_clearInspeccion( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : peErro
                              : peMsgs );
       peErro = 0;
       clear peMsgs;
       if peInsp.nomb <> *blanks or
          peInsp.domi <> *blanks or
          peInsp.ntel <> *blanks or
          peInsp.nte1 <> *blanks or
          peInsp.mail <> *blanks or
          peInsp.hdes <> *zeros  or
          peInsp.hhas <> *zeros  or
          peInsp.nrin <> *blanks or
          peInsp.ctro <> *blanks or
          peInsp.come <> *blanks or
          peInsp.tipo <> *blanks or
            //* Que pasa si la fecha siempre viene en blanco

            k1wins.inempr = peBase.peEmpr;
            k1wins.insucu = peBase.peSucu;
            k1wins.innivt = peBase.peNivt;
            k1wins.innivc = peBase.peNivc;
            k1wins.innctw = peNctw;
            k1wins.intipo = 'I';
            k1wins.inrama = peRama;
            k1wins.inpoco = pePoco;
            k1wins.inarse = peArse;
            chain %kds(k1wins:9) ctwins;
            if %found;
               indomi = peInsp.domi;
               inntel = peInsp.ntel;
               innte1 = peInsp.nte1;
               inmail = peInsp.mail;
               inhdes = peInsp.hdes;
               inhhas = peInsp.hhas;
               innrin = peInsp.nrin;
               inctro = peInsp.ctro;
               income = peInsp.come;
               inmarc = peInsp.tipo;
               innomb = peInsp.nomb;
               update c1wins;
             else;
               inempr = peBase.peEmpr;
               insucu = peBase.peSucu;
               innivt = peBase.peNivt;
               innivc = peBase.peNivc;
               innctw = peNctw;
               inrama = peRama;
               inarse = peArse;
               inpoco = pePoco;
               intipo = 'I';
               indomi = peInsp.domi;
               inntel = peInsp.ntel;
               innte1 = peInsp.nte1;
               inmail = peInsp.mail;
               inhdes = peInsp.hdes;
               inhhas = peInsp.hhas;
               innrin = peInsp.nrin;
               inctro = peInsp.ctro;
               income = peInsp.come;
               inmarc = peInsp.tipo;
               innomb = peInsp.nomb;
               write c1wins;
          endif;
       endif;

       // ------------------------------------------------
       // Obtengo Cabecera de Vehiculo
       // ------------------------------------------------
       k1wet0.t0empr = PeBase.peEmpr;
       k1wet0.t0sucu = PeBase.peSucu;
       k1wet0.t0nivt = PeBase.peNivt;
       k1wet0.t0nivc = PeBase.peNivc;
       k1wet0.t0nctw = peNctw;
       k1wet0.t0rama = peRama;
       k1wet0.t0arse = peArse;
       k1wet0.t0poco = pePoco;
       chain %kds( k1wet0 : 8 ) ctwet0;
       if %found;
          t0tmat = peTmat;
          t0nmat = @pate;
          t0chas = %xlate(min:may:peChas);
          t0moto = %xlate(min:may:peMoto);
          t0aver = @aver;
          t0Nmer = %xlate(min:may:peNmer);
          t0ruta = peRuta;
          t0cesv = peCesv;
          t0iris = peIris;
          t0vhuv = peVhuv;
          t0acrc = peAcrc;
          update c1wet0;
       endif;

       return;

      /end-free

     P PRWBIEN_setVehiculo...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_setVehiculo2(): Graba datos de Vehiculo                  *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePate (input)   Patente                                 *
      *         peChas (input)   Chasis                                  *
      *         peMoto (input)   Motor                                   *
      *         peAver (input)   Averías (S/N)                           *
      *         peNmer (input)   Nombre Tarjeta Circulación              *
      *         peAcrc (input)   Código de Acreedor Prendario            *
      *         peRuta (input)   Número de R.U.T.A.                      *
      *         peCesv (input)   OK CESVI (S/N)                          *
      *         peIris (input)   OK IRIS (S/N)                           *
      *         peInsp (input)   Datos de Inspección                     *
      *         peVhuv (input)   Uso del Vehículo                        *
      *         peRast (input)   Datos de Rastreador                     *
      *         peAcce (input)   Accesorios                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_setVehiculo2...
     P                 B                   Export
     D PRWBIEN_setVehiculo2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePate                      25    const
     D   peChas                      25    const
     D   peMoto                      25    const
     D   peAver                       1    const
     D   peNmer                      40    const
     D   peAcrc                       7  0 const
     D   peRuta                      16  0 const
     D   peCesv                       1    const
     D   peIris                       1    const
     D   peVhuv                       2  0 const
     D   peInsp                            likeds(prwbienInsp_t2) const
     D   peRast                            likeds(prwbienRast_t ) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1w000          ds                  likerec(c1w000:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1nrut1         ds                  likerec(s1nrut1:*key)
     D k1wins          ds                  likerec(c1wins:*key)
     D k1hec0          ds                  likerec(p1hec0:*key)
     D k1tpat          ds                  likerec(s1tpat:*key)
     D k1wet03         ds                  likerec(c1wet003:*key)

     D rc              s              1N
     D erro            s              1
     D err2            s              1
     D x               s             10i 0
     D peMcod          s              3a
     D peVald          s              1a
     D peRtco          s              7a
     D peTmat          s              3a
     D @aver           s              1a
     D @cras           s              3  0
     D @pate           s             25a
     D @repl           s          65535a
     D pattern         s             25a   varying
     D fechPat         s              8  0
     D @@valsys        S            512
     D reg             ds                  likeds(regex_t)
     D match           ds                  likeds(regmatch_t)

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de auto
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'A';
            %subst(wrepl:1:2) = %editc(peRama:'X');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0067'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haberse seleccionado una cobertura
       // ------------------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       k1wetc.t0rama = peRama;
       k1wetc.t0arse = peArse;
       k1wetc.t0poco = pePoco;
       chain %kds(k1wetc:8) ctwetc01;
       if not %found;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0066'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       @pate = %xlate( min : may : pePate );

       // ------------------------------------------------
       // Busco máscara para la patente que llegó
       // ------------------------------------------------
       SPFMTPAT( peBase.peEmpr
               : peBase.peSucu
               : @pate
               : %char(%date():*ymd)
               : '2'
               : 'A'
               : peTmat
               : peVald
               : peRtco             );
       if %trim(peRtco) <> 'OK';
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0050'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       k1tpat.ptempr = peBase.peEmpr;
       k1tpat.ptsucu = peBase.peSucu;
       k1tpat.ptmcod = peTmat;
       chain %kds(k1tpat:3) setpat01;
       if %found;
          if ptmbaj <> ' ' or ptmweb <> '1';
             %subst(wrepl:1:6) = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0050'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Valido Patente Duplicada contra GAUS
       // ------------------------------------------------
       fechPat = %dec(%date():*eur);
       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain %kds(k1w000:5) ctw000;
       if %found;
          if w0tiou = 2;
             k1hec0.c0empr = w0empr;
             k1hec0.c0sucu = w0sucu;
             k1hec0.c0arcd = w0arcd;
             k1hec0.c0spol = w0spo1;
             chain %kds(k1hec0) pahec0;
             if %found;
                fechPat = (c0fvod * 1000000)
                        + (c0fvom *   10000)
                        +  c0fvoa;
             endif;
          endif;
       endif;

       // ------------------------------------
       // Veo si debo validar patente dupl
       // 'B' = Valida PRWBIEN
       // 'S' = Valida PRWSND
       // ------------------------------------
       @@ValSys = 'B';
       if SVPVLS_getValsys('HVALPATDUP':*omit:@@ValSys );
          if @@ValSys = 'S';
             peVald = 'S';
          endif;
       endif;
       if peVald = 'N';
          SP0082( *Zeros
                : *Zeros
                : @pate
                : fechPat
                : erro
                : err2
                : peBase.peEmpr
                : peBase.peSucu
                : pePoco );
          if ( erro = 'E' );
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0042'
                          : peMsgs );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Valido Patente Duplicada vs = propuesta
       //
       // ¡¡¡ ATENCION !!!
       // Descartada una duplicidad contra GAUS (SP0082),
       // barro acá la misma propuesta para ver si alguien
       // si quiso pasar de pillo y mandó mas de una vez la
       // misma patente.
       // Ahora bien, sólo barro la MISMA propuesta web, con
       // lo que queda un sólo agujerito: barrer TODAS las
       // otras propuestas que aún no están emitidas. Para
       // no quedarnos a vivir, por el momento no lo implemen-
       // to... pero si vemos que se empiezan a mandar por
       // ahí, se tendrán que bancar el loop...
       //
       // ------------------------------------------------
       //k1wet0.t0empr = PeBase.peEmpr;
       //k1wet0.t0sucu = PeBase.peSucu;
       //k1wet0.t0nivt = PeBase.peNivt;
       //k1wet0.t0nivc = PeBase.peNivc;
       //k1wet0.t0nctw = peNctw;
       //k1wet0.t0rama = peRama;
       //setll %kds(k1wet0:6) ctwet0;
       //reade(n) %kds(k1wet0:6) ctwet0;
       //dow not %eof;

           //
           // Es el mismo componente: no le doy bola
           //
       //    if t0poco <> pePoco;
       //       if t0nmat = @pate;
       //          if peVald = 'N';
                    //
                    // peVald:
                    // "N" = No se permite duplicado
                    // "S" = Sí se permite duplicado
                    //
        //            SVPWS_getMsgs( '*LIBL'
        //                         : 'WSVMSG'
        //                         : 'COW0042'
        //                         : peMsgs );
        //            peErro = -1;
        //            return;
        //         endif;
        //      endif;
        //   endif;

       // reade(n) %kds(k1wet0:6) ctwet0;
       //enddo;

       // --------------------------------------------------//
       // Se valida patente duplicada dentro de propuestas  //
       // WEB                                               //
       // --------------------------------------------------//
       k1wet03.t0nmat = @pate;
       if peVald = 'N';
          setll %kds( k1wet03 : 1 ) ctwet003;
          reade(n) %kds( k1wet03 : 1 ) ctwet003;
          dow not %eof( ctwet003 );
            if t0nctw = peNctw;
              if t0poco <> pePoco;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0042'
                             : peMsgs );
                peErro = -1;
                return;
              endif;
            else;
              k1w000.w0empr = peBase.peEmpr;
              k1w000.w0sucu = peBase.peSucu;
              k1w000.w0nivt = peBase.peNivt;
              k1w000.w0nivc = peBase.peNivc;
              k1w000.w0nctw = t0nctw;
              chain %kds(k1w000:5) ctw000;
              if %found( ctw000 );
                if ( w0cest = 1 and w0cses  = 9 ) or
                   ( w0cest = 5 and w0cses  = 6 ) or
                   ( w0cest = 7 and w0cses  = 6 ) or
                   ( w0cest = 7 and w0cses  = 7 );
                else;
                   %subst(wrepl:1:25) = %trim(t0nmat);
                   SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'COW0145'
                                : peMsgs
                                : %trim(wrepl)
                                : %len(%trim(wrepl))  );
                    peErro = -1;
                   return;
                endif;
              endif;
            endif;
           reade(n) %kds( k1wet03 : 1 ) ctwet003;
          enddo;

       endif;

       pattern = '^[a-zA-Z0-9]+$';
       x  = regcomp( reg
                   : pattern
                   : REG_EXTENDED + REG_ICASE + REG_NOSUB);

       // ------------------------------------------------
       // Valido Motor (no blanco)
       // ------------------------------------------------
       if not SPVVEH_CheckMotor ( peMoto );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0039'
                       : peMsgs );
          peErro = -1;
          return;
       endif;
       if %checkr(' ':peMoto) <= 3;
          %subst(wrepl:1:6) = 'Motor';
          %subst(wrepl:7:1) = '4';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0135'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;
       if regexec( reg
                 : %trim(peMoto)
                 : 0
                 : match
                 : 0) <> *zeros;
          %subst(wrepl:1:6) = 'Motor';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0136'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Chasis (no blanco)
       // ------------------------------------------------
       if not SPVVEH_CheckChasis ( peChas );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0038'
                       : peMsgs );
          peErro = -1;
          return;
       endif;
       if %checkr(' ':peChas) <= 5;
          %subst(wrepl:1:6) = 'Chasis';
          %subst(wrepl:7:1) = '6';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0135'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;
       if regexec( reg
                 : %trim(peChas)
                 : 0
                 : match
                 : 0) <> *zeros;
          %subst(wrepl:1:6) = 'Chasis';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0136'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Marca de Averías
       // ------------------------------------------------
       @aver = *blank;
       if peAver = 'S';
          @aver = '1';
       endif;
       if peAver = 'N';
          @aver = '0';
       endif;
       if not SPVVEH_CheckAveria ( @aver  );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0043'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Uso
       // ------------------------------------------------
       if SPVVEH_checkCodUso( peVhuv ) = *OFF;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0072'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Mercosur
       // ------------------------------------------------
       if not SPVVEH_CheckTarjMercosur ( peNmer );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0044'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido Acc. Prendario
       // ------------------------------------------------
       if peAcrc <> 0;
          if not SPVVEH_CheckAcPrendario ( peAcrc );
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0045'
                          : peMsgs );
             peErro = -1;
             return;
          endif;
          setll peAcrc gnhda102;
          if not %equal;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0075'
                          : peMsgs );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Valido CESVI
       // ------------------------------------------------
       if peCesv <> 'S' and peCesv <> 'N';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0047'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido IRIS
       // ------------------------------------------------
       if peIris <> 'S' and peIris <> 'N';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0048'
                       : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido RUTA
       // ------------------------------------------------
       k1wet0.t0empr = PeBase.peEmpr;
       k1wet0.t0sucu = PeBase.peSucu;
       k1wet0.t0nivt = PeBase.peNivt;
       k1wet0.t0nivc = PeBase.peNivc;
       k1wet0.t0nctw = peNctw;
       k1wet0.t0rama = peRama;
       k1wet0.t0poco = pePoco;
       k1wet0.t0arse = peArse;
       chain(n) %kds(k1wet0:8) ctwet0;
       if %found;
          k1nrut1.s@empr = peBase.peEmpr;
          k1nrut1.s@sucu = peBase.peSucu;
          k1nrut1.s@vhca = t0vhca;
          k1nrut1.s@vhuv = peVhuv;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          setll %kds(k1nrut1) ssnrut1;
          if %equal and peRuta = 0;
             //SVPWS_getMsgs( '*LIBL'
             //             : 'WSVMSG'
             //             : 'COW0070'
             //             : peMsgs
             //             : %trim(wrepl)
             //             : %len(%trim(wrepl))  );
             //peErro = -1;
             //return;
          endif;
          if not %equal and peRuta <> 0;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0071'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Rastreador:
       //   Si Requiere:
       //                Si ya tiene: debe ser válido
       //                Si no tiene: asigna la emisión
       //   Si No requiere:
       //                No carga nada
       // ------------------------------------------------
       PRWBIEN_clearRastreador( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : peErro
                              : peMsgs );
       peErro = 0;
       clear peMsgs;
       wrepl = *blanks;
       if (t0rras = 'S');
          if peRast.have <> 'S' and peRast.have <> 'N';
             %subst(wrepl:1:4) = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0039'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
          if peRast.have = 'S';
             setll peRast.rast set243;
             if not %equal;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0049'
                             : peMsgs );
                peErro = -1;
                return;
             endif;
             k1wins.inempr = peBase.peEmpr;
             k1wins.insucu = peBase.peSucu;
             k1wins.innivt = peBase.peNivt;
             k1wins.innivc = peBase.peNivc;
             k1wins.innctw = peNctw;
             k1wins.intipo = 'R';
             k1wins.inrama = peRama;
             k1wins.inpoco = pePoco;
             k1wins.inarse = peArse;
             chain %kds(k1wins:9) ctwins;
             if %found;
                innomb = peRast.nomb;
                indomi = peRast.domi;
                inntel = peRast.ntel;
                innte1 = peRast.nte1;
                inmail = peRast.mail;
                inhdes = peRast.hdes;
                inhhas = peRast.hhas;
                incras = peRast.rast;
                indras = peRast.dras;
                inma01 = peRast.have;
                update c1wins;
              else;
                inempr = peBase.peEmpr;
                insucu = peBase.peSucu;
                innivt = peBase.peNivt;
                innivc = peBase.peNivc;
                innctw = peNctw;
                inrama = peRama;
                inarse = peArse;
                inpoco = pePoco;
                intipo = 'R';
                innomb = peRast.nomb;
                indomi = peRast.domi;
                inntel = peRast.ntel;
                innte1 = peRast.nte1;
                inmail = peRast.mail;
                inhdes = peRast.hdes;
                inhhas = peRast.hhas;
                incras = peRast.rast;
                indras = peRast.dras;
                inma01 = peRast.have;
                write c1wins;
             endif;
           else;
             // Valida Datos de contacto...
             if peRast.nomb = *blanks or
                peRast.ntel = *blanks;
                %subst(wrepl:1:6) = %trim(%char(pePoco));
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0054'
                             : peMsgs
                             : %trim(wrepl)
                             : %len(%trim(wrepl))  );
                peMsgs.PEMSG2 = 'Por favor ingresar Nombre y Telefono '
                              + 'de contacto';
                peErro = -1;
                return;
             endif;
             k1wins.inempr = peBase.peEmpr;
             k1wins.insucu = peBase.peSucu;
             k1wins.innivt = peBase.peNivt;
             k1wins.innivc = peBase.peNivc;
             k1wins.innctw = peNctw;
             k1wins.intipo = 'R';
             k1wins.inrama = peRama;
             k1wins.inpoco = pePoco;
             k1wins.inarse = peArse;
             chain %kds(k1wins:9) ctwins;
             if %found;
                innomb = peRast.nomb;
                indomi = peRast.domi;
                inntel = peRast.ntel;
                innte1 = peRast.nte1;
                inmail = peRast.mail;
                inhdes = peRast.hdes;
                inhhas = peRast.hhas;
                incras = 0;
                indras = *blanks;
                inma01 = peRast.have;
                update c1wins;
              else;
                inempr = peBase.peEmpr;
                insucu = peBase.peSucu;
                innivt = peBase.peNivt;
                innivc = peBase.peNivc;
                innctw = peNctw;
                inrama = peRama;
                inarse = peArse;
                inpoco = pePoco;
                intipo = 'R';
                innomb = peRast.nomb;
                indomi = peRast.domi;
                inntel = peRast.ntel;
                innte1 = peRast.nte1;
                inmail = peRast.mail;
                inhdes = peRast.hdes;
                inhhas = peRast.hhas;
                incras = 0;
                indras = *blanks;
                inma01 = peRast.have;
                write c1wins;
             endif;
          endif;
       endif;

       // ------------------------------------------------
       // Inspeccion: si requiere, valido datos mínimos
       // Requiere inspección viene de CTWETC ya que
       // depende de la cobertura
       // ------------------------------------------------
       if (t0rins = 'S');
          if peInsp.nomb = *blanks and
             peInsp.ntel = *blanks and
             peInsp.nte1 = *blanks and
             peInsp.mail = *blanks;
             %subst(wrepl:1:6) = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0053'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
          If peInsp.fins < %dec(%date():*iso);
             %subst(wrepl:1:6) = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0045'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       PRWBIEN_clearInspeccion( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : peErro
                              : peMsgs );
       peErro = 0;
       clear peMsgs;
       if peInsp.nomb <> *blanks or
          peInsp.domi <> *blanks or
          peInsp.ntel <> *blanks or
          peInsp.nte1 <> *blanks or
          peInsp.mail <> *blanks or
          peInsp.hdes <> *zeros  or
          peInsp.hhas <> *zeros  or
          peInsp.nrin <> *blanks or
          peInsp.ctro <> *blanks or
          peInsp.come <> *blanks or
          peInsp.tipo <> *blanks or
          peInsp.fins <> *zeros;
            //* Que pasa si la fecha siempre viene en blanco

            k1wins.inempr = peBase.peEmpr;
            k1wins.insucu = peBase.peSucu;
            k1wins.innivt = peBase.peNivt;
            k1wins.innivc = peBase.peNivc;
            k1wins.innctw = peNctw;
            k1wins.intipo = 'I';
            k1wins.inrama = peRama;
            k1wins.inpoco = pePoco;
            k1wins.inarse = peArse;
            chain %kds(k1wins:9) ctwins;
            if %found;
               indomi = peInsp.domi;
               inntel = peInsp.ntel;
               innte1 = peInsp.nte1;
               inmail = peInsp.mail;
               inhdes = peInsp.hdes;
               inhhas = peInsp.hhas;
               innrin = peInsp.nrin;
               inctro = peInsp.ctro;
               income = peInsp.come;
               inmarc = peInsp.tipo;
               innomb = peInsp.nomb;
               infins = peInsp.fins;
               update c1wins;
             else;
               inempr = peBase.peEmpr;
               insucu = peBase.peSucu;
               innivt = peBase.peNivt;
               innivc = peBase.peNivc;
               innctw = peNctw;
               inrama = peRama;
               inarse = peArse;
               inpoco = pePoco;
               intipo = 'I';
               indomi = peInsp.domi;
               inntel = peInsp.ntel;
               innte1 = peInsp.nte1;
               inmail = peInsp.mail;
               inhdes = peInsp.hdes;
               inhhas = peInsp.hhas;
               innrin = peInsp.nrin;
               inctro = peInsp.ctro;
               income = peInsp.come;
               inmarc = peInsp.tipo;
               innomb = peInsp.nomb;
               infins = peInsp.fins;
               write c1wins;
          endif;
       endif;

       // ------------------------------------------------
       // Obtengo Cabecera de Vehiculo
       // ------------------------------------------------
       k1wet0.t0empr = PeBase.peEmpr;
       k1wet0.t0sucu = PeBase.peSucu;
       k1wet0.t0nivt = PeBase.peNivt;
       k1wet0.t0nivc = PeBase.peNivc;
       k1wet0.t0nctw = peNctw;
       k1wet0.t0rama = peRama;
       k1wet0.t0arse = peArse;
       k1wet0.t0poco = pePoco;
       chain %kds( k1wet0 : 8 ) ctwet0;
       if %found;
          t0tmat = peTmat;
          t0nmat = @pate;
          t0chas = %xlate(min:may:peChas);
          t0moto = %xlate(min:may:peMoto);
          t0aver = @aver;
          t0Nmer = %xlate(min:may:peNmer);
          t0ruta = peRuta;
          t0cesv = peCesv;
          t0iris = peIris;
          t0vhuv = peVhuv;
          t0acrc = peAcrc;
          update c1wet0;
       endif;

       return;

      /end-free

     P PRWBIEN_setVehiculo2...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_clearInspección(): Elimina Datos de Inspección           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_clearInspeccion...
     P                 B                   export
     D PRWBIEN_clearInspeccion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              1N

     D k1wins          ds                  likerec(c1wins:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de auto
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'A';
            %subst(wrepl:1:2) = %editc(peRama:'X');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0067'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haberse seleccionado una cobertura
       // ------------------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       k1wetc.t0rama = peRama;
       k1wetc.t0arse = peArse;
       k1wetc.t0poco = pePoco;
       chain %kds(k1wetc:8) ctwetc01;
       if not %found;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0066'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haber datos de inspección cargados
       // ------------------------------------------------
       k1wins.inempr = peBase.peEmpr;
       k1wins.insucu = peBase.peSucu;
       k1wins.innivt = peBase.peNivt;
       k1wins.innivc = peBase.peNivc;
       k1wins.innctw = peNctw;
       k1wins.intipo = 'I';
       k1wins.inrama = peRama;
       k1wins.inpoco = pePoco;
       k1wins.inarse = peArse;
       chain %kds(k1wins) ctwins;
       if %found;
          delete c1wins;
        else;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          %subst(wrepl:7:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0055'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
       endif;

       return;

      /end-free

     P PRWBIEN_clearInspeccion...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_clearRastreador(): Elimina datos de Rastreadores         *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_clearRastreador...
     P                 B                   export
     D PRWBIEN_clearRastreador...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              1N

     D k1wins          ds                  likerec(c1wins:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de auto
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'A';
            %subst(wrepl:1:2) = %editc(peRama:'X');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0067'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haberse seleccionado una cobertura
       // ------------------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       k1wetc.t0rama = peRama;
       k1wetc.t0arse = peArse;
       k1wetc.t0poco = pePoco;
       chain %kds(k1wetc:8) ctwetc01;
       if not %found;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0066'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haber datos de rastreador cargados
       // ------------------------------------------------
       k1wins.inempr = peBase.peEmpr;
       k1wins.insucu = peBase.peSucu;
       k1wins.innivt = peBase.peNivt;
       k1wins.innivc = peBase.peNivc;
       k1wins.innctw = peNctw;
       k1wins.intipo = 'R';
       k1wins.inrama = peRama;
       k1wins.inpoco = pePoco;
       k1wins.inarse = peArse;
       chain %kds(k1wins) ctwins;
       if %found;
          delete c1wins;
        else;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          %subst(wrepl:7:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0056'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
       endif;

       return;

      /end-free

     P PRWBIEN_clearRastreador...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_setUbicacion(): Graba datos de Ubicacion                 *
      *                                                                  *
      *  ****** DEPRECATED ****** Usar PRWBIEN_setUbicacion2()           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRdes (input)   Ubicación del Riesgo                    *
      *         peInsp (input)   Datos de Inspección                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_setUbicacion...
     P                 B                   export
     D PRWBIEN_setUbicacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peInsp                            const likeds(prwbienInsp_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /free

       PRWBIEN_setUbicacion2( peBase
                            : peNctw
                            : peRama
                            : peArse
                            : pePoco
                            : peRdes
                            : peInsp
                            : peErro
                            : peMsgs  );
       return;

      /end-free

     P PRWBIEN_setUbicacion...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_setUbicacion2(): Graba datos de Ubicacion                *
      *                                                                  *
      *  ****** DEPRECATED ****** Usar PRWBIEN_setUbicacion3()           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRdes (input)   Ubicación del Riesgo                    *
      *         peInsp (input)   Datos de Inspección                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_setUbicacion2...
     P                 B                   export
     D PRWBIEN_setUbicacion2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peInsp                            const likeds(prwbienInsp_t2)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /free

       PRWBIEN_setUbicacion3( peBase
                            : peNctw
                            : peRama
                            : peArse
                            : pePoco
                            : peRdes
                            : 0
                            : peInsp
                            : peErro
                            : peMsgs  );
       return;

      /end-free

     P PRWBIEN_setUbicacion2...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_setAccesorioNoTar(): Graba Acccesorios No Tarifables     *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peSecu (input)   Secuencia                               *
      *         peAccd (input)   Descripción de Accesorio                *
      *         peAccv (input)   Valor del Accesorio                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_setAccesorioNoTar...
     P                 B                   export
     D PRWBIEN_setAccesorioNoTar...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSecu                       2  0 const
     D   peAccd                      20    const
     D   peAccv                      15  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)
     D k1wet1          ds                  likerec(c1wet1:*key)

     D suma_acc        s             15  2
     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de auto
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'A';
            %subst(wrepl:1:2) = %editc(peRama:'X');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0067'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haberse seleccionado una cobertura
       // ------------------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       k1wetc.t0rama = peRama;
       k1wetc.t0arse = peArse;
       k1wetc.t0poco = pePoco;
       chain %kds(k1wetc:8) ctwetc01;
       if not %found;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0066'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Secuencia debe ser mayor a cero
       // ------------------------------------------------
       if peSecu <= 0;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          %subst(wrepl:7:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0058'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Descripción de accesorio debe estar cargada
       // ------------------------------------------------
       if peAccd = *blanks;
          %subst(wrepl:1:2)  = %trim(%char(peSecu));
          %subst(wrepl:3:6)  = %trim(%char(pePoco));
          %subst(wrepl:9:7)  = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0059'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Suma debe ser mayor a cero
       // ------------------------------------------------
       if peAccv <= 0;
          %subst(wrepl:1:2)  = %trim(%char(peSecu));
          %subst(wrepl:3:6)  = %trim(%char(pePoco));
          %subst(wrepl:9:7)  = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0060'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valor del Accesorio no puede superar al Vehículo
       // ------------------------------------------------
       k1wet0.t0empr = PeBase.peEmpr;
       k1wet0.t0sucu = PeBase.peSucu;
       k1wet0.t0nivt = PeBase.peNivt;
       k1wet0.t0nivc = PeBase.peNivc;
       k1wet0.t0nctw = peNctw;
       k1wet0.t0rama = peRama;
       k1wet0.t0arse = peArse;
       k1wet0.t0poco = pePoco;
       chain %kds(k1wet0:8) ctwet0;
       if %found;
          if peAccv > t0vhvu;
             %subst(wrepl:1:2)  = %trim(%char(peSecu));
             %subst(wrepl:3:6)  = %trim(%char(pePoco));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0068'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       // ------------------------------------------------
       // Todos los accesorios no pueden superar Vehículo
       // ------------------------------------------------
       suma_acc = 0;
       k1wet1.t1empr = PeBase.peEmpr;
       k1wet1.t1sucu = PeBase.peSucu;
       k1wet1.t1nivt = PeBase.peNivt;
       k1wet1.t1nivc = PeBase.peNivc;
       k1wet1.t1nctw = peNctw;
       k1wet1.t1rama = peRama;
       k1wet1.t1arse = peArse;
       k1wet1.t1poco = pePoco;
       setll %kds(k1wet1:8) ctwet1;
       reade(n) %kds(k1wet1:8) ctwet1;
       dow not %eof;
           if peSecu <> t1secu;
              suma_acc += t1accv;
           endif;
        reade(n) %kds(k1wet1:8) ctwet1;
       enddo;
       suma_acc += peAccv;
       if suma_acc > t0vhvu;
          %subst(wrepl:1:6)  = %trim(%char(pePoco));
          %subst(wrepl:7:20) = %trim(peAccd);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0069'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Lo elimino siempre y lo vuelvo a crear
       // ------------------------------------------------
       k1wet1.t1secu = peSecu;
       chain %kds(k1wet1:9) ctwet1;
       if %found;
          t1accd = peAccd;
          t1accv = peAccv;
          update c1wet1;
        else;
          t1empr = k1wet1.t1empr;
          t1sucu = k1wet1.t1sucu;
          t1nivt = k1wet1.t1nivt;
          t1nivc = k1wet1.t1nivc;
          t1nctw = k1wet1.t1nctw;
          t1rama = k1wet1.t1rama;
          t1arse = k1wet1.t1arse;
          t1poco = k1wet1.t1poco;
          t1secu = k1wet1.t1secu;
          t1accd = peAccd;
          t1accv = peAccv;
          t1mar1 = '2';
          t1ma01 = '0';
          t1ma02 = '0';
          t1ma03 = '0';
          t1ma04 = '0';
          t1ma05 = '0';
          write c1wet1;
       endif;

       return;

      /end-free

     P PRWBIEN_setAccesorioNoTar...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_dltAccesorioNoTar(): Eliminar Acccesorio No Tarifable    *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peSecu (input)   Accesorios                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_dltAccesorioNoTar...
     P                 B                   export
     D PRWBIEN_dltAccesorioNoTar...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1wet1          ds                  likerec(c1wet1:*key)

     D suma_acc        s             15  2
     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de auto
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'A';
            %subst(wrepl:1:2) = %editc(peRama:'X');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0067'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haberse seleccionado una cobertura
       // ------------------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       k1wetc.t0rama = peRama;
       k1wetc.t0arse = peArse;
       k1wetc.t0poco = pePoco;
       chain %kds(k1wetc:8) ctwetc01;
       if not %found;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0066'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Secuencia debe ser mayor a cero
       // ------------------------------------------------
       if peSecu <= 0;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          %subst(wrepl:7:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0058'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Lo elimino
       // ------------------------------------------------
       k1wet1.t1secu = peSecu;
       chain %kds(k1wet1:9) ctwet1;
       if %found;
          delete c1wet1;
       endif;

       return;

      /end-free

     P PRWBIEN_dltAccesorioNoTar...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_setObjetoAsegurado(): Graba Objeto Asegurad              *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peOsec (input)   Secuencia                               *
      *         peObje (input)   Descripción Objeto                      *
      *         peMarc (input)   Marca del Objeto                        *
      *         peMode (input)   Modelo del Objeto                       *
      *         peNser (input)   Número de Serie                         *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_setObjetoAsegurado...
     P                 B                   export
     D PRWBIEN_setObjetoAsegurado...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peObje                      74    const
     D   peSuas                      15  2 const
     D   peMarc                      45    const
     D   peMode                      45    const
     D   peNser                      45    const
     D   peDeta                     400a   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wer7          ds                  likerec(c1wer7:*key)
     D k1wer2          ds                  likerec(c1wer2:*key)
     D k1t107          ds                  likerec(s1t107:*key)

     D suma_obj        s             15  2
     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Riesgo/Cobertura debe existir
       // ------------------------------------------------
       k1wer2.r2empr = peBase.peEmpr;
       k1wer2.r2sucu = peBase.peSucu;
       k1wer2.r2nivt = peBase.peNivt;
       k1wer2.r2nivc = peBase.peNivc;
       k1wer2.r2nctw = peNctw;
       k1wer2.r2rama = peRama;
       k1wer2.r2arse = peArse;
       k1wer2.r2poco = pePoco;
       k1wer2.r2riec = peRiec;
       k1wer2.r2xcob = peXcob;
       chain %kds(k1wer2) ctwer2;
       if not %found;
          %subst(wrepl:1:3)  = %trim(peRiec);
          %subst(wrepl:4:3)  = %trim(%editc(peXcob:'X'));
          %subst(wrepl:7:6)  = %trim(%char(pePoco));
          %subst(wrepl:13:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0061'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Secuencia debe ser mayor a cero
       // ------------------------------------------------
       if peOsec <= 0;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          %subst(wrepl:7:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0062'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Descripción del objeto es obligatoria
       // ------------------------------------------------
       if peObje = *blanks;
          %subst(wrepl:1:9)  = %trim(%char(peOsec));
          %subst(wrepl:10:6) = %trim(%char(pePoco));
          %subst(wrepl:16:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0063'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Suma no puede ser cero, ni mayor a la cobertura
       // ------------------------------------------------
       if peSuas > r2saco or peSuas <= 0;
          %subst(wrepl:1:9)  = %trim(%char(peOsec));
          %subst(wrepl:10:6) = %trim(%char(pePoco));
          %subst(wrepl:16:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0064'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Sumar todos los accesorios
       // ------------------------------------------------
       suma_obj = 0;
       k1wer7.r7empr = peBase.peEmpr;
       k1wer7.r7sucu = peBase.peSucu;
       k1wer7.r7nivt = peBase.peNivt;
       k1wer7.r7nivc = peBase.peNivc;
       k1wer7.r7nctw = peNctw;
       k1wer7.r7rama = peRama;
       k1wer7.r7arse = peArse;
       k1wer7.r7poco = pePoco;
       k1wer7.r7riec = peRiec;
       k1wer7.r7xcob = peXcob;
       setll %kds(k1wer7:10) ctwer7;
       reade(n) %kds(k1wer7:10) ctwer7;
       dow not %eof;
           if r7osec <> peOsec;
              suma_obj += r7suas;
           endif;
           reade(n) %kds(k1wer7:10) ctwer7;
       enddo;
       if (suma_obj + peSuas) > r2saco;
          %subst(wrepl:1:9)  = %trim(%char(peOsec));
          %subst(wrepl:10:6) = %trim(%char(pePoco));
          %subst(wrepl:16:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0064'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // La cobertura debe permitir insertar objetos
       // ------------------------------------------------
       k1t107.t@rama = peRama;
       k1t107.t@cobc = peXcob;
       chain %kds(k1t107:2) set107;
       if not %found;
          t@mar3 = 'N';
          t@cobd = *all'*';
       endif;
       if t@mar3 = 'N';
          %subst(wrepl:1:20) = %trim(t@cobd);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0034'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // La marca es obligatoria
       // ------------------------------------------------
       if peMarc = *blanks;
          %subst(wrepl:1:9)  = %trim(%char(peOsec));
          %subst(wrepl:10:6) = %trim(%char(pePoco));
          %subst(wrepl:16:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0035'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Grabar/Actualizar
       // ------------------------------------------------
       k1wer7.r7empr = peBase.peEmpr;
       k1wer7.r7sucu = peBase.peSucu;
       k1wer7.r7nivt = peBase.peNivt;
       k1wer7.r7nivc = peBase.peNivc;
       k1wer7.r7nctw = peNctw;
       k1wer7.r7rama = peRama;
       k1wer7.r7arse = peArse;
       k1wer7.r7poco = pePoco;
       k1wer7.r7riec = peRiec;
       k1wer7.r7xcob = peXcob;
       k1wer7.r7osec = peOsec;
       chain %kds(k1wer7) ctwer7;
       if %found;
          r7obje = peObje;
          r7marc = peMarc;
          r7mode = peMode;
          r7nser = peNser;
          r7suas = peSuas;
          r7det1 = %subst(peDeta:  1:74);
          r7det2 = %subst(peDeta: 75:74);
          r7det3 = %subst(peDeta:149:74);
          r7det4 = %subst(peDeta:223:74);
          r7det5 = %subst(peDeta:297:74);
          r7det6 = %subst(peDeta:371:29);
          update c1wer7;
        else;
          r7empr = peBase.peEmpr;
          r7sucu = peBase.peSucu;
          r7nivt = peBase.peNivt;
          r7nivc = peBase.peNivc;
          r7nctw = peNctw;
          r7rama = peRama;
          r7arse = peArse;
          r7poco = pePoco;
          r7riec = peRiec;
          r7xcob = peXcob;
          r7osec = peOsec;
          r7obje = peObje;
          r7marc = peMarc;
          r7mode = peMode;
          r7nser = peNser;
          r7suas = peSuas;
          r7det1 = %subst(peDeta:  1:74);
          r7det2 = %subst(peDeta: 75:74);
          r7det3 = %subst(peDeta:149:74);
          r7det4 = %subst(peDeta:223:74);
          r7det5 = %subst(peDeta:297:74);
          r7det6 = %subst(peDeta:371:29);
          r7ma01 = '0';
          r7ma02 = '0';
          r7ma03 = '0';
          r7ma04 = '0';
          r7ma05 = '0';
          write  c1wer7;
       endif;

       return;

      /end-free

     P PRWBIEN_setObjetoAsegurado...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_dltObjetoAsegurado(): Borra Objeto Asegurad              *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peOsec (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_dltObjetoAsegurado...
     P                 B                   export
     D PRWBIEN_dltObjetoAsegurado...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wer7          ds                  likerec(c1wer7:*key)

     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Eliminar
       // ------------------------------------------------
       k1wer7.r7empr = peBase.peEmpr;
       k1wer7.r7sucu = peBase.peSucu;
       k1wer7.r7nivt = peBase.peNivt;
       k1wer7.r7nivc = peBase.peNivc;
       k1wer7.r7nctw = peNctw;
       k1wer7.r7rama = peRama;
       k1wer7.r7arse = peArse;
       k1wer7.r7poco = pePoco;
       k1wer7.r7riec = peRiec;
       k1wer7.r7xcob = peXcob;
       k1wer7.r7osec = peOsec;
       chain %kds(k1wer7) ctwer7;
       if %found;
         Monitor;
           delete c1wer7;
         on-error;
           %subst(wrepl:1:74) = %trim(r7obje:'X');
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0051'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
         endmon;
       endif;

       return;

      /end-free

     P PRWBIEN_dltObjetoAsegurado...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_insertAsegurado(): Insertar asegurado                    *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia                               *
      *         peNomb (input)   Nombre                                  *
      *         peApel (input)   Apellido                                *
      *         peTido (input)   Numero de Documento                     *
      *         peNrdo (input)   Numero de Documento                     *
      *         peFnac (input)   Fecha de Nacimiento                     *
      *         peSuas (input)   Suma Asegurada                          *
      *         peSmue (input)   Suma Asegurada Muerte                   *
      *         peSinv (input)   Suma Asegurada Invalidez                *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_insertAsegurado...
     P                 B                   export
     D PRWBIEN_insertAsegurado...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peSuas                      13  0 const
     D   peSmue                      13  0 const
     D   peSinv                      13  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wer1          ds                  likerec(c1wer1:*key)
     D actualiza       s               n

     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido parametros generales
       // ------------------------------------------------
       if not ValAsegurados ( peRama :
                              peXcob :
                              peNomb :
                              peApel :
                              peTido :
                              peNrdo :
                              peFnac :
                              peErro :
                              peMsgs );

          peErro = -1;
          return;

       endif;

       // -----------------------------------------------
       // Primero lo elimino porque la web reenvia todo
       // siempre y vamos a sumar de más
       // -----------------------------------------------
       PRWBIEN_dltAsegurado( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : pePoco
                           : peRiec
                           : peXcob
                           : peSecu
                           : peErro
                           : peMsgs );
       peErro = 0;
       clear peMsgs;

       // --------------------------------------------------------
       // No puedo superar la suma asegurada total de la cobertura
       // --------------------------------------------------------
        if peSuas + COWGRAI_getSumaAsegAsegurados ( peBase :
                                                    peNctw :
                                                    peRama :
                                                    peArse :
                                                    pePoco :
                                                    peRiec :
                                                    peXcob )
                                                    >
          COWGRAI_getSumaAseguradaCobertura ( peBase :
                                              peNctw :
                                              peRama :
                                              peArse :
                                              pePoco :
                                              peRiec :
                                              peXcob );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0107'
                       : peMsgs      );
          peErro = -1;
          return;

        endif;

       // ------------------------------------------------
       // Grabo o Actualizo
       // ------------------------------------------------

       k1wer1.r1empr = peBase.peEmpr;
       k1wer1.r1sucu = peBase.peSucu;
       k1wer1.r1nivt = peBase.peNivt;
       k1wer1.r1nivc = peBase.peNivc;
       k1wer1.r1nctw = peNctw;
       k1wer1.r1rama = peRama;
       k1wer1.r1arse = peArse;
       k1wer1.r1poco = pePoco;
       k1wer1.r1riec = peRiec;
       k1wer1.r1xcob = peXcob;
       k1wer1.r1secu = peSecu;

       chain %kds( k1wer1 ) ctwer1;
       if %found();
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       r1empr = peBase.peEmpr;
       r1sucu = peBase.peSucu;
       r1nivt = peBase.peNivt;
       r1nivc = peBase.peNivc;
       r1nctw = peNctw;
       r1rama = peRama;
       r1arse = peArse;
       r1poco = pePoco;
       r1riec = peRiec;
       r1xcob = peXcob;
       r1secu = peSecu;
       r1nomb = %trim(peApel) + ', ' + %trim(peNomb);
       r1tido = peTido;
       r1nrdo = peNrdo;
       r1fnac = peFnac;
       r1suas = peSuas;
       r1smue = peSmue;
       r1sinv = peSinv;
       r1mar1 = '0';
       r1mar2 = '0';
       r1mar3 = '0';
       r1mar4 = '0';
       r1mar5 = '0';
       r1user = @PsDs.CurUsr;
       r1date = %dec(%date);
       r1time = %dec(%time);

       if actualiza = *off;
         write c1wer1;
       else;
         update c1wer1;
       endif;

     P PRWBIEN_insertAsegurado...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_insertBeneficiario(): Inserta beneficiarios del asegurado*
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia Persona                       *
      *         peSebe (input)   Secuencia Beneficiario                  *
      *         peNomb (input)   Nombre                                  *
      *         peApel (input)   Apellido                                *
      *         peTido (input)   Numero de Documento                     *
      *         peNrdo (input)   Numero de Documento                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_insertBeneficiario...
     P                 B                   export
     D PRWBIEN_insertBeneficiario...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peSebe                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wer1b         ds                  likerec(c1wer1b:*key)
     D actualiza       s               n

     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1wer1b.b1empr = peBase.peEmpr;
       k1wer1b.b1sucu = peBase.peSucu;
       k1wer1b.b1nivt = peBase.peNivt;
       k1wer1b.b1nivc = peBase.peNivc;
       k1wer1b.b1nctw = peNctw;
       k1wer1b.b1rama = peRama;
       k1wer1b.b1arse = peArse;
       k1wer1b.b1poco = pePoco;
       k1wer1b.b1riec = peRiec;
       k1wer1b.b1xcob = peXcob;
       k1wer1b.b1secu = peSecu;

       //Debe existir el Asegurado para poder insertar los beneficiarios.
       setll  %kds ( k1wer1b : 11 ) ctwer1;
       if not %equal();

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0108'
                       : peMsgs      );
          peErro = -1;
          return;

       endif;

       //completo la clave del ctwer1b

       k1wer1b.b1sebe = peSebe;

       chain %kds( k1wer1b ) ctwer1b;
       if %found();
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       b1empr = peBase.peEmpr;
       b1sucu = peBase.peSucu;
       b1nivt = peBase.peNivt;
       b1nivc = peBase.peNivc;
       b1nctw = peNctw;
       b1rama = peRama;
       b1arse = peArse;
       b1poco = pePoco;
       b1riec = peRiec;
       b1xcob = peXcob;
       b1secu = peSecu;
       b1sebe = peSebe;
       b1nomb = %trim(peApel) + ', ' + %trim(peNomb);
       b1tido = peTido;
       b1nrdo = peNrdo;
       b1mar1 = '0';
       b1mar2 = '0';
       b1mar3 = '0';
       b1mar4 = '0';
       b1mar5 = '0';
       b1user = @PsDs.CurUsr;
       b1date = %dec(%date);
       b1time = %dec(%time);

       if actualiza = *off;
         write c1wer1b;
       else;
         update c1wer1b;
       endif;

       return;

     P PRWBIEN_insertBeneficiario...
     P                 E
      * -----------------------------------------------------------------*
      * PRWBIEN_dltAsegurado(): Elimina Asegurado                        *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_dltAsegurado...
     P                 B                   export
     D PRWBIEN_dltAsegurado...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wer1          ds                  likerec(c1wer1:*key)
     D actualiza       s               n

     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;


       k1wer1.r1empr = peBase.peEmpr;
       k1wer1.r1sucu = peBase.peSucu;
       k1wer1.r1nivt = peBase.peNivt;
       k1wer1.r1nivc = peBase.peNivc;
       k1wer1.r1nctw = peNctw;
       k1wer1.r1rama = peRama;
       k1wer1.r1arse = peArse;
       k1wer1.r1poco = pePoco;
       k1wer1.r1riec = peRiec;
       k1wer1.r1xcob = peXcob;
       k1wer1.r1secu = peSecu;

       //Debe existir el Asegurado para poder insertar los beneficiarios.
       chain  %kds ( k1wer1 ) ctwer1;
       if %found();

         monitor;
           delete c1wer1;
         on-error;
           %subst(wrepl:1:40) = %trim(r1Nomb);
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0050'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
         endmon;

       endif;

       return;

     P PRWBIEN_dltAsegurado...
     P                 E
      * -----------------------------------------------------------------*
      * PRWBIEN_dltBeneficiario (): Elimina Beneficiario                 *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia                               *
      *         peSebe (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_dltBeneficiario...
     P                 B                   export
     D PRWBIEN_dltBeneficiario...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peSebe                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wer1b         ds                  likerec(c1wer1b:*key)
     D actualiza       s               n

     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1wer1b.b1empr = peBase.peEmpr;
       k1wer1b.b1sucu = peBase.peSucu;
       k1wer1b.b1nivt = peBase.peNivt;
       k1wer1b.b1nivc = peBase.peNivc;
       k1wer1b.b1nctw = peNctw;
       k1wer1b.b1rama = peRama;
       k1wer1b.b1arse = peArse;
       k1wer1b.b1poco = pePoco;
       k1wer1b.b1riec = peRiec;
       k1wer1b.b1xcob = peXcob;
       k1wer1b.b1secu = peSecu;
       k1wer1b.b1sebe = peSebe;

       //Debe existir el Asegurado para poder insertar los beneficiarios.
       chain  %kds ( k1wer1b ) ctwer1b;
       if %found();

         delete c1wer1b;
         return;

       else;

         SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0107'
                       : peMsgs      );
         peErro = -1;
         return;

       endif;

       return;

     P PRWBIEN_dltBeneficiario...
     P                 E
      * -----------------------------------------------------------------*
      * PRWBIEN_insertAseguradoV(): Insertar asegurado Vida              *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePaco (input)   Código de Riesgo                        *
      *         peNomb (input)   Nombre y Apellido                       *
      *         peTido (input)   Tipo de Documento                       *
      *         peNrdo (input)   Numero de Documento                     *
      *         peFnac (input)   Fecha de Nacimiento                     *
      *         peNaci (input)   Nacionalidad                            *
      *         peActi (input)   Actividad                               *
      *         peCate (input)   Categoria                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_insertAseguradoV...
     P                 B                   export
     D PRWBIEN_insertAseguradoV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peNaci                      25    const
     D   peActi                       5  0 const
     D   peCate                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wev1          ds                  likerec(c1wev1:*key)
     D actualiza       s               n

     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'V';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido parametros generales
       // ------------------------------------------------
       if not ValAseguradosV( peBase :
                              peNctw :
                              peRama :
                              peArse :
                              pePoco :
                              *Zeros :
                              peNomb :
                              peTido :
                              peNrdo :
                              peFnac :
                              peErro :
                              peMsgs );

          peErro = -1;
          return;

       endif;

       // ------------------------------------------------
       // Grabo o Actualizo
       // ------------------------------------------------
       k1wev1.v1empr = peBase.peEmpr;
       k1wev1.v1sucu = peBase.peSucu;
       k1wev1.v1nivt = peBase.peNivt;
       k1wev1.v1nivc = peBase.peNivc;
       k1wev1.v1nctw = peNctw;
       k1wev1.v1rama = peRama;
       k1wev1.v1arse = peArse;
       k1wev1.v1poco = pePoco;
       k1wev1.v1paco = pePaco;

       chain %kds( k1wev1 ) ctwev1;
       if %found ( ctwev1 );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       v1empr = peBase.peEmpr;
       v1sucu = peBase.peSucu;
       v1nivt = peBase.peNivt;
       v1nivc = peBase.peNivc;
       v1nctw = peNctw;
       v1rama = peRama;
       v1arse = peArse;
       v1poco = pePoco;
       v1paco = pePaco;
       v1nomb = %trim(peNomb);
       v1tido = peTido;
       v1nrdo = peNrdo;
       v1fnac = peFnac;
       v1naci = peNaci;
       v1acti = peActi;
       v1cate = COWGRAI_getCategoria( peActi );
       v1mar1 = '0';
       v1mar2 = '0';
       v1mar3 = '0';
       v1mar4 = '0';
       v1mar5 = '0';
       v1strg = '0';
       v1user = @PsDs.CurUsr;
       v1date = udate;
       v1time = %dec(%time);

       if actualiza = *off;
         write c1wev1;
       else;
         update c1wev1;
       endif;

     P PRWBIEN_insertAseguradoV...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_dlttAseguradoV(): Elimina asegurado Vida                 *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePaco (input)   Código de Riesgo                        *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_dltAseguradoV...
     P                 B                   export
     D PRWBIEN_dltAseguradoV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wev1          ds                  likerec(c1wev1:*key)

     D rc              s              1N

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de Vida
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'V';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1wev1.v1empr = peBase.peEmpr;
       k1wev1.v1sucu = peBase.peSucu;
       k1wev1.v1nivt = peBase.peNivt;
       k1wev1.v1nivc = peBase.peNivc;
       k1wev1.v1nctw = peNctw;
       k1wev1.v1rama = peRama;
       k1wev1.v1arse = peArse;
       k1wev1.v1poco = pePoco;
       k1wev1.v1paco = pePaco;

       chain %kds( k1wev1 ) ctwev1;

       if %found ( ctwev1 );
         delete c1wev1;
       endif;

     P PRWBIEN_dltAseguradoV...
     P                 E

      * ------------------------------------------------------------ *
      * PRWBIEN_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P PRWBIEN_inz     B                   Export
     D PRWBIEN_inz     pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(ctwet0);
         open ctwet0;
       endif;

       if not %open(ctwetc01);
         open ctwetc01;
       endif;

       if not %open(ctwins);
         open ctwins;
       endif;

       if not %open(ctwet1);
         open ctwet1;
       endif;

       if not %open(ssnrut1);
         open ssnrut1;
       endif;

       if not %open(set243);
         open set243;
       endif;

       if not %open(set107);
         open set107;
       endif;

       if not %open(gnhda102);
         open gnhda102;
       endif;

       if not %open(ctwer0);
         open ctwer0;
       endif;

       if not %open(ctwer1);
         open ctwer1;
       endif;

       if not %open(ctwer1b);
         open ctwer1b;
       endif;

       if not %open(ctwer2);
         open ctwer2;
       endif;

       if not %open(ctwer7);
         open ctwer7;
       endif;

       if not %open(ctwev1);
         open ctwev1;
       endif;

       if not %open(pahec0);
         open pahec0;
       endif;

       if not %open(ctw000);
         open ctw000;
       endif;

       if not %open(setpat01);
         open setpat01;
       endif;

       if not %open(ctwet003);
         open ctwet003;
       endif;

       if not %open(paher905);
         open paher905;
       endif;

       if not %open(ctwera);
         open ctwera;
       endif;

       if not %open(ctwev2);
         open ctwev2;
       endif;

       initialized = *ON;
       return;

      /end-free

     P PRWBIEN_inz     E

      * ------------------------------------------------------------ *
      * PRWBIEN_End(): Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P PRWBIEN_End     B                   Export
     D PRWBIEN_End     pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P PRWBIEN_End     E

      * ------------------------------------------------------------ *
      * PRWBIEN_Error(): Retorna el último error del service program *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P PRWBIEN_Error   B                   Export
     D PRWBIEN_Error   pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P PRWBIEN_Error   E

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

      * --------------------------------------------------- *
      * Validaciones generales a todos los procedimientos   *
      * --------------------------------------------------- *
     P valGeneral      B
     D valGeneral      pi             1N
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  pePoco                        4  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      /free

       // ---------------------------
       // Valido ParmBase
       // ---------------------------
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
          peErro = -1;
          return *OFF;
       endif;

       // ---------------------------
       // Valido Cotización
       // ---------------------------
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
          return *off;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama que pueda emitir en web
       // ------------------------------------------------
       if SVPVAL_ramaWeb ( peRama ) = *off;
          ErrText = SVPVAL_Error(ErrCode);
          if SVPVAL_RAMNW = ErrCode;
            %subst(wrepl:1:2) = %editc(peRama:'X');
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0000'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          endif;
          peErro = -1;
          return *off;
       endif;

       // ------------------------------------------------
       // Valido que exista número de componente
       // COWGRAI_chkComponente() retorna *ON si no existe
       // ------------------------------------------------
       if peRama <> 85;
          if COWGRAI_chkComponente( peBase
                                  : peNctw
                                  : peRama
                                  : peArse
                                  : pePoco ) = *ON;
             %subst(wrepl:1:6) = %trim(%char(pePoco));
             %subst(wrepl:7:7) = %trim(%char(peNctw));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0065'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return *off;
          endif;
       endif;

       return *on;

      /end-free

     P valGeneral      E
      * ------------------------------------------------------- *
      * Validaciones generales para Asegurados y Beneficiarios  *
      * ------------------------------------------------------- *
     P valAsegurados   B
     D valAsegurados   pi              n
     D   peRama                       2  0 const
     D   peXcob                       3  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y107          ds                  likerec(s1t107:*key)

      /free

      // ------------------------------------------------
      // Valido que el nombre no este en blanco
      // ------------------------------------------------
       if peNomb = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0009'
                        : peMsgs      );
         peErro = -1;
         return *off;
       endif;

      // ------------------------------------------------
      // Valido que el apellido no este en blanco
      // ------------------------------------------------
       if peApel = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0009'
                        : peMsgs      );
         peErro = -1;
         return *off;
       endif;

      // ------------------------------------------------
      // Valido el tipo de documento
      // ------------------------------------------------
       if SVPVAL_tipoDeDocumento ( peTido ) = *off;

        %subst(wrepl:1:2) = %editc(peTido:'X');

        SVPWS_getMsgs( '*LIBL'
                     : 'WSVMSG'
                     : 'PRW0004'
                     : peMsgs
                     : %trim(wrepl)
                     : %len(%trim(wrepl))  );

        peErro = -1;
        return *off;

       endif;

      // ------------------------------------------------
      // Valido número de documento
      // ------------------------------------------------
       if peNrdo <= 0;

        wrepl = *blanks;
        SVPWS_getMsgs( '*LIBL'
                     : 'WSVMSG'
                     : 'PRW0005'
                     : peMsgs
                     : %trim(wrepl)
                     : %len(%trim(wrepl))  );

        peErro = -1;
        return *off;

       endif;

      // ------------------------------------------------
      // Valido fecha de nacimiento
      // ------------------------------------------------
       test(DE) *iso peFnac;
       if %error;

        %subst(wrepl:1:8) = %editc(peFnac:'X');

        SVPWS_getMsgs( '*LIBL'
                     : 'WSVMSG'
                     : 'PRW0010'
                     : peMsgs
                     : %trim(wrepl)
                     : %len(%trim(wrepl))  );

        peErro = -1;
        return *off;

       endif;

       k1y107.t@rama = peRama;
       k1y107.t@cobc = peXcob;

       chain %kds ( k1y107 ) set107;
       if %found();

         if t@mar3 = 'D';

           if SPVFEC_DiasEntreFecha8 ( pefnac ) / 365 > 65;

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0049'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             peMsgs.peMsg1 = 'La edad del asegurado ' + %trim(peNomb) + ' '
                           + %trim(peApel) + ', no puede ser mayor a 65.';

             peErro = -1;
             return *off;
           endif;

         else;

           if SPVFEC_DiasEntreFecha8( pefnac ) / 365 > 70;

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0049'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             peMsgs.peMsg1 = 'La edad del Asegurado ' + %trim(peNomb) + ' '
                           + %trim(peApel) + ', no puede ser mayor a 70.';

             peErro = -1;
             return *off;
           endif;

         endif ;

       endif ;

       return *on;

      /end-free

     P valAsegurados   E

      * ------------------------------------------------------- *
      * Validaciones generales para Asegurados y Beneficiarios  *
      * ------------------------------------------------------- *
     P valAseguradosV  B
     D valAseguradosV  pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peXcob                       3  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D peArcd          s              6  0
     D peXpro          s              3  0
     D peEdad          s              2  0
     D @@AÑo           s              4  0
     D peComp          ds                  likeds(CompVida)

      /free

      // ------------------------------------------------
      // Valido que el nombre no este en blanco
      // ------------------------------------------------
       if peNomb = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0009'
                        : peMsgs      );
         peErro = -1;
         return *off;
       endif;

      // ------------------------------------------------
      // Valido el tipo de documento
      // ------------------------------------------------
       if SVPVAL_tipoDeDocumento ( peTido ) = *off;

        %subst(wrepl:1:2) = %editc(peTido:'X');

        SVPWS_getMsgs( '*LIBL'
                     : 'WSVMSG'
                     : 'PRW0004'
                     : peMsgs
                     : %trim(wrepl)
                     : %len(%trim(wrepl))  );

        peErro = -1;
        return *off;

       endif;

      // ------------------------------------------------
      // Valido número de documento
      // ------------------------------------------------
       if peNrdo <= 0;

        wrepl = *blanks;
        SVPWS_getMsgs( '*LIBL'
                     : 'WSVMSG'
                     : 'PRW0005'
                     : peMsgs
                     : %trim(wrepl)
                     : %len(%trim(wrepl))  );

        peErro = -1;
        return *off;

       endif;

      // ------------------------------------------------
      // Valido fecha de nacimiento
      // ------------------------------------------------
       test(DE) *iso peFnac;
       if %error;

        %subst(wrepl:1:8) = %editc(peFnac:'X');

        SVPWS_getMsgs( '*LIBL'
                     : 'WSVMSG'
                     : 'PRW0010'
                     : peMsgs
                     : %trim(wrepl)
                     : %len(%trim(wrepl))  );

        peErro = -1;
        return *off;

       endif;

       peArcd = COWGRAI_getArticulo( peBase: peNctw);
       @@AÑo  = %dec(%subst(%char(peFnac):1:4):4:0);
       peEdad = *year - @@AÑo;

       COWRTV_getComponenteVida( peBase
                               : peNctw
                               : peRama
                               : peArse
                               : pePoco
                               : peComp
                               : peErro
                               : peMsgs );

       if peErro = *zeros;
         peXpro = peComp.Xpro;

         if not SVPVAL_chkEdadVida( peArcd
                                  : peRama
                                  : peArse
                                  : peXpro
                                  : peEdad );

          ErrText = SVPVAL_Error(ErrCode);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0049'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

          peMsgs.peMsg1 = 'Asegurado ' + %trim(peNomb) + ', '
                        + %trim(ErrText);

          peErro = -1;
          return *off;

         endif;
       endif;

       return *on;

      /end-free

     P valAseguradosV  E

      * ------------------------------------------------------------ *
      * PRWBIEN_setUbicacion3(): Graba datos de Ubicacion            *
      *                                                              *
      *         peBase (input)   Paramametro Base                    *
      *         peNctw (input)   Numero de Cotizacion                *
      *         peRama (input)   Rama                                *
      *         peArse (input)   Arse                                *
      *         pePoco (input)   Componente                          *
      *         peRdes (input)   Ubicación del Riesgo                *
      *         peNrdm (input)   Número de puerta                    *
      *         peInsp (input)   Datos de Inspección                 *
      *         peErro (output)  Indicador de Error                  *
      *         peMsgs (output)  Estructura de Error                 *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWBIEN_setUbicacion3...
     P                 B                   export
     D PRWBIEN_setUbicacion3...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peNrdm                       5  0 const
     D   peInsp                            const likeds(prwbienInsp_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              1N
     D @@nrdm          s              5  0
     D peTiou          s              1  0
     D peStou          s              2  0
     D peStos          s              2  0
     D peSpo1          s              9  0
     D peArcd          s              6  0
     D pePoli          s              7  0

     D k1wer0          ds                  likerec(c1wer0:*key)
     D k1wins          ds                  likerec(c1wins:*key)
     D k1her9          ds                  likerec(p1her9:*key)

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs   );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Debe haber enviado la ubicación
       // ------------------------------------------------
       if peRdes = *blanks;
            %subst(wrepl:1:4) = %trim(%char(pePoco));
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PRW0033'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       @@nrdm = peNrdm;
       // ----------------------------------------
       // Si es reno: busco nro de puerta
       // ----------------------------------------
       rc = COWGRAI_getTipoDeOperacion( peBase
                                      : peNctw
                                      : peTiou
                                      : peStou
                                      : peStos );
       if peTiou = 2 and peNrdm = 0;
          peSpo1 = COWGRAI_getSuperpolizaReno( peBase: peNctw);
          peArcd = COWGRAI_getArticulo( peBase: peNctw);
          pePoli = SPVSPO_getPoliza( peBase.peEmpr
                                   : peBase.peSucu
                                   : peArcd
                                   : peSpo1        );
          k1her9.r9empr = peBase.peEmpr;
          k1her9.r9sucu = peBase.peSucu;
          k1her9.r9rama = peRama;
          k1her9.r9poli = pePoli;
          k1her9.r9poco = pePoco;
          k1her9.r9arcd = peArcd;
          k1her9.r9spol = peSpo1;
          chain %kds(k1her9:7) paher905;
          if %found;
             @@nrdm = r9nrdm;
          endif;
       endif;

       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       k1wer0.r0rama = peRama;
       k1wer0.r0poco = pePoco;
       k1wer0.r0arse = peArse;
       chain %kds(k1wer0) ctwer0;
       if %found;

         // ----------------------------------------------------------
         // Valida datos de inspección, cuando se requiera del mismo
         // ----------------------------------------------------------
          if r0Ma01 = '1';
            if peInsp.nomb = *blanks;
               %subst(wrepl:1:6) = %trim(%char(pePoco));
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0146'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );
               peErro = -1;
               return;
            endif;

            if peInsp.ntel = *blanks;
               %subst(wrepl:1:6) = %trim(%char(pePoco));
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0147'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );
               peErro = -1;
               return;
            endif;
          endif;
          r0rdes = peRdes;
          r0nrdm = @@nrdm;
          update c1wer0;
       endif;

       k1wins.inempr = peBase.peEmpr;
       k1wins.insucu = peBase.peSucu;
       k1wins.innivt = peBase.peNivt;
       k1wins.innivc = peBase.peNivc;
       k1wins.innctw = peNctw;
       k1wins.intipo = 'I';
       k1wins.inrama = peRama;
       k1wins.inpoco = pePoco;
       k1wins.inarse = peArse;
       chain %kds(k1wins) ctwins;
       if %found;
          delete c1wins;
       endif;

       inempr = peBase.peEmpr;
       insucu = peBase.peSucu;
       innivt = peBase.peNivt;
       innivc = peBase.peNivc;
       innctw = peNctw;
       inrama = peRama;
       inarse = peArse;
       inpoco = pePoco;
       intipo = 'I';
       indomi = peInsp.domi;
       inntel = peInsp.ntel;
       innte1 = peInsp.nte1;
       inmail = peInsp.mail;
       inhdes = peInsp.hdes;
       inhhas = peInsp.hhas;
       innrin = peInsp.nrin;
       inctro = peInsp.ctro;
       income = peInsp.come;
       inmarc = peInsp.tipo;
       innomb = peInsp.nomb;
       write c1wins;

       return;

      /end-free

     P PRWBIEN_setUbicacion3...
     P                 E
      * -----------------------------------------------------------------*
      * PRWBIEN_setMascotaAsegurada(): Graba Mascota Asegurada           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Cobertura                               *
      *         peMsec (input)   Secuencia de Mascota                    *
      *         peCtma (input)   Tipo de Mascota (tabla SET136)          *
      *         peCraz (input)   Raza de Mascota (tabla SET137)          *
      *         peFnaa (input)   Año de Nacimiento de la mascota         *
      *         pePvac (input)   Plan de Vacunacion? S=Si/N=No           *
      *         peCria (input)   Se usa para exposicion? S=Si/N=No       *
      *         peExpo (input)   Extender cobertura a la cria? S=Si/N=No *
      *         peSuas (input)   Suma Asegurada de la Mascota            *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_setMascotaAsegurada...
     P                 B                   export
     D PRWBIEN_setMascotaAsegurada...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peCtma                       2  0 const
     D   peCraz                       4  0 const
     D   peFnaa                       4  0 const
     D   pePvac                       1a   const
     D   peExpo                       1a   const
     D   peCria                       1a   const
     D   peSuas                      15  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1t107          ds                  likerec(s1t107:*key)
     D k1wera          ds                  likerec(c1wera:*key)
     D actualiza       s               n

     D rc              s              1N

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de hogar
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // La cobertura debe permitir insertar objetos
       // ------------------------------------------------
       k1t107.t@rama = peRama;
       k1t107.t@cobc = peXcob;
       chain %kds(k1t107:2) set107;
       if not %found;
          t@mar3 = 'N';
          t@cobd = *all'*';
       endif;
       if t@mar3 = 'N';
          %subst(wrepl:1:20) = %trim(t@cobd);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRWxxxx'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Secuencia debe ser mayor a cero
       // ------------------------------------------------
       if peMsec <= 0;
          %subst(wrepl:1:6) = %trim(%char(pePoco));
          %subst(wrepl:7:7) = %trim(%char(peNctw));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0062'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido que Año sea Mayor a Cero
       // ------------------------------------------------
       if peFnaa <= 0;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COWXXXX'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Grabo o Actualizo
       // ------------------------------------------------
       k1wera.raEmpr = peBase.peEmpr;
       k1wera.raSucu = peBase.peSucu;
       k1wera.raNivt = peBase.peNivt;
       k1wera.raNivc = peBase.peNivc;
       k1wera.raNctw = peNctw;
       k1wera.raRama = peRama;
       k1wera.raArse = peArse;
       k1wera.raPoco = pePoco;
       k1wera.raRiec = peRiec;
       k1wera.raXcob = peXcob;
       k1wera.raMsec = peMsec;

       chain %kds( k1wera ) ctwera;
       if %found ( ctwera );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       raEmpr = peBase.peEmpr;
       raSucu = peBase.peSucu;
       raNivt = peBase.peNivt;
       raNivc = peBase.peNivc;
       raNctw = peNctw;
       raRama = peRama;
       raArse = peArse;
       raPoco = pePoco;
       raRiec = peRiec;
       raXcob = peXcob;
       raMsec = peMsec;
       raCtma = peCtma;
       raCraz = peCraz;
       raFnaa = peFnaa;

       if pePvac = 'S';
         raPvac = '1';
       else;
         raPvac = '0';
       endif;

       if peCria = 'S';
         raCria = '1';
       else;
         raCria = '0';
       endif;

       if peExpo = 'S';
         raExpo = '1';
       else;
         raExpo = '0';
       endif;

       raSuas = peSuas;
       rama01 = '0';
       rama02 = '0';
       rama03 = '0';
       rama04 = '0';
       rama05 = '0';

       if actualiza = *off;
         write c1wera;
       else;
         update c1wera;
       endif;

      /end-free

     P PRWBIEN_setMascotaAsegurada...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_dltMascotaAsegurada(): Elimina Mascota Asegurada         *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Cobertura                               *
      *         peMsec (input)   Secuencia de Mascota                    *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWBIEN_dltMascotaAsegurada...
     P                 B                   export
     D PRWBIEN_dltMascotaAsegurada...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1wera          ds                  likerec(c1wera:*key)

     D rc              s              1N
     D @@Nomb          s             40a

      /free

       PRWBIEN_inz();

       peErro = *Zeros;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : pePoco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de Riesgo
       // ------------------------------------------------
       if SVPWS_getGrupoRamaArch ( peRama ) <> 'R';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1wera.raEmpr = peBase.peEmpr;
       k1wera.raSucu = peBase.peSucu;
       k1wera.raNivt = peBase.peNivt;
       k1wera.raNivc = peBase.peNivc;
       k1wera.raNctw = peNctw;
       k1wera.raRama = peRama;
       k1wera.raArse = peArse;
       k1wera.raPoco = pePoco;
       k1wera.raRiec = peRiec;
       k1wera.raXcob = peXcob;
       k1wera.raMsec = peMsec;

       chain %kds( k1wera ) ctwera;

       if %found ( ctwera );
         Monitor;
           delete c1wera;
         on-error;
           clear @@Nomb;
           @@Nomb = SVPDES_tipoDeMascota(raCtma);
           %subst(wrepl:1:40) = %trim(@@Nomb);

           @@Nomb = SVPDES_razaDeMascota(raCraz);
           %subst(wrepl:41:40) = %trim(@@Nomb);

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0052'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
         endmon;
       endif;

      /end-free

     P PRWBIEN_dltMascotaAsegurada...
     P                 E

      * -----------------------------------------------------------------*
      * PRWBIEN_copiaPoliza(): Retorna Tipo de Inspección                *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peTipo (input)   Inspección / Rastreo                    *
      *                                                                  *
      * Retorna: *on = Existe / *off = no Existe                         *
      * ---------------------------------------------------------------- *
     P PRWBIEN_copiaPoliza...
     P                 B                   export
     D PRWBIEN_copiaPoliza...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTipo                       1a   const

     D k1yins          ds                  likerec(c1wins:*key)

     D rc              s              1N

      /free

       PRWBIEN_inz();

       k1yins.inEmpr = peBase.peEmpr;
       k1yins.inSucu = peBase.peSucu;
       k1yins.inNivt = peBase.peNivt;
       k1yins.inNivc = peBase.peNivc;
       k1yins.inNctw = peNctw;
       k1yins.inTipo = peTipo;
       setll %kds( k1yins : 6 ) ctwins;
       reade %kds( k1yins : 6 ) ctwins;
       dow not %eof( ctwins );
         if inMarc = 'Copia de Poliza';
           return *on;
         endif;
         reade %kds( k1yins : 6 ) ctwins;
       enddo;

       return *off;

      /end-free

     P PRWBIEN_copiaPoliza...
     P                 E

      * ------------------------------------------------------------ *
      * PRWBIEN_insertaAseguradoSepelio(): Insertar asegurado de nomi*
      *                                    na de Sepelio.            *
      *                                                              *
      *         peBase (input)   Paramametro Base                    *
      *         peNctw (input)   Numero de Cotizacion                *
      *         peBsep (input)   Bien de Sepeliostreo                *
      *         peBsepC(input)   Cantidad de Bienes                  *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWBIEN_insertaAseguradoSepelio...
     P                 b                   export
     D PRWBIEN_insertaAseguradoSepelio...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peBsep                            likeds(prwBienSepe_t) dim(10)
     D   peBsepC                     10i 0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              1n
     D q               s             10i 0
     D x               s             10i 0
     D z               s             10i 0
     D peT069C         s             10i 0
     D pacos           s              3  0 dim(999)
     D paco2           s              3  0 dim(999)
     D hay_titular     s              1n
     D fnac_titular    s              8  0
     D fecha           s             10d
     D hoy             s             10d
     D peWsep          ds                  likeds(ctwsep_t)
     D peWse1          ds                  likeds(ctwse1_t) dim(20)
     D peT069          ds                  likeds(set069_t) dim(999)
     D k1wev1          ds                  likerec(c1wev1:*key)
     D k1wev2          ds                  likerec(c1wev2:*key)

      /free

       PRWBIEN_inz();

       peErro = 0;
       clear peMsgs;

       rc = valGeneral( peBase
                      : peNctw
                      : peRama
                      : peArse
                      : peBsep(1).poco
                      : peErro
                      : peMsgs );

       if ( rc = *OFF );
          return;
       endif;

       // ---------------------------------------
       // Recupero cabecera de cotizacion
       // ---------------------------------------
       rc = COWSEP_getCabecera( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : peWsep );

       // ---------------------------------------
       // Recupero coberturas
       // ---------------------------------------
       q  = COWSEP_getCoberturas( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : peWse1 );

       for x = 1 to q;
           if peWsep.epcant <> 0;
              peWse1(x).e1ptco /= peWsep.epcant;
           endif;
       endfor;

       // ---------------------------------------
       // Recupero parentescos
       // ---------------------------------------
       paco2(*) = 0;
       pacos(*) = 0;
       rc = SVPTAB_getParentescoVida( peT069 : peT069C);
       for x = 1 to peT069C;
           pacos(x) = peT069(x).t@paco;
       endfor;

       // ---------------------------------------
       // Cantidad no puede ser mayor a 10
       // ---------------------------------------
       if peBsepC > 10 or peBsepC <= 0;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0053'
                       : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ---------------------------------------
       // Cantidad no puede ser distinta a coti
       // ---------------------------------------
       if peBsepC <> peWsep.epcant;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0054'
                       : peMsgs      );
          peErro = -1;
          return;
       endif;

       // ---------------------------------------
       // Validar Componentes
       // ---------------------------------------
       hay_titular = *off;
       fnac_titular = 0;
       hoy = %date();
       for x = 1 to peBsepC;
           // -------------------------------
           // Componente siempre es 1
           // -------------------------------
           if peBsep(x).poco <> 1;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0055'
                           : peMsgs      );
              peErro = -1;
              return;
           endif;
           // -------------------------------
           // Parentesco tiene que existir
           // -------------------------------
           if %lookup(peBsep(x).paco: pacos) <= 0;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0056'
                           : peMsgs      );
              peErro = -1;
              return;
           endif;
           // -------------------------------
           // Parentesco no se debe repetir
           // -------------------------------
           if %lookup(peBsep(x).paco: paco2) <> 0;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0059'
                           : peMsgs      );
              peErro = -1;
              return;
            else;
              z = %lookup(0:paco2);
              if z > 0;
                 paco2(z) = peBsep(x).paco;
              endif;
           endif;
           // -------------------------------
           // Guardo el titular
           // -------------------------------
           if peBsep(x).paco = 1;
              hay_titular = *on;
              fnac_titular = peBsep(x).fnac;
           endif;
           // -------------------------------
           // Nombre cargado
           // -------------------------------
           if peBsep(x).nomb = *blanks;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0009'
                           : peMsgs      );
              peErro = -1;
              return;
           endif;
           // -------------------------------
           // Apellido cargado
           // -------------------------------
           if peBsep(x).apel = *blanks;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0058'
                           : peMsgs      );
              peErro = -1;
              return;
           endif;
           // -------------------------------
           // Nacionalidad
           // -------------------------------
           if SVPVAL_nacionalidad( peBsep(x).cnac ) = *off;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0042'
                           : peMsgs      );
              peErro = -1;
              return;
           endif;
           // -------------------------------
           // Fecha de Nacimiento
           // -------------------------------
           monitor;
               fecha = %date(peBsep(x).fnac:*iso);
            on-error;
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'GEN0009'
                            : peMsgs      );
               peErro = -1;
               return;
           endmon;
       endfor;

       // -----------------------------------
       // Al menos un titular
       // -----------------------------------
       if not hay_titular;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0060'
                       : peMsgs      );
          peErro = -1;
          return;
       endif;

       // -----------------------------------
       // Titular menor de edad
       // -----------------------------------
       if %diff( hoy : %date(fnac_titular:*iso) : *y ) < 18;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0061'
                       : peMsgs      );
          peErro = -1;
          return;
       endif;

       // -----------------------------------
       // No hay errores, asi que grabamos
       // -----------------------------------
       k1wev1.v1empr = peBase.peEmpr;
       k1wev1.v1sucu = peBase.peSucu;
       k1wev1.v1nivt = peBase.peNivt;
       k1wev1.v1nivc = peBase.peNivc;
       k1wev1.v1nctw = peNctw;
       k1wev1.v1rama = peRama;
       k1wev1.v1arse = peArse;
       for x = 1 to peBsepC;
           k1wev1.v1poco = peBsep(x).poco;
           k1wev1.v1paco = peBsep(x).paco;
           chain %kds(k1wev1:9) ctwev1;
           if %found;
              delete c1wev1;
           endif;
           v1empr = peBase.peEmpr;
           v1sucu = peBase.peSucu;
           v1nivt = peBase.peNivt;
           v1nivc = peBase.peNivc;
           v1rama = peRama;
           v1nctw = peNctw;
           v1arse = peArse;
           v1poco = peBsep(x).poco;
           v1paco = peBsep(x).paco;
           v1xpro = peWsep.epxpro;
           v1nomb = peBsep(x).apel + ' ' + peBsep(x).nomb;
           v1tido = peBsep(x).tido;
           v1nrdo = peBsep(x).nrdo;
           v1fnac = peBsep(x).fnac;
           v1naci = SVPDES_nacionalidad(peBsep(x).cnac);
           v1user = @PsDs.CurUsr;
           v1date = %dec(%date():*dmy);
           v1time = %dec(%time():*iso);
           write c1wev1;
           // ----------------------------------
           // Coberturas
           // ----------------------------------
           k1wev2.v2empr = peBase.peEmpr;
           k1wev2.v2sucu = peBase.peSucu;
           k1wev2.v2nivt = peBase.peNivt;
           k1wev2.v2nivc = peBase.peNivc;
           k1wev2.v2nctw = peNctw;
           k1wev2.v2rama = peRama;
           k1wev2.v2arse = peArse;
           k1wev2.v2poco = peBsep(x).poco;
           k1wev2.v2paco = peBsep(x).paco;
           for z = 1 to q;
               k1wev2.v2riec = peWse1(z).e1riec;
               k1wev2.v2xcob = peWse1(z).e1xcob;
               chain %kds(k1wev2:11) ctwev2;
               if %found;
                  delete c1wev2;
               endif;
               v2empr = peBase.peEmpr;
               v2sucu = peBase.peSucu;
               v2nivt = peBase.peNivt;
               v2nivc = peBase.peNivc;
               v2nctw = peNctw;
               v2rama = peRama;
               v2arse = peArse;
               v2poco = peBsep(x).poco;
               v2paco = peBsep(x).paco;
               v2riec = peWse1(z).e1riec;
               v2xcob = peWse1(z).e1xcob;
               v2ecob = peWse1(z).e1ecob;
               v2saco = peWse1(z).e1saco;
               v2ptco = peWse1(z).e1ptco;
               v2xpri = peWse1(z).e1xpri;
               v2prsa = peWse1(z).e1prsa;
               v2user = @PsDs.CurUsr;
               v2date = %dec(%date():*dmy);
               v2time = %dec(%time():*iso);
               write c1wev2;
           endfor;
       endfor;

      /end-free

     P PRWBIEN_insertaAseguradoSepelio...
     P                 e

