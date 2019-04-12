// Speed comparison over two axpy function that 
// 1) returns a new result array
// 2) modifies the referenced array Y
// On TIO:
// axpy with new array: 0.028651 seconds
// axpy with ref/const ref: 0.006137 seconds

use Time;

config var n = 1024 * 1024;
const dom = {1..n};
var k = 1.0;

var A: [dom] real = [i in dom] sin(i) * sin(i);
var B: [dom] real = [i in dom] cos(i) * cos(i);

var C: [dom] real = 0.0;

proc axpy_copy(X: [?D] ?etype, Y: [D] etype, alpha: etype) {
  var V: [D] real = 0.0;
  forall i in D {
    V[i] = alpha * X[i] + Y[i];
  }
  return V;
}

var t1: Timer;
t1.start();

for i in 1..10 {
  C = axpy_copy(A,B,k);
}
// writeln(C);
// writeln(B);

t1.stop();
writeln("axpy with new array: ", t1.elapsed(), " seconds");

proc axpy_ref(const ref X: [?D] ?etype, ref Y: [D] etype, const ref alpha: etype) {
  forall i in D {
    Y[i] = alpha * X[i] + Y[i];
  }
}

ref rA = A, rB = B, ralpha = k;

var t2: Timer;
t2.start();

for i in 1..10 {
  axpy_ref(rA,rB,ralpha);
}

//writeln(rB);

t2.stop();
writeln("axpy with ref/const ref: ", t2.elapsed(), " seconds");
