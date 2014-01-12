//
//  ViewConnectionViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionDelegate.h"

@interface ViewConnectionViewController : UITableViewController

@property (nonatomic, strong) id<ConnectionsDelegate> delegate;
@property (nonatomic, strong) BoxConnection *connection;

@end
