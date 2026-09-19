//
//  URL.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/5/21.
//

import UIKit

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
    
    func isDeepLink() -> Bool {
        if let schema = self.scheme, schema.contains("http"), UIApplication.shared.canOpenURL(self) {
            return false
        } else {
            return true
        }
    }
}
