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
    
    @Published var width: Int {
        didSet {
            restart(generatorType: generatorType)
        }
    }
    @Published var height: Int{
        didSet {
            restart(generatorType: generatorType)
        }
    }
    
    private var generationTask: Task<Void, Never>?
        
    @Published var generatorType: AnimatedMazeGeneratorType
    var entry: Coordinate
    var exit: Coordinate
    
    private var generator: AnimatedMazeGenerator
    
    init(width: Int = 17, heigth: Int = 17, generatorType: AnimatedMazeGeneratorType = .huntAndKillGenerator) {
        self.width = width
        self.height = heigth
        self.generatorType = generatorType
        self.generator = AnimatedMazeGeneratorFactory.make(generatorType, width: width, height: heigth)
        self.maze = generator.grid
        self.entry = Coordinate(row: 1, col: 1)
        self.exit = Coordinate(row: generator.grid.count - 2, col: generator.grid[0].count - 2)
    }
    
    func start() {
        generationTask = Task {
            await MainActor.run {
                self.isGenerating = true
                self.maze = self.generator.grid
            }
            do {
                for await step in generator.generateSteps() {
                    try Task.checkCancellation()
                    
                    await MainActor.run {
                        guard self.maze.indices.contains(step.row) && self.maze[step.row].indices.contains(step.col) else { return }
                        self.maze[step.row][step.col] = step.type
                    }
                }
                await MainActor.run {
                    self.isGenerating = false
                }
            } catch {
                await MainActor.run {
                    if !Task.isCancelled {
                        self.isGenerating = false
                    }
                }
            }
        }
    }
    
    func restart(generatorType: AnimatedMazeGeneratorType) {
        generationTask?.cancel()
        self.generatorType = generatorType
        self.generator = AnimatedMazeGeneratorFactory.make(self.generatorType, width: self.width, height: self.height)
        self.entry = Coordinate(row: 1, col: 1)
        self.exit = Coordinate(row: generator.grid.count - 2, col: generator.grid[0].count - 2)
        self.maze = self.generator.grid
        wonGame = false
        isGenerating = false
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
