//
//  Type.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/30.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import Foundation

enum Type{
    case food, clothing, housing, transportation, education, entertainment
    
    var description: String{
        var text = ""
        switch self {
        case .food:
            text = "食"
        case .clothing:
            text = "衣"
        case .housing:
            text = "住"
        case .transportation:
            text = "行"
        case .education:
            text = "育"
        case .entertainment:
            text = "樂"
        }
        return text
    }
}
