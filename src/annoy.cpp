// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; indent-tabs-mode: nil; -*-
//
//  RcppAnnoy -- Rcpp bindings to Annoy library for Approximate Nearest Neighbours
//
//  Copyright (C) 2014 - 2015  Dirk Eddelbuettel
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
// define R's unif_rand() as the uniform rand generator for Annoy
#define __UNIFORM_RAND_OVERRIDE__ static_cast<long int>(unif_rand() * RAND_MAX)
#include "annoylib.h"
#include "kissrandom.h"

template<typename S, typename T, typename Distance>
class Annoy : public AnnoyIndexInterface<S, T> {
public:
    Annoy(int n) : AnnoyIndexInterface<S, T>(n) {}

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
    //void   verbose(bool v)                { this->_verbose = v;              }

    std::vector<S> getNNsByItem(S item, size_t n, size_t searchk) {
        std::vector<S> result;
        std::vector<T> distance;
        this->get_nns_by_item(item, n, searchk, &result, &distance);
        return result;
    }

    std::vector<S> getNNsByVector(std::vector<double> dv, size_t n, size_t searchk) {
        std::vector<T> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        std::vector<S> result;
        std::vector<T> distance;
        this->get_nns_by_vector(&fv[0], n, searchk, &result, &distance);
        return result;
    }

    Rcpp::NumericVector getItemsVector(S item) {
        const typename Distance::Node* m = this->_get(item);
        const T* v = m->v;
        Rcpp::NumericVector dv(this->_f);
        for (int i = 0; i < this->_f; i++) {
            dv[i] = v[i];
        }
        return dv;
    }
};

// this breaks Rcpp Modules as we can not have nested (ie two-level) templates :-/
//typedef Annoy<int32_t, float, Angular<int32_t, float, Kiss64Random> >   AnnoyAngular;
//typedef Annoy<int32_t, float, Euclidean<int32_t, float, Kiss64Random> > AnnoyEuclidean;

// this does too
//typedef Angular<int32_t, float, Kiss64Random>     AnnoyAngularDist;
//typedef Euclidean<int32_t, float, Kiss64Random>   AnnoyEucledianDist;
//typedef Annoy<int32_t, float, AnnoyAngularDist>   AnnoyAngular;
//typedef Annoy<int32_t, float, AnnoyEucledianDist> AnnoyEuclidean;

template class AnnoyIndexInterface<int32_t, float>;

class AnnoyAngular {
protected:    
    AnnoyIndexInterface<int32_t, float> *ptr;
public:
    AnnoyAngular(int n) {
        ptr = new AnnoyIndex<int32_t, float, Angular, Kiss64Random>(n);
    }
    void addItem(int32_t item, Rcpp::NumericVector dv) {
        std::vector<float> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        ptr->add_item(item, &fv[0]);
    }
    void   callBuild(int n)               { ptr->build(n);                  }
    void   callSave(std::string filename) { ptr->save(filename.c_str());    }
    void   callLoad(std::string filename) { ptr->load(filename.c_str());    }
    void   callUnload()                   { ptr->unload();                  }
    int    getNItems()                    { return ptr->get_n_items();      }
    double getDistance(int i, int j)      { return ptr->get_distance(i, j); }
    //void   verbose(bool v)                { ptr->_verbose = v;              }

    std::vector<int32_t> getNNsByItem(int32_t item, size_t n) {
        std::vector<int32_t> result;
        ptr->get_nns_by_item(item, n, -1, &result, NULL);
        return result;
    }

    std::vector<int32_t> getNNsByVector(std::vector<double> dv, size_t n) {
        std::vector<float> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        std::vector<int32_t> result;
        ptr->get_nns_by_vector(&fv[0], n, -1, &result, NULL);
        return result;
    }

    // -- commented as as the accessor _get is protected and not exported
    // Rcpp::NumericVector getItemsVector(int32_t item) {
    //     typedef Angular<int32_t, float, Kiss64Random> D;
    //     typedef typename D::Node Node;
    //     const Node* m = ptr->_get(item);
    //     const float* v = m->v;
    //     Rcpp::NumericVector dv(ptr->_f);
    //     for (int i = 0; i < ptr->_f; i++) {
    //         dv[i] = v[i];
    //     }
    //     return dv;
    // }
    
};

class AnnoyEuclidean {
protected:    
    AnnoyIndexInterface<int32_t, float>* ptr;
public:
    AnnoyEuclidean(int n) {
        ptr = new AnnoyIndex<int32_t, float, Euclidean, Kiss64Random>(n);
    }
    void addItem(int32_t item, Rcpp::NumericVector dv) {
        std::vector<float> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        this->ptr->add_item(item, &fv[0]);
    }
    void   callBuild(int n)               { this->ptr->build(n);                  }
    void   callSave(std::string filename) { this->ptr->save(filename.c_str());    }
    void   callLoad(std::string filename) { this->ptr->load(filename.c_str());    }
    void   callUnload()                   { this->ptr->unload();                  }
    int    getNItems()                    { return this->ptr->get_n_items();      }
    double getDistance(int i, int j)      { return this->ptr->get_distance(i, j); }
    //void   verbose(bool v)                { this->ptr->_verbose = v;              }

    std::vector<int32_t> getNNsByItem(int32_t item, size_t n) {
        std::vector<int32_t> result;
        this->ptr->get_nns_by_item(item, n, -1, &result, NULL);
        return result;
    }

    std::vector<int32_t> getNNsByVector(std::vector<double> dv, size_t n) {
        std::vector<float> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        std::vector<int32_t> result;
        this->ptr->get_nns_by_vector(&fv[0], n, -1, &result, NULL);
        return result;
    }

    // -- commented as as the accessor _get is protected and not exported
    // Rcpp::NumericVector getItemsVector(int32_t item) {
    //     const Euclidean<int32_t, float, Kiss64Random>::Node* m = this->ptr->_get(item);
    //     const float* v = m->v;
    //     Rcpp::NumericVector dv(this->ptr->_f);
    //     for (int i = 0; i < this->ptr->_f; i++) {
    //         dv[i] = v[i];
    //     }
    //     return dv;
    // }
    
};


//typedef AnnoyAngularClass<int32_t, float>   AnnoyAngular;
//typedef AnnoyEuclideanClass<int32_t, float> AnnoyEuclidean;

//RCPP_EXPOSED_CLASS_NODECL(AnnoyAngular)
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
        //.method("getItemsVector", &AnnoyAngular::getItemsVector,  "retrieve item vector")
        .method("getNItems",      &AnnoyAngular::getNItems,       "get N items")
        //.method("setVerbose",     &AnnoyAngular::verbose,         "set verbose")
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
        //.method("getItemsVector", &AnnoyEuclidean::getItemsVector, "retrieve item vector")
        .method("getNItems",      &AnnoyEuclidean::getNItems,      "get N items")
        //.method("setVerbose",     &AnnoyEuclidean::verbose,        "set verbose")
        ;
}
