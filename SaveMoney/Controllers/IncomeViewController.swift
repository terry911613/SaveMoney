//
//  IncomeViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/23.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit

class IncomeViewController: UIViewController {

    @IBOutlet weak var incomeTableView: UITableView!
    @IBOutlet weak var totalIcomeLabel: UILabel!
    
    var allIncomeArray = [Income]()
    var currentDateIncomeArray = [Income]()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var currentSelectDate = Date()
    var currentSelectDateText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDate()
    }
    
    func getDate(){
        //  顯示 datePicker 方式和大小
        dateFormatter.dateStyle = .medium
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
            self.currentDateIncomeArray = [Income]()
            // 按下確定，讓標題改成選取到的日期
            self.currentSelectDateText = self.dateFormatter.string(from: self.datePicker.date)
            self.navigationItem.title = self.currentSelectDateText
            self.currentSelectDate = self.datePicker.date
            
            for income in self.allIncomeArray{
                if self.currentSelectDateText == income.date{
                    self.currentDateIncomeArray.append(income)
                }
            }
            self.incomeTableView.reloadData()
        }
        dateAlert.addAction(okAction)
        //  警告控制器裡的取消按鈕
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        dateAlert.addAction(cancelAction)
        
        self.present(dateAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editIncomeSegue"{
            if let indexPath = incomeTableView.indexPathForSelectedRow{
                let editIncomeVC = segue.destination as? EditIncomeViewController
                editIncomeVC?.type = currentDateIncomeArray[indexPath.row].type
                editIncomeVC?.dateText = currentDateIncomeArray[indexPath.row].date
                editIncomeVC?.index = indexPath
                
                editIncomeVC?.setupEditType()
                editIncomeVC?.typeDropDownMenu.menuText = currentDateIncomeArray[indexPath.row].type
                
                editIncomeVC?.moneyTextfield.text = String(currentDateIncomeArray[indexPath.row].money)
            }
        }
        else if segue.identifier == "addIncomeSegue"{
            let AddIncomeVC = segue.destination as? AddIncomeViewController
            currentSelectDateText = dateFormatter.string(from: currentSelectDate)
            AddIncomeVC?.dateText = currentSelectDateText
            AddIncomeVC?.setupAddType()
            print("ok")
        }
        
    }
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){
    }

}

//  tableView
extension IncomeViewController: UITableViewDataSource, UITableViewDelegate{

    //MARK: - Tableview Datasource Methods
    //  tableView 的列數等於 moneyArray
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDateIncomeArray.count
    }
    //  重複使用列數
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = incomeTableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath)

        let income = currentDateIncomeArray[indexPath.row]
//        cell.imageView?.image = UIImage(named: "\(expenditure.type)")
        cell.textLabel?.text = "\t類型：\(income.type)"
        cell.detailTextLabel?.text = "$\(income.money)"
        return cell
    }

    //MARK: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        incomeTableView.deselectRow(at: indexPath, animated: true)
    }

    //  在 tableView 上往左滑可以刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{

            currentDateIncomeArray.remove(at: indexPath.row)
            incomeTableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

