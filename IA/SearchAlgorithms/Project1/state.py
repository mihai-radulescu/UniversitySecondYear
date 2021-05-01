from typing import Tuple, List, Union, Optional

map_colors: List[List[str]] = None
map_bonus: List[List[str]] = None

start = None
stone = None

N, M = None, None

def setData(colors: List[List[str]], bonuses: List[List[str]]):
    # Sets inital values

    global map_colors, map_bonus, start, N, M, stone
    N = len(colors)
    M = len(colors[0])

    map_colors = colors
    map_bonus = bonuses

    start = None
    stone = None
    
    for i in range(N):
        if len(map_colors[i]) != M or len(map_colors[i]) != M:
            print("Invalid input.")
            return

    # Checks for input errors
    for i in range(N):
        for j in range(M):
            if bonuses[i][j] == '*':
                if start is not None:
                    print("Two start positions!")
                    break

                start = (i, j)
            
            if bonuses[i][j] == '@':
                if stone is not None:
                    print("Two stones!")
                    return

                stone = (i, j)

    if start is None:
        print("No start position!")
        return

    if stone is None:
        print("No stone position!")
        return

class State:
    def __init__(self, position: Tuple[int, int], previous_state: "State", distance: int, shoes: Tuple[str, int], backpack: Tuple[str, int], has_stone: bool, history: List[str]):
    

        # Player position
        self.position = position
        
        # Equiped shoes
        self.shoes = shoes
        
        # Shoes in backpack
        self.backpack = backpack
        
        # Picked up the stone
        self.has_stone = has_stone
        
        # Previous staet
        self.previous_state = previous_state
        
        # All moves made
        self.history = history
        
        self.distance = distance

    def clearBackpack(self):
        # Empty backpack if the shoes are used up
        
        if self.backpack is not None and self.backpack[1] == 3:
            self.backpack = None
            self.history.append("Removed shoes from the backpack as they are completly used")

    def endNode(self) -> bool:
        # Checks if the node is the exit

        if self.position == start and self.has_stone:
            return True
        else:
            return False
        
        #return self.position == start and self.has_stone

    def encode(self) -> Tuple:
        # Convetr to a tuple for easy comparison

        return tuple([self.position, self.shoes, self.backpack, self.has_stone])
    
    def reconstruct(self) -> "List[State]":
        # Generates a path from the root to the curent node
        ans = []
        act = self

        while act is not None:
            ans.append(act)
            act = act.previous_state
        
        return ans[::-1]

    def belongPath(self, state: "State") -> bool:
        # Checks if the state belogns to the path
        
        for i in self.reconstruct():
            if i.encode() == state.encode():
                return True
        return False

    def successors(self) -> "List[State]":

        ans = []

        def move( new_position: Tuple[int, int]) -> "List[State]":
            # Generates posible states for a move

            if new_position[0] < 0 or new_position[1] < 0 or new_position[0] >= N\
                    or new_position[1] >= M:
                return []
            next_color = map_colors[new_position[0]][new_position[1]]

            before_bonus: List[State] = []

            # State with equiped shoes
            if self.shoes[0] == next_color and self.shoes[1] < 3:
                new_state = State(new_position, self, self.distance + 1, (self.shoes[0], self.shoes[1] + 1), self.backpack, self.has_stone, ["Moved to " + str(new_position) + " from " + str(self.position)])
                before_bonus.append(new_state)

            # Change shoes
            if self.backpack is not None and self.backpack[0] == next_color and self.backpack[1] < 3:
                # Replace same color shoes if the shoes are used up
                if self.backpack[0] != self.shoes[0] or self.shoes[1] == 3:
                    new_state = State( new_position, self, self.distance + 1, (self.backpack[0], 1 + self.backpack[1]), self.shoes, self.has_stone, ["Changed shoes with backpack and moved to " + str(new_position) + " from " + str(self.position)])
                    before_bonus.append(new_state)
            
            ans = []

            for new_state in before_bonus:
                
                new_state.clearBackpack()
                bonus = map_bonus[new_position[0]][new_position[1]]
                
                if bonus == '@' and new_state.has_stone == False:
                    new_state.has_stone = True
                    new_state.history.append("Has the stone")
                    ans.append(new_state)
                    continue
                
                if bonus == '0' or bonus == '*':
                    ans.append(new_state)
                    continue

                if new_state.backpack is None:
                    new_state.backpack = (bonus, 0)
                    new_state.history.append("Added " + bonus + " color shoes in backpack")
                    ans.append(new_state)
                    continue
                
                # Ignore bonus - only if backpack is different.
                if new_state.backpack[0] != bonus:
                    ans.append(new_state)

                # Replace backpack -- only if different.
                if new_state.backpack[0] != bonus or new_state.backpack[1] != 0:
                    backpack_new = State(new_state.position, new_state.previous_state, new_state.distance, new_state.shoes, (bonus, 0), new_state.has_stone, new_state.history + ["Replaced backpack with " + bonus + " color shoes"])
                    ans.append(backpack_new)

                if bonus == next_color:
                    shoes_new = State(new_state.position, new_state.previous_state, new_state.distance, (bonus, 0), new_state.backpack, new_state.has_stone, new_state.history + ["Replaced equiped shoes with " + bonus + " color shoes and discarded previous pair"])
                    ans.append(shoes_new)

                    if new_state.backpack[0] != new_state.shoes[0]:
                        shoes_new_backpack_diff = State(new_state.position, new_state.previous_state, new_state.distance, (bonus, 0), new_state.shoes, new_state.has_stone, new_state.history + ["Replaced equiped shoes with " + bonus + " color shoes and replaced backpack with previous pair"])
                        ans.append(shoes_new_backpack_diff)
            
            for new_state in ans:
                new_state.clearBackpack()
            return ans

        relative_pos = [(0, 1), (0, -1), (1, 0), (-1, 0)]

        for dx, dy in relative_pos:
            new_position = move((self.position[0] + dx, self.position[1] + dy))
            ans += new_position
        return ans