//
//  NetworkSeatching.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation


public protocol NetworkSearching: AnyObject {
    
    init(networkService: Networking)
    
    var networkService: Networking { get  }
    
}

