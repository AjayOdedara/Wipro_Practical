//
//  Bindable.swift
//  HomeWork
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

class Bindable<T> {
    typealias Listener = ((T) -> Void)
    var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ val: T) {
        self.value = val
    }

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

}
