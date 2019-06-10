//
//  EditIncomeViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/23.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu

class AddIncomeViewController: UIViewController {

    @IBOutlet weak var moneyTextfield: UITextField!
    
    var typeDropDownMenu = IGLDropDownMenu()
    var typeArray: NSArray = ["薪水", "獎金", "補助", "投資", "其他"]
    var type: String?
    var dateText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let money = Int(moneyTextfield.text!),
            let type = type,
            let dateText = dateText{
            let newIncome = Income(money: money, type: type, date: dateText)
            
            let incomeVC = segue.destination as? IncomeViewController
            incomeVC?.allIncomeArray.append(newIncome)
            
            // 把新收入資料日期金額加進字典裡
            if let totalExpenditureDic = incomeVC?.totalIncomeDic{
                if totalExpenditureDic.isEmpty{
                    incomeVC?.totalIncomeDic[dateText] = [money]
                }
                else{
                    for (key, _) in totalExpenditureDic{
                        if key == dateText{
                            incomeVC?.totalIncomeDic[dateText]?.append(money)
                            break
                        }
                        else{
                            incomeVC?.totalIncomeDic[dateText] = [money]
                            break
                        }
                    }
                }
            }
            // 算今日收入總和
            if let total = incomeVC?.totalIncomeDic[dateText]{
                var todayMoney = 0
                for i in total{
                    todayMoney += i
                }
                if let todayMoney = incomeVC?.formatter.string(from: NSNumber(value: todayMoney)){
                    incomeVC?.totalIcomeLabel.text = "\(todayMoney)"
                }
            }
            
            // 找出所有收入裡今天日期的收入資料
            if let allIncomeArray = incomeVC?.allIncomeArray{
                incomeVC?.currentDateIncomeArray = [Income]()
                for income in allIncomeArray{
                    if income.date == dateText{
                        incomeVC?.currentDateIncomeArray.append(income)
                    }
                }
            }
            incomeVC?.incomeTableView.reloadData()
            incomeVC?.animateTableView()
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

extension AddIncomeViewController: IGLDropDownMenuDelegate{
    
    func setupAddType(){
        let typeDropDownItems: NSMutableArray = NSMutableArray()
        for i in 0...(typeArray.count-1) {
            let typeItem = IGLDropDownItem()
            //            typeItem.iconImage = UIImage(named: "\(typeArray[i])")
            typeItem.text = "\(typeArray[i])"
            typeItem.showBackgroundShadow = true
            typeDropDownItems.add(typeItem)
        }
        if let typeText = type{
            //            typeDropDownMenu.menuIconImage = UIImage(named: "\(typeText)")
            typeDropDownMenu.menuText = "\(typeText)"
        }
        typeDropDownMenu.menuText = "Choose Type"
        typeDropDownMenu.dropDownItems = typeDropDownItems as [AnyObject]
        typeDropDownMenu.paddingLeft = 15
        typeDropDownMenu.frame = CGRect(x: 120, y: 180, width: 180, height: 45)
        typeDropDownMenu.delegate = self
        typeDropDownMenu.type = .stack
        typeDropDownMenu.gutterY = 5
        typeDropDownMenu.itemAnimationDelay = 0.1
        typeDropDownMenu.rotate = .random
        typeDropDownMenu.shouldFlipWhenToggleView = true
        typeDropDownMenu.reloadView()
        self.view.addSubview(self.typeDropDownMenu)
    }
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        
        if dropDownMenu == typeDropDownMenu{
            let typeItem: IGLDropDownItem = typeDropDownMenu.dropDownItems[index] as! IGLDropDownItem
            if let typeText = typeItem.text{
                type = typeText
            }
        }
        
    }
}
