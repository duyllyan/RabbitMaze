//
//  MazeView.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import SwiftUI

struct MazeView: View {
    @ObservedObject private var viewModel = MazeViewModel()
    @State private var touchedCoordinate: Coordinate? = nil
    @State private var lastTouchedCoordinate: Coordinate? = nil
    
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
            .frame(height: 200)
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let totalHeight = geometry.size.height
                
                let rows = viewModel.maze.count
                let cols = viewModel.maze.first?.count ?? 0
                
                let cellSize = min(
                    totalWidth / CGFloat(cols),
                    totalHeight / CGFloat(rows)
                )
                
                ZStack {
                    VStack(spacing: 0) {
                        ForEach(0..<rows, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<cols, id: \.self) { col in
                                    if viewModel.maze.indices.contains(row),
                                       viewModel.maze[row].indices.contains(col) {
                                        
                                        let cell = viewModel.maze[row][col]
                                        let position = Coordinate(row: row, col: col)
                                        
                                        FillCell(
                                            position: position,
                                            playerPosition: viewModel.entry,
                                            carrotPosition: viewModel.exit,
                                            cell: cell
                                        )
                                        .frame(width: cellSize, height: cellSize)
                                    }
                                }
                            }
                        }
                    }
                    .frame(
                        width: CGFloat(cols) * cellSize,
                        height: CGFloat(rows) * cellSize,
                        alignment: .center
                    )
                    .position(x: totalWidth / 2, y: totalHeight / 2)
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let x = value.location.x - (totalWidth - CGFloat(cols) * cellSize) / 2
                                    let y = value.location.y - (totalHeight - CGFloat(rows) * cellSize) / 2
                                    
                                    let row = Int(y / cellSize)
                                    let col = Int(x / cellSize)
                                    
                                    guard row >= 0, row < rows, col >= 0, col < cols else { return }
                                    
                                    let coordinate = Coordinate(row: row, col: col)
                                    
                                    // Impede chamadas duplicadas para a mesma célula
                                    guard coordinate != lastTouchedCoordinate else { return }
                                    
                                    lastTouchedCoordinate = coordinate
                                    
                                    if viewModel.canMove(to: coordinate) {
                                        viewModel.move(to: coordinate)
                                    }
                                }
                                .onEnded { _ in
                                    // Reset ao fim do gesto
                                    lastTouchedCoordinate = nil
                                }
                        )
                }
            }
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
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                
                Text(overlayEmoji)
                    .font(.system(size: geo.size.height * 0.8))
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var backgroundColor: Color {
        if position == playerPosition {
            return .red
        } else if position == carrotPosition {
            return .yellow
        } else {
            return cell == .wall ? .black : .cyan
        }
    }
    
    private var overlayEmoji: String {
        if position == playerPosition {
            return "🐰"
        } else if position == carrotPosition {
            return "🥕"
        } else {
            return ""
        }
    }
}

#Preview {
    MazeView()
}
