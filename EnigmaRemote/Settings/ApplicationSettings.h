//
//  ApplicationSettings.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoxConnection.h"

@interface ApplicationSettings : NSObject

@property (nonatomic, strong) BoxConnection *favorite;
@property (nonatomic, strong, readonly) NSArray *connections;

- (void)addHost:(BoxConnection *)connection;
- (void)removeHost:(BoxConnection *)connection;
- (void)save;

@end
