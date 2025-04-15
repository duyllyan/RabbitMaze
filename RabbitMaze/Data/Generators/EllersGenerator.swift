//
//  EllersGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 14/04/25.
//

final class EllersGenerator: AnimatedMazeGenerator {
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
                var setManager = EllerSetManager()
                
                for row in stride(from: 1, to: grid.count - 1, by: 2) {
                    let isLastRow = row == grid.count - 2
                    
                    for col in stride(from: 1, to: grid[0].count - 1, by: 2) {
                        _ = setManager.getSetId(for: col)
                        
                        let currentCoord = Coordinate(row: row, col: col)
                        currentCoord.updateCell(in: &grid, continuation: continuation)
                    }
                    try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                    
                    for col in stride(from: 1, to: grid[0].count - 3, by: 2) {
                        
                        let currentCoord = Coordinate(row: row, col: col)
                        let rightCoord = Coordinate(row: row, col: col + 2)
                        let wallCoord = Coordinate(row: row, col: col + 1)
                        
                        let currentSetId = setManager.getSetId(for: currentCoord.col)
                        let rightSetId = setManager.getSetId(for: rightCoord.col)
                        
                        let shouldJoin = (currentSetId != rightSetId) && (isLastRow || Bool.random())
                        
                        if shouldJoin {
                            wallCoord.updateCell(in: &grid, continuation: continuation)
                            
                            setManager.mergeSets(oldId: rightSetId, newId: currentSetId)
                        }
                    }
                    
                    try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                    
                    if !isLastRow {
                        var colsForNextRow = Set<Int>()
                        
                        for setId in setManager.uniqueSetIds() {
                            let colsInSet = setManager.columnsInSet(setId)
                            let shuffledCols = colsInSet.shuffled()
                            
                            let connectionsToMake = Int.random(in: 1...colsInSet.count)
                            
                            for i in 0..<connectionsToMake {
                                let colToConnect = shuffledCols[i]
                                let belowCoord = Coordinate(row: row + 1, col: colToConnect)
                                
                                belowCoord.updateCell(in: &grid, continuation: continuation)
                                
                                colsForNextRow.insert(colToConnect)
                            }
                        }
                        
                        setManager.prepareForNextRow(colsToKeep: colsForNextRow)
                        try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                        
                    }
                }
                
                continuation.finish()
            }
        }
    }
    
    private struct EllerSetManager {
        private var  sets: [Int: Int]
        private var nextSetId: Int
        
        init() {
            self.sets = [:]
            self.nextSetId = 1
        }
        
        mutating func getSetId(for col: Int) -> Int {
            if let setId = sets[col] {
                return setId
            } else {
                let newId = nextSetId
                sets[col] = newId
                nextSetId += 1
                return newId
            }
        }
        
        mutating func mergeSets(oldId: Int, newId: Int) {
            for (col, currentId) in sets {
                if currentId == oldId {
                    sets[col] = newId
                }
            }
        }
        
        func columnsInSet(_ setId: Int) -> [Int] {
            return sets.filter { $1 == setId }.map { $0.key }.sorted()
        }
        
        func uniqueSetIds() -> Set<Int> {
            return Set(sets.values)
        }
        
        mutating func prepareForNextRow(colsToKeep: Set<Int>) {
            sets = sets.filter { colsToKeep.contains($0.key) }
        }
    }
}
