//
//  Entry.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 03.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import Foundation

struct Entry {
    var date: Date
    var furnace: Furnace
    var scrap: Scrap
    var amount: Int
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy\nHH:mm"
        return dateFormatter.string(from: date)
    }
}
