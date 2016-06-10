/* 
 * Project Name: Raspberry Pi Crust
 * Author: Kamikaze Joe
 * 
 * Description:
 * 
 * Library for building mounting plates and cases
 * for a Raspberry Pi B+/2.
 */

/* *** TODO LIST ***
 * Vented Bracket
 * Cases
 * Documentation
 * 
 */ 

/* *** DOCUMENTATION *** 
 * 
 * raspi_mount_plate(h,$fn);
 * 
 * 		Basic flat plate that is slightly larger than the dimensions
 * 		of the Raspberry Pi.
 * 		
 * 		Parameters:
 * 		'h' is the z-depth of the model.
 * 		$fn defines the number of polygons that make up the screw holes.
 * 
 * 
 * rounded_raspi_mount_plate(h,r,$fn);
 * 
 * 		Basic flat plate that is slightly larger than the dimensions
 * 		of the Raspberry Pi, but with the corners rounded.
 *      
 *      Parameters:
 * 		'h' is the z-depth of the model.
 * 		'r' defines the radius of the corner.
 *      $fn defines the number of polygons that make up the screw holes
 * 			and corners.
 * 
 * raspi_bracket(h);
 * 
 * 		Same dimensions as the raspi_mount_plate, but with an area
 * 	    cut-out between the mounting screw holes. 
 *      
 *      Use to save on material, or allow cooling.
 * 		
 *      'h' is the z-depth of the model.
 *      $fn defines the number of polygons that make up the screw holes.
 * 
 * rounded_raspi_bracket(h,r,$fn);
 *      
 *      Same dimensions as the raspi_mount_plate, but with an area
 * 	    cut-out between the mounting screw holes and rounded corners.
 *      
 *      Use to save on material, or allow cooling.
 * 
 *      Parameters:
 * 		'h' is the z-depth of the model.
 * 		'r' defines the radius of the corner.
 *      $fn defines the number of polygons that make up the screw holes
 *          and corners.
 */



// *** INCLUDE/USE LIBRARIES *** //
include <shapes.scad>;
include <fillets.scad>;



// *** VARIABLES *** //
pi_screw_diam = 3.75; // Extra 1mm in diameter to account for extrusion
stem_height = 25; // Stand offs

pi_width = 85.6;
pi_height = 56;
pi_depth = 21;

pi_dimensions = [ pi_width, pi_height, pi_depth ];

base_plate_overhang = 4;

rounded_corner_radius = 2;



/*

Mounting Hole Diagram

|------------|
|1      2    |
|            |
|0      3    |
|------------|

*/

screw_hole_vector = [
[3.5, 3.5, 0],          // Hole 0
[3.5, 3.5 + 49, 0],     // Hole 1
[3.5 + 56.5, 3.5 + 49, 0],// Hole 2
[3.5 + 56.5, 3.5, 0]      // Hole 3
];



base_plate_w = pi_width + base_plate_overhang;
base_plate_h = pi_height + base_plate_overhang;

// For Development.
space_gap = 5;
spacing_x = base_plate_w + space_gap;
spacing_y = base_plate_h + space_gap;

standard_fn = 20;


// *** MODULES AND FUNCTIONS *** //

// Mock-up of Raspberry Pi B+/2 Dimensions
module raspi() {
    difference() {
        color("lime")
            cube(pi_dimensions);
    
// mounting holes are 58mm x 49mm, 2.75 diameter
        translate(screw_hole_vector[0])
            cylinder(h=pi_depth + 1, d=pi_screw_diam);
        
        translate(screw_hole_vector[1])
            cylinder(h=pi_depth + 1, d=pi_screw_diam);
        
        translate(screw_hole_vector[2])
            cylinder(h=pi_depth + 1, d=pi_screw_diam);
        
        translate(screw_hole_vector[3])
            cylinder(h=pi_depth + 1, d=pi_screw_diam);
    }
}



// Screw holes to mount Raspberry Pi.
// Measured from the Pi at 0,0.
// Need to be translated for larger platforms.
module raspi_screw_holes(plate_depth, diam=pi_screw_diam, mod_fn=$fn) {

    translate(screw_hole_vector[0])
        cylinder(h=plate_depth, d=diam, $fn=mod_fn);
    
    translate(screw_hole_vector[1])
        cylinder(h=plate_depth, d=diam, $fn=mod_fn);
    
    translate(screw_hole_vector[2])
        cylinder(h=plate_depth, d=diam, $fn=mod_fn);
    
    translate(screw_hole_vector[3])
        cylinder(h=plate_depth, d=diam, $fn=mod_fn);
}



// Base plate for Raspberry Pi mount.
// Is 4mm x 4mm larger than the Pi.
module raspi_base_plate(plate_depth) {
   
   cube([base_plate_w,base_plate_h,plate_depth]);

}



module rounded_raspi_base_plate(plate_depth, corners=rounded_corner_radius, mod_fn=$fn) {
   
   // Thinner because minkowski is the sum of the shapes.
   minkowski() { 
      cube([base_plate_w, base_plate_h, plate_depth/2 ]);
      cylinder(h=plate_depth/2, r=corners, $fn=mod_fn);
   }

}



// Completed mounting plate.
module raspi_mount_plate(plate_depth, mod_fn=$fn) {
   
   difference() {
      raspi_base_plate(plate_depth);
      
      translate([2,2,0])
         raspi_screw_holes(plate_depth, pi_screw_diam, mod_fn);
      
   }
}



module rounded_raspi_mount_plate(plate_depth, corners=rounded_corner_radius, mod_fn=$fn) {
   
   difference() {
      rounded_raspi_base_plate(plate_depth, corners, mod_fn);
      
      translate([rounded_corner_radius , rounded_corner_radius ,0])
         raspi_screw_holes(plate_depth);
      
   }
}



// Add vents in plate for coooling
module raspi_vented_bracket(plate_depth, mod_fn=$fn) {
   
   // WORK IN PROGRESS
   // width of slits
   // angle of slits
   // parallelogram
   // a^2 + b^2 = c^2
   // auto number of slits.
	linear_extrude(height = plate_depth, center = false, convexity = 10, twist = 0)
        polygon(
            points=[ [0,0],
					 [0,0],
					 [0,0],
					 [0,0] ],
            paths=[ [0,1,2,3] ]
        );
   
   
   
}

// Add vents in plate for coooling
module rounded_raspi_vented_bracket(plate_depth, corners=rounded_corner_radius, mod_fn=$fn) {
   
   // WORK IN PROGRESS
   
}


module bracket_cutout(plate_depth) {
	
	// 1st Screw position 
    // + oversize of the plate 
    // + radius of the screw hole 
    translate([ screw_hole_vector[0][0] 
                + (base_plate_overhang / 2) 
                + (pi_screw_diam/2),
                
                screw_hole_vector[0][1] 
                + (base_plate_overhang / 2) 
                + (pi_screw_diam/2), 
                0])

      cube([ screw_hole_vector[2][0] 
             - (pi_screw_diam) 
             - base_plate_overhang,
             
             screw_hole_vector[2][1] 
             - (pi_screw_diam) 
             - base_plate_overhang,
              
             plate_depth]);

}



// Build a hollow bracket instead of full plate
module raspi_bracket(plate_depth, mod_fn=$fn) {
   
   difference() {
	   
	   raspi_mount_plate(plate_depth, mod_fn);
	   
	   bracket_cutout(plate_depth);
	}
}



module rounded_raspi_bracket(plate_depth, corners=rounded_corner_radius, mod_fn=$fn) {
	
   difference() {
	   
	   rounded_raspi_mount_plate(plate_depth, corners, mod_fn);
	   
	   bracket_cutout(plate_depth);
	}
}



module raspi_cover_standoffs() {
   
   //Stand-offs
   stem_radius=4;
   wall_thickness=1;
   
   //Bottom
   translate(screw_hole_vector[0])
       cylinder(h=2, r=stem_radius, $fn=standard_fn);
    
   translate(screw_hole_vector[1])
       cylinder(h=2, r=stem_radius, $fn=standard_fn);
    
   translate(screw_hole_vector[2])
       cylinder(h=2, r=stem_radius, $fn=standard_fn);
    
   translate(screw_hole_vector[3])
       cylinder(h=2, r=stem_radius, $fn=standard_fn);   


   
   translate(screw_hole_vector[0])
       tube(stem_height, stem_radius, wall_thickness);
    
   translate(screw_hole_vector[1])
       tube(stem_height, stem_radius, wall_thickness);
    
   translate(screw_hole_vector[2])
       tube(stem_height, stem_radius, wall_thickness);
    
   translate(screw_hole_vector[3])
       tube(stem_height, stem_radius, wall_thickness);


   //Stem Fillets
   //Translating twice.  Once for stem height, then again for screw hole position.
   translate([0, 0, stem_height])
   translate(screw_hole_vector[0])
      rotate([0,180,0])
         fillet_polar_i(4, 1, fillet_fn=10, rotate_fn=standard_fn);
    
   translate([0, 0, stem_height])
   translate(screw_hole_vector[1])
      rotate([0,180,0])
         fillet_polar_i(4, 1, fillet_fn=10, rotate_fn=standard_fn);
    
   translate([0, 0, stem_height])
   translate(screw_hole_vector[2])
      rotate([0,180,0])
         fillet_polar_i(4, 1, fillet_fn=10, rotate_fn=standard_fn);
    
   translate([0, 0, stem_height])
   translate(screw_hole_vector[3])
      rotate([0,180,0])
         fillet_polar_i(4, 1, fillet_fn=10, rotate_fn=standard_fn);
   
   // Fillets to provide print support
   translate([0, 0, 2])
   translate(screw_hole_vector[0])
      rotate([0,0,0])
         fillet_polar_i_n(3, 2, fillet_fn=10, rotate_fn=standard_fn);  

   translate([0, 0, 2])
   translate(screw_hole_vector[1])
      rotate([0,0,0])
         fillet_polar_i_n(3, 2, fillet_fn=10, rotate_fn=standard_fn);  

   translate([0, 0, 2])
   translate(screw_hole_vector[2])
      rotate([0,0,0])
         fillet_polar_i_n(3, 2, fillet_fn=10, rotate_fn=standard_fn);  
         
   translate([0, 0, 2])
   translate(screw_hole_vector[3])
      rotate([0,0,0])
         fillet_polar_i_n(3, 2, fillet_fn=10, rotate_fn=standard_fn);   
      
       
}



module raspi_cover() {
   
   difference() {
   
      union() {
         translate([2, 60 - 2, stem_height + 3])
         rotate([180,0,0])
            raspi_cover_standoffs();
   
         raspi_base_plate(3);
    
      }
      
      translate([2,2,0])
         raspi_screw_holes(30);
      
      translate([2,2,0])
         raspi_screw_holes(4, 6); // Allowing for recessed screws.
   }
}



// Build_it function just for testing out each module
// during development.
module build_it() {
	
	// First row
	raspi(); 
	
	translate([spacing_x,0,0])
	raspi_base_plate(5);
	
	translate([2 * spacing_x,0,0])
	bracket_cutout();
	
	translate([3 * spacing_x,0,0])
	raspi_cover_standoffs();	
	
	// Second row
	translate([0,spacing_y,0])
	raspi_mount_plate(5);
	
	translate([spacing_x,spacing_y,0])
	rounded_raspi_mount_plate(5);
	
	// Third row
	translate([0, 2 * spacing_y,0])
	   raspi_bracket(5);
	
	translate([spacing_x, 2 * spacing_y,0])
		rounded_raspi_bracket(5);
	   
}

// *** MAIN *** //
$fn = standard_fn;
build_it();
