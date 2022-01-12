$fa = 0.01;
$fs = 0.01;

// 20220111 changes
// * Added EPS to increase tolerance.
// * Removed extra taps that aren't needed.
EPS = 0.0125;
RAIL_DIAMETER = 0.258 + EPS * 2;
SUPPORT_DIAMETER = 0.5 + EPS * 2;
MIC_DIAMETER = 0.268;
TAP_SIZE_QUARTER_INCH = 7/32;
PADDING=0.1;

module RodSet(cube_length, cube_width, rail_diameter, rail_offset, tap_size, tap_depth) {
    translate([cube_width/2 + rail_offset, -0.15, 0]) {
        rotate([-90, 0, 0]) cylinder(d=rail_diameter, h=cube_length+0.3);
    }
    translate([cube_width/2 - rail_offset, -0.15, 0]) {
        rotate([-90, 0, 0]) cylinder(d=rail_diameter, h=cube_length+0.3);
    }
    if (tap_size > 0) {
        // taps for rod set 1
        translate([-0.3, cube_length/2, 0]) {
            rotate([0, 90, 0]) cylinder(d=tap_size, h=tap_depth + 0.3);
        }
        translate([cube_width+0.3, cube_length/2, 0]) {
            rotate([0, -90, 0]) cylinder(d=tap_size, h=tap_depth + 0.3);
        }
    }
}
    

module BarRailMount(padding=PADDING, support_diameter=SUPPORT_DIAMETER, rail_diameter=RAIL_DIAMETER, tap_size=TAP_SIZE_QUARTER_INCH) {

    cube_height = rail_diameter * 2 + padding * 2;
    cube_width = support_diameter + rail_diameter * 2 + padding * 4;
    cube_length = cube_width;
    rail_offset = support_diameter / 2 + padding + rail_diameter / 2;
    tap_depth = padding + rail_diameter / 2;

    difference() {
        minkowski() {
            cube(size=[cube_width, cube_length, cube_height]);
            sphere(r=0.1, $fn=25);
        }
        union() {
            
            // main support
            translate([cube_width/2, cube_length/2, -0.15]) {
                cylinder(d=support_diameter, h=cube_height+0.3);
            }
            // taps for main support
            translate([cube_width/2, cube_width + 0.15, tap_size / 2 + padding]) {
                rotate([90, 0, 0]) cylinder(d=tap_size, h=cube_width + 0.3);
            }
            
            // rod set 1 (x axis)
            translate([0, 0, 0 + rail_diameter / 2 + padding]) {
                RodSet(cube_length, cube_width, rail_diameter, rail_offset, tap_size, tap_depth);
            }         
            // rod set 2 (y axis)
            translate([cube_width, 0, cube_height - rail_diameter/2 - padding]) {
                rotate([0, 0, 90]) RodSet(cube_length, cube_width, rail_diameter, rail_offset, tap_size, tap_depth);
            }
            // rod set 3 (z axis)
            translate([0, cube_width / 2, -rail_diameter/2 - padding]) {
                rotate([90, 0, 0]) RodSet(cube_length, cube_width, rail_diameter, rail_offset, 0, 0);
            }
        }
    }
}


module MicrophoneClamp(padding=PADDING, mic_offset=0.5, rail_diameter=RAIL_DIAMETER, mic_diameter=MIC_DIAMETER, tap_size=TAP_SIZE_QUARTER_INCH) {
    
    thickness = tap_size + padding * 2;
    width = rail_diameter * 3 + padding * 2;
    depth = rail_diameter + mic_offset + padding * 2;
    mic_x = padding + mic_diameter / 2;
    
    difference () {
        linear_extrude(height=thickness) {
            difference() {
                minkowski() {
                    translate([0, -width/2]) square([depth, width], center=false);
                    circle(r=0.02);
                }
                
                translate([mic_x, 0, 0]) circle(d=mic_diameter);
                translate([mic_x + mic_offset, -rail_diameter]) circle(d=rail_diameter);
                translate([mic_x + mic_offset, rail_diameter]) circle(d=rail_diameter);
            }
        }   
        translate([-0.05, 0, thickness/2]) rotate([0, 90, 0]) cylinder(h=padding + mic_diameter / 2 + 0.05, d=tap_size);
        translate([mic_x + mic_offset, -rail_diameter-0.05, thickness/2]) rotate([90, 0, 0]) cylinder(h=padding + rail_diameter / 2, d=tap_size);
        translate([mic_x + mic_offset, rail_diameter+0.05, thickness/2]) rotate([-90, 0, 0]) cylinder(h=padding + rail_diameter / 2, d=tap_size);

        translate([-.25, - width - .125, 0.25]) rotate([-90, 0, 0]) cylinder(h=0.25, d=tap_size);
    }
}

//MicrophoneClamp();
BarRailMount();
