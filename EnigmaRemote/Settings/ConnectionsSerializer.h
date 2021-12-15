//
//  ConnectionsSerializer
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoxConnection.h"

@interface ConnectionsSerializer : NSObject

@property (nonatomic, strong) NSArray *connections;

- (void)clear;
- (void)save;

@end
