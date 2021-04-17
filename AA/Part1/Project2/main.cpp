#include <iostream>
#include <cstdio>
#include <iomanip>

#include "alg/population.h"
#include "alg/chromosome.h"

int main()
{

    freopen("date/input.txt", "r", stdin);
    freopen("date/evolutie.txt", "w", stdout);

    // Generam populatia initiala pe baza informatiilor din fisierul input.txt
    auto *mutation = new Mutation(std::cin);

    mutation->set_debug(true);

    // Incepem procesul de evolutie
    mutation->mutate();

    std::cout << "\nEvolutia maximului:\n";

    for (int t = 1; t < mutation->get_steps(); t++)
    {
        mutation->set_debug(true);

        //Chromosome x = mutation->get_max_chromosome();

        // Afisam evolutia maximului
        std::cout << std::setprecision(16) << mutation->get_max_performance() << '\n'; //<< " x=" << mutation->max_x()

        mutation->mutate();
    }

    return 0;
}
// Comanada de build:
// g++ -Wall *.cpp alg/*.cpp  -o genetic