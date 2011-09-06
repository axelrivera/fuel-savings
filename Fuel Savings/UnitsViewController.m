//
//  UnitsViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnitsViewController.h"

@implementation UnitsViewController

@synthesize tableData = tableData_;
@synthesize currentDistance = currentDistance_;
@synthesize currentVolume = currentVolume_;
@synthesize currentEfficiency = currentEfficiency_;

- (id)init
{
	self = [super initWithNibName:@"UnitsViewController" bundle:nil];
	if (self) {
		settings_ = [Settings sharedSettings];
		distanceUnits_ = [[Settings orderedDistanceUnits] retain];
		volumeUnits_ = [[Settings orderedVolumeUnits] retain];
		efficiencyUnits_ = [[Settings orderedEfficiencyUnits] retain];
		self.currentDistance = -1;
		self.currentVolume = -1;
		self.currentEfficiency = -1;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
	[distanceUnits_ release];
	[volumeUnits_ release];
	[efficiencyUnits_ release];
	[tableData_ release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Units";
	
	self.tableData = [NSArray arrayWithObjects:distanceUnits_, volumeUnits_, efficiencyUnits_, nil];
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
	
	if (self.currentDistance < 0) {
		self.currentDistance = [distanceUnits_ indexOfObject:settings_.defaultDistanceUnit];
	}
	
	if (self.currentVolume < 0) {
		self.currentVolume = [volumeUnits_ indexOfObject:settings_.defaultVolumeUnit];
	}
	
	if (self.currentEfficiency < 0) {
		self.currentEfficiency = [efficiencyUnits_ indexOfObject:settings_.defaultEfficiencyUnit];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	settings_.defaultDistanceUnit = [distanceUnits_ objectAtIndex:self.currentDistance];
	settings_.defaultVolumeUnit = [volumeUnits_ objectAtIndex:self.currentVolume];
	settings_.defaultEfficiencyUnit = [efficiencyUnits_ objectAtIndex:self.currentEfficiency];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return [[self.tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSDictionary *dataDictionary = nil;
	NSInteger currentIndex = 0;
	
	if (indexPath.section == 0) {
		dataDictionary = [Settings distanceUnits];
		currentIndex = self.currentDistance;
	} else if (indexPath.section == 1) {
		dataDictionary = [Settings volumeUnits];
		currentIndex = self.currentVolume;
	} else {
		dataDictionary = [Settings efficiencyUnits];
		currentIndex = self.currentEfficiency;
	}
	
	NSDictionary *dictionary = [dataDictionary objectForKey:[[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
	
	NSString *textLabelStr = [NSString stringWithFormat:@"%@ (%@)",
							  [dictionary objectForKey:kSettingsUnitNameKey],
							  [dictionary objectForKey:kSettingsUnitUnitKey]];
	
	cell.textLabel.font = [UIFont systemFontOfSize:17.0];
	cell.textLabel.text = textLabelStr;
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	if (indexPath.row == currentIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSInteger localIndex = 0;
	if (indexPath.section == 0) {
		localIndex = self.currentDistance;
	} else if (indexPath.section == 1) {
		localIndex = self.currentVolume;
	} else {
		localIndex = self.currentEfficiency;
	}
	
	if (localIndex == indexPath.row) {
		return;
	}
	
	NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:localIndex inSection:indexPath.section];
	
	UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
	if (newCell.accessoryType == UITableViewCellAccessoryNone) {
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		NSInteger row = indexPath.row;
		if (indexPath.section == 0) {
			self.currentDistance = row;
		} else if (indexPath.section == 1) {
			self.currentVolume = row;
		} else {
			self.currentEfficiency = row;
		}
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
		titleStr = @"Distance Units";
	} else if (section == 1) {
		titleStr = @"Fuel Volume Units";
	} else {
		titleStr = @"Fuel Efficiency Units";
	}
	return titleStr;
}

@end
