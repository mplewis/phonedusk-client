//
//  OtherUITweaks.m
//  Phonedusk
//
//  Created by Matthew Lewis on 11/9/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

#import "OtherUITweaks.h"
#import <UIKit/UIKit.h>

@implementation OtherUITweaks

+ (void)doTweaks
{
    [[UINavigationBar appearance] setTitleTextAttributes: @{
        NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:21.0f]
        }];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"Futura-Medium" size:21.0f]
       }
     forState:UIControlStateNormal];
}

@end
