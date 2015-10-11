// bftcover.scad
// BFT Cover template
// 
// Copyright (C) 2015 Christopher Roberts
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// Outer-wall Parameters
out_height        = 35;
out_width         = 100;
out_depth         = 100;
out_radius        = 30;
out_thick         = 2.4;

// Interwall Parameters
int_thick         = 3;
int_depth         = 10;

// Innerwall Parameters
inn_thick         = 2;
inn_height        = 5;
inn_depth         = out_height - inn_height;

// Buttresses Parameters
but_height        = inn_height * 0.9;
but_width         = 2;
but_depth         = int_thick /2;
but_angle = atan( but_depth / but_height );

// General Parameters
$fn               = 120;

// Whole cover
module bftcover() {
    difference() {
        union() {
            main_cover();
            for (y = [ out_radius : 12 : out_depth - out_radius ] ) {
                translate( v = [out_thick + int_thick - but_depth, y, out_height - int_depth] ) rotate([0,0,-90]) buttress();
            }
            for (y = [ out_radius : 12 : out_depth - out_radius ] ) {
                translate( v = [out_width - out_thick - but_depth, y, out_height - int_depth] ) rotate([0,0,90]) buttress();
            }
            for (x = [ out_radius : 12 : out_width - out_radius ] ) {
                translate( v = [x, out_thick + int_thick - but_depth, out_height - int_depth] ) rotate([0,0,0]) buttress();
            }
            for (x = [ out_radius : 12 : out_width - out_radius ] ) {
                translate( v = [x, out_depth - out_thick - but_depth, out_height - int_depth] ) rotate([0,0,180]) buttress();
            }
        }
        union() {

        }

    }
}

module buttress() {
    difference() {
        union() {
            cube( size = [but_width, but_depth + inn_thick/2, but_height] );

        }
        union() {
            rotate([but_angle * -0.7, 0, 0] ) translate( v = [-0.1, -but_depth, 0]) cube( size = [but_width + 0.2, but_depth, but_height *1.25] );

        }

    }
}

module main_cover() {
    difference() {
        union() {
            // Main box
            rounded_box( out_width, out_depth, out_height, out_radius, out_thick + int_thick + inn_thick, out_thick );
        }
        union() {
            // Groove
            translate( v = [out_thick, out_thick, out_height - int_depth] )
                rounded_box( out_width - out_thick *2, out_depth - out_thick*2, int_depth + 0.1, out_radius - out_thick, int_thick, 0 );
            // Lower inner-wall
            translate( v = [out_thick, out_thick, inn_depth] )
                rounded_block( out_width - out_thick *2, out_depth - out_thick*2, int_depth + 0.1, out_radius - out_thick, int_thick, 0 );
        }
    }
}

// Creates a rounded cuboid box
module rounded_box( wth, dth, hgt, rad, wal, flr) {

    difference() {
        rounded_block( wth, dth, hgt, rad );
        translate( v = [wal, wal, flr])
            rounded_block( wth - wal *2, dth - wal *2, hgt, rad - wal );
    }

}

// Creates a rounded cuboid block
module rounded_block( wt, dt, ht, rd ) {

    hull () {
        translate( v = [rd, rd, 0] )           cylinder( h = ht, r = rd );
        translate( v = [wt - rd, rd, 0] )      cylinder( h = ht, r = rd );
        translate( v = [rd, dt - rd, 0] )      cylinder( h = ht, r = rd );
        translate( v = [wt - rd, dt - rd, 0] ) cylinder( h = ht, r = rd );
    }

}

module sizecheck() {
    difference() {
        color("pink") cube( size = [out_width, out_depth, 1]);
        translate( v = [out_thick, out_thick, -1]) cube( size = [out_width - out_thick*2, out_depth - out_thick*2, 3]);
    }
}

bftcover();
//translate( v = [0, 0, out_height + 2]) sizecheck();

// -------------------------------------------------------------------------------------------
// Commands
// -------------------------------------------------------------------------------------------

// http://en.wikibooks.org/wiki/OpenSCAD_User_Manual

// primitives
// cube(size = [1,2,3], center = true);
// sphere( r = 10, $fn=100 );
// circle( r = 10 );
// cylinder( h = 10, r = 20, $fs = 6, center = true );
// cylinder( h = 10, r1 = 10, r2 = 20, $fs = 6, center = false );
// polyhedron(points = [ [x, y, z], ... ], triangles = [ [p1, p2, p3..], ... ], convexity = N);
// polygon(points = [ [x, y], ... ], paths = [ [p1, p2, p3..], ... ], convexity = N);

// transormations
// scale(v = [x, y, z]) { ... }
// rotate(a=[0,180,0]) { ... }
// translate(v = [x, y, z]) { ... }
// mirror([ 0, 1, 0 ]) { ... }

// rounded box by combining a cube and single cylinder
// $fn=50;
// minkowski() {
//   cube([10,10,1]);
//   cylinder(r=2,h=1);
// }

// hull() {
//   translate([15,10,0]) circle(10);
//   circle(10);
// }

// linear_extrude(height=1, convexity = 1) import("tridentlogo.dxf");
// deprecated - dxf_linear_extrude(file="tridentlogo.dxf", height = 1, center = false, convexity = 10);
// deprecated - import_dxf(file="design.dxf", layer="layername", origin = [100,100], scale = 0.5);
// linear_extrude(height = 10, center = true, convexity = 10, twist = 0, $fn = 100)
// rotate_extrude(convexity = 10, $fn = 100)
// import_stl("example012.stl", convexity = 5);

// for (z = [-1, 1] ) { ... } // two iterations, z = -1, z = 1
// for (z = [ 0 : 5 ] ) { ... } // range of interations step 1
// for (z = [ 0 : 2 : 5 ] ) { ... } // range of interations step 2

// for (i = [ [ 0, 0, 0 ], [...] ] ) { ... } // range of rotations or vectors
// usage say rotate($i) or translate($i)
// if ( x > y ) { ... } else { ... }
// assign (angle = i*360/20, distance = i*10, r = i*2)

// text http://www.thingiverse.com/thing:25036
// inkscape / select all items
// objects to path
// select the object to export
// extensions / generate from path / paths to openscad

