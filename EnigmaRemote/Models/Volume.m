//
//  Volume.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 07/03/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "Volume.h"

@implementation Volume

-(instancetype)init:(NSUInteger)volume andMuted:(BOOL)muted
{
    self = [super init];
    
    if (self)
    {
        _volume = volume;
        _muted = muted;
    }
    
    return self;
}

@end
