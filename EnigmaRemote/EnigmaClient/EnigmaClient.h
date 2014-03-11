//
//  EnigmaClient.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"
#import "ChannelEPG.h"
#import "Volume.h"

// TODO: Perform full documentation of all API:s
// Använd eventuellt ett specifikt kommentarsspråk för att gena dokumentation...
// https://github.com/tomaz/appledoc

typedef enum
{
    PowerStateUnknown,  // unknown state
    PowerStateOff,      // Box is turned off or server software not running
    PowerStateOn,       // Box is on and is currenlty streaming a channel
    PowerStateStandBy   // Box is powered on but in stand by

}PowerState;

typedef enum
{
    BoxCommandToggleStandBy,    // Toggle PowerState between PowerStateOn and PowerStateStandBy
    BoxCommandShutDown,         // Shut down the box completely - will require local access to turn it back in by pressing powerbutton
    BoxCommandReboot,           // Reboot the box operating system
    BoxCommandRestart,          // Restart the box TV-specific processes (no operating system restart)

}BoxCommandAction;

extern const NSUInteger INVALID_VOLUME;

// All calls to EnigmaClient will block and should be perfomed in a separate queue.
@interface EnigmaClient : NSObject

+ (EnigmaClient *) sharedInstance;

- (DeviceInfo *)deviceInfo;

- (PowerState)powerState;

- (void)performAction:(BoxCommandAction)command;

// Volume can be in interval 0 - 100
- (NSUInteger)volume;
- (void)setVolume:(NSUInteger)volume;

- (BOOL)muted;
- (void)mute:(BOOL)mute;


// Return all bouquets
- (NSArray *)bouquets;

// Return all channels within a bouquet
- (NSArray *)channelsFor:(NSString *)serviceReference;

// Return all channels that has epg data
// Channel that is missing epg data will not be included
- (NSArray *)channelsWithEpgFor:(NSString *)serviceReference;

// Returns all channels even if they dont have any epg data
- (NSArray *)channelsWithEpgFixedFor:(NSString *)serviceReference;

- (void)zapTo:(NSString *)serviceReference;

- (ChannelEPG *)channelEPGFor:(NSString *)serviceReference;

- (ChannelEPG *)currentPlaying;
    
@end
