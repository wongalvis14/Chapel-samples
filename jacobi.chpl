// 2D 5-pt Poisson, Jacobi, n is the length of each side of solution grid
// Example of using Jacobi to solve Ax=b with known constants in A and b
// Using tol = 0.000001, the number of iterations for the following n's should be:
// n = 16, iters = 753; n = 32, iters = 2846; 
// n = 64, iters = 11051; n = 128, iters = 43539 (11.8531 secondson TIO with --fast);
// Note that the number of iterations varies linearly with n*n (solution grid size)

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
