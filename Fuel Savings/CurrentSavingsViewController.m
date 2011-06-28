//
//  CurrentSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentSavingsViewController.h"
#import "TypeInputViewController.h"
#import "PriceInputViewController.h"
#import "NameInputViewController.h"

@implementation CurrentSavingsViewController

@synthesize currentTable = currentTable_;

- (id)init
{
	self = [super initWithNibName:@"CurrentSavingsViewController" bundle:nil];
	if (self) {
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																					  target:self
																					  action:@selector(dismissAction)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																					target:self
																					action:@selector(saveAction)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
		
		savingsData_ = [SavingsData sharedSavingsData];
	}
	return self;
}

- (void)dealloc
{
	[currentTable_ release];
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
	self.currentTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.title = @"New Savings";
	[self.currentTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)saveAction
{
	[self performSelector:@selector(dismissAction)];
}

- (void)dismissAction
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows;
	if (section == 0) {
		rows = 4;
	} else if (section == 1) {
		rows = 1;
	} else {
		rows = 1;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Type";
			cell.detailTextLabel.text = [savingsData_.currentCalculation stringForCurrentType];
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Fuel Price";
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			cell.detailTextLabel.text = [formatter stringFromNumber:savingsData_.currentCalculation.fuelPrice];
		} else if (indexPath.row == 2) {
			cell.textLabel.text = @"Distance";
			cell.detailTextLabel.text = @"100,000 miles/year";
		} else {
			cell.textLabel.text = @"Car Ownership";
			cell.detailTextLabel.text = @"20 years";
		}
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Add New Vehicle";
		}
	} else {
		cell.textLabel.text = @"Name";
		cell.detailTextLabel.text = savingsData_.currentCalculation.name;
	}
	
	return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController;
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			TypeInputViewController *inputViewController = [[TypeInputViewController alloc] init];
			inputViewController.title = @"Change Type";
			viewController = inputViewController;
		} else if (indexPath.row == 1) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.title = @"Change Price";
			viewController = inputViewController;
		} else if (indexPath.row == 2) {
			// Test
		} else {
			// test
		}
		
	} else if (indexPath.section == 1) {
		// data
	} else {
		NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
		inputViewController.title = @"Edit Name";
		viewController = inputViewController;
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

@end
