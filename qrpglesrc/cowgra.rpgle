     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA:  Recupera descripcion del grupo rama              *
      * --------------------------------------------------------- *
      * Julio Barranco                       11-Dic-2015          *
      * ********************************************************* *

     D COWGRA          pr                  ExtPgm('COWGRA')
     D   peRama                       2  0   const
     D   peDgra                      30
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWGRA          pi
     D   peRama                       2  0   const
     D   peDgra                      30
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   @@Gra         s              1

      /copy './qcpybooks/svpws_h.rpgle'

       *inlr  = *on;

       @@Gra = SVPWS_getGrupoRama ( peRama );

       If @@gra = *blanks;
         peErro = -1;
       Endif;

       select;

          when @@Gra = 'T';    /// Embarcaciones ///
             peDgra = 'Embarcaciones';

          when @@Gra  = 'M';    /// Mercaderias ///
             peDgra = 'Mercaderias';

          when @@Gra  = 'C';   /// Consorcio ///
             peDgra = 'Consorcio';

          when @@Gra  = 'H';   /// Combinado Familiar - Hogar ///
             peDgra = 'Combinado Familiar - Hogar';

          when @@Gra  = 'R';   /// Comercio ///
             peDgra = 'Comercio';

          when @@Gra  = 'A';   /// Automoviles ///
             peDgra = 'Automoviles';

          when @@Gra  = 'V';   /// Vida ///
             peDgra = 'Vida';

          other;               /// Riesgos Varios ///
             peDgra = 'Riesgos Varios';

       endsl;

       SVPWS_End();

       return;
