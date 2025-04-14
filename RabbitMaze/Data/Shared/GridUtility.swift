//
//  GridUtility.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

struct GridUtility {
    private init() {}
    
    static func randomOddCoordinate(width: Int, height: Int) -> Coordinate {
        var row: Int
        var column: Int
        repeat { row = Int.random(in: 1..<height - 1) } while row.isOdd
        repeat { column = Int.random(in: 1..<width - 1) } while column.isOdd
        return Coordinate(row: row, col: column)
    }
    
    static func initMaze(width: Int, height: Int) -> [[CellType]] {
        let adjustedWidth = width.toOdd
        let adjustedHeight = height.toOdd
        return Array(repeating: Array(repeating: .wall, count: adjustedWidth), count: adjustedHeight)
    }
    
    static func startCell(_ grid: [[CellType]]) -> Coordinate {
        var row: Int
        var col: Int
        repeat { row = Int.random(in: 1..<grid.count - 1) } while row.isOdd
        repeat { col = Int.random(in: 1..<grid[0].count - 1) } while col.isOdd
        return Coordinate(row: row, col: col)
    }
}

extension Int {
    var isOdd: Bool {
        self % 2 == 0
    }
    
    var toOdd: Int {
        self.isOdd ? self + 1 : self
    }
}

extension AsyncStream.Continuation where Element == MazeStep {
    func updateCell(_ coord: Coordinate) {
        self.yield(MazeStep(row: coord.row, col: coord.col, type: .path))
    }
}
