//
//  Alert.swift
//  HomeWork
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//
import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
