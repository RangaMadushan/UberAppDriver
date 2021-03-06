//
//  DBReference.swift
//  Uber App For Driver
//
//  Created by Ranga Madushan on 3/18/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    
    private static let _instance = DBProvider();
    
    static var Instance: DBProvider {
        return _instance;
    }
    
    
    //this is for give reference to the database
    var dbRef: DatabaseReference {
        return Database.database().reference();
    }
    
    var driversRef: DatabaseReference {
        return dbRef.child(Constants.DRIVERS);
    }
    
    
    //request ref
    var requestRef: DatabaseReference {
        return dbRef.child(Constants.UBER_REQUEST);
    }
    
    
    //request Accepted
    var requestAcceptedRef: DatabaseReference {
        return dbRef.child(Constants.UBER_ACCEPTED);
    }
    
    
    func saveUser(withID: String, email: String, password: String){
        
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isRider: false];
        
        driversRef.child(withID).child(Constants.DATA).setValue(data);
        
    }
    
}//class

































