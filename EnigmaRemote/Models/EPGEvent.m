//
//  EPGEvent.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 07/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EPGEvent.h"

@interface EPGEvent ()

// Redeclaration opf properties as readwrite
@property (nonatomic, readwrite) NSUInteger eventId;
@property (nonatomic, strong, readwrite) NSDate *startTime;
@property (nonatomic, readwrite) NSUInteger duration; // TODO: använd datatyp för tidslängs om det finns
@property (nonatomic, strong, readwrite) NSDate *currentTime;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *description;
@property (nonatomic, copy, readwrite) NSString *extendedDescription;
@property (nonatomic, copy, readwrite) NSString *serviceReference;
@property (nonatomic, copy, readwrite) NSString *serviceName;

@end



@implementation EPGEvent

- (instancetype)initWith:(NSUInteger)eventId
                    startTime:(NSDate *)startTime
                duration:(NSUInteger)duration
             currentTime:(NSDate *)currentTime
                   title:(NSString *)title
             description:(NSString *)description
     extendedDescription:(NSString *)extendedDescription
               reference:(NSString *)serviceReference
             serviceName:(NSString *)serviceName
{
    self = [super init];
    
    if (self)
    {
        _eventId = eventId;
        _startTime = startTime;
        _duration = duration;
        _currentTime = currentTime;
        _title = title;
        _description = description;
        _extendedDescription = extendedDescription;
        _serviceReference = serviceReference;
        _serviceName = serviceName;
        
    }
    
    return self;
}

@end
