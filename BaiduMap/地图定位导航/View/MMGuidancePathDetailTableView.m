//
//  MMGuidancePathDetailTableView.m
//  happyDot
//
//  Created by MM on 17/4/17.
//
//

#import "MMGuidancePathDetailTableView.h"
#import "MMLookPathTableViewCell.h"
#import "MMGuidancePathDetailTableViewCell.h"
#import "MMGuidancePathDetailHeaderView.h"

@interface MMGuidancePathDetailTableView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)NSMutableArray *pathArr;
@property(nonatomic, strong)NSMutableArray *pathTypeArr;
@end
@implementation MMGuidancePathDetailTableView
- (NSMutableArray *)pathArr
{
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
        _pathTypeArr = [NSMutableArray array];
        //0公交、1开车、2步行
        switch (_type) {
            case 0:
            {
                [_transitPath.steps enumerateObjectsUsingBlock:^( BMKTransitStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_pathArr addObject:obj.instruction];
                    [_pathTypeArr addObject:[NSString stringWithFormat:@"%d",obj.stepType]];
                }];
            }
                break;
            case 1:
            {
                [_drivingPath.steps enumerateObjectsUsingBlock:^( BMKDrivingStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_pathArr addObject:obj.instruction];
                }];
            }
                break;
            case 2:
            {
                [_walkingPath.steps enumerateObjectsUsingBlock:^( BMKWalkingStep * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_pathArr addObject:obj.instruction];
                }];
            }
                break;
            default:
                break;
        }
    }
    return _pathArr;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
    }
    return self;
}

#pragma mark - UITableViewDataSource\delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pathArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMGuidancePathDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MMGuidancePathDetailTableViewCell class])];
    if (cell == nil) {
        cell = [[MMGuidancePathDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MMGuidancePathDetailTableViewCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.pathText.text = self.pathArr[indexPath.row];
    //0公交、1开车、2步行
    switch (_type) {
        case 0:
        {
            //0公交、1地铁、2步行
            switch ([self.pathTypeArr[indexPath.row] integerValue]) {
                case 0:
                    cell.leftImageView.image = [UIImage imageNamed:@"map_bus2"];

                    break;
                case 1:
                    cell.leftImageView.image = [UIImage imageNamed:@"map_subway"];

                    break;
                case 2:
                    cell.leftImageView.image = [UIImage imageNamed:@"map_walking"];

                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.leftImageView.image = [UIImage imageNamed:@"map_driving"];
        }
            break;
        case 2:
        {
            cell.leftImageView.image = [UIImage imageNamed:@"map_walking"];

        }
            break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *arrts = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize size = [self.pathArr[indexPath.row] boundingRectWithSize:CGSizeMake(ViewWidth-52, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
    return size.height+30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MMGuidancePathDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MMGuidancePathDetailHeaderView class])];
    if (headerView == nil) {
        headerView = [[MMGuidancePathDetailHeaderView alloc] initWithReuseIdentifier:NSStringFromClass([MMGuidancePathDetailHeaderView class])];
    }
    switch (_type) {
        case 0:
            headerView.transitInfo = _transitPath;
            break;
        case 1:
            headerView.drivingInfo = _drivingPath;
            break;
        case 2:
            headerView.walkingInfo = _walkingPath;
            break;
        default:
            break;
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}
@end
