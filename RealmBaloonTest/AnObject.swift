//
//  AnObject.swift
//  RealmBaloonTest
//
//  Created by Jon Vogel on 1/5/17.
//  Copyright © 2017 Jon Vogel. All rights reserved.
//

import Foundation
import RealmSwift


class AnObject: Object {
    
    dynamic var someString: String = "One time I wished that Realm would hire me and take me away from this entry level iOS Dev Job that does not pay enough. I used to be a pilot, then I switched careers."
    
    dynamic var someBool: Bool = false
    
    dynamic var someInt: Int = 7
    
    dynamic var aNew: String = "Something going on"
    
}
