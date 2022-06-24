     h Dftactgrp(*No)
     h option(*srcstmt: *nodebugio: *noshowcpy)
     h bnddir('HDIILE/HDIBDIR')
      **---------------------------------------------------------**
      *  Sistema       : CONSULTAS WEB
      *  Origen        : Software local
      *  Programa      : COW124
      *  Programacion  : Sergio Luis Puentes Valladares
      *  Fecha         : 2020/01/21
      *  Abr.Dev.      :
      *  Objetivo      : Consulta de Scoring
      *
      *
      *  Project Name  :
      *  Work ID       :

      **---------------------------------------------------------**
      *   Fecha    User    Modificacion
      **---------------------------------------------------------**
      *
      *
      *
      **---------------------------------------------------------**
      *  Objeto     D e s c r i p c i o n                         Tipo
      **---------------------------------------------------------**
      *  COW124FM   Consulta de Scoring Vehiculos                 DSPF
      *  CTWET3     Cotización Web: Scoring                       PF
      *  CTW000     Cotización Web: Cabecera de Cotizaciones      PF
      *
      **---------------------------------------------------------**
      *  Ind        Uso
      *
      *
      *
      **---------------------------------------------------------**
     * Define Archivos
      **---------------------------------------------------------**
     fcow124fm  cf   e             Workstn
     f                                     Sfile(Cow124cwa:NrSfl)
     f                                     InfDs(Iofb)
     fctwet3    if   e           k Disk
     fctw000    if   e           k Disk
      *---------------------------------------------------------------*
     * Define Estructura de Programa
      *---------------------------------------------------------------*
     d Parms          sds
     d  WsProg                 1     10
     d  WsStat                11     15  0
     d  ErrMsi                40     46
     d  ErrMsg                91    169
     d  JobNam               244    253
     d  WsPant               244    253
     d  Userid               254    263
     d  JobNbr               264    269
      *---------------------------------------------------------------*
     * Define Estructura de Pantalla
      *---------------------------------------------------------------*
     d Iofb            DS
     d  Wpfopn                 9      9
     d  Wpfeof                10     10
     d  WMsgid                46     52
     d  Wkypres              369    369
     d  WCurso               370    371B 0
     d  WSrn                 376    377B 0
     d  WSrnb                378    379B 0
      *
     d  F01            c                   Const(X'31')
     d  F02            c                   Const(X'32')
     d  F03            c                   Const(X'33')
     d  F04            c                   Const(X'34')
     d  F05            c                   Const(X'35')
     d  F06            c                   Const(X'36')
     d  F07            c                   Const(X'37')
     d  F08            c                   Const(X'38')
     d  F09            c                   Const(X'39')
     d  F10            c                   Const(X'3A')
     d  F11            c                   Const(X'3B')
     d  F12            c                   Const(X'3C')
     d  F13            c                   Const(X'B1')
     d  F14            c                   Const(X'B2')
     d  F15            c                   Const(X'B3')
     d  F16            c                   Const(X'B4')
     d  F17            c                   Const(X'B5')
     d  F18            c                   Const(X'B6')
     d  F19            c                   Const(X'B7')
     d  F20            c                   Const(X'B8')
     d  F21            c                   Const(X'B9')
     d  F22            c                   Const(X'BA')
     d  F23            c                   Const(X'BB')
     d  F24            c                   Const(X'BC')
     d  Enter          c                   Const(X'F1')
     d  Help           c                   Const(X'F3')
     d  PageUp         c                   Const(X'F4')
     d  PageDn         c                   Const(X'F5')
     d  Print          c                   Const(X'F6')

      *---------------------------------------------------------------*
     * Define Variables de Programa
      *---------------------------------------------------------------*
     d xVariables      ds                  Inz
     d  xInd                          5s 0
     d  xPos                          5s 0
     d  xLine                         5s 0
     d  xCiclo                        5s 0
     d  xRama1                        2s 0

     d  xFormat                       2A
     d  xData                         1A
     d  xError                        1A

     d  xFecha                        8A
     d  xTime                         8A
     d  xFecha1                       8S 0
     d  xTime1                        8S 0
     d  xTime_S                      26A
     d  xTime0                        8A
     d  xFecha0                      10A
     d  xTime_Stamp    S               Z

      *---------------------------------------------------
     * Define Variables de Subfile
      *---------------------------------------------------
     d XSubfile        DS                  Inz
     d  NrSfl                         4S 0
     d  RrSfl                         4S 0
     d  SrSfl                         4S 0
     d  ZrSfl                         4S 0
     d  WsfNum1                       4S 0
     d  WsfNum2                       4S 0
     d  WsfNum3                       4S 0
     d  WsfNum4                       4S 0
     d  Wsftot1                       4S 0
     d  Wsftot2                       4S 0
     d  Wsftot3                       4S 0
     d  Wsftot4                       4S 0

      *---------------------------------------------------
     * Define Variables de Keys
      *---------------------------------------------------
     d xKey1           DS                  Inz
     d  xEMPR                         1a
     d  xSUCU                         2a
     d  xNIVT                         1s 0
     d  xNIVC                         5s 0
     d  xNCTW                         7s 0
     d  xRAMA                         2s 0
     d  xPOCO                         4s 0
     d  xARSE                         2s 0

      *---------------------------------------------------------------*
     * Define Constantes de Programa
      *---------------------------------------------------------------*
     d up              c                   'ABCDEFGHIJKLMNNOPQRSTUVWXY-
     d                                     ZAEIOUAEIOUNAEIOU'
     d lo              c                   'abcdefghijklmn¤opqrstuvwxy-
     d                                     z ?¡¢£???"¥µÖàé'

      *----------------------------------------------------------------*
     * Define copys
      *----------------------------------------------------------------*
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

      *----------------------------------------------------------------*
     * Define klist de archivos
      *----------------------------------------------------------------*
     D k1twet3         ds                  likerec(C1wet3:*key)
     d k1tw000         ds                  likerec(C1w000:*key)

      *----------------------------------------------------------------*
     * Define programas invocados
      *----------------------------------------------------------------*
     d Main            pr                  ExtPgm('COW124    ')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1a   const
     d  peNivc                        5a   const
     d  peNctw                        7a   const
     d  peRama                        2a   const
     d  pePoco                        4a   const
     d  peArse                        2a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

      *----------------------------------------------------------------*
     * Define parametros de programas invocados
      *----------------------------------------------------------------*
     d Main            pi
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1a   const
     d  peNivc                        5a   const
     d  peNctw                        7a   const
     d  peRama                        2a   const
     d  pePoco                        4a   const
     d  peArse                        2a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

      /Free
         //*--------------------------------------------------------*
         //*    C  u  e  r  p  o      P  r  i  n  c  i  p  a  l     *
         //*--------------------------------------------------------*
         // Inicializa variables
            Exsr RtvDtaSis;

         // Ciclo de Proceso - Paneles
            Dow xFormat <> *Blanks;
                Select;
                   When xFormat = '10';  // Panel Principal
                        Exsr HndDtaP10;
                EndSl;
            EndDo;

         // Fin de Programa
            *inlr = *On;

         //*--------------------------------------------------------*
         //* HndDtaP10 - Rutina Manejo Panel 10                     *
         //*--------------------------------------------------------*
          BegSr  HndDtaP10;

            // Inicializa Panel
            Clear Cow124cwa;

            // Carga data de cabecera
            xxnivt = %Dec(peNivt:1:0);
            xxnivc = %Dec(peNivc:5:0);
            xxProd = SVPINT_GetNombre( peEmpr:
                                       peSucu:
                                       %Dec(peNivt:1:0):
                                       %Dec(peNivc:5:0));
            xxnctw = %Dec(peNctw:7:0);
            xxrama = %Dec(peRama:2:0);
            xxdram = SVPDES_rama( xxRama);
            xxPoco = %Dec(pePoco:4:0);
            // Carga data de cabecera
            Exsr RtvDtaCab;

            // Carga data de cobertura
            Exsr ChgDtaSfl1;

            // Ciclo Manejo Panel 10
            Dow xFormat = '10';

                // Despliega Panel
                Write  Cow124cca;
                Exfmt  Cow124cwb;

                // F12 = Salir
                If  Wkypres  = F12;
                    xFormat  = *Blanks;
                EndIf;

                // Intro:Valida - Procesa
                If  Wkypres  = Enter;
                EndIf;

            EndDo;

          EndSr;

         //*--------------------------------------------------------*
         //* ChgDtaSfl1 - Rutina Carga Datos Subfile 1              *
         //*--------------------------------------------------------*
          BegSr  ChgDtaSfl1;

              // Limpia Subfile
              *in30 = '0';
              *in31 = '1';
              Write Cow124cwb;
              *in30 = '1';
              *in31 = '0';
              *in32 = '1';

              // Inicializa variables de Subfile
              NrSfl       = *Zeros;

              // Posicionamiento
              // asigna campos clave
              Clear k1twet3;
              k1twet3.t3empr = peEmpr;
              k1twet3.t3sucu = peSucu;
              k1twet3.t3nivt = %Dec(peNivt:1:0);
              k1twet3.t3nivc = %Dec(peNivc:5:0);
              k1twet3.t3nctw = %Dec(peNctw:7:0);
              k1twet3.t3rama = %Dec(peRama:2:0);
              k1twet3.t3arse = %Dec(peArse:2:0);
              k1twet3.t3poco = %Dec(pePoco:4:0);
              // Posicionamiento
              Setll %kds(k1twet3:8) CTwet3;
              // Lectura de CTwet1
                 Reade %kds(k1twet3:8) CTwet3;

              // Carga Subfile - Principal
              Dow Not %Eof(CTwet3);
                  Clear Cow124cwa;
                  // Carga datos
                  xxTaaj =  t3Taaj;
                  x1Cosg =  t3Cosg;
                  x1Dcos =  SVPDES_pregunta(t3Taaj: t3Cosg);
                  x1Vefa =  'V';
                  If t3Vefa = '0';
                     x1Vefa =  'F';
                  EndIf;
                  x1Corc =  t3Corc;
                  x1Coca =  t3Coca;
                  x1Cant =  t3Cant;

                  NrSfl += 1;
                  Write Cow124cwa;
                  // Lectura de CTwet1
                  Reade %kds(k1twet3:8) CTwet3;
              EndDo;

              //  Verifica, si cargo subfile
              If NrSfl = 0;
                 *in40  = *On;
                 NrSfl += 1;
                 Write Cow124cwa;
              EndIf;

              //  Posiciona Record Subfile number, inicio
              WsfNum1 = NrSfl;
              //  Guarda total de registros Subfile
              If Wsftot1 = *Zeros;
                 Wsftot1 = NrSfl;
              EndIf;
              NrSfl   = 1;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvDtaCab  - Rutina Recupera datos de Tabla CTw000     *
         //*--------------------------------------------------------*
          BegSr  RtvDtaCab;

              // Inicializa registro
              Clear C1W000;

              // Posicionamiento
              Clear k1tw000;
              k1tw000.w0empr = peEmpr;
              k1tw000.w0sucu = peSucu;
              k1tw000.w0nivt = %Dec(peNivt:1:0);
              k1tw000.w0nivc = %Dec(peNivc:5:0);
              k1tw000.w0nctw = %Dec(peNctw:7:0);
              // Lectura de archivo CTw000
              Chain %kds(k1tw000) CTw000;
                  xxArcd = W0Arcd;
                  xxArno = W0Arno;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvPrmPrc - Rutina Recupera Parametros de Proceso      *
         //*--------------------------------------------------------*
          BegSr  RtvPrmPrc;

             // Recupera fecha de proceso
             xTime_Stamp = %Timestamp();
             xTime_S     = %Char(xTime_Stamp);
             xFecha      = %Subst(xTime_S:01:04)
                         + %Subst(xTime_S:06:02)
                         + %Subst(xTime_S:09:02);
             xFecha0     = %Subst(xTime_S:09:02) + '/'
                         + %Subst(xTime_S:06:02) + '/'
                         + %Subst(xTime_S:01:04);
             xTime       = %Subst(xTime_S:12:02)
                         + %Subst(xTime_S:15:02)
                         + %Subst(xTime_S:18:02)
                         + %Subst(xTime_S:21:02);
             xTime0      = %Subst(xTime_S:12:02)
                         + %Subst(xTime_S:15:02)
                         + %Subst(xTime_S:18:02)
                         + %Subst(xTime_S:21:02);
             xFecha1     = %Int(xFecha);
             xTime1      = %Int(xTime);

          EndSr;
         //*--------------------------------------------------------*
         //* RtvDtaSis - Rutina Inicial, Recupera datos de Sistema  *
         //*--------------------------------------------------------*
          BegSr  RtvDtaSis;

             //  Recupera Parametros de Proceso
             Exsr RtvPrmPrc;

             // Inicializa variables de programas
             xFormat = '10';

          EndSr;

      /End-Free
