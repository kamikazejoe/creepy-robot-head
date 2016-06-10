

// Mock-up of Raspberry Pi Dimensions
module raspi() {
    difference() {
        color("lightblue")
            cube([85.6,56,21]);
    
// mounting holes are 58mm x 49mm, 2.75 diameter
        translate([3.5,3.5,0])
            cylinder(h=22, d=2.75);
        
        translate([3.5,52.5,0])
            cylinder(h=22, d=2.75);
        
        translate([61.5,52.5,0])
            cylinder(h=22, d=2.75);
        
        translate([61.5,3.5,0])
            cylinder(h=22, d=2.75);
    }
}


// Screw holes to mount Raspberry Pi.
module screw_holes() {
    
    translate([3.5,3.5,0])
        cylinder(h=22, d=2.75, $fn=20);
    
    translate([3.5,52.5,0])
        cylinder(h=22, d=2.75, $fn=20);
    
    translate([61.5,52.5,0])
        cylinder(h=22, d=2.75, $fn=20);
    
    translate([61.5,3.5,0])
        cylinder(h=22, d=2.75, $fn=20);
}



// Mounting bracket for Raspberry Pi
module raspi_mount() {
    
    
    translate([64.4,47,0])
        difference() {
            cube([85.6,56,5]);
        
        translate([6.2,6.2,-3])
            cube([73.2,43.6,10]);
        } 
    


// Bracket
        translate([55.4,45,0])
        difference() {
            cube([89.6,60,5]);
        
        translate([6.2,8.2,-3])
            cube([73.2,43.6,10]);
        }
}




// Basic flat base plate shape.
module base_plate() {
    linear_extrude(height = 5, center = false, convexity = 10, twist = 0)
        polygon(
            points=[ [10,0],[0,20],[0,130],[10,150],[130,150],[150,130],[150,20],[130,0] ],
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
        cylinder(h=10, d=2, $fn=20);
    
    translate([ 5 + 24.4 + 2.2 ,46,-3])
        cylinder(h=10, d=2, $fn=20);
    
    translate([ 5-2.2, 104, -3])
        cylinder(h=10, d=2, $fn=20);
    
    translate([ 5 + 24.4 + 2.2, 104, -3])
        cylinder(h=10, d=2, $fn=20);
}

// Screw mounting slot
module cut_slot() {
    //translate([5,5,-3])
      //  rotate([0,0,0])
            hull() {
                cylinder(h=10, d=3, $fn=20);
                    
                translate([0,60,0])
                    cylinder(h=100, d=3, $fn=20);
                }
}

module slot_grid() { // Woo-hoo!  The for-loop worked!
    for ( i = [15 : 10 : 130] )
    {
        translate([i, 5, -3])
            cut_slot();
    }
    
        for ( i = [15 : 10 : 130] )
    {
        translate([i, 85, -3])
            cut_slot();
    }
}

// Add mounting brackets to gridded base plate
module grid_plate() {

    raspi_mount();
    servo_plate();
    
    difference() {
        base_plate();
        slot_grid();
    }

}

// Build the grid plate with mounting holes.
module build_with_mount_holes() {
    difference() {
        grid_plate();
        servo_cavity();
        servo_screws();
        translate([58.4,47,-5])
            screw_holes();
    }
}



// Mount point for Camera Bracket
module camera_mount_point() {
    
    translate([0,62.5,0])
        cube([25,25,5]);  
}

module build_all() {
//camera_mount_point();
build_with_mount_holes();
}

//projection() translate([0,0,100]) build_all();
//build_all();

/*
translate([58.4,47,5])
    rotate([0,0,0])
        raspi();
*/
