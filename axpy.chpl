// Example of using Chapel domain and BLAS for axpy
// Compiled with `chpl -lblas axpy.chpl` after running `sudo apt-get install libblas-dev liblapack-dev` on Ubuntu
// Output:
//  Chapel forall: 0.182318 seconds
//  BLAS: 0.005643 seconds


use Math;
use BLAS;
use Time;

config var n = 1024 * 1024;
const dom = {1..n};
var k = 1.0;

var A: [dom] real = [i in dom] sin(i) * sin(i);
var B: [dom] real = [i in dom] cos(i) * cos(i);

var C: [dom] real = 0.0;

var t1, t2: Timer;
t1.start();

forall i in dom {
  C[i] = k * A[i] + B[i];
}

t1.stop();
writeln("Chapel forall: ", t1.elapsed(), " seconds");

// writeln(C);

var vA: [dom] real = [i in dom] sin(i) * sin(i);
var vB: [dom] real = [i in dom] cos(i) * cos(i);

ref alpha = k;

t2.start();

axpy(vA,vB,alpha,1,1);

t2.stop();
writeln("BLAS: ", t2.elapsed(), " seconds");

//writeln(vB);
