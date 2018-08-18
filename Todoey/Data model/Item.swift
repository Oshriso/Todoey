//
//  Item.swift
//  Todoey
//
//  Created by Dev2 on 8/16/18.
//  Copyright © 2018 Dev2. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
