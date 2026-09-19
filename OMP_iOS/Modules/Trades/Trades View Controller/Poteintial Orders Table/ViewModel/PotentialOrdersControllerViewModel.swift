//
//  PotentialOrdersControllerViewModel.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import UIKit

protocol PotentialOrdersControllerViewModelProtocol: AnyObject {
    func tableViewShouldReload()
    func updateTableTitles()
    func ordersInputStackViewSubviewsShouldChange()
    
    func setOrderButtonNeedsUpdate()
    func updateSliderWithValue(value: Float)
    func handlingBuyOrSellStatus(type: OrdersType)
    func refreshOpenOrders()
    
    func updateTotalPriceField()
    func updateCurrentAmountField()
    func updateUnitPriceField()
    func updateWalletQuoteAmount()
    func updateWalletBaseAmount()
    func stopRefreshControlOnParent()
}

extension PotentialOrdersControllerViewModelProtocol {
    func tableViewShouldReload() {}
    func updateTableTitles() {}
    func ordersInputStackViewSubviewsShouldChange() {}
    
    func setOrderButtonNeedsUpdate() {}
    func updateSliderWithValue(value: Float) {}
    func handlingBuyOrSellStatus(type: OrdersType) {}
    func refreshOpenOrders() {}
    
    
    func updateTotalPriceField() {}
    func updateCurrentAmountField() {}
    func updateUnitPriceField() {}
    func updateWalletQuoteAmount() {}
    func updateWalletBaseAmount() {}
    func stopRefreshControlOnParent() {}
}

class PotentialOrdersControllerViewModel {
    
    var sellVolume: Double = 1
    var buyVolume: Double = 1
    
    var potentialOrderRequestInProgress: Bool = false
    var getWalletRequestInProgress: Bool = false
    
    var timer = Timer()
    
    var wallets: [Wallet] = [] {
        didSet {
            userWalletAmountHandler()
        }
    }
    
    private var potentialOrders: [PotentialOrders] = []
    
    //MARK: - NEW APPROACH
    var unitPriceHolder: String {
        get {
            if unitPrice == "" {
                return ""
            } else {
                return unitPrice
            }
        }
        set {
            if newValue == "" {
                unitPrice = newValue
            } else {
                if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                    unitPrice = (newValue.removeComma.persianToEng().toDouble).toString
                } else {
                    unitPrice = (newValue.removeComma.persianToEng().toDouble).toString
                }
            }
        }
    }
    
    var amountValueHolder: String {
        get {
            if currentAmount == "" {
                return ""
            } else {
                return currentAmount
            }
        }
        set {
            if newValue == "" {
                currentAmount = newValue
            } else {
                currentAmount = newValue.removeComma.persianToEng()
            }
        }
    }
    
    var totalPriceHolder: String {
        get {
            if totalPrice == "" {
                return ""
            } else {
                if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                    return "\(Int(totalPrice.toDouble))".toDouble.changeToToman.formattedWithSeparator.convertEngNumToPersianNum()
                } else {
                    return totalPrice.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
                }
            }
        }
        set {
            if newValue == "" {
                totalPrice = newValue
            } else {
                if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                    totalPrice = (newValue.removeComma.persianToEng().toDouble * 10).toString
                } else {
                    totalPrice = (newValue.removeComma.persianToEng().toDouble).toString
                }
            }
        }
    }
    
    var walletQuoteAmountHolder: String {
        get {
            if walletQuoteAmount == "" {
                return "-"
            } else {
                if selectedMarket?.quoteCurrency.id == "IRR" || selectedMarket == nil {
                    return "\(Int(walletQuoteAmount.toDouble))".toDouble.changeToToman.formattedWithSeparator.convertEngNumToPersianNum()
                } else {
                    return walletQuoteAmount.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
                }
            }
        }
    }
    
    var walletBaseAmountHolder: String {
        get {
            if walletBaseAmount.toDouble < 1 {
                return walletBaseAmount.convertEngNumToPersianNum()
            } else {
                return walletBaseAmount.toDouble.formattedWithSeparator.convertEngNumToPersianNum()
            }
        }
    }
    
    private var totalPrice: String = "" {
        didSet {
            delegate?.updateTotalPriceField()
            updateSliderPosition()
        }
    }
    
    private var currentAmount: String = "" {
        didSet {
            delegate?.updateCurrentAmountField()
        }
    }
    
    private var unitPrice: String = "" {
        didSet {
            delegate?.updateUnitPriceField()
        }
    }
    
    private var walletBaseAmount: String = "-" {
        didSet {
            delegate?.updateWalletBaseAmount()
        }
    }
    
    private var walletQuoteAmount: String = "-" {
        didSet {
            delegate?.updateWalletQuoteAmount()
        }
    }
    
    func updatedValueFromInputView(value: String, type: OrderInputType) {
        switch type {
        case .amount:
            amountValueHolder = value
        case .price:
            unitPriceHolder = value
        }
        updateTotalPriceByUnitPriceChangeAndAmountChange()
    }
    
    
    //MARK: - END OF NEW APPROACH
    var selectedMarket: Markets? {
        didSet {
            currentAmount = ""
            unitPrice = ""
            totalPrice = ""
            getPotentialOrdersListAPI()
            getWalletsAPI()
            delegate?.updateTableTitles()
        }
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    var amountTitle: String {
        let amount = "amount".localized
        return amount + " (\(selectedMarket?.baseCurrency.id ?? DefaultCoin.base_currency_id))"
    }
    
    var priceTitle: String {
        let price = "unitPrice".localized
        if selectedMarket?.quoteCurrency.id == "IRR" {
            return price + " (IRT)"
        } else {
            return price + " (\(selectedMarket?.quoteCurrency.id ?? "IRT"))"
        }
    }
    
    var executionType: Execution = .limit {
        didSet {
            delegate?.ordersInputStackViewSubviewsShouldChange()
        }
    }
    
    var dropDownDataSource: [String] {
        return executions.map({ $0.stringFromType()})
    }
    
    var buyOrSell: OrdersType = .buy {
        didSet {
            delegate?.setOrderButtonNeedsUpdate()
            userWalletAmountHandler()
        }
    }
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    var sliderTitles: [String] {
        if dir == .rightToLeft {
            return ["0","25","50","75","100"].map({$0.convertEngNumToPersianNum()})
        } else {
            return Array(["0","25","50","75","100"].map({$0.convertEngNumToPersianNum()}).reversed())
        }
    }
    
    let executions: [Execution] = [.limit, .market]
    
    weak var delegate: PotentialOrdersControllerViewModelProtocol?
    
    //MARK: - FUNCTIONS
    func getNumberOfItemForSection(section: Int) -> Int {
        switch section {
        case 0:
            return potentialOrders.filter({ $0.type == .sell}).count
        case 1:
            return potentialOrders.filter({ $0.type == .buy}).count
        default:
            return 0
        }
    }
    
    func getOrderForRowAt(indexPath: IndexPath) -> PotentialOrders? {
        switch indexPath.section {
        case 0:
            return potentialOrders.filter({ $0.type == .sell})[indexPath.row]
        case 1:
            return potentialOrders.filter({ $0.type == .buy})[indexPath.row]
        default:
            return nil
        }
    }
    
    func getVolumePercentageToHighlightRow(indexPath: IndexPath) -> Double {
        switch indexPath.section {
        case 0:
            let item = potentialOrders.filter({ $0.type == .sell})[indexPath.row]
            return (item.amount.toDouble * item.price) / sellVolume
        case 1:
            let item = potentialOrders.filter({ $0.type == .buy})[indexPath.row]
            return (item.amount.toDouble * item.price) / buyVolume
        default:
            return 1
        }
    }
    
    func getHeightForHeader(section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
    
    func prepareOrders(potentialOrders: [PotentialOrders]){
        var tempResult: [PotentialOrders] = []
        let sellArray = potentialOrders.filter { $0.type == .sell && $0.myOrder == false }.sorted(by: {$0.price < $1.price}).prefix(6).reversed()
        let buyArray = potentialOrders.filter { $0.type == .buy && $0.myOrder == false }.sorted(by: {$0.price > $1.price}).prefix(6)
        tempResult.append(contentsOf: sellArray)
        tempResult.append(contentsOf: buyArray)
        self.potentialOrders = tempResult
        calculateVolumeOfOrders(potentialOrders: potentialOrders)
    }
    
    private func calculateVolumeOfOrders(potentialOrders: [PotentialOrders]) {
        var buyVolume: [Double] = []
        var sellVolume: [Double] = []
        
        for item in potentialOrders {
            if item.type == .sell {
                sellVolume.append(item.amount.toDouble * item.price)
            } else {
                buyVolume.append(item.amount.toDouble * item.price)
            }
        }
        self.buyVolume = buyVolume.max() ?? 0
        self.sellVolume = sellVolume.max() ?? 0
        print("#Volume", buyVolume, " / ", sellVolume)
        delegate?.tableViewShouldReload()
    }
    
    func handleSelectedOrder(with indexPath: IndexPath) {
        var totalAmount: Decimal = 0
        if let selectedOrder = getOrderForRowAt(indexPath: indexPath) {
            switch selectedOrder.type {
            case .buy:
                //yeah it's opposite
                buyOrSell = .sell
                let orders = Array(potentialOrders.filter({$0.type == .buy}))
                let price = selectedOrder.price
                for i in 0...indexPath.row {
                    totalAmount += Decimal(orders[i].amount.toDouble)
                }
                let formattedTotalAmount = (totalAmount as NSDecimalNumber).doubleValue.toString
                
                totalPrice = (price * (totalAmount as NSDecimalNumber).doubleValue).toString
                unitPrice = selectedOrder.price.toString
                currentAmount = formattedTotalAmount
            case .sell:
                //yeah it's opposite
                buyOrSell = .buy
                let orders = potentialOrders.filter({$0.type == .sell})
                let price = selectedOrder.price
                for i in indexPath.row...orders.count - 1 {
                    totalAmount += Decimal(orders[i].amount.toDouble)
                }
                let formattedTotalAmount = (totalAmount as NSDecimalNumber).doubleValue.toString
                
                totalPrice = (price * (totalAmount as NSDecimalNumber).doubleValue).toString
                unitPrice = selectedOrder.price.toString
                currentAmount = formattedTotalAmount
            }
            
            delegate?.handlingBuyOrSellStatus(type: buyOrSell)
        }
    }
    
    func userWalletAmountHandler() {
        let baseCurrencyID: String = selectedMarket?.baseCurrency.id ?? DefaultCoin.base_currency_id
        let quoteCurrencyID: String = selectedMarket?.quoteCurrency.id ?? DefaultCoin.quote_currency_id
        
        switch buyOrSell {
        case .buy:
            if let index = wallets.firstIndex(where: {$0.currency.id == quoteCurrencyID}){
                walletQuoteAmount = wallets[index].balance
            }
        case .sell:
            if let index = wallets.firstIndex(where: {$0.currency.id == baseCurrencyID}){
                walletBaseAmount = wallets[index].balance
            }
        }
    }
    
    func updateAmountField() {
        currentAmount = (totalPrice.toDouble / unitPrice.toDouble).toString
    }
    
    func updateTotalPriceByUnitPriceChangeAndAmountChange() {
        totalPrice = (unitPrice.toDouble * currentAmount.toDouble).toString
    }
    
    func updateValuesBySliderChanges(with value: Double) {
        if UserDefaults.standard.isLogin == false {
            return
        }
        if buyOrSell == .buy {
            totalPrice = (walletQuoteAmount.toDouble * value).toString
            currentAmount = (totalPrice.toDouble / unitPrice.toDouble).toString
        } else {
            currentAmount = (walletBaseAmount.toDouble * value).toString
            totalPrice = (currentAmount.toDouble * unitPrice.toDouble).toString
        }
    }
    
    func updateSliderPosition() {
        if UserDefaults.standard.isLogin == false {
            return
        }
        if buyOrSell == .buy {
            if walletQuoteAmount.toDouble <= totalPrice.toDouble {
                delegate?.updateSliderWithValue(value: 100)
            } else {
                let position = Float(totalPrice.toDouble / walletQuoteAmount.toDouble) * 100
                delegate?.updateSliderWithValue(value: position)
            }
        } else {
            if walletBaseAmount.toDouble <= currentAmount.toDouble {
                delegate?.updateSliderWithValue(value: 100)
            } else {
                let position = Float(currentAmount.toDouble / walletBaseAmount.toDouble) * 100
                delegate?.updateSliderWithValue(value: position)
            }
        }
    }
    
    func startTimerToRefreshData() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateByTimer), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func updateByTimer() {
        if potentialOrderRequestInProgress == false {
            getPotentialOrdersListAPI()
        }
        
        if getWalletRequestInProgress == false {
            getWalletsAPI()
        }
    }
    
    func updateWalletsAmountByAddingNewOrder() {
        if getWalletRequestInProgress == false {
            getWalletsAPI()
        }
    }
    
    //MARK: - FUNCTIONS
    func getPotentialOrdersListAPI() {
        potentialOrderRequestInProgress = true
        PotentialOrdersService.getPotentialOrders(request: .init(id: selectedMarket?.id ?? 1)) { [weak self] results in
            guard let self = self else { return }
            self.delegate?.stopRefreshControlOnParent()
            self.potentialOrderRequestInProgress = false
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.prepareOrders(potentialOrders: responseModel.data)
                case let .validation(error: errorModel):
                    if let idError  = errorModel.errors.id {
                        Popup.showError(body: idError.createErrorMessage())
                    }
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
    
    //MARK: - API
    func getWalletsAPI() {
        if UserDefaults.standard.isLogin == false {
            return
        }
        getWalletRequestInProgress = true
        UserWalletService.getUserWallets { [weak self] results in
            guard let self = self else { return }
            self.getWalletRequestInProgress = false
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case let .success(response: responseModel):
                    self.wallets = responseModel.data
                default:
                    print("will be empty")
                }
            case let .failure(error):
                print(error.localizedStrings)
            }
        }
    }
    
    func createNewOrderAPI() {
        let marketID = selectedMarket?.id ?? DefaultCoin.id
        let price: String = executionType == .market ? totalPrice : unitPrice
        let type: String = buyOrSell == .sell ? OrdersType.sell.rawValue : OrdersType.buy.rawValue
        NewOrderService.createNewOrder(request: .init(marketID: marketID, amount: currentAmount, price: price, type: type, execution: executionType.rawValue)) { [weak self] results in
            guard let self = self else { return }
            self.updateWalletsAmountByAddingNewOrder()
            switch results {
            case let .success(responseReceived):
                switch responseReceived {
                case .success(response: _):
                    self.delegate?.refreshOpenOrders()
                case let .validation(error: errorModel):
                    var errorMessage = ""
                    if let priceError  = errorModel.errors.price {
                        errorMessage = priceError.createErrorMessage() + "\n"
                    }
                    if let amountError = errorModel.errors.amount {
                        errorMessage += amountError.createErrorMessage()
                    }
                    Popup.showError(body: errorMessage)
                }
            case let .failure(error):
                Popup.showError(body: error.localizedStrings)
            }
        }
    }
}
