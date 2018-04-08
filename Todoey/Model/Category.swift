//
//  Category.swift
//  Todoey
//
//  Created by Arpit Garg on 08/04/18.
//  Copyright © 2018 Arpit Garg. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object{
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
