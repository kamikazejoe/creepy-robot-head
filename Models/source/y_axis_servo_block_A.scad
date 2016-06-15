/* 
 * Project Name: Creepy Robot Head - Y-Servo Block Part A
 * Author: Kamikaze Joe
 * 
 * Description:
 * 
 * Generate model for part of the neck base of the Creepy Robot Head.
 * Simply calls the neck library and calls for the part.
 */



// *** INCLUDE/USE LIBRARIES *** //
//include <shapes.scad>;
include <fillets.scad>;
use <kamikaze_shapes.scad>;

// Same funcitonality will be built into OpenSCAD 2016.XX.
use <partial_rotate_extrude.scad>;

// Robot Head Libraries
include <neck.scad>;




// *** VARIABLES *** //


/*
 * Directions:
 * 
 * Enter the desired dimension for the jaw and teeth below.
 * 
 * Everything else should calculate automatically.
 * 
 */




module build_it() {

		y_servo_block_A();

}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
