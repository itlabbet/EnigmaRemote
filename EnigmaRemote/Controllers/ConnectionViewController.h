//
//  ConnectionViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>

// Forward declaration of delegate
@protocol ConnectionsDelegate;


@interface ConnectionViewController : UITableViewController

@property(assign, nonatomic) id<ConnectionsDelegate> delegate;

@end
