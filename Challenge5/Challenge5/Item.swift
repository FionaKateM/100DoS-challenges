//
//  Item.swift
//  Challenge5
//
//  Created by Fiona Kate Morgan on 07/04/2019.
//  Copyright © 2019 Fiona Kate Morgan. All rights reserved.
//

import UIKit

class Item: NSObject, Codable {
    var caption: String
    var image: String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}
