//
//  AnimatedMazeGeneratorFactory.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 15/04/25.
//

struct AnimatedMazeGeneratorFactory {
    static func make(_ type: AnimatedMazeGeneratorType, width: Int, height: Int) -> AnimatedMazeGenerator {
        switch type {
        case .aldousBorderGenerator:
            AldousBorderGenerator(width: width, height: height)
        case .backtrackingMazeGenerator:
            BacktrackingMazeGenerator(width: width, height: height)
        case .binaryTreeGenerator:
            BinaryTreeGenerator(width: width, height: height)
        case .ellersGenerator:
            EllersGenerator(width: width, height: height)
        case .huntAndKillGenerator:
            HuntAndKillGenerator(width: width, height: height)
        case .kruskalsGenerator:
            KruskalGenerator(width: width, height: height)
        case .randomizePrimGenerator:
            RandomizePrimsGenerator(width: width, height: height)
        case .recursiveDivisionGenerator:
            RecursiveDivisionGenerator(width: width, height: height)
        case .sidewinderGenerator:
            SidewinderGenerator(width: width, height: height)
        case .wilsonsGenerator:
            WilsonGenerator(width: width, height: height)
        }
    }
}
enum AnimatedMazeGeneratorType: String, CaseIterable {
    case aldousBorderGenerator = "Aldous-Broder Algorithm"
    case backtrackingMazeGenerator = "Backtracking Algorithm"
    case binaryTreeGenerator = "Binary Tree Algorithm"
    case ellersGenerator = "Eller`s Algorithm"
    case huntAndKillGenerator = "Hunt-and-Kill Algorithm"
    case kruskalsGenerator = "Kruskal's Algorithm"
    case randomizePrimGenerator = "Randomized Prim`s Algorithm"
    case recursiveDivisionGenerator = "Recursive Division Algorithm"
    case sidewinderGenerator = "Sidewinder Algorithm"
    case wilsonsGenerator = "Wilson’s Algorithm"
}
