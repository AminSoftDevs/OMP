//
//  WalletMockData.swift
//  OMP_iOS
//
//  Created by Moein Barzegaran on 9/29/21.
//

import Foundation

//struct WalletMockData {
//    private static let walletMockData = """
//            [{
//             "currency": {
//                            "id": "IRR",
//                            "name": "تومان",
//                            "description": null,
//                            "usdc_price": 250000,
//                            "irr_buy_price": 250000,
//                            "irr_sell_price": 260000,
//                            "withdraw_fee": 0,
//                            "minimum_withdraw_amount": 0,
//                            "icon_path": "https://cdn.countryflags.com/thumbs/iran/flag-round-250.png",
//                            "color": "#4caf50",
//                            "has_tag": false,
//                            "tag_label": "Memo"
//                        },
//                        "balance": "178254942.15179870",
//                        "blocked_balance": "0.00000000"
//            },
//                    {
//                     "currency": {
//                                    "id": "XRZ",
//                                    "name": "تزوس",
//                                    "description": null,
//                                    "usdc_price": 250000,
//                                    "irr_buy_price": 250000,
//                                    "irr_sell_price": 260000,
//                                    "withdraw_fee": 0,
//                                    "minimum_withdraw_amount": 0,
//                                    "icon_path": "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@9ab8d6934b83a4aa8ae5e8711609a70ca0ab1b2b/128/color/xtz.png",
//                                    "color": "#4caf50",
//                                    "has_tag": false,
//                                    "tag_label": "Memo"
//                                },
//                                "balance": "178254942.15179870",
//                                "blocked_balance": "0.00000000"
//                    },
//                            {
//                             "currency": {
//                                            "id": "XRZ",
//                                            "name": "تزوس",
//                                            "description": null,
//                                            "usdc_price": 250000,
//                                            "irr_buy_price": 250000,
//                                            "irr_sell_price": 260000,
//                                            "withdraw_fee": 0,
//                                            "minimum_withdraw_amount": 0,
//                                            "icon_path": "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@9ab8d6934b83a4aa8ae5e8711609a70ca0ab1b2b/128/color/eos.png",
//                                            "color": "#4caf50",
//                                            "has_tag": false,
//                                            "tag_label": "Memo"
//                                        },
//                                        "balance": "178254942.15179870",
//                                        "blocked_balance": "0.00000000"
//                            },
//                                    {
//                                     "currency": {
//                                                    "id": "XLM",
//                                                    "name": "استلار",
//                                                    "description": null,
//                                                    "usdc_price": 250000,
//                                                    "irr_buy_price": 250000,
//                                                    "irr_sell_price": 260000,
//                                                    "withdraw_fee": 0,
//                                                    "minimum_withdraw_amount": 0,
//                                                    "icon_path": "https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@9ab8d6934b83a4aa8ae5e8711609a70ca0ab1b2b/128/color/xlm.png",
//                                                    "color": "#4caf50",
//                                                    "has_tag": false,
//                                                    "tag_label": "Memo"
//                                                },
//                                                "balance": "178254942.15179870",
//                                                "blocked_balance": "0.00000000"
//                                    }
//        ]
//        """.data(using: .utf8)!
//    
//    private static let walletsMockData = """
//           
//        """.data(using: .utf8)!
//    
//    static func getWallet() -> [Wallet]? {
//        let decoder = JSONDecoder()
//        
//        do {
//            
//            let wallet = try decoder.decode([Wallet].self, from: WalletMockData.walletMockData)
//            return wallet
//            
//        } catch let error {
//            print(error)
//            return nil
//        }
//    }
//    
//    static func getWalletsList() -> [Wallet]? {
//        let decoder = JSONDecoder()
//        
//        do {
//            
//            let wallet = try decoder.decode([Wallet].self, from: WalletMockData.walletsMockData)
//            return wallet
//            
//        } catch let error {
//            print(error)
//            return nil
//        }
//    }
//}
