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

// define R's REprintf as the 'local' error print method for Annoy
#define __ERROR_PRINTER_OVERRIDE__  REprintf
#include "annoylib.h"

template<typename T, typename Distance> 
class Annoy : public AnnoyIndex<T, Distance > {
public:
    Annoy(int n) : AnnoyIndex<T, Distance>(n) {}

    void addItem(int item, Rcpp::NumericVector dv) {
        std::vector<T> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        this->add_item(item, &fv[0]);
    }

    void   callBuild(int n)               { this->build(n);                  }
    void   callSave(std::string filename) { this->save(filename);            }
    void   callLoad(std::string filename) { this->load(filename);            }
    void   callUnload()                   { this->unload();                  }
    int    getNItems()                    { return this->get_n_items();      }
    double getDistance(int i, int j)      { return this->get_distance(i, j); }

    std::vector<int> getNNsByItem(int item, int n) {
        std::vector<int> result;
        this->get_nns_by_item(item, n, &result);
        return result;
    }

    std::vector<int> getNNsByVector(std::vector<double> dv, int n) {
        std::vector<T> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        vector<int> result;
        this->get_nns_by_vector(&fv[0], n, &result);
        return result;
    }

    Rcpp::NumericVector getItemsVector(int item) {
        const typename Distance::node* m = this->_get(item);
        const T* v = m->v;
        Rcpp::NumericVector dv(this->_f);
        for (int i = 0; i < this->_f; i++) {
            dv[i] = v[i];
        }
        return dv;
    }


};

typedef Annoy<float, Angular<float> >   AnnoyAngular;
typedef Annoy<float, Euclidean<float> > AnnoyEuclidean;

RCPP_EXPOSED_CLASS_NODECL(AnnoyAngular)
RCPP_MODULE(AnnoyAngular) {
    Rcpp::class_<AnnoyAngular>("AnnoyAngular")   
        
        .constructor<int>("constructor with int")  

        .method("addItem",        &Annoy<float, Angular<float> >::addItem,        "add item")
        .method("build",          &Annoy<float, Angular<float> >::callBuild,      "build an index")
        .method("save",           &Annoy<float, Angular<float> >::callSave,       "save index to file")
        .method("load",           &Annoy<float, Angular<float> >::callLoad,       "load index from file")
        .method("unload",         &Annoy<float, Angular<float> >::callUnload,     "unload index")
        .method("getDistance",    &Annoy<float, Angular<float> >::getDistance,    "get distance between i and j")
        .method("getNNsByItem",   &Annoy<float, Angular<float> >::getNNsByItem,   "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &Annoy<float, Angular<float> >::getNNsByVector, "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &Annoy<float, Angular<float> >::getItemsVector, "retrieve item vector")
        .method("getNItems",      &Annoy<float, Angular<float> >::getNItems,      "get N items")
        ;
}

RCPP_EXPOSED_CLASS_NODECL(AnnoyEuclidean)
RCPP_MODULE(AnnoyEuclidean) {
    Rcpp::class_<AnnoyEuclidean>("AnnoyEuclidean")   
        
        .constructor<int>("constructor with int")  

        .method("addItem",        &Annoy<float, Euclidean<float> >::addItem,        "add item")
        .method("build",          &Annoy<float, Euclidean<float> >::callBuild,      "build an index")
        .method("save",           &Annoy<float, Euclidean<float> >::callSave,       "save index to file")
        .method("load",           &Annoy<float, Euclidean<float> >::callLoad,       "load index from file")
        .method("unload",         &Annoy<float, Euclidean<float> >::callUnload,     "unload index")
        .method("getDistance",    &Annoy<float, Euclidean<float> >::getDistance,    "get distance between i and j")
        .method("getNNsByItem",   &Annoy<float, Euclidean<float> >::getNNsByItem,   "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &Annoy<float, Euclidean<float> >::getNNsByVector, "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &Annoy<float, Euclidean<float> >::getItemsVector, "retrieve item vector")
        .method("getNItems",      &Annoy<float, Euclidean<float> >::getNItems,      "get N items")
        ;
}
