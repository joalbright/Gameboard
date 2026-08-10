//
//  DoublesUI.swift
//  Games
//
//  Created by Jo Albright on 4/16/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct DoublesPiecesUI: View {

    var grid: Grid

    var body: some View {

        GeometryReader { g in

            let w = (g.size.width - 12) / 4 - 16
            let h = (g.size.height - 12) / 4 - 16

            VStack(spacing: 4) {

                ForEach(grid.cols) { col in

                    HStack(spacing: 4) {

                        ForEach(col.rows) { row in

                            ZStack {

                                Text(row.piece)
                                    .foregroundColor(Color(.sRGB, white: 0.1, opacity: 1))
                                    .frame(minWidth: w, maxWidth: w, minHeight: h, maxHeight: h)
                                    .font(.system(size: (w + h) / 3.5, weight: .heavy))
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .padding(8)

                            }
                            .background(row.piece.doublesColor)
                            .cornerRadius(10)

                        }

                    }

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct DoublesLayoutUI: View {

    var grid: Grid
    var onSwipe: (GameSwipeDirection) -> Void = { _ in }

    var body: some View {

        ZStack {

            Color.background.ignoresSafeArea(edges: .bottom)

            VStack {

                ZStack {

                    DoublesPiecesUI(grid: grid)

                }
                .padding(.horizontal, 32)
                .padding(.vertical, 64)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 20).onEnded { value in

                    let horizontal = abs(value.translation.width) > abs(value.translation.height)

                    if horizontal {

                        onSwipe(value.translation.width < 0 ? .left : .right)

                    } else {

                        onSwipe(value.translation.height < 0 ? .up : .down)

                    }

                })
                .accessibilityAction(named: "Swipe Up") { onSwipe(.up) }
                .accessibilityAction(named: "Swipe Down") { onSwipe(.down) }
                .accessibilityAction(named: "Swipe Left") { onSwipe(.left) }
                .accessibilityAction(named: "Swipe Right") { onSwipe(.right) }

            }

        }
        .navigationTitle("Doubles")

    }

}

#Preview {

    NavigationStack {

        DoublesLayoutUI(grid: Grid([

            "  2 ".array(),
            "    ".array(),
            "   8".array(),
            [" "," ","16","2048"]

        ], playerPieces: ["◉","◎"]))

    }

}

extension String {

    var doublesColor: Color {

        switch self {

        case "2": return Color(red: 0.722, green: 0.886, blue: 0.592)
        case "4": return Color(red: 0.584, green: 0.824, blue: 0.420)
        case "8": return Color(red: 0.467, green: 0.765, blue: 0.267)
        case "16": return Color(red: 0.976, green: 0.851, blue: 0.549)
        case "32": return Color(red: 0.969, green: 0.780, blue: 0.345)
        case "64": return Color(red: 0.961, green: 0.706, blue: 0.200)
        case "128": return Color(red: 0.957, green: 0.659, blue: 0.545)
        case "256": return Color(red: 0.941, green: 0.498, blue: 0.353)
        case "512": return Color(red: 0.937, green: 0.349, blue: 0.192)
        case "1024": return Color(red: 0.910, green: 0.478, blue: 0.643)
        case "2048": return Color(red: 0.855, green: 0.251, blue: 0.478)
        case "4096": return Color(red: 0.808, green: 0.027, blue: 0.333)
        default: return Color.text.opacity(0.2)

        }

    }

}
