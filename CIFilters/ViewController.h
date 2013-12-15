//
//  ViewController.h
//  CIFilters
//
//  Created by Naoto Yoshioka on 2013/12/06.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *targetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;

@end
