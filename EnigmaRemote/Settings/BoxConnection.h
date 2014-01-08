//
//  BoxConnection.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxConnection : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic) NSUInteger port;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;


@end
