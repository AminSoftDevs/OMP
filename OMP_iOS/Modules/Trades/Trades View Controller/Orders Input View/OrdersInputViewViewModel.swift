//
//  NewOrdersInputViewViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import Foundation

protocol NewPotentialOrdersViewDelegate: AnyObject {
    func inputFieldCurrentValue(value: String, type: OrderInputType)
    func inputsTextFieldShouldUpdate()
}

extension NewPotentialOrdersViewDelegate {
    func inputsTextFieldShouldUpdate() {}
}

enum OrderInputType {
    case amount
    case price
}

class OrdersInputViewViewModel {
    
    var changedByTyping: Bool = false
    
    var changeRange: Double {
        switch getViewType {
        case .amount:
            if selectedMarket?.baseCurrency.id == "SHIB" {
                return 1000
            } else {
                return pow(10.0, Double(-(selectedMarket?.amountPrecision ?? 7)))
            }
        case .price:
            if selectedMarket?.baseCurrency.id == "SHIB" {
                if selectedMarket?.quoteCurrency.id == "IRR" {
                    return 0.01
                } else {
                    return 0.000001
                }
            } else {
                return pow(10.0, Double(selectedMarket?.unitPricePrecision ?? 6))
            }
        }
    }
    
    var precision: Int {
        switch getViewType {
        case .amount:
            return abs(selectedMarket?.amountPrecision ?? 7)
        case .price:
            if selectedMarket?.baseCurrency.id == "SHIB" {
                return 5
            }
            return abs(selectedMarket?.unitPricePrecision ?? 6)
        }
    }
    
    var textFieldValueHandler: String {
        get {
            if value == "" {
                return ""
            }
            
            switch type {
            case .price:
                if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                    if value.toDouble < 100000 {
                        return value.toDouble.changeToToman.format(f: 5).convertEngNumToPersianNum()
                    } else {
                        return "\(Int(value.toDouble))".toDouble.changeToRial.formattedWithSeparator.convertEngNumToPersianNum()
                    }
                } else {
                    return value.toDouble.format(f: 7).convertEngNumToPersianNum()
                }
            case .amount:
                if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                    if value.toDouble < 1 {
                        return value.toDouble.format(f: precision).removeZeroFromEnd.convertEngNumToPersianNum()
                    } else {
                        return value.toDouble.format(f: precision).convertEngNumToPersianNum()
                    }
                } else {
                    return value.toDouble.format(f: precision).convertEngNumToPersianNum()
                }
            }
        }
        
        set {
            if (newValue == ""){
                value = ""
            } else {
                switch type {
                case .price:
                    if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                        value = (newValue.removeComma.persianToEng().toDouble * 10).toString
                    } else {
                        value = newValue.removeComma.persianToEng()
                    }
                    delegate?.inputFieldCurrentValue(value: value, type: type)
                case .amount:
                    value = newValue.removeComma.persianToEng()
                    delegate?.inputFieldCurrentValue(value: value, type: type)
                }
            }
            changedByTyping = false
            delegate?.inputsTextFieldShouldUpdate()
        }
    }
    
    var value: String  = "" {
        didSet {
            if changedByTyping == false {
                delegate?.inputsTextFieldShouldUpdate()
            }
        }
    }
    
    var getViewType: OrderInputType {
        return type
    }
    
    var selectedMarket: Markets? {
        didSet {
            //textFieldValueHandler = ""
            changedByTyping = false
        }
    }
    
    weak var delegate: NewPotentialOrdersViewDelegate?
    
    //MARK: - INITIALIZER
    private let type: OrderInputType
    
    init(inputType: OrderInputType) {
        self.type = inputType
    }
    
    //MARK: - FUNCTIONS
    func getPlaceholder() -> String {
        switch type {
        case .amount:
            return "amount".localized + " (\(selectedMarket?.baseCurrency.id ?? DefaultCoin.base_currency_id))"
        case .price:
            if selectedMarket?.quoteCurrency.id == "IRR" {
                return "unitPrice".localized + " (IRT)"
            } else {
                return "unitPrice".localized + " (\(selectedMarket?.quoteCurrency.id ?? "IRT"))"
            }
        }
    }
    
    func handlePlusButtonAction() {
        changedByTyping = false
        let decimalValue = Decimal(string: value)
        if decimalValue != nil {
            let finalValue = decimalValue! + Decimal(changeRange)
            value = "\(finalValue)"
            delegate?.inputFieldCurrentValue(value: value, type: type)
            
        }
    }
    
    func handleMinusButtonAction() {
        changedByTyping = false
        let decimalValue = Decimal(string: value)
        if decimalValue == 0 {
            return
        }
        if decimalValue != nil {
            let finalValue = decimalValue! - Decimal(changeRange)
            value = "\(finalValue)"
            delegate?.inputFieldCurrentValue(value: value, type: type)
        }
    }
    
    func handleChangedByTyping(text: String) -> String {
        let newText = text.removeComma.persianToEng()
        
        switch type {
        case .price:
            if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                value = (newText.toDouble * 10).toString
            } else {
                value = newText
            }
            return newText.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
        case .amount:
            value = newText
            return newText.convertEngNumToPersianNum()
        }
    }
    
}
