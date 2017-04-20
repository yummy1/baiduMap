//
//  MMGuidancePathDetailHeaderView.h
//  happyDot
//
//  Created by MM on 17/4/17.
//
//

#import <UIKit/UIKit.h>

@interface MMGuidancePathDetailHeaderView : UITableViewHeaderFooterView
@property(nonatomic, strong)BMKTransitRouteLine *transitInfo;
@property(nonatomic, strong)BMKDrivingRouteLine *drivingInfo;
@property(nonatomic, strong)BMKWalkingRouteLine *walkingInfo;
@end
