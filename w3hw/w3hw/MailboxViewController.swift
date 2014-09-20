//
//  MailboxViewController.swift
//  w3hw
//
//  Created by Jeff Conniff on 9/15/14.
//  Copyright (c) 2014 jconniff. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var singleMessageContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftMsgIcon: UIImageView!
    @IBOutlet weak var rightMsgIcon: UIImageView!
    @IBOutlet weak var message: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var cancelIcon: UIImageView!


    @IBAction func tapOnMenu(tapOnMenu: UITapGestureRecognizer) {
        if (tapOnMenu.state == UIGestureRecognizerState.Ended) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.containerView.frame.origin.x = 0
            })
        }
    }

    var menuIconBeganPt: CGFloat = 0;
    var containerLeftBegan: CGFloat = 0;
    @IBAction func panMenuIcon(panMenuIcon: UIPanGestureRecognizer) {
        var translate = panMenuIcon.translationInView(view)
        var point = panMenuIcon.locationInView(view)
        if (panMenuIcon.state == UIGestureRecognizerState.Began) {
            menuIconBeganPt = point.x
            containerLeftBegan = containerView.frame.origin.x
            
            
        } else if (panMenuIcon.state == UIGestureRecognizerState.Changed) {
            containerView.frame.origin.x = translate.x + containerLeftBegan
            
            
            
        } else if (panMenuIcon.state == UIGestureRecognizerState.Ended) {
            if (translate.x < 0) {
                //UIView.animateWithDuration(0.5, animations: { () -> Void in
                    //self.containerView.frame.origin.x = 0
                //})
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.containerView.frame.origin.x = 0
                    }, completion: { (finished: Bool) -> Void in
                    // nothing
                })
            } else if (translate.x > 0) {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.containerView.frame.origin.x = 270
                })
            }
        }
    }
    @IBAction func tapOnListView(tapGestureRecognizer: UITapGestureRecognizer) {
        resetMessage()
    }
    @IBAction func tapOnRescheduler(tapGestureRecognizer: UITapGestureRecognizer) {
        resetMessage()
    }
    func resetMessage () {
        // RESET all the single message stuff to original state
        panBegin = 0
        self.leftMsgIcon.frame.origin.x = 6
        self.rightMsgIcon.frame.origin.x = 283
        self.message.transform = CGAffineTransformMakeTranslation(0, 0)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.rescheduleView.alpha = 0
            self.listView.alpha = 0
            self.feedView.frame.origin.y = 79
            }) { (finished: Bool) -> Void in
            // after anim
                UIView.animateWithDuration(0.3, delay: 2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
                    self.feedView.frame.origin.y = 165
                    }, completion: { (finished: Bool) -> Void in
                        //none
                })
        }
    }

    func onEdgePan(edgePanGestureRecognizer : UIScreenEdgePanGestureRecognizer) {
        var point = edgePanGestureRecognizer.locationInView(view)
        var velocity = edgePanGestureRecognizer.velocityInView(view)
        var translate = edgePanGestureRecognizer.translationInView(view)
        println("edge")
        if edgePanGestureRecognizer.state == UIGestureRecognizerState.Began {
            // Began
        } else if edgePanGestureRecognizer.state == UIGestureRecognizerState.Changed {
            // Changed
            containerView.frame.origin.x = point.x
        } else if edgePanGestureRecognizer.state == UIGestureRecognizerState.Ended {
            // Ended
            if (translate.x > 60) {
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.containerView.frame.origin.x = 270
                })
            } else {
                // not far enough to show menu
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.containerView.frame.origin.x = 0
                })
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1434)
        
        // The onCustomPan: method will be defined in Step 3 below.
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        singleMessageContainer.addGestureRecognizer(panGestureRecognizer)

 
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        containerView.addGestureRecognizer(edgeGesture)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    var panBegin:CGFloat = 0;
    var panEnd:CGFloat = 0;

    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        // pan single message left or right
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translate = panGestureRecognizer.translationInView(view)
        
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            // BEGAN state -------------------------------
            panBegin = (point).x
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            // CHANGED state -----------------------------
            if (translate.x > 0) {
                // RIGHT pan
                self.leftMsgIcon.alpha = ((point.x - panBegin) / 60)
                if (translate.x < 60) {
                    singleMessageContainer.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                    leftMsgIcon.frame.origin.x = 6 // 6 is original x
                } else if (translate.x > 60) {
                    leftMsgIcon.frame.origin.x = translate.x - 60 + 6 // 60 is begin to move place. 6 is original x
                    singleMessageContainer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
                    leftMsgIcon.highlighted = false // changes to check
                }
                if (translate.x > 260) {
                    leftMsgIcon.highlighted = true // changes to cancel
                    singleMessageContainer.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.0, alpha: 1.0)
                }
            } else {
                // LEFT pan
                self.rightMsgIcon.alpha = ((panBegin - point.x) / 60)
                if (translate.x > -60) {
                    // gray
                    singleMessageContainer.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                    rightMsgIcon.frame.origin.x = 283
                } else if (translate.x < -60) {
                    singleMessageContainer.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.2, alpha: 1.0)
                    rightMsgIcon.frame.origin.x = 283 + translate.x + 60 // 60 is begin to move place. 6 is original x
                    rightMsgIcon.highlighted = false // later icon
                }
                if (translate.x < -260) {
                    rightMsgIcon.highlighted = true // changes to list icon
                    singleMessageContainer.backgroundColor = UIColor(red: 0.6, green: 0.5, blue: 0.4, alpha: 1.0)
                }
            }
                
            message.transform = CGAffineTransformMakeTranslation((point.x - panBegin), 0)
        
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            // END state ---------------------------------
            if (abs(point.x - panBegin) < 60) {
                // not enough pan distance
                UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                
                    self.message.transform = CGAffineTransformMakeTranslation(0, 0)
                    //self.leftMsgIcon.frame.origin.x = 6 // 6 is original x

                
                    }, completion: { finished in
                    // bkg color return to gray
                    self.singleMessageContainer.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                })
            } else {
                // panned more than 60
                
                if (panBegin < point.x) {
                    // ENDED RIGHT pan
                    rightMsgIcon.alpha = 0
                    UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                        // move far enough to also go past icon
                        self.message.transform = CGAffineTransformMakeTranslation(380, 0)
                        self.leftMsgIcon.frame.origin.x = 324 // 320 screen + 60 - 6

                        }, completion: { finished in
                            // println("panGest animation ends")
                            // bkg color return to gray
                            self.singleMessageContainer.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                            self.message.transform = CGAffineTransformMakeTranslation(0, 0)

                            self.leftMsgIcon.highlighted = false
                            
                            UIView.animateWithDuration(0.5, animations: { () -> Void in
                                // code
                                self.feedView.frame.origin.y = 79
                                }) { (finished: Bool) -> Void in
                                    // after anim
                                    UIView.animateWithDuration(0.3, delay: 2, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                                            
                                        self.feedView.frame.origin.y = 165
                                        }, completion: { (finished: Bool) -> Void in
                                            //none
                                    })
                                }
                    })

                } else {
                    // ENDED LEFT pan
                    leftMsgIcon.alpha = 0
                    UIView.animateWithDuration(0.7, delay: 0, options: .CurveEaseOut, animations: {
                        self.message.transform = CGAffineTransformMakeTranslation(-380, 0)
                        if (translate.x < -260) {
                            self.listView.alpha = 1
                        } else {
                            self.rescheduleView.alpha = 1
                        }
                        //self.feedView.frame.origin.y = 86
                        self.rightMsgIcon.frame.origin.x = -380 + 283 //

                        
                        }, completion: { finished in
                            // println("panGest animation ends")
                            // bkg color return to gray
                            self.singleMessageContainer.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                            self.rightMsgIcon.highlighted = false
                    })
                }
                
            }
        }
    }


    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
