'''
Sursa formule din functia ccc: https://en.wikipedia.org/wiki/Circumscribed_circle#Circumcenter_coordinates
'''

from math import sqrt

def distance(A:tuple, B:tuple):

    return sqrt((A[0] - B[0]) ** 2 + (A[1] - B[1]) ** 2)

def radius(A:tuple, B:tuple, C:tuple):

    AB = distance(A, B)
    BC = distance(B, C)
    AC = distance(A, C)

    s = (AB + BC + AC) / 2

    return (AB * BC * AC) / (4 * sqrt(s * (s - AB) * (s - BC) * (s - AC)))

def ccc(A:tuple, B:tuple, C:tuple):

    D = 2 * (A[0] * (B[1] - C[1]) + B[0] * (C[1] - A[1]) + C[0] * (A[1] - B[1]))

    ux = ((A[0]**2 + A[1]**2) * (B[1] - C[1]) + (B[0]**2 + B[1]**2) * (C[1] - A[1]) + (C[0]**2 + C[1]**2) * (A[1] - B[1])) / D

    uy = ((A[0]**2 + A[1]**2) * (C[0] - B[0]) + (B[0]**2 + B[1]**2) * (A[0] - C[0]) + (C[0]**2 + C[1]**2) * (B[0] - A[0])) / D 

    return (ux, uy)

def check_position(K:tuple, U:tuple, r:int):
    
    dst = abs(distance(K, U))
    dst = round(dst, 3)
    r = round(r, 3)

    if dst > r:
        print("In exterior")
        return 
    elif dst == r:
        print("Pe cerc")
        return 
    else:
        print("In interior")
        return 

def main():

    print("Points that make the triangle:")
    
    x, y = input(">> ").split()
    x = int(x)
    y = int(y)
    A = (x, y)

    x, y = input(">> ").split()
    x = int(x)
    y = int(y)
    B = (x, y)

    x, y = input(">> ").split()
    x = int(x)
    y = int(y)
    C = (x, y)

    x, y = input("Point to check:\n>> ").split()
    x = int(x)
    y = int(y)
    K = (x, y)

    U = ccc(A, B, C)
    #print(U)
    r = radius(A, B ,C)

    check_position(K, U, r)

if __name__ == '__main__':
    main()