//
//  CursorCustomization.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/26/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "UsingCursorModifierChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

static const int PointsCount = 500;

@implementation UsingCursorModifierChartView


@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    

    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(3) Max:SCIGeneric(6)];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.05) Max:SCIGeneric(0.05)];
    yAxis.autoRange = SCIAutoRange_Always;

    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds1.seriesName = @"Green Series";
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds2.seriesName = @"Red Series";
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds3.seriesName = @"Gray Series";
    SCIXyDataSeries *ds4 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds4.seriesName = @"Gold Series";
    
    DoubleSeries *data1 = [DataManager getNoisySinewaveWithAmplitude:300 Phase:1.0 PointCount:PointsCount NoiseAmplitude:0.25];
    DoubleSeries *data2 = [DataManager getSinewaveWithAmplitude:100 Phase:2 PointCount:PointsCount];
    DoubleSeries *data3 = [DataManager getSinewaveWithAmplitude:200 Phase:1.5 PointCount:PointsCount];
    DoubleSeries *data4 = [DataManager getSinewaveWithAmplitude:50 Phase:0.1 PointCount:PointsCount];
    
    [ds1 appendRangeX:data1.xValues Y:data1.yValues Count:data1.size];
    [ds2 appendRangeX:data2.xValues Y:data2.yValues Count:data2.size];
    [ds3 appendRangeX:data3.xValues Y:data3.yValues Count:data3.size];
    [ds4 appendRangeX:data4.xValues Y:data4.yValues Count:data4.size];
    
    SCIFastLineRenderableSeries *rs1 = [[SCIFastLineRenderableSeries alloc] init];
    rs1.dataSeries = ds1;
    rs1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF177B17 withThickness:2.0];
    
    SCIDrawLineRenderableSeriesAnimation *animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurveEaseOut];
    [animation startAfterDelay:0.3];
    [rs1 addAnimation:animation];
    
    SCIFastLineRenderableSeries *rs2 = [[SCIFastLineRenderableSeries alloc] init];
    rs2.dataSeries = ds2;
    rs2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDD0909 withThickness:2.0];
    
    animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurveEaseOut];
    [animation startAfterDelay:0.3];
    [rs2 addAnimation:animation];
    
    SCIFastLineRenderableSeries *rs3 = [[SCIFastLineRenderableSeries alloc] init];
    rs3.dataSeries = ds3;
    rs3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF808080 withThickness:2.0];
    
    animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurveEaseOut];
    [animation startAfterDelay:0.3];
    [rs3 addAnimation:animation];
    
    SCIFastLineRenderableSeries *rs4 = [[SCIFastLineRenderableSeries alloc] init];
    rs4.dataSeries = ds4;
    rs4.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFD700 withThickness:2.0];
    rs4.isVisible = NO;
    
    animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurveEaseOut];
    [animation startAfterDelay:0.3];
    [rs4 addAnimation:animation];

    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    [surface.renderableSeries add:rs1];
    [surface.renderableSeries add:rs2];
    [surface.renderableSeries add:rs3];
    [surface.renderableSeries add:rs4];
    
    SCICursorModifier *cursorModifier = [[SCICursorModifier alloc] init];
    cursorModifier.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    
    surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[cursorModifier]];
   
    [surface invalidateElement];
}

@end
