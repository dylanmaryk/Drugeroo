//
//  ViewController.swift
//  Drugeroo
//
//  Created by Dylan Maryk on 10/06/2017.
//  Copyright © 2017 drugeroos. All rights reserved.
//

import PusherSwift
import UIKit

class ViewController: UIViewController, PusherDelegate {
    @IBOutlet var tabBar: UITabBar!
    
    var pusher: Pusher!
    var channel: PusherChannel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pusher = Pusher(key: "b91115f15fb79204ed0d",
                        options: PusherClientOptions(authMethod: .endpoint(authEndpoint: "https://secure-temple-86252.herokuapp.com/pusher/auth"),
                                                     host: .cluster("eu")))
        pusher.delegate = self
        pusher.connect()
        
        channel = pusher?.subscribe("private-my-channel")
        
        tabBar.selectedItem = tabBar.items?.first
    }
    
    func subscribedToChannel(name: String) {
        channel.trigger(eventName: "client-my-event", data: ["key" : "value"])
    }
    
    func debugLog(message: String) {
        print(message)
    }
}

