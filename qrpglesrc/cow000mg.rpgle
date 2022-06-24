     H dftactgrp(*no) actgrp(*caller)
     H option(*nodebugio:*srcstmt)
      * ************************************************************** *
      * COW000MG:QUOM Web                                              *
      *          QUOM: Cotizaciones/Propuestas Mensajes                *
      * -------------------------------------------------------------- *
      * Sergio Fernandez                   *18-Ene-2016                *
      * -------------------------------------------------------------- *
      *                                                                *
      * ************************************************************** *
     Fctwmsg    if a e           k disk
     Fctw000    if   e           k disk
     Fsehni201  if   e           k disk
     Fcow000mgm cf   e             workstn

     D COW000MG        pr                  extpgm('COW000MG')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const
     D  peIndi                        2  0 const
     D  peRetu                         n

     D COW000MG        pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const
     D  peIndi                        2  0 const
     D  peRetu                         n

     Dgira_fecha       pr             8  0
     D                                8  0 const
     D                                3a   const options(*rightadj)

     D PsDs           sds                  qualified
     D  CurUsr                       10a   overlay(PsDs:358)

     C                   eval      *inlr = *on
     C                   write     cow000ca
     C                   exsr      carg00
     C                   dow       not *inkl
     C                   exsr      pant01
     C                   enddo
     C                   return

     C     pant01        begsr
     C                   exfmt     cow00001
     C                   select
     C                   when      *inka
     C                   exsr      vali01
     C  n50              exsr      grab01
     C  n50              eval      *inkl = *On
     C                   when      *inkl
     C                   eval      peRetu = *Off
     C                   endsl
     C                   endsr

     C     vali01        begsr
     C                   setoff                                       50
     C                   if        x2txmg = *Blanks
     C                   seton                                        50
     C                   endif
     C                   endsr

     C     grab01        begsr
     C     k1wmsg        setgt     ctwmsg
     C     k1wmsg        readpe    ctwmsg
     C                   if        %eof
     C                   eval      msivse  = 1
     C                   else
     C                   eval      msivse += 1
     C                   endif
     C                   eval      msempr = peEmpr
     C                   eval      mssucu = peSucu
     C                   eval      msnivt = peNivt
     C                   eval      msnivc = peNivc
     C                   eval      msnctw = peNctw
     C                   eval      mscpgm = 'COW000MG'
     C                   eval      mstxmg = x2txmg
     C                   eval      msmar1 = '0'
     C                   eval      msmar2 = '0'
     C                   eval      msmar3 = '0'
     C                   eval      msmar4 = '0'
     C                   eval      msmar5 = '0'
     C                   eval      msuser = PsDs.CurUsr
     C                   eval      msdate = %dec(%date():*iso)
     C                   eval      mstime = %dec(%time():*iso)
     C                   write     c1wmsg
     C                   endsr

     C     carg00        begsr
     C                   eval      peRetu = *On
     C     k1w000        chain     ctw000
     C                   if        not %found
     C                   eval      *inkl = *on
     C                   leavesr
     C                   endif
     C                   eval      x1soln = w0soln
     C     k1hni2        chain     sehni201                           20
     C   20              eval      x1nomb = *all'*'
     C  n20              eval      x1nomb = dfnomb
     C                   endsr

     C     *inzsr        begsr
     C     k1w000        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C                   kfld                    penctw
     C     k1hni2        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C     k1wmsg        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C                   kfld                    penctw
     C                   if        peIndi = 5
     C                   seton                                        05
     C                   else
     C                   setoff                                       05
     C                   endif
     C                   endsr

     P gira_fecha      B
     D gira_fecha      PI             8  0
     D @@feve                         8  0 CONST
     D @@tipo                         3A   CONST OPTIONS(*RIGHTADJ)
     D retField        S              8  0
     D                 ds                  inz
     Dp@famd                  01     08  0
     D@@aÑo                   01     04  0
     D@@mes                   05     06  0
     D@@dia                   07     08  0
     D                 ds                  inz
     Dp@fdma                  01     08  0
     D$$dia                   01     02  0
     D$$mes                   03     04  0
     D$$aÑo                   05     08  0
     *
     C                   select
     C                   when      @@tipo = 'AMD'
     C                   eval      p@fdma = @@feve
     C                   eval      @@aÑo = $$aÑo
     C                   eval      @@mes = $$mes
     C                   eval      @@dia = $$dia
     C                   eval      retfield = p@famd
     C                   when      @@tipo = 'DMA'
     C                   eval      p@famd = @@feve
     C                   eval      $$aÑo = @@aÑo
     C                   eval      $$mes = @@mes
     C                   eval      $$dia = @@dia
     C                   eval      retfield = p@fdma
     C                   endsl
     C                   RETURN    retField
     P gira_fecha      E
