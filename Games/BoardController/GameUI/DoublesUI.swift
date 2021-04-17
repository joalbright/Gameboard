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
                                    .font(Font(UIFont.systemFont(ofSize: (w + h) / 3.5, weight: .heavy)))
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

    var body: some View {

        ZStack {

            Color("Background").edgesIgnoringSafeArea(.bottom)

            VStack {

                ZStack {

                    DoublesPiecesUI(grid: grid)

                }
                .padding(32)

            }

        }
        .navigationTitle("Doubles")

    }

}

struct DoublesUI_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {

            DoublesLayoutUI(grid: Grid([

                "  2 ".array(),
                "    ".array(),
                "   8".array(),
                [" "," ","16","2048"]

            ], playerPieces: ["◉","◎"]))

        }
        .preferredColorScheme(.dark)

    }

}

extension String {

    var doublesColor: Color {

        switch self {

        case "2": return Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        case "4": return Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        case "8": return Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        case "16": return Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
        case "32": return Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
        case "64": return Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        case "128": return Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
        case "256": return Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
        case "512": return Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
        case "1024": return Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        case "2048": return Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
        case "4096": return Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        default: return Color("Text").opacity(0.2)

        }

    }

}
