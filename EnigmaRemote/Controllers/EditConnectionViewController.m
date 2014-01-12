//
//  EditConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 12/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EditConnectionViewController.h"


@interface EditConnectionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *ipAddress;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation EditConnectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.connection.name;
    
    [self updateUI];
}


#pragma mark - Handling of UI events

- (IBAction)save:(id)sender
{
    // TODO:
    BoxConnection *updatedConnection = nil;
    
    [self.delegate updateBoxConnection:updatedConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)remove:(id)sender
{
    // TODO:
    BoxConnection *removedConnection = nil;
    
    [self.delegate removeBoxConnection:removedConnection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - internal helpers

- (void)updateUI
{
    self.name.text = self.connection.name;
    self.ipAddress.text = self.connection.ipAddress;
    self.port.text = [NSString stringWithFormat:@"%d", self.connection.port];
    self.username.text = self.connection.username;
    self.password.text = self.connection.password;
}

@end
