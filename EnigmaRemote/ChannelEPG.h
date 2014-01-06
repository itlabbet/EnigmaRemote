//
//  ChannelEPG.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 06/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPGEvent : NSObject

// TODO: make readonly and set with init...
@property (nonatomic) NSUInteger eventId;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic) NSUInteger duration; // TODO: använd datatyp för tidslängs om det finns
@property (nonatomic, strong) NSDate *currentTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *extendedDescription;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *serviceName;

@end



@interface ChannelEPG : NSObject

// TODO: make readonly and set with init
@property (nonatomic, strong) EPGEvent *currentEvent;
@property (nonatomic, strong) EPGEvent *nextEvent;

- (instancetype)initWithCurrentEvent:(EPGEvent *)current andNextEvent:(EPGEvent *)next;


@end
