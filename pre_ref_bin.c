/* a simple example of how to use ambrals froward function in image mode*/

#include "ambralsfor.c"
#include <stdio.h>

main(int argc,char **argv)
{
  geom_t geom;
  param_t params;
  FILE *in,*out;
  float ref; /* save bidirectional reflectance */
  int i,j,row,column;

  if(argc!=5){
    printf("Usage: %s brdf_parm_file num_row num_column out_ref_file\n",argv[0]);
    exit(1);
  }
  
  if((in=fopen(argv[1],"rb"))==NULL){
    printf("Can't open %s. Please check your input brdf parameter file\n",argv[1]);
    exit(1);
  }

  if((out=fopen(argv[4],"wb"))==NULL){
    printf("Can't open %s for write\n",argv[4]);
    exit(1);
  }

  /* get image size */
  row=atoi(argv[2]);
  column=atoi(argv[3]);

  /* set bi-directional observation geometry parameters */
  /* which will be provided by you in whatever input format */
  /* you prefer --- in this example they are just hardcoded */
 
  /* nadir at SZA=30 */
  geom.szen=30.0;   
  geom.vzen=0.0;
  geom.relaz=0.0;


  /* o image */
  for(i=0;i<row;i++)
    for(j=0;j<column;j++) {

      /* get the three weights of Ambrals model */
      /* which will be provided by us as a flat */ 
      /* cartesian lat/lon file of floats for each ROI*/

      /* get brdf parameters from input file (4-byte float in binary) */
      fread(&(params.iso),1,4,in);
      fread(&(params.vol),1,4,in);
      fread(&(params.geo),1,4,in);

      /* call ambrals forward model */
      ref=forward(geom,params); 

      fwrite(&ref,1,4,out);
    }

  fclose(in);
  fclose(out);
}






