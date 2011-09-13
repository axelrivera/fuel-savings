//
//  MySavingsViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "MySavingsViewController.h"
#import "SavingsData.h"
#import "Savings.h"
#import "Trip.h"
#import "FuelSavingsViewController.h"
#import "TripViewController.h"
#import "RLCustomButton+Default.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

@interface MySavingsViewController (Private)

- (void)setupSegmentedControl;
- (void)reloadTableData;

@end

@implementation MySavingsViewController

@synthesize contentView = contentView_;
@synthesize mySavingsTable = mySavingsTable_;
@synthesize tableData = tableData_;
@synthesize segmentedControl = segmentedControl_;

- (id)init
{
	self = [super initWithNibName:@"MySavingsViewController" bundle:nil];
	if (self) {
		selectedIndex_ = 0;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Saved";
		self.navigationItem.title = @"Saved";
		self.tabBarItem.image = [UIImage imageNamed:@"saved_tab.png"];
	}
	return self;
}

- (void)dealloc
{
	[contentView_ release];
	[mySavingsTable_ release];
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
	
	self.contentView.tag = kAdContentViewTag;
	
	[self setupSegmentedControl];
	self.navigationItem.titleView = self.segmentedControl;
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	mySavingsTable_.sectionHeaderHeight = 10.0;
	mySavingsTable_.sectionFooterHeight = 10.0;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.contentView = nil;
	self.mySavingsTable = nil;
	self.segmentedControl = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = self;
	[self layoutCurrentOrientation:NO];
	
	[self.segmentedControl setSelectedSegmentIndex:selectedIndex_];
	[self reloadTableData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = nil;
}

#pragma mark - Custom Actions

- (void)changedSegmentedControlAction
{
	selectedIndex_ = [self.segmentedControl selectedSegmentIndex];
	if (selectedIndex_ == 0) {
		self.tableData =  [[SavingsData sharedSavingsData] savingsArray];
	} else {
		self.tableData = [[SavingsData sharedSavingsData] tripArray];
	}
	[self reloadTableData];
}

#pragma mark - Private Methods

- (void)setupSegmentedControl
{	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:@"Savings", @"Trips", nil]];
	[segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	[segmentedControl setMomentary:NO];
	[segmentedControl addTarget:self action:@selector(changedSegmentedControlAction) forControlEvents:UIControlEventValueChanged];
	
	[segmentedControl setWidth:80.0 forSegmentAtIndex:0];
	[segmentedControl setWidth:80.0 forSegmentAtIndex:1];
	
	self.segmentedControl = segmentedControl;
	[segmentedControl release];
}

- (void)reloadTableData
{
	if ([self.tableData count] > 0) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	} else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	[self.mySavingsTable reloadData];
}

#pragma mark - View Controller Delegates

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		[[self.tableData objectAtIndex:selectedRow_] setName:controller.currentName];
		[self reloadTableData];
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Methods

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
	// Always call super implementation of this method, it needs to do some work
	[super setEditing:flag animated:animated];
	[mySavingsTable_ setEditing:flag animated:animated];
	self.segmentedControl.enabled = !self.segmentedControl.enabled;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.tableData == nil) {
		return 0;
	}
	NSInteger sections = 1;
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	if (section == 0) {
		rows = [self.tableData count];
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	UIImage *iconImage = nil;
	NSString *textLabelString = nil;
	
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		Savings *calculation = [self.tableData objectAtIndex:indexPath.row];
		iconImage = [UIImage imageNamed:@"tags.png"];
		textLabelString = [calculation stringForName];
	} else {
		Trip *calculation = [self.tableData objectAtIndex:indexPath.row];
		textLabelString = [calculation stringForName];
		iconImage = [UIImage imageNamed:@"navigation.png"];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.imageView.image = iconImage;
	
	cell.textLabel.font = [UIFont systemFontOfSize:16.0];
	cell.textLabel.text = textLabelString;
	
	return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *currentController = nil;
	
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		FuelSavingsViewController *fuelSavingsViewController = [[FuelSavingsViewController alloc] init];
		Savings *calculation = [self.tableData objectAtIndex:indexPath.row];
		fuelSavingsViewController.title	= [calculation stringForName];
		fuelSavingsViewController.currentSavings = calculation;
		currentController = fuelSavingsViewController;
	} else {
		TripViewController *tripViewController = [[TripViewController alloc] init];
		Trip *calculation = [self.tableData objectAtIndex:indexPath.row];
		tripViewController.title = [calculation stringForName];
		tripViewController.currentTrip = calculation;
		currentController = tripViewController;
	}
	
	if (currentController) {
		[self.navigationController pushViewController:currentController animated:YES];
		[currentController release];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSString *name = nil;
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		Savings *calculation = [self.tableData objectAtIndex:indexPath.row];
		name = calculation.name;
	}
	
	NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
	inputViewController.delegate = self;
	inputViewController.currentName = name;
	
	selectedRow_ = indexPath.row;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	[inputViewController release];
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// If the table view is asking to commit a delete command...
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// We remove the row being deleted from the possessions array
		[self.tableData removeObjectAtIndex:indexPath.row];
		// We also remove that row from the table view with an animation
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
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
