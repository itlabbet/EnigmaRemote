//
//  EmbeddedNewConnectionViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 13/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmbeddedNewConnectionViewController : UITableViewController

// Output properties
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *ipAddress;
@property (nonatomic, readonly) NSUInteger port;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *password;

@end
