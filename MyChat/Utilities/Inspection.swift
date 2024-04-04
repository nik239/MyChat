//
//  Inspection.swift
//  MyChat
//
//  Created by Nikita Ivanov on 03/04/2024.
//

#if DEBUG
import Combine
import SwiftUI

internal final class Inspection<V> {

    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()

    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
#endif
