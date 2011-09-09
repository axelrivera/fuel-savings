//
//  PriceInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PriceInputViewController.h"

#define MAX_DIGITS 4
#define CURRENCY_SCALE -2

@implementation PriceInputViewController

@synthesize delegate = delegate_;
@synthesize inputToolbar = inputToolbar_;
@synthesize enteredDigits = enteredDigits_;
@synthesize currentPrice = currentPrice_;
@synthesize footerText = footerText_;
@synthesize key = key_;

- (id)init
{
	self = [super initWithNibName:@"PriceInputViewController" bundle:nil];
	if (self) {		
		formatter_ = [[NSNumberFormatter alloc] init];
		[formatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		self.enteredDigits = @"";
		self.currentPrice = [NSDecimalNumber zero];
		self.key = nil;
	}
	return self;
}

- (void)dealloc
{
	[inputTextField_ release];
	[inputToolbar_ release];
	[enteredDigits_ release];
	[currentPrice_ release];
	[footerText_ release];
	[key_ release];
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
	self.title = @"Change Price";
	
	UIBarButtonItem *clearButton = [[self.inputToolbar items] objectAtIndex:1];
	clearButton.title = @"Clear";
	
	inputTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 280.0, 30.0)];
	inputTextField_.font = [UIFont systemFontOfSize:18.0];
	inputTextField_.adjustsFontSizeToFitWidth = NO;
	inputTextField_.placeholder = @"Fuel Price";
	inputTextField_.keyboardType = UIKeyboardTypeNumberPad;
	inputTextField_.textAlignment = UITextAlignmentCenter;
	inputTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	inputTextField_.clearButtonMode = NO;
	inputTextField_.inputAccessoryView = self.inputToolbar;
	inputTextField_.delegate = self;
	
	self.tableView.sectionHeaderHeight = 35.0;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[inputTextField_ release];
	inputTextField_ = nil;
	self.inputToolbar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([self.currentPrice floatValue] > 0.0) {
		inputTextField_.text = [formatter_ stringFromNumber:self.currentPrice];
	} else {
		inputTextField_.text = @"";
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[inputTextField_ becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	BOOL save = YES;
	if ([self.currentPrice floatValue] == 0.0) {
		save = NO;
	}
	[self.delegate priceInputViewControllerDidFinish:self save:save];
}

#pragma mark - Custom Actions

- (IBAction)clearButtonAction:(id)sender
{
	self.currentPrice = [NSDecimalNumber zero];
	self.enteredDigits = @"";
	inputTextField_.text = @"";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryView = inputTextField_;
	
	return cell;
}

#pragma mark - Table view delegate methods

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return self.footerText;
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	if ([self.currentPrice floatValue] > 0.0) {
		NSDecimalNumber *digits = [self.currentPrice decimalNumberByMultiplyingByPowerOf10:abs(CURRENCY_SCALE)];
		self.enteredDigits = [digits stringValue];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{	
	//NSLog(@"Entered Digits (change start): %@", self.enteredDigits);
	//NSLog(@"Current Efficiency (change start): %@", self.currentPrice);
	
	if ([string isEqualToString:@"0"] && [self.enteredDigits length] == 0) {
		return NO;
	}
	
	// Check the length of the string
	if ([string length] > 0) {
		if ([self.enteredDigits length] + 1 <= MAX_DIGITS) {
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
	
	NSDecimalNumber *number = nil;
	
	if (![self.enteredDigits isEqualToString:@""]) {
		NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:self.enteredDigits];
		number = [decimal decimalNumberByMultiplyingByPowerOf10:CURRENCY_SCALE];
	} else {
		number = [NSDecimalNumber zero];
	}
	
	self.currentPrice = number;
	// Replace the text with the localized decimal number
	textField.text = [formatter_ stringFromNumber:number];
	
	//NSLog(@"Entered Digits (change end): %@", self.enteredDigits);
	//NSLog(@"Current Efficiency (change end): %@", self.currentPrice);
	
	return NO;  
}

@end
