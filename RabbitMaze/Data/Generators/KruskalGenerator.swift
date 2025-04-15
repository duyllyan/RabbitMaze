//
//  KruskalGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 14/04/25.
//

final class KruskalGenerator: AnimatedMazeGenerator {
    var height: Int
    var width: Int
    var grid: [[CellType]] = []
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = GridUtility.initMazeWithOddIntersections(width: width, height: height)
    }
    
    func generateSteps() -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                var dsu = UnionFind()
                
                var walls: [Coordinate] = []
                
                for row in stride(from: 1, to: grid.count, by: 2) {
                    for col in stride(from: 1, to: grid[0].count, by: 2) {
                        let currentCell = Coordinate(row: row, col: col)
                        dsu.addSet(for: currentCell)
                        
                        if col + 2 < grid[0].count {
                            let wallEast = Coordinate(row: row, col: col + 1)
                            walls.append(wallEast)
                        }
                        
                        if row + 2 < grid.count {
                            let wallSouth = Coordinate(row: row + 1, col: col)
                            walls.append(wallSouth)
                        }
                    }
                }
                
                walls.shuffle()
                
                for wallCoord in walls {
                    var cell1: Coordinate
                    var cell2: Coordinate
                    
                    if wallCoord.row.isEven {
                        cell1 = Coordinate(row: wallCoord.row - 1, col: wallCoord.col)
                        cell2 = Coordinate(row: wallCoord.row + 1, col: wallCoord.col)
                    } else {
                        cell1 = Coordinate(row: wallCoord.row, col: wallCoord.col - 1)
                        cell2 = Coordinate(row: wallCoord.row, col: wallCoord.col + 1)
                    }
                    
                    let root1 = dsu.find(cell1)
                    let root2 = dsu.find(cell2)
                    
                    if root1 != root2 {
                        dsu.union(cell1, cell2)
                        wallCoord.updateCell(in: &grid, continuation: continuation)
                        try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                    }
                }
                
                continuation.finish()
            }
        }
    }
    
    private struct UnionFind {
        private var parent: [Coordinate: Coordinate] = [:]
        private var rank: [Coordinate: Int] = [:]
        
        init() {}
        
        mutating func addSet(for element: Coordinate) {
            guard parent[element] == nil else { return }
            parent[element] = element
            rank[element] = 0
        }
        
        mutating func find(_ element: Coordinate) -> Coordinate {
            guard let currentParent = parent[element] else {
                addSet(for: element)
                return element
            }
            
            if currentParent != element {
                let root = find(currentParent)
                parent[element] = root
                return root
            } else {
                return element
            }
        }
        
        mutating func union(_ element1: Coordinate,_ element2: Coordinate) {
            let root1 = find(element1)
            let root2 = find(element2)
            
            guard root1 != root2 else { return }
            
            if rank[root1]! < rank[root2]! {
                parent[root1] = root2
            } else if rank[root1]! > rank[root2]! {
                parent[root2] = root1
            } else {
                parent[root2] = root1
                rank[root1]? += 1
            }
        }
    }
}
