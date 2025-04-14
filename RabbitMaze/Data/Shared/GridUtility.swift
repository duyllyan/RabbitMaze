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
        repeat { row = Int.random(in: 1..<height - 1) } while row.isEven
        repeat { column = Int.random(in: 1..<width - 1) } while column.isEven
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
        repeat { row = Int.random(in: 1..<grid.count - 1) } while row.isEven
        repeat { col = Int.random(in: 1..<grid[0].count - 1) } while col.isEven
        return Coordinate(row: row, col: col)
    }
    
    static func initMazeWithOddIntersections(width: Int, height: Int) -> [[CellType]] {
        var maze = Self.initMaze(width: width, height: height)
        for row in stride(from: 1, to: maze.count, by: 2) {
            for col in stride(from: 1, to: maze[0].count, by: 2) {
                maze[row][col] = .path
            }
        }
        return maze
    }
}

extension Int {
    var isEven: Bool {
        self % 2 == 0
    }
    
    var toOdd: Int {
        self.isEven ? self + 1 : self
    }
}

extension AsyncStream.Continuation where Element == MazeStep {
    func updateCell(_ coord: Coordinate) {
        self.yield(MazeStep(row: coord.row, col: coord.col, type: .path))
    }
}
