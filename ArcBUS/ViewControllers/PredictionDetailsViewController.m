//
//  PredictionDetailsViewController.m
//  ArcBUS
//
//  Created by David C. Thor on 2/23/14.
//  Copyright (c) 2014 Arcus Solutions. All rights reserved.
//

#import "PredictionDetailsViewController.h"

@interface PredictionDetailsViewController ()

@end

@implementation PredictionDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Prediction";
    self.title = @"Arrivals";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissModal)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.routeNumberLabel setText:self.routeDetails.title];
    [self.routeDirectionLabel setText:self.routeDirection.title];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] fontWithSize:12]];

    self.loadingDialog = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:self.loadingDialog];
    [self.loadingDialog showWhileExecuting:@selector(initPredictionData) onTarget:self withObject:nil animated:YES];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(initPredictionData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)initPredictionData
{
    NextbusDataService *nextbusDataService = [[NextbusDataService alloc] init];
    NSArray *predictions = [nextbusDataService getPredictionsForRoute:self.routeDetails AndDirection:self.routeDirection];
    
    for (PredictionsWrapper *predictionWrapper in predictions) {
        if ([predictionWrapper.stopTitle isEqualToString:self.routeStop.title]) {
            PredictionsDirection *predictionDirection = [predictionWrapper getDirectionForTitle:self.routeDirection.title];
            self.predictions = predictionDirection.predictions;
            break;
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    self.lastRefreshTime = [formatter stringFromDate:[NSDate date]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.loadingDialog hide:YES];
    });
}

- (void)dismissModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.routeStop.title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Last updated at %@", self.lastRefreshTime];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.predictions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PredictionCellFirst"];
        return cell.frame.size.height;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PredictionCell"];
        return cell.frame.size.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PredictionCellFirst"];
        UILabel *mainLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:2];
        
        Prediction *prediction = [self.predictions objectAtIndex:indexPath.row];
        [mainLabel setText:[NSString stringWithFormat:@"%ld minutes", (long)prediction.minutes]];
        
        NSTimeInterval seconds = [[NSString stringWithFormat:@"%ld", (long)prediction.seconds] doubleValue];
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSinceNow:seconds];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        [timeLabel setText:[dateFormatter stringFromDate:epochNSDate]];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PredictionCell"];
        UILabel *mainLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *busLabel = (UILabel *)[cell.contentView viewWithTag:3];
        
        Prediction *prediction = [self.predictions objectAtIndex:indexPath.row];
        [mainLabel setText:[NSString stringWithFormat:@"%ld minutes", (long)prediction.minutes]];
        
        NSTimeInterval seconds = [[NSString stringWithFormat:@"%ld", (long)prediction.seconds] doubleValue];
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSinceNow:seconds];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        [timeLabel setText:[dateFormatter stringFromDate:epochNSDate]];
        
        [busLabel setText:[NSString stringWithFormat:@"Bus #%@", prediction.vehicle]];
        
        return cell;
    }
}

@end
