//
//  ConnectionViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateConnectionDelegate.h"

@interface ConnectionViewController : UITableViewController

// Used for input to set UI
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic) NSUInteger port;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

// Delegate that handles connection updates
@property (nonatomic, weak) id<UpdateConnectionDelegate> delegate;

@end
