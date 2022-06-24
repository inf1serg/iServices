     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLCLI : WebService - Busqueda de Asegurado unificada.       *
      *          Este programa pretende implementar un "fasade" para *
      *          la ejecución de:                                    *
      *          WSLASE                                              *
      *          WSLAXN                                              *
      *          WSLAXD                                              *
      *          WSLAXC                                              *
      * Por lo tanto no hay lógica acá, sólo armado de parámetros.   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                          *25-Abr-2016       *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 01/06/2016 - Cambio en DS Asegurado                      *
      * JSN 28/02/2019 - Recompilacion por cambio en la estructura   *
      *                  PAHASE_T                                    *
      * ************************************************************ *

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D WSLCLI          pr                  ExtPgm('WSLCLI')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keycli_t) const
     D   pePreg                            likeds(keycli_t)
     D   peUreg                            likeds(keycli_t)
     D   peLase                            likeds(pahase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMase                            likeds(dsMail_t) dim(99)
     D   peMaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLCLI          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keycli_t) const
     D   pePreg                            likeds(keycli_t)
     D   peUreg                            likeds(keycli_t)
     D   peLase                            likeds(pahase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMase                            likeds(dsMail_t) dim(99)
     D   peMaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLASE          pr                  ExtPgm('WSLASE')
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(99)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLAXN          pr                  ExtPgm('WSLAXN')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyaxn_t) const
     D   pePreg                            likeds(keyaxn_t)
     D   peUreg                            likeds(keyaxn_t)
     D   peLase                            likeds(pahase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLAXD          pr                  ExtPgm('WSLAXD')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyaxd_t) const
     D   pePreg                            likeds(keyaxd_t)
     D   peUreg                            likeds(keyaxd_t)
     D   peLase                            likeds(pahase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLAXC          pr                  ExtPgm('WSLAXC')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyaxc_t) const
     D   pePreg                            likeds(keyaxc_t)
     D   peUreg                            likeds(keyaxc_t)
     D   peLase                            likeds(pahase_t) dim(99)
     D   peLaseC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ----------------------------------------------------
      * Para WSLAXN
      * ----------------------------------------------------
     D pePos1          ds                  likeds(keyaxn_t)
     D pePre1          ds                  likeds(keyaxn_t)
     D peUre1          ds                  likeds(keyaxn_t)

      * ----------------------------------------------------
      * Para WSLAXD
      * ----------------------------------------------------
     D pePos2          ds                  likeds(keyaxd_t)
     D pePre2          ds                  likeds(keyaxd_t)
     D peUre2          ds                  likeds(keyaxd_t)

      * ----------------------------------------------------
      * Para WSLAXC
      * ----------------------------------------------------
     D pePos3          ds                  likeds(keyaxc_t)
     D pePre3          ds                  likeds(keyaxc_t)
     D peUre3          ds                  likeds(keyaxc_t)

     D peDase          ds                  likeds(pahase_t)

      /free

       *inlr = *On;

       // ----------------------------------
       // Valida Orden
       // ----------------------------------
       if not SVPWS_chkOrde( 'WSLCLI' : peOrde : peMsgs );
          peErro = -1;
          return;
       endif;

       select;

        when peOrde = 'CODIGOASEG';

             WSLASE( peBase
                   : pePosi.asasen
                   : peDase
                   : peMase
                   : peMaseC
                   : peErro
                   : peMsgs        );

             if peErro = 0;
                peLase(1) = peDase;
                peLaseC   = 1;
                pePreg.asasen = peDase.asasen;
                pePreg.ascuit = peDase.ascuit;
                pePreg.astido = peDase.astido;
                pePreg.asnrdo = peDase.asnrdo;
                pePreg.asnomb = peDase.asnomb;
                peUreg.asasen = peDase.asasen;
                peUreg.ascuit = peDase.ascuit;
                peUreg.astido = peDase.astido;
                peUreg.asnrdo = peDase.asnrdo;
                peUreg.asnomb = peDase.asnomb;
             endif;

        when peOrde = 'NOMBREASEG';

              pePos1.asasen = pePosi.asasen;
              pePos1.asnomb = pePosi.asnomb;

             WSLAXN( peBase
                   : peCant
                   : peRoll
                   : pePos1
                   : pePre1
                   : peUre1
                   : peLase
                   : peLaseC
                   : peMore
                   : peErro
                   : peMsgs        );

             if peLaseC = 0;
                clear pePreg;
                clear peUreg;
                clear peLase;
              else;
                pePreg.asasen = pePre1.asasen;
                pePreg.asnomb = pePre1.asnomb;
                pePreg.ascuit = peLase(1).ascuit;
                pePreg.astido = peLase(1).astido;
                pePreg.asnrdo = peLase(1).asnrdo;
                peUreg.asasen = peUre1.asasen;
                peUreg.asnomb = peUre1.asnomb;
                peUreg.ascuit = peLase(peLaseC).ascuit;
                peUreg.astido = peLase(peLaseC).astido;
                peUreg.asnrdo = peLase(peLaseC).asnrdo;
             endif;

        when peOrde = 'NRCUITASEG';

             pePos3.asasen = pePosi.asasen;
             pePos3.ascuit = pePosi.ascuit;

             WSLAXC( peBase
                   : peCant
                   : peRoll
                   : pePos3
                   : pePre3
                   : peUre3
                   : peLase
                   : peLaseC
                   : peMore
                   : peErro
                   : peMsgs        );

             if peLaseC = 0;
                clear pePreg;
                clear peUreg;
                clear peLase;
              else;
                pePreg.asasen = pePre3.asasen;
                pePreg.ascuit = pePre3.ascuit;
                pePreg.asnomb = peLase(1).asnomb;
                pePreg.astido = peLase(1).astido;
                pePreg.asnrdo = peLase(1).asnrdo;
                peUreg.asasen = peUre3.asasen;
                peUreg.ascuit = peUre3.ascuit;
                peUreg.asnomb = peLase(peLaseC).asnomb;
                peUreg.astido = peLase(peLaseC).astido;
                peUreg.asnrdo = peLase(peLaseC).asnrdo;
             endif;

        when peOrde = 'NRDOCUASEG';

             pePos2.astido = pePosi.astido;
             pePos2.asnrdo = pePosi.asnrdo;
             pePos2.asasen = pePosi.asasen;

             WSLAXD( peBase
                   : peCant
                   : peRoll
                   : pePos2
                   : pePre2
                   : peUre2
                   : peLase
                   : peLaseC
                   : peMore
                   : peErro
                   : peMsgs        );

             if peLaseC = 0;
                clear pePreg;
                clear peUreg;
                clear peLase;
              else;
                pePreg.asasen = pePre2.asasen;
                pePreg.astido = pePre2.astido;
                pePreg.asnrdo = pePre2.asnrdo;
                pePreg.asnomb = peLase(1).asnomb;
                pePreg.ascuit = peLase(1).ascuit;
                peUreg.asasen = pePre2.asasen;
                peUreg.astido = pePre2.astido;
                peUreg.asnrdo = pePre2.asnrdo;
                peUreg.asnomb = peLase(peLaseC).asnomb;
                peUreg.ascuit = peLase(peLaseC).ascuit;
             endif;

       endsl;

      /end-free

