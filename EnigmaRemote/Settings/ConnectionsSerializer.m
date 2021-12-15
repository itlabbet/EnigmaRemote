//
//  ConnectionsSerializer
//  EnigmaRemote
//
//  Created by Niklas Andersson on 08/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//


// TODO: gör konstanter av strängnycklarna

#import "ConnectionsSerializer.h"
#import "NotificationCenterConstants.h"

@interface ConnectionsSerializer ()

@end


@implementation ConnectionsSerializer

- (void)setConnections:(NSArray *)connections
{
    _connections = connections;
    
    if ([_connections count] == 1)
    {
        [self setFavorite:[_connections firstObject]];
    }
}

- (BoxConnection *)favorite
{
    for (BoxConnection *connection in self.connections)
    {
        if (connection.favorite)
            return connection;
    }
    
    return nil;
}

- (void)setFavorite:(BoxConnection *)favorite
{
    // Change favorite connection
    BoxConnection *currentFavorite = self.favorite;
    
    if ([self.connections containsObject:favorite])
    {
        currentFavorite.favorite = NO;

        favorite.favorite = YES;
    }
}

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

- (void)clear
{
    NSError *error;
    
    [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error: &error];
}

- (void)save
{
    // Save connections to file
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:self.connections forKey:@"BoxConnections"];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath] atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBoxConnectionsChanged object:nil];
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
