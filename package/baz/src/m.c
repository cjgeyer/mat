// See section 6.6.1 of Writing R Extensions (Fortran character strings)
#define USE_FC_LEN_T

#include <R.h>
#include <R_ext/BLAS.h>

#ifndef FCONE
# define FCONE
#endif

void matvecmult(double *a, double *b, int *nrow, int *ncol, double *result)
{
    double zero = 0.0;
    double one = 1.0;
    int ione = 1;
    F77_CALL(dgemv)("n", nrow, ncol, &one, a, nrow, b, &ione, &zero, result,
        &ione FCONE);
}

void matmatmult(double *a, double *b, int *nrowa, int *ncola, int *ncolb,
    double *c)
{
    double one = 1.0;
    double zero = 0.0;
    F77_CALL(dgemm)("n", "n", nrowa, ncolb, ncola, &one, a, nrowa, b, ncola,
        &zero, c, nrowa FCONE FCONE);
}

