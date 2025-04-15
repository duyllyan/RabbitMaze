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
    let entry: Coordinate
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
            for await step in generator.generateSteps() {
                self.maze[step.row][step.col] = step.type
            }
        }
    }
}
