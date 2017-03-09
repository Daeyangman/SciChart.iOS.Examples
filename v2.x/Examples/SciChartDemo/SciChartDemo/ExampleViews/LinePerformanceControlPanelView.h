//
//  LinePerformanceControlPanelView.h
//  SciChartDemo
//
//  Created by Admin on 28.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SciChartBaseViewProtocol.h"

typedef void(^Callback)(void);

@interface LinePerformanceControlPanelView : UIView

@property (nonatomic, copy) Callback onClearClicked;
@property (nonatomic, copy) Callback onAdd100KClicked;
@property (nonatomic, copy) Callback onAdd1KKClicked;

@end
