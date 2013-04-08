//
//  AADeleteButtonTableViewCell.m
//  Breaks
//
//  Created by Sasha Friedenberg on 6/6/12.
//  Copyright (c) 2012 Apple, Stamford. All rights reserved.
//

#import "AADeleteButtonTableViewCell.h"

@implementation AADeleteButtonTableViewCell

static UIImage *kDeleteButtonBackground;

+ (void)initialize
{
	if (self == [AADeleteButtonTableViewCell class])
	{
		kDeleteButtonBackground = [[UIImage imageNamed:@"deleteButtonBackground"] retain];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundColor = [UIColor redColor];
		
		self.textLabel.font = [UIFont boldSystemFontOfSize:18];
		self.textLabel.textColor = [UIColor whiteColor];
		self.textLabel.shadowColor = [UIColor darkTextColor];
		self.textLabel.shadowOffset = CGSizeMake(0, -1);
		self.textLabel.contentMode = UIViewContentModeCenter;
		self.textLabel.textAlignment = UITextAlignmentCenter;
    }
	
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect bounds = self.contentView.bounds;
	
	CGRect textLabelRect = self.textLabel.frame;
	textLabelRect.origin.x = floor(CGRectGetMidX(bounds) - (textLabelRect.size.width / 2));
	textLabelRect.origin.y = floor(CGRectGetMidY(bounds) - (textLabelRect.size.height / 2));
}

@end
