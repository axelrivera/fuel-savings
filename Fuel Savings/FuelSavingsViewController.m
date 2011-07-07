//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "NewSavingsViewController.h"

@implementation FuelSavingsViewController

@synthesize savingsTable = savingsTable_;
@synthesize vehicle1AnnualCost = vehicle1AnnualCost_;
@synthesize vehicle1TotalCost = vehicle1TotalCost_;

- (id)init
{
	self = [super initWithNibName:@"FuelSavingsViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		currencyFormatter_ = [[NSNumberFormatter alloc] init];
		[currencyFormatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter_ setMaximumFractionDigits:0];
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Compare";
		self.navigationItem.title = @"Compare Savings";
		self.tabBarItem.image = [UIImage imageNamed:@"compare_tab.png"];
	}
	return self;
}

- (void)dealloc
{
	[savingsTable_ release];
	[currencyFormatter_ release];
	[vehicle1AnnualCost_ release];
	[vehicle1TotalCost_ release];
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
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(newAction)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.savingsTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.savingsTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)newAction
{
	[savingsData_ resetNewCalculation];
	NewSavingsViewController *currentSavingsViewController = [[NewSavingsViewController alloc] init];
	currentSavingsViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	
	[currentSavingsViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)editAction
{
	
}

- (void)saveAction
{
	
}

#pragma mark - View Controller Delegates

- (void)newSavingsViewControllerDelegateDidFinish:(NewSavingsViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation = savingsData_.newCalculation;
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (savingsData_.currentCalculation == nil) {
		return 0;
	}
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSNumber *number1 = nil;
	//NSNumber *number2 = nil;
	if (indexPath.section == 0) {
		number1 = [savingsData_.currentCalculation annualCostForVehicle1];
		//number2 = [savingsData_.currentCalculation annualCostForVehicle2];
	} else {
		number1 = [savingsData_.currentCalculation totalCostForVehicle1];
		//number2 = [savingsData_.currentCalculation totalCostForVehicle2];
	}
	
	NSString *textLabelString = nil;
	NSString *detailTextLabelString = nil;
	
	if (indexPath.row == 0) {
		textLabelString = savingsData_.currentCalculation.vehicle1.name;
		detailTextLabelString = [currencyFormatter_ stringFromNumber:number1];
	} else {
		//textLabelString = savingsData_.currentCalculation.vehicle2.name;
		//detailTextLabelString = [currencyFormatter_ stringFromNumber:number2];
	}
	
		
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
	
	cell.textLabel.text = textLabelString;
	cell.detailTextLabel.text = detailTextLabelString;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Annual Cost";
	}
	return @"Total Cost";
}

@end
