//
//  PegsUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct PegsBoardUI: View {

    var body: some View {

        let p: CGFloat = 20

        GeometryReader { g in

            let w = (g.size.width - p * 5) / 7
            let h = (g.size.height - p * 5) / 7

            Path { path in

                path.move(to: CGPoint(x: g.size.width / 2, y: p / 2))
                path.addLine(to: CGPoint(x: g.size.width - p / 2, y: g.size.height / 2))
                path.addLine(to: CGPoint(x: g.size.width / 2, y: g.size.height - p / 2))
                path.addLine(to: CGPoint(x: p / 2, y: g.size.height / 2))

            }.fill(Color("Accent"))

            Path { path in

                path.move(to: CGPoint(x: g.size.width / 2, y: p / 2))
                path.addLine(to: CGPoint(x: g.size.width - p / 2, y: g.size.height / 2))
                path.addLine(to: CGPoint(x: g.size.width / 2, y: g.size.height - p / 2))
                path.addLine(to: CGPoint(x: p / 2, y: g.size.height / 2))
                path.closeSubpath()

            }.stroke(Color("Accent"), style: StrokeStyle(lineWidth: p, lineCap: .round, lineJoin: .round))

            let holes: [(Int,Int)] = [

                            (0,2),(0,3),(0,4),
                            (1,2),(1,3),(1,4),
                (2,0),(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),
                (3,0),(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),
                (4,0),(4,1),(4,2),(4,3),(4,4),(4,5),(4,6),
                            (5,2),(5,3),(5,4),
                            (6,2),(6,3),(6,4)

            ]

            ForEach(Value<(Int,Int)>.array(holes)) { hole in

                let r = CGFloat(hole.value.0)
                let c = CGFloat(hole.value.1)

                Path { path in

                    path.move(to: CGPoint(x: w * c + w / 2 + 2.5 * p, y: h * r + h / 2 + 2.5 * p))
                    path.addLine(to: CGPoint(x: w * c + w / 2 + 2.5 * p, y: h * r + h / 2 + 2.5 * p))

                }.stroke(Color("Text"), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))

            }

        }
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct PegsPiecesUI: View {

    var grid: Grid

    var body: some View {

        let p: CGFloat = 20

        GeometryReader { g in

            let w = (g.size.width - p * 5) / 7
            let h = (g.size.height - p * 5) / 7

            ForEach(grid.cols) { col in

                let c = CGFloat(col.id)

                ForEach(col.rows) { row in

                    let r = CGFloat(row.id)

                    if grid.player(row.piece) == 0 {

                        Path { path in

                            path.move(to: CGPoint(x: w * c + w / 2 + 2.5 * p, y: h * r + h / 2 + 2.5 * p))
                            path.addLine(to: CGPoint(x: w * c + w / 2 + 2.5 * p, y: h * r + h / 2 + 2.5 * p))

                        }.stroke(Color("Text"), style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))

                    }

                }

            }

        }
        .cornerRadius(10)
        .aspectRatio(1.0, contentMode: .fit)

    }

}

struct PegsLayoutUI: View {

    var grid: Grid

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    PegsBoardUI()

                    PegsPiecesUI(grid: grid)

                }
                .padding(32)

            }

        }
        .navigationTitle("Pegs")

    }

}

struct PegsUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

            PegsLayoutUI(grid: Grid([

                "!!●●●!!".array(),
                "!!●●●!!".array(),
                "●●●●●●●".array(),
                "●●● ●●●".array(),
                "●●●●●●●".array(),
                "!!●●●!!".array(),
                "!!●●●!!".array()

            ], playerPieces: ["●"]))

        }
        .preferredColorScheme(.dark)

    }

}
