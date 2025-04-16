//
//  MazeView.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import SwiftUI

struct MazeView: View {
    @ObservedObject private var viewModel = MazeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section {
                    Stepper("\(viewModel.width) Width", value: $viewModel.width, in: 7...55, step: 2)
                    Stepper("\(viewModel.height) Height", value: $viewModel.height, in: 7...77, step: 2)
                }
                Section {
                    Picker("Choose Algorithm", selection: $viewModel.generatorType) {
                        ForEach(AnimatedMazeGeneratorType.allCases, id: \.self) {
                            Text("\($0.rawValue)")
                        }
                    }
                    .onChange(of: viewModel.generatorType) { type in
                        viewModel.restart(generatorType: type)
                    }
                    .labelsHidden()
                }
            }
            .frame(width: .infinity, height: 200)
            GeometryReader { geometry in
                let availableWidth = geometry.size.width
                let availableHeight = geometry.size.height
                
                let mazeGridWidth = CGFloat(viewModel.width > 0 ? viewModel.width : 1)
                let mazeGridHeight = CGFloat(viewModel.height > 0 ? viewModel.height : 1)
                
                let maxCellWidth = availableWidth / mazeGridWidth
                let maxCellHeight = availableHeight / mazeGridHeight
                
                let cellSize = min(maxCellWidth, maxCellHeight)
                
                if cellSize > 0 {
                    VStack(spacing: 0) {
                        ForEach(0..<viewModel.maze.count, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<viewModel.maze[row].count, id: \.self) { col in
                                    if viewModel.maze.indices.contains(row) && viewModel.maze[row].indices.contains(col) {
                                        let cell = viewModel.maze[row][col]
                                        let position = Coordinate(row: row, col: col)
                                        
                                        FillCell(position: position, playerPosition: viewModel.entry, carrotPosition: viewModel.exit, cell: cell)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.2)
                                            .frame(width: cellSize, height: cellSize, alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
            Spacer()
            JoystickView(
                moveUp: {
                    viewModel.move(direction: .up)
                },
                moveDown: {
                    viewModel.move(direction: .down)
                },
                moveLeft: {
                    viewModel.move(direction: .left)
                },
                moveRight: {
                    viewModel.move(direction: .right)
                },
                disabled: viewModel.isGenerating
            )
            Spacer()
        }
        .onAppear {
            viewModel.start()
        }
        .alert("Congrats! You won!", isPresented: $viewModel.wonGame) {
            Button("OK") {
                viewModel.restart(generatorType: viewModel.generatorType)
            }
        }
        .background(.black)
    }
}

struct FillCell: View {
    let position: Coordinate
    let playerPosition: Coordinate
    let carrotPosition: Coordinate
    let cell: CellType
    var body: some View {
        if position == playerPosition {
            return ZStack {
                Rectangle().fill(.red)
                Text("🐰")
            }
        } else if position == carrotPosition {
            return ZStack {
                Rectangle().fill(.yellow)
                Text("🥕")
            }
        } else {
            return ZStack {
                Rectangle().fill(cell == .wall ? .black : .cyan)
                Text("")
            }
        }
    }
}

#Preview {
    MazeView()
}


