from math import inf
import numpy

def readInput():
    
    global leftmost
    global rightmost
    global minX
    global maxX 

    leftmost = -1
    rightmost = -1
    minX = inf
    maxX = -inf

    with open("2.in") as f:
        n = int(f.readline().strip())

        puncte = []
        for i in range(n):
            x, y = f.readline().strip().split()

            x = int(x)
            y = int(y) 

            if x > maxX:
                rightmost = i
                maxX = x
            if x < minX:
                leftmost = i
                minX = x

            puncte.append((x,y))
    return puncte, n

def viraj(P, Q, R):
    mat = numpy.array([[1, 1,  1],
                    [P[0],Q[0],R[0]],
                    [P[1],Q[1],R[1]]])

    rez = numpy.linalg.det(mat)

    if rez == 0:
        return 0
    elif rez > 0:
        return 1
    else:
        return 2


def main():

    puncte, n = readInput()

    print(puncte)

    i = leftmost

    P = puncte[i]
    Q = puncte[(i+1) % n]

    hull = []

    hull.append(P)

    while True:
        hull.append(Q)

        R = puncte[(i + 2) % n]

        if i + 2 <= rightmost: 
            rez = viraj(P, Q, R)

            if rez == 0 or rez == 2:
                hull.pop(-1)
                hull.append(R)
            elif rez == 1:
                hull.append(R)

        elif i + 2 > rightmost:
            rez = viraj(P, Q, R)

            if rez == 0 or rez == 1:
                hull.pop(-1)
                hull.append(R)
            elif rez == 2:
                hull.append(R)

        i = (i + 1 ) % n
        P = Q
        Q = R

        if i == leftmost:
            print(hull)
            return



if __name__ == "__main__":
    main()