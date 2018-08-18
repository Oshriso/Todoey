//
//  Category.swift
//  Todoey
//
//  Created by Dev2 on 8/16/18.
//  Copyright © 2018 Dev2. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
