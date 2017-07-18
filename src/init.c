#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP _rcpp_module_boot_AnnoyAngular();
extern SEXP _rcpp_module_boot_AnnoyEuclidean();
extern SEXP _rcpp_module_boot_AnnoyManhattan();

static const R_CallMethodDef CallEntries[] = {
    {"_rcpp_module_boot_AnnoyAngular", (DL_FUNC) &_rcpp_module_boot_AnnoyAngular, 0},
    {"_rcpp_module_boot_AnnoyEuclidean", (DL_FUNC) &_rcpp_module_boot_AnnoyEuclidean, 0},
    {"_rcpp_module_boot_AnnoyManhattan", (DL_FUNC) &_rcpp_module_boot_AnnoyManhattan, 0},
    {NULL, NULL, 0}
};

void R_init_RcppAnnoy(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
