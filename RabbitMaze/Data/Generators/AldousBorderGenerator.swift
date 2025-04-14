//
//  AldousBorderGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

final class AldousBorderGenerator: AnimatedMazeGenerator {
    func generateSteps(width: Int, height: Int) -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                var grid = GridUtility.initMaze(width: width, height: height)
                let start = GridUtility.startCell(grid)
                
                start.updateCell(in: &grid, continuation: continuation)
                
                let visitableRows = (grid.count - 1) / 2
                let visitableCols = (grid[0].count - 1) / 2
                var unvisited = visitableRows * visitableCols - 1
                
                var current = start
                
                while unvisited > 0 {
                    guard let neighbor = current.findNeighbors(in: grid).randomElement() else { return }
                    
                    let intermediate = Coordinate(row: (current.row + neighbor.row) / 2, col: (current.col + neighbor.col) / 2)
                    
                    if grid[neighbor.row][neighbor.col] == .wall {
                        neighbor.updateCell(in: &grid, continuation: continuation)
                        intermediate.updateCell(in: &grid, continuation: continuation)
                        unvisited -= 1
                    }
                    
                    current = neighbor
                    try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                }
                
                continuation.finish()
            }
        }
    }
}
