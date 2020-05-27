#include <Rcpp.h>

using namespace Rcpp;

//' Returns the position for a distance in n
//'
//' @param n First value
//' @param d Second value
//' @return Vector of x y
// [[Rcpp::export]]
NumericVector d2xy(int n, int d) {
  NumericVector output(2);
  int rx, ry, s, t=d;
  int x = 0; int y = 0;
  //*x = *y = 0;
  // loop sqrt(n) times
  for (s=1; s<n; s*=2) {
    rx = 1 & (t/2);
    ry = 1 & (t ^ rx);
    // Rotation
    if (ry == 0) {
      if (rx == 1) {
        x = s-1 - x;
        y = s-1 - y;
      }

      //Swap x and y
      int t2  = x;
      x = y;
      y = t2;
    }
    // end Rotation
    x += s * rx;
    y += s * ry;
    t /= 4;
  }
  output[0] = x;
  output[1] = y;

  return output;
}


