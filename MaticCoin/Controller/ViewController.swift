//
//  ViewController.swift
//  MaticCoin
//
//  Created by Mariola Hullings on 12/20/23.
//

import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()

    @IBOutlet weak var maticLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateRate(price: String, currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.maticLabel.text = price
        }
    }
}

//MARK: - UIPickerView Data Source and Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
