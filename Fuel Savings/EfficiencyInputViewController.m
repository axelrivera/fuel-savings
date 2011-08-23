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
@synthesize inputToolbar = inputToolbar_;
@synthesize currentType = currentType_;
@synthesize key = key_;
@synthesize enteredDigits = enteredDigits_;
@synthesize currentEfficiency = currentEfficiency_;
@synthesize footerText = footerText_;

- (id)init
{
	self = [super initWithNibName:@"EfficiencyInputViewController" bundle:nil];
	if (self) {
		self.currentType = EfficiencyInputTypeAverage;
		self.enteredDigits = @"";
		self.currentEfficiency = [NSNumber numberWithInteger:0];
		self.footerText = nil;
	}
	return self;
}

- (void)dealloc
{
	[efficiencyTextField_ release];
	[key_ release];
	[inputToolbar_ release];
	[enteredDigits_ release];
	[currentEfficiency_ release];
	[footerText_ release];
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
		
	self.title = @"Fuel Efficiency";
	
	UIBarButtonItem *clearButton = [[self.inputToolbar items] objectAtIndex:1];
	clearButton.title = @"Clear";
	
	efficiencyTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 280.0, 30.0)];
	efficiencyTextField_.font = [UIFont systemFontOfSize:18.0];
	efficiencyTextField_.adjustsFontSizeToFitWidth = NO;
	efficiencyTextField_.placeholder = @"Fuel Efficiency";
	efficiencyTextField_.keyboardType = UIKeyboardTypeNumberPad;
	efficiencyTextField_.textAlignment = UITextAlignmentCenter;
	efficiencyTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	efficiencyTextField_.clearButtonMode = NO;
	efficiencyTextField_.inputAccessoryView = self.inputToolbar;
	efficiencyTextField_.delegate = self;
	
	self.tableView.sectionHeaderHeight = 35.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[efficiencyTextField_ release];
	efficiencyTextField_ = nil;
	self.inputToolbar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([self.currentEfficiency integerValue] > 0) {
		efficiencyTextField_.text = [NSString stringWithFormat:@"%@ MPG", [self.currentEfficiency stringValue]];
	} else {
		efficiencyTextField_.text = @"";
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[efficiencyTextField_ becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	BOOL save = YES;
	if ([self.currentEfficiency integerValue] == 0) {
		save = NO;
	}
	[self.delegate efficiencyInputViewControllerDidFinish:self save:save];
}

#pragma mark - Custom Actions

- (IBAction)clearButtonAction:(id)sender
{
	self.currentEfficiency = [NSNumber numberWithInteger:0];
	self.enteredDigits = @"";
	efficiencyTextField_.text = @"";
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
	cell.accessoryView = efficiencyTextField_;
	
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
	if ([self.currentEfficiency integerValue] > 0) {
		self.enteredDigits = [self.currentEfficiency stringValue];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{	
	//NSLog(@"Entered Digits (change start): %@", self.enteredDigits);
	//NSLog(@"Current Efficiency (change start): %@", self.currentEfficiency);
	
	// Don't do anything if the first entered digit is 0
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

	//NSLog(@"Entered Digits (change end): %@", self.enteredDigits);
	//NSLog(@"Current Efficiency (change end): %@", self.currentEfficiency);
	
    return NO;  
}

@end
