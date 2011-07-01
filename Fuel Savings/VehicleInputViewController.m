//
//  VehicleInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VehicleInputViewController.h"

#define AVG_ROWS 2
#define CITY_HIGHWAY_ROWS 3

@implementation VehicleInputViewController

@synthesize vehicleName = vehicleName_;

- (id)init
{
	self = [super initWithNibName:@"VehicleInputViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		
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
		
		editingVehicle_ = nil;
	}
	return self;
}

- (void)dealloc
{
	[nameTextField_ release];
	[avgTextField_ release];
	[cityTextField_ release];
	[highwayTextField_ release];
	[vehicleName_ release];
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
	
	nameTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 7.0, 190.0, 30.0)];
	nameTextField_.font = [UIFont systemFontOfSize:16.0];
	nameTextField_.adjustsFontSizeToFitWidth = YES;
	nameTextField_.placeholder = @"Name";
	nameTextField_.keyboardType = UIKeyboardTypeDefault;
	nameTextField_.returnKeyType = UIReturnKeyDefault;
	nameTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	nameTextField_.textAlignment = UITextAlignmentLeft;
	nameTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	nameTextField_.delegate = self;
	
	avgTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 7.0, 190.0, 30.0)];
	avgTextField_.font = [UIFont systemFontOfSize:16.0];
	avgTextField_.adjustsFontSizeToFitWidth = YES;
	avgTextField_.placeholder = @"Average MPG";
	avgTextField_.keyboardType = UIKeyboardTypeDefault;
	avgTextField_.returnKeyType = UIReturnKeyDefault;
	avgTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	avgTextField_.textAlignment = UITextAlignmentLeft;
	avgTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	avgTextField_.delegate = self;
	
	cityTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 7.0, 190.0, 30.0)];
	cityTextField_.font = [UIFont systemFontOfSize:16.0];
	cityTextField_.adjustsFontSizeToFitWidth = YES;
	cityTextField_.placeholder = @"City MPG";
	cityTextField_.keyboardType = UIKeyboardTypeDefault;
	cityTextField_.returnKeyType = UIReturnKeyDefault;
	cityTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	cityTextField_.textAlignment = UITextAlignmentLeft;
	cityTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	cityTextField_.delegate = self;
	
	highwayTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(110.0, 7.0, 190.0, 30.0)];
	highwayTextField_.font = [UIFont systemFontOfSize:16.0];
	highwayTextField_.adjustsFontSizeToFitWidth = YES;
	highwayTextField_.placeholder = @"Highway MPG";
	highwayTextField_.keyboardType = UIKeyboardTypeDefault;
	highwayTextField_.returnKeyType = UIReturnKeyDefault;
	highwayTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	highwayTextField_.textAlignment = UITextAlignmentLeft;
	highwayTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	highwayTextField_.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[nameTextField_ release];
	nameTextField_ = nil;
	[avgTextField_ release];
	avgTextField_ = nil;
	[cityTextField_ release];
	cityTextField_ = nil;
	[highwayTextField_ release];
	highwayTextField_ = nil;
	self.vehicleName = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	if (!editingVehicle_) {
		self.title = @"New Vehicle";
	} else {
		self.title = @"Edit Vehicle";
	}
	
	if (savingsData_.currentCalculation.type == SavingsCalculationTypeAverage) {
		infoRows_ = AVG_ROWS;
	} else {
		infoRows_ = CITY_HIGHWAY_ROWS;
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[self performSelector:@selector(dismissAction)];
}

- (void)dismissAction
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Methods

- (void)setEditingVehicle:(Vehicle *)vehicle
{
	editingVehicle_ = vehicle;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
		return infoRows_;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		static NSString *DatabaseIdentifier = @"DatabaseIdentifier";
		
		UITableViewCell *databaseCell = [tableView dequeueReusableCellWithIdentifier:DatabaseIdentifier];
		if (databaseCell == nil) {
			databaseCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DatabaseIdentifier] autorelease];
		}
		
		databaseCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		databaseCell.textLabel.text = @"Load From Database";
		
		return databaseCell;
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString *labelString = nil;
	UIView *accessoryView = nil;
	if (indexPath.row == 0) {
		labelString = @"Name";
		accessoryView = nameTextField_;
	} else if (indexPath.row == 1) {
		if (infoRows_ == AVG_ROWS) {
			labelString = @"Average";
			accessoryView = avgTextField_;
		} else {
			labelString = @"City";
			accessoryView = cityTextField_;
		}
	} else {
		labelString = @"Highway";
		accessoryView = highwayTextField_;
	}
	
	cell.selectionStyle = UITableViewCellEditingStyleNone;
	cell.textLabel.text = labelString;
	cell.accessoryView = accessoryView;
	
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
