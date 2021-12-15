//
//  ChannelEPG.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 06/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ChannelEPG.h"


@interface ChannelEPG ()

@property (nonatomic, strong, readwrite) EPGEvent *currentEvent;
@property (nonatomic, strong, readwrite) EPGEvent *nextEvent;

@end



@implementation ChannelEPG

- (instancetype)initWithCurrentEvent:(EPGEvent *)current andNextEvent:(EPGEvent *)next
{
    self = [super init];
    
    if (self)
    {
        _currentEvent = current;
        _nextEvent = next;
    }
    
    return self;
}

@end
