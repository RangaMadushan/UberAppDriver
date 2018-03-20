//
//  UberHandler.swift
//  Uber App For Driver
//
//  Created by Ranga Madushan on 3/19/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import Foundation
import FirebaseDatabase


/* mehem protocol ekak dammama eka thwa ekakdi delegate karnna nm
 me protocol eka athule func tika ehma aye handunwann ona yatin api ekad
 deleget karann hadan eke*/
protocol UberController: class {
    func acceptUber(lat: Double, long: Double);
    func riderCanceledUber();
    func uberCanceled();
}

class UberHandler {

    private static let _instance = UberHandler();
    
    weak var delegate: UberController?;
        var rider = "";
        var driver = "";
        var driver_id = "";
    
    static var Instance: UberHandler {
        return _instance;
    }
    
    func observeMessagesForDriver() {
        //RIDER REQUESTED AN UBER
        //here this behave like a trigger
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let latitude = data[Constants.LATITUDE] as? Double {
                
                    if let longitude = data[Constants.LONGITUDE] as? Double {
                        self.delegate?.acceptUber(lat: latitude, long: longitude);
                    
                    }
                }
                
                if let name = data[Constants.NAME] as? String{
                    self.rider = name;
                }
                
            }
            
            //RIDER CANCELLED UBER
            DBProvider.Instance.requestRef.observe(DataEventType.childRemoved, with: { (snapshot: DataSnapshot) in
               
                if let data = snapshot.value as? NSDictionary {
                    if let name = data[Constants.NAME] as? String{
                    
                        if name == self.rider {
                            self.rider = "";
                            self.delegate?.riderCanceledUber();
                        }
                    }
                }
            });
            
            
        }
        
        //DRIVER ACCEPT UBER
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
           if let data = snapshot.value as? NSDictionary {
                
            if let name = data[Constants.NAME] as? String {
            
                if name == self.driver {
                    self.driver_id = snapshot.key;
                }
            }
                
            }
            
        }
        
        
        // DRIVER CANCELED UBER
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childRemoved) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
            
                if let name = data[Constants.NAME] as? String{
                    if name ==  self.driver{
                    
                        self.delegate?.uberCanceled();
                    }
                }
            }
        }
        
    
    }// observeMessagesForDriver
    
    func uberAccepted(lat: Double, long: Double) {
        let data: Dictionary<String, Any> = [Constants.NAME: driver, Constants.LATITUDE: lat, Constants.LONGITUDE: long];
    
        DBProvider.Instance.requestAcceptedRef.childByAutoId().setValue(data);
        
    }//func uber accepted
    
    func cancelUberForDriver() {
        DBProvider.Instance.requestAcceptedRef.child(driver_id).removeValue();
    }
    
    
}//class




















