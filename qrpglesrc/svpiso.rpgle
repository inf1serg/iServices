     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPISO: Programa de Servicio. Sistema iSOL.                  *
      *         RM#03135 Migracion de Cartera Vigente iSol           *
      * ------------------------------------------------------------ *
      * Nestor Nelson                                  * 31-Oct-2018 *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * ************************************************************ *

     Fset107    if   e           k disk    usropn
     Fset102    if   e           k disk    usropn
     Fgntpai    if   e           k disk    usropn
     Fpahedi    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpiso_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      ** - Area del Sistema. ---------------------------- *
     D                sds
     D  usjobn               244    253
     D  ususer               254    263

      * ------------------------------------------------------------ *
      * SVPISO_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPISO_inz      B                   export
     D SVPISO_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set107);
         open set107;
       endif;

       if not %open(set102);
         open set102;
       endif;

       if not %open(gntpai);
         open gntpai;
       endif;

       if not %open(pahedi);
         open pahedi;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPISO_inz      E

      * ------------------------------------------------------------ *
      * SVPISO_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPISO_End      B                   export
     D SVPISO_End      pi

      /free

       close *all;
       initialized = *off;

       return;

      /end-free

     P SVPISO_End      E

      * ------------------------------------------------------------ *
      * SVPISO_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPISO_Error    B                   export
     D SVPISO_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPISO_Error    E

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
      * ------------------------------------------------------------ *
      * SVPISO_getCoberturaIsol :                                    *
      *                                                              *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peCobc   (input)   Código de Cobertura                   *
      *     peCeis   (output)  Código de Cobertura Equivalente iSOL  *
      *     peCedi   (output)  Descripción Cobertura Equivalente iSOL*
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getCoberturaIsol...
     P                 B                   export
     D SVPISO_getCoberturaIsol...
     D                 pi              n
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
     D   peCeis                       9  0
     D   peCedi                      50

     D   k1y107        ds                  likerec( s1t107 : *key )

      /free

       SVPISO_inz();

       k1y107.t@rama = peRama;
       k1y107.t@cobc = peCobc;
       chain %kds( k1y107 ) set107;
       if %found( set107 );
          peCeis = t@Ceis;
          peCedi = t@cobd;
          return *on;
       endif;

       return *off;

      /end-free
     P SVPISO_getCoberturaIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getProductoIsol :                                     *
      *                                                              *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peXpro   (input)   Código de Producto                    *
      *     pePeis   (output)  Código de Producto Equivalente iSOL   *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getProductoIsol...
     P                 B                   export
     D SVPISO_getProductoIsol...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   pePeis                       9  0

     D   k1y102        ds                  likerec( s1t102 : *key )

      /free

       SVPISO_inz();

       k1y102.t@rama = peRama;
       k1y102.t@xpro = peXpro;
       chain %kds( k1y102 ) set102;
       if %found( set102 );
          pePeis = t@Peis;
          return *on;
       endif;

       return *off;

      /end-free
     P SVPISO_getProductoIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getPaisIsol:                                          *
      *                                                              *
      *                                                              *
      *     pePain   (input)   Código de Pais                        *
      *     pePais   (output)  Código de Pais Equivalente iSOL       *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getPaisIsol...
     P                 B                   export
     D SVPISO_getPaisIsol...
     D                 pi              n
     D   pePain                       5  0 const
     D   pePais                       9  0

     D   k1ypai        ds                  likerec( g1tpai : *key )

      /free

       SVPISO_inz();

       k1ypai.papain = pePain;
       chain %kds( k1ypai ) gntpai;
       if %found( gntpai );
          pePais = paPais;
          return *on;
       endif;

       return *off;

      /end-free
     P SVPISO_getPaisIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getSolicitudIsol:                                     *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Código de Superpóliza                 *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Código de Pólizas por Rama            *
      *     peOper   (input)   Número de Operación                   *
      *     pepoli   (input)   Número de Póliza                      *
      *     peSoln   (output)  Número Solicitud ISOL                 *
      *     peFech   (output)  Fecha Solicitud ISOL                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getSolicitudIsol...
     P                 B                   export
     D SVPISO_getSolicitudIsol...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSoln                      18  0
     D   peFech                       8  0

     D   k1yedi        ds                  likerec( p1hedi : *key )

      /free

       SVPISO_inz();

       clear peSoln;
       clear peFech;

       k1yedi.diempr = peEmpr;
       k1yedi.disucu = peSucu;
       k1yedi.diarcd = peArcd;
       k1yedi.dispol = peSpol;
       k1yedi.dirama = peRama;
       k1yedi.diarse = peArse;
       k1yedi.dioper = peOper;
       k1yedi.dipoli = pePoli;
       chain(n) %kds( k1yedi ) pahedi;
       if %found( pahedi );
          peSoln = disoln;
          peFech = didate;
          return *on;
       endif;

       return *off;

      /end-free
     P SVPISO_getSolicitudIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_setSolicitudIsol:                                     *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Código de Superpóliza                 *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Código de Pólizas por Rama            *
      *     peOper   (input)   Número de Operación                   *
      *     pepoli   (input)   Número de Póliza                      *
      *     peSoln   (input)   Número Solicitud ISOL                 *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_setSolicitudIsol...
     P                 B                   export
     D SVPISO_setSolicitudIsol...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSoln                      18  0 const

     D   k1yedi        ds                  likerec( p1hedi : *key )

      /free

       SVPISO_inz();

       k1yedi.diempr = peEmpr;
       k1yedi.disucu = peSucu;
       k1yedi.diarcd = peArcd;
       k1yedi.dispol = peSpol;
       k1yedi.dirama = peRama;
       k1yedi.diarse = peArse;
       k1yedi.dioper = peOper;
       k1yedi.dipoli = pePoli;
       chain(n) %kds( k1yedi ) pahedi;
       if not %found( pahedi );
          diempr = peEmpr;
          disucu = peSucu;
          diarcd = peArcd;
          dispol = peSpol;
          dirama = peRama;
          diarse = peArse;
          dioper = peOper;
          dipoli = pePoli;
          disoln = peSoln;
          dimar1 = '0';
          dimar2 = '0';
          dimar3 = '0';
          dimar4 = '0';
          dimar5 = '0';
          dimar6 = '0';
          dimar7 = '0';
          dimar8 = '0';
          dimar9 = '0';
          dimar0 = '0';
          diuser = ususer;
          didate = %dec(%date():*iso);
          ditime = %dec(%time():*iso);
          write p1hedi;
          return *on;
       endif;

       return *off;

      /end-free
     P SVPISO_setSolicitudIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_updSolicitudIsol:                                     *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Código de Superpóliza                 *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Código de Pólizas por Rama            *
      *     peOper   (input)   Número de Operación                   *
      *     pepoli   (input)   Número de Póliza                      *
      *     peSoln   (update)  Número Solicitud ISOL                 *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_updSolicitudIsol...
     P                 B                   export
     D SVPISO_updSolicitudIsol...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSoln                      18  0 const

     D   k1yedi        ds                  likerec( p1hedi : *key )

      /free

       SVPISO_inz();

       k1yedi.diempr = peEmpr;
       k1yedi.disucu = peSucu;
       k1yedi.diarcd = peArcd;
       k1yedi.dispol = peSpol;
       k1yedi.dirama = peRama;
       k1yedi.diarse = peArse;
       k1yedi.dioper = peOper;
       k1yedi.dipoli = pePoli;
       chain %kds( k1yedi ) pahedi;
       if %found( pahedi );
          disoln = peSoln;
          diuser = ususer;
          didate = %dec(%date():*iso);
          ditime = %dec(%time():*iso);
          update p1hedi;
          return *on;
       endif;

       return *off;

      /end-free
     P SVPISO_updSolicitudIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getFormaPagoIsol...                                   *
      *                                                              *
      *     peFpga   (input)   Código de Forma de Pago GAUS          *
      *     peFpis   (output)  Código de Forma de Pago iSOL          *
      *     peFpdi   (output)  Descripción Forma de Pago iSOL        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getFormaPagoIsol...
     P                 B                   export
     D SVPISO_getFormaPagoIsol...
     D                 pi              n
     D   peFpga                       2  0 const
     D   peFpis                       4  0
     D   peFpdi                      80

      /free

       SVPISO_inz();

       select;
       when peFpga = 01;
         pefpis = 06 ;
         pefpdi = 'Débito automático en Tarjeta de crédito en pesos';

       when peFpga = 02;
         pefpis = 03 ;
         pefpdi = 'Débito automático en Cta. Cte. en pesos';

       when peFpga = 03;
         pefpis = 04 ;
         pefpdi = 'Débito automático en Caja de Ahorro en pesos';

       other;
         pefpis = 0;
         pefpdi = 'Pago por caja - sin datos migración';

       endsl;

       return *on;

      /end-free
     P SVPISO_getFormaPagoIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getCodigoIvaIsol...                                   *
      *                                                              *
      *     peCiga   (input)   Código de Iva GAUS                    *
      *     peCiis   (output)  Código de Iva iSOL                    *
      *     peCidi   (output)  Descripción Código de Iva iSOL        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getCodigoIvaIsol...
     P                 B                   export
     D SVPISO_getCodigoIvaIsol...
     D                 pi              n
     D   peCiga                       2  0 const
     D   peCiis                      30
     D   peCidi                      30

      /free

       SVPISO_inz();

       select;
       when peCiga = 01 ;
            peCiis = 'INSC' ;
            peCidi = 'RESPONSABLE INSCRIPTO';
          return *on;
       when peCiga = 02 ;
            peCiis = 'INEX' ;
            peCidi = 'RESPONS. INSC. EXEN PERCEPCION';
          return *on;
       when peCiga = 03 ;
            peCiis = 'NORE' ;
            peCidi = 'NO RESPONSABLE';
          return *on;
       when peCiga = 04 ;
            peCiis = 'EXEN' ;
            peCidi = 'EXENTO';
          return *on;
       when peCiga = 05 ;
            peCiis = 'CONF' ;
            peCidi = 'CONSUMIDOR FINAL';
          return *on;
       when peCiga = 06 ;
            peCiis = 'MONO' ;
            peCidi = 'CONTRIB DEL REGIMEN SIMPLIFICADO';
          return *on;
       when peCiga = 07 ;
            peCiis = 'SNCA' ;
            peCidi = 'SUJETO NO CATEGORIZADO';
          return *on;
       endsl;

       return *off;

      /end-free
     P SVPISO_getCodigoIvaIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getTipoDocumIsol...                                   *
      *                                                              *
      *     peTdga   (input)   Tipo de Documento GAUS                *
      *     peTdis   (output)  Tipo de Documento iSOL                *
      *     peTddi   (output)  Descripción Tipo de Documento iSOL    *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getTipoDocumIsol...
     P                 B                   export
     D SVPISO_getTipoDocumIsol...
     D                 pi              n
     D   peTdga                       2  0 const
     D   peTdis                      30
     D   peTddi                      30

      /free

       SVPISO_inz();

       select;
       when peTdga = 01 ;
         peTdis = '25' ;
         peTddi = 'LIBRETA DE ENROLAMIENTO';

       when peTdga = 02 ;
         peTdis = '26' ;
         peTddi = 'LIBRETA CIVICA';

       when peTdga = 03 ;
         peTdis = '101' ;
         peTddi = 'C.I. POLIC. FED. ARGENTINA';

       when peTdga = 04 ;
         peTdis = '00';
         peTddi = 'D.N.I.';

       when peTdga = 05 ;
         peTdis = '48';
         peTddi = 'PASAPORTE ARGENTINO';

       other;
         peTdis = '996';
         peTddi = 'No presentó Documentos';

       endsl;

       return *on;

      /end-free
     P SVPISO_getTipoDocumIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getSexoIsol...                                        *
      *                                                              *
      *     peSega   (input)   Código de Sexo GAUS                   *
      *     peSeis   (output)  Código de Sexo iSOL                   *
      *     peSedi   (output)  Descripción Código de Sexo iSOL       *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getSexoIsol...
     P                 B                   export
     D SVPISO_getSexoIsol...
     D                 pi              n
     D   peSega                       1  0 const
     D   peSeis                      30
     D   peSedi                      30

      /free

       SVPISO_inz();

       select;
       when peSega = 1 ;
         peSeis = 'M' ;
         peSedi = 'Masculino';

       when peSega = 2 ;
         peSeis = 'F';
         peSedi = 'Femenino';

       other;
         peSeis = 'N';
         peSedi = 'No informado';

       endsl;

       return *on;

      /end-free
     P SVPISO_getSexoIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getEstCivilIsol...                                    *
      *                                                              *
      *     peEcga   (input)   Código de Estado Civil GAUS           *
      *     peEcis   (output)  Código de Estado Civil iSOL           *
      *     peEcdi   (output)  Descripción Código Estado Civil iSOL  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getEstCivilIsol...
     P                 B                   export
     D SVPISO_getEstCivilIsol...
     D                 pi              n
     D   peEcga                       1  0 const
     D   peEcis                      30
     D   peEcdi                      30

      /free

       SVPISO_inz();

       select;
       when peEcga = 1 ;
         peEcis = 'S' ;
         peEcdi = 'SOLTERO/A';

       when peEcga = 2 ;
         peEcis = 'C' ;
         peEcdi = 'CASADO/A';

       when peEcga = 3 ;
         peEcis = 'D' ;
         peEcdi = 'DIVORCIADO/A';

       when peEcga = 6 ;
         peEcis = 'V' ;
         peEcdi = 'VIUDO/A';

       other;
         peEcis = 'O';
         peEcdi = 'OTRO';

       endsl;

       return *on;

      /end-free
     P SVPISO_getEstCivilIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getProvinciaIsol...                                   *
      *                                                              *
      *     pePvga   (input)   Código de Provincia GAUS              *
      *     pePvis   (output)  Código de Provincia iSOL              *
      *     pePvdi   (output)  Descripción Código de Provincia iSOL  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getProvinciaIsol...
     P                 B                   export
     D SVPISO_getProvinciaIsol...
     D                 pi              n
     D   pePvga                       2  0 const
     D   pePvis                      30
     D   pePvdi                      30

      /free

       SVPISO_inz();

       select;
       when pePvga = 1 or pePvga = 2;
         pePvis = '2' ;
         pePvdi = 'Buenos Aires';

       when pePvga = 20;
         pePvis = '1' ;
         pePvdi = 'Capital Federal';

       when pePvga = 3;
         pePvis = '3' ;
         pePvdi = 'Catamarca';

       when pePvga = 16;
         pePvis = '6' ;
         pePvdi = 'Chaco';

       when pePvga = 17;
         pePvis = '7' ;
         pePvdi = 'Chubut';

       when pePvga = 4;
         pePvis = '4' ;
         pePvdi = 'Córdoba';

       when pePvga = 5;
         pePvis = '5' ;
         pePvdi = 'Corrientes';

       when pePvga = 6;
         pePvis = '8' ;
         pePvdi = 'Entre Ríos';

       when pePvga = 18;
         pePvis = '9' ;
         pePvdi = 'Formosa';

       when pePvga = 7;
         pePvis = '10' ;
         pePvdi = 'Jujuy';

       when pePvga = 19;
         pePvis = '11' ;
         pePvdi = 'La Pampa';

       when pePvga = 8;
         pePvis = '12' ;
         pePvdi = 'La Rioja';

       when pePvga = 9;
         pePvis = '13' ;
         pePvdi = 'Mendoza';

       when pePvga = 21;
         pePvis = '14' ;
         pePvdi = 'Misiones';

       when pePvga = 22;
         pePvis = '15' ;
         pePvdi = 'Neuquen';

       when pePvga = 23;
         pePvis = '16' ;
         pePvdi = 'Río Negro';

       when pePvga = 10;
         pePvis = '17' ;
         pePvdi = 'Salta';

       when pePvga = 11;
         pePvis = '18' ;
         pePvdi = 'San Juan';

       when pePvga = 12;
         pePvis = '19' ;
         pePvdi = 'San Luis';

       when pePvga = 24;
         pePvis = '20' ;
         pePvdi = 'Santa Cruz';

       when pePvga = 13;
         pePvis = '21' ;
         pePvdi = 'Santa Fe';

       when pePvga = 14;
         pePvis = '22' ;
         pePvdi = 'Santiago del Estero';

       when pePvga = 25;
         pePvis = '40' ;
         pePvdi = 'Tierra del Fuego';

       when pePvga = 15;
         pePvis = '23' ;
         pePvdi = 'Tucumán';

       other;
         pePvis = '99';
         pePvdi = 'No informada';

       endsl;

       return *on;

      /end-free
     P SVPISO_getProvinciaIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getCodTarjCredIsol...                                 *
      *                                                              *
      *     peTcga   (input)   Código de Tarjeta de Crédito GAUS     *
      *     peTcis   (output)  Código de Tarjeta de Crédito iSOL     *
      *     peTcdi   (output)  Descripción Tarjeta de Crédito iSOL   *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getCodTarjCredIsol...
     P                 B                   export
     D SVPISO_getCodTarjCredIsol...
     D                 pi              n
     D   peTcga                       3  0 const
     D   peTcis                       9  0
     D   peTcdi                      50

      /free

       SVPISO_inz();

       select;
       when peTcga = 3 ;
            peTcis = 1 ;
            peTcdi = 'MASTERCARD';
          return *on;
       when peTcga = 4 ;
            peTcis = 3 ;
            peTcdi = 'VISA';
          return *on;
       when peTcga = 7 ;
            peTcis = 2 ;
            peTcdi = 'CABAL';
          return *on;
       endsl;

       return *off;

      /end-free
     P SVPISO_getCodTarjCredIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getPlanesIsol...                                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivt   (input)   Código de Intermediario               *
      *     pePlis   (output)  Código de Plan iSOL                   *
      *     pePldi   (output)  Descripción Código de Plan iSOL       *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getPlanesIsol...
     P                 B                   export
     D SVPISO_getPlanesIsol...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   pePlis                       9  0
     D   pePldi                      60

       select;
       when (peNivt = 1 and peNivc = 79594) or (peNivt = 1 and peNivc = 77681);
         pePlis = 301 ;
         pePldi = 'Plan  ' + %char(%dec(pePlis));
         return *on;
       when (peNivt = 1 and peNivc = 77680);
         pePlis = 303 ;
         pePldi = 'Plan  ' + %char(%dec(pePlis));
         return *on;
       endsl;

       return *off;

      /end-free
     P SVPISO_getPlanesIsol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPISO_getMotivoAnulacionIsol...                             *
      *                                                              *
      *     peStou   (input)   Subtipo Operacion Usuario GAUS        *
      *     peCman   (output)  Codigo Motivo de Anulacion iSol       *
      *     peDman   (output)  Descripcion Motivo de Anulacion iSol  *
      *                                                              *
      * Retorna: *on = Si coincide la Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPISO_getMotivoAnulacionIsol...
     P                 B                   export
     D SVPISO_getMotivoAnulacionIsol...
     D                 pi              n
     D   peStou                       2  0 const
     D   peCman                      30
     D   peDman                     100

      /free

       SVPISO_inz();

       select;
       when peStou = 1;
         peCman = '207';
         peDman = 'FALTA DE PAGO';

       when peStou = 2;
         peCman = '110';
         peDman = 'REEMPLAZO';

       when peStou = 3;
         peCman = '203';
         peDman = 'DESISTIMIENTO ASEGURADO';

       when peStou = 4;
         peCman = '112';
         peDman = 'DESISTIMIENTO CIA.';

       other;
         peCman = '296';
         peDman = 'OTRA CAUSA';

       endsl;

       return *on;

      /end-free
     P SVPISO_getMotivoAnulacionIsol...
     P                 E
