//
//  EditIncomeViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/26.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import IGLDropDownMenu

class EditIncomeViewController: UIViewController {
    
    @IBOutlet weak var moneyTextfield: UITextField!
    
    var editIncomeArray = [Income]()
    var typeDropDownMenu = IGLDropDownMenu()
    var money: Int?
    var typeArray: NSArray = ["薪水", "獎金", "補助", "投資", "其他"]
    var type: String?
    var dateText: String?
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let inputMoney = Int(moneyTextfield.text!),
            let typeText = type,
            let dateText = dateText{
            
            let IncomeVC = segue.destination as? IncomeViewController
            if let indexPath = index{
                IncomeVC?.currentDateIncomeArray[indexPath.row].money = inputMoney
                IncomeVC?.currentDateIncomeArray[indexPath.row].type = typeText
                IncomeVC?.currentDateIncomeArray[indexPath.row].date = dateText
                IncomeVC?.incomeTableView.reloadData()
                IncomeVC?.animateTableView()
            }
            
            //  假如編輯過後的錢跟編輯前的錢不一樣才會改掉裡面的值
            if money != inputMoney{
                if var total = IncomeVC?.totalIncomeDic[dateText]{
                    for i in 0...total.count-1{
                        if let money = money {
                            if total[i] == money{
                                total.remove(at: i)
                                total.append(inputMoney)
                                break
                            }
                        }
                    }
                    var todayMoney = 0
                    for x in total{
                        todayMoney += x
                    }
                    IncomeVC?.totalIcomeLabel.text = "\(todayMoney)"
                    IncomeVC?.totalIncomeDic[dateText] = total
                }
            }
            
        }
        
    }
    
    //  隨便按一個地方，彈出鍵盤就會收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EditIncomeViewController: IGLDropDownMenuDelegate{
    
    func setupEditType(){
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
