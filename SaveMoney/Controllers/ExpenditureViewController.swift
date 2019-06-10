//
//  ViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/23.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import ViewAnimator

class ExpenditureViewController: UIViewController{
    
    @IBOutlet weak var expenditureTableView: UITableView!
    @IBOutlet weak var totalExpenditureLabel: UILabel!
    
    var allExpenditureArray = [Expenditure]()
    var currentDateExpenditureArray = [Expenditure]()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var currentSelectDate = Date()
    var currentSelectDateText: String?
    let formatter = NumberFormatter()
    
    var totalExpenditureDic = [String : [Int]]()
    var foodDic = [String : [Int]]()
    var clothingDic = [String : [Int]]()
    var housingDic = [String : [Int]]()
    var transportationDic = [String : [Int]]()
    var educationDic = [String : [Int]]()
    var entertainmentDic = [String : [Int]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDate()
        totalExpenditureLabel.text = ""
        formatter.numberStyle = .currency
        
        //  取今天所有的支出總和
        currentSelectDateText = dateFormatter.string(from: datePicker.date)
        
        if let today = currentSelectDateText{
            if let todayMoneyArray = totalExpenditureDic[today]{
                var todayMoney = 0
                for money in todayMoneyArray{
                    todayMoney += money
                }
                if let todayMoney = formatter.string(from: NSNumber(value: todayMoney)){
                    totalExpenditureLabel.text = "\(todayMoney)"
                }
            }
        }
        
    }
    
    //  tableview顯示特效
    func animateTableView(){
        let animations = [AnimationType.from(direction: .left, offset: 10.0)]
        expenditureTableView.reloadData()
        UIView.animate(views: expenditureTableView.visibleCells, animations: animations, reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0, animationInterval: 0.05, duration: ViewAnimatorConfig.duration, completion: nil)
    }
    
    func getDate(){
        //  顯示 datePicker 方式和大小
        dateFormatter.dateStyle = .medium
//        if Locale.current.description.contains("TW") {
//            datePicker.locale = Locale(identifier: "zh_TW")
//        }
        datePicker.locale = Locale.current
        dateFormatter.locale = datePicker.locale
        dateFormatter.dateStyle = .medium
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        navigationItem.title = dateFormatter.string(from: datePicker.date)
    }
    
    //  左上角按鈕選擇日期
    @IBAction func dateButton(_ sender: UIBarButtonItem) {
        
        //  建立警告控制器顯示 datePicker
        let dateAlert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        dateAlert.view.addSubview(datePicker)
        //  警告控制器裡的確定按鈕
        let okAction = UIAlertAction(title: "確定", style: .default) { (alert: UIAlertAction) in
            self.currentDateExpenditureArray = [Expenditure]()
            // 按下確定，讓標題改成選取到的日期
            if var currentSelectDateText = self.currentSelectDateText{
                currentSelectDateText = self.dateFormatter.string(from: self.datePicker.date)
                self.navigationItem.title = currentSelectDateText
                self.currentSelectDate = self.datePicker.date
                
                //  取選取日期的支出資料
                for expenditure in self.allExpenditureArray{
                    if currentSelectDateText == expenditure.date{
                        self.currentDateExpenditureArray.append(expenditure)
                    }
                }
                //  取選取日期的支出總和
                for (key, value) in self.totalExpenditureDic{
                    if currentSelectDateText == key{
                        var todayMoney = 0
                        for money in value{
                            todayMoney += money
                        }
                        if let todayMoney = self.formatter.string(from: (NSNumber(value: todayMoney))){
                            self.totalExpenditureLabel.text = "\(todayMoney)"
                        }
                        break
                    }
                    else{
                        self.totalExpenditureLabel.text = ""
                    }
                }
                self.expenditureTableView.reloadData()
                self.animateTableView()
            }
        }
        dateAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        
        self.present(dateAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editExpenditureSegue"{
            if let indexPath = expenditureTableView.indexPathForSelectedRow{
                let editExpenditureVC = segue.destination as? EditExpenditureViewController
                editExpenditureVC?.money = currentDateExpenditureArray[indexPath.row].money
                editExpenditureVC?.type = currentDateExpenditureArray[indexPath.row].type
                editExpenditureVC?.typeDetail = currentDateExpenditureArray[indexPath.row].typeDetail
                editExpenditureVC?.dateText = currentDateExpenditureArray[indexPath.row].date
                editExpenditureVC?.index = indexPath
                
                editExpenditureVC?.setupEditType()
                editExpenditureVC?.typeDropDownMenu.menuText = currentDateExpenditureArray[indexPath.row].type
                editExpenditureVC?.setupEditTypeDetail()
                editExpenditureVC?.typeDetailDropDownMenu.menuText = currentDateExpenditureArray[indexPath.row].typeDetail
                
                editExpenditureVC?.moneyTextfield.text = String(currentDateExpenditureArray[indexPath.row].money)
            }
        }
        else if segue.identifier == "addExpenditureSegue"{
            let addExpenditureVC = segue.destination as? AddExpenditureViewController
            if var currentSelectDateText = currentSelectDateText{
                currentSelectDateText = dateFormatter.string(from: currentSelectDate)
                addExpenditureVC?.dateText = currentSelectDateText
                addExpenditureVC?.setupTypeInit()
            }
        }
        else if segue.identifier == "chartExpenditureSegue"{
            let chartExpenditureVC = segue.destination as? ChartExpenditureViewController
            
            chartExpenditureVC?.dateText = currentSelectDateText
            chartExpenditureVC?.totalExpenditureDic = totalExpenditureDic
            chartExpenditureVC?.foodDic = foodDic
            chartExpenditureVC?.clothingDic = clothingDic
            chartExpenditureVC?.housingDic = housingDic
            chartExpenditureVC?.transportationDic = transportationDic
            chartExpenditureVC?.educationDic = educationDic
            chartExpenditureVC?.entertainmentDic = entertainmentDic
            
//            chartExpenditureVC?.pieChartUpdate()
        }
        
    }
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }
}

//  tableView
extension ExpenditureViewController: UITableViewDataSource, UITableViewDelegate{
    
    //MARK: - Tableview Datasource Methods
    //  tableView 的列數等於 moneyArray
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDateExpenditureArray.count
    }
    //  重複使用列數
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = expenditureTableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        
        let expenditure = currentDateExpenditureArray[indexPath.row]
        cell.imageView?.image = UIImage(named: "\(expenditure.type)")
        cell.textLabel?.text = "\t類型：\(expenditure.type)"
        if let expenditureMoney = formatter.string(from: NSNumber(value: expenditure.money)){
            cell.detailTextLabel?.text = "\(expenditure.typeDetail) " + expenditureMoney
        }
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        expenditureTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //  在 tableView 上往左滑可以刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            currentDateExpenditureArray.remove(at: indexPath.row)
            expenditureTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
