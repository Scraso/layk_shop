//
//  ErrorHandler.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/17/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

enum NewOrderErrors: Error {
    case invalidName
    case invalidPhone
    case invalidDeliveryAddress
    case invalidCity
}

extension NewOrderErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidName:
            return NSLocalizedString("Имя не может быть пустое", comment: "Пожалуйста, попробуйте еще раз")
        case .invalidPhone:
            return NSLocalizedString("Телефон не может быть пустой", comment: "Пожалуйста, попробуйте еще раз")
        case .invalidDeliveryAddress:
            return NSLocalizedString("Адрес почты не может пусть пустой", comment: "Пожалуйста, попробуйте еще раз")
        case .invalidCity:
            return NSLocalizedString("Город не может быть пустой", comment: "Пожалуйста, попробуйте еще раз")
        }
    }
}
