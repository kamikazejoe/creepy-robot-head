/*
 * Project Name: Creepy Robot Head - Upper Jaw
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Generate model for the upper jaw of the Creepy Robot Head.
 * Simply calls the jaw library and calls for the upper jaw.
 */

/* *** TODO LIST ***
 *
 * Tab to spaces
 *
 */

// *** INCLUDE/USE LIBRARIES *** //
//include <shapes.scad>;
//include <fillets.scad>;
use <kamikaze_shapes.scad>;

// Same funcitonality will be built into OpenSCAD 2016.XX.
use <partial_rotate_extrude.scad>;

// Robot Head Libraries
use <jaw.scad>;




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

standard_fn = 20;


module build_it() {

  upper_jaw();

}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
