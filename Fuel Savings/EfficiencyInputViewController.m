//
//  MPGInputViewController.m
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EfficiencyInputViewController.h"

#define MAX_DIGITS 3

@implementation EfficiencyInputViewController

@synthesize delegate = delegate_;
@synthesize efficiencyTextField = efficiencyTextField_;
@synthesize clearButton = clearButton_;
@synthesize enteredDigits = enteredDigits_;
@synthesize currentEfficiency = currentEfficiency_;
@synthesize currentType = currentType_;

- (id)init
{
	self = [super initWithNibName:@"EfficiencyInputViewController" bundle:nil];
	if (self) {
		self.enteredDigits = @"";
		self.currentEfficiency = [NSNumber numberWithInteger:0];
		self.currentType = EfficiencyInputTypeAverage;
	}
	return self;
}

- (void)dealloc
{
	[efficiencyTextField_ release];
	[clearButton_ release];
	[enteredDigits_ release];
	[currentEfficiency_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(dismissAction)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																				action:@selector(doneAction)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	self.title = @"Fuel Efficiency";
	self.clearButton.title = @"Clear";
	self.efficiencyTextField.placeholder = @"MPG";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.efficiencyTextField = nil;
	self.clearButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([self.currentEfficiency integerValue] > 0) {
		self.efficiencyTextField.text = [NSString stringWithFormat:@"%@ MPG", [self.currentEfficiency stringValue]];
	} else {
		self.efficiencyTextField.text = @"";
	}
	
	[self.efficiencyTextField becomeFirstResponder];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[self.delegate efficiencyInputViewControllerDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate efficiencyInputViewControllerDidFinish:self save:NO];
}


- (void)clearAction:(id)sender
{
	self.currentEfficiency = [NSNumber numberWithInteger:0];
	self.enteredDigits = @"";
	self.efficiencyTextField.text = @"";
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	self.enteredDigits = [self.currentEfficiency stringValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{	
    // Check the length of the string
    if ([string length] > 0) {
		if ([self.enteredDigits length] <= MAX_DIGITS) {
			self.enteredDigits = [self.enteredDigits stringByAppendingFormat:@"%d", [string integerValue]];
		}
    } else {
        // This is a backspace
        NSUInteger len = [self.enteredDigits length];
        if (len > 1) {
            self.enteredDigits = [self.enteredDigits substringWithRange:NSMakeRange(0, len - 1)];
        } else {
            self.enteredDigits = @"";
        }
    }
	
    if (![self.enteredDigits isEqualToString:@""]) {
		self.currentEfficiency = [NSNumber numberWithInteger:[self.enteredDigits integerValue]];
    } else {
        self.currentEfficiency = [NSNumber numberWithInteger:0];
	}
    
	if ([self.currentEfficiency integerValue] > 0) {
		textField.text = [NSString stringWithFormat:@"%@ MPG", [self.currentEfficiency stringValue]];
	} else {
		textField.text = @"";
	}
	
    return NO;  
}

@end
