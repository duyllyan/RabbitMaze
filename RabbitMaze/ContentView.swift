//
//  ContentView.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MazeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<viewModel.grid.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.grid.count, id: \.self) { column in
                        Text(viewModel.grid[row][column] == .path ? "🟨" : "🟩")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

