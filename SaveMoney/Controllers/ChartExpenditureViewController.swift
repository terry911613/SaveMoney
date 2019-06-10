//
//  ChartExpenditureViewController.swift
//  SaveMoney
//
//  Created by 李泰儀 on 2019/4/30.
//  Copyright © 2019 TerryLee. All rights reserved.
//

import UIKit
import Charts

class ChartExpenditureViewController: UIViewController {

    @IBOutlet weak var chartExpenditureView: PieChartView!
    
    var dateText: String?
    
    var totalExpenditureDic = [String : [Int]]()
    
    var foodDic = [String : [Int]]()
    var clothingDic = [String : [Int]]()
    var housingDic = [String : [Int]]()
    var transportationDic = [String : [Int]]()
    var educationDic = [String : [Int]]()
    var entertainmentDic = [String : [Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pieChartUpdate()
    }
    @IBAction func a(_ sender: UIButton) {
        print(dailyTotalMoney(dic: foodDic))
        print(dailyTotalMoney(dic: clothingDic))
        print(dailyTotalMoney(dic: housingDic))
        print(dailyTotalMoney(dic: transportationDic))
        print(dailyTotalMoney(dic: educationDic))
        print(dailyTotalMoney(dic: entertainmentDic))
    }
    
    @IBAction func timeSegmented(_ sender: UISegmentedControl) {
        
    }
    
    func pieChartUpdate () {
        let food = PieChartDataEntry(value: dailyTotalMoney(dic: foodDic) , label: "食")
        let clothing = PieChartDataEntry(value: dailyTotalMoney(dic: clothingDic), label: "衣")
        let housing = PieChartDataEntry(value: dailyTotalMoney(dic: housingDic), label: "住")
        let transportation = PieChartDataEntry(value: dailyTotalMoney(dic: transportationDic), label: "行")
        let education = PieChartDataEntry(value: dailyTotalMoney(dic: educationDic), label: "育")
        let entertainment = PieChartDataEntry(value: dailyTotalMoney(dic: entertainmentDic), label: "樂")
        
        let pieChartDataSet = PieChartDataSet(values: [food, clothing, housing, transportation, education, entertainment], label: "123")
        
        pieChartDataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]

        let data = PieChartData(dataSet: pieChartDataSet)
        chartExpenditureView.data = data
        chartExpenditureView.chartDescription?.text = "今日支出情況"

        chartExpenditureView.notifyDataSetChanged()
    }
    func dailyTotalMoney(dic: [String : [Int]]) -> Double{
        var total = 0
        if dic.isEmpty{
            return 0.0
        }
        else{
            for (key, value) in dic{
                if let dateText = dateText{
                    if key == dateText{
                        for money in value{
                            total += money
                        }
                        break
                    }
                }
                
            }
            return Double(total)
        }
    }
}
