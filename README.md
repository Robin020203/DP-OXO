# Tic-Tac-Toe (OXO) - Prolog Implementation

## Overview
This repository contains a Prolog implementation of the classic game Tic-Tac-Toe (also known as Noughts and Crosses or OXO). It was developed as a logic programming practical exercise. The program supports both two-player (Human vs. Human) and single-player (Human vs. Computer) modes, applying structured strategies and game state evaluation.

## Features
* **Robust Board Representation:** Utilizes Prolog terms to represent a 3x3 grid and track game state securely.
* **Game Modes:** 
  * `playHH/0`: Interactive Human vs. Human gameplay.
  * `playHC/0`: Human vs. Computer gameplay where the program takes on the role of 'o'.
* **Computer AI Heuristics:** The computer opponent evaluates the board and selects its moves based on the following prioritized heuristics:
  1. Take a winning line if available.
  2. Block the opponent's winning line.
  3. Take the middle square.
  4. Take an available corner square.
  5. Choose the next available space dumbly.
* **Game State Detection:** Automatically spots winners and stalemates (draws) to conclude the game appropriately without requiring a fully occupied board if no further wins are possible.

## Prerequisites
* [SWI-Prolog](https://www.swi-prolog.org/)
* Required library files (`io.pl` and `fill.pl`) must be in the same directory for handling board rendering, user input, and state manipulation.

## How to Play
1. Load the main file into SWI-Prolog:
   ```prolog
   ?- consult('tic_tac_toe.pl').
   ```
2. To start a Human vs. Human game:
   ```prolog
   ?- playHH.
   ```
3. To start a Human vs. Computer game:
   ```prolog
   ?- playHC.
   ```
