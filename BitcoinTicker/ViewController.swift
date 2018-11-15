//
//  ViewController.swift
//  DiceGame
//
//  Created by Mehmet Anıl Kul on 7.05.2018.
//  Copyright © 2018 Mehmet Anıl Kul. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel?
    @IBOutlet weak var currencyPicker: UIPickerView?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Proto
        currencyPicker!.delegate = self
        currencyPicker!.dataSource = self
        
    }

    
    //MARK: Pickerview Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    var currencySymbol: Int = 0
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
        print("Final URL: \(finalURL)")
        getPrice(url: finalURL)
        currencySymbol = row
        
    }
    
    
    //Networking
    func getPrice(url: String) {
        
        Alamofire.request(finalURL, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("We got the coin data")
                if let result = response.result.value {
                    let coinJSON : JSON = JSON(result)
                    self.updatePrice(json: coinJSON)
                }
                
            } else {
                print("Error: \(response.result.error!)")
                self.bitcoinPriceLabel?.text = "Connection Issues"
            }
        }
    }
    

//    //MARK: - JSON Parsing
//    /***************************************************************/
    
    func updatePrice(json : JSON) {
        
        let priceResult = json["last"].doubleValue
        print(priceResult)
        bitcoinPriceLabel?.text = "1 BTC = \(currencySymbols[currencySymbol])\(priceResult)"

    }
//




}

