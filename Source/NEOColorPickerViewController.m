#import "NEOColorPickerViewController.h"
#import "NEOColorPickerHSLViewController.h"
#import "NEOColorPickerHueGridViewController.h"
#import "NEOColorPickerFavoritesViewController.h"
#import "UIColor+NEOColor.h"
#import <QuartzCore/QuartzCore.h>


@interface NEOColorPickerViewController () <NEOColorPickerViewControllerDelegate> {
    NSMutableArray *_colorArray;
}

@property (nonatomic, weak) CALayer *selectedColorLayer;
@property (nonatomic, strong) UIColor* savedColor;
@property (nonatomic, strong) NSMutableArray* colorLayers;
@property (nonatomic, assign) CGRect selectedColorLabelBaseFrame;
@property (nonatomic, assign) CGRect simpleColorGridBaseFrame;
@property (nonatomic, assign) CGRect doneButtonBaseFrame;

@end

@implementation NEOColorPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _colorArray = [NSMutableArray array];
        
        int colorCount = NEOColorPicker4InchDisplay() ? 18 : 16;
        for (int i = 0; i < colorCount; i++) {
            UIColor *color = [UIColor colorWithHue:i / (float)colorCount saturation:1.0 brightness:1.0 alpha:1.0];
            [_colorArray addObject:color];
        }
        
        colorCount = NEOColorPicker4InchDisplay() ? 6 : 4;
        for (int i = 0; i < colorCount; i++) {
            UIColor *color = [UIColor colorWithWhite:i/(float)(colorCount - 1) alpha:1.0];
            [_colorArray addObject:color];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedColorLabel.frame = CGRectMake(20, 10, 130, 40);
    self.selectedColorLabelBaseFrame = self.selectedColorLabel.frame;
    self.simpleColorGrid.frame = CGRectMake(0, 60, 320, 320);
    self.simpleColorGridBaseFrame = self.simpleColorGrid.frame;
    // position this button in line with the hue button programmatically (not with a magic number)
    self.doneButton.frame = CGRectMake(240, self.buttonHue.frame.origin.y - self.buttonHue.frame.size.height/2, 80, 70);
    self.doneButtonBaseFrame = self.doneButton.frame;
    
    self.colorLayers = [NSMutableArray array];
    self.selectedColorLabel.numberOfLines = 5;
    
    if (!self.selectedColor)
    {
        self.selectedColor = [UIColor blackColor];
    }
    if (self.selectedColorText.length != 0)
    {
        self.selectedColorLabel.text = self.selectedColorText;
    }
    if (self.doneButtonText.length != 0)
    {
        [self.doneButton setTitle:self.doneButtonText forState:UIControlStateNormal];
    }
    self.simpleColorGrid.backgroundColor = [UIColor clearColor];
    
    [self.buttonHue setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonHue];
    [self.buttonHue setImage:[UIImage imageNamed:@"colorPicker.bundle/hue_selector"] forState:UIControlStateNormal];
    
    [self.buttonAddFavorite setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonAddFavorite];
    [self.buttonAddFavorite setImage:[UIImage imageNamed:@"colorPicker.bundle/picker-favorites-add"] forState:UIControlStateNormal];
    
    [self.buttonFavorites setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonFavorites];
    [self.buttonFavorites setImage:[UIImage imageNamed:@"colorPicker.bundle/picker-favorites"] forState:UIControlStateNormal];
    
    [self.buttonHueGrid setBackgroundColor:[UIColor clearColor]];
    //    [NTTAppDefaults setupSecondaryButton:self.buttonHueGrid];
    [self.buttonHueGrid setImage:[UIImage imageNamed:@"colorPicker.bundle/picker-grid"] forState:UIControlStateNormal];
    
    self.selectedColoerFrame = [self getFrameNextToLabel:self.selectedColorLabel]; //CGRectMake(130, 16, 100, 40);
    UIImageView *checkeredView = [[UIImageView alloc] initWithFrame:self.selectedColoerFrame];
    checkeredView.layer.cornerRadius = 6.0;
    checkeredView.layer.masksToBounds = YES;
    checkeredView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorPicker.bundle/color-picker-checkered"]];
    [self.centeredView addSubview:checkeredView];
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.selectedColoerFrame;
    layer.cornerRadius = 6.0;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowOpacity = 0.8;
    
    [self.centeredView.layer addSublayer:layer];
    self.selectedColorLayer = layer;
    
    [self repositionTheColorsPalette];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorGridTapped:)];
    [self.simpleColorGrid addGestureRecognizer:recognizer];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateSelectedColor];
}


- (void) updateSelectedColor {
    self.selectedColorLayer.backgroundColor = self.selectedColor.CGColor;
}


- (void) colorGridTapped:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.simpleColorGrid];
    int row = (int)((point.y - 8) / 48);
    int column = (int)((point.x - 8) / 78);
    int index = row * 4 + column;
    int colorCount = NEOColorPicker4InchDisplay() ? 24 : 20;
    if (index < colorCount)
    {
        self.selectedColor = [_colorArray objectAtIndex:index];
    }
    [self updateSelectedColor];
}


- (IBAction)buttonPressCancel:(id)sender {
    [self.delegate colorPickerViewControllerDidCancel:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonPressDone:(id)sender {
    [self.delegate colorPickerViewController:self didSelectColor:self.selectedColor];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)buttonPressHue:(id)sender {
    NEOColorPickerHSLViewController *controller = [[NEOColorPickerHSLViewController alloc] init];
    controller.delegate = self;
    
    // passing these translated strings along to the new view controller
    controller.saturationText = self.saturationText;
    controller.luminosityText = self.luminosityText;
    controller.hueText = self.hueText;
    controller.transparencyText = self.transparencyText;
    controller.doneButtonText = self.doneButtonText;
    controller.selectedText = self.selectedText;
    
    controller.title = self.title;
    controller.disallowOpacitySelection = self.disallowOpacitySelection;
    controller.selectedColor = self.selectedColor;
    self.savedColor = self.selectedColor;
    
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    if (self.disallowOpacitySelection && [color neoAlpha] != 1.0) {
        self.selectedColor = [color neoColorWithAlpha:1.0];
    } else {
        self.selectedColor = color;
    }
    [self updateSelectedColor];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didChangeColor:(UIColor *)color {
    self.selectedColor = color;
    [self updateSelectedColor];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    if (self.savedColor != nil) {
        self.selectedColor = self.savedColor;
        [self updateSelectedColor];
        self.savedColor = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonPressHueGrid:(id)sender {
    NEOColorPickerHueGridViewController *controller = [[NEOColorPickerHueGridViewController alloc] init];
    controller.delegate = self;
    controller.title = self.title;
    controller.selectedColor = self.selectedColor;
    
    // passing these translated strings along to the new view controller
    controller.selectedColorText = self.selectedColorText;
    controller.saturationText = self.saturationText;
    controller.luminosityText = self.luminosityText;
    controller.hueText = self.hueText;
    controller.transparencyText = self.transparencyText;
    controller.doneButtonText = self.doneButtonText;
    controller.selectedText = self.selectedText;
    
    self.savedColor = self.selectedColor;
    
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)buttonPressAddFavorite:(id)sender {
    [[NEOColorPickerFavoritesManager instance] addFavorite:self.selectedColor];
    // TODO: Suggest using a framework like SVProgressHUD to provide feedback.
    // [SVProgressHUD showSuccessWithStatus:@"Added to favorites"];
}


- (IBAction)buttonPressFavorites:(id)sender {
    NEOColorPickerFavoritesViewController *controller = [[NEOColorPickerFavoritesViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = self.selectedColor;
    controller.title = (self.favoritesTitle.length == 0 ? @"Favorites" : self.favoritesTitle);
    
    // passing these translated strings along to the new view controller
    controller.selectedColorText = self.selectedColorText;
    controller.saturationText = self.saturationText;
    controller.luminosityText = self.luminosityText;
    controller.hueText = self.hueText;
    controller.transparencyText = self.transparencyText;
    controller.doneButtonText = self.doneButtonText;
    controller.selectedText = self.selectedText;
    
    self.savedColor = self.selectedColor;
    
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)updateForDeviceOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
    CGFloat degrees = 0.0f;
    switch (orientation)
    {
        case UIDeviceOrientationLandscapeLeft:
            degrees = 90.0f;
            break;
        case UIDeviceOrientationLandscapeRight:
            degrees = -90.0f;
            break;
        case UIDeviceOrientationPortrait:
            degrees = 0.0f;
            break;
        default:
            return;
            break;
    }
    
    CGFloat duration = (animated) ? [UIApplication sharedApplication].statusBarOrientationAnimationDuration : 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        // Rotate view
        [self rotateView:self.selectedColorLabel withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.simpleColorGrid withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.buttonAddFavorite withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.buttonFavorites withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.buttonHue withDegrees:degrees andOrientation:orientation];
        [self rotateView:self.doneButton withDegrees:degrees andOrientation:orientation];
        
    } completion:^(BOOL finished){[self repositionTheColorsPalette];}];
}

-(CGRect)getBaseViewFrameForView:(UIView*)view
{
    if (view == self.selectedColorLabel)
    {
        return self.selectedColorLabelBaseFrame;
    }
    if (view == self.simpleColorGrid)
    {
        return self.simpleColorGridBaseFrame;
    }
    if (view == self.doneButton)
    {
        return self.doneButtonBaseFrame;
    }
    
    return view.frame;
}

-(void)rotateView:(UIView*)rotatingView withDegrees:(CGFloat)degrees andOrientation:(UIDeviceOrientation)orientation
{
    rotatingView.transform = CGAffineTransformIdentity;
    rotatingView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    
    if (rotatingView != self.simpleColorGrid)
    {
        CGRect baseRect = [self getBaseViewFrameForView:rotatingView];
        CGFloat width = CGRectGetWidth(baseRect);
        CGFloat height = CGRectGetHeight(baseRect);
        if (degrees != 0)
        {
            // Resize view for rotation
            width = CGRectGetHeight(baseRect);
            height = CGRectGetWidth(baseRect);
        }
        CGSize newSize = CGSizeMake(width, height);
        
        CGRect viewBounds = rotatingView.bounds;
        viewBounds.size = newSize;
        rotatingView.bounds = viewBounds;
        
        CGRect viewFrame = rotatingView.frame;
        viewFrame.size = newSize;
        rotatingView.bounds = viewFrame;
    }
}

-(void)repositionTheColorsPalette
{
    @try
    {
        for (CALayer *colorLayer in self.colorLayers)
        {
            [colorLayer removeFromSuperlayer];
        }
        [self.simpleColorGrid.layer setNeedsDisplay];
        [self.colorLayers removeAllObjects];
        int colorCount = NEOColorPicker4InchDisplay() ? 24 : 20;
        for (int i = 0; i < colorCount; i++)
        {
            CALayer *layer = [CALayer layer];
            layer.cornerRadius = 6.0;
            UIColor *color = [_colorArray objectAtIndex:i];
            layer.backgroundColor = color.CGColor;
            
            int column = i % 4;
            int row = i / 4;
            layer.frame = CGRectMake(8 + (column * 78), 8 + row * 48, 70, 40);
            [self setupShadow:layer];
            [self.simpleColorGrid.layer addSublayer:layer];
            [self.colorLayers addObject:layer];
        }
        
    }
    @catch (NSException *exception)
    {
        
    }
}

@end
