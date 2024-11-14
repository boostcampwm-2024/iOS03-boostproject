//
//  Response.swift
//  HGDNetwork
//
//  Created by 윤지성 on 11/7/24.
//

import Foundation

public final class SNMNetworkResponse {
    public let statusCode: Int
    public let data: Data
    public let response: HTTPURLResponse?
    
    public init(statusCode: Int, data: Data, response: HTTPURLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.response = response
    }
}

extension SNMNetworkResponse: CustomDebugStringConvertible, Equatable {
    public var description: String {
        "Status Code: \(statusCode), Data Length: \(data.count)"
    }
    
    public var debugDescription: String { description }
    
    public static func == (lhs: SNMNetworkResponse, rhs: SNMNetworkResponse) -> Bool {
        lhs.statusCode == rhs.statusCode
        && lhs.data == rhs.data
        && lhs.response == rhs.response
    }
}
