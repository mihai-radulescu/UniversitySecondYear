#ifndef POPULATION_H_INCLUDED
#define POPULATION_H_INCLUDED

#include <iostream>
#include <vector>

#include "domain.h"
#include "chromosome.h"

class Mutation{
private:
    // Dimensiunea populatiei
    int n{};

    // Precizie
    int p{};

    // Nr de pasi
    int steps{};

    // Probabilitati de crossover si mutatie
    float pc{}, pm{};
    
    //
    LD tp{}; /// Total performance -> to be set
    
    // Domeniu
    domain_type domain{};
    
    // Vector care retine parametrii functie
    // x ^ 2 * params[0] + x * params[1] + params[2]
    std::vector<int> params = {0,0,0}; 
    
    // Vector in care se retine populatia (lista de comozomi)
    std::vector<Chromosome> population;
    
    // Interval de selectie
    std::vector<LD> q;

    bool DEBUG = true;

    // Generaeaza functia de maximizare
    LD f(LD x);

    // Returneaza functia
    LD fitness(LD x);

    // u in [0, 1)
    static float get_random_u();

    // p_i = fitness(X_i) / F
    void set_selection_probabilities(); 
    
    // q_i = p_1 + ... + p_i
    void set_selection_interval(); 
    
    // search <-> [q_i, q_i+1)
    int search_chromosome_on_q(float u); 
    
    std::vector<Chromosome> get_selected_population();

    std::pair<Chromosome, Chromosome> cross_split_chromosomes(Chromosome chromosome1, Chromosome chromosome2, int i);
    std::vector<int> get_crossover_marked_population();
    std::vector<Chromosome> get_crossed_population();

    std::vector<Chromosome> get_mutated_population();
    std::vector<int> get_mutation_marked_population() const;

public:

    explicit Mutation(std::istream&, bool = true);

    void set_debug(bool d);
    int get_steps() const;

    // Citire
    void read(std::istream &in);

    // Afiseaza informatiile populatiei
    void print_population(std::ostream &out);

    // Adauga cromozomi
    void add_chromosome(std::vector<bool> genes);
    void add_chromosome();

    // Genereaza populatia initiala
    void generate_initial_population();

    // Calculul performantei
    // F = sum(1..n, fitness(X_j))
    LD calculate_total_performance();
    LD get_total_performance();

    // AVG = F / n
    LD get_avg_performance();

    // MAX = max f(X)
    LD get_max_performance();

    void mutate();

    LD max_x();

    Chromosome get_max_chromosome();
};


#endif // POPULATION_H_INCLUDED
