//
//  ApplicationSettings.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//


// TODO: gör konstanter av strängnycklarna

#import "ApplicationSettings.h"

@interface ApplicationSettings ()

@property (nonatomic, strong, readwrite) NSArray *connections;

@end


@implementation ApplicationSettings

- (instancetype)init
{
    if (self = [super init])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
            
            // File found decode it from file.
			NSData *data = [[NSData alloc] initWithContentsOfFile:[self dataFilePath]];
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			_connections = [unarchiver decodeObjectForKey:@"BoxConnections"];
			[unarchiver finishDecoding];
            
		} else {  // no data file found
            
			_connections = [NSMutableArray array];
            
		}
	}
	
    return self;
}


- (void)addHost:(BoxConnection *)connection
{
    NSMutableArray *connections = [self.connections mutableCopy];
    
    [connections addObject:connection];
    
    self.connections = connections;
}

- (void)removeHost:(BoxConnection *)connection
{
    NSMutableArray *connections = [self.connections mutableCopy];
    
    [connections removeObject:connection];
    
    self.connections = connections;
}

- (void)save
{
    // Save settings to file
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self.connections forKey:@"BoxConnections"];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)dataFilePath
{
	// This method returns the full path to the plist file that will store
	// our TreasureMap objects.
    
	return [[self documentsDirectory] stringByAppendingPathComponent:@"boxconnections.bin"];
}

- (NSString *)documentsDirectory
{
	// This method returns the path to the app's Documents folder.
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return paths[0];
}


@end
