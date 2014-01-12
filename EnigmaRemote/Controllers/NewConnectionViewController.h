//
//  ConnectionViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionDelegate.h"


@interface NewConnectionViewController : UITableViewController

@property (nonatomic, assign) id<ConnectionsDelegate> delegate;

@property (nonatomic, assign) id<ConnectionsDelegate> nisse;

@end
