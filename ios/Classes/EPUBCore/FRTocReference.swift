//
//  FRTocReference.swift
//  aoepub_viewer
//
//  Created by Salem Duy on 27/01/2021.
//

import UIKit

open class FRTocReference: NSObject {
    var children: [FRTocReference]!

    public var title: String!
    public var resource: FRResource?
    public var fragmentID: String?
    
    convenience init(title: String, resource: FRResource?, fragmentID: String = "") {
        self.init(title: title, resource: resource, fragmentID: fragmentID, children: [FRTocReference]())
    }

    init(title: String, resource: FRResource?, fragmentID: String, children: [FRTocReference]) {
        self.resource = resource
        self.title = title
        self.fragmentID = fragmentID
        self.children = children
    }
}

// MARK: Equatable

func ==(lhs: FRTocReference, rhs: FRTocReference) -> Bool {
    return lhs.title == rhs.title && lhs.fragmentID == rhs.fragmentID
}
