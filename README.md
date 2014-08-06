
This is an R package that is a demo for statistical confusing classes
about how to call
[BLAS](http://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms) and
[LAPACK](http://en.wikipedia.org/wiki/LAPACK) routines to do numerical linear
algebra in C code called from R.

It is just a demo, it doesn't show how to use all BLAS and LINPACK routines
only a few of them (but if you can figure out how to call one, then you
can figure out how to call the rest).

Thus all the interesting stuff in this package is in the `src` directory of
the package, which contains the files

 * [m.c](package/mat/src/m.c) BLAS examples
 * [i.c](package/mat/src/i.c) LAPACK examples (also more BLAS)
 * [Makevars](package/mat/src/Makevars) which sets `PKG_LDFLAGS`

Everything else is just junk that surrounds this with a R package so it
can get exercised.  The examples in the help pages and in the `tests`
directory of the package show that the code works.  If the package is built
with

    R CMD check --use-valgrind mat

[valgrind](http://valgrind.org/) does not complain.
