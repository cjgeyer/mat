library(mat)

a <- matrix(1:12, 3, 4)
b <- matrix(1:20, 4, 5)
x <- 1:4

all.equal(matvecmult(a, x), as.vector(a %*% cbind(x)))
all.equal(matmatmult(a, b), a %*% b)

n <- 20
p <- 5
x <- matrix(rnorm(n * p), nrow = n)
a <- t(x) %*% x
b <- rnorm(p)

all.equal(matinv(a), solve(a))
all.equal(matdet(a), det(a))
all.equal(matsolve(a, b), cbind(solve(a, b)))
all.equal(matsmash(a, b), as.vector(rbind(b) %*% solve(a) %*% cbind(b)))

b <- cbind(b, rnorm(p))
all.equal(matsolve(a, b), solve(a, b))

