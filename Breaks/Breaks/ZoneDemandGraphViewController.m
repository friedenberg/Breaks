//
//  ZoneDemandGraphViewController.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/16/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "ZoneDemandGraphViewController.h"

@interface ZoneDemandGraphViewController ()

@end

@implementation ZoneDemandGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonItem:)];
    self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
}

- (void)doneBarButtonItem:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
