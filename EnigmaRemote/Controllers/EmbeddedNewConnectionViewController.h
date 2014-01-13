//
//  EmbeddedNewConnectionViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 13/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmbeddedNewConnectionViewController : UITableViewController

// TODO: ska dessa exponeras publikt eller bättre göra en egen BoxConnection property?
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *ipAddress;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
