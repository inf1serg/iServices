     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COW0001: Consulta General de Cotizaciones                    *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                               *06/01/2016   *
      **---------------------------------------------------------**
      *   Fecha    User     Modificacion
      * 2020/01/30 INF1SER1 Incorpora llamada a ramas
      *                     03  Vehiculos
      *                     23  Vida y AP
      *                     27  Hogar
      * 2020/03/24 INF1SERG Incorporo ramas de RV.
      **---------------------------------------------------------**
      * ************************************************************ *
     Fctw001    if   e           k disk
     Fset001    if   e           k disk
     Fsehni2    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fcow0001m  cf   e             workstn sfile(cow0001s1:recnum)

      * Prototypes ------------------------------------------------- *
     D COW0001         pr                  EXTPGM('COW0001')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt                        1  0 const
     D    nivc                        5  0 const
     D    nctw                        7  0 const

     D COW0001         pi
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D COW121          pr                  EXTPGM('COW121')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt1                       1    const
     D    nivc1                       5    const
     D    nctw1                       7    const
     D    rama                        2    const

     D COW131          pr                  EXTPGM('COW131')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt1                       1    const
     D    nivc1                       5    const
     D    nctw1                       7    const
     D    rama                        2    const

     D COW141          pr                  EXTPGM('COW141')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt1                       1    const
     D    nivc1                       5    const
     D    nctw1                       7    const
     D    rama                        2    const
     D    arse                        2    const

     D COW000111       pr                  EXTPGM('COW00011')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt                        1  0 const
     D    nivc                        5  0 const
     D    nctw                        7  0 const
     D    rama                        2  0 const

     D COW0002         pr                  EXTPGM('COW0002')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt                        1  0 const
     D    nivc                        5  0 const
     D    nctw                        7  0 const

      * Variables -------------------------------------------------- *
     D pempr           s              1
     D psucu           s              2
     D pnivt           s              1  0
     D pnivc           s              5  0
     D pnctw           s              7  0
     D peEmpr1         s              1
     D peSucu1         s              2
     D peNivt1         s              1
     D peNivc1         s              5
     D peNctw1         s              7
     D peRama1         s              2
     D peArse1         s              2
     D peRama          s              2  0
     D prama           s              2  0
     D uempr           s              1
     D usucu           s              2
     D univt           s              1  0
     D univc           s              5  0
     D unctw           s              7  0
     D urama           s              2  0

     D xxiden          s              1  0
     D recnum          s             10i 0

      * Local Data Ara --------------------------------------------- *
     D                uds
     D  usempr               401    401
     D  ussucu               402    403

      * Inicio Programa -------------------------------------------- *
     C                   eval      *inlr = *on
     C     k1yni2        chain     sehni2
     C     n2nrdf        chain     gnhdaf
     C                   eval      xxnivt = peNivt
     C                   eval      xxnivc = peNivc
     C                   eval      xxnctw = peNctw
     C                   eval      xxnomb = dfnomb
     C                   call      'SP0000'
     C                   parm                    xxemsu
     C                   eval      xxiden = 1
     C                   exsr      sf1car
     C                   dow       not *inkl
     C                   select
     C                   when      xxiden = 1
     C                   exsr      pant01
     C                   endsl
     C                   enddo
     C                   return
      * ************************************************************ *
     C     sf1car        begsr
     C                   exsr      sf1bor
     C                   exsr      setllRec
     C                   exsr      readRec
     C                   dow       not %eof and recnum < 12
     C                   eval      x1opci = *Zeros
     C                   eval      x1rama = w1rama
     C                   eval      x1arse = 1
     C     w1rama        chain     set001
     C                   eval      x1ramd = t@ramd
     C                   eval      recnum += 1
     C                   eval      *in30 = *on
     C                   write     cow0001s1
     C                   if        recnum = 1
     C                   eval      pempr = w1empr
     C                   eval      psucu = w1sucu
     C                   eval      pnivt = w1nivt
     C                   eval      pnivc = w1nivc
     C                   eval      pnctw = w1nctw
     C                   eval      prama = w1rama
     C                   endif
     C                   eval      uempr = w1empr
     C                   eval      usucu = w1sucu
     C                   eval      univt = w1nivt
     C                   eval      univc = w1nivc
     C                   eval      unctw = w1nctw
     C                   eval      urama = w1rama
     C                   exsr      readRec
     C                   enddo
     C                   eval      *in32 = %eof
     C                   endsr
      * ************************************************************ *
     C     sf1bor        begsr
     C                   setoff                                       3031
     C                   seton                                        32
     C                   write     cow0001c1
     C                   setoff                                       32
     C                   seton                                        31
     C                   eval      recnum = *Zeros
     C                   endsr
      * ************************************************************ *
     C     avanc         begsr
     C                   exsr      setgtRec
     C                   exsr      readRec
     C                   if        %eof
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      urama = prama
     C                   else
     C                   eval      uempr = w1empr
     C                   eval      usucu = w1sucu
     C                   eval      univt = w1nivt
     C                   eval      univc = w1nivc
     C                   eval      unctw = w1nctw
     C                   eval      urama = w1rama
     C                   endif
     C                   exsr      sf1car
     C                   endsr
      * ************************************************************ *
     C     retro         begsr
     C                   eval      recnum = *zeros
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      urama = prama
     C                   exsr      setllRec
     C                   dow       recnum < 12
     C                   exsr      readpRec
     C                   if        %eof
     C                   leave
     C                   else
     C                   add       1             recnum
     C                   endif
     C                   eval      uempr = w1empr
     C                   eval      usucu = w1sucu
     C                   eval      univt = w1nivt
     C                   eval      univc = w1nivc
     C                   eval      unctw = w1nctw
     C                   eval      urama = w1rama
     C                   enddo
     C                   exsr      sf1car
     C                   endsr
      * ************************************************************ *
     C     pant01        begsr
     C                   write     cow0001ca
     C                   write     cow0001p1
     C  n30              write     cow0001ne
     C                   exfmt     cow0001c1
     C                   setoff                                       50
     C                   select
     C                   when      *in27
     C                   exsr      retro
     C                   when      *in28
     C                   exsr      avanc
     C                   other
     C                   exsr      opci01
     C                   endsl
     C                   endsr
      * ************************************************************ *
     C     opci01        begsr
     C                   if        *in30
     C                   readc     cow0001s1
     C                   dow       not %eof
     C                   select
     C                   when      x1opci = 1
     C                   callp     COW000111 ( peEmpr : peSucu : peNivt
     C                             : peNivc : peNctw : x1rama )
     C                   eval      *inkl = *Off
     C                   when      x1opci = 2
     C                   callp     COW0002 ( peEmpr : peSucu : peNivt
     C                             : peNivc : peNctw )
     C                   when      x1opci = 3
      /Free
            // Seleccion x Rama
            Select;
              // Vehiculos
              When x1Rama = 03;
                   peNivt1 = %Editc(peNivt:'X');
                   peNivc1 = %Editc(peNivc:'X');
                   peNctw1 = %Editc(peNctw:'X');
                   peRama1 = %Editc(x1Rama:'X');
                   COW121  ( peEmpr :
                             peSucu :
                             peNivt1:
                             peNivc1:
                             peNctw1:
                             peRama1 );
              // Hogar
              When x1Rama = 27 or
                   x1Rama = 26 or
                   x1Rama = 28 or
                   x1Rama = 01 or
                   x1Rama = 08 or
                   x1Rama = 09 or
                   x1Rama = 15 or
                   x1Rama = 16;
                   peNivt1 = %Editc(peNivt:'X');
                   peNivc1 = %Editc(peNivc:'X');
                   peNctw1 = %Editc(peNctw:'X');
                   peRama1 = %Editc(x1Rama:'X');
                   COW131  ( peEmpr :
                             peSucu :
                             peNivt1:
                             peNivc1:
                             peNctw1:
                             peRama1 );
              // Vida
              When x1Rama = 23;
                   peNivt1 = %Editc(peNivt:'X');
                   peNivc1 = %Editc(peNivc:'X');
                   peNctw1 = %Editc(peNctw:'X');
                   peRama1 = %Editc(x1Rama:'X');
                   peArse1 = '01';
                   COW141  ( peEmpr :
                             peSucu :
                             peNivt1:
                             peNivc1:
                             peNctw1:
                             peRama1:
                             peArse1 );
            EndSl;
      /End-Free
     C                   other
     C                   eval      x1opci = *zeros
     C                   update    cow0001s1
     C                   leavesr
     C                   endsl
     C                   eval      x1opci = *zeros
     C                   update    cow0001s1
     C                   readc     cow0001s1
     C                   enddo
     C                   endif
     C                   endsr
      * ************************************************************ *
     C     *inzsr        begsr
     C     k1y001        klist
     C                   kfld                    peEmpr
     C                   kfld                    peSucu
     C                   kfld                    peNivt
     C                   kfld                    peNivc
     C                   kfld                    peNctw
     C                   kfld                    urama
     C     k2y001        klist
     C                   kfld                    peEmpr
     C                   kfld                    peSucu
     C                   kfld                    peNivt
     C                   kfld                    peNivc
     C                   kfld                    peNctw
     C     k1yni2        klist
     C                   kfld                    peEmpr
     C                   kfld                    peSucu
     C                   kfld                    peNivt
     C                   kfld                    peNivc
     C                   endsr
      * ************************************************************ *
     C     readRec       begsr
     C     k2y001        reade     ctw001
     C                   endsr
      * ************************************************************ *
     C     readpRec      begsr
     C     k2y001        readpe    ctw001
     C                   endsr
      * ************************************************************ *
     C     setllRec      begsr
     C     k1y001        setll     ctw001
     C                   endsr
      * ************************************************************ *
     C     setgtRec      begsr
     C     k1y001        setgt     ctw001
     C                   endsr
