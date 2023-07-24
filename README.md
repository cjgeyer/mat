
This is an R package that is a demo for statistical confusing classes
about how to call
[BLAS](http://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms) and
[LAPACK](http://en.wikipedia.org/wiki/LAPACK) routines to do numerical linear
algebra in C code called from [R](http://www.r-project.org).

If you don't use C but rather Fortran, then things are a lot simpler
because BLAS and Lapack are written in Fortran.  This is illustrated
for one of the functions in the package (R function `matsmash` can
call either Fortran or C, the Fortran in the file
[`footran.f`](package/baz/src/footran.f) is simpler than the alternative,
which is the C function `matsmash` in the file
[`i.c`](package/baz/src/i.c)).

The name of the git repo is different from the name of the R package because
the package used to be called mat and was renamed baz to avoid a conflict
with CRAN, not that we intend to put the package on CRAN but
`R CMD check --as-cran` does more checks, so we want to pass that too.

It is just a demo, it doesn't show how to use all BLAS and LINPACK routines
(only a few of them, but if you can figure out how to call one, then you
can figure out how to call the rest).

Thus all the interesting stuff in this package is in the `src` directory of
the package, which contains the files

 * [`m.c`](package/baz/src/m.c) BLAS examples
 * [`i.c`](package/baz/src/i.c) LAPACK examples (also more BLAS)
 * [`Makevars`](package/baz/src/Makevars) which sets `PKG_LIBS`

Everything else is just junk that surrounds this with an R package so it
can get exercised.  The examples in the help pages and in the `tests`
directory of the package show that the code works.  If the package is checked
with

    R CMD check baz_*.tar.gz --use-valgrind

[valgrind](http://valgrind.org/) does not complain.

To call some other BLAS or LAPACK routines, first you have to figure out
which ones.  The main [BLAS web site](http://www.netlib.org/blas/) has a
quick reference card, but it is in PostScript rather than PDF so you need
a PostScript viewer to read it.  As I write this, the version of LAPACK
included in the R sources is 3.10.1.  Check the `NEWS` file in the `doc`
directory of the R source tarball or at http://cran.r-project.org/src/base/NEWS
to see where it is now.  Alternatively, `news()` at the R command line
gets this.  Then read the users guide at
[LAPACK web site](http://www.netlib.org/lapack/#_manpages) to find out
which routines do what.

Then look at the R sources for which routines are included in R and are part
of the R public API.  They are found in the include files

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

The final things you need to know if you don't know FORTRAN are

 * a FORTRAN subroutine `foo` called from C must be wrapped with a macro `F77_CALL(foo)`, see [Section 6.6 of the book *Writing R Extensions*](http://cran.us.r-project.org/doc/manuals/r-release/R-exts.html#Calling-C-from-FORTRAN-and-vice-versa),
 * all variables in FORTRAN are passed by reference (meaning when called from
   C everything is a pointer),
 * R like FORTRAN stores matrices in columnwise order (first index changes the
   the fastest) and similarly for higher-dimensional arrays, see
   [Section 5.1 of the book *Introduction to R*](http://cran.us.r-project.org/doc/manuals/r-release/R-intro.html#Arrays).  This means (assuming you keep the matrices in the same storage order that R and FORTRAN have in your C code) you can pass the matrices direct to BLAS or LAPACK code without reordering them.
 * if a FORTRAN subroutine has character arguments (and many LAPACK routines
   do), then [Section 6.6.1  of the book *Writing R Extensions*](http://cran.us.r-project.org/doc/manuals/r-release/R-exts.html#fortran-character-strings)
   shows how to do that, and this package has been modified accordingly.
   
Our examples illustrate all of these.

One caution about the examples: the function `matinv` in the file
[`i.c`](package/baz/src/i.c) calculates the inverse of a square, positive
definite matrix.  But you should [almost never want to calculate a matrix
inverse](http://www.johndcook.com/blog/2010/01/19/dont-invert-that-matrix/).
If you are going to multiply the inverse by another vector, then you should
instead think of this problem as solving linear equations.

Suppose you want to calculate <var>A</var><sup>&minus;1</sup> <var>b</var>.
What you should actually do is solve the linear equations <var>A x = b</var>
for <var>x</var>.  This will be not only faster but also more computationally
stable.

Suppose you want to calculate <var>A</var><sup>&minus;1</sup> <var>B</var>,
where now <var>A</var> and </var>B</var> are both matrices.  What you should
actually do is still think of this as solving linear equations, now <var>A X = B</var>, where now <var>X</var> and <var>B</var> are both matrices.
(Since version 0.2 of this package, the function `matsolve` in
[`i.c`](package/baz/src/i.c) illustrates this.)

As an example of this, `matsmash` (I didn't know what to call it) in the file
[`i.c`](package/baz/src/i.c) calculates <var>x<sup>T</sup></var>
<var>A</var><sup>&minus;1</sup> <var>x</var> without doing explicit matrix
inversion.

The only place I can think of where you really need matrix inversion is
calculating the inverse Fisher information matrix (because you don't
use this in further matrix multiplications).

This package when checked with

    R CMD check baz_*.tar.gz --as-cran

generates complaints about registration of native routines.
If we actually wanted to make this a CRAN package (which of course we
don't because it is just a demo), we would need to do that.
See R package `fooRegister` in Github repo `foo`
(https://github.com/cjgeyer/foo) for how to do that.

