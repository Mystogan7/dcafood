//
//  Observer.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import Foundation

protocol Observer: AnyObject {
    associatedtype Value
    var valueDidChange: ((Value) -> Void)? { get set }
}

class ClosureObserver<T>: Observer {
    typealias Value = T
    var valueDidChange: ((T) -> Void)?

    init(_ closure: @escaping (T) -> Void) {
        valueDidChange = closure
    }
}

class Observable<T> {
    typealias Observer = ClosureObserver<T>
    
    private var observers: [Observer] = []

    var value: T {
        didSet {
            notifyObservers()
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func addObserver(_ observer: Observer) {
        observers.append(observer)
    }

    func removeObserver(_ observer: Observer) {
        observers.removeAll { $0 === observer }
    }

    private func notifyObservers() {
        observers.forEach { $0.valueDidChange?(value) }
    }
}
