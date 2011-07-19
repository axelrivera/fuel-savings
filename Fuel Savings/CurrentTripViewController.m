//
//  CurrentTripViewController.m
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentTripViewController.h"

@implementation CurrentTripViewController

@synthesize delegate = delegate_;
@synthesize isEditingTrip = isEditingTrip_;

- (id)init
{
	self = [super initWithNibName:@"CurrentTripViewController" bundle:nil];
	if (self) {
		tripData_ = [TripData sharedTripData];
	}
	return self;
}

- (void)dealloc
{
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	if (self.isEditingTrip) {
		self.title = @"Edit Trip";
	} else {
		self.title = @"New Trip";
	}
	
	[self.tableView reloadData];
}

#pragma mark - Custom Actions

- (void)saveAction
{
	[self.delegate currentTripViewControllerDelegateDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate currentTripViewControllerDelegateDidFinish:self save:NO];
}

#pragma mark - UIViewController Delegates

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.fuelPrice = controller.currentPrice;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.distance = controller.currentDistance;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.vehicle.name = controller.currentName;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.vehicle.avgEfficiency = controller.currentEfficiency;
		tripData_.currentCalculation.vehicle.cityEfficiency = controller.currentEfficiency;
		tripData_.currentCalculation.vehicle.highwayEfficiency = controller.currentEfficiency;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString *textLabelString = nil;
	NSString *detailTextLabelString = nil;
	
    if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			textLabelString = @"Fuel Price";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			
			NSString *numberString = [formatter stringFromNumber:tripData_.currentCalculation.fuelPrice];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ /gallon", numberString];
		} else {
			textLabelString = @"Distance";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[formatter setMaximumFractionDigits:0];
			
			NSString *numberString = [formatter stringFromNumber:tripData_.currentCalculation.distance];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ miles", numberString];
		}
	} else {
		if (indexPath.row == 0) {
			textLabelString = @"Name";
			detailTextLabelString = tripData_.currentCalculation.vehicle.name;
		} else {
			textLabelString = @"Fuel Efficiency";
			detailTextLabelString = [NSString stringWithFormat:@"%@ MPG",
									 [tripData_.currentCalculation.vehicle.avgEfficiency stringValue]];
		}
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
	
	cell.textLabel.text = textLabelString;
	cell.detailTextLabel.text = detailTextLabelString;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
    
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = tripData_.currentCalculation.fuelPrice;
			viewController = inputViewController;
		} else {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] initWithType:DistanceInputTypeTrip];
			inputViewController.delegate = self;
			inputViewController.currentDistance = tripData_.currentCalculation.distance;
			viewController = inputViewController;
		}
	} else {
		if (indexPath.row == 0) {
			NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentName = tripData_.currentCalculation.vehicle.name;
			viewController = inputViewController;
		} else {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentEfficiency = tripData_.currentCalculation.vehicle.avgEfficiency;
			inputViewController.currentType	= EfficiencyInputTypeAverage;
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

@end
