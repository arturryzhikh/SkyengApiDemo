//
//  ReuseIdentifiable.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//


protocol ReuseIdentifiable {
    static var reuseId: String { get }
}

extension ReuseIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}
