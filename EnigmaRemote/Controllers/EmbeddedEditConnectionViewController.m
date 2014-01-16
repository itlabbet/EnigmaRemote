//
//  EmbeddedEditConnectionViewController.m
//  EnigmaRemote
//
//  Created by Niklas Andersson on 13/01/14.
//  Copyright (c) 2014 Niklas Andersson. All rights reserved.
//

#import "EmbeddedEditConnectionViewController.h"

@interface EmbeddedEditConnectionViewController () <UIActionSheetDelegate, UITextFieldDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfIPAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfPort;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (strong, nonatomic) UIActionSheet *actionSheet;

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

    // Subscribe to "going to background event"
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(applicationWillResignActive:)
                                                name:UIApplicationWillResignActiveNotification
                                               object: nil];
    
    // Create the action sheet for confirm delete - but do not display it yet
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Bekräfta ta bort"
                                                       delegate:self
                                              cancelButtonTitle:@"Avbryt"
                                         destructiveButtonTitle:@"Radera"
                                              otherButtonTitles:nil];

    // Hook up delegates
    self.tfName.delegate = self;
    self.tfIPAddress.delegate = self;
    self.tfPort.delegate = self;
    self.tfUsername.delegate = self;
    self.tfPassword.delegate = self;
    
    [self updateUI];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.actionSheet showInView:self.tableView];
}


#pragma mark - UIActionSheetDelegate implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self performSegueWithIdentifier:@"unwindDeleteConnection" sender:self];
    }
    else if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        // Clicked second button - i.e. canceled - Do nothing
    }
}

#pragma mark - UIApplicationDidEnterBackgroundNotification handler

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:NO];
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
