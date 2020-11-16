
#include "RcppAnnoy.h"

#if defined(USE_AVX512)
#define AVX_INFO "Using 512-bit AVX instructions"
#elif defined(USE_AVX128)
#define AVX_INFO "Using 128-bit AVX instructions"
#else
#define AVX_INFO "Not using AVX instructions"
#endif

#if defined(_MSC_VER)
#define COMPILER_INFO "Compiled using MSC"
#elif defined(__GNUC__)
#define COMPILER_INFO "Compiled using GCC"
#elif defined(__clang__)
#define COMPILER_INFO "Compiled using Clang"
#else
#define COMPILER_INFO "Compiled on unknown platform"
#endif

#define ANNOY_DOC (COMPILER_INFO ". " AVX_INFO ".")

//' Report CPU Architecture and Compiler
//'
//' @return A constant direct created at compile-time describing
//' the extent of AVX instructions (512 bit, 128 bit, or none)
//' and compiler use where currently recognised are MSC (unlikely
//' for R), GCC, Clang, or \sQuote{other}.
// [[Rcpp::export]]
std::string getArchictectureStatus() {
  return std::string(ANNOY_DOC);
}
