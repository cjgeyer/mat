
#include <R.h>
#include <R_ext/Lapack.h>

// matrix inverse using cholesky (LAPACK)
// first call DPOTRF and then DPOTRI

void matinv(double *a, int *n, double *result)
{
    int info;
    F77_CALL(dpotrf)("L", n, a, n, &info);
    if (info != 0)
        error("Cholesky decomposition failed");
    F77_CALL(dpotri)("L", n, a, n, &info);
    if (info != 0)
        error("inverse computation failed");
    // but we still only have the lower triangle of the result in a
    int in = n[0];
    for (int i = 0; i < in; i++) {
        result[i + in * i] = a[i + in * i];
        for (int j = 0; j < i; j++) {
            result[i + in * j] = a[i + in * j];
            result[j + in * i] = a[i + in * j];
        }
    }
}

// determinant using cholesky (LAPACK)
// first call DPOTRF and then determinant is square of product
// of diagonal elements of Cholesky factor (L in L L^T)

void matdet(double *a, int *n, double *result)
{
    int info;
    F77_CALL(dpotrf)("L", n, a, n, &info);
    if (info != 0)
        error("Cholesky decomposition failed");
    int in = n[0];
    result[0] = 1.0;
    for (int i = 0; i < in; i++)
        result[0] *= a[i + in * i];
    result[0] *= result[0];
}

// Solves A x = b with the solution x clobbering b (LAPACK)
// first call DPOTRF and then DPOTRS

void matsolve(double *a, double *b, int *nrowb, int *ncolb)
{
    int info;
    F77_CALL(dpotrf)("L", nrowb, a, nrowb, &info);
    if (info != 0)
        error("Cholesky decomposition failed");
    F77_CALL(dpotrs)("L", nrowb, ncolb, a, nrowb, b, nrowb, &info);
    if (info != 0)
        error("solution failed");
}

// Finds x^T A^{- 1} x
// Illustrates use of DPOTRS to avoid matrix inverse

void matsmash(double *a, int *n, double *x, double *result)
{
    int info;
    int ione = 1;
    double *savex = (double *) R_alloc(n[0], sizeof(double));
    F77_CALL(dpotrf)("L", n, a, n, &info);
    if (info != 0)
        error("Cholesky decomposition failed");
    F77_CALL(dcopy)(n, x, &ione, savex, &ione);
    F77_CALL(dpotrs)("L", n, &ione, a, n, x, n, &info);
    if (info != 0)
        error("solution failed");
    result[0] = F77_CALL(ddot)(n, x, &ione, savex, &ione);
}

