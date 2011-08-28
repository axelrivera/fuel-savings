//
//  CurrencyViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
	self.title = @"Units";
	self.tableData = [Settings orderedCountries];
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
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 3;
	if (section == 0) {
		rows = [self.tableData count];
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		static NSString *SelectCellIdentifier = @"SelectCell";
		
		UITableViewCell *selectCell = [tableView dequeueReusableCellWithIdentifier:SelectCellIdentifier];
		if (selectCell == nil) {
			selectCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SelectCellIdentifier] autorelease];
		}
		
		NSDictionary *dictionary = [[Settings countries]  objectForKey:[self.tableData objectAtIndex:indexPath.row]];
		NSString *textLabelStr = [dictionary objectForKey:kSettingsUnitNameKey];
		
		selectCell.textLabel.text = textLabelStr;
		
		selectCell.accessoryType = UITableViewCellAccessoryNone;
		if (indexPath.row == self.currentCountry) {
			selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		
		selectCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		
		return selectCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	NSDictionary *dictionary = [[Settings countries]  objectForKey:[self.tableData objectAtIndex:self.currentCountry]];
	
	NSString *textLabelStr = nil;
	NSString *detailLabelStr = nil;
	
	if (indexPath.row == 0) {
		textLabelStr = @"Distance Units";
		detailLabelStr = [dictionary objectForKey:kCountriesDistanceUnitKey];
	} else if (indexPath.row == 1) {
		textLabelStr = @"Volume Units";
		detailLabelStr = [dictionary objectForKey:kCountriesVolumeUnitKey];
	} else {
		textLabelStr = @"Fuel Efficiency Units";
		detailLabelStr = [dictionary objectForKey:kCountriesEfficiencyUnitKey];
	}
	
	cell.textLabel.text = textLabelStr;
	cell.detailTextLabel.text = detailLabelStr;
	
	return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger localIndex = self.currentCountry;
	if (indexPath.section == 1 || localIndex == indexPath.row) {
		return;
	}
	
	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:localIndex inSection:indexPath.section];
	
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	if (newCell.accessoryType == UITableViewCellAccessoryNone) {
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.currentCountry = indexPath.row;
		[tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
	}
	
	UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
		oldCell.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *titleStr = nil;
	if (section == 0) {
		titleStr = @"Available Countries";
	} else {
		NSDictionary *dictionary = [[Settings countries]  objectForKey:[self.tableData objectAtIndex:self.currentCountry]];
		titleStr = [dictionary objectForKey:kSettingsUnitNameKey];
	}
	return titleStr;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *titleStr = nil;
	if (section == 0) {
		titleStr = @"Changes will only affect new calculations.";
	}
	return titleStr;
}

@end
