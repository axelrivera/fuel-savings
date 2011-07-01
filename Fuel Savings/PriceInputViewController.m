//
//  PriceInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PriceInputViewController.h"

@implementation PriceInputViewController

@synthesize delegate = delegate_;
@synthesize inputTextField = inputTextField_;
@synthesize clearButton = clearButton_;
@synthesize enteredDigits = enteredDigits_;
@synthesize currentPrice = currentPrice_;

- (id)init
{
	self = [super initWithNibName:@"PriceInputViewController" bundle:nil];
	if (self) {		
		formatter_ = [[NSNumberFormatter alloc] init];
		[formatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		currencyScale_ = -1 * [formatter_ maximumFractionDigits];
		self.currentPrice = [NSDecimalNumber zero];
	}
	return self;
}

- (void)dealloc
{
	[inputTextField_ release];
	[clearButton_ release];
	[enteredDigits_ release];
	[currentPrice_ release];
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
	
	self.title = @"Change Price";
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
	
	self.inputTextField.text = [formatter_ stringFromNumber:self.currentPrice];
	[self.inputTextField becomeFirstResponder];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[self.inputTextField resignFirstResponder];
	[self.delegate priceInputViewControllerDidFinish:self save:YES];
	 
}

- (void)dismissAction
{
	[self.delegate priceInputViewControllerDidFinish:self save:NO];
}

- (void)clearAction:(id)sender
{
	self.currentPrice = [NSDecimalNumber zero];
	self.enteredDigits = @"";
	self.inputTextField.text = [formatter_ stringFromNumber:self.currentPrice];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	NSDecimalNumber *digits = [self.currentPrice decimalNumberByMultiplyingByPowerOf10:abs(currencyScale_)];
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
	
	self.currentPrice = number;
    // Replace the text with the localized decimal number
    textField.text = [formatter_ stringFromNumber:number];
	
    return NO;  
}

@end
