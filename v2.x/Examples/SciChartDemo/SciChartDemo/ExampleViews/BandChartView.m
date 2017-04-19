//
//  BandChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "BandChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation BandChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        sciChartSurfaceView = [[SCIChartSurfaceView alloc]init];
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
      
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    [xAxis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(1.1) Max:SCIGeneric(2.7)]];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    [yAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    
    DoubleSeries *data = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.01 PointCount:1000 Freq:10];
    DoubleSeries *moreData = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.05 PointCount:1000 Freq:12];
    
    SCIXyyDataSeries *dataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [dataSeries appendRangeX:data.xValues Y1:data.yValues Y2:moreData.yValues Count:data.size];
    
    SCIBandRenderableSeries * bandRenderableSeries = [[SCIBandRenderableSeries alloc] init];
    bandRenderableSeries.dataSeries = dataSeries;
    bandRenderableSeries.style.brush1 = [[SCISolidBrushStyle alloc] initWithColorCode:0x33279B27];
    bandRenderableSeries.style.brush2 = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FF1919];
    bandRenderableSeries.style.pen1 = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
    bandRenderableSeries.style.pen2 = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF1919 withThickness:1.0];
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    [surface.renderableSeries add:bandRenderableSeries];

    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    [zpm setModifierName:@"ZoomPan Modifier"];
    
    surface.chartModifier = [[SCIModifierGroup alloc] initWithChildModifiers:@[pzm, zem, zpm]];

    [surface invalidateElement];
}

@end
