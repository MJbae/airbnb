//
//  NotificationName.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/28.
//

import Foundation

extension Notification.Name {
    static let selectDateDidChange = Notification.Name("selectDateDidChange")
    static let selectDateisChanging = Notification.Name("selectDateisChanging")
    static let moveSearchFlowNextStep = Notification.Name("moveSearchFlowNextStep")
    static let resetFiltering = Notification.Name("resetFiltering")
    static let personMinusButtonDidTap = Notification.Name("personMinusButtonDidTap")
    static let personPlustButtonDidTap = Notification.Name("personPlustButtonDidTap")
    static let userIsLogin = Notification.Name("userIsLogin")
    static let userIsLogout = Notification.Name("userIsLogout")
}
