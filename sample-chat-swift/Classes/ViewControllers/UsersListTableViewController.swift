//
//  UsersListTableViewController.swift
//  sample-chat-swift
//
//  Created by Injoit on 6/3/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

import Foundation

class UsersListTableViewController: UITableViewController {
    
    var users : [QBUUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.retrieveAllUsersFromPage(1)
        
       
        
        // Fetching users from cache.
        /*ServicesManager.instance().usersService.loadFromCache().continueWithBlock { [weak self] (task : BFTask!) -> AnyObject! in
            if task.result!.count > 0 {
				guard let users = ServicesManager.instance().sortedUsers() else {
					print("No cached users")
					return nil
				}
                self?.setupUsers(users)
                
            } else {
                
                SVProgressHUD.showWithStatus("SA_STR_LOADING_USERS".localized, maskType: SVProgressHUDMaskType.Clear)
                
                // Downloading users from Quickblox.
				
                ServicesManager.instance().downloadCurrentEnvironmentUsers({ (users: [QBUUser]?) -> Void in
					
					guard let unwrappedUsers = users else {
						SVProgressHUD.showErrorWithStatus("No users downloaded")
						return
					}
					
                    SVProgressHUD.showSuccessWithStatus("SA_STR_COMPLETED".localized)
					
                    self?.setupUsers(unwrappedUsers)
                    
                    }, errorBlock: { (error: NSError!) -> Void in
                        
                        SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                })
            }
            
            return nil;
        }*/
    }
    
    // MARK: UITableViewDataSource
    func retrieveAllUsersFromPage(page:UInt){
        let pag = QBGeneralResponsePage(currentPage: page,perPage: 100)
        QBRequest.usersForPage(pag, successBlock: { (response: QBResponse, pageInformation:QBGeneralResponsePage? , users: [QBUUser]?) in
            var userNumber:Int=0
            userNumber += (users?.count)!
            print(self.users)
            var contacts = QBChat.instance().contactList!.contacts
            for contact in contacts!{
                for user in users!{
                    if contact.userID==user.ID
                    {
                        self.users.append(user)
                        break;
                    }
                }
            }
            //self.users=users!
            print(self.users)
            self.tableView.reloadData()
            //if pageInformation?.totalEntries > userNumber{
            //self.retrieveAllUsersFromPage((pageInformation?.totalEntries)!+1)
            //}
        }) { (response: QBResponse) in
            print(response)
            
        }
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SA_STR_CELL_USER".localized, forIndexPath: indexPath) as! UserTableViewCell
        
        let user = self.users[indexPath.row]
        var currentTimeInterval: Double = NSDate( ).timeIntervalSince1970
        var userLastRequestAtTimeInterval: Double = user.lastRequestAt!.timeIntervalSince1970
        if((currentTimeInterval - userLastRequestAtTimeInterval) > 60){
            // user is offline now
            cell.setColorMarkerText(String(indexPath.row + 1), color: ServicesManager.instance().color(forUser: user))
            cell.userDescription = user.login!+" offline"
        }
        else{
        //online
            cell.setColorMarkerText(String(indexPath.row + 1), color: UIColor.greenColor())
            cell.userDescription = user.login!+" online"
        }
        
        
        
        cell.tag = indexPath.row
        
        return cell
    }
    
    func setupUsers(users: [QBUUser]) {
        self.users = users
        self.tableView.reloadData()
    }
}