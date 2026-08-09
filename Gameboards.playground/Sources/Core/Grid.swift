import Foundation

public struct Grid {

    struct CellID: Hashable {

        var row: Int
        var column: Int

    }

    struct Row: Identifiable {

        var id: CellID
        var index: Int
        var piece: Piece

    }

    struct Col: Identifiable {

        var id: Int
        var rows: [Row]
        
    }

    var cols: [Col] {

        return content.enumerated().map { row, content in

            Col(id: row, rows: content.enumerated().map { column, piece in Row(id: CellID(row: row, column: column), index: column, piece: piece) })

        }

    }
    
    public var content: [[Piece]]
    
    public var rowRange: CountableRange<Int> { return 0..<content.count }
    public var colRange: CountableRange<Int> { return content.count > 0 ? 0..<content[0].count : 0..<0 }
    
    public var playerPieces: [Piece] = []
    
    public init(_ content: [[Piece]], playerPieces: [Piece] = []) {
        
        self.content = content
        self.playerPieces = playerPieces
        
    }
    
    public subscript(c: Int, r: Int) -> Piece {
        
        get { return content[c][r] }
        set { content[c][r] = newValue }
        
    }
    
    public subscript(c: Int) -> [Piece] {
        
        get { return content[c] }
        set { content[c] = newValue }
        
    }

    public func onBoard(_ s1: Square, _ s2: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange) && s2.0.within(rowRange) && s2.1.within(colRange)
        
    }
    
    public func onBoard(_ s1: Square) -> Bool {
        
        return s1.0.within(rowRange) && s1.1.within(colRange)
        
    }
    
    func player(_ piece: Piece) -> Int {
        
        for (p,player) in playerPieces.enumerated() {
            
            if player.contains(piece) { return p }
            
        }
        
        return -1
        
    }

    func solid(_ piece: Piece) -> Piece {

        guard playerPieces.count > 1 else { return piece }
        guard let index = playerPieces[1].array().firstIndex(of: piece) else { return piece }
        return playerPieces[0].array()[index]

    }
    
}
