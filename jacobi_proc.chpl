// Implementation of Jacobi solver as a proc
// Example usage in main() of 5-pt 2D Poisson

use Math;

// m is length of each side in 2D solution grid
// i.e. length of vector x is n = m * m
config var m = 16;
config var tol = 0.000001;

proc jacobi(A: [?AD] ?etype, ref x: [?D] etype, b: [D] etype, tol, maxiter) {
  if AD.rank != 2 || x.rank != 1 || b.rank != 1 then
    halt("Wrong shape of input matrix or vector");
  if AD.shape(1) != AD.shape(2) then
    halt("Matrix A is not a square");
  if AD.shape(1) != D.shape(1) then
    halt("Mismatch shape");

  var itern = 0, err: etype = 1;

  // writeln(AD.shape(1));
  // writeln(AD.dim(1));
  // writeln(D.shape(1));

  var t: [D] etype = 0;

  while (itern < maxiter) {
    itern = itern + 1;
    forall i in D {
      // TODO: faster and less memory, e.g. linear algebra, reduction
      var sigma = 0.0;
      for j in D {
        if i!=j then sigma += A(i,j) * x(j);
      }
      t(i) = (b(i) - sigma) / A(i,i);
    }
    err = max reduce abs(t[D] - x[D]);
    x[D] = t[D];
    if err < tol {
	    // writeln(itern);
	    break;
    }
  }

}

proc main() {

  // var t, x: [{0..n+1, 0..n+1}] real = 0.0;

  var n = m*m;

  var xdom = {1..n};
  var Adom = {1..n, 1..n};

  var A: [Adom] real = 0.0;

  forall i in {1..n} {
    A(i,i) = 4.0;
    if (i % m != 1) then A(i,i-1) = -1.0;
    if (i % m != 0) then A(i,i+1) = -1.0;
    if (i > m) then A(i,i-m) = -1.0;
    if (i <= n - m) then A(i,i+m) = -1.0;
  }

  // writeln(A);
  var x: [xdom] real = 0.0;
  var b: [xdom] real = 1.0;

  ref rx = x;

  jacobi(A, rx, b, tol, 10000);

  // writeln(rx);

}
