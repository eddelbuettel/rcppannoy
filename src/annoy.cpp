// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; indent-tabs-mode: nil; -*-

#include <Rcpp.h>

#include "annoylib.h"

class Annoy {

private:
    AnnoyIndex<float, Euclidean<float> > *ann;

public:
    //Annoy() { };
    Annoy(int n) {
        ann = new AnnoyIndex<float, Euclidean<float> >(n);
    }

    void addItem(int item, Rcpp::NumericVector dv) {
        std::vector<float> fv(dv.size());
        std::copy(dv.begin(), dv.end(), fv.begin());
        ann->add_item(item, &fv[0]);
    }

    void build(int n)               { ann->build(n);       }
    void save(std::string filename) { ann->save(filename); }
    void load(std::string filename) { ann->load(filename); }

    std::vector<int> getNNsByItem(int item, int n) {
        std::vector<int> result;
        ann->get_nns_by_item(item, n, &result);
        return result;
    }
};

RCPP_MODULE(Annoy) {
    Rcpp::class_<Annoy>("Annoy")   
        
        //.constructor("default constructor")  
        .constructor<int>("constructor with int")  

        .method("addItem",      &Annoy::addItem,      "adds an item")
        .method("build",        &Annoy::build,        "build an index")
        .method("save",         &Annoy::save,         "save index to file")
        .method("load",         &Annoy::load,         "load index from file")
        
        .method("getNNsByItem", &Annoy::getNNsByItem, "retrieve Nearest Neigbours given item")

        ;

}
