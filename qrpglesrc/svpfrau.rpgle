     H nomain
      * ************************************************************ *
      * SVPFRAU :Programa de Servicio.                               *
      *          Indicadores de Fraude Siniestros                    *
      * ------------------------------------------------------------ *
      * Mónica Alonso                        08-abr-2014             *
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
      *> TEXT('Programa de Servicio: Indicadores de Fraude')  <*  *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                         <*  *
      * ************************************************************ *
     fpahed004  if   e           k disk    usropn
     fpahed0    if   e           k disk    usropn
     f                                     rename(p1hed0:p2hed0)
     f                                     prefix(dz:2)
     fpahec0    if   e           k disk    usropn
     fpahcd620  if   e           k disk    usropn
     fpahcc2    if   e           k disk    usropn
     fset400    if   e             disk    usropn
     fset001    if   e           k disk    usropn
     fpahet002  if   e           k disk    usropn
     fpaher002  if   e           k disk    usropn
     fpahet9    if   e           k disk    usropn
     fpaher9    if   e           k disk    usropn
     fpaher2    if   e           k disk    usropn
     ftab020    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
     D/copy './qcpybooks/SVPFRAU_h.rpgle'
     D*copy inf1moni/qpedi$3389,SVPFRAU_h

     D @@empr          s                   like(c0empr)
     D @@sucu          s                   like(c0sucu)
     D @@arcd          s                   like(c0arcd)
     D @@spol          s                   like(c0spol)
     D @@fema          s              4  0
     D @@femm          s              2  0
     D @@femd          s              2  0
     D @@dias          s             10i 0
     D @@finpgm        s              3a
     D @RETORNO        s              1n
     d @@FItm          s              8  0
     d @@Tipo          s              1
     D @@Aver          s              1
     D @@CobAU         s              2
     D @@CobRV         s              3  0
     D @@SumA          s             15  2
     D @@VIGdde        s              8  0
     D @@VIGhta        s              8  0
     D @@fvigd         s              8  0
     D @error          s              1n
     d ksuop           s                   like(d0suop)
     d ksspo           s                   like(d0sspo)
     D @autos          s              2  0 inz(04)
     D @encontro       s              1n

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

     D  ErrCode        s             10i 0
     D  ErrText        s             80a
      * ---- claves
     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hec0          ds                  likerec(p1hec0:*key)
     D k2hed0          ds                  likerec(p2hed0:*key)
     D k1het9          ds                  likerec(p1het9:*key)
     D k1het0          ds                  likerec(p1het002:*key)
     D k1her9          ds                  likerec(p1her9:*key)
     D k1her0          ds                  likerec(p1her002:*key)
     D k1her2          ds                  likerec(p1her2:*key)
     D k1hcd6          ds                  likerec(p1hcd620:*key)
     D k1hcc2          ds                  likerec(P1HCC2:*key)
     D k1b020          ds                  likerec(TAB020FM:*key)

     d                 ds
     d kempr                          1
     d ksucu                          2
     d karcd                          6  0
     d kspol                          9  0
     d krama                          2  0
     d karse                          2  0
     d kOper                          7  0
     d kPoco                          4  0
      *--- Initialized --------------------------------------------- *
     D Initialized     s              1N   inz(*OFF)

      *--- Definición de Procedimientos----------------------------- *

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxFEmi(): Chequea Si corresponde indicativo posible *
      *                    fraude, por cantidad de dias entre f.sini *
      *                    y f.emision                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peIFemi  (output)  Indicativo posible Fraude x F.Emision *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_OkxFEmi...
     P                 B                   export
     D SVPFRAU_OkxFEmi...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFsin                       8  0 const
     D   peIFemi                      1
      *

     D femision        s              8  0

      /free

       SVPFRAU_Inz();

       @retorno = *off;
       peIFemi = '0';

       if t@demi = *zero;
          return @retorno;
       endif;

       k1hed0.d0Empr =   peEmpr;
       k1hed0.d0Sucu =   peSucu;
       k1hed0.d0Rama =   peRama;
       k1hed0.d0Poli =   pePoli;

         //obtengo superpóliza
       chain %kds(k1hed0:4) pahed004;
1b     if %found;

         k1hec0.c0Empr =   d0Empr;
         k1hec0.c0Sucu =   d0Sucu;
         k1hec0.c0Arcd =   d0Arcd;
         k1hec0.c0Spol =   d0Spol;

         //obtengo fe.emisión
         chain %kds(k1hec0:4) pahec0;

2b       if %found;
            femision = c0fema * 10000 + c0femm * 100 + c0femd;
3b          if svpfrau_difdias(femision : peFsin : @@dias);
                  @retorno = *on;
               if @@dias < *zero;
                  @@dias = @@dias * (-1);
               endif;
4b             if @@dias <= t@demi;
                  peIFemi = '1';
4e             endif;
3e          endif;
2e       endif;
1e     endif;

       return @retorno;
      /end-free

     P SVPFRAU_OkxFEmi...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxFVig(): Chequea Si corresponde indicativo posible *
      *                    fraude, porque F.Emision posterior a F.Vi-*
      *                    gencia y Fe.Ocurrencia sinietro entre ambas
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peIFVig  (output)  Indicativo posible Fraude x F.Vig.dde.*
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_OkxFVig...
     P                 B                   export
     D SVPFRAU_OkxFVig...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFsin                       8  0 const
     D   peIFVig                      1
      *
     D femision        s              8  0
     D fvigdde         s              8  0
      *

      /free

       SVPFRAU_Inz();

       @retorno = *off;
       peIFVig = '0';

       k1hed0.d0Empr =   peEmpr;
       k1hed0.d0Sucu =   peSucu;
       k1hed0.d0Rama =   peRama;
       k1hed0.d0Poli =   pePoli;
       k1hed0.d0Suop =   *zero;

         //obtengo superpóliza y f.vigencia de suplemento 0
       chain %kds(k1hed0:5) pahed004;
       if %found;

         fvigdde = d0fioa * 10000 + d0fiom * 100 + d0fiod;

         k1hec0.c0Empr =   d0Empr;
         k1hec0.c0Sucu =   d0Sucu;
         k1hec0.c0Arcd =   d0Arcd;
         k1hec0.c0Spol =   d0Spol;

         //obtengo fe.emisión
         chain %kds(k1hec0:4) pahec0;

         if %found;
            femision = c0fema * 10000 + c0femm * 100 + c0femd;

         // si la fecha de emision de la póliza es posterior a la vigencia desde
            @retorno = *on;
            if  femision > fvigdde;

         // si F. Emision > F. Siniestro > F.Vig.Desde => posible fraude

                if femision >= peFsin  and
                   peFsin   >= fvigdde;
                   peIFVig = '1';
                endif;
            endif;
         endif;
       endif;

       return @retorno;
      /end-free

     P SVPFRAU_OkxFVig...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxFItm(): Chequea Si corresponde indicativo posible *
      *                    fraude, porque F.Emision posterior a F.Vi-*
      *                    gencia y Fe.Ocurrencia sinietro entre ambas
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peIFIItm (output)  Indicativo posible Fraude x F.Emision *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_okxFItm...
     P                 B                   export
     D SVPFRAU_okxFItm...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peFsin                       8  0 const
     d   peIFIItm                     1
      *

      /free
       SVPFRAU_Inz();

       @retorno = *off;
       peIFIItm = '0';

        //busca la fecha de Inclusion de Item del Componente
       @@Tipo = '9';
       if SVPFRAU_getPoco( peEmpr
                         : peSucu
                         : peRama
                         : pePoli
                         : pePoco
                         : @@Tipo
                         : peFsin
                         : @@FItm
                         : @@SumA
                         : @@CobAU
                         : @@COBRV
                         : @@Aver);
            if svpfrau_difdias(@@FItm : peFsin : @@dias) and t@ditm > *zero;
               @retorno = *on;
               if @@dias < *zero;
                  @@dias = @@dias * (-1);
               endif;
               if @@dias <= t@ditm;
                  peIFIItm = '1';
               endif;
            endif;
       endif;

       return @retorno;
      /end-free

     PSVPFRAU_okxFItm...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxSumA(): Chequea Si Hubo Aumento de Suma antes de  *
      *                    Siniestro                                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peISumA  (output)  Indicativo posible Fraude x Aumento Sum
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_okxSumA...
     P                 B                   export
     D SVPFRAU_okxSumA...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peFsin                       8  0 const
     d   peISumA                      1
      *

     d @@SumA          s             15  2
     d @@SumA_ant      s             15  2

     c     klave         klist
     c                   kfld                    kempr
     c                   kfld                    ksucu
     c                   kfld                    karcd
     c                   kfld                    kspol
     c                   kfld                    krama
     c                   kfld                    karse
     c                   kfld                    kOper
     c                   kfld                    kPoco

      /free
       SVPFRAU_Inz();

       @retorno = *off;
       peISumA  = '0';

       // si no encontro registro en set400 o el parámetro está en cero
       // retorna error

1b     if t@dsum = 0;
          return @retorno;
1e     endif;

       @@SumA     = *zero;
       @@SumA_ant = *zero;

       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;

       chain %kds(k1hed0 : 4) pahed004;

       //busca superpóliza
1b     if %found;
          // para saber que archivos utilizar segun rama
          chain d0rama set001;
2b        if %found;
             kempr = peEmpr;
             ksucu = peSucu;
             karcd = d0Arcd;
             kspol = d0Spol;
             krama = d0Rama;
             karse = d0Arse;
             kOper = d0Oper;
             kPoco = pePoco;
           // solo se comprueba para autos
3b           if t@rame = @autos;
                setll klave pahet002;
                reade klave pahet002;

4b              if  not %eof;
                    exsr autosuma;
4e              endif;
3e           endif;
2e        endif;
1e     endif;

       return @retorno;

       // Ciclo Autos
       begsr autosuma;

       @encontro  = *off;

1b     dow not %eof(pahet002);
         ksspo = t0sspo;
         ksuop = t0suop;
         exsr busca_pahed0;
2b       if %found;
            @@VIGdde = dzfioa * 10000 + dzfiom * 100 + dzfiod;
            @@VIGhta = dzfvoa * 10000 + dzfvom * 100 + dzfvod;
3b          if @@VIGHTA >= peFsin   and @@VIGDDE <= peFsin;
               @encontro =  *on;
               LEAVE;
3E          ENDIF;
2x       else;
           leave;
2e       endif;
         reade klave pahet002;
1e     enddo;

1b     if @encontro;
2b        if svpfrau_difdias(@@vigdde : peFsin : @@Dias);
3b           if @@dias < *zero;
                @@dias = @@dias * (-1);
3e           endif;
             @retorno = *on;
3b        if @@dias <= t@dsum;
          // el primer registro que encuentre la fe.sini entre vigdde y hta
          // es el de fecha más cercana... primero me fijo la cant. de dias
          // entre vigencia y siniestro para ver si justifica seguir y si ok
          // lee siguiente reg y verifica diferencia de sumas aseguradas
             @@SumA = t0vhvu;
             reade klave pahet002;
4b           if not %eof(pahet002);
                @@SumA_ant = t0vhvu;
5b              if @@sumA > @@suma_ant;
                   peISumA  = '1';
5e              endif;
4e           endif;
3e         endif;
2e       endif;
1e     endif;
       endsr;

       begsr busca_pahed0;
          k2hed0.dzempr = peEmpr;
          k2hed0.dzsucu = peSucu;
          k2hed0.dzarcd = karcd;
          k2hed0.dzspol = kspol;
          k2hed0.dzrama = krama;
          k2hed0.dzarse = karse;
          k2hed0.dzoper = koper;
          k2hed0.dzsspo = ksspo;
          k2hed0.dzsuop = ksuop;

        // accedo a pahed0 para verificar que sea el suplemento que
        // correcto.. por la fecha de parámetro (fe. Siniestro)
        // que corresponda a la vigencia del suplemento

          chain %kds(k2hed0 : 9) p2hed0;
       endsr;
      /end-free

     PSVPFRAU_okxSumA...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxCob(): Chequea Si Hubo Cambio de Cobertura antes  *
      *                   de Siniestro                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peICob   (output)  Indicativo posible Fraude x Cambio de *
      *                        Cobertura                             *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_okxCob...
     P                 B                   export
     D SVPFRAU_okxCob...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peFsin                       8  0 const
     d   peICob                       1
      *

     d @@Cob           s              2
     d @@Cob_ant       s              2

     c     klave         klist
     c                   kfld                    kempr
     c                   kfld                    ksucu
     c                   kfld                    karcd
     c                   kfld                    kspol
     c                   kfld                    krama
     c                   kfld                    karse
     c                   kfld                    kOper
     c                   kfld                    kPoco

      /free
       SVPFRAU_Inz();

       @retorno = *off;
       peICob   = '0';

       // si no encontro registro en set400 o el parámetro está en cero
       // retorna error

1b     if t@dcob = 0;
          return @retorno;
1e     endif;

       @@COB      = *blank;
       @@cob_ant  = *blank;

       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;

       chain %kds(k1hed0 : 4) pahed004;

       //busca superpóliza
1b     if %found;
          // para saber que archivos utilizar segun rama
          chain d0rama set001;
2b        if %found;
             kempr = peEmpr;
             ksucu = peSucu;
             karcd = d0Arcd;
             kspol = d0Spol;
             krama = d0Rama;
             karse = d0Arse;
             kOper = d0Oper;
             kPoco = pePoco;

             // solo puede realizarse para autos
3b           if t@rame =  @autos;
                setll klave pahet002;
                reade klave pahet002;

4b              if  not %eof;
                    exsr autocob;
4e              endif;
3e           endif;
2e        endif;
1e     endif;

       return @retorno;

       // Ciclo Autos
       begsr autocob;

       @encontro  = *off;
1b     dow not %eof(pahet002);
         ksspo = t0sspo;
         ksuop = t0suop;
         exsr busca_pahed0;
2b       if %found;
            @@VIGdde = dzfioa * 10000 + dzfiom * 100 + dzfiod;
            @@VIGhta = dzfvoa * 10000 + dzfvom * 100 + dzfvod;
3b          if @@VIGHTA >= peFsin   and @@VIGDDE <= peFsin;
               @encontro =  *on;
               LEAVE;
3e          ENDIF;
2x       else;
           leave;
2e       endif;
         reade klave pahet002;
1e     enddo;

1b     if @encontro;
2b        if svpfrau_difdias(@@vigdde : peFsin : @@Dias);
3b           if @@dias < *zero;
                @@dias = @@dias * (-1);
3e           endif;
             @retorno = *on;
3b           if @@dias <= t@dcob;
          // el primer registro que encuentre la fe.sini entre vigdde y hta
          // es el de fecha más cercana... primero me fijo la cant. de dias
          // si entre vigencia y siniestro para ver si justifica seguir
                @@cob = t0cobl;
                reade klave pahet002;
4b              if not %eof(pahet002);
                   @@cob_ant = t0cobl;
5b                 if @@cob <> @@cob_ant;
                      peIcob  = '1';
5e                 endif;
4e              endif;
3e           endif;
2e        endif;
1e     endif;

       endsr;

       begsr busca_pahed0;
          k2hed0.dzempr = peEmpr;
          k2hed0.dzsucu = peSucu;
          k2hed0.dzarcd = karcd;
          k2hed0.dzspol = kspol;
          k2hed0.dzrama = krama;
          k2hed0.dzarse = karse;
          k2hed0.dzoper = koper;
          k2hed0.dzsspo = ksspo;
          k2hed0.dzsuop = ksuop;

        // accedo a pahed0 para verificar que sea el suplemento que
        // correcto.. por la fecha de parámetro (fe. Siniestro)
        // que corresponda a la vigencia del suplemento

          chain %kds(k2hed0 : 9) p2hed0;
       endsr;
      /end-free

     PSVPFRAU_okxcob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFRAU_okxAver(): Chequea Si tiene Averias informadas       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peIAver  (output)  Indicativo si tiene Averia            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_okxAver...
     P                 B                   export
     D SVPFRAU_okxAver...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peFsin                       8  0 const
     d   peIAver                      1
      *
     d@@FItm           s              8  0
     d@@Tipo           s              1

      /free
       SVPFRAU_Inz();

       @retorno = *off;
       peIaver = '0';

        //busca la fecha de Inclusion de Item del Componente
       @@Tipo = '0';
       if SVPFRAU_getPoco( peEmpr
                        : peSucu
                        : peRama
                        : pePoli
                        : pePoco
                        : @@Tipo
                        : peFsin
                        : @@FItm
                        : @@SumA
                        : @@CobAU
                        : @@COBRV
                        : @@Aver);
          peIaver = @@Aver;
          @retorno = *on;
       endif;

       return @retorno;
      /end-free

     PSVPFRAU_okxAver...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFRAU_OkxCuo(): Chequea Si Fecha Siniestro Posterior a pago*
      *                   de cuota vencida                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFsin   (input)   Fe.Siniestro(aaaammdd)                *
      *     peICuo   (output)  Indicativo posible Fraude x Siniestro *
      *                        posterior a Pago cuota vencida        *
      *     peICVPag (output)  Indicativo Productor con Convenio Pago*
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_okxCuo...
     P                 B                   export
     D SVPFRAU_okxCuo...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peFsin                       8  0 const
     d   peICuo                       1
     d   peICVPag                     1

     d                 ds
     d   @@fecha               1      8s 0
     d   @@anio                1      4s 0
     d   @@mes                 5      6s 0
     d   @@dia                 7      8s 0
      *
     d@@fvtocuo        s              8  0
     d@@fpago          s              8  0


      /free
       SVPFRAU_Inz();

       @retorno = *off;
       peICuo   = '0';
       peICVPAG = '0';

1b     if t@dcuo = 0;
          return @retorno;
1e     endif;

       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;

       chain %kds(k1hed0 : 4) pahed004;

       //busca superpóliza
1b     if %found;
          k1hec0.c0Empr =   d0Empr;
          k1hec0.c0Sucu =   d0Sucu;
          k1hec0.c0Arcd =   d0Arcd;
          k1hec0.c0Spol =   d0Spol;

          chain %kds(k1hec0 : 4) pahec0;

2b        if %found;
             k1hcd6.d6empr = peEmpr;
             k1hcd6.d6sucu = peSucu;
             k1hcd6.d6rama = peRama;
             k1hcd6.d6poli = pePoli;
             @@fecha = peFsin;
             k1hcd6.d6fasa = @@anio;
             k1hcd6.d6fasm = @@mes;
             k1hcd6.d6fasd = @@dia;

             setll %kds(k1hcd6) pahcd620;
             reade %kds(k1hcd6 : 4) pahcd620;
3b           if  %eof;
                 @retorno = *on;
             else;
                 @@fpago = d6fasa * 10000 + d6fasm * 100 + d6fasd;
4b               if svpfrau_difdias(@@fpago : pefsin : @@dias);
                    if @@dias < *zero;
                       @@dias = @@dias * (-1);
                    endif;
5b                  if @@dias > t@dcuo;
                    // este siniestro ya no me interesa... salgo del loop
                       @retorno = *on;
5x                  else;
                 // si la fe.pago esta cercana a fe.siniestro, tengo que ver
                 // si  cuota estaba vencida. y si corresp. a productor con
                 // condición de pago especial
                       k1hcc2.C2EMPR = d6Empr;
                       k1hcc2.C2SUCU = d6Sucu;
                       k1hcc2.C2ARCD = d6arcd;
                       k1hcc2.C2SPOL = d6spol;
                       k1hcc2.C2SSPO = d6sspo;
                       k1hcc2.C2NRCU = d6nrcu;
                       k1hcc2.C2NRSC = d6nrsc;
                       chain %kds(k1hcc2) pahcc2;

6b                     if not %found;
6x                     else;
                         @retorno = *on;
                   // me fijo cuando es la fecha de vencimiento de la cuota
                   // si se pago vencida (fe.vto < fpago)

                         @@fvtocuo = C2FVCA * 10000 + C2FVCM * 100 + C2FVCD;
7b                       if @@fvtocuo < @@fpago;
                            peIcuo = '1';
                     // si estaba vencida me fijo si corresponde a productor
                     // con convenio de pago
                            k1b020.t@empr = 'A';
                            k1b020.t@sucu = 'CA';
                            k1b020.t@nivt = 1;
                            k1b020.t@nivc = c0nivc;
                            chain %kds(k1b020) tab020;
8b                          if %found;
                               peICVPAG = '1';
8e                          endif;
7x                       else;
7e                       endif;
6e                    endif;
5e                 endif;
4e              endif;
3e           endif;

2e        endif;
1e     endif;

       return @retorno;

      /end-free
     P SVPFRAU_okxCuo...
     P                 e

      * ------------------------------------------------------------ *
      *  SVPFRAU_getPoco(): Busca Componente                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Código Rama                           *
      *     pePoli   (input)   Póliza                                *
      *     pePoco   (input)   Componente                            *
      *     peTipo   (input)   Tipo 0: a Fecha de param. (pahet0)    *
      *                             9: Ult.Estado (pahet9)           *
      *     peFecha  (input)   se usa si peTipo = 0                  *
      *     peFItm   (output)  Fecha Inclusion Itm                   *
      *     peSumA   (output)  Suma Asegurada                        *
      *     peCobAU  (output)  Cobertura (Rama Autos)                *
      *     peCOBRV  (output)  Cobertura (Rama Riesgos Varios)       *
      *     peAver   (output)  Averia    (Rama Autos)                *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPFRAU_getPoco...
     P                 B
     D SVPFRAU_getPoco...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peTipo                       1    const
     D   peFecha                      8  0 const
     D   peFItm                       8  0
     D   peSumA                      15  2
     D   PECobAU                      2
     D   peCobRV                      3  0
     D   peAver                       1
      *                                                              *
      *                                                              *
     d @cuo_en_pr      s                   like(*inlr)
     d @feaux          s              8  0
      *
     c     klave         klist
     c                   kfld                    kempr
     c                   kfld                    ksucu
     c                   kfld                    karcd
     c                   kfld                    kspol
     c                   kfld                    krama
     c                   kfld                    karse
     c                   kfld                    kOper
     c                   kfld                    kPoco
      /free

       @retorno = *off;
       SVPFRAU_Inz();

       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;

       chain %kds(k1hed0 : 4) pahed004;

       //busca superpóliza
1b     if  %found;
          // para saber que archivos utilizar segun rama
          chain d0rama set001;
2b        if  %found;
             kempr = peEmpr;
             ksucu = peSucu;
             karcd = d0Arcd;
             kspol = d0Spol;
             krama = d0Rama;
             karse = d0Arse;
             kOper = d0Oper;
             kPoco = pePoco;
3b        select;
3x        when peTipo = '9';
4b           if t@rame = @autos;
                chain klave pahet9;
4x           else;
                chain klave paher9;
4e           endif;

4b           if %found;
                @retorno = *on;
5b              if t@rame = @autos;
                   peFItm = t9ainn * 10000 + t9minn * 100 + t9dinn;
5x              else;
                   peFItm = r9ainn * 10000 + r9minn * 100 + r9dinn;
5e              endif;

                peSumA = *zero;
                peCobAU = *blank;
                peCobRV = *zero;
                peAver  = '0';
4e           endif;

3x        when peTipo = '0';
4b           if t@rame = @autos;
                setll klave pahet002;
                reade klave pahet002;

5b              if  not %eof;
                    exsr autos;
5e              endif;
4x           else;
               // RSVS
                setll klave paher002;
                reade klave paher002;

5b              if  not %eof;
                    exsr rsvs;
5e              endif;
4e           endif;
3e         endsl;
2e        endif;
1e     endif;

       return @retorno;

       begsr busca_ed0;
          k2hed0.dzempr = peEmpr;
          k2hed0.dzsucu = peSucu;
          k2hed0.dzarcd = karcd;
          k2hed0.dzspol = kspol;
          k2hed0.dzrama = krama;
          k2hed0.dzarse = karse;
          k2hed0.dzoper = koper;
          k2hed0.dzsspo = ksspo;
          k2hed0.dzsuop = ksuop;

        // accedo a pahed0 para verificar que sea el suplemento que
        // correcto.. por la fecha de parámetro (fe. Siniestro)
        // que corresponda a la vigencia del suplemento

          chain %kds(k2hed0 : 9) p2hed0;
       endsr;

       // Ciclo Autos
       begsr autos;
6b     dow not %eof(pahet002);
         ksspo = t0sspo;
         ksuop = t0suop;
         exsr busca_ed0;
7b       if %found;
            @@VIGdde = dzfioa * 10000 + dzfiom * 100 + dzfiod;
            @@VIGhta = dzfvoa * 10000 + dzfvom * 100 + dzfvod;
8b          if @@VIGHTA >= pefecha  and @@VIGDDE <= pefecha;
               peFItm = @@vigDDE;
               peSumA = t0vhvu;
               peCobAU = t0cobl;
               peCobRV = *zero;
               peAver = t0Mar1;
               @retorno = *on;
               leave;
8e          endif;
7x       else;
           leave;
7e       endif;

         reade klave pahet002;

6e       enddo;
       endsr;

       // Ciclo RSVS
       begsr Rsvs;
6b       dow not %eof(paher002);
             ksspo = r0sspo;
             ksuop = r0suop;
             exsr busca_ed0;
7b           if %found;
                @@VIGdde = dzfioa * 10000 + dzfiom * 100 + dzfiod;
                @@VIGhta = dzfvoa * 10000 + dzfvom * 100 + dzfvod;
8b              if @@VIGHTA >= pefecha  and @@VIGDDE <= pefecha;
                   peFItm = @@vigDDE;
                // El caso de Cobertura RSVS con valor esta previsto para
                // cuando se llame desde alta de Siniestro (en Gaus)
                   if peCobRv <> *zero;
                      exsr busca_suma;
                   endif;
                // exsr busca_cobl;
                   peSumA  = *zero;
                   peCobAU = *blanks;
                   peCobRV = *zero;
                   peAver = '0';
                   @retorno = *on;
                   leave;
8e              endif;
7x           else;
                @retorno = *on;
                leave;
7e           endif;

             reade %kds(k1her0 : 8) paher002;

6e       enddo;
       endsr;

       begsr busca_suma;

       endsr;
      /end-free

     P SVPFRAU_getPoco...
     P                 E
      *                                                              *
      * ------------------------------------------------------------ *
      * SVPFRAU_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPFRAU_inz     B                   export
     D SVPFRAU_inz     pi

      /free

       monitor;
         if (Initialized);
           return;
         endif;

       if not %open(pahed004);
         open pahed004;
       endif;

       if not %open(pahec0);
         open pahec0;
       endif;

       if not %open(pahcd620);
         open pahcd620;
       endif;

       if not %open(pahcc2);
         open pahcc2;
       endif;

       if not %open(set400);
         open set400;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(tab020);
         open tab020;
       endif;

       if not %open(pahet002);
         open pahet002;
       endif;

       if not %open(paher002);
         open paher002;
       endif;

       if not %open(paher2);
         open paher2;
       endif;

       if not %open(pahet9);
         open pahet9;
       endif;

       if not %open(paher9);
         open paher9;
       endif;

       if not %open(pahed0);
         open pahed0;
       endif;

         Initialized = *ON;

       //obtengo registro de parametros
       read set400;
       if %eof;
       clear s1t400;
       endif;

         return;
         on-error;
         Initialized = *OFF;
       endmon;

       /end-free

     P SVPFRAU_inz     E

      * ------------------------------------------------------------ *
      * SVPFRAU_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPFRAU_End     B                   export
     D SVPFRAU_End     pi

      /free

        close *all;
        initialized = *off;

         close pahed004;
         close pahec0;
         close pahed0;
         close set001;
         close set400;
         close tab020;
         close pahcc2;
         close pahcd620;
         close pahet002;
         close paher002;
         close pahet9;
         close paher9;
         close paher2;
      /end-free

     P SVPFRAU_End     E

      * ------------------------------------------------------------ *
      * SVPFRAU_DifDias(): Retorna dif. en días entre dos fechas     *
      *                                                              *
      *     peFedde (Input)    Fecha desde                           *
      *     peFehta (Input)    Fecha hasta                           *
      *     peDias  (Output)   Cant. Días entre fechas               *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     PSVPFRAU_DifDias  B                   export
     DSVPFRAU_DifDias  pi             1n
     D   peFedde                      8  0 const
     D   peFehta                      8  0 const
     D   peDias                      10i 0

     D @DATE1          s             10d   datfmt(*iso)
     D @DATE2          s             10d   datfmt(*iso)

      /free
       peDias = *zero;
       monitor;
       @Date1 = %date(peFedde: *iso);
       on-error;
       @retorno = *off;
       return @retorno;
       endmon;

       monitor;
       @Date2 = %date(peFehta: *iso);
       on-error;
       //@dias = *zero;
       @retorno = *off;
       return @retorno;
       endmon;

       peDias = %diff(@date2 : @date1 : *Days);
       @retorno = *on;
       return @retorno;
      /end-free

     PSVPFRAU_DifDias  E

      * ------------------------------------------------------------ *
      * SVPFRAU_Error(): Retorna el último error del service program *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPFRAU_Error   B                   export
     D SVPFRAU_Error   pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SVPFRAU_Error   E

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
