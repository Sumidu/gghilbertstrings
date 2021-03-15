#include <Rcpp.h>

using namespace Rcpp;

//' Returns the x/y-position for a distance d in n possible values
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


//' Returns the x/y-position for a Vector of distances d in n possible values
//'
//' @param n Size of
//' @param d Second value
//' @return Matrix of x y values
// [[Rcpp::export]]
NumericMatrix d2xy2(int n, NumericVector d) {
  int l = d.size();
  NumericMatrix output(l, 2);
  int order = (log((int)n) / log((int)4));
  int offset = 0;
  int offset2 = 0;
  if (order % 2 == 1) {
    offset = -l;
    offset2 = l;
  }
  for (int i = 0; i < l; i ++) {
    int rx, ry, s, t=d[i];
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
        int t2 = x;
        x = y;
        y = t2;
      }
      // end Rotation
      x += s * rx;
      y += s * ry;
      t /= 4;
    }

    if (order % 2 == 1) {
      output[i] = y;
      output[l+i] = x;
    } else {
      output[i] = x;
      output[l+i] = y;
    }
  }


  return output;
}


