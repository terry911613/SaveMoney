//
//  EditExpenditureViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/23.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu
import ViewAnimator

class AddExpenditureViewController: UIViewController {
    
    @IBOutlet weak var moneyTextfield: UITextField!
    
    var typeDropDownMenu = IGLDropDownMenu()
    var typeDetailDropDownMenu = IGLDropDownMenu()
    var typeArray: NSArray = ["食", "衣", "住", "行", "育", "樂"]
    var typeDetailDic: [String : NSArray] = ["食" : ["早餐", "午餐", "下午茶", "晚餐", "零食", "其他"],
                                             "衣" : ["服飾", "鞋子", "其他"],
                                             "住" : ["房租", "水費", "電費", "其他"],
                                             "行" : ["交通費", "其他"],
                                             "育" : ["教育", "其他"],
                                             "樂" : ["旅遊", "看電影", "其他"]]
    var type: String?
    var typeDetail: String?
    var dateText: String?
    var isSelectType = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let expenditureVC = segue.destination as? ExpenditureViewController
        
        if let money = Int(moneyTextfield.text!),
            let type = type,
            let typeDetail = typeDetail,
            let dateText = dateText{
            //  建立新支出
            let newExpenditure = Expenditure(money: money, type: type, typeDetail: typeDetail, date: dateText)
            
//            let expenditureVC = segue.destination as? ExpenditureViewController
            //  把新支出加入陣列中
            expenditureVC?.allExpenditureArray.append(newExpenditure)
            
            // 把新支出資料日期金額加進字典裡
            if let totalExpenditureDic = expenditureVC?.totalExpenditureDic{
                if totalExpenditureDic.isEmpty{
                    expenditureVC?.totalExpenditureDic[dateText] = [money]
                    print(expenditureVC?.totalExpenditureDic)
                }
                else{
                    for (key, _) in totalExpenditureDic{
                        if key == dateText{
                            expenditureVC?.totalExpenditureDic[dateText]?.append(money)
                            break
                        }
                        else{
                            expenditureVC?.totalExpenditureDic[dateText] = [money]
                            break
                        }
                    }
                }
            }
            // 算今日支出總和
            if let total = expenditureVC?.totalExpenditureDic[dateText]{
                var todayMoney = 0
                for i in total{
                    todayMoney += i
                }
                if let todayMoney = expenditureVC?.formatter.string(from: NSNumber(value: todayMoney)){
                    expenditureVC?.totalExpenditureLabel.text = "\(todayMoney)"
                }
            }
            
            // 找出所有支出裡今天日期的支出資料
            if let allExpenditureArray = expenditureVC?.allExpenditureArray{
                expenditureVC?.currentDateExpenditureArray = [Expenditure]()
                for expenditure in allExpenditureArray{
                    if expenditure.date == dateText{
                        expenditureVC?.currentDateExpenditureArray.append(expenditure)
                    }
                }
            }
            expenditureVC?.expenditureTableView.reloadData()
            expenditureVC?.animateTableView()
        }
        else{
            let noMoneyAlert = UIAlertController(title: "請輸入金額", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            noMoneyAlert.addAction(okAction)
            self.present(noMoneyAlert, animated: true, completion: nil)
        }
        //  把類型細項加近各自的字典裡
        if let type = type{
            print(type)
            print(Type.food.description)
            // 食
            if type == Type.food.description{
//                addDetailInDic(dic: expenditureVC?.foodDic)
                if let money = Int(moneyTextfield.text!),
                    let dateText = dateText{
                    if let dic = expenditureVC?.foodDic{
                        if dic.isEmpty{
                            expenditureVC?.foodDic[dateText] = [money]
                        }
                        else{
                            for (key, _) in dic{
                                if key == dateText{
                                    expenditureVC?.foodDic[dateText]?.append(money)
                                    break
                                }
                                else{
                                    expenditureVC?.foodDic[dateText] = [money]
                                    break
                                }
                            }
                        }
                        print("食 \(expenditureVC?.foodDic)")
                    }
                }
            }
            // 衣
            else if type == Type.clothing.description{
                if let money = Int(moneyTextfield.text!),
                    let dateText = dateText{
                    if let dic = expenditureVC?.clothingDic{
                        if dic.isEmpty{
                            expenditureVC?.clothingDic[dateText] = [money]
                        }
                        else{
                            for (key, _) in dic{
                                if key == dateText{
                                    expenditureVC?.clothingDic[dateText]?.append(money)
                                    break
                                }
                                else{
                                    expenditureVC?.clothingDic[dateText] = [money]
                                    break
                                }
                            }
                        }
                        print(expenditureVC?.clothingDic)
                    }
                }
            }
            //  住
            else if type == Type.housing.description{
                if let money = Int(moneyTextfield.text!),
                    let dateText = dateText{
                    if let dic = expenditureVC?.housingDic{
                        if dic.isEmpty{
                            expenditureVC?.housingDic[dateText] = [money]
                        }
                        else{
                            for (key, _) in dic{
                                if key == dateText{
                                    expenditureVC?.housingDic[dateText]?.append(money)
                                    break
                                }
                                else{
                                    expenditureVC?.housingDic[dateText] = [money]
                                    break
                                }
                            }
                        }
                        print(expenditureVC?.housingDic)
                    }
                }
            }
            //  行
            else if type == Type.transportation.description{
                if let money = Int(moneyTextfield.text!),
                    let dateText = dateText{
                    if let dic = expenditureVC?.transportationDic{
                        if dic.isEmpty{
                            expenditureVC?.foodDic[dateText] = [money]
                        }
                        else{
                            for (key, _) in dic{
                                if key == dateText{
                                    expenditureVC?.transportationDic[dateText]?.append(money)
                                    break
                                }
                                else{
                                    expenditureVC?.transportationDic[dateText] = [money]
                                    break
                                }
                            }
                        }
                        print(expenditureVC?.transportationDic)
                    }
                }
            }
            //  育
            else if type == Type.education.description{
                if let money = Int(moneyTextfield.text!),
                    let dateText = dateText{
                    if let dic = expenditureVC?.educationDic{
                        if dic.isEmpty{
                            expenditureVC?.educationDic[dateText] = [money]
                        }
                        else{
                            for (key, _) in dic{
                                if key == dateText{
                                    expenditureVC?.educationDic[dateText]?.append(money)
                                    break
                                }
                                else{
                                    expenditureVC?.educationDic[dateText] = [money]
                                    break
                                }
                            }
                        }
                        print(expenditureVC?.educationDic)
                    }
                }
            }
            //  樂
            else if type == Type.entertainment.description{
                if let money = Int(moneyTextfield.text!),
                    let dateText = dateText{
                    if let dic = expenditureVC?.entertainmentDic{
                        if dic.isEmpty{
                            expenditureVC?.entertainmentDic[dateText] = [money]
                        }
                        else{
                            for (key, _) in dic{
                                if key == dateText{
                                    expenditureVC?.entertainmentDic[dateText]?.append(money)
                                    break
                                }
                                else{
                                    expenditureVC?.entertainmentDic[dateText] = [money]
                                    break
                                }
                            }
                        }
                        print(expenditureVC?.entertainmentDic)
                    }
                }
            }
        }
    }
    
    //隨便按一個地方，彈出鍵盤就會收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AddExpenditureViewController: IGLDropDownMenuDelegate{
    
    func setupTypeInit(){
        let typeDropDownItems: NSMutableArray = NSMutableArray()
        
        for i in 0...(typeArray.count-1) {
            let typeItem = IGLDropDownItem()
            typeItem.iconImage = UIImage(named: "\(typeArray[i])")
            typeItem.text = "\(typeArray[i])"
            typeItem.showBackgroundShadow = true
            typeDropDownItems.add(typeItem)
        }
        typeDropDownMenu.menuText = "Choose Type"
        typeDropDownMenu.dropDownItems = typeDropDownItems as [AnyObject]
        typeDropDownMenu.paddingLeft = 15
        typeDropDownMenu.frame = CGRect(x: 15, y: 180, width: 180, height: 45)
        typeDropDownMenu.delegate = self
        typeDropDownMenu.type = .stack
        typeDropDownMenu.gutterY = 5
        typeDropDownMenu.itemAnimationDelay = 0.1
        typeDropDownMenu.rotate = .random
        typeDropDownMenu.shouldFlipWhenToggleView = true
        typeDropDownMenu.reloadView()
        
        self.view.addSubview(self.typeDropDownMenu)
    }
    
    func setupTypeDetailInit(){
        let typeDetailDropDownItems:NSMutableArray = NSMutableArray()
        
        if let type = type{
            if let no = typeDetailDic[type]{
                for i in 0...(no.count-1) {
                    let typeDetailItem = IGLDropDownItem()
                    if let typeDetailText = typeDetailDic[type]{
                        typeDetailItem.text = "\(typeDetailText[i])"
                        typeDetailItem.showBackgroundShadow = true
                        typeDetailDropDownItems.add(typeDetailItem)
                    }
                }
            }
        }
        
        typeDetailDropDownMenu.menuText = "Choose TypeDetail"
        typeDetailDropDownMenu.dropDownItems = typeDetailDropDownItems as [AnyObject]
        typeDetailDropDownMenu.paddingLeft = 15
        typeDetailDropDownMenu.frame = CGRect(x: 209, y: 180, width: 180, height: 45)
        typeDetailDropDownMenu.delegate = self
        typeDetailDropDownMenu.type = .stack
        typeDetailDropDownMenu.gutterY = 5
        typeDetailDropDownMenu.itemAnimationDelay = 0.1
        typeDetailDropDownMenu.rotate = .random
        typeDetailDropDownMenu.shouldFlipWhenToggleView = true
        typeDetailDropDownMenu.reloadView()
        
        self.view.addSubview(self.typeDetailDropDownMenu)
    }
    
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        
        if dropDownMenu == typeDropDownMenu{
            let typeItem: IGLDropDownItem = typeDropDownMenu.dropDownItems[index] as! IGLDropDownItem
            if let typeText = typeItem.text{
                type = typeText
                isSelectType = true
                print(typeText)
                if isSelectType {
                    setupTypeDetailInit()
                    isSelectType = false
                }
            }
        }
        else if dropDownMenu == typeDetailDropDownMenu{
            let typeDetailItem: IGLDropDownItem = typeDetailDropDownMenu.dropDownItems[index] as! IGLDropDownItem
            if let typeDetailText = typeDetailItem.text{
                typeDetail = typeDetailText
                print(typeDetailText)
            }
        }
        
    }
    
}
