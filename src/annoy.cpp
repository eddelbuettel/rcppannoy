// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; indent-tabs-mode: nil; -*-
//
//  RcppAnnoy -- Rcpp bindings to Annoy library for Approximate Nearest Neighbours
//
//  Copyright (C) 2014           Dirk Eddelbuettel 
//
//  This file is part of RcppAnnoy
//
//  RcppAnnoy is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  RcppAnnoy is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with RcppAnnoy.  If not, see <http://www.gnu.org/licenses/>.

// simple C++ modules to wrap to two templated classes from Annoy
//
// uses annoylib.h (from Annoy) and provides R access via Rcpp
//
// Dirk Eddelbuettel, Nov 2014


#include <Rcpp.h>

#if defined(__MINGW32__)
#undef Realloc
#undef Free
#endif

// define R's REprintf as the 'local' error print method for Annoy
#define __ERROR_PRINTER_OVERRIDE__  REprintf
#include "annoylib.h"

template<typename S, typename T, typename Distance> 
class Annoy : public AnnoyIndex<S, T, Distance > {
public:
    Annoy(int n) : AnnoyIndex<S, T, Distance>(n) {}

    void addItem(S item, Rcpp::NumericVector dv) {
        std::vector<T> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        this->add_item(item, &fv[0]);
    }

    void   callBuild(int n)               { this->build(n);                  }
    void   callSave(std::string filename) { this->save(filename.c_str());    }
    void   callLoad(std::string filename) { this->load(filename.c_str());    }
    void   callUnload()                   { this->unload();                  }
    int    getNItems()                    { return this->get_n_items();      }
    double getDistance(int i, int j)      { return this->get_distance(i, j); }
    void   verbose(bool v)                { this->_verbose = v;              }

    std::vector<S> getNNsByItem(S item, size_t n) {
        std::vector<S> result;
        this->get_nns_by_item(item, n, &result);
        return result;
    }

    std::vector<S> getNNsByVector(std::vector<double> dv, size_t n) {
        std::vector<T> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        std::vector<S> result;
        this->get_nns_by_vector(&fv[0], n, &result);
        return result;
    }

    Rcpp::NumericVector getItemsVector(S item) {
        const typename Distance::node* m = this->_get(item);
        const T* v = m->v;
        Rcpp::NumericVector dv(this->_f);
        for (int i = 0; i < this->_f; i++) {
            dv[i] = v[i];
        }
        return dv;
    }


};

typedef Annoy<int32_t, float, Angular<int32_t, float> >   AnnoyAngular;
typedef Annoy<int32_t, float, Euclidean<int32_t, float> > AnnoyEuclidean;

RCPP_EXPOSED_CLASS_NODECL(AnnoyAngular)
RCPP_MODULE(AnnoyAngular) {
    Rcpp::class_<AnnoyAngular>("AnnoyAngular")   
        
        .constructor<int32_t>("constructor with integer count")  

        .method("addItem",        &AnnoyAngular::addItem,         "add item")
        .method("build",          &AnnoyAngular::callBuild,       "build an index")
        .method("save",           &AnnoyAngular::callSave,        "save index to file")
        .method("load",           &AnnoyAngular::callLoad,        "load index from file")
        .method("unload",         &AnnoyAngular::callUnload,      "unload index")
        .method("getDistance",    &AnnoyAngular::getDistance,     "get distance between i and j")
        .method("getNNsByItem",   &AnnoyAngular::getNNsByItem,    "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &AnnoyAngular::getNNsByVector,  "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &AnnoyAngular::getItemsVector,  "retrieve item vector")
        .method("getNItems",      &AnnoyAngular::getNItems,       "get N items")
        .method("setVerbose",     &AnnoyAngular::verbose,         "set verbose")
        ;
}

RCPP_EXPOSED_CLASS_NODECL(AnnoyEuclidean)
RCPP_MODULE(AnnoyEuclidean) {
    Rcpp::class_<AnnoyEuclidean>("AnnoyEuclidean")   
        
        .constructor<int32_t>("constructor with integer count")  

        .method("addItem",        &AnnoyEuclidean::addItem,        "add item")
        .method("build",          &AnnoyEuclidean::callBuild,      "build an index")
        .method("save",           &AnnoyEuclidean::callSave,       "save index to file")
        .method("load",           &AnnoyEuclidean::callLoad,       "load index from file")
        .method("unload",         &AnnoyEuclidean::callUnload,     "unload index")
        .method("getDistance",    &AnnoyEuclidean::getDistance,    "get distance between i and j")
        .method("getNNsByItem",   &AnnoyEuclidean::getNNsByItem,   "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &AnnoyEuclidean::getNNsByVector, "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &AnnoyEuclidean::getItemsVector, "retrieve item vector")
        .method("getNItems",      &AnnoyEuclidean::getNItems,      "get N items")
        .method("setVerbose",     &AnnoyEuclidean::verbose,        "set verbose")
        ;
}

