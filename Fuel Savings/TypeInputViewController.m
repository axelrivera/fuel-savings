//
//  TypeInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TypeInputViewController.h"
#import "SavingsCalculation.h"

@implementation TypeInputViewController

@synthesize delegate = delegate_;
@synthesize currentType = currentType_;

- (id)init
{
	self = [super initWithNibName:@"TypeInputViewController" bundle:nil];
	if (self) {
		self.currentType = 0;
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
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																				action:@selector(doneAction)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	self.title = @"Change Use";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Custom Actions

- (void)doneAction
{
	[self.delegate typeInputViewControllerDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate typeInputViewControllerDidFinish:self save:NO];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if (indexPath.row == 0) {
		cell.textLabel.text = [SavingsCalculation stringValueForType:SavingsCalculationTypeAverage];
	} else {
		cell.textLabel.text = [SavingsCalculation stringValueForType:SavingsCalculationTypeCombined];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	if (self.currentType == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger localIndex = self.currentType;
    if (localIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:localIndex inSection:0];
	
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentType = indexPath.row;
    }
	
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
