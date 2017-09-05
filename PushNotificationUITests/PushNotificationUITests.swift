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
        
        let springboard = XCUIApplication(privateWithPath: nil, bundleID: "com.apple.springboard")!
        springboard.resolve()
        
        allowPushNotificationsIfNeeded()
        
        XCTAssert(app.staticTexts["Welcome!"].exists)
        
        let deviceToken = app.staticTexts.element(matching: .any, identifier: "tokenLabel").label
        
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        sleep(1)
        
        // Test Red Push Notification
        triggerPushNotification(
            withPayload: "{\"aps\":{\"alert\":\"Hello Red\"}, \"vcType\":\"red\"}",
            deviceToken: deviceToken)
                
        springboard.otherElements["PUSHNOTIFICATION, now, Hello Red"].tap()
        
        XCTAssert(app.staticTexts["Red"].exists)
        app.buttons["Close"].tap()
        
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        sleep(1)
        
        // Test Green Push Notification
        triggerPushNotification(
            withPayload: "{\"aps\":{\"alert\":\"Hello Green\"}, \"vcType\":\"green\"}",
            deviceToken: deviceToken)
        
        springboard.otherElements["PUSHNOTIFICATION, now, Hello Green"].tap()
        
        XCTAssert(app.staticTexts["Green"].exists)
        app.buttons["Close"].tap()
        
        XCUIDevice.shared.press(XCUIDevice.Button.home)
        
        sleep(1)
        
        // Test Blue Push Notification
        triggerPushNotification(
            withPayload: "{\"aps\":{\"alert\":\"Hello Blue\"}, \"vcType\":\"blue\"}",
            deviceToken: deviceToken)
        
        springboard.otherElements["PUSHNOTIFICATION, now, Hello Blue"].tap()
        
        XCTAssert(app.staticTexts["Blue"].exists)
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
            print("CONNECTED")
            do {
                try pusher.pushPayload(payload, token: deviceToken, identifier: UInt(arc4random_uniform(UInt32(999))))
                print("Send PUSH")
            } catch {
                print("COULD NOT SEND PUSH")
            }
        } catch {
            print(error)
        }
    }

    func allowPushNotificationsIfNeeded() {
        addUIInterruptionMonitor(withDescription: "“RemoteNotification” Would Like to Send You Notifications") { (alerts) -> Bool in
            if(alerts.buttons["Allow"].exists){
                alerts.buttons["Allow"].tap();
            }
            return true;
        }
        XCUIApplication().tap()
    }
}
