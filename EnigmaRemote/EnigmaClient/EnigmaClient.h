//
//  EnigmaClient.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    PowerStateUnknown,
    PowerStateStandBy,
    PowerStateShutDown,
    PowerStateReboot,
    PowerStateRestart
    
}PowerState;

@interface EnigmaClient : NSObject
{
    NSString *_baseUrl;
}

+ (EnigmaClient *) sharedInstance;

- (PowerState)powerState;

- (void)setPowerState:(PowerState)state;

- (NSArray *)bouquets;

- (NSArray *)channelsFor:(NSString *)serviceReference;

- (void)zapTo:(NSString *)serviceReference;
    
@end
