//
//  ConnectionsViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxConnection.h"

@protocol ConnectionsDelegate <NSObject>

- (void)addBoxConnection:(BoxConnection *)connection;
- (void)updateBoxConnection:(BoxConnection *)connection;
- (void)removeBoxConnection:(BoxConnection *)connection;

@end

@interface ConnectionsViewController : UITableViewController <ConnectionsDelegate>

@end
