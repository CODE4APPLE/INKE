//
//  HottestViewController.m
//  LearningFFmpeg
//
//  Created by ZhangLe on 16/4/16.
//  Copyright © 2016年 30days-tech. All rights reserved.
//

#import "HottestViewController.h"
#import "HotestTableViewCell.h"

#import "LivesModel.h"
#import "HTTPClient.h"
#import "MJExtension.h"

#import "KxMovieViewController.h"

@interface HottestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation HottestViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[HotestTableViewCell class] forCellReuseIdentifier:@"hotCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    [self getListData];
}

-(void)getListData {
    //含有中文请求会出错
    NSString *url = [@"http://101.200.29.199/api/live/simpleall?cc=TG0001&conn=Wifi&cv=IK2.5.10_Iphone&devi=44d94653f9a0934cc94f12e542d7d363fae4256b&idfa=07506DA9-419B-460D-BAC8-E035DD6099BC&idfv=3D5EC291-4DDF-44FE-8AC7-B9598B532319&imei=&imsi=&lc=0000000000000014&multiaddr=1&osversion=ios_9.200000&proto=1&sid=EE3qPwpb4VuMR65ShMqfaS8i3&ua=iPhone%205s&uid=509195" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [HTTPClient get:url parameter:nil success:^(NSDictionary *JSON) {
        
        NSMutableArray *dataDic = [JSON objectForKey:@"lives"];
        for (NSDictionary *dic in dataDic) {
            LivesModel *model=[LivesModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {}];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return screen_width+115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
    
    LivesModel *model = self.dataSource[indexPath.row];
    
    NSString *urlStr;
    if ([model.creator.portrait rangeOfString:@"http"].location !=NSNotFound) {
        //$$字符串判断
        urlStr= model.creator.portrait;
    }else{
        urlStr= [NSString stringWithFormat:@"http://img.meelive.cn/%@",model.creator.portrait];
    }
    
    [cell.prodImgeView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_room.jpg"] options:SDWebImageCacheMemoryOnly];
    [cell.bgImgeView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_room.jpg"] options:SDWebImageCacheMemoryOnly];
    
    cell.titleLabel.text = model.creator.nick;
    cell.priceLabel.text = model.city;
    cell.nameLabel.text = model.name;
    cell.onlineLabel.text = model.online_users;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LivesModel *model = self.dataSource[indexPath.row];
    if (!model.stream_addr) return;
    
    NSString *path=model.stream_addr;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // increase buffering for .wmv, it solves problem with delaying audio frames
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);

    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];
}


+(NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
-(NSString *)decodeString:(NSString*)encodedString {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}



@end
