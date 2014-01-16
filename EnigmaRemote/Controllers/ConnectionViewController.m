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

@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfIPAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfPort;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation ConnectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editConnection"])
    {
        if ([segue.destinationViewController isKindOfClass:[EditConnectionViewController class]])
        {
            // Set current values in the edit controller
            
            EditConnectionViewController *editCtrl = segue.destinationViewController;
            
            editCtrl.id = self.id;
            editCtrl.name = self.name;
            editCtrl.ipAddress = self.ipAddress;
            editCtrl.port = self.port;
            editCtrl.username = self.username;
            editCtrl.password = self.password;
        }
    }
}

#pragma mark - unwind handlers

- (IBAction)unwindUpdateConnection:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"unwindUpdateConnection"])
    {
        if ([segue.sourceViewController isKindOfClass:[EditConnectionViewController class]])
        {
            EditConnectionViewController *editCtrl = segue.sourceViewController;
            
            self.id = editCtrl.id;
            self.name = editCtrl.name;
            self.ipAddress = editCtrl.ipAddress;
            self.port = editCtrl.port;
            self.username = editCtrl.username;
            self.password = editCtrl.password;
            
            [self updateUI];
            
            // Delegate update handling
            [self.delegate updateConnection:self.id
                                       name:self.name
                                  ipAddress:self.ipAddress
                                       port:self.port
                                   username:self.username
                                   password:self.password
                                   favorite:NO];
        }
    }
}

#pragma mark - internal helpers

- (void)updateUI
{
    self.tfName.text = self.name;
    self.tfIPAddress.text = self.ipAddress;
    self.tfPort.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.port];
    self.tfUsername.text = self.username;
    self.tfPassword.text = self.password;
}

@end
