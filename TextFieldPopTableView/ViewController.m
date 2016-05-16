//
//  ViewController.m
//  TextFieldPopTableView
//
//  Created by ida on 16/5/16.
//  Copyright © 2016年 实信腾. All rights reserved.
//

#import "ViewController.h"
#define BGCOLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic)NSMutableDictionary  *searchResultDic;
@property (strong, nonatomic)NSMutableArray  *searchResultArr;
@property (strong, nonatomic) NSMutableDictionary *faults;//faultdic.plist字典

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFaultData];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)textChanged:(UITextField*)sender {
    [self filterContentForSearchText:sender.text];
}

-(void)getFaultData{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"faultdic"
                                                   ofType:@"plist"];
    self.faults = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
}
- (void)filterContentForSearchText:(NSString*)searchText {
    self.searchResultDic = nil;
    self.searchResultDic= [[NSMutableDictionary alloc]init];
    
    self.searchResultArr = nil;
    self.searchResultArr = [[NSMutableArray alloc]init];
    
    if (searchText.length > 0) {
        
        
        for (int i=0;i<self.faults.count ; i++)//字典-》数组
        {
            NSArray *allfault = [NSArray arrayWithArray:[self.faults allKeys]];//主标题
            
            for (int i=0; i<allfault.count; i++) {
                NSString *sectionTitle = [allfault objectAtIndex:i];
                NSMutableArray *sectionTitleArr = [NSMutableArray array];
                NSArray *rowstitleArr = [self.faults valueForKey:sectionTitle];
                for (NSString *rowstitle in rowstitleArr) {
                    NSRange range = [rowstitle rangeOfString:searchText];
                    if (range.location!=NSNotFound) {
                        [sectionTitleArr addObject:rowstitle];
                    }
                }
                if (sectionTitleArr.count!=0) {
                    [self.searchResultDic setObject:sectionTitleArr forKey:sectionTitle];
                }
                
                
            }
            
        }
        
    }
    if (self.searchResultDic.count!=0) {
        
        if (_searchResultTableViewVC==nil){
            //添加table，并且刷新表格
            UITableViewController * mypopTableView = [[UITableViewController alloc]init];
            mypopTableView.tableView.delegate = self;
            mypopTableView.tableView.dataSource = self;
            _searchResultTableViewVC = mypopTableView;
            _searchResultTableViewVC.modalPresentationStyle = UIModalPresentationPopover;
            
            UIPopoverPresentationController *popPC = _searchResultTableViewVC.popoverPresentationController;
            popPC.sourceView = self.view;
            popPC.sourceRect =CGRectMake(30,60,500,150);
            popPC.permittedArrowDirections = UIPopoverArrowDirectionRight;
            popPC.delegate = self;
            
            [self presentViewController:_searchResultTableViewVC animated:YES completion:nil];
            
            //只是ipad中的
            /*
             UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:_searchResultTableViewVC];
             self.popoverController = popover;
             self.popoverController.delegate = self;
             [self.popoverController presentPopoverFromRect:CGRectMake(32, 80, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
             [self.popoverController setPopoverContentSize:CGSizeMake(270, 250) animated:NO];
             */
            
            
        }
        [_searchResultTableViewVC.tableView reloadData];
    }
    
    
    else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        self.searchResultTableViewVC = nil;
        /*
         [self.popoverController dismissPopoverAnimated:YES];
         self.popoverController = nil;
         self.searchResultTableViewVC = nil;
         */
        
    }
    
}

#pragma mark - tableview的代理方法



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.searchResultDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arr = [self.searchResultDic allKeys];//标题数组
    NSString *rowTitle = [arr objectAtIndex:section];//标题
    NSArray *rowArr = [self.searchResultDic valueForKey:rowTitle];
    return rowArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    NSArray *arr = [self.searchResultDic allKeys];//标题数组
    NSString *rowTitle = [arr objectAtIndex:indexPath.section];//标题
    
    NSString *labelTitle =  [[self.searchResultDic valueForKey:rowTitle]objectAtIndex:indexPath.row];
    
    cell.textLabel.text = labelTitle;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

//注意tableviewHeader显示不出来，就是没有设置tableviewHeader的高度
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    bgView.backgroundColor = BGCOLOR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, tableView.frame.size.width, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19, bgView.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    
    NSArray *arr = [self.searchResultDic allKeys];//标题数组
    NSString *rowTitle = [arr objectAtIndex:section];//标题
    
    titleLabel.text = rowTitle;
    [bgView addSubview:line];
    [bgView addSubview:titleLabel];
    
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = [self.searchResultDic allKeys];//标题数组
    NSString *rowTitle = [arr objectAtIndex:indexPath.section];//标题
    
    NSString *cityName =  [[self.searchResultDic valueForKey:rowTitle]objectAtIndex:indexPath.row];
    //textField 显示选择的内容。
    self.searchText.text = cityName;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.searchResultTableViewVC = nil;
    /*
     [self.popoverController dismissPopoverAnimated:YES];
     self.popoverController = nil;
     self.searchResultTableViewVC = nil;
     */
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
