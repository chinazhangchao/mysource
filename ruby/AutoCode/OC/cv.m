
#import "CLASSNAME.h"
#import "CWRequest.h"
#import "MJRefresh.h"
#import "NSString+URLEncoding.h"

@interface CLASSNAME ()

@end

@implementation CLASSNAME

#pragma mark --
#pragma mark LifeStyle
- (void)dealloc{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self requestFromServer:RefreshTypeDown];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark Method
//初始化界面
- (void)initView
{
    [self initNavBar];
    [self updateNavTitle:NSLocalizedString(@"", nil)];
    [self initBackButton];
    
    [self initTableView];

    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
    _loadingView.backgroundColor = [UIColor whiteColor];
    _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _resetBtn.frame = CGRectMake(120, 300, 89, 27);
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"resetBtnNormal.png"] forState:UIControlStateNormal];
    [_resetBtn setBackgroundImage:[UIImage imageNamed:@"resetBtnSelect.png"] forState:UIControlStateHighlighted];
    [_resetBtn addTarget:self action:@selector(resetRequest) forControlEvents:UIControlEventTouchUpInside];
    [_loadingView addSubview:_resetBtn];
    _resetBtn.hidden = YES;
    
    [self.view addSubview:_loadingView];
}


#pragma mark --
#pragma mark IOS6 UI

//回退到上个页面
-(void)navigateBack{
    [super handleBackEvent];
    if ([self isPushOpen]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//初始化 
- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    if (IOS7_OR_BEFORE) {
        _tableView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-59);
    }
}

#pragma mark --
#pragma mark HTTP Request

- (NSInteger) getCityId
{
    if (self.pushCityId != 0) {
        return [self pushCityId];
    }
    else{
        return [app.userCacheNode getCurrentCityNode].cityId;
    }
}

- (BOOL)requestFromServer:(RefreshType)type
{
    if (![super requestFromServer:type]){
        _loadingView.hidden = NO;
        _loadingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_failed.png"]];
        [self.view bringSubviewToFront:_loadingView];
        [super cancelCurrentRequest];
        [self.tableView footerEndRefreshing];
        return NO;
    }
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[NSNumber numberWithInt:[self getCityId] ] forKey:KCityID];

    typeof(self) __weak sself = self;
    if (![CWRequest getProfitList:dictionary callback:^(NSDictionary* dic){
        [sself performSelectorOnMainThread:@selector(requestDidFinish:) withObject:dic waitUntilDone:NO];
    }]){
        [super requestDidFinish:nil isShowTip:NO];
        [self.tableView footerEndRefreshing];
        [_tableView reloadData];
        
        return NO;
    }

    return YES;
}

- (BOOL)requestDidFinish:(NSDictionary *)dictionary
{
    [self.tableView footerEndRefreshing];
    if (![super requestDidFinish:dictionary isShowTip:YES]){
        _loadingView.hidden = NO;
        _resetBtn.hidden = NO;
        _loadingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_failed.png"]];
        [self.view bringSubviewToFront:_loadingView];
        return NO;
    }
    else
    {
        ResponseTip* tip = [dictionary objectForKey:KResHeader];
        if (!tip || !tip.isSuccess){
            _loadingView.hidden = NO;
            _resetBtn.hidden = NO;
            _loadingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_failed.png"]];
            [self.view bringSubviewToFront:_loadingView];
            if (tip.msg) {
                [self.view makeToast:tip.msg];
            }
            [self.dataArray removeAllObjects];
            [_tableView reloadData];
        }
        else
        {
            _loadingView.hidden = YES;
            
            if (tip.code == 0) {
                //请求失败，重新加载
            }
            else if(tip.code == 1){
                NSMutableArray* result = [dictionary objectForKey:KResData];
                    self.dataArray = result;
                    [_tableView reloadData];
            }
            else if (tip.code == 2)
            {
                    [self.dataArray removeAllObjects];
                    [_tableView reloadData];
                    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:NSLocalizedString(@"TitleAlert", nil) contentText:NSLocalizedString(@"SearchNoResultAlertMsg", nil) leftButtonTitle:nil rightButtonTitle:NSLocalizedString(@"SureAlert", nil)];
                    [alert show];
                    alert.rightBlock = ^() {
                        
                    };
                    alert.dismissBlock = ^() {
                        
                    };
                    [alert release];
            }
            
        }
    }
    return YES;
}


#pragma mark --
#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArray count] <= 0) {
        return 0;
    }
    else
    {
        return [_dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 215;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *profitCell = [tableView dequeueReusableCellWithIdentifier:@"profitCell"];
//    if (profitCell == nil)
//    {
//        profitCell = [[[ProfitCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                           reuseIdentifier:@"profitCell"]autorelease];
//    }
//    ProfitNode *node = [_dataArray objectAtIndex:indexPath.row];
//    [profitCell refreshDataWithNode:node];
//    
    return profitCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ProfitNode *node = [_dataArray objectAtIndex:indexPath.row];
//    //进入返现详情页面
//    ProfitDetailViewController *profitDetail = [[ProfitDetailViewController alloc]init];
//    profitDetail.node = node;
//    [self.navigationController pushViewController:profitDetail animated:YES];
//    [profitDetail release];
}

@end
