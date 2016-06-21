/* 
 * Project Name: Creepy Robot Head - Middle Deck
 * Author: Kamikaze Joe
 * 
 * Description:
 * 
 * Middle plate to mount eye-servos and Raspberry Pi.
 * Slits cut out along plate for additional attachments.
 * 
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


plate_length = 150;
plate_width = 150;

// Plate is designed to be laser-cut
// Depth figure is only for design.
plate_depth = 5;

/*

Mounting Hole Diagram

|------------|
|1      2    |
|            |
|0      3    |
|------------|

*/

pi_screw_hole_vector = [
[3.5, 3.5, 0],          // Hole 0
[3.5, 3.5 + 49, 0],     // Hole 1
[3.5 + 56.5, 3.5 + 49, 0],// Hole 2
[3.5 + 56.5, 3.5, 0]      // Hole 3
];

plate_screw_diam = 3;

pi_screw_diam = 2.75;

pi_dimension = [85.6,56,21];

//raspi_loc = [55.4,45,0];
raspi_loc = [ plate_length - pi_dimension[0],
              ( plate_width - pi_dimension[1] ) / 2,
              0 ];

// *** MODULES AND FUNCTIONS *** //
// Mock-up of Raspberry Pi Dimensions
module raspi() {
    difference() {
        color("lightblue")
            cube(pi_dimension);

// mounting holes are 58mm x 49mm, 2.75 diameter
        translate(pi_screw_hole_vector[0])
            cylinder( h=pi_dimension[2], d=pi_screw_diam);

        translate(pi_screw_hole_vector[1])
            cylinder( h=pi_dimension[2], d=pi_screw_diam);

        translate(pi_screw_hole_vector[2])
            cylinder( h=pi_dimension[2], d=pi_screw_diam);

        translate(pi_screw_hole_vector[3])
            cylinder( h=pi_dimension[2], d=pi_screw_diam);
    }
}


// Screw holes to mount Raspberry Pi.
module screw_holes() {

    translate(pi_screw_hole_vector[0])
        cylinder( h=plate_depth, d=pi_screw_diam, $fn=standard_fn);

    translate(pi_screw_hole_vector[1])
        cylinder( h=plate_depth, d=pi_screw_diam, $fn=standard_fn);

    translate(pi_screw_hole_vector[2])
        cylinder( h=plate_depth, d=pi_screw_diam, $fn=standard_fn);

    translate(pi_screw_hole_vector[3])
        cylinder( h=plate_depth, d=pi_screw_diam, $fn=standard_fn);
}



// Mounting bracket for Raspberry Pi
module raspi_mount() {

/* // No idea what the point of this was.
    translate([64.4,47,0])
        difference() {
            cube([pi_dimension[0],pi_dimension[1],plate_depth]);

        translate([6.2,6.2,-3])
            cube([73.2,43.6,10]);
        }
*/
bracket_width = pi_screw_hole_vector[0][0] * 2;

bracket_outer_dim = [ pi_dimension[0],
                      pi_dimension[1],
                      plate_depth ];

bracket_inner_dim = [ pi_dimension[0] - (bracket_width * 2),
                      pi_dimension[1] - (bracket_width * 2),
                      plate_depth ];
    
    translate(raspi_loc)
        difference() {
            
            cube(bracket_outer_dim);
            
            translate([bracket_width, bracket_width, 0])
            cube(bracket_inner_dim);
            
        }
}




// Basic flat base plate shape.
module m_base_plate() {
    
    x = plate_length;
    y = plate_width;

/*  Original points.
 *  Angles were pretty arbitrary.

    plate_points = [
                    [  10,   0 ],
                    [   0,  20 ],
                    [   0, 130 ],
                    [  10, 150 ],
                    [ 130, 150 ],
                    [ 150, 130 ],
                    [ 150,  20 ],
                    [ 130,   0 ]
                   ];    
*/

    plate_points = [
                    [ x * .067,         0 ],
                    [        0,  y * .137 ],
                    [        0,  y * .867 ],
                    [ x * .067,         y ],
                    [ x * .867,         y ],
                    [        x,  y * .867 ],
                    [        x,  y * .137 ],
                    [ x * .867,         0 ]
                   ];
    
    linear_extrude(height = plate_depth, center = false, convexity = 10, twist = 0)
        polygon(
            //points=[ [10,0],[0,20],[0,130],[10,150],[130,150],[150,130],[150,20],[130,0] ],
            points=plate_points,
            paths=[ [0,1,2,3,4,5,6,7,8] ]
        );
}



// Mounting plate for servos.
module servo_plate() {
    translate([0,35,0])
        cube([40,23,5]);

    translate([0,93,0])
        cube([40,23,5]);
}



// Shape of cavity to hold servos.
module servo_cavity() {
    translate([5,40,-3])
        cube([24.4,12,10]);

    translate([5,98,-3])
        cube([24.4,12,10]);
}

// Server mounting screw holes.
module servo_screws() {
    translate([ 5-2.2, 46, -3])
        cylinder(h=10, d=2, $fn=standard_fn);

    translate([ 5 + 24.4 + 2.2 ,46,-3])
        cylinder(h=10, d=2, $fn=standard_fn);

    translate([ 5-2.2, 104, -3])
        cylinder(h=10, d=2, $fn=standard_fn);

    translate([ 5 + 24.4 + 2.2, 104, -3])
        cylinder(h=10, d=2, $fn=standard_fn);
}

// Screw mounting slot
module m_cut_slot() {
    //translate([5,5,-3])
      //  rotate([0,0,0])
            hull() {
                cylinder(h=plate_depth, d=plate_screw_diam, $fn=standard_fn);

                translate([0, (plate_width / 2) - (plate_width * .10), 0])
                    cylinder(h=plate_depth, d=plate_screw_diam, $fn=standard_fn);
                }
}

module m_slot_grid() {
    
    grid_start = plate_width * .067 + plate_screw_diam;
    grid_step = 10; // fix me.
    grid_end = plate_width * .867;
    
    for ( i = [ grid_start : grid_step : grid_end] )
    {
        translate([i, plate_screw_diam * 2, 0])
            m_cut_slot();
    }

        for ( i = [grid_start : grid_step : grid_end] )
    {
        translate([i, (plate_width / 2) + (plate_width * .10) - (plate_screw_diam * 2), 0])
            m_cut_slot();
    }
}

// Add mounting brackets to gridded base plate
module m_grid_plate() {

    raspi_mount();
    servo_plate();

    difference() {
        m_base_plate();
        m_slot_grid();
    }

}

// Build the grid plate with mounting holes.
module middle_deck_plate() {
    
    difference() {
        m_grid_plate();
        servo_cavity();
        servo_screws();
        //translate([58.4,47,0])
        translate(raspi_loc)
            screw_holes();
    }
}



// Build_it function just for testing out each module
// during development.
module build_it() {
        
    middle_deck_plate();
    
    /*
    translate([58.4,47,5])
    rotate([0,0,0])
        raspi();
    */

}

// *** MAIN ***  //
//projection() translate([0,0,100]) build_it();
build_it();

