//
//  BoxConnection.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxConnection : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic) NSUInteger port;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, readonly) BOOL favorite;

// TODO: ev property istället...? Skyddad hantering behövs så att inte två kan vara favorite samtidigt dock
- (instancetype)initWithName:(NSString *)name
                   ipAddress:(NSString* )ipAddress
                        port:(NSUInteger)port
                    username:(NSString *)username
                    password:(NSString *)password
                    favorite:(BOOL)favorite;

- (void)setAsFavorite:(BOOL)favorite;

@end
