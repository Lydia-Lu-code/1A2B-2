//
//  1A2BViewController.swift
//  1A2B-2
//
//  Created by 維衣 on 2021/2/8.
//

import UIKit

class ABViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var randomAnswer: UILabel!
    @IBOutlet weak var numberAnswer: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet var abLabel: [UILabel]!
    @IBOutlet var gueLabel: [UILabel]!
    
    @IBOutlet weak var boomView: UIView!
    
    var number: Array<Int> = []
    var number1: Array<Int> = []
    var number2: Array<Int> = []
    var array: Array<Int> = []
    var rightAns: Int = 0
    var errorAns: Int = 0
    var count: Int = 0
    var numString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        numberAnswer.keyboardType = .numberPad
        numberAnswer.delegate = self
        boomView.alpha = 0
    }
    
    
    @IBAction func checkbtn(_ sender: Any) {
        count += 1
        rightAns = 0
        errorAns = 0
        array = []
        randomAnswer.layer.isHidden = true
        ///有可能為重複數字999
        if Int(numberAnswer.text!)! <= 999 || numberAnswer.text! == "" {
            alert("字數太少!","請重新輸入唷！")
        }else{
            switch count {
            case 0...3:
                if randomAnswer.text! == "" {
                    randomAnswer.layer.isHidden = true
                    repeat{
                    numString = String(Int.random(in: 0123...9876))
                    number1 = intToArrayInt("\(numString)").removingDuplicates()
                    }while number1.count != 4
                }
                randomAnswer.text! = numString
                print("**numString == \(numString)")
                run()
            case 4...5:
                run()
                count = 0
                alert("遊戲結束!","挑戰失敗，重新開局嗎？")
                randomAnswer.layer.isHidden = false
            default:
                break
                }
            
            if rightAns == 4{
                VFX()
                reset()
                count = 0
                randomAnswer.layer.isHidden = false
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        boomView.alpha = 0
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 4
    }
    
    func check(array1: Array<Int>, array2: Array<Int>) -> Array<Int> {

        var list = Array<Int>()
        var set = Set<Int>()

        for item in array1 { set.insert(item) }
        for item in array2 { if set.contains(item) { list.append(item) } }
        
        array = list
        return array
    }
    
    func alert(_ title:String,_ message: String) {
        
        if title == "字數太少!" || title == "數字重複!"{
            count = count - 1
            numberAnswer.text! = ""
            }

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default) { [self] (_) in
                if title == "遊戲結束!"{ reset() }
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
    }

    func intToArrayInt(_ answerText: String) -> Array<Int>{
        number.removeAll()
        for i in answerText{
            let num = Int(String(i))!
            number.append(num)
            }
        return number
    }
    
    func run() {
        let number2 = intToArrayInt(numberAnswer.text!).removingDuplicates()
        if number2.count != 4 {
            alert("數字重複!","請重新輸入唷！")
        }else{
        array = check(array1: number1, array2: number2)
        for x in 0...3 {
            if number1[x] == number2[x]{
                rightAns = rightAns + 1
            }
        }
        
        errorAns = array.count - rightAns
        guard errorAns >= 0 else {
            return errorAns = 0
        }
        
        gueLabel[count-1].text! = numberAnswer.text!
        abLabel[count-1].text! = "\(rightAns)A\(errorAns)B"
        }
        numberAnswer.text! = ""
    }
    
    func reset(){
        randomAnswer.text = ""
        numberAnswer.text = ""
        array.removeAll()
        number.removeAll()
        
        for i in 0...3{
            gueLabel[i].text = ""
            abLabel[i].text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return false
    }
    
    func VFX(){
        boomView.alpha = 1
        // 讓方塊變放大後再縮小回來
        UIView.animate(withDuration: 0.2, animations: {
            self.boomView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) { (_) in
            UIView.animate(withDuration: 0.5) {
                self.boomView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
}

extension Array where Element: Hashable {
  func removingDuplicates() -> [Element] {
      var addedDict = [Element: Bool]()
      return filter {
        addedDict.updateValue(true, forKey: $0) == nil
      }
   }
   mutating func removeDuplicates() {
      self = self.removingDuplicates()
   }
}
