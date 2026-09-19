//
//  HTTPTask.swift
//  OMP_iOS
//
//  Created by AminSoft on 7/1/1400 AP.
//


import Foundation

public typealias HTTPHeaderss = [String:String]

public enum HTTPTask<T: Encodable> {
    case urlRequest(urlParameters: Parameters)
    case jsonRequest(request: T)
    case jsonAndURLRequest(urlParameters: Parameters, request: T)
}


