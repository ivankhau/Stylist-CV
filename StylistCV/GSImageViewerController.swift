//
//  GSImageViewerController.swift
//  Hair CV
//
//  Created by Ivan Khau on 4/17/16.
//  Copyright © 2016 Peer Goggles. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

public struct GSImageInfo {
    
    public enum ImageMode : Int {
        case AspectFit  = 1
        case AspectFill = 2
    }
    
    public let image     : UIImage
    public let imageMode : ImageMode
    public var imageHD   : NSURL?
    
    public var contentMode : UIViewContentMode {
        return UIViewContentMode(rawValue: imageMode.rawValue)!
    }
    
    public init(image: UIImage, imageMode: ImageMode) {
        self.image     = image
        self.imageMode = imageMode
    }
    
    public init(image: UIImage, imageMode: ImageMode, imageHD: NSURL?) {
        self.init(image: image, imageMode: imageMode)
        self.imageHD = imageHD
    }
    
    func calculateRect(size: CGSize) -> CGRect {
        
        let widthRatio  = size.width  / image.size.width
        let heightRatio = size.height / image.size.height
        
        switch imageMode {
            
        case .AspectFit:
            
            return CGRect(origin: CGPointZero, size: size)
            
        case .AspectFill:
            
            return CGRect(
                x      : 0,
                y      : 0,
                width  : image.size.width  * max(widthRatio, heightRatio),
                height : image.size.height * max(widthRatio, heightRatio)
            )
            
        }
    }
    
    func calculateMaximumZoomScale(size: CGSize) -> CGFloat {
        return max(2, max(
            image.size.width  / size.width,
            image.size.height / size.height
            ))
    }
    
}

public class GSTransitionInfo {
    
    public var duration: NSTimeInterval = 0.35
    
    public init(fromView: UIView) {
        self.fromView = fromView
    }
    
    weak var fromView : UIView?
    
    private var convertedRect : CGRect?
    
}

public class GSImageViewerController: UIViewController {
    
    // GOOBER BOOB BUTT
    // GOOBER BOOB BUTT
    private var textLabel1 = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 140, 25 ,140, 35))
    //private var textLabel1 = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.width/2) - 70, 25 ,140, 45))

    
    
    
    private var textLabel2 = UILabel()
    private var likeButton = UIButton(frame: CGRectMake((UIScreen.mainScreen().bounds.width)/2 - 20, (UIScreen.mainScreen().bounds.height) - 50, 40, 40))
    
    public let imageInfo      : GSImageInfo
    public var transitionInfo : GSTransitionInfo?
    
    private let imageView  = UIImageView()
    private let scrollView = UIScrollView()
    
    private lazy var session: NSURLSession = {
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        return NSURLSession(configuration: configuration, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
    }()
    
    // MARK: Initialization
    
    public init(imageInfo: GSImageInfo) {
        self.imageInfo = imageInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(imageInfo: GSImageInfo, transitionInfo: GSTransitionInfo) {
        self.init(imageInfo: imageInfo)
        self.transitionInfo = transitionInfo
        if let fromView = transitionInfo.fromView, referenceView = fromView.superview {
            self.transitioningDelegate = self
            self.modalPresentationStyle = .Custom
            transitionInfo.convertedRect = referenceView.convertRect(fromView.frame, toView: nil)
        }
    }
    
    public convenience init(image: UIImage, imageMode: UIViewContentMode, imageHD: NSURL?, fromView: UIView?) {
        let imageInfo = GSImageInfo(image: image, imageMode: GSImageInfo.ImageMode(rawValue: imageMode.rawValue)!, imageHD: imageHD)
        if let fromView = fromView {
            self.init(imageInfo: imageInfo, transitionInfo: GSTransitionInfo(fromView: fromView))
        } else {
            self.init(imageInfo: imageInfo)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let screenwidth = UIScreen.mainScreen().bounds.width
        let screenheight = UIScreen.mainScreen().bounds.height
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        setupView()
        setupScrollView()
        setupImageView()
        setupGesture()
        setupImageHD()
        
        textLabel1.font = UIFont(name: "Avenir", size: 12.0)
        textLabel1.minimumScaleFactor = 0.7
        //textLabel1.layer.masksToBounds = true
        textLabel1.layer.backgroundColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 0.1).CGColor
        //textLabel1.layer.cornerRadius = 9
        //textLabel1.layer.masksToBounds = true
        
        textLabel1.alpha = 1
        textLabel1.textColor = UIColor.blackColor()
        textLabel1.numberOfLines = 2
        textLabel1.textAlignment = .Center
        
        if let dateo = selectedImg["da"] {
        let timeStamp = dateo as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let reformattedDate = dateFormatter.dateFromString(timeStamp)
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.stringFromDate(reformattedDate!)
        
            if let nameo = selectedImg["fn"] {
                textLabel1.text = "\(nameo as! String)\r\(dateString)"
            } else {
                textLabel1.text = dateString
            }
            
            
        
        } else {
            textLabel1.text = ""
        }
        
        textLabel2 = UILabel(frame: CGRectMake(2, screenwidth + (screenheight - screenwidth)/2, screenwidth - 4, 80))
        textLabel2.font = UIFont(name: "Avenir-Medium", size: 15.0)
        textLabel2.layer.masksToBounds = true
        textLabel2.layer.backgroundColor = UIColor.clearColor().CGColor
        textLabel2.alpha = 1
        textLabel2.textColor = UIColor.darkTextColor()
        textLabel2.numberOfLines = 5
        textLabel2.minimumScaleFactor = 0.7
        textLabel2.textAlignment = .Center

        if selectedImg["te"] == nil || selectedImg["te"] as! String == "" {
            textLabel2.text = ""
            textLabel2.alpha = 0
        } else {
            
            textLabel2.text = (selectedImg["te"] as! String)
            textLabel2.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).CGColor
            
        }
        
        self.view.addSubview(self.textLabel2)
        self.view.addSubview(self.textLabel1)

        let ref = NSUserDefaults.standardUserDefaults()
        var arrayo = [NSString]()
        
        
        if ref.objectForKey("likedImages") != nil {
            
            arrayo = ref.objectForKey("likedImages") as! [NSString]
            
            if arrayo.contains(selectedImg["ul"] as! NSString) {
                likeButton.setImage(UIImage(named:"favoritered.png"), forState: UIControlState.Normal)

            } else {
                likeButton.setImage(UIImage(named:"favorite.png"), forState: UIControlState.Normal)
            }
        } else {
            likeButton.setImage(UIImage(named:"favorite.png"), forState: UIControlState.Normal)
        }

        likeButton.addTarget(self, action: #selector(GSImageViewerController.likeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.likeButton)
        
        print(ref.objectForKey("likedImages"))
        
        if UIScreen.mainScreen().nativeBounds.height == 960 {
            textLabel2.hidden = true
        }

        edgesForExtendedLayout = .None
        automaticallyAdjustsScrollViewInsets = false
        
        let profileImageTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(GSImageViewerController.nameTapped(_:))); textLabel1.userInteractionEnabled = true; textLabel1.addGestureRecognizer(profileImageTapGestureRecognizer)
        
        
    }
    
    private var backoDict = NSMutableDictionary()
    
    @objc private func nameTapped(sender:UIButton) {
        
        actionShowLoader()
        
        queryRef.child("st").child(selectedImg["na"] as! String).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            var toProfileDict = snapshot.value as! NSMutableDictionary
            toProfileDict.setValuesForKeysWithDictionary(["uid":(selectedImg["na"] as! String)])
            imageViewerDict = toProfileDict
            SwiftLoader.hide()
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("stylistProfile") as! stylistProfileViewController
            nextViewController.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(nextViewController, animated: true)
            }) { (error) in
                
        }
    }
    
    @objc private func likeAction(sender:UIButton!) {
    
        let ref = NSUserDefaults.standardUserDefaults()
        var arrayo = [NSString]()
        if ref.objectForKey("likedImages") != nil {
            arrayo = ref.objectForKey("likedImages") as! [NSString]
            if arrayo.contains(selectedImg["ul"] as! NSString) {
                arrayo = arrayo.filter{$0 != (selectedImg["ul"] as! NSString)}
                ref.setObject(arrayo, forKey: "likedImages")
                likeButton.setImage(UIImage(named:"favorite.png"), forState: UIControlState.Normal)
                
            } else {
                arrayo.append(selectedImg["ul"] as! NSString)
                ref.setObject(arrayo, forKey: "likedImages")
                likeButton.setImage(UIImage(named:"favoritered.png"), forState: UIControlState.Normal)
            }
        } else {
            arrayo.append(selectedImg["ul"] as! NSString)
            ref.setObject(arrayo, forKey: "likedImages")
            likeButton.setImage(UIImage(named:"favoritered.png"), forState: UIControlState.Normal)
        }
        
        print(ref.objectForKey("likedImages"))

    }
    
    public override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.frame = imageInfo.calculateRect(view.bounds.size)
        
        scrollView.frame = view.bounds
        scrollView.contentSize = imageView.bounds.size
        
        scrollView.maximumZoomScale = imageInfo.calculateMaximumZoomScale(scrollView.bounds.size)
        
        //scrollView.maximumZoomScale = 1
    }
    
    // MARK: Setups
    
    private func setupView() {
        view.backgroundColor = UIColor.whiteColor()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    private func setupImageView() {
        imageView.image = imageInfo.image
        imageView.contentMode = .ScaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    private func setupGesture() {
        
        let single = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        scrollView.addGestureRecognizer(single)
        
        // For Double Tap Zoom
        //let double = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        //double.numberOfTapsRequired = 2
        //single.requireGestureRecognizerToFail(double)
        //scrollView.addGestureRecognizer(double)
 
    }
    
    private func setupImageHD() {
        guard let imageHD = imageInfo.imageHD else { return }
        
        let request = NSMutableURLRequest(URL: imageHD, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 15)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.imageView.image = image
            self.view.layoutIfNeeded()
        })
        task.resume()
    }
    
    // MARK: Gesture
    
    @objc private func singleTap() {
        /*if navigationController == nil || (presentingViewController != nil && navigationController!.viewControllers.count <= 1) {
            
            selectedImg = NSMutableDictionary()
            
            dismissViewControllerAnimated(true, completion: nil)
        }*/
        selectedImg = NSMutableDictionary()
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    @objc private func doubleTap(gesture: UITapGestureRecognizer) {
        let point = gesture.locationInView(scrollView)
        
        if scrollView.zoomScale == 1.0 {
            scrollView.zoomToRect(CGRectMake(point.x-40, point.y-40, 80, 80), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
}

extension GSImageViewerController: UIScrollViewDelegate {
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        imageView.frame = imageInfo.calculateRect(scrollView.contentSize)
    }
    
}

extension GSImageViewerController: UIViewControllerTransitioningDelegate {
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GSImageViewerTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .Present)
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GSImageViewerTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .Dismiss)
    }
    
}

class GSImageViewerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let imageInfo      : GSImageInfo
    let transitionInfo : GSTransitionInfo
    var transitionMode : TransitionMode
    
    enum TransitionMode {
        case Present
        case Dismiss
    }
    
    init(imageInfo: GSImageInfo, transitionInfo: GSTransitionInfo, transitionMode: TransitionMode) {
        self.imageInfo = imageInfo
        self.transitionInfo = transitionInfo
        self.transitionMode = transitionMode
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionInfo.duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //guard let containerView = transitionContext.containerView() else {
        //    return
        //}
        let containerView = transitionContext.containerView()
        
        let tempMask = UIView()
        tempMask.backgroundColor = UIColor.blackColor()
        
        let tempImage = UIImageView(image: imageInfo.image)
        tempImage.layer.cornerRadius = transitionInfo.fromView!.layer.cornerRadius
        tempImage.layer.masksToBounds = true
        tempImage.contentMode = imageInfo.contentMode
        
        containerView.addSubview(tempMask)
        containerView.addSubview(tempImage)
        
        if transitionMode == .Present {
            
            let imageViewer = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! GSImageViewerController
            imageViewer.view.layoutIfNeeded()
            
            tempMask.alpha = 0
            tempMask.frame = imageViewer.view.bounds
            tempImage.frame = transitionInfo.convertedRect!
            
            UIView.animateWithDuration(transitionInfo.duration,
                                       animations: {
                                        tempMask.alpha  = 1
                                        tempImage.frame = imageViewer.imageView.frame
                },
                                       completion: { _ in
                                        tempMask.removeFromSuperview()
                                        tempImage.removeFromSuperview()
                                        containerView.addSubview(imageViewer.view)
                                        transitionContext.completeTransition(true)
                }
            )
            
        }
        
        if transitionMode == .Dismiss {
            
            
            
            let imageViewer = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! GSImageViewerController
            imageViewer.view.removeFromSuperview()
            
            tempMask.frame = imageViewer.view.bounds
            tempImage.frame = imageViewer.view.bounds
            
            UIView.animateWithDuration(transitionInfo.duration,
                                       animations: {
                                        tempMask.alpha  = 0
                                        tempImage.frame = self.transitionInfo.convertedRect!
                },
                                       completion: { _ in
                                        tempMask.removeFromSuperview()
                                        imageViewer.view.removeFromSuperview()
                                        transitionContext.completeTransition(true)
                }
            )
            
        }
        
    }
    
}
