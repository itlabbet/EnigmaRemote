//
//  Volume.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 07/03/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Volume : NSObject

// Volume is [0-100]
@property (nonatomic, readonly) NSUInteger volume;
@property (nonatomic, readonly) BOOL muted;

-(instancetype)init:(NSUInteger)volume andMuted:(BOOL)muted;

@end
