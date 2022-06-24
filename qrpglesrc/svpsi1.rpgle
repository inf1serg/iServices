     H nomain
     H option(*noshowcpy:*nodebugio)
      * ************************************************************ *
      * SVPSI1: exportación SVPSI1                                   *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     13-Sep-2021             *
      * ------------------------------------------------------------ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *> TEXT('Programa de Servicio: Autogestion Asegurados') <*     *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPSI1)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPSI1)) <*         *
      *> IGN: DLTSPLF FILE(SVPSI1)                           <*     *
      * ----------------------------------------------------------- *
      * Modificaciones:                                             *
      * DOT 08/02/22 - Se modifico getPahsbs                        *
      *              Funcion: Obtener Pahsbs Bienes siniestrados    *
      *              Cambio:  Se pusieron los parametros de llamada *
      *                       *ommit                                *
      *                                                             *
      ***************************************************************
     Fpahscd    uf a e           k disk    usropn
     Fpahsbe    uf a e           k disk    usropn
     Fpahsbo    uf a e           k disk    usropn
     Fpahsbr    uf a e           k disk    usropn
     Fpahsbs    uf a e           k disk    usropn
     Fpahsb1    uf a e           k disk    usropn
     Fpahsb101  uf a e           k disk    usropn
     Fpahsb2    uf a e           k disk    usropn
     Fpahsb4    uf a e           k disk    usropn
     Fpahscc    uf a e           k disk    usropn
     Fpahsc1    uf a e           k disk    usropn
     Fpahsdt    uf a e           k disk    usropn
     Fpahsfr    uf a e           k disk    usropn
     Fpahshe    uf a e           k disk    usropn
     Fpahshp    uf a e           k disk    usropn
     Fpahshr    uf a e           k disk    usropn
     Fpahsd0    uf a e           k disk    usropn
     Fpahsd1    uf a e           k disk    usropn
     Fpahsd2    uf a e           k disk    usropn
     Fpahsep    uf a e           k disk    usropn
     Fpahsfa    uf a e           k disk    usropn
     Fpahslk    uf a e           k disk    usropn
     Fpahsus    uf a e           k disk    usropn
     Fpawscd    uf a e           k disk    usropn
     Fpahsct    uf a e           k disk    usropn
     Fpahsd3    uf a e           k disk    usropn
     Fpahsd4    uf a e           k disk    usropn
     Fpahsd5    uf a e           k disk    usropn
     Fpahsnc    uf a e           k disk    usropn
     Fpahsoc    uf a e           k disk    usropn
     Fpahssp    uf a e           k disk    usropn
     Fpahstc    uf a e           k disk    usropn
     Fpahsva    uf a e           k disk    usropn
     Fpahsvt    uf a e           k disk    usropn
     Fpahsao    uf a e           k disk    usropn
     Fpahsag    uf a e           k disk    usropn
     Fpahsi0    uf a e           k disk    usropn
     Fpahsi1    uf a e           k disk    usropn
     Fgti980s   uf a e           k disk    usropn
     Fpahscl    uf a e           k disk    usropn
     Fset904    uf a e           k disk    usropn
     Fpahst1    uf a e           k disk    usropn
     Fpahst2    uf a e           k disk    usropn
     Fpahsd0b   uf a e           k disk    usropn
     Fpahsd0c   uf a e           k disk    usropn
     Fpahsd1b   uf a e           k disk    usropn
     Fpahsd1c   uf a e           k disk    usropn
     Fpds00005  uf a e           k disk    usropn
     Fpahsdt01  uf a e           k disk    usropn rename(p1hsdt:x1hsdt)
     Fpahscd03  if   e           k disk    usropn
     Fset401    if   e           k disk    usropn
     Fset402    if   e           k disk    usropn
     Fset466    if   e           k disk    usropn  prefix (tt:2)
     Fpahjcr    if   e           k disk    usropn
     Fpawsbe    uf a e           k disk    usropn
     Fpahslp    uf a e           k disk    usropn
     Fcntmfp    if   e           k disk    usropn
     FPahshp01  if   e           k disk    usropn  rename(p1hshp:x1hshp)
     FCnhric    uf a e           k disk    usropn
     FCnhrid    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'


      *- Area Local del Sistema. -------------------------- *
     D                sds
     D  ususer               254    263
     D  ususr2               358    367


     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrN            s             10i 0
     D ErrM            s             80a


     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const


     D SndMail         pr                  extpgm('SNDMAIL')
     D  peCprc                       20a   const
     D  peCspr                       20a   const options(*nopass:*omit)
     D  peMens                      512a   varying options(*nopass:*omit)
     D  peLmsg                     5000a   options(*nopass:*omit)

     D SetError        pr
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     D GSWEB903X       pr                  extpgm('GSWEB903X')
     D                                1a
     D                                2a
     D                                2  0
     D                                7  0
     D                                7  0

     D SAV903S         pr                  extPgm('SAV903S')
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     *
     D SAV903R         pr                  extpgm('SAV903R')
     D  p_empr                        1a
     D  p_sucu                        2a
     D  p_rama                        2  0
     D  p_poli                        7  0
      *

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPSI1_inz(): Inicializa módulo.                             *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPSI1_inz      B                   export
     D SVPSI1_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahscd);
          open pahscd;
       endif;

       if not %open(pahsbe);
          open pahsbe;
       endif;

       if not %open(pahsbo);
          open pahsbo;
       endif;

       if not %open(pahsbr);
          open pahsbr;
       endif;

       if not %open(pahsbs);
          open pahsbs;
       endif;

       if not %open(pahsb1);
          open pahsb1;
       endif;

       if not %open(pahsb101);
          open pahsb101;
       endif;

       if not %open(pahsb2);
          open pahsb2;
       endif;

       if not %open(pahsb4);
          open pahsb4;
       endif;

       if not %open(pahscc);
          open pahscc;
       endif;

       if not %open(pahsc1);
          open pahsc1;
       endif;

       if not %open(pahsdt);
          open pahsdt;
       endif;

       if not %open(pahsfr);
          open pahsfr;
       endif;

       if not %open(pahshe);
          open pahshe;
       endif;

       if not %open(pahshp);
          open pahshp;
       endif;

       if not %open(pahshr);
          open pahshr;
       endif;

       if not %open(pahsd0);
          open pahsd0;
       endif;

       if not %open(pahsd1);
          open pahsd1;
       endif;

       if not %open(pahsd2);
          open pahsd2;
       endif;

       if not %open(pahsep);
          open pahsep;
       endif;

       if not %open(pahsfa);
          open pahsfa;
       endif;

       if not %open(pahslk);
          open pahslk;
       endif;

       if not %open(pahsus);
          open pahsus;
       endif;

       if not %open(pawscd);
          open pawscd;
       endif;

       if not %open(pahsct);
          open pahsct;
       endif;

       if not %open(pahsd3);
          open pahsd3;
       endif;

       if not %open(pahsd4);
          open pahsd4;
       endif;

       if not %open(pahsd5);
          open pahsd5;
       endif;

       if not %open(pahsnc);
          open pahsnc;
       endif;

       if not %open(pahsoc);
          open pahsoc;
       endif;

       if not %open(pahssp);
          open pahssp;
       endif;

       if not %open(pahstc);
          open pahstc;
       endif;

       if not %open(pahsva);
          open pahsva;
       endif;

       if not %open(pahsvt);
          open pahsvt;
       endif;

       if not %open(pahsao);
          open pahsao;
       endif;

       if not %open(pahsag);
          open pahsag;
       endif;

       if not %open(gti980s);
          open gti980s;
       endif;

       if not %open(pahscl);
          open pahscl;
       endif;

       if not %open(set904);
          open set904;
       endif;

       if not %open(pahst1);
          open pahst1;
       endif;

       if not %open(pahst2);
          open pahst2;
       endif;

       if not %open(pahsd0b);
          open pahsd0b;
       endif;

       if not %open(pahsd0c);
          open pahsd0c;
       endif;

       if not %open(pahsd1b);
          open pahsd1b;
       endif;

       if not %open(pahsd1c);
          open pahsd1c;
       endif;

       if not %open(pds00005);
          open pds00005;
       endif;

       if not %open(pahsdt01);
          open pahsdt01;
       endif;

       if not %open(pahsi0);
          open pahsi0;
       endif;

       if not %open(pahsi1);
          open pahsi1;
       endif;

       if not %open(pahscd03);
          open pahscd03;
       endif;

       if not %open(set401);
          open set401;
       endif;

       if not %open(set402);
          open set402;
       endif;

       if not %open(set466);
          open set466;
       endif;

       if not %open(pahjcr);
          open pahjcr;
       endif;

       if not %open(pawsbe);
          open pawsbe;
       endif;

       if not %open(pahslp);
          open pahslp;
       endif;

       if not %open(cntmfp);
          open cntmfp;
       endif;

       if not %open(pahshp01);
          open pahshp01;
       endif;

       if not %open(cnhric);
          open cnhric;
       endif;

       if not %open(cnhrid);
          open cnhrid;
       endif;

      /end-free

     P SVPSI1_inz      E
      * ------------------------------------------------------------ *
      * SVPSI1_End(): Finaliza módulo.                               *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPSI1_End      B                   export
     D SVPSI1_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPSI1_End      E

      * ------------------------------------------------------------ *
      * SVPSI1_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPSI1_Error    B                   export
     D SVPSI1_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPSI1_Error    E

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

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahscd(): Retorna datos de Pahscd                       *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                ( opcional ) *
      *         peNops   ( input  ) Operación de Siniestro   ( opcional ) *
      *         peLscd   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLscdC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahscd...
     P                 B                   export
     D SVPSI1_getPahscd...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options( *Nopass : *Omit ) const
     D   peNops                       7  0 options( *Nopass : *Omit ) const
     D   peLscd                            likeds(dsPahscd_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLscdC                     10i 0 options( *Nopass : *Omit )

     D   k1yscd        ds                  likerec( p1hscd : *key    )
     D   @@DsIcd       ds                  likerec( p1hscd : *input  )
     D   @@DsCd        ds                  likeds ( dsPahscd_t ) dim( 9999 )
     D   @@DsCdC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsCd;
       @@DsCdC = 0;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;

       if %parms >= 4;
         Select;
           when %addr( peSini ) <> *null and
                %addr( peNops ) <> *null;

                k1yscd.cdSini = peSini;
                k1yscd.cdNops = peNops;
                setll %kds( k1yscd : 5 ) pahscd;
                if not %equal( pahscd );
                  return *off;
                endif;
                reade(n) %kds( k1yscd : 5 ) pahscd @@DsICd;
                dow not %eof( pahscd );
                  @@DsCdC += 1;
                  eval-corr @@DsCd ( @@DsCdC ) = @@DsICd;
                 reade(n) %kds( k1yscd : 5 ) pahscd @@DsICd;
                enddo;

           when %addr( peSini ) <> *null and
                %addr( peNops ) =  *null;

                k1yscd.cdSini = peSini;
                setll %kds( k1yscd : 4 ) pahscd;
                if not %equal( pahscd );
                  return *off;
                endif;
                reade(n) %kds( k1yscd : 4 ) pahscd @@DsICd;
                dow not %eof( pahscd );
                  @@DsCdC += 1;
                  eval-corr @@DsCd ( @@DsCdC ) = @@DsICd;
                 reade(n) %kds( k1yscd : 4 ) pahscd @@DsICd;
                enddo;
           other;
                setll %kds( k1yscd : 3 ) pahscd;
                if not %equal( pahscd );
                  return *off;
                endif;
                reade(n) %kds( k1yscd : 3 ) pahscd @@DsICd;
                dow not %eof( pahscd );
                  @@DsCdC += 1;
                  eval-corr @@DsCd ( @@DsCdC ) = @@DsICd;
                 reade(n) %kds( k1yscd : 3 ) pahscd @@DsICd;
                enddo;
           endsl;
       else;

         setll %kds( k1yscd : 3 ) pahscd;
         if not %equal( pahscd );
           return *off;
         endif;
         reade(n) %kds( k1yscd : 3 ) pahscd @@DsICd;
         dow not %eof( pahscd );
           @@DsCdC += 1;
           eval-corr @@DsCd ( @@DsCdC ) = @@DsICd;
          reade(n) %kds( k1yscd : 3 ) pahscd @@DsICd;
         enddo;
       endif;

       if %addr( peLscd ) <> *null;
         eval-corr peLscd = @@DsCd;
       endif;

       if %addr( peLscdC ) <> *null;
         peLscdC = @@DsCdC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahscd...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahscd(): Valida si existe siniestro               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahscd...
     P                 B                   export
     D SVPSI1_chkPahscd...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1yscd          ds                  likerec( p1hscd : *key )

      /free

       SVPSI1_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;
       k1yscd.cdnops = peNops;
       setll %kds( k1yscd : 5 ) pahscd;

       if not %equal(pahscd);
         SetError( SVPSI1_SINNE
                 : 'Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahscd...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahscd(): Graba datos en el archivo pahscd              *
      *                                                                   *
      *          peDsCd   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahscd...
     P                 B                   export
     D SVPSI1_setPahscd...
     D                 pi              n
     D   peDsCd                            likeds( dsPahscd_t ) const

     D  k1yscd         ds                  likerec( p1hscd : *key    )
     D  dsOscd         ds                  likerec( p1hscd : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahscd( peDsCd.cdEmpr
                          : peDsCd.cdSucu
                          : peDsCd.cdRama
                          : peDsCd.cdSini
                          : peDsCd.cdNops );

         return *off;
       endif;

       eval-corr DsOscd = peDsCd;
       monitor;
         write p1hscd DsOscd;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahscd...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahscd(): Actualiza datos en el archivo pahscd          *
      *                                                                   *
      *          peDsCd   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahscd...
     P                 B                   export
     D SVPSI1_updPahscd...
     D                 pi              n
     D   peDsCd                            likeds( dsPahscd_t ) const

     D  k1yscd         ds                  likerec( p1hscd : *key    )
     D  dsOscd         ds                  likerec( p1hscd : *output )

      /free

       SVPSI1_inz();

       k1yscd.cdEmpr = peDsCd.cdEmpr;
       k1yscd.cdSucu = peDsCd.cdSucu;
       k1yscd.cdRama = peDsCd.cdRama;
       k1yscd.cdSini = peDsCd.cdSini;
       k1yscd.cdNops = peDsCd.cdNops;
       chain %kds( k1yscd : 5 ) pahscd;
       if %found( pahscd );
         eval-corr dsOscd = peDsCd;
         update p1hscd dsOscd;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahscd...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahscd(): Elimina datos en el archivo pahscd            *
      *                                                                   *
      *          peDsCd   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahscd...
     P                 B                   export
     D SVPSI1_dltPahscd...
     D                 pi              n
     D   peDsCd                            likeds( dsPahscd_t ) const

     D  k1yscd         ds                  likerec( p1hscd : *key    )
     D  dsOscd         ds                  likerec( p1hscd : *output )

      /free

       SVPSI1_inz();

       k1yscd.cdEmpr = peDsCd.cdEmpr;
       k1yscd.cdSucu = peDsCd.cdSucu;
       k1yscd.cdRama = peDsCd.cdRama;
       k1yscd.cdSini = peDsCd.cdSini;
       k1yscd.cdNops = peDsCd.cdNops;
       chain %kds( k1yscd : 5 ) pahscd;
       if %found( pahscd );
         delete p1hscd;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahscd...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_getPahsbe(): Retorna datos de Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsBe   ( output ) Estructura de Beneficiarios de Sini. *
      *     peDsBeC  ( output ) Cantidad de Beneficiario de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_getPahsbe...
     P                 B                   export
     D SVPSI1_getPahsbe...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options(*nopass:*omit) const
     D   peNops                       7  0 options(*nopass:*omit) const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsBe                            likeds ( DsPahsbe_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsBeC                     10i 0 options(*nopass:*omit)

     D   k1ysbe        ds                  likerec( p1hsbe : *key   )
     D   @@DsIbe       ds                  likerec( p1hsbe : *input )
     D   @@DsBe        ds                  likeds ( DsPahsbe_t ) dim(9999)
     D   @@DsBeC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsBe;
       clear @@DsBeC;

       k1ysbe.beEmpr = peEmpr;
       k1ysbe.beSucu = peSucu;
       k1ysbe.beRama = peRama;

       select;
         when %parms >= 11 and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null;

           k1ysbe.beSini =  peSini;
           k1ysbe.beNops =  peNops;
           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           k1ysbe.beNrdf =  peNrdf;
           k1ysbe.beSebe =  peSebe;
           setll %kds( k1ysbe : 11 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 11 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 11 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 10 and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null;

           k1ysbe.beSini =  peSini;
           k1ysbe.beNops =  peNops;
           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           k1ysbe.beNrdf =  peNrdf;
           setll %kds( k1ysbe : 10 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 10 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 10 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 9  and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) =  *null
                           and %addr( peSebe ) =  *null;

           k1ysbe.beSini =  peSini;
           k1ysbe.beNops =  peNops;
           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           setll %kds( k1ysbe : 9 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 9 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 9 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 8  and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) =  *null
                           and %addr( peNrdf ) =  *null
                           and %addr( peSebe ) =  *null;

           k1ysbe.beSini =  peSini;
           k1ysbe.beNops =  peNops;
           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           setll %kds( k1ysbe : 8 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 8 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 8 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 7 and %addr( peSini ) <> *null
                          and %addr( peNops ) <> *null
                          and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.beSini =  peSini;
           k1ysbe.beNops =  peNops;
           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           setll %kds( k1ysbe : 7 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 7 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 7 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 6 and %addr( peSini ) <> *null
                          and %addr( peNops ) <> *null
                          and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.beSini =  peSini;
           k1ysbe.beNops =  peNops;
           k1ysbe.bePoco =  pePoco;
           setll %kds( k1ysbe : 6 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 6 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 6 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 5 and %addr( peSini ) <> *null
                          and %addr( peNops ) <> *null
                          and %addr( pePoco ) =  *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.beSini =  peSini;
           k1ysbe.beNops =  peNops;
           setll %kds( k1ysbe : 5 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 5 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 5 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 4 and %addr( peSini ) <> *null
                          and %addr( peNops ) =  *null
                          and %addr( pePoco ) =  *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.beSini =  peSini;
           setll %kds( k1ysbe : 4 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 4 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 4 ) pahsbe @@DsIbe;
           enddo;

         other;

           setll %kds( k1ysbe : 3 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 3 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 3 ) pahsbe @@DsIbe;
           enddo;

       endsl;

       if %addr( peDsBe ) <> *null;
         eval-corr peDsBe = @@DsBe;
       endif;

       if %addr( peDsBeC ) <> *null;
         peDsBeC = @@DsBeC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsbe...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbe(): Valida si existe Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsbe...
     P                 B                   export
     D SVPSI1_chkPahsbe...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

     D   k1ysbe        ds                  likerec( p1hsbe : *key   )

      /free

       SVPSI1_inz();

       k1ysbe.beEmpr = peEmpr;
       k1ysbe.beSucu = peSucu;
       k1ysbe.beRama = peRama;
       k1ysbe.beSini = peSini;
       k1ysbe.beNops = peNops;
       k1ysbe.bePoco = pePoco;
       k1ysbe.bePaco = pePaco;
       k1ysbe.beRiec = peRiec;
       k1ysbe.beXcob = peXcob;
       k1ysbe.beNrdf = peNrdf;
       k1ysbe.beSebe = peSebe;
       setll %kds( k1ysbe : 11 ) pahsbe;

       if not %equal(pahsbe);
         SetError( SVPSI1_BENNE
                 : 'Beneficiario Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsbe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbe(): Graba datos en el archivo pahsbe              *
      *                                                                   *
      *          peDsBe   ( input  ) Estrutura de pahsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsbe...
     P                 B                   export
     D SVPSI1_setPahsbe...
     D                 pi              n
     D   peDsBe                            likeds( dsPahsbe_t ) const

     D  k1ysbe         ds                  likerec( p1hsbe : *key    )
     D  dsOsbe         ds                  likerec( p1hsbe : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsbe( peDsBe.beEmpr
                          : peDsBe.beSucu
                          : peDsBe.beRama
                          : peDsBe.beSini
                          : peDsBe.beNops
                          : peDsBe.bePoco
                          : peDsBe.bePaco
                          : peDsBe.beRiec
                          : peDsBe.beXcob
                          : peDsBe.beNrdf
                          : peDsBe.beSebe );

         return *off;
       endif;

       eval-corr DsOsbe = peDsBe;
       monitor;
         write p1hsbe DsOsbe;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsbe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbe(): Actualiza datos en el archivo pahsbe          *
      *                                                                   *
      *          peDsBe   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsbe...
     P                 B                   export
     D SVPSI1_updPahsbe...
     D                 pi              n
     D   peDsBe                            likeds( dsPahsbe_t ) const

     D  k1ysbe         ds                  likerec( p1hsbe : *key    )
     D  dsOsbe         ds                  likerec( p1hsbe : *output )

      /free

       SVPSI1_inz();

       k1ysbe.beEmpr = peDsBe.beEmpr;
       k1ysbe.beSucu = peDsBe.beSucu;
       k1ysbe.beRama = peDsBe.beRama;
       k1ysbe.beSini = peDsBe.beSini;
       k1ysbe.beNops = peDsBe.beNops;
       k1ysbe.bePoco = peDsBe.bePoco;
       k1ysbe.bePaco = peDsBe.bePaco;
       k1ysbe.beRiec = peDsBe.beRiec;
       k1ysbe.beXcob = peDsBe.beXcob;
       k1ysbe.beNrdf = peDsBe.beNrdf;
       k1ysbe.beSebe = peDsBe.beSebe;
       chain %kds( k1ysbe : 11 ) pahsbe;
       if %found( pahsbe );
         eval-corr dsOsbe = peDsBe;
         update p1hsbe dsOsbe;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsbe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbe(): Elimina datos en el archivo pahsbe            *
      *                                                                   *
      *          peDsBe   ( input  ) Estrutura de pahsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsbe...
     P                 B                   export
     D SVPSI1_dltPahsbe...
     D                 pi              n
     D   peDsBe                            likeds( dsPahsbe_t ) const

     D  k1ysbe         ds                  likerec( p1hsbe : *key    )
     D  dsOsbe         ds                  likerec( p1hsbe : *output )

      /free

       SVPSI1_inz();

       k1ysbe.beEmpr = peDsBe.beEmpr;
       k1ysbe.beSucu = peDsBe.beSucu;
       k1ysbe.beRama = peDsBe.beRama;
       k1ysbe.beSini = peDsBe.beSini;
       k1ysbe.beNops = peDsBe.beNops;
       k1ysbe.bePoco = peDsBe.bePoco;
       k1ysbe.bePaco = peDsBe.bePaco;
       k1ysbe.beRiec = peDsBe.beRiec;
       k1ysbe.beXcob = peDsBe.beXcob;
       k1ysbe.beNrdf = peDsBe.beNrdf;
       k1ysbe.beSebe = peDsBe.beSebe;
       chain %kds( k1ysbe : 11 ) pahsbe;
       if %found( pahsbe );
         delete p1hsbe;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsbe...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsbo(): Retorna datos de Objeto de Siniestro          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peOsec   ( input  ) Secuencia de Objeto                   *
      *         peLsbo   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsboC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsbo...
     P                 B                   export
     D SVPSI1_getPahsbo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peLsbo                            likeds(dsPahsbo_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsboC                     10i 0 options( *Nopass : *Omit )

     D   k1ysbo        ds                  likerec( p1hsbo : *key    )
     D   @@DsIbo       ds                  likerec( p1hsbo : *input  )
     D   @@Dsbo        ds                  likeds ( dsPahsbo_t ) dim( 9999 )
     D   @@DsboC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsbo;
       @@DsboC = 0;

       k1ysbo.boEmpr = peEmpr;
       k1ysbo.boSucu = peSucu;
       k1ysbo.boRama = peRama;
       k1ysbo.boSini = peSini;
       k1ysbo.boNops = peNops;
       k1ysbo.boPoco = pePoco;
       k1ysbo.boPaco = pePaco;
       k1ysbo.boRiec = peRiec;
       k1ysbo.boXcob = peXcob;
       k1ysbo.boOsec = peOsec;

       setll %kds( k1ysbo : 10 ) pahsbo;
       if not %equal( pahsbo );
          return *off;
       endif;
       reade(n) %kds( k1ysbo : 10 ) pahsbo @@DsIbo;
       dow not %eof( pahsbo );
          @@DsboC += 1;
          eval-corr @@Dsbo ( @@DsboC ) = @@DsIbo;
       reade(n) %kds( k1ysbo : 10 ) pahsbo @@DsIbo;
       enddo;

       if %addr( peLsbo ) <> *null;
         eval-corr peLsbo = @@Dsbo;
       endif;

       if %addr( peLsboC ) <> *null;
         peLsboC = @@DsboC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsbo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbo(): Valida si existe objeto de siniestro     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peOsec   ( input  ) Secuencia de Objeto              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsbo...
     P                 B                   export
     D SVPSI1_chkPahsbo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const

     D k1ysbo          ds                  likerec( p1hsbo : *key )

      /free

       SVPSI1_inz();

       k1ysbo.boEmpr = peEmpr;
       k1ysbo.boSucu = peSucu;
       k1ysbo.boRama = peRama;
       k1ysbo.boSini = peSini;
       k1ysbo.boNops = peNops;
       k1ysbo.boPoco = pePoco;
       k1ysbo.boPaco = pePaco;
       k1ysbo.boRiec = peRiec;
       k1ysbo.boXcob = peXcob;
       k1ysbo.boOsec = peOsec;
       setll %kds( k1ysbo : 10 ) pahsbo;

       if not %equal(pahsbo);
         SetError( SVPSI1_OBJNE
                 : 'Objeto Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsbo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbo(): Graba datos en el archivo pahsbo              *
      *                                                                   *
      *          peDsbo   ( input  ) Estrutura de pahsbo                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsbo...
     P                 B                   export
     D SVPSI1_setPahsbo...
     D                 pi              n
     D   peDsbo                            likeds( dsPahsbo_t ) const

     D  k1ysbo         ds                  likerec( p1hsbo : *key    )
     D  dsOsbo         ds                  likerec( p1hsbo : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsbo( peDsbo.boEmpr
                          : peDsbo.boSucu
                          : peDsbo.boRama
                          : peDsbo.boSini
                          : peDsbo.boNops
                          : peDsbo.boPoco
                          : peDsbo.boPaco
                          : peDsbo.boRiec
                          : peDsbo.boXcob
                          : peDsbo.boOsec );

         return *off;
       endif;

       eval-corr DsOsbo = peDsbo;
       monitor;
         write p1hsbo DsOsbo;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsbo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbo(): Actualiza datos en el archivo pahsbo          *
      *                                                                   *
      *          peDsbo   ( input  ) Estrutura de pahsbo                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsbo...
     P                 B                   export
     D SVPSI1_updPahsbo...
     D                 pi              n
     D   peDsbo                            likeds( dsPahsbo_t ) const

     D  k1ysbo         ds                  likerec( p1hsbo : *key    )
     D  dsOsbo         ds                  likerec( p1hsbo : *output )

      /free

       SVPSI1_inz();

       k1ysbo.boEmpr = peDsbo.boEmpr;
       k1ysbo.boSucu = peDsbo.boSucu;
       k1ysbo.boRama = peDsbo.boRama;
       k1ysbo.boSini = peDsbo.boSini;
       k1ysbo.boNops = peDsbo.boNops;
       k1ysbo.boPoco = peDsbo.boPoco;
       k1ysbo.boPaco = peDsbo.boPaco;
       k1ysbo.boRiec = peDsbo.boRiec;
       k1ysbo.boXcob = peDsbo.boXcob;
       k1ysbo.boOsec = peDsbo.boOsec;
       chain %kds( k1ysbo : 10 ) pahsbo;
       if %found( pahsbo );
         eval-corr dsOsbo = peDsbo;
         update p1hsbo dsOsbo;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsbo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbo(): Elimina datos en el archivo pahsbo            *
      *                                                                   *
      *          peDsbo   ( input  ) Estrutura de pahsbo                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsbo...
     P                 B                   export
     D SVPSI1_dltPahsbo...
     D                 pi              n
     D   peDsbo                            likeds( dsPahsbo_t ) const

     D  k1ysbo         ds                  likerec( p1hsbo : *key    )
     D  dsOsbo         ds                  likerec( p1hsbo : *output )

      /free

       SVPSI1_inz();

       k1ysbo.boEmpr = peDsbo.boEmpr;
       k1ysbo.boSucu = peDsbo.boSucu;
       k1ysbo.boRama = peDsbo.boRama;
       k1ysbo.boSini = peDsbo.boSini;
       k1ysbo.boNops = peDsbo.boNops;
       k1ysbo.boPoco = peDsbo.boPoco;
       k1ysbo.boPaco = peDsbo.boPaco;
       k1ysbo.boRiec = peDsbo.boRiec;
       k1ysbo.boXcob = peDsbo.boXcob;
       k1ysbo.boOsec = peDsbo.boOsec;
       chain %kds( k1ysbo : 10 ) pahsbo;
       if %found( pahsbo );
         delete p1hsbo;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsbo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsbr(): Retorna datos de Reasegurado                  *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio del Movimiento                   *
      *         peFmom   ( input  ) Mes  del Movimiento                   *
      *         peFmod   ( input  ) Dia  del Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLsbr   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsbrC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsbr...
     P                 B                   export
     D SVPSI1_getPahsbr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLsbr                            likeds(dsPahsbr_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsbrC                     10i 0 options( *Nopass : *Omit )

     D   k1ysbr        ds                  likerec( p1hsbr : *key    )
     D   @@DsIbr       ds                  likerec( p1hsbr : *input  )
     D   @@Dsbr        ds                  likeds ( dsPahsbr_t ) dim( 9999 )
     D   @@DsbrC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsbr;
       @@DsbrC = 0;

       k1ysbr.brEmpr = peEmpr;
       k1ysbr.brSucu = peSucu;
       k1ysbr.brRama = peRama;
       k1ysbr.brSini = peSini;
       k1ysbr.brNops = peNops;
       k1ysbr.brPoco = pePoco;
       k1ysbr.brPaco = pePaco;
       k1ysbr.brNrdf = peNrdf;
       k1ysbr.brSebe = peSebe;
       k1ysbr.brRiec = peRiec;
       k1ysbr.brXcob = peXcob;
       k1ysbr.brFmoa = peFmoa;
       k1ysbr.brFmom = peFmom;
       k1ysbr.brFmod = peFmod;
       k1ysbr.brPsec = pePsec;

       setll %kds( k1ysbr : 15 ) pahsbr;
       if not %equal( pahsbr );
          return *off;
       endif;
       reade(n) %kds( k1ysbr : 15 ) pahsbr @@DsIbr;
       dow not %eof( pahsbr );
          @@DsbrC += 1;
          eval-corr @@Dsbr ( @@DsbrC ) = @@DsIbr;
       reade(n) %kds( k1ysbr : 15 ) pahsbr @@DsIbr;
       enddo;

       if %addr( peLsbr ) <> *null;
         eval-corr peLsbr = @@Dsbr;
       endif;

       if %addr( peLsbrC ) <> *null;
         peLsbrC = @@DsbrC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsbr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbr(): Valida si existe Reasegurado             *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peFmoa   ( input  ) Anio del Movimiento              *
      *         peFmom   ( input  ) Mes  del Movimiento              *
      *         peFmod   ( input  ) Dia  del Movimiento              *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsbr...
     P                 B                   export
     D SVPSI1_chkPahsbr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

     D k1ysbr          ds                  likerec( p1hsbr : *key )

      /free

       SVPSI1_inz();

       k1ysbr.brEmpr = peEmpr;
       k1ysbr.brSucu = peSucu;
       k1ysbr.brRama = peRama;
       k1ysbr.brSini = peSini;
       k1ysbr.brNops = peNops;
       k1ysbr.brPoco = pePoco;
       k1ysbr.brPaco = pePaco;
       k1ysbr.brNrdf = peNrdf;
       k1ysbr.brSebe = peSebe;
       k1ysbr.brRiec = peRiec;
       k1ysbr.brXcob = peXcob;
       k1ysbr.brFmoa = peFmoa;
       k1ysbr.brFmom = peFmom;
       k1ysbr.brFmod = peFmod;
       k1ysbr.brPsec = pePsec;
       setll %kds( k1ysbr : 15 ) pahsbr;

       if not %equal(pahsbr);
         SetError( SVPSI1_REANE
                 : 'Reasegurado Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsbr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbr(): Graba datos en el archivo pahsbr              *
      *                                                                   *
      *          peDsbr   ( input  ) Estrutura de pahsbr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsbr...
     P                 B                   export
     D SVPSI1_setPahsbr...
     D                 pi              n
     D   peDsbr                            likeds( dsPahsbr_t ) const

     D  k1ysbr         ds                  likerec( p1hsbr : *key    )
     D  dsOsbr         ds                  likerec( p1hsbr : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsbr( peDsbr.brEmpr
                          : peDsbr.brSucu
                          : peDsbr.brRama
                          : peDsbr.brSini
                          : peDsbr.brNops
                          : peDsbr.brPoco
                          : peDsbr.brPaco
                          : peDsbr.brNrdf
                          : peDsbr.brSebe
                          : peDsbr.brRiec
                          : peDsbr.brXcob
                          : peDsbr.brFmoa
                          : peDsbr.brFmom
                          : peDsbr.brFmod
                          : peDsbr.brPsec );

         return *off;
       endif;

       eval-corr DsOsbr = peDsbr;
       monitor;
         write p1hsbr DsOsbr;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsbr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbr(): Actualiza datos en el archivo pahsbr          *
      *                                                                   *
      *          peDsbr   ( input  ) Estrutura de pahsbr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsbr...
     P                 B                   export
     D SVPSI1_updPahsbr...
     D                 pi              n
     D   peDsbr                            likeds( dsPahsbr_t ) const

     D  k1ysbr         ds                  likerec( p1hsbr : *key    )
     D  dsOsbr         ds                  likerec( p1hsbr : *output )

      /free

       SVPSI1_inz();

       k1ysbr.brEmpr = peDsbr.brEmpr;
       k1ysbr.brSucu = peDsbr.brSucu;
       k1ysbr.brRama = peDsbr.brRama;
       k1ysbr.brSini = peDsbr.brSini;
       k1ysbr.brNops = peDsbr.brNops;
       k1ysbr.brPoco = peDsbr.brPoco;
       k1ysbr.brPaco = peDsbr.brPaco;
       k1ysbr.brNrdf = peDsbr.brNrdf;
       k1ysbr.brSebe = peDsbr.brSebe;
       k1ysbr.brRiec = peDsbr.brRiec;
       k1ysbr.brXcob = peDsbr.brXcob;
       k1ysbr.brFmoa = peDsbr.brFmoa;
       k1ysbr.brFmom = peDsbr.brFmom;
       k1ysbr.brFmod = peDsbr.brFmod;
       k1ysbr.brPsec = peDsbr.brPsec;
       chain %kds( k1ysbr : 15 ) pahsbr;
       if %found( pahsbr );
         eval-corr dsOsbr = peDsbr;
         update p1hsbr dsOsbr;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsbr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbr(): Elimina datos en el archivo pahsbr            *
      *                                                                   *
      *          peDsbr   ( input  ) Estrutura de pahsbr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsbr...
     P                 B                   export
     D SVPSI1_dltPahsbr...
     D                 pi              n
     D   peDsbr                            likeds( dsPahsbr_t ) const

     D  k1ysbr         ds                  likerec( p1hsbr : *key    )
     D  dsOsbr         ds                  likerec( p1hsbr : *output )

      /free

       SVPSI1_inz();

       k1ysbr.brEmpr = peDsbr.brEmpr;
       k1ysbr.brSucu = peDsbr.brSucu;
       k1ysbr.brRama = peDsbr.brRama;
       k1ysbr.brSini = peDsbr.brSini;
       k1ysbr.brNops = peDsbr.brNops;
       k1ysbr.brPoco = peDsbr.brPoco;
       k1ysbr.brPaco = peDsbr.brPaco;
       k1ysbr.brNrdf = peDsbr.brNrdf;
       k1ysbr.brSebe = peDsbr.brSebe;
       k1ysbr.brRiec = peDsbr.brRiec;
       k1ysbr.brXcob = peDsbr.brXcob;
       k1ysbr.brFmoa = peDsbr.brFmoa;
       k1ysbr.brFmom = peDsbr.brFmom;
       k1ysbr.brFmod = peDsbr.brFmod;
       k1ysbr.brPsec = peDsbr.brPsec;
       chain %kds( k1ysbr : 15 ) pahsbr;
       if %found( pahsbr );
         delete p1hsbr;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsbr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsbs(): Retorna datos de Bienes Siniestrados          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                   (opcional)*
      *         peNops   ( input  ) Operación de Siniestro      (opcional)*
      *         pePoco   ( input  ) Nro Componente              (opcional)*
      *         pePaco   ( input  ) Cod Parentesco              (opcional)*
      *         peRiec   ( input  ) Cod Riesgo                  (opcional)*
      *         peXcob   ( input  ) Cod Cobertura               (opcional)*
      *         peLsbs   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsbsC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsbs...
     P                 B                   export
     D SVPSI1_getPahsbs...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options(*nopass:*omit) const
     D   peNops                       7  0 options(*nopass:*omit) const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peLsbs                            likeds(dsPahsbs_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsbsC                     10i 0 options( *Nopass : *Omit )

     D   k1ysbs        ds                  likerec( p1hsbs : *key    )
     D   @@DsIbs       ds                  likerec( p1hsbs : *input  )
     D   @@Dsbs        ds                  likeds ( dsPahsbs_t ) dim( 9999 )
     D   @@DsbsC       s             10i 0
      *  Cantidad de campos claves utilizados en operaciones de acceso
     D   @@NrCla       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsbs;
       @@DsbsC = 0;
       // Mueve los obligatorios
       k1ysbs.bsEmpr = peEmpr;
       k1ysbs.bsSucu = peSucu;
       k1ysbs.bsRama = peRama;
       select;
         when %parms >= 9  and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null;
         k1ysbs.bsSini = peSini;
         k1ysbs.bsNops = peNops;
         k1ysbs.bsPoco = pePoco;
         k1ysbs.bsPaco = pePaco;
         k1ysbs.bsRiec = peRiec;
         k1ysbs.bsXcob = peXcob;
         @@NrCla = 9;
         when %parms >= 8  and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) = *null;
         k1ysbs.bsSini = peSini;
         k1ysbs.bsNops = peNops;
         k1ysbs.bsPoco = pePoco;
         k1ysbs.bsPaco = pePaco;
         k1ysbs.bsRiec = peRiec;
         @@NrCla = 8;
         when %parms >= 7  and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) = *null
                           and %addr( peXcob ) = *null;
         k1ysbs.bsSini = peSini;
         k1ysbs.bsNops = peNops;
         k1ysbs.bsPoco = pePoco;
         k1ysbs.bsPaco = pePaco;
         @@NrCla = 7;
         when %parms >= 6  and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) <> *null
                           and %addr( pePaco ) = *null
                           and %addr( peRiec ) = *null
                           and %addr( peXcob ) = *null;
         k1ysbs.bsSini = peSini;
         k1ysbs.bsNops = peNops;
         k1ysbs.bsPoco = pePoco;
         @@NrCla = 6;
         when %parms >= 5  and %addr( peSini ) <> *null
                           and %addr( peNops ) <> *null
                           and %addr( pePoco ) = *null
                           and %addr( pePaco ) = *null
                           and %addr( peRiec ) = *null
                           and %addr( peXcob ) = *null;
         k1ysbs.bsSini = peSini;
         k1ysbs.bsNops = peNops;
         @@NrCla = 5;
         when %parms >= 4  and %addr( peSini ) <> *null
                           and %addr( peNops ) = *null
                           and %addr( pePoco ) = *null
                           and %addr( pePaco ) = *null
                           and %addr( peRiec ) = *null
                           and %addr( peXcob ) = *null;
         k1ysbs.bsSini = peSini;
         @@NrCla = 4;
         other;
         // Solo lee por los obligatorios
         @@NrCla = 3;
       endsl;

       // Posiciona por utilizando solo los paramatros recibidos
       setll %kds( k1ysbs : @@NrCla ) pahsbs;
       if not %equal( pahsbs );
          return *off;
       endif;
       reade(n) %kds( k1ysbs : @@NrCla ) pahsbs @@DsIbs;
       dow not %eof( pahsbs );
          @@DsbsC += 1;
          eval-corr @@Dsbs ( @@DsbsC ) = @@DsIbs;
          reade(n) %kds( k1ysbs : @@NrCla ) pahsbs @@DsIbs;
       enddo;

       if %addr( peLsbs ) <> *null;
         eval-corr peLsbs = @@Dsbs;
       endif;

       if %addr( peLsbsC ) <> *null;
         peLsbsC = @@DsbsC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsbs...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbs(): Valida si existe bienes siniestrados     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsbs...
     P                 B                   export
     D SVPSI1_chkPahsbs...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

     D k1ysbs          ds                  likerec( p1hsbs : *key )

      /free

       SVPSI1_inz();

       k1ysbs.bsEmpr = peEmpr;
       k1ysbs.bsSucu = peSucu;
       k1ysbs.bsRama = peRama;
       k1ysbs.bsSini = peSini;
       k1ysbs.bsNops = peNops;
       k1ysbs.bsPoco = pePoco;
       k1ysbs.bsPaco = pePaco;
       k1ysbs.bsRiec = peRiec;
       k1ysbs.bsXcob = peXcob;
       setll %kds( k1ysbs : 9 ) pahsbs;

       if not %equal(pahsbs);
         SetError( SVPSI1_BIENE
                 : 'Bienes Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsbs...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbs(): Graba datos en el archivo pahsbs              *
      *                                                                   *
      *          peDsbs   ( input  ) Estrutura de pahsbs                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsbs...
     P                 B                   export
     D SVPSI1_setPahsbs...
     D                 pi              n
     D   peDsbs                            likeds( dsPahsbs_t ) const

     D  k1ysbs         ds                  likerec( p1hsbs : *key    )
     D  dsOsbs         ds                  likerec( p1hsbs : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsbs( peDsbs.bsEmpr
                          : peDsbs.bsSucu
                          : peDsbs.bsRama
                          : peDsbs.bsSini
                          : peDsbs.bsNops
                          : peDsbs.bsPoco
                          : peDsbs.bsPaco
                          : peDsbs.bsRiec
                          : peDsbs.bsXcob );

         return *off;
       endif;

       eval-corr DsOsbs = peDsbs;
       monitor;
         write p1hsbs DsOsbs;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsbs...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbs(): Actualiza datos en el archivo pahsbs          *
      *                                                                   *
      *          peDsbs   ( input  ) Estrutura de pahsbs                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsbs...
     P                 B                   export
     D SVPSI1_updPahsbs...
     D                 pi              n
     D   peDsbs                            likeds( dsPahsbs_t ) const

     D  k1ysbs         ds                  likerec( p1hsbs : *key    )
     D  dsOsbs         ds                  likerec( p1hsbs : *output )

      /free

       SVPSI1_inz();

       k1ysbs.bsEmpr = peDsbs.bsEmpr;
       k1ysbs.bsSucu = peDsbs.bsSucu;
       k1ysbs.bsRama = peDsbs.bsRama;
       k1ysbs.bsSini = peDsbs.bsSini;
       k1ysbs.bsNops = peDsbs.bsNops;
       k1ysbs.bsPoco = peDsbs.bsPoco;
       k1ysbs.bsPaco = peDsbs.bsPaco;
       k1ysbs.bsRiec = peDsbs.bsRiec;
       k1ysbs.bsXcob = peDsbs.bsXcob;
       chain %kds( k1ysbs : 9 ) pahsbs;
       if %found( pahsbs );
         eval-corr dsOsbs = peDsbs;
         update p1hsbs dsOsbs;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsbs...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbs(): Elimina datos en el archivo pahsbs            *
      *                                                                   *
      *          peDsbs   ( input  ) Estrutura de pahsbs                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsbs...
     P                 B                   export
     D SVPSI1_dltPahsbs...
     D                 pi              n
     D   peDsbs                            likeds( dsPahsbs_t ) const

     D  k1ysbs         ds                  likerec( p1hsbs : *key    )
     D  dsOsbs         ds                  likerec( p1hsbs : *output )

      /free

       SVPSI1_inz();

       k1ysbs.bsEmpr = peDsbs.bsEmpr;
       k1ysbs.bsSucu = peDsbs.bsSucu;
       k1ysbs.bsRama = peDsbs.bsRama;
       k1ysbs.bsSini = peDsbs.bsSini;
       k1ysbs.bsNops = peDsbs.bsNops;
       k1ysbs.bsPoco = peDsbs.bsPoco;
       k1ysbs.bsPaco = peDsbs.bsPaco;
       k1ysbs.bsRiec = peDsbs.bsRiec;
       k1ysbs.bsXcob = peDsbs.bsXcob;
       chain %kds( k1ysbs : 9 ) pahsbs;
       if %found( pahsbs );
         delete p1hsbs;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsbs...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsb1(): Retorna datos de beneficiario / Reclamo       *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peFema   ( input  ) Anio de emision                       *
      *         peFemm   ( input  ) Mes  de emision                       *
      *         peFemd   ( input  ) Dia  de emision                       *
      *         peLsb1   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsb1C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsb1...
     P                 B                   export
     D SVPSI1_getPahsb1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   peLsb1                            likeds(dsPahsb1_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsb1C                     10i 0 options( *Nopass : *Omit )

     D   k1ysb1        ds                  likerec( p1hsb1 : *key    )
     D   @@DsIb1       ds                  likerec( p1hsb1 : *input  )
     D   @@Dsb1        ds                  likeds ( dsPahsb1_t ) dim( 9999 )
     D   @@Dsb1C       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsb1;
       @@Dsb1C = 0;

       k1ysb1.b1Empr = peEmpr;
       k1ysb1.b1Sucu = peSucu;
       k1ysb1.b1Rama = peRama;
       k1ysb1.b1Sini = peSini;
       k1ysb1.b1Nops = peNops;
       k1ysb1.b1Poco = pePoco;
       k1ysb1.b1Paco = pePaco;
       k1ysb1.b1Riec = peRiec;
       k1ysb1.b1Xcob = peXcob;
       k1ysb1.b1Nrdf = peNrdf;
       k1ysb1.b1Sebe = peSebe;
       k1ysb1.b1Fema = peFema;
       k1ysb1.b1Femm = peFemm;
       k1ysb1.b1Femd = peFemd;

       setll %kds( k1ysb1 : 14 ) pahsb1;
       if not %equal( pahsb1 );
          return *off;
       endif;
       reade(n) %kds( k1ysb1 : 14 ) pahsb1 @@DsIb1;
       dow not %eof( pahsb1 );
          @@Dsb1C += 1;
          eval-corr @@Dsb1 ( @@Dsb1C ) = @@DsIb1;
       reade(n) %kds( k1ysb1 : 14 ) pahsb1 @@DsIb1;
       enddo;

       if %addr( peLsb1 ) <> *null;
         eval-corr peLsb1 = @@Dsb1;
       endif;

       if %addr( peLsb1C ) <> *null;
         peLsb1C = @@Dsb1C;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsb1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsb1(): Valida si existe beneficiario / reclamo  *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *         peFema   ( input  ) Anio de emision                  *
      *         peFemm   ( input  ) Mes  de emision                  *
      *         peFemd   ( input  ) Dia  de emision                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsb1...
     P                 B                   export
     D SVPSI1_chkPahsb1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const

     D k1ysb1          ds                  likerec( p1hsb1 : *key )

      /free

       SVPSI1_inz();

       k1ysb1.b1Empr = peEmpr;
       k1ysb1.b1Sucu = peSucu;
       k1ysb1.b1Rama = peRama;
       k1ysb1.b1Sini = peSini;
       k1ysb1.b1Nops = peNops;
       k1ysb1.b1Poco = pePoco;
       k1ysb1.b1Paco = pePaco;
       k1ysb1.b1Riec = peRiec;
       k1ysb1.b1Xcob = peXcob;
       k1ysb1.b1Nrdf = peNrdf;
       k1ysb1.b1Sebe = peSebe;
       k1ysb1.b1Fema = peFema;
       k1ysb1.b1Femm = peFemm;
       k1ysb1.b1Femd = peFemd;
       setll %kds( k1ysb1 : 14 ) pahsb1;

       if not %equal(pahsb1);
         SetError( SVPSI1_BNRNE
                 : 'Beneficiario / Reclamo Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsb1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsb1(): Graba datos en el archivo pahsb1              *
      *                                                                   *
      *          peDsb1   ( input  ) Estrutura de pahsb1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsb1...
     P                 B                   export
     D SVPSI1_setPahsb1...
     D                 pi              n
     D   peDsb1                            likeds( dsPahsb1_t ) const

     D  k1ysb1         ds                  likerec( p1hsb1 : *key    )
     D  dsOsb1         ds                  likerec( p1hsb1 : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsb1( peDsb1.b1Empr
                          : peDsb1.b1Sucu
                          : peDsb1.b1Rama
                          : peDsb1.b1Sini
                          : peDsb1.b1Nops
                          : peDsb1.b1Poco
                          : peDsb1.b1Paco
                          : peDsb1.b1Riec
                          : peDsb1.b1Xcob
                          : peDsb1.b1Nrdf
                          : peDsb1.b1Sebe
                          : peDsb1.b1Fema
                          : peDsb1.b1Femm
                          : peDsb1.b1Femd );

         return *off;
       endif;

       eval-corr DsOsb1 = peDsb1;
       monitor;
         write p1hsb1 DsOsb1;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsb1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsb1(): Actualiza datos en el archivo pahsb1          *
      *                                                                   *
      *          peDsb1   ( input  ) Estrutura de pahsb1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsb1...
     P                 B                   export
     D SVPSI1_updPahsb1...
     D                 pi              n
     D   peDsb1                            likeds( dsPahsb1_t ) const

     D  k1ysb1         ds                  likerec( p1hsb1 : *key    )
     D  dsOsb1         ds                  likerec( p1hsb1 : *output )

      /free

       SVPSI1_inz();

       k1ysb1.b1Empr = peDsb1.b1Empr;
       k1ysb1.b1Sucu = peDsb1.b1Sucu;
       k1ysb1.b1Rama = peDsb1.b1Rama;
       k1ysb1.b1Sini = peDsb1.b1Sini;
       k1ysb1.b1Nops = peDsb1.b1Nops;
       k1ysb1.b1Poco = peDsb1.b1Poco;
       k1ysb1.b1Paco = peDsb1.b1Paco;
       k1ysb1.b1Riec = peDsb1.b1Riec;
       k1ysb1.b1Xcob = peDsb1.b1Xcob;
       k1ysb1.b1Nrdf = peDsb1.b1Nrdf;
       k1ysb1.b1Sebe = peDsb1.b1Sebe;
       k1ysb1.b1Fema = peDsb1.b1Fema;
       k1ysb1.b1Femm = peDsb1.b1Femm;
       k1ysb1.b1Femd = peDsb1.b1Femd;
       chain %kds( k1ysb1 : 14 ) pahsb1;
       if %found( pahsb1 );
         eval-corr dsOsb1 = peDsb1;
         update p1hsb1 dsOsb1;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsb1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsb1(): Elimina datos en el archivo pahsb1            *
      *                                                                   *
      *          peDsb1   ( input  ) Estrutura de pahsb1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsb1...
     P                 B                   export
     D SVPSI1_dltPahsb1...
     D                 pi              n
     D   peDsb1                            likeds( dsPahsb1_t ) const

     D  k1ysb1         ds                  likerec( p1hsb1 : *key    )
     D  dsOsb1         ds                  likerec( p1hsb1 : *output )

      /free

       SVPSI1_inz();

       k1ysb1.b1Empr = peDsb1.b1Empr;
       k1ysb1.b1Sucu = peDsb1.b1Sucu;
       k1ysb1.b1Rama = peDsb1.b1Rama;
       k1ysb1.b1Sini = peDsb1.b1Sini;
       k1ysb1.b1Nops = peDsb1.b1Nops;
       k1ysb1.b1Poco = peDsb1.b1Poco;
       k1ysb1.b1Paco = peDsb1.b1Paco;
       k1ysb1.b1Riec = peDsb1.b1Riec;
       k1ysb1.b1Xcob = peDsb1.b1Xcob;
       k1ysb1.b1Nrdf = peDsb1.b1Nrdf;
       k1ysb1.b1Sebe = peDsb1.b1Sebe;
       k1ysb1.b1Fema = peDsb1.b1Fema;
       k1ysb1.b1Femm = peDsb1.b1Femm;
       k1ysb1.b1Femd = peDsb1.b1Femd;
       chain %kds( k1ysb1 : 14 ) pahsb1;
       if %found( pahsb1 );
         delete p1hsb1;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsb1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsb2(): Retorna datos de Beneficiario Adicional       *
      *                     Conductores                                   *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peLsb2   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsb2C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsb2...
     P                 B                   export
     D SVPSI1_getPahsb2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peLsb2                            likeds(dsPahsb2_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsb2C                     10i 0 options( *Nopass : *Omit )

     D   k1ysb2        ds                  likerec( p1hsb2 : *key    )
     D   @@DsIb2       ds                  likerec( p1hsb2 : *input  )
     D   @@Dsb2        ds                  likeds ( dsPahsb2_t ) dim( 9999 )
     D   @@Dsb2C       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsb2;
       @@Dsb2C = 0;

       k1ysb2.b2Empr = peEmpr;
       k1ysb2.b2Sucu = peSucu;
       k1ysb2.b2Rama = peRama;
       k1ysb2.b2Sini = peSini;
       k1ysb2.b2Nops = peNops;
       k1ysb2.b2Poco = pePoco;
       k1ysb2.b2Paco = pePaco;
       k1ysb2.b2Riec = peRiec;
       k1ysb2.b2Xcob = peXcob;
       k1ysb2.b2Nrdf = peNrdf;
       k1ysb2.b2Sebe = peSebe;

       setll %kds( k1ysb2 : 11 ) pahsb2;
       if not %equal( pahsb2 );
          return *off;
       endif;
       reade(n) %kds( k1ysb2 : 11 ) pahsb2 @@DsIb2;
       dow not %eof( pahsb2 );
          @@Dsb2C += 1;
          eval-corr @@Dsb2 ( @@Dsb2C ) = @@DsIb2;
       reade(n) %kds( k1ysb2 : 11 ) pahsb2 @@DsIb2;
       enddo;

       if %addr( peLsb2 ) <> *null;
         eval-corr peLsb2 = @@Dsb2;
       endif;

       if %addr( peLsb2C ) <> *null;
         peLsb2C = @@Dsb2C;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsb2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsb2(): Valida si existe beneficiario adicional  *
      *                     conductores                              *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peNrdf   ( input  ) Num Persona                      *
      *         PeSebe   ( input  ) Sec. Benef. Siniestros           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsb2...
     P                 B                   export
     D SVPSI1_chkPahsb2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

     D k1ysb2          ds                  likerec( p1hsb2 : *key )

      /free

       SVPSI1_inz();

       k1ysb2.b2Empr = peEmpr;
       k1ysb2.b2Sucu = peSucu;
       k1ysb2.b2Rama = peRama;
       k1ysb2.b2Sini = peSini;
       k1ysb2.b2Nops = peNops;
       k1ysb2.b2Poco = pePoco;
       k1ysb2.b2Paco = pePaco;
       k1ysb2.b2Riec = peRiec;
       k1ysb2.b2Xcob = peXcob;
       k1ysb2.b2Nrdf = peNrdf;
       k1ysb2.b2Sebe = peSebe;
       setll %kds( k1ysb2 : 11 ) pahsb2;

       if not %equal(pahsb2);
         SetError( SVPSI1_BACNE
                 : 'Beneficiario Adicional Conductores Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsb2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsb2(): Graba datos en el archivo pahsb2              *
      *                                                                   *
      *          peDsb2   ( input  ) Estrutura de pahsb2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsb2...
     P                 B                   export
     D SVPSI1_setPahsb2...
     D                 pi              n
     D   peDsb2                            likeds( dsPahsb2_t ) const

     D  k1ysb2         ds                  likerec( p1hsb2 : *key    )
     D  dsOsb2         ds                  likerec( p1hsb2 : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsb2( peDsb2.b2Empr
                          : peDsb2.b2Sucu
                          : peDsb2.b2Rama
                          : peDsb2.b2Sini
                          : peDsb2.b2Nops
                          : peDsb2.b2Poco
                          : peDsb2.b2Paco
                          : peDsb2.b2Riec
                          : peDsb2.b2Xcob
                          : peDsb2.b2Nrdf
                          : peDsb2.b2Sebe );

         return *off;
       endif;

       eval-corr DsOsb2 = peDsb2;
       monitor;
         write p1hsb2 DsOsb2;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsb2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsb2(): Actualiza datos en el archivo pahsb2          *
      *                                                                   *
      *          peDsb2   ( input  ) Estrutura de pahsb2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsb2...
     P                 B                   export
     D SVPSI1_updPahsb2...
     D                 pi              n
     D   peDsb2                            likeds( dsPahsb2_t ) const

     D  k1ysb2         ds                  likerec( p1hsb2 : *key    )
     D  dsOsb2         ds                  likerec( p1hsb2 : *output )

      /free

       SVPSI1_inz();

       k1ysb2.b2Empr = peDsb2.b2Empr;
       k1ysb2.b2Sucu = peDsb2.b2Sucu;
       k1ysb2.b2Rama = peDsb2.b2Rama;
       k1ysb2.b2Sini = peDsb2.b2Sini;
       k1ysb2.b2Nops = peDsb2.b2Nops;
       k1ysb2.b2Poco = peDsb2.b2Poco;
       k1ysb2.b2Paco = peDsb2.b2Paco;
       k1ysb2.b2Riec = peDsb2.b2Riec;
       k1ysb2.b2Xcob = peDsb2.b2Xcob;
       k1ysb2.b2Nrdf = peDsb2.b2Nrdf;
       k1ysb2.b2Sebe = peDsb2.b2Sebe;
       chain %kds( k1ysb2 : 11 ) pahsb2;
       if %found( pahsb2 );
         eval-corr dsOsb2 = peDsb2;
         update p1hsb2 dsOsb2;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsb2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsb2(): Elimina datos en el archivo pahsb2            *
      *                                                                   *
      *          peDsb2   ( input  ) Estrutura de pahsb2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsb2...
     P                 B                   export
     D SVPSI1_dltPahsb2...
     D                 pi              n
     D   peDsb2                            likeds( dsPahsb2_t ) const

     D  k1ysb2         ds                  likerec( p1hsb2 : *key    )
     D  dsOsb2         ds                  likerec( p1hsb2 : *output )

      /free

       SVPSI1_inz();

       k1ysb2.b2Empr = peDsb2.b2Empr;
       k1ysb2.b2Sucu = peDsb2.b2Sucu;
       k1ysb2.b2Rama = peDsb2.b2Rama;
       k1ysb2.b2Sini = peDsb2.b2Sini;
       k1ysb2.b2Nops = peDsb2.b2Nops;
       k1ysb2.b2Poco = peDsb2.b2Poco;
       k1ysb2.b2Paco = peDsb2.b2Paco;
       k1ysb2.b2Riec = peDsb2.b2Riec;
       k1ysb2.b2Xcob = peDsb2.b2Xcob;
       k1ysb2.b2Nrdf = peDsb2.b2Nrdf;
       k1ysb2.b2Sebe = peDsb2.b2Sebe;
       chain %kds( k1ysb2 : 11 ) pahsb2;
       if %found( pahsb2 );
         delete p1hsb2;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsb2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsb4(): Retorna datos de Beneficiario Adicional       *
      *                     Vehiculo del Tercero                          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peLsb4   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsb4C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsb4...
     P                 B                   export
     D SVPSI1_getPahsb4...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peLsb4                            likeds(dsPahsb4_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsb4C                     10i 0 options( *Nopass : *Omit )

     D   k1ysb4        ds                  likerec( p1hsb4 : *key    )
     D   @@DsIb4       ds                  likerec( p1hsb4 : *input  )
     D   @@Dsb4        ds                  likeds ( dsPahsb4_t ) dim( 9999 )
     D   @@Dsb4C       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsb4;
       @@Dsb4C = 0;

       k1ysb4.b4Empr = peEmpr;
       k1ysb4.b4Sucu = peSucu;
       k1ysb4.b4Rama = peRama;
       k1ysb4.b4Sini = peSini;
       k1ysb4.b4Nops = peNops;
       k1ysb4.b4Poco = pePoco;
       k1ysb4.b4Paco = pePaco;
       k1ysb4.b4Riec = peRiec;
       k1ysb4.b4Xcob = peXcob;
       k1ysb4.b4Nrdf = peNrdf;
       k1ysb4.b4Sebe = peSebe;

       setll %kds( k1ysb4 : 11 ) pahsb4;
       if not %equal( pahsb4 );
          return *off;
       endif;
       reade(n) %kds( k1ysb4 : 11 ) pahsb4 @@DsIb4;
       dow not %eof( pahsb4 );
          @@Dsb4C += 1;
          eval-corr @@Dsb4 ( @@Dsb4C ) = @@DsIb4;
       reade(n) %kds( k1ysb4 : 11 ) pahsb4 @@DsIb4;
       enddo;

       if %addr( peLsb4 ) <> *null;
         eval-corr peLsb4 = @@Dsb4;
       endif;

       if %addr( peLsb4C ) <> *null;
         peLsb4C = @@Dsb4C;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsb4...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsb4(): Valida si existe beneficiario adicional  *
      *                     vehiculo del tercero                     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsb4...
     P                 B                   export
     D SVPSI1_chkPahsb4...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

     D k1ysb4          ds                  likerec( p1hsb4 : *key )

      /free

       SVPSI1_inz();

       k1ysb4.b4Empr = peEmpr;
       k1ysb4.b4Sucu = peSucu;
       k1ysb4.b4Rama = peRama;
       k1ysb4.b4Sini = peSini;
       k1ysb4.b4Nops = peNops;
       k1ysb4.b4Poco = pePoco;
       k1ysb4.b4Paco = pePaco;
       k1ysb4.b4Riec = peRiec;
       k1ysb4.b4Xcob = peXcob;
       k1ysb4.b4Nrdf = peNrdf;
       k1ysb4.b4Sebe = peSebe;
       setll %kds( k1ysb4 : 11 ) pahsb4;

       if not %equal(pahsb4);
         SetError( SVPSI1_BAVNE
                 : 'Beneficiario Adicional Vehiculo del Tercero Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsb4...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsb4(): Graba datos en el archivo pahsb4              *
      *                                                                   *
      *          peDsb4   ( input  ) Estrutura de pahsb4                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsb4...
     P                 B                   export
     D SVPSI1_setPahsb4...
     D                 pi              n
     D   peDsb4                            likeds( dsPahsb4_t ) const

     D  k1ysb4         ds                  likerec( p1hsb4 : *key    )
     D  dsOsb4         ds                  likerec( p1hsb4 : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsb4( peDsb4.b4Empr
                          : peDsb4.b4Sucu
                          : peDsb4.b4Rama
                          : peDsb4.b4Sini
                          : peDsb4.b4Nops
                          : peDsb4.b4Poco
                          : peDsb4.b4Paco
                          : peDsb4.b4Riec
                          : peDsb4.b4Xcob
                          : peDsb4.b4Nrdf
                          : peDsb4.b4Sebe );

         return *off;
       endif;

       eval-corr DsOsb4 = peDsb4;
       monitor;
         write p1hsb4 DsOsb4;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsb4...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsb4(): Actualiza datos en el archivo pahsb4          *
      *                                                                   *
      *          peDsb4   ( input  ) Estrutura de pahsb4                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsb4...
     P                 B                   export
     D SVPSI1_updPahsb4...
     D                 pi              n
     D   peDsb4                            likeds( dsPahsb4_t ) const

     D  k1ysb4         ds                  likerec( p1hsb4 : *key    )
     D  dsOsb4         ds                  likerec( p1hsb4 : *output )

      /free

       SVPSI1_inz();

       k1ysb4.b4Empr = peDsb4.b4Empr;
       k1ysb4.b4Sucu = peDsb4.b4Sucu;
       k1ysb4.b4Rama = peDsb4.b4Rama;
       k1ysb4.b4Sini = peDsb4.b4Sini;
       k1ysb4.b4Nops = peDsb4.b4Nops;
       k1ysb4.b4Poco = peDsb4.b4Poco;
       k1ysb4.b4Paco = peDsb4.b4Paco;
       k1ysb4.b4Riec = peDsb4.b4Riec;
       k1ysb4.b4Xcob = peDsb4.b4Xcob;
       k1ysb4.b4Nrdf = peDsb4.b4Nrdf;
       k1ysb4.b4Sebe = peDsb4.b4Sebe;
       chain %kds( k1ysb4 : 11 ) pahsb4;
       if %found( pahsb4 );
         eval-corr dsOsb4 = peDsb4;
         update p1hsb4 dsOsb4;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsb4...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsb4(): Elimina datos en el archivo pahsb4            *
      *                                                                   *
      *          peDsb4   ( input  ) Estrutura de pahsb4                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsb4...
     P                 B                   export
     D SVPSI1_dltPahsb4...
     D                 pi              n
     D   peDsb4                            likeds( dsPahsb4_t ) const

     D  k1ysb4         ds                  likerec( p1hsb4 : *key    )
     D  dsOsb4         ds                  likerec( p1hsb4 : *output )

      /free

       SVPSI1_inz();

       k1ysb4.b4Empr = peDsb4.b4Empr;
       k1ysb4.b4Sucu = peDsb4.b4Sucu;
       k1ysb4.b4Rama = peDsb4.b4Rama;
       k1ysb4.b4Sini = peDsb4.b4Sini;
       k1ysb4.b4Nops = peDsb4.b4Nops;
       k1ysb4.b4Poco = peDsb4.b4Poco;
       k1ysb4.b4Paco = peDsb4.b4Paco;
       k1ysb4.b4Riec = peDsb4.b4Riec;
       k1ysb4.b4Xcob = peDsb4.b4Xcob;
       k1ysb4.b4Nrdf = peDsb4.b4Nrdf;
       k1ysb4.b4Sebe = peDsb4.b4Sebe;
       chain %kds( k1ysb4 : 11 ) pahsb4;
       if %found( pahsb4 );
         delete p1hsb4;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsb4...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahscc(): Retorna datos de Cuentas Corrientes           *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peCmov   ( input  ) Cod Movimiento                        *
      *         peFmoa   ( input  ) Anio del Movimiento                   *
      *         peFmom   ( input  ) Mes  del Movimiento                   *
      *         peFmod   ( input  ) Dia  del Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLscc   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsccC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahscc...
     P                 B                   export
     D SVPSI1_getPahscc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peCmov                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLscc                            likeds(dsPahscc_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsccC                     10i 0 options( *Nopass : *Omit )

     D   k1yscc        ds                  likerec( p1hscc : *key    )
     D   @@DsIcc       ds                  likerec( p1hscc : *input  )
     D   @@Dscc        ds                  likeds ( dsPahscc_t ) dim( 9999 )
     D   @@DsccC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dscc;
       @@DsccC = 0;

       k1yscc.ccEmpr = peEmpr;
       k1yscc.ccSucu = peSucu;
       k1yscc.ccRama = peRama;
       k1yscc.ccSini = peSini;
       k1yscc.ccNops = peNops;
       k1yscc.ccCmov = peCmov;
       k1yscc.ccFmoa = peFmoa;
       k1yscc.ccFmom = peFmom;
       k1yscc.ccFmod = peFmod;
       k1yscc.ccPsec = pePsec;

       setll %kds( k1yscc : 10 ) pahscc;
       if not %equal( pahscc );
          return *off;
       endif;
       reade(n) %kds( k1yscc : 10 ) pahscc @@DsIcc;
       dow not %eof( pahscc );
          @@DsccC += 1;
          eval-corr @@Dscc ( @@DsccC ) = @@DsIcc;
       reade(n) %kds( k1yscc : 10 ) pahscc @@DsIcc;
       enddo;

       if %addr( peLscc ) <> *null;
         eval-corr peLscc = @@Dscc;
       endif;

       if %addr( peLsccC ) <> *null;
         peLsccC = @@DsccC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahscc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahscc(): Valida si existe cuenta corriente        *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         peCmov   ( input  ) Cod Movimiento                   *
      *         peFmoa   ( input  ) Anio del Movimiento              *
      *         peFmom   ( input  ) Mes  del Movimiento              *
      *         peFmod   ( input  ) Dia  del Movimiento              *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahscc...
     P                 B                   export
     D SVPSI1_chkPahscc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peCmov                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

     D k1yscc          ds                  likerec( p1hscc : *key )

      /free

       SVPSI1_inz();

       k1yscc.ccEmpr = peEmpr;
       k1yscc.ccSucu = peSucu;
       k1yscc.ccRama = peRama;
       k1yscc.ccSini = peSini;
       k1yscc.ccNops = peNops;
       k1yscc.ccCmov = peCmov;
       k1yscc.ccFmoa = peFmoa;
       k1yscc.ccFmom = peFmom;
       k1yscc.ccFmod = peFmod;
       k1yscc.ccPsec = pePsec;
       setll %kds( k1yscc : 10 ) pahscc;

       if not %equal(pahscc);
         SetError( SVPSI1_CCRNE
                 : 'Cuenta Corriente Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahscc...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahscc(): Graba datos en el archivo pahscc              *
      *                                                                   *
      *          peDscc   ( input  ) Estrutura de pahscc                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahscc...
     P                 B                   export
     D SVPSI1_setPahscc...
     D                 pi              n
     D   peDscc                            likeds( dsPahscc_t ) const

     D  k1yscc         ds                  likerec( p1hscc : *key    )
     D  dsOscc         ds                  likerec( p1hscc : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahscc( peDscc.ccEmpr
                          : peDscc.ccSucu
                          : peDscc.ccRama
                          : peDscc.ccSini
                          : peDscc.ccNops
                          : peDscc.ccCmov
                          : peDscc.ccFmoa
                          : peDscc.ccFmom
                          : peDscc.ccFmod
                          : peDscc.ccPsec );

         return *off;
       endif;

       eval-corr DsOscc = peDscc;
       monitor;
         write p1hscc DsOscc;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahscc...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahscc(): Actualiza datos en el archivo pahscc          *
      *                                                                   *
      *          peDscc   ( input  ) Estrutura de pahscc                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahscc...
     P                 B                   export
     D SVPSI1_updPahscc...
     D                 pi              n
     D   peDscc                            likeds( dsPahscc_t ) const

     D  k1yscc         ds                  likerec( p1hscc : *key    )
     D  dsOscc         ds                  likerec( p1hscc : *output )

      /free

       SVPSI1_inz();

       k1yscc.ccEmpr = peDscc.ccEmpr;
       k1yscc.ccSucu = peDscc.ccSucu;
       k1yscc.ccRama = peDscc.ccRama;
       k1yscc.ccSini = peDscc.ccSini;
       k1yscc.ccNops = peDscc.ccNops;
       k1yscc.ccCmov = peDscc.ccCmov;
       k1yscc.ccFmoa = peDscc.ccFmoa;
       k1yscc.ccFmom = peDscc.ccFmom;
       k1yscc.ccFmod = peDscc.ccFmod;
       k1yscc.ccPsec = peDscc.ccPsec;
       chain %kds( k1yscc : 10 ) pahscc;
       if %found( pahscc );
         eval-corr dsOscc = peDscc;
         update p1hscc dsOscc;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahscc...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahscc(): Elimina datos en el archivo pahscc            *
      *                                                                   *
      *          peDscc   ( input  ) Estrutura de pahscc                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahscc...
     P                 B                   export
     D SVPSI1_dltPahscc...
     D                 pi              n
     D   peDscc                            likeds( dsPahscc_t ) const

     D  k1yscc         ds                  likerec( p1hscc : *key    )
     D  dsOscc         ds                  likerec( p1hscc : *output )

      /free

       SVPSI1_inz();

       k1yscc.ccEmpr = peDscc.ccEmpr;
       k1yscc.ccSucu = peDscc.ccSucu;
       k1yscc.ccRama = peDscc.ccRama;
       k1yscc.ccSini = peDscc.ccSini;
       k1yscc.ccNops = peDscc.ccNops;
       k1yscc.ccCmov = peDscc.ccCmov;
       k1yscc.ccFmoa = peDscc.ccFmoa;
       k1yscc.ccFmom = peDscc.ccFmom;
       k1yscc.ccFmod = peDscc.ccFmod;
       k1yscc.ccPsec = peDscc.ccPsec;
       chain %kds( k1yscc : 10 ) pahscc;
       if %found( pahscc );
         delete p1hscc;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahscc...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsc1(): Retorna datos de Extensión Autos              *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsc1   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsc1C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsc1...
     P                 B                   export
     D SVPSI1_getPahsc1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLsc1                            likeds(dsPahsc1_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsc1C                     10i 0 options( *Nopass : *Omit )

     D   k1ysc1        ds                  likerec( p1hsc1 : *key    )
     D   @@DsIc1       ds                  likerec( p1hsc1 : *input  )
     D   @@Dsc1        ds                  likeds ( dsPahsc1_t ) dim( 9999 )
     D   @@Dsc1C       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsc1;
       @@Dsc1C = 0;

       k1ysc1.cd1Empr = peEmpr;
       k1ysc1.cd1Sucu = peSucu;
       k1ysc1.cd1Rama = peRama;
       k1ysc1.cd1Sini = peSini;
       k1ysc1.cd1Nops = peNops;

       setll %kds( k1ysc1 : 5 ) pahsc1;
       if not %equal( pahsc1 );
          return *off;
       endif;
       reade(n) %kds( k1ysc1 : 5 ) pahsc1 @@DsIc1;
       dow not %eof( pahsc1 );
          @@Dsc1C += 1;
          eval-corr @@Dsc1 ( @@Dsc1C ) = @@DsIc1;
       reade(n) %kds( k1ysc1 : 5 ) pahsc1 @@DsIc1;
       enddo;

       if %addr( peLsc1 ) <> *null;
         eval-corr peLsc1 = @@Dsc1;
       endif;

       if %addr( peLsc1C ) <> *null;
         peLsc1C = @@Dsc1C;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsc1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsc1(): Valida si existe extensión autos         *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsc1...
     P                 B                   export
     D SVPSI1_chkPahsc1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ysc1          ds                  likerec( p1hsc1 : *key )

      /free

       SVPSI1_inz();

       k1ysc1.cd1Empr = peEmpr;
       k1ysc1.cd1Sucu = peSucu;
       k1ysc1.cd1Rama = peRama;
       k1ysc1.cd1Sini = peSini;
       k1ysc1.cd1Nops = peNops;
       setll %kds( k1ysc1 : 5 ) pahsc1;

       if not %equal(pahsc1);
         SetError( SVPSI1_EXANE
                 : 'Extensión Autos Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsc1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsc1(): Graba datos en el archivo pahsc1              *
      *                                                                   *
      *          peDsc1   ( input  ) Estrutura de pahsc1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsc1...
     P                 B                   export
     D SVPSI1_setPahsc1...
     D                 pi              n
     D   peDsc1                            likeds( dsPahsc1_t ) const

     D  k1ysc1         ds                  likerec( p1hsc1 : *key    )
     D  dsOsc1         ds                  likerec( p1hsc1 : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsc1( peDsc1.cd1Empr
                          : peDsc1.cd1Sucu
                          : peDsc1.cd1Rama
                          : peDsc1.cd1Sini
                          : peDsc1.cd1Nops ) ;

         return *off;
       endif;

       eval-corr DsOsc1 = peDsc1;
       monitor;
         write p1hsc1 DsOsc1;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsc1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsc1(): Actualiza datos en el archivo pahsc1          *
      *                                                                   *
      *          peDsc1   ( input  ) Estrutura de pahsc1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsc1...
     P                 B                   export
     D SVPSI1_updPahsc1...
     D                 pi              n
     D   peDsc1                            likeds( dsPahsc1_t ) const

     D  k1ysc1         ds                  likerec( p1hsc1 : *key    )
     D  dsOsc1         ds                  likerec( p1hsc1 : *output )

      /free

       SVPSI1_inz();

       k1ysc1.cd1Empr = peDsc1.cd1Empr;
       k1ysc1.cd1Sucu = peDsc1.cd1Sucu;
       k1ysc1.cd1Rama = peDsc1.cd1Rama;
       k1ysc1.cd1Sini = peDsc1.cd1Sini;
       k1ysc1.cd1Nops = peDsc1.cd1Nops;
       chain %kds( k1ysc1 : 5 ) pahsc1;
       if %found( pahsc1 );
         eval-corr dsOsc1 = peDsc1;
         update p1hsc1 dsOsc1;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsc1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsc1(): Elimina datos en el archivo pahsc1            *
      *                                                                   *
      *          peDsc1   ( input  ) Estrutura de pahsc1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsc1...
     P                 B                   export
     D SVPSI1_dltPahsc1...
     D                 pi              n
     D   peDsc1                            likeds( dsPahsc1_t ) const

     D  k1ysc1         ds                  likerec( p1hsc1 : *key    )
     D  dsOsc1         ds                  likerec( p1hsc1 : *output )

      /free

       SVPSI1_inz();

       k1ysc1.cd1Empr = peDsc1.cd1Empr;
       k1ysc1.cd1Sucu = peDsc1.cd1Sucu;
       k1ysc1.cd1Rama = peDsc1.cd1Rama;
       k1ysc1.cd1Sini = peDsc1.cd1Sini;
       k1ysc1.cd1Nops = peDsc1.cd1Nops;
       chain %kds( k1ysc1 : 5 ) pahsc1;
       if %found( pahsc1 );
         delete p1hsc1;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsc1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsdt(): Retorna datos del Transporte                  *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsdt   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsdtC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsdt...
     P                 B                   export
     D SVPSI1_getPahsdt...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLsdt                            likeds(dsPahsdt_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsdtC                     10i 0 options( *Nopass : *Omit )

     D   k1ysdt        ds                  likerec( p1hsdt : *key    )
     D   @@DsIdt       ds                  likerec( p1hsdt : *input  )
     D   @@Dsdt        ds                  likeds ( dsPahsdt_t ) dim( 9999 )
     D   @@DsdtC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsdt;
       @@DsdtC = 0;

       k1ysdt.dtEmpr = peEmpr;
       k1ysdt.dtSucu = peSucu;
       k1ysdt.dtRama = peRama;
       k1ysdt.dtSini = peSini;
       k1ysdt.dtNops = peNops;

       setll %kds( k1ysdt : 5 ) pahsdt;
       if not %equal( pahsdt );
          return *off;
       endif;
       reade(n) %kds( k1ysdt : 5 ) pahsdt @@DsIdt;
       dow not %eof( pahsdt );
          @@DsdtC += 1;
          eval-corr @@Dsdt ( @@DsdtC ) = @@DsIdt;
       reade(n) %kds( k1ysdt : 5 ) pahsdt @@DsIdt;
       enddo;

       if %addr( peLsdt ) <> *null;
         eval-corr peLsdt = @@Dsdt;
       endif;

       if %addr( peLsdtC ) <> *null;
         peLsdtC = @@DsdtC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsdt...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsdt(): Valida si existe transporte              *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsdt...
     P                 B                   export
     D SVPSI1_chkPahsdt...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ysdt          ds                  likerec( p1hsdt : *key )

      /free

       SVPSI1_inz();

       k1ysdt.dtEmpr = peEmpr;
       k1ysdt.dtSucu = peSucu;
       k1ysdt.dtRama = peRama;
       k1ysdt.dtSini = peSini;
       k1ysdt.dtNops = peNops;
       setll %kds( k1ysdt : 5 ) pahsdt;

       if not %equal(pahsdt);
         SetError( SVPSI1_TRANE
                 : 'Transporte Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsdt...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsdt(): Graba datos en el archivo pahsdt              *
      *                                                                   *
      *          peDsdt   ( input  ) Estrutura de pahsdt                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsdt...
     P                 B                   export
     D SVPSI1_setPahsdt...
     D                 pi              n
     D   peDsdt                            likeds( dsPahsdt_t ) const

     D  k1ysdt         ds                  likerec( p1hsdt : *key    )
     D  dsOsdt         ds                  likerec( p1hsdt : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsdt( peDsdt.dtEmpr
                          : peDsdt.dtSucu
                          : peDsdt.dtRama
                          : peDsdt.dtSini
                          : peDsdt.dtNops );

         return *off;
       endif;

       eval-corr DsOsdt = peDsdt;
       monitor;
         write p1hsdt DsOsdt;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsdt...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsdt(): Actualiza datos en el archivo pahsdt          *
      *                                                                   *
      *          peDsdt   ( input  ) Estrutura de pahsdt                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsdt...
     P                 B                   export
     D SVPSI1_updPahsdt...
     D                 pi              n
     D   peDsdt                            likeds( dsPahsdt_t ) const

     D  k1ysdt         ds                  likerec( p1hsdt : *key    )
     D  dsOsdt         ds                  likerec( p1hsdt : *output )

      /free

       SVPSI1_inz();

       k1ysdt.dtEmpr = peDsdt.dtEmpr;
       k1ysdt.dtSucu = peDsdt.dtSucu;
       k1ysdt.dtRama = peDsdt.dtRama;
       k1ysdt.dtSini = peDsdt.dtSini;
       k1ysdt.dtNops = peDsdt.dtNops;
       chain %kds( k1ysdt : 5 ) pahsdt;
       if %found( pahsdt );
         eval-corr dsOsdt = peDsdt;
         update p1hsdt dsOsdt;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsdt...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsdt(): Elimina datos en el archivo pahsdt            *
      *                                                                   *
      *          peDsdt   ( input  ) Estrutura de pahsdt                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsdt...
     P                 B                   export
     D SVPSI1_dltPahsdt...
     D                 pi              n
     D   peDsdt                            likeds( dsPahsdt_t ) const

     D  k1ysdt         ds                  likerec( p1hsdt : *key    )
     D  dsOsdt         ds                  likerec( p1hsdt : *output )

      /free

       SVPSI1_inz();

       k1ysdt.dtEmpr = peDsdt.dtEmpr;
       k1ysdt.dtSucu = peDsdt.dtSucu;
       k1ysdt.dtRama = peDsdt.dtRama;
       k1ysdt.dtSini = peDsdt.dtSini;
       k1ysdt.dtNops = peDsdt.dtNops;
       chain %kds( k1ysdt : 5 ) pahsdt;
       if %found( pahsdt );
         delete p1hsdt;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsdt...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsfr(): Retorna datos de Importe Franquicia           *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio Movimiento                       *
      *         peFmom   ( input  ) Mes Movimiento                        *
      *         peFmod   ( input  ) Dia Movimiento                        *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLsfr   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsfrC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsfr...
     P                 B                   export
     D SVPSI1_getPahsfr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLsfr                            likeds(dsPahsfr_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsfrC                     10i 0 options( *Nopass : *Omit )

     D   k1ysfr        ds                  likerec( p1hsfr : *key    )
     D   @@DsIfr       ds                  likerec( p1hsfr : *input  )
     D   @@Dsfr        ds                  likeds ( dsPahsfr_t ) dim( 9999 )
     D   @@DsfrC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsfr;
       @@DsfrC = 0;

       k1ysfr.frEmpr = peEmpr;
       k1ysfr.frSucu = peSucu;
       k1ysfr.frRama = peRama;
       k1ysfr.frSini = peSini;
       k1ysfr.frNops = peNops;
       k1ysfr.frPoco = pePoco;
       k1ysfr.frPaco = pePaco;
       k1ysfr.frNrdf = peNrdf;
       k1ysfr.frSebe = peSebe;
       k1ysfr.frRiec = peRiec;
       k1ysfr.frXcob = peXcob;
       k1ysfr.frFmoa = peFmoa;
       k1ysfr.frFmom = peFmom;
       k1ysfr.frFmod = peFmod;
       k1ysfr.frpsec = pepsec;

       setll %kds( k1ysfr : 15 ) pahsfr;
       if not %equal( pahsfr );
          return *off;
       endif;
       reade(n) %kds( k1ysfr : 15 ) pahsfr @@DsIfr;
       dow not %eof( pahsfr );
          @@DsfrC += 1;
          eval-corr @@Dsfr ( @@DsfrC ) = @@DsIfr;
       reade(n) %kds( k1ysfr : 15 ) pahsfr @@DsIfr;
       enddo;

       if %addr( peLsfr ) <> *null;
         eval-corr peLsfr = @@Dsfr;
       endif;

       if %addr( peLsfrC ) <> *null;
         peLsfrC = @@DsfrC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahsfr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_chkPahsfr(): Valida si existe importe franquicia           *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio Movimiento                       *
      *         peFmom   ( input  ) Mes Movimiento                        *
      *         peFmod   ( input  ) Dia Movimiento                        *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *                                                                   *
      * Retorna: *On / *Off                                               *
      * ----------------------------------------------------------------- *
     P SVPSI1_chkPahsfr...
     P                 B                   export
     D SVPSI1_chkPahsfr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

     D k1ysfr          ds                  likerec( p1hsfr : *key )

      /free

       SVPSI1_inz();

       k1ysfr.frEmpr = peEmpr;
       k1ysfr.frSucu = peSucu;
       k1ysfr.frRama = peRama;
       k1ysfr.frSini = peSini;
       k1ysfr.frNops = peNops;
       k1ysfr.frPoco = pePoco;
       k1ysfr.frPaco = pePaco;
       k1ysfr.frNrdf = peNrdf;
       k1ysfr.frSebe = peSebe;
       k1ysfr.frRiec = peRiec;
       k1ysfr.frXcob = peXcob;
       k1ysfr.frFmoa = peFmoa;
       k1ysfr.frFmom = peFmom;
       k1ysfr.frFmod = peFmod;
       k1ysfr.frpsec = pepsec;
       setll %kds( k1ysfr : 15 ) pahsfr;

       if not %equal(pahsfr);
         SetError( SVPSI1_IMFNE
                 : 'Importe Franquicia Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsfr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsfr(): Graba datos en el archivo pahsfr              *
      *                                                                   *
      *          peDsfr   ( input  ) Estrutura de pahsfr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsfr...
     P                 B                   export
     D SVPSI1_setPahsfr...
     D                 pi              n
     D   peDsfr                            likeds( dsPahsfr_t ) const

     D  k1ysfr         ds                  likerec( p1hsfr : *key    )
     D  dsOsfr         ds                  likerec( p1hsfr : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsfr( peDsfr.frEmpr
                          : peDsfr.frSucu
                          : peDsfr.frRama
                          : peDsfr.frSini
                          : peDsfr.frNops
                          : peDsfr.frPoco
                          : peDsfr.frPaco
                          : peDsfr.frNrdf
                          : peDsfr.frSebe
                          : peDsfr.frRiec
                          : peDsfr.frXcob
                          : peDsfr.frFmoa
                          : peDsfr.frFmom
                          : peDsfr.frFmod
                          : peDsfr.frpsec );

         return *off;
       endif;

       eval-corr DsOsfr = peDsfr;
       monitor;
         write p1hsfr DsOsfr;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsfr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsfr(): Actualiza datos en el archivo pahsfr          *
      *                                                                   *
      *          peDsfr   ( input  ) Estrutura de pahsfr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsfr...
     P                 B                   export
     D SVPSI1_updPahsfr...
     D                 pi              n
     D   peDsfr                            likeds( dsPahsfr_t ) const

     D  k1ysfr         ds                  likerec( p1hsfr : *key    )
     D  dsOsfr         ds                  likerec( p1hsfr : *output )

      /free

       SVPSI1_inz();

       k1ysfr.frEmpr = peDsfr.frEmpr;
       k1ysfr.frSucu = peDsfr.frSucu;
       k1ysfr.frRama = peDsfr.frRama;
       k1ysfr.frSini = peDsfr.frSini;
       k1ysfr.frNops = peDsfr.frNops;
       k1ysfr.frPoco = peDsfr.frPoco;
       k1ysfr.frPaco = peDsfr.frPaco;
       k1ysfr.frNrdf = peDsfr.frNrdf;
       k1ysfr.frSebe = peDsfr.frSebe;
       k1ysfr.frRiec = peDsfr.frRiec;
       k1ysfr.frXcob = peDsfr.frXcob;
       k1ysfr.frFmoa = peDsfr.frFmoa;
       k1ysfr.frFmom = peDsfr.frFmom;
       k1ysfr.frFmod = peDsfr.frFmod;
       k1ysfr.frpsec = peDsfr.frpsec;
       chain %kds( k1ysfr : 15 ) pahsfr;
       if %found( pahsfr );
         eval-corr dsOsfr = peDsfr;
         update p1hsfr dsOsfr;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsfr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsfr(): Elimina datos en el archivo pahsfr            *
      *                                                                   *
      *          peDsfr   ( input  ) Estrutura de pahsfr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsfr...
     P                 B                   export
     D SVPSI1_dltPahsfr...
     D                 pi              n
     D   peDsfr                            likeds( dsPahsfr_t ) const

     D  k1ysfr         ds                  likerec( p1hsfr : *key    )
     D  dsOsfr         ds                  likerec( p1hsfr : *output )

      /free

       SVPSI1_inz();

       k1ysfr.frEmpr = peDsfr.frEmpr;
       k1ysfr.frSucu = peDsfr.frSucu;
       k1ysfr.frRama = peDsfr.frRama;
       k1ysfr.frSini = peDsfr.frSini;
       k1ysfr.frNops = peDsfr.frNops;
       k1ysfr.frPoco = peDsfr.frPoco;
       k1ysfr.frPaco = peDsfr.frPaco;
       k1ysfr.frNrdf = peDsfr.frNrdf;
       k1ysfr.frSebe = peDsfr.frSebe;
       k1ysfr.frRiec = peDsfr.frRiec;
       k1ysfr.frXcob = peDsfr.frXcob;
       k1ysfr.frFmoa = peDsfr.frFmoa;
       k1ysfr.frFmom = peDsfr.frFmom;
       k1ysfr.frFmod = peDsfr.frFmod;
       k1ysfr.frpsec = peDsfr.frpsec;
       chain %kds( k1ysfr : 15 ) pahsfr;
       if %found( pahsfr );
         delete p1hsfr;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsfr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahshe(): Retorna datos de Historia del Estado de Sini- *
      *                     estro                                         *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peFema   ( input  ) Fecha Emision Anio                    *
      *         peFemm   ( input  ) Fecha Emision Mes                     *
      *         peFemd   ( input  ) Fecha Emision Dia                     *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peCesi   ( input  ) Cod Estadp Siniestro                  *
      *         peLshe   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsheC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahshe...
     P                 B                   export
     D SVPSI1_getPahshe...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   pePsec                       2  0 const
     D   peCesi                       2  0 const
     D   peLshe                            likeds(dsPahshe_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsheC                     10i 0 options( *Nopass : *Omit )

     D   k1yshe        ds                  likerec( p1hshe : *key    )
     D   @@DsIhe       ds                  likerec( p1hshe : *input  )
     D   @@Dshe        ds                  likeds ( dsPahshe_t ) dim( 9999 )
     D   @@DsheC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dshe;
       @@DsheC = 0;

       k1yshe.heEmpr = peEmpr;
       k1yshe.heSucu = peSucu;
       k1yshe.heRama = peRama;
       k1yshe.heSini = peSini;
       k1yshe.heNops = peNops;
       k1yshe.heFema = peFema;
       k1yshe.heFemm = peFemm;
       k1yshe.heFemd = peFemd;
       k1yshe.hePsec = pePsec;
       k1yshe.heCesi = peCesi;

       setll %kds( k1yshe : 10 ) pahshe;
       if not %equal( pahshe );
          return *off;
       endif;
       reade(n) %kds( k1yshe : 10 ) pahshe @@DsIhe;
       dow not %eof( pahshe );
          @@DsheC += 1;
          eval-corr @@Dshe ( @@DsheC ) = @@DsIhe;
       reade(n) %kds( k1yshe : 10 ) pahshe @@DsIhe;
       enddo;

       if %addr( peLshe ) <> *null;
         eval-corr peLshe = @@Dshe;
       endif;

       if %addr( peLsheC ) <> *null;
         peLsheC = @@DsheC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahshe...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahshe(): Valida si existe historia del estado de  *
      *                     siniestro                                *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         peFema   ( input  ) Fecha Emision Anio               *
      *         peFemm   ( input  ) Fecha Emision Mes                *
      *         peFemd   ( input  ) Fecha Emision Dia                *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *         peCesi   ( input  ) Cod Estadp Siniestro             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahshe...
     P                 B                   export
     D SVPSI1_chkPahshe...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   pePsec                       2  0 const
     D   peCesi                       2  0 const

     D k1yshe          ds                  likerec( p1hshe : *key )

      /free

       SVPSI1_inz();

       k1yshe.heEmpr = peEmpr;
       k1yshe.heSucu = peSucu;
       k1yshe.heRama = peRama;
       k1yshe.heSini = peSini;
       k1yshe.heNops = peNops;
       k1yshe.heFema = peFema;
       k1yshe.heFemm = peFemm;
       k1yshe.heFemd = peFemd;
       k1yshe.hePsec = pePsec;
       k1yshe.heCesi = peCesi;
       setll %kds( k1yshe : 10 ) pahshe;

       if not %equal(pahshe);
         SetError( SVPSI1_HESNE
                 : 'Historia del Estado de Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahshe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahshe(): Graba datos en el archivo pahshe              *
      *                                                                   *
      *          peDshe   ( input  ) Estrutura de pahshe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahshe...
     P                 B                   export
     D SVPSI1_setPahshe...
     D                 pi              n
     D   peDshe                            likeds( dsPahshe_t ) const

     D  k1yshe         ds                  likerec( p1hshe : *key    )
     D  dsOshe         ds                  likerec( p1hshe : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahshe( peDshe.heEmpr
                          : peDshe.heSucu
                          : peDshe.heRama
                          : peDshe.heSini
                          : peDshe.heNops
                          : peDshe.heFema
                          : peDshe.heFemm
                          : peDshe.heFemd
                          : peDshe.hePsec
                          : peDshe.heCesi );

         return *off;
       endif;

       eval-corr DsOshe = peDshe;
       monitor;
         write p1hshe DsOshe;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahshe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahshe(): Actualiza datos en el archivo pahshe          *
      *                                                                   *
      *          peDshe   ( input  ) Estrutura de pahshe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahshe...
     P                 B                   export
     D SVPSI1_updPahshe...
     D                 pi              n
     D   peDshe                            likeds( dsPahshe_t ) const

     D  k1yshe         ds                  likerec( p1hshe : *key    )
     D  dsOshe         ds                  likerec( p1hshe : *output )

      /free

       SVPSI1_inz();

       k1yshe.heEmpr = peDshe.heEmpr;
       k1yshe.heSucu = peDshe.heSucu;
       k1yshe.heRama = peDshe.heRama;
       k1yshe.heSini = peDshe.heSini;
       k1yshe.heNops = peDshe.heNops;
       k1yshe.heFema = peDshe.heFema;
       k1yshe.heFemm = peDshe.heFemm;
       k1yshe.heFemd = peDshe.heFemd;
       k1yshe.hePsec = peDshe.hePsec;
       k1yshe.heCesi = peDshe.heCesi;
       chain %kds( k1yshe : 10 ) pahshe;
       if %found( pahshe );
         eval-corr dsOshe = peDshe;
         update p1hshe dsOshe;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahshe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahshe(): Elimina datos en el archivo pahshe            *
      *                                                                   *
      *          peDshe   ( input  ) Estrutura de pahshe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahshe...
     P                 B                   export
     D SVPSI1_dltPahshe...
     D                 pi              n
     D   peDshe                            likeds( dsPahshe_t ) const

     D  k1yshe         ds                  likerec( p1hshe : *key    )
     D  dsOshe         ds                  likerec( p1hshe : *output )

      /free

       SVPSI1_inz();

       k1yshe.heEmpr = peDshe.heEmpr;
       k1yshe.heSucu = peDshe.heSucu;
       k1yshe.heRama = peDshe.heRama;
       k1yshe.heSini = peDshe.heSini;
       k1yshe.heNops = peDshe.heNops;
       k1yshe.heFema = peDshe.heFema;
       k1yshe.heFemm = peDshe.heFemm;
       k1yshe.heFemd = peDshe.heFemd;
       k1yshe.hePsec = peDshe.hePsec;
       k1yshe.heCesi = peDshe.heCesi;
       chain %kds( k1yshe : 10 ) pahshe;
       if %found( pahshe );
         delete p1hshe;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahshe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahshp(): Retorna datos de Pagos Históricos             *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         PeSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio Movimiento                       *
      *         peFmom   ( input  ) Mes Movimiento                        *
      *         peFmod   ( input  ) Dia Movimiento                        *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLshp   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLshpC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahshp...
     P                 B                   export
     D SVPSI1_getPahshp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLshp                            likeds(dsPahshp_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLshpC                     10i 0 options( *Nopass : *Omit )

     D   k1yshp        ds                  likerec( p1hshp : *key    )
     D   @@DsIhp       ds                  likerec( p1hshp : *input  )
     D   @@Dshp        ds                  likeds ( dsPahshp_t ) dim( 9999 )
     D   @@DshpC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dshp;
       @@DshpC = 0;

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpRama = peRama;
       k1yshp.hpSini = peSini;
       k1yshp.hpNops = peNops;
       k1yshp.hpPoco = pePoco;
       k1yshp.hpPaco = pePaco;
       k1yshp.hpNrdf = peNrdf;
       k1yshp.hpSebe = peSebe;
       k1yshp.hpRiec = peRiec;
       k1yshp.hpXcob = peXcob;
       k1yshp.hpFmoa = peFmoa;
       k1yshp.hpFmom = peFmom;
       k1yshp.hpFmod = peFmod;
       k1yshp.hpPsec = pePsec;

       setll %kds( k1yshp : 15 ) pahshp;
       if not %equal( pahshp );
          return *off;
       endif;
       reade(n) %kds( k1yshp : 15 ) pahshp @@DsIhp;
       dow not %eof( pahshp );
          @@DshpC += 1;
          eval-corr @@Dshp ( @@DshpC ) = @@DsIhp;
       reade(n) %kds( k1yshp : 15 ) pahshp @@DsIhp;
       enddo;

       if %addr( peLshp ) <> *null;
         eval-corr peLshp = @@Dshp;
       endif;

       if %addr( peLshpC ) <> *null;
         peLshpC = @@DshpC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahshp...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahshp(): Valida si existe pagos históricos        *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peNrdf   ( input  ) Num Persona                      *
      *         PESebe   ( input  ) Sec. Benef. Siniestros           *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peFmoa   ( input  ) Anio Movimiento                  *
      *         peFmom   ( input  ) Mes Movimiento                   *
      *         peFmod   ( input  ) Dia Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahshp...
     P                 B                   export
     D SVPSI1_chkPahshp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

     D k1yshp          ds                  likerec( p1hshp : *key )

      /free

       SVPSI1_inz();

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpRama = peRama;
       k1yshp.hpSini = peSini;
       k1yshp.hpNops = peNops;
       k1yshp.hpPoco = pePoco;
       k1yshp.hpPaco = pePaco;
       k1yshp.hpNrdf = peNrdf;
       k1yshp.hpSebe = peSebe;
       k1yshp.hpRiec = peRiec;
       k1yshp.hpXcob = peXcob;
       k1yshp.hpFmoa = peFmoa;
       k1yshp.hpFmom = peFmom;
       k1yshp.hpFmod = peFmod;
       k1yshp.hpPsec = pePsec;
       setll %kds( k1yshp : 15 ) pahshp;

       if not %equal(pahshp);
         SetError( SVPSI1_PGHNE
                 : 'Pagos Históricos Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahshp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahshp(): Graba datos en el archivo pahshp              *
      *                                                                   *
      *          peDshp   ( input  ) Estrutura de pahshp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahshp...
     P                 B                   export
     D SVPSI1_setPahshp...
     D                 pi              n
     D   peDshp                            likeds( dsPahshp_t ) const

     D  k1yshp         ds                  likerec( p1hshp : *key    )
     D  dsOshp         ds                  likerec( p1hshp : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahshp( peDshp.hpEmpr
                          : peDshp.hpSucu
                          : peDshp.hpRama
                          : peDshp.hpSini
                          : peDshp.hpNops
                          : peDshp.hpPoco
                          : peDshp.hpPaco
                          : peDshp.hpNrdf
                          : peDshp.hpSebe
                          : peDshp.hpRiec
                          : peDshp.hpXcob
                          : peDshp.hpFmoa
                          : peDshp.hpFmom
                          : peDshp.hpFmod
                          : peDshp.hpPsec );

         return *off;
       endif;

       eval-corr DsOshp = peDshp;
       monitor;
         write p1hshp DsOshp;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahshp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahshp(): Actualiza datos en el archivo pahshp          *
      *                                                                   *
      *          peDshp   ( input  ) Estrutura de pahshp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahshp...
     P                 B                   export
     D SVPSI1_updPahshp...
     D                 pi              n
     D   peDshp                            likeds( dsPahshp_t ) const

     D  k1yshp         ds                  likerec( p1hshp : *key    )
     D  dsOshp         ds                  likerec( p1hshp : *output )

      /free

       SVPSI1_inz();

       k1yshp.hpEmpr = peDshp.hpEmpr;
       k1yshp.hpSucu = peDshp.hpSucu;
       k1yshp.hpRama = peDshp.hpRama;
       k1yshp.hpSini = peDshp.hpSini;
       k1yshp.hpNops = peDshp.hpNops;
       k1yshp.hpPoco = peDshp.hpPoco;
       k1yshp.hpPaco = peDshp.hpPaco;
       k1yshp.hpNrdf = peDshp.hpNrdf;
       k1yshp.hpSebe = peDshp.hpSebe;
       k1yshp.hpRiec = peDshp.hpRiec;
       k1yshp.hpXcob = peDshp.hpXcob;
       k1yshp.hpFmoa = peDshp.hpFmoa;
       k1yshp.hpFmom = peDshp.hpFmom;
       k1yshp.hpFmod = peDshp.hpFmod;
       k1yshp.hpPsec = peDshp.hpPsec;
       chain %kds( k1yshp : 15 ) pahshp;
       if %found( pahshp );
         eval-corr dsOshp = peDshp;
         update p1hshp dsOshp;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahshp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahshp(): Elimina datos en el archivo pahshp            *
      *                                                                   *
      *          peDshp   ( input  ) Estrutura de pahshp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahshp...
     P                 B                   export
     D SVPSI1_dltPahshp...
     D                 pi              n
     D   peDshp                            likeds( dsPahshp_t ) const

     D  k1yshp         ds                  likerec( p1hshp : *key    )
     D  dsOshp         ds                  likerec( p1hshp : *output )

      /free

       SVPSI1_inz();

       k1yshp.hpEmpr = peDshp.hpEmpr;
       k1yshp.hpSucu = peDshp.hpSucu;
       k1yshp.hpRama = peDshp.hpRama;
       k1yshp.hpSini = peDshp.hpSini;
       k1yshp.hpNops = peDshp.hpNops;
       k1yshp.hpPoco = peDshp.hpPoco;
       k1yshp.hpPaco = peDshp.hpPaco;
       k1yshp.hpNrdf = peDshp.hpNrdf;
       k1yshp.hpSebe = peDshp.hpSebe;
       k1yshp.hpRiec = peDshp.hpRiec;
       k1yshp.hpXcob = peDshp.hpXcob;
       k1yshp.hpFmoa = peDshp.hpFmoa;
       k1yshp.hpFmom = peDshp.hpFmom;
       k1yshp.hpFmod = peDshp.hpFmod;
       k1yshp.hpPsec = peDshp.hpPsec;
       chain %kds( k1yshp : 15 ) pahshp;
       if %found( pahshp );
         delete p1hshp;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahshp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahshr(): Retorna datos de Reservas Históricas          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio Movimiento                       *
      *         peFmom   ( input  ) Mes Movimiento                        *
      *         peFmod   ( input  ) Dia Movimiento                        *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLshr   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLshrC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahshr...
     P                 B                   export
     D SVPSI1_getPahshr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLshr                            likeds(dsPahshr_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLshrC                     10i 0 options( *Nopass : *Omit )

     D   k1yshr        ds                  likerec( p1hshr : *key    )
     D   @@DsIhr       ds                  likerec( p1hshr : *input  )
     D   @@Dshr        ds                  likeds ( dsPahshr_t ) dim( 9999 )
     D   @@DshrC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dshr;
       @@DshrC = 0;

       k1yshr.hrEmpr = peEmpr;
       k1yshr.hrSucu = peSucu;
       k1yshr.hrRama = peRama;
       k1yshr.hrSini = peSini;
       k1yshr.hrNops = peNops;
       k1yshr.hrPoco = pePoco;
       k1yshr.hrPaco = pePaco;
       k1yshr.hrNrdf = peNrdf;
       k1yshr.hrSebe = peSebe;
       k1yshr.hrRiec = peRiec;
       k1yshr.hrXcob = peXcob;
       k1yshr.hrFmoa = peFmoa;
       k1yshr.hrFmom = peFmom;
       k1yshr.hrFmod = peFmod;
       k1yshr.hrPsec = pePsec;

       setll %kds( k1yshr : 15 ) pahshr;
       if not %equal( pahshr );
          return *off;
       endif;
       reade(n) %kds( k1yshr : 15 ) pahshr @@DsIhr;
       dow not %eof( pahshr );
          @@DshrC += 1;
          eval-corr @@Dshr ( @@DshrC ) = @@DsIhr;
       reade(n) %kds( k1yshr : 15 ) pahshr @@DsIhr;
       enddo;

       if %addr( peLshr ) <> *null;
         eval-corr peLshr = @@Dshr;
       endif;

       if %addr( peLshrC ) <> *null;
         peLshrC = @@DshrC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahshr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahshr(): Valida si existe reservas históricas     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peFmoa   ( input  ) Anio Movimiento                  *
      *         peFmom   ( input  ) Mes Movimiento                   *
      *         peFmod   ( input  ) Dia Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahshr...
     P                 B                   export
     D SVPSI1_chkPahshr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

     D k1yshr          ds                  likerec( p1hshr : *key )

      /free

       SVPSI1_inz();

       k1yshr.hrEmpr = peEmpr;
       k1yshr.hrSucu = peSucu;
       k1yshr.hrRama = peRama;
       k1yshr.hrSini = peSini;
       k1yshr.hrNops = peNops;
       k1yshr.hrPoco = pePoco;
       k1yshr.hrPaco = pePaco;
       k1yshr.hrNrdf = peNrdf;
       k1yshr.hrSebe = peSebe;
       k1yshr.hrRiec = peRiec;
       k1yshr.hrXcob = peXcob;
       k1yshr.hrFmoa = peFmoa;
       k1yshr.hrFmom = peFmom;
       k1yshr.hrFmod = peFmod;
       k1yshr.hrPsec = pePsec;
       setll %kds( k1yshr : 15 ) pahshr;

       if not %equal(pahshr);
         SetError( SVPSI1_RHINE
                 : 'Reserva Históricas Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahshr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahshr(): Graba datos en el archivo pahshr              *
      *                                                                   *
      *          peDshr   ( input  ) Estrutura de pahshr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahshr...
     P                 B                   export
     D SVPSI1_setPahshr...
     D                 pi              n
     D   peDshr                            likeds( dsPahshr_t ) const

     D  k1yshr         ds                  likerec( p1hshr : *key    )
     D  dsOshr         ds                  likerec( p1hshr : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahshr( peDshr.hrEmpr
                          : peDshr.hrSucu
                          : peDshr.hrRama
                          : peDshr.hrSini
                          : peDshr.hrNops
                          : peDshr.hrPoco
                          : peDshr.hrPaco
                          : peDshr.hrNrdf
                          : peDshr.hrSebe
                          : peDshr.hrRiec
                          : peDshr.hrXcob
                          : peDshr.hrFmoa
                          : peDshr.hrFmom
                          : peDshr.hrFmod
                          : peDshr.hrPsec );

         return *off;
       endif;

       eval-corr DsOshr = peDshr;
       monitor;
         write p1hshr DsOshr;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahshr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahshr(): Actualiza datos en el archivo pahshr          *
      *                                                                   *
      *          peDshr   ( input  ) Estrutura de pahshr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahshr...
     P                 B                   export
     D SVPSI1_updPahshr...
     D                 pi              n
     D   peDshr                            likeds( dsPahshr_t ) const

     D  k1yshr         ds                  likerec( p1hshr : *key    )
     D  dsOshr         ds                  likerec( p1hshr : *output )

      /free

       SVPSI1_inz();

       k1yshr.hrEmpr = peDshr.hrEmpr;
       k1yshr.hrSucu = peDshr.hrSucu;
       k1yshr.hrRama = peDshr.hrRama;
       k1yshr.hrSini = peDshr.hrSini;
       k1yshr.hrNops = peDshr.hrNops;
       k1yshr.hrPoco = peDshr.hrPoco;
       k1yshr.hrPaco = peDshr.hrPaco;
       k1yshr.hrNrdf = peDshr.hrNrdf;
       k1yshr.hrSebe = peDshr.hrSebe;
       k1yshr.hrRiec = peDshr.hrRiec;
       k1yshr.hrXcob = peDshr.hrXcob;
       k1yshr.hrFmoa = peDshr.hrFmoa;
       k1yshr.hrFmom = peDshr.hrFmom;
       k1yshr.hrFmod = peDshr.hrFmod;
       k1yshr.hrPsec = peDshr.hrPsec;
       chain %kds( k1yshr : 15 ) pahshr;
       if %found( pahshr );
         eval-corr dsOshr = peDshr;
         update p1hshr dsOshr;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahshr...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahshr(): Elimina datos en el archivo pahshr            *
      *                                                                   *
      *          peDshr   ( input  ) Estrutura de pahshr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahshr...
     P                 B                   export
     D SVPSI1_dltPahshr...
     D                 pi              n
     D   peDshr                            likeds( dsPahshr_t ) const

     D  k1yshr         ds                  likerec( p1hshr : *key    )
     D  dsOshr         ds                  likerec( p1hshr : *output )

      /free

       SVPSI1_inz();

       k1yshr.hrEmpr = peDshr.hrEmpr;
       k1yshr.hrSucu = peDshr.hrSucu;
       k1yshr.hrRama = peDshr.hrRama;
       k1yshr.hrSini = peDshr.hrSini;
       k1yshr.hrNops = peDshr.hrNops;
       k1yshr.hrPoco = peDshr.hrPoco;
       k1yshr.hrPaco = peDshr.hrPaco;
       k1yshr.hrNrdf = peDshr.hrNrdf;
       k1yshr.hrSebe = peDshr.hrSebe;
       k1yshr.hrRiec = peDshr.hrRiec;
       k1yshr.hrXcob = peDshr.hrXcob;
       k1yshr.hrFmoa = peDshr.hrFmoa;
       k1yshr.hrFmom = peDshr.hrFmom;
       k1yshr.hrFmod = peDshr.hrFmod;
       k1yshr.hrPsec = peDshr.hrPsec;
       chain %kds( k1yshr : 15 ) pahshr;
       if %found( pahshr );
         delete p1hshr;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahshr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsd0(): Valida si existe detalle de la forma que *
      *                     ocurre.                                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsd0...
     P                 B                   export
     D SVPSI1_chkPahsd0...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ysd0          ds                  likerec( p1hsd0 : *key )

      /free

       SVPSI1_inz();

       k1ysd0.d0empr = peEmpr;
       k1ysd0.d0sucu = peSucu;
       k1ysd0.d0rama = peRama;
       k1ysd0.d0sini = peSini;
       k1ysd0.d0nops = peNops;
       setll %kds( k1ysd0 : 5 ) Pahsd0;

       if not %equal(Pahsd0);
         SetError( SVPSI1_DFONE
                 : 'Detalle de ocurrencia Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsd0...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsd0(): Graba datos en el archivo Pahsd0              *
      *                                                                   *
      *          peDSD0   ( input  ) Estrutura de Pahsd0                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsd0...
     P                 B                   export
     D SVPSI1_setPahsd0...
     D                 pi              n
     D   peDSD0                            likeds( dsPahsd0_t ) const

     D  k1ysd0         ds                  likerec( p1hsd0 : *key    )
     D  dsOSD0         ds                  likerec( p1hsd0 : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsd0( peDSD0.d0Empr
                          : peDSD0.d0Sucu
                          : peDSD0.d0Rama
                          : peDSD0.d0Sini
                          : peDSD0.d0Nops );

         return *off;
       endif;

       eval-corr DsOSD0 = peDSD0;
       monitor;
         write p1hsd0 DsOSD0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsd0...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsd0(): Actualiza datos en el archivo Pahsd0          *
      *                                                                   *
      *          peDSD0   ( input  ) Estrutura de Pahsd0                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsd0...
     P                 B                   export
     D SVPSI1_updPahsd0...
     D                 pi              n
     D   peDSD0                            likeds( dsPahsd0_t ) const

     D  k1ysd0         ds                  likerec( p1hsd0 : *key    )
     D  dsOSD0         ds                  likerec( p1hsd0 : *output )

      /free

       SVPSI1_inz();

       k1ysd0.d0Empr = peDSD0.d0Empr;
       k1ysd0.d0Sucu = peDSD0.d0Sucu;
       k1ysd0.d0Rama = peDSD0.d0Rama;
       k1ysd0.d0Sini = peDSD0.d0Sini;
       k1ysd0.d0Nops = peDSD0.d0Nops;
       chain %kds( k1ysd0 : 5 ) Pahsd0;
       if %found( Pahsd0 );
         eval-corr dsOSD0 = peDSD0;
         update p1hsd0 dsOSD0;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsd0...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsd0(): Elimina datos en el archivo Pahsd0            *
      *                                                                   *
      *          peDSD0   ( input  ) Estrutura de Pahsd0                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsd0...
     P                 B                   export
     D SVPSI1_dltPahsd0...
     D                 pi              n
     D   peDSD0                            likeds( dsPahsd0_t ) const

     D  k1ysd0         ds                  likerec( p1hsd0 : *key    )
     D  dsOSD0         ds                  likerec( p1hsd0 : *output )

      /free

       SVPSI1_inz();

       k1ysd0.d0Empr = peDSD0.d0Empr;
       k1ysd0.d0Sucu = peDSD0.d0Sucu;
       k1ysd0.d0Rama = peDSD0.d0Rama;
       k1ysd0.d0Sini = peDSD0.d0Sini;
       k1ysd0.d0Nops = peDSD0.d0Nops;
       chain %kds( k1ysd0 : 5 ) Pahsd0;
       if %found( Pahsd0 );
         delete p1hsd0;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsd0...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsd1(): Valida si existe detalle de daños        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrre   (input)   Nro Linea Texto                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsd1...
     P                 B                   export
     D SVPSI1_chkPahsd1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrre                       3  0 const

     D k1ysd1          ds                  likerec( p1hsd1 : *key )

      /free

       SVPSI1_inz();

       k1ysd1.d1empr = peEmpr;
       k1ysd1.d1sucu = peSucu;
       k1ysd1.d1rama = peRama;
       k1ysd1.d1sini = peSini;
       k1ysd1.d1nops = peNops;
       k1ysd1.d1nrre = peNrre;
       setll %kds( k1ysd1 : 6 ) pahsd1;

       if not %equal(pahsd1);
         SetError( SVPSI1_DTDNE
                 : 'Detalle del Daño Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsd1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsd1(): Graba datos en el archivo pahsd1              *
      *                                                                   *
      *          peDsd1   ( input  ) Estrutura de pahsd1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsd1...
     P                 B                   export
     D SVPSI1_setPahsd1...
     D                 pi              n
     D   peDsd1                            likeds( dsPahsd1_t ) const

     D  k1ysd1         ds                  likerec( p1hsd1 : *key    )
     D  dsOsd1         ds                  likerec( p1hsd1 : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsd1( peDsd1.d1Empr
                          : peDsd1.d1Sucu
                          : peDsd1.d1Rama
                          : peDsd1.d1Sini
                          : peDsd1.d1Nops
                          : peDsd1.d1Nrre );

         return *off;
       endif;

       eval-corr DsOsd1 = peDsd1;
       monitor;
         write p1hsd1 DsOsd1;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsd1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsd1(): Actualiza datos en el archivo pahsd1          *
      *                                                                   *
      *          peDsd1   ( input  ) Estrutura de pahsd1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsd1...
     P                 B                   export
     D SVPSI1_updPahsd1...
     D                 pi              n
     D   peDsd1                            likeds( dsPahsd1_t ) const

     D  k1ysd1         ds                  likerec( p1hsd1 : *key    )
     D  dsOsd1         ds                  likerec( p1hsd1 : *output )

      /free

       SVPSI1_inz();

       k1ysd1.d1Empr = peDsd1.d1Empr;
       k1ysd1.d1Sucu = peDsd1.d1Sucu;
       k1ysd1.d1Rama = peDsd1.d1Rama;
       k1ysd1.d1Sini = peDsd1.d1Sini;
       k1ysd1.d1Nops = peDsd1.d1Nops;
       chain %kds( k1ysd1 : 5 ) pahsd1;
       if %found( pahsd1 );
         eval-corr dsOsd1 = peDsd1;
         update p1hsd1 dsOsd1;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsd1...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsd1(): Elimina datos en el archivo pahsd1            *
      *                                                                   *
      *          peDsd1   ( input  ) Estrutura de pahsd1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsd1...
     P                 B                   export
     D SVPSI1_dltPahsd1...
     D                 pi              n
     D   peDsd1                            likeds( dsPahsd1_t ) const

     D  k1ysd1         ds                  likerec( p1hsd1 : *key    )
     D  dsOsd1         ds                  likerec( p1hsd1 : *output )

      /free

       SVPSI1_inz();

       k1ysd1.d1Empr = peDsd1.d1Empr;
       k1ysd1.d1Sucu = peDsd1.d1Sucu;
       k1ysd1.d1Rama = peDsd1.d1Rama;
       k1ysd1.d1Sini = peDsd1.d1Sini;
       k1ysd1.d1Nops = peDsd1.d1Nops;
       k1ysd1.d1Nrre = peDsd1.d1Nrre;
       chain %kds( k1ysd1 : 6 ) pahsd1;
       if %found( pahsd1 );
         delete p1hsd1;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsd1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkpahsd2(): Valida si existe detalle del daño - Vehi-*
      *                     culo Terceros                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkpahsd2...
     P                 B                   export
     D SVPSI1_chkpahsd2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ySD2          ds                  likerec( p1hSD2 : *key )

      /free

       SVPSI1_inz();

       k1ySD2.d2empr = peEmpr;
       k1ySD2.d2sucu = peSucu;
       k1ySD2.d2rama = peRama;
       k1ySD2.d2sini = peSini;
       k1ySD2.d2nops = peNops;
       setll %kds( k1ySD2 : 5 ) pahsd2;

       if not %equal(pahsd2);
         SetError( SVPSI1_DVTNE
                 : 'Detale del daño Vehiculos Terceros Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkpahsd2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setpahsd2(): Graba datos en el archivo pahsd2              *
      *                                                                   *
      *          peDSD2   ( input  ) Estrutura de pahsd2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setpahsd2...
     P                 B                   export
     D SVPSI1_setpahsd2...
     D                 pi              n
     D   peDSD2                            likeds( dspahsd2_t ) const

     D  k1ySD2         ds                  likerec( p1hSD2 : *key    )
     D  dsOSD2         ds                  likerec( p1hSD2 : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkpahsd2( peDSD2.d2Empr
                          : peDSD2.d2Sucu
                          : peDSD2.d2Rama
                          : peDSD2.d2Sini
                          : peDSD2.d2Nops );

         return *off;
       endif;

       eval-corr DsOSD2 = peDSD2;
       monitor;
         write p1hSD2 DsOSD2;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setpahsd2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updpahsd2(): Actualiza datos en el archivo pahsd2          *
      *                                                                   *
      *          peDSD2   ( input  ) Estrutura de pahsd2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updpahsd2...
     P                 B                   export
     D SVPSI1_updpahsd2...
     D                 pi              n
     D   peDSD2                            likeds( dspahsd2_t ) const

     D  k1ySD2         ds                  likerec( p1hSD2 : *key    )
     D  dsOSD2         ds                  likerec( p1hSD2 : *output )

      /free

       SVPSI1_inz();

       k1ySD2.d2Empr = peDSD2.d2Empr;
       k1ySD2.d2Sucu = peDSD2.d2Sucu;
       k1ySD2.d2Rama = peDSD2.d2Rama;
       k1ySD2.d2Sini = peDSD2.d2Sini;
       k1ySD2.d2Nops = peDSD2.d2Nops;
       chain %kds( k1ySD2 : 5 ) pahsd2;
       if %found( pahsd2 );
         eval-corr dsOSD2 = peDSD2;
         update p1hSD2 dsOSD2;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updpahsd2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltpahsd2(): Elimina datos en el archivo pahsd2            *
      *                                                                   *
      *          peDSD2   ( input  ) Estrutura de pahsd2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltpahsd2...
     P                 B                   export
     D SVPSI1_dltpahsd2...
     D                 pi              n
     D   peDSD2                            likeds( dspahsd2_t ) const

     D  k1ySD2         ds                  likerec( p1hSD2 : *key    )
     D  dsOSD2         ds                  likerec( p1hSD2 : *output )

      /free

       SVPSI1_inz();

       k1ySD2.d2Empr = peDSD2.d2Empr;
       k1ySD2.d2Sucu = peDSD2.d2Sucu;
       k1ySD2.d2Rama = peDSD2.d2Rama;
       k1ySD2.d2Sini = peDSD2.d2Sini;
       k1ySD2.d2Nops = peDSD2.d2Nops;
       chain %kds( k1ySD2 : 5 ) pahsd2;
       if %found( pahsd2 );
         delete p1hSD2;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltpahsd2...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsep(): Retorna datos del estado de la poliza del     *
      *                     siniestro                                     *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsep   ( output ) Lista de Siniestros                   *
      *         peLsepC  ( output ) Cantidad Siniestros                   *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsep...
     P                 B                   export
     D SVPSI1_getPahsep...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLsep                            likeds(dsPahsep_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsepC                     10i 0 options( *Nopass : *Omit )

     D   k1ysep        ds                  likerec( p1hsep : *key    )
     D   @@DsIep       ds                  likerec( p1hsep : *input  )
     D   @@Dsep        ds                  likeds ( dsPahsep_t ) dim( 9999 )
     D   @@DsepC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsep;
       @@DsepC = 0;

       k1ysep.epEmpr = peEmpr;
       k1ysep.epSucu = peSucu;
       k1ysep.epRama = peRama;
       k1ysep.epSini = peSini;
       k1ysep.epNops = peNops;
       setll %kds( k1ysep : 5 ) pahsep;
       if not %equal( pahsep );
         return *off;
       endif;
       reade(n) %kds( k1ysep : 5 ) pahsep @@DsIep;
       dow not %eof( pahsep );
         @@DsepC += 1;
         eval-corr @@Dsep ( @@DsepC ) = @@DsIep;
        reade(n) %kds( k1ysep : 5 ) pahsep @@DsIep;
       enddo;

       return *on;

      /end-free

     P SVPSI1_getPahsep...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsep(): Valida si existe estado de poliza del    *
      *                     siniestro                                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsep...
     P                 B                   export
     D SVPSI1_chkPahsep...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ysep          ds                  likerec( p1hsep : *key )

      /free

       SVPSI1_inz();

       k1ysep.epempr = peEmpr;
       k1ysep.epsucu = peSucu;
       k1ysep.eprama = peRama;
       k1ysep.epsini = peSini;
       k1ysep.epnops = peNops;
       setll %kds( k1ysep : 5 ) pahsep;
       if not %equal(pahsep);
         SetError( SVPSI1_SEPNE
                 : 'Estado de Póliza de Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsep...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsep(): Graba datos en el archivo pahsep              *
      *                                                                   *
      *          peDsep   ( input  ) Estrutura de pahsep                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsep...
     P                 B                   export
     D SVPSI1_setPahsep...
     D                 pi              n
     D   peDsep                            likeds( dsPahsep_t ) const

     D  k1ysep         ds                  likerec( p1hsep : *key    )
     D  dsOsep         ds                  likerec( p1hsep : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsep( peDsep.epEmpr
                          : peDsep.epSucu
                          : peDsep.epRama
                          : peDsep.epSini
                          : peDsep.epNops );
         return *off;
       endif;

       eval-corr DsOsep = peDsep;
       monitor;
         write p1hsep DsOsep;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsep...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsep(): Actualiza datos en el archivo pahsep          *
      *                                                                   *
      *          peDsep   ( input  ) Estrutura de pahsep                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsep...
     P                 B                   export
     D SVPSI1_updPahsep...
     D                 pi              n
     D   peDsep                            likeds( dsPahsep_t ) const

     D  k1ysep         ds                  likerec( p1hsep : *key    )
     D  dsOsep         ds                  likerec( p1hsep : *output )

      /free

       SVPSI1_inz();

       k1ysep.epEmpr = peDsep.epEmpr;
       k1ysep.epSucu = peDsep.epSucu;
       k1ysep.epRama = peDsep.epRama;
       k1ysep.epSini = peDsep.epSini;
       k1ysep.epNops = peDsep.epNops;
       chain %kds( k1ysep : 5 ) pahsep;
       if %found( pahsep );
         eval-corr dsOsep = peDsep;
         update p1hsep dsOsep;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsep...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsep(): Elimina datos en el archivo pahsep            *
      *                                                                   *
      *          peDsep   ( input  ) Estrutura de pahsep                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsep...
     P                 B                   export
     D SVPSI1_dltPahsep...
     D                 pi              n
     D   peDsep                            likeds( dsPahsep_t ) const

     D  k1ysep         ds                  likerec( p1hsep : *key    )
     D  dsOsep         ds                  likerec( p1hsep : *output )

      /free

       SVPSI1_inz();

       k1ysep.epEmpr = peDsep.epEmpr;
       k1ysep.epSucu = peDsep.epSucu;
       k1ysep.epRama = peDsep.epRama;
       k1ysep.epSini = peDsep.epSini;
       k1ysep.epNops = peDsep.epNops;
       chain %kds( k1ysep : 5 ) pahsep;
       if %found( pahsep );
         delete p1hsep;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsep...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsfa(): Retorna datos de Fallecidos                   *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsfa   ( output ) Lista de Siniestros                   *
      *         peLsfaC  ( output ) Cantidad Siniestros                   *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsfa...
     P                 B                   export
     D SVPSI1_getPahsfa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D   peLsfa                            likeds(dsPahsfa_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsfaC                     10i 0 options( *Nopass : *Omit )

     D   k1ysfa        ds                  likerec( p1hsfa : *key    )
     D   @@DsIfa       ds                  likerec( p1hsfa : *input  )
     D   @@Dsfa        ds                  likeds ( dsPahsfa_t ) dim( 9999 )
     D   @@DsfaC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dsfa;
       @@DsfaC = 0;

       k1ysfa.faEmpr = peEmpr;
       k1ysfa.faSucu = peSucu;
       k1ysfa.faRama = peRama;
       k1ysfa.faSini = peSini;
       k1ysfa.faNops = peNops;
       setll %kds( k1ysfa : 5 ) pahsfa;
       if not %equal( pahsfa );
         return *off;
       endif;
       reade(n) %kds( k1ysfa : 5 ) pahsfa @@DsIfa;
       dow not %eof( pahsfa );
         @@DsfaC += 1;
         eval-corr @@Dsfa ( @@DsfaC ) = @@DsIfa;
        reade(n) %kds( k1ysfa : 5 ) pahsfa @@DsIfa;
       enddo;

       return *on;

      /end-free

     P SVPSI1_getPahsfa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsfa(): Valida si existe fallecidos              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsfa...
     P                 B                   export
     D SVPSI1_chkPahsfa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ysfa          ds                  likerec( p1hsfa : *key )

      /free

       SVPSI1_inz();

       k1ysfa.faempr = peEmpr;
       k1ysfa.fasucu = peSucu;
       k1ysfa.farama = peRama;
       k1ysfa.fasini = peSini;
       k1ysfa.fanops = peNops;
       setll %kds( k1ysfa : 5 ) pahsfa;
       if not %equal(pahsfa);
         SetError( SVPSI1_FALNE
                 : 'Fallecido Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsfa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsfa(): Graba datos en el archivo pahsfa              *
      *                                                                   *
      *          peDsfa   ( input  ) Estrutura de pahsfa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsfa...
     P                 B                   export
     D SVPSI1_setPahsfa...
     D                 pi              n
     D   peDsfa                            likeds( dsPahsfa_t ) const

     D  k1ysfa         ds                  likerec( p1hsfa : *key    )
     D  dsOsfa         ds                  likerec( p1hsfa : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsfa( peDsfa.faEmpr
                          : peDsfa.faSucu
                          : peDsfa.faRama
                          : peDsfa.faSini
                          : peDsfa.faNops );
         return *off;
       endif;

       eval-corr DsOsfa = peDsfa;
       monitor;
         write p1hsfa DsOsfa;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsfa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsfa(): Actualiza datos en el archivo pahsfa          *
      *                                                                   *
      *          peDsfa   ( input  ) Estrutura de pahsfa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsfa...
     P                 B                   export
     D SVPSI1_updPahsfa...
     D                 pi              n
     D   peDsfa                            likeds( dsPahsfa_t ) const

     D  k1ysfa         ds                  likerec( p1hsfa : *key    )
     D  dsOsfa         ds                  likerec( p1hsfa : *output )

      /free

       SVPSI1_inz();

       k1ysfa.faEmpr = peDsfa.faEmpr;
       k1ysfa.faSucu = peDsfa.faSucu;
       k1ysfa.faRama = peDsfa.faRama;
       k1ysfa.faSini = peDsfa.faSini;
       k1ysfa.faNops = peDsfa.faNops;
       chain %kds( k1ysfa : 5 ) pahsfa;
       if %found( pahsfa );
         eval-corr dsOsfa = peDsfa;
         update p1hsfa dsOsfa;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsfa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsfa(): Elimina datos en el archivo pahsfa            *
      *                                                                   *
      *          peDsfa   ( input  ) Estrutura de pahsfa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsfa...
     P                 B                   export
     D SVPSI1_dltPahsfa...
     D                 pi              n
     D   peDsfa                            likeds( dsPahsfa_t ) const

     D  k1ysfa         ds                  likerec( p1hsfa : *key    )
     D  dsOsfa         ds                  likerec( p1hsfa : *output )

      /free

       SVPSI1_inz();

       k1ysfa.faEmpr = peDsfa.faEmpr;
       k1ysfa.faSucu = peDsfa.faSucu;
       k1ysfa.faRama = peDsfa.faRama;
       k1ysfa.faSini = peDsfa.faSini;
       k1ysfa.faNops = peDsfa.faNops;
       chain %kds( k1ysfa : 5 ) pahsfa;
       if %found( pahsfa );
         delete p1hsfa;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsfa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahslk(): Retorna datos de Sinestro en Proceso          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLslk   ( output ) Lista de Siniestros                   *
      *         peLslkC  ( output ) Cantidad Siniestros                   *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahslk...
     P                 B                   export
     D SVPSI1_getPahslk...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLslk                            likeds(dsPahslk_t) dim(9999)
     D   peLslkC                     10i 0

     D   k1yslk        ds                  likerec( p1hslk : *key    )
     D   @@DsIlk       ds                  likerec( p1hslk : *input  )
     D   @@Dslk        ds                  likeds ( dsPahslk_t ) dim( 9999 )
     D   @@DslkC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@Dslk;
       @@DslkC = 0;

       k1yslk.lkEmpr = peEmpr;
       k1yslk.lkSucu = peSucu;
       k1yslk.lkRama = peRama;
       k1yslk.lkSini = peSini;
       k1yslk.lkNops = peNops;
       setll %kds( k1yslk : 5 ) pahslk;
       if not %equal( pahslk );
         return *off;
       endif;
       reade(n) %kds( k1yslk : 5 ) pahslk @@DsIlk;
       dow not %eof( pahslk );
         @@DslkC += 1;
         eval-corr @@Dslk ( @@DslkC ) = @@DsIlk;
       reade(n) %kds( k1yslk : 5 ) pahslk @@DsIlk;
       enddo;

       return *on;

      /end-free

     P SVPSI1_getPahslk...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahslk(): Valida si existe siniestro en proceso    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahslk...
     P                 B                   export
     D SVPSI1_chkPahslk...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1yslk          ds                  likerec( p1hslk : *key )

      /free

       SVPSI1_inz();

       k1yslk.lkempr = peEmpr;
       k1yslk.lksucu = peSucu;
       k1yslk.lkrama = peRama;
       k1yslk.lksini = peSini;
       k1yslk.lknops = peNops;
       setll %kds( k1yslk : 5 ) pahslk;
       if not %equal(pahslk);
         SetError( SVPSI1_SINNE
                 : 'Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahslk...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahslk(): Graba datos en el archivo pahslk              *
      *                                                                   *
      *          peDslk   ( input  ) Estrutura de pahslk                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahslk...
     P                 B                   export
     D SVPSI1_setPahslk...
     D                 pi              n
     D   peDslk                            likeds( dsPahslk_t ) const

     D  k1yslk         ds                  likerec( p1hslk : *key    )
     D  dsOslk         ds                  likerec( p1hslk : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahslk( peDslk.lkEmpr
                          : peDslk.lkSucu
                          : peDslk.lkRama
                          : peDslk.lkSini
                          : peDslk.lkNops );

         return *off;
       endif;

       eval-corr DsOslk = peDslk;
       monitor;
         write p1hslk DsOslk;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahslk...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahslk(): Actualiza datos en el archivo pahslk          *
      *                                                                   *
      *          peDslk   ( input  ) Estrutura de pahslk                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahslk...
     P                 B                   export
     D SVPSI1_updPahslk...
     D                 pi              n
     D   peDslk                            likeds( dsPahslk_t ) const

     D  k1yslk         ds                  likerec( p1hslk : *key    )
     D  dsOslk         ds                  likerec( p1hslk : *output )

      /free

       SVPSI1_inz();

       k1yslk.lkEmpr = peDslk.lkEmpr;
       k1yslk.lkSucu = peDslk.lkSucu;
       k1yslk.lkRama = peDslk.lkRama;
       k1yslk.lkSini = peDslk.lkSini;
       k1yslk.lkNops = peDslk.lkNops;
       chain %kds( k1yslk : 5 ) pahslk;
       if %found( pahslk );
         eval-corr dsOslk = peDslk;
         update p1hslk dsOslk;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahslk...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahslk(): Elimina datos en el archivo pahslk            *
      *                                                                   *
      *          peDslk   ( input  ) Estrutura de pahslk                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahslk...
     P                 B                   export
     D SVPSI1_dltPahslk...
     D                 pi              n
     D   peDslk                            likeds( dsPahslk_t ) const

     D  k1yslk         ds                  likerec( p1hslk : *key    )
     D  dsOslk         ds                  likerec( p1hslk : *output )

      /free

       SVPSI1_inz();

       k1yslk.lkEmpr = peDslk.lkEmpr;
       k1yslk.lkSucu = peDslk.lkSucu;
       k1yslk.lkRama = peDslk.lkRama;
       k1yslk.lkSini = peDslk.lkSini;
       k1yslk.lkNops = peDslk.lkNops;
       chain %kds( k1yslk : 5 ) pahslk;
       if %found( pahslk );
         delete p1hslk;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahslk...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsus(): Retorna datos de Usuarios                     *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peUser   ( input  ) Usuario                               *
      *         peRama   ( input  ) Rama                                  *
      *         peLsus   ( output ) Lista de Usuario                      *
      *         peLsusC  ( output ) Cantidad de Usuarios                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahsus...
     P                 B                   export
     D SVPSI1_getPahsus...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peUser                      10    const
     D   peRama                       2  0 const
     D   peLsus                            likeds(dsPahsus_t) dim(9999)
     D   peLsusC                     10i 0

     D   k1ysus        ds                  likerec( p1hsus : *key    )
     D   @@DsIsu       ds                  likerec( p1hsus : *input  )
     D   @@DsSu        ds                  likeds ( dsPahsus_t ) dim( 9999 )
     D   @@DsSuC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsSu;
       @@DsSuC = 0;

       k1ysus.usEmpr = peEmpr;
       k1ysus.usSucu = peSucu;
       k1ysus.usUser = peUser;
       k1ysus.usRama = peRama;

       setll %kds( k1ysus : 4 ) pahsus;
       if not %equal( pahsus );
          return *off;
       endif;
       reade(n) %kds( k1ysus : 4 ) pahsus @@DsISu;
       dow not %eof( pahsus );
           @@DsSuC += 1;
           eval-corr @@DsSu ( @@DsSuC ) = @@DsISu;
        reade(n) %kds( k1ysus : 4 ) pahsus @@DsISu;
       enddo;

       eval-corr peLsus = @@DsSu;
       peLsusC = @@DsSuC;

       return *on;

      /end-free

     P SVPSI1_getPahsus...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsus(): Valida si existe usuario                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peUser   (input)   Usuario                               *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahsus...
     P                 B                   export
     D SVPSI1_chkPahsus...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peUser                      10    const
     D   peRama                       2  0 const

     D k1ysus          ds                  likerec( p1hsus : *key )

      /free

       SVPSI1_inz();

       k1ysus.usempr = peEmpr;
       k1ysus.ussucu = peSucu;
       k1ysus.ususer = peUser;
       k1ysus.usrama = peRama;
       setll %kds( k1ysus : 4 ) pahsus;
       if not %equal(pahsus);
         SetError( SVPSI1_USENE
                 : 'Usuario/Rama Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahsus...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsus(): Graba datos en el archivo pahsus              *
      *                                                                   *
      *          peDsus   ( input  ) Estrutura de pahsus                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahsus...
     P                 B                   export
     D SVPSI1_setPahsus...
     D                 pi              n
     D   peDsus                            likeds( dsPahsus_t ) const

     D  k1ysus         ds                  likerec( p1hsus : *key    )
     D  dsOsus         ds                  likerec( p1hsus : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahsus( peDsus.usEmpr
                          : peDsus.usSucu
                          : peDsus.usUser
                          : peDsus.usRama );

         return *off;
       endif;

       eval-corr DsOsus = peDsus;
       monitor;
         write p1hsus DsOsus;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahsus...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsus(): Actualiza datos en el archivo pahsus          *
      *                                                                   *
      *          peDsus   ( input  ) Estrutura de pahsus                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahsus...
     P                 B                   export
     D SVPSI1_updPahsus...
     D                 pi              n
     D   peDsus                            likeds( dsPahsus_t ) const

     D  k1ysus         ds                  likerec( p1hsus : *key    )
     D  dsOsus         ds                  likerec( p1hsus : *output )

      /free

       SVPSI1_inz();

       k1ysus.usEmpr = peDsus.usEmpr;
       k1ysus.usSucu = peDsus.usSucu;
       k1ysus.usUser = peDsus.usUser;
       k1ysus.usRama = peDsus.usRama;
       chain %kds( k1ysus : 4 ) pahsus;
       if %found( pahsus );
         eval-corr dsOsus = peDsus;
         update p1hsus dsOsus;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahsus...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsus(): Elimina datos en el archivo pahsus            *
      *                                                                   *
      *          peDsus   ( input  ) Estrutura de pahsus                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahsus...
     P                 B                   export
     D SVPSI1_dltPahsus...
     D                 pi              n
     D   peDsus                            likeds( dsPahsus_t ) const

     D  k1ysus         ds                  likerec( p1hsus : *key    )
     D  dsOsus         ds                  likerec( p1hsus : *output )

      /free

       SVPSI1_inz();

       k1ysus.usEmpr = peDsus.usEmpr;
       k1ysus.usSucu = peDsus.usSucu;
       k1ysus.usUser = peDsus.usUser;
       k1ysus.usRama = peDsus.usRama;
       chain %kds( k1ysus : 4 ) pahsus;
       if %found( pahsus );
         delete p1hsus;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahsus...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_numeraAltaSiniestro : Númera en alta de Siniestro          *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna numero de Siniestro                                       *
      * ----------------------------------------------------------------- *
     P SVPSI1_numeraAltaSiniestro...
     P                 B                   export
     D SVPSI1_numeraAltaSiniestro...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const

     D  @@sini         s              7  0
     D  pesini         s              7  0
     D  @@pate         s             25
     D  @@Focu         s              8  0
     D  peepgm         s              3

     D  k1ysbe         ds                  likerec( p1hsbe : *key   )
     D  k1ysb1         ds                  likerec( p1hsb1 : *key   )
     D  k1ysb2         ds                  likerec( p1hsb2 : *key   )
     D  k1ysb4         ds                  likerec( p1hsb4 : *key   )
     D  k1ysbs         ds                  likerec( p1hsbs : *key   )
     D  k1ysbo         ds                  likerec( p1hsbo : *key   )
     D  k1yscc         ds                  likerec( p1hscc : *key   )
     D  k1yscd         ds                  likerec( p1hscd : *key   )
     D  k1ywscd        ds                  likerec( p1wscd : *key   )
     D  k1ysct         ds                  likerec( p1hsct : *key   )
     D  k1ysd0         ds                  likerec( p1hsd0 : *key   )
     D  k1ysd1         ds                  likerec( p1hsd1 : *key   )
     D  k1ysd2         ds                  likerec( p1hsd2 : *key   )
     D  k1ysd3         ds                  likerec( p1hsd3 : *key   )
     D  k1ysd4         ds                  likerec( p1hsd4 : *key   )
     D  k1ysd5         ds                  likerec( p1hsd5 : *key   )
     D  k1ysfa         ds                  likerec( p1hsfa : *key   )
     D  k1yshe         ds                  likerec( p1hshe : *key   )
     D  k1yshp         ds                  likerec( p1hshp : *key   )
     D  k1yshr         ds                  likerec( p1hshr : *key   )
     D  k1yslk         ds                  likerec( p1hslk : *key   )
     D  k1ysnc         ds                  likerec( p1hsnc : *key   )
     D  k1ysoc         ds                  likerec( p1hsoc : *key   )
     D  k1yssp         ds                  likerec( p1hssp : *key   )
     D  k1ystc         ds                  likerec( p1hstc : *key   )
     D  k1ysva         ds                  likerec( p1hsva : *key   )
     D  k1ysvt         ds                  likerec( p1hsvt : *key   )
     D  k1ysao         ds                  likerec( p1hsao : *key   )
     D  k1ysag         ds                  likerec( p1hsag : *key   )
     D  k1ysi0         ds                  likerec( p1hsi0 : *key   )
     D  k1ysi1         ds                  likerec( p1hsi1 : *key   )
     D  k1ysfr         ds                  likerec( p1hsfr : *key   )
     D  k1y980s        ds                  likerec( g1i980s: *key   )
     D  k1yscl         ds                  likerec( p1hscl : *key   )
     D  k1y904         ds                  likerec( s1t904 : *key   )
     D  k1yst1         ds                  likerec( p1hst1 : *key   )
     D  k1yst2         ds                  likerec( p1hst2 : *key   )
     D  k1ysd0b        ds                  likerec( p1hsd0b: *key   )
     D  k1ysd0c        ds                  likerec( p1hsd0c: *key   )
     D  k1ysd1b        ds                  likerec( p1hsd1b: *key   )
     D  k1ysd1c        ds                  likerec( p1hsd1c: *key   )
     D  k1y005         ds                  likerec( p1ds00 : *key   )
     D  k1ysdt         ds                  likerec( x1hsdt : *key   )
     D  k1ysc1         ds                  likerec( p1hsc1 : *key   )
     D @@ds456         ds                  likeds( DsSet456_t )

      /free

       SVPSI1_inz();

       pesini = *zeros ;

       @@sini = SVPSI1_numeraSet904( peEmpr
                                   : peSucu
                                   : peRama) ;

       k1ysbe.beEmpr = peEmpr;
       k1ysbe.beSucu = peSucu;
       k1ysbe.beRama = peRama;
       k1ysbe.beSini = peSini;
       k1ysbe.beNops = peNops;
       Setll %kds( k1ysbe : 5 ) p1hsbe;
       reade %kds( k1ysbe : 5 ) p1hsbe;
       dow not %eof( pahsbe );
         besini= @@sini;
         update p1hsbe;
       reade %kds( k1ysbe : 5 ) p1hsbe;
       enddo;
       unlock pahsbe;

       k1ysb1.b1Empr = peEmpr;
       k1ysb1.b1Sucu = peSucu;
       k1ysb1.b1Rama = peRama;
       k1ysb1.b1Sini = peSini;
       k1ysb1.b1Nops = peNops;
       Setll %kds( k1ysb1 : 5 ) p1hsb1;
       reade %kds( k1ysb1 : 5 ) p1hsb1;
       dow not %eof( pahsb1 );
         b1sini= @@sini;
         update p1hsb1;
       reade %kds( k1ysb1 : 5 ) p1hsb1;
       enddo;
       unlock pahsb1;

       k1ysb2.b2Empr = peEmpr;
       k1ysb2.b2Sucu = peSucu;
       k1ysb2.b2Rama = peRama;
       k1ysb2.b2Sini = peSini;
       k1ysb2.b2Nops = peNops;
       Setll %kds( k1ysb2 : 5 ) p1hsb2;
       reade %kds( k1ysb2 : 5 ) p1hsb2;
       dow not %eof( pahsb2 );
         b2sini= @@sini;
         update p1hsb2;
       reade %kds( k1ysb2 : 5 ) p1hsb2;
       enddo;
       unlock pahsb2;

       k1ysb4.b4Empr = peEmpr;
       k1ysb4.b4Sucu = peSucu;
       k1ysb4.b4Rama = peRama;
       k1ysb4.b4Sini = peSini;
       k1ysb4.b4Nops = peNops;
       Setll %kds( k1ysb4 : 5 ) p1hsb4;
       reade %kds( k1ysb4 : 5 ) p1hsb4;
       dow not %eof( pahsb4 );
         b4sini= @@sini;
         update p1hsb4;
       reade %kds( k1ysb4 : 5 ) p1hsb4;
       enddo;
       unlock pahsb4;

       k1ysbs.bsEmpr = peEmpr;
       k1ysbs.bsSucu = peSucu;
       k1ysbs.bsRama = peRama;
       k1ysbs.bsSini = peSini;
       k1ysbs.bsNops = peNops;
       Setll %kds( k1ysbs : 5 ) p1hsbs;
       reade %kds( k1ysbs : 5 ) p1hsbs;
       dow not %eof( pahsbs );
         bssini= @@sini;
         update p1hsbs;
       reade %kds( k1ysbs : 5 ) p1hsbs;
       enddo;
       unlock pahsbs;

       k1ysbo.boEmpr = peEmpr;
       k1ysbo.boSucu = peSucu;
       k1ysbo.boRama = peRama;
       k1ysbo.boSini = peSini;
       k1ysbo.boNops = peNops;
       Setll %kds( k1ysbo : 5 ) p1hsbo;
       reade %kds( k1ysbo : 5 ) p1hsbo;
       dow not %eof( pahsbo );
         bosini= @@sini;
         update p1hsbo;
       reade %kds( k1ysbo : 5 ) p1hsbo;
       enddo;
       unlock pahsbo;

       k1yscc.ccEmpr = peEmpr;
       k1yscc.ccSucu = peSucu;
       k1yscc.ccRama = peRama;
       k1yscc.ccSini = peSini;
       k1yscc.ccNops = peNops;
       Setll %kds( k1yscc : 5 ) p1hscc;
       reade %kds( k1yscc : 5 ) p1hscc;
       dow not %eof( pahscc );
         ccsini= @@sini;
         update p1hscc;
       reade %kds( k1yscc : 5 ) p1hscc;
       enddo;
       unlock pahscc;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdSini = peSini;
       k1yscd.cdNops = peNops;
       chain %kds( k1yscd : 5 ) p1hscd;
       if %found;
        cdsini = @@sini ;
        SVPSIN_getSet456( peEmpr
                        : peSucu
                        : @@Ds456) ;
        cdfdea = @@Ds456.t@fema ;
        cdfdem = @@Ds456.t@femm ;
        cdfded = @@Ds456.t@femd ;
        @@Focu = (cdfsia * 10000) + (cdfsim *   100) + cdfsid ;

        update p1hscd;

           k1ywscd.wdEmpr = cdEmpr;
           k1ywscd.wdSucu = cdSucu;
           k1ywscd.wdRama = cdRama;
           k1ywscd.wdSini = cdSini;
           k1ywscd.wdNops = cdNops;
           chain %kds( k1ywscd : 5 ) p1wscd;
           if not %found;
            wdempr = cdempr ;
            wdsucu = cdsucu ;
            wdarcd = cdarcd ;
            wdspol = cdspol ;
            wdsspo = cdsspo ;
            wdrama = cdrama ;
            wdarse = cdarse ;
            wdoper = cdoper ;
            wdsuop = cdsuop ;
            wdmonr = cdmonr ;
            wdmoeq = cdmoeq ;
            wdpoli = cdpoli ;
            wdcert = cdcert ;
            wdotom = cdotom ;
            wdasen = cdasen ;
            wdsocn = cdsocn ;
            wdsini = cdsini ;
            wdnsag = cdnsag ;
            wdnops = cdnops ;
            wdludi = cdludi ;
            wdcopo = cdcopo ;
            wdcops = cdcops ;
            wdejco = cdejco ;
            wdfsia = cdfsia ;
            wdfsim = cdfsim ;
            wdfsid = cdfsid ;
            wdfdea = cdfdea ;
            wdfdem = cdfdem ;
            wdfded = cdfded ;
            wdcesi = cdcesi ;
            wdterm = cdterm ;
            wdmar1 = cdmar1 ;
            wdmar2 = cdmar2 ;
            wdmar3 = cdmar3 ;
            wdmar4 = cdmar4 ;
            wdmar5 = cdmar5 ;
            wdstrg = *off   ;
            wduser = cduser ;
            wdtime = cdtime ;
            wdfera = cdfera ;
            wdferm = cdferm ;
            wdferd = cdferd ;
            write p1wscd ;
           endif;
        endif;
       unlock pahscd;

       k1ysc1.cd1Empr = peEmpr;
       k1ysc1.cd1Sucu = peSucu;
       k1ysc1.cd1Rama = peRama;
       k1ysc1.cd1Sini = peSini;
       k1ysc1.cd1Nops = peNops;
       Setll %kds( k1ysc1 : 5 ) p1hsc1;
       reade %kds( k1ysc1 : 5 ) p1hsc1;
       dow not %eof( pahsc1 );
         cd1sini= @@sini;
         update p1hsc1;
       reade %kds( k1ysc1 : 5 ) p1hsc1;
       enddo;
       unlock pahsc1;

       k1ysct.ctEmpr = peEmpr;
       k1ysct.ctSucu = peSucu;
       k1ysct.ctRama = peRama;
       k1ysct.ctSini = peSini;
       k1ysct.ctNops = peNops;
       Setll %kds( k1ysct : 5 ) p1hsct;
       reade %kds( k1ysct : 5 ) p1hsct;
       dow not %eof( pahsct );
         ctsini= @@sini;
         update p1hsct;
       reade %kds( k1ysct : 5 ) p1hsct;
       enddo;
       unlock pahsct;

       k1ysd0.d0Empr = peEmpr;
       k1ysd0.d0Sucu = peSucu;
       k1ysd0.d0Rama = peRama;
       k1ysd0.d0Sini = peSini;
       k1ysd0.d0Nops = peNops;
       Setll %kds( k1ysd0 : 5 ) p1hsd0;
       reade %kds( k1ysd0 : 5 ) p1hsd0;
       dow not %eof( pahsd0 );
         d0sini= @@sini;
         update p1hsd0;
       reade %kds( k1ysd0 : 5 ) p1hsd0;
       enddo;
       unlock pahsd0;

       k1ysd1.d1Empr = peEmpr;
       k1ysd1.d1Sucu = peSucu;
       k1ysd1.d1Rama = peRama;
       k1ysd1.d1Sini = peSini;
       k1ysd1.d1Nops = peNops;
       Setll %kds( k1ysd1 : 5 ) p1hsd1;
       reade %kds( k1ysd1 : 5 ) p1hsd1;
       dow not %eof( pahsd1 );
         d1sini= @@sini;
         update p1hsd1;
       reade %kds( k1ysd1 : 5 ) p1hsd1;
       enddo;
       unlock pahsd1;

       k1ysd2.d2Empr = peEmpr;
       k1ysd2.d2Sucu = peSucu;
       k1ysd2.d2Rama = peRama;
       k1ysd2.d2Sini = peSini;
       k1ysd2.d2Nops = peNops;
       Setll %kds( k1ysd2 : 5 ) p1hsd2;
       reade %kds( k1ysd2 : 5 ) p1hsd2;
       dow not %eof( pahsd2 );
         d2sini= @@sini;
         update p1hsd2;
       reade %kds( k1ysd2 : 5 ) p1hsd2;
       enddo;
       unlock pahsd2;

       k1ysd3.d3Empr = peEmpr;
       k1ysd3.d3Sucu = peSucu;
       k1ysd3.d3Rama = peRama;
       k1ysd3.d3Sini = peSini;
       k1ysd3.d3Nops = peNops;
       Setll %kds( k1ysd3 : 5 ) p1hsd3;
       reade %kds( k1ysd3 : 5 ) p1hsd3;
       dow not %eof( pahsd3 );
         d3sini= @@sini;
         update p1hsd3;
       reade %kds( k1ysd3 : 5 ) p1hsd3;
       enddo;
       unlock pahsd3;

       k1ysd4.d4Empr = peEmpr;
       k1ysd4.d4Sucu = peSucu;
       k1ysd4.d4Rama = peRama;
       k1ysd4.d4Sini = peSini;
       k1ysd4.d4Nops = peNops;
       Setll %kds( k1ysd4 : 5 ) p1hsd4;
       reade %kds( k1ysd4 : 5 ) p1hsd4;
       dow not %eof( pahsd4 );
         d4sini= @@sini;
         update p1hsd4;
       reade %kds( k1ysd4 : 5 ) p1hsd4;
       enddo;
       unlock pahsd4;

       k1ysd5.d5Empr = peEmpr;
       k1ysd5.d5Sucu = peSucu;
       k1ysd5.d5Rama = peRama;
       k1ysd5.d5Sini = peSini;
       k1ysd5.d5Nops = peNops;
       Setll %kds( k1ysd5 : 5 ) p1hsd5;
       reade %kds( k1ysd5 : 5 ) p1hsd5;
       dow not %eof( pahsd5 );
         d5sini= @@sini;
         update p1hsd5;
       reade %kds( k1ysd5 : 5 ) p1hsd5;
       enddo;
       unlock pahsd5;

       k1ysfa.faEmpr = peEmpr;
       k1ysfa.faSucu = peSucu;
       k1ysfa.faRama = peRama;
       k1ysfa.faSini = peSini;
       k1ysfa.faNops = peNops;
       Setll %kds( k1ysfa : 5 ) p1hsfa;
       reade %kds( k1ysfa : 5 ) p1hsfa;
       dow not %eof( pahsfa );
         fasini= @@sini;
         update p1hsfa;
       reade %kds( k1ysfa : 5 ) p1hsfa;
       enddo;
       unlock pahsfa;

       k1yshe.heEmpr = peEmpr;
       k1yshe.heSucu = peSucu;
       k1yshe.heRama = peRama;
       k1yshe.heSini = peSini;
       k1yshe.heNops = peNops;
       Setll %kds( k1yshe : 5 ) p1hshe;
       reade %kds( k1yshe : 5 ) p1hshe;
       dow not %eof( pahshe );
         hesini= @@sini;
         update p1hshe;
       reade %kds( k1yshe : 5 ) p1hshe;
       enddo;
       unlock pahshe;

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpRama = peRama;
       k1yshp.hpSini = peSini;
       k1yshp.hpNops = peNops;
       Setll %kds( k1yshp : 5 ) p1hshp;
       reade %kds( k1yshp : 5 ) p1hshp;
       dow not %eof( pahshp );
         hpsini= @@sini;
         update p1hshp;
       reade %kds( k1yshp : 5 ) p1hshp;
       enddo;
       unlock pahshp;

       k1yshr.hrEmpr = peEmpr;
       k1yshr.hrSucu = peSucu;
       k1yshr.hrRama = peRama;
       k1yshr.hrSini = peSini;
       k1yshr.hrNops = peNops;
       Setll %kds( k1yshr : 5 ) p1hshr;
       reade %kds( k1yshr : 5 ) p1hshr;
       dow not %eof( pahshr );
         hrsini= @@sini;
         update p1hshr;
       reade %kds( k1yshr : 5 ) p1hshr;
       enddo;
       unlock pahshr;

       k1yslk.lkEmpr = peEmpr;
       k1yslk.lkSucu = peSucu;
       k1yslk.lkRama = peRama;
       k1yslk.lkSini = peSini;
       k1yslk.lkNops = peNops;
       Setll %kds( k1yslk : 5 ) p1hslk;
       reade %kds( k1yslk : 5 ) p1hslk;
       dow not %eof( pahslk );
         lksini= @@sini;
         update p1hslk;
       reade %kds( k1yslk : 5 ) p1hslk;
       enddo;
       unlock pahslk;

       k1ysnc.ncEmpr = peEmpr;
       k1ysnc.ncSucu = peSucu;
       k1ysnc.ncRama = peRama;
       k1ysnc.ncSini = peSini;
       k1ysnc.ncNops = peNops;
       Setll %kds( k1ysnc : 5 ) p1hsnc;
       reade %kds( k1ysnc : 5 ) p1hsnc;
       dow not %eof( pahsnc );
         ncsini= @@sini;
         update p1hsnc;
       reade %kds( k1ysnc : 5 ) p1hsnc;
       enddo;
       unlock pahsnc;

       k1ysoc.ocEmpr = peEmpr;
       k1ysoc.ocSucu = peSucu;
       k1ysoc.ocRama = peRama;
       k1ysoc.ocSini = peSini;
       k1ysoc.ocNops = peNops;
       Setll %kds( k1ysoc : 5 ) p1hsoc;
       reade %kds( k1ysoc : 5 ) p1hsoc;
       dow not %eof( pahsoc );
         ocsini= @@sini;
         update p1hsoc;
       reade %kds( k1ysoc : 5 ) p1hsoc;
       enddo;
       unlock pahsoc;

       k1yssp.spEmpr = peEmpr;
       k1yssp.spSucu = peSucu;
       k1yssp.spRama = peRama;
       k1yssp.spSini = peSini;
       k1yssp.spNops = peNops;
       Setll %kds( k1yssp : 5 ) p1hssp;
       reade %kds( k1yssp : 5 ) p1hssp;
       dow not %eof( pahssp );
         spsini= @@sini;
         spmar1 = *on ;
         update p1hssp;
       reade %kds( k1yssp : 5 ) p1hssp;
       enddo;
       unlock pahssp;

       k1ystc.stEmpr = peEmpr;
       k1ystc.stSucu = peSucu;
       k1ystc.stRama = peRama;
       k1ystc.stSini = peSini;
       k1ystc.stNops = peNops;
       Setll %kds( k1ystc : 5 ) p1hstc;
       reade %kds( k1ystc : 5 ) p1hstc;
       dow not %eof( pahstc );
         stsini= @@sini;
         update p1hstc;
       reade %kds( k1ystc : 5 ) p1hstc;
       enddo;
       unlock pahstc;

       k1yst1.stEmpr = peEmpr;
       k1yst1.stSucu = peSucu;
       k1yst1.stRama = peRama;
       k1yst1.stSini = peSini;
       k1yst1.stNops = peNops;
       Setll %kds( k1yst1 : 5 ) p1hst1;
       reade %kds( k1yst1 : 5 ) p1hst1;
       dow not %eof( pahst1 );
         stsini= @@sini;
         update p1hst1;
       reade %kds( k1yst1 : 5 ) p1hst1;
       enddo;
       unlock pahst1;

       k1yst2.stEmpr = peEmpr;
       k1yst2.stSucu = peSucu;
       k1yst2.stRama = peRama;
       k1yst2.stSini = peSini;
       k1yst2.stNops = peNops;
       Setll %kds( k1yst2 : 5 ) p1hst2;
       reade %kds( k1yst2 : 5 ) p1hst2;
       dow not %eof( pahst2 );
         stsini= @@sini;
         update p1hst2;
       reade %kds( k1yst2 : 5 ) p1hst2;
       enddo;
       unlock pahst2;

       k1ysd0b.d0Empr = peEmpr;
       k1ysd0b.d0Sucu = peSucu;
       k1ysd0b.d0Rama = peRama;
       k1ysd0b.d0Sini = peSini;
       k1ysd0b.d0Nops = peNops;
       Setll %kds( k1ysd0b: 5 ) p1hsd0b;
       reade %kds( k1ysd0b: 5 ) p1hsd0b;
       dow not %eof( pahsd0b );
         d0sini= @@sini;
         update p1hsd0b;
       reade %kds( k1ysd0b: 5 ) p1hsd0b;
       enddo;
       unlock pahsd0b;

       k1ysd0c.d0Empr = peEmpr;
       k1ysd0c.d0Sucu = peSucu;
       k1ysd0c.d0Rama = peRama;
       k1ysd0c.d0Sini = peSini;
       k1ysd0c.d0Nops = peNops;
       Setll %kds( k1ysd0c: 5 ) p1hsd0c;
       reade %kds( k1ysd0c: 5 ) p1hsd0c;
       dow not %eof( pahsd0c );
         d0sini= @@sini;
         update p1hsd0c;
       reade %kds( k1ysd0c: 5 ) p1hsd0c;
       enddo;
       unlock pahsd0c;

       k1ysd1b.d1Empr = peEmpr;
       k1ysd1b.d1Sucu = peSucu;
       k1ysd1b.d1Rama = peRama;
       k1ysd1b.d1Sini = peSini;
       k1ysd1b.d1Nops = peNops;
       Setll %kds( k1ysd1b: 5 ) p1hsd1b;
       reade %kds( k1ysd1b: 5 ) p1hsd1b;
       dow not %eof( pahsd1b );
         d1sini= @@sini;
         update p1hsd1b;
       reade %kds( k1ysd1b: 5 ) p1hsd1b;
       enddo;
       unlock pahsd1b;

       k1ysd1c.d1Empr = peEmpr;
       k1ysd1c.d1Sucu = peSucu;
       k1ysd1c.d1Rama = peRama;
       k1ysd1c.d1Sini = peSini;
       k1ysd1c.d1Nops = peNops;
       Setll %kds( k1ysd1c: 5 ) p1hsd1c;
       reade %kds( k1ysd1c: 5 ) p1hsd1c;
       dow not %eof( pahsd1c );
         d1sini= @@sini;
         update p1hsd0c;
       reade %kds( k1ysd1c: 5 ) p1hsd1c;
       enddo;
       unlock pahsd1c;

       k1ysva.vaEmpr = peEmpr;
       k1ysva.vaSucu = peSucu;
       k1ysva.vaRama = peRama;
       k1ysva.vaSini = peSini;
       k1ysva.vaNops = peNops;
       Setll %kds( k1ysva : 5 ) p1hsva;
       reade %kds( k1ysva : 5 ) p1hsva;
       dow not %eof( pahsva );
         vasini= @@sini;
         @@pate= vaNmat;
         update p1hsva;
       reade %kds( k1ysva : 5 ) p1hsva;
       enddo;
       unlock pahsva;

       k1ysvt.vtEmpr = peEmpr;
       k1ysvt.vtSucu = peSucu;
       k1ysvt.vtRama = peRama;
       k1ysvt.vtSini = peSini;
       k1ysvt.vtNops = peNops;
       Setll %kds( k1ysvt : 5 ) p1hsvt;
       reade %kds( k1ysvt : 5 ) p1hsvt;
       dow not %eof( pahsvt );
         vtsini= @@sini;
         update p1hsvt;
       reade %kds( k1ysvt : 5 ) p1hsvt;
       enddo;
       unlock pahsvt;

       k1ysao.aoEmpr = peEmpr;
       k1ysao.aoSucu = peSucu;
       k1ysao.aoRama = peRama;
       k1ysao.aoSini = peSini;
       k1ysao.aoNops = peNops;
       Setll %kds( k1ysao : 5 ) p1hsao;
       reade %kds( k1ysao : 5 ) p1hsao;
       dow not %eof( pahsao );
         aosini= @@sini;
         update p1hsao;
       reade %kds( k1ysao : 5 ) p1hsao;
       enddo;
       unlock pahsao;

       k1ysag.agEmpr = peEmpr;
       k1ysag.agSucu = peSucu;
       k1ysag.agRama = peRama;
       k1ysag.agSini = peSini;
       k1ysag.agNops = peNops;
       Setll %kds( k1ysag : 5 ) p1hsag;
       reade %kds( k1ysag : 5 ) p1hsag;
       dow not %eof( pahsag );
         agsini= @@sini;
         update p1hsag;
       reade %kds( k1ysag : 5 ) p1hsag;
       enddo;
       unlock pahsag;

       k1ysi0.i0Empr = peEmpr;
       k1ysi0.i0Sucu = peSucu;
       k1ysi0.i0Rama = peRama;
       k1ysi0.i0Sini = peSini;
       k1ysi0.i0Nops = peNops;
       Setll %kds( k1ysi0 : 5 ) p1hsi0;
       reade %kds( k1ysi0 : 5 ) p1hsi0;
       dow not %eof( pahsi0 );
         i0sini= @@sini;
         update p1hsi0;
       reade %kds( k1ysi0 : 5 ) p1hsi0;
       enddo;
       unlock pahsi0;

       k1ysi1.i1Empr = peEmpr;
       k1ysi1.i1Sucu = peSucu;
       k1ysi1.i1Rama = peRama;
       k1ysi1.i1Sini = peSini;
       k1ysi1.i1Nops = peNops;
       Setll %kds( k1ysi1 : 5 ) p1hsi1;
       reade %kds( k1ysi1 : 5 ) p1hsi1;
       dow not %eof( pahsi1 );
         i1sini= @@sini;
         update p1hsi1;
       reade %kds( k1ysi1 : 5 ) p1hsi1;
       enddo;
       unlock pahsi1;

       k1ysfr.frEmpr = peEmpr;
       k1ysfr.frSucu = peSucu;
       k1ysfr.frRama = peRama;
       k1ysfr.frSini = peSini;
       k1ysfr.frNops = peNops;
       Setll %kds( k1ysfr : 5 ) p1hsfr;
       reade %kds( k1ysfr : 5 ) p1hsfr;
       dow not %eof( pahsfr );
         frsini= @@sini;
         update p1hsfr;
       reade %kds( k1ysfr : 5 ) p1hsfr;
       enddo;
       unlock pahsfr;

       k1y980s.g0sEmpr = peEmpr;
       k1y980s.g0sSucu = peSucu;
       k1y980s.g0sRama = peRama;
       k1y980s.g0sNops = peNops;
       Setll %kds( k1y980s : 4 ) g1i980s;
       reade %kds( k1y980s : 4 ) g1i980s;
       dow not %eof( gti980s );
         g0ssini= @@sini;
         update g1i980s;
       reade %kds( k1y980s : 4 ) g1i980s;
       enddo;
       unlock gti980s;

        GSWEB903X( cdempr
                 : cdsucu
                 : cdrama
                 : cdsini
                 : cdnops );

       k1yscl.clEmpr = peEmpr;
       k1yscl.clSucu = peSucu;
       k1yscl.clRama = peRama;
       k1yscl.clNops = peNops;
       k1yscl.clFera = *zeros;
       k1yscl.clFerm = *zeros;
       k1yscl.clFerd = *zeros;
       k1yscl.clPsec = *zeros;
       Setll %kds( k1yscl : 8 ) p1hscl;
       reade %kds( k1yscl : 4 ) p1hscl;
       dow not %eof( pahscl );
         clsini= @@sini;
         update p1hscl;
       reade %kds( k1yscl : 4 ) p1hscl;
       enddo;
       unlock pahscl;

       k1ysdt.dtEmpr = peEmpr;
       k1ysdt.dtSucu = peSucu;
       k1ysdt.dtRama = peRama;
       k1ysdt.dtSini = peSini;
       k1ysdt.dtNops = peNops;
       Setll %kds( k1ysdt : 5 ) x1hsdt;
       reade %kds( k1ysdt : 5 ) x1hsdt;
       dow not %eof( pahsdt01 );
         dtsini= @@sini;
         update p1hsdt;
       reade %kds( k1ysdt : 5 ) x1hsdt;
       enddo;
       unlock pahsdt01;

       SVPSI1_envioMailAltaSiniestralidad( peEmpr
                                         : peSucu
                                         : peRama
                                         : @@Sini
                                         : peNops );

       SAV903R( beEmpr
              : beSucu
              : beRama
              : bePoli );

       SAV903S( peEmpr
              : peSucu
              : peRama
              : @@sini
              : peNops );

       SVPSI1_guarSinPDS( peEmpr
                        : peSucu
                        : peRama
                        : @@Sini
                        : cdPoli
                        : @@Pate
                        : @@Focu );

       peSini = @@sini ;

       return @@sini;

      /end-free

     P SVPSI1_numeraAltaSiniestro...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_numeraSet904 : Númera y actualiza SET904                   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (output)  Siniestro                                  *
      *                                                                   *
      * retorna numero de Siniestro                                       *
      * ----------------------------------------------------------------- *
     P SVPSI1_numeraSet904...
     P                 B                   export
     D SVPSI1_numeraSet904...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const

     D  k1y904         ds                  likerec( s1t904 : *key    )

      /free

       SVPSI1_inz();

       k1y904.t@Empr = peEmpr;
       k1y904.t@Sucu = peSucu;
       k1y904.t@Rama = peRama;
       chain %kds( k1y904 : 3 ) s1t904;
       if %found( set904 );
         t@nrsi += 1;
         update s1t904 ;
         return t@nrsi;
        else;
         t@empr = usempr ;
         t@sucu = ussucu ;
         t@rama = perama ;
         t@nrsi = 1 ;
         write s1t904 ;
         return t@nrsi;
       endif;

       return *zeros;

      /end-free

     P SVPSI1_numeraSet904...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_envioMailAltaSiniestralidad: Envio de Mail en caso de Alta *
      *                                     Siniestralidad.               *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Número Operación Siniestro                 *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_envioMailAltaSiniestralidad...
     P                 B                   export
     D SVPSI1_envioMailAltaSiniestralidad...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D  k1yscd03       ds                  likerec( p1hscd03 : *key )
     D  k1yjcr         ds                  likerec( p1hjcr : *key )
     D  k1yshe         ds                  likerec( p1hshe : *key )
     D  k1y401         ds                  likerec( s1t401 : *key )
     D  k1y402         ds                  likerec( s1t402 : *key )

     D  @@Mens         s           5000a
     D  @@cant         s              3  0
     D  p_fmoa         s              4  0
     D  p_fmom         s              2  0
     D  p_fmod         s              2  0
     D  p_rese         s             15  2
     D  p_paga         s             15  2
     D  pePoli         s              7  0
     D  sts_Sini       s              1

     D                 ds
     D  Fch_Denun              1     10
     D   dia_Denun             1      2S 0
     D                         3      3    inz('/')
     D   mes_Denun             4      5S 0
     D                         6      6    inz('/')
     D   aÑo_Denun             7     10S 0

     D                 ds
     D  Fch_Sinie              1     10
     D   dia_Sinie             1      2S 0
     D                         3      3    inz('/')
     D   mes_Sinie             4      5S 0
     D                         6      6    inz('/')
     D   aÑo_Sinie             7     10S 0


      /free

       SVPSI1_inz();

        if perama <> 23 and perama <> 80 and perama <> 89;
          read set466;
          @@cant = SVPSI1_cantidadSiniestrosEnAlta( peEmpr
                                                  : peSucu
                                                  : peRama
                                                  : pePoli );
          if @@cant >= ttcant;

       @@Mens =
        '<html><head><title>Aviso Alta Siniestralidad</title></head>'
       +'<body>Estimado/a, <br><br>'
       +'Se le informa que se ha generado el Siniestro Numero '
       +'<span style="font-weight: bold;">'+ %char(t@nrsi) +'</span>'
       +'correspondiente a la Póliza '
       +'<span style="font-weight: bold;">' + %char(perama)
       +                              '/' + %char(cdpoli) + '</span>. '
       +'La misma ha alcanzado un total de '
       +'<span style="font-weight: bold;">' + %char(@@cant)
       +                                          '</span> Siniestros.'
       +'<br><br>'
       +'<table border="1">'
       +'<tbody><tr bgcolor="gray">'
       +'<th style="background-color: rgb(51, 102, 255);">Siniestro</th>'
       +'<th style="background-color: rgb(51, 102, 255);">Fec.Denun.</th>'
       +'<th style="background-color: rgb(51, 102, 255);">Fec.Stro.</th>'
       +'<th style="background-color: rgb(51, 102, 255);">Reserv. -Franq $</th>'
       +'<th style="background-color: rgb(51, 102, 255);">Monto Pagado $</th>'
       +'<th style="background-color: rgb(51, 102, 255);">J</th>'
       +'<th style="background-color: rgb(51, 102, 255);">Estado</th>'
       +'<th style="background-color: rgb(51, 102, 255);">Causa</th>'
       +'</tr>';

       k1yscd03.cdEmpr = peEmpr;
       k1yscd03.cdSucu = peSucu;
       k1yscd03.cdRama = peRama;
       k1yscd03.cdpoli = pePoli;
       k1yscd03.cdSini = peSini;
       k1yscd03.cdNops = peNops;
       setll %kds(k1yscd03:6) p1hscd03;
       reade %kds(k1yscd03:6) p1hscd03;
       Dow  not %eof(pahscd03) and %len(%trim(@@Mens)) < 4501;
       eval dia_Denun = cdfded;
       eval mes_Denun = cdfdem;
       eval aÑo_Denun = cdfdea;
       eval dia_Sinie = cdfsid;
       eval mes_Sinie = cdfsim;
       eval aÑo_Sinie = cdfsia;
       p_rese = *all'9';
       p_paga = *all'9';
       p_fmoa = *all'9';
       p_fmom = *all'9';
       p_fmod = *all'9';
       SVPSI1_saldoConsolidadoSiniestroPesos( peEmpr
                                            : peSucu
                                            : peRama
                                            : peSini
                                            : peNops
                                            : p_fmoa
                                            : p_fmom
                                            : p_fmod
                                            : p_rese
                                            : p_paga );

       k1yjcr.jcEmpr = peEmpr;
       k1yjcr.jcSucu = peSucu;
       k1yjcr.jcRama = peRama;
       k1yjcr.jcSini = peSini;
       k1yjcr.jcNops = peNops;
       setll %kds(k1yjcr:5) pahjcr;
       if %equal;
       Eval sts_sini = 'S';
       else;
       Eval sts_sini = 'N';
       EndIf;

       k1yshe.heEmpr = peEmpr;
       k1yshe.heSucu = peSucu;
       k1yshe.heRama = peRama;
       k1yshe.heSini = peSini;
       k1yshe.heNops = peNops;
       setgt %kds(k1yshe:5) pahshe;
       readpe %kds(k1yshe:5) pahshe;
       if not %eof(pahshe);
       eval cdcesi = hecesi;
       endif;

       k1y402.t@Empr = peEmpr;
       k1y402.t@Sucu = peSucu;
       k1y402.t@Rama = peRama;
       k1y402.t@Cesi = cdCesi;
       chain %kds(k1y402:4) set402;
       if not %found(set402);
       eval t@desi = *all' ';
       endif;

       k1y401.t@Rama = peRama;
       k1y401.t@Cauc = cdCauc;
       chain %kds(k1y401:2) set401;
       if not %found(set401);
       eval t@caud = *all' ';
       endif;


       @@Mens = %trim(@@Mens) + ' '
       +'<tr>'
       +'<td style="text-align: right;">'+%editc(CDSINI:'3')+'</td>'
       +'<td style="text-align: right;">'+ Fch_Denun +'</td>'
       +'<td style="text-align: right;">'+ Fch_Sinie +'</td>'
       +'<td style="text-align: right;">'+%trim(%editc(p_rese:'P'))+'</td>'
       +'<td style="text-align: right;">'+%trim(%editc(p_paga:'P'))+'</td>'
       +'<td>'+Sts_Sini+'</td>'
       +'<td>'+ %editc(cdcesi:'3') + ' - ' + %trim(T@DESI) +   '</td>'
       +'<td>'+ %editc(cdcauc:'3') + ' - ' + %trim(T@CAUD) +   '</td>'
       +'</tr>';

       reade %kds(k1yscd03:6) p1hscd03;
       enddo;

       @@Mens = %trim(@@Mens) + ' '
       + '</tbody></table>'
       + '</body></html>';

            SNDMAIL ( 'SAV903'
                    : 'SAV903'
                    : *OMIT
                    : @@Mens );
          endif;
        endif;

       return *on;

      /end-free

     P SVPSI1_envioMailAltaSiniestralidad...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_saldoConsolidadoSiniestroPesos :  Saldo Consolidado de un  *
      *                                          Siniestro en Pesos.      *
      * Sumo Reservas a una determinada fecha y le resto las Franquicias. *
      * Sumo los pagos a una determinada fecha.                           *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *     peFmoa   (input)   Fecha Movimiento Año                       *
      *     peFmom   (input)   Fecha Movimiento Mes                       *
      *     peFmod   (input)   Fecha Movimiento Día                       *
      *     peRese   (output)  Importe de Reserva                         *
      *     pePaga   (output)  Importe de Pagos                           *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_saldoConsolidadoSiniestroPesos...
     P                 B                   export
     D SVPSI1_saldoConsolidadoSiniestroPesos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   peRese                      15  2
     D   pePaga                      15  2

     D  k1yshr         ds                  likerec( p1hshr : *key )
     D  k1ysfr         ds                  likerec( p1hsfr : *key )
     D  k1yshp         ds                  likerec( p1hshp : *key )
     D  peFmov         s              8  0

      /free

       SVPSI1_inz();

       clear peRese;
       clear pePaga;
       peFmov = (peFmoa*10000) + (peFmom*100) + peFmod;

       k1yshr.hrEmpr = peEmpr;
       k1yshr.hrSucu = peSucu;
       k1yshr.hrRama = peRama;
       k1yshr.hrSini = peRama;
       k1yshr.hrNops = peNops;
       Setll %kds( k1yshr : 5 ) p1hshr;
       reade %kds( k1yshr : 5 ) p1hshr;
       dow not %eof and
        SPVFEC_ArmarFecha8 (hrfmoa : hrfmom : hrfmod: 'AMD' ) <= peFmov;
          peRese += hrimau;
       reade %kds( k1yshr : 5 ) p1hshr;
       enddo;

       k1ysfr.frEmpr = peEmpr;
       k1ysfr.frSucu = peSucu;
       k1ysfr.frRama = peRama;
       k1ysfr.frSini = peRama;
       k1ysfr.frNops = peNops;
       Setll %kds( k1ysfr : 5 ) p1hsfr;
       reade %kds( k1ysfr : 5 ) p1hsfr;
       dow not %eof and
        SPVFEC_ArmarFecha8 (frfmoa : frfmom : frfmod: 'AMD' ) <= peFmov;
          peRese -= frimau;
       reade %kds( k1ysfr : 5 ) p1hsfr;
       enddo;

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpRama = peRama;
       k1yshp.hpSini = peRama;
       k1yshp.hpNops = peNops;
       Setll %kds( k1yshp : 5 ) p1hshp;
       reade %kds( k1yshp : 5 ) p1hshp;
       dow not %eof and
        SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= peFmov;
          pePaga += hpimau;
       reade %kds( k1yshp : 5 ) p1hshp;
       enddo;

       return *on;

      /end-free

     P SVPSI1_saldoConsolidadoSiniestroPesos...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_guarSinPDS : Guarda Siniestero en Pre-Denuncia de Siniestro*
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     pePoli   (input)   Numero de Operacion Siniestro              *
      *     pePate   (input)   Numero de Operacion Siniestro              *
      *     pefocu   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_guarSinPDS...
     P                 B                   export
     D SVPSI1_guarSinPDS...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const

     D  k1y005         ds                  likerec( p1ds00 : *key )

      /free

       SVPSI1_inz();

       k1y005.p0Empr = peEmpr;
       k1y005.p0Sucu = peSucu;
       k1y005.p0Rama = peRama;
       k1y005.p0Poli = pePoli;
       k1y005.p0Pate = pePate;
       k1y005.p0Focu = peFocu;
       chain %kds( k1y005 : 6 ) p1ds00;
       if %found;
       p0sini = peSini;
       p0User = ususer;
       p0Date = (*year * 10000)
              + (*month *  100)
              +  *day ;
       p0Time = %dec(%time():*iso);
       update p1ds00 ;
       endif ;

       return *on;

      /end-free

     P SVPSI1_guarSinPDS...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSI1_cantidadSiniestrosEnAlta:Cantidad de Siniestros en Alta de *
      *                                 Siniestros.                       *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Número de Operación Siniestro              *
      *                                                                   *
      * retorna Cantidad                                                  *
      * ----------------------------------------------------------------- *
     P SVPSI1_cantidadSiniestrosEnAlta...
     P                 B                   export
     D SVPSI1_cantidadSiniestrosEnAlta...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D  k1yscd         ds                  likerec( p1hscd03 : *key )
     D  @@cant         s              3  0

      /free

       SVPSI1_inz();

       @@cant = *zeros ;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdPoli = pePoli;
       Setll %kds( k1yscd : 4 ) p1hscd03;
       reade %kds( k1yscd : 4 ) p1hscd03;
       dow not %eof ;
         @@cant += 1 ;
       reade %kds( k1yscd : 4 ) p1hscd03;
       enddo;

       return @@cant ;

      /end-free

     P SVPSI1_cantidadSiniestrosEnAlta...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_chkPasoDeTrabajo : Cheque Pasos de Trabajo del Siniestro   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_chkPasoDeTrabajo...
     P                 B                   export
     D SVPSI1_chkPasoDeTrabajo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D  k1yssp         ds                  likerec( p1hssp : *key )
     D  paso           s              2  0

      /free

       SVPSI1_inz();

       paso = *zeros ;

       k1yssp.spEmpr = peEmpr;
       k1yssp.spSucu = peSucu;
       k1yssp.spRama = peRama;
       k1yssp.spSini = peSini;
       k1yssp.spNops = peNops;
       chain %kds( k1yssp : 5 ) p1hssp;
        if not %found ;
         Return *off ;
          else ;
         paso = spap01 + spap06 ;
         if paso >= 2 ;
          else;
          Return *off ;
         endif;
        endif;

       Return *on ;

      /end-free

     P SVPSI1_chkPasoDeTrabajo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getNumReclamo : Recupera ultimo numero de reclamo para la  *
      *                        Caratula                                   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna: Numero de Reclamo / -1 Error                             *
      * ----------------------------------------------------------------- *
     P SVPSI1_getNumReclamo...
     P                 B                   export
     D SVPSI1_getNumReclamo...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D  k1ysb101       ds                  likerec( p1hsb101 : *key )
     D   @@Recl        s              3  0

      /free

       SVPSI1_inz();

       k1ysb101.b1Empr = peEmpr;
       k1ysb101.b1Sucu = peSucu;
       k1ysb101.b1Rama = peRama;
       k1ysb101.b1Sini = peSini;
       k1ysb101.b1Nops = peNops;
       setgt  %kds( k1ysb101 : 5 ) p1hsb101;
       readpe %kds( k1ysb101 : 5 ) p1hsb101;
       if %found ;
          @@Recl = b1Recl + 1;
          return @@Recl;
       endif;
       return -1;


      /end-free

     P SVPSI1_getNumReclamo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_chkNumReclamo: Valida numero del Reclamo                   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *     peRecl   (input)   Numero del Reclamo                         *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_chkNumReclamo...
     P                 B                   export
     D SVPSI1_chkNumReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const

     D  k1ysb101       ds                  likerec( p1hsb101 : *key )
     D  paso           s              2  0

      /free

       SVPSI1_inz();

       k1ysb101.b1Empr = peEmpr;
       k1ysb101.b1Sucu = peSucu;
       k1ysb101.b1Rama = peRama;
       k1ysb101.b1Sini = peSini;
       k1ysb101.b1Nops = peNops;
       k1ysb101.b1Recl = peRecl;
       chain %kds( k1ysb101 : 6 ) p1hsb101;
        if not %found ;
         Return *off ;
        endif;

       Return *on ;

      /end-free

     P SVPSI1_chkNumReclamo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahssp(): Retorna datos de siniestro suspendido         *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                ( opcional ) *
      *         peNops   ( input  ) Operación de Siniestro   ( opcional ) *
      *         peLssp   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsspC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_getPahssp...
     P                 B                   export
     D SVPSI1_getPahssp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options( *Nopass : *Omit ) const
     D   peNops                       7  0 options( *Nopass : *Omit ) const
     D   peLssp                            likeds(dsPahssp_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsspC                     10i 0 options( *Nopass : *Omit )

     D   k1yssp        ds                  likerec( p1hssp : *key    )
     D   @@DsIsp       ds                  likerec( p1hssp : *input  )
     D   @@DsSp        ds                  likeds ( dsPahssp_t ) dim( 9999 )
     D   @@DsSpC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsSp;
       @@DsSpC = 0;

       k1yssp.spEmpr = peEmpr;
       k1yssp.spSucu = peSucu;
       k1yssp.spRama = peRama;

       if %parms >= 4;
         Select;
           when %addr( peSini ) <> *null and
                %addr( peNops ) <> *null;

                k1yssp.spSini = peSini;
                k1yssp.spNops = peNops;
                setll %kds( k1yssp : 5 ) pahssp;
                if not %equal( pahssp );
                  return *off;
                endif;
                reade(n) %kds( k1yssp : 5 ) pahssp @@DsISp;
                dow not %eof( pahssp );
                  @@DsSpC += 1;
                  eval-corr @@DsSp ( @@DsSpC ) = @@DsISp;
                 reade(n) %kds( k1yssp : 5 ) pahssp @@DsISp;
                enddo;

           when %addr( peSini ) <> *null and
                %addr( peNops ) =  *null;

                k1yssp.spSini = peSini;
                setll %kds( k1yssp : 4 ) pahssp;
                if not %equal( pahssp );
                  return *off;
                endif;
                reade(n) %kds( k1yssp : 4 ) pahssp @@DsISp;
                dow not %eof( pahssp );
                  @@DsSpC += 1;
                  eval-corr @@DsSp ( @@DsSpC ) = @@DsISp;
                 reade(n) %kds( k1yssp : 4 ) pahssp @@DsISp;
                enddo;
           other;
                setll %kds( k1yssp : 3 ) pahssp;
                if not %equal( pahssp );
                  return *off;
                endif;
                reade(n) %kds( k1yssp : 3 ) pahssp @@DsISp;
                dow not %eof( pahssp );
                  @@DsSpC += 1;
                  eval-corr @@DsSp ( @@DsSpC ) = @@DsISp;
                 reade(n) %kds( k1yssp : 3 ) pahssp @@DsISp;
                enddo;
           endsl;
       else;

         setll %kds( k1yssp : 3 ) pahssp;
         if not %equal( pahssp );
           return *off;
         endif;
         reade(n) %kds( k1yssp : 3 ) pahssp @@DsISp;
         dow not %eof( pahssp );
           @@DsSpC += 1;
           eval-corr @@DsSp ( @@DsSpC ) = @@DsISp;
          reade(n) %kds( k1yssp : 3 ) pahssp @@DsISp;
         enddo;
       endif;

       if %addr( peLssp ) <> *null;
         eval-corr peLssp = @@DsSp;
       endif;

       if %addr( peLsspC ) <> *null;
         peLsspC = @@DsSpC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahssp...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahssp(): Valida si existe siniestro suspendido    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahssp...
     P                 B                   export
     D SVPSI1_chkPahssp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1yssp          ds                  likerec( p1hssp : *key )

      /free

       SVPSI1_inz();

       k1yssp.spempr = peEmpr;
       k1yssp.spsucu = peSucu;
       k1yssp.sprama = peRama;
       k1yssp.spsini = peSini;
       k1yssp.spnops = peNops;
       setll %kds( k1yssp : 5 ) pahssp;

       if not %equal(pahssp);
         SetError( SVPSI1_SSPNE
                 : 'Siniestro Suspendido Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahssp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahssp(): Graba datos en el archivo pahssp              *
      *                                                                   *
      *          peDsSp   ( input  ) Estrutura de pahssp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahssp...
     P                 B                   export
     D SVPSI1_setPahssp...
     D                 pi              n
     D   peDsSp                            likeds( dsPahssp_t ) const

     D  k1yssp         ds                  likerec( p1hssp : *key    )
     D  dsOssp         ds                  likerec( p1hssp : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPahssp( peDsSp.spEmpr
                          : peDsSp.spSucu
                          : peDsSp.spRama
                          : peDsSp.spSini
                          : peDsSp.spNops );

         return *off;
       endif;

       eval-corr DsOssp = peDsSp;
       monitor;
         write p1hssp DsOssp;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahssp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahssp(): Actualiza datos en el archivo pahssp          *
      *                                                                   *
      *          peDsSp   ( input  ) Estrutura de pahssp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahssp...
     P                 B                   export
     D SVPSI1_updPahssp...
     D                 pi              n
     D   peDsSp                            likeds( dsPahssp_t ) const

     D  k1yssp         ds                  likerec( p1hssp : *key    )
     D  dsOssp         ds                  likerec( p1hssp : *output )

      /free

       SVPSI1_inz();

       k1yssp.spEmpr = peDsSp.spEmpr;
       k1yssp.spSucu = peDsSp.spSucu;
       k1yssp.spRama = peDsSp.spRama;
       k1yssp.spSini = peDsSp.spSini;
       k1yssp.spNops = peDsSp.spNops;
       chain %kds( k1yssp : 5 ) pahssp;
       if %found( pahssp );
         eval-corr dsOssp = peDsSp;
         update p1hssp dsOssp;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahssp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahssp(): Elimina datos en el archivo pahssp            *
      *                                                                   *
      *          peDsSp   ( input  ) Estrutura de pahssp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahssp...
     P                 B                   export
     D SVPSI1_dltPahssp...
     D                 pi              n
     D   peDsSp                            likeds( dsPahssp_t ) const

     D  k1yssp         ds                  likerec( p1hssp : *key    )
     D  dsOssp         ds                  likerec( p1hssp : *output )

      /free

       SVPSI1_inz();

       k1yssp.spEmpr = peDsSp.spEmpr;
       k1yssp.spSucu = peDsSp.spSucu;
       k1yssp.spRama = peDsSp.spRama;
       k1yssp.spSini = peDsSp.spSini;
       k1yssp.spNops = peDsSp.spNops;
       chain %kds( k1yssp : 5 ) pahssp;
       if %found( pahssp );
         delete p1hssp;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahssp...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSI1_RecalBenef: Recalcula Importe del Beneficiario             *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_RecalBenef...
     P                 B                   export
     D SVPSI1_RecalBenef...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D @@DsBe          ds                  likeds ( DsPahsbe_t ) dim(999)
     D @@DsBeC         s             10i 0
     D @@Totl          s             15  2
     D @X              s             10i 0

      /free

       SVPSI1_inz();

       if SVPSIN_getBeneficiarios( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : @@DsBe
                                 : @@DsBeC) = *off;
          Return *off;
       endif;
       @@Totl = SVPSIN_getRvaStro( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops);

       for @X = 1 to @@DsBeC;
          if @@Totl = *zeros;
             @@Dsbe(@X).bePart = 100;
          else;
             @@Dsbe(@X).bePart = (@@DsBe(@X).beImmr / @@Totl ) * 100;
          endif;
          if SVPSI1_updPahsbe( @@DsBe(@X)) = *off;
             Return *off;
          endif;
       endfor;

       Return *on ;

      /end-free

     P SVPSI1_RecalBenef...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_getPahsd1(): Retorna datos de Pahsd1                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peDsd1   ( output ) Lista de detalle de daños (opcional) *
      *     peDsd1C  ( output ) Cant. detalle de daños    (opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_getPahsd1...
     P                 B                   export
     D SVPSI1_getPahsd1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsd1                            likeds( dsPahsd1_t ) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peDsd1C                     10i 0 options( *Nopass : *Omit )

     D k1ysd1          ds                  likerec( p1hsd1 : *key )
     D @@DsId1         ds                  likerec( p1hsd1 : *input  )
     D @@Dsd1          ds                  likeds ( dsPahsd1_t ) dim( 9999 )
     D @@Dsd1C         s             10i 0

      /free

       SVPSI1_inz();
       clear @@Dsd1;
       @@Dsd1C = 0;

       k1ysd1.d1empr = peEmpr;
       k1ysd1.d1sucu = peSucu;
       k1ysd1.d1rama = peRama;
       k1ysd1.d1sini = peSini;
       k1ysd1.d1nops = peNops;
       setll %kds( k1ysd1 : 5 ) pahsd1;
       if not %equal(pahsd1);
         SetError( SVPSI1_DTDNE
                 : 'Detalle del Daño Inexistente' );
         return *Off;
       endif;

       reade(n) %kds( k1ysd1 : 5 ) pahsd1 @@DsId1;
       dow not %eof( pahsd1 );
          @@Dsd1C += 1;
          eval-corr @@Dsd1 ( @@Dsd1C ) = @@DsId1;
       reade(n) %kds( k1ysd1 : 5 ) pahsd1 @@DsId1;
       enddo;

       if %addr( peDsd1 ) <> *null;
         eval-corr peDsd1 = @@Dsd1;
       endif;

       if %addr( peDsd1C ) <> *null;
         peDsd1C = @@Dsd1C;
       endif;
       return *On;

      /end-free

     P SVPSI1_getPahsd1...
     P                 E


      * ------------------------------------------------------------ *
      * SVPSI1_updMarca03(): Graba paso 03 de Pahssp                 *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSI1_updMarca03...
     P                 B                   export
     D SVPSI1_updMarca03...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D  k1yssp         ds                  likerec( p1hssp : *key    )
     D  dsOssp         ds                  likerec( p1hssp : *output )

      /free

       SVPSI1_inz();

       k1yssp.spEmpr = peEmpr;
       k1yssp.spSucu = peSucu;
       k1yssp.spRama = peRama;
       k1yssp.spSini = peSini;
       k1yssp.spNops = peNops;
       chain %kds(k1yssp:5) pahssp;
       if not %found;
          return *off;
       endif;

       spap03 = 1;
       update p1hssp;
       return *on;

      /end-free

     P SVPSI1_updMarca03...
     P                 E
      * ------------------------------------------------------------ *
      * SVPSI1_getPawsbe(): Retorna datos de Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsBw   ( output ) Estructura de Beneficiarios de Sini. *
      *     peDsBwC  ( output ) Cantidad de Beneficiario de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_getPawsbe...
     P                 B                   export
     D SVPSI1_getPawsbe...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsBw                            likeds ( DsPawsbe_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsBwC                     10i 0 options(*nopass:*omit)

     D   k1ysbe        ds                  likerec( p1wsbe : *key   )
     D   @@DsIbw       ds                  likerec( p1wsbe : *input )
     D   @@DsBw        ds                  likeds ( DsPawsbe_t ) dim(9999)
     D   @@DsBwC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsBw;
       clear @@DsBwC;

       k1ysbe.bwEmpr = peEmpr;
       k1ysbe.bwSucu = peSucu;
       k1ysbe.bwRama = peRama;
       k1ysbe.bwSini = peSini;
       k1ysbe.bwNops = peNops;

       select;
         when %parms >= 7 and %addr( peNrdf ) <> *null
                          and %addr( peSebe ) <> *null;

           k1ysbe.bwNrdf = peNrdf;
           k1ysbe.bwSebe = peSebe;
           setll %kds( k1ysbe : 7 ) pawsbe;
           if not %equal( pawsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 7 ) pawsbe @@DsIbw;
           dow not %eof( pawsbe );
             @@DsBwC += 1;
             eval-corr @@DsBw ( @@DsBwC ) = @@DsIbw;
             reade(n) %kds( k1ysbe : 7 ) pawsbe @@DsIbw;
           enddo;

         when %parms >= 6 and %addr( peNrdf ) <> *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bwNrdf = peNrdf;
           setll %kds( k1ysbe : 6 ) pawsbe;
           if not %equal( pawsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 6 ) pawsbe @@DsIbw;
           dow not %eof( pawsbe );
             @@DsBwC += 1;
             eval-corr @@DsBw ( @@DsBwC ) = @@DsIbw;
             reade(n) %kds( k1ysbe : 6 ) pawsbe @@DsIbw;
           enddo;

         other;

           setll %kds( k1ysbe : 5 ) pawsbe;
           if not %equal( pawsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 5 ) pawsbe @@DsIbw;
           dow not %eof( pawsbe );
             @@DsBwC += 1;
             eval-corr @@DsBw ( @@DsBwC ) = @@DsIbw;
             reade(n) %kds( k1ysbe : 5 ) pawsbe @@DsIbw;
           enddo;
       endsl;

       if %addr( peDsBw ) <> *null;
         eval-corr peDsBw = @@DsBw;
       endif;

       if %addr( peDsBwC ) <> *null;
         peDsBwC = @@DsBwC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPawsbe...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPawsbe(): Valida si existe Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPawsbe...
     P                 B                   export
     D SVPSI1_chkPawsbe...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

     D   k1ysbe        ds                  likerec( p1wsbe : *key   )

      /free

       SVPSI1_inz();

       k1ysbe.bwEmpr = peEmpr;
       k1ysbe.bwSucu = peSucu;
       k1ysbe.bwRama = peRama;
       k1ysbe.bwSini = peSini;
       k1ysbe.bwNops = peNops;
       k1ysbe.bwNrdf = peNrdf;
       k1ysbe.bwSebe = peSebe;
       setll %kds( k1ysbe : 7 ) pawsbe;

       if not %equal(pawsbe);
         SetError( SVPSI1_BENNE
                 : 'Beneficiario Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPawsbe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPawsbe(): Graba datos en el archivo pawsbe              *
      *                                                                   *
      *          peDsBw   ( input  ) Estrutura de pawsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPawsbe...
     P                 B                   export
     D SVPSI1_setPawsbe...
     D                 pi              n
     D   peDsBw                            likeds( dsPawsbe_t ) const

     D  k1ysbe         ds                  likerec( p1wsbe : *key    )
     D  dsOsbw         ds                  likerec( p1wsbe : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkPawsbe( peDsBw.bwEmpr
                          : peDsBw.bwSucu
                          : peDsBw.bwRama
                          : peDsBw.bwSini
                          : peDsBw.bwNops
                          : peDsBw.bwNrdf
                          : peDsBw.bwSebe );

         return *off;
       endif;

       eval-corr DsOsbw = peDsBw;
       monitor;
         write p1wsbe DsOsbw;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPawsbe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPawsbe(): Actualiza datos en el archivo pawsbe          *
      *                                                                   *
      *          peDsBw   ( input  ) Estrutura de pawsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPawsbe...
     P                 B                   export
     D SVPSI1_updPawsbe...
     D                 pi              n
     D   peDsBw                            likeds( dsPawsbe_t ) const

     D  k1ysbe         ds                  likerec( p1wsbe : *key    )
     D  dsOsbw         ds                  likerec( p1wsbe : *output )

      /free

       SVPSI1_inz();

       k1ysbe.bwEmpr = peDsBw.bwEmpr;
       k1ysbe.bwSucu = peDsBw.bwSucu;
       k1ysbe.bwRama = peDsBw.bwRama;
       k1ysbe.bwSini = peDsBw.bwSini;
       k1ysbe.bwNops = peDsBw.bwNops;
       k1ysbe.bwNrdf = peDsBw.bwNrdf;
       k1ysbe.bwSebe = peDsBw.bwSebe;
       chain %kds( k1ysbe : 7 ) pawsbe;
       if %found( pawsbe );
         eval-corr dsOsbw = peDsBw;
         update p1wsbe dsOsbw;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPawsbe...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPawsbe(): Elimina datos en el archivo pawsbe            *
      *                                                                   *
      *          peDsBw   ( input  ) Estrutura de pawsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPawsbe...
     P                 B                   export
     D SVPSI1_dltPawsbe...
     D                 pi              n
     D   peDsBw                            likeds( dsPawsbe_t ) const

     D  k1ysbe         ds                  likerec( p1wsbe : *key    )

      /free

       SVPSI1_inz();

       k1ysbe.bwEmpr = peDsBw.bwEmpr;
       k1ysbe.bwSucu = peDsBw.bwSucu;
       k1ysbe.bwRama = peDsBw.bwRama;
       k1ysbe.bwSini = peDsBw.bwSini;
       k1ysbe.bwNops = peDsBw.bwNops;
       k1ysbe.bwNrdf = peDsBw.bwNrdf;
       k1ysbe.bwSebe = peDsBw.bwSebe;
       chain %kds( k1ysbe : 7 ) pawsbe;
       if %found( pawsbe );
         delete p1wsbe;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPawsbe...
     P                 E
      * ------------------------------------------------------------ *
      * SVPSI1_getPahslp(): Retorna datos de Limite Autorizado Pago  *
      *                     por dia.-                                *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peFmoa   ( input  ) Anio del Movimiento                  *
      *     peFmom   ( input  ) Mes del Movimiento                   *
      *     peFmod   ( input  ) Dia del Movimiento                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     peComo   ( input  ) Moneda                               *
      *     pePsec   ( input  ) Nro. de Secuencia                    *
      *     peDsLp   ( output ) Estructura de Beneficiarios de Sini. *
      *     peDsLpC  ( output ) Cantidad de Beneficiario de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_getPahslp...
     P                 B                   export
     D SVPSI1_getPahslp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   peArtc                       2  0 const
     D   peComo                       2    const
     D   pePsec                       6  0 const
     D   peDsLp                            likeds ( DsPahslp_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsLpC                     10i 0 options(*nopass:*omit)

     D   k1yslp        ds                  likerec( p1hslp : *key   )
     D   @@DsILp       ds                  likerec( p1hslp : *input )
     D   @@DsLp        ds                  likeds ( DsPahslp_t ) dim(9999)
     D   @@DsLpC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsLp;
       clear @@DsLpC;

       k1yslp.lpEmpr = peEmpr;
       k1yslp.lpSucu = peSucu;
       k1yslp.lpFmoa = peFmoa;
       k1yslp.lpFmom = peFmom;
       k1yslp.lpFmod = peFmod;
       k1yslp.lpArtc = peArtc;
       k1yslp.lpComo = peComo;
       k1yslp.lpPsec = pePsec;
       setll %kds( k1yslp : 8 ) pahslp;
       if not %equal( pahslp );
          return *off;
       endif;

       reade(n) %kds( k1yslp : 8 ) pahslp @@DsILp;
       dow not %eof( pahslp );
           @@DsLpC += 1;
           eval-corr @@DsLp ( @@DsLpC ) = @@DsILp;
           reade(n) %kds( k1yslp : 8 ) pahslp @@DsILp;
       enddo;


       if %addr( peDsLp ) <> *null;
         eval-corr peDsLp = @@DsLp;
       endif;

       if %addr( peDsLpC ) <> *null;
         peDsLpC = @@DsLpC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahslp...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahslp(): Valida si existe Limite Autorizado Pago  *
      *                     por dia.-                                *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peFmoa   ( input  ) Anio del Movimiento                  *
      *     peFmom   ( input  ) Mes del Movimiento                   *
      *     peFmod   ( input  ) Dia del Movimiento                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     peComo   ( input  ) Moneda                               *
      *     pePsec   ( input  ) Nro. de Secuencia                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahslp...
     P                 B                   export
     D SVPSI1_chkPahslp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   peArtc                       2  0 const
     D   peComo                       2    const
     D   pePsec                       6  0 const

     D   k1yslp        ds                  likerec( p1hslp : *key   )

      /free

       SVPSI1_inz();

       k1yslp.lpEmpr = peEmpr;
       k1yslp.lpSucu = peSucu;
       k1yslp.lpFmoa = peFmoa;
       k1yslp.lpFmom = peFmom;
       k1yslp.lpFmod = peFmod;
       k1yslp.lpArtc = peArtc;
       k1yslp.lpComo = peComo;
       k1yslp.lpPsec = pePsec;
       setll %kds( k1yslp : 8 ) pahslp;

       if not %equal(pahslp);
         SetError( SVPSI1_LAUNE
                 : 'Limite Aut. Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahslp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahslp(): Graba datos en el archivo pahslp              *
      *                                                                   *
      *          peDsLp   ( input  ) Estrutura de pahslp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setPahslp...
     P                 B                   export
     D SVPSI1_setPahslp...
     D                 pi              n
     D   peDsLp                            likeds( dsPahslp_t ) const

     D  @@DsLp         ds                  likeds( dsPahslp_t )
     D  k1yslp         ds                  likerec( p1hslp : *key    )
     D  dsOsLp         ds                  likerec( p1hslp : *output )

      /free

       SVPSI1_inz();

       clear @@DsLp;
       eval-corr @@DsLp = peDsLp;

       k1yslp.lpEmpr = @@DsLp.lpEmpr;
       k1yslp.lpSucu = @@DsLp.lpSucu;
       k1yslp.lpFmoa = @@DsLp.lpFmoa;
       k1yslp.lpFmom = @@DsLp.lpFmom;
       k1yslp.lpFmod = @@DsLp.lpFmod;
       k1yslp.lpArtc = @@DsLp.lpArtc;
       k1yslp.lpComo = @@DsLp.lpComo;
       setgt %kds( k1yslp : 7 ) pahslp;
       readpe(n) %kds( k1yslp : 7 ) pahslp;
       if %eof( pahslp );
         @@DsLp.lpPsec = 1;
       else;
         @@DsLp.lpPsec = lpPsec + 1;
       endif;

       eval-corr DsOsLp = @@DsLp;
       monitor;
         write p1hslp DsOsLp;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setPahslp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahslp(): Actualiza datos en el archivo pahslp          *
      *                                                                   *
      *          peDsLp   ( input  ) Estrutura de pahslp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updPahslp...
     P                 B                   export
     D SVPSI1_updPahslp...
     D                 pi              n
     D   peDsLp                            likeds( dsPahslp_t ) const

     D  k1yslp         ds                  likerec( p1hslp : *key    )
     D  dsOsLp         ds                  likerec( p1hslp : *output )

      /free

       SVPSI1_inz();

       k1yslp.lpEmpr = peDsLp.lpEmpr;
       k1yslp.lpSucu = peDsLp.lpSucu;
       k1yslp.lpFmoa = peDsLp.lpFmoa;
       k1yslp.lpFmom = peDsLp.lpFmom;
       k1yslp.lpFmod = peDsLp.lpFmod;
       k1yslp.lpArtc = peDsLp.lpArtc;
       k1yslp.lpComo = peDsLp.lpComo;
       k1yslp.lpPsec = peDsLp.lpPsec;
       chain %kds( k1yslp : 8 ) pahslp;
       if %found( pahslp );
         eval-corr dsOsLp = peDsLp;
         update p1hslp dsOsLp;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updPahslp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahslp(): Elimina datos en el archivo pahslp            *
      *                                                                   *
      *          peDsLp   ( input  ) Estrutura de pahslp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltPahslp...
     P                 B                   export
     D SVPSI1_dltPahslp...
     D                 pi              n
     D   peDsLp                            likeds( dsPahslp_t ) const

     D  k1yslp         ds                  likerec( p1hslp : *key    )

      /free

       SVPSI1_inz();

       k1yslp.lpEmpr = peDsLp.lpEmpr;
       k1yslp.lpSucu = peDsLp.lpSucu;
       k1yslp.lpFmoa = peDsLp.lpFmoa;
       k1yslp.lpFmom = peDsLp.lpFmom;
       k1yslp.lpFmod = peDsLp.lpFmod;
       k1yslp.lpArtc = peDsLp.lpArtc;
       k1yslp.lpComo = peDsLp.lpComo;
       k1yslp.lpPsec = peDsLp.lpPsec;
       chain %kds( k1yslp : 8 ) pahslp;
       if %found( pahslp );
         delete p1hslp;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltPahslp...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_montoMaximo(): Retorna monto máximo                        *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peIvcv   ( input  ) Código del valor                     *
      *                                                                   *
      * retorna: Monto                                                    *
      * ----------------------------------------------------------------- *
     P SVPSI1_montoMaximo...
     P                 B                   export
     D SVPSI1_montoMaximo...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvcv                       2  0 const

     D k1tmfp          ds                  likerec(c1tmfp:*key)
     D @fech           s              8  0
     D @retval         s             15  2
     D @hay            s               n

      /free

       SVPSI1_inz();

       @RetVal = *zeros;
          @Hay = *off;

       @Fech = ( *year  * 10000 )
             + ( *month *   100 )
             +   *day;

       k1tmfp.fpEmpr = peEmpr;
       k1tmfp.fpSucu = peSucu;
       k1tmfp.fpIvcv = peIvcv;

       setll %kds( k1tmfp : 3 ) cntmfp;
       reade %kds( k1tmfp : 3 ) cntmfp;
       dow not %eof( cntmfp );
         @hay = *on;
         if ( fpfini <= @fech );
           @retval = fpimau;
         else;
           leave;
         endif;
         reade %kds( k1tmfp : 3 ) cntmfp;
       enddo;

       if not @Hay;
          @RetVal = 9999999999999,99;
       endif;

       return @Retval;

      /end-free

     P SVPSI1_montoMaximo...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSI1_chkPahshp01(): Valida si existe Pagos Historicos.-    *
      *                                                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Siniestro                            *
      *     peNops   ( input  ) Nro. Oper. Siniestro                 *
      *     pePoco   ( input  ) Nro. Componente                      *
      *     pePaco   ( input  ) Cod. Parentesco                      *
      *     peNrdf   ( input  ) Nro. Persona                         *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peRiec   ( input  ) Cod. Riesgo                          *
      *     peXcob   ( input  ) Cod. Cobertura                       *
      *     peFmoa   ( input  ) Anio del Movimiento                  *
      *     peFmom   ( input  ) Mes del Movimiento                   *
      *     peFmod   ( input  ) Dia del Movimiento                   *
      *     pePsec   ( input  ) Nro. de Secuencia                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_chkPahshp01...
     P                 B                   export
     D SVPSI1_chkPahshp01...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

     D   k1yshp        ds                  likerec( x1hshp : *key   )

      /free

       SVPSI1_inz();

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpArtc = peArtc;
       k1yshp.hpPacp = pePacp;
       setll %kds( k1yshp : 4 ) pahshp01;

       if not %equal(pahshp01);
         SetError( SVPSI1_LAUNE
                 : 'Limite Aut. Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkPahshp01...
     P                 E
      * ------------------------------------------------------------ *
      * SVPSI1_getCnhric(): Retorna datos de Recibo de Indemnizacion *
      *                     Cabecera.-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_getCnhric...
     P                 B                   export
     D SVPSI1_getCnhric...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const
     D   peDsIc                            likeds ( DsCnhric_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsIcC                     10i 0 options(*nopass:*omit)

     D   k1ysic        ds                  likerec( c1hric : *key   )
     D   @@DsIIc       ds                  likerec( c1hric : *input )
     D   @@DsIc        ds                  likeds ( DsCnhric_t ) dim(9999)
     D   @@DsIcC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsIc;
       clear @@DsIcC;

       k1ysic.icEmpr = peEmpr;
       k1ysic.icSucu = peSucu;
       k1ysic.icArtc = peArtc;
       k1ysic.icPacp = pePacp;
       k1ysic.icIvnr = peIvnr;
       setll %kds( k1ysic : 5 ) Cnhric;
       if not %equal( Cnhric );
          return *off;
       endif;

       reade(n) %kds( k1ysic : 5 ) Cnhric @@DsIIc;
       dow not %eof( Cnhric );
           @@DsIcC += 1;
           eval-corr @@DsIc ( @@DsIcC ) = @@DsIIc;
           reade(n) %kds( k1ysic : 5 ) Cnhric @@DsIIc;
       enddo;


       if %addr( peDsIc ) <> *null;
         eval-corr peDsIc = @@DsIc;
       endif;

       if %addr( peDsIcC ) <> *null;
         peDsIcC = @@DsIcC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getCnhric...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkCnhric(): Valida si existe Recibo de Indemnizacion *
      *                     Cabecera.-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_chkCnhric...
     P                 B                   export
     D SVPSI1_chkCnhric...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const

     D   k1ysic        ds                  likerec( c1hric : *key   )

      /free

       SVPSI1_inz();

       k1ysic.icEmpr = peEmpr;
       k1ysic.icSucu = peSucu;
       k1ysic.icArtc = peArtc;
       k1ysic.icPacp = pePacp;
       k1ysic.icIvnr = peIvnr;
       setll %kds( k1ysic : 5 ) Cnhric;

       if not %equal(Cnhric);
         SetError( SVPSI1_REINE
                 : 'Recibo Indemnizacion Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkCnhric...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setCnhric(): Graba datos en el archivo Cnhric              *
      *                                                                   *
      *          peDsIc   ( input  ) Estrutura de Cnhric                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setCnhric...
     P                 B                   export
     D SVPSI1_setCnhric...
     D                 pi              n
     D   peDsIc                            likeds( dsCnhric_t ) const

     D  k1ysic         ds                  likerec( c1hric : *key    )
     D  dsOsic         ds                  likerec( c1hric : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkCnhric( peDsIc.icEmpr
                          : peDsIc.icSucu
                          : peDsIc.icArtc
                          : peDsIc.icPacp
                          : peDsIc.icIvnr );

         return *off;
       endif;

       eval-corr DsOsic = peDsIc;
       monitor;
         write c1hric DsOsic;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setCnhric...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updCnhric(): Actualiza datos en el archivo Cnhric          *
      *                                                                   *
      *          peDsIc   ( input  ) Estrutura de Cnhric                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updCnhric...
     P                 B                   export
     D SVPSI1_updCnhric...
     D                 pi              n
     D   peDsIc                            likeds( dsCnhric_t ) const

     D  k1ysic         ds                  likerec( c1hric : *key    )
     D  dsOsic         ds                  likerec( c1hric : *output )

      /free

       SVPSI1_inz();

       k1ysic.icEmpr = peDsIc.icEmpr;
       k1ysic.icSucu = peDsIc.icSucu;
       k1ysic.icArtc = peDsIc.icArtc;
       k1ysic.icPacp = peDsIc.icPacp;
       k1ysic.icIvnr = peDsIc.icIvnr;
       chain %kds( k1ysic : 5 ) Cnhric;
       if %found( Cnhric );
         eval-corr dsOsIc = peDsIc;
         update c1hric dsOsic;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updCnhric...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltCnhric(): Elimina datos en el archivo Cnhric            *
      *                                                                   *
      *          peDsIc   ( input  ) Estrutura de Cnhric                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltCnhric...
     P                 B                   export
     D SVPSI1_dltCnhric...
     D                 pi              n
     D   peDsIc                            likeds( dsCnhric_t ) const

     D  k1ysic         ds                  likerec( c1hric : *key    )

      /free

       SVPSI1_inz();

       k1ysic.icEmpr = peDsIc.icEmpr;
       k1ysic.icSucu = peDsIc.icSucu;
       k1ysic.icArtc = peDsIc.icArtc;
       k1ysic.icPacp = peDsIc.icPacp;
       k1ysic.icIvnr = peDsIc.icIvnr;
       chain %kds( k1ysic : 5 ) Cnhric;
       if %found( Cnhric );
         delete c1hric;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltCnhric...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_getCnhrid(): Retorna datos de Recibo de Indemnizacion *
      *                     Detalle.-                                *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *     peTpnl   ( input  ) Nro. Linea Texto                     *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_getCnhrid...
     P                 B                   export
     D SVPSI1_getCnhrid...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const
     D   peTpnl                       3  0 const
     D   peDsId                            likeds ( DsCnhrid_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsIdC                     10i 0 options(*nopass:*omit)

     D   k1ysid        ds                  likerec( c1hrid : *key   )
     D   @@DsIId       ds                  likerec( c1hrid : *input )
     D   @@DsId        ds                  likeds ( DsCnhrid_t ) dim(9999)
     D   @@DsIdC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsId;
       clear @@DsIdC;

       k1ysid.idEmpr = peEmpr;
       k1ysid.idSucu = peSucu;
       k1ysid.idArtc = peArtc;
       k1ysid.idPacp = pePacp;
       k1ysid.idIvnr = peIvnr;
       k1ysid.idTpnl = peTpnl;
       setll %kds( k1ysid : 6 ) Cnhrid;
       if not %equal( Cnhrid );
          return *off;
       endif;

       reade(n) %kds( k1ysid : 5 ) Cnhrid @@DsIId;
       dow not %eof( Cnhrid );
           @@DsIdC += 1;
           eval-corr @@DsId ( @@DsIdC ) = @@DsIId;
           reade(n) %kds( k1ysid : 6 ) Cnhrid @@DsIId;
       enddo;


       if %addr( peDsId ) <> *null;
         eval-corr peDsId = @@DsId;
       endif;

       if %addr( peDsIdC ) <> *null;
         peDsIdC = @@DsIdC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getCnhrid...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_chkCnhrid(): Valida si existe Recibo de Indemnizacion *
      *                     Detalle .-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *     peTpnl   ( input  ) Nro. Linea Texto                     *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_chkCnhrid...
     P                 B                   export
     D SVPSI1_chkCnhrid...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const
     D   peTpnl                       3  0 const

     D   k1ysid        ds                  likerec( c1hrid : *key   )

      /free

       SVPSI1_inz();

       k1ysid.idEmpr = peEmpr;
       k1ysid.idSucu = peSucu;
       k1ysid.idArtc = peArtc;
       k1ysid.idPacp = pePacp;
       k1ysid.idIvnr = peIvnr;
       k1ysid.idTpnl = peTpnl;
       setll %kds( k1ysid : 6 ) Cnhrid;

       if not %equal(Cnhrid);
         SetError( SVPSI1_REINE
                 : 'Recibo Indemnizacion Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSI1_chkCnhrid...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_setCnhrid(): Graba datos en el archivo Cnhrid              *
      *                                                                   *
      *          peDsId   ( input  ) Estrutura de Cnhrid                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_setCnhrid...
     P                 B                   export
     D SVPSI1_setCnhrid...
     D                 pi              n
     D   peDsId                            likeds( dsCnhrid_t ) const

     D  k1ysid         ds                  likerec( c1hrid : *key    )
     D  dsOsid         ds                  likerec( c1hrid : *output )

      /free

       SVPSI1_inz();

       if SVPSI1_chkCnhrid( peDsId.idEmpr
                          : peDsId.idSucu
                          : peDsId.idArtc
                          : peDsId.idPacp
                          : peDsId.idIvnr
                          : peDsId.idTpnl );

         return *off;
       endif;

       eval-corr DsOsid = peDsId;
       monitor;
         write c1hrid DsOsid;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSI1_setCnhrid...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_updCnhrid(): Actualiza datos en el archivo Cnhrid          *
      *                                                                   *
      *          peDsId   ( input  ) Estrutura de Cnhrid                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_updCnhrid...
     P                 B                   export
     D SVPSI1_updCnhrid...
     D                 pi              n
     D   peDsId                            likeds( dsCnhrid_t ) const

     D  k1ysid         ds                  likerec( c1hrid : *key    )
     D  dsOsid         ds                  likerec( c1hrid : *output )

      /free

       SVPSI1_inz();

       k1ysid.idEmpr = peDsId.idEmpr;
       k1ysid.idSucu = peDsId.idSucu;
       k1ysid.idArtc = peDsId.idArtc;
       k1ysid.idPacp = peDsId.idPacp;
       k1ysid.idIvnr = peDsId.idIvnr;
       k1ysid.idTpnl = peDsId.idTpnl;
       chain %kds( k1ysid : 6 ) Cnhrid;
       if %found( Cnhrid );
         eval-corr dsOsId = peDsId;
         update c1hrid dsOsid;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSI1_updCnhrid...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSI1_dltCnhrid(): Elimina datos en el archivo Cnhrid            *
      *                                                                   *
      *          peDsId   ( input  ) Estrutura de Cnhrid                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSI1_dltCnhrid...
     P                 B                   export
     D SVPSI1_dltCnhrid...
     D                 pi              n
     D   peDsId                            likeds( dsCnhrid_t ) const

     D  k1ysid         ds                  likerec( c1hrid : *key    )

      /free

       SVPSI1_inz();

       k1ysid.idEmpr = peDsId.idEmpr;
       k1ysid.idSucu = peDsId.idSucu;
       k1ysid.idArtc = peDsId.idArtc;
       k1ysid.idPacp = peDsId.idPacp;
       k1ysid.idIvnr = peDsId.idIvnr;
       k1ysid.idTpnl = peDsId.idTpnl;
       chain %kds( k1ysid : 5 ) Cnhrid;
       if %found( Cnhrid );
         delete c1hrid;
       endif;

       return *on;

      /end-free

     P SVPSI1_dltCnhrid...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSI1_getVoucher : Recupera ultimo numero de Recibo.-            *
      *                                                                   *
      * retorna: Numero de Recibo / -1 Error                              *
      * ----------------------------------------------------------------- *
     P SVPSI1_getVoucher...
     P                 B                   export
     D SVPSI1_getVoucher...
     D                 pi             7  0

     D   @@Nres        s              7  0

      /free

       SVPSI1_inz();

       if SVPTAB_getNumeradorGenerico( 'R'
                                     : @@Nres ) = *on;

         if @@Nres > 0;
            return @@Nres;
         endif;
       endif;

       return -1;


      /end-free

     P SVPSI1_getVoucher...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSI1_getPahshp01(): Retorna datos de Pagos Historicos.-    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSI1_getPahshp01...
     P                 B                   export
     D SVPSI1_getPahshp01...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsHp                            likeds ( DsPahshp_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsHpC                     10i 0 options(*nopass:*omit)

     D   k1yshp        ds                  likerec( x1hshp : *key   )
     D   @@DsIHp       ds                  likerec( x1hshp : *input )
     D   @@DsHp        ds                  likeds ( DsPahshp_t ) dim(9999)
     D   @@DsHpC       s             10i 0

      /free

       SVPSI1_inz();

       clear @@DsHp;
       clear @@DsHpC;

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpArtc = peArtc;
       k1yshp.hpPacp = pePacp;
       setll %kds( k1yshp : 4 ) Pahshp01;
       if not %equal( Pahshp01 );
          return *off;
       endif;

       reade(n) %kds( k1yshp : 4 ) Pahshp01 @@DsIHp;
       dow not %eof( Pahshp01 );
           @@DsHpC += 1;
           eval-corr @@DsHp ( @@DsHpC ) = @@DsIHp;
           reade(n) %kds( k1yshp : 4 ) Pahshp01 @@DsIHp;
       enddo;


       if %addr( peDsHp ) <> *null;
         eval-corr peDsHp = @@DsHp;
       endif;

       if %addr( peDsHpC ) <> *null;
         peDsHpC = @@DsHpC;
       endif;

       return *on;

      /end-free

     P SVPSI1_getPahshp01...
     P                 E



