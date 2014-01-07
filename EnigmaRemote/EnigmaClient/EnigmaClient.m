//
//  EnigmaClient.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

// API for the http communication with dreambox 800hd se running Enigma 2

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

// EPG för SVT2 HD
// http://192.168.10.12/web/epgservice?sRef=1:0:19:416:36:A027:FFFF0000:0:0:0:

// Byta kanal till SVT 2 HD
// http://192.168.10.12/web/zap?sRef=1:0:19:416:36:A027:FFFF0000:0:0:0:

// Byta kanal till SVT1
// http://192.168.10.12/web/zap?sRef=1:0:1:449:2D:A027:FFFF0000:0:0:0:

// Tittar på just nu
// http://192.168.10.12/web/getcurrent


#import "EnigmaClient.h"
#import "NSString+URLEncode.h"
#import "GDataXMLNode.h"
#import "Bouquet.h"
#import "Channel.h"
#import "ChannelEPG.h"


@interface EnigmaClient ()
{
    NSString *_baseUrl;
}
@end

@implementation EnigmaClient

+ (EnigmaClient *)sharedInstance
{
    // 1
    static EnigmaClient *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
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
        // TODO: get from settings instead.
        _baseUrl = @"http://192.168.10.12";
        
        // if not settings - return nil
    }
    
    return self;
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
    
    NSData *resultData = [[NSData alloc] initWithContentsOfURL:bouquetsUrl];
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
        NSString *eventId;
        NSString *eventStart;
        NSString *eventDuration;
        NSString *eventCurrentTime;
        NSString *eventTitle;
        NSString *eventDescription;
        NSString *eventExtendedDescription;
        NSString *eventServiceReference;
        NSString *eventServiceName;
        
        // Fetch EPG element values from XML
        
        NSArray *eventIds = [epgElement elementsForName:@"e2eventid"];
        if (eventIds.count > 0)
        {
            // TODO: always use firstObject instead of objectAtIndex:0
            eventId = [[eventIds firstObject] stringValue];
        }
        
        NSArray *starts = [epgElement elementsForName:@"e2eventstart"];
        if (starts.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [starts objectAtIndex:0];
            eventStart = first.stringValue;
        }
        
        NSArray *durations = [epgElement elementsForName:@"e2eventduration"];
        if (durations.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [durations objectAtIndex:0];
            eventDuration = first.stringValue;
        }
        
        NSArray *currentTimes = [epgElement elementsForName:@"e2eventcurrenttime"];
        if (currentTimes.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [currentTimes objectAtIndex:0];
            eventCurrentTime = first.stringValue;
        }
        
        NSArray *titles = [epgElement elementsForName:@"e2eventtitle"];
        if (titles.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [titles objectAtIndex:0];
            eventTitle = first.stringValue;
        }
        
        NSArray *descriptions = [epgElement elementsForName:@"e2eventdescription"];
        if (descriptions.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [descriptions objectAtIndex:0];
            eventDescription = first.stringValue;
        }
        
        NSArray *extendeds = [epgElement elementsForName:@"e2eventdescriptionextended"];
        if (extendeds.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [extendeds objectAtIndex:0];
            eventExtendedDescription = first.stringValue;
        }
        
        NSArray *references = [epgElement elementsForName:@"e2eventservicereference"];
        if (references.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [references objectAtIndex:0];
            serviceReference = first.stringValue;
        }
        
        NSArray *names = [epgElement elementsForName:@"e2eventservicename"];
        if (names.count > 0)
        {
            GDataXMLElement *first = (GDataXMLElement *) [names objectAtIndex:0];
            eventServiceName = first.stringValue;
        }
        
        
        //EPGEvent *epgEvent = [[EPGEvent alloc] initWith:eventId date:<#(NSDate *)#> duration:<#(NSUInteger)#> currentTime:<#(NSDate *)#> title:<#(NSString *)#> description:<#(NSString *)#> extendedDescription:<#(NSString *)#> reference:<#(NSString *)#> serviceName:<#(NSString *)#>:.........];
        EPGEvent *epgEvent;
        [epgs addObject:epgEvent];
        
    }
    
    // TODO: verify size == 2 of epgs
    
    channelEPG = [[ChannelEPG alloc] initWithCurrentEvent:[epgs firstObject] andNextEvent:[epgs lastObject]];
    
    
    return channelEPG;
}

@end



