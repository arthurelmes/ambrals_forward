/* a simple example of how to use ambrals froward function */

#include "ambralsfor.c"
#include <stdio.h>
#include <stdlib.h>

main(int argc, char* argv[])
{
  if( argc > 1 ) 
    { float szen;
      float vzen;
      float relaz;
      float iso;
      float vol;
      float geo;
      
      szen = atof(argv[1]);
      vzen = atof(argv[2]);
      relaz = atof(argv[3]);
      iso = atof(argv[4]);
      vol = atof(argv[5]);
      geo = atof(argv[6]);

      printf("The argument provided for szen is: %f\n", szen);
      printf("The argument provided for vzen is: %f\n", vzen);      
      printf("The argument provided for relaz is: %f\n", relaz);
      printf("The argument provided for iso is: %f\n", iso);
      printf("The argument provided for vol is: %f\n", vol);      
      printf("The argument provided for geo is: %f\n", geo);

  

  geom_t geom;
  param_t params;

  float ref; /* save bidirectional reflectance */

  /* set bi-directional observation geometry parameters */
  /* which will be provided by you in whatever input format */
  /* you prefer --- in this single pixel example they are */
  /* just hardcoded */

  geom.szen = szen;
  geom.vzen = vzen;
  geom.relaz = relaz;

  /* set the three weights of Ambrals model */
  /* which will be provided by us as a flat */ 
  /* cartesian lat/lon file of floats for each */
  /* ROI ----- in this example they are just hardcoded */

  params.iso=iso;
  params.vol=vol;
  params.geo=geo;

  ref=forward(geom,params); /* call ambrals forward model */

  printf("%f\n",ref);
    }

}


