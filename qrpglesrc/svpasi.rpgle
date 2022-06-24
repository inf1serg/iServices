     H datedit(*DMY/)
     H nomain
      * ************************************************************ *
      * SPVASI: Programa de Servicio.                                *
      *         Asientos                                             *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        14-Ago-2021             *
      * ------------------------------------------------------------ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                <*
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*
      *>           DBGVIEW(&DV)                         <*
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*
      *>           MODULE(QTEMP/&N) -                   <*
      *>           EXPORT(*SRCFILE) -                   <*
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*
      *> TEXT('Programa de Servicio: Asientos      ')   <*
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*
      * ------------------------------------------------------------ *
     Fcnhasi    uf a e           k disk    usropn
     Fcnwnin    uf a e           k disk    usropn
     Fgnttge    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpasi_h.rpgle'

      *------------------------------------------------------------- *

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrCode         s             10i 0
     D ErrText         s             80a

      *--- Initialized --------------------------------------------- *
     D Initialized     s              1N   inz(*OFF)

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

      * ------------------------------------------------------------ *
      *                                                              *
      * SVPASI_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPASI_inz      B                   export
     D SVPASI_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(cnhasi);
         open cnhasi;
       endif;

       if not %open(cnwnin);
         open cnwnin;
       endif;

       if not %open(gnttge);
         open gnttge;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPASI_inz      E

      * ------------------------------------------------------------ *
      * SVPASI_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPASI_End      B                   export
     D SVPASI_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPASI_End      E

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * SVPASI_getCnhAsi: Retorna CNHASI                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *     peHasi   (output)  DS con los registros de Asientos      *
      *     peHasic  (output)  Cantidad de Registros de Asientos     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPASI_getCnHasi...
     P                 B                   export
     D SVPASI_getCnHasi...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     d   peFasa                       4S 0 const
     d   peFasm                       2S 0 const
     d   peFasd                       2S 0 const
     d   peLibr                       1S 0 const
     d   peTico                       2  0 const
     d   peNras                       6S 0 const
     d   peComo                       2    const
     D   peSeas                       4S 0 const options(*nopass:*omit)
     D   peDsAsi                           likeds ( DsCnhasi_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsAsiC                    10i 0 options(*nopass:*omit)

     D k1hasi          ds                  likerec( c1hasi : *key   )
     D inAsi           ds                  likerec( c1hasi : *input )

      /free

       SVPASI_Inz();

       clear peDsAsi;
       clear inAsi;
       pedsAsiC = *zeros ;

       if %parms >= 9 and %addr(peSeas) = *Null;
        k1hasi.asEmpr = peEmpr;
        k1hasi.asSucu = peSucu;
        k1hasi.asfasa = peFasa;
        k1hasi.asfasm = peFasm;
        k1hasi.asfasd = peFasd;
        k1hasi.aslibr = peLibr;
        k1hasi.asTico = peTico;
        k1hasi.asNras = peNras;
        k1hasi.asComo = peComo;
        setll %kds(k1hasi:9) cnhasi;
        reade %kds(k1hasI:9) cnhasi;
         dow not  %eof;
            peDsAsiC += 1;
            eval-corr peDsAsi(peDsAsiC) = inAsi;
        reade %kds(k1hasi:9) cnhasi;
        enddo;
       endif;

       if %parms >= 10 and %addr(peSeas) <> *Null;
        k1hasi.asEmpr = peEmpr;
        k1hasi.asSucu = peSucu;
        k1hasi.asfasa = peFasa;
        k1hasi.asfasm = peFasm;
        k1hasi.asfasd = peFasd;
        k1hasi.aslibr = peLibr;
        k1hasi.asTico = peTico;
        k1hasi.asNras = peNras;
        k1hasi.asComo = peComo;
        k1hasi.asSeas = peSeas;
        chain %kds(k1hasi:10) cnhasi;
         if %found;
            peDsAsiC += 1;
            eval-corr peDsAsi(peDsAsiC) = inAsi;
         endif;
       endif;

       if peDsAsiC = *zeros;
          return *off;
       endif;

       return *on;

      /end-free

     P SVPASI_getCnhAsi...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASI_chkCnhAsi: Chequea existencia CNHASI                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPASI_chkCnHasi...
     P                 B                   export
     D SVPASI_chkCnHasi...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     d   pefasa                       4S 0 const
     d   pefasm                       2S 0 const
     d   pefasd                       2S 0 const
     d   pelibr                       1S 0 const
     d   petico                       2  0 const
     d   penras                       6S 0 const
     d   pecomo                       2    const
     d   peseas                       4S 0 const options(*omit:*nopass)

     D k1hasi          ds                  likerec( c1hasi   : *key )

      /free

       SVPASI_Inz();

       if %parms >= 9 and %addr(peSeas) = *Null;
        k1hasi.asEmpr = peEmpr;
        k1hasi.asSucu = peSucu;
        k1hasi.asfasa = peFasa;
        k1hasi.asfasm = peFasm;
        k1hasi.asfasd = peFasd;
        k1hasi.aslibr = peLibr;
        k1hasi.asTico = peTico;
        k1hasi.asNras = peNras;
        k1hasi.asComo = peComo;
        setll %kds(k1hasi:9) cnhasi;
         if %equal(cnhasi);
          return *on;
         endif;
       endif;

       if %parms >= 10 and %addr(peSeas) <> *Null;
        k1hasi.asEmpr = peEmpr;
        k1hasi.asSucu = peSucu;
        k1hasi.asfasa = peFasa;
        k1hasi.asfasm = peFasm;
        k1hasi.asfasd = peFasd;
        k1hasi.aslibr = peLibr;
        k1hasi.asTico = peTico;
        k1hasi.asNras = peNras;
        k1hasi.asComo = peComo;
        k1hasi.asSeas = peSeas;
        setll %kds(k1hasi:10) cnhasi;
         if %equal(cnhasi);
          return *on;
         endif;
       endif;

         return *off;

       Initialized = *OFF;


      /end-free

     P SVPASI_chkCnhAsi...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASI_UpdCnhAsi: Update Cnhasi                              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *                                                              *
      * Retorna: *on = Actualizó / *off = No Actualizó               *
      * ------------------------------------------------------------ *
     P SVPASI_UpdCnHasi...
     P                 B                   export
     D SVPASI_UpdCnHasi...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     d   pefasa                       4S 0 const
     d   pefasm                       2S 0 const
     d   pefasd                       2S 0 const
     d   pelibr                       1S 0 const
     d   petico                       2  0 const
     d   penras                       6S 0 const
     d   pecomo                       2    const
     d   peseas                       4S 0 const
     D   peDsAsi                           likeds ( DsCnhasi_t )

     D k1hasi          ds                  likerec( c1hasi   : *key )
     D   @@DsOAsi      ds                  likerec( c1hasi : *output )

      /free

       SVPASI_Inz();
       clear @@DsOAsi;

        k1hasi.asEmpr = peEmpr;
        k1hasi.asSucu = peSucu;
        k1hasi.asfasa = peFasa;
        k1hasi.asfasm = peFasm;
        k1hasi.asfasd = peFasd;
        k1hasi.aslibr = peLibr;
        k1hasi.asTico = peTico;
        k1hasi.asNras = peNras;
        k1hasi.asComo = peComo;
        k1hasi.asSeas = peSeas;
        chain %kds(k1hasi:10) cnhasi;
         if %found;
            eval-corr @@DsOAsi = peDsAsi;
            update c1hasi @@DsOAsi;
          else;
            return *off;
         endif;

         return *on;

      /end-free

     P SVPASI_UpdCnhAsi...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASI_SetCnhAsi: Graba Cnhasi                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peSeas   (input)   Secuencia del Asiento                 *
      *                                                              *
      * Retorna: *on = Grabó     / *off = No Grabó                   *
      * ------------------------------------------------------------ *
     P SVPASI_SetCnHasi...
     P                 B                   export
     D SVPASI_SetCnHasi...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     d   pefasa                       4S 0 const
     d   pefasm                       2S 0 const
     d   pefasd                       2S 0 const
     d   pelibr                       1S 0 const
     d   petico                       2  0 const
     d   penras                       6S 0 const
     d   pecomo                       2    const
     d   peseas                       4S 0 const
     D   peDsAsi                           likeds ( DsCnhasi_t )

     D k1hasi          ds                  likerec( c1hasi   : *key )
     D   @@DsOAsi      ds                  likerec( c1hasi : *output )

      /free

       SVPASI_Inz();
       clear @@DsOAsi;

        k1hasi.asEmpr = peEmpr;
        k1hasi.asSucu = peSucu;
        k1hasi.asfasa = peFasa;
        k1hasi.asfasm = peFasm;
        k1hasi.asfasd = peFasd;
        k1hasi.aslibr = peLibr;
        k1hasi.asTico = peTico;
        k1hasi.asNras = peNras;
        k1hasi.asComo = peComo;
        k1hasi.asSeas = peSeas;
        chain %kds(k1hasi:10) cnhasi;
         if not %found;
            eval-corr @@DsOAsi = peDsAsi;
            write c1hasi @@DsOAsi;
          else;
            return *off;
         endif;

         return *on;

      /end-free

     P SVPASI_SetCnhAsi...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASI_BalanceoAsiento: Balanceo Asiento en CNWNIN           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peFasa   (input)   Fecha Año Asiento                     *
      *     peFasm   (input)   Fecha Mes Asiento                     *
      *     peFasd   (input)   Fecha Día Asiento                     *
      *     peLibr   (input)   Libro                                 *
      *     peTico   (input)   Tipo de Comprobante                   *
      *     peNras   (input)   Número de Asiento                     *
      *     peComo   (input)   Código de Moneda                      *
      *     peNrcm   (input)   Numero de Cuenta de Mayor a Ajustar   *
      *                                                              *
      * Retorna: *on = Balanceó  / *off = No Balanceó                *
      * ------------------------------------------------------------ *
     P SVPASI_BalanceoAsiento...
     P                 B                   export
     D SVPASI_BalanceoAsiento...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     d   pefasa                       4S 0 const
     d   pefasm                       2S 0 const
     d   pefasd                       2S 0 const
     d   pelibr                       1S 0 const
     d   petic2                       2  0 const
     d   penras                       6S 0 const
     d   pecomo                       2    const
     d   peNrcm                      11S 0 const

       dcl-s debe     packed(15:2);
       dcl-s haber    packed(15:2);
       dcl-s resto    packed(15:2);

       dcl-ds k1tnin likerec(c1wnin:*key);


      /free

       SVPASI_Inz();

       k1tnin.niEmpr = peempr;
       k1tnin.niSuc2 = pesucu;
       k1tnin.nifasa = pefasa;
       k1tnin.nifasm = pefasm;
       k1tnin.nifasd = pefasd;
       k1tnin.nilibr = pelibr;
       k1tnin.nitic2 = petic2;
       k1tnin.ninras = penras;
       k1tnin.nicomo = pecomo;
       setll %kds(k1tnin:9) cnwnin;
       reade %kds(k1tnin:9) cnwnin;
       dow not %eof;
           if nideha = 1;
           debe  += niimau;
             else;
           haber += niimau;
           endif;
       reade %kds(k1tnin:9) cnwnin;
       enddo;

       if debe <> haber;
         resto = debe - haber;
       endif;

       if resto <> *zeros;
       k1tnin.niEmpr = peempr;
       k1tnin.niSuc2 = pesucu;
       k1tnin.nifasa = pefasa;
       k1tnin.nifasm = pefasm;
       k1tnin.nifasd = pefasd;
       k1tnin.nilibr = pelibr;
       k1tnin.nitic2 = petic2;
       k1tnin.ninras = penras;
       k1tnin.nicomo = pecomo;
       setll %kds(k1tnin:9) cnwnin;
       reade %kds(k1tnin:9) cnwnin;
       dow not %eof;
         if ninrcm = penrcm;
         if nideha = 1;
          niimau += -resto;
          else;
          niimau += resto;
         endif;
          update c1wnin;
          return *on;
         endif;
       reade %kds(k1tnin:9) cnwnin;
       enddo;
       endif;

       return *off;

      /end-free

     P SVPASI_BalanceoAsiento...
     P                 E

