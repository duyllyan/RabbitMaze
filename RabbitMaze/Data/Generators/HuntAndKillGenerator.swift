//
//  HK.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

final class HuntAndKillGenerator: AnimatedMazeGenerator {
    var height: Int
    var width: Int
    var grid: [[CellType]] = []
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = GridUtility.initMaze(width: width, height: height)
    }
    
    func generateSteps() -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                let start = GridUtility.startCell(grid)
                
                start.updateCell(in: &grid, continuation: continuation)
                
                var current: Coordinate? = start
                
                while current != nil {
                    if let walkedTo = performWalkStep(from: current, in: &grid, continuation: continuation) {
                        current = walkedTo
                        try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                    } else {
                        current = performHuntStep(in: &grid, continuation: continuation)
                    }
                }
                continuation.finish()
            }
        }
    }
    
    private func performWalkStep(
        from current: Coordinate?,
        in grid: inout [[CellType]],
        continuation: AsyncStream<MazeStep>.Continuation
    ) -> Coordinate? {
        guard let actual = current else { return nil }
        guard let neighbor = current?.findNeighbors(in: grid, type: .wall).randomElement() else { return nil }
        let intermediate = Coordinate(row: (actual.row + neighbor.row) / 2, col: (actual.col + neighbor.col) / 2)
        intermediate.updateCell(in: &grid, continuation: continuation)
        neighbor.updateCell(in: &grid, continuation: continuation)
        return neighbor
    }
    
    private func performHuntStep(
        in grid: inout [[CellType]], continuation: AsyncStream<MazeStep>.Continuation
    ) -> Coordinate? {
        for row in stride(from: 1, to: grid.count, by: 2) {
            for col in stride(from: 1, to: grid[0].count, by: 2) {
                if grid[row][col] == .wall {
                    let potentialStart = Coordinate(row: row, col: col)
                    let visitedNeighbors = potentialStart.findNeighbors(in: grid, type: .path)
                    if let neighbor = visitedNeighbors.randomElement() {
                        let intermediate = Coordinate(row: (potentialStart.row + neighbor.row) / 2, col: (potentialStart.col + neighbor.col) / 2)
                        potentialStart.updateCell(in: &grid, continuation: continuation)
                        intermediate.updateCell(in: &grid, continuation: continuation)
                        return potentialStart
                    }
                }
            }
        }
        return nil
    }
}
