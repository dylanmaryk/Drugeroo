//
//  MapViewController.swift
//  Drugeroo
//
//  Created by Dylan Maryk on 10/06/2017.
//  Copyright © 2017 drugeroos. All rights reserved.
//

import GoogleMaps
import PusherSwift
import UIKit

class MapViewController: UIViewController, PusherDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    
    var pusher: Pusher!
    var channel: PusherChannel!
    
    private let marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pusher = Pusher(key: "b91115f15fb79204ed0d",
                        options: PusherClientOptions(authMethod: .endpoint(authEndpoint: "https://secure-temple-86252.herokuapp.com/pusher/auth"),
                                                     host: .cluster("eu")))
        pusher.delegate = self
        pusher.connect()
        
        channel = pusher?.subscribe("private-drugeroo-channel")
        
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: 52.53217, longitude: 13.40173))
        mapView.animate(toZoom: 15)
        
        marker.icon = UIImage(named: "marker")
        marker.map = mapView
        marker.appearAnimation = .pop
    }
    
    private func moveAlong(polyline: GMSPolyline) {
        marker.position = (polyline.path?.coordinate(at: 0))!
        
        for coordinateIndex in UInt(0) ..< (polyline.path?.count())! {
            let delay = Double(coordinateIndex * 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                CATransaction.begin()
                CATransaction.setAnimationDuration(1)
                self.marker.position = (polyline.path?.coordinate(at: coordinateIndex))!
                CATransaction.commit()
            })
        }
    }
    
    private func onEventReceived() {
        let polyline = GMSPolyline(path: GMSPath(fromEncodedPath: "wkt_IclwpA`KsGlHwB~@fJ"))
        moveAlong(polyline: polyline)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            let polyline2 = GMSPolyline(path: GMSPath(fromEncodedPath: "gvs_IoxwpA~@fJNj@zDcD?wBhEcAI_FrP_NImI"))
            self.moveAlong(polyline: polyline2)
        })
    }
    
    func subscribedToChannel(name: String) {
        channel.trigger(eventName: "client-doctor-pharmacy-event", data: [])
        channel.bind(eventName: "client-doctor-confirmed-event", callback: { (data: Any?) -> Void in
            self.onEventReceived()
        })
    }
    
    func debugLog(message: String) {
        print(message)
    }
}
