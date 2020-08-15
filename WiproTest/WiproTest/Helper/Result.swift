//
//  Result.swift
//  HomeWork
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

enum Result<T, U: Error> {
    case success(payload: T)
    case failure(U?)
}

enum EmptyResult<U: Error> {
    case success
    case failure(U?)
}
