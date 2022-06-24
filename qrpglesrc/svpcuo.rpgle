     h nomain
      * ************************************************************ *
      * SVPCUO  :Programa de Servicio.                               *
      *          Validaciones Cuotas                                 *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        21-May-2021             *
      * ************************************************************ *
      *------------------------------------------------------------- *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                               <*
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                               <*
      *> CRTRPGMOD MODULE(QTEMP/&N) -                               <*
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -                 <*
      *>           DBGVIEW(&DV)                                     <*
      *> CRTSRVPGM SRVPGM(&O/&ON) -                                 <*
      *>           MODULE(QTEMP/&N) -                               <*
      *>           EXPORT(*SRCFILE) -                               <*
      *>           SRCFILE(HDIILE/QSRVSRC) -                        <*
      *>           BNDDIR(HDIILE/HDIBDIR) -                         <*
      *> TEXT('Prorama de Servicio: Dato Filiatorio')               <*
      *> IGN: DLTMOD MODULE(QTEMP/&N)                               <*
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPDAF))       <*
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPDAF))            <*
      *> IGN: DLTSPLF FILE(SVPDAF)                                  <*
      *------------------------------------------------------------- *

     fpahcd6    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpcuo_h.rpgle'

      *--- Variables de Trabajo...---------------------------------- *
     D @@finpgm        s              3a
     D @RETORNO        s              1n
     D @@FItm          s              8  0
     D @error          s              1n
     D @@rtex          s            132                                         ||
     D @@ivse          s              5  0                                      ||
     D @@PGMN          s             10                                         ||

      * --------------------------------------------------- *
      * Setea procedimientos globales
      * --------------------------------------------------- *

     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D  Errn           s             10i 0
     D  Errm           s             80a
     D  Initialized    s              1N   inz(*OFF)

      * ---- claves

      * ------------------------------------------------------------ *
      * SVPCUO_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPCUO_inz      B                   export
     D SVPCUO_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahcd6);
         open pahcd6;
       endif;

       initialized = *ON;

      /end-free

     P SVPCUO_inz      E
      * ------------------------------------------------------------ *
      * SVPCUO_end(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPCUO_end      B                   export
     D SVPCUO_end      pi

      /free

       close *all;
       initialized = *off;
       return;

      /end-free

     P SVPCUO_end      E

      * ------------------------------------------------------------ *
      * SVPCUO_getNumeroAsiento() : Retorna Número de Asiento del    *
      *                             Archivo PAHCD6.                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peSspo   ( input  ) Suplemento Superpóliza               *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia                            *
      *     peOper   ( input  ) Operación                            *
      *     peSuop   ( input  ) Suplemento Operación                 *
      *     peNrcu   ( input  ) Número de Cuota                      *
      *     peNrsc   ( input  ) Número de Sub-Cuota                  *
      *     pePsec   ( input  ) Secuencia de Pago.                   *
      *                                                              *
      * Retorna: Numero de Asiento / *zeros                          *
      * ------------------------------------------------------------ *
     P SVPCUO_getNumeroAsiento...
     P                 B                   export
     D SVPCUO_getNumeroAsiento...
     D                 pi             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   pePsec                       2  0 const options(*nopass:*omit)

     D k1ycd6          ds                  likerec(p1hcd6:*key)

      /free

       SVPCUO_inz();

        clear d6nras;

        k1ycd6.d6Empr = peEmpr;
        k1ycd6.d6Sucu = peSucu;
        k1ycd6.d6Arcd = peArcd;
        k1ycd6.d6Spol = peSpol;
        k1ycd6.d6Sspo = peSspo;
        k1ycd6.d6Rama = peRama;
        k1ycd6.d6Arse = peArse;
        k1ycd6.d6Oper = peOper;
        k1ycd6.d6Suop = peSuop;
        k1ycd6.d6Nrcu = peNrcu;
        k1ycd6.d6Nrsc = peNrsc;
        chain %kds( k1ycd6 : 11 ) pahcd6;
        return d6nras;

      /end-free

     P SVPCUO_getNumeroAsiento...
     P                 E

