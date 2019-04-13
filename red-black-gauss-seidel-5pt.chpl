// 2D 5-pt Poisson, Red-Black Gauss Seidel, n is the length of each side of solution grid
// Example of using RBGS to solve Ax=b with known constants in A and b
// Using tol = 0.000001, the number of iterations for the following n's should be:
// n = 16, iters = 397; n = 32, iters = 1500; 
// n = 64, iters = 5823; n = 128, iters = 22939;
// Note that the number of iterations varies linearly with n*n (solution grid size)
// Iteration number is roughly half of Jacobi's

config var n = 16;
config var tol = 0.000001;

const solveDom = {1..n, 1..n};
const fullDom = {0..n+1, 0..n+1};

// O(n) additional space to store red, black indices
// For n = 128, the overhead for generating red,black indices takes 0.020637 seconds
// The solving part takes 5.91022 seconds

var red_odd: sparse subdomain(solveDom);
var red_even: sparse subdomain(solveDom);
var red: sparse subdomain(solveDom);

red_odd+= {1..n, 1..n} by 2 align (1,1);
red_even+= {1..n, 1..n} by 2 align (2,2);
red = red_odd + red_even;

var black_odd: sparse subdomain(solveDom);
var black_even: sparse subdomain(solveDom);
var black: sparse subdomain(solveDom);

black_odd+= {1..n, 1..n} by 2 align (1,2);
black_even+= {1..n, 1..n} by 2 align (2,1);
black= black_odd + black_even;

// writeln(red);
// writeln(black);
// writeln(red+black);

proc main() {

  var t, x: [{0..n+1, 0..n+1}] real = 0.0;

  var itern = 0, err: real = 1, maxiter = 10000;

  while (itern < maxiter) {
    itern = itern + 1;
    forall (i,j) in red {
      t(i,j) = (t(i+1,j) + t(i-1,j) + t(i,j-1) + t(i,j+1) + 1) / 4;
    }
    forall (i,j) in black{
      t(i,j) = (t(i+1,j) + t(i-1,j) + t(i,j-1) + t(i,j+1) + 1) / 4;
    }
    err = max reduce abs(t[{1..n, 1..n}] - x[{1..n, 1..n}]);
    if err < tol then break;
    x[{1..n, 1..n}] = t[{1..n, 1..n}];
  } 

  writeln("# of iterations: ", itern);
}
