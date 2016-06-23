/*
 * Project Name: Creepy Robot Head - Mount Base Plate
 * Author: Kamikaze Joe
 *
 * Description:
 *
 * Base plate to build mounting plates that will fit on the bottom
 * of the x-axis base of the neck.
 *
 */



// *** INCLUDE/USE LIBRARIES *** //
include <fillets.scad>;
use <kamikaze_shapes.scad>;

// Robot Head Libraries
include <neck.scad>;



// *** VARIABLES *** //
mount_socket_diam = 6.35;


// *** MODULES AND FUNCTIONS *** //

module tripod_base_plate() {

  difference() {

    mount_base_plate();

    cylinder( h=screw_head_diameter, d=mount_socket_diam );

  }

}

module build_it() {

    tripod_base_plate();
}

// *** MAIN ***  //
$fn = standard_fn;
build_it();
