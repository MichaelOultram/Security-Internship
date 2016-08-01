#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/time.h>


#include <unistd.h>
#include <fcntl.h>

FILE *fp;
long lSize;
char *buffer;

char* openFile(char* file)
{
  /* open the file */
  fp = fopen ( file , "rb" );
  if( !fp ) perror(file),exit(1);
  fseek( fp , 0L , SEEK_END);
  lSize = ftell( fp );
  rewind( fp );

  /* allocate memory for entire content */
  buffer = calloc( 1, lSize+1 );
  if( !buffer ) fclose(fp),fputs("memory alloc fails",stderr),exit(1);

	/* copy the file into the buffer */
  if( 1!=fread( buffer , lSize, 1 , fp) )
    fclose(fp),free(buffer),fputs("entire read fails",stderr),exit(1);
  fclose(fp);
  return buffer;
}

char* concatWithQuotes(char *s1, char *s2)
{
    char *result = malloc(strlen(s1)+strlen(s2)+3);
    //in real code you would check for errors in malloc here
    strcpy(result, s1);
    strcat(result, "\'");
    strcat(result, s2);
    strcat(result, "\'");
    return result;
}


int main ( int argc, char **argv )
{

  /* Load the file named on the command line*/
  char* plainText = openFile(argv[1]);
  char* runCommandP = concatWithQuotes("python EncryptAES.py ",plainText);
  printf("Running Python encryption program\n");

  /* Measure time */
  struct timeval stop, start;
  gettimeofday(&start, NULL);

  /* Run the Python encryption program */
  system(runCommandP);

  /* Print time taken */
  gettimeofday(&stop, NULL);
  printf("    Done, that took: %lu microseconds\n", stop.tv_usec - start.tv_usec);

  free(runCommandP);

}
