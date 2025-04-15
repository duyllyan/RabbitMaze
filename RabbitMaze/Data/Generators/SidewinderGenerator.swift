//
//  SidewinderGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 14/04/25.
//

final class SidewinderGenerator: AnimatedMazeGenerator {
    var height: Int
    var width: Int
    var grid: [[CellType]] = []
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = GridUtility.initMazeWithOddIntersections(width: self.width, height: self.height)
    }
    
    func generateSteps() -> AsyncStream<MazeStep> {
        
        AsyncStream { continuation in
            Task {
                for row in stride(from: 1, to: grid.count, by: 2) {
                    
                    var run: [Coordinate] = []
                    
                    for col in stride(from: 1, to: grid[0].count, by: 2) {
                        let current = Coordinate(row: row, col: col)
                        run.append(current)
                        current.updateCell(in: &grid, continuation: continuation)
                        
                        let atEasternEdge = col + 2 >= grid[0].count
                        let atNorthernEdge = row == 1
                        let shouldCloseRun = atEasternEdge || (!atNorthernEdge && Bool.random())
                        
                        if shouldCloseRun {
                            if let random = run.randomElement(), !atNorthernEdge {
                                let above = Coordinate(row: (random.row - 1), col: random.col)
                                above.updateCell(in: &grid, continuation: continuation)
                            }
                            run.removeAll()
                        } else {
                            let east = Coordinate(row: row, col: col + 1)
                            east.updateCell(in: &grid, continuation: continuation)
                        }
                        
                        try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                    }
                }
                
                continuation.finish()
                
            }
        }
    }
}
