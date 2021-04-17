#ifndef CHROMOSOME_H_INCLUDED
#define CHROMOSOME_H_INCLUDED

#include <utility>
#include <vector>
#include <string>

#include "domain.h"

class Chromosome {
private:
    // Lungimea cromozomului
    int l = 0;
    
    // Domeniu
    domain_type domain;
    
    // Precizie
    int p;

    // Probabilitatea de selectie (set)
    LD ps{};

    // Vector ge gene
    std::vector<bool> genes;

    // Calculul lungimi unui cromozom: l = log((b - a) * 10 ^ p)
    void set_length();

public:

    Chromosome(domain_type d, int p): domain(d), p(p){
        set_length();
        generate_random();
    }
    Chromosome(domain_type d, int p, std::vector<bool> genes): domain(d), p(p), genes(std::move(genes)){
        set_length();
    }

    /// Metode de tip set

    // Setez genele unui cormozom
    void set_genome(std::vector<bool> genes);

    // Setez probabilitatea de selectie
    void set_selection_probability(LD ps);

    /// Metode de tip get

    // Obtin si setez lungimea
    int get_length();

    /// Decode chromosome - get value on interval
    LD get_value() const;

    // Obtin genom-ul sub forma de vector
    const std::vector<bool> &get_genome() const;
    
    // Obtin genomul sub forma de string
    std::string get_string_genome();

    // Obtin brobabilitatea de selectie
    LD get_selection_probability() const;
    
    /// Generez un set de gene aleator
    void generate_random();
};

#endif // CHROMOSOME_H_INCLUDED
