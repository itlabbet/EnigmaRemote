//
//  BoxConnection.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "BoxConnection.h"

@interface BoxConnection ()

@end


@implementation BoxConnection

- (instancetype)initWithId:(NSString *)id
                        name:(NSString *)name
                        ipAddress:(NSString* )ipAddress
                        port:(NSUInteger)port
                        username:(NSString *)username
                        password:(NSString *)password
                        favorite:(BOOL)favorite
{
    if (self = [super init])
    {
        _id = id;
        _name = name;
        _ipAddress = ipAddress;
        _port = port;
        _username = username;
        _password = password;
        _favorite = favorite;
    }
    
    return self;
}

// TODO: gör konstanter av nycklarna nedan

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
    {
		self.id = [aDecoder decodeObjectForKey:@"Id"];
        self.name = [aDecoder decodeObjectForKey:@"Name"];
		self.ipAddress = [aDecoder decodeObjectForKey:@"IpAddress"];
        NSNumber *portNumber = [aDecoder decodeObjectForKey:@"Port"];
        self.port = [portNumber unsignedIntegerValue];
        self.username = [aDecoder decodeObjectForKey:@"Username"];
        self.password = [aDecoder decodeObjectForKey:@"Password"];
        self.favorite = [aDecoder decodeBoolForKey:@"Favorite"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.id forKey:@"Id"];
	[aCoder encodeObject:self.name forKey:@"Name"];
	[aCoder encodeObject:self.ipAddress forKey:@"IpAddress"];
    NSNumber *portNumber = [NSNumber numberWithUnsignedLong:self.port];
    [aCoder encodeObject:portNumber forKey:@"Port"];
	[aCoder encodeObject:self.username forKey:@"Username"];
    [aCoder encodeObject:self.password forKey:@"Password"];
	[aCoder encodeBool:self.favorite forKey:@"Favorite"];
}

@end
