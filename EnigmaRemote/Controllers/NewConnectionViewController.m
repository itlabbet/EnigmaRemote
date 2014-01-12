//
//  ConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "NewConnectionViewController.h"

@interface NewConnectionViewController ()

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
    BoxConnection *newConnection = [self createConnection];
   
    [self.delegate addBoxConnection:newConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    // TODO: temporary for testing
    [self.delegate clear];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BoxConnection *)createConnection
{
    // TODO: get all fields
    
    // TODO: sätta som favorite = YES?? - bättre välja med en checkbox i listan med anslutnigar
    BoxConnection *connection = [[BoxConnection alloc] initWithName:@"DB800SE"
                                                          ipAddress:@"192.168.10.12"
                                                               port:80 username:@""
                                                           password:@""
                                                           favorite:YES];
    
    return connection;
}

@end
