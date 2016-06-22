/*
 * Project Name: Creepy Robot Head - Upper Jaw
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Generate model for the upper jaw of the Creepy Robot Head.
 * Simply calls the jaw library and calls for the upper jaw.
 */

// *** INCLUDE/USE LIBRARIES *** //
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

jaw_length = 60;
jaw_width  = 40;
jaw_height = 20;


// Tooth Dimensions
// [x,y,z,r] where;
// x,y,z are dimensions of the cube.
// r is the radius of curved corners.
// Embedded 'r' into the gum line.

tooth_length = 9;
tooth_width  = 5;
tooth_height = 10;
tooth_radius = 1;

num_of_teeth = 14;

standard_fn = 20;



// *** MODULES AND FUNCTIONS *** //
module build_it() {

  upper_jaw();

}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
