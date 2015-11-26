#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <linux/termios.h>

int ioctl(int d, int request, ...);

int main(int argc, char *argv[])
{
  struct termios2 t;
  int fd,baud;

  if (argc != 3)
    {
      fprintf(stderr,"usage: %s <device> <baud>\n", argv[0]);
      return 1;
    }

  fd = open(argv[1], O_RDWR | O_NOCTTY | O_NDELAY);

  if (fd == -1)
      {
        fprintf(stderr, "error opening %s: %s", argv[1], strerror(errno));
        return 2;
      }

  baud = atoi(argv[2]);

  if (ioctl(fd, TCGETS2, &t))
    {
      perror("TCGETS2");
      return 3;
    }

  t.c_cflag &= ~CBAUD;
  t.c_cflag |= BOTHER;
  t.c_ispeed = baud;
  t.c_ospeed = baud;

  if (ioctl(fd, TCSETS2, &t))
    {
      perror("TCSETS2");
      return 4;
    }

  if (ioctl(fd, TCGETS2, &t))
    {
      perror("TCGETS2");
      return 5;
    }

  printf("actual speed reported %d\n", t.c_ospeed);
  return 0;
}
