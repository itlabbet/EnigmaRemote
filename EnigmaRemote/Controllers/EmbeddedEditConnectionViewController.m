//
//  EmbeddedEditConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 13/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EmbeddedEditConnectionViewController.h"

@interface EmbeddedEditConnectionViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfIPAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfPort;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation EmbeddedEditConnectionViewController

- (NSString *)name
{
    return self.tfName.text;
}

- (NSString *)ipAddress
{
    return self.tfIPAddress.text;
}

- (NSUInteger)port
{
    NSInteger port = [self.tfPort.text integerValue];
    
    return port;
}

- (NSString *)username
{
    return self.tfUsername.text;
}

- (NSString *)password
{
    return self.tfPassword.text;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];

}

#pragma mark - internal helpers

- (void)updateUI
{
    // NOTE: using private member variables here since the getters override fetchung values from UI elements
    self.tfName.text = _name;
    self.tfIPAddress.text = _ipAddress;
    self.tfPort.text = [NSString stringWithFormat:@"%lu", (unsigned long)_port];
    self.tfUsername.text = _username;
    self.tfPassword.text = _password;
}

@end
