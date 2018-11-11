//
//  MainViewController.swift
//  XRateTinSwift
//
//  Created by Herbert Caller on 05/09/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let identifier = segue.identifier
        if (identifier == "seguePairs"){
            let controller = segue.destination as! CurrencyPickerViewController
            controller.aimCurrency = "EUR"
            controller.baseCurrency = "USD"
        }
    }
    
    @IBAction func gotoPairsExchange(sender:TinButton) {
        performSegue(withIdentifier: "seguePairs", sender: sender)
    }
    
    @IBAction func gotoMostUsedExchange(sender:TinButton) {
        performSegue(withIdentifier: "segueMostUsed", sender: sender)
    }
    

}
