//
//  OwnerInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OwnerInputViewController.h"

@implementation OwnerInputViewController

@synthesize delegate = delegate_;
@synthesize inputLabel = inputLabel_;
@synthesize inputPicker = inputPicker_;
@synthesize currentOwnership = currentOwnership_;

- (id)init
{
	self = [super initWithNibName:@"OwnerInputViewController" bundle:nil];
	if (self) {
		NSMutableArray *input = [[NSMutableArray alloc] initWithCapacity:50];
		
		for (NSInteger i = 1; i <= 20; i++) {
			[input addObject:[NSNumber numberWithInteger:i]];
		}
		
		inputData_ = [[NSArray alloc] initWithArray:input];
		[input release];
		
		self.currentOwnership = [NSNumber numberWithInteger:5];
	}
	return self;
}

- (void)dealloc
{
	[inputData_ release];
	[inputLabel_ release];
	[inputPicker_ release];
	[currentOwnership_ release];
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
	
	self.title = @"Change Ownership";
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
	
	NSInteger initialRow = [self.currentOwnership integerValue] - 1;
	
	NSString *yearString;
	if (initialRow == 0) {
		yearString = @"year";
	} else {
		yearString = @"years";
	}
	self.inputLabel.text = [NSString stringWithFormat:@"%@ %@", [self.currentOwnership stringValue], yearString];
	[self.inputPicker selectRow:initialRow inComponent:0 animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[self.delegate ownerInputViewControllerDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate ownerInputViewControllerDidFinish:self save:NO];
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
	self.currentOwnership = [inputData_ objectAtIndex:row];
	NSString *yearString;
	if (row == 0) {
		yearString = @"year";
	} else {
		yearString = @"years";
	}
	self.inputLabel.text = [NSString stringWithFormat:@"%@ %@", [self.currentOwnership stringValue], yearString];
}

@end
