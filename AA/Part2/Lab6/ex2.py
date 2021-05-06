from math import inf

def readInput():
    nr_points = int(input("Nr points\n"))

    poly = []
    minX = minY = inf

    for i in range(0, nr_points):
        x, y = input(">> ").split()
        x = int(x)
        y = int(y)

        if x < minX:
            minX = x
            idx = i

        if y < minY:
            minY = y
            idy = i

        poly.append((x, y))
    return poly, idx, idy

def check(poly, minim, axis):

    if axis == 'x':
        axis = 0
    else:
        axis = 1

    ok = True
    nr = len(poly)

    prevPoint = poly[minim][axis]

    for i in range(1, nr):
        pos = (minim + i) % nr
        nextPoint = poly[pos][axis]

        if ok == True:
            if nextPoint < prevPoint:
                ok = False
        else:
            if nextPoint > prevPoint:
                return False

        prevPoint = nextPoint

    return True
            
def main():

    poly, minX, minY = readInput()

    if check(poly, minX, 'x') == True:
        print("Poligonul este x-monoton\n")
    else:
        print("Poligonul nu este x-monoton\n")

    if check(poly, minY, 'y') == True:
        print("Poligonul este y-monoton\n")
    else:
        print("Poligonul nu este y-monoton\n")


if __name__ == '__main__':
    main()