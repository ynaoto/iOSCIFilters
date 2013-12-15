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

@interface MySlider : UISlider
@property (nonatomic) NSString *attributeKey;
@property (nonatomic) NSString *attributeClass;
@property (nonatomic) CIVector *attributeVector;
@property (nonatomic) int attributeVectorIndex;

@end

@implementation MySlider
{
    UILabel *valueLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, h/2)];
        [self addSubview:valueLabel];
    }
    return self;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    valueLabel.text = [NSString stringWithFormat:@"%g", value];
    return result;
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
//    [filter setDefaults];
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

- (void)sliderChanged:(MySlider*)sender event:(UIEvent*)event
{
//    NSLog(@"%s: value = %g, key = %@, class = %@", __FUNCTION__, sender.value, sender.attributeKey, sender.attributeClass);
    NSString *attrClass = sender.attributeClass;
    if ([attrClass isEqualToString:@"NSNumber"]) {
        [filter setValue:@(sender.value) forKey:sender.attributeKey];
    } else if ([attrClass isEqualToString:@"CIVector"]) {
        CIVector *v = sender.attributeVector;
        CGFloat x[v.count];
        for (int i = 0; i < v.count; i++) {
            x[i] = [v valueAtIndex:i];
        }
        x[sender.attributeVectorIndex] = sender.value;
        [filter setValue:[CIVector vectorWithValues:x count:v.count] forKey:sender.attributeKey];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *attrKey = inputKeys[indexPath.row];
    cell.textLabel.text = attrKey;
    id attr = attributes[attrKey];
    NSString *attrClass = attr[kCIAttributeClass];
    NSString *attrType = attr[kCIAttributeType];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@) %@",
                                 [attrType stringByReplacingOccurrencesOfString:@"CIAttribute" withString:@""],
                                 attrClass,
                                 [filter valueForKey:attrKey]];
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:MySlider.class]) {
            [view removeFromSuperview];
        }
    }

    CGFloat cellW = cell.frame.size.width;
    CGFloat cellH = cell.frame.size.height;
    
    // NSNumber
    // CIImage
    // CIColor
    // CIVector
    // NSValue
    // NSData
    // NSString
    // NSObject
    if ([attrClass isEqualToString:@"NSNumber"]) {
        MySlider *slider = [[MySlider alloc] initWithFrame:CGRectMake(cellW/2, 0, cellW/2, cellH)];
        [cell.contentView addSubview:slider];
        slider.minimumValue = [attr[kCIAttributeSliderMin] floatValue];
        slider.maximumValue = [attr[kCIAttributeSliderMax] floatValue];
        slider.value = [attr[kCIAttributeDefault] floatValue];
        slider.alpha = 0.5;
        slider.attributeKey = attrKey;
        slider.attributeClass = attrClass;
        [slider addTarget:self action:@selector(sliderChanged:event:) forControlEvents:UIControlEventValueChanged];
    } else if ([attrClass isEqualToString:@"CIVector"]) {
        CIVector *v = attr[kCIAttributeDefault];
        CGFloat x = cellW/2;
        CGFloat w = cellW/2/v.count;
        for (int i = 0; i < v.count; i++) {
            MySlider *slider = [[MySlider alloc] initWithFrame:CGRectMake(x + i * w, 0, w, cellH)];
            [cell.contentView addSubview:slider];
            slider.minimumValue = -300;
            slider.maximumValue = 300;
            slider.value = [v valueAtIndex:i];
            slider.alpha = 0.5;
            slider.attributeKey = attrKey;
            slider.attributeClass = attrClass;
            slider.attributeVector = v;
            slider.attributeVectorIndex = i;
            [slider addTarget:self action:@selector(sliderChanged:event:) forControlEvents:UIControlEventValueChanged];
        }
    }

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

    if ([inputKeys containsObject:kCIInputImageKey]) {
        [filter setValue:vc.imageView.CIImage forKey:kCIInputImageKey];
    }

    //kCIInputGradientImageKey, __IPHONE_NA
#define kCIInputGradientImageKey @"inputGradientImage" // ??? CIColorMap で使っている
    //kCIInputShadingImageKey, __IPHONE_NA

    if ([inputKeys containsObject:kCIInputBackgroundImageKey]) {
        [filter setValue:vc.backgroundImageView.CIImage forKey:kCIInputBackgroundImageKey];
    }
    
    if ([inputKeys containsObject:kCIInputTargetImageKey]) {
        [filter setValue:vc.targetImageView.CIImage forKey:kCIInputTargetImageKey];
    }

    if ([inputKeys containsObject:kCIInputMaskImageKey]) {
        [filter setValue:vc.maskImageView.CIImage forKey:kCIInputMaskImageKey];
    }
    
    if ([inputKeys containsObject:kCIInputGradientImageKey]) {
        [filter setValue:vc.gradientImageView.CIImage forKey:kCIInputGradientImageKey];
    }

    CIImage *result = filter.outputImage;
    if (result) {
        CIContext *context = [CIContext contextWithOptions:nil];
        CGRect rect = result.extent;
        if (CGRectIsInfinite(rect)) {
            NSLog(@"infinite extent!");
            rect = vc.imageView.bounds;
        }
        CGImageRef cgImage = [context createCGImage:result fromRect:rect];
        vc.imageView.image = [UIImage imageWithCGImage:cgImage];
    } else {
        NSLog(@"warning: nil result");
    }
}

@end
