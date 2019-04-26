//
//  Expenditure.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/23.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import Foundation

class Expenditure {
    var money: Int
    var type: String
    var typeDetail = ""
    var date = ""

    init(money: Int, type: String, typeDetail: String, date: String) {
        self.money = money
        self.type = type
        self.typeDetail = typeDetail
        self.date = date
    }

}
