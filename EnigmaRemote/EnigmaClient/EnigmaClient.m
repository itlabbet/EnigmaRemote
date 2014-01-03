//
//  EnigmaClient.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EnigmaClient.h"
#import "XMLReader.h"

@implementation EnigmaClient
    
+(NSArray *)bouquets
{
    NSURL *myURL = [[NSURL alloc] initWithString:@"http://192.168.10.12/web/getservices"];
    
    // NSURL *myURI = [NSURL URLWithString:@"/autotimer/set" relativeToURL:_baseAddress];
    
    NSData *bouquetData = [[NSData alloc] initWithContentsOfURL:myURL];
    
    if (bouquetData)
    {
        NSError *error;
        
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:bouquetData error:&error];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:xmlDictionary
                                                           options:kNilOptions
                                                             error:&error];
        
        if (! jsonData)
        {
            NSLog(@"Got an error: %@", error);
        }
        else
        {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",jsonString);
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            
            NSArray *bouquets = [[json objectForKey:@"e2servicelist"] objectForKey:@"e2service"];
         
            return bouquets;
            
            // TODO: convert bouquets to real objects
        }
    }
    
    return nil;
}

+(NSArray *)bouquets_bck
{
    NSURL *myURL = [[NSURL alloc] initWithString:@"http://192.168.10.12/web/getservices"];
    
    NSData *bouquetData = [[NSData alloc] initWithContentsOfURL:myURL];
    
    if (bouquetData)
    {
        NSError *error;
        
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:bouquetData error:&error];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:xmlDictionary
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        if (! jsonData)
        {
            NSLog(@"Got an error: %@", error);
        }
        else
        {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",jsonString);
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            
            NSArray *bouquets = [[json objectForKey:@"e2servicelist"] objectForKey:@"e2service"];
            
            return bouquets;
            
            // TODO: convert bouquets to real objects
        }
    }
    
    return nil;
}

// State
// http://192.168.10.12/web/powerstate
// http://192.168.10.12/web/powerstate?newstate=0 // Toggle stand by
// http://192.168.10.12/web/powerstate?newstate=1 // Shut down hard
// http://192.168.10.12/web/powerstate?newstate=2 // Reboot
// http://192.168.10.12/web/powerstate?newstate=3 // Restart GUI

// About your box
// http://192.168.10.12/web/about
// http://192.168.10.12/web/deviceinfo

// Current local time
// http://192.168.10.12/web/currenttime

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

@end



