//
//  AttributeTableViewController.m
//  CIFilters
//
//  Created by Naoto Yoshioka on 2013/12/12.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import "AttributeTableViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface UIImageView (CIImage)

@end

@implementation UIImageView (CIImage)

- (CIImage*)CIImage
{
    CIImage *image = self.image.CIImage;
    if (!image) {
        image = [CIImage imageWithCGImage:self.image.CGImage];
    }
    return image;
}

@end

@interface AttributeTableViewController ()

@end

@implementation AttributeTableViewController
{
    CIFilter *filter;
    NSDictionary *attributes;
    NSArray *inputKeys;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = self.filterName;
    filter = [CIFilter filterWithName:self.filterName];
    attributes = filter.attributes;
    inputKeys = filter.inputKeys;
    [filter setDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inputKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *key = inputKeys[indexPath.row];
    cell.textLabel.text = key;
    id a = attributes[key];
    NSString *class = a[kCIAttributeClass];
    NSString *type = a[kCIAttributeType];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", type, class];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)apply:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"attr = %@", attributes);
    
    AppDelegate *app = UIApplication.sharedApplication.delegate;
    ViewController *vc = (ViewController*)app.window.rootViewController;

    CIContext *context = [CIContext contextWithOptions:nil];
    
    if ([inputKeys containsObject:kCIInputImageKey]) {
        [filter setValue:vc.imageView.CIImage forKey:kCIInputImageKey];
    }

    //kCIInputGradientImageKey, __IPHONE_NA
    //kCIInputShadingImageKey, __IPHONE_NA

    if ([inputKeys containsObject:kCIInputBackgroundImageKey]) {
        [filter setValue:vc.backgroundImageView.CIImage forKey:kCIInputBackgroundImageKey];
    }
    
    if ([inputKeys containsObject:kCIInputMaskImageKey]) {
        [filter setValue:vc.maskImageView.CIImage forKey:kCIInputMaskImageKey];
    }
    
    if ([inputKeys containsObject:kCIInputTargetImageKey]) {
        [filter setValue:vc.targetImageView.CIImage forKey:kCIInputTargetImageKey];
    }

    CIImage *result = filter.outputImage;
    if (result) {
        CGRect extent = result.extent;
        CGImageRef cgImage = [context createCGImage:result fromRect:extent];
        vc.imageView.image = [UIImage imageWithCGImage:cgImage];
    } else {
        NSLog(@"warning: nil result");
    }
}

@end
