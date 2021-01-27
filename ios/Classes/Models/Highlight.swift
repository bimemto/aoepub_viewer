//
//  Highlight.swift
//  aoepub_viewer
//
//  Created by Salem Duy on 27/01/2021.
//

import Foundation
import RealmSwift

/// A Highlight object
open class Highlight: Object {
    @objc open dynamic var bookId: String!
    @objc open dynamic var content: String!
    @objc open dynamic var contentPost: String!
    @objc open dynamic var contentPre: String!
    @objc open dynamic var date: Date!
    @objc open dynamic var highlightId: String!
    @objc open dynamic var page: Int = 0
    @objc open dynamic var type: Int = 0
    @objc open dynamic var startOffset: Int = -1
    @objc open dynamic var endOffset: Int = -1
    @objc open dynamic var noteForHighlight: String?

    override open class func primaryKey()-> String {
        return "highlightId"
    }
}

extension Results {
    func toArray<T>(_ ofType: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
