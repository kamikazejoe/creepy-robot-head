/* 
 * Project Name: Creepy Robot Head - Bottom Jaw
 * Author: Kamikaze Joe
 * 
 * Description:
 * 
 * Generate model for the lower jaw of the Creepy Robot Head.
 * Simply calls the jaw library and calls for the bottom jaw.
 */



// *** INCLUDE/USE LIBRARIES *** //
//include <shapes.scad>;
include <fillets.scad>;
use <kamikaze_shapes.scad>;

// Same funcitonality will be built into OpenSCAD 2016.XX.
use <partial_rotate_extrude.scad>;

// Robot Head Libraries
include <jaw.scad>;




// *** VARIABLES *** //


/*
 * Directions:
 * 
 * Enter the desired dimension for the jaw and teeth below.
 * 
 * Everything else should calculate automatically.
 * 
 */
 
// Length, width, and height of the basic jaw. [x,y,z]
// x should be greater than y.
// Does not include additonal height of lower jaw hinge.
// The height of the lower hinge is to accommodate the
// upper and lower jaw fitting together.

Jaw_Length = 230;
Jaw_Width  = 150;
Jaw_Height = 70;




// Tooth Dimensions
// [x,y,z,r] where;
// x,y,z are dimensions of the cube.
// r is the radius of curved corners.
// Embedded 'r' into the gum line.

Tooth_Length = 35;
Tooth_Width  = 18;
Tooth_Height = 40;
Tooth_Radius = 5;



module build_it() {

	scale([0.25,0.25,0.25])
		bottom_jaw();

}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
