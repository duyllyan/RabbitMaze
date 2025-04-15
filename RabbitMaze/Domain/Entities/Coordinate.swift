//
//  Coordinate.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

struct Coordinate: Equatable, Hashable {
    let row: Int
    let col: Int
    
    func moved(in direction: Direction) -> Coordinate {
        let delta = direction.delta
        return Coordinate(row: row + delta.row, col: col + delta.col)
    }
    
    func findNeighbors(in grid: [[CellType]], at directions: [Direction] = Direction.allCases, type: CellType? = nil) -> [Coordinate] {
        directions.compactMap { direction in
            let neighbor = self.moved(in: direction)
            guard neighbor.isInsideGrid(grid), neighbor.isOfType(type, in: grid) else { return nil }
            
            return neighbor
        }
    }
    
    func updateCell(in grid: inout [[CellType]], continuation: AsyncStream<MazeStep>.Continuation, type: CellType = .path) {
        grid[self.row][self.col] = type
        continuation.yield(MazeStep(row: self.row, col: self.col, type: type))
    }
    
    func isInsideGrid(_ grid: [[CellType]]) -> Bool {
        return row > 0 && row < grid.count &&
               col > 0 && col < grid[0].count
    }
    
    private func isOfType(_ type: CellType?, in grid: [[CellType]]) -> Bool {
        guard let type = type else { return true }
        return grid[row][col] == type
    }
}

