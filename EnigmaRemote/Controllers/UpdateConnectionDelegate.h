//
//  UpdateConnectionDelegate.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 16/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateConnectionDelegate <NSObject>

- (void)updateConnection:(NSString *)id
                    name:(NSString *)name
               ipAddress:(NSString* )ipAddress
                    port:(NSUInteger)port
                username:(NSString *)username
                password:(NSString *)password
                favorite:(BOOL)favorite;


@end
