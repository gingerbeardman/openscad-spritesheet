// animate X,X,32

// sprite
$vpr = [45,0,180-$t*360];
//$vpt = [0,100,100];
$vpt = [0,0,25];
$vpd = 520;

s = 30;
h = s/2;
d = s*2;
w = h*4.5;
dark = [1/5, 1/5, 1/5];
dither = [1/2, 1/2, 1/2];
light = [1, 1, 1];

*for (h = [-1:2:1])
translate([70*h,250,0])
cylinder(1,180,180);

rr = 0;
rl = 0;
rside = 6;

rf = 0;
rb = 0;
rfwd = 4;

jump = 0;
jumpfact = 8;
jumpshrink = 0.15;

shad = -1;

if (shad == 0 || shad == -1) {
    translate([-h,-d,3.5+abs(jump)*(1-jump)*jumpfact])
    rotate([jump*jumpfact,0,0])
    car();
}

if (shad == 1 || shad == -1) {
    translate([0,-5*jump,0])
    scale([1-(jumpshrink*abs(jump)),1-(jumpshrink*abs(jump)),0.01])
    union() {
        translate([-h,-d,abs(jump)*(1-jump)*jumpfact])
        rotate([jump*jumpfact,0,0])
        realshadow();
    }
}

//beams();

module car() {
    // rear wheels
    translate([s*0.84, h, h])
    wheel();
    translate([-s*0.84, h, h])
    wheel();

    // front wheels
    if (rl == 1) {
        translate([s*0.84, s*3.5, h])
        translate([4,-7,0])
        rotate([0,0,30])
        wheel();
    }
    if (rr == 1) {
        translate([s*0.84, s*3.5, h])
        translate([4,9,0])
        rotate([0,0,-35])
        wheel();
    }
    if (!rr && !rl) {
        translate([s*0.84, s*3.5, h])
        wheel();
    }

    if (rl == 1) {
        translate([-s*0.84, s*3.5, h])
        translate([0,-8,0])
        rotate([0,0,35])
        wheel();
    }
    if (rr == 1) {
        translate([-s*0.84, s*3.5, h])
        translate([0,7,0])
        rotate([0,0,-30])
        wheel();
    }
    if (!rr && !rl) {
        translate([-s*0.84, s*3.5, h])
        wheel();
    }

rotate([-rfwd*rf+rfwd*rb,-rside*rr+rside*rl,0])
translate([0,0,-rfwd*rb+rfwd*rf])
union() {

//        color(light)
        difference() {
            body();
            
            difference() {
                // front/back windows
                color(light)
                translate([-11,-40,41])
                cube([52,200,21]);

                // boot bottom
                color(dark)
                translate([-h, h, d])
                rotate([35,0,0])
                translate([0, -37, -5])
                cube([s*2,h*0.4,h/2]);

                // windscreen bottom
                color(dark)
                translate([-h, d*1.82265, d*1.15])
                rotate([55,0,0])
                translate([0, -37, -5])
                cube([s*2,h/3,h/3]);
            }

            // side windows
            color(light)
            translate([46,105,40])
            rotate([90,0,-90])
            linear_extrude(0,0,62)
            polygon(points=[[20,1],[106,1],[87,21],[48,21]]);

            // wheel arches
            union() {
                translate([s*0.75, h, h])
                arch();

                translate([-s*0.75, h, h])
                arch();

                translate([s*0.75, s*3.5, h])
                arch();

                translate([-s*0.75, s*3.5, h])
                arch();
            }
        }

        // struts
        color(dark)
        translate([42,36,62])
        rotate([0,90,0])
        cube([22,6,3]);
        color(dark)
        translate([-15,36,62])
        rotate([0,90,0])
        cube([22,6,3]);

        // door handles
        color(light)
        translate([43,44,36])
        rotate([0,90,0])
        cube([5,8,3]);
        color(light)
        translate([-16,44,36])
        rotate([0,90,0])
        cube([5,8,3]);

        // wing mirrors - housings
        color(dark)
        translate([44,86-abs(shad)*2,43])
        rotate([0,90,0])
        cube([7,4+abs(shad)*4,10]);
        color(dark)
        translate([-24,86-abs(shad)*2,43])
        rotate([0,90,0])
        cube([7,4+abs(shad)*4,10]);

        // wing mirrors - glass
        color(light)
        translate([46,85.9,42])
        rotate([0,90,0])
        cube([5,2,7]);
        color(light)
        translate([-23,85.9,42])
        rotate([0,90,0])
        cube([5,2,7]);

        // head
//        *translate([s/8, s*1.9, s*1.6])
//        sphere(7);

        // steering wheel
//        *translate([s/8, s*2.6, s*1.3])
//        rotate([70,0,00])
//        cylinder(2,7,7);

        lights();
    }
    
//    *translate([0,0,0])
//    skids_car();
}

module lights() {
    //front left
    color(light)
    translate([-5,135,31])
    rotate([90,0,0])
    cylinder(11,8,7);
    //front right
    color(light)
    translate([35,135,31])
    rotate([90,0,0])
    cylinder(11,8,7);

    //fog left
    color(light)
    translate([8,135,22])
    rotate([90,0,0])
    cylinder(11,5,5);
    //fog right
    color(light)
    translate([23,135,22])
    rotate([90,0,0])
    cylinder(11,5,5);

    //rear left
    color(light)
    translate([-16,-9,27])
    rotate([90,0,0])
    cube([15,6,7]);
    //rear right
    color(light)
    translate([31,-9,27])
    rotate([90,0,0])
    cube([15,6,7]);

    //boot button
    color(dark)
    translate([15,-14,33])
    rotate([90,0,0])
    cylinder(2,2.25,2.25);
}

module body() {
    // spoiler
    color(dark)
    translate([-h*0.99, h*0.94, d])
    rotate([45,0,0])
    translate([0, -2, 0])
    cube([s*1.99,h/4,h*0.75]);

    color(dark)
    union() {
        difference() {
            body_main();
            
            // interior
//            *translate([-11,50,25])
//            cube([52,35,20]);

            // windscreen angle
            translate([-s,s*1.5,s*2.5])
            rotate([-35,0,0])
            cube([s*3,s*4,d]);
            
            // boot angle
            color(dark)
            translate([d,s*1.75,s*3.5])
            rotate([-45,0,180])
            cube([s*3,s*4,d]);
        }

        difference() {
            // bonnet
            translate([-h, s*2.95, h])
            cube([s*2,s*1.5,s*5/6]);

            // bonnet angle
            translate([-s,s*3.75,s*1.5])
            rotate([-30,0,0])
            cube([s*3,s,s]);
        }
    }

    *color(dark)
    union() {
        // left bumper
        translate([-h*1.2, s*4.55, h*0.8])
        rotate([0,0,90])
        translate([-d*1.675, -11, 0])
        cube([s*1.6,h*0.7,h/2]);

        // right bumper
        translate([-h*1.2, s*4.55, h*0.8])
        rotate([0,0,90])
        translate([-d*1.675, -d-6, 0])
        cube([s*1.6,h*0.7,h/2]);

        // front bumper
        translate([-h*1.2, s*4.5, h*0.8])
        translate([0, -9, 0])
        cube([s*2.2,h*0.7,h/2]);

        // back bumper
        translate([-h*1.2, -h*0.6, h*0.8])
        translate([0, -9, 0])
        cube([s*2.2,h*0.7,h/2]);
    }

    // grille
    *translate([7.5, s*4.67, s*0.85])
    translate([0, -9.5, 0])
    color(dark)
    cube([s*0.5,h/4,h/5]);
}

module body_main() {
    translate([-h, -h, h])
    cube([s*2,s*5,s*1.65]);
}

module wheel() {
    difference() {
        // tyre
        translate([s/3,0,0])
        color(dark)
        rotate([0,90,0])
        cylinder(s/3,h*1.25,h*1.25);

        // tyre hole
        color(dither)
        translate([h/2,0,0])
        rotate([0,90,0])
        cylinder(h,s/3,s/3);
    }

    // hub cap
    color(dither)
    translate([h*0.75,0,0])
    rotate([0,90,0])
    cylinder(h/2,s/3,s/3);
}

module arch() {
    // hole
    translate([4.5,0,0])
    color(light)
    rotate([0,90,0])
    cylinder(s*0.7,s*0.7,s*0.7);
}

module beams() {
    radius = d*5;
    angles = [90-45, 90+45];
    fn = 24;
    
    translate([h+5,d,0])
    sector(radius, angles, fn);  

    translate([-h-5,d,0])
    sector(radius, angles, fn);  
}

module realshadow() {
    color([0,0,0, 1])
    translate([0,0,-4])
    scale([1,1,1])
    car();
}

module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}