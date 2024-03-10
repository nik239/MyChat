//
//  Helpers.swift
//  MyChat
//
//  Created by Nikita Ivanov on 10/03/2024.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
