===============================

<Ambrals Forward Model Functions>

ambralsfor.c:  Ambrals forward model functions
ambralsfor.h:  header file of ambralsfor.c

Following is the functional form of the forward mode ambrals for you to
incorporate into your code.

        float forward(geom_t geom, param_t params);

        where geom has members:
        geom.szen       Solar Zenith
        geom.vzen       View Zenith
        geom.relaz      Relative Azimuth

        and params has members:
        params.iso      Isotropic BRDF parameter
        params.vol      volumetric BRDF parameter
        params.geo      geometric BRDF parameter

Angles in floating point degrees, BRDF parameters are simple floats.


==========================
/* a simple example of how to use ambrals froward function */

#include "ambralsfor.c"
#include <stdio.h>

main()
{
  geom_t geom;
  param_t params;

  float ref; /* save bidirectional reflectance */

  /* set bi-directional observation geometry parameters */
  /* which will be provided by you in whatever input format */
  /* you prefer --- in this single pixel example they are */
  /* just hardcoded */

  geom.szen=30.0;
  geom.vzen=45.0;
  geom.relaz=120.0;

  /* set the three weights of Ambrals model */
  /* which will be provided by us as a flat */ 
  /* cartesian lat/lon file of floats for each /*
  /* ROI ----- in this example they are just hardcoded */

  params.iso=0.2;
  params.vol=0.1;
  params.geo=0.05;

  ref=forward(geom,params); /* call ambrals forward model */

  printf("%f\n",ref);

}


SAMPLE CODE

one_ref.c: given three parameters and viewing and solar geometries, 
compute directional reflectance. 

pre_ref_bin.c: given three parameters file (in binary) and viewing 
and solar geometries, compute the directional reflectance for the 
image.






