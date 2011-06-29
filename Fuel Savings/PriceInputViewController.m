//
//  PriceInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PriceInputViewController.h"

@implementation PriceInputViewController

@synthesize inputTextField = inputTextField_;
@synthesize clearButton = clearButton_;
@synthesize enteredDigits = enteredDigits_;
@synthesize result = result_;

- (id)init
{
	self = [super initWithNibName:@"PriceInputViewController" bundle:nil];
	if (self) {
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
		
		formatter_ = [[NSNumberFormatter alloc] init];
		[formatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		currencyScale_ = -1 * [formatter_ maximumFractionDigits];
		savingsData_ = [SavingsData sharedSavingsData];
	}
	return self;
}

- (void)dealloc
{
	[inputTextField_ release];
	[clearButton_ release];
	[enteredDigits_ release];
	[result_ release];
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
	self.clearButton.title = @"Clear";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.inputTextField = nil;
	self.clearButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.result = savingsData_.currentCalculation.fuelPrice;
	self.inputTextField.text = [formatter_ stringFromNumber:self.result];
	
	[self.inputTextField becomeFirstResponder];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[self.inputTextField resignFirstResponder];
	savingsData_.currentCalculation.fuelPrice = self.result;
	[self performSelector:@selector(dismissAction)];
}

- (void)dismissAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)clearAction:(id)sender
{
	self.result = [NSDecimalNumber zero];
	self.enteredDigits = @"";
	self.inputTextField.text = [formatter_ stringFromNumber:self.result];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	NSDecimalNumber *digits = [self.result decimalNumberByMultiplyingByPowerOf10:abs(currencyScale_)];
	self.enteredDigits = [digits stringValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{	
    // Check the length of the string
    if ([string length] > 0) {
        self.enteredDigits = [self.enteredDigits stringByAppendingFormat:@"%d", [string integerValue]];
    } else {
        // This is a backspace
        NSUInteger len = [self.enteredDigits length];
        if (len > 1) {
            self.enteredDigits = [self.enteredDigits substringWithRange:NSMakeRange(0, len - 1)];
        } else {
            self.enteredDigits = @"";
        }
    }
	
    NSDecimalNumber *number = nil;
	
    if (![self.enteredDigits isEqualToString:@""]) {
		NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:self.enteredDigits];
        number = [decimal decimalNumberByMultiplyingByPowerOf10:currencyScale_];
    } else {
        number = [NSDecimalNumber zero];
    }
	
	self.result = number;
    // Replace the text with the localized decimal number
    textField.text = [formatter_ stringFromNumber:number];
	
    return NO;  
}

@end
