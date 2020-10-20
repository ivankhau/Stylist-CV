//
//  Constants.swift
//  Hair Dew
//
//  Created by Ivan Khau on 4/2/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import UIKit
import Firebase

var database: FIRDatabase!
var auth: FIRAuth!
var storage: FIRStorage!


let stand = NSUserDefaults.standardUserDefaults()
let queryRef = FIRDatabase.database().reference()
//var uidforchat:String? = nil

var dictforchat:NSMutableDictionary? = nil


var imageViewerDict:NSMutableDictionary? = nil


struct Constants {
    struct MessageFields {
        static let name = "id"
        static let text = "me"
        static let photoUrl = "photoUrl"
        static let imageUrl = "imageUrl"
    }
}

let SEPARATOR_COLOR = UIColor(white: 0.8, alpha: 1.0)

var signedIn = false
var myDict = NSMutableDictionary()

let phonewidth = UIScreen.mainScreen().bounds.width
let phoneheight = UIScreen.mainScreen().bounds.height
let Device = UIDevice.currentDevice()

var justSignedUp = false
var backupReviewAVG = Double()
var backupReviewCount = Int()




var backupImageDict:NSMutableDictionary? = nil



var window:UIWindow?
var isGranted = Bool()
var hasLocation:Bool = false




var locationAuthorizeButtonClicked = false

var currentUserLocation = CLLocation()

var selectedImageToSend:String? = nil

var justLoggedIn = false
var addedToPortfolio = false

var selfViewFromSearch = false

var locationSave:CLLocationCoordinate2D? = nil
var addressSave = NSDictionary()

var selectedLocation = 0

var needsFullAddress = 0


var selectedImg = NSMutableDictionary()


func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.drawInRect(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class DistanceCount: NSObject {
    
    let π: Double
    
    static let count = DistanceCount()
    
    private override init() {
        π = M_PI
    }
    
    func distance(lat1: Double, lon1: Double, lat2: Double, lon2: Double, units: String) -> Double {
        let θ = lon1 - lon2
        var distance = sin(º2rad(lat1)) * sin(º2rad(lat2)) + cos(º2rad(lat1)) * cos(º2rad(lat2)) * cos(º2rad(θ))
        distance = acos(distance)
        distance = rad2º(distance)
        switch units {
        case "M": distance *= (69.09*1)
        case "K": distance *= (69.09*1.60934)
        case "N": distance *= (69.09*0.868976)
        case "m": distance *= (69.09*1.60934*1000)
        default: distance *= (69.09*1)
        }
        return (distance);
    }
    
    private func º2rad(º: Double) -> Double {
        return (º * π / 180.0);
    }
    
    private func rad2º(rad: Double) -> Double {
        return (rad * 180 / π);
    }
}
