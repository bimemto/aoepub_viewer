//
//  FolioReaderSharingProvider.swift
//  aoepub_viewer
//
//  Created by Salem Duy on 27/01/2021.
//

import UIKit

class FolioReaderSharingProvider: UIActivityItemProvider {
    var subject: String
    var text: String
    var html: String?
    var image: UIImage?

    init(subject: String, text: String, html: String? = nil, image: UIImage? = nil) {
        self.subject = subject
        self.text = text
        self.html = html
        self.image = image

        super.init(placeholderItem: "")
    }

    override func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return subject
    }
    
    override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if let html = html , activityType == UIActivity.ActivityType.mail {
            return html
        }

        if let image = image , activityType == UIActivity.ActivityType.postToFacebook {
            return image
        }

        return text
    }
}
