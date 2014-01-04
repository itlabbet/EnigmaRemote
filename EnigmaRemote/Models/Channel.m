//
//  Channel.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "Channel.h"

@implementation Channel

-(instancetype)initWithreference:(NSString *)reference andName:(NSString *)name
{
    self = [super init];
    
    if (self)
    {
        _reference = reference;
        _name = name;
    }
    
    return self;
}

@end
