//
//  CountriesViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/18/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "CountriesViewController.h"

@implementation CountriesViewController

@synthesize tableData = tableData_;
@synthesize currentCountry = currentCountry_;

- (id)init
{
	self = [super initWithNibName:@"CountriesViewController" bundle:nil];
	if (self) {
		settings_ = [Settings sharedSettings];
		self.currentCountry = -1;
	}
	return self;
}

- (void)dealloc
{
	[tableData_ release];
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
	self.title = @"Change Units";
	self.tableData = [Settings orderedCountries];
	self.tableView.rowHeight = 48.0;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tableData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.currentCountry < 0) {
		self.currentCountry = [self.tableData indexOfObject:settings_.defaultCountry];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	settings_.defaultCountry = [self.tableData objectAtIndex:self.currentCountry];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSDictionary *dictionary = [[Settings countries]  objectForKey:[self.tableData objectAtIndex:indexPath.row]];
	
	NSString *textLabelStr = [dictionary objectForKey:kSettingsUnitNameKey];
	
	NSString *detailLabelStr = [NSString stringWithFormat:@"%@, %@, %@",
								[dictionary objectForKey:kCountriesDistanceUnitKey],
								[dictionary objectForKey:kCountriesVolumeUnitKey],
								[dictionary objectForKey:kCountriesEfficiencyUnitKey]];
	
	cell.textLabel.text = textLabelStr;
	cell.detailTextLabel.text = detailLabelStr;
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	if (indexPath.row == self.currentCountry) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger localIndex = self.currentCountry;
	if (localIndex == indexPath.row) {
		return;
	}
	
	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:localIndex inSection:indexPath.section];
	
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	if (newCell.accessoryType == UITableViewCellAccessoryNone) {
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.currentCountry = indexPath.row;
	}
	
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
		oldCell.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Available Countries";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *titleStr = nil;
	if (section == 0) {
		titleStr = @"Available units are Distance, Volume and Fuel Efficiency. Changes will only affect new calculations.";
	}
	return titleStr;
}

@end
