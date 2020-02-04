// Printing mode
// 0: Object is displayed in a way that is better for engineering / all things stick together
// 1: Object is displayed optimized for printing
PRINTING_MODE = 1;




// Display size: 84,5mm x 63,5mm
displayInnerWidth = 84.5;
displayInnerHeight = 63.5;
displayInnerFrameLeftRight = 9.2;
displayInnerFrameTop = 4;
displayInnerFrameBottom = 11.5;

displayWidth = displayInnerWidth + 2 * displayInnerFrameLeftRight;
displayHeight = displayInnerHeight + displayInnerFrameTop + displayInnerFrameBottom;
displaySpiel = 0.4;

echo("Total display size (including edges): ", displayWidth, " x ", displayHeight);

displayPlateHeight = 3.5;
displayTotalHeight = 9.5;

frameAdditionalSpace = 7.3; // Min. 5.5mm so that cables can be well folded at left side
frameWallThickness = 1;
frameWallAddThicknessForCover = 1.2;
frameCoverPlateThickness = 2;
frameCoverPlateThicknessAtScrews = 1;
frameCoverPlateTolerance = 0.5;
frameCoverPlateHoleCableRadius = 4;

frameSpaceInside = 25;

frameTotalWidth = displayInnerWidth + 2 * displayInnerFrameBottom + 2 * frameAdditionalSpace + 2 * frameWallThickness;
frameTotalHeight = displayInnerHeight + 2 * displayInnerFrameBottom + 2 * frameAdditionalSpace + 2 * frameWallThickness;

frameCornerCubeWidth = 8;
frameCornerCubeHeight = frameSpaceInside;
frameCornerScrewNutHeight = 2.6;
frameCornerScrewHoleRadius = 1.9;
frameCornerScrewIndentationRadius = 4;
frameCornerScrewNutRadius = 2.75 / cos(30) + 0.2; // See norms for details, 0.2 is the tolerance that is used here

frameDisplayFixationFrameElementsWidth = 2;
frameDisplayFixationFrameElementsDepth = 3;
frameDisplayFixationFrameStructureThickness = 3;
frameDisplayFixationFrameTolerance = 0.4;

frameDisplayFixationFrameElementsMargin = displayInnerFrameLeftRight + frameAdditionalSpace + 10;



// Helper function for the screws: With the function you can place objects to the correct corner: starting with (0,0) and in counterclockwise direction
// Example usage:
// for(corner=[0:1:3]){
//     moveChildToCorrectCorner(corner) frameCornerScrewHole();
// }
module moveChildToCorrectCorner(corner = 0, rotationAngle = 0, zOffset = frameWallThickness + displayPlateHeight){
    x_offset = (corner % 3 == 0) ? frameCornerCubeWidth/2 + frameWallThickness + frameWallAddThicknessForCover : frameTotalWidth - frameCornerCubeWidth/2 - frameWallThickness - frameWallAddThicknessForCover;
        
    y_offset = (corner <= 1) ? frameCornerCubeWidth/2 + frameWallThickness + frameWallAddThicknessForCover : frameTotalHeight - frameCornerCubeWidth/2 - frameWallThickness - frameWallAddThicknessForCover;
            
    translate([x_offset, y_offset, zOffset]) rotate(a=corner*rotationAngle, v = [0,0,1]) children();
}


module moveChildToCorrectFixingPoint(corner = 0, totalWidth = 0, zOffset = frameWallThickness + displayPlateHeight){
     
    x_offset = (corner % 3 == 0) ? frameWallThickness + frameWallAddThicknessForCover + frameDisplayFixationFrameElementsMargin: frameTotalWidth - frameWallThickness - frameWallAddThicknessForCover - frameDisplayFixationFrameElementsMargin - totalWidth;
        
    y_offset = (corner <= 1) ? frameWallThickness + frameWallAddThicknessForCover : frameTotalHeight - frameWallThickness - frameWallAddThicknessForCover - frameDisplayFixationFrameElementsDepth;
            
    translate([x_offset, y_offset, zOffset]) children();
}


    //////////////////////////////////////////////////////////////////////
   //                                                                  //
  //           MAIN PART OF THE FRAME: BOTTOM AND WALLS               //
 //                                                                  //
//////////////////////////////////////////////////////////////////////


difference(){
    translate([0,0,0]) cube([frameTotalWidth, frameTotalHeight,frameWallThickness + displayPlateHeight + frameSpaceInside + frameCoverPlateThickness]); // 
    
    translate([frameAdditionalSpace + frameWallThickness + displayInnerFrameBottom,frameAdditionalSpace + frameWallThickness + displayInnerFrameBottom,-1]) cube([displayInnerWidth,displayInnerHeight,30]); // Cube for cutting out the first layer in front of the real  display (without a frame around the display)
    
    translate([frameAdditionalSpace + frameWallThickness + displayInnerFrameBottom - displayInnerFrameLeftRight - displaySpiel,frameAdditionalSpace + frameWallThickness - displaySpiel,frameWallThickness]) cube([displayWidth + 2 * displaySpiel,displayHeight + 2 * displaySpiel,30]); // Cube for cutting out the space where the complete display (with it's frame) lays in
    
    translate([frameWallThickness + frameWallAddThicknessForCover,frameWallThickness + frameWallAddThicknessForCover,frameWallThickness + displayPlateHeight]) cube([frameTotalWidth - 2 * frameWallThickness - 2 * frameWallAddThicknessForCover, frameTotalHeight - 2 * frameWallThickness - 2 * frameWallAddThicknessForCover, 30]); // Cube for cutting out all the rest of the inside where all the electronics can be
    
    translate([frameWallThickness,frameWallThickness,frameWallThickness + displayPlateHeight + frameSpaceInside]) cube([frameTotalWidth - 2 * frameWallThickness, frameTotalHeight - 2 * frameWallThickness, 30]); // Cube for cutting out the edge on which the cover plate lays
}






    //////////////////////////////////////////////////////////////////////
   //                                                                  //
  //                  SCREW HOLDER IN THE CORNERS                     //
 //                                                                  //
//////////////////////////////////////////////////////////////////////


module frameCornerScrewHolder(){
    difference(){
        rotate(v = [0,0,1], a = 135) translate([-5*frameCornerCubeWidth, -frameCornerCubeWidth/2, 0]) cube([10*frameCornerCubeWidth, 10*frameCornerCubeWidth, frameCornerCubeHeight]);
        rotate(v=[0,0,1], a = 15) translate([0, 0, frameCornerCubeHeight-frameCornerScrewNutHeight]) cylinder(r = frameCornerScrewNutRadius, h = 50, $fn = 6);
        translate([0, 0, -10]) cylinder(h = 50, r = frameCornerScrewHoleRadius, $fn = 50 + PRINTING_MODE * 150);
        translate([10 * frameCornerCubeWidth,0,0]) rotate(v=[0,0,1], a = 180) translate([frameCornerCubeWidth/2, frameCornerCubeWidth/2, -2*frameCornerCubeHeight]) cube([20*frameCornerCubeWidth, 20*frameCornerCubeWidth, 4*frameCornerCubeHeight]);
        translate([0, 10 * frameCornerCubeWidth,0]) rotate(v=[0,0,1], a = 180) translate([frameCornerCubeWidth/2, frameCornerCubeWidth/2, -2*frameCornerCubeHeight]) cube([20*frameCornerCubeWidth, 20*frameCornerCubeWidth, 4*frameCornerCubeHeight]);
    }
}



// 4 screw holders in the corners
for(corner=[0:1:3]){
    moveChildToCorrectCorner(corner, 90) frameCornerScrewHolder();
}





    //////////////////////////////////////////////////////////////////////
   //                                                                  //
  //                    DISPLAY FIXATION STRUCTURE                    //
 //                                                                  //
//////////////////////////////////////////////////////////////////////


module frameDisplayFixation(){
    // First fixation element border
    cube([frameDisplayFixationFrameElementsWidth, frameDisplayFixationFrameElementsDepth, frameSpaceInside]);
    
    // Second fixation element border
    translate([frameDisplayFixationFrameElementsWidth + frameDisplayFixationFrameStructureThickness + 2 * frameDisplayFixationFrameTolerance, 0, 0])
    cube([frameDisplayFixationFrameElementsWidth, frameDisplayFixationFrameElementsDepth, frameSpaceInside]);
}



// Fixation elements at 4 points
for(corner=[0:1:3]){
    moveChildToCorrectFixingPoint(corner, 2 * frameDisplayFixationFrameElementsWidth + frameDisplayFixationFrameStructureThickness + 2 * frameDisplayFixationFrameTolerance) frameDisplayFixation();
}


module frameDisplayFixationFrameStructure(){
    difference(){
        frameDisplayFixationFrameStructureHeigth = frameTotalHeight - 2 * frameWallThickness - 2 * frameWallAddThicknessForCover - 2 * frameDisplayFixationFrameTolerance;
        cube([frameDisplayFixationFrameStructureThickness, frameDisplayFixationFrameStructureHeigth, frameSpaceInside - frameDisplayFixationFrameTolerance]);
        
        // ATTENTION: For the cutted out parts this is manually done by eye --> Enter good values here, they aren't stored in variables
        translate([-100, 10, 2 * frameWallAddThicknessForCover]) cube([200, 30, 50]);
        translate([-100, frameDisplayFixationFrameStructureHeigth - 40, 2 * frameWallAddThicknessForCover])cube([200, 30, 50]);
    }
}




x1_offset = (PRINTING_MODE) ? frameTotalWidth - frameDisplayFixationFrameElementsMargin/2 : frameWallThickness + frameWallAddThicknessForCover + frameDisplayFixationFrameElementsMargin + frameDisplayFixationFrameElementsWidth + frameDisplayFixationFrameTolerance;
x2_offset = (PRINTING_MODE) ? frameTotalWidth - frameDisplayFixationFrameElementsMargin/2 : frameTotalWidth - x1_offset - frameDisplayFixationFrameStructureThickness;

y1_offset = (PRINTING_MODE) ? frameTotalHeight + frameSpaceInside + 10: frameWallThickness + frameWallAddThicknessForCover + frameDisplayFixationFrameTolerance;
y2_offset = (PRINTING_MODE) ? frameTotalHeight + 2 * frameSpaceInside + 20 : frameWallThickness + frameWallAddThicknessForCover + frameDisplayFixationFrameTolerance;

z_offset = (PRINTING_MODE) ? 0 : frameWallThickness + displayPlateHeight + frameDisplayFixationFrameTolerance;

translate([x1_offset, y1_offset, z_offset])
rotate(v = [1,0,0], a = 90 * PRINTING_MODE) rotate(v = [0,0,1], a = 90 * PRINTING_MODE) frameDisplayFixationFrameStructure();

translate([x2_offset, y2_offset, z_offset]) rotate(v = [1,0,0], a = 90 * PRINTING_MODE) rotate(v = [0,0,1], a = 90 * PRINTING_MODE) frameDisplayFixationFrameStructure();

    //////////////////////////////////////////////////////////////////////
   //                                                                  //
  //                         COVER PLATE                              //
 //                                                                  //
//////////////////////////////////////////////////////////////////////



module frameCornerScrewHole(){
    translate([0, 0, -10]) cylinder(h = 50, r = frameCornerScrewHoleRadius, $fn = 50 + PRINTING_MODE * 200);
}

module frameCornerScrewHoleScrew(){
    translate([0, 0, 0]) cylinder(h = 50, r = frameCornerScrewIndentationRadius, $fn = 50 + PRINTING_MODE * 200, center = false);
}


translate([0, PRINTING_MODE * ( -110 ), PRINTING_MODE * -(frameWallThickness + displayPlateHeight + frameSpaceInside)]){
    
    // Main plate with slot for a cable that can go out at the back
    difference(){
        translate([frameWallThickness + frameCoverPlateTolerance,frameWallThickness + frameCoverPlateTolerance, frameWallThickness + displayPlateHeight + frameSpaceInside]) 
        
        difference(){
            cube([frameTotalWidth - 2 * frameWallThickness -2 * frameCoverPlateTolerance, frameTotalHeight - 2 * frameWallThickness - 2 * frameCoverPlateTolerance, frameCoverPlateThickness]);
            
            translate([(frameTotalWidth - 2 * frameWallThickness -2 * frameCoverPlateTolerance)/2,0,0]) cylinder(r = frameCoverPlateHoleCableRadius, h = 20, $fn = 50 + PRINTING_MODE * 200, center = true); // Cylinder for the slot where a cable can go out
        }
    
        
        // ----- Holes for screws -----
        for(corner=[0:1:3]){
            moveChildToCorrectCorner(corner, 0) frameCornerScrewHole();
        }
        
        
        // ----- Indentation for screws: Big radius but small depth -----
        translate([0,0, frameWallThickness + displayPlateHeight + frameSpaceInside + frameCoverPlateThicknessAtScrews]){
            for(corner=[0:1:3]){
                moveChildToCorrectCorner(corner, 0, zOffset = 0) frameCornerScrewHoleScrew();
            }
        }
    }
    
}