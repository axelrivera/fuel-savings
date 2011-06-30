//
//  VehicleInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VehicleInputViewController.h"

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
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}

@end
