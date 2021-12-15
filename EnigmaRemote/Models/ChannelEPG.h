//
//  ChannelEPG.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 06/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPGEvent.h"


@interface ChannelEPG : NSObject

@property (nonatomic, strong, readonly) EPGEvent *currentEvent;
@property (nonatomic, strong, readonly) EPGEvent *nextEvent;

- (instancetype)initWithCurrentEvent:(EPGEvent *)current andNextEvent:(EPGEvent *)next;

@end
