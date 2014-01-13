//
//  ApplicationSettings.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoxConnection.h"

// TODO: fundera på om denna bör heta ngt annat!
// Skulle kunna ha EPG i kanallistan eller bara rena kanaler som en valbar setting istället....

@interface ApplicationSettings : NSObject

@property (nonatomic, strong) BoxConnection *favorite;
@property (nonatomic, strong) NSArray *connections;

- (void)addHost:(BoxConnection *)connection;
- (void)removeHost:(BoxConnection *)connection;
- (void)clear;
- (void)save;

@end
