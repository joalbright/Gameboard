//
//  HelperUI.swift
//  Games
//
//  Created by Jo Albright on 4/15/21.
//  Copyright © 2021 Jo Albright. All rights reserved.
//

import SwiftUI

struct Index: Identifiable {

    static func count(_ to: Int) -> [Index] { return (0..<to).map { Index(id:$0) } }
    static func range(_ range: CountableClosedRange<Int>) -> [Index] { return range.map { Index(id:$0) } }

    var id: Int

}

struct Value<T: Any>: Identifiable {

    static func array(_ array: [T]) -> [Value<T>] { return array.enumerated().map { Value<T>(id:$0.offset, value: $0.element) } }

    var id: Int
    var value: T

}

struct DifficultyMenu: View {

    var difficulty: Difficulty
    var onSelect: (Difficulty) -> Void

    var body: some View {

        Menu {

            ForEach(Difficulty.allCases) { option in

                Button {

                    onSelect(option)

                } label: {

                    if option == difficulty {

                        Label(option.name, systemImage: "checkmark")

                    } else {

                        Text(option.name)

                    }

                }

            }

        } label: {

            ZStack(alignment: .center) {

                ForEach(Difficulty.allCases) { option in

                    Text(option.name)
                        .hidden()
                        .accessibilityHidden(true)

                }

                Text(difficulty.name)

            }

        }
        .foregroundStyle(Color.text)
        .buttonStyle(.bordered)
        .accessibilityLabel("Difficulty")
        .accessibilityValue(difficulty.name)

    }

}

extension GeometryProxy {

    var rect: CGRect { return CGRect(origin: .zero, size: size) }

}
