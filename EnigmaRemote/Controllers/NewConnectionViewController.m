//
//  ConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "NewConnectionViewController.h"
#import "EmbeddedNewConnectionViewController.h"

@interface NewConnectionViewController ()

@property (nonatomic, weak) EmbeddedNewConnectionViewController *embeddedController;

@end

@implementation NewConnectionViewController

- (void)setDelegate:(id<ConnectionsDelegate>)delegate
{
    _delegate = delegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Handling of UI events

- (IBAction)save:(id)sender
{
    // A new connection was added
    BoxConnection *newConnection = [self createConnection];
   
    [self.delegate addBoxConnection:newConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    // The new connection was canceled - dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BoxConnection *)createConnection
{
    // Fetch data from UI and create model
    BoxConnection *connection = [[BoxConnection alloc] initWithName:self.embeddedController.name
                                                          ipAddress:self.embeddedController.ipAddress
                                                               port:self.embeddedController.port
                                                           username:self.embeddedController.username
                                                           password:self.embeddedController.password
                                                           favorite:YES]; // TODO: Hantera favoriter
    
    return connection;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedded"])
    {
        self.embeddedController = segue.destinationViewController;
    }
}

@end
