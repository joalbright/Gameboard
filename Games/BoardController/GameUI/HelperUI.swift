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

    var id: Int

}

extension GeometryProxy {

    var rect: CGRect { return CGRect(origin: .zero, size: size) }

}
