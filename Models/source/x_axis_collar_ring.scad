/*
 * Project Name: Creepy Robot Head - X-axis Collar Ring
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Generate model for part of the neck base of the Creepy Robot Head.
 * Simply calls the neck library and calls for the part.
 */



// *** INCLUDE/USE LIBRARIES *** //
include <fillets.scad>;
use <kamikaze_shapes.scad>;

// Same funcitonality will be built into OpenSCAD 2016.XX.
use <partial_rotate_extrude.scad>;

// Robot Head Libraries
include <neck.scad>;



// *** VARIABLES *** //



// *** MODULES AND FUNCTIONS *** //
module build_it() {

    x_collar_ring();

}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
