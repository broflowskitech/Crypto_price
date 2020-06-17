//
//  ViewController.swift
//  Crypto Price
//
//  Created by Jan B on 24/05/2020.
//  Copyright © 2020 broflowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate  {
    
    

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var cryptoModel = CryptoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        cryptoModel.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        searchTextField.layer.cornerRadius = 5
    }
    
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //what happens, when the user presses return button on the keyboard
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Search cryptocurrency"
            return false
        }
 }

    func textFieldDidEndEditing(_ textField: UITextField) {
//        let defaultRow = self.currencyPicker.selectedRow(inComponent: 0)
//        let currency = pickerView(currencyPicker, didSelectRow: defaultRow, inComponent: 0)
//        print(currency)
//        try the above later
        if let crypto = searchTextField.text
             {
                cryptoModel.getPrice(cryptoName: crypto, for: cryptoModel.currencyArray[0])
        }
        searchTextField.text = ""
    }
}



extension ViewController: CryptoModelDelegate {
    
    func didUpdatePrice(price: String, currency: String) {
            DispatchQueue.main.async {
                self.priceLabel.text = price
                self.currencyLabel.text = currency
            }
        }
        
    func didFailWithError(error: Error) {
            print(error)
        }
    }


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoModel.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoModel.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = cryptoModel.currencyArray[row]
        cryptoModel.getPrice(cryptoName: searchTextField.text ?? "Select cryptocurrency",for: selectedCurrency)
    }
}
