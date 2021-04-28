import pygame
import sys
import copy
import time
import random

from dataclasses import dataclass
from typing import Any, Callable, List, Optional, Tuple

LIN = 5
COL = 5
GAME_H_OFFSET = 50

GAME_SCREEN_X, GAME_SCREEN_Y = None, None

class State:

    def __init__(self, display):
        self.moves = []

        self.taken = [[-1 for j in range(LIN - 1)] for i in range(COL - 1)]
        self.display = display

        self.taken_right = [[False for j in range(LIN)] for i in range(COL - 1)]

        self.taken_down = [[False for j in range(LIN - 1)] for i in range(COL)]


    def possible_moves(self):

        ans = []
        for i in range(self.COL):
            for j in range(self.LIN):
                if i < self.COL - 1 and self.taken_right[i][j] == False:
                    ans.append((0, i, j))
                
                if j < self.LIN - 1 and self.taken_down[i][j] == False:
                    ans.append((1, i, j))
        
        random.shuffle(ans)
        return ans

    def scores(self):
    
        ans = [0, 0]
        for i in range(self.COL - 1):
            for j in range(self.LIN - 1):
                if self.taken[i][j] != -1:
                    ans[self.taken[i][j]] += 1
        return ans


def min_max(state: State, player: int, depth: int):

    if depth == 0 or game_ended(state):
        return estimation

    for (move_type, x, y) in state.possible_moves():
        state_copy = state.create_copy()
        
        act, _ = min_max(state_copy, new_player, depth - 1, estimation_type)

        if (player == 0 and act > estimate) or (player == 1 and act < estimate):
            estimate = act
            action = (move_type, x, y)

    return (estimate, action)


def printMenu(question: str, answers: list, L: int, H: int, display):
    '''
        Asks the user some questions.
    '''
    display.fill((255, 255, 255))

    text = FONT.render(question, True, (0, 0, 0))
    text_rect = text.get_rect()
    text_rect.center = (GAME_SCREEN_X // 2, GAME_H_OFFSET // 2 + 5)
    display.blit(text, text_rect)

    DISTANCE = 10

    X = len(answers)
    Y = len(answers[0])
    H -= GAME_H_OFFSET

    for i in range(X):
        for j in range(Y):
            rect = pygame.Rect(
                int(L / X * i) + 3,
                int(H / Y * j) + GAME_H_OFFSET + 3,
                int(L / X - 6),
                int(H / Y - 6)
            )
            pygame.draw.rect(display, (100, 100, 100), rect, width=4, border_radius=6) 

            center_x = int(L / X * i + (L / X / 2))
            center_y = GAME_H_OFFSET + int(H / Y * j + (H / Y / 2))
            text = FONT_SMALLER.render(answers[i][j], True, (0, 0, 0))
            text_rect = text.get_rect()
            text_rect.center = (center_x, center_y)
            display.blit(text, text_rect)
            
    pygame.display.flip()

    while True:
        # Loop through the events of the game.
        for event in pygame.event.get():
            # Quit.
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            
            # Something was pressed.
            if event.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()
                # Check if a move was made, and if yes acknowledge it.
                pos = (pos[0], pos[1] - GAME_H_OFFSET)

                choice = (int(pos[0] / (L / X)), int(pos[1] / (H / Y)))
                return choice

pygame.font.init()
FONT = pygame.font.Font('freesansbold.ttf', 60)
FONT_SMALLER = pygame.font.Font('freesansbold.ttf', 30)

def loop(alg, player_1, name_1, player_2, name_2):
    return 0

def main():

    global GAME_SCREEN_Y, GAME_SCREEN_X
    pygame.display.set_caption("Radulescu Mihai => Dots and Boxes")

    GAME_SCREEN_X = 1000
    GAME_SCREEN_Y = 700

    # Get informations.
    ecran = pygame.display.set_mode(size=(GAME_SCREEN_X, GAME_SCREEN_Y))
        
    algs = [["Min-max", "A-B"]]
    _, alg = printMenu("Algorithm to use", algs, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

    if alg == 0:
        depth = [[None, 1],
                [2, 3]]
        questions = [["Player", "Easy"],
                    ["Medium", "Hard"]]
        idx, idy = printMenu("First Player", questions, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

        player_1 = depth[idx][idy]
        name_1 = questions[idx][idy]

        print(f"The user choose the first user as {name_1}")

        depth = [[None, 1],
                [2, 3]]
        questions = [["Player", "Easy"],
                    ["Medium", "Hard"]]
        idx, idy = printMenu("Second Player", questions, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

        player_2 = depth[idx][idy]
        name_2 = questions[idx][idy]

    if alg == 1:

        depth = [[None, 2],
                [3, 4]]
        questions = [["Player", "Easy"],
                    ["Medium", "Hard"]]
        idx, idy = printMenu("Second Player", questions, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

        player_1 = depth[idx][idy]
        name_1 = questions[idx][idy]

        print(f"The user choose the first user as {name_1}")

        depth = [[None, 2],
                [3, 4]]
        questions = [["Player", "Easy"],
                    ["Medium", "Hard"]]
        idx, idy = printMenu("Second Player", questions, GAME_SCREEN_X, GAME_SCREEN_Y, ecran)

        player_2 = depth[idx][idy]
        name_2 = questions[idx][idy]

        print(f"The user choose the second user as {name_2}")

    start_time = time.time()
    time = []
    
    generated = []
    nodes = 0
    moves = [0, 0]

    loop(alg, player_1, name_1, player_2, name_2)

if __name__ == '__main__':
    main()