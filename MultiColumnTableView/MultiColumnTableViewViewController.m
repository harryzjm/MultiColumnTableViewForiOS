/*
 * Copyright (c) 2011 Eli Wang
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */


#import "MultiColumnTableViewViewController.h"
#import "NSObject+DelayedBlock.h"

#define ROWS 100

#define cellWith 90.f
#define cellHight 30.f

@interface MultiColumnTableViewViewController()

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer;

@end





@implementation MultiColumnTableViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }   
    return self;
}


- (void)dealloc
{
    [data release];
    [tblView release];
    [sectionHeaderData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    numberOfColumns = 10;
    numberOfSections = 10;
    

    colWidth = cellWith;
    
    data = [[NSMutableArray alloc] initWithCapacity:numberOfSections * 5];
    sectionHeaderData = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    
    for (int i = 0; i < numberOfSections; i++) {
        
        int rows = arc4random()%6 + 1;
        NSMutableArray *a = [NSMutableArray arrayWithCapacity:numberOfColumns];
        for (int j = 0; j < numberOfColumns; j++) {
            
            int d = arc4random() % 100;
            
            NSMutableString *text = [NSMutableString stringWithFormat:@"S %d C %d", i, j];
            if (d < 66) {
                [text appendFormat:@"\nsecond line"];
            }
            
            if (d < 33) {
                [text appendFormat:@"\nthird line"];
            }
            
            
            [a addObject:text];
        }
        [sectionHeaderData addObject:a];

        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:10];
        for (int k = 0; k < rows; k++) {
            
            NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:numberOfColumns];
            for (int j = 0; j < numberOfColumns; j++) {
                int d = arc4random() % 100;
                
                NSMutableString *text = [NSMutableString stringWithFormat:@"(%d, %d, %d)", i, k, j];
                if (d < 66) {
                    [text appendFormat:@"\nsecond line"];
                }
                
                if (d < 33) {
                    [text appendFormat:@"\nthird line"];
                }
                
                [rowArray addObject:text];
            }
            
            [sectionArray addObject:rowArray];
        }
        
        [data addObject:sectionArray];
    }
    
    
    tblView = [[EWMultiColumnTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
    tblView.sectionHeaderEnabled = YES;
//    tblView.cellWidth = 100.0f;
//    tblView.boldSeperatorLineColor = [UIColor blueColor];
//    tblView.normalSeperatorLineColor = [UIColor blueColor];
//    tblView.boldSeperatorLineWidth = 10.0f;
//    tblView.normalSeperatorLineWidth = 10.0f;
    tblView.dataSource = self;
    tblView.delegate = self;
    tblView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tblView];
    
    [self performBlock:^{
        [tblView scrollToColumn:3 position:EWMultiColumnTableViewColumnPositionMiddle animated:YES];
    } afterDelay:0.5];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // e.g. self.myOutlet = nil;
    [tblView release];
    tblView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - EWMultiColumnTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(EWMultiColumnTableView *)tableView
{
    return numberOfSections;
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWith, cellHight)];
    return l;
}


- (void)tableView:(EWMultiColumnTableView *)tableView setContentForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col{
    UILabel *l = (UILabel *)cell;
    l.text = [[[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:col];
    
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor greenColor];

}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    return cellHight;
//    NSString *str = [[[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:col];
//    CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
//               constrainedToSize:CGSizeMake([self tableView:tableView widthForColumn:col], MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//    
//    return s.height + 20.0f;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView widthForColumn:(NSInteger)column
{
    return cellWith;
}

- (NSInteger)tableView:(EWMultiColumnTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[data objectAtIndex:section] count];
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView sectionHeaderCellForSection:(NSInteger)section column:(NSInteger)col
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWith, cellHight)];
    return l;
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForSectionHeaderCell:(UIView *)cell section:(NSInteger)section column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"S %zd C %zd", section, col];
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor purpleColor];
}

- (NSInteger)numberOfColumnsInTableView:(EWMultiColumnTableView *)tableView
{
    return numberOfColumns;
}

#pragma mark Header Cell

- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForIndexPath:(NSIndexPath *)indexPath
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWith, cellHight)];
    return l;
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCell:(UIView *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"Line: (%zd, %zd)", indexPath.section, indexPath.row];
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor redColor];
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForHeaderCellAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHight;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForSectionHeaderCellAtSection:(NSInteger)section column:(NSInteger)col
{
    return cellHight;
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellInSectionHeaderForSection:(NSInteger)section
{
    UILabel *l = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWith, cellHight)] autorelease];
    return l;

}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCellInSectionHeader:(UIView *)cell AtSection:(NSInteger)section
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"Section %zd", section];
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor blueColor];
}

- (CGFloat)widthForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return cellWith;
}


- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForColumn:(NSInteger)col
{
    UILabel *l =  [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWith, cellHight)];
    l.text = [NSString stringWithFormat:@"Column: %zd", col];
    l.userInteractionEnabled = YES;
    
    l.tag = col;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    recognizer.numberOfTapsRequired = 2;
    [l addGestureRecognizer:recognizer];
    
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor orangeColor];

    return l;
}

- (UIView *)topleftHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    UILabel *l =  [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWith, cellHight)];
    l.text = @"Products";
    l.textAlignment = NSTextAlignmentCenter;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor blackColor];
    return l;
}

- (CGFloat)heightForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return cellHight;
}

- (void)tableView:(EWMultiColumnTableView *)tableView swapDataOfColumn:(NSInteger)col1 andColumn:(NSInteger)col2
{
    for (int i = 0; i < [self numberOfSectionsInTableView:tableView]; i++) {
        NSMutableArray *section = [data objectAtIndex:i];
        for (int j = 0; j < [self tableView:tableView numberOfRowsInSection:i]; j++) {
            NSMutableArray *a = [section objectAtIndex:j];
            id tmp = [[a objectAtIndex:col2] retain];
            
            [a replaceObjectAtIndex:col2 withObject:[a objectAtIndex:col1]];
            [a replaceObjectAtIndex:col1 withObject:tmp];
            [tmp release];
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    NSInteger col = [recognizer.view tag];
    for (NSMutableArray *array in sectionHeaderData) {
        [array removeObjectAtIndex:col];
    }
    
    for (NSMutableArray *section in data) {
        for (NSMutableArray *row in section) {
            [row removeObjectAtIndex:col];
        }
    }
    
    numberOfColumns--;
    
    [tblView reloadData];

}

- (void)tableView:(EWMultiColumnTableView *)tableView
didSelectRowAtColumn:(NSInteger)column
          section:(NSInteger)section
              row:(NSInteger)row
{
    NSLog(@"z  column:%zd, section:%zd, row:%zd", column, section, row);
}

- (void)tableView:(EWMultiColumnTableView *)tableView
didSelectRowAtColumn:(NSInteger)column
          section:(NSInteger)section
{
    NSLog(@"z  column:%zd, section:%zd", column, section);
}

@end
