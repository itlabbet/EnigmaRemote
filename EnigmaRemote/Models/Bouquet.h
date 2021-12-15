//
//  Bouquet.h
//  EnigmaRemote
//
//  Created by Niklas Andersson on 03/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bouquet : NSObject

@property (strong, nonatomic, readonly) NSString *reference;
@property (strong, nonatomic, readonly) NSString *name;

-(instancetype)initWithreference:(NSString *)reference andName:(NSString *)name;

@end
