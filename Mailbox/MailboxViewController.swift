//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Michael Volovar on 10/30/16.
//  Copyright © 2016 Michael Volovar. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mailboxSuperview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedSuperview: UIView!
    @IBOutlet weak var feedImage: UIImageView!
    // message related views / images
    @IBOutlet weak var messageSuperview: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageIconsLeftView: UIView!
    @IBOutlet weak var messageIconsRightView: UIView!
    // message icons
    @IBOutlet weak var deleteIconImage: UIImageView!
    @IBOutlet weak var archiveIconImage: UIImageView!
    @IBOutlet weak var listIconImage: UIImageView!
    @IBOutlet weak var laterIconImage: UIImageView!
    // other views
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    
    var settingsOpen: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MailboxViewController.showSettings))
        let screenEdgeRightRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MailboxViewController.hideSettings))
        let rescheduleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MailboxViewController.hideReschedule))
        let listTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MailboxViewController.hideList))
        
        screenEdgeRecognizer.edges = .left
        screenEdgeRightRecognizer.edges = .right
        
        view.addGestureRecognizer(screenEdgeRecognizer)
        view.addGestureRecognizer(screenEdgeRightRecognizer)
        rescheduleView.addGestureRecognizer(rescheduleTapRecognizer)
        listView.addGestureRecognizer(listTapRecognizer)
        
        settingsOpen = false

        messageSuperview.frame.size = messageImage.frame.size
        
        let scrollWidth = Int(UIScreen.main.bounds.width)
        let scrollHeight = Int(searchImage.frame.size.height + feedImage.frame.size.height + messageSuperview.frame.size.height)
        
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        // set some views / icons to hidden
        deleteIconImage.alpha = 0
        listIconImage.alpha = 0
        rescheduleView.alpha = 0
        listView.alpha = 0
        messageIconsLeftView.alpha = 0
        messageIconsRightView.alpha = 0
    }

    @IBAction func didPressSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // do stuff here
        } else if sender.selectedSegmentIndex == 2 {
            // do more stuff here
        }
    }
    
    @IBAction func didPanMessage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            UIView.animate(withDuration: 0.3, animations: {
                
            })
        }
        
        if sender.state == .changed {
            var bgColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
            messageImage.transform = CGAffineTransform(translationX: translation.x, y: 0)
            
            // set color for bg
            if translation.x > 200 {
                bgColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            } else if translation.x > 50 {
                bgColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else if translation.x < -200 {
                bgColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            }else if translation.x < -50 {
                bgColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            }
            
            // animate bg color
            UIView.animate(withDuration: 0.3, animations: {
                self.messageSuperview.backgroundColor = bgColor
            })
            
            // icon positioning
            if translation.x > 51 {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.messageIconsLeftView.alpha = 1
                })
                messageIconsLeftView.transform = CGAffineTransform(translationX: translation.x - 51, y: 0)
            }
            
            if translation.x < -59 {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.messageIconsRightView.alpha = 1
                })
                messageIconsRightView.transform = CGAffineTransform(translationX: translation.x + 59, y: 0)
            }
            
            if translation.x < 51 && translation.x > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageIconsLeftView.alpha = 0
                })
            }
            
            if translation.x > -59 && translation.x < 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageIconsRightView.alpha = 0
                })
            }
            
            // show / hide icons
            if translation.x > 200 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.archiveIconImage.alpha = 0
                    self.deleteIconImage.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.archiveIconImage.alpha = 1
                    self.deleteIconImage.alpha = 0
                })
            }
            
            if translation.x < -200 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.laterIconImage.alpha = 0
                    self.listIconImage.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.laterIconImage.alpha = 1
                    self.listIconImage.alpha = 0
                })
            }
        }
        
        if sender.state == .ended {
            if translation.x < 70 && translation.x > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageIconsLeftView.alpha = 0
                    self.messageImage.transform = CGAffineTransform.identity
                    self.messageSuperview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                })
            } else if translation.x > -70 && translation.x < 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageIconsRightView.alpha = 0
                    self.messageImage.transform = CGAffineTransform.identity
                    self.messageSuperview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                })
            } else if translation.x > 70 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageImage.transform = self.messageImage.transform.translatedBy(x: 375 - self.messageImage.transform.tx, y: 0)
                    self.messageIconsLeftView.transform = self.messageIconsLeftView.transform.translatedBy(x: 375 - self.messageIconsLeftView.transform.tx, y: 0)
                    self.messageIconsLeftView.alpha = 0
                }) { (Bool) in
                    UIView.animate(withDuration: 0.3, animations: { 
                        self.hideMessage()
                    })
                    
                    delay(0.8, closure: {
                        self.resetMessage()
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.feedImage.transform = CGAffineTransform.identity
                        })
                    })
                }
            } else if translation.x < -70 && translation.x > -175 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageImage.transform = self.messageImage.transform.translatedBy(x: -375 - self.messageImage.transform.tx, y: 0)
                    self.archiveIconImage.alpha = 0
                    self.rescheduleView.alpha = 1
                    self.messageIconsRightView.transform = self.messageIconsRightView.transform.translatedBy(x: -375 - self.messageIconsRightView.transform.tx, y: 0)
                    self.messageIconsRightView.alpha = 0
                })
            } else if translation.x < -175 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageImage.transform = self.messageImage.transform.translatedBy(x: -375 - self.messageImage.transform.tx, y: 0)
                    self.archiveIconImage.alpha = 0
                    self.listView.alpha = 1
                    self.messageIconsRightView.transform = self.messageIconsRightView.transform.translatedBy(x: -375 - self.messageIconsRightView.transform.tx, y: 0)
                    self.messageIconsRightView.alpha = 0
                })
            }

        }
    }
    
    func showSettings(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        // don't do anything if settings is shown
        if settingsOpen == true {
            return
        }
        
        if sender.state == .changed {
            mailboxSuperview.transform = CGAffineTransform(translationX: translation.x, y: 0)
        }
        
        if sender.state == .ended {
            // checking against hardcoded screen with of 375, should be updated to check screen width
            if velocity.x > 0 && translation.x > 100 && mailboxSuperview.transform.tx < 375 && mailboxSuperview.transform.tx > 0 {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    // translationX is hardcoded to 375, but should check screen width
                    self.mailboxSuperview.transform = CGAffineTransform(translationX: 375, y: 0)
                    }, completion: { (Bool) in
                        self.settingsOpen = true
                })
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    // set message view back to 0
                    self.mailboxSuperview.transform = CGAffineTransform(translationX: 0, y: 0)
                    }, completion: nil)
            }
        }
    }
    
    func hideSettings(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        // don't do anything if settings isn't shown
        if settingsOpen == false {
            return
        }
        
        if sender.state == .changed {
            mailboxSuperview.transform = CGAffineTransform(translationX: 375 + translation.x, y: 0)
        }
        
        if sender.state == .ended {
            // checking against hardcoded screen with of 375, should be updated to check screen width
            if (-1 * velocity.x) > 0 && (-1 * translation.x) > 100 && mailboxSuperview.transform.tx < 375 && mailboxSuperview.transform.tx > 0 {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    // set message view back to 0
                    self.mailboxSuperview.transform = CGAffineTransform(translationX: 0, y: 0)
                    }, completion: { (Bool) in
                        self.settingsOpen = false
                })
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    // translationX is hardcoded to 375, but should check screen width
                    self.mailboxSuperview.transform = CGAffineTransform(translationX: 375, y: 0)
                    }, completion: nil)
            }
        }
    }
    
    func hideReschedule(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: { 
            self.rescheduleView.alpha = 0
            self.hideMessage()
            }) { (Bool) in
                delay(0.8, closure: {
                    self.resetMessage()
                    
                    UIView.animate(withDuration: 0.3, animations: { 
                        self.feedImage.transform = CGAffineTransform.identity
                    })
                })
        }
    }
    
    func hideList(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.listView.alpha = 0
            self.hideMessage()
        }) { (Bool) in
            delay(0.8, closure: {
                self.resetMessage()
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.feedImage.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    func hideMessage() {
        self.feedImage.transform = self.feedImage.transform.translatedBy(x: 0, y: -101)
        self.messageSuperview.transform = self.messageSuperview.transform.translatedBy(x: 0, y: -101)
    }
    
    func resetMessage() {
        self.messageSuperview.transform = CGAffineTransform.identity
        self.messageSuperview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.messageImage.transform = CGAffineTransform.identity
        self.messageIconsRightView.transform = CGAffineTransform.identity
        self.messageIconsLeftView.alpha = 0
        self.messageIconsRightView.alpha = 0
    }
}
