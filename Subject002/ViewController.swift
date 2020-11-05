//
//  ViewController.swift
//  Subject002
//
//  Created by Masaki Horimoto on 2020/10/27.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var numTextField: [UITextField]!
    @IBOutlet weak var resultCalc: UILabel!
    @IBOutlet weak var operatorSegment: UISegmentedControl!
    
    private enum ErrorSubject2: Error {
        case text2IntError
    }

    class Calculate {
        
        enum Operator: String, CaseIterable {
            case add = "+"
            case subtract = "-"
            case multiply = "×"
            case devide = "÷"
        }
        
        enum ErrorCalculate: Error {
            case zeroDevide
        }
        
//        let operatorChar = [Operator.add.rawValue,
//                            Operator.subtract.rawValue,
//                            Operator.multiply.rawValue,
//                            Operator.devide.rawValue]
        
        func getOperator(opText: String) -> Operator? {
//            switch(opText) {
//                case Operator.add.rawValue:
//                    return Operator.add
//                case Operator.subtract.rawValue:
//                    return Operator.subtract
//                case Operator.multiply.rawValue:
//                    return Operator.multiply
//                case Operator.devide.rawValue:
//                    return Operator.devide
//                default:
//                    return nil
//            }
            Operator(rawValue: opText)
        }
        
        func calc(op: Operator, num1: Int?, num2: Int?) throws -> Int {
            
            if num1 == nil || num2 == nil {
                fatalError("num is nil.")
            }
            let num1 = num1!
            let num2 = num2!
            
            let result: Int
            switch op {
                case .add:
                    result = num1 + num2
                case .subtract:
                    result = num1 - num2
                case .multiply:
                    result = num1 * num2
                case .devide:
                    if num2 == 0 {
                        throw ErrorCalculate.zeroDevide
                    }
                    result = num1 / num2
            }
            return result
        }
        
    }
    
    let calcSubject002 = Calculate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SegmentedControlの表示文字列をセット
//        calcSubject002.operatorChar.enumerated().forEach{
        Calculate.Operator.allCases.enumerated().forEach{
//            operatorSegment.setTitle($0.1.rawValue, forSegmentAt: $0.0)
            operatorSegment.setTitle($0.1.rawValue, forSegmentAt: $0.0)
        }
    }

    //ボタンを押した時
    @IBAction func pressButton(_ sender: Any) {
        
        //テキストフィールドの文字列を数値に変換する
        let numArray = changeNumTextFieldArrayToInt(numTextField)
        
        //テキストフィールドに有効な数字が入っている場合のみ計算を実行する
        if !canCalculate(numArray) {
            return
        }
        
        let selectedIndex = operatorSegment.selectedSegmentIndex    //選択中のセグメントのIndexを取得する
        guard let opText = operatorSegment.titleForSegment(at: selectedIndex) else {    //洗濯中のセグメントのテキストを取得
            fatalError("Can't get value of titleForSegment.")
        }
        guard let op = calcSubject002.getOperator(opText: opText) else { //洗濯中の演算子を取得
            fatalError("Can't get value of titleForSegment.")   //テキストが+,-,×,÷以外の時には何かがおかしいのでfatalError
        }
        
        //計算、及び、ラベルへ結果の出力
        let outputText: String
        do {
            let result = try calcSubject002.calc(op: op, num1: numArray[0], num2: numArray[1])
            outputText = "\(result)"
        } catch {
            outputText = "割る数には0以外を入力して下さい"
        }
        
        resultCalc.text = outputText
    }
    
    //テキストフィールドの文字列を数値に変換する関数
    private func changeNumTextFieldArrayToInt(_ numTextField: [UITextField]) -> ([Int?]){
        let numArray: [Int?] = numTextField.map {
            do {
                let text = $0.text ?? ""
                if Int(text) == nil {
                    throw ErrorSubject2.text2IntError
                } else {
                    return Int(text)!
                }
            } catch {
                resultCalc.text = "各枠に数字（半角）を入力して下さい"
                return nil
            }
        }
        return numArray
    }
    
    //計算可能な数値が入っているか判断する関数
    private func canCalculate(_ numArray: [Int?]) -> Bool {
        let retValue: Bool = numArray.map {
            if $0 == nil {
                return false
            } else {
                return true
            }
        }.reduce(true) {
            $0 == false || $1 == false ? false : true
        }
        return retValue
    }

}

