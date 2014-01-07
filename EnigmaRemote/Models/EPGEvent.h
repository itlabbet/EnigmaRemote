//
//  EPGEvent.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 07/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPGEvent : NSObject

@property (nonatomic, readonly) NSUInteger eventId;
@property (nonatomic, strong, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, strong, readonly) NSDate *currentTime;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *description;
@property (nonatomic, copy, readonly) NSString *extendedDescription;
@property (nonatomic, copy, readonly) NSString *serviceReference;
@property (nonatomic, copy, readonly) NSString *serviceName;

- (instancetype)initWith:(NSUInteger)eventId
                    startTime:(NSDate *)startTime
                duration:(NSTimeInterval)duration
             currentTime:(NSDate *)date
                   title:(NSString *)title
             description:(NSString *)description
     extendedDescription:(NSString *)extendedDescription
               reference:(NSString *)serviceReference
             serviceName:(NSString *)serviceName;

@end

