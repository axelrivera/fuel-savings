//
//  SettingsViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "SettingsViewController.h"
#import "CountriesViewController.h"
#import "AboutViewController.h"

@implementation SettingsViewController

@synthesize settingsTable = settingsTable_;
@synthesize settingsData = settingsData_;

- (id)init
{
	self = [super initWithNibName:@"SettingsViewController" bundle:nil];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Settings";
		self.navigationItem.title = @"Settings";
		self.tabBarItem.image = [UIImage imageNamed:@"settings_tab.png"];
	}
	return self;
}

- (void)dealloc
{
	[settingsTable_ release];
	[settingsData_ release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.settingsTable = nil;
	self.settingsData = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

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
	
	NSString *textLabelStr = nil;
	
	if (indexPath.section == 0) {
		textLabelStr = @"Change Units";
	} else {
		textLabelStr = @"About";
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.textLabel.text = textLabelStr;
	
	return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
	
	if (indexPath.section == 0) {
		CountriesViewController *controller = [[CountriesViewController alloc] init];
		viewController = controller;
	} else {
		AboutViewController *controller = [[AboutViewController alloc] init];
		viewController = controller;
	}
	
	if (viewController) {
		viewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

@end
