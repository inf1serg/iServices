     H option(*nodebugio: *srcstmt: *noshowcpy)
     H dftactgrp(*no) actgrp(*caller)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLVI1:  WebService                                          *
      *          Retorna Días a Sumar/Restar Vigencia y frecuencia   *
      *          de refacturación.                                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               * 10-Abr-2017 *
      * ------------------------------------------------------------ *
      * GIO 20/12/2017: Controla la fecha de vigencia segun valor    *
      *                 definido en la tabla SETWEB                  *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpweb_h.rpgle'

     D WSLVI1          pr                  ExtPgm('WSLVI1')
     D   peArcd                       6  0 const
     D   peFdes                       8  0 const
     D   peHast                       8  0 const
     D   peHas1                       8  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLVI1          pi
     D   peArcd                       6  0 const
     D   peFdes                       8  0 const
     D   peHast                       8  0 const
     D   peHas1                       8  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPOPFECH        pr                  extpgm('SPOPFECH')
     D peFec1                         8  0
     D peSign                         1a
     D peTipo                         1a
     D peCant                         5  0
     D peFec2                         8  0
     D peErro                         1a
     D peFfec                         3a   options(*nopass)

     D SP0001          pr                  extpgm('SP0001')
     D  peParf                        8  0
     D  peParm                        2  0 const
     D  peFpgm                        3a   const

     D gira_fecha      pr             8  0
     D                                8  0 const
     D                                3a   const

     D @@repl          s          65536a
     D @@fhas          s              8  0

     D @@Empr          s              1    inz('A')
     D @@Sucu          s              2    inz('CA')
     D @@Tvha          s              3  0 inz(*zeros)
     D @@Flag          s               n
     D @@Fec1          s              8  0
     D @@Sign          s              1a
     D @@Tipo          s              1a
     D @@Cant          s              5  0
     D @@Fec2          s              8  0
     D @@Erro          s              1a
     D @@Ffec          s              3a

      /free

        *inlr = *on;

        peHas1 = 0;
        peErro = 0;
        clear peMsgs;

        if SVPWEB_getTopeVigenciaHasta( @@Empr
                                      : @@Sucu
                                      : peArcd
                                      : @@Tvha );

          @@Fec1 = peFdes;
          @@Sign = '+';
          @@Tipo = 'D';
          @@Cant = @@Tvha;
          clear @@Erro;
          @@Ffec = 'AMD';
          SPOPFECH( @@Fec1
                  : @@Sign
                  : @@Tipo
                  : @@Cant
                  : peHas1
                  : @@Erro
                  : @@Ffec );

          if @@Erro <> *blanks;

            peErro = -1;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'GEN0001'
                         : peMsgs    );

          endif;

        else;

          @@fhas = gira_fecha( peFdes : 'DMA' );
          SP0001( @@fhas : 12 : *blanks );
          @@fhas = gira_fecha( @@fhas : 'AMD' );
          peHas1 = @@fhas;
          SP0001( @@fhas : 12 : 'FIN' );

        endif;

        if peErro = 0 and peHast > peHas1;

           peErro = -1;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'GEN0016'
                        : peMsgs    );

        endif;

        return;

      /end-free

     P gira_fecha      B
     D gira_fecha      PI             8  0
     D @@feve                         8  0 CONST
     D @@tipo                         3A   CONST
     * Local fields
     D retField        S              8  0
     * AÑO-MES-DIA...
     D                 ds                  inz
     Dp@famd                  01     08  0
     D@@aÑo                   01     04  0
     D@@mes                   05     06  0
     D@@dia                   07     08  0
     * DIA-MES-AÑO...
     D                 ds                  inz
     Dp@fdma                  01     08  0
     D$$dia                   01     02  0
     D$$mes                   03     04  0
     D$$aÑo                   05     08  0
     *
     * Girar según como se pida...
     C                   select
     * Pasar a AÑO-MES-DIA...
     C                   when      @@tipo = 'AMD'
     C                   eval      p@fdma = @@feve
     C                   eval      @@aÑo = $$aÑo
     C                   eval      @@mes = $$mes
     C                   eval      @@dia = $$dia
     C                   eval      retfield = p@famd
     * Pasar a DIA-MES-AÑO...
     C                   when      @@tipo = 'DMA'
     C                   eval      p@famd = @@feve
     C                   eval      $$aÑo = @@aÑo
     C                   eval      $$mes = @@mes
     C                   eval      $$dia = @@dia
     C                   eval      retfield = p@fdma
     C                   endsl
     C                   RETURN    retField
     P gira_fecha      E
