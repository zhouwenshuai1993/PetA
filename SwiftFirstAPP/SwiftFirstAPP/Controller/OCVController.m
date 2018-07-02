//
//  OCVController.m
//  SwiftFirstAPP
//
//  Created by 嗯，大葱 on 2018/7/2.
//  Copyright © 2018年 嗯，大葱. All rights reserved.
//

#import "OCVController.h"
#import "SwiftFirstAPP-Swift.h"
#import "ChatOneCell.h"

/*
 (反复用到的代码，可以写到一个方法里)
 优化聊天界面tableView上移的问题
 点击发送按钮，自动清除输入框内容
 增加无聊天数据提示
 增加清除聊天记录功能
 */
@interface OCVController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSString *typeSpeaker;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *dataArray2;
@property (nonatomic, strong)UITextField *textF;

@property (nonatomic, strong)UILabel *placeLB;

@property (nonatomic, strong)UIView *iPutV;

@end

@implementation OCVController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = _nameStr;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:(UIBarButtonItemStylePlain) target:self action:@selector(handleCleanAction:)];
    
    [self readFileArray];
    
    
    
}
//清除聊天记录
- (void)handleCleanAction:(UIBarButtonItem *)sender {
    [self deleteFile];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    typeSpeaker = @"甲方";
  
    [self configureVC2];
      [self configureVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureVC {
    CGRect NavRect = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat hightT = NavRect.size.height +rectStatus.size.height;
    _iPutV = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-hightT-50,[UIScreen mainScreen].bounds.size.width,50)];
    
    _iPutV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8];
    
    
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"甲方" forState:(UIControlStateNormal)];
    [btn setTitle:@"已方" forState:(UIControlStateSelected)];
    [btn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    btn.layer.cornerRadius = 3;
    btn.frame =CGRectMake(10, 10, 55, 30);
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth =1;
    [btn addTarget:self action:@selector(handleChooseTypeSpeakerAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_iPutV addSubview:btn];
    
    
    
    
    _textF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, 10, [UIScreen mainScreen].bounds.size.width-75-65, 30)];
    _textF.placeholder = @"请输入要发送的信息";
    _textF.borderStyle = UITextBorderStyleRoundedRect;
    _textF.font = [UIFont systemFontOfSize:14];
    [_iPutV addSubview:_textF];
    
    
    UIButton *sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
    sendBtn.layer.cornerRadius = 3;
    sendBtn.layer.masksToBounds = YES;
    [sendBtn addTarget:self action:@selector(handleSendMessage:) forControlEvents:(UIControlEventTouchUpInside)];
    sendBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-65, 10, 55, 30);
    [sendBtn setBackgroundColor:[UIColor grayColor]];
    [_iPutV addSubview:sendBtn];
    [self.view addSubview:_iPutV];
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect NavRect = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat hightT = NavRect.size.height +rectStatus.size.height;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    _iPutV.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height-hightT-height-50,[UIScreen mainScreen].bounds.size.width,50);
    _tableView.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-hightT-50-height);
    if (_dataArray.count >0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
 
}


//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect NavRect = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat hightT = NavRect.size.height +rectStatus.size.height;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    _iPutV.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height-hightT-height-50,[UIScreen mainScreen].bounds.size.width,50);
      _tableView.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-hightT-50);
    if (_dataArray.count > 0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect NavRect = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat hightT = NavRect.size.height +rectStatus.size.height;
    [self.view endEditing:YES];
    _iPutV.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height-hightT-50,[UIScreen mainScreen].bounds.size.width,50);
}

//选择聊天人的身份
- (void)handleChooseTypeSpeakerAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        typeSpeaker = @"已方";
    }else {
        typeSpeaker = @"甲方";
    }
    
}


//发送信息按钮
- (void)handleSendMessage:(UIButton *)sender{
    if (_textF.text.length == 0) {
        return;
    }

    
    [_dataArray addObject:_textF.text];
    if ([typeSpeaker isEqualToString:@"甲方"]) {
        [_dataArray2 addObject:@"甲方"];
    }else{
        [_dataArray2 addObject:@"已方"];
    }

#pragma mark 将聊天记录写入到本地
    [_dataArray writeToFile:[self documentsPath:@"usefile.txt"] atomically:YES];
    [_dataArray2 writeToFile:[self documentsPath:@"usefile2.txt"] atomically:YES];

    [self.tableView reloadData];
    [self hidenHD];
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    _textF.text = @"";
}

#pragma mark 将数组存储入程序文件 arrayWithContentsOfFile
-(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}
-(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}


-(NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

// 删除沙盒里的文件
-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"usefile.txt"];
    NSString *uniquePath2=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"usefile2.txt"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    BOOL blHave2=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath2];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
          BOOL blDele2= [fileManager removeItemAtPath:uniquePath2 error:nil];
        if (blDele) {
            NSLog(@"dele success");
            
            CGRect NavRect = self.navigationController.navigationBar.frame;
            CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
            CGFloat hightT = NavRect.size.height +rectStatus.size.height;
            [self.view endEditing:YES];
            _iPutV.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height-hightT-50,[UIScreen mainScreen].bounds.size.width,50);
            [_dataArray removeAllObjects];
            [_dataArray2 removeAllObjects];
            [self.tableView reloadData];
            [self showHD];
        }else {
            NSLog(@"dele fail");
        }
        
    }
}

-(void)readFileArray
{
    NSLog(@"readfile........\n");
    //dataPath 表示当前目录下指定的一个文件 data.plist
    //NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    //filePath 表示程序目录下指定文件
    NSString *filePath = [self documentsPath:@"usefile.txt"];
    NSString *filePath2 = [self documentsPath:@"usefile2.txt"];
    //从filePath 这个指定的文件里读
    NSArray *userinfo = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *userinfo2 = [NSArray arrayWithContentsOfFile:filePath2];
 
    if (userinfo.count == 0) {
        _dataArray = [NSMutableArray array];
        _dataArray2 = [NSMutableArray array];
        [self showHD];
    }else {
        _dataArray = [NSMutableArray arrayWithArray:userinfo];
        _dataArray2 = [NSMutableArray arrayWithArray:userinfo2];
        [self.tableView reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self hidenHD];
        
    }
    
  
    
}


#pragma mark 无数据源提示当前无数据
-(void)showHD {
    _placeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _placeLB.center = self.tableView.center;
    _placeLB.text = @"暂无聊天内容";
    _placeLB.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:_placeLB];
}
-(void)hidenHD {
    if (_placeLB) {
    [_placeLB removeFromSuperview];
    }
    
}


-(void)configureVC2 {
    CGRect NavRect = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat hightT = NavRect.size.height +rectStatus.size.height;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-hightT-50) style:(UITableViewStylePlain)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ChatOneCell" bundle:nil] forCellReuseIdentifier:@"ChatOneCell"];
    
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    bgv.backgroundColor = [UIColor whiteColor];
    return bgv;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatOneCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentLB.text = _dataArray[indexPath.row];
    NSString *typeS = _dataArray2[indexPath.row];
    if ([typeS isEqualToString:@"甲方"]) {
        cell.contentLB.textAlignment = NSTextAlignmentLeft;
        cell.oneImageV.hidden = NO;
        cell.twoImageV.hidden = YES;
    }else {
        cell.contentLB.textAlignment = NSTextAlignmentRight;
        cell.oneImageV.hidden = YES;
        cell.twoImageV.hidden = NO;
    }
    
    
    return cell;
}

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect NavRect = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat hightT = NavRect.size.height +rectStatus.size.height;
    [self.view endEditing:YES];
    
      _iPutV.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height-hightT-50,[UIScreen mainScreen].bounds.size.width,50);
}











@end
