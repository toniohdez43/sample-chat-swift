//
//  LoginTableViewController.swift
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 3/31/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import UIKit

/**
 *  Default test users password
 */
let kTestUsersDefaultPassword = "x6Bt0VDy5"

class LoginTableViewController: UITableViewController, NotificationServiceDelegate {

    // MARK: ViewController overrides
    //public var xmppStream: XMPPStream?
    @IBOutlet weak var domainTextF: UITextField!
    @IBOutlet var usernameTextF: UITextField!
    @IBOutlet var passwordTextF: UITextField!
 
    
    @IBAction func validate(sender: AnyObject) {
        if OneChat.sharedInstance.isConnected() {
            OneChat.sharedInstance.disconnect()
            QBRequest.logOutWithSuccessBlock({ (response:QBResponse) in
                print("logged out")
                }, errorBlock:   { (response:QBResponse) in                  print("unable to logout")})
            usernameTextF.hidden = false
            passwordTextF.hidden = false
                   } else {
            if self.domainTextF.text! != ""
            {
                OneChat.sharedInstance.xmppStream?.hostName=self.domainTextF.text!
            }
            else{
                let user:QBUUser! = QBUUser()
                user.password=self.passwordTextF.text!
                user.login = self.usernameTextF.text!
                QBRequest.signUp(user, successBlock: { (response:QBResponse,user: QBUUser?) in
                    print("logro el sign")
                    self.logInChatWithUser(user!)
                    QBChat.instance().connectWithUser(user!) { (error: NSError?) -> Void in
                        print("unable to connect")
                    }
                    }, errorBlock: { (response:QBResponse) in
                        self.logInChatWithUser(user!)
                })
                
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                
            }
            
            OneChat.sharedInstance.connect(username: self.usernameTextF.text!, password:    self.passwordTextF.text!) { (stream, error) -> Void in
                if let _ = error {
                    if #available(iOS 8.0, *) {
                        var alertController = UIAlertController(title: "Sorry", message: "An error occured: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                            //do something
                        }))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {}
                        
                    
                }
                else{
                    let user:QBUUser! = QBUUser()
                    user.password=self.passwordTextF.text!
                    user.login = self.usernameTextF.text!
                    QBRequest.signUp(user, successBlock: { (response:QBResponse,user: QBUUser?) in
                        print("logro el sign")
                        self.logInChatWithUser(user!)
                        QBChat.instance().connectWithUser(user!) { (error: NSError?) -> Void in
                            print("unable to connect")
                        }
                        }, errorBlock: { (response:QBResponse) in
                            self.logInChatWithUser(user)
                    })
                    
                    
                    
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
		super.viewDidLoad()
		//xmppStream?.ho
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginTableViewController.dismissKeyboard))
       // view.addGestureRecognizer(tap)
		/*guard let currentUser = ServicesManager.instance().currentUser() else {
			return
		}
		
		currentUser.password = kTestUsersDefaultPassword
		
		SVProgressHUD.showWithStatus("SA_STR_LOGGING_IN_AS".localized + currentUser.login!, maskType: SVProgressHUDMaskType.Clear)
        
		
		// Logging to Quickblox REST API and chat.
		ServicesManager.instance().logInWithUser(currentUser, completion: {
			[weak self] (success:Bool,  errorMessage: String?) -> Void in
			
			guard let strongSelf = self else { return }
			
			guard success else {
				SVProgressHUD.showErrorWithStatus(errorMessage)
				return
			}
			
			strongSelf.registerForRemoteNotification()
			SVProgressHUD.showSuccessWithStatus("SA_STR_LOGGED_IN".localized)
			
			if (ServicesManager.instance().notificationService.pushDialogID != nil) {
				ServicesManager.instance().notificationService.handlePushNotificationWithDelegate(strongSelf)
			}
			else {
				strongSelf.performSegueWithIdentifier("SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
			}
			})*/
		
		self.tableView.reloadData()
    }

    // MARK: NotificationServiceDelegate protocol
	
    func notificationServiceDidStartLoadingDialogFromServer() {
        SVProgressHUD.showWithStatus("SA_STR_LOADING_DIALOG".localized, maskType: SVProgressHUDMaskType.Clear)
    }
	
    func notificationServiceDidFinishLoadingDialogFromServer() {
        SVProgressHUD.dismiss()
    }
    
    func notificationServiceDidSucceedFetchingDialog(chatDialog: QBChatDialog!) {
        let dialogsController = self.storyboard?.instantiateViewControllerWithIdentifier("DialogsViewController") as! DialogsViewController
        let chatController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        chatController.dialog = chatDialog

        self.navigationController?.viewControllers = [dialogsController, chatController]
    }
    
    func notificationServiceDidFailFetchingDialog() {
        self.performSegueWithIdentifier("SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
    }
    
    // MARK: Actions
	
	/**
	Login in chat with user and register for remote notifications
	
	- parameter user: QBUUser instance
	*/
    func logInChatWithUser(user: QBUUser) {
        
        SVProgressHUD.showWithStatus("SA_STR_LOGGING_IN_AS".localized + user.login!, maskType: SVProgressHUDMaskType.Clear)
        
        // Logging to Quickblox REST API and chat.
        ServicesManager.instance().logInWithUser(user, completion:{
            [unowned self] (success:Bool, errorMessage: String?) -> Void in

			guard success else {
				SVProgressHUD.showErrorWithStatus(errorMessage)
				return
			}
			
			self.registerForRemoteNotification()
			self.performSegueWithIdentifier("SA_STR_SEGUE_GO_TO_DIALOGS".localized, sender: nil)
           //QBChat.instance().sendPresenceWithStatus("I am online")
			SVProgressHUD.showSuccessWithStatus("SA_STR_LOGGED_IN".localized)
            //QBChat.instance().sendPresenceWithStatus("I am online")
			
        })
    }
	
    // MARK: Remote notifications
    
    func registerForRemoteNotification() {
        // Register for push in iOS 8
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            // Register for push in iOS 7
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([UIRemoteNotificationType.Badge, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Alert])
        }
    }
    
    // MARK: UITableViewDataSource


    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        /*let user = self.users[indexPath.row]
        user.password = kTestUsersDefaultPassword*/
        let user = QBUUser()
        user.login="tonio@localhost"
        user.ID = 12467044
        user.password = "password"
        if OneChat.sharedInstance.isConnected() {
            OneChat.sharedInstance.disconnect()
            QBRequest.logOutWithSuccessBlock({ (response:QBResponse) in
                print("logged out")
                }, errorBlock:   { (response:QBResponse) in                  print("unable to logout")})
            usernameTextF.hidden = false
            passwordTextF.hidden = false
        } else {
            if self.domainTextF.text! != ""
            {
                OneChat.sharedInstance.xmppStream?.hostName=self.domainTextF.text!
            }
            else{
                let user:QBUUser! = QBUUser()
                user.password=self.passwordTextF.text!
                user.login = self.usernameTextF.text!
                QBRequest.signUp(user, successBlock: { (response:QBResponse,user: QBUUser?) in
                    print("logro el sign")
                    self.logInChatWithUser(user!)
                    QBChat.instance().connectWithUser(user!) { (error: NSError?) -> Void in
                        print("unable to connect")
                    }
                    }, errorBlock: { (response:QBResponse) in
                        self.logInChatWithUser(user!)
                        
                })
                
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                
            }
            
            OneChat.sharedInstance.connect(username: self.usernameTextF.text!, password:    self.passwordTextF.text!) { (stream, error) -> Void in
                if let _ = error {
                    if #available(iOS 8.0, *) {
                        var alertController = UIAlertController(title: "Sorry", message: "An error occured: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                            //do something
                        }))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {}
                    
                    
                }
                else{
                    let user:QBUUser! = QBUUser()
                    user.password=self.passwordTextF.text!
                    user.login = self.usernameTextF.text!
                    QBRequest.signUp(user, successBlock: { (response:QBResponse,user: QBUUser?) in
                        print("logro el sign")
                        self.logInChatWithUser(user!)
                        QBChat.instance().connectWithUser(user!) { (error: NSError?) -> Void in
                            print("unable to connect")
                        }
                        }, errorBlock: { (response:QBResponse) in
                            self.logInChatWithUser(user)
                            
                    })
                    
                    
                    
                }
                self.dismissViewControllerAnimated(true, completion: nil)

            }
        }

    }
    
}
