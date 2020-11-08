//
//  ViewController.swift
//  Subject002
//
//  Created by Masaki Horimoto on 2020/10/27.
//

import UIKit

/// 計算で扱う2つの値を保持する責務のみ持つ
struct CalculatingSource {
    let value1: Int
    let value2: Int
}


/// 2つの値に対する計算に関する責務のみ受け持つ
enum Operator: Int {
    case add
    case subtract
    case multiply
    case devide

    enum Error: Swift.Error {
        case dividingByZero
    }

    func calculate(source: CalculatingSource) throws -> Int {
        switch self {
        case .add, .subtract, .multiply:
            break
        case .devide:
            guard source.value2 != 0 else {
                throw Error.dividingByZero
            }
        }

        return ope(source.value1, source.value2)
    }

    private var ope: (Int, Int) -> Int {
        switch self {
        case .add:
            return (+)
        case .subtract:
            return (-)
        case .multiply:
            return (*)
        case .devide:
            return (/)
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var numTextFields: [UITextField]!
    @IBOutlet weak var resultCalcLabel: UILabel!
    @IBOutlet weak var operatorSegment: UISegmentedControl!
    
    private enum ErrorSubject2: Error {
        case text2IntError
    }

    //ボタンを押した時
    @IBAction func pressButton(_ sender: Any) {
        
        guard let calculatingSource = InputNumberExtractor().extract(numTextFields: numTextFields) else {
            resultCalcLabel.text = "各枠に数字（半角）を入力して下さい"
            return
        }

        guard let ope = Operator(rawValue: operatorSegment.selectedSegmentIndex) else {
            fatalError("selectedSegmentIndex is invalid.")
        }

        do {
            resultCalcLabel.text = String(try ope.calculate(source: calculatingSource))
        } catch Operator.Error.dividingByZero {
            resultCalcLabel.text = "割る数には0以外を入力して下さい"
        } catch {

        }
        
    }

}


/// テキストフィールドから2つの値を取り出すことに関する責務のみ持つ
struct InputNumberExtractor {
    func extract(numTextFields: [UITextField]) -> CalculatingSource? {
        let numbers = numTextFields
            .map { $0.text ?? "" }
            .compactMap { Int($0) }

        guard numbers.count == 2 else {
            return nil
        }

        return CalculatingSource(value1: numbers[0], value2: numbers[1])
    }
}

