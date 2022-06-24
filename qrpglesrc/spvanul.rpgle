     H nomain
      * ************************************************************ *
      * SPVANUL:Programa de Servicio.                                *
      *         Validación ANULACIONES DE PÓLIZA                     *
      * ------------------------------------------------------------ *
      * Mónica Alonso                        28-ENE-2014             *
      * ************************************************************ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                         <*  *
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                      <*  *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                         <*  *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -           <*  *
      *>           DBGVIEW(&DV)                               <*  *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                           <*  *
      *>           MODULE(QTEMP/&N) -                         <*  *
      *>           EXPORT(*SRCFILE) -                         <*  *
      *>           SRCFILE(HDIILE/QSRVSRC) -                  <*  *
      *> TEXT('Programa de Servicio: Anulacion x Interfase')  <*  *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                         <*  *
      * ************************************************************ *
     fpawpc0    if   e           k disk    usropn
     fgti98003  if   e           k disk    usropn
     fpawkl1    if   e           k disk    usropn
     fpawemi01  if   e           k disk    usropn
     fpahec0    if   e           k disk    usropn
     fpahec108  if   e           k disk    usropn
     fpahscd11  if   e           k disk    usropn
     fpahcc2    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
     D/copy './qcpybooks/spvanul_h.rpgle'

     D @@empr          s                   like(w0empr)
     D @@sucu          s                   like(w0sucu)
     D @@arcd          s                   like(w0arcd)
     D @@spol          s                   like(w0spol)
     D @@fema          s              4  0
     D @@femm          s              2  0
     D @@femd          s              2  0
     D @@finpgm        s              3a
     D @@tiou          s                   like(w0tiou)
     D @RETORNO        s              1n

     D r1hec0          ds                  likerec(p1hec0)
      * --------------------------------------------------- *
      * Setea procedimientos globales
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D PAR310X3        pr                  extpgm('PAR310X3')
     D    Empr                        1    const
     D    @anio                       4  0
     D    @mes                        2  0
     D    @dia                        2  0

     D getEc0          pr             1N
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   d1hec0                            likeds(r1hec0)

     D  ErrCode        s             10i 0
     D  ErrText        s             80a

      *--- Initialized --------------------------------------------- *
     D Initialized     s              1N   inz(*OFF)

     * Llamada al DXP021.
     Ddxp021           pr                  extpgm('DXP021')
     D empr                           1
     D sucu                           2
     D arcd                           6  0
     D spol                           9  0
     D fema                           4  0
     D femm                           2  0
     D femd                           2  0
     D anul                           1
     D fpgm                           3

      *--- Definición de Procedimientos----------------------------- *

      * ------------------------------------------------------------ *
      * SPVANUL_EstadOK(): Chequea Situacion de Póliza               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *     peFema   (input)   Año                                   *
      *     peFemm   (input)   Mes                                   *
      *     peFemd   (input)   Día                                   *
      *     petiou   (input)   Tipo operación (opcional)             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_EstadOK...
     P                 B                   export
     D SPVANUL_EstadOK...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   petiou                       1  0 options(*nopass:*omit)
      *
      *
     D @@anul          s              1

      /free

       SPVAnul_Inz();

         @@finpgm = *blank;
         @@Anul = *blank;
         @retorno = *on;

        //se puede pasar que tipo de operación se chequea...
        //sino se asume anulacion

       if %parms >= 9 and %addr(peTiou) <> *null;
         @@tiou = peTiou;
       else;
         @@tiou = 4;
       endif;

         @@Empr =   peEmpr;
         @@Sucu =   peSucu;
         @@Arcd =   peArcd;
         @@Spol =   peSpol;
         @@Fema =   peFema;
         @@Femm =   peFemm;
         @@Femd =   peFemd;

         callp     dxp021(@@Empr:
                          @@Sucu:
                          @@Arcd:
                          @@Spol:
                          @@Fema:
                          @@Femm:
                          @@Femd:
                          @@Anul:
                          @@finpgm);

        select;
        when @@tiou = 4;
         if @@anul = 'A';
            SetError( SPVANUL_YAANU
                    : 'Intenta Anular Póliza ya Anulada');
           @retorno = *off;
         endif;
        when @@tiou = 5;
         if @@anul <> 'A';
            SetError( SPVANUL_Noreha
                    : 'No puede Rehabilit Póliza no anulada');
           @retorno = *off;
         endif;
       endsl;

       return @retorno;
      /end-free

     P SPVANUL_EstadOK...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_PolenPro(): Chequea si la póliza se esta procesando  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_PolenPro...
     P                 B                   export
     D SPVANUL_PolenPro...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
      *                                                              *
     D k1wpc0          ds                  likerec(p1wpc0:*key)
      *                                                              *

      /free

       SPVANUL_Inz();
       k1wpc0.w0empr = peEmpr;
       k1wpc0.w0sucu = peSucu;
       k1wpc0.w0arcd = peArcd;
       k1wpc0.w0spo1 = peSpol;

       chain %kds(k1wpc0) pawpc0;

       @retorno = *off;
       if %found;
         SetError( SPVANUL_ENPR
                 : 'Existe una Transacción Pendiente');
         @retorno = *on;
       else;
         @retorno = *off;
       endif;
       return @retorno;

      /end-free

     P SPVANUL_PolenPro...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_PolSpdwy(): Chequea si la póliza esta pendiente de   *
      *                     proceso por Speedway                     *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Código Rama                           *
      *     pePoli   (input)   Póliza                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_PolSpdwy...
     P                 B                   export
     D SPVANUL_PolSpdwy...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
      *                                                              *
     D k1I98003        ds                  likerec(G1I98003:*key)
      *                                                              *

      /free

       SPVANUL_Inz();
       k1I98003.g0empr = peEmpr;
       k1I98003.g0sucu = peSucu;
       k1I98003.g0rama = peRama;
       k1I98003.g0poli = pePoli;
       k1I98003.g0soln = *zero;

       chain %kds(k1i98003) gti98003;

       if %found;
         SetError( SPVANUL_spdwyp
                 : 'Existe una Transacción Pendiente en Speedway');
         @retorno = *on;
       else;
         @retorno = *off;
       endif;

       return @retorno;
      /end-free

     P SPVANUL_Polspdwy...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_PolBlq(): Chequea si la póliza está bloquead pawkl1  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_PolBlq...
     P                 B                   export
     D SPVANUL_PolBlq...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
      *                                                              *
     D k1wkl1          ds                  likerec(p1wkl1:*key)
      *                                                              *

      /free

       SPVANUL_Inz();
       k1wkl1.l1empr = peEmpr;
       k1wkl1.l1sucu = peSucu;
       k1wkl1.l1arcd = peArcd;
       k1wkl1.l1spol = peSpol;

       chain %kds(k1wkl1) pawkl1;

       if %found;
         SetError( SPVANUL_PBLQ
                 : 'Registro Bloqueado por Anulación');
         @retorno = *on;
       else;
         @retorno = *off;
       endif;

       return @retorno;
      /end-free

     P SPVANUL_PolBlq...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_PLEMI (): Chequea si la póliza está p1wemi01. Esta   *
      *                   bloque renovandose por otro artic.         *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_PLEMI...
     P                 B                   export
     D SPVANUL_PLEMI...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
      *                                                              *
     D k1wemi01        ds                  likerec(P1WEMI01:*key)
      *                                                              *

      /free

       SPVANUL_Inz();
       k1wemi01.x1empr = peEmpr;
       k1wemi01.x1sucu = peSucu;
       k1wemi01.x1arcd = peArcd;
       k1wemi01.x1spo1 = peSpol;

       chain %kds(k1wemi01 : 4) pawemi01;

       if %found;
         SetError( SPVANUL_PEMI
                 : 'Póliza Bloqueada Renovandose x otro Art');
         @retorno = *on;
       else;
         @retorno  = *off;
       endif;

       return @retorno;
      /end-free

     P SPVANUL_PLEMI...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_POCRI (): Chequea si póliza en estado crítico        *
      *                   depende de PAHEC108                        *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_POCRI...
     P                 B                   export
     D SPVANUL_POCRI...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
      *                                                              *
     D k1HEC108        ds                  likerec(P1HEC108:*key)
      *                                                              *

      /free

       SPVANUL_Inz();
       k1hec108.c1empr = peEmpr;
       k1hec108.c1sucu = peSucu;
       k1hec108.c1arcd = peArcd;
       k1hec108.c1spol = peSpol;

       chain %kds(k1Hec108 : 4) pahec108;

       if %found;
         SetError( SPVANUL_POCR
                 : 'Registro Bloqueado por Cobranza');
         @retorno = *on;
       else;
         @retorno = *off;
       endif;

       return @retorno;
      /end-free

     P SPVANUL_POCRI...
     P                 E


      * ------------------------------------------------------------ *
      * SPVANUL_POSIN (): Chequea si póliza con siniestros abiertos  *
      *                   depende de pahscd11                        *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *     peFeEmi  (input)   Fecha Emisión Informada               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_POSIN...
     P                 B                   export
     D SPVANUL_POSIN...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFeEmi                      8  0 const
      *                                                              *
     D k1HSCD11        ds                  likerec(p1hscd11:*key)
      *                                                              *

      /free

       SPVANUL_Inz();
       k1hscd11.cdempr = peEmpr;
       k1hscd11.cdsucu = peSucu;
       k1hscd11.cdarcd = peArcd;
       k1hscd11.cdspol = peSpol;

       chain %kds(k1hscd11 : 4) pahscd11;

       if %found;
         if peFeEmi < cdfsia * 10000 + cdfsim * 100 + cdfsid
         or peFeEmi < cdfdea * 10000 + cdfdem * 100 + cdfded;
            SetError( SPVANUL_SIPAN
                 : 'Existen Siniestros Fecha Posterior a Anulación');
            return *on;
         else;
            SetError( SPVANUL_PSIN
                 : 'Póliza con Siniestros Abiertos');
         @retorno = *on;
         endif;
       else;
         @retorno = *off;
       endif;

       return @retorno;
      /end-free


     P SPVANUL_POSIN...
     P                 E


      * ------------------------------------------------------------ *
      * SPVANUL_POANUL(): Chequea si Cabecera de pòliza con Indicati-*
      *                   vo de Anulación                            *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_POANUL...
     P                 B                   export
     D SPVANUL_POANUL...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const


      /free

       SPVANUL_Inz();
        //si no encuentra cabecera de póliza manda error
       if not getEc0( peEmpr
                    : peSucu
                    : peArcd
                    : peSpol
                    : r1hec0 );
          SetError( SPVANUL_SCAB
                  : 'Póliza sin Cabecera de Póliza');
          @retorno  = *on;
       else;
         if r1hec0.c0econ  = '0';
            @retorno = *OFF;
         else;
            SetError( SPVANUL_POANU
                 : 'La Cabecera Póliza indic. Anulada');
            @retorno = *on;
         endif;
       endif;

       return @retorno;
      /end-free

     P SPVANUL_POANUL...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_FVIG (): Chequea si Póliza está Vigente              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *     peFAnu   (input)   Fecha de Anulación (si no se pasa     *
      *                         se toma con PAR310X3                 *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_FVIG...
     P                 B                   export
     D SPVANUL_FVIG...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFAnu                       8  0 options(*nopass:*omit)
      *                                                              *
     D r1hec0          ds                  likerec(p1hec0)

      *                                                              *
     D @@fecha         s              8  0
     D @@desd          s              8  0
     D @@hast          s              8  0
     D @empr           s              1
     D @anio           s              4  0
     D @mes            s              2  0
     D @dia            s              2  0

     D                 ds
     D p@famd                  1      8S 0
     D @@anio                  1      4S 0
     D @@mes                   5      6S 0
     D @@dia                   7      8S 0
      /free

       SPVANUL_Inz();

       //si no pasa fecha de anulación toma fecha de par310x3
       if %parms >= 5 and %addr(peFanu) <> *null;
       //Valida que el porcentaje bonificación este dentro de lo permitido
         @@fecha = peFAnu;
       else;
         eval @empr = peEmpr;
         PAR310X3( @empr
               : @anio
               : @mes
               : @dia );
         @@fecha = @anio * 10000 + @mes * 100 + @dia;
       endif;

        //si no encuentra cabecera de póliza manda error
       if not getEc0( peEmpr
                    : peSucu
                    : peArcd
                    : peSpol
                    : r1hec0 );
          SetError( SPVANUL_SCAB
                  : 'Póliza sin Cabecera de Póliza');
          @retorno = *on;
       else;
          @@anio = r1hec0.c0fioa;
          @@mes  = r1hec0.c0fiom;
          @@dia  = r1hec0.c0fiod;
          @@desd = p@famd;
          @@anio = r1hec0.c0fvoa;
          @@mes  = r1hec0.c0fvom;
          @@dia  = r1hec0.c0fvod;
          @@hast = p@famd;
         if @@fecha < @@desd  or @@fecha > @@hast;
             SetError( SPVANUL_FEFV
                 : 'Anulación fuera de vigencia de Pòliza');
             @retorno = *on;
          else;
             @retorno = *OFF;
          endif;
       endif;

       return @retorno;
      /end-free


     P SPVANUL_FVIG...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_SSALD(): Chequea si tiene saldo la póliza             *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_SSALD...
     P                 B                   export
     D SPVANUL_SSALD...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
      *                                                              *
     D k1Hcc2          ds                  likerec(p1hcc2:*key)
      *                                                              *
     d @@sald          s             15  2
      *                                                              *
     D                 ds
     D p@famd                  1      8S 0
     D @@anio                  1      4S 0
     D @@mes                   5      6S 0
     D @@dia                   7      8S 0

     D PAGADA          c                   '3'

      /free

       SPVANUL_Inz();
       k1hcc2.c2empr = peEmpr;
       k1hcc2.c2sucu = peSucu;
       k1hcc2.c2arcd = peArcd;
       k1hcc2.c2spol = peSpol;
       @@sald = *zero;
       setll %kds(k1hcc2:4) pahcc2;
       reade %kds(k1hcc2:4) pahcc2;

       dow not %eof(pahcc2);
           if  c2sttc <> PAGADA;
              @@sald += c2imcu;
           endif;
           reade %kds(k1hcc2:4) pahcc2;
       enddo;

          if @@sald = *ZERO;
             SetError( SPVANUL_POSS
                 : 'Póliza sin Saldo Pendiente');
            @retorno = *on;
       else;
            @retorno = *OFF;
       endif;

       return @retorno;
      /end-free


     P SPVANUL_SSALD...
     P                 E

      * ------------------------------------------------------------ *
      * SPVANUL_cuopr(): Chequea si tiene cuotas en proceso           *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVANUL_cuopr...
     P                 B                   export
     D SPVANUL_cuopr...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
      *                                                              *
     D k1Hcc2          ds                  likerec(p1hcc2:*key)
     d @cuo_en_pr      s                   like(*inlr)
     D PRDEBITO        c                   '2'
     D PRPRELI         c                   'C'
      *                                                              *
      /free

       SPVANUL_Inz();
       k1hcc2.c2empr = peEmpr;
       k1hcc2.c2sucu = peSucu;
       k1hcc2.c2arcd = peArcd;
       k1hcc2.c2spol = peSpol;
       setll %kds(k1hcc2:4) pahcc2;
       reade %kds(k1hcc2:4) pahcc2;

       @cuo_en_pr = *off;
     dow not %eof(pahcc2);
      if c2sttc = '2'  or c2sttc = 'C';
       // setea cuotas en proceso
         @cuo_en_pr = *on;
      endif;
       reade %kds(k1hcc2:4) pahcc2;
     enddo;

        if @cuo_en_pr;
             SetError( SPVANUL_cupr
                 : 'Póliza con Cuotas Tomadas x Preliq');
       endif;
       eval @retorno = @cuo_en_pr;

       return @retorno;
      /end-free


     P SPVANUL_CUOPR...
     P                 E

      * ------------------------------------------------------------ *
      * getEc0(): Busca registro de Pahec0                           *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *     pehec0   (output)  registro de pahec0                    *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P getEc0          B
     D getEc0          pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pehec0                            likeds(r1hec0)
      *                                                              *
     D k1hec0          ds                  likerec(p1hec0:*key)
      *r1hec0          ds                  likerec(p1hec0)
     d @cuo_en_pr      s                   like(*inlr)
      *
      /free

       SPVANUL_Inz();

       k1hec0.c0empr = peEmpr;
       k1hec0.c0sucu = peSucu;
       k1hec0.c0arcd = peArcd;
       k1hec0.c0spol = peSpol;

       chain %kds(k1hec0) pahec0 pehec0;
       if not %found;
          @retorno  = *OFF;
       endif;
       @retorno = *ON;

       return @retorno;
      /end-free


     P getEc0          E


      *                                                              *
      * ------------------------------------------------------------ *
      * SPVANUL_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVANUL_inz     B                   export
     D SPVANUL_inz     pi

      /free

       monitor;
         if (Initialized);
           return;
         endif;

       if not %open(pawpc0);
         open pawpc0;
       endif;

       if not %open(pahec0);
         open pahec0;
       endif;

       if not %open(pawkl1);
         open pawkl1;
       endif;

       if not %open(pawemi01);
         open pawemi01;
       endif;

       if not %open(pahec108);
         open pahec108;
       endif;

       if not %open(pahscd11);
         open pahscd11;
       endif;

       if not %open(pahCC2);
         open pahCC2;
       endif;

       if not %open(gti98003);
         open gti98003;
       endif;


         Initialized = *ON;
         return;
         on-error;
         Initialized = *OFF;
       endmon;

       /end-free

     P SPVANUL_inz     E

      * ------------------------------------------------------------ *
      * SPVANUL_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVANUL_End     B                   export
     D SPVANUL_End     pi

      /free

        close *all;
        initialized = *off;

         close pawpc0;
         close pahec0;
         close pawkl1;
         close pawemi01;
         close pahec108;
         close pahscd11;
         close pahCC2;
         close gti98003;
      /end-free

     P SPVANUL_End     E

      * ------------------------------------------------------------ *
      * SPVANUL_Error(): Retorna el último error del service program *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SPVANUL_Error   B                   export
     D SPVANUL_Error   pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SPVANUL_Error   E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peEnum   (input)   Número de error a setear.             *
      *     peEtxt   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peEnum                       10i 0 const
     D  peEtxt                       80a   const

      /free

       ErrCode = peEnum;
       ErrText = peEtxt;

      /end-free

     P SetError...
     P                 E
