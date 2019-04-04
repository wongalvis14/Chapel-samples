// 2D 5-pt Poisson, Jacobi, n is the length of each side of solution grid

config var n = 16;
config var tol = 0.000001;

proc main() {

  var t, x: [{0..n+1, 0..n+1}] real = 0.0;

  var itern = 0, err: real = 1, maxiter = 10000;

  while (itern < maxiter) {
    itern = itern + 1;
    forall (i,j) in {1..n, 1..n} {
      t(i,j) = (x(i+1,j) + x(i-1,j) + x(i,j-1) + x(i,j+1) + 1) / 4;
    }
    err = max reduce abs(t[{1..n, 1..n}] - x[{1..n, 1..n}]);
    if err < tol then break;
    x[{1..n, 1..n}] = t[{1..n, 1..n}];
  } 

  writeln("# of iterations: ", itern );
}
