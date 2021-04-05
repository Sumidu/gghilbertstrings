#include <Rcpp.h>
//#include <math.h>
#include <cmath>

const double log4 = log(4.f);


//' Finds the order of the next highest number to the power of 4
//' @param n number
//' @return Order of next highest number 4^x
// [[Rcpp::export]]
long order4(long n) {
  if(n < 1){
    return (0L);
  }
  return ceil(log((double)n)/log4);
}


using namespace Rcpp;

//' Returns the x/y-position for a distance d in n possible values
//'
//' @param n First value
//' @param d Second value
//' @return Vector of x y
// [[Rcpp::export]]
NumericVector d2xy(long n, long d) {
  NumericVector output(2);
  long rx, ry, s, t=d;
  long x = 0L; long y = 0L;
  //*x = *y = 0;
  // loop sqrt(n) times - divide and conquer approach
  for (s = 1; s < n; s *= 2) {

    // Test odd of half, causses 01100110011 pattern
    rx = 1 & (t/2);

    // test odd of t^odd of half causes 001100110011 pattern
    ry = 1 & (t ^ rx);
    // Rotation
    if (ry == 0) {
      if (rx == 1) {
        x = s - 1 - x;
        y = s - 1 - y;
      }

      //Swap x and y
      long t2 = x;
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
NumericMatrix d2xy2(long n, NumericVector d) {

  // how long is the vector of data to produce
  long l = d.size();
  // innit matrix size l,2
  NumericMatrix output(l, 2);

  // To allow only powers of 4 as the basis we determine the order
  // This makes sense as we always want to start at 0,0 and end at 0, ymax
  // This is equalt to order = log^4(n)
  long order = order4(n);

  long offset = 0;
  long offset2 = 0;
  if (order % 2 == 1) {
    offset = -l;
    offset2 = l;
  }


  for (long i = 0; i < l; i ++) {
    long rx, ry, s, t=d[i];
    long x = 0; long y = 0;
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
        long t2 = x;
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



