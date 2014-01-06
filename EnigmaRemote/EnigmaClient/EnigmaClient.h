//
//  EnigmaClient.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnigmaClient : NSObject

+ (NSArray *)bouquets;

+ (NSArray *)channelsFor:(NSString *)serviceReference;

+ (void)zapTo:(NSString *)serviceReference;
    
@end
