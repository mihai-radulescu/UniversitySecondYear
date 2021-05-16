
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
    
    print(semi)

if __name__ == '__main__':
    main()    