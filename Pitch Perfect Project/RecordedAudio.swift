//
//  RecordedAudio.swift
//  Pitch Perfect Project
//
//  Created by Jared Wong on 12/16/15.
//  Copyright © 2015 Apparatus Unlimited. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathURL: NSURL!
    var title: String!
    
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
    
    
}