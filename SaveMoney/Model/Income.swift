//
//  Income.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/26.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import Foundation

class Income {
    var money: Int
    var type: String
    var date = ""
    
    init(money: Int, type: String, date: String) {
        self.money = money
        self.type = type
        self.date = date
    }
    
}
