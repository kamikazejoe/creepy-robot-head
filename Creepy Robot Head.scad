/* 
 * Project Name: Creepy Robot Head
 * Author: Kamikaze Joe
 * 
 * Description:
 * 
 * 3D Models of Creepy Robot Head that will do stuff
 */

/* *** TODO LIST ***
 * 
 * Tab to spaces
 * 
 */ 

/* ***** Cheats *****

translate([0,0,0])
    rotate([0,0,0])
        function();

vector = [ // aka: A matrix or array.
[0, 0, 0],          // vector[0][0,1,2]
[0, 0, 0],     		// vector[1]
[0, 0, 0],			// vector[2]
[0, 0, 0]      		// vector[3]
];
        

 */

// *** INCLUDE/USE LIBRARIES *** //
//include <shapes.scad>;
include <fillets.scad>;
//include <joesmodules.scad>;

//Other Robot Head Parts
include <jaw.scad>;
include <bottom-jaw.scad>;
include <upper-jaw.scad>;
include <mid-deck.scad>;
include <upper-deck.scad>;
include <neck.scad>;
//include <camera_mount.scad>;


// *** VARIABLES *** //
standard_fn = 20;


// *** MODULES AND FUNCTIONS *** //

module build_it() {

	translate([0,0,0]) {
		
		x_neck_A();
		x_neck_B();
		
	}
	
	translate([0,0,100]) {
		
		scale([0.25,0.25,0.25])
			translate([0,0,0])
				rotate([0,0,0])
					bottom_jaw();
		
		scale([0.25,0.25,0.25])
			translate([0,0,jaw_dimension[1]])
				rotate([180,0,0])
					upper_jaw();
			}
	
}

// *** MAIN ***  //
build_it();
