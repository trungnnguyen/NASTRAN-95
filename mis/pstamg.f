      SUBROUTINE PSTAMG (INPUT,AJJL,SKJ)
C
C     DRIVER FOR PISTON THEORY
C
      INTEGER         SYSBUF,AJJL,SKJ,NAME(2),IZ(1)
      CHARACTER       UFM*23
      COMMON /XMSSG / UFM
      COMMON /ZZZZZZ/ Z(1)
      COMMON /SYSTEM/ SYSBUF,IOUT
      COMMON /PACKX / ITI,ITO,II,NN,INCR
      COMMON /AMGMN / MCB(7),NROW,ND,NE,REFC,FMACH,RFK,TSKJ(7),ISK,NSK
      COMMON /PSTONC/ NNJ,NMACH,NTHRY,NTHICK,NALPHA,NXIS,NTAUS,NSTRIP,
     1                SECLAM
      EQUIVALENCE     (Z(1),IZ(1))
      DATA    NHACPT, NHCOMM,NAME /4HACPT,4HCOMM,4HPSTA,4HMG  /
C
      ICORE = KORSZ(IZ) - 4*SYSBUF
C
C     BRING IN DATA AND ALLOCATE CORE
C
      CALL FREAD (INPUT,NNJ,9,0)
      IDEL = 1
      IB   = IDEL + NSTRIP
      ICA  = IB  + NSTRIP
      IPALP= ICA + NSTRIP
C
C     READ FIXED ARRAYS
C
      NW = 3*NSTRIP
      CALL FREAD (INPUT,Z,NW,0)
C
C     READ ALPHA ARRAY AND STUFF  AT END (INTEGRALS OR TAUS)
C
      IEND = 0
      DO 20 I = 1,NMACH
      CALL FREAD (INPUT,RM,1,0)
      IF (RM .NE. FMACH) GO TO 10
      IEND = 1
      CALL FREAD (INPUT,Z(IPALP),NALPHA,0)
      GO TO 20
   10 CALL FREAD (INPUT,Z,-NALPHA,0)
   20 CONTINUE
      IF (IEND .EQ. 0) GO TO 50
      IPT = IPALP + NALPHA
      CALL READ (*30,*30,INPUT,Z(IPT),ICORE,1,N)
   30 NT = IPT + N
      CALL BUG (NHACPT,30,Z,NT)
      CALL BUG (NHCOMM,30,NNJ,9)
C
C     OUTPUT SKJ
C
      RM  = 1.0
      ITI = 1
      ITO = 3
      II  = ISK
      NSK = NSK + 1
      NN  = NSK
      DO 40 I = 1,NNJ
      CALL PACK (RM,SKJ,TSKJ)
      II  = II + 1
      IF (I .EQ. NNJ) GO TO 40
      NN  = NN + 1
   40 CONTINUE
      ISK = II
      NSK = NN
      ITI = 3
      ITO = 3
      CALL PSTA (Z(IDEL),Z(IB),Z(ICA),Z(IPALP),Z(IPT),AJJL)
      NROW = NROW + NNJ
      GO TO 70
C
C     ERROR MESSAGE
C
   50 WRITE  (IOUT,60) UFM,FMACH
   60 FORMAT (A23,' 2428, MACH NUMBER ',F10.5,' WAS NOT FOUND IN ',
     1       'PISTON THEORY ALPHA ARRAY.')
      CALL MESAGE (-61,0,NAME)
C
   70 RETURN
      END