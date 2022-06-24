     H nomain
      * ************************************************************ *
      * PRWSND: Programa de Servicio.                                *
      *         Propuesta Web - Enviar Propuesta                     *
      *                                                              *
      * Este programa debe enlazarse a:                              *
      *                                                              *
      *  Script de compilación (para INF1SERG/BUILD)                 *
      *                                                              *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) -       <*           *
      *>                 OBJ((&N))                      <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *> TEXT('Programa de Servicio: Enviar Prop. Web') <*           *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) -       <*           *
      *>                 OBJ((&O))                      <*           *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                                             *
      * ------------------------------------------------------------ *
      * SGF 06/08/2016: Recompilo por ASEN en CTW000.                *
      * SGF 13/12/2016: Autos con cobertura A, llevan suma asegurada,*
      *                 cláusula de ajuste y suma siniestrable en 0. *
      * SGF 11/04/2017: Agrego Bajo Riesgo y Buen Resultado cuando no*
      *                 llegan.                                      *
      * LRG 15/08/2017: Se recompila por cambios en CTW000:          *
      *                          º Número de Cotización API          *
      *                          º Nombre de Sistema Remoto          *
      *                          º CUIT del productor                *
      * LRG 13/10/2017: Se recompila por cambios en CTW000:          *
      *                          º Nombre de Usuario                 *
      * NWN 23/11/2017: Se agrega 1023 a Calculo Fecha Hasta Factu-  *
      *                 rada.                                        *
      * GIO 07/12/2017: Habilita Marca T@MAR2 para indicar el Tipo   *
      *                 de Calculo de la Fecha-Hasta en cotizacion   *
      *                 invocando al SVPWEB_getCalculoFechaHasta     *
      * SGF 11/12/2017: En PRWSND_calculaHasta() peModi siempre es   *
      *                 "N".                                         *
      * LRG 06/06/2018. Se modifica llamda a PRWASE_isValid se       *
      *                 agregan parametros                           *
      * SGF 11/12/2017: En endosos, la fecha hasta es la de póliza.  *
      * LRG 30/04/2019: Se cambia fecha de vigencia de poliza a      *
      *                 renovar por defecto en app.                  *
      *                 Solución provisoria: Valsys que activa cambio*
      *                 automático en _SndPropuesta                  *
      * EXT 17/01/2019: Se recompila por cambios en CTWET0           *
      * GIO 21/03/2019: RM#03835 Desarrollo Servicio REST WSRECV     *
      *                 Ajusta condiciones para Endoso 3/7/4         *
      *                 Cambio en Patente - Chasis - Motor           *
      * LRG 27/05/2019: Se cambia llamada ed SVPWS_getGrupoRama por  *
      *                 SVPWS_getGrupoRamaArch                       *
      * SGF 04/05/2020: Veo si en _sndPropuesta() debo validar las   *
      *                 patentes duplicadas.                         *
      *                                                              *
      * LRG 14/05/2020: Se pasa valor absoluto campo días anticipados*
      *                 de inicio de vigencia                        *
      * JSN 07/05/2020: Se agrega filtro para pasar parametros de    *
      *                 Arcd, Poco y Spol al procedimiento           *
      *                 _sndPropuesta().                             *
      * SGF 11/06/2020: Valido mascotas.                             *
      * SGF 31/08/2020: Si es renovacion, validar que no este renova-*
      *                 da.                                          *
      * SGF 06/11/2020: Buscar mail de ctw004 para isValid().        *
      * JSN 01/07/2021: Se agrega el procedimiento _sndPropuesta2(). *
      * ************************************************************ *
     Fctw000    uf   e           k disk    usropn
     Fset620    if   e           k disk    usropn
     Fset621    if   e           k disk    usropn
     Fset915    uf a e           k disk    usropn
     Fset916    if   e           k disk    usropn prefix(te:2)
     Fctwer0    if   e           k disk    usropn
     Fctwer1    if   e           k disk    usropn
     Fctwer2    if a e           k disk    usropn
     Fctwer7    if   e           k disk    usropn
     Fset107    if   e           k disk    usropn
     Fctw001    if   e           k disk    usropn
     Fctw001c   if   e           k disk    usropn
     Fctw003    if   e           k disk    usropn
     Fctwet0    uf   e           k disk    usropn
     Fctwev1    if   e           k disk    usropn
     Fctwetc01  if   e           k disk    usropn
     Fset103    if   e           k disk    usropn
     Fctwer6    if a e           k disk    usropn
     Fset160    if   e           k disk    usropn
     Fsetpam01  if   e           k disk    usropn
     Fctwera    if   e           k disk    usropn
     Fctw004    if   e           k disk    usropn

      /copy './qcpybooks/prwsnd_h.rpgle'

     D @@valsys        S            512
     D @@debug         S              1

     D SPOPFECH        pr                  extpgm('SPOPFECH')
     D  peFdes                        8  0 const
     D  peSign                        1a   const
     D  peTipo                        1a   const
     D  peCant                        5  0 const
     D  peFech                        8  0
     D  peErro                        1a

     D WSLVIG          pr                  extpgm('WSLVIG')
     D  peArcd                        6  0 const
     D  peDsum                        2  0
     D  peDres                        2  0
     D  peFrec                       50a
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D SetError        pr
     D  peErrn                       10i 0
     D  peErrm                       80a

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     D Initialized     s              1N
     D Errn            s             10i 0
     D Errm            s             80a

     D calculaHasta    pr
     D  peArcd                        6  0 const
     D  peFdes                        8  0 const
     D  peFhas                        8  0
     D  peFhfa                        8  0

     Is1t915
     I              t@date                      tydate
     Is1t160
     I              t@date                      s6date

      * ------------------------------------------------------------ *
      * PRWSND_sndPropuesta(): Envía (o recibe) propuesta web.       *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peFdes  (input)  Fecha de Inicio de Vigencia            *
      *      peFhas  (input)  Fecha de Fin    de Vigencia (AP)       *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_sndPropuesta...
     P                 B                   Export
     D PRWSND_sndPropuesta...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D wrepl           s          65535a
     D rc              s              1N
     D*QUsec           ds                  likeds(QUsec_t)

     D SP0082          pr                  EXTPGM('SP0082')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peNmat                       25    const
     D  peFech                        8  0 const
     D  peErro                        1
     D  peErr2                        1
     D  peEmpr                        1    options(*nopass:*omit) const
     D  peSucu                        2    options(*nopass:*omit) const
     D  pePoco                        4  0 options(*nopass:*omit) const
     D  peArcd2                       6  0 options(*nopass:*omit)
     D  peSpol2                       7  0 options(*nopass:*omit)
     D  peRama                        2  0 options(*nopass:*omit)
     D  pePoli                        7  0 options(*nopass:*omit)
     D  pePoco2                       4  0 options(*nopass:*omit)
     D  peHast                        8  0 options(*nopass:*omit)

     D Data            ds                  qualified
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1a
     D  nivc                          5a
     D  nit1                          1a
     D  niv1                          5a
     D  nctw                          7a
     D  keyw                         10a

     D k1w000          ds                  likerec(c1w000:*key)
     D k1wer0          ds                  likerec(c1wer0:*key)
     D k1wer2          ds                  likerec(c1wer2:*key)
     D k1wer7          ds                  likerec(c1wer7:*key)
     D k1t107          ds                  likerec(s1t107:*key)
     D k1t103          ds                  likerec(s1t103:*key)
     D K1y001          ds                  likerec(c1w001:*key)
     D k1t621          ds                  likerec(s1t621:*key)
     D k1y915          ds                  likerec(s1t915:*key)
     D k1w003          ds                  likerec(c1w003:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)
     D k1wev1          ds                  likerec(c1wev1:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1wer6          ds                  likerec(c1wer6:*key)
     D k1y160          ds                  likerec(s1t160:*key)
     D k1tpam          ds                  likerec(s1tpam:*key)
     D k1w004          ds                  likerec(c1w004:*key)

     D peDomi          ds                  likeds(prwaseDomi_t)
     D peDocu          ds                  likeds(prwaseDocu_t)
     D peNtel          ds                  likeds(prwaseTele_t)
     D peMail          ds                  likeds(prwaseEmail_t)
     D peInsc          ds                  likeds(prwaseInsc_t)
     D peNaci          ds                  likeds(prwaseNaco_t)

     D suma_obj        s             15  2
     D suma_ase        s             15  2
     D p@arcd          s              6  0
     D nohaydatos      s               n
     D fdes            s             10d
     D difpermitida    s              5i 0 inz(3)
     D dif             s              5i 0
     D aseg_valido     s              1N
     D i               s             10i 0
     D z               s              4  0
     D peModi          s              1a
     D peFhfa          s              8  0

     D desde           s             10d
     D hasta           s             10d
     D peDsum          s              2  0
     D peDres          s              2  0
     D peFrec          s             50a
     D saco_rem        s             15  2
     D tmpfec          s               d   datfmt(*iso)
     D @@fecd          s              8  0
     D @@fech          s              8  0
     D @@fdes          s              8  0
     D @@tiou          s              1  0 inz(*zeros)
     D @@stou          s              2  0 inz(*zeros)
     D @@stos          s              2  0 inz(*zeros)
     D fechPat         s              8  0
     D errPate         s              1a
     D errPat2         s              1a
     D @@poco          s              4  0
     D @@Arcd          s              6  0
     D @@Spol          s              9  0
     D @@masc          s              1n

      /free

       PRWSND_inz();

       @@fdes = peFdes;

       rc = SVPWS_chkParmBase( peBase : peMsgs );
       if rc = *off;
          peErro = -1;
          PRWSND_end();
          return;
       endif;

       // ------------------------------------------
       // Si ya la enviaron, es error
       // ------------------------------------------
       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain(n) %kds(k1w000:5) ctw000;
       if %found;
          if w0soln <> 0 or w0spol <> 0;
             %subst(wrepl:1:7) = %trim(%char(peNctw));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0119'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
          peErro = -1;
          PRWSND_end();
          return;
          endif;
          // ---------------------------------------------
          // Es una cotización vencida
          // ---------------------------------------------
          if w0cest = 1 and w0cses = 9;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SND0002'
                          : peMsgs     );
             peErro = -1;
             PRWSND_end();
             return;
          endif;
       endif;

       @@tiou = w0tiou;
       @@stou = w0stou;
       @@stos = w0stos;

       rc = COWGRAI_chkCotizacion( peBase : peNctw );
       if rc = *off;
          %subst(wrepl:1:7) = %editc(peNctw:'X');
          %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
          %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          PRWSND_end();
          return;
       endif;

       monitor;
          fdes = %date(@@fdes:*iso);
        on-error;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0117'
                       : peMsgs        );
          peErro = -1;
          PRWSND_end();
          return;
       endmon;

       if not SVPVLS_getValsys('HCHGFVIGRN':*omit:@@ValSys );
         @@Valsys = 'N';
       endif;

       if w0tiou = 2 and %trim(@@Valsys) = 'S';
         if SPVSPO_getFecVig( w0empr
                            : w0sucu
                            : w0arcd
                            : w0spo1
                            : @@fecd
                            : @@fech  );
          @@fdes  = @@fech;
          tmpfec  = %date(( @@fech ): *iso );
          tmpfec += %years(1);
          peFhas  = %int( %char( tmpfec : *iso0) );
        endif;
       endif;

       // ------------------------------------
       // Diferencia entre hoy y vigencia
       // ------------------------------------
       if w0tiou <> 2;
          WSLVIG( w0arcd: peDsum: peDres: peFrec: peErro: peMsgs );
          desde = %date() - %days(%abs(peDres));
          hasta = %date() + %days(peDsum);
          if %date(@@fdes:*iso) < desde or
             %date(@@fdes:*iso) > hasta;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0120'
                          : peMsgs     );
             peErro = -1;
             PRWSND_end();
             return;
          endif;
       endif;

       // ------------------------------------
       // Si es una renovacion, ver si no esta
       // renovada
       // ------------------------------------
       if (w0tiou = 2);
          if SPVSPO_chkSpolRenovada( peBase.peEmpr
                                   : peBase.peSucu
                                   : w0arcd
                                   : w0spo1         ) <> 0;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SND0006'
                          : peMsgs );
             peErro = -1;
             return;
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
             fechPat = SPVFEC_giroFecha8( @@fdes : 'DMA' );
             k1wet0.t0empr = peBase.peEmpr;
             k1wet0.t0sucu = peBase.peSucu;
             k1wet0.t0nivt = peBase.peNivt;
             k1wet0.t0nivc = peBase.peNivc;
             k1wet0.t0nctw = peNctw;
             setll %kds(k1wet0:5) ctwet0;
             reade(n) %kds(k1wet0:5) ctwet0;
             dow not %eof;
               k1tpam.pmempr = t0empr;
               k1tpam.pmsucu = t0sucu;
               k1tpam.pmmcod = t0tmat;
               chain %kds(k1tpam:3) setpam01;
               if %found;

                 // --------------------------------------------------------
                 // Antes de ejecutar SP0082, se debe tomar en cuenta si es
                 // un endoso de aumento de suma, para mandar los parametros
                 // de ARCD, POCO y SPOL, diferente de Cero
                 // --------------------------------------------------------
                 if w0Tiou = 3 and w0Stou = 1 and w0Stos = 5;
                   @@Arcd = w0Arcd;
                   @@Spol = w0Spo1;
                   @@poco = t0Poco;
                 else;
                   @@Arcd = *zeros;
                   @@Spol = *zeros;
                   @@poco = *zeros;
                 endif;

                 if pmvald = 'N';
                    SP0082( @@Arcd
                          : @@Spol
                          : t0nmat
                          : fechPat
                          : errPate
                          : errPat2
                          : t0empr
                          : t0sucu
                          : @@poco );
                    if ( errPate = 'E' );
                       SVPWS_getMsgs( '*LIBL'
                                    : 'WSVMSG'
                                    : 'COW0042'
                                    : peMsgs );
                       peErro = -1;
                       return;
                    endif;
                 endif;
               endif;
               reade(n) %kds(k1wet0:5) ctwet0;
             enddo;
          endif;
       endif;

       // ------------------------------------
       // Valido sumatoria de objetos x Cob
       // ------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
           k1wer2.r2empr = peBase.peEmpr;
           k1wer2.r2sucu = peBase.peSucu;
           k1wer2.r2nivt = peBase.peNivt;
           k1wer2.r2nivc = peBase.peNivc;
           k1wer2.r2nctw = peNctw;
           k1wer2.r2rama = r0rama;
           k1wer2.r2arse = r0arse;
           k1wer2.r2poco = r0poco;
           setll %kds(k1wer2:8) ctwer2;
           reade(n) %kds(k1wer2:8) ctwer2;
           dow not %eof;
               suma_obj = 0;
               k1wer7.r7empr = peBase.peEmpr;
               k1wer7.r7sucu = peBase.peSucu;
               k1wer7.r7nivt = peBase.peNivt;
               k1wer7.r7nivc = peBase.peNivc;
               k1wer7.r7nctw = peNctw;
               k1wer7.r7rama = r0rama;
               k1wer7.r7arse = r0arse;
               k1wer7.r7poco = r0poco;
               k1wer7.r7riec = r2riec;
               k1wer7.r7xcob = r2xcob;
               setll %kds(k1wer7:10) ctwer7;
               if %equal();
                 nohaydatos = *off;
                 reade %kds(k1wer7:10) ctwer7;
                 dow not %eof;
                     suma_obj += r7suas;
                  reade %kds(k1wer7:10) ctwer7;
                 enddo;
               else;
                 nohaydatos = *on;
               endif;
               if suma_obj <> r2saco and nohaydatos = *off;
                  k1t107.t@rama = r2rama;
                  k1t107.t@cobc = r2xcob;
                  chain %kds(k1t107:2) set107;
                  if not %found;
                     t@cobd = *all'*';
                  endif;
                  %subst(wrepl:1:20) = %trim(t@cobd);
                  %subst(wrepl:21:6) = %trim(%char(r2poco));
                  %subst(wrepl:27:7) = %trim(%char(peNctw));
                  SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : 'PRW0036'
                               : peMsgs
                               : %trim(wrepl)
                               : %len(%trim(wrepl))  );
                  peErro = -1;
                  PRWSND_end();
                  return;
               endif;
            reade(n) %kds(k1wer2:8) ctwer2;
           enddo;
        reade %kds(k1wer0:5) ctwer0;
       enddo;

       // ------------------------------------------
       // Valido sumatoria de los Asegurasdos x Cob
       // ------------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
           k1wer2.r2empr = peBase.peEmpr;
           k1wer2.r2sucu = peBase.peSucu;
           k1wer2.r2nivt = peBase.peNivt;
           k1wer2.r2nivc = peBase.peNivc;
           k1wer2.r2nctw = peNctw;
           k1wer2.r2rama = r0rama;
           k1wer2.r2arse = r0arse;
           k1wer2.r2poco = r0poco;
           setll %kds(k1wer2:8) ctwer2;
           reade(n) %kds(k1wer2:8) ctwer2;
           dow not %eof;
               suma_ase = 0;
               k1wer7.r7empr = peBase.peEmpr;
               k1wer7.r7sucu = peBase.peSucu;
               k1wer7.r7nivt = peBase.peNivt;
               k1wer7.r7nivc = peBase.peNivc;
               k1wer7.r7nctw = peNctw;
               k1wer7.r7rama = r0rama;
               k1wer7.r7arse = r0arse;
               k1wer7.r7poco = r0poco;
               k1wer7.r7riec = r2riec;
               k1wer7.r7xcob = r2xcob;
               setll %kds(k1wer7:10) ctwer1;
               if %equal();
                 nohaydatos = *off;
                 reade %kds(k1wer7:10) ctwer1;
                 dow not %eof;
                     suma_ase += r1suas;
                  reade %kds(k1wer7:10) ctwer1;
                 enddo;
               else;
                 nohaydatos = *on;
               endif;
               if suma_ase <> r2saco and nohaydatos = *off;
                  k1t107.t@rama = r2rama;
                  k1t107.t@cobc = r2xcob;
                  chain %kds(k1t107:2) set107;
                  if not %found;
                     t@cobd = *all'*';
                  endif;
                  %subst(wrepl:1:20) = %trim(t@cobd);
                  %subst(wrepl:21:6) = %trim(%char(r2poco));
                  %subst(wrepl:27:7) = %trim(%char(peNctw));
                  SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : 'PRW0037'
                               : peMsgs
                               : %trim(wrepl)
                               : %len(%trim(wrepl))  );
                  peErro = -1;
                  PRWSND_end();
                  return;
               endif;
            reade(n) %kds(k1wer2:8) ctwer2;
           enddo;
        reade %kds(k1wer0:5) ctwer0;
       enddo;

       // --------------------------------------------
       // Si alguna cobertura permite mascota, debe
       // haberse cargado una
       // --------------------------------------------
       @@masc = *off;
       k1wer2.r2empr = peBase.peEmpr;
       k1wer2.r2sucu = peBase.peSucu;
       k1wer2.r2nivt = peBase.peNivt;
       k1wer2.r2nivc = peBase.peNivc;
       k1wer2.r2nctw = peNctw;
       setll %kds(k1wer2:5) ctwer2;
       reade %kds(k1wer2:5) ctwer2;
       dow not %eof;
           k1t107.t@rama = r2rama;
           k1t107.t@cobc = r2xcob;
           chain %kds(k1t107:2) set107;
           if %found;
              if t@mar3 = 'M';
                 @@masc = *on;
                 leave;
              endif;
           endif;
        reade %kds(k1wer2:5) ctwer2;
       enddo;
       if @@masc;
          setll %kds(k1wer2:5) ctwera;
          if not %equal;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0062'
                          : peMsgs     );
             peErro = -1;
             PRWSND_end();
             return;
          endif;
       endif;

       // Si operacion 3/7/4 => No hacer la validacion
       if not ( @@tiou = 3 and @@stou = 7 and @@stos = 4 );

         // ------------------------------------------
         // Valido que se coticen todas las ramas
         // ------------------------------------------

         p@Arcd = COWGRAI_getArticulo ( peBase :
                                        peNctw );

         k1t621.t@arcd = p@arcd;

         setll %kds(k1t621:1) set621;
         reade %kds(k1t621:1) set621;
         dow not %eof();

           k1y001.w1empr = peBase.peEmpr;
           k1y001.w1sucu = peBase.pesucu;
           k1y001.w1nivt = peBase.peNivt;
           k1y001.w1nivc = peBase.peNivc;
           k1y001.w1nctw = peNctw;
           k1y001.w1rama = t@rama;

           setll %kds( k1y001 ) ctw001;
           if not %equal();

             %subst(wrepl:24:2) = %trim(%char(t@rama));
             %subst(wrepl:28:6) = %trim(%char(p@arcd));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0038'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             PRWSND_end();
             return;

           endif;

           reade %kds(k1t621:1) set621;
         enddo;
       endif;

       // ------------------------------------------ //
       // Valida bien asegurado exista en Cotizacion //
       // ------------------------------------------ //

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.pesucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         setll %kds( k1y001 : 5 ) ctw001;
         reade %kds( k1y001 : 5 ) ctw001;
           dow not %eof( ctw001 );
             Select;
               when SVPWS_getGrupoRamaArch( w1rama ) = 'A';

                    k1wet0.t0empr = peBase.peEmpr;
                    k1wet0.t0sucu = peBase.peSucu;
                    k1wet0.t0nivt = peBase.peNivt;
                    k1wet0.t0nivc = peBase.peNivc;
                    k1wet0.t0nctw = peNctw;
                    setll %kds(k1wet0:5) ctwet0;
                    reade(n) %kds(k1wet0:5) ctwet0;
                    dow not %eof;
                        if t0poco <= 0;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0moto = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0chas = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0vhuv <= 0;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0mgnc <> 'S' and t0mgnc <> 'N' and
                           t0mgnc <> '1' and t0mgnc <> '0';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0mgnc = 'S' and t0rgnc <= 0;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0tmat = *blanks or t0nmat = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0nmer = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0aver <> '0' and t0aver <> '1' and
                           t0aver <> 'S' and t0aver <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0cesv <> '0' and t0cesv <> '1' and
                           t0cesv <> 'S' and t0cesv <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0iris <> '0' and t0iris <> '1' and
                           t0iris <> 'S' and t0iris <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0clin <> '0' and t0clin <> '1' and
                           t0clin <> 'S' and t0clin <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        k1wetc.t0empr = t0empr;
                        k1wetc.t0sucu = t0sucu;
                        k1wetc.t0nivt = t0nivt;
                        k1wetc.t0nivc = t0nivc;
                        k1wetc.t0nctw = t0nctw;
                        k1wetc.t0rama = t0rama;
                        k1wetc.t0arse = t0arse;
                        k1wetc.t0poco = t0poco;
                        setll %kds(k1wetc:8) ctwetc01;
                        if not %equal;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                     reade(n) %kds(k1wet0:5) ctwet0;
                    enddo;

               when SVPWS_getGrupoRamaArch( w1rama ) = 'R';

                    k1wer0.r0empr = peBase.peEmpr;
                    k1wer0.r0sucu = peBase.peSucu;
                    k1wer0.r0nivt = peBase.peNivt;
                    k1wer0.r0nivc = peBase.peNivc;
                    k1wer0.r0nctw = peNctw;
                    setll %kds(k1wer0:5) ctwer0;
                    reade %kds(k1wer0:5) ctwer0;
                    dow not %eof;
                        if r0poco <= 0;
                           %subst(wrepl:1:4) = %trim(%char(r0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0004'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if r0rdes = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(r0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0004'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if r0cviv <= 0 and SVPWS_getGrupoRama(w1rama) = 'H';
                           %subst(wrepl:1:4) = %trim(%char(r0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0004'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                     reade %kds(k1wer0:5) ctwer0;
                    enddo;

               when SVPWS_getGrupoRamaArch( w1rama ) = 'V';

                    k1wev1.v1empr = peBase.peEmpr;
                    k1wev1.v1sucu = peBase.peSucu;
                    k1wev1.v1nivt = peBase.peNivt;
                    k1wev1.v1nivc = peBase.peNivc;
                    k1wev1.v1nctw = peNctw;
                    setll %kds(k1wev1:5) ctwev1;
                    reade %kds(k1wev1:5) ctwev1;
                    dow not %eof;
                        if v1poco <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1paco <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1acti <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1secu <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1xpro <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1nomb = *blanks;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1tido <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1nrdo <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1fnac <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1naci = *blanks;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                     reade %kds(k1wev1:5) ctwev1;
                    enddo;

             endsl;


          reade %kds( k1y001 : 5 ) ctw001;
           enddo;

       // -----------------------------------------
       // Debe haber un asegurado principal
       // -----------------------------------------
       k1w003.w3empr = peBase.peEmpr;
       k1w003.w3sucu = peBase.peSucu;
       k1w003.w3nivt = peBase.peNivt;
       k1w003.w3nivc = peBase.peNivc;
       k1w003.w3nctw = peNctw;
       k1w003.w3nase = 0;
       setll %kds(k1w003:6) ctw003;
       if not %equal;
           %subst(wrepl:1:7) = %trim(%char(peNctw));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'SND0001'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           PRWSND_end();
           return;
       endif;

       // -----------------------------------------
       // Los asegurados deben ser todos válidos
       // Barro todos (principal y adicionales si
       // hay)
       // -----------------------------------------
       setll %kds(k1w003:5) ctw003;
       reade %kds(k1w003:5) ctw003;
       dow not %eof;
           if w3nase < 0;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0040'
                           : peMsgs     );
              peErro = -1;
              PRWSND_end();
              return;
           endif;
           peDomi.domi = w3domi;
           peDomi.copo = w3copo;
           peDomi.cops = w3cops;
           peDocu.tido = w3tido;
           peDocu.nrdo = w3nrdo;
           for i = 1 to 11;
               if %subst(w3cuit:i:1) <> '0' and
                  %subst(w3cuit:i:1) <> '1' and
                  %subst(w3cuit:i:1) <> '2' and
                  %subst(w3cuit:i:1) <> '3' and
                  %subst(w3cuit:i:1) <> '4' and
                  %subst(w3cuit:i:1) <> '5' and
                  %subst(w3cuit:i:1) <> '6' and
                  %subst(w3cuit:i:1) <> '7' and
                  %subst(w3cuit:i:1) <> '8' and
                  %subst(w3cuit:i:1) <> '9';
                  %subst(w3cuit:i:1) = '0';
               endif;
           endfor;
           peDocu.cuit = %dec(w3cuit:11:0);
           peDocu.cuil = w3njub;
           peNtel.nte1 = w3telp;
           peNtel.nte2 = w3telc;
           peNtel.nte3 = w3telt;
           peNtel.nte4 = *blanks;
           peNtel.pweb = *blanks;
           peMail.ctce = *zeros;
           peMail.mail = *blanks;
           peInsc.fein = w3fein;
           peInsc.nrin = w3nrin;
           peInsc.feco = w3feco;
           peNaci.fnac = w3fnac;
           peNaci.lnac = *blanks;
           peNaci.pain = 6;
           peNaci.cnac = w3cnac;
           k1w004.w4empr = w3empr;
           k1w004.w4sucu = w3sucu;
           k1w004.w4nivt = w3nivt;
           k1w004.w4nivc = w3nivc;
           k1w004.w4nctw = w3nctw;
           k1w004.w4nase = w3nase;
           chain %kds(k1w004:6) ctw004;
           if %found;
              peMail.ctce = w4ctce;
              peMail.mail = w4mail;
           endif;
           PRWASE_isValid( peBase
                         : peNctw
                         : w3asen
                         : peDomi
                         : peDocu
                         : peNtel
                         : w3tiso
                         : peNaci
                         : w3cprf
                         : w3csex
                         : w3cesc
                         : w3raae
                         : peMail
                         : w3cbus
                         : w3ruta
                         : w3civa
                         : peInsc
                         : peErro
                         : peMsgs   );
          if peErro = -1;
             PRWSND_end();
             return;
          endif;
        reade %kds(k1w003:5) ctw003;
       enddo;

       // -----------------------------------------//

       k1w003.w3empr = peBase.peEmpr;
       k1w003.w3sucu = peBase.peSucu;
       k1w003.w3nivt = peBase.peNivt;
       k1w003.w3nivc = peBase.peNivc;
       k1w003.w3nctw = peNctw;
       k1w003.w3nase = 0;
       chain %kds(k1w003:6) ctw003;
       if not %found;
          w3nomb = 'N/A';
       endif;

       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;


       chain %kds(k1w000:5) ctw000;
       if %found;

          k1y915.t@empr = peBase.peEmpr;
          k1y915.t@sucu = peBase.peSucu;
          k1y915.t@tnum = 'SO';

          chain %kds( k1y915 : 3 ) set915;

          if %found;
             t@nres += 1;
             t@user  = @PsDs.CurUsr;
             t@date  = udate;
             t@time  = %dec(%time);
             update s1t915;
          else;
             t@empr = peBase.peEmpr;
             t@sucu = peBase.peSucu;
             t@tnum = 'SO';
             t@dnum = 'NUMERO DE SOLICITUD';
             t@nres = 1;
             t@user = @PsDs.CurUsr;
             t@date = udate;
             t@time = %dec(%time);
             write s1t915;
          endif;

          w0soln = t@nres;
          w0cest = 5;   // Propuesta
          w0cses = 3;   // Recibida por la cia
          chain (w0cest:w0cses) set916;
          if %found;
             w0dest = tedest;
          endif;
          w0vdes = @@fdes;
          w0nomb = w3nomb;
          // -------------------------------------
          // Hasta se calcula siempre, salvo AP
          // -------------------------------------
          if not SVPWEB_getCalculoFechaHasta( peBase.peEmpr :
                                              peBase.peSucu :
                                              w0arcd );
             w0vhas = peFhas;
           else;
             calculaHasta( w0arcd
                         : @@fdes
                         : w0vhas
                         : peFhfa );
          endif;
          // ----------------------------------------
          // En endosos, la fecha hasta es la póliza
          // ----------------------------------------
          if w0tiou = 3;
             rc = SPVSPO_getFecVig( w0empr
                                  : w0sucu
                                  : w0arcd
                                  : w0spo1
                                  : *omit
                                  : w0vhas );
          endif;
          w0fpro = %dec(%date():*iso);
          update c1w000;

       endif;

       // -------------------------------------
       // Suma Asegurada RC
       // -------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       setll %kds(k1wetc:5) ctwetc01;
       reade %kds(k1wetc:5) ctwetc01;
       dow not %eof;
           if t0cobl = 'A';
               k1wet0.t0empr = peBase.peEmpr;
               k1wet0.t0sucu = peBase.peSucu;
               k1wet0.t0nivt = peBase.peNivt;
               k1wet0.t0nivc = peBase.peNivc;
               k1wet0.t0nctw = peNctw;
               k1wet0.t0rama = t0rama;
               k1wet0.t0arse = t0arse;
               k1wet0.t0poco = t0poco;
               chain %kds(k1wet0) ctwet0;
               if %found;
                  t0claj = 0;
                  t0vhvu = 0;
                  t0sast = 0;
                  update c1wet0;
               endif;
           endif;
        reade %kds(k1wetc:5) ctwetc01;
       enddo;

       // -------------------------------------
       // Agrego la remoción de escombros, si
       // no está
       // -------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
           k1t103.t@rama = r0rama;
           k1t103.t@xpro = r0xpro;
           k1t103.t@riec = '010';
           k1t103.t@cobc = 140;
           k1t103.t@mone = COWGRAI_monedaCotizacion(peBase:peNctw);
           setll %kds(k1t103) set103;
           if %equal;
              k1wer2.r2empr = r0empr;
              k1wer2.r2sucu = r0sucu;
              k1wer2.r2nivt = r0nivt;
              k1wer2.r2nivc = r0nivc;
              k1wer2.r2nctw = r0nctw;
              k1wer2.r2rama = r0rama;
              k1wer2.r2arse = r0arse;
              k1wer2.r2poco = r0poco;
              k1wer2.r2riec = '010';
              k1wer2.r2xcob = 13;
              chain(n) %kds(k1wer2) ctwer2;
              if %found;
                 saco_rem = r2saco * 0.05;
                 k1wer2.r2xcob = 140;
                 setll %kds(k1wer2) ctwer2;
                 if not %equal;
                    r2empr = r0empr;
                    r2sucu = r0sucu;
                    r2nivt = r0nivt;
                    r2nivc = r0nivc;
                    r2nctw = r0nctw;
                    r2rama = r0rama;
                    r2arse = r0arse;
                    r2poco = r0poco;
                    r2riec = '010';
                    r2xcob = 140;
                    r2saco = saco_rem;
                    r2ptco = 0;
                    r2xpri = 0;
                    r2prsa = 0;
                    r2ptca = 0;
                    r2ma01 = ' ';
                    r2ma02 = ' ';
                    r2ma03 = ' ';
                    r2ma04 = ' ';
                    r2ma05 = ' ';
                    write c1wer2;
                 endif;
              endif;
           endif;
        reade %kds(k1wer0:5) ctwer0;
       enddo;

       // -------------------------------------
       // Agrego Buen resultado y bajo riesgo
       // si no están
       // -------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
         for z = 996 to 999;
           k1y160.t@Empr = r0Empr;
           k1y160.t@Sucu = r0Sucu;
           k1y160.t@Rama = r0Rama;
           k1y160.t@Ccba = z;
           setll %kds( k1y160 : 4 ) set160;
           if %equal( set160 );
               k1wer6.r6empr = r0empr;
               k1wer6.r6sucu = r0sucu;
               k1wer6.r6nivt = r0nivt;
               k1wer6.r6nivc = r0nivc;
               k1wer6.r6nctw = r0nctw;
               k1wer6.r6rama = r0rama;
               k1wer6.r6arse = r0arse;
               k1wer6.r6poco = r0poco;
               k1wer6.r6ccba = z;
               setll %kds(k1wer6) ctwer6;
               if not %equal;
                  r6empr = r0empr;
                  r6sucu = r0sucu;
                  r6nivt = r0nivt;
                  r6nivc = r0nivc;
                  r6nctw = r0nctw;
                  r6rama = r0rama;
                  r6arse = r0arse;
                  r6poco = r0poco;
                  r6ccba = z;
                  r6ma01 = 'N';
                  r6ma02 = 'N';
                  write c1wer6;
               endif;
           endif;
         endfor;
         reade %kds(k1wer0:5) ctwer0;
       enddo;

       @@debug = 'N';
       if SVPVLS_getValsys('HDEBUGSND':*omit:@@ValSys );
         @@debug = @@valsys;
       endif;

       if @@debug <> 'S';
          PRWSND_sndDtaQ( peBase
                        : peNctw  );
          PRWSND_sndMail( peBase : peNctw : w0soln );
       endif;

       PRWSND_end();
       return;

      /end-free

     P PRWSND_sndPropuesta...
     P                 E

      * ------------------------------------------------------------ *
      * PRWSND_calculaHasta(): Calcula fecha de vencimiento.         *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peFdes  (input)  Fecha de Inicio de Vigencia            *
      *      peFhas  (output) Fecha de Fin    de Vigencia            *
      *      peFhfa  (output) Fecha Hasta Facturado                  *
      *      peModi  (output) Permite cambiar fecha hasta S/N        *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_calculaHasta...
     P                 B                   Export
     D PRWSND_calculaHasta...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peFhfa                       8  0
     D   peModi                       1a
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D wrepl           s          65535a
     D rc              s              1N
     D peCant          s              5  0
     D peFech          s              8  0
     D peErr1          s              1a
     D peFiso          s             10d
     D peTope          s              8  0

     D fdes            s             10d
     D difpermitida    s              5i 0 inz(3)
     D dif             s              5i 0
     D desde           s             10d
     D hasta           s             10d
     D peDsum          s              2  0
     D peDres          s              2  0
     D peFrec          s             50a

     D k1w000          ds                  likerec(c1w000:*key)
     D k1t621          ds                  likerec(s1t621:*key)

      /free

       PRWSND_inz();

       peModi = 'N';
       peFhas = 0;
       peFhfa = 0;

       rc = SVPWS_chkParmBase( peBase : peMsgs );
       if rc = *off;
          peErro = -1;
          PRWSND_end();
          return;
       endif;

       rc = COWGRAI_chkCotizacion( peBase : peNctw );
       if rc = *off;
          %subst(wrepl:1:7) = %editc(peNctw:'X');
          %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
          %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          PRWSND_end();
          return;
       endif;

       monitor;
          fdes = %date(peFdes:*iso);
        on-error;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0117'
                       : peMsgs      );
          peErro = -1;
          PRWSND_end();
          return;
       endmon;

       // ------------------------------------
       // Diferencia entre hoy y vigencia
       // ------------------------------------
       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain(n) %kds(k1w000) ctw000;
       if %found;
          if w0tiou <> 2;
             WSLVIG(w0arcd: peDsum: peDres: peFrec: peErro: peMsgs);
             desde = %date() - %days(%abs(peDres));
             hasta = %date() + %days(peDsum);
             if %date(peFdes:*iso) < desde or
                %date(peFdes:*iso) > hasta;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0120'
                             : peMsgs     );
                peErro = -1;
                PRWSND_end();
                return;
             endif;
          endif;
       endif;

       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain(n) %kds(k1w000) ctw000;
       if %found;
          calculaHasta( w0arcd
                      : peFdes
                      : peFhas
                      : peFhfa );
       endif;

       return;

      /end-free

     P PRWSND_calculaHasta...
     P                 E

      * ------------------------------------------------------------ *
      * PRWSND_sndDtaQ(): Enviar propuesta a DTAQ.                   *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_sndDtaQ...
     P                 B                   Export
     D PRWSND_sndDtaQ  pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D Data            ds                  qualified
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1a
     D  nivc                          5a
     D  nit1                          1a
     D  niv1                          5a
     D  nctw                          7a
     D  keyw                         10a

      /free

       Data.empr = peBase.peEmpr;
       Data.sucu = peBase.peSucu;
       Data.nivt = %editc(peBase.peNivt:'X');
       Data.nivc = %editc(peBase.peNivc:'X');
       Data.nit1 = %editc(peBase.peNit1:'X');
       Data.niv1 = %editc(peBase.peNiv1:'X');
       Data.nctw = %editc(peNctw:'X');
       Data.keyw = 'EMISOLWEB';

       QSNDDTAQ( 'QUOMEMI01'
               : '*LIBL'
               : %len(%trim(data))
               : Data                    );

      /end-free

     P PRWSND_sndDtaQ...
     P                 E

      * ------------------------------------------------------------ *
      * PRWSND_getNroSolicitud(): Recupera número de propuesta para  *
      *                           cotización.                        *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peSoln  (output) Número de Solicitud                    *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_getNroSolicitud...
     P                 B                   Export
     D PRWSND_getNroSolicitud...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1w000          ds                  likerec(c1w000:*key)

      /free

       PRWSND_inz();

       peSoln = 0;

       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain(n) %kds(k1w000:5) ctw000;
       if %found;
          if w0soln <> 0;
             peSoln = w0soln;
          endif;
       endif;

       return;

      /end-free

     P PRWSND_getNroSolicitud...
     P                 E

      * ------------------------------------------------------------ *
      * PRWSND_inz(): Inicializa Módulo                              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_inz      B                   Export
     D PRWSND_inz      pi

      /free

       if Initialized;
          return;
       endif;

       if not %open(ctw000);
          open ctw000;
       endif;

       if not %open(ctw001);
          open ctw001;
       endif;

       if not %open(ctw001c);
          open ctw001c;
       endif;

       if not %open(ctw003);
          open ctw003;
       endif;

       if not %open(ctwer0);
          open ctwer0;
       endif;

       if not %open(ctwer1);
          open ctwer1;
       endif;

       if not %open(ctwer2);
          open ctwer2;
       endif;

       if not %open(ctwer6);
          open ctwer6;
       endif;

       if not %open(ctwer7);
          open ctwer7;
       endif;

       if not %open(set107);
          open set107;
       endif;

       if not %open(set620);
          open set620;
       endif;

       if not %open(set621);
          open set621;
       endif;

       if not %open(set915);
          open set915;
       endif;

       if not %open(set916);
          open set916;
       endif;

       if not %open(ctwet0);
          open ctwet0;
       endif;

       if not %open(ctwev1);
          open ctwev1;
       endif;

       if not %open(ctwetc01);
          open ctwetc01;
       endif;

       if not %open(set103);
          open set103;
       endif;

       if not %open(set160);
          open set160;
       endif;

       if not %open(setpam01);
          open setpam01;
       endif;

       if not %open(ctwera);
          open ctwera;
       endif;

       if not %open(ctw004);
          open ctw004;
       endif;

       Initialized = *ON;
       return;

      /end-free

     P PRWSND_inz      E

      * ------------------------------------------------------------ *
      * PRWSND_end(): Finaliza  Módulo                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_end      B                   Export
     D PRWSND_end      pi

      /free

       Initialized = *OFF;
       close *all;
       return;

      /end-free

     P PRWSND_end      E

      * ------------------------------------------------------------ *
      * PRWSND_error(): Retorna último error del módulo.             *
      *                                                              *
      *      peErrn  (input)  Número de error (opcional)             *
      *                                                              *
      * Retorna: mensaje de error                                    *
      * ------------------------------------------------------------ *
     P PRWSND_error    B                   Export
     D PRWSND_error    pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *NULL;
          peErrn = Errn;
       endif;

       return Errm;

      /end-free

     P PRWSND_error    E

      * ------------------------------------------------------------ *
      * SetError(): Establece error global.                          *
      *                                                              *
      *      peErrn  (input)  Número de error                        *
      *      peErrm  (input)  Mensaje de Error                       *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0
     D  peErrm                       80a

      /free

       Errn = peErrn;
       Errm = peErrm;

       return;

      /end-free

     P SetError        E

      * ------------------------------------------------------------ *
      * calculaHasta: Calcular Vigencia Hasta/Hasta Facturado        *
      *                                                              *
      *      peArcd  (input)  Artículo                               *
      *      peFdes  (input)  Vigencia Desde                         *
      *      peFhas  (output) Vigencia Hasta                         *
      *      peFhfa  (output) Hasta Facturado                        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P calculaHasta    B
     D calculaHasta    pi
     D  peArcd                        6  0 const
     D  peFdes                        8  0 const
     D  peFhas                        8  0
     D  peFhfa                        8  0

     D peTipo          s              1
     D p@Erro          s              1

      /free

       chain peArcd set620;
       if not %found;
          return;
       endif;

       select;
        when t@mar1 = '1'; // En meses
             peTipo = 'M';
        when t@mar1 = '2'; // En años
             peTipo = 'A';
        when t@mar1 = '3'; // En años hasta (no implementado)
             peTipo = 'A';
        other;             // Pozo: Asumo años
             peTipo = 'A';
       endsl;
       SPOPFECH( peFdes
               : '+'
               : peTipo
               : t@dupe
               : peFhas
               : p@Erro );

       peFhfa = peFhas;

       chain peArcd set621;
       if not %found;
          return;
       endif;
       SPOPFECH( peFdes
               : '+'
               : 'M'
               : t@dupe
               : peFhfa
               : p@Erro );

       return;

      /end-free

     P calculaHasta    E

      * ------------------------------------------------------------ *
      * PRWSND_sndMail(): Envia Mail.                                *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peSoln  (input)  Número de Solicitud                    *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_sndMail  B                   Export
     D PRWSND_sndMail  pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       7  0 const

     D peCprc          s             20    inz('QUOM_AUTOMATICO')
     D peCspr          s             20    inz('PRWSND_SEND')
     D peRemi          ds                  likeds(Remitente_t)
     D peSubj          s             70a   varying
     D peMens          s            512a   varying
     D peRprp          ds                  likeds(recprp_t) dim(100)
     D peMadd          ds                  likeds(MailAddr_t) dim(100)
     D @copr           s             15  2
     D @prem           s             15  2
     D @nase           s             40a
     D x               s             10i 0
     D y               s             10i 0
     D rc              s             10i 0
     D peTo            s             50a   dim(100)
     D peToad          s            256a   dim(100)
     D peToty          s             10i 0 dim(100)

     D k1w001c         ds                  likerec(c1w001c:*key)
     D k1w001          ds                  likerec(c1w001:*key)
     D k1w003          ds                  likerec(c1w003:*key)

      /free

       PRWSND_inz();

       @copr = 0;
       k1w001c.w1empr = peBase.peEmpr;
       k1w001c.w1sucu = peBase.peSucu;
       k1w001c.w1nivt = peBase.peNivt;
       k1w001c.w1nivc = peBase.peNivc;
       k1w001c.w1nctw = peNctw;
       setll %kds(k1w001c:5) ctw001c;
       reade %kds(k1w001c:5) ctw001c;
       dow not %eof;
           @copr += w1copr;
        reade %kds(k1w001c:5) ctw001c;
       enddo;

       @prem = 0;
       k1w001.w1empr = peBase.peEmpr;
       k1w001.w1sucu = peBase.peSucu;
       k1w001.w1nivt = peBase.peNivt;
       k1w001.w1nivc = peBase.peNivc;
       k1w001.w1nctw = peNctw;
       setll %kds(k1w001:5) ctw001;
       reade %kds(k1w001:5) ctw001;
       dow not %eof;
           @prem += w1prem;
        reade %kds(k1w001:5) ctw001;
       enddo;

       @nase = *blanks;
       k1w003.w3empr = peBase.peEmpr;
       k1w003.w3sucu = peBase.peSucu;
       k1w003.w3nivt = peBase.peNivt;
       k1w003.w3nivc = peBase.peNivc;
       k1w003.w3nctw = peNctw;
       setll %kds(k1w003:5) ctw003;
       reade %kds(k1w003:5) ctw003;
       dow not %eof;
           if w3nase = 0;
              @nase = w3nomb;
              leave;
           endif;
        reade %kds(k1w003:5) ctw003;
       enddo;

       rc = MAIL_getFrom( peCprc : peCspr : peRemi );
       if rc = -1;
          return;
       endif;

       rc = MAIL_getSubject( peCprc : peCspr : peSubj );
       if rc = -1;
          return;
       endif;
       peSubj = %scanrpl( '%NCTW%' : %trim(%char(peNctw)) : peSubj);
       peSubj = %scanrpl( '%SOLN%' : %trim(%char(peSoln)) : peSubj);

       rc = MAIL_getBody( peCprc : peCspr : peMens );
       if rc = -1;
          return;
       endif;
       peMens = %scanrpl( '%NCTW%' : %trim(%char(peNctw)) : peMens);
       peMens = %scanrpl( '%SOLN%' : %trim(%char(peSoln)) : peMens);
       peMens = %scanrpl( '%PREM%'
                        : %trim(%editw(@prem : '   .    .   . 0 ,  '))
                        : peMens );
       peMens = %scanrpl( '%COPR%'
                        : %trim(%editw(@copr : '   .    .   . 0 ,  '))
                        : peMens );
       peMens = %scanrpl( '%NASE%' : %trim(@nase) : peMens );

       y = 0;
       rc = SVPMAIL_xNivc( peBase.peEmpr
                         : peBase.peSucu
                         : peBase.peNivt
                         : peBase.peNivc
                         : peMadd
                         : 20             );
       for x = 1 to rc;
           y += 1;
           peTo(y)   = peMadd(x).nomb;
           peToad(y) = peMadd(x).mail;
           peToty(y) = MAIL_NORMAL;
       endfor;

       rc = MAIL_getReceipt( peCprc : peCspr : peRprp : *ON );
       if y = 0;
          for x = 1 to rc;
              peRprp(x).rpma01 = '1';
          endfor;
       endif;
       for x = 1 to rc;
           y += 1;
           peTo(y)   = peRprp(x).rpnomb;
           peToad(y) = peRprp(x).rpmail;
           select;
            when peRprp(x).rpma01 = '1';
                 peToty(y) = MAIL_NORMAL;
            when peRprp(x).rpma01 = '2';
                 peToty(y) = MAIL_CC;
            when peRprp(x).rpma01 = '3';
                 peToty(y) = MAIL_CCO;
            other;
                 peToty(y) = MAIL_NORMAL;
           endsl;
       endfor;

       rc = MAIL_sndEmail( peRemi.From
                         : peRemi.Fadr
                         : peSubj
                         : peMens
                         : 'H'
                         : peTo
                         : peToad
                         : peToty       );

      /end-free

     P PRWSND_sndMail  E

      * ------------------------------------------------------------ *
      * PRWSND_sndPropuesta2(): Envía (o recibe) propuesta web, sin  *
      *                         ejecutar _sndDtaQ() y _sndMail() ya  *
      *                         que es una propuesta hija            *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peFdes  (input)  Fecha de Inicio de Vigencia            *
      *      peFhas  (input)  Fecha de Fin    de Vigencia (AP)       *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P PRWSND_sndPropuesta2...
     P                 B                   Export
     D PRWSND_sndPropuesta2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D wrepl           s          65535a
     D rc              s              1N
     D*QUsec           ds                  likeds(QUsec_t)

     D SP0082          pr                  EXTPGM('SP0082')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peNmat                       25    const
     D  peFech                        8  0 const
     D  peErro                        1
     D  peErr2                        1
     D  peEmpr                        1    options(*nopass:*omit) const
     D  peSucu                        2    options(*nopass:*omit) const
     D  pePoco                        4  0 options(*nopass:*omit) const
     D  peArcd2                       6  0 options(*nopass:*omit)
     D  peSpol2                       7  0 options(*nopass:*omit)
     D  peRama                        2  0 options(*nopass:*omit)
     D  pePoli                        7  0 options(*nopass:*omit)
     D  pePoco2                       4  0 options(*nopass:*omit)
     D  peHast                        8  0 options(*nopass:*omit)

     D Data            ds                  qualified
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1a
     D  nivc                          5a
     D  nit1                          1a
     D  niv1                          5a
     D  nctw                          7a
     D  keyw                         10a

     D k1w000          ds                  likerec(c1w000:*key)
     D k1wer0          ds                  likerec(c1wer0:*key)
     D k1wer2          ds                  likerec(c1wer2:*key)
     D k1wer7          ds                  likerec(c1wer7:*key)
     D k1t107          ds                  likerec(s1t107:*key)
     D k1t103          ds                  likerec(s1t103:*key)
     D K1y001          ds                  likerec(c1w001:*key)
     D k1t621          ds                  likerec(s1t621:*key)
     D k1y915          ds                  likerec(s1t915:*key)
     D k1w003          ds                  likerec(c1w003:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)
     D k1wev1          ds                  likerec(c1wev1:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1wer6          ds                  likerec(c1wer6:*key)
     D k1y160          ds                  likerec(s1t160:*key)
     D k1tpam          ds                  likerec(s1tpam:*key)
     D k1w004          ds                  likerec(c1w004:*key)

     D peDomi          ds                  likeds(prwaseDomi_t)
     D peDocu          ds                  likeds(prwaseDocu_t)
     D peNtel          ds                  likeds(prwaseTele_t)
     D peMail          ds                  likeds(prwaseEmail_t)
     D peInsc          ds                  likeds(prwaseInsc_t)
     D peNaci          ds                  likeds(prwaseNaco_t)

     D suma_obj        s             15  2
     D suma_ase        s             15  2
     D p@arcd          s              6  0
     D nohaydatos      s               n
     D fdes            s             10d
     D difpermitida    s              5i 0 inz(3)
     D dif             s              5i 0
     D aseg_valido     s              1N
     D i               s             10i 0
     D z               s              4  0
     D peModi          s              1a
     D peFhfa          s              8  0

     D desde           s             10d
     D hasta           s             10d
     D peDsum          s              2  0
     D peDres          s              2  0
     D peFrec          s             50a
     D saco_rem        s             15  2
     D tmpfec          s               d   datfmt(*iso)
     D @@fecd          s              8  0
     D @@fech          s              8  0
     D @@fdes          s              8  0
     D @@tiou          s              1  0 inz(*zeros)
     D @@stou          s              2  0 inz(*zeros)
     D @@stos          s              2  0 inz(*zeros)
     D fechPat         s              8  0
     D errPate         s              1a
     D errPat2         s              1a
     D @@poco          s              4  0
     D @@Arcd          s              6  0
     D @@Spol          s              9  0
     D @@masc          s              1n

      /free

       PRWSND_inz();

       @@fdes = peFdes;

       rc = SVPWS_chkParmBase( peBase : peMsgs );
       if rc = *off;
          peErro = -1;
          PRWSND_end();
          return;
       endif;

       // ------------------------------------------
       // Si ya la enviaron, es error
       // ------------------------------------------
       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain(n) %kds(k1w000:5) ctw000;
       if %found;
          if w0soln <> 0 or w0spol <> 0;
             %subst(wrepl:1:7) = %trim(%char(peNctw));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0119'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
          peErro = -1;
          PRWSND_end();
          return;
          endif;
          // ---------------------------------------------
          // Es una cotización vencida
          // ---------------------------------------------
          if w0cest = 1 and w0cses = 9;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SND0002'
                          : peMsgs     );
             peErro = -1;
             PRWSND_end();
             return;
          endif;
       endif;

       @@tiou = w0tiou;
       @@stou = w0stou;
       @@stos = w0stos;

       rc = COWGRAI_chkCotizacion( peBase : peNctw );
       if rc = *off;
          %subst(wrepl:1:7) = %editc(peNctw:'X');
          %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
          %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          peErro = -1;
          PRWSND_end();
          return;
       endif;

       monitor;
          fdes = %date(@@fdes:*iso);
        on-error;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0117'
                       : peMsgs        );
          peErro = -1;
          PRWSND_end();
          return;
       endmon;

       if not SVPVLS_getValsys('HCHGFVIGRN':*omit:@@ValSys );
         @@Valsys = 'N';
       endif;

       if w0tiou = 2 and %trim(@@Valsys) = 'S';
         if SPVSPO_getFecVig( w0empr
                            : w0sucu
                            : w0arcd
                            : w0spo1
                            : @@fecd
                            : @@fech  );
          @@fdes  = @@fech;
          tmpfec  = %date(( @@fech ): *iso );
          tmpfec += %years(1);
          peFhas  = %int( %char( tmpfec : *iso0) );
        endif;
       endif;

       // ------------------------------------
       // Diferencia entre hoy y vigencia
       // ------------------------------------
       if w0tiou <> 2;
          WSLVIG( w0arcd: peDsum: peDres: peFrec: peErro: peMsgs );
          desde = %date() - %days(%abs(peDres));
          hasta = %date() + %days(peDsum);
          if %date(@@fdes:*iso) < desde or
             %date(@@fdes:*iso) > hasta;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0120'
                          : peMsgs     );
             peErro = -1;
             PRWSND_end();
             return;
          endif;
       endif;

       // ------------------------------------
       // Si es una renovacion, ver si no esta
       // renovada
       // ------------------------------------
       if (w0tiou = 2);
          if SPVSPO_chkSpolRenovada( peBase.peEmpr
                                   : peBase.peSucu
                                   : w0arcd
                                   : w0spo1         ) <> 0;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SND0006'
                          : peMsgs );
             peErro = -1;
             return;
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
             fechPat = SPVFEC_giroFecha8( @@fdes : 'DMA' );
             k1wet0.t0empr = peBase.peEmpr;
             k1wet0.t0sucu = peBase.peSucu;
             k1wet0.t0nivt = peBase.peNivt;
             k1wet0.t0nivc = peBase.peNivc;
             k1wet0.t0nctw = peNctw;
             setll %kds(k1wet0:5) ctwet0;
             reade(n) %kds(k1wet0:5) ctwet0;
             dow not %eof;
               k1tpam.pmempr = t0empr;
               k1tpam.pmsucu = t0sucu;
               k1tpam.pmmcod = t0tmat;
               chain %kds(k1tpam:3) setpam01;
               if %found;

                 // --------------------------------------------------------
                 // Antes de ejecutar SP0082, se debe tomar en cuenta si es
                 // un endoso de aumento de suma, para mandar los parametros
                 // de ARCD, POCO y SPOL, diferente de Cero
                 // --------------------------------------------------------
                 if w0Tiou = 3 and w0Stou = 1 and w0Stos = 5;
                   @@Arcd = w0Arcd;
                   @@Spol = w0Spo1;
                   @@poco = t0Poco;
                 else;
                   @@Arcd = *zeros;
                   @@Spol = *zeros;
                   @@poco = *zeros;
                 endif;

                 if pmvald = 'N';
                    SP0082( @@Arcd
                          : @@Spol
                          : t0nmat
                          : fechPat
                          : errPate
                          : errPat2
                          : t0empr
                          : t0sucu
                          : @@poco );
                    if ( errPate = 'E' );
                       SVPWS_getMsgs( '*LIBL'
                                    : 'WSVMSG'
                                    : 'COW0042'
                                    : peMsgs );
                       peErro = -1;
                       return;
                    endif;
                 endif;
               endif;
               reade(n) %kds(k1wet0:5) ctwet0;
             enddo;
          endif;
       endif;

       // ------------------------------------
       // Valido sumatoria de objetos x Cob
       // ------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
           k1wer2.r2empr = peBase.peEmpr;
           k1wer2.r2sucu = peBase.peSucu;
           k1wer2.r2nivt = peBase.peNivt;
           k1wer2.r2nivc = peBase.peNivc;
           k1wer2.r2nctw = peNctw;
           k1wer2.r2rama = r0rama;
           k1wer2.r2arse = r0arse;
           k1wer2.r2poco = r0poco;
           setll %kds(k1wer2:8) ctwer2;
           reade(n) %kds(k1wer2:8) ctwer2;
           dow not %eof;
               suma_obj = 0;
               k1wer7.r7empr = peBase.peEmpr;
               k1wer7.r7sucu = peBase.peSucu;
               k1wer7.r7nivt = peBase.peNivt;
               k1wer7.r7nivc = peBase.peNivc;
               k1wer7.r7nctw = peNctw;
               k1wer7.r7rama = r0rama;
               k1wer7.r7arse = r0arse;
               k1wer7.r7poco = r0poco;
               k1wer7.r7riec = r2riec;
               k1wer7.r7xcob = r2xcob;
               setll %kds(k1wer7:10) ctwer7;
               if %equal();
                 nohaydatos = *off;
                 reade %kds(k1wer7:10) ctwer7;
                 dow not %eof;
                     suma_obj += r7suas;
                  reade %kds(k1wer7:10) ctwer7;
                 enddo;
               else;
                 nohaydatos = *on;
               endif;
               if suma_obj <> r2saco and nohaydatos = *off;
                  k1t107.t@rama = r2rama;
                  k1t107.t@cobc = r2xcob;
                  chain %kds(k1t107:2) set107;
                  if not %found;
                     t@cobd = *all'*';
                  endif;
                  %subst(wrepl:1:20) = %trim(t@cobd);
                  %subst(wrepl:21:6) = %trim(%char(r2poco));
                  %subst(wrepl:27:7) = %trim(%char(peNctw));
                  SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : 'PRW0036'
                               : peMsgs
                               : %trim(wrepl)
                               : %len(%trim(wrepl))  );
                  peErro = -1;
                  PRWSND_end();
                  return;
               endif;
            reade(n) %kds(k1wer2:8) ctwer2;
           enddo;
        reade %kds(k1wer0:5) ctwer0;
       enddo;

       // ------------------------------------------
       // Valido sumatoria de los Asegurasdos x Cob
       // ------------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
           k1wer2.r2empr = peBase.peEmpr;
           k1wer2.r2sucu = peBase.peSucu;
           k1wer2.r2nivt = peBase.peNivt;
           k1wer2.r2nivc = peBase.peNivc;
           k1wer2.r2nctw = peNctw;
           k1wer2.r2rama = r0rama;
           k1wer2.r2arse = r0arse;
           k1wer2.r2poco = r0poco;
           setll %kds(k1wer2:8) ctwer2;
           reade(n) %kds(k1wer2:8) ctwer2;
           dow not %eof;
               suma_ase = 0;
               k1wer7.r7empr = peBase.peEmpr;
               k1wer7.r7sucu = peBase.peSucu;
               k1wer7.r7nivt = peBase.peNivt;
               k1wer7.r7nivc = peBase.peNivc;
               k1wer7.r7nctw = peNctw;
               k1wer7.r7rama = r0rama;
               k1wer7.r7arse = r0arse;
               k1wer7.r7poco = r0poco;
               k1wer7.r7riec = r2riec;
               k1wer7.r7xcob = r2xcob;
               setll %kds(k1wer7:10) ctwer1;
               if %equal();
                 nohaydatos = *off;
                 reade %kds(k1wer7:10) ctwer1;
                 dow not %eof;
                     suma_ase += r1suas;
                  reade %kds(k1wer7:10) ctwer1;
                 enddo;
               else;
                 nohaydatos = *on;
               endif;
               if suma_ase <> r2saco and nohaydatos = *off;
                  k1t107.t@rama = r2rama;
                  k1t107.t@cobc = r2xcob;
                  chain %kds(k1t107:2) set107;
                  if not %found;
                     t@cobd = *all'*';
                  endif;
                  %subst(wrepl:1:20) = %trim(t@cobd);
                  %subst(wrepl:21:6) = %trim(%char(r2poco));
                  %subst(wrepl:27:7) = %trim(%char(peNctw));
                  SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : 'PRW0037'
                               : peMsgs
                               : %trim(wrepl)
                               : %len(%trim(wrepl))  );
                  peErro = -1;
                  PRWSND_end();
                  return;
               endif;
            reade(n) %kds(k1wer2:8) ctwer2;
           enddo;
        reade %kds(k1wer0:5) ctwer0;
       enddo;

       // --------------------------------------------
       // Si alguna cobertura permite mascota, debe
       // haberse cargado una
       // --------------------------------------------
       @@masc = *off;
       k1wer2.r2empr = peBase.peEmpr;
       k1wer2.r2sucu = peBase.peSucu;
       k1wer2.r2nivt = peBase.peNivt;
       k1wer2.r2nivc = peBase.peNivc;
       k1wer2.r2nctw = peNctw;
       setll %kds(k1wer2:5) ctwer2;
       reade %kds(k1wer2:5) ctwer2;
       dow not %eof;
           k1t107.t@rama = r2rama;
           k1t107.t@cobc = r2xcob;
           chain %kds(k1t107:2) set107;
           if %found;
              if t@mar3 = 'M';
                 @@masc = *on;
                 leave;
              endif;
           endif;
        reade %kds(k1wer2:5) ctwer2;
       enddo;
       if @@masc;
          setll %kds(k1wer2:5) ctwera;
          if not %equal;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0062'
                          : peMsgs     );
             peErro = -1;
             PRWSND_end();
             return;
          endif;
       endif;

       // Si operacion 3/7/4 => No hacer la validacion
       if not ( @@tiou = 3 and @@stou = 7 and @@stos = 4 );

         // ------------------------------------------
         // Valido que se coticen todas las ramas
         // ------------------------------------------

         p@Arcd = COWGRAI_getArticulo ( peBase :
                                        peNctw );

         k1t621.t@arcd = p@arcd;

         setll %kds(k1t621:1) set621;
         reade %kds(k1t621:1) set621;
         dow not %eof();

           k1y001.w1empr = peBase.peEmpr;
           k1y001.w1sucu = peBase.pesucu;
           k1y001.w1nivt = peBase.peNivt;
           k1y001.w1nivc = peBase.peNivc;
           k1y001.w1nctw = peNctw;
           k1y001.w1rama = t@rama;

           setll %kds( k1y001 ) ctw001;
           if not %equal();

             %subst(wrepl:24:2) = %trim(%char(t@rama));
             %subst(wrepl:28:6) = %trim(%char(p@arcd));
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0038'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             PRWSND_end();
             return;

           endif;

           reade %kds(k1t621:1) set621;
         enddo;
       endif;

       // ------------------------------------------ //
       // Valida bien asegurado exista en Cotizacion //
       // ------------------------------------------ //

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.pesucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         setll %kds( k1y001 : 5 ) ctw001;
         reade %kds( k1y001 : 5 ) ctw001;
           dow not %eof( ctw001 );
             Select;
               when SVPWS_getGrupoRamaArch( w1rama ) = 'A';

                    k1wet0.t0empr = peBase.peEmpr;
                    k1wet0.t0sucu = peBase.peSucu;
                    k1wet0.t0nivt = peBase.peNivt;
                    k1wet0.t0nivc = peBase.peNivc;
                    k1wet0.t0nctw = peNctw;
                    setll %kds(k1wet0:5) ctwet0;
                    reade(n) %kds(k1wet0:5) ctwet0;
                    dow not %eof;
                        if t0poco <= 0;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0moto = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0chas = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0vhuv <= 0;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0mgnc <> 'S' and t0mgnc <> 'N' and
                           t0mgnc <> '1' and t0mgnc <> '0';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0mgnc = 'S' and t0rgnc <= 0;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0tmat = *blanks or t0nmat = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0nmer = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0aver <> '0' and t0aver <> '1' and
                           t0aver <> 'S' and t0aver <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0cesv <> '0' and t0cesv <> '1' and
                           t0cesv <> 'S' and t0cesv <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0iris <> '0' and t0iris <> '1' and
                           t0iris <> 'S' and t0iris <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if t0clin <> '0' and t0clin <> '1' and
                           t0clin <> 'S' and t0clin <> 'N';
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        k1wetc.t0empr = t0empr;
                        k1wetc.t0sucu = t0sucu;
                        k1wetc.t0nivt = t0nivt;
                        k1wetc.t0nivc = t0nivc;
                        k1wetc.t0nctw = t0nctw;
                        k1wetc.t0rama = t0rama;
                        k1wetc.t0arse = t0arse;
                        k1wetc.t0poco = t0poco;
                        setll %kds(k1wetc:8) ctwetc01;
                        if not %equal;
                           %subst(wrepl:1:4) = %trim(%char(t0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0003'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                     reade(n) %kds(k1wet0:5) ctwet0;
                    enddo;

               when SVPWS_getGrupoRamaArch( w1rama ) = 'R';

                    k1wer0.r0empr = peBase.peEmpr;
                    k1wer0.r0sucu = peBase.peSucu;
                    k1wer0.r0nivt = peBase.peNivt;
                    k1wer0.r0nivc = peBase.peNivc;
                    k1wer0.r0nctw = peNctw;
                    setll %kds(k1wer0:5) ctwer0;
                    reade %kds(k1wer0:5) ctwer0;
                    dow not %eof;
                        if r0poco <= 0;
                           %subst(wrepl:1:4) = %trim(%char(r0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0004'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if r0rdes = *blanks;
                           %subst(wrepl:1:4) = %trim(%char(r0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0004'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if r0cviv <= 0 and SVPWS_getGrupoRama(w1rama) = 'H';
                           %subst(wrepl:1:4) = %trim(%char(r0poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0004'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                     reade %kds(k1wer0:5) ctwer0;
                    enddo;

               when SVPWS_getGrupoRamaArch( w1rama ) = 'V';

                    k1wev1.v1empr = peBase.peEmpr;
                    k1wev1.v1sucu = peBase.peSucu;
                    k1wev1.v1nivt = peBase.peNivt;
                    k1wev1.v1nivc = peBase.peNivc;
                    k1wev1.v1nctw = peNctw;
                    setll %kds(k1wev1:5) ctwev1;
                    reade %kds(k1wev1:5) ctwev1;
                    dow not %eof;
                        if v1poco <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1paco <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1acti <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1secu <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1xpro <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1nomb = *blanks;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1tido <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1nrdo <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1fnac <= 0;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                        if v1naci = *blanks;
                           %subst(wrepl:1:6) = %trim(%char(v1poco));
                           SVPWS_getMsgs( '*LIBL'
                                        : 'WSVMSG'
                                        : 'SND0005'
                                        : peMsgs
                                        : %trim(wrepl)
                                        : %len(%trim(wrepl))  );
                           peErro = -1;
                           PRWSND_end();
                           return;
                        endif;
                     reade %kds(k1wev1:5) ctwev1;
                    enddo;

             endsl;


          reade %kds( k1y001 : 5 ) ctw001;
           enddo;

       // -----------------------------------------
       // Debe haber un asegurado principal
       // -----------------------------------------
       k1w003.w3empr = peBase.peEmpr;
       k1w003.w3sucu = peBase.peSucu;
       k1w003.w3nivt = peBase.peNivt;
       k1w003.w3nivc = peBase.peNivc;
       k1w003.w3nctw = peNctw;
       k1w003.w3nase = 0;
       setll %kds(k1w003:6) ctw003;
       if not %equal;
           %subst(wrepl:1:7) = %trim(%char(peNctw));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'SND0001'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           PRWSND_end();
           return;
       endif;

       // -----------------------------------------
       // Los asegurados deben ser todos válidos
       // Barro todos (principal y adicionales si
       // hay)
       // -----------------------------------------
       setll %kds(k1w003:5) ctw003;
       reade %kds(k1w003:5) ctw003;
       dow not %eof;
           if w3nase < 0;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0040'
                           : peMsgs     );
              peErro = -1;
              PRWSND_end();
              return;
           endif;
           peDomi.domi = w3domi;
           peDomi.copo = w3copo;
           peDomi.cops = w3cops;
           peDocu.tido = w3tido;
           peDocu.nrdo = w3nrdo;
           for i = 1 to 11;
               if %subst(w3cuit:i:1) <> '0' and
                  %subst(w3cuit:i:1) <> '1' and
                  %subst(w3cuit:i:1) <> '2' and
                  %subst(w3cuit:i:1) <> '3' and
                  %subst(w3cuit:i:1) <> '4' and
                  %subst(w3cuit:i:1) <> '5' and
                  %subst(w3cuit:i:1) <> '6' and
                  %subst(w3cuit:i:1) <> '7' and
                  %subst(w3cuit:i:1) <> '8' and
                  %subst(w3cuit:i:1) <> '9';
                  %subst(w3cuit:i:1) = '0';
               endif;
           endfor;
           peDocu.cuit = %dec(w3cuit:11:0);
           peDocu.cuil = w3njub;
           peNtel.nte1 = w3telp;
           peNtel.nte2 = w3telc;
           peNtel.nte3 = w3telt;
           peNtel.nte4 = *blanks;
           peNtel.pweb = *blanks;
           peMail.ctce = *zeros;
           peMail.mail = *blanks;
           peInsc.fein = w3fein;
           peInsc.nrin = w3nrin;
           peInsc.feco = w3feco;
           peNaci.fnac = w3fnac;
           peNaci.lnac = *blanks;
           peNaci.pain = 6;
           peNaci.cnac = w3cnac;
           k1w004.w4empr = w3empr;
           k1w004.w4sucu = w3sucu;
           k1w004.w4nivt = w3nivt;
           k1w004.w4nivc = w3nivc;
           k1w004.w4nctw = w3nctw;
           k1w004.w4nase = w3nase;
           chain %kds(k1w004:6) ctw004;
           if %found;
              peMail.ctce = w4ctce;
              peMail.mail = w4mail;
           endif;
           PRWASE_isValid( peBase
                         : peNctw
                         : w3asen
                         : peDomi
                         : peDocu
                         : peNtel
                         : w3tiso
                         : peNaci
                         : w3cprf
                         : w3csex
                         : w3cesc
                         : w3raae
                         : peMail
                         : w3cbus
                         : w3ruta
                         : w3civa
                         : peInsc
                         : peErro
                         : peMsgs   );
          if peErro = -1;
             PRWSND_end();
             return;
          endif;
        reade %kds(k1w003:5) ctw003;
       enddo;

       // -----------------------------------------//

       k1w003.w3empr = peBase.peEmpr;
       k1w003.w3sucu = peBase.peSucu;
       k1w003.w3nivt = peBase.peNivt;
       k1w003.w3nivc = peBase.peNivc;
       k1w003.w3nctw = peNctw;
       k1w003.w3nase = 0;
       chain %kds(k1w003:6) ctw003;
       if not %found;
          w3nomb = 'N/A';
       endif;

       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;


       chain %kds(k1w000:5) ctw000;
       if %found;

          k1y915.t@empr = peBase.peEmpr;
          k1y915.t@sucu = peBase.peSucu;
          k1y915.t@tnum = 'SO';

          chain %kds( k1y915 : 3 ) set915;

          if %found;
             t@nres += 1;
             t@user  = @PsDs.CurUsr;
             t@date  = udate;
             t@time  = %dec(%time);
             update s1t915;
          else;
             t@empr = peBase.peEmpr;
             t@sucu = peBase.peSucu;
             t@tnum = 'SO';
             t@dnum = 'NUMERO DE SOLICITUD';
             t@nres = 1;
             t@user = @PsDs.CurUsr;
             t@date = udate;
             t@time = %dec(%time);
             write s1t915;
          endif;

          w0soln = t@nres;
          w0cest = 5;   // Propuesta
          w0cses = 3;   // Recibida por la cia
          chain (w0cest:w0cses) set916;
          if %found;
             w0dest = tedest;
          endif;
          w0vdes = @@fdes;
          w0nomb = w3nomb;
          // -------------------------------------
          // Hasta se calcula siempre, salvo AP
          // -------------------------------------
          if not SVPWEB_getCalculoFechaHasta( peBase.peEmpr :
                                              peBase.peSucu :
                                              w0arcd );
             w0vhas = peFhas;
           else;
             calculaHasta( w0arcd
                         : @@fdes
                         : w0vhas
                         : peFhfa );
          endif;
          // ----------------------------------------
          // En endosos, la fecha hasta es la póliza
          // ----------------------------------------
          if w0tiou = 3;
             rc = SPVSPO_getFecVig( w0empr
                                  : w0sucu
                                  : w0arcd
                                  : w0spo1
                                  : *omit
                                  : w0vhas );
          endif;
          w0fpro = %dec(%date():*iso);
          update c1w000;

       endif;

       // -------------------------------------
       // Suma Asegurada RC
       // -------------------------------------
       k1wetc.t0empr = peBase.peEmpr;
       k1wetc.t0sucu = peBase.peSucu;
       k1wetc.t0nivt = peBase.peNivt;
       k1wetc.t0nivc = peBase.peNivc;
       k1wetc.t0nctw = peNctw;
       setll %kds(k1wetc:5) ctwetc01;
       reade %kds(k1wetc:5) ctwetc01;
       dow not %eof;
           if t0cobl = 'A';
               k1wet0.t0empr = peBase.peEmpr;
               k1wet0.t0sucu = peBase.peSucu;
               k1wet0.t0nivt = peBase.peNivt;
               k1wet0.t0nivc = peBase.peNivc;
               k1wet0.t0nctw = peNctw;
               k1wet0.t0rama = t0rama;
               k1wet0.t0arse = t0arse;
               k1wet0.t0poco = t0poco;
               chain %kds(k1wet0) ctwet0;
               if %found;
                  t0claj = 0;
                  t0vhvu = 0;
                  t0sast = 0;
                  update c1wet0;
               endif;
           endif;
        reade %kds(k1wetc:5) ctwetc01;
       enddo;

       // -------------------------------------
       // Agrego la remoción de escombros, si
       // no está
       // -------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
           k1t103.t@rama = r0rama;
           k1t103.t@xpro = r0xpro;
           k1t103.t@riec = '010';
           k1t103.t@cobc = 140;
           k1t103.t@mone = COWGRAI_monedaCotizacion(peBase:peNctw);
           setll %kds(k1t103) set103;
           if %equal;
              k1wer2.r2empr = r0empr;
              k1wer2.r2sucu = r0sucu;
              k1wer2.r2nivt = r0nivt;
              k1wer2.r2nivc = r0nivc;
              k1wer2.r2nctw = r0nctw;
              k1wer2.r2rama = r0rama;
              k1wer2.r2arse = r0arse;
              k1wer2.r2poco = r0poco;
              k1wer2.r2riec = '010';
              k1wer2.r2xcob = 13;
              chain(n) %kds(k1wer2) ctwer2;
              if %found;
                 saco_rem = r2saco * 0.05;
                 k1wer2.r2xcob = 140;
                 setll %kds(k1wer2) ctwer2;
                 if not %equal;
                    r2empr = r0empr;
                    r2sucu = r0sucu;
                    r2nivt = r0nivt;
                    r2nivc = r0nivc;
                    r2nctw = r0nctw;
                    r2rama = r0rama;
                    r2arse = r0arse;
                    r2poco = r0poco;
                    r2riec = '010';
                    r2xcob = 140;
                    r2saco = saco_rem;
                    r2ptco = 0;
                    r2xpri = 0;
                    r2prsa = 0;
                    r2ptca = 0;
                    r2ma01 = ' ';
                    r2ma02 = ' ';
                    r2ma03 = ' ';
                    r2ma04 = ' ';
                    r2ma05 = ' ';
                    write c1wer2;
                 endif;
              endif;
           endif;
        reade %kds(k1wer0:5) ctwer0;
       enddo;

       // -------------------------------------
       // Agrego Buen resultado y bajo riesgo
       // si no están
       // -------------------------------------
       k1wer0.r0empr = peBase.peEmpr;
       k1wer0.r0sucu = peBase.peSucu;
       k1wer0.r0nivt = peBase.peNivt;
       k1wer0.r0nivc = peBase.peNivc;
       k1wer0.r0nctw = peNctw;
       setll %kds(k1wer0:5) ctwer0;
       reade %kds(k1wer0:5) ctwer0;
       dow not %eof;
         for z = 996 to 999;
           k1y160.t@Empr = r0Empr;
           k1y160.t@Sucu = r0Sucu;
           k1y160.t@Rama = r0Rama;
           k1y160.t@Ccba = z;
           setll %kds( k1y160 : 4 ) set160;
           if %equal( set160 );
               k1wer6.r6empr = r0empr;
               k1wer6.r6sucu = r0sucu;
               k1wer6.r6nivt = r0nivt;
               k1wer6.r6nivc = r0nivc;
               k1wer6.r6nctw = r0nctw;
               k1wer6.r6rama = r0rama;
               k1wer6.r6arse = r0arse;
               k1wer6.r6poco = r0poco;
               k1wer6.r6ccba = z;
               setll %kds(k1wer6) ctwer6;
               if not %equal;
                  r6empr = r0empr;
                  r6sucu = r0sucu;
                  r6nivt = r0nivt;
                  r6nivc = r0nivc;
                  r6nctw = r0nctw;
                  r6rama = r0rama;
                  r6arse = r0arse;
                  r6poco = r0poco;
                  r6ccba = z;
                  r6ma01 = 'N';
                  r6ma02 = 'N';
                  write c1wer6;
               endif;
           endif;
         endfor;
         reade %kds(k1wer0:5) ctwer0;
       enddo;

       PRWSND_end();
       return;

      /end-free

     P PRWSND_sndPropuesta2...
     P                 E

