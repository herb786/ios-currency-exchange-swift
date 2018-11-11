//
//  XChangeViewController.swift
//  XRateTinSwift
//
//  Created by Herbert Caller on 05/09/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

import UIKit

class XChangeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView:UITableView!
    var lblBaseCurrency: String!
    var baseCurrency: String!
    var currencies: [String]?
    var values: [Double]?
    var flags: [String]?
    
    var uflags: [String] = ["\u{1f1e6}\u{1f1fa}",
                            "\u{1f1e7}\u{1f1ec}",
                            "\u{1f1e7}\u{1f1f7}",
                            "\u{1f1e8}\u{1f1e6}",
                            "\u{1f1e8}\u{1f1ed}",
                            "\u{1f1e8}\u{1f1f3}",
                            "\u{1f1e8}\u{1f1ff}",
                            "\u{1f1e9}\u{1f1f0}",
                            "\u{1f1ec}\u{1f1e7}",
                            "\u{1f1ed}\u{1f1f0}",
                            "\u{1f1ed}\u{1f1f7}",
                            "\u{1f1ed}\u{1f1fa}",
                            "\u{1f1ee}\u{1f1e9}",
                            "\u{1f1ee}\u{1f1f1}",
                            "\u{1f1ee}\u{1f1f3}",
                            "\u{1f1ef}\u{1f1f5}",
                            "\u{1f1f0}\u{1f1f7}",
                            "\u{1f1f2}\u{1f1fd}",
                            "\u{1f1f2}\u{1f1fe}",
                            "\u{1f1f3}\u{1f1f4}",
                            "\u{1f1f3}\u{1f1ff}",
                            "\u{1f1f5}\u{1f1ed}",
                            "\u{1f1f5}\u{1f1f1}",
                            "\u{1f1f7}\u{1f1f4}",
                            "\u{1f1f7}\u{1f1fa}",
                            "\u{1f1f8}\u{1f1ea}",
                            "\u{1f1f8}\u{1f1ec}",
                            "\u{1f1f9}\u{1f1ed}",
                            "\u{1f1f9}\u{1f1f7}",
                            "\u{1f1fa}\u{1f1f8}",
                            "\u{1f1ff}\u{1f1e6}",
                            "\u{1f1ea}\u{1f1fa}"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        baseCurrency = "EUR"
        lblBaseCurrency = "Change Unit: Euro"
        self.fetchExchangeRates(baseCurrency: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let controller = segue.destination as! CurrencyPickerViewController
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
        controller.aimCurrency = (self.currencies?[indexPath.row])!
        controller.baseCurrency = self.baseCurrency
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.currencies == nil){
            return 1
        } else {
            return self.currencies!.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell")!
            cell.textLabel!.text = lblBaseCurrency
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyRateIdentifier") as! CurrencyRateTableViewCell
            cell.lblCode.text = self.currencies![indexPath.row]
            let value = self.values![indexPath.row]
            let textCell = String(format: "%.4f", value)
            cell.lblValue.text = textCell
            let image = UIImage.init(named: self.currencies![indexPath.row].lowercased() + ".png")
            cell.flag.image = image
            if (self.flags != nil){
                //let img = self.flags![indexPath.row]
                //let myUrl = URL(string: img)
                //do {
                  //  let data = try Data.init(contentsOf: myUrl!)
                  //  let image = UIImage.init(data: data)
                  //  cell.flag.image = image
                //} catch {}
                let image = UIImage.init(named: self.currencies![indexPath.row].lowercased() + ".png")
                cell.flag.image = image
            }
            return cell
        }
        
    }
    
    @IBAction func fetchRatesEuroBased(sender:UIBarButtonItem) {
        self.lblBaseCurrency = "Change Unit: Euro"
        self.baseCurrency = "EUR"
        self.fetchExchangeRates(baseCurrency: "?base=EUR")
    }
    
    @IBAction func fetchRatesDollarBased(sender:UIBarButtonItem) {
        self.lblBaseCurrency = "Change Unit: US Dollar"
        self.baseCurrency = "USD"
        self.fetchExchangeRates(baseCurrency: "?base=USD")
    }
    
    @IBAction func fetchRatesPoundBased(sender:UIBarButtonItem) {
        self.lblBaseCurrency = "Change Unit: British Pound"
        self.baseCurrency = "GBP"
        self.fetchExchangeRates(baseCurrency: "?base=GBP")
    }
    
    func fetchExchangeRates(baseCurrency:String) {
        let baseUrl = "https://api.fixer.io/latest"
        let fullUrl = baseUrl + baseCurrency
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
                    self.currencies = rates.allKeys as? [String]
                    self.values = rates.allValues as? [Double]
                    //self.fetchImages()
                } catch {
                    print(error)
                }
                // Reload table view
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        })
        task.resume()
        
    }
    
    func fetchImages() {
        let imgUrl = "http://hackaller.com/api/flags.json"
        guard let myUrl = URL(string: imgUrl) else {
            return
        }
        let request = URLRequest(url: myUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            // Parse JSON data
            if let data = data {
                do {
                    let myflags = try JSONSerialization.jsonObject(with: data, options:
                        JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]
                    let maxi = myflags!.count
                    let maxj = self.currencies!.count
                    self.flags = self.currencies
                    for idx in 0..<maxj {
                        let code = self.currencies![idx]
                        for jdx in 0..<maxi {
                            let myflag = myflags![jdx]
                            let flagcode = myflag["code"] as! String
                            if (flagcode == code){
                                print(myflag["flag"])
                                self.flags![idx] = myflag["flag"] as! String
                            }
                        }
                    }
                } catch {
                    print(error)
                }
                // Reload table view
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        })
        task.resume()
        
    }
    
}
