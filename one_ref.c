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

  geom.szen=45.0;
  geom.vzen=45.0;
  geom.relaz=0.0;

  /* set the three weights of Ambrals model */
  /* which will be provided by us as a flat */ 
  /* cartesian lat/lon file of floats for each */
  /* ROI ----- in this example they are just hardcoded */

  params.iso=0.12089;
  params.vol=0.0;
  params.geo=0.063989;

  ref=forward(geom,params); /* call ambrals forward model */

  printf("%f\n",ref);

  geom.szen=45.0;
  geom.vzen=0.0;
  geom.relaz=0.0;
  ref=forward(geom,params); /* call ambrals forward model */

  printf("%f\n",ref);

  geom.szen=45.0;
  geom.vzen=45.0;
  geom.relaz=180.0;
  ref=forward(geom,params); /* call ambrals forward model */

  printf("%f\n",ref);


}


