     H nomain
      * ************************************************************ *
      * SVPFAC: Programa de Servicio.                                *
      *         Facturas Web                                         *
      * ------------------------------------------------------------ *
      * Segovia Jennifer                  ** 06-Ago-2020 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      *   JSN 15/06/2022 - Se agrega nuevo estado R=Rechazada - Com. *
      * ************************************************************ *
     Fgnttfc    if   e           k disk    usropn
     Fpahiva    uf   e           k disk    usropn
     Fpahivw    uf a e           k disk    usropn
     Fpahivw02  if   e           k disk    usropn rename(p1hivw : p1hivw02)
     Fpahivw01  if   e           k disk    usropn rename(p1hivw : p1hivw01)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpfac_h.rpgle'
      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

     D wrepl           s          65535a

      *--- Definicion de Procedimiento ----------------------------- *
     ?* ------------------------------------------------------------ *
     ?* SVPFAC_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPFAC_inz      B                   export
     D SVPFAC_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahiva);
         open pahiva;
       endif;

       if not %open(pahivw);
         open pahivw;
       endif;

       if not %open(pahivw02);
         open pahivw02;
       endif;

       if not %open(gnttfc);
         open gnttfc;
       endif;

       if not %open(pahivw01);
         open pahivw01;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPFAC_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPFAC_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPFAC_End      B                   export
     D SVPFAC_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPFAC_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPFAC_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPFAC_Error    B                   export
     D SVPFAC_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPFAC_Error    E

      * ------------------------------------------------------------ *
      * SVPFAC_chkFactura: Chequea facturacion                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_chkFactura...
     P                 B                   export
     D SVPFAC_chkFactura...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const

     D   k1yiva        ds                  likerec( p1hiva : *key )

      /free

       SVPFAC_inz();

       k1yiva.ivEmpr = peEmpr;
       k1yiva.ivSucu = peSucu;
       k1yiva.ivComa = peComa;
       k1yiva.ivNrma = peNrma;
       k1yiva.ivFe1a = peFe1a;
       k1yiva.ivFe1m = peFe1m;
       k1yiva.ivFe1d = peFe1d;
       k1yiva.ivC4s2 = peC4s2;
       setll %kds( k1yiva : 8 ) pahiva;
       return %equal( pahiva );

      /end-free

     P SVPFAC_chkFactura...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_getPahivw: Retorna Auditoria de Facturas Web          *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso            (Opcional) *
      *     beFe1m   ( input  ) Mes de Proceso            (Opcional) *
      *     peFe1d   ( input  ) Dia de Proceso            (Opcional) *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza   (Opcional) *
      *     peDsVw   ( output ) Estrutura de Facturas Web (Opcional) *
      *     peDsVwC  ( output ) Cantidad de Facturas Web  (Opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_getPahivw...
     P                 B                   export
     D SVPFAC_getPahivw...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 options( *nopass : *omit ) const
     D   peFe1m                       2  0 options( *nopass : *omit ) const
     D   peFe1d                       2  0 options( *nopass : *omit ) const
     D   peC4s2                       3  0 options( *nopass : *omit ) const
     D   peDsVw                            likeds( dsPahivw_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVwC                     10i 0 options( *nopass : *omit )

     D   k1yivw        ds                  likerec( p1hivw : *key )
     D   @@DsIVw       ds                  likerec( p1hivw : *input )
     D   @@DsVw        ds                  likeds ( dsPahivw_t ) dim( 9999 )
     D   @@DsVwC       s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsVw;
       @@DsVwC = 0;

       k1yivw.pwEmpr = peEmpr;
       k1yivw.pwSucu = peSucu;
       k1yivw.pwComa = peComa;
       k1yivw.pwNrma = peNrma;

       if %parms >= 4;
         Select;
           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) <> *null and
                %addr( peFe1d ) <> *null and
                %addr( peC4s2 ) <> *null;

             k1yivw.pwFe1a = peFe1a;
             k1yivw.pwFe1m = peFe1m;
             k1yivw.pwFe1d = peFe1d;
             k1yivw.pwC4s2 = peC4s2;
             setll %kds( k1yivw : 8 ) pahivw;
             if not %equal( pahivw );
               return *off;
             endif;
             reade(n) %kds( k1yivw : 8 ) pahivw @@DsIVw;
             dow not %eof( pahivw );
               @@DsVwC += 1;
               eval-corr @@DsVw( @@DsVwC ) = @@DsIVw;
               reade(n) %kds( k1yivw : 8 ) pahivw @@DsIVw;
             enddo;

           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) <> *null and
                %addr( peFe1d ) <> *null and
                %addr( peC4s2 ) =  *null;

             k1yivw.pwFe1a = peFe1a;
             k1yivw.pwFe1m = peFe1m;
             k1yivw.pwFe1d = peFe1d;
             setll %kds( k1yivw : 7 ) pahivw;
             if not %equal( pahivw );
               return *off;
             endif;
             reade(n) %kds( k1yivw : 7 ) pahivw @@DsIVw;
             dow not %eof( pahivw );
               @@DsVwC += 1;
               eval-corr @@DsVw( @@DsVwC ) = @@DsIVw;
               reade(n) %kds( k1yivw : 7 ) pahivw @@DsIVw;
             enddo;

           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) <> *null and
                %addr( peFe1d ) =  *null and
                %addr( peC4s2 ) =  *null;

             k1yivw.pwFe1a = peFe1a;
             k1yivw.pwFe1m = peFe1m;
             setll %kds( k1yivw : 6 ) pahivw;
             if not %equal( pahivw );
               return *off;
             endif;
             reade(n) %kds( k1yivw : 6 ) pahivw @@DsIVw;
             dow not %eof( pahivw );
               @@DsVwC += 1;
               eval-corr @@DsVw( @@DsVwC ) = @@DsIVw;
               reade(n) %kds( k1yivw : 6 ) pahivw @@DsIVw;
             enddo;

           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) =  *null and
                %addr( peFe1d ) =  *null and
                %addr( peC4s2 ) =  *null;

             k1yivw.pwFe1a = peFe1a;
             setll %kds( k1yivw : 5 ) pahivw;
             if not %equal( pahivw );
               return *off;
             endif;
             reade(n) %kds( k1yivw : 5 ) pahivw @@DsIVw;
             dow not %eof( pahivw );
               @@DsVwC += 1;
               eval-corr @@DsVw( @@DsVwC ) = @@DsIVw;
               reade(n) %kds( k1yivw : 5 ) pahivw @@DsIVw;
             enddo;

           other;

             setll %kds( k1yivw : 4 ) pahivw;
             if not %equal( pahivw );
               return *off;
             endif;
             reade(n) %kds( k1yivw : 4 ) pahivw @@DsIVw;
             dow not %eof( pahivw );
               @@DsVwC += 1;
               eval-corr @@DsVw( @@DsVwC ) = @@DsIVw;
               reade(n) %kds( k1yivw : 4 ) pahivw @@DsIVw;
             enddo;
         endsl;
       else;

         setll %kds( k1yivw : 4 ) pahivw;
         if not %equal( pahivw );
           return *off;
         endif;
         reade(n) %kds( k1yivw : 4 ) pahivw @@DsIVw;
         dow not %eof( pahivw );
           @@DsVwC += 1;
           eval-corr @@DsVw( @@DsVwC ) = @@DsIVw;
           reade(n) %kds( k1yivw : 4 ) pahivw @@DsIVw;
         enddo;
       endif;

       if %addr( peDsVw ) <> *null;
         eval-corr peDsVw = @@DsVw;
       endif;

       if %addr( peDsVwC ) <> *null;
          peDsVwC = @@DsVwC;
       endif;

       return *on;

      /end-free

     P SVPFAC_getPahivw...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_chkIngreso: Chequea Ingreso de Facturas Web           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_chkIngreso...
     P                 B                   export
     D SVPFAC_chkIngreso...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const

     D x               s             10i 0
     D @@DsVw          ds                  likeds ( dsPahivw_t ) dim( 9999 )
     D @@DsVwC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsVw;
       @@DsVwC = 0;

       if SVPFAC_getPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : @@DsVw
                          : @@DsVwC );

         return *on;
       endif;

       return *off;

      /end-free

     P SVPFAC_chkIngreso...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_getEstadoPahivw: Retorna estado de Facturas Web       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peEsta   ( output ) Código de Estado                     *
      *     peDest   ( output ) Descripción de Estado    (opcional)  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_getEstadoPahivw...
     P                 B                   export
     D SVPFAC_getEstadoPahivw...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peEsta                       1
     D   peDest                      40    options( *nopass : *omit )

     D @@DsVw          ds                  likeds ( dsPahivw_t ) dim( 9999 )
     D @@DsVwC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsVw;
       @@DsVwC = 0;

       if SVPFAC_getPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : @@DsVw
                          : @@DsVwC );

         peEsta = @@DsVw(@@DsVwC).pwEsta;

         if %parms > 9 and %addr( peDest ) <> *null;
           select;
             when peEsta = '1';
               peDest = 'Factura Ingresada';
             when peEsta = '2';
               peDest = 'Factura Descargada - Enviada a analizar';
             when peEsta = '3';
               peDest = 'Factura imputada en la compañia';
             when peEsta = 'E';
               peDest = 'Factura con inconvenientes';
             when peEsta = 'R';
               peDest = 'Rechazada - Comuníquese con Contaduría';
           endsl;
         endif;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPFAC_getEstadoPahivw...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_setIngreso: Graba estado de Facturas Web              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peVarc   ( input  ) Nombre del Archivo                   *
      *     peErro   ( output ) Indicador de Error                   *
      *     PeMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_setIngreso...
     P                 B                   export
     D SVPFAC_setIngreso...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peVarc                     300    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D @@Dest          s             40a
     D @@DsVw          ds                  likeds( dsPahivw_t ) dim( 9999 )
     D @@DsVwC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@Dest;

       if SVPFAC_getPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : @@DsVw
                          : @@DsVwC );

         if ( @@DsVW(@@DsVwC).pwEsta = 'E' and ( @@DsVW(@@DsVwC).pwMar1 <> '1'
            or @@DsVW(@@DsVwC).pwMar1 = '2')) or @@DsVW(@@DsVwC).pwEsta <> 'E';

           @@Dest = SVPDES_estadoDeFactura( @@DsVw(@@DsVwC).pwEsta );
           %subst(wrepl:1:40) = %trim( @@Dest );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'FAC0002'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl)) );
           peErro = -1;
           return *off;
         endif;

         @@DsVw(@@DsVwC).pwEsta = '1';
         @@DsVw(@@DsVwC).pwVarc = %trim(peVarc);
         @@DsVw(@@DsVwC).pwObse = *blanks;
         @@DsVw(@@DsVwC).pwFing = %dec(%date);
         @@DsVw(@@DsVwC).pwHing = %dec(%time);
         @@DsVw(@@DsVwC).pwUing = @PsDs.CurUsr;

         SVPFAC_updFactura( @@DsVw(@@DsVwC) );
         return *on;

       endif;

       if SVPFAC_setPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : peVarc );

         return *on;
       endif;

      /end-free

     P SVPFAC_setIngreso...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_setPahivw: Graba estado de Facturas Web               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peVarc   ( input  ) Nombre del Archivo                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_setPahivw...
     P                 B                   export
     D SVPFAC_setPahivw...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peVarc                     300    const

      /free

       SVPFAC_inz();

       pwEmpr = PeEmpr;
       pwSucu = peSucu;
       pwComa = peComa;
       pwNrma = peNrma;
       pwFe1a = peFe1a;
       pwFe1m = peFe1m;
       pwFe1d = peFe1d;
       pwC4s2 = peC4s2;
       pwVarc = peVarc;
       pwEsta = '1';
       pwFing = %dec(%date);
       pwHing = %dec(%time);
       pwUing = @PsDs.CurUsr;

       write p1hivw;

       return *on;

      /end-free

     P SVPFAC_setPahivw...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_setDescarga: Graba Descarga de Facturas Web           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peCarp   ( input  ) Carpeta de descarga                  *
      *     peErro   ( output ) Indicador de Error                   *
      *     PeMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_setDescarga...
     P                 B                   export
     D SVPFAC_setDescarga...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peCarp                     128    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D x               s             10i 0
     D @@Dest          s             40a
     D @@DsVw          ds                  likeds( dsPahivw_t ) dim( 9999 )
     D @@DsVwC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@Dest;
       clear @@DsVw;
       @@DsVwC = 0;

       if SVPFAC_getPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : @@DsVw
                          : @@DsVwC );

         for x = 1 to @@DsVwC;
           if @@DsVw(x).pwEsta <> '1';
             @@Dest = SVPDES_estadoDeFactura( @@DsVw(x).pwEsta );
             %subst(wrepl:1:40) = %trim( @@Dest );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'FAC0005'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             SVPFAC_setErrorPahivw( @@DsVw(x).pwEmpr
                                  : @@DsVw(x).pwSucu
                                  : @@DsVw(x).pwComa
                                  : @@DsVw(x).pwNrma
                                  : @@DsVw(x).pwFe1a
                                  : @@DsVw(x).pwFe1m
                                  : @@DsVw(x).pwFe1d
                                  : @@DsVw(x).pwC4s2
                                  : peMsgs.peMsg1 );

             peErro = -1;
             return *off;
           else;
             @@DsVw(x).pwEsta = '2';
             @@DsVw(x).pwCarp = %trim(peCarp);
             @@DsVw(x).pwFifs = %dec(%date);
             @@DsVw(x).pwHifs = %dec(%time);
             @@DsVw(x).pwUifs = @PsDs.CurUsr;

             SVPFAC_updFactura( @@DsVw(x) );
             return *on;
           endif;
         endfor;
       endif;

       SVPWS_getMsgs( '*LIBL'
                    : 'WSVMSG'
                    : 'FAC0006'
                    : peMsgs
                    : %trim(wrepl)
                    : %len(%trim(wrepl))  );

       peErro = -1;
       return *off;

      /end-free

     P SVPFAC_setDescarga...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_setVuelta: Graba Vuelta de Facturas Web               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peErro   ( output ) Indicador de Error                   *
      *     PeMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_setVuelta...
     P                 B                   export
     D SVPFAC_setVuelta...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D x               s             10i 0
     D @@Dest          s             40a
     D @@DsVw          ds                  likeds( dsPahivw_t ) dim( 9999 )
     D @@DsVwC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@Dest;
       clear @@DsVw;
       @@DsVwC = 0;

       if SVPFAC_getPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : @@DsVw
                          : @@DsVwC );

         for x = 1 to @@DsVwC;
           if @@DsVw(x).pwEsta <> '2';
             @@Dest = SVPDES_estadoDeFactura( @@DsVw(x).pwEsta );
             %subst(wrepl:1:40) = %trim( @@Dest );

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'FAC0007'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             SVPFAC_setErrorPahivw( peEmpr
                                  : peSucu
                                  : peComa
                                  : peNrma
                                  : peFe1a
                                  : peFe1m
                                  : peFe1d
                                  : peC4s2
                                  : peMsgs.peMsg1 );

             peErro = -1;
             return *off;

           else;
             @@DsVw(x).pwEsta = '3';
             @@DsVw(x).pwFvue = %dec(%date);
             @@DsVw(x).pwHvue = %dec(%time);
             @@DsVw(x).pwUvue = @PsDs.CurUsr;

             SVPFAC_updFactura( @@DsVw(x) );
             return *on;
           endif;
         endfor;
       endif;

       SVPWS_getMsgs( '*LIBL'
                    : 'WSVMSG'
                    : 'FAC0006'
                    : peMsgs
                    : %trim(wrepl)
                    : %len(%trim(wrepl))  );

       peErro = -1;
       return *off;

      /end-free

     P SVPFAC_setVuelta...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_setErrorPahivw: Graba Error en Facturas Web           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peMsgs   ( input  ) Estructura de Error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_setErrorPahivw...
     P                 B                   export
     D SVPFAC_setErrorPahivw...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peMsge                     100    const

     D x               s             10i 0
     D @@DsVw          ds                  likeds( dsPahivw_t ) dim( 9999 )
     D @@DsVwC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsVw;
       @@DsVwC = 0;

       if SVPFAC_getPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : @@DsVw
                          : @@DsVwC );

         for x = 1 to @@DsVwC;
           @@DsVw(x).pwMar1 = @@DsVw(x).pwEsta;
           @@DsVw(x).pwEsta = 'E';
           @@DsVw(x).pwObse = %trim( peMsge );
           SVPFAC_updFactura( @@DsVw(x) );
         endfor;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPFAC_setErrorPahivw...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_updFactura: Actualiza Facturas Web                    *
      *                                                              *
      *     peDsVw   ( input  ) Estructura de Facturas Web           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_updFactura...
     P                 B                   export
     D SVPFAC_updFactura...
     D                 pi              n
     D   peDsVw                            likeds( dsPahivw_t ) const

     D k1yivw          ds                  likerec( p1hivw : *key )
     D dsOivw          ds                  likerec( p1hivw : *output )

      /free

       SVPFAC_inz();

       k1yivw.pwEmpr = peDsVw.pwEmpr;
       k1yivw.pwSucu = peDsVw.pwSucu;
       k1yivw.pwComa = peDsVw.pwComa;
       k1yivw.pwNrma = peDsVw.pwNrma;
       k1yivw.pwFe1a = peDsVw.pwFe1a;
       k1yivw.pwFe1m = peDsVw.pwFe1m;
       k1yivw.pwFe1d = peDsVw.pwFe1d;
       k1yivw.pwC4s2 = peDsVw.pwC4s2;
       chain %kds( k1yivw : 8 ) pahivw;
       if %found( pahivw );
         eval-corr dsOIvw = peDsVw;
         update p1hivw dsOIvw;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPFAC_updFactura...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_getTipoDeComprobante: Retorna datos del tipo de       *
      *                              comprobante                     *
      *                                                              *
      *     peTifa   ( input  ) Tipo de Comprobante (Opcional)       *
      *     peDsTc   ( output ) Estructura de Tipo de Comprobante    *
      *     peDsTcC  ( output ) Cantidad de Tipos                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_getTipoDeComprobante...
     P                 B                   export
     D SVPFAC_getTipoDeComprobante...
     D                 pi              n
     D   peTifa                       2  0 options( *nopass : *omit ) const
     D   peDsTc                            options( *nopass : *omit )
     D                                     likeds( dsGnttfc_t ) dim( 99 )
     D   peDsTcC                     10i 0 options( *nopass : *omit )

     D @@DsITc         ds                  likerec( g1ttfc : *input )
     D @@DsTc          ds                  likeds ( dsGnttfc_t ) dim( 99 )
     D @@DsTcC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsTc;
       @@DsTcC = 0;

       if %addr( peTifa ) <> *null;
         chain(n) peTifa gnttfc @@DsITc;
         if not %found( gnttfc );
           return *off;
         endif;
         @@DsTcC = 1;
       else;
         setll *loval gnttfc;
         read(n) gnttfc @@DsItc;
         dow not %eof( gnttfc );
           @@DsTcC += 1;
           eval-corr @@DsTc(@@DsTcC) = @@DsITc;
           read(n) gnttfc @@DsItc;
         enddo;
       endif;

       if %addr( peDsTc ) <> *null;
         eval-corr peDsTc = @@DsTc;
       endif;

       if %addr( peDsTcC ) <> *null;
         peDsTcC = @@DsTcC;
       endif;

       return *on;

      /end-free

     P SVPFAC_getTipoDeComprobante...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_chkTipoDeFactura: Chequea que exista el tipo de       *
      *                          comprobante                         *
      *                                                              *
      *     peTifa   ( input  ) Tipo de Comprobante                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_chkTipoDeFactura...
     P                 B                   export
     D SVPFAC_chkTipoDeFactura...
     D                 pi              n
     D   peTifa                       2  0 const

     D @@DsTc          ds                  likeds ( dsGnttfc_t ) dim( 99 )
     D @@DsTcC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsTc;
       @@DsTcC = 0;

       if SVPFAC_getTipoDeComprobante( peTifa
                                     : @@DsTc
                                     : @@DsTcC );

         return *on;
       endif;

       return *off;

      /end-free

     P SVPFAC_chkTipoDeFactura...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_getPahivwXArchivo: Retorna Datos de la factura Web    *
      *                           por nombre del archivo             *
      *                                                              *
      *     peVarc   ( input  ) Nombre del Archivo        (opcional) *
      *     peDsVw   ( output ) Estrutura de Facturas Web (opcional) *
      *     peDsVwC  ( output ) Cantidad de Facturas Web  (opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_getPahivwXArchivo...
     P                 B                   export
     D SVPFAC_getPahivwXArchivo...
     D                 pi              n
     D   peVarc                     300    options( *nopass : *omit ) const
     D   peDsVw                            likeds( dsPahivw_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVwC                     10i 0 options( *nopass : *omit )

     D   url           s           3000a   varying
     D   nom1          s             40a
     D   nom2          s             40a
     D   empr          s              1a
     D   sucu          s              2a
     D   coma          s              2a
     D   nrma          s              7a
     D   fe1a          s              4a
     D   fe1m          s              2a
     D   fe1d          s              2a
     D   c4s2          s              3a
     D   cuit          s             11a
     D   extn          s             10a
     D   @@nrma        s              7  0
     D   @@fe1a        s              4  0
     D   @@fe1m        s              2  0
     D   @@fe1d        s              2  0
     D   @@c4s2        s              3  0
     D   @@DsIVw       ds                  likerec( p1hivw : *input )
     D   @@DsVw        ds                  likeds ( dsPahivw_t ) dim( 9999 )
     D   @@DsVwC       s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsVw;
       @@DsVwC = 0;

       if %parms >= 1 and %addr( peVarc ) <> *null;

         url = %trim(peVarc);

         nom1 =  REST_getNextPart( url : '_' );
         nom2 =  REST_getNextPart( url : '_' );
         empr =  REST_getNextPart( url : '_' );
         sucu =  REST_getNextPart( url : '_' );
         coma =  REST_getNextPart( url : '_' );
         nrma =  REST_getNextPart( url : '_' );
         fe1a =  REST_getNextPart( url : '_' );
         fe1m =  REST_getNextPart( url : '_' );
         fe1d =  REST_getNextPart( url : '_' );
         c4s2 =  REST_getNextPart( url : '_' );
         cuit =  REST_getNextPart( url : '.' );
         extn =  '.' + REST_getNextPart( url : '_' );

         if %check('0123456789':%trim(nrma)) <> *zeros;
           @@nrma = 0;
         else;
            monitor;
              @@nrma = %int( %trim(nrma) );
            on-error;
              @@nrma = 0;
            endmon;
         endif;

         if %check('0123456789':%trim(fe1a)) <> *zeros;
            @@fe1a = 0;
         else;
            monitor;
              @@fe1a = %int( %trim(fe1a) );
            on-error;
              @@fe1a = 0;
            endmon;
         endif;

         if %check('0123456789':%trim(fe1m)) <> *zeros;
            @@fe1m = 0;
         else;
            monitor;
              @@fe1m = %int( %trim(fe1m) );
            on-error;
              @@fe1m = 0;
            endmon;
         endif;

         if %check('0123456789':%trim(fe1d)) <> *zeros;
            @@fe1d = 0;
         else;
            monitor;
              @@fe1d = %int( %trim(fe1d) );
            on-error;
              @@fe1d = 0;
            endmon;
         endif;

         if %check('0123456789':%trim(c4s2)) <> *zeros;
            @@c4s2 = 0;
         else;
           monitor;
             @@c4s2 = %int( %trim(c4s2) );
           on-error;
             @@c4s2 = 0;
           endmon;
         endif;

         if not SVPFAC_getPahivw( Empr
                                : Sucu
                                : Coma
                                : @@Nrma
                                : @@Fe1a
                                : @@Fe1m
                                : @@Fe1d
                                : @@C4s2
                                : @@DsVw
                                : @@DsVwC );

           return *off;
         endif;

         @@DsVw( @@DsVwC ).pwCuit = %trim(cuit);
         SVPFAC_updFactura( @@DsVw(@@DsVwC) );
       else;

         setll *loval pahivw;
         read(n) pahivw @@DsIVw;
         dow not %eof( pahivw );
           @@DsVwC += 1;
           eval-corr @@DsVw( @@DsVwC ) = @@DsIVw;
           read(n) pahivw @@DsIVw;
         enddo;
       endif;

       if %addr( peDsVw ) <> *null;
         eval-corr peDsVw = @@DsVw;
       endif;

       if %addr( peDsVwC ) <> *null;
          peDsVwC = @@DsVwC;
       endif;

       return *on;

      /end-free

     P SVPFAC_getPahivwXArchivo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_updPahiva: Actualiza datos en el archivo pahiva       *
      *                                                              *
      *     peDsIv   ( input  ) Estrutura de Pahiva                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_updPahiva...
     P                 B                   export
     D SVPFAC_updPahiva...
     D                 pi              n
     D   peDsIv                            likeds( dsPahiva_t ) const

     D k1yiva          ds                  likerec( p1hiva : *key )
     D dsOiva          ds                  likerec( p1hiva : *output )

      /free

       SVPFAC_inz();

       k1yiva.ivEmpr = peDsIv.ivEmpr;
       k1yiva.ivSucu = peDsIv.ivSucu;
       k1yiva.ivComa = peDsIv.ivComa;
       k1yiva.ivNrma = peDsIv.ivNrma;
       k1yiva.ivFe1a = peDsIv.ivFe1a;
       k1yiva.ivFe1m = peDsIv.ivFe1m;
       k1yiva.ivFe1d = peDsIv.ivFe1d;
       k1yiva.ivC4s2 = peDsIv.ivC4s2;
       chain %kds( k1yiva : 8 ) pahiva;
       if %found( pahiva );
         eval-corr dsOIva = peDsIv;
         update p1hiva dsOIva;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPFAC_updPahiva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_getPahiva: Retorna datos de Pahiva                    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso            (Opcional) *
      *     beFe1m   ( input  ) Mes de Proceso            (Opcional) *
      *     peFe1d   ( input  ) Dia de Proceso            (Opcional) *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza   (Opcional) *
      *     peDsVa   ( output ) Estrutura de Pahiva       (Opcional) *
      *     peDsVaC  ( output ) Cantidad de registros     (Opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_getPahiva...
     P                 B                   export
     D SVPFAC_getPahiva...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 options( *nopass : *omit ) const
     D   peFe1m                       2  0 options( *nopass : *omit ) const
     D   peFe1d                       2  0 options( *nopass : *omit ) const
     D   peC4s2                       3  0 options( *nopass : *omit ) const
     D   peDsVa                            likeds( dsPahiva_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVaC                     10i 0 options( *nopass : *omit )

     D   k1yiva        ds                  likerec( p1hiva : *key )
     D   @@DsIVa       ds                  likerec( p1hiva : *input )
     D   @@DsVa        ds                  likeds ( dsPahiva_t ) dim( 9999 )
     D   @@DsVaC       s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsVa;
       @@DsVaC = 0;

       k1yiva.ivEmpr = peEmpr;
       k1yiva.ivSucu = peSucu;
       k1yiva.ivComa = peComa;
       k1yiva.ivNrma = peNrma;

       if %parms >= 4;
         Select;
           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) <> *null and
                %addr( peFe1d ) <> *null and
                %addr( peC4s2 ) <> *null;

             k1yiva.ivFe1a = peFe1a;
             k1yiva.ivFe1m = peFe1m;
             k1yiva.ivFe1d = peFe1d;
             k1yiva.ivC4s2 = peC4s2;
             setll %kds( k1yiva : 8 ) pahiva;
             if not %equal( pahiva );
               return *off;
             endif;
             reade(n) %kds( k1yiva : 8 ) pahiva @@DsIVa;
             dow not %eof( pahiva );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
               reade(n) %kds( k1yiva : 8 ) pahiva @@DsIVa;
             enddo;

           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) <> *null and
                %addr( peFe1d ) <> *null and
                %addr( peC4s2 ) =  *null;

             k1yiva.ivFe1a = peFe1a;
             k1yiva.ivFe1m = peFe1m;
             k1yiva.ivFe1d = peFe1d;
             setll %kds( k1yiva : 7 ) pahiva;
             if not %equal( pahiva );
               return *off;
             endif;
             reade(n) %kds( k1yiva : 7 ) pahiva @@DsIVa;
             dow not %eof( pahiva );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
               reade(n) %kds( k1yiva : 7 ) pahiva @@DsIVa;
             enddo;

           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) <> *null and
                %addr( peFe1d ) =  *null and
                %addr( peC4s2 ) =  *null;

             k1yiva.ivFe1a = peFe1a;
             k1yiva.ivFe1m = peFe1m;
             setll %kds( k1yiva : 6 ) pahiva;
             if not %equal( pahiva );
               return *off;
             endif;
             reade(n) %kds( k1yiva : 6 ) pahiva @@DsIVa;
             dow not %eof( pahiva );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
               reade(n) %kds( k1yiva : 6 ) pahiva @@DsIVa;
             enddo;

           when %addr( peFe1a ) <> *null and
                %addr( peFe1m ) =  *null and
                %addr( peFe1d ) =  *null and
                %addr( peC4s2 ) =  *null;

             k1yiva.ivFe1a = peFe1a;
             setll %kds( k1yiva : 5 ) pahiva;
             if not %equal( pahiva );
               return *off;
             endif;
             reade(n) %kds( k1yiva : 5 ) pahiva @@DsIVa;
             dow not %eof( pahiva );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
               reade(n) %kds( k1yiva : 5 ) pahiva @@DsIVa;
             enddo;

           other;

             setll %kds( k1yiva : 4 ) pahiva;
             if not %equal( pahiva );
               return *off;
             endif;
             reade(n) %kds( k1yiva : 4 ) pahiva @@DsIVa;
             dow not %eof( pahiva );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
               reade(n) %kds( k1yiva : 4 ) pahiva @@DsIVa;
             enddo;
         endsl;
       else;

         setll %kds( k1yiva : 4 ) pahiva;
         if not %equal( pahiva );
           return *off;
         endif;
         reade(n) %kds( k1yiva : 4 ) pahiva @@DsIVa;
         dow not %eof( pahiva );
           @@DsVaC += 1;
           eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
           reade(n) %kds( k1yiva : 4 ) pahiva @@DsIVa;
         enddo;
       endif;

       if %addr( peDsVa ) <> *null;
         eval-corr peDsVa = @@DsVa;
       endif;

       if %addr( peDsVaC ) <> *null;
          peDsVaC = @@DsVaC;
       endif;

       return *on;

      /end-free

     P SVPFAC_getPahiva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_getPahivwXArcFnet: Retorna Datos de la factura Web    *
      *                           por nombre del archivo de Filenet  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peVarc   ( input  ) Nombre del Archivo                   *
      *     peDsVw   ( output ) Estrutura de Facturas Web            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_getPahivwXArcFnet...
     P                 B                   export
     D SVPFAC_getPahivwXArcFnet...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peVarc                     300    const
     D   peDsVw                            likeds( dsPahivw_t )

     D   k1yIvw        ds                  likerec( p1hivw01 : *key   )
     D   @@DsIvw       ds                  likerec( p1hivw01 : *input )

      /free

       SVPFAC_inz();

       clear peDsVw;

       k1yivw.pwEmpr = peEmpr;
       k1yivw.pwSucu = peSucu;
       k1yivw.pwVarc = peVarc;
       chain(n) %kds(k1yivw : 3 ) pahivw01 @@DsIvw ;
        if %found( pahivw01 );
            eval-corr peDsVw = @@DsIVw;
        else;
           return *off;
        endif;

       return *on;

      /end-free

     P SVPFAC_getPahivwXArcFnet...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFAC_getEstadoAnterior: Retorna estado de Facturas Web     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peEsta   ( output ) Código de Estado                     *
      *     peDest   ( output ) Descripción de Estado    (opcional)  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPFAC_getEstadoAnterior...
     P                 B                   export
     D SVPFAC_getEstadoAnterior...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peEsta                       1
     D   peDest                      40    options( *nopass : *omit )

     D @@DsVw          ds                  likeds ( dsPahivw_t ) dim( 9999 )
     D @@DsVwC         s             10i 0

      /free

       SVPFAC_inz();

       clear @@DsVw;
       @@DsVwC = 0;

       if SVPFAC_getPahivw( peEmpr
                          : peSucu
                          : peComa
                          : peNrma
                          : peFe1a
                          : peFe1m
                          : peFe1d
                          : peC4s2
                          : @@DsVw
                          : @@DsVwC );

         peEsta = @@DsVw(@@DsVwC).pwMar1;

         if %parms > 9 and %addr( peDest ) <> *null;
           select;
             when peEsta = '1';
               peDest = 'Factura Ingresada';
             when peEsta = '2';
               peDest = 'Factura Descargada - Enviada a analizar';
             when peEsta = '3';
               peDest = 'Factura imputada en la compañia';
             when peEsta = 'E';
               peDest = 'Factura con inconvenientes';
             when peEsta = 'R';
               peDest = 'Rechazada - Comuníquese con Contaduría';
           endsl;
         endif;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPFAC_getEstadoAnterior...
     P                 E

