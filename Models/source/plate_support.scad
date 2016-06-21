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
 * Make proportional to plates.
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
        
fillet_linear_o(l, fillet_r, fillet_angle=90, fillet_fn=0, add=0.02)
 */

// *** INCLUDE/USE LIBRARIES *** //
//use <shapes.scad>;
use <fillets.scad>;
use <kamikaze_shapes.scad>;

// *** VARIABLES *** //

bracket_width = 20;
bracket_length = 60;

print_gap = 2;

screw_diam = 3;
screw_head_diameter = 6;

screw_length = screw_diam + 1;
recess_diam  = screw_head_diameter + print_gap;
recess_depth = screw_head_diameter;

standard_fn = 20;


// *** MODULES AND FUNCTIONS *** //

module l_shape() {
  
  translate([ 0, recess_diam * 3, 0 ])
    fillet_linear_o( bracket_width, recess_diam );
  
  translate([ recess_diam, recess_diam, 0 ])  
    fillet_linear_i( bracket_width, recess_diam );

/*
  translate([ screw_head_diameter * 2, 0, 0 ])
    fillet_linear_o( bracket_width, screw_head_diameter );
*/
  
  cube([ recess_diam, recess_diam * 3, bracket_width]);

}

module screw_holes() {
  
  screw_loc = [ 
		[0, recess_diam * 1.5, 5],
		[0, recess_diam * 1.5, 15],
		[0, recess_diam * 3, 5],
		[0, recess_diam * 3, 15]
	      ];
  
  translate(screw_loc[0])
    rotate([0,90,0])
      recessed_screw_cutout( bracket_length / 2, recess_diam, screw_length, screw_diam );
  
  translate(screw_loc[1])
    rotate([0,90,0])
      recessed_screw_cutout( bracket_length / 2, recess_diam, screw_length, screw_diam );
      
  translate(screw_loc[2])
    rotate([0,90,0])
      recessed_screw_cutout( bracket_length / 2, recess_diam, screw_length, screw_diam );
  
  translate(screw_loc[3])
    rotate([0,90,0])
      recessed_screw_cutout( bracket_length / 2, recess_diam, screw_length, screw_diam );
  
}

module bracket_end() {
  
  difference() {
    
    l_shape();
    
    screw_holes();
  }
}

module plate_support_bracket() {
  
  bracket_end();
  
  cube([ bracket_length, recess_diam, bracket_width]);
  
  translate([ bracket_length, 0, 0])
    mirror([1,0,0])
      bracket_end();
    
}

// Build_it function just for testing out each module
// during development.
module build_it() {
  
  plate_support_bracket();
  //screw_holes();
	
}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
