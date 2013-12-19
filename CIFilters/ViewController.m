//
//  ViewController.m
//  CIFilters
//
//  Created by Naoto Yoshioka on 2013/12/06.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import "ViewController.h"
#import "Messages.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;

@end

@implementation ViewController
{
    Messages *messages;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    messages = [[Messages alloc] init];
    messages = [Messages theMessages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reset:(id)sender {
    self.imageView.image = self.originalImageView.image;
}

@end
