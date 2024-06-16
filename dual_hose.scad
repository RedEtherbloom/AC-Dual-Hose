// Parametric Midea Dual Air Hose adapter
THICKNESS = 7;

// All these values are completly arbitrary for now
PLASTIC_RIM_FILTER = 7;
TOTAL_WIDTH_FILTER = 273;
TOTAL_HEIGHT_FILTER = 246;

WIDTH_FILTER = TOTAL_WIDTH_FILTER - 2 * PLASTIC_RIM_FILTER;
HEIGHT_FILTER = TOTAL_HEIGHT_FILTER - 2 * PLASTIC_RIM_FILTER;

WIDTH_SEAL = 10;
// Extra tolerance for gluing
SEAL_EXTRA_TOLERANCE = 4;
WIDTH_SEAL_LIP = WIDTH_SEAL + SEAL_EXTRA_TOLERANCE;
SEAL_PROTRUSION_FROM_BOX = max(WIDTH_SEAL_LIP - THICKNESS, 0);
THICKNESS_SEAL_LIP = min(THICKNESS, 10);

DEPTH_EXPANSION_BOX = 50;

// various constants for the hose adapter. No idea how to do that yet...

MAGNET_DIAMETER = 3;
MAGNET_DISTANCE_TO_MESH = 3;

// Quirks of this specific AC
// Rim between filter and hot air outlet
RIM_ABOVE = 3;
RIM_ABOVE_TOLERANCE = 1;
// Rim to dodge thethe plastic portruding from the middle of the bottom of the filter
RIM_BELOW = PLASTIC_RIM_FILTER;
RIM_HEIGHT_PORTRUSION = 8;

module box() {
  inner_width_box = WIDTH_FILTER;
  inner_depth_box = DEPTH_EXPANSION_BOX;

  // Inner height so that the extrusion on the bottom of the filter is also contained. Logic:
  // If box covers plastic rim of filter:
  assert((THICKNESS + SEAL_PROTRUSION_FROM_BOX) > PLASTIC_RIM_FILTER);
  // Then inner height should be: (Width of box + seal (which is definitely larger than the width of the filters plastic rim)) + height of the filter(without the plastic rims) + 1 x Plastic rim to extend it so it covers the bottom protrusion.
  inner_height_box = (THICKNESS + SEAL_PROTRUSION_FROM_BOX) + HEIGHT_FILTER + RIM_BELOW;
  echo("Inner height of box=", inner_height_box);

  outer_width_box = inner_width_box + 2 * THICKNESS;
  outer_depth_box = inner_depth_box + THICKNESS;

  outer_height_box = inner_height_box + 2 * THICKNESS;

  // Main body
  difference() {
    cube([outer_width_box, outer_height_box, outer_depth_box]);
    translate([THICKNESS, THICKNESS, 0]) {
      cube([inner_width_box, inner_height_box, inner_depth_box]);
    }
  }
  
  // Sealant lip
  // If mostly for clarity
  if (SEAL_PROTRUSION_FROM_BOX > 0) {
    translate([-SEAL_PROTRUSION_FROM_BOX, -SEAL_PROTRUSION_FROM_BOX, 0]) {
      difference() {
        cube([outer_width_box + 2 * SEAL_PROTRUSION_FROM_BOX, outer_height_box + 2 * SEAL_PROTRUSION_FROM_BOX, THICKNESS_SEAL_LIP]);
        translate([SEAL_PROTRUSION_FROM_BOX, SEAL_PROTRUSION_FROM_BOX, 0]) {
          cube([outer_width_box, outer_height_box, THICKNESS_SEAL_LIP]);
        }
      }
    }
  }
}

box();