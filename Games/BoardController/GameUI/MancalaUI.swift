//
//  MancalaUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct MancalaBoardUI: View {
    
    let rows = [
        
        "12221",
        "13 31",
        "1   1",
        "1   1",
        "13 31",
        "12221"
        
    ]

    var body: some View {
        
        let p: CGFloat = 25

        GeometryReader { g in
            
            let w = (g.rect.width - p * 2) / 5
            let h = (g.rect.height - p * 2) / 6
            
            let radius: CGFloat = w / 4

            Color(red: 0.630, green: 0.550, blue: 0.384)
            
            ForEach(Index.count(6)) { row in
                
                let r = CGFloat(row.id)
                
                if [0,5].contains(row.id) {
                    
                    Path { path in
                        
                        path.addRoundedRect(in: CGRect(x: w + p, y: h * r + p, width: w * 3, height: h).insetBy(dx: 2, dy: 2), cornerSize: CGSize(width: radius, height: radius))
                        
                    }.fill(Color(red: 0.350, green: 0.310, blue: 0.230))
                    
                }
                
                ForEach(Index.count(5)) { col in
                    
                    let c = CGFloat(col.id)
                    
                    let spot = rows[row.id].array()[col.id]
                    
                    if spot == "1" {
                        
                        Path { path in
                            
                            path.addRoundedRect(in: CGRect(x: w * c + p, y: h * r + p, width: w, height: h).insetBy(dx: 2, dy: 2), cornerSize: CGSize(width: radius, height: radius))
                            
                        }.fill(Color(red: 0.350, green: 0.310, blue: 0.230))
                        
                    } else if spot == "3" {
                        
                        Path { path in
                            
                            path.addRoundedRect(in: CGRect(x: w * c + p, y: h * r + p, width: w, height: h).insetBy(dx: w / 3, dy: w / 3), cornerSize: CGSize(width: radius, height: radius))
                            
                        }.fill(Color(red: 0.580, green: 0.500, blue: 0.330))
                        
                    }
                    
                }
                
            }
            
        }
        .cornerRadius(30)
        .aspectRatio(5/6, contentMode: .fit)

    }

}

struct MancalaPiecesUI: View {

    var grid: Grid
    var onSelect: (Square) -> Void
    
    let p: CGFloat = 25

    var body: some View {

        GeometryReader { g in
            
            let w = (g.rect.width - p * 2) / 5
            let h = (g.rect.height - p * 2) / 6
            
            VStack(spacing: 0) {
                
                ForEach(grid.cols) { col in
                    
                    HStack(spacing: w) {
                        
                        ForEach(col.rows) { row in

                            Button {

                                onSelect((col.id, row.index))

                            } label: {

                                Text(row.piece)
                                    .foregroundColor(Color(red: 0.980, green: 0.900, blue: 0.734))
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(.system(size: h / 2))

                            }
                            .buttonStyle(.plain)
                            .disabled(row.index == 1)
                            .accessibilityLabel(row.index == 1 ? "Store with \(row.piece) stones" : "Pit with \(row.piece) stones")
                            
                        }
                        
                    }
                    
                }
                
            }
            .padding(25)

        }
        .aspectRatio(5/6, contentMode: .fit)

    }

}

struct MancalaLayoutUI: View {

    var grid: Grid
    var onSelect: (Square) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    MancalaBoardUI()

                    MancalaPiecesUI(grid: grid, onSelect: onSelect)

                }
                .padding(32)

            }


        }
        .navigationTitle("Mancala")

    }

}

#Preview {

    NavigationStack {

        MancalaLayoutUI(grid: Grid([
            
            ["0","3","4"],
            ["4"," ","4"],
            ["0"," ","3"],
            ["3"," ","0"],
            ["4"," ","1"],
            ["5","4","1"]
        
        ], playerPieces: ["◉","◎"]))

    }

}
