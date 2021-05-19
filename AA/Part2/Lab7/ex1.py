from math import inf

def readInput(semi:list):
    n = int(input("Nr of semiplanes:\n>> "))

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
    minX = minY = inf

    for plane in semi:
        upperBound = inf
        lowerBound = -inf

        if plane[0] == 0:
            k = plane[1]
        elif plane[1] == 0:
            k = plane[0]

        if k > 0:
            upperBound = -plane[2] / k
        else:
            lowerBound = -plane[2] / k

        if plane[0] == 0:
            minY = max(minY, lowerBound)
            maxY = min(maxY, upperBound)
        elif plane[1] == 0:
            minX = max(minX, lowerBound)
            maxX = min(maxX, upperBound)

    if minX > maxX or minY > maxY:
        print("empty")
    elif (max(maxX, maxY) > inf) or (min(minX, minY) > -inf):
        print("infinity")
    else:
        print("finit")
        

if __name__ == '__main__':
    main()    