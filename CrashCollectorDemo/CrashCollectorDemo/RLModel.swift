//
//  RLModel.swift
//  BuglyDemo
//
//  Created by Zack.Zhang on 9/17/19.
//  Copyright © 2019 Zack.Zhang. All rights reserved.
//

import UIKit
import RealmSwift

//先run一个版本，再关掉注释run一个版本，触发调用，会crash
class RLModel: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
//    @objc dynamic var level = 0
}
