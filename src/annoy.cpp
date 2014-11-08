// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; indent-tabs-mode: nil; -*-

#include <Rcpp.h>

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

    void build(int n)               { this->build(n);       }
    void save(std::string filename) { this->save(filename); }
    void load(std::string filename) { this->load(filename); }

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
        
        //.constructor("default constructor")  
        .constructor<int>("constructor with int")  

        .method("addItem",        &Annoy<float, Angular<float> >::addItem,        "adds an item")
        .method("build",          &Annoy<float, Angular<float> >::build,          "build an index")
        .method("save",           &Annoy<float, Angular<float> >::save,           "save index to file")
        .method("load",           &Annoy<float, Angular<float> >::load,           "load index from file")
        //unload

        // getDistance
        .method("getNNsByItem",   &Annoy<float, Angular<float> >::getNNsByItem,   "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &Annoy<float, Angular<float> >::getNNsByVector, "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &Annoy<float, Angular<float> >::getItemsVector, "retrieve item vector")
        // getNItems
        ;
}

RCPP_EXPOSED_CLASS_NODECL(AnnoyEuclidean)
RCPP_MODULE(AnnoyEuclidean) {
    Rcpp::class_<AnnoyEuclidean>("AnnoyEuclidean")   
        
        //.constructor("default constructor")  
        .constructor<int>("constructor with int")  

        .method("addItem",        &Annoy<float, Euclidean<float> >::addItem,        "adds an item")
        .method("build",          &Annoy<float, Euclidean<float> >::build,          "build an index")
        .method("save",           &Annoy<float, Euclidean<float> >::save,           "save index to file")
        .method("load",           &Annoy<float, Euclidean<float> >::load,           "load index from file")
        //unload

        // getDistance
        .method("getNNsByItem",   &Annoy<float, Euclidean<float> >::getNNsByItem,   "retrieve Nearest Neigbours given item")
        .method("getNNsByVector", &Annoy<float, Euclidean<float> >::getNNsByVector, "retrieve Nearest Neigbours given vector")
        .method("getItemsVector", &Annoy<float, Euclidean<float> >::getItemsVector, "retrieve item vector")
        // getNItems
        ;
}
