#include <stdio.h>

#define OUT(c) fputc(c,stdout)

void outbyte(unsigned char c)
{
 unsigned char i=0x80;

 while(i)
 {
  if (i&c) {OUT(0xf0);OUT(0xf0);OUT(0xf0);OUT(0xf0);OUT(0xf0);
            OUT(0xf0);OUT(0xf0);OUT(0xf0);OUT(0xf0);}
      else {OUT(0xf0);OUT(0xf0);OUT(0xf0);OUT(0xf0);}
  OUT(0);OUT(0);OUT(0);OUT(0);
  i>>=1;
 }
}

void main(int argc, char *argv[])
{
 FILE *fi;
 int i;
 int c;

 for(i=0;i<5000*4;i++)
  OUT(0);

 outbyte('T'-27);
 outbyte('E'-27);
 outbyte('S'-27);
 outbyte('T'-27+128);

 fi=fopen(argv[1],"rb");
 while ((c=fgetc(fi))!=EOF) 
  outbyte(c);

 for(i=0;i<1000*4;i++)
  OUT(0);
}

