//
//  MySavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MySavingsViewController.h"
#import "SavingsCalculation.h"

@interface MySavingsViewController (Private)

- (void)setupSegmentedControl;

@end

@implementation MySavingsViewController

@synthesize segmentedControl = segmentedControl_;

- (id)init
{
	self = [super initWithNibName:@"MySavingsViewController" bundle:nil];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		self.title = @"Saved";
		self.navigationItem.title = @"Saved";
		self.tabBarItem.image = [UIImage imageNamed:@"saved_tab.png"];
	}
	return self;
}

- (void)dealloc
{
	[segmentedControl_ release];
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
	
	[self setupSegmentedControl];
	self.navigationItem.titleView = self.segmentedControl;
	[self.segmentedControl setSelectedSegmentIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.segmentedControl = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

#pragma mark - Custom Actions

- (void)changedSegmentedControl
{
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		tableData_ = savingsData_.savedCalculations;
	} else {
		tableData_ = nil;
	}
	
	[self.tableView reloadData];
}

#pragma mark - Private Methods

- (void)setupSegmentedControl
{	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Savings", @"Trips", nil]];
	[segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	[segmentedControl setMomentary:NO];
	[segmentedControl addTarget:self action:@selector(changedSegmentedControl) forControlEvents:UIControlEventValueChanged];
	
	
	[segmentedControl setWidth:150.0 forSegmentAtIndex:0];
	[segmentedControl setWidth:150.0 forSegmentAtIndex:1];
	
	self.segmentedControl = segmentedControl;
	[segmentedControl release];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [tableData_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *textLabelString = nil;
	
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		SavingsCalculation *calculation = [tableData_ objectAtIndex:indexPath.row];
		textLabelString = calculation.name;
	}
	
	cell.textLabel.text = textLabelString;
	
	return cell;
}

@end
