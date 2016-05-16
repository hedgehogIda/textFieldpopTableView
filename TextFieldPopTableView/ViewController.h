//
//  ViewController.h
//  TextFieldPopTableView
//
//  Created by ida on 16/5/16.
//  Copyright © 2016年 实信腾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate,UITextFieldDelegate>

//@property (nonatomic,strong)UIPopoverController * popoverController;

@property (nonatomic,strong)UITableViewController *popTableView;

@property(nonatomic,strong)UITableViewController *searchResultTableViewVC;
@end

