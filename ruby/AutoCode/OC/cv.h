
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CLASSNAME : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_loadingView;
    UIButton *_resetBtn;
}
@property (nonatomic, assign) BOOL isPushOpen;
@property (nonatomic, assign) NSInteger pushCityId;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
/*
 *作用：初始化界面
 *参数：
 *返回值：N/A
 *备注：
 */
- (void)initView:(FilterListViewType)type;

/*
 *作用：初始化tableView
 *参数：
 *返回值：N/A
 *备注：
 */
- (void)initTableView;
@end
