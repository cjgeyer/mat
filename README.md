
This is an R package that is a demo for statistical confusing classes
about how to call
[BLAS](http://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms) and
[LAPACK](http://en.wikipedia.org/wiki/LAPACK) routines to do numerical linear
algebra in C code called from [R](http://www.r-project.org).

It is just a demo, it doesn't show how to use all BLAS and LINPACK routines
only a few of them (but if you can figure out how to call one, then you
can figure out how to call the rest).

Thus all the interesting stuff in this package is in the `src` directory of
the package, which contains the files

 * [`m.c`](package/mat/src/m.c) BLAS examples
 * [`i.c`](package/mat/src/i.c) LAPACK examples (also more BLAS)
 * [`Makevars`](package/mat/src/Makevars) which sets `PKG_LDFLAGS`

Everything else is just junk that surrounds this with a R package so it
can get exercised.  The examples in the help pages and in the `tests`
directory of the package show that the code works.  If the package is built
with

    R CMD check --use-valgrind mat

[valgrind](http://valgrind.org/) does not complain.

To call some other BLAS or LAPACK routines, first you have to figure out
which ones.  The main [BLAS web site](http://www.netlib.org/blas/) has a
quick reference card, but it is in PostScript rather than PDF so you need
a PostScript viewer to read it.  As I write this, the version of LAPACK
included in the R sources is 3.5.0.  Check the `NEWS` file in the `doc`
directory of the R source tarball or at http://cran.r-project.org/src/base/NEWS
to see where it is now.  Then read the users guide at
[LAPACK web site](http://www.netlib.org/lapack/#_manpages) to find out
which routines do what.

Then look at the R sources for which routines are included in R and are part
of the R public API.  They are if they are found in the include files

 * [`R_ext/BLAS.h`](https://svn.r-project.org/R/trunk/src/include/R_ext/BLAS.h)
 * [`R_ext/Lapack.h`](https://svn.r-project.org/R/trunk/src/include/R_ext/Lapack.h)

The files can also be found in your current R installation (whether or not
you have source).  Do

    R CMD config --cppflags

This tells you where the header files are.

Now that you have figured out what BLAS or LAPACK routine you want to use
and that it is indeed part of the R public API, you need to figure out how
to call it.  For this you read the comments in the FORTRAN source code in

 * [`src/extra/blas/blas.f`](https://svn.r-project.org/R/trunk/src/extra/blas/blas.f)
 * [`src/modules/lapack/dlapack.f`](http://svn.r-project.org/R/trunk/src/modules/lapack/dlapack.f)

of the R sources (so for this you need to have unpacked an R source tarball
or to read the sources online).

The final thing you need to know if you don't know FORTRAN is that all
variables in FORTRAN are passed by reference (meaning when called from
C everything is a pointer).  That is one thing our examples show.  The
other is how to call FORTRAN from C, and [Section 6.6 of the book *Writing R Extensions](http://cran.us.r-project.org/doc/manuals/r-release/R-exts.html#Calling-C-from-FORTRAN-and-vice-versa) explains this.  It is another thing
our examples show.

