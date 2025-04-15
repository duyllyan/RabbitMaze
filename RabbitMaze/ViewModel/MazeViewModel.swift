//
//  MazeViewModel.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import Foundation

@MainActor
class MazeViewModel: ObservableObject {
    @Published var maze: [[CellType]] = []
    @Published var isGenerating: Bool = false
    @Published var wonGame: Bool = false
    var entry: Coordinate
    let exit: Coordinate
    
    private var generator: AnimatedMazeGenerator
    
    init(generator: AnimatedMazeGenerator) {
        self.maze = generator.grid
        self.generator = generator
        self.entry = Coordinate(row: 1, col: 1)
        self.exit = Coordinate(row: generator.grid.count - 2, col: generator.grid[0].count - 2)
    }
    
    func start() {
        Task {
            self.isGenerating = true
            for await step in generator.generateSteps() {
                self.maze[step.row][step.col] = step.type
            }
            self.isGenerating = false
        }
        
    }
    
    func restart() {
        entry = Coordinate(row: 1, col: 1)
        generator.grid = generator.initGrid(width: generator.grid.count, height: generator.grid[0].count)
        maze = generator.grid
        start()
    }
    
    func move(direction: Direction) {
        switch direction {
        case .up:
            let newPos = Coordinate(row: entry.row - 1, col: entry.col)
            if maze[newPos.row][newPos.col] == .path {
                maze[entry.row][entry.col] = .path
                entry = newPos
            }
        case .down:
            let newPos = Coordinate(row: entry.row + 1, col: entry.col)
            if maze[newPos.row][newPos.col] == .path {
                maze[entry.row][entry.col] = .path
                entry = newPos
            }
        case .left:
            let newPos = Coordinate(row: entry.row, col: entry.col - 1)
            if maze[newPos.row][newPos.col] == .path {
                maze[entry.row][entry.col] = .path
                entry = newPos
            }
        case .right:
            let newPos = Coordinate(row: entry.row, col: entry.col + 1)
            if maze[newPos.row][newPos.col] == .path {
                maze[entry.row][entry.col] = .path
                entry = newPos
            }
        }
        wonGame = entry == exit
    }
}
