//
//  Functions.swift
//  Hair CV
//
//  Created by Ivan Khau on 7/19/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import Foundation
import Firebase

func checkUser() {
    if FIRAuth.auth()!.currentUser != nil {
        
        var amigotypo = String()
        if stand.stringForKey("userType") == "Stylist" {
            amigotypo = "st"
        } else if stand.stringForKey("userType") == "User" {
            amigotypo = "us"
        }
        
        let queryRef = FIRDatabase.database().reference().child(amigotypo).child(FIRAuth.auth()!.currentUser!.uid)
        
        queryRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            MeasurementHelper.sendLoginEvent()
            
            signedIn = true
            myDict = snapshot.value as! NSMutableDictionary
            myDict.setValuesForKeysWithDictionary(["uid":FIRAuth.auth()!.currentUser!.uid])
            
            print(myDict)
            print(myDict)
            
            updateScore()
        })
    }
}

func updateScore() {
    if stand.stringForKey("userType") == "Stylist" {
        var barbScore:Double = 0
        var isSubscribed = false
        var isVerified = false
        //IS SUBSCRIBED?
        if myDict["su"] != nil {
            if myDict["su"] as! String == "true" {
                isSubscribed = true
            }
        }
        //VERIFICATION
        if myDict["ve"] != nil {
            if myDict["ve"] as! NSNumber == 1 {
                barbScore = barbScore + 10
                isVerified = true
            }
        }
        //PF IMAGE
        if myDict["iu"] != nil {
            barbScore = barbScore + 1
        }
        //PF SIDE IMAGE 1
        if myDict["iuo"] != nil {
            barbScore = barbScore + 1
        }
        //PF SIDE IMAGE 2
        if myDict["iut"] != nil {
            barbScore = barbScore + 1
        }
        //ABOUT
        if myDict["ab"] != nil {
            barbScore = barbScore + 1
        }
        //PHONE NUMBER
        if myDict["pn"] != nil {
            barbScore = barbScore + 2
        }
        //PRICE $-$$$
        if myDict["pr"] != nil {
            barbScore = barbScore + 2
        }

        var finScore:Double = barbScore
        if isSubscribed == true {
            finScore = finScore * 1.25
        }
        if isVerified == true {
            finScore = finScore * 1.10
        }
        
        // do something like if score doesn't equal current score update the value, and everytime score is different it updates. Probably should do a external function.
        
        if stand.doubleForKey("score") != finScore {
        let queryRef = FIRDatabase.database().reference().child("st").child(FIRAuth.auth()!.currentUser!.uid)
        queryRef.updateChildValues(["sc":finScore])
        myDict.setValuesForKeysWithDictionary(["sc":finScore])
        stand.setDouble(finScore, forKey: "score")
        }
    }
}

/*func getChatList(tableView: UITableView) {
    
    if FIRAuth.auth()?.currentUser != nil {
        
        let mesRef = queryRef.child("ch").child("re").child((FIRAuth.auth()?.currentUser!.uid)!).queryOrderedByChild("ts")
        
        mesRef.observeEventType(.Value, withBlock: { (snapo) -> Void in
            //self.snapArray.removeAll()
            
            var newItems = [FIRDataSnapshot]()
            
            for item in snapo.children {
                newItems.append(item as! FIRDataSnapshot)
            }
            
            print(snapArray)
            snapArray = newItems.reverse()
            //snapArray = snapArray.reverse()
            
            tableView.reloadData()
        })
    }
}*/


var myFollowing = [NSMutableDictionary]()
var followingReceived = false


func checkFollowed() {
    
    followingReceived = true
    myFollowing.removeAll()
    if FIRAuth.auth()!.currentUser != nil {
        
        let follRef = queryRef.child("fg").child((FIRAuth.auth()?.currentUser?.uid)!)
        follRef.observeSingleEventOfType(.Value, withBlock: { (snapo) in
            
            var newFollow = [NSMutableDictionary]()
            
            for item in snapo.children {
                
                let followItem = NSMutableDictionary()
                
                if let imageUrl = item.value!["iu"] {
                    followItem.setValuesForKeysWithDictionary(["iu":imageUrl])
                } else {
                    followItem.setValuesForKeysWithDictionary(["iu":""])
                }
                if let firstName = item.value!["fn"] {
                    followItem.setValuesForKeysWithDictionary(["fn":firstName])
                } else {
                    followItem.setValuesForKeysWithDictionary(["fn":""])
                }
                if let lastName = item.value!["ln"] {
                    followItem.setValuesForKeysWithDictionary(["ln":lastName])
                } else {
                    followItem.setValuesForKeysWithDictionary(["ln":""])
                }
                if let uido = item.value!["uid"] {
                    followItem.setValuesForKeysWithDictionary(["uid":uido])
                } else {
                    followItem.setValuesForKeysWithDictionary(["uid":""])
                }
                newFollow.append(followItem)
            }

            myFollowing = newFollow
            
        }) { (error) in
        }
    }
}

func getDate(type: String) -> Int {
    
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Hour, .Minute, .Month, .Day, .Year], fromDate: date)
    if type == "hour" {
        let hour = components.hour
        return hour
    } else if type == "minutes" {
        let minute = components.minute
        return minute
    } else if type == "month" {
        let month = components.month
        return month
    } else if type == "day" {
        let day = components.day
        return day
    } else if type == "year" {
        let year = components.year
        return year
    } else {
        return 0
    }
}

func betweenDates(startDate: NSDate, endDate: NSDate) -> [Int]
{
    let calendar = NSCalendar.currentCalendar()
    
    let components = calendar.components([.Day, .Hour, .Minute], fromDate: startDate, toDate: endDate, options: [])
    
    return [components.day,components.hour,components.minute]
    
}

func setPushID() {
    
    
    OneSignal.defaultClient().IdsAvailable { (userID, pushToken) in
        print(userID)
    }
    
    if stand.boolForKey("uploadPushID") == true {
        OneSignal.defaultClient().IdsAvailable({ (userId, pushToken) in
            NSLog("UserId:%@", userId)

            if stand.stringForKey("userType") == "User" {
                queryRef.child("us").child((FIRAuth.auth()?.currentUser?.uid)!).child("pu").setValue(userId!, withCompletionBlock: { (error, pushRefo) in
                    stand.setBool(false, forKey: "uploadPushID")
                    
                    myDict.setValuesForKeysWithDictionary(["pu":userId!])
                    
                })
            
            } else if stand.stringForKey("userType") == "Stylist" {
            queryRef.child("st").child((FIRAuth.auth()?.currentUser?.uid)!).child("pu").setValue(userId!, withCompletionBlock: { (error, pushRefo) in
                stand.setBool(false, forKey: "uploadPushID")
                
                myDict.setValuesForKeysWithDictionary(["pu":userId!])
                
            })
            }
            
            if (pushToken != nil) {
                NSLog("pushToken:%@", pushToken)
            }
        })
    }
}

