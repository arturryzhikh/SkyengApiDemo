//
//  String+Extensiins.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 19.12.2021.
//

extension String {
    var isValid: Bool {
        return !self.isEmpty && self.first != " " && self.last != " "
    }
}
