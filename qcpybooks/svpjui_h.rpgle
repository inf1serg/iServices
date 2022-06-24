      /if defined(SVPJUI_H)
      /eof
      /endif
      /define SVPJUI_H

         dcl-ds dsPahJc2_t qualified based(template);
                j2empr char(1);
                j2sucu char(2);
                j2rama packed(2:0);
                j2sini packed(7:0);
                j2nops packed(7:0);
                j2nrdf packed(7:0);
                j2sebe packed(6:0);
                j2nrcj packed(6:0);
                j2juin packed(6:0);
                j2fdem packed(8:0);
                j2trim char(10);
                j2trij char(10);
                j2aglo char(1);
                j2user char(10);
                j2date packed(8:0);
                j2time packed(6:0);
         end-ds;

         dcl-ds dsPahJc22_t qualified based(template);
                j2empr char(1);
                j2sucu char(2);
                j2rama packed(2:0);
                j2sini packed(7:0);
                j2nops packed(7:0);
                j2nrdf packed(7:0);
                j2sebe packed(6:0);
                j2nrcj packed(6:0);
                j2juin packed(6:0);
                j2fdem packed(8:0);
                j2trim char(10);
                j2trij char(10);
                j2aglo char(1);
                j2fmed char(1);
                j2user char(10);
                j2date packed(8:0);
                j2time packed(6:0);
         end-ds;

         dcl-ds dsPahJc3_t qualified based(template);
                j3empr char(1);
                j3sucu char(2);
                j3rama packed(2:0);
                j3sini packed(7:0);
                j3nops packed(7:0);
                j3nrdf packed(7:0);
                j3sebe packed(6:0);
                j3nrcj packed(6:0);
                j3juin packed(6:0);
                j3tins char(1);
                j3fsen packed(8:0);
                j3isob packed(15:2);
                j3ifis packed(15:2);
                j3xifi packed(5:2);
                j3ipsi packed(15:2);
                j3xips packed(5:2);
                j3dmor packed(15:2);
                j3dmat packed(15:2);
                j3puso packed(15:2);
                j3lces packed(15:2);
                j3tfut packed(15:2);
                j3gmed packed(15:2);
                j3tcon packed(15:2);
                j3liqs packed(15:2);
                j3otro packed(15:2);
                j3sala char(1);
                j3user char(10);
                j3date packed(8:0);
                j3time packed(6:0);
         end-ds;

         dcl-ds dsPahJc4_t qualified based(template);
                j4empr char(1);
                j4sucu char(2);
                j4rama packed(2:0);
                j4sini packed(7:0);
                j4nops packed(7:0);
                j4nrdf packed(7:0);
                j4sebe packed(6:0);
                j4nrcj packed(6:0);
                j4juin packed(6:0);
                j4tins char(1);
                j4tita packed(2:0);
                j4tint packed(7:4);
                j4mar1 char(1);
                j4user char(10);
                j4date packed(8:0);
                j4time packed(6:0);
         end-ds;

         dcl-pr SVPJUI_inz end-pr;
         dcl-pr SVPJUI_end end-pr;

         dcl-pr SVPJUI_error char(80);
             peErrm int(10) options(*nopass:*omit);
         end-pr;

         dcl-pr SVPJUI_getPahJc2 ind;
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
         end-pr;

         dcl-pr SVPJUI_setPahJc2 ind;
                peHjc2 likeds(dsPahJc2_t) const;
         end-pr;

         dcl-pr SVPJUI_dltPahJc2 ind;
                peEmpr char(1) const;
                peSucu char(2) const;
                peRama packed(2:0) const;
                peSini packed(7:0) const;
                peNops packed(7:0) const;
                peNrdf packed(7:0) const;
                peSebe packed(6:0) const;
                peNrcj packed(6:0) const;
                peJuin packed(6:0) const;
         end-pr;

         dcl-pr SVPJUI_chkPahJc2 ind;
                peEmpr char(1) const;
                peSucu char(2) const;
                peRama packed(2:0) const;
                peSini packed(7:0) const;
                peNops packed(7:0) const;
                peNrdf packed(7:0) const;
                peSebe packed(6:0) const;
                peNrcj packed(6:0) const;
                peJuin packed(6:0) const;
         end-pr;

         dcl-pr SVPJUI_updPahJc2 ind;
                peHjc2 likeds(dsPahJc2_t) const;
         end-pr;

         dcl-pr SVPJUI_getPahJc3 ind;
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
         end-pr;

         dcl-pr SVPJUI_setPahJc3 ind;
                peHjc3 likeds(dsPahJc3_t) const;
         end-pr;

         dcl-pr SVPJUI_dltPahJc3 ind;
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
         end-pr;

         dcl-pr SVPJUI_chkPahJc3 ind;
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
         end-pr;

         dcl-pr SVPJUI_updPahJc3 ind;
                peHjc3 likeds(dsPahJc3_t) const;
         end-pr;

         dcl-pr SVPJUI_getPahJc4 ind;
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
         end-pr;

         dcl-pr SVPJUI_setPahJc4 ind;
                peHjc4 likeds(dsPahJc4_t) const;
         end-pr;

         dcl-pr SVPJUI_dltPahJc4 ind;
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
         end-pr;

         dcl-pr SVPJUI_chkPahJc4 ind;
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
         end-pr;

         dcl-pr SVPJUI_updPahJc4 ind;
                peHjc4 likeds(dsPahJc4_t) const;
         end-pr;

         dcl-pr SVPJUI_getPahJc22 ind;
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
         end-pr;

         dcl-pr SVPJUI_setPahJc22 ind;
                peHjc2 likeds(dsPahJc22_t) const;
         end-pr;

         dcl-pr SVPJUI_updPahJc22 ind;
                peHjc2 likeds(dsPahJc22_t) const;
         end-pr;

