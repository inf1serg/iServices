      * ************************************************************ *
      * COW314: QUOM Emisión Web                                     *
      *         Control anulaciones por falta de pago.               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                       *06-Dic-2021          *
      * ------------------------------------------------------------ *
      * SGF 10/01/22: La misma póliza no tomarla como vigente.       *
      *                                                              *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f ctw003    disk usage(*input) keyed;
        dcl-f pahec002  disk usage(*input) keyed;
        dcl-f pahec1    disk usage(*input) keyed;
        dcl-f pahed0    disk usage(*input) keyed;

        dcl-pr COW314 ExtPgm('COW314');
               peEmpr  char(1)     const;
               peSucu  char(2)     const;
               peNivt  packed(1:0) const;
               peNivc  packed(5:0) const;
               peNit1  packed(1:0) const;
               peNiv1  packed(5:0) const;
               peNctw  packed(7:0) const;
        end-pr;

        dcl-pi COW314;
               peEmpr  char(1)     const;
               peSucu  char(2)     const;
               peNivt  packed(1:0) const;
               peNivc  packed(5:0) const;
               peNit1  packed(1:0) const;
               peNiv1  packed(5:0) const;
               peNctw  packed(7:0) const;
        end-pi;

        dcl-pr SPVIG2 extpgm('SPVIG2');
               peArcd  packed(6:0) const;
               peSpol  packed(9:0) const;
               peRama  packed(2:0) const;
               peArse  packed(2:0) const;
               peOper  packed(7:0) const;
               peFemi  packed(8:0) const;
               peFemi  packed(8:0) const;
               peVige  ind;
               peSspo  packed(3:0);
               peSuop  packed(3:0);
               peEpgm  char(3) const;
        end-pr;

        dcl-pr SNDMAIL extpgm('SNDMAIL');
               peCprc  char(20) const;
               peCspr  char(20) const;
               peMens  varchar(512) const;
               peLmen  char(5000)   const options(*nopass:*omit);
        end-pr;

        dcl-pr PAR310X3 ExtPgm('PAR310X3');
               peEmpr  char(1)     const;
               peFema  packed(4:0);
               peFemm  packed(2:0);
               peFemd  packed(2:0);
        end-pr;

       /copy './qcpybooks/spvspo_h.rpgle'
       /copy './qcpybooks/svpase_h.rpgle'
       /copy './qcpybooks/svpint_h.rpgle'
       /copy './qcpybooks/cowlog_h.rpgle'
       /copy './qcpybooks/cowgrai_h.rpgle'

        dcl-s  peFemi packed(8:0);
        dcl-s  peFema packed(4:0);
        dcl-s  peFemm packed(2:0);
        dcl-s  peFemd packed(2:0);
        dcl-s  peFdes packed(8:0);
        dcl-s  peSspo packed(3:0);
        dcl-s  peSuop packed(3:0);
        dcl-s  c1femi packed(8:0);
        dcl-s  asen   packed(7:0);
        dcl-s  rc     int(10);
        dcl-s  data   char(65535);
        dcl-s  p      char(512);
        dcl-s  peMens varchar(512);
        dcl-s  peFech date;
        dcl-s  peVige   ind;
        dcl-s  vigentes ind;
        dcl-s  faltapag ind;

        dcl-s  peCade   packed(5:0) dim(9);

        dcl-ds peBase likeds(paramBase);
        dcl-ds peDsct likeds(dsctw000_t);
        dcl-ds k1w003 likerec(c1w003:*key);
        dcl-ds k1hec0 likerec(p1hec002:*key);
        dcl-ds k1hec1 likerec(p1hec1:*key);

        *inlr = *on;

        peBase.peEmpr = peEmpr;
        peBase.peSucu = peSucu;
        peBase.peNivt = peNivt;
        peBase.peNivc = peNivc;
        peBase.peNit1 = peNit1;
        peBase.peNiv1 = peNiv1;

        vigentes = *off;
        faltapag = *off;

        //
        // Fecha de hoy
        //
        PAR310X3( peEmpr : peFema : peFemm : peFemd );
        peFemi = (peFema * 10000)
               + (peFemm *   100)
               +  peFemd;
        peFech = %date(peFemi:*iso) - %years(1);
        peFdes = %dec(peFech:*iso);

        //
        // Obtengo el estado de la solicitud
        //
        if COWGRAI_getCtw000( peBase
                            : peNctw
                            : peDsCt ) = *off;
           return;
        endif;

        if peDsCt.w0cest <> 7 or
           peDsCt.w0cses <> 7;
           return;
        endif;

        if peDsCt.w0sspo <> 0;
           return;
        endif;

        //
        // Obtengo los datos del asegurado
        //
        k1w003.w3empr = peEmpr;
        k1w003.w3sucu = peSucu;
        k1w003.w3nivt = peNivt;
        k1w003.w3nivc = peNivc;
        k1w003.w3nctw = peNctw;
        k1w003.w3nase = 0;
        k1w003.w3asen = 0;
        chain %kds(k1w003:6) ctw003;
        if not %found;
           return;
        endif;

        k1hec0.c0empr = peEmpr;
        k1hec0.c0sucu = peSucu;
        k1hec0.c0asen = w3asen;
        setll %kds(k1hec0:3) pahec002;
        reade %kds(k1hec0:3) pahec002;
        dow not %eof;
            k1hec1.c1empr = c0empr;
            k1hec1.c1sucu = c0sucu;
            k1hec1.c1arcd = c0arcd;
            k1hec1.c1spol = c0spol;
            setll %kds(k1hec1:4) pahec1;
            reade %kds(k1hec1:4) pahec1;
            dow not %eof;
                c1femi = (c1fema * 10000)
                       + (c1femm *   100)
                       +  c1femd;
                if (c1femi >= peFdes and
                    c1femi <= peFemi);
                    if (c1tiou = 4 and c1stos = 13);
                       faltapag = *on;
                    endif;
                endif;
                if c1sspo = 0;
                   exsr $vige;
                endif;
             reade %kds(k1hec1:4) pahec1;
            enddo;
         reade %kds(k1hec0:3) pahec002;
        enddo;

        data = 'Cotizacion: '
             + %trim(%char(peNctw))
             + '<br>'
             + 'Vigente: '
             + vigentes
             + '<br>'
             + 'Falta de Pago: '
             + faltapag
             + '<br>';
        COWLOG_pgmLog( 'COW314' : data );

        SPVIG2( d0arcd
              : d0spol
              : d0rama
              : d0arse
              : d0oper
              : peFemi
              : peFemi
              : peVige
              : peSspo
              : peSuop
              : 'FIN'   );

        if faltapag;
           exsr $mail;
        endif;

        return;

        begsr $vige;
         if c1arcd = peDsCt.w0arcd and
            c1spol = peDsCt.w0spol;
            leavesr;
         endif;
         setll %kds(k1hec1:4) pahed0;
         reade %kds(k1hec1:4) pahed0;
         dow not %eof;
             SPVIG2( d0arcd
                   : d0spol
                   : d0rama
                   : d0arse
                   : d0oper
                   : peFemi
                   : peFemi
                   : peVige
                   : peSspo
                   : peSuop
                   : *blanks );
             if peVige;
                vigentes = *on;
                leavesr;
             endif;
          reade %kds(k1hec1:4) pahed0;
         enddo;

        endsr;

        begsr $mail;
         exsr $data;
        endsr;

        begsr $data;
         rc = MAIL_getBody( 'QUOM_MAILS' : 'COW314' : peMens );
         if SPVSPO_getCadenaComercial( peEmpr
                                     : peSucu
                                     : peDsCt.w0arcd
                                     : peDsCt.w0spol
                                     : peCade
                                     : peDsCt.w0sspo ) = *off;
            leavesr;
         endif;
         asen = w3asen;
         peMens = %scanrpl( '%ASEN%'
                          : %trim(%char(asen))
                          : peMens             );
         peMens = %scanrpl( '%NASE%'
                          : %trim(SVPASE_getNombre( asen ))
                          : peMens             );
         peMens = %scanrpl( '%NIV1%'
                          : %trim(%char(peNivc))
                          : peMens             );
         peMens = %scanrpl( '%NPR1%'
                          : %trim(SVPINT_getNombre( peEmpr
                                            : peSucu
                                            : 1
                                            : peCade(1) ))
                          : peMens             );
         peMens = %scanrpl( '%NCTW%'
                          : %trim(%char(peDsct.w0nctw))
                          : peMens             );
         peMens = %scanrpl( '%SOLN%'
                          : %trim(%char(peDsct.w0soln))
                          : peMens             );
         peMens = %scanrpl( '%ARCD%'
                          : %trim(%char(peDsct.w0arcd))
                          : peMens             );
         peMens = %scanrpl( '%SPOL%'
                          : %trim(%char(peDsct.w0spol))
                          : peMens             );
         if vigentes;
            peMens = %scanrpl( '%VIGE%'
                             : 'El asegurado <b>tiene polizas vigentes</b>'
                             : peMens             );
          else;
            peMens = %scanrpl( '%VIGE%'
                             : 'El asegurado <b>no tiene polizas vigentes<'
                             + '/b>'
                             : peMens             );
         endif;
         if faltapag;
            peMens = %scanrpl( '%FPAG%'
                             : 'El asegurado <b>tiene anulaciones por falt'
                             + 'a de pago en el ultimo año</b>'
                             : peMens             );
          else;
            peMens = %scanrpl( '%FPAG%'
                             : 'El asegurado <b>no tiene anulaciones por f'
                             + 'alta de pago en el ultimo año</b>'
                             : peMens             );
         endif;
         p = *blanks;
         k1hec1.c1empr = peEmpr;
         k1hec1.c1sucu = peSucu;
         k1hec1.c1arcd = peDsct.w0arcd;
         k1hec1.c1spol = peDsct.w0spol;
         k1hec1.c1sspo = 0;
         setll %kds(k1hec1:5) pahed0;
         reade %kds(k1hec1:5) pahed0;
         dow not %eof;
             p = %trim(p)
               + '<br>'
               + %trim(%editc(d0rama:'X'))
               + '/'
               + %trim(%editw(d0poli:' . 0 .   '));
          reade %kds(k1hec1:5) pahed0;
         enddo;
         peMens = %scanrpl( '%POLI%'
                          : %trim(p)
                          : peMens   );
         SNDMAIL( 'QUOM_MAILS' : 'COW314': peMens : *omit);
        endsr;

