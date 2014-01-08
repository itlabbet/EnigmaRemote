//
//  BoxConnection.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "BoxConnection.h"

@implementation BoxConnection

// TODO: gör konstanter av nycklarna nedan

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init])) {
		self.name = [aDecoder decodeObjectForKey:@"Name"];
		self.ipAddress = [aDecoder decodeObjectForKey:@"IpAddress"];
        NSNumber *portNumber = [aDecoder decodeObjectForKey:@"Port"];
        self.port = [portNumber unsignedIntegerValue];
        self.username = [aDecoder decodeObjectForKey:@"Username"];
        self.password = [aDecoder decodeObjectForKey:@"Password"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.name forKey:@"Name"];
	[aCoder encodeObject:self.ipAddress forKey:@"IpAddress"];
    NSNumber *portNumber = [NSNumber numberWithUnsignedLong:self.port];
    [aCoder encodeObject:portNumber forKey:@"Port"];
	[aCoder encodeObject:self.username forKey:@"Username"];
    [aCoder encodeObject:self.password forKey:@"Password"];
	
}

@end
