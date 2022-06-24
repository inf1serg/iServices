     H nomain
     H datedit(*DMY/)
     * ************************************************************ *
     * SVPVLO: Programa de Servicio.                                *
     *         Ingreso de Valores                                   *
     * ------------------------------------------------------------ *
     * Gomez Luis Roberto                   15-11-2018              *
     *------------------------------------------------------------- *
     * Modificaciones:                                              *
     *  JSN 18/09/2020 - Nuevos Procedimientos:                     *
     *                    _getNumeroOperacion                       *
     *                    _getNumeroIngreso                         *
     *                    _getFechaDeIngreso                        *
     * ************************************************************ *
     Fivt001    if   e           k disk    usropn
     Fivt002    if   e           k disk    usropn
     Fivt004    if   e           k disk    usropn
     Fivt00501  if   e           k disk    usropn
     Fivt006    if   e           k disk    usropn
     Fivt007    if   e           k disk    usropn
     Fivhcar    uf a e           k disk    usropn
     Fivhval    uf a e           k disk    usropn

     *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpvlo_h.rpgle'

     * ------------------------------------------------------------ *
     * Setea error global                                           *
     * ------------------------------------------------------------ *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     *--- PR Externos --------------------------------------------- *
     D CA0112          pr                  extpgm('CA0112')
     D  peIvop                        7  0

     D CA01121         pr                  extpgm('CA01121')
     D  peIvni                        6  0

     D CA01122         pr                  extpgm('CA01122')
     D  peIc1a                        4  0
     D  peIc1m                        2  0
     D  peIc1d                        2  0

     *--- Definicion de Procedimiento ----------------------------- *

     * ------------------------------------------------------------ *
     * SVPVLO_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     P SVPVLO_inz      B                   export
     D SVPVLO_inz      pi

      /free

       if not %open(ivt001);
          open ivt001;
       endif;

       if not %open(ivt002);
          open ivt002;
       endif;

       if not %open(ivt004);
          open ivt004;
       endif;

       if not %open(ivt00501);
          open ivt00501;
       endif;

       if not %open(ivt006);
          open ivt006;
       endif;

       if not %open(ivt007);
          open ivt007;
       endif;

       if not %open(ivhval);
          open ivhval;
       endif;

       if not %open(ivhcar);
          open ivhcar;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPVLO_inz      E

     * ------------------------------------------------------------ *
     * SVPVLO_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     P SVPVLO_End      B                   export
     D SVPVLO_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPVLO_End      E

     * ------------------------------------------------------------ *
     * SVPVLO_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     P SVPVLO_Error    B                   export
     D SVPVLO_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

      if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
     endif;

       return ErrM;

      /end-free

     P SVPVLO_Error    E

     * ------------------------------------------------------------ *
     * SetError(): Setea último error y mensaje.                    *
     *                                                              *
     *     peErrn   (input)   Número de error a setear.             *
     *     peErrm   (input)   Texto del mensaje.                    *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *

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

     * ------------------------------------------------------------ *
     * SVPVLO_chkTipoDeMovimientos: Validar tipo de movimiento      *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvtm   ( input  )   Tipo de Movimiento    ( opcional ) *
     *                                                              *
     * Retorna: *on = Encontró / *off = No encontró                 *
     * ------------------------------------------------------------ *
     P SVPVLO_chkTipoDeMovimientos...
     P                 b                   export
     D SVPVLO_chkTipoDeMovimientos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvtm                       2  0 const

     D   k1yiv1        ds                  likerec( i1t001 : *key )

      /free

       SVPVLO_inz();

       k1yiv1.t1empr = peEmpr;
       k1yiv1.t1sucu = peSucu;
       k1yiv1.t1ivtm = peIvtm;
       setll %kds( k1yiv1 : 3 ) ivt001;

       return %equal();

      /end-free

     P SVPVLO_chkTipoDeMovimientos...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_getTipoDeMovimientos: Retorna tipos de movimientos    *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvtm   ( input  )   Tipo de Movimiento    ( opcional ) *
     *     peDsT1   ( output )   Estr. T.  Movimientos ( opcional ) *
     *     peDsT1C  ( output )   Cantidad  Movimientos ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_getTipoDeMovimientos...
     P                 b                   export
     D SVPVLO_getTipoDeMovimientos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvtm                       2  0 options( *nopass : *omit ) const
     D   peDsT1                            likeds( dsIvt001_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsT1C                     10i 0 options( *nopass : *omit )

     D   k1yiv1        ds                  likerec( i1t001 : *key   )
     D   @@DsIT1       ds                  likerec( i1t001 : *input )
     D   @@DsT1        ds                  likeds( dsIvt001_t ) dim( 9999 )
     D   @@DsT1C       s             10  0

      /free

       SVPVLO_inz();

       k1yiv1.t1empr = peEmpr;
       k1yiv1.t1sucu = peSucu;

       if %parms >= 3;
         Select;
           when %addr( peivtm ) <> *null;
             k1yiv1.t1ivtm = peIvtm;
             setll %kds( k1yiv1 : 3 ) ivt001;
             if not %equal( ivt001 );
               return *off;
             endif;
             reade(n) %kds( k1yiv1 : 3 ) ivt001 @@DsIT1;
             dow not %eof( ivt001 );
               @@DsT1C += 1;
               eval-corr @@DsT1( @@DsT1C ) = @@DsIT1;
              reade(n) %kds( k1yiv1 : 3 ) ivt001 @@DsIT1;
             enddo;
           other;
             setll %kds( k1yiv1 : 2 ) ivt001;
             if not %equal( ivt001 );
               return *off;
             endif;
             reade(n) %kds( k1yiv1 : 2 ) ivt001 @@DsIT1;
             dow not %eof( ivt001 );
               @@DsT1C += 1;
               eval-corr @@DsT1( @@DsT1C ) = @@DsIT1;
              reade(n) %kds( k1yiv1 : 2 ) ivt001 @@DsIT1;
             enddo;
         endsl;
       else;
         setll %kds( k1yiv1 : 2 ) ivt001;
         if not %equal( ivt001 );
           return *off;
         endif;
         reade(n) %kds( k1yiv1 : 2 ) ivt001 @@DsIT1;
         dow not %eof( ivt001 );
           @@DsT1C += 1;
           eval-corr @@DsT1( @@DsT1C ) = @@DsIT1;
          reade(n) %kds( k1yiv1 : 2 ) ivt001 @@DsIT1;
         enddo;
       endif;

       if %addr( peDsT1 ) <> *null;
         eval-corr peDsT1 = @@DsT1;
       endif;

       if %addr( peDsT1C ) <> *null;
          peDsT1C = @@DsT1C;
       endif;

       return *on;

      /end-free

     P SVPVLO_getTipoDeMovimientos...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_getRegistroDeControl: Retorna informacion de Registro *
     *                              de Control                      *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peDsT2   ( output )   Estr. Reg. de Control ( opcional ) *
     *     peDsT2C  ( output )   Cantidad R.de Control ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_getRegistroDeControl...
     P                 b                   export
     D SVPVLO_getRegistroDeControl...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsT2                            likeds( dsIvt002_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsT2C                     10i 0 options( *nopass : *omit )

     D   k1yiv2        ds                  likerec( i1t002 : *key   )
     D   @@DsIT2       ds                  likerec( i1t002 : *input )
     D   @@DsT2        ds                  likeds ( dsIvt002_t ) dim( 9999 )
     D   @@DsT2C       s             10  0

      /free

       SVPVLO_inz();

       k1yiv2.t2empr = peEmpr;
       k1yiv2.t2sucu = peSucu;

       setll %kds( k1yiv2 : 2 ) ivt002;
       if not %equal( ivt002 );
         return *off;
       endif;
       reade(n) %kds( k1yiv2 : 2 ) ivt002 @@DsIT2;
       dow not %eof( ivt002 );
         @@DsT2C += 1;
         eval-corr @@DsT2( @@DsT2C ) = @@DsIT2;
        reade(n) %kds( k1yiv2 : 2 ) ivt002 @@DsIT2;
       enddo;

       if %addr( peDsT2 ) <> *null;
         eval-corr peDsT2 = @@DsT2;
       endif;

       if %addr( peDsT2C ) <> *null;
          peDsT2C = @@DsT2C;
       endif;

       return *on;

      /end-free

     P SVPVLO_getRegistroDeControl...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_chkCaratula : Valida Caratula de un ingreso de Valores*
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion                *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_chkCaratula...
     P                 b                   export
     D SVPVLO_chkCaratula...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 const

     D   k1yCar        ds                  likerec( i1hcar : *key   )

      /free

       SVPVLO_inz();

       k1yCar.caempr = peEmpr;
       k1yCar.casucu = peSucu;
       k1ycar.caivop = peIvop;
       setll %kds( k1yCar : 3 ) ivhcar;
       if not %equal( ivhcar );
         return *off;
       endif;

       return *on;

      /end-free

     P SVPVLO_chkCaratula...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_getCaratulas:Retorna Caratula de un ingreso de Valores*
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion   ( opcional ) *
     *     peDsCa   ( output )   Estr. T.  Caratulas   ( opcional ) *
     *     peDsCaC  ( output )   Cantidad  Caratuals   ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_getCaratulas...
     P                 b                   export
     D SVPVLO_getCaratulas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 options( *nopass : *omit ) const
     D   peDsCa                            likeds( dsIvhcar_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsCaC                     10i 0 options( *nopass : *omit )

     D   k1yCar        ds                  likerec( i1hcar : *key   )
     D   @@DsICa       ds                  likerec( i1hcar : *input )
     D   @@DsCa        ds                  likeds( dsIvhcar_t ) dim( 9999 )
     D   @@DsCaC       s             10  0

      /free

       SVPVLO_inz();

       k1yCar.caempr = peEmpr;
       k1yCar.casucu = peSucu;

       if %parms >= 3;
         Select;
           when %addr( peIvop ) <> *null;
             k1ycar.caivop = peIvop;
             setll %kds( k1yCar : 3 ) ivhcar;
             if not %equal( ivhcar );
               return *off;
             endif;
             reade(n) %kds( k1yCar : 3 ) ivhcar @@DsICa;
             dow not %eof( ivhcar );
               @@DsCaC += 1;
               eval-corr @@DsCa( @@DsCaC ) = @@DsICa;
              reade(n) %kds( k1yCar : 3 ) ivhcar @@DsICa;
             enddo;
           other;
             setll %kds( k1yCar : 2 ) ivhcar;
             if not %equal( ivhcar );
               return *off;
             endif;
             reade(n) %kds( k1yCar : 2 ) ivhcar @@DsICa;
             dow not %eof( ivhcar );
               @@DsCaC += 1;
               eval-corr @@DsCa( @@DsCaC ) = @@DsICa;
              reade(n) %kds( k1yCar : 2 ) ivhcar @@DsICa;
             enddo;
         endsl;
       else;
         setll %kds( k1yCar : 2 ) ivhcar;
         if not %equal( ivhcar );
           return *off;
         endif;
         reade(n) %kds( k1yCar : 2 ) ivhcar @@DsICa;
         dow not %eof( ivhcar );
           @@DsCaC += 1;
           eval-corr @@DsCa( @@DsCaC ) = @@DsICa;
          reade(n) %kds( k1yCar : 2 ) ivhcar @@DsICa;
         enddo;
       endif;

       if %addr( peDsCa ) <> *null;
         eval-corr peDsCa = @@DsCa;
       endif;

       if %addr( peDsCaC ) <> *null;
          peDsCaC = @@DsCaC;
       endif;

       return *on;

      /end-free

     P SVPVLO_getCaratulas...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_setCaratula : Graba Caratula de un ingreso de Valores *
     *                                                              *
     *     peDsCa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_setCaratula...
     P                 b                   export
     D SVPVLO_setCaratula...
     D                 pi              n
     D   peDsCa                            likeds( dsIvhcar_t )

     D   k1yCar        ds                  likerec( i1hcar : *key      )
     D   @@DsOCa       ds                  likerec( i1hcar : *output   )

      /free

       SVPVLO_inz();

       k1yCar.caempr = peDsCa.caEmpr;
       k1yCar.casucu = peDsCa.casucu;
       k1yCar.caivop = peDsCa.caivop;
       chain %kds( k1yCar : 3 ) ivhcar;
       if %found( ivhcar );
         return *off;
       endif;

       monitor;
         eval-corr @@DsOCa = peDsCa;
         write i1hcar @@DsOCa;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPVLO_setCaratula...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_dltCaratula : Elimina Caratula de un ingreso de       *
     *                      Valores                                 *
     *                                                              *
     *     peDsCa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_dltCaratula...
     P                 b                   export
     D SVPVLO_dltCaratula...
     D                 pi              n
     D   peDsCa                            likeds( dsIvhcar_t )

     D   k1yCar        ds                  likerec( i1hcar : *key      )

      /free

       SVPVLO_inz();

       k1yCar.caempr = peDsCa.caempr;
       k1yCar.casucu = peDsCa.casucu;
       k1yCar.caivop = peDsCa.caivop;
       chain %kds( k1yCar : 3 ) ivhcar;
       if %found( ivhcar );
         delete ivhcar;
       endif;

       return *on;

      /end-free

     P SVPVLO_dltCaratula...
     P                 e
     * ------------------------------------------------------------ *
     * SVPVLO_chkValor : Valida Valor                               *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion                *
     *     peIvse   ( input  )   Secuencia             ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_chkValor...
     P                 b                   export
     D SVPVLO_chkValor...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 const
     D   peIvse                       5  0 options( *nopass : *omit ) const

     D   k1yVal        ds                  likerec( i1hval : *key   )

      /free

       SVPVLO_inz();

       k1yVal.vaempr = peEmpr;
       k1yVal.vasucu = peSucu;
       k1yval.vaivop = peIvop;

       if %parms >= 4;
         Select;
           when %addr( peIvse ) <> *null;
             k1yval.vaivse = peIvse;
             setll %kds( k1yVal : 4 ) ivhval;
             if not %equal( ivhval );
               return *off;
             endif;
           other;
             setll %kds( k1yVal : 3 ) ivhval;
             if not %equal( ivhval );
               return *off;
             endif;
         endsl;
       else;
         setll %kds( k1yVal : 3 ) ivhval;
         if not %equal( ivhval );
           return *off;
         endif;
       endif;

       return *on;

      /end-free

     P SVPVLO_chkValor...
     P                 e
     * ------------------------------------------------------------ *
     * SVPVLO_getValores :Retorna Valores                           *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion   ( opcional ) *
     *     peIvse   ( input  )   Secuencia             ( opcional ) *
     *     peDsCa   ( output )   Estr. T.  Caratulas   ( opcional ) *
     *     peDsCaC  ( output )   Cantidad  Caratuals   ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_getValores...
     P                 b                   export
     D SVPVLO_getValores...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 options( *nopass : *omit ) const
     D   peIvse                       5  0 options( *nopass : *omit ) const
     D   peDsVa                            likeds( dsIvhval_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVaC                     10i 0 options( *nopass : *omit )

     D   k1yVal        ds                  likerec( i1hval : *key   )
     D   @@DsIVa       ds                  likerec( i1hval : *input )
     D   @@DsVa        ds                  likeds( dsIvhval_t ) dim( 9999 )
     D   @@DsVaC       s             10  0

      /free

       SVPVLO_inz();

       k1yVal.vaempr = peEmpr;
       k1yVal.vasucu = peSucu;

       if %parms >= 3;
         Select;
           when %addr( peIvop ) <> *null and
                %addr( peIvse ) <> *null;
             k1yval.vaivop = peIvop;
             k1yval.vaivse = peIvse;
             setll %kds( k1yVal : 4 ) ivhval;
             if not %equal( ivhval );
               return *off;
             endif;
             reade(n) %kds( k1yVal : 4 ) ivhval @@DsIVa;
             dow not %eof( ivhval );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
              reade(n) %kds( k1yVal : 4 ) ivhval @@DsIVa;
             enddo;
           when %addr( peIvop ) <> *null and
                %addr( peIvse ) =  *null;
             k1yval.vaivop = peIvop;
             setll %kds( k1yVal : 3 ) ivhval;
             if not %equal( ivhval );
               return *off;
             endif;
             reade(n) %kds( k1yVal : 3 ) ivhval @@DsIVa;
             dow not %eof( ivhval );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
              reade(n) %kds( k1yVal : 3 ) ivhval @@DsIVa;
             enddo;
           other;
             setll %kds( k1yVal : 2 ) ivhval;
             if not %equal( ivhval );
               return *off;
             endif;
             reade(n) %kds( k1yVal : 2 ) ivhval @@DsIVa;
             dow not %eof( ivhval );
               @@DsVaC += 1;
               eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
              reade(n) %kds( k1yVal : 2 ) ivhval @@DsIVa;
             enddo;
         endsl;
       else;
         setll %kds( k1yVal : 2 ) ivhval;
         if not %equal( ivhval );
           return *off;
         endif;
         reade(n) %kds( k1yVal : 2 ) ivhval @@DsIVa;
         dow not %eof( ivhval );
           @@DsVaC += 1;
           eval-corr @@DsVa( @@DsVaC ) = @@DsIVa;
          reade(n) %kds( k1yVal : 2 ) ivhval @@DsIVa;
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

     P SVPVLO_getValores...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_setValor : Graba Valor Ingresado                      *
     *                                                              *
     *     peDsVa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_setValor...
     P                 b                   export
     D SVPVLO_setValor...
     D                 pi              n
     D   peDsVa                            likeds( dsIvhval_t )

     D   k1yVal        ds                  likerec( i1hval : *key      )
     D   @@DsOVa       ds                  likerec( i1hval : *output   )

      /free

       SVPVLO_inz();

       k1yVal.vaempr = peDsVa.vaempr;
       k1yVal.vasucu = peDsVa.vasucu;
       k1yVal.vaivop = peDsVa.vaivop;
       k1yVal.vaivse = peDsVa.vaivse;
       chain %kds( k1yVal : 4 ) ivhval;
       if %found( ivhval );
         return *off;
       endif;

       monitor;
         eval-corr @@DsOVa = peDsVa;
         write i1hval @@DsOVa;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPVLO_setValor...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_dltValor : Elimina Caratula de un ingreso de Valores  *
     *                                                              *
     *     peDsVa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_dltValor...
     P                 b                   export
     D SVPVLO_dltValor...
     D                 pi              n
     D   peDsVa                            likeds( dsIvhval_t )

     D   k1yVal        ds                  likerec( i1hval : *key      )

      /free

       SVPVLO_inz();

       k1yVal.vaempr = peDsVa.vaempr;
       k1yVal.vasucu = peDsVa.vasucu;
       k1yVal.vaivop = peDsVa.vaivop;
       k1yVal.vaivse = peDsVa.vaivse;
       chain %kds( k1yVal : 4 ) ivhval;
       if %found( ivhval );
         delete ivhval;
       endif;

       return *on;

      /end-free

     P SVPVLO_dltValor...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_chkCaja  : Valida que Caja                            *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvr2   ( input  )   Numero de Caja ( opcional )        *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_chkCaja...
     P                 b                   export
     D SVPVLO_chkCaja...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvr2                       6  0 const options(*nopass:*omit)

     D   k1y004        ds                  likerec( i1t004 : *key   )

      /free

       SVPVLO_inz();

       k1y004.t4empr = peEmpr;
       k1y004.t4sucu = peSucu;

       if %parms >= 3 and %addr(peIvr2) <> *NULL;
         k1y004.t4ivr2 = peIvr2;
         setll %kds( k1y004 : 3 ) ivt004;
       else;
         setll %kds( k1y004 : 2 ) ivt004;
       endif;

       return %equal();

      /end-free

     P SVPVLO_chkCaja...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_chkCajaTerminal : Valida Caja por Terminal            *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peWdis   ( input  )   Nombre de Dispositivo              *
     *     peIvr2   ( input  )   Numero de Caja        ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     P SVPVLO_chkCajaTerminal...
     P                 b                   export
     D SVPVLO_chkCajaTerminal...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peWdis                      10    const
     D   peIvr2                       6  0 const options(*nopass:*omit)

     D   k1y005        ds                  likerec( i1t00501 : *key   )

      /free

       SVPVLO_inz();

       k1y005.t5empr = peEmpr;
       k1y005.t5sucu = peSucu;
       k1y005.t5wdis = peWdis;
       if %parms >= 4 and %addr(peIvr2) <> *NULL;
         k1y005.t5Ivr2 = peIvr2;
         setll %kds( k1y005 : 4 ) ivt00501;
       else;
         setll %kds( k1y005 : 3 ) ivt00501;
       endif;

       return %equal();

      /end-free

     P SVPVLO_chkCajaTerminal...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_chkUsuario : Valida Usuario                           *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peUser   ( input  )   Nombre de Usuario                  *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     P SVPVLO_chkUsuario...
     P                 b                   export
     D SVPVLO_chkUsuario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peUser                      10    const

     D   k1y007        ds                  likerec( i1t007 : *key )

      /free

       SVPVLO_inz();

       k1y007.t7empr = peEmpr;
       k1y007.t7sucu = peSucu;
       k1y007.t7user = peUser;
       setll %kds( k1y007 : 3 ) ivt007;

       return %equal();

     P SVPVLO_chkUsuario...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_chkTipoMovPorUsuario: Valida si Tipo de movimiento    *
     *                              corresponde a un Usuario        *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvtm   ( input  )   Tipo de Movimiento                 *
     *     peUser   ( input  )   Nombre de Usuario                  *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     P SVPVLO_chkTipoMovPorUsuario...
     P                 b                   export
     D SVPVLO_chkTipoMovPorUsuario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvtm                       2  0 const
     D   peUser                      10    const

     D   k1y006        ds                  likerec( i1t006 : *key )

      /free

       SVPVLO_inz();

       k1y006.t6empr = peEmpr;
       k1y006.t6sucu = peSucu;
       k1y006.t6ivtm = peIvtm;
       k1y006.t6user = peUser;
       setll %kds( k1y006 : 4 ) ivt006;

       return %equal();

     P SVPVLO_chkTipoMovPorUsuario...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_getNumeroOperacion: Retorna número de operación       *
     *                                                              *
     * Retorna: Número de Operación                                 *
     * ------------------------------------------------------------ *
     P SVPVLO_getNumeroOperacion...
     P                 b                   export
     D SVPVLO_getNumeroOperacion...
     D                 pi             7  0

     D @@Ivop          s              7  0

      /free

       SVPVLO_inz();

       @@Ivop = *zeros;
       CA0112( @@Ivop );

       return @@Ivop;

     P SVPVLO_getNumeroOperacion...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_getNumeroIngreso: Retorna número de ingreso           *
     *                                                              *
     * Retorna: Número de Ingreso                                   *
     * ------------------------------------------------------------ *
     P SVPVLO_getNumeroIngreso...
     P                 b                   export
     D SVPVLO_getNumeroIngreso...
     D                 pi             6  0

     D @@Ivni          s              6  0

      /free

       SVPVLO_inz();

       @@Ivni = *zeros;
       CA01121( @@Ivni );

       return @@Ivni;

     P SVPVLO_getNumeroIngreso...
     P                 e

     * ------------------------------------------------------------ *
     * SVPVLO_getFechaDeIngreso: Retorna Fecha de ingreso           *
     *                                                              *
     * Retorna: Fecha de Ingreso                                    *
     * ------------------------------------------------------------ *
     P SVPVLO_getFechaDeIngreso...
     P                 b                   export
     D SVPVLO_getFechaDeIngreso...
     D                 pi             8  0
     D   peForm                       3    const

     D @@Fing          s              8  0
     D @@Ic1a          s              4  0
     D @@Ic1m          s              2  0
     D @@Ic1d          s              2  0

      /free

       SVPVLO_inz();

       @@Ic1a = *zeros;
       @@Ic1m = *zeros;
       @@Ic1d = *zeros;

       CA01122( @@Ic1a
              : @@Ic1m
              : @@Ic1d );

       select;
         when peForm = 'AMD';
           @@Fing = ( @@Ic1a * 10000) + ( @@Ic1m * 100) + @@Ic1d;
         when peForm = 'DMA';
           @@Fing = ( @@Ic1d * 1000000 ) + ( @@Ic1m * 10000 ) + @@Ic1a;
         other;
           @@Fing = *zeros;
       endsl;

       return @@Fing;

     P SVPVLO_getFechaDeIngreso...
     P                 e

