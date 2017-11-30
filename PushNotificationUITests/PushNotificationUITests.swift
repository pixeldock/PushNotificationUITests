//
//  PushNotificationUITests.swift
//  PushNotificationUITests
//
//  Created by Jörn Schoppe on 09.07.17.
//  Copyright © 2017 pixeldock. All rights reserved.
//

import XCTest
import PusherKit

class PushNotificationUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testPushNotifications() {
        let app = XCUIApplication()
        app.launchArguments.append("isRunningUITests")
        app.launch()
        
        // access to the springboard (to be able to tap the notification later)
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        // dismiss the system dialog if it pops up
        allowPushNotificationsIfNeeded()
        
        // get the current deviceToken from the app
        let deviceToken = app.staticTexts.element(matching: .any, identifier: "tokenLabel").label
        
        // close app
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(1)
        
        // trigger red Push Notification
        triggerPushNotification(
            withPayload: "{\"aps\":{\"alert\":\"Hello Red\"}, \"vcType\":\"red\"}",
            deviceToken: deviceToken)
                
        // tap on the notification when it is received
        springboard.otherElements["PUSHNOTIFICATION, now, Hello Red"].tap()
        
        // check if the red view controller is shown
        XCTAssert(app.staticTexts["Red"].exists)
        
        // dismiss modal view controller and close app
        app.buttons["Close"].tap()
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(1)
        
        // trigger green Push Notification
        triggerPushNotification(
            withPayload: "{\"aps\":{\"alert\":\"Hello Green\"}, \"vcType\":\"green\"}",
            deviceToken: deviceToken)
        
        // tap on the notification when it is received
        springboard.otherElements["PUSHNOTIFICATION, now, Hello Green"].tap()
        
        // check if the green view controller is shown
        XCTAssert(app.staticTexts["Green"].exists)
        
        // dismiss modal view controller and close app
        app.buttons["Close"].tap()
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        sleep(1)
        
        // trigger blue Push Notification
        triggerPushNotification(
            withPayload: "{\"aps\":{\"alert\":\"Hello Blue\"}, \"vcType\":\"blue\"}",
            deviceToken: deviceToken)
        
        // tap on the notification when it is received
        springboard.otherElements["PUSHNOTIFICATION, now, Hello Blue"].tap()
        
        // check if the blue view controller is shown
        XCTAssert(app.staticTexts["Blue"].exists)
        
        // dismiss modal view controller 
        app.buttons["Close"].tap()
    }
}

extension XCTestCase {
    func triggerPushNotification(withPayload payload: String, deviceToken: String) {
        let uiTestBundle = Bundle(for: PushNotificationUITests.self)
        guard let url = uiTestBundle.url(forResource: "pusher.p12", withExtension: nil) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let pusher = try NWPusher.connect(withPKCS12Data: data, password: "pusher", environment: .auto)
            try pusher.pushPayload(payload, token: deviceToken, identifier: UInt(arc4random_uniform(UInt32(999))))
        } catch {
            print(error)
        }
    }

    func allowPushNotificationsIfNeeded() {
        addUIInterruptionMonitor(withDescription: "Remote Authorization") { (alerts) -> Bool in
            if(alerts.buttons["Allow"].exists){
                alerts.buttons["Allow"].tap()
                return true
            }
            return false
        }
        XCUIApplication().tap()
    }
}
