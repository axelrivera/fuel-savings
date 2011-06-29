//
//  DistanceInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DistanceInputViewController.h"

#define DISTANCE_MULTIPLIER 1000

@implementation DistanceInputViewController

@synthesize inputLabel = inputLabel_;
@synthesize inputPicker = inputPicker_;
@synthesize result = result_;

- (id)init
{
	self = [super initWithNibName:@"DistanceInputViewController" bundle:nil];
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
		
		for (NSInteger i = 1; i <= 50; i++) {
			[input addObject:[NSNumber numberWithInteger:i * DISTANCE_MULTIPLIER]];
		}
		
		inputData_ = [[NSArray alloc] initWithArray:input];
		[input release];
		
		numberFormatter_ = [[NSNumberFormatter alloc] init];
		[numberFormatter_ setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter_ setMaximumFractionDigits:0];
	}
	return self;
}

- (void)dealloc
{
	[inputData_ release];
	[numberFormatter_ release];
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
	self.inputLabel = nil;
	self.inputPicker = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.result = savingsData.currentCalculation.distance;
	
	NSInteger initialRow = ([self.result integerValue] / DISTANCE_MULTIPLIER) - 1;
	
	[self.inputPicker selectRow:initialRow inComponent:0 animated:NO];
	self.inputLabel.text = [NSString stringWithFormat:@"%@ miles/year", [numberFormatter_ stringFromNumber:self.result]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	savingsData.currentCalculation.distance = self.result;
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
	return [numberFormatter_ stringFromNumber:[inputData_ objectAtIndex:row]];
}

#pragma UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 120.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.result = [inputData_ objectAtIndex:row];
	self.inputLabel.text = [NSString stringWithFormat:@"%@ miles/year", [numberFormatter_ stringFromNumber:self.result]];
}

@end
