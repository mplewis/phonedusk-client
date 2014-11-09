//
//  UILabel.m
//  Phonedusk
//
//  Created by Matthew Lewis on 11/9/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

#import "UILabel.h"

@implementation UILabel (CustomFont)

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFont:[UIFont fontWithName:@"Futura-Medium" size:self.font.pointSize]];
}

@end
