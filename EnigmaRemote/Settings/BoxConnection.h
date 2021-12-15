//
//  BoxConnection.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxConnection : NSObject <NSCoding>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic) NSUInteger port;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) BOOL favorite;

- (instancetype)initWithId:(NSString *)id
                    name:(NSString *)name
                   ipAddress:(NSString* )ipAddress
                        port:(NSUInteger)port
                    username:(NSString *)username
                    password:(NSString *)password
                    favorite:(BOOL)favorite;

@end
