//
//  VehicleInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VehicleInputViewController.h"

#define AVG_ROWS 2
#define CITY_HIGHWAY_ROWS 3

@implementation VehicleInputViewController

@synthesize delegate = delegate_;
@synthesize currentName = currentName_;
@synthesize currentAvgEfficiency = currentAvgEfficiency_;
@synthesize currentCityEfficiency = currentCityEfficiency_;
@synthesize currentHighwayEfficiency = currentHighwayEfficiency_;
@synthesize isEditingVehicle = isEditingVehicle_;
@synthesize editVehicleIndex = editVehicleIndex_;

- (id)init
{
	self = [super initWithNibName:@"VehicleInputViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																					  target:self
																					  action:@selector(dismissAction)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																					target:self
																					action:@selector(finishAction)];
		self.navigationItem.rightBarButtonItem = finishButton;
		[finishButton release];
		
		self.currentName = @"";
		self.currentAvgEfficiency = [NSNumber numberWithInteger:0];
		self.currentCityEfficiency = [NSNumber numberWithInteger:0];
		self.currentHighwayEfficiency = [NSNumber numberWithInteger:0];
		self.isEditingVehicle = NO;
		self.editVehicleIndex = -1;
	}
	return self;
}

- (void)dealloc
{
	[currentName_ release];
	[currentAvgEfficiency_ release];
	[currentCityEfficiency_ release];
	[currentHighwayEfficiency_ release];
	
	if (isEditingVehicle_) {
		[deleteView_ release];
	}
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
	self.currentName = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	if (!isEditingVehicle_) {
		self.title = @"New Vehicle";
	} else {
		self.title = @"Edit Vehicle";
	}
	
	if (savingsData_.newCalculation.type == SavingsCalculationTypeAverage) {
		infoRows_ = AVG_ROWS;
	} else {
		infoRows_ = CITY_HIGHWAY_ROWS;
	}
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)finishAction
{
	[self.delegate vehicleInputViewControllerDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate vehicleInputViewControllerDidFinish:self save:NO];
}

- (void)deleteVehicleAction
{
	if (editVehicleIndex_ > -1) {
		[savingsData_.newCalculation.vehicles removeObjectAtIndex:editVehicleIndex_];
	}
	[self performSelector:@selector(dismissAction)];
}

- (void)showDeleteVehicleActionSheet:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:@"Delete Vehicle"
													otherButtonTitles:nil];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
		return infoRows_;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		static NSString *DatabaseIdentifier = @"DatabaseIdentifier";
		
		UITableViewCell *databaseCell = [tableView dequeueReusableCellWithIdentifier:DatabaseIdentifier];
		if (databaseCell == nil) {
			databaseCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DatabaseIdentifier] autorelease];
		}
		
		databaseCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		databaseCell.textLabel.text = @"Load From Database";
		
		return databaseCell;
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString *labelString = nil;
	NSString *detailString = nil;
	if (indexPath.row == 0) {
		labelString = @"Name";
		detailString = self.currentName;
	} else if (indexPath.row == 1) {
		if (infoRows_ == AVG_ROWS) {
			labelString = @"Average MPG";
			detailString = [NSString stringWithFormat:@"%@ MPG", [self.currentAvgEfficiency stringValue]];
		} else {
			labelString = @"City MPG";
			detailString = [NSString stringWithFormat:@"%@ MPG", [self.currentCityEfficiency stringValue]];
		}
	} else {
		labelString = @"Highway MPG";
		detailString = [NSString stringWithFormat:@"%@ MPG", [self.currentHighwayEfficiency stringValue]];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = labelString;
	cell.detailTextLabel.text = detailString;
	
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentName = self.currentName;
			viewController = inputViewController;
		} else {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			if (indexPath.row == 1) {
				if (infoRows_ == AVG_ROWS) {
					inputViewController.currentEfficiency = self.currentAvgEfficiency;
					inputViewController.currentType = EfficiencyInputTypeAverage;
				} else {
					inputViewController.currentEfficiency = self.currentCityEfficiency;
					inputViewController.currentType = EfficiencyInputTypeCity;
				}
			} else {
				inputViewController.currentEfficiency = self.currentHighwayEfficiency;
				inputViewController.currentType = EfficiencyInputTypeHighway;
			}
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (isEditingVehicle_ == NO) {
		return nil;
	}
	
	if (section == 0) {
		return nil;
	}

	if (deleteView_ == nil) {
		deleteView_ = [[UIView alloc] initWithFrame:CGRectZero];
		
		UIButton *deleteButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		
		[deleteButton addTarget:self action:@selector(showDeleteVehicleActionSheet:) forControlEvents:UIControlEventTouchDown];
		[deleteButton setTitle:@"Delete Vehicle" forState:UIControlStateNormal];
		
		CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
		deleteButton.frame = CGRectMake(10.0, 25.0, buttonWidth, 44.0);
		
		[deleteView_ addSubview:deleteButton];
		[deleteButton release];
	}
	return deleteView_;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (section == 1) {
		return 69.0;
	}
	return 0.0;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self performSelector:@selector(deleteVehicleAction)];
	}
}

# pragma mark View Controller Delegates

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentName = controller.currentName;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save
{
	if (save) {
		if (controller.currentType == EfficiencyInputTypeAverage) {
			self.currentAvgEfficiency = controller.currentEfficiency;
		} else if (controller.currentType == EfficiencyInputTypeCity) {
			self.currentCityEfficiency = controller.currentEfficiency;
		} else {
			self.currentHighwayEfficiency = controller.currentEfficiency;
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

@end
