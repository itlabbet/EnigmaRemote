//
//  EmbeddedEditConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 13/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EmbeddedEditConnectionViewController.h"

@interface EmbeddedEditConnectionViewController () <UIAlertViewDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfIPAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfPort;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@end

@implementation EmbeddedEditConnectionViewController

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

#pragma mark - inherited

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

- (IBAction)delete:(UIButton *)sender
{
    [self showConfirmDelete];
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

- (void)showConfirmDelete
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Bekräfta"];
    [alert setMessage:@"Vill du radera anslutningen?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Radera"];
    [alert addButtonWithTitle:@"Avbryt"];
    
    [alert setDelegate:self];
    [alert show];
}

#pragma mark - UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // Clicked first button - Delete this contact
        // Forward the deletion handling to our delete delegate
        [self.delegate delete];
    }
    else if (buttonIndex == 1)
    {
        // Clicked second button - i.e. canceled - Do nothing 
    }
}

@end
