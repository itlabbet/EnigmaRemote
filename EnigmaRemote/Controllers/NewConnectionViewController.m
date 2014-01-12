//
//  ConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "NewConnectionViewController.h"

@interface NewConnectionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *ipAddress;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BoxConnection *)createConnection
{
    NSInteger port = [self.port.text integerValue];

    BoxConnection *connection = [[BoxConnection alloc] initWithName:self.name.text
                                                          ipAddress:self.ipAddress.text
                                                               port:port
                                                           username:self.username.text
                                                           password:self.password.text
                                                           favorite:NO];
    
    return connection;
}

@end
