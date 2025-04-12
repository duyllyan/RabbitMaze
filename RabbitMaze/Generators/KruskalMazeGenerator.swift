//
//  KruskalMazeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

class KruskalMazeGenerator: MazeGenerator {
    struct Position: Hashable {
        let row: Int
        let column: Int
    }

    struct Edge {
        let from: Position
        let to: Position
        let between: Position
    }

    func generate(maze: Maze) {
        var parent = [Position: Position]()

        func find(_ p: Position) -> Position {
            var root = p
            while parent[root] != root {
                root = parent[root]!
            }
            return root
        }

        func union(_ a: Position, _ b: Position) {
            let rootA = find(a)
            let rootB = find(b)
            if rootA != rootB {
                parent[rootB] = rootA
            }
        }

        var edges = [Edge]()

        for row in stride(from: 1, to: maze.rows - 1, by: 2) {
            for col in stride(from: 1, to: maze.columns - 1, by: 2) {
                let pos = Position(row: row, column: col)
                parent[pos] = pos
                maze.setCell(row: row, column: col, to: .path)

                let directions = [(2, 0), (0, 2)]
                for (dr, dc) in directions {
                    let newRow = row + dr
                    let newCol = col + dc
                    if newRow < maze.rows - 1, newCol < maze.columns - 1 {
                        let to = Position(row: newRow, column: newCol)
                        let between = Position(row: row + dr / 2, column: col + dc / 2)
                        edges.append(Edge(from: pos, to: to, between: between))
                    }
                }
            }
        }

        edges.shuffle()

        for edge in edges {
            if find(edge.from) != find(edge.to) {
                union(edge.from, edge.to)
                maze.setCell(row: edge.between.row, column: edge.between.column, to: .path)
            }
        }

        maze.setCell(row: 0, column: 1, to: .path)
        
        for col in stride(from: 1, to: maze.columns - 1, by: 2) {
            if maze.getCell(row: maze.rows - 2, column: col) == .path {
                maze.setCell(row: maze.rows - 1, column: col, to: .path)
                break
            }
        }
    }
}
