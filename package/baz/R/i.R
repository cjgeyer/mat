
matinv <- function(a)
{
    stopifnot(is.numeric(a))
    stopifnot(is.finite(a))
    stopifnot(is.matrix(a))
    stopifnot(a == t(a))
    .C("matinv", a = a, n = nrow(a),
        result = matrix(as.double(0), nrow(a), ncol(a)),
        PACKAGE = "baz")$result
}

matdet <- function(a)
{
    stopifnot(is.numeric(a))
    stopifnot(is.finite(a))
    stopifnot(is.matrix(a))
    stopifnot(a == t(a))
    .C("matdet", a = a, n = nrow(a), result = double(1),
        PACKAGE = "baz")$result
}

matsolve <- function(a, b)
{
    stopifnot(is.numeric(a))
    stopifnot(is.numeric(b))
    stopifnot(is.finite(a))
    stopifnot(is.finite(b))
    stopifnot(is.matrix(a))
    stopifnot(a == t(a))
    b <- as.matrix(b)
    stopifnot(nrow(a) == nrow(b))
    storage.mode(a) <- "double"
    storage.mode(b) <- "double"
    .C("matsolve", a = a, b = b, nrowb = nrow(b), ncolb = ncol(b),
        PACKAGE = "baz")$b
}

matsmash <- function(a, x, fortran = FALSE)
{
    stopifnot(is.numeric(a))
    stopifnot(is.numeric(x))
    stopifnot(is.finite(a))
    stopifnot(is.finite(x))
    stopifnot(is.matrix(a))
    stopifnot(a == t(a))
    stopifnot(nrow(a) == length(x))
    stopifnot(is.logical(fortran))
    stopifnot(length(fortran) == 1)
    if (fortran) {
        .Fortran("footran", a = as.double(a), n = nrow(a), x = as.double(x),
            result = double(1), PACKAGE = "baz")$result
    } else {
        .C("matsmash", a = as.double(a), n = nrow(a), x = as.double(x),
        result = double(1), PACKAGE = "baz")$result
    }
}

