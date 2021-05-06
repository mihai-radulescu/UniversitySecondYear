'''
Ex1
Sursa: https://www.geeksforgeeks.org/how-to-check-if-a-given-point-lies-inside-a-polygon/
'''

INT_MAX = 10000
 
# Given three colinear points p, q, r, 
# the function checks if point q lies
# on line segment 'pr'
def onSegment(p:tuple, q:tuple, r:tuple):
     
    if ((q[0] <= max(p[0], r[0])) &
        (q[0] >= min(p[0], r[0])) &
        (q[1] <= max(p[1], r[1])) &
        (q[1] >= min(p[1], r[1]))):
        return -1
         
    #return False
 
# To find orientation of ordered triplet (p, q, r).
# The function returns following values
# 0 --> p, q and r are colinear
# 1 --> Clockwise
# 2 --> Counterclockwise
def orientation(p:tuple, q:tuple, r:tuple) -> int:
     
    val = (((q[1] - p[1]) *
            (r[0] - q[0])) -
           ((q[0] - p[0]) *
            (r[1] - q[1])))
            
    if val == 0:
        return 0
    if val > 0:
        return 1 # Collinear
    else:
        return 2 # Clock or counterclock
 
def doIntersect(p1, q1, p2, q2):
     
    # Find the four orientations needed for 
    # general and special cases
    o1 = orientation(p1, q1, p2)
    o2 = orientation(p1, q1, q2)
    o3 = orientation(p2, q2, p1)
    o4 = orientation(p2, q2, q1)
 
    # General case
    if (o1 != o2) and (o3 != o4):
        return True
     
    # Special Cases
    # p1, q1 and p2 are colinear and
    # p2 lies on segment p1q1
    if (o1 == 0) and (onSegment(p1, p2, q1)):
        return True
 
    # p1, q1 and p2 are colinear and
    # q2 lies on segment p1q1
    if (o2 == 0) and (onSegment(p1, q2, q1)):
        return True
 
    # p2, q2 and p1 are colinear and
    # p1 lies on segment p2q2
    if (o3 == 0) and (onSegment(p2, p1, q2)):
        return True
 
    # p2, q2 and q1 are colinear and
    # q1 lies on segment p2q2
    if (o4 == 0) and (onSegment(p2, q1, q2)):
        return True
 
    return False
 
# Returns true if the point p lies 
# inside the polygon[] with n vertices
def is_inside_polygon(points:list, p:tuple) -> bool:
     
    n = len(points)
     
    # There must be at least 3 vertices
    # in polygon
    if n < 3:
        return False
         
    # Create a point for line segment
    # from p to infinite
    extreme = (INT_MAX, p[1])
    count = i = 0
     
    while True:
        next = (i + 1) % n
         
        # Check if the line segment from 'p' to 
        # 'extreme' intersects with the line 
        # segment from 'polygon[i]' to 'polygon[next]'
        if (doIntersect(points[i],
                        points[next],
                        p, extreme)):
                             
            # If the point 'p' is colinear with line 
            # segment 'i-next', then check if it lies 
            # on segment. If it lies, return true, otherwise false
            if orientation(points[i], p,
                           points[next]) == 0:
                if onSegment(points[i], p, points[next]) == -1:
                    return -1
                                  
            count += 1
             
        i = next
         
        if (i == 0):
            break
         
    # Return true if count is odd, false otherwise
    return count #(count % 2 == 1)


def readInput():
    nr_points = int(input("Nr points\n"))

    poly = []

    for i in range(0, nr_points):
        x, y = input(">> ").split()
        x = int(x)
        y = int(y)
        
        poly.append((x, y))
    return poly

 
if __name__ == '__main__':
    #poly = [ (0, 0), (10, 0), (10, 10), (0, 10), (10, 15)]
    #poly = [ (0, 6), (0, 0), (6,0), (6, 6), (2, 6), (2, 2), (4, 2), (4, 5), (5, 5), (5, 1), (1, 1), (1, 6)]
    #point = (3, 2)
    
    poly = readInput()

    x, y = input("Point to check: ").split()
    x = int(x)
    y = int(y)
    point = (x, y)    

    ans = is_inside_polygon(poly, point)
    
    if ans >= 0 and ans % 2 == 1:
        print(" Inside")
    elif ans >= 0 and ans % 2 == 0:
        print(" Outside")
    elif ans < 0:
        print(" On segment")
