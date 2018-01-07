//
//  EntriesTableViewHeader.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 04.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import UIKit

protocol EntriesTableViewHeaderDelegate: class {
    func didTapAddButton(furnace: Furnace, scrap: Scrap, amount: Int, completion: () -> Void)
    func didTapPickerDoneButton()
    func didTapAddFurnacesButton()
    func didTapAddScrapButton()
}

class EntriesTableViewHeader: UIView {
    
    weak var delegate: EntriesTableViewHeaderDelegate?

    @IBOutlet weak var furnaceTextField: UITextField!
    @IBOutlet weak var leftCapacityLabel: UILabel!
    @IBOutlet weak var scrapTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var furnaces: [Furnace] = []
    var scraps: [Scrap] = []
    var entries: [Entry] = []
    
    private var selectedFurnace: Furnace?
    private var selectedScrap: Scrap?
    private var leftCapacity = 0
    
    let furnacePickerView = UIPickerView()
    let scrapPickerView = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurePickerViews()
    }

    @IBAction func addButtonAction(_ sender: UIButton) {
        if let furnace = selectedFurnace, let scrap = selectedScrap, let amountString = amountTextField.text, let amount = Int(amountString) {
            delegate?.didTapAddButton(furnace: furnace, scrap: scrap, amount: amount, completion: {
                resetFields()
                setRemainingCapacity(furnace: furnace)
                addButton.isEnabled = validateTextFields()
            })
        }
    }
    
    @IBAction func addFurnacesButtonAction(_ sender: UIButton) {
        delegate?.didTapAddFurnacesButton()
    }
    
    @IBAction func addScrapButtonAction(_ sender: UIButton) {
        delegate?.didTapAddScrapButton()
    }
    
    @objc internal func pickerDoneButtonAction() {
        if furnaceTextField.isFirstResponder {
            let index = furnacePickerView.selectedRow(inComponent: 0)
            let furnace = furnaces[index]
            furnaceTextField.text = furnace.name
            selectedFurnace = furnace
            setRemainingCapacity(furnace: furnace)
        } else if scrapTextField.isFirstResponder {
            let index = scrapPickerView.selectedRow(inComponent: 0)
            let scrap = scraps[index]
            scrapTextField.text = scrap.name
            selectedScrap = scrap
        }
        
        addButton.isEnabled = validateTextFields()
        delegate?.didTapPickerDoneButton()
    }
    
    @objc func pickerCloseButtonAction() {
        delegate?.didTapPickerDoneButton()
    }
    
    func validateTextFields() -> Bool {
        if let text = amountTextField.text, let amount = Int(text), amount > leftCapacity {
            return false
        }
        return !furnaceTextField.text!.isEmpty
            && !scrapTextField.text!.isEmpty
            && !amountTextField.text!.isEmpty
            && amountTextField.text!.isNumber
    }
    
    func setRemainingCapacity(furnace: Furnace) {
        guard furnace.objectID == selectedFurnace?.objectID else { return }
        let total = entries.filter({ $0.furnace.objectID == furnace.objectID })
                           .map({ $0.amount })
                           .reduce(0, +)
        
        let remaining = furnace.capacity - Int32(total)
        leftCapacityLabel.text = "\(Int(remaining).formatted()) kg"
        leftCapacity = Int(remaining)
        if remaining == 0 {
            addButton.isEnabled = false
        }
    }
    
    func resetFields() {
        selectedScrap = nil
        scrapTextField.text = ""
        amountTextField.text = ""
    }
    
    func resetAllFields() {
        selectedFurnace = nil
        selectedScrap = nil
        furnaceTextField.text = ""
        scrapTextField.text = ""
        amountTextField.text = ""
        leftCapacityLabel.text = "-"
        leftCapacity = 0
    }
    
    // MARK: - Textfield delegate
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        addButton.isEnabled = validateTextFields()
    }
    
    internal func configurePickerViews() {
        furnacePickerView.dataSource = self
        furnacePickerView.delegate = self
        scrapPickerView.dataSource = self
        scrapPickerView.delegate = self
        
        furnaceTextField.inputView = furnacePickerView
        scrapTextField.inputView = scrapPickerView
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        toolbar.barStyle = .default
        toolbar.isTranslucent = false
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let buttonItem1 = UIBarButtonItem(title: "Seç", style: .done, target: self, action: #selector(pickerDoneButtonAction))
        buttonItem1.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], for: UIControlState())
        
        let buttonItem2 = UIBarButtonItem(title: "Kapat", style: .done, target: self, action: #selector(pickerCloseButtonAction))
        buttonItem2.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], for: UIControlState())
        
        toolbar.items = [buttonItem2, flexSpace, buttonItem1]
        toolbar.sizeToFit()
        
        furnaceTextField.inputAccessoryView = toolbar
        scrapTextField.inputAccessoryView = toolbar
    }
    
}

extension EntriesTableViewHeader: UIPickerViewDataSource {
    
    func numberOfComponents(in colorPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == furnacePickerView {
            return furnaces.count
        } else {
            return scraps.count
        }
    }
}

extension EntriesTableViewHeader: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == furnacePickerView {
            let furnace = furnaces[row]
            return furnace.name
        } else {
            let scrap = scraps[row]
            return scrap.name
        }
    }
}
