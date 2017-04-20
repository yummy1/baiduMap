//
//  MMGuidancePathDetailTableView.h
//  happyDot
//
//  Created by MM on 17/4/17.
//
//

#import <UIKit/UIKit.h>

@interface MMGuidancePathDetailTableView : UITableView
@property(nonatomic, strong)BMKTransitRouteLine *transitPath;
@property(nonatomic, strong)BMKDrivingRouteLine *drivingPath;
@property(nonatomic, strong)BMKWalkingRouteLine *walkingPath;

//表示选择的哪个//0公交、1开车、2步行
@property(nonatomic, assign)NSInteger type;

@end
