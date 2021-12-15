//
//  EnigmaClient.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

// API for the http communication version 1.6.5 with dreambox 800hd se running Enigma 2

// State
// http://192.168.10.12/web/powerstate            // Get powerstate
// http://192.168.10.12/web/powerstate?newstate=0 // Toggle stand by
// http://192.168.10.12/web/powerstate?newstate=1 // Shut down hard
// http://192.168.10.12/web/powerstate?newstate=2 // Reboot
// http://192.168.10.12/web/powerstate?newstate=3 // Restart GUI

// About your box
// http://192.168.10.12/web/about
// http://192.168.10.12/web/deviceinfo

// Current local time
// http://192.168.10.12/web/currenttime

// Bouquets
// http://192.168.10.12/web/getservices

// URL för Svenska kanaler
// http://192.168.10.12/web/getservices?sRef=1:7:1:0:0:0:0:0:0:0:FROM%20BOUQUET%20%22userbouquet.favourites.tv%22%20ORDER%20BY%20bouquet

// URL för Svenska kanaler med EPG
//http://192.168.10.12/web/epgbouquet?bRef=1:7:1:0:0:0:0:0:0:0:FROM%20BOUQUET%20%22userbouquet.favourites.tv%22%20ORDER%20BY%20bouquet

// EPG för SVT2 HD
// http://192.168.10.12/web/epgservice?sRef=1:0:19:416:36:A027:FFFF0000:0:0:0:

// Byta kanal till SVT 2 HD
// http://192.168.10.12/web/zap?sRef=1:0:19:416:36:A027:FFFF0000:0:0:0:

// Byta kanal till SVT1
// http://192.168.10.12/web/zap?sRef=1:0:1:449:2D:A027:FFFF0000:0:0:0:

// Tittar på just nu
// http://192.168.10.12/web/getcurrent


#import "EnigmaClient.h"
#import "NotificationCenterConstants.h"
#import "ConnectionsSerializer.h"
#import "NSString+URLEncode.h"
#import "GDataXMLNode.h"
#import "Bouquet.h"
#import "Channel.h"
#import "ChannelEPG.h"

// TODO: gör konstanter av alla strängar som används i koden
const NSUInteger INVALID_VOLUME = 1000;

@interface EnigmaClient ()
{
    NSString *_baseUrl;
}
@end

@implementation EnigmaClient

+ (EnigmaClient *)sharedInstance
{
    static EnigmaClient *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate = 0;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[EnigmaClient alloc] init];
        
    });
    return _sharedInstance;
}


-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self loadSettings];
        
        [self observeConnections];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
     

- (void)observeConnections
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionsDidUpdate:)
                                                 name:kBoxConnectionsChanged
                                               object:nil];
}


-(void)connectionsDidUpdate:(NSNotification *)notification
{
    // The connections have been modified - reload them from file
    [self loadSettings];
}

- (void)loadSettings
{
    ConnectionsSerializer *settings = [[ConnectionsSerializer alloc] init];
    _baseUrl = @"";

    for (BoxConnection *connection in settings.connections)
    {
        if (connection.favorite)
        {
            _baseUrl = [NSString stringWithFormat:@"http://%@:%@@%@", connection.username, connection.password, connection.ipAddress];
            
            NSLog(@"Favorite: %@", _baseUrl);
            return;
        }
        
    }
    
    NSLog(@"No favorite found!");
    
}

- (DeviceInfo *)deviceInfo
{
    DeviceInfo *deviceInfo = nil;
    NSURL *infoUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/deviceinfo"]];
    NSData *infoData = [[NSData alloc] initWithContentsOfURL:infoUrl];
    
    if (infoData == nil)
    {
        return nil;
    }
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:infoData options:0 error:&error];
    
    if (doc == nil)
    {
        // The server returned non xml answer
        return nil;
    }
    
    
    NSArray *infoElements = [doc nodesForXPath:@"//e2deviceinfo" error:nil];
    
    NSString *enigmaVersion;
    NSString *imageVersion;
    NSString *webifVersion;
    NSString *fpVersion;
    NSString *deviceName;
    
    
    for (GDataXMLElement *infoElement in infoElements)
    {
        enigmaVersion = [self valueOfElement:infoElement forKey:@"e2enigmaversion"];
        imageVersion = [self valueOfElement:infoElement forKey:@"e2imageversion"];
        webifVersion = [self valueOfElement:infoElement forKey:@"e2webifversion"];
        fpVersion = [self valueOfElement:infoElement forKey:@"e2fpversion"];
        deviceName = [self valueOfElement:infoElement forKey:@"e2devicename"];
        
        
    }
    
    NSString *tunerName;
    NSString *tunerModel;
    
    NSArray *frontEndElements = [doc nodesForXPath:@"//e2deviceinfo/e2frontends/e2frontend" error:nil];
    
    for (GDataXMLElement *frontEndElement in frontEndElements)
    {
        tunerName = [self valueOfElement:frontEndElement forKey:@"e2name"];
        tunerModel = [self valueOfElement:frontEndElement forKey:@"e2model"];
    }

    
    
    NSString *interfaceName;
    NSString *macAddress;
    NSString *dchpEnabledStr;
    NSString *ipAddress;
    NSString *gateway;
    NSString *netmask;
    
    NSArray *networkElements = [doc nodesForXPath:@"//e2deviceinfo/e2network/e2interface" error:nil];
    
    for (GDataXMLElement *networkElement in networkElements)
    {
        interfaceName = [self valueOfElement:networkElement forKey:@"e2name"];
        macAddress = [self valueOfElement:networkElement forKey:@"e2mac"];
        dchpEnabledStr = [self valueOfElement:networkElement forKey:@"e2dhcp"];
        ipAddress = [self valueOfElement:networkElement forKey:@"e2ip"];
        gateway = [self valueOfElement:networkElement forKey:@"e2gateway"];
        netmask = [self valueOfElement:networkElement forKey:@"e2netmask"];
    }
    
    
    NSString *hddModel;
    NSString *hddCapacity;
    NSString *hddFree;
    
    NSArray *hddElements = [doc nodesForXPath:@"//e2deviceinfo/e2hdds/e2hdd" error:nil];
    
    for (GDataXMLElement *hddElement in hddElements)
    {
        hddModel = [self valueOfElement:hddElement forKey:@"e2model"];
        hddCapacity = [self valueOfElement:hddElement forKey:@"e2capacity"];
        hddFree = [self valueOfElement:hddElement forKey:@"e2free"];

    }

    
    // Convert to real data types
    
    BOOL dhcpEnabled = [[dchpEnabledStr lowercaseString] isEqualToString:@"true"];
    
    // Create device info model
    deviceInfo = [[DeviceInfo alloc] initWith:enigmaVersion
                                imageVersion:imageVersion
                                 webifVersion:webifVersion
                                    fpVersion:fpVersion
                                   deviceName:deviceName
                                    tunerName:tunerName
                                   tunerModel:tunerModel
                                 intefaceName:interfaceName
                                   macAddress:macAddress
                                         dchpEnabled:dhcpEnabled
                                    ipAddress:ipAddress
                                      gateway:gateway
                                      netmask:netmask
                                     hddModel:hddModel
                                  hddCapacity:hddCapacity
                                      hddFree:hddFree];
    
    
    
    return deviceInfo;
}

- (PowerState)powerState
{
    NSString *powerStateStr;
    
    NSURL *stateUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/powerstate"]];
    NSData *stateData = [[NSData alloc] initWithContentsOfURL:stateUrl];
    
    if (stateData == nil)
    {
        return PowerStateOff;
    }
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:stateData options:0 error:&error];
    
    if (doc == nil)
    {
        // The server returned non xml answer
        return PowerStateUnknown;
    }
    
    
    NSArray *stateElements = [doc nodesForXPath:@"//e2powerstate" error:nil];
    
    for (GDataXMLElement *stateElement in stateElements)
    {
        NSArray *instandByStates = [stateElement elementsForName:@"e2instandby"];
        if (instandByStates.count > 0)
        {
            GDataXMLElement *firstState = (GDataXMLElement *) [instandByStates objectAtIndex:0];
            powerStateStr = firstState.stringValue;
        } else continue;
    }
    
    if ([powerStateStr isEqualToString:@"true"])
    {
        return PowerStateStandBy;
    }
    
    if ([powerStateStr isEqualToString:@"true"])
    {
        return PowerStateOn;
    }
    
    
    return PowerStateUnknown;
}

- (void)performAction:(BoxCommandAction)command
{
    NSURL *bouquetsUrl = nil;
    
    switch (command)
    {
        case BoxCommandReboot:
            bouquetsUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/powerstate?newstate=2"]];
            break;
            
        case BoxCommandRestart:
            bouquetsUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/powerstate?newstate=3"]];
            break;
            
        case BoxCommandShutDown:
            bouquetsUrl= [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/powerstate?newstate=1"]];
            break;
            
        case BoxCommandToggleStandBy:
            bouquetsUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/powerstate?newstate=0"]];
            break;
            
        default:
            break;
    }
    
    if (bouquetsUrl == nil)
    {
        return;
    }
    
    // TODO: hantera returdata från boxen för att kolla att rewuesten hanterades korrekt.
    NSData *resultData = [[NSData alloc] initWithContentsOfURL:bouquetsUrl];
}

// Volume can be in interval 0 - 100
- (NSUInteger)volume
{
    Volume *volume = [self volumeInfo];
    
    if (volume == nil)
    {
        return INVALID_VOLUME;
    }
    
    return volume.volume;

}

- (void)setVolume:(NSUInteger)volume
{
    if (volume > 100)
    {
        volume = 100;
    }
    
    NSString *volUrlStr = [NSString stringWithFormat:@"/web/vol?set=set%lu",
                           (unsigned long)volume];
    
    NSURL *volUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:volUrlStr]];
    NSData *resultData = [[NSData alloc] initWithContentsOfURL:volUrl];
}

- (BOOL)muted
{
    Volume *volume = [self volumeInfo];
    
    if (volume == nil)
    {
        return NO; // What to return if not sure...?
    }
    
    return volume.muted;
}

- (void)mute:(BOOL)mute
{
    NSString *volUrlStr = [NSString stringWithFormat:@"/web/vol?set=mute"];
    
    // TODO: verkar bara gå att toggla mute, inte sätta till ett visst värde
    
    NSURL *volUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:volUrlStr]];
    NSData *resultData = [[NSData alloc] initWithContentsOfURL:volUrl];

}

- (Volume *)volumeInfo
{
    NSURL *volUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/vol"]];
    NSData *volData = [[NSData alloc] initWithContentsOfURL:volUrl];
    
    if (volData == nil)
    {
        return nil;
    }
    
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:volData options:0 error:&error];
    
    if (doc == nil)
    {
        return nil;
    }
    
    // Should be only one entry in this array
    NSMutableArray *volumes = [[NSMutableArray alloc] init];
    
    NSArray *volumeElements = [doc nodesForXPath:@"//e2volume" error:nil];
    
    for (GDataXMLElement *volumeElement in volumeElements)
    {
        Volume *volume = nil;
        NSString *currentVolume;
        NSString *muted;
        
        // Current Volume
        NSArray *currentVolumes = [volumeElement elementsForName:@"e2current"];
        if (currentVolumes.count > 0)
        {
            GDataXMLElement *firstCurrentVolume = (GDataXMLElement *) [currentVolumes objectAtIndex:0];
            currentVolume = firstCurrentVolume.stringValue;
        } else continue;
        
        // Muted
        NSArray *muteds = [volumeElement elementsForName:@"e2ismuted"];
        if (muteds.count > 0)
        {
            GDataXMLElement *firstMuted = (GDataXMLElement *) [muteds objectAtIndex:0];
            muted = firstMuted.stringValue;
        } else continue;
        
        volume = [[Volume alloc] init:[currentVolume integerValue] andMuted:[muted boolValue]];
        
        [volumes addObject:volume];
        
    }
    
    if ([volumes count] != 1)
    {
        return nil;
    }
    
    Volume *v = [volumes firstObject];
    
    return v;
    
}


- (NSArray *)bouquets
{
    NSURL *bouquetsUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:@"/web/getservices"]];
    NSData *bouquetData = [[NSData alloc] initWithContentsOfURL:bouquetsUrl];
    
    if (bouquetData == nil)
    {
        return nil;
    }
    
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:bouquetData options:0 error:&error];
        
    if (doc == nil)
    {
        return nil;
    }
    
    
    NSMutableArray *bouquets = [[NSMutableArray alloc] init];
    
    NSArray *bouquetElements = [doc nodesForXPath:@"//e2servicelist/e2service" error:nil];
    
    for (GDataXMLElement *bouquetElement in bouquetElements)
    {
        Bouquet *bouquet = nil;
        NSString *serviceReference;
        NSString *serviceName;
        
        // Reference
        NSArray *references = [bouquetElement elementsForName:@"e2servicereference"];
        if (references.count > 0)
        {
            GDataXMLElement *firstReference = (GDataXMLElement *) [references objectAtIndex:0];
            serviceReference = firstReference.stringValue;
        } else continue;
        
        // Name
        NSArray *names = [bouquetElement elementsForName:@"e2servicename"];
        if (names.count > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            serviceName = firstName.stringValue;
        } else continue;

        bouquet = [[Bouquet alloc] initWithreference:serviceReference andName:serviceName];
        
        [bouquets addObject:bouquet];
        
    }
    
    return bouquets;
}


- (NSArray *)channelsFor:(NSString *)serviceReference
{
    NSString *channelsUrlStr = [NSString stringWithFormat:@"/web/getservices?sRef=%@", [serviceReference urlencode]];
    
    NSURL *channelsUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:channelsUrlStr]];
    NSData *channelData = [[NSData alloc] initWithContentsOfURL:channelsUrl];
    
    if (channelData == nil)
    {
        return nil;
    }
    
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:channelData options:0 error:&error];
    
    if (doc == nil)
    {
        return nil;
    }
    
    
    NSArray *channelElements = [doc nodesForXPath:@"//e2servicelist/e2service" error:nil];
    
    for (GDataXMLElement *channelElement in channelElements)
    {
        Channel *channel = nil;
        NSString *serviceReference;
        NSString *serviceName;
        
        // Reference
        NSArray *references = [channelElement elementsForName:@"e2servicereference"];
        if (references.count > 0)
        {
            GDataXMLElement *firstReference = (GDataXMLElement *) [references objectAtIndex:0];
            serviceReference = firstReference.stringValue;
        } else continue;
        
        // Name
        NSArray *names = [channelElement elementsForName:@"e2servicename"];
        if (names.count > 0)
        {
            GDataXMLElement *firstName = (GDataXMLElement *) [names objectAtIndex:0];
            serviceName = firstName.stringValue;
        } else continue;
        
        channel = [[Channel alloc] initWithreference:serviceReference andName:serviceName];
        
        [channels addObject:channel];
        
    }
    
    return channels;
}

- (NSArray *)channelsWithEpgFor:(NSString *)serviceReference
{
    NSString *channelsUrlStr = [NSString stringWithFormat:@"/web/epgbouquet?bRef=%@", [serviceReference urlencode]];
    
    NSURL *channelsUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:channelsUrlStr]];
    NSData *channelData = [[NSData alloc] initWithContentsOfURL:channelsUrl];
    
    if (channelData == nil)
    {
        return nil;
    }
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:channelData options:0 error:&error];
    
    if (doc == nil)
    {
        return nil;
    }
    
    
    NSMutableArray *epgs = [[NSMutableArray alloc] init];
    
    NSArray *epgElements = [doc nodesForXPath:@"//e2eventlist/e2event" error:nil];
    
    for (GDataXMLElement *epgElement in epgElements)
    {
        NSString *eventIdStr;
        NSString *eventStartStr;
        NSString *eventDurationStr;
        NSString *eventCurrentTimeStr;
        NSString *eventTitle;
        NSString *eventDescription;
        NSString *eventExtendedDescription;
        NSString *eventServiceReference;
        NSString *eventServiceName;
        
        // Fetch EPG element values from XML
        
        eventIdStr = [self valueOfElement:epgElement forKey:@"e2eventid"];
        eventStartStr = [self valueOfElement:epgElement forKey:@"e2eventstart"];
        eventDurationStr = [self valueOfElement:epgElement forKey:@"e2eventduration"];
        eventCurrentTimeStr = [self valueOfElement:epgElement forKey:@"e2eventcurrenttime"];
        eventTitle = [self valueOfElement:epgElement forKey:@"e2eventtitle"];
        eventDescription = [self valueOfElement:epgElement forKey:@"e2eventdescription"];
        eventExtendedDescription = [self valueOfElement:epgElement forKey:@"e2eventdescriptionextended"];
        eventServiceReference = [self valueOfElement:epgElement forKey:@"e2eventservicereference"];
        eventServiceName = [self valueOfElement:epgElement forKey:@"e2eventservicename"];
        
        
        // Convert string values to real data types
        
        NSNumber *tempEventId = [[NSNumber alloc]initWithLongLong:[eventIdStr longLongValue]];
        NSUInteger eventId = [tempEventId unsignedIntegerValue];
        NSNumber *tempStartTime = [[NSNumber alloc]initWithLongLong:[eventStartStr longLongValue]];
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[tempStartTime unsignedIntegerValue]];
        NSTimeInterval duration = [eventDurationStr doubleValue];
        NSNumber *tempCurrentTime = [[NSNumber alloc]initWithLongLong:[eventCurrentTimeStr longLongValue]];
        NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[tempCurrentTime unsignedIntegerValue]];
        
        // Create the epg object
        
        EPGEvent *epgEvent = [[EPGEvent alloc] initWith:eventId
                                              startTime:startTime
                                               duration:duration
                                            currentTime:currentTime
                                                  title:eventTitle
                                            description:eventDescription
                                    extendedDescription:eventExtendedDescription
                                              reference:eventServiceReference
                                            serviceName:eventServiceName];
        
        [epgs addObject:epgEvent];
        
    }
    
    return epgs;
}

#define EPG_DATA_IS_MISSING NSLocalizedStringFromTable(@"EPG_DATA_IS_MISSING", @"EnigmaClient", @"EPG information was missing for the current channel.")


- (NSArray *)channelsWithEpgFixedFor:(NSString *)serviceReference
{
    NSMutableArray *channelsWithEpg = [[NSMutableArray alloc] init];
    
    NSArray *channels = [self channelsFor:serviceReference];
    NSArray *epgs = [self channelsWithEpgFor:serviceReference];
    
    
    for (Channel *channel in channels)
    {
        BOOL channelHasEPG = NO;
        EPGEvent *channelWithEpg = nil;
        
        for (EPGEvent *epg in epgs)
        {
            if ([channel.reference isEqualToString:epg.serviceReference])
            {
                channelHasEPG = YES;
                channelWithEpg = epg;
                break;
            }
        }
        
        if (channelWithEpg)
        {
            [channelsWithEpg addObject:channelWithEpg];
        }
        else
        {
            channelWithEpg = [[EPGEvent alloc] initWith:0 startTime:nil duration:0 currentTime:nil title:EPG_DATA_IS_MISSING description:@"" extendedDescription:@"" reference:channel.reference serviceName:channel.name];
            
            [channelsWithEpg addObject:channelWithEpg];
            
        }
    }
    
    return channelsWithEpg;
}

- (void)zapTo:(NSString *)serviceReference
{
    
    NSString *zapUrlStr = [NSString stringWithFormat:@"/web/zap?sRef=%@",
                     [serviceReference urlencode]];
    
    NSURL *zapUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:zapUrlStr]];
    NSData *resultData = [[NSData alloc] initWithContentsOfURL:zapUrl];
    
    // TODO: check if zap was done...
    
}

- (ChannelEPG *)channelEPGFor:(NSString *)serviceReference;
{
    ChannelEPG *channelEPG = nil;
    
    NSString *epgUrlStr = [NSString stringWithFormat:@"/web/epgservice?sRef=%@", [serviceReference urlencode]];
    
    NSURL *epgUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:epgUrlStr]];
    NSData *epgData = [[NSData alloc] initWithContentsOfURL:epgUrl];
    
    if (epgData == nil)
    {
        return nil;
    }
    
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:epgData options:0 error:&error];
    
    if (doc == nil)
    {
        return nil;
    }
    
    NSMutableArray *epgs = [[NSMutableArray alloc] init];
    
    NSArray *epgElements = [doc nodesForXPath:@"//e2eventlist/e2event" error:nil];
    
    for (GDataXMLElement *epgElement in epgElements)
    {
        NSString *eventIdStr;
        NSString *eventStartStr;
        NSString *eventDurationStr;
        NSString *eventCurrentTimeStr;
        NSString *eventTitle;
        NSString *eventDescription;
        NSString *eventExtendedDescription;
        NSString *eventServiceReference;
        NSString *eventServiceName;
        
        // Fetch EPG element values from XML
        
        eventIdStr = [self valueOfElement:epgElement forKey:@"e2eventid"];
        eventStartStr = [self valueOfElement:epgElement forKey:@"e2eventstart"];
        eventDurationStr = [self valueOfElement:epgElement forKey:@"e2eventduration"];
        eventCurrentTimeStr = [self valueOfElement:epgElement forKey:@"e2eventcurrenttime"];
        eventTitle = [self valueOfElement:epgElement forKey:@"e2eventtitle"];
        eventDescription = [self valueOfElement:epgElement forKey:@"e2eventdescription"];
        eventExtendedDescription = [self valueOfElement:epgElement forKey:@"e2eventdescriptionextended"];
        eventServiceReference = [self valueOfElement:epgElement forKey:@"e2eventservicereference"];
        eventServiceName = [self valueOfElement:epgElement forKey:@"e2eventservicename"];
        
        
        // Convert string values to real data types
        
        NSNumber *tempEventId = [[NSNumber alloc]initWithLongLong:[eventIdStr longLongValue]];
        NSUInteger eventId = [tempEventId unsignedIntegerValue];
        NSNumber *tempStartTime = [[NSNumber alloc]initWithLongLong:[eventStartStr longLongValue]];
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[tempStartTime unsignedIntegerValue]];
        NSTimeInterval duration = [eventDurationStr doubleValue];
        NSNumber *tempCurrentTime = [[NSNumber alloc]initWithLongLong:[eventCurrentTimeStr longLongValue]];
        NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[tempCurrentTime unsignedIntegerValue]];
        
        // Create the epg object
        
        EPGEvent *epgEvent = [[EPGEvent alloc] initWith:eventId
                                              startTime:startTime
                                               duration:duration
                                            currentTime:currentTime
                                                  title:eventTitle
                                            description:eventDescription
                                    extendedDescription:eventExtendedDescription
                                              reference:eventServiceReference
                                            serviceName:eventServiceName];
        
        [epgs addObject:epgEvent];
        
    }
    
    // TODO: verify size == 2 of epgs
    if ([epgs count] >= 2)
    {
        channelEPG = [[ChannelEPG alloc] initWithCurrentEvent:[epgs firstObject] andNextEvent:[epgs objectAtIndex:1]];
    }
    else
    {
        channelEPG = [[ChannelEPG alloc] initWithCurrentEvent:[epgs firstObject] andNextEvent:nil];
    }
    
    return channelEPG;
}

- (ChannelEPG *)currentPlaying
{
    ChannelEPG *channelEPG = nil;
    NSString *eventServiceName;
    
    NSString *playingUrlStr = [NSString stringWithFormat:@"/web/getcurrent"];
    
    NSURL *playingUrl = [[NSURL alloc] initWithString:[_baseUrl stringByAppendingString:playingUrlStr]];
    NSData *playingData = [[NSData alloc] initWithContentsOfURL:playingUrl];
    
    if (playingData == nil)
    {
        // TODO: Notify user about error
        return nil;
    }
    
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:playingData options:0 error:&error];
    
    if (doc == nil)
    {
        // TODO: Notify user about error
        return nil;
    }
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    // Note - there is only one service, but need to get is as an array
    NSArray *serviceElements = [doc nodesForXPath:@"//e2currentserviceinformation/e2service" error:nil];
    if ([serviceElements count] > 0)
    {
        eventServiceName = [self valueOfElement:[serviceElements firstObject] forKey:@"e2servicename"];
    }
    
    // There might be more than two events returned but just take the first two and display them as current program and next program
    NSArray *eventElements = [doc nodesForXPath:@"//e2currentserviceinformation/e2eventlist/e2event" error:nil];
    NSUInteger counter = 0;
    for (GDataXMLElement *eventElement in eventElements)
    {
        // Handle the case that there might be more than two events returned
        counter++;
        if (counter > 2)
            break;
        
        NSString *eventIdStr;
        NSString *eventStartStr;
        NSString *eventDurationStr;
        NSString *eventCurrentTimeStr;
        NSString *eventTitle;
        NSString *eventDescription;
        NSString *eventExtendedDescription;
        NSString *eventServiceReference;
        
        
        // Fetch EPG element values from XML
        
        eventIdStr = [self valueOfElement:eventElement forKey:@"e2eventid"];
        eventTitle = [self valueOfElement:eventElement forKey:@"e2eventtitle"];
        eventStartStr = [self valueOfElement:eventElement forKey:@"e2eventstart"];
        eventDurationStr = [self valueOfElement:eventElement forKey:@"e2eventduration"];
        eventCurrentTimeStr = [self valueOfElement:eventElement forKey:@"e2eventcurrenttime"];
        eventDescription = [self valueOfElement:eventElement forKey:@"e2eventdescription"];
        eventExtendedDescription = [self valueOfElement:eventElement forKey:@"e2eventdescriptionextended"];
        eventServiceReference = [self valueOfElement:eventElement forKey:@"e2eventservicereference"];
        
        
        // Convert string values to real data types
        
        NSNumber *tempEventId = [[NSNumber alloc]initWithLongLong:[eventIdStr longLongValue]];
        NSUInteger eventId = [tempEventId unsignedIntegerValue];
        NSNumber *tempStartTime = [[NSNumber alloc]initWithLongLong:[eventStartStr longLongValue]];
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[tempStartTime unsignedIntegerValue]];
        NSTimeInterval duration = [eventDurationStr doubleValue];
        NSNumber *tempCurrentTime = [[NSNumber alloc]initWithLongLong:[eventCurrentTimeStr longLongValue]];
        NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[tempCurrentTime unsignedIntegerValue]];
        
        // Create the epg object
        
        EPGEvent *epgEvent = [[EPGEvent alloc] initWith:eventId
                                              startTime:startTime
                                               duration:duration
                                            currentTime:currentTime
                                                  title:eventTitle
                                            description:eventDescription
                                    extendedDescription:eventExtendedDescription
                                              reference:eventServiceReference
                                            serviceName:eventServiceName];
        
        [events addObject:epgEvent];
        
    }
    
    // TODO: verify size == 2 of epgs
    channelEPG = [[ChannelEPG alloc] initWithCurrentEvent:[events firstObject] andNextEvent:[events lastObject]];
    
    
    return channelEPG;
}

#pragma mark - Helpers

- (NSString *)valueOfElement:(GDataXMLElement *)element forKey:(NSString *)key
{
    NSString *value = @"";
    NSArray *elements = [element elementsForName:key];
    
    if (elements.count > 0)
    {
        value = [[elements firstObject] stringValue];
    }
    
    return value;
}

@end



