//
//  PriceInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PriceInputViewController.h"
#import "SavingsData.h"

@implementation PriceInputViewController

@synthesize inputTextField = inputTextField_;
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
	}
	return self;
}

- (void)dealloc
{
	[inputTextField_ release];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.inputTextField = nil;
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[SavingsData sharedSavingsData].currentCalculation.fuelPrice = [NSDecimalNumber decimalNumberWithDecimal:[self.result decimalValue]];
	NSLog(@"Fuel Price: %@", [SavingsData sharedSavingsData].currentCalculation.fuelPrice);
	[self performSelector:@selector(dismissAction)];
}

- (void)dismissAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Keep a pointer to the field, so we can resign it from a toolbar
    self.inputTextField = textField;
    self.enteredDigits = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.enteredDigits length] > 0) {
        // Get the amount
		NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:self.enteredDigits];
        NSDecimalNumber *result = [decimal decimalNumberByMultiplyingByPowerOf10:currencyScale_];
		self.result = result;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
    // Check the length of the string
    if ([string length]) {
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
	
    NSDecimalNumber *result = nil;
	
    if ( ![self.enteredDigits isEqualToString:@""]) {
		NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:self.enteredDigits];
        result = [decimal decimalNumberByMultiplyingByPowerOf10:currencyScale_];
    } else {
        result = [NSDecimalNumber zero];
    }
	
    // Replace the text with the localized decimal number
    textField.text = [formatter_ stringFromNumber:result];
	
    return NO;  
}

@end
