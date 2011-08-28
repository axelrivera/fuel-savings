//
//  VehicleSelectViewController.m
//  MPGDatabase
//
//  Created by Axel Rivera on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VehicleSelectViewController.h"
#import "CurrentSavingsViewController.h"
#import "CurrentTripViewController.h"
#import "VehicleDetailsViewController.h"

@interface VehicleSelectViewController (Private)

- (void)setupDataSourceAndFetchRequest;

@end

@implementation VehicleSelectViewController

@synthesize selectionType = _selectionType;
@synthesize year = _year;
@synthesize make = _make;
@synthesize mpgDatabaseInfo = _mpgDatabaseInfo;
@synthesize context = _context;
@synthesize currentSavingsViewController = _currentSavingsViewController;
@synthesize currentTripViewController = _currentTripViewController;

- (id)init
{
	self = [super initWithNibName:@"VehicleSelectViewController" bundle:nil];
	if (self) {
		self.selectionType = VehicleSelectionTypeYear;
		self.year = @"";
		self.make = @"";
		self.mpgDatabaseInfo = nil;
		self.context = nil;
		self.currentSavingsViewController = nil;
		self.currentTripViewController = nil;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Database";
		self.tabBarItem.image = [UIImage imageNamed:@"mpg_tab.png"];
	}
	return self;
}

- (id)initWithType:(VehicleSelectionType)type year:(NSString *)year make:(NSString *)make
{
	self = [self init];
	if (self) {
		self.selectionType = type;
		self.year = year;
		self.make = make;
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
	self.year = nil;
	self.make = nil;
	self.mpgDatabaseInfo = nil;
	self.context = nil;
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.tabBarController == nil) {
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																																									target:self
																																									action:@selector(cancelAction)];
		self.navigationItem.rightBarButtonItem = cancelButton;
		[cancelButton release];
	}
	
	[self setupDataSourceAndFetchRequest];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.mpgDatabaseInfo = nil;
}

#pragma mark - Action Methods

- (void)cancelAction
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)setupDataSourceAndFetchRequest
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MPGDatabaseInfo" inManagedObjectContext:_context];
	
	[fetchRequest setEntity:entity];
	
	[fetchRequest setResultType:NSDictionaryResultType];
	
	NSString *titleStr = nil;
	
	if (self.selectionType == VehicleSelectionTypeYear) {
		NSDictionary *properties = [entity propertiesByName];
		NSPropertyDescription *yearProperty = [properties objectForKey:@"year"];
		
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:yearProperty]];
		[fetchRequest setReturnsDistinctResults:YES];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		
		titleStr = @"Select Year";
		[sort release];
	} else if (self.selectionType == VehicleSelectionTypeMake) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@", self.year];
		[fetchRequest setPredicate:predicate];
		
		NSDictionary *properties = [entity propertiesByName];
		NSPropertyDescription *makeProperty = [properties objectForKey:@"make"];
		
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:makeProperty]];
		[fetchRequest setReturnsDistinctResults:YES];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"make" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		[sort release];
		
		titleStr = self.year;
	} else {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND make == %@", self.year, self.make];
		[fetchRequest setPredicate:predicate];
		
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"model" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		
		titleStr = self.make;
		[sort release];
	}
	
	NSError *error;
	self.mpgDatabaseInfo = [self.context executeFetchRequest:fetchRequest error:&error];
	
	self.navigationItem.title = titleStr;
	
	[fetchRequest release];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.mpgDatabaseInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	
	if (self.selectionType == VehicleSelectionTypeModel) {
		cellStyle = UITableViewCellStyleSubtitle;
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSDictionary *info = [self.mpgDatabaseInfo objectAtIndex:indexPath.row];
	
	NSString *labelStr = nil;
	NSString *detailStr = nil;
	
	if (self.selectionType == VehicleSelectionTypeYear) {
		labelStr = [[info objectForKey:@"year"] stringValue];
	} else if (self.selectionType == VehicleSelectionTypeMake) {
		labelStr = [info objectForKey:@"make"];
	} else {
		labelStr = [info objectForKey:@"model"];
		detailStr = [NSString stringWithFormat:@"%@ Cyl, %@ L, %@",
								 [info objectForKey:@"cylinders"],
								 [info objectForKey:@"engine"],
								 [info objectForKey:@"transmission"]];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = labelStr;
	
	if (detailStr) {
		cell.detailTextLabel.text = detailStr;
	}
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary *info = [self.mpgDatabaseInfo objectAtIndex:indexPath.row];
	UIViewController *viewController = nil;
	
	if (self.selectionType == VehicleSelectionTypeYear) {
		NSString *yearStr = [[info objectForKey:@"year"] stringValue];
		VehicleSelectViewController *selectController = [[VehicleSelectViewController alloc] initWithType:VehicleSelectionTypeMake
																																																 year:yearStr
																																																 make:nil];
		selectController.context = self.context;
		selectController.currentSavingsViewController = self.currentSavingsViewController;
		selectController.currentTripViewController = self.currentTripViewController;
		viewController = selectController;
	} else if (self.selectionType == VehicleSelectionTypeMake) {
		NSString *yearStr = self.year;
		NSString *makeStr = [info objectForKey:@"make"];
		VehicleSelectViewController *selectController = [[VehicleSelectViewController alloc] initWithType:VehicleSelectionTypeModel
																																																 year:yearStr
																																																 make:makeStr];
		selectController.context = self.context;
		selectController.currentSavingsViewController = self.currentSavingsViewController;
		selectController.currentTripViewController = self.currentTripViewController;
		viewController = selectController;
	} else {
		VehicleDetailsViewController *detailsController = [[VehicleDetailsViewController alloc] initWithInfo:info];
		
		if (self.currentSavingsViewController) {
			detailsController.delegate = self.currentSavingsViewController;
		}
		
		if (self.currentTripViewController) {
			detailsController.delegate = self.currentTripViewController;
		}
		
		viewController = detailsController;
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

@end
