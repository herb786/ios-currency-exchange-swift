//
//  CurrencyPickerViewController.swift
//  XRateTinSwift
//
//  Created by Herbert Caller on 15/09/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

import UIKit

class CurrencyPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var pickerFromCurrency : UIPickerView!
    @IBOutlet var pickerToCurrency: UIPickerView!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var edtAmount: UITextField!
    @IBOutlet var lblExchange: UILabel!
    @IBOutlet var btnConvert: TinButton!
    @IBOutlet var swapBtn: TinButton!
    
    var pickedAimCurrency:Double = 0.0
    var pickedBaseCurrency:Double = 0.0
    
    var aimCurrency : String?
    var baseCurrency : String?
    var baseMoneyCode : [String] = ["AUD","BGN","BRL","CAD","CHF","CNY","CZK","DKK","GBP","HKD","HRK","HUF","IDR","ILS","INR","JPY","KRW","MXN","MYR","NOK","NZD","PHP","PLN","RON","RUB","SEK","SGD","THB","TRY","USD","ZAR","EUR"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(CurrencyPickerViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyPickerViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CurrencyPickerViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        let row0 = baseMoneyCode.index(of: self.baseCurrency!)
        self.pickerToCurrency.selectRow(row0!, inComponent: 0, animated: false)
        
        let row1 = baseMoneyCode.index(of: self.aimCurrency!)
        self.pickerFromCurrency.selectRow(row1!, inComponent: 0, animated: false)
        
        fetchExchangeRates(baseCurrency: self.baseMoneyCode[row1!], aimCurrency: self.baseMoneyCode[row0!])
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getCurrencyExchange(sender:TinButton) {
        let formatter = NumberFormatter.init()
        if self.edtAmount.text != "" {
            let amount:Double = (formatter.number(from: self.edtAmount.text!)!.doubleValue)
            let rate:Double = (formatter.number(from: self.lblRate.text!)?.doubleValue)!
            formatter.positiveFormat = "###0.##"
            self.lblExchange.text = formatter.string(from: NSNumber.init(value: amount*rate))!
        }
        
    }
    
    @IBAction func swapCurrencies(sender:TinButton) {
        let row0 = self.pickerFromCurrency.selectedRow(inComponent: 0)
        let row1 = self.pickerToCurrency.selectedRow(inComponent: 0)
        self.pickerFromCurrency.selectRow(row1, inComponent: 0, animated: false)
        self.pickerToCurrency.selectRow(row0, inComponent: 0, animated: false)
        fetchExchangeRates(baseCurrency: self.baseMoneyCode[row1], aimCurrency: self.baseMoneyCode[row0])
        
    }
    
   
    @IBAction func hideKeyboard(_ sender: UIControl) {
        self.edtAmount.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if (pickerView == self.pickerFromCurrency){
            return 1
        }
        if (pickerView == self.pickerToCurrency) {
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == self.pickerFromCurrency){
            return self.baseMoneyCode.count
        }
        if (pickerView == self.pickerToCurrency) {
            return self.baseMoneyCode.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == self.pickerFromCurrency){
            return self.baseMoneyCode[row]
        }
        if (pickerView == self.pickerToCurrency) {
            return self.baseMoneyCode[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == self.pickerFromCurrency){
            let row1:Int = self.pickerToCurrency.selectedRow(inComponent: 0)
            fetchExchangeRates(baseCurrency: self.baseMoneyCode[row], aimCurrency: self.baseMoneyCode[row1])
        }
        if (pickerView == self.pickerToCurrency) {
            let row1:Int = self.pickerFromCurrency.selectedRow(inComponent: 0)
            fetchExchangeRates(baseCurrency: self.baseMoneyCode[row], aimCurrency: self.baseMoneyCode[row1])
        }
    }
    
    
    func fetchExchangeRates(baseCurrency: String, aimCurrency: String) {
        let baseUrl:String = "https://api.fixer.io/latest?symbols="
        let fullUrl:String = baseUrl.appendingFormat("%@,%@", baseCurrency, aimCurrency)
        guard let fixerioUrl = URL(string: fullUrl) else {
            return
        }
        let request = URLRequest(url: fixerioUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            // Parse JSON data
            if let data = data {
                do {
                    let referenceRate = try JSONSerialization.jsonObject(with: data, options:
                        JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    let rates = referenceRate?["rates"] as! NSDictionary
                    let currencies = rates.allKeys as? [String]
                    let values = rates.allValues as? [Double]
                    if (baseCurrency != aimCurrency){
                        if (baseCurrency == "EUR"){
                            self.pickedBaseCurrency = 1.0
                            self.pickedAimCurrency = values![0]
                        } else if (aimCurrency == "EUR"){
                            self.pickedAimCurrency = 1.0
                            self.pickedBaseCurrency = values![0]
                        } else {
                            if (currencies![0] == baseCurrency){
                                self.pickedBaseCurrency = values![0]
                                self.pickedAimCurrency = values![1]
                            } else {
                                self.pickedBaseCurrency = values![1]
                                self.pickedAimCurrency = values![0]
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
                OperationQueue.main.addOperation({
                    let rate:Double = self.pickedAimCurrency/self.pickedBaseCurrency
                    let formatter = NumberFormatter.init()
                    formatter.positiveFormat = "###0.###"
                    self.lblRate.text = formatter.string(from: NSNumber.init(value: rate))
                })
            }
        })
        task.resume()
        
    }
    

}
