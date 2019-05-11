// This example experiments using forall each time for a number of tasks, 
//  versus using a coforall for all the tasks. Running axpy repetitively may not be a good example,
//  a better situation would be, for example Jacobi, running different tasks. The results shed light
//  on the overhead of calling forall, such that using a coforall for all the tasks and blocking 
//  unnecessary threads for each task may be faster.
// If Rep is set to 1, 
//  axpy with forall: 0.178096 seconds
//  axpy with coforall: 3.55405 seconds
// If Rep is set to 100,
//  axpy with forall: 0.178096 seconds
//  axpy with coforall: 3.55405 seconds
// Setting numThreads to 2048 actually increases or does not improve the runtime.

use Time;

config var n = 1024 * 1024;
const dom = {1..n};
var k = 1.0;

var A: [dom] real = [i in dom] sin(i) * sin(i);
var B: [dom] real = [i in dom] cos(i) * cos(i);

const Rep = 100;

proc axpy_forall(const ref X: [?D] ?etype, ref Y: [D] etype, const ref alpha: etype) {
  for c in 1..Rep {
    forall i in D {
      Y[i] = alpha * X[i] + Y[i];
    }
  }
}

ref rA = A, rB = B, ralpha = k;

var t1: Timer;
t1.start();

axpy_forall(rA,rB,ralpha);

//writeln(rB);

t1.stop();
writeln("axpy with forall: ", t1.elapsed(), " seconds");

var A1: [dom] real = [i in dom] sin(i) * sin(i);
var B1: [dom] real = [i in dom] cos(i) * cos(i);

rA = A1; rB = B1;

proc axpy_coforall(const ref X: [?D] ?etype, ref Y: [D] etype, const ref alpha: etype) {
  var numEle = D.shape(1);
  var numThreads = 1024, numRep = numEle / numThreads;
  coforall i in 1..numThreads {
    for c in 1..Rep {
      for j in 1..numRep {
        var id = (i-1) * numRep + (j - 1) + 1;
        Y[id] = alpha * X[id] + Y[id];
      }
    }
  }
}

var t2: Timer;
t2.start();

axpy_coforall(rA,rB,ralpha);


t2.stop();
writeln("axpy with coforall: ", t2.elapsed(), " seconds");
