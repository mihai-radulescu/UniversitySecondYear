from math import inf

def readInput(semi:list):
    n = int(input("Nr de semiplane:\n>> "))

    for i in range(0, n):
        a, b, c = input(">> ").split()
        a = int(a)
        b = int(b)
        c = int(c)
        semi.append((a,b,c))

def main():
    semi = []
    readInput(semi)
    
    maxX = maxY = inf
    minX = minY = -inf

    for plane in semi:
        upperBound = inf
        lowerBound = -inf

        # Verific daca semiplanul este vertical sau orizontal
        if plane[0] == 0:
            k = plane[1]
        elif plane[1] == 0:
            k = plane[0]

        if k > 0:
            upperBound = -plane[2] / k
        else:
            lowerBound = -plane[2] / k

        if plane[0] == 0:
            maxY = min(maxY, upperBound)
            minY = max(minY, lowerBound)
        elif plane[1] == 0:
            maxX = min(maxX, upperBound)
            minX = max(minX, lowerBound)

    # print(minX, maxX, minY, maxY)

    # print(lowerBound, upperBound)

    if minX > maxX or minY > maxY:
        print("Intersectie vida")
        return
    
    if (max(maxX, maxY) == inf) or (min(minX, minY) == -inf):
        print("Intersectie nevida, nemarginita")
        return
    else:
        print("Intersectie nevida, marginita")
        return
        

if __name__ == '__main__':
    main()    