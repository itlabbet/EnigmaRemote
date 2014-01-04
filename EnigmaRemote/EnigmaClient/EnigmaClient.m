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

@implementation EnigmaClient
    
+(NSArray *)bouquets
{
    NSURL *myURL = [[NSURL alloc] initWithString:@"http://192.168.10.12/web/getservices"];
    NSData *bouquetData = [[NSData alloc] initWithContentsOfURL:myURL];
    NSMutableArray *bouquets = [[NSMutableArray alloc] init];
    
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
        
        // Reference
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


+(NSArray *)channelsFor:(NSString *)serviceReference
{
    NSString *url = [NSString stringWithFormat:@"http://192.168.10.12/web/getservices?sRef=%@", [serviceReference urlencode]];
    
    NSURL *myURL = [[NSURL alloc] initWithString:url];
    NSData *channelData = [[NSData alloc] initWithContentsOfURL:myURL];
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    
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
        
        // Reference
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

@end



