import numpy  

def readInput():
    x, y = input("P:\n>> ").split()
    x = int(x)
    y = int(y)
    P = (x, y)

    x, y = input("Q:\n>> ").split()
    x = int(x)
    y = int(y)
    Q = (x, y)

    x, y = input("R:\n>> ").split()
    x = int(x)
    y = int(y)
    R = (x, y)

    return P, Q, R

def main():

    P, Q, R = readInput()

    mat = numpy.array([[1, 1,  1],
                    [P[0],Q[0],R[0]],
                    [P[1],Q[1],R[1]]])

    rez = numpy.linalg.det(mat)

    if rez == 0:
        print("Punctele sunt coliniare.")
        return
    elif rez > 0:
        print("Viraj la stanga.")
        return
    else:
        print("Viraj la dreapta.")
        return

if __name__ == "__main__":
    main()