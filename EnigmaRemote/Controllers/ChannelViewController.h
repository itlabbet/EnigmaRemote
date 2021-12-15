//
//  ChannelViewController.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 11/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPGEvent.h"

@interface ChannelViewController : UITableViewController

@property (nonatomic, strong) EPGEvent *epgEvent;

@end
