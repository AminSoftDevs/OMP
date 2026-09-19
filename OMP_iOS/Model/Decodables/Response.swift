//
//  Response.swift
//  OMP_iOS
//
//  Created by soroush amini araste on 10/1/21.

import Foundation

struct Response<T: Decodable>: Decodable {
   let status: String
   let data: T
   let message: String?
}

struct BaseResponse: Decodable {
    let status: String
    let message: String?
}
