include <constants.scad>


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

MicrophoneClamp();
