//
//  BackgammonUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct BackgammonBoardUI: View {

    var body: some View {
        
        VStack(spacing: 0) {
            
            GeometryReader { g in
                
                let e: CGFloat = g.size.width / 20
                let h: CGFloat = g.size.width
                
                let hG: CGFloat = h / 4
                
                let pW = (g.rect.width - e * 3) / 12
                let pH = (h - e * 2 - hG) / 12
                
                let sH = (g.rect.height - g.rect.width) / 2
                    
                UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10, style: .circular)
                    .fill(Color(red: 0.716, green: 0.642, blue: 0.523))
                    .frame(height: sH)
                    .padding(.horizontal, 16)
                
                Color(red: 0.404, green: 0.333, blue: 0.191)
                    .cornerRadius(10)
                    .frame(width: g.size.width, height: h)
                    .offset(y: sH)
                
                Path { path in
                    
                    path.addRect(g.rect.insetBy(dx: e, dy: e + sH))
                    
                }.fill(Color(red: 0.716, green: 0.642, blue: 0.523))
                
                Path { path in
                    
                    path.addRect(CGRect(x: g.rect.midX - e / 2, y: sH, width: e, height: h))
                    
                }.fill(Color(red: 0.404, green: 0.333, blue: 0.191))
                
                ForEach(Index.count(12)) { index in
                    
                    let i = CGFloat(index.id)
                    let x: CGFloat = index.id > 5 ? e * 2 : e
                    let eo = index.id % 2 == 0
                    
                    Path { path in
                        
                        path.move(to: CGPoint(x: pW * i + x, y: e + sH))
                        path.addLine(to: CGPoint(x: pW * i + x + pW, y: e + sH))
                        path.addLine(to: CGPoint(x: pW * i + x + pW / 2, y: pH * 7 + e + sH))
                        path.closeSubpath()
                        
                    }.fill(eo ? Color(red: 0.716, green: 0.642, blue: 0.523) : Color(red: 0.404, green: 0.333, blue: 0.191)).blendMode(.multiply).opacity(0.5)
                    
                    Path { path in
                        
                        path.move(to: CGPoint(x: pW * i + x, y: h - e + sH))
                        path.addLine(to: CGPoint(x: pW * i + x + pW, y: h - e + sH))
                        path.addLine(to: CGPoint(x: pW * i + x + pW / 2, y: pH * 5 + hG + e + sH))
                        path.closeSubpath()
                        
                    }.fill(eo ? Color(red: 0.404, green: 0.333, blue: 0.191) : Color(red: 0.716, green: 0.642, blue: 0.523)).blendMode(.multiply).opacity(0.5)
                    
                }
                
                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 0, style: .circular)
                    .offset(y: g.rect.height - sH)
                    .fill(Color(red: 0.716, green: 0.642, blue: 0.523))
                    .frame(height: sH)
                    .padding(.horizontal, 16)
                
            }
            .aspectRatio(10/13, contentMode: .fit)
            
        }

    }

}

struct BackgammonPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in
            
            let e: CGFloat = g.size.width / 20
            let h: CGFloat = g.size.width
            
            let hG: CGFloat = h / 4
            
            let pW = (g.rect.width - e * 3) / 12
            let pH = (h - e * 2 - hG) / 12
            
            let sH = (g.rect.height - g.rect.width) / 2

            VStack(spacing: 0) {

                ForEach(grid.cols) { col in

                    if col.id == 6 { Text("").frame(width: pW, height: hG) }

                    HStack(spacing: 0) {

                        ForEach(col.rows) { row in

                            if row.index == 6 { Text("").frame(width: e, height: pH) }

                            let player = grid.player(row.piece) == 0

                            Text(grid.solid(row.piece)).foregroundColor(player ? Color(white: 0.198) : .white)
                                .frame(width: pW, height: pH)
                                .font(.system(size: (pW + pH) / 2, weight: .regular))

                        }

                    }

                }

            }
            .padding(.horizontal, e)
            .padding(.vertical, e + sH)
            
        }
        .aspectRatio(10/13, contentMode: .fit)

    }

}

struct BackgammonInteractionUI: View {

    var selectedPoint: Int?
    var highlightedPoints: [Int]
    var pointCounts: [Int]
    var onSelect: (Int) -> Void

    var body: some View {

        GeometryReader { g in

            let padding: CGFloat = g.size.width / 20
            let horizontalGap: CGFloat = g.size.width / 4
            let width = (g.rect.width - padding * 3) / 12
            let pointHeight = (g.rect.width - padding * 2 - horizontalGap) / 2
            let shelf = (g.rect.height - g.rect.width) / 2

            ForEach(0..<12, id: \.self) { column in

                let xOffset: CGFloat = column > 5 ? padding * 2 : padding
                let topPoint = column + 13
                let bottomPoint = 12 - column

                pointButton(topPoint, count: pointCounts[topPoint - 1], pointsDown: true)
                    .frame(width: width, height: pointHeight)
                    .position(x: width * CGFloat(column) + xOffset + width / 2, y: padding + shelf + pointHeight / 2)

                pointButton(bottomPoint, count: pointCounts[bottomPoint - 1], pointsDown: false)
                    .frame(width: width, height: pointHeight)
                    .position(x: width * CGFloat(column) + xOffset + width / 2, y: g.rect.height - padding - shelf - pointHeight / 2)

            }

        }
        .aspectRatio(10/13, contentMode: .fit)

    }

    private func pointButton(_ point: Int, count: Int, pointsDown: Bool) -> some View {

        let isSelected = selectedPoint == point
        let isHighlighted = highlightedPoints.contains(point)

        return Button {

            onSelect(point)

        } label: {

            ZStack {

                Rectangle()
                    .fill(isHighlighted ? Color.accent.opacity(0.25) : .clear)
                    .contentShape(Rectangle())

                if isSelected {

                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.accent, lineWidth: 4)
                        .padding(2)

                }

            }

        }
        .buttonStyle(.plain)
        .accessibilityLabel("Point \(point), \(count) checkers")
        .accessibilityHint(isHighlighted ? "Legal destination" : "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])

    }

}

struct BackgammonLayoutUI: View {

    var grid: Grid
    var selectedPoint: Int? = nil
    var highlightedPoints: [Int] = []
    var dice: [Int] = []
    var bar: [Int] = [0,0]
    var borneOff: [Int] = [0,0]
    var pointCounts: [Int] = Backgammon.initialPoints.map { abs($0) }
    var canRoll = true
    var canBearOff = false
    var onRoll: () -> Void = {}
    var onSelect: (Int) -> Void = { _ in }
    var onBearOff: () -> Void = {}

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack(spacing: 12) {
                
                ZStack(alignment: .center) {
                    
                    BackgammonBoardUI()
                    
                    BackgammonPiecesUI(grid: grid)
                    
                    VStack(spacing: 0) {
                        
                        Spacer(minLength: 0)
                        
                        HStack(spacing: 12) {
                            
                            Button("Roll", systemImage: "die.face.5.fill", action: onRoll)
                                .tint(Color(red: 0.404, green: 0.333, blue: 0.191))
                                .buttonStyle(.borderedProminent)
                                .disabled(!canRoll)
                            
                            ForEach(Array(dice.enumerated()), id: \.offset) { _, die in
                                
                                Image(systemName: "die.face.\(die).fill")
                                    .font(.title2)
                                    .foregroundStyle(Color.white)
                                    .accessibilityLabel("Die showing \(die)")
                                
                            }
                            
                            Spacer(minLength: 0)
                            
                        }
                        .padding(.horizontal, 32)
                        
                        Spacer(minLength: 0)
                        
                        Rectangle()
                            .fill(Color.clear)
                            .aspectRatio(1, contentMode: .fit)
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            
                            Text("● Bar \(bar[0]) · Off \(borneOff[0])")
                                .font(.callout)
                                .foregroundStyle(Color(white: 0.198))
                            
                            Spacer(minLength: 0)
                            
                            Text("● Bar \(bar[1]) · Off \(borneOff[1])")
                                .font(.callout)
                                .foregroundStyle(Color.white)
                            
                        }
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 32)
                        
                        Spacer(minLength: 0)
                        
                    }
                    .aspectRatio(10/13, contentMode: .fit)
                    
                    BackgammonInteractionUI(selectedPoint: selectedPoint, highlightedPoints: highlightedPoints, pointCounts: pointCounts, onSelect: onSelect)
                    
                }
                .padding(32)
                
                Button("Bear Off", action: onBearOff)
                    .buttonStyle(.bordered)
                    .disabled(!canBearOff)
                
            }
            
        }
        .navigationTitle("Backgammon")

    }

}

#Preview {

    NavigationStack {

        BackgammonLayoutUI(grid: Grid(Backgammon.board.content, playerPieces: ["●","○"]))

    }

}
