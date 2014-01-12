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
    [self updateModel];
    
    [self.delegate updateBoxConnection:self.connection];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// TODO: anslut denna till en Action
- (IBAction)remove:(id)sender
{
    [self.delegate removeBoxConnection:self.connection];
    
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

- (void)updateModel
{
    NSInteger port = [self.port.text integerValue];
    
    self.connection.name = self.name.text;
    self.connection.ipAddress = self.ipAddress.text;
    self.connection.port = port;
    self.connection.username = self.username.text;
    self.connection.password = self.password.text;
}

@end
