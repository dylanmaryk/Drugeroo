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
    @IBOutlet weak var notificationImageView: UIImageView!
    
    var pusher: Pusher!
    var channel: PusherChannel!
    
    private let marker = GMSMarker()
    private let pharmacyOrangeMarker = GMSMarker()
    private let pharmacyGreenMarker = GMSMarker()
    private let houseMarker = GMSMarker()
    
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
        
        pharmacyOrangeMarker.icon = UIImage(named: "pharmacyOrange")
        pharmacyOrangeMarker.position = CLLocationCoordinate2D(latitude: 52.53507, longitude: 13.39637)
        pharmacyOrangeMarker.map = mapView
        
        pharmacyGreenMarker.icon = UIImage(named: "pharmacyGreen")
        pharmacyGreenMarker.position = CLLocationCoordinate2D(latitude: 52.53507, longitude: 13.39637)
        
        houseMarker.icon = UIImage(named: "house")
        houseMarker.position = CLLocationCoordinate2D(latitude: 52.53032, longitude: 13.40332)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.set(notificationImage: UIImage(named: "notification-3"))
        })
    }
    
    private func onEventReceived() {
        pharmacyOrangeMarker.map = nil
        pharmacyGreenMarker.map = mapView
        
        set(notificationImage: UIImage(named: "notification-4"))
        
        let polyline = GMSPolyline(path: GMSPath(fromEncodedPath: "wkt_IclwpA`KsGlHwB~@fJ"))
        moveAlong(polyline: polyline) {
            self.set(notificationImage: UIImage(named: "notification-5"))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            self.pharmacyGreenMarker.map = nil
            self.houseMarker.map = self.mapView
            
            self.set(notificationImage: UIImage(named: "notification-6"))
            
            let polyline2 = GMSPolyline(path: GMSPath(fromEncodedPath: "gts_IgmwpANj@zDcD?wBhEcAI_FrP_NImI"))
            self.moveAlong(polyline: polyline2) {
                self.set(notificationImage: UIImage(named: "notification-7"))
                
                self.channel.trigger(eventName: "client-driver-arrived-event", data: [])
            }
        })
    }
    
    private func moveAlong(polyline: GMSPolyline, completion: @escaping (Void) -> Void) {
        for coordinateIndex in UInt(0) ..< (polyline.path?.count())! {
            let delay = Double(coordinateIndex * 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                CATransaction.begin()
                CATransaction.setAnimationDuration(1)
                self.marker.position = (polyline.path?.coordinate(at: coordinateIndex))!
                CATransaction.commit()
                
                if coordinateIndex == (polyline.path?.count())! - 1 {
                    completion()
                }
            })
        }
    }
    
    private func set(notificationImage: UIImage?) {
        UIView.transition(with: notificationImageView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.notificationImageView.image = notificationImage
        }, completion: nil)
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
