//
//  OwnerInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OwnerInputViewController.h"

@interface OwnerInputViewController (Private)

- (NSString *)suffixForYear:(NSInteger)year;

@end

@implementation OwnerInputViewController

@synthesize delegate = delegate_;
@synthesize ownerTable = ownerTable_;
@synthesize inputPicker = inputPicker_;
@synthesize currentOwnership = currentOwnership_;
@synthesize footerText = footerText_;

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
	[ownerTable_ release];
	[inputPicker_ release];
	[currentOwnership_ release];
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
	self.title = @"Change Ownership";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.ownerTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSInteger initialRow = [self.currentOwnership integerValue] - 1;
	[self.inputPicker selectRow:initialRow inComponent:0 animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.delegate ownerInputViewControllerDidFinish:self save:YES];
}

#pragma mark - Private Methods

- (NSString *)suffixForYear:(NSInteger)year
{
	NSString *suffixStr;
	if (year == 1) {
		suffixStr = @"year";
	} else {
		suffixStr = @"years";
	}
	return suffixStr;
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
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	NSString *suffixStr = [self suffixForYear:[self.currentOwnership integerValue]];
	NSString *textLabelStr = [NSString stringWithFormat:@"%@ %@", self.currentOwnership, suffixStr];
	
	cell.textLabel.text = textLabelStr;
	
    return cell;
}

#pragma mark - Table view delegate methods

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 35.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return self.footerText;
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
	[self.ownerTable reloadData];
}

@end
