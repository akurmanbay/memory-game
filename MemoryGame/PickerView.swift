//
//  PickerView.swift
//  MemoryGame
//
//  Created by Ayan Kurmanbay on 5/7/20.
//  Copyright © 2020 Ayan Kurmanbay. All rights reserved.
//

import UIKit

final class PickerView: UIPickerView {
    
    // MARK: - Properties
    private let pickerLogic: PickerLogic
    
    // MARK: - Lifecycle
    init(pickerLogic: PickerLogic) {
        self.pickerLogic = pickerLogic
        super.init(frame: .zero)
        delegate = self
        dataSource = self
        
        pickerLogic.reloadComponent = { [weak self] component in
            self?.reloadComponent(component)
            self?.selectRow(0, inComponent: component, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UIPickerViewDelegate
extension PickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let widthProportion = pickerLogic.widthProportionForComponent(component)
        return pickerView.frame.width * widthProportion
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return pickerLogic.attributedTitleForRow(row, forComponent: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerLogic.didSelectRow(row, inComponent: component)
    }
    
}

// MARK: - UIPickerViewDataSource
extension PickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerLogic.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerLogic.numberOfRowsInComponent(component)
    }
    
}
