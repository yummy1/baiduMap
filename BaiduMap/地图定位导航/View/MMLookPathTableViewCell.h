//
//  MMLookPathTableViewCell.h
//  happyDot
//
//  Created by MM on 17/4/14.
//
//

#import <UIKit/UIKit.h>
@class BMKTransitRouteLine;
@interface MMLookPathTableViewCell : UITableViewCell
@property(nonatomic, strong)BMKTransitRouteLine *transitInfo;
@property(nonatomic, strong)BMKDrivingRouteLine *drivingInfo;
@property(nonatomic, strong)BMKWalkingRouteLine *walkingInfo;

@property(nonatomic, strong)UILabel *pathText;
@property(nonatomic, strong)UILabel *LeftNum;
@end
