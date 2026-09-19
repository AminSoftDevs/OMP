//
//  OMP_iOSTests.swift
//  OMP_iOSTests
//
//  Created by soroush amini araste on 8/29/21.
//

import XCTest
@testable import OMP_iOS

class OMP_iOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChangeToRialExtension() {
        XCTAssertEqual(0.changeToRial, 0)
        XCTAssertEqual(100.changeToRial, 10)
        XCTAssertEqual(101.034.changeToRial, 10.103)
        XCTAssertEqual(10.234.changeToRial, 1.023)
        XCTAssertEqual(1.234.changeToRial, 0.123)
        XCTAssertEqual(-1.234.changeToRial, -0.123)
        
    }
    
    func testChangeToDecimal() {
        let n = Decimal(string: "101.034")?.significantFractionalDecimalDigits
        let j = Decimal(string: "101.000003")?.significantFractionalDecimalDigits
        let k = Decimal(string: "101.0")?.significantFractionalDecimalDigits
        XCTAssertEqual(n, 3)
        XCTAssertEqual(j, 6)
        XCTAssertEqual(k, 0)
    }
    
    func testOrderHistoryDecimal() {
        let baseCurrency = Currency(id: "LTC", name: nil, icon: nil, decimalPrecision: 8)
        let quoteCurrency = Currency(id: "IRR", name: nil, icon: nil, decimalPrecision: 0)
        
        let market = Market(id: 3, baseCurrency: baseCurrency, quoteCurrency: quoteCurrency, name: "لایت‌کوین - تومان", minPrice: nil, maxPrice: nil, lastPrice: nil, lastVolume: nil, dayChangePercent: nil, tradingViewSymbol: nil, liked: nil, base_currency_precision: 5, quote_currency_precision: 0)
        
        let order = Order(id: 100, type: "sell", market: market , amount: 4.96107, completedAmount: 4.95114786, price: 47275862.5, fee: 0.00992214, status: "COMPLETED", execution: "MARKET", createdAt: "2021-08-30 19:32:53.258812")
        
        let orderViewModel = OrderViewModel(order: order)
        
        XCTAssertEqual(order.id, orderViewModel.id)
        XCTAssertEqual(order.market.name, orderViewModel.name)
        XCTAssertEqual("4.96107".convertEngNumToPersianNum(), orderViewModel.amount)
    }
    
    func testRemovingZeroFromEnd() {
        let n = String("120".removeZeroFromEnd)
        let j = String("120.00".removeZeroFromEnd)
        let k = String("120.000010".removeZeroFromEnd)
        XCTAssertEqual(n, "120")
        XCTAssertEqual(j, "120")
        XCTAssertEqual(k, "120.00001")
    }
}
