//
//  EmbeddedEditConnectionViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 13/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmbeddedEditConnectionViewController : UITableViewController

// Used for both input and outputs outputs
// Input values will be set in UI
// output values will be the edited result if not canceled
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic) NSUInteger port;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
