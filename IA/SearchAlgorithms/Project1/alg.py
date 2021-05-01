from collections import OrderedDict, defaultdict
from typing import Callable, List, Tuple, final

import time
import state

def trivial(position: state.State) -> int:
    # Trivial estimation with default value 0
    
    return 0

def dstFinish(position: state.State) -> int:
    # Calculate the distance between stone and exit
    dst = [abs(state.start[i] - position.position[i]) for i in range(2)]

    return sum(dst)

# List of available estimations
estimations: List[Tuple[Callable,str]] = [(trivial, "Trivial Estimation"), (dstFinish, "Distance from position to end")]

def aStar(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.State], dict]:

    # Implementation of slow A*. Returns a list with fial state and some additional data
    
    states = [state.State(state.start, None, 0, (state.map_colors[state.start[0]][state.start[1]], 1), None, False, ["Start"])]

    time_start = time.time()
    
    ans = []
    data = {
        "time": [],
        "nodes": []
    }

    visited_nodes = 0

    def proccesTime() -> float:
        return time.time() - time_start

    def estDistance(userstate: state.State) -> int:
        return userstate.distance + estimation(userstate)

    while states != [] and len(ans) < nr_solutions:
        if proccesTime() > timeout:
            break

        states.sort(key=estDistance)

        userstate = states[0]
        states.pop(0)
        visited_nodes += 1

        for urm in userstate.successors():
            if urm.endNode():
                ans.append(urm)
                data["time"].append(proccesTime())
                data["nodes"].append(visited_nodes)

            if not userstate.belongPath(urm):
                states.append(urm)
    
    return ans, data

def optimized(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.State], dict]:

    # Implementation of A* with open and closed list. Returns a list with fial state and some additional data

    opened = [state.State(state.start, None, 0, (state.map_colors[state.start[0]][state.start[1]], 1), None, False, ["Start"])]
    closed: List[state.State] = []

    time_start = time.time()
    
    def proccesTime() -> float:
        return time.time() - time_start

    def IsInClosed(userstate: state.State) -> bool:
        for el in closed:
            if el.encode() == userstate.encode():
                return True
        return False

    def estDistance(userstate: state.State) -> int:
        return userstate.distance + estimation(userstate)
    
    def FindAndUpdateInOpen(userstate: state.State) -> bool:
        for i in range(len(opened)):
            if opened[i].encode() == userstate.encode():
                if opened[i].distance > userstate.distance:
                    opened[i] = userstate
                return True
        return False

    while opened != []:
        if proccesTime() > timeout:
            return [], {
                    "UsedAlgorithm": "optimized A*"
                }

        opened.sort(key=estDistance)

        userstate = opened[0]
        opened.pop(0)
        closed.append(userstate)

        for urm in userstate.successors():
            if urm.endNode():
                return [urm], {
                    "time": [proccesTime()],
                    "nodes": [len(closed)],
                    "UsedAlgorithm": "optimized A*"
                }
            if IsInClosed(urm):
                continue
            if not FindAndUpdateInOpen(urm):
                opened.append(urm)
        
    return [], { }

def ucs(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.State], dict]:

    # Implementation of UCS algorithm. Returns a list with fial state and some additional data

    states = [state.State(state.start, None, 0, (state.map_colors[state.start[0]][state.start[1]], 1), None, False, ["Start"])]
    time_start = time.time()

    ans = []
    data = {
        "time": [],
        "nodes": []
    }

    visited_nodes = 0
    
    def proccesTime() -> float:
        return time.time() - time_start


    while states != [] and len(ans) < nr_solutions:
        if proccesTime() > timeout:
            break

        # There is no need of sorting

        userstate = states[0]
        states.pop(0)
        visited_nodes += 1

        for urm in userstate.successors():
            if urm.endNode():
                ans.append(urm)
                data["time"].append(proccesTime())
                data["nodes"].append(visited_nodes)

            if not userstate.belongPath(urm):
                states.append(urm)

    return ans, data

def idaStar(estimation: Callable, nr_solutions: int, timeout: float) -> Tuple[List[state.State], dict]:
    # Implementation of IDA* algorithm. Returns a list with fial state and some additional data

    start_node = state.State(state.start, None, 0, (state.map_colors[state.start[0]][state.start[1]], 1), None, False, ["Start"])
    time_start = time.time()

    ans = []
    data = {
        "time": [],
        "nodes": []
    }

    visited_nodes = 0
    current_estimation = 0
    
    def proccesTime() -> float:
        return time.time() - time_start

    def estDistance(userstate: state.State) -> int:
        return userstate.distance + estimation(userstate)


    visited_nodes = 0
    total_nodes = 0

    def SearchForPath(node: state.State, max_distance: int):
        nonlocal visited_nodes, total_nodes, proccesTime, timeout

        if proccesTime() > timeout:
            return None, float("inf")

        visited_nodes += 1

        if estDistance(node) > max_distance:
            return None, estDistance(node)
        
        if node.endNode():
            return node, node.distance
            
        min_cost = float('inf')

        for urm in node.successors():
            total_nodes += 1
            if node.belongPath(urm):
                continue
            
            final_node, best_est = SearchForPath(urm, max_distance)

            if final_node is not None:
                return final_node, best_est

            min_cost = min(min_cost, best_est)
        
        return None, min_cost


    while True:
        if proccesTime() > timeout:
            break
        
        final_node, current_estimation = SearchForPath(start_node, current_estimation)
        total_nodes += 1

        if final_node is not None:
            ans.append(final_node)
            data["time"].append(proccesTime())
            data["nodes"].append(visited_nodes)
            break

    return ans, data

# List of available algorithms
algorithms: List[Tuple[Callable, str]] = [(aStar, "Normal A*"), (idaStar, "IDA*"), (optimized, "optimized A*"), (ucs, "UCS"),]