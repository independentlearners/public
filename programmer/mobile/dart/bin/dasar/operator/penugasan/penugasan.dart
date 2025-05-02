void main() {
  print('\n' * 5);

  var a = 10;
  var b = 20;
  var c = 10;
  var d = 2.0;
  var e = 10;
  var f = 20;
  var g = 0;
  var h = 0;
  var i = 0;
  var j = 0;

  a += 5;
  b -= 10;
  c *= 5;
  d /= 2.0;
  e %= 3;
  f ~/= 2;

  'Increment';
  ++i;
  --j;

  'Decrement';
  g++;
  h--;

  print(' $a =>  a += 5 '
      ' $b => b -= 10 '
      ' $c => c *= 5 '
      ' $d => d /= 2.0 '
      ' $e => e %= 3 '
      ' $f => f ~/= 2 '
      ' $g => g++ Decrement'
      ' $h => h-- '
      ' $i => ++i Increment'
      ' $j => --j ');

  print('\n' * 5);
}
