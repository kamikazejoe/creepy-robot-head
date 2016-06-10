/* 
 * Project Name:
 * Author: Kamikaze Joe
 * 
 * Description:
 */

/* *** TODO LIST ***
 * 
 * Tabs to spaces
 * 
 */ 

/* ***** Cheats *****

cube([x,y,z]);
translate([x,y,z]);
rotate([x_deg,y_deg,z_deg]);
cylinder(h=x,d=y);

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
use <shapes.scad>;
use <fillets.scad>;
use <kamikaze_shapes.scad>;

// *** VARIABLES *** //
standard_fn = 20;


// *** MODULES AND FUNCTIONS *** //

// Build_it function just for testing out each module
// during development.
module build_it() {
	
}

// *** MAIN ***  //
build_it();
