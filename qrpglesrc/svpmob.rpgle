     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPMOB: Programa de servicios.                               *
      *         APP Movil                                            *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                   21-Ene-2018             *
      * ------------------------------------------------------------ *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *
     Fpahmob    if a e           k disk    usropn

     D @@valsys        s            512

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpmob_h.rpgle'

      * ------------------------------------------------------------ *
      * Setea error global
      * ------------------------------------------------------------ *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * SVPMOB_getAuditoria: Retorna informacion de auditoria        *
      *                                                              *
      *     peEmpr   ( input  ) Código de Empresa                    *
      *     peSucu   ( input  ) Código de sucursal                   *
      *     peFech   ( input  ) Fecha de alta                        *
      *     peDsmo   ( output ) Estructura Datos Mobile              *
      *                                                              *
      * Retorna: *on = Obtiene Datos.-                               *
      *          *off= No obtiene Datos.-                            *
      * ------------------------------------------------------------ *

     P SVPMOB_getAuditoria...
     P                 B                   export
     D SVPMOB_getAuditoria...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFech                      25    const
     D   peDsmo                            likeds( DsPahmob_t )

     D k1ymob          ds                  likerec( p1hmob : *key )
     D dsIMob          ds                  likerec( p1hmob : *input)

      /free

       SVPMOB_inz();

       clear peDsmo;
       k1ymob.obempr = peEmpr;
       k1ymob.obsucu = peSucu;
       k1ymob.obfech = peFech;
       chain(n) %kds( k1ymob ) pahmob dsIMob;
       if %found( pahmob );
         eval-corr peDsMo = dsIMob;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPMOB_getAuditoria...
     P                 E
      * ------------------------------------------------------------ *
      * SVPMOB_setAuditoria: Graba datos de Auditoria.-              *
      *                                                              *
      *     peDsmo   (input)   Estructura Datos Mobile               *
      *                                                              *
      * Retorna: *on = Se insertó correctamente.-                    *
      *          *off= No se insertó.-                               *
      * ------------------------------------------------------------ *

     P SVPMOB_setAuditoria...
     P                 B                   export
     D SVPMOB_setAuditoria...
     D                 pi              n
     D   peDsmo                            likeds( DsPahmob_t ) const

     D k1ymob          ds                  likerec( p1hmob : *key )
     D dsOMob          ds                  likerec( p1hmob : *output)

      /free

       SVPMOB_inz();

       eval-corr dsOMob = peDsMo;
       write p1hmob dsOMob;

       return *on;

      /end-free

     P SVPMOB_setAuditoria...
     P                 E

      * ------------------------------------------------------------ *
      * SVPMOB_setDataq() : Envia datos a cola.-                     *
      *                                                              *
      *     peEmpr   ( input )  Empresa                              *
      *     peSucu   ( input )  Sucursal                             *
      *     peFech   ( input )  Fecha y Hora                         *
      *     peDtaq   ( input )  Nombre de Cola. ( opcional )         *
      *                                                              *
      * Retorna: *on = Se insertó correctamente.-                    *
      *          *off= Error al insertar.-                           *
      * ------------------------------------------------------------ *

     P SVPMOB_setDataq...
     P                 B                   export
     D SVPMOB_setDataq...
     D                 pi              n
     D   peEmpr                       1      const
     D   peSucu                       2      const
     D   peFech                      25      const
     D   peAcci                      10      options(*omit:*nopass)
     D   peDtaq                      10      options(*omit:*nopass)

     D Data            s             38a
     D len             s              5p 0
     D @@dtaq          s             10
     D @@acci          s             10

      /free

         if %parms>= 4 and %addr( peAcci ) <> *null;
           @@acci = peAcci;
         else;
           @@acci = 'SETDATOS';
         endif;

         if %parms>= 5 and %addr( peDtaq ) <> *null;
           @@dtaq = peDtaq;
         else;
           if SVPVLS_getValSys( 'HMOBDTAQ':*omit :@@ValSys );
             @@dtaq =  %trim(@@ValSys );
           endif;
         endif;

         Data = %trim(peEmpr)
              + %trim(peSucu)
              + %trim(peFech)
              + @@acci;

         monitor;
           QSNDDTAQ( @@dtaq
                   : '*LIBL'
                   : %len(%trim(data))
                   : Data             );
         on-error;
           return *off;
         endmon;
         return *on;
      /end-free

     P SVPMOB_setDataq...
     P                 E
      * ------------------------------------------------------------ *
      * SVPMOB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPMOB_inz      B                   export
     D SVPMOB_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahmob);
         open pahmob;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPMOB_inz      E

      * ------------------------------------------------------------ *
      * SVPMOB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPMOB_End      B                   export
     D SVPMOB_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPMOB_End      E

      * ------------------------------------------------------------ *
      * SVPMOB_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPMOB_Error    B                   export
     D SVPMOB_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPMOB_Error    E

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
