//
//  EmbeddedNewConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 13/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EmbeddedNewConnectionViewController.h"

@interface EmbeddedNewConnectionViewController () <UITextFieldDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfIPAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfPort;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation EmbeddedNewConnectionViewController

#pragma mark - getters

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

#pragma mark - overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hook up delegates
    self.tfName.delegate = self;
    self.tfIPAddress.delegate = self;
    self.tfPort.delegate = self;
    self.tfUsername.delegate = self;
    self.tfPassword.delegate = self;
    
    [self.tfName becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // If Return is pressed on keyboard - jump to next textfield
    
    if (textField == self.tfName)
    {
        [self.tfIPAddress becomeFirstResponder];
    }
    
    if (textField == self.tfIPAddress)
    {
        [self.tfPort becomeFirstResponder];
    }
    
    if (textField == self.tfPort)
    {
        [self.tfUsername becomeFirstResponder];
    }
    
    if (textField == self.tfUsername)
    {
        [self.tfPassword becomeFirstResponder];
    }
    
    if (textField == self.tfPassword)
    {
        [self.tfPassword resignFirstResponder];
    }
    
    return YES;
}

@end
