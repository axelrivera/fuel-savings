//
//  OwnerInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OwnerInputViewController.h"

@implementation OwnerInputViewController

@synthesize inputLabel = inputLabel_;
@synthesize inputPicker = inputPicker_;
@synthesize result = result_;

- (id)init
{
	self = [super initWithNibName:@"OwnerInputViewController" bundle:nil];
	if (self) {
		savingsData = [SavingsData sharedSavingsData];
		
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
		
		NSMutableArray *input = [[NSMutableArray alloc] initWithCapacity:50];
		
		for (NSInteger i = 1; i <= 20; i++) {
			[input addObject:[NSNumber numberWithInteger:i]];
		}
		
		inputData_ = [[NSArray alloc] initWithArray:input];
		[input release];
	}
	return self;
}

- (void)dealloc
{
	[inputData_ release];
	[inputLabel_ release];
	[inputPicker_ release];
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
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.result = savingsData.currentCalculation.carOwnership;
	
	NSInteger initialRow = [self.result integerValue] - 1;
	
	NSString *yearString;
	if (initialRow == 0) {
		yearString = @"year";
	} else {
		yearString = @"years";
	}
	self.inputLabel.text = [NSString stringWithFormat:@"%@ %@", [self.result stringValue], yearString];
	[self.inputPicker selectRow:initialRow inComponent:0 animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	savingsData.currentCalculation.carOwnership = self.result;
	[self performSelector:@selector(dismissAction)];
}

- (void)dismissAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - UIPickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [inputData_ count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[inputData_ objectAtIndex:row] stringValue];
}

#pragma UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 80.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.result = [inputData_ objectAtIndex:row];
	NSString *yearString;
	if (row == 0) {
		yearString = @"year";
	} else {
		yearString = @"years";
	}
	self.inputLabel.text = [NSString stringWithFormat:@"%@ %@", [self.result stringValue], yearString];
}

@end
