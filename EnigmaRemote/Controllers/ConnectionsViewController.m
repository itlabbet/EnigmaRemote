//
//  ConnectionsViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "NewConnectionViewController.h"
#import "ConnectionViewController.h"
#import "EditConnectionViewController.h"
#import "EmbeddedEditConnectionViewController.h"
#import "ConnectionsSerializer.h"

@interface ConnectionsViewController ()

@property (nonatomic, strong) NSArray *connections;

@end


@implementation ConnectionsViewController

- (void)setConnections:(NSArray *)connections
{
    _connections = connections;
    
    [self.tableView reloadData];
}

- (void)loadView
{
    [super loadView];
    
    [self loadConnections];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup event handling
    [self.refreshControl addTarget:self
                            action:@selector(loadConnections)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.connections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConnectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BoxConnection *connection = [self.connections objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [self createConnectionText:connection];
    
    if (connection.favorite)
    {
        UIFont *font = [cell.textLabel.font copy];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:font.pointSize];
        cell.textLabel.textColor = [[[UIApplication sharedApplication] delegate] window].tintColor;
    }
    else
    {
        UIFont *font = [cell.textLabel.font copy];
        cell.textLabel.font = [UIFont systemFontOfSize:font.pointSize];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"viewConnection" sender:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxConnection *selectedConnection = [self.connections objectAtIndex:indexPath.row];
   
    selectedConnection.favorite = YES;
    
    [self updateConnection:selectedConnection.id
                      name:selectedConnection.name
                 ipAddress:selectedConnection.ipAddress
                      port:selectedConnection.port
                  username:selectedConnection.username
                  password:selectedConnection.password
                  favorite:selectedConnection.favorite];
    
}

#pragma mark - event handlers

- (IBAction)add:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"newConnection" sender:self];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newConnection"])
    {
        // Do nothing - just let the segue happen
    }
    else if ([segue.identifier isEqualToString:@"viewConnection"])
    {
        if ([sender isKindOfClass:[UITableViewCell class]])
        {
            UITableViewCell *cell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            BoxConnection *connection = [self.connections objectAtIndex:indexPath.row];
            
            if ([segue.destinationViewController isKindOfClass:[ConnectionViewController class]])
            {
                ConnectionViewController *viewCtrl = segue.destinationViewController;
                
                viewCtrl.id = connection.id;
                viewCtrl.name = connection.name;
                viewCtrl.ipAddress = connection.ipAddress;
                viewCtrl.port = connection.port;
                viewCtrl.username = connection.username;
                viewCtrl.password = connection.password;
                
                viewCtrl.delegate = self;
            }
        }
    }
}

#pragma mark - unwind handlers

- (IBAction)unwindCancelNewConnection:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Do nothing - the user canceled the "Add new connection" and was navigated back here
}

- (IBAction)unwindAddNewConnection:(UIStoryboardSegue *)segue sender:(id)sender
{
    // The user added a new connection - fetch the connection information
    if ([segue.identifier isEqualToString:@"unwindAddNewConnection"])
    {
        if ([segue.sourceViewController isKindOfClass:[NewConnectionViewController class]])
        {
             NewConnectionViewController *newCtrl = segue.sourceViewController;
             
             BoxConnection *connection = [[BoxConnection alloc] initWithId:newCtrl.id
                                                                      name:newCtrl.name
                                                                 ipAddress:newCtrl.ipAddress
                                                                      port:newCtrl.port
                                                                  username:newCtrl.username
                                                                  password:newCtrl.password
                                                                  favorite:NO];
             [self addBoxConnection:connection];

        }
    }
}

- (IBAction)unwindDeleteConnection:(UIStoryboardSegue *)segue sender:(id)sender
{
    // The user deleted a connection - find out which one and remove it
    if ([segue.identifier isEqualToString:@"unwindDeleteConnection"])
    {
        if ([segue.sourceViewController isKindOfClass:[EmbeddedEditConnectionViewController class]])
        {
            EmbeddedEditConnectionViewController *ctrl = segue.sourceViewController;
         
            [self removeBoxConnection:ctrl.id];
        }
    }
}

#pragma mark - UpdateConnectionDelegate impl

- (void)updateConnection:(NSString *)id
                    name:(NSString *)name
               ipAddress:(NSString* )ipAddress
                    port:(NSUInteger)port
                username:(NSString *)username
                password:(NSString *)password
               favorite:(BOOL)favorite
{
    // Get the connection that was updated
    
    BoxConnection *updatedConnection = nil;
    
    for (BoxConnection *connection in self.connections)
    {
        if ([connection.id isEqualToString:id])
        {
            updatedConnection = connection;
            break; // no need to iterate any futher
        }
    }
    
    if (updatedConnection)
    {
        // Found connection to update -> set new values
        updatedConnection.name = name;
        updatedConnection.ipAddress = ipAddress;
        updatedConnection.port = port;
        updatedConnection.username = username;
        updatedConnection.password = password;
        
        if (updatedConnection.favorite)
        {
            // Reset all other connections to be non favorite
            for (BoxConnection *connection in self.connections)
            {
                connection.favorite = NO;
            }
            
            // Set the updated connection to be the new favorite
            updatedConnection.favorite = YES;
        }
        
        // Save changes
        ConnectionsSerializer *settings = [[ConnectionsSerializer alloc] init];
        settings.connections = self.connections;
        [settings save];
        
        // Update UI
        [self.tableView reloadData];
    }
}

#pragma mark - helpers

- (NSString *)createConnectionText:(BoxConnection *)connection
{
    if (connection.favorite)
    {
        // Return name with a checkmark in front
        return [NSString stringWithFormat:@"\u2713 %@", connection.name];
    }
    
    // Return the name without checkmark
    return [NSString stringWithFormat:@"\u2001 %@", connection.name];
}

- (void)loadConnections
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t clientLoaderQueue = dispatch_queue_create("client fetch queue", NULL);
    
    dispatch_async(clientLoaderQueue, ^{
        
        ConnectionsSerializer *settings = [[ConnectionsSerializer alloc] init];
        
        NSArray *connections = settings.connections;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // executed by main thread - OK to update UI
            
            self.connections = connections;
            
            [self.refreshControl endRefreshing];
        });
    });
    
}

- (void)addBoxConnection:(BoxConnection *)connection
{
    NSMutableArray *connections = [self.connections mutableCopy];
    [connections addObject:connection];
    
    ConnectionsSerializer *settings = [[ConnectionsSerializer alloc] init];
    
    settings.connections = connections;
    
    [settings save];
    
    [self loadConnections];
}

- (void)removeBoxConnection:(NSString *)connectionId
{
    NSMutableArray *connections = [self.connections mutableCopy];
    BoxConnection *connectionToRemove = nil;
    
    for (BoxConnection *connection in connections)
    {
        if ([connection.id isEqualToString:connectionId])
        {
            connectionToRemove = connection;
            
            break; // no need to iterate any further
        }
    }
    
    if (connectionToRemove)
    {
        // Save to persistent storage and update UI
        ConnectionsSerializer *settings = [[ConnectionsSerializer alloc] init];
        
        [connections removeObject:connectionToRemove];
     
        if (connectionToRemove.favorite)
        {
            // The removed connection was the favorite -> pick the first remaining connection as favorite
            
            [[connections firstObject] setFavorite:YES];
        }
        
        settings.connections = connections;
        
        [settings save];
        
        [self loadConnections];
    }
}

- (void)clear
{
    ConnectionsSerializer *settings = [[ConnectionsSerializer alloc] init];
    
    [settings clear];
    
    [self loadConnections];
}

@end
