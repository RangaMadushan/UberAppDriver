//
//  DriverVC.swift
//  Uber App For Driver
//
//  Created by Ranga Madushan on 3/17/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import UIKit
import MapKit

class DriverVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController {
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var acceptUberBtn: UIButton!
    
    
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?;
//    private var riderLocation: CLLocationCoordinate2D?;

    private var acceptedUber = false;
    private var driverCanceledUber = false;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocationManager();
        UberHandler.Instance.delegate = self;
        UberHandler.Instance.observeMessagesForDriver();
    }
    
    

    private func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
    
    }// func initlize location
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude);
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            myMap.setRegion(region, animated: true);
            myMap.removeAnnotations(myMap.annotations);
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = userLocation!;
            annotation.title = "Driver Location";
            myMap.addAnnotation(annotation);
            
        }
    } //an overide func
    
    //methana thami protocol eka athule tiyen func liyala tiyenne
    func acceptUber(lat: Double, long: Double) {
        
        if !acceptedUber {
            uberRequest(title: "Uber Request", message: "You have a request for an uber at this location Lat: \(lat), Long: \(long)", requestAlive: true);
        }
        
    }//func accept uber
    
    
    func riderCanceledUber() {
        if !driverCanceledUber {
        //so then here cancel the uber from drivers perspective
            UberHandler.Instance.cancelUberForDriver();
            self.acceptedUber = false;
            self.acceptUberBtn.isHidden = true;
            uberRequest(title: "Uber Canceled", message: "The Rider Has Canceled The Uber", requestAlive: false);
        }
        
    }// func rider canceled uber
    
    func uberCanceled() {
        acceptedUber = false;
        acceptUberBtn.isHidden = true;
        //invalidate timer
        
    }
    
    
    @IBAction func cancelUber(_ sender: AnyObject) {
        
        if acceptedUber {
            driverCanceledUber = true;
            acceptUberBtn.isHidden = true;
            UberHandler.Instance.cancelUberForDriver();
            
            //invalidate timer
            
        }
        
    }//cancel uber
    
    
    @IBAction func logOut(_ sender: AnyObject) {
       
        if AuthProvider.Instance.logOut() {
        
        dismiss(animated: true, completion: nil)
            
        }else{
            //Problem with loging out
            uberRequest(title: "Could Not Logout", message: "We could not logout at the moment, please try again later", requestAlive: false);
            
          /*  self.alertTheUser(title: "Could Not Logout", message: "We could not logout at the moment, please try again later"); */
        }
        
    }//logout btn
    
    private func uberRequest(title: String, message: String, requestAlive: Bool){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        
        if requestAlive {
        
            let accept = UIAlertAction(title: "Accept", style: .default, handler: { (alertAction: UIAlertAction) in
                
                self.acceptedUber = true;
                self.acceptUberBtn.isHidden = false;
                
                //inform that we accepted the uber
                UberHandler.Instance.uberAccepted(lat: Double((self.userLocation?.latitude)!), long:Double((self.userLocation?.longitude)!));
                
            });
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil);
            
            alert.addAction(accept);
            alert.addAction(cancel);
            
        }else{
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
            alert.addAction(ok);
        }
        
        present(alert, animated: true, completion: nil);
    
    }

    
    /*
    private func alertTheUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    } //func alert user
    */

}// class



























