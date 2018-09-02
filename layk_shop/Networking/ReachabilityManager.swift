//
//  ReachabilityManager.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 8/27/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import Reachability

// Protocol for listenig network status change
public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.Connection)
}

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaCellular)
    var reachabilityStatus: Reachability.Connection = .none
    
    // 5. Reachability instance for Network status monitoring
    let reachability = Reachability()!
    
    // Called whenever there is a change in NetworkReachibility Status
    //
    // — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            print("Network became unreachable")
        case .wifi:
            print("Network reachable through WiFi")
        case .cellular:
            print("Network reachable through Cellular Data")
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
        
        // Assign NetWork status to load it lately in viewDiDLoad once one of the Tab Bar Controller is loaded
        reachabilityStatus = reachability.connection
        
    }
    
    // Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    // Stops monitoring the network availability status
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    // 6. Array of delegates which are interested to listen to network status change
    var listeners = [NetworkStatusListener]()
    
    // Adds a new listener to the listeners array
    //
    // - parameter delegate: a new listener
    func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }

    // Removes a listener from listeners array
    //
    // - parameter delegate: the listener which is to be removed
    func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter{ $0 !== listener}
    }

}
