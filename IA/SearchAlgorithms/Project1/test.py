from typing import Callable, Tuple, List

import os
import state
import alg

def listFiles(folder: str) -> List[str]:
    # Recives a path to a folder and returns a list of files from that folder

    files = [f for f in os.listdir(folder) if os.path.isfile(os.path.join(folder, f))]
    
    return files

def readFile(filepath: str):
    # Readss a file 

    with open(filepath, "r") as fin:
        lines = [x.split() for x in fin.readlines()]
        N, M = (len(lines) - 1) // 2, len(lines[0])
        
        if len(lines[N]) != 0:
            raise IOError("Invalid input file!")

        state.setData(lines[:N], lines[N + 1:])

def makeDir(dir: str):
    # Create an output folder is there is none

    if os.path.exists(dir):
        return
    os.mkdir(dir)

def printResult(states: List[state.State], status: dict, file: str):
    # Prints solution

    # Open the output file
    with open(file, "w") as fout:

        # If states is empty there is no solution
        if states == []:
            fout.write("No solutions.\n")
            return
        
        # Nr of solutions found
        fout.write("Solutions found: %d\n" % len(states))

        # Prints steps for every solution
        for id, final_state in enumerate(states):
            fout.write("Solution #%d:\n" % (id + 1))
            total_history = final_state.reconstruct()

            # Actions for every step
            for step, i in enumerate(total_history):
                fout.write("\tStep #%d:\n" % step)
                for s in i.history:
                    fout.write("\t\t* " + s + "\n")
                
                fout.write("\t\t* Has stone: %s\n" % str(i.has_stone))

            fout.write("\tSummary:\n")
            fout.write("\t\tTime: %f seconds\n" % round(status["time"][id], 4))
            fout.write("\t\tNodes: %d\n" % status["nodes"][id])
            fout.write("\n")
                

def main():
    # Program start

    # Input folder
    folder = "input"
    output_folder = "output"
    id_alg = 4
    id_fn = 1
    nr_solutions = 3

    algorithm = alg.algorithms[id_alg - 1][0]

    function = alg.estimations[id_fn - 1][0]

    timeout = float(360)

    try:
        files_in_folder = listFiles(folder)
    except:
        print("Folder not found.")
        return

    # Output folder
    try:
        makeDir(output_folder)
    except:
        print("Unable to create the folder.")
        return

    # Select algorithm
    
    # Select estimation
    
    # Nr of solutions
   
    # Timeout in seconds

    # Read every input file
    for file in files_in_folder:

        try:

            # Read input
            print("Reading file \"%s\" ... \n" % file, end='')
            try:
                readFile(folder + "/" + file)
            except:
                print("Input file is corrupted (the data is not valid)! Skipping test...")
                continue
            
            # Call algorithm
            results = algorithm(function, nr_solutions, timeout)

            # Print solutions
            printResult(results[0], results[1], output_folder + "/" + file)

            print("Done!")
        
        except:
            print("Something went wrong.")
            return

if __name__ == "__main__":
    main()