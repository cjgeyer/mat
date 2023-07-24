
      SUBROUTINE footran(a, n, x, result)
      INTEGER info, errno
      DOUBLE PRECISION a(n, n), x(n), result, savex(n), ddot
      CALL dpotrf('L', n, a, n, info)
      IF (info .ne. 0) THEN
          CALL rexit('Cholesky decomposition failed')
      END IF
      CALL dcopy(n, x, 1, savex, 1)
      CALL dpotrs('L', n, 1, a, n, x, n, info)
      IF (info .ne. 0) THEN
          CALL rexit('solution failed')
      END IF
      result = ddot(n, x, 1, savex, 1)
      END
