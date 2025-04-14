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
    
    init(generator: AnimatedMazeGenerator, width: Int, height: Int) {
        self.maze = GridUtility.initMaze(width: width, height: height)
        self.generator = generator
        self.entry = Coordinate(row: 1, col: 1)
        self.exit = Coordinate(row: height.toOdd - 2, col: width.toOdd - 2)
    }
    
    func start() {
        Task {
            for await step in generator.generateSteps(width: self.maze[0].count, height: self.maze.count) {
                self.maze[step.row][step.col] = step.type
            }
        }
    }
}
