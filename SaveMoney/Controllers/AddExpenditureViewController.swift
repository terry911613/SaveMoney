//
//  EditExpenditureViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/23.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu

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
//    var money: String?
    var type: String?
    var typeDetail: String?
    var dateText: String?
    var isSelectType = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let money = Int(moneyTextfield.text!),
            let type = type,
            let typeDetail = typeDetail,
            let dateText = dateText{
            let newExpenditure = Expenditure(money: money, type: type, typeDetail: typeDetail, date: dateText)
            print(money)
            let expenditureVC = segue.destination as? ExpenditureViewController
            expenditureVC?.allExpenditureArray.append(newExpenditure)
            print("現在新支出\(newExpenditure.date)\n\(newExpenditure.money)\(newExpenditure.type)\(newExpenditure.typeDetail)")
            if let allExpenditureArray = expenditureVC?.allExpenditureArray{
                expenditureVC?.currentDateExpenditureArray = [Expenditure]()
                for expenditure in allExpenditureArray{
                    if expenditure.date == dateText{
                        expenditureVC?.currentDateExpenditureArray.append(expenditure)
                        print("\(expenditure.date)\(expenditure.money)\(expenditure.type)\(expenditure.typeDetail)")
                    }
                }
            }
            expenditureVC?.ExpenditureTableView.reloadData()
        }
        else{
            let noMoneyAlert = UIAlertController(title: "請輸入金額", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            noMoneyAlert.addAction(okAction)
            self.present(noMoneyAlert, animated: true, completion: nil)
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
