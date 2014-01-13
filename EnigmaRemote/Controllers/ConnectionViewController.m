//
//  ConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "ConnectionViewController.h"
#import "EditConnectionViewController.h"

@interface ConnectionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *ipAddress;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ConnectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

#pragma mark - Implementation of ConnectionDelegate
// TODO: hanteringen av dessa bör nog ligga i edit kontrollern...

- (void)updateBoxConnection:(BoxConnection *)connection
{
    self.connection = connection;
    
    [self.delegate updateBoxConnection:self.connection];
    
    [self updateUI];
}

- (void)removeBoxConnection:(BoxConnection *)connection
{
    [self.delegate removeBoxConnection:connection];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editConnection"])
    {
        if ([segue.destinationViewController isKindOfClass:[EditConnectionViewController class]])
        {
            EditConnectionViewController *editCtrl = segue.destinationViewController;
            editCtrl.delegate = self;
            editCtrl.connection = self.connection;
        }
    }
}

#pragma mark - internal helpers

- (void)updateUI
{
    self.name.text = self.connection.name;
    self.ipAddress.text = self.connection.ipAddress;
    self.port.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.connection.port];
    self.username.text = self.connection.username;
    self.password.text = self.connection.password;
}

@end
