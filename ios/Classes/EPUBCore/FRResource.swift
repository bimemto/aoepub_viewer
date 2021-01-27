//
//  FRResource.swift
//  aoepub_viewer
//
//  Created by Salem Duy on 27/01/2021.
//

import UIKit

open class FRResource: NSObject {
    var id: String!
    var properties: String?
    var mediaType: MediaType!
    var mediaOverlay: String?
    
    public var href: String!
    public var fullHref: String!

    func basePath() -> String! {
        if href == nil || href.isEmpty { return nil }
        var paths = fullHref.components(separatedBy: "/")
        paths.removeLast()
        return paths.joined(separator: "/")
    }
}

// MARK: Equatable

func ==(lhs: FRResource, rhs: FRResource) -> Bool {
    return lhs.id == rhs.id && lhs.href == rhs.href
}
