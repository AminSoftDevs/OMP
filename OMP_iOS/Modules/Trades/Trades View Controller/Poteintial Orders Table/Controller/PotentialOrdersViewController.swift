//
//  PotentialOrdersViewController.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 11/10/21.
//

import UIKit
import DropDown

class PotentialOrdersViewController: BaseViewController {
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PotentialOrderTableViewCell.self, forCellReuseIdentifier: PotentialOrderTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var tableViewTitlesStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var amountTitleLabel: UILabel = {
      var label = UILabel()
        label.configure(text: viewModel.amountTitle, fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var unitPriceTitleLabel: UILabel = {
      var label = UILabel()
        label.configure(text: viewModel.priceTitle, fontSize: 12, textColor: .textColor, textAlignment: .center, fontType: .regular)
        return label
    }()
    
    private lazy var orderTypeButton: UIButton = {
        var button = UIButton()
        button.configure(fontSize: 12, title: "OrdersSectionView.limitOrder".localized, fontType: .bold, titleColor: .textColor, backgroundColor: .clear, borderColor: .clear, cornerRadius: 15)
        button.imageEdgeInsets = dir == .leftToRight ? .init(top: 0, left: 20, bottom: 0, right: -20) : .init(top: 0, left: -20, bottom: 0, right: 20)
        button.setImage(UIImage(named: "arrow_down_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.addTarget(self, action: #selector(changeOrderTypeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.backgroundColor = .backgroundColor
        dropDown.textFont = UIFont(type: .regular, fontSize: 13)
        dropDown.textColor = .textColor
        dropDown.selectionBackgroundColor = .backgroundColor
        dropDown.selectedTextColor = .textColor
        dropDown.cornerRadius = 15
        dropDown.cellHeight = 40
        dropDown.cellNib = UINib(nibName: "DropDownCustomTableViewCell", bundle: nil)
        return dropDown
    }()
    
    private lazy var ordersInputStackView: UIStackView = {
       var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var totalPriceTextField: TextFieldWithPadding = {
        var textField = TextFieldWithPadding()
        textField.configure(placeholder: "total".localized, borderColor: .textColor, fontSize: 11, fontType: .regular, keyboardType: .numberPad, textAlignment: .center, radius: 10, backgroundColor: .clear, textColor: .textColor)
        textField.layer.borderWidth = 1
        textField.textPadding = .init(top: 3, left: 0, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(totalPriceTextFieldValueChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var walletUseSlider: CenteredThumbSlider = {
        var slider = CenteredThumbSlider()
        slider.setValue(0, animated: true)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.minimumTrackTintColor = .textColor
        slider.maximumTrackTintColor = .lightGray
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.isContinuous = false
        slider.setThumbImage(UIImage(named: "slider"), for: .normal)
        return slider
    }()
    
    private lazy var sliderStepsTitleStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var sliderImagesStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var availableInWalletLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "OrdersSectionView.available".localized + ":", fontSize: 13, textColor: .textColor, textAlignment: .right, fontType: .bold)
        return label
    }()
    
    private lazy var totalWalletLabel: UILabel = {
        var label = UILabel()
        label.configure(text: "-", fontSize: 13, textColor: .textColor, textAlignment: .left, fontType: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var setOrderButton: UIButton = {
        var button = UIButton()
        button.configure(fontSize: 12, title: "buy".localized, fontType: .regular, titleColor: .backgroundColor, backgroundColor: .submitGreenColor, borderColor: .clear, cornerRadius: 10)
        button.setTitle("sell", for: .selected)
        button.addTarget(self, action: #selector(setOrderButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let dir = Localization.sharedInstance.getlanguageDirection()
    
    lazy var unitPriceView = OrderInputView.makeInstance(type: .price)
    lazy var amountView = OrderInputView.makeInstance(type: .amount)

    weak var delegate: PotentialOrdersControllerViewModelProtocol?
    
    //MARK: - INITIALIZER
    let viewModel: PotentialOrdersControllerViewModel
    
    init(viewModel: PotentialOrdersControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor(.cardsColor)
        hideNavigationBar(true)
        view.layer.cornerRadius = 10
        createUI()
        dropDownActionsHandler()
        
        viewModel.getWalletsAPI()
        viewModel.getPotentialOrdersListAPI()
        viewModel.delegate = self
        
        unitPriceView.delegate = self
        amountView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.timer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startTimerToRefreshData()
    }
    
    //MARK: - CREATE UI
    private func createUI() {
        addingTableViewTitlesStackView()
        addingMainTableView()
        addingChangeOrderTypeButton()
        addingOrderTypeDropDown()
        addingOrdersInputStackView()
        ordersInputStackViewSubviews()
        addingMainSlider()
        addingStepTitleStackView()
        addingSliderImagesStackView()
        addingAvailableWallet()
        addingSetOrderButton()
    }
    
    private func addingTableViewTitlesStackView() {
        view.addSubview(tableViewTitlesStackView)
        tableViewTitlesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewTitlesStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            tableViewTitlesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableViewTitlesStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            tableViewTitlesStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        tableViewTitlesStackView.addArrangedSubview(amountTitleLabel)
        tableViewTitlesStackView.addArrangedSubview(unitPriceTitleLabel)
    }
    
    private func addingMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: tableViewTitlesStackView.bottomAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.58),
            mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    private func addingChangeOrderTypeButton() {
        view.addSubview(orderTypeButton)
        orderTypeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orderTypeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            orderTypeButton.leadingAnchor.constraint(equalTo: tableViewTitlesStackView.trailingAnchor, constant: 10),
            orderTypeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            orderTypeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addingOrdersInputStackView() {
        view.addSubview(ordersInputStackView)
        ordersInputStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ordersInputStackView.topAnchor.constraint(equalTo: orderTypeButton.bottomAnchor, constant: 10),
            ordersInputStackView.leadingAnchor.constraint(equalTo: mainTableView.trailingAnchor, constant: 5),
            ordersInputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            amountView.heightAnchor.constraint(equalToConstant: 55),
            unitPriceView.heightAnchor.constraint(equalToConstant: 55),
            totalPriceTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func ordersInputStackViewSubviews() {
        ordersInputStackView.addArrangedSubview(amountView)
        ordersInputStackView.addArrangedSubview(totalPriceTextField)
        if viewModel.executionType == .limit {
            ordersInputStackView.insertArrangedSubview(unitPriceView, at: 0)
        }
    }
    
    //MARK: - SLIDER
    private func addingMainSlider() {
        view.addSubview(walletUseSlider)
        walletUseSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            walletUseSlider.topAnchor.constraint(equalTo: ordersInputStackView.bottomAnchor, constant: 10),
            walletUseSlider.leadingAnchor.constraint(equalTo: ordersInputStackView.leadingAnchor, constant: 8),
            walletUseSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func addingStepTitleStackView() {
        view.addSubview(sliderStepsTitleStackView)
        sliderStepsTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderStepsTitleStackView.topAnchor.constraint(equalTo: walletUseSlider.bottomAnchor),
            sliderStepsTitleStackView.heightAnchor.constraint(equalToConstant: 20),
            sliderStepsTitleStackView.leadingAnchor.constraint(equalTo: ordersInputStackView.leadingAnchor, constant: 8),
            sliderStepsTitleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
        ])
        createLabels()
    }
    
    private func addingSliderImagesStackView() {
        view.addSubview(sliderImagesStackView)
        sliderImagesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderImagesStackView.topAnchor.constraint(equalTo: walletUseSlider.topAnchor, constant: 3),
            sliderImagesStackView.heightAnchor.constraint(equalToConstant: 20),
            sliderImagesStackView.leadingAnchor.constraint(equalTo: ordersInputStackView.leadingAnchor),
            sliderImagesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        createImages()
    }
    
    private func createLabels() {
        for i in 0...4 {
            let label = UILabel()
            label.configure(text: viewModel.sliderTitles[i] + "%", fontSize: 10, textColor: .textColor, textAlignment: .left, fontType: .regular)
            sliderStepsTitleStackView.addArrangedSubview(label)
        }
    }
    
    private func createImages() {
        for _ in 0...4 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "slider")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
            sliderImagesStackView.addArrangedSubview(imageView)
        }
    }
    
    private func addingAvailableWallet() {
        view.addSubview(availableInWalletLabel)
        availableInWalletLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalWalletLabel)
        totalWalletLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            availableInWalletLabel.topAnchor.constraint(equalTo: sliderStepsTitleStackView.bottomAnchor, constant: 20),
            availableInWalletLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            totalWalletLabel.topAnchor.constraint(equalTo: availableInWalletLabel.topAnchor, constant: 2),
            totalWalletLabel.leadingAnchor.constraint(equalTo: ordersInputStackView.leadingAnchor),
            totalWalletLabel.trailingAnchor.constraint(equalTo: availableInWalletLabel.leadingAnchor, constant: -4),
        ])
        availableInWalletLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        totalWalletLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func addingSetOrderButton() {
        view.addSubview(setOrderButton)
        setOrderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setOrderButton.topAnchor.constraint(equalTo: totalWalletLabel.bottomAnchor, constant: 15),
            setOrderButton.leadingAnchor.constraint(equalTo: mainTableView.trailingAnchor, constant: 5),
            setOrderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            setOrderButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func updateDataByRefreshController() {
        viewModel.updateByTimer()
    }
    
    //MARK: - OBJC FUNCTIONS
    @objc func changeOrderTypeButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectedOrderTypeButton()
        } else {
            normalizeOrderTypeButton()
        }
        dropDown.show()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let x = Double(round(sender.value)) / 100
        viewModel.updateValuesBySliderChanges(with: x)
    }
    
    @objc func setOrderButtonPressed(_ sender: UIButton) {
        viewModel.createNewOrderAPI()
    }
    
    @objc func totalPriceTextFieldValueChanged(_ sender: UITextField) {
        viewModel.totalPriceHolder = sender.text ?? ""
        sender.text = viewModel.totalPriceHolder
        viewModel.updateAmountField()
    }
    
    //MARK: - FUNCTIONS
    private func changeOrdersInputStackViewSubviews() {
        if viewModel.executionType == .market {
            ordersInputStackView.removeArrangedSubview(unitPriceView)
            unitPriceView.removeFromSuperview()
        } else {
            ordersInputStackView.insertArrangedSubview(unitPriceView, at: 0)
        }
    }
    
    private func normalizeOrderTypeButton() {
        orderTypeButton.backgroundColor = .clear
        orderTypeButton.layer.borderWidth = 0
        orderTypeButton.layer.borderColor = UIColor.clear.cgColor
        orderTypeButton.tintColor = .textColor
    }
    
    private func selectedOrderTypeButton() {
        orderTypeButton.backgroundColor = .backgroundColor
        orderTypeButton.layer.borderWidth = 1
        orderTypeButton.layer.borderColor = UIColor.submitButtonColor.cgColor
        orderTypeButton.tintColor = .submitButtonColor
    }
    
    func selectedMarketHandler(market: Markets) {
        viewModel.selectedMarket = market
        unitPriceView.selectedMarketHandler(market: market)
        amountView.selectedMarketHandler(market: market)
        viewModel.totalPriceHolder = ""
    }
    
    func changeBuyOrSellStatus(type: OrdersType ) {
        viewModel.buyOrSell = type
    }
    
    private func updateSetOrderButtonStyle() {
        if viewModel.buyOrSell == .buy {
            setOrderButton.setTitle("buy".localized, for: .normal)
            setOrderButton.backgroundColor = .submitGreenColor
        } else {
            setOrderButton.setTitle("sell".localized, for: .normal)
            setOrderButton.backgroundColor = .rejectOrangeColor
        }
    }
    
    private func addingOrderTypeDropDown() {
        dropDown.dataSource = viewModel.dropDownDataSource
        dropDown.anchorView = orderTypeButton
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.reloadAllComponents()
        
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? DropDownCustomTableViewCell else { return }
            
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.text = item
        }
        
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            self.orderTypeButton.setTitle(item, for: .normal)
            self.orderTypeButton.isSelected = false
            self.normalizeOrderTypeButton()
            self.viewModel.executionType = self.viewModel.executions[index]
        }
    }
    
    private func dropDownActionsHandler() {
        dropDown.cancelAction = { [weak self] in
            self?.orderTypeButton.isSelected = false
            self?.normalizeOrderTypeButton()
        }
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE
extension PotentialOrdersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemForSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PotentialOrderTableViewCell.identifier, for: indexPath) as! PotentialOrderTableViewCell
        cell.selectedMarket = viewModel.selectedMarket
        cell.potentialOrder = viewModel.getOrderForRowAt(indexPath: indexPath)
        cell.volumePercent = viewModel.getVolumePercentageToHighlightRow(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.getHeightForHeader(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PotentialOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelectedOrder(with: indexPath)
    }
}

//MARK: - MAKE INSTANCE METHOD
extension PotentialOrdersViewController {
    static func makeInstance() -> PotentialOrdersViewController {
        .init(viewModel: PotentialOrdersControllerViewModel())
    }
}

//MARK: - Potential Orders View Model Protocol
extension PotentialOrdersViewController: PotentialOrdersControllerViewModelProtocol {
    
    func updateTotalPriceField() {
        totalPriceTextField.text = viewModel.totalPriceHolder
    }
    
    func updateCurrentAmountField() {
        amountView.fieldValueUpdated(value: viewModel.amountValueHolder)
    }
    
    func updateUnitPriceField() {
        unitPriceView.fieldValueUpdated(value: viewModel.unitPriceHolder)
    }
    
    func updateWalletBaseAmount() {
        totalWalletLabel.text = viewModel.walletBaseAmountHolder
    }
    
    func updateWalletQuoteAmount() {
        totalWalletLabel.text = viewModel.walletQuoteAmountHolder
    }
    
    func handlingBuyOrSellStatus(type: OrdersType) {
        delegate?.handlingBuyOrSellStatus(type: type)
    }
    
    func updateSliderWithValue(value: Float) {
        walletUseSlider.setValue(value, animated: true)
    }
    
    func setOrderButtonNeedsUpdate() {
        updateSetOrderButtonStyle()
    }
    
    func ordersInputStackViewSubviewsShouldChange() {
        changeOrdersInputStackViewSubviews()
    }
    
    func updateTableTitles() {
        amountTitleLabel.text = viewModel.amountTitle
        unitPriceTitleLabel.text = viewModel.priceTitle
    }
    
    func tableViewShouldReload() {
        mainTableView.reloadData()
    }
    
    func refreshOpenOrders() {
        delegate?.refreshOpenOrders()
    }
    
    func stopRefreshControlOnParent() {
        delegate?.stopRefreshControlOnParent()
    }
}

extension PotentialOrdersViewController: NewPotentialOrdersViewDelegate {
    func inputFieldCurrentValue(value: String, type: OrderInputType) {
        print(value)
        viewModel.updatedValueFromInputView(value: value, type: type)
    }
}
