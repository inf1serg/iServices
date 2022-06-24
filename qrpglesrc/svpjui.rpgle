      * ************************************************************ *
      * SVPJUI: Juicios                                              *
      *         Programa de Servicio                                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *14-Feb-2022  *
      * ------------------------------------------------------------ *
      * SGF 22/02/2022: Depreco:                                     *
      *                 _getPahJc2()                                 *
      *                 _setPahJc2()                                 *
      *                 _updPahJc2()                                 *
      *                 Agrego:                                      *
      *                 _getPahJc22()                                *
      *                 _setPahJc22()                                *
      *                 _updPahJc22()                                *
      *                                                              *
      * ************************************************************ *

        ctl-opt
               nomain
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy);

        dcl-f pahjc2 disk usage(*input:*output:*delete:*update) keyed
              usropn;
        dcl-f pahjc3 disk usage(*input:*output:*delete:*update) keyed
              usropn;
        dcl-f pahjc4 disk usage(*input:*output:*delete:*update) keyed
              usropn;

      /copy './qcpybooks/svpjui_h.rpgle'

        dcl-pr SetError;
            peErrn int(10)  const;
            peErrm char(80) const;
        end-pr;

        dcl-s SVPJUI_errn int(10);
        dcl-s SVPJUI_errm char(80);
        dcl-s initialized ind;

        // -------------------------------------------------------------
        // Inicializa modulo
        // -------------------------------------------------------------
        dcl-proc SVPJUI_inz export;
         dcl-pi SVPJUI_inz;
         end-pi;

         if initialized;
            return;
         endif;

         if not %open(pahjc2);
            open pahjc2;
         endif;

         if not %open(pahjc3);
            open pahjc3;
         endif;

         if not %open(pahjc4);
            open pahjc4;
         endif;

         initialized = *on;

        end-proc;

        // -------------------------------------------------------------
        // Finaliza modulo
        // -------------------------------------------------------------
        dcl-proc SVPJUI_end export;
         dcl-pi SVPJUI_end;
         end-pi;

         initialized = *off;
         close *all;

        end-proc;

        // -------------------------------------------------------------
        // Retorna error
        // -------------------------------------------------------------
        dcl-proc SVPJUI_error export;
         dcl-pi SVPJUI_error char(80);
             peErrn int(10) options(*nopass:*omit);
         end-pi;

         SVPJUI_inz();

         if %parms >= 1 and %addr(peErrn) <> *null;
            peErrn = SVPJUI_errn;
         endif;

         return SVPJUI_errm;

        end-proc;

        // -------------------------------------------------------------
        // Retorna registro de PAHJC2
        // ***DEPRECATED*** Usar _getPahJc22
        // -------------------------------------------------------------
        dcl-proc SVPJUI_getPahJc2 export;
         dcl-pi SVPJUI_getPahJc2 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peHjc2 likeds(dsPahJc2_t);
         end-pi;

         dcl-ds p2Hjc2 likeds(dsPahJc22_t);

         dcl-s  rc ind;

         SVPJUI_inz();

         clear peHjc2;
         clear p2Hjc2;

         rc = SVPJUI_getPahJc22( peEmpr
                               : peSucu
                               : peRama
                               : peSini
                               : peNops
                               : peNrdf
                               : peSebe
                               : peNrcj
                               : peJuin
                               : p2Hjc2 );

         if rc;
            eval-corr p2Hjc2 = p2Hjc2;
            return *on;
          else;
            return *off;
         endif;
        end-proc;

        // -------------------------------------------------------------
        // Graba registro de PAHJC2
        // ***DEPRECATED*** Usar _setPahJc22
        // -------------------------------------------------------------
        dcl-proc SVPJUI_setPahJc2 export;
         dcl-pi SVPJUI_setPahJc2 ind;
             peHjc2 likeds(dsPahJc2_t) const;
         end-pi;

         dcl-ds p2Hjc2 likeds(dsPahJc22_t);

         dcl-s  rc ind;

         SVPJUI_inz();

         eval-corr p2Hjc2 = peHjc2;
         p2Hjc2.j2fmed = ' ';

         return SVPJUI_setPahJc22( p2Hjc2 );

        end-proc;

        // -------------------------------------------------------------
        // Verifica registro de PAHJC2
        // -------------------------------------------------------------
        dcl-proc SVPJUI_chkPahJc2 export;
         dcl-pi SVPJUI_chkPahJc2 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
         end-pi;

         dcl-ds k1hjc2 likerec(p1hjc2:*key);

         SVPJUI_inz();

         clear k1hjc2;
         k1hjc2.j2empr = peEmpr;
         k1hjc2.j2Sucu = peSucu;
         k1hjc2.j2Rama = peRama;
         k1hjc2.j2Sini = peSini;
         k1hjc2.j2Nops = peNops;
         k1hjc2.j2Nrdf = peNrdf;
         k1hjc2.j2Sebe = peSebe;
         k1hjc2.j2Nrcj = peNrcj;
         k1hjc2.j2Juin = peJuin;
         setll %kds(k1hjc2:9) pahjc2;

         return %equal;

        end-proc;

        // -------------------------------------------------------------
        // Elimina registro de PAHJC2
        // -------------------------------------------------------------
        dcl-proc SVPJUI_dltPahJc2 export;
         dcl-pi SVPJUI_dltPahJc2 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
         end-pi;

         dcl-ds k1hjc2 likerec(p1hjc2:*key);

         SVPJUI_inz();

         clear k1hjc2;
         k1hjc2.j2empr = peEmpr;
         k1hjc2.j2Sucu = peSucu;
         k1hjc2.j2Rama = peRama;
         k1hjc2.j2Sini = peSini;
         k1hjc2.j2Nops = peNops;
         k1hjc2.j2Nrdf = peNrdf;
         k1hjc2.j2Sebe = peSebe;
         k1hjc2.j2Nrcj = peNrcj;
         k1hjc2.j2Juin = peJuin;
         chain %kds(k1hjc2:9) pahjc2;
         if %found;
             delete p1hjc2;
             return *on;
         endif;

         return *off;

        end-proc;

        // -------------------------------------------------------------
        // Actualiza registro de PAHJC2
        // ***DEPRECATED*** Usar _updPahJc22
        // -------------------------------------------------------------
        dcl-proc SVPJUI_updPahJc2 export;
         dcl-pi SVPJUI_updPahJc2 ind;
             peHjc2 likeds(dsPahJc2_t) const;
         end-pi;

         dcl-ds p2hjc2 likeds(dsPahJc22_t);

         SVPJUI_inz();

         eval-corr p2Hjc2 = peHjc2;
         p2Hjc2.j2fmed = ' ';

         return SVPJUI_setPahJc22( p2Hjc2 );

        end-proc;

        // -------------------------------------------------------------
        // Retorna registro de PAHJC3
        // -------------------------------------------------------------
        dcl-proc SVPJUI_getPahJc3 export;
         dcl-pi SVPJUI_getPahJc3 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peTins char(1)     const;
             peHjc3 likeds(dsPahJc3_t);
         end-pi;

         dcl-ds k1hjc3 likerec(p1hjc3:*key);
         dcl-ds inhjc3 likerec(p1hjc3:*input);

         SVPJUI_inz();

         clear k1hjc3;
         clear inhjc3;
         clear peHjc3;

         k1hjc3.j3empr = peEmpr;
         k1hjc3.j3Sucu = peSucu;
         k1hjc3.j3Rama = peRama;
         k1hjc3.j3Sini = peSini;
         k1hjc3.j3Nops = peNops;
         k1hjc3.j3Nrdf = peNrdf;
         k1hjc3.j3Sebe = peSebe;
         k1hjc3.j3Nrcj = peNrcj;
         k1hjc3.j3Juin = peJuin;
         k1hjc3.j3Tins = peTins;
         chain %kds(k1hjc3:10) pahjc3 inHjc3;
         if %found;
            eval-corr peHjc3 = inHjc3;
            return *on;
         endif;

         return *off;

        end-proc;

        // -------------------------------------------------------------
        // Graba registro de PAHJC3
        // -------------------------------------------------------------
        dcl-proc SVPJUI_setPahJc3 export;
         dcl-pi SVPJUI_setPahJc3 ind;
             peHjc3 likeds(dsPahJc3_t) const;
         end-pi;

         dcl-ds outhjc3 likerec(p1hjc3:*output);

         SVPJUI_inz();

         if SVPJUI_chkPahJc3( peHjc3.j3empr
                            : peHjc3.j3Sucu
                            : %dec(peHjc3.j3Rama:2:0)
                            : %dec(peHjc3.j3Sini:7:0)
                            : %dec(peHjc3.j3Nops:7:0)
                            : %dec(peHjc3.j3Nrdf:7:0)
                            : %dec(peHjc3.j3Sebe:6:0)
                            : %dec(peHjc3.j3Nrcj:6:0)
                            : %dec(peHjc3.j3Juin:6:0)
                            : peHjc3.j3Tins              );
            return *off;
         endif;

         eval-corr OutHjc3 = peHjc3;
         monitor;
            write p1hjc3 outHjc3;
          on-error;
            return *off;
         endmon;

         return *on;

        end-proc;

        // -------------------------------------------------------------
        // Verifica registro de PAHJC3
        // -------------------------------------------------------------
        dcl-proc SVPJUI_chkPahJc3 export;
         dcl-pi SVPJUI_chkPahJc3 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peTins char(1)     const;
         end-pi;

         dcl-ds k1hjc3 likerec(p1hjc3:*key);

         SVPJUI_inz();

         clear k1hjc3;
         k1hjc3.j3empr = peEmpr;
         k1hjc3.j3Sucu = peSucu;
         k1hjc3.j3Rama = peRama;
         k1hjc3.j3Sini = peSini;
         k1hjc3.j3Nops = peNops;
         k1hjc3.j3Nrdf = peNrdf;
         k1hjc3.j3Sebe = peSebe;
         k1hjc3.j3Nrcj = peNrcj;
         k1hjc3.j3Juin = peJuin;
         k1hjc3.j3tins = petins;
         setll %kds(k1hjc3:10) pahjc3;

         return %equal;

        end-proc;

        // -------------------------------------------------------------
        // Elimina registro de PAHJC3
        // -------------------------------------------------------------
        dcl-proc SVPJUI_dltPahJc3 export;
         dcl-pi SVPJUI_dltPahJc3 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peTins char(1)     const;
         end-pi;

         dcl-ds k1hjc3 likerec(p1hjc3:*key);

         SVPJUI_inz();

         clear k1hjc3;
         k1hjc3.j3empr = peEmpr;
         k1hjc3.j3Sucu = peSucu;
         k1hjc3.j3Rama = peRama;
         k1hjc3.j3Sini = peSini;
         k1hjc3.j3Nops = peNops;
         k1hjc3.j3Nrdf = peNrdf;
         k1hjc3.j3Sebe = peSebe;
         k1hjc3.j3Nrcj = peNrcj;
         k1hjc3.j3Juin = peJuin;
         k1hjc3.j3tins = peTins;
         chain %kds(k1hjc3:10) pahjc3;
         if %found;
             delete p1hjc3;
             return *on;
         endif;

         return *off;

        end-proc;

        // -------------------------------------------------------------
        // Actualiza registro de PAHJC3
        // -------------------------------------------------------------
        dcl-proc SVPJUI_updPahJc3 export;
         dcl-pi SVPJUI_updPahJc3 ind;
             peHjc3 likeds(dsPahJc3_t) const;
         end-pi;

         dcl-ds outhjc3 likerec(p1hjc3:*output);

         SVPJUI_inz();

         if SVPJUI_chkPahJc3( peHjc3.j3empr
                            : peHjc3.j3Sucu
                            : %dec(peHjc3.j3Rama:2:0)
                            : %dec(peHjc3.j3Sini:7:0)
                            : %dec(peHjc3.j3Nops:7:0)
                            : %dec(peHjc3.j3Nrdf:7:0)
                            : %dec(peHjc3.j3Sebe:6:0)
                            : %dec(peHjc3.j3Nrcj:6:0)
                            : %dec(peHjc3.j3Juin:6:0)
                            : peHjc3.j3tins           ) = *off;
            return *off;
         endif;

         if SVPJUI_dltPahJc3( peHjc3.j3empr
                            : peHjc3.j3Sucu
                            : %dec(peHjc3.j3Rama:2:0)
                            : %dec(peHjc3.j3Sini:7:0)
                            : %dec(peHjc3.j3Nops:7:0)
                            : %dec(peHjc3.j3Nrdf:7:0)
                            : %dec(peHjc3.j3Sebe:6:0)
                            : %dec(peHjc3.j3Nrcj:6:0)
                            : %dec(peHjc3.j3Juin:6:0)
                            : peHjc3.j3tins           ) = *off;
            return *off;
         endif;

         return SVPJUI_setPahJc3( peHjc3 );

        end-proc;

        // -------------------------------------------------------------
        // Retorna registro de PAHJC4
        // -------------------------------------------------------------
        dcl-proc SVPJUI_getPahJc4 export;
         dcl-pi SVPJUI_getPahJc4 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peTins char(1)     const;
             peTita packed(2:0) const;
             peHjc4 likeds(dsPahJc4_t);
         end-pi;

         dcl-ds k1hjc4 likerec(p1hjc4:*key);
         dcl-ds inhjc4 likerec(p1hjc4:*input);

         SVPJUI_inz();

         clear k1hjc4;
         clear inhjc4;
         clear peHjc4;

         k1hjc4.j4empr = peEmpr;
         k1hjc4.j4Sucu = peSucu;
         k1hjc4.j4Rama = peRama;
         k1hjc4.j4Sini = peSini;
         k1hjc4.j4Nops = peNops;
         k1hjc4.j4Nrdf = peNrdf;
         k1hjc4.j4Sebe = peSebe;
         k1hjc4.j4Nrcj = peNrcj;
         k1hjc4.j4Juin = peJuin;
         k1hjc4.j4Tita = peTita;
         k1hjc4.j4Tins = peTins;
         chain %kds(k1hjc4:11) pahjc4 inHjc4;
         if %found;
            eval-corr peHjc4 = inHjc4;
            return *on;
         endif;

         return *off;

        end-proc;

        // -------------------------------------------------------------
        // Graba registro de PAHJC4
        // -------------------------------------------------------------
        dcl-proc SVPJUI_setPahJc4 export;
         dcl-pi SVPJUI_setPahJc4 ind;
             peHjc4 likeds(dsPahJc4_t) const;
         end-pi;

         dcl-ds outhjc4 likerec(p1hjc4:*output);

         SVPJUI_inz();

         if SVPJUI_chkPahJc4( peHjc4.j4empr
                            : peHjc4.j4Sucu
                            : %dec(peHjc4.j4Rama:2:0)
                            : %dec(peHjc4.j4Sini:7:0)
                            : %dec(peHjc4.j4Nops:7:0)
                            : %dec(peHjc4.j4Nrdf:7:0)
                            : %dec(peHjc4.j4Sebe:6:0)
                            : %dec(peHjc4.j4Nrcj:6:0)
                            : %dec(peHjc4.j4Juin:6:0)
                            :      peHjc4.j4Tins
                            : %dec(peHjc4.j4Tita:2:0) );
            return *off;
         endif;

         eval-corr OutHjc4 = peHjc4;
         monitor;
            write p1hjc4 outHjc4;
          on-error;
            return *off;
         endmon;

         return *on;

        end-proc;

        // -------------------------------------------------------------
        // Verifica registro de PAHJC4
        // -------------------------------------------------------------
        dcl-proc SVPJUI_chkPahJc4 export;
         dcl-pi SVPJUI_chkPahJc4 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peTins char(1)     const;
             peTita packed(2:0) const;
         end-pi;

         dcl-ds k1hjc4 likerec(p1hjc4:*key);

         SVPJUI_inz();

         clear k1hjc4;
         k1hjc4.j4empr = peEmpr;
         k1hjc4.j4Sucu = peSucu;
         k1hjc4.j4Rama = peRama;
         k1hjc4.j4Sini = peSini;
         k1hjc4.j4Nops = peNops;
         k1hjc4.j4Nrdf = peNrdf;
         k1hjc4.j4Sebe = peSebe;
         k1hjc4.j4Nrcj = peNrcj;
         k1hjc4.j4Juin = peJuin;
         k1hjc4.j4Tins = peTins;
         setll %kds(k1hjc4:11) pahjc4;

         return %equal;

        end-proc;

        // -------------------------------------------------------------
        // Elimina registro de PAHJC4
        // -------------------------------------------------------------
        dcl-proc SVPJUI_dltPahJc4 export;
         dcl-pi SVPJUI_dltPahJc4 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peTins char(1)     const;
             peTita packed(2:0) const;
         end-pi;

         dcl-ds k1hjc4 likerec(p1hjc4:*key);

         SVPJUI_inz();

         clear k1hjc4;
         k1hjc4.j4empr = peEmpr;
         k1hjc4.j4Sucu = peSucu;
         k1hjc4.j4Rama = peRama;
         k1hjc4.j4Sini = peSini;
         k1hjc4.j4Nops = peNops;
         k1hjc4.j4Nrdf = peNrdf;
         k1hjc4.j4Sebe = peSebe;
         k1hjc4.j4Nrcj = peNrcj;
         k1hjc4.j4Juin = peJuin;
         k1hjc4.j4Tita = peTita;
         k1hjc4.j4Tins = peTins;
         chain %kds(k1hjc4:11) pahjc4;
         if %found;
             delete p1hjc4;
             return *on;
         endif;

         return *off;

        end-proc;

        // -------------------------------------------------------------
        // Actualiza registro de PAHJC4
        // -------------------------------------------------------------
        dcl-proc SVPJUI_updPahJc4 export;
         dcl-pi SVPJUI_updPahJc4 ind;
             peHjc4 likeds(dsPahJc4_t) const;
         end-pi;

         dcl-ds outhjc4 likerec(p1hjc4:*output);

         SVPJUI_inz();

         if SVPJUI_chkPahJc4( peHjc4.j4empr
                            : peHjc4.j4Sucu
                            : %dec(peHjc4.j4Rama:2:0)
                            : %dec(peHjc4.j4Sini:7:0)
                            : %dec(peHjc4.j4Nops:7:0)
                            : %dec(peHjc4.j4Nrdf:7:0)
                            : %dec(peHjc4.j4Sebe:6:0)
                            : %dec(peHjc4.j4Nrcj:6:0)
                            : %dec(peHjc4.j4Juin:6:0)
                            :      peHjc4.j4Tins
                            : %dec(peHjc4.j4Tita:2:0) ) = *off;
            return *off;
         endif;

         if SVPJUI_dltPahJc4( peHjc4.j4empr
                            : peHjc4.j4Sucu
                            : %dec(peHjc4.j4Rama:2:0)
                            : %dec(peHjc4.j4Sini:7:0)
                            : %dec(peHjc4.j4Nops:7:0)
                            : %dec(peHjc4.j4Nrdf:7:0)
                            : %dec(peHjc4.j4Sebe:6:0)
                            : %dec(peHjc4.j4Nrcj:6:0)
                            : %dec(peHjc4.j4Juin:6:0)
                            :      peHjc4.j4Tins
                            : %dec(peHjc4.j4Tita:2:0) ) = *off;
            return *off;
         endif;

         return SVPJUI_setPahJc4( peHjc4 );

        end-proc;

        // -------------------------------------------------------------
        // Retorna registro de PAHJC2
        // -------------------------------------------------------------
        dcl-proc SVPJUI_getPahJc22 export;
         dcl-pi SVPJUI_getPahJc22 ind;
             peEmpr char(1) const;
             peSucu char(2) const;
             peRama packed(2:0) const;
             peSini packed(7:0) const;
             peNops packed(7:0) const;
             peNrdf packed(7:0) const;
             peSebe packed(6:0) const;
             peNrcj packed(6:0) const;
             peJuin packed(6:0) const;
             peHjc2 likeds(dsPahJc22_t);
         end-pi;

         dcl-ds k1hjc2 likerec(p1hjc2:*key);
         dcl-ds inhjc2 likerec(p1hjc2:*input);

         SVPJUI_inz();

         clear k1hjc2;
         clear inhjc2;
         clear peHjc2;

         k1hjc2.j2empr = peEmpr;
         k1hjc2.j2Sucu = peSucu;
         k1hjc2.j2Rama = peRama;
         k1hjc2.j2Sini = peSini;
         k1hjc2.j2Nops = peNops;
         k1hjc2.j2Nrdf = peNrdf;
         k1hjc2.j2Sebe = peSebe;
         k1hjc2.j2Nrcj = peNrcj;
         k1hjc2.j2Juin = peJuin;
         chain %kds(k1hjc2:9) pahjc2 inHjc2;
         if %found;
            eval-corr peHjc2 = inHjc2;
            return *on;
         endif;

         return *off;

        end-proc;

        // -------------------------------------------------------------
        // Graba registro de PAHJC2
        // -------------------------------------------------------------
        dcl-proc SVPJUI_setPahJc22 export;
         dcl-pi SVPJUI_setPahJc22 ind;
             peHjc2 likeds(dsPahJc22_t) const;
         end-pi;

         dcl-ds outhjc2 likerec(p1hjc2:*output);

         SVPJUI_inz();

         if SVPJUI_chkPahJc2( peHjc2.j2empr
                            : peHjc2.j2Sucu
                            : %dec(peHjc2.j2Rama:2:0)
                            : %dec(peHjc2.j2Sini:7:0)
                            : %dec(peHjc2.j2Nops:7:0)
                            : %dec(peHjc2.j2Nrdf:7:0)
                            : %dec(peHjc2.j2Sebe:6:0)
                            : %dec(peHjc2.j2Nrcj:6:0)
                            : %dec(peHjc2.j2Juin:6:0) );
            return *off;
         endif;

         eval-corr OutHjc2 = peHjc2;
         monitor;
            write p1hjc2 outHjc2;
          on-error;
            return *off;
         endmon;

         return *on;

        end-proc;

        // -------------------------------------------------------------
        // Actualiza registro de PAHJC2
        // -------------------------------------------------------------
        dcl-proc SVPJUI_updPahJc22 export;
         dcl-pi SVPJUI_updPahJc22 ind;
             peHjc2 likeds(dsPahJc22_t) const;
         end-pi;

         dcl-ds outhjc2 likerec(p1hjc2:*output);

         SVPJUI_inz();

         if SVPJUI_chkPahJc2( peHjc2.j2empr
                            : peHjc2.j2Sucu
                            : %dec(peHjc2.j2Rama:2:0)
                            : %dec(peHjc2.j2Sini:7:0)
                            : %dec(peHjc2.j2Nops:7:0)
                            : %dec(peHjc2.j2Nrdf:7:0)
                            : %dec(peHjc2.j2Sebe:6:0)
                            : %dec(peHjc2.j2Nrcj:6:0)
                            : %dec(peHjc2.j2Juin:6:0) ) = *off;
            return *off;
         endif;

         if SVPJUI_dltPahJc2( peHjc2.j2empr
                            : peHjc2.j2Sucu
                            : %dec(peHjc2.j2Rama:2:0)
                            : %dec(peHjc2.j2Sini:7:0)
                            : %dec(peHjc2.j2Nops:7:0)
                            : %dec(peHjc2.j2Nrdf:7:0)
                            : %dec(peHjc2.j2Sebe:6:0)
                            : %dec(peHjc2.j2Nrcj:6:0)
                            : %dec(peHjc2.j2Juin:6:0) ) = *off;
            return *off;
         endif;

         return SVPJUI_setPahJc2( peHjc2 );

        end-proc;

