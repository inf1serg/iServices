     H option(*nodebugio:*srcstmt)
     H nomain
      * ************************************************************ *
      * CZWUTL: Cotización Standard                                  *
      *         Programa de Servicio - Rutinas Utilitarias           *
      *                                                              *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                          <*    *
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                       <*    *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                          <*    *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -            <*    *
      *>           DBGVIEW(&DV)                                <*    *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                            <*    *
      *>           MODULE(QTEMP/&N) -                          <*    *
      *>           EXPORT(*SRCFILE) -                          <*    *
      *>           SRCFILE(HDIILE/QSRVSRC) -                   <*    *
      *>           BNDSRVPGM(*LIBL/SPVVEH) -                   <*    *
      *> TEXT('Cotización Standard: Rutinas utilitarias')      <*    *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                          <*    *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *01-Oct-2013        *
      * ------------------------------------------------------------ *
      * SGF 02/12/13: Tarifa 109                                     *
      *               Suma máxima pasa a 700.000.-                   *
      *               Suma mínima pasa a  30.000.-                   *
      * SGF 16/12/13: getSumaMaxima() llama a SPVVEH_getSumaMaxima() *
      *               getSumaMinima() llama a SPVVEH_getSumaMinima() *
      *               chkSumaAsegurada() usa SPVVEH_chkSumaAsegurada *
      *               Tarifa 109: Alta Gama pasa a 175.000.-         *
      * SGF 01/04/14: chkAÑoMinimo(): controla año mínimo para coti- *
      *               zar, sin importar cobertura.                   *
      * SGF 03/07/14: Tarifa 110: Alta Gama pasa a 300.000.-         *
      * SGF 28/07/14: Tarifa 109: Alta Gama pasa a 230.000.-         *
      * SFA 27/05/15: Recompilo por modificacion en SET6302/SET6303  *
      * SFA 20/06/15: Nuevo parametro opcional en getDescMarcaModelo *
      *               Nuevo procedimiento chkDescAltaGama            *
      * LRG 25/11/15: se recompila por cambio en archivo DBA22531    *
      * SGF 21/03/19: Depreco _chkDescAltaGama().                    *
      *               Creo _chkDescAltaGama2().                      *
      *               Esto se hace para poder diferenciar el % de    *
      *               descuento alta gama para 0 kms y no 0 kms.     *
      *                                                              *
      * ************************************************************ *

     Fgntloc    if   e           k disk    usropn
     Fgntloc02  if   e           k disk    usropn
     Fset621    if   e           k disk    usropn
     Fset22221  if   e           k disk    usropn
     Fset250    if   e           k disk    usropn
     Fset2501   if   e           k disk    usropn
     Fset204    if   e           k disk    usropn
     Fset20496  if   e           k disk    usropn rename(s1t204:s1t20496)
     Fset20493  if   e           k disk    usropn rename(s1t204:s1t20493)
     Fgntiv1    if   e           k disk    usropn
     Fset6302   if   e           k disk    usropn
     Fsehni201  if   e           k disk    usropn
     Fsehni41   if   e           k disk    usropn
     Fset2254   if   e           k disk    usropn

      /copy './qcpybooks/czwutl_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'

      * Establecer ultimo error
     D SetError        pr
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

     D initialized     s              1n
     D ErrorNumb       s             10i 0
     D ErrorText       s             80a

     D                uds
     D usempr                401    401
     D ussucu                402    403

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWUTL_Inz      B                   export
     D CZWUTL_Inz      pi

      /free

       if (initialized = *ON);
          return;
       endif;

       if not %open(gntloc);
          open gntloc;
       endif;
       if not %open(gntloc02);
          open gntloc02;
       endif;
       if not %open(set621);
          open set621;
       endif;
       if not %open(set22221);
          open set22221;
       endif;
       if not %open(set250);
          open set250;
       endif;
       if not %open(set2501);
          open set2501;
       endif;
       if not %open(set204);
          open set204;
       endif;
       if not %open(set20496);
          open set20496;
       endif;
       if not %open(set20493);
          open set20493;
       endif;
       if not %open(gntiv1);
          open gntiv1;
       endif;
       if not %open(set6302);
          open set6302;
       endif;
       if not %open(sehni201);
          open sehni201;
       endif;
       if not %open(sehni41);
          open sehni41;
       endif;
       if not %open(set2254);
          open set2254;
       endif;

       Initialized = *ON;

      /end-free

     P CZWUTL_Inz      E

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWUTL_End      B                   export
     D CZWUTL_End      pi

      /free

       close *all;
       Initialized = *OFF;

       /end-free

     P CZWUTL_End      E

      * ------------------------------------------------------------ *
      * Error():    Retorna último error del módulo                  *
      *                                                              *
      *         peErrn    (output)    Código de Error                *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     P CZWUTL_Error    B                   export
     D CZWUTL_Error    pi            80a
     D   peErrn                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *NULL;
          peErrn = ErrorNumb;
       endif;

       return ErrorText;

      /end-free

     P CZWUTL_Error    E

      * ------------------------------------------------------------ *
      * SetError():  Establece último error del módulo               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

      /free

         ErrorNumb = peErrn;
         ErrorText = peErrm;

      /end-free

     P SetError        E

      * ------------------------------------------------------------ *
      * getOldCp():   Extraer Código Postal viejo desde el CPA       *
      *                                                              *
      *     peCpar    (input)    Código Postal Argentino (A9999AAA)  *
      *                                                              *
      * retorna: CP viejo, -1 si error o -2 si inexistente           *
      * ------------------------------------------------------------ *
     P CZWUTL_getOldCp...
     P                 B                   export
     D CZWUTL_getOldCp...
     D                 pi            10i 0
     D  peCpar                        8a   const
     D  peCopo                        5  0

     D @copo           s              5  0

      /free

       CZWUTL_Inz();

       monitor;
          @Copo = %dec( %subst(peCpar:2:4):5:0 );
        on-error;
          SetError( 50000
                  : 'Error de formato CPA' );
          return -1;
       endmon;

       setll @copo gntloc;
       if not %equal;
          SetError( 50001
                  : 'C.P. Inexistente');
          return -2;
       endif;

       eval peCopo = @Copo;
       return 0;

      /end-free

     P CZWUTL_getOldCp...
     P                 E

      * ------------------------------------------------------------ *
      * getZona():    Obtiene Zona de Riesgo                         *
      *                                                              *
      *     peCopo    (input)    Código Postal (viejo)               *
      *     peTipo    (input)    AUT = Autos                         *
      *                          RSV = Riesgos Varios                *
      *                                                              *
      * retorna: Zona,  -1 si error                                  *
      * ------------------------------------------------------------ *
     P CZWUTL_getZona  B                   Export
     D CZWUTL_getZona  pi            10i 0
     D  peCopo                        5  0 const
     D  peTipo                        3a   const
     D  peScta                        1  0

      /free

       CZWUTL_Inz();

       chain peCopo gntloc;
       if %found;
          select;
           when peTipo = 'AUT';
             peScta = loscta;
             return 0;
           when peTipo = 'RSV';
             peScta = lozrrv;
             return 0;
          endsl;
        else;
          SetError( 50001
                  : 'C.P. Inexistente');
          return -1;
       endif;

      /end-free

     P CZWUTL_getZona  E

      * ------------------------------------------------------------ *
      * getFemi():    Obtiene Fecha de Emisión                       *
      *                                                              *
      *                                                              *
      * retorna: Fecha de Emisión                                    *
      * ------------------------------------------------------------ *
     P CZWUTL_getFemi  B                   Export
     D CZWUTL_getFemi  pi             8  0

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D @femi           s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0

      /free

       CZWUTL_Inz();

       PAR310X3( usempr: peFema: peFemm: peFemd );
       if (peFema = 0 or peFemm = 0 or peFemd = 0);
          @femi = (*year * 10000)
                + (*month * 100)
                +  *day;
          return @femi;
       endif;

       @femi = (peFema * 10000)
             + (peFemm * 100)
             +  peFemd;
       return @femi;

      /end-free

     P CZWUTL_getFemi  E

      * ------------------------------------------------------------ *
      * getDupe():   Obtiene duración del período                    *
      *                                                              *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peArse    (input)    Pólizas por Artículo/Rama           *
      *                                                              *
      * retorna: Duración del período, o -1 si error                 *
      * ------------------------------------------------------------ *
     P CZWUTL_getDupe  B                   export
     D CZWUTL_getDupe  pi            10i 0
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peDupe                        2  0

     D k1t621          ds                  likerec(s1t621:*key)

      /free

       CZWUTL_Inz();

       k1t621.t@arcd = peArcd;
       k1t621.t@rama = peRama;
       k1t621.t@arse = peArse;
       chain %kds(k1t621) set621;
       if %found;
          peDupe = t@dupe;
          return 0;
       endif;

       SetError( 50003
               : 'No ha podido determinarse duración del período');
       return -1;

      /end-free

     P CZWUTL_getDupe  E

      * ------------------------------------------------------------ *
      * getTarifa(): Obtiene tarifa vigente a una fecha              *
      *                                                              *
      *     peFemi    (input)    Fecha a la cual obtener tarifa.     *
      *                          Si no se envía, toma hoy            *
      *                                                              *
      * retorna: Código de tarifa o -1 si error                      *
      * ------------------------------------------------------------ *
     P CZWUTL_getTarifa...
     P                 B                   export
     D CZWUTL_getTarifa...
     D                 pi            10i 0
     D  peCtre                        5  0
     D  peFemi                        8  0 options(*nopass:*omit)

     D @Femi           s              8  0
     D @Ctre           s              5  0 inz(-1)

      /free

       CZWUTL_Inz();

       if %parms >= 1 and %addr(peFemi) <> *NULL;
          @Femi = peFemi;
        else;
          @Femi = CZWUTL_getFemi();
       endif;

       setgt @Femi set22221;
       readp set22221;
       dow not %eof;
        if t@femi <= @Femi;
           peCtre = t@ctre;
           return 0;
           leave;
        endif;
        readp set22221;
       enddo;

       SetError( 50004
               : 'No ha podido encontrarse Tarifa vigente');
       return -1;

      /end-free

     P CZWUTL_getTarifa...
     P                 E

      * ------------------------------------------------------------ *
      * esAltaGama():   Determina si un vehículo es Alta Gama        *
      *                                                              *
      *     ATENCION: No se determina aquí si hay o no que aplicar   *
      *               descuento (ver getDescAltaGama() ).            *
      *                                                              *
      *     peVhvu    (input)    Suma Asegurada                      *
      *     peFech    (input)    Fecha a la cual verificar           *
      *                                                              *
      * retorna: *ON si es alta gama, *off si no.                    *
      * ------------------------------------------------------------ *
     P CZWUTL_esAltaGama...
     P                 B                   export
     D CZWUTL_esAltaGama...
     D                 pi             1N
     D  peVhvu                       15  2 const
     D  peFech                        8  0 options(*nopass:*omit)

     D VALOR_ALGAMA    c                   230000
     D @Fech           s              8  0

      /free

       CZWUTL_Inz();

       if %parms >= 2 and %addr(peFech) <> *NULL;
          @fech = peFech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       return (peVhvu > VALOR_ALGAMA);

      /end-free

     P CZWUTL_esAltaGama...
     P                 E

      * ------------------------------------------------------------ *
      * getPorcAltaGama(): Retorna porcentaje de Alta Gama           *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Porcentaje de Alta Gama                             *
      * ------------------------------------------------------------ *
     P CZWUTL_getPorcAltaGama...
     P                 B                   export
     D CZWUTL_getPorcAltaGama...
     D                 pi             5  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peFech                        8  0 options(*nopass:*omit)

     D k1t250          ds                  likerec(s1t250:*key)
     D @femi           s              8  0
     D ALTA_GAMA       c                   31
     D PORC_AG         c                   10

      /free

       CZWUTL_Inz();

       if %parms >= 5 and %addr(peFech) <> *NULL;
          @femi = peFech;
        else;
          @femi = CZWUTL_getFemi();
       endif;

       k1t250.stempr = peEmpr;
       k1t250.stsucu = peSucu;
       k1t250.starcd = peArcd;
       k1t250.strama = peRama;
       k1t250.stccbp = ALTA_GAMA;
       k1t250.stmar1 = 'C';
       chain %kds(k1t250) set250;
       if %found;
          if @femi >= stfcbp and stffbp = 0;
             return PORC_AG;
          endif;
          if @femi >= stfcbp and @femi <= stffbp;
             return PORC_AG;
          endif;
       endif;

       return 0;

      /end-free

     P CZWUTL_getPorcAltaGama...
     P                 E

      * ------------------------------------------------------------ *
      * getPorcPromo0Km(): Retorna porcentaje de Promo 0 KM          *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Porcentaje de Promo 0 Km                            *
      * ------------------------------------------------------------ *
     P CZWUTL_getPorcPromo0Km...
     P                 B                   export
     D CZWUTL_getPorcPromo0Km...
     D                 pi             5  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peFech                        8  0 options(*nopass:*omit)

     D k1t250          ds                  likerec(s1t250:*key)
     D @femi           s              8  0
     D PROMO_0KM       c                   18
     D PORC_PROMO      c                   15

      /free

       CZWUTL_Inz();

       if %parms >= 5 and %addr(peFech) <> *NULL;
          @femi = peFech;
        else;
          @femi = CZWUTL_getFemi();
       endif;

       k1t250.stempr = peEmpr;
       k1t250.stsucu = peSucu;
       k1t250.starcd = peArcd;
       k1t250.strama = peRama;
       k1t250.stccbp = PROMO_0KM;
       k1t250.stmar1 = 'C';
       chain %kds(k1t250) set250;
       if %found;
          if @femi >= stfcbp and stffbp = 0;
             return PORC_PROMO;
          endif;
          if @femi >= stfcbp and @femi <= stffbp;
             return PORC_PROMO;
          endif;
       endif;

       return 0;

      /end-free

     P CZWUTL_getPorcPromo0Km...
     P                 E

      * ------------------------------------------------------------ *
      * getSumaMaxima():  Obtiene Suma Asegurada Máxima              *
      *                                                              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Suma Asegurada Máxima                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getSumaMaxima...
     P                 B                   export
     D CZWUTL_getSumaMaxima...
     D                 pi            15  2
     D  peFech                        8  0 options(*nopass:*omit)

     D @Fech           s              8  0
     D @smax           s             15  2

      /free

       CZWUTL_Inz();

       if %parms >= 1 and %addr(peFech) <> *NULL;
          @fech = peFech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       @smax = SPVVEH_getSumaMaxima(@fech);

       return @smax;

      /end-free

     P CZWUTL_getSumaMaxima...
     P                 E

      * ------------------------------------------------------------ *
      * getSumaMinima():  Obtiene Suma Asegurada Mínima              *
      *                                                              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Suma Asegurada Mínima                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getSumaMinima...
     P                 B                   export
     D CZWUTL_getSumaMinima...
     D                 pi            15  2
     D  peFech                        8  0 options(*nopass:*omit)

     D @fech           s              8  0
     D @smin           s             15  2

      /free

       CZWUTL_Inz();

       if %parms >= 1 and %addr(peFech) <> *NULL;
          @fech = peFech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       @smin = SPVVEH_getSumaMinima(@fech);

       return @smin;

      /end-free

     P CZWUTL_getSumaMinima...
     P                 E

      * ------------------------------------------------------------ *
      * getCobertD():  Obtiene Cobertura D a utilizar                *
      *                                                              *
      *     peVhca    (input)    Capítulo                            *
      *     peVhv1    (input)    Variante 1                          *
      *     peVhv2    (input)    Variante 2                          *
      *     peMtdf    (input)    Marca de Tarifa Diferencial         *
      *     peScta    (input)    Zona                                *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getCobertD...
     P                 B                   export
     D CZWUTL_getCobertD...
     D                 pi            10i 0
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1a   const
     D  peScta                        1  0 const
     D  peCobd                        2a
     D  peFech                        8  0 options(*nopass:*omit)

     D @Fech           s              8  0
      /free

       CZWUTL_Inz();

       if %parms >= 7 and %addr(peFech) <> *NULL;
          @fech = pefech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       if (peScta = 1 or peScta = 6);
          select;
           when peVhca = 1 and peVhv2 = 1 or
                peVhca = 1 and peVhv2 = 7 or
                peVhca = 1 and peVhv2 = 5 or
                peVhca = 4 and peMtdf = '2';
                  peCobd = 'D3';
                  return 0;
           other;
                  peCobd = 'D2';
                  return 0;
          endsl;
        else;
          peCobd = 'D2';
          return 0;
       endif;

       peCobd = 'D';
       SetError( 50005
               : 'Cobertura D no establecida' );
       return -1;

      /end-free

     P CZWUTL_getCobertD...
     P                 E

      * ------------------------------------------------------------ *
      * getDescMarcaModelo():  Obtiene Desc/Recargo Marca/Modelo     *
      *                                                              *
      *     peVhca    (input)    Capítulo                            *
      *     peVhv1    (input)    Variante 1                          *
      *     peVhv2    (input)    Variante 2                          *
      *     peMtdf    (input)    Marca de Tarifa Diferencial         *
      *     peScta    (input)    Zona                                *
      *                                                              *
      * retorna: porcentaje a aplicar.                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getDescMarcaModelo...
     P                 B                   export
     D CZWUTL_getDescMarcaModelo...
     D                 pi             5  2
     D  peVhmc                        3a
     D  peVhmo                        3a
     D  peVhcs                        3a
     D  peCcbp                        3  0 options (*Omit:*Nopass)

     D k1t2501         ds                  likerec(s1t2501:*key)

      /free

       CZWUTL_Inz();

       k1t2501.t@vhmc = peVhmc;
       k1t2501.t@vhmo = peVhmo;
       k1t2501.t@vhcs = peVhcs;

       // --------------------------------
       // Busco clave exacta
       // --------------------------------
       setll %kds(k1t2501:3) set2501;
       if %equal;
          reade %kds(k1t2501:3) set2501;
          if not %eof;
             if %parms >= 4 and %addr(peCcbp) <> *Null;
               peCcbp = t@ccbp;
             endif;
             return t@pcbp;
          endif;
       endif;

       // --------------------------------
       // Solo marca/modelo
       // --------------------------------
       k1t2501.t@vhcs = *blanks;
       setll %kds(k1t2501:3) set2501;
       if %equal;
          reade %kds(k1t2501:3) set2501;
          if not %eof;
             if %parms >= 4 and %addr(peCcbp) <> *Null;
               peCcbp = t@ccbp;
             endif;
             return t@pcbp;
          endif;
       endif;

       // --------------------------------
       // Solo marca
       // --------------------------------
       k1t2501.t@vhmo = *blanks;
       setll %kds(k1t2501:3) set2501;
       if %equal;
          reade %kds(k1t2501:3) set2501;
          if not %eof;
             if %parms >= 4 and %addr(peCcbp) <> *Null;
               peCcbp = t@ccbp;
             endif;
             return t@pcbp;
          endif;
       endif;

       if %parms >= 4 and %addr(peCcbp) <> *Null;
         peCcbp = *Zeros;
       endif;

       return 0;

      /end-free

     P CZWUTL_getDescMarcaModelo...
     P                 E

      * ------------------------------------------------------------ *
      * getArticulo(): Obtiene Artículo usado para emitir            *
      *                                                              *
      *     peArcd    (output)   Artículo                            *
      *     peRama    (output)   Rama                                *
      *     peArse    (output)   Pólizas por Artículo/Rama           *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Artículo o -1 si error                              *
      * ------------------------------------------------------------ *
     P CZWUTL_getArticulo...
     P                 B                    export
     D CZWUTL_getArticulo...
     D                 pi            10i 0
     D   peArcd                       6  0
     D   peRama                       2  0
     D   peArse                       2  0
     D   peFech                       8  0 options(*nopass:*omit)

     D @fech           s              8  0
     D ARTICULO        c                   1203
     D ARSE            c                   1
     D RAMA            c                   3

      /free

       CZWUTL_Inz();

       if %parms >= 4 and %addr(peFech) <> *NULL;
          @fech = pefech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       peArcd = ARTICULO;
       peRama = RAMA;
       peArse = ARSE;

       return 0;

      /end-free

     P CZWUTL_getArticulo...
     P                 E

      * ------------------------------------------------------------ *
      * getVehiculoGAUS():  Obtener vehículo GAUS con INFOAUTO       *
      * "DEPRECATED" se debe utilizar getVehiculoGAU1                *
      *     ATENCION: Es posible que exista más de un Vehículo       *
      *               GAUS para uno INFOAUTO.                        *
      *               Se retorna el primero (con marca de incluir    *
      *               en "I")                                        *
      *                                                              *
      *     peCmar    (input)    Código marca INFOAUTO               *
      *     peCmod    (input)    Código Modelo INFOAUTO              *
      *     peVhmc    (output)   Código Marca GAUS                   *
      *     peVhmo    (output)   Código Modelo GAUS                  *
      *     peVhcs    (output)   Código SubModelo GAUS               *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getVehiculoGAUS...
     P                 B                   export
     D CZWUTL_getVehiculoGAUS...
     D                 pi            10i 0
     D  peCmar                        3  0 const
     D  peCmod                        3  0 const
     D  peVhmc                        3a
     D  peVhmo                        3a
     D  peVhcs                        3a

     D k1t204          ds                  likerec(s1t20496:*key)

      /free

       CZWUTL_Inz();

       k1t204.t@cmar = peCmar;
       k1t204.t@cmod = peCmod;
       setll %kds(k1t204:2) set20496;
       reade %kds(k1t204:2) set20496;
       dow not %eof;
           if (t@mar1 = 'I');
              peVhmc = t@vhmc;
              peVhmo = t@vhmo;
              peVhcs = t@vhcs;
              return 0;
           endif;
        reade %kds(k1t204:2) set20496;
       enddo;

       SetError( 50006
               : 'Vehículo INFOAUTO no encontrado' );
       return -1;

      /end-free

     P CZWUTL_getVehiculoGAUS...
     P                 E

      * ------------------------------------------------------------ *
      * getVehiculoGAU1():  Obtener vehículo GAUS con INFOAUTO       *
      *                                                              *
      *     ATENCION: Es posible que exista más de un Vehículo       *
      *               GAUS para uno INFOAUTO.                        *
      *               Se retorna el primero (con marca de incluir    *
      *               en "I")                                        *
      *                                                              *
      *     peCmar    (input)    Código marca INFOAUTO               *
      *     peCmod    (input)    Código Modelo INFOAUTO              *
      *     peVhmc    (output)   Código Marca GAUS                   *
      *     peVhmo    (output)   Código Modelo GAUS                  *
      *     peVhcs    (output)   Código SubModelo GAUS               *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getVehiculoGAU1...
     P                 B                   export
     D CZWUTL_getVehiculoGAU1...
     D                 pi            10i 0
     D  peCma1                        9  0 const
     D  peCmo1                        9  0 const
     D  peVhmc                        3a
     D  peVhmo                        3a
     D  peVhcs                        3a

     D k2t204          ds                  likerec(s1t20493:*key)

      /free

       CZWUTL_Inz();

       k2t204.t@cma1 = peCma1;
       k2t204.t@cmo1 = peCmo1;
       setll %kds(k2t204:2) set20493;
       reade %kds(k2t204:2) set20493;
       dow not %eof;
           if (t@mar1 = 'I');
              peVhmc = t@vhmc;
              peVhmo = t@vhmo;
              peVhcs = t@vhcs;
              return 0;
           endif;
        reade %kds(k2t204:2) set20493;
       enddo;

       SetError( 50006
               : 'Vehículo INFOAUTO no encontrado' );
       return -1;

      /end-free

     P CZWUTL_getVehiculoGAU1...
     P                 E

      * ------------------------------------------------------------ *
      * getVehiculoINFO():  Obtener vehículo INFOAUTO con GAUS       *
      * "DEPRECATED" se debe utilizar getVehiculoINF1                *
      *     peVhmc    (input)    Código Marca GAUS                   *
      *     peVhmo    (input)    Código Modelo GAUS                  *
      *     peVhcs    (input)    Código SubModelo GAUS               *
      *     peCmar    (output)   Código marca INFOAUTO               *
      *     peCmod    (output)   Código Modelo INFOAUTO              *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getVehiculoINFO...
     P                 B                   export
     D CZWUTL_getVehiculoINFO...
     D                 pi            10i 0
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peCmar                        3  0
     D  peCmod                        3  0

     D k1t204          ds                  likerec(s1t204:*key)

      /free

       CZWUTL_Inz();

       k1t204.t@vhmc = peVhmc;
       k1t204.t@vhmo = peVhmo;
       k1t204.t@vhcs = peVhcs;
       chain %kds(k1t204:3) set204;
       if %found;
          peCmar = t@cmar;
          peCmod = t@cmod;
          return 0;
       endif;

       SetError( 50007
               : 'Vehículo GAUS no encontrado' );
       return -1;

      /end-free

     P CZWUTL_getVehiculoINFO...
     P                 E

      * ------------------------------------------------------------ *
      * getVehiculoINF1():  Obtener vehículo INFOAUTO con GAUS       *
      *                                                              *
      *     peVhmc    (input)    Código Marca GAUS                   *
      *     peVhmo    (input)    Código Modelo GAUS                  *
      *     peVhcs    (input)    Código SubModelo GAUS               *
      *     peCmar    (output)   Código marca INFOAUTO               *
      *     peCmod    (output)   Código Modelo INFOAUTO              *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      * ------------------------------------------------------------ *
     P CZWUTL_getVehiculoINF1...
     P                 B                   export
     D CZWUTL_getVehiculoINF1...
     D                 pi            10i 0
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peCma1                        9  0
     D  peCmo1                        9  0

     D k3t204          ds                  likerec(s1t204:*key)

      /free

       CZWUTL_Inz();

       k3t204.t@vhmc = peVhmc;
       k3t204.t@vhmo = peVhmo;
       k3t204.t@vhcs = peVhcs;
       chain %kds(k3t204:3) set204;
       if %found;
          peCma1 = t@cma1;
          peCmo1 = t@cmo1;
          return 0;
       endif;

       SetError( 50007
               : 'Vehículo GAUS no encontrado' );
       return -1;

      /end-free

     P CZWUTL_getVehiculoINF1...
     P                 E

      * ------------------------------------------------------------ *
      * sumaAsegMayor():   Valida que la suma asegurada sea valida   *
      *                                                              *
      *     peVhvu    (input)    Valor a asegurar                    *
      *     peFech    (input)    Fecha para controlar                *
      *                                                              *
      * retorna: *on si ok, *OFF si no.                              *
      * ------------------------------------------------------------ *
     P CZWUTL_sumaAsegMayor...
     P                 B                   export
     D CZWUTL_sumaAsegMayor...
     D                 pi             1N
     D  peVhvu                       15  2 const
     D  peFech                        8  0 options(*nopass:*omit)

     D @fech           s              8  0

      /free

       CZWUTL_Inz();

       if %parms >= 2 and %addr(pefech) <> *null;
          @fech = pefech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       if (peVhvu > CZWUTL_getSumaMaxima(@fech) );
          SetError( 50008
                  : 'Suma Asegurada supera el máximo permitido' );
          return *OFF;
       endif;

       return *ON;

      /end-free

     P CZWUTL_sumaAsegMayor...
     P                 E

      * ------------------------------------------------------------ *
      * getProvincia():  Obtener la provincia                        *
      *                                                              *
      *     peCopo    (input)    Código Postal                       *
      *     peCops    (input)    Sufijo Código Postal                *
      *     peProc    (output)   Código de Provincia GAUS            *
      *     peRpro    (output)   Código de Provincia INDER           *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_NOCP                                   *
      *          CZWUTL_ERROR_PROVINCIA                              *
      * ------------------------------------------------------------ *
     P CZWUTL_getProvincia...
     P                 B                   export
     D CZWUTL_getProvincia...
     D                 pi            10i 0
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peProc                        3a
     D  peRpro                        2  0

     D k1tloc          ds                  likerec(g1tloc02:*key)

      /free

       CZWUTL_Inz();

       k1tloc.locopo = pecopo;
       k1tloc.locops = pecops;
       chain %kds(k1tloc:2) gntloc02;
       if not %found;
          SetError( CZWUTL_ERROR_NOCP
                  : 'Código Postal inexistente' );
          return -1;
       endif;

       peProc = loproc;
       peRpro = prrpro;
       return 0;

      /end-free

     P CZWUTL_getProvincia...
     P                 E

      * ------------------------------------------------------------ *
      * getDatosCotizVeh():  Obtiene datos necesarios para cotizar   *
      *                                                              *
      *     peVhmc    (input)    Código de Marca del Vehículo        *
      *     peVhmo    (input)    Código de Modelo del Vehículo       *
      *     peVhcs    (input)    Código de SubModelo del Vehículo    *
      *     peVhca    (output)   Capítulo                            *
      *     peVhv1    (output)   Variante 1                          *
      *     peVhv2    (output)   Variante 2                          *
      *     peMtdf    (output)   Marca de Tarifa Diferencial         *
      *     peVhni    (output)   Origen                              *
      *     peVhct    (output)   Tipo                                *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_VHGAUS                                 *
      * ------------------------------------------------------------ *
     P CZWUTL_getDatosCotizVeh...
     P                 B                   export
     D CZWUTL_getDatosCotizVeh...
     D                 pi            10i 0
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peVhca                        2  0
     D  peVhv1                        1  0
     D  peVhv2                        1  0
     D  peMtdf                        1a
     D  peVhni                        1a   options(*nopass:*omit)
     D  peVhct                        2  0 options(*nopass:*omit)

     D k1t204          ds                  likerec(s1t204:*key)

      /free

       CZWUTL_Inz();

       k1t204.t@vhmc = peVhmc;
       k1t204.t@vhmo = peVhmo;
       k1t204.t@vhcs = peVhcs;
       chain %kds(k1t204:3) set204;
       if %found;
          peVhca = t@vhca;
          peVhv1 = t@vhv1;
          peVhv2 = t@vhv2;
          peMtdf = t@mar2;
          if %parms >= 8 and %addr(peVhni) <> *null;
             peVhni = t@vhni;
          endif;
          if %parms >= 9 and %addr(peVhct) <> *null;
             peVhct = t@vhct;
          endif;
          return 0;
       endif;

       SetError( 50007
               : 'Vehículo GAUS no encontrado' );
       return -1;

      /end-free

     P CZWUTL_getDatosCotizVeh...
     P                 E

      * ------------------------------------------------------------ *
      * chkCodigoIva():   Valida código de IVA                       *
      *                                                              *
      *     peCiva    (input)    Código de IVA                       *
      *     peDiva    (output)   Descripción                         *
      *     peNcic    (output)   Descripción corta                   *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_CODIVA                                 *
      * ------------------------------------------------------------ *
     P CZWUTL_chkCodigoIva...
     P                 B                   export
     D CZWUTL_chkCodigoIva...
     D                 pi            10i 0
     D  peCiva                        2  0 const
     D  peDiva                       30a   options(*nopass:*omit)
     D  peNcic                        3a   options(*nopass:*omit)

      /free

       CZWUTL_Inz();

       chain peCiva gntiv1;
       if %found;
          if %parms >= 2 and %addr(peDiva) <> *null;
             peDiva = i1ncil;
          endif;
          if %parms >= 3 and %addr(peNcic) <> *null;
             peNcic = i1ncic;
          endif;
          return 0;
       endif;

       SetError( CZWUTL_ERROR_CODIVA
               : 'No existe inscripción de IVA' );
       return -1;

      /end-free

     P CZWUTL_chkCodigoIva...
     P                 E

      * ------------------------------------------------------------ *
      * chkFormaDePago(): Valida Forma de Pago                       *
      *                                                              *
      *     peCfpg    (input)    Código de Forma de Pago             *
      *     peDfpg    (output)   Descripción                         *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_FORPAG                                 *
      * ------------------------------------------------------------ *
     P CZWUTL_chkFormaDePago...
     P                 B                   export
     D CZWUTL_chkFormaDePago...
     D                 pi            10i 0
     D  peCfpg                        1  0 const
     D  peDfpg                       30a   options(*nopass:*omit)

      /free

       CZWUTL_Inz();

       select;
        when peCfpg = 1;
             if %parms >= 2 and %addr(peDfpg) <> *null;
                peDfpg = 'TARJETA DE CREDITO';
             endif;
             return 0;
        when peCfpg = 2;
             if %parms >= 2 and %addr(peDfpg) <> *null;
                peDfpg = 'DEBITO BANCARIO';
             endif;
             return 0;
        when peCfpg = 4;
             if %parms >= 2 and %addr(peDfpg) <> *null;
                peDfpg = 'EFECTIVO';
             endif;
             return 0;
        other;
             SetError( CZWUTL_ERROR_FORPAG
                     : 'No existe Forma de Pago' );
             return -1;
       endsl;

       SetError( CZWUTL_ERROR_FORPAG
               : 'No existe Forma de Pago' );
       return -1;

      /end-free

     P CZWUTL_chkFormaDePago...
     P                 E

      * ------------------------------------------------------------ *
      * chkTipoPersona(): Valida Tipo de Persona                     *
      *                                                              *
      *     peTipp    (input)    Tipo de Persona                     *
      *     peDipp    (output)   Descripción                         *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_TIPPER                                 *
      * ------------------------------------------------------------ *
     P CZWUTL_chkTipoPersona...
     P                 B                   export
     D CZWUTL_chkTipoPersona...
     D                 pi            10i 0
     D  peTipp                        1a   const
     D  peDipp                       30a   options(*nopass:*omit)

      /free

       CZWUTL_Inz();

       select;
        when peTipp = 'F';
             if %parms >= 2 and %addr(peDipp) <> *null;
                peDipp = 'PERSONA FISICA';
             endif;
             return 0;
        when peTipp = 'J';
             if %parms >= 2 and %addr(peDipp) <> *null;
                peDipp = 'PERSONA JURIDICA';
             endif;
             return 0;
        other;
             SetError( CZWUTL_ERROR_TIPPER
                     : 'Tipo de Persona incorrecta' );
             return -1;
       endsl;

       SetError( CZWUTL_ERROR_TIPPER
               : 'Tipo de Persona incorrecta' );
       return -1;

      /end-free

     P CZWUTL_chkTipoPersona...
     P                 E

      * ------------------------------------------------------------ *
      * chkSumaAsegurada(): Valida Suma Asegurada cero/negativa.     *
      *                                                              *
      *     peVhvu    (input)    Suma Asegurada                      *
      *                                                              *
      * retorna: *on si ok, *off si no.                              *
      *                                                              *
      * Errores: CZWUTL_ERROR_SUMACERO                               *
      * ------------------------------------------------------------ *
     P CZWUTL_chkSumaAsegurada...
     P                 B                   export
     D CZWUTL_chkSumaAsegurada...
     D                 pi             1N
     D  peVhvu                       15  2 const

     D @errm           s             80a
     D @errn           s             10i 0
     D @vhvu           s             15  2
     D rc              s              1N

      /free

       @vhvu = peVhvu;
       // --------------------------
       // Validar suma mínima
       // --------------------------
       rc = SPVVEH_chkSumaMinima( @Vhvu: *omit);
       if (rc = *OFF);
          @errm = SPVVEH_Error(@errn);
          SetError( @errn
                  : @errm );
          return *off;
       endif;

       // --------------------------
       // Validar suma máxima
       // --------------------------
       rc = SPVVEH_chkSumaMaxima( @Vhvu: *omit);
       if (rc = *OFF);
          @errm = SPVVEH_Error(@errn);
          SetError( @errn
                  : @errm );
          return *off;
       endif;

       return *on;

      /end-free

     P CZWUTL_chkSumaAsegurada...
     P                 E

      * ------------------------------------------------------------ *
      * getValorGnc():   Recupera importe de GNC                     *
      *                                                              *
      *     peArcd    (input)    Artículo                            *
      *                                                              *
      * retorna: importe de GNC                                      *
      * ------------------------------------------------------------ *
     P CZWUTL_getValorGnc...
     P                 B                   export
     D CZWUTL_getValorGnc...
     D                 pi             9  2
     D  peArcd                        6  0 const

      /free

       CZWUTL_Inz();

       return SPVVEH_getValGnc ( 'A' : 'CA' );

      /end-free

     P CZWUTL_getValorGnc...
     P                 E

      * ------------------------------------------------------------ *
      * chkIntermediario(): Validar Intermediario                    *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peNivt    (input)    Tipo de Intermediario               *
      *     peNivc    (input)    Código de Intermediario             *
      *                                                              *
      * retorna: *on ok, *off no ok                                  *
      * ------------------------------------------------------------ *
     P CZWUTL_chkIntermediario...
     P                 B                   export
     D CZWUTL_chkIntermediario...
     D                 pi             1N
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const

     D k1hni2          ds                  likerec(s1hni201:*key)

      /free

       CZWUTL_Inz();

       k1hni2.n2empr = peEmpr;
       k1hni2.n2sucu = peSucu;
       k1hni2.n2nivt = peNivt;
       k1hni2.n2nivc = peNivc;
       setll %kds(k1hni2:4) sehni201;
       if %equal;
          return *on;
       endif;

       SetError( CZWUTL_ERROR_INTERM
               : 'No existe intermediario' );
       return *off;

      /end-free

     P CZWUTL_chkIntermediario...
     P                 E

      * ------------------------------------------------------------ *
      * getZonaReal():     Obtiene la Zona de cotizacion.            *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peNivt    (input)    Tipo de Intermediario               *
      *     peNivc    (input)    Código de Intermediario             *
      *     peScta    (input)    Zona                                *
      *                                                              *
      * retorna: Zona para usar, o la misma que peScta               *
      * ------------------------------------------------------------ *
     P CZWUTL_getZonaReal...
     P                 B                   export
     D CZWUTL_getZonaReal...
     D                 pi             1  0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peScta                        1  0 const

     D k1hni41         ds                  likerec(s1hni41:*key)

      /free

       CZWUTL_Inz();

       k1hni41.n4nivt = peNivt;
       k1hni41.n4nivc = peNivc;
       k1hni41.n4scta = peScta;
       chain %kds(k1hni41:3) sehni41;
       if %found;
          return n4ctae;
       endif;

       return peScta;

      /end-free

     P CZWUTL_getZonaReal...
     P                 E

      * ------------------------------------------------------------ *
      * chkAÑoMinimo():    Valida menor año posible de cotizar.      *
      *                                                              *
      *     peAÑo     (input)    Año del vehículo que se cotiza      *
      *                                                              *
      * retorna: *ON OK, *OFF No OK.                                 *
      * ------------------------------------------------------------ *
     P CZWUTL_chkAÑoMinimo...
     P                 B                   EXPORT
     D CZWUTL_chkAÑoMinimo...
     D                 pi             1n
     D  peAÑo                         4  0 const

     D AÑO_MINIMO      C                   1950

      /free

       if (peAÑo < AÑO_MINIMO);
          SetError( CZWUTL_ERROR_ANOMINIMO
                   : 'Año del vehículo inferior al mínimo permitido' );
          return *OFF;
       endif;

       return *ON;

      /end-free

     P CZWUTL_chkAÑoMinimo...
     P                 E

      * ------------------------------------------------------------ *
      * chkDescAltaGama(): Retorna Descuento de Alta Gama            *
      *                                                              *
      *     DEPRECATED: Usar chkDescAltaGama2()                      *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peCobl    (input)    Cobertura                           *
      *     peVhca    (input)    Capítulo                            *
      *     peVhv1    (input)    Variante 1                          *
      *     peVhv2    (input)    Variante 2                          *
      *     peMtdf    (input)    Marca de Tarifa Diferencial         *
      *     peSuma    (input)    Suma Asegurada                      *
      *     peCcbp    (output)   Codigo de Descuento                 *
      *     pePcbp    (output)   % de Descuento                      *
      *                                                              *
      * retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P CZWUTL_chkDescAltaGama...
     P                 B                   Export
     D CZWUTL_chkDescAltaGama...
     D                 pi             1n
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peCobl                        2    const
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1    const
     D  peSuma                       15  2 const
     D  peCcbp                        3  0 options (*Omit:*Nopass)
     D  pePcbp                        5  2 options (*Omit:*Nopass)

      /free

        return CZWUTL_chkDescAltaGama2( peEmpr
                                      : peSucu
                                      : peCobl
                                      : peVhca
                                      : peVhv1
                                      : peVhv2
                                      : peMtdf
                                      : peSuma
                                      : '0'
                                      : peCcbp
                                      : pePcbp  );

      /end-free

     P CZWUTL_chkDescAltaGama...
     P                 E

      * ------------------------------------------------------------ *
      * chkDescAltaGama2(): Retorna Descuento de Alta Gama           *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peCobl    (input)    Cobertura                           *
      *     peVhca    (input)    Capítulo                            *
      *     peVhv1    (input)    Variante 1                          *
      *     peVhv2    (input)    Variante 2                          *
      *     peMtdf    (input)    Marca de Tarifa Diferencial         *
      *     peSuma    (input)    Suma Asegurada                      *
      *     peCond    (input)    Condición del auto                  *
      *                          '1' = 0 KM primer año               *
      *                          '2' = 0 KM segundo año              *
      *                          '0' = No 0 KM                       *
      *     peCcbp    (output)   Codigo de Descuento                 *
      *     pePcbp    (output)   % de Descuento                      *
      *                                                              *
      * retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P CZWUTL_chkDescAltaGama2...
     P                 B                   export
     D CZWUTL_chkDescAltaGama2...
     D                 pi              n
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peCobl                        2    const
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1    const
     D  peSuma                       15  2 const
     D  peCond                        1a   const
     D  peCcbp                        3  0 options (*Omit:*Nopass)
     D  pePcbp                        5  2 options (*Omit:*Nopass)

     D  k1y2254        ds                  likerec ( s1t2254 : *Key )

      /free

        CZWUTL_Inz();

        k1y2254.t@empr = peEmpr;
        k1y2254.t@sucu = peSucu;
        k1y2254.t@cobl = peCobl;
        k1y2254.t@vhca = peVhca;
        k1y2254.t@vhv1 = peVhv1;
        k1y2254.t@vhv2 = peVhv2;
        k1y2254.t@mtdf = peMtdf;

        setll %kds ( k1y2254 : 7 ) set2254;
        reade %kds ( k1y2254 : 7 ) set2254;

        if %eof ( set2254 );

          if %parms >= 10 and %addr ( peCcbp ) <> *Null;
            peCcbp = *Zeros;
          endif;

          if %parms >= 11 and %addr ( pePcbp ) <> *Null;
            pePcbp = *Zeros;
          endif;

          return *Off;

        endif;

        if peSuma < t@paga;

          if %parms >= 10 and %addr ( peCcbp ) <> *Null;
            peCcbp = *Zeros;
          endif;

          if %parms >= 11 and %addr ( pePcbp ) <> *Null;
            pePcbp = *Zeros;
          endif;

          return *Off;

        endif;

        if %parms >= 10 and %addr ( peCcbp ) <> *Null;
          peCcbp = t@ccbp;
        endif;

        if %parms >= 11 and %addr ( pePcbp ) <> *Null;
           select;
            when peCond = '0';
                 pePcbp = t@pcbp;
            when peCond = '1';
                 pePcbp = t@pcb0;
            when peCond = '2';
                 pePcbp = t@pcb0;
            other;
                 pePcbp = t@pcbp;
           endsl;
        endif;

        return *On;

      /end-free

     P CZWUTL_chkDescAltaGama2...
     P                 E

