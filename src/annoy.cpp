// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; indent-tabs-mode: nil; -*-
//
//  RcppAnnoy -- Rcpp bindings to Annoy library for Approximate Nearest Neighbours
//
//  Copyright (C) 2014 - 2020  Dirk Eddelbuettel
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

#include "RcppAnnoy.h"

template< typename S, typename T, typename Distance, typename Random, class ThreadedBuildPolicy >
class Annoy
{
protected:
    AnnoyIndex<S, T, Distance, Random, ThreadedBuildPolicy> *ptr;
    unsigned int vectorsz;
public:
    Annoy(int n) : vectorsz(n) {
        ptr = new AnnoyIndex<S, T, Distance, Random, ThreadedBuildPolicy>(n);
    }
    ~Annoy() { if (ptr != NULL) delete ptr; }
    void addItem(S item, Rcpp::NumericVector dv) {
        if (item < 0) Rcpp::stop("Inadmissible item value %d", item);
        std::vector<T> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        char *errormsg;
        if (!ptr->add_item(item, &fv[0], &errormsg)) Rcpp::stop(errormsg);
    }
    void   callBuild(int n)               { ptr->build(n);                  }
    void   callUnbuild()                  { ptr->unbuild();                 }
    void   callSave(std::string filename) { ptr->save(filename.c_str());    }
    void   callLoad(std::string filename) { ptr->load(filename.c_str());    }
    void   callUnload()                   { ptr->unload();                  }
    int    getNItems()                    { return ptr->get_n_items();      }
    int    getNTrees()                    { return ptr->get_n_trees();      }
    double getDistance(int i, int j)      { return ptr->get_distance(i, j); }
    void   verbose(bool v)                { ptr->verbose(v);                }
    void   setSeed(int s)                 { ptr->set_seed(s);               }

    std::vector<S> getNNsByItem(S item, size_t n) {
        std::vector<S> result;
        ptr->get_nns_by_item(item, n, -1, &result, NULL);
        return result;
    }

    Rcpp::List getNNsByItemList(S item, size_t n, int search_k, bool include_distances) {
        if (include_distances) {
            std::vector<S> result;
            std::vector<T> distances;
            ptr->get_nns_by_item(item, n, search_k, &result, &distances);
            return Rcpp::List::create(Rcpp::Named("item")     = result,
                                      Rcpp::Named("distance") = distances);
        } else {
            std::vector<S> result;
            ptr->get_nns_by_item(item, n, search_k, &result, NULL);
            return Rcpp::List::create(Rcpp::Named("item") = result);
        }
    }

    std::vector<S> getNNsByVector(std::vector<double> dv, size_t n) {
        std::vector<T> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        std::vector<S> result;
        ptr->get_nns_by_vector(&fv[0], n, -1, &result, NULL);
        return result;
    }

    Rcpp::List getNNsByVectorList(std::vector<T> fv, size_t n, int search_k, bool include_distances) {
        if (fv.size() != vectorsz) {
            Rcpp::stop("fv.size() != vector_size");
        }
        if (include_distances) {
            std::vector<S> result;
            std::vector<T> distances;
            ptr->get_nns_by_vector(&fv[0], n, search_k, &result, &distances);
            return Rcpp::List::create(
                Rcpp::Named("item") = result,
                Rcpp::Named("distance") = distances);
        } else {
            std::vector<S> result;
            ptr->get_nns_by_vector(&fv[0], n, search_k, &result, NULL);
            return Rcpp::List::create(Rcpp::Named("item") = result);
        }
    }

    std::vector<double> getItemsVector(S item) {
        std::vector<T> fv(vectorsz);
        ptr->get_item(item, &fv[0]);
        std::vector<double> dv(fv.size());
        std::copy(fv.begin(), fv.end(), dv.begin());
        return dv;
    }

    bool onDiskBuild(std::string fname) {
        char *errormsg;
        if (!ptr->on_disk_build(fname.c_str(), &errormsg)) Rcpp::stop(errormsg);
        return true;
    }

};

typedef Annoy<int32_t, float,    Angular,   Kiss64Random, RcppAnnoyIndexThreadPolicy> AnnoyAngular;
typedef Annoy<int32_t, float,    Euclidean, Kiss64Random, RcppAnnoyIndexThreadPolicy> AnnoyEuclidean;
typedef Annoy<int32_t, float,    Manhattan, Kiss64Random, RcppAnnoyIndexThreadPolicy> AnnoyManhattan;
typedef Annoy<int32_t, uint64_t, Hamming,   Kiss64Random, RcppAnnoyIndexThreadPolicy> AnnoyHamming;

RCPP_EXPOSED_CLASS_NODECL(AnnoyAngular)
RCPP_MODULE(AnnoyAngular) {
    Rcpp::class_<AnnoyAngular>("AnnoyAngular")

        .constructor<int32_t>("constructor with integer count")

        .method("addItem",        &AnnoyAngular::addItem,         "add item")
        .method("build",          &AnnoyAngular::callBuild,       "build an index")
        .method("unbuild",        &AnnoyAngular::callUnbuild,     "unbuild an index")
        .method("save",           &AnnoyAngular::callSave,        "save index to file")
        .method("load",           &AnnoyAngular::callLoad,        "load index from file")
        .method("unload",         &AnnoyAngular::callUnload,      "unload index")
        .method("getDistance",    &AnnoyAngular::getDistance,     "get distance between i and j")
        .method("getNNsByItem",   &AnnoyAngular::getNNsByItem,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByItemList",  &AnnoyAngular::getNNsByItemList,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &AnnoyAngular::getNNsByVector,
                "retrieve Nearest Neigbours given vector")
        .method("getNNsByVectorList",  &AnnoyAngular::getNNsByVectorList,
                "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &AnnoyAngular::getItemsVector,  "retrieve item vector")
        .method("getNItems",      &AnnoyAngular::getNItems,       "get number of items")
        .method("getNTrees",      &AnnoyAngular::getNTrees,       "get number of trees")
        .method("setVerbose",     &AnnoyAngular::verbose,         "set verbose")
        .method("setSeed",        &AnnoyAngular::setSeed,         "set seed")
        .method("onDiskBuild",    &AnnoyAngular::onDiskBuild,     "build in given file")
        ;
}

RCPP_EXPOSED_CLASS_NODECL(AnnoyEuclidean)
RCPP_MODULE(AnnoyEuclidean) {
    Rcpp::class_<AnnoyEuclidean>("AnnoyEuclidean")

        .constructor<int32_t>("constructor with integer count")

        .method("addItem",        &AnnoyEuclidean::addItem,        "add item")
        .method("build",          &AnnoyEuclidean::callBuild,      "build an index")
        .method("unbuild",        &AnnoyEuclidean::callUnbuild,    "unbuild an index")
        .method("save",           &AnnoyEuclidean::callSave,       "save index to file")
        .method("load",           &AnnoyEuclidean::callLoad,       "load index from file")
        .method("unload",         &AnnoyEuclidean::callUnload,     "unload index")
        .method("getDistance",    &AnnoyEuclidean::getDistance,    "get distance between i and j")
        .method("getNNsByItem",   &AnnoyEuclidean::getNNsByItem,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByItemList",  &AnnoyEuclidean::getNNsByItemList,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &AnnoyEuclidean::getNNsByVector,
                "retrieve Nearest Neigbours given vector")
        .method("getNNsByVectorList",&AnnoyEuclidean::getNNsByVectorList,
                "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &AnnoyEuclidean::getItemsVector, "retrieve item vector")
        .method("getNItems",      &AnnoyEuclidean::getNItems,      "get number of items")
        .method("getNTrees",      &AnnoyEuclidean::getNTrees,      "get number of trees")
        .method("setVerbose",     &AnnoyEuclidean::verbose,        "set verbose")
        .method("setSeed",        &AnnoyEuclidean::setSeed,        "set seed")
        .method("onDiskBuild",    &AnnoyEuclidean::onDiskBuild,    "build in given file")
        ;
}

RCPP_EXPOSED_CLASS_NODECL(AnnoyManhattan)
RCPP_MODULE(AnnoyManhattan) {
    Rcpp::class_<AnnoyManhattan>("AnnoyManhattan")

        .constructor<int32_t>("constructor with integer count")

        .method("addItem",        &AnnoyManhattan::addItem,        "add item")
        .method("build",          &AnnoyManhattan::callBuild,      "build an index")
        .method("unbuild",        &AnnoyManhattan::callUnbuild,    "unbuild an index")
        .method("save",           &AnnoyManhattan::callSave,       "save index to file")
        .method("load",           &AnnoyManhattan::callLoad,       "load index from file")
        .method("unload",         &AnnoyManhattan::callUnload,     "unload index")
        .method("getDistance",    &AnnoyManhattan::getDistance,    "get distance between i and j")
        .method("getNNsByItem",   &AnnoyManhattan::getNNsByItem,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByItemList",  &AnnoyManhattan::getNNsByItemList,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &AnnoyManhattan::getNNsByVector,
                "retrieve Nearest Neigbours given vector")
        .method("getNNsByVectorList",&AnnoyManhattan::getNNsByVectorList,
                "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &AnnoyManhattan::getItemsVector, "retrieve item vector")
        .method("getNItems",      &AnnoyManhattan::getNItems,      "get number of items")
        .method("getNTrees",      &AnnoyManhattan::getNTrees,      "get number of trees")
        .method("setVerbose",     &AnnoyManhattan::verbose,        "set verbose")
        .method("setSeed",        &AnnoyManhattan::setSeed,        "set seed")
        .method("onDiskBuild",    &AnnoyManhattan::onDiskBuild,    "build in given file")
        ;
}

RCPP_EXPOSED_CLASS_NODECL(AnnoyHamming)
RCPP_MODULE(AnnoyHamming) {
    Rcpp::class_<AnnoyHamming>("AnnoyHamming")

        .constructor<int32_t>("constructor with integer count")

        .method("addItem",        &AnnoyHamming::addItem,        "add item")
        .method("build",          &AnnoyHamming::callBuild,      "build an index")
        .method("unbuild",        &AnnoyHamming::callUnbuild,    "unbuild an index")
        .method("save",           &AnnoyHamming::callSave,       "save index to file")
        .method("load",           &AnnoyHamming::callLoad,       "load index from file")
        .method("unload",         &AnnoyHamming::callUnload,     "unload index")
        .method("getDistance",    &AnnoyHamming::getDistance,    "get distance between i and j")
        .method("getNNsByItem",   &AnnoyHamming::getNNsByItem,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByItemList",  &AnnoyHamming::getNNsByItemList,
                "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &AnnoyHamming::getNNsByVector,
                "retrieve Nearest Neigbours given vector")
        .method("getNNsByVectorList",&AnnoyHamming::getNNsByVectorList,
                "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &AnnoyHamming::getItemsVector, "retrieve item vector")
        .method("getNItems",      &AnnoyHamming::getNItems,      "get number of items")
        .method("getNTrees",      &AnnoyHamming::getNTrees,      "get number of trees")
        .method("setVerbose",     &AnnoyHamming::verbose,        "set verbose")
        .method("setSeed",        &AnnoyHamming::setSeed,        "set seed")
        .method("onDiskBuild",    &AnnoyHamming::onDiskBuild,    "build in given file")
        ;
}
