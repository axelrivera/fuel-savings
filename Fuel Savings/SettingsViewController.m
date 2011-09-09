//
//  SettingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "CountriesViewController.h"
#import "AboutViewController.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

@implementation SettingsViewController

@synthesize contentView = contentView_;
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
	[contentView_ release];
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

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.contentView.tag = kAdContentViewTag;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.contentView = nil;
	self.settingsTable = nil;
	self.settingsData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = self;
	[self layoutCurrentOrientation:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = nil;
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

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[self layoutCurrentOrientation:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[self layoutCurrentOrientation:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	// Stop or Pause Stuff Here
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	// Get things back up running again!
}

@end
