#include <poll.h>
#include <termios.h>

void _shrink(int alink, char *result, int x) {
  *result=x;
}

void _extend(int alink, int *result, char x) {
  *result=x;
}

void _strlen(int alink, int* result, char *s) {
  char *t=s;
  for (;*s;s++) {}
  *result=(int)(s-t);
}

void _strcmp(int alink, int *result, char *s2, char *s1) {
  while (*s1 != 0 && *s2 != 0 && *s1 == *s2) {
    s1++;
    s2++;
  }

  if (*s1 == 0 && *s2 == 0)
    *result=0;
  else if (*s1 > *s2)
    *result=1;
  else
    *result=-1;
}

void _strcpy(int alink, int *result, char *src, char *trg) {
  while (*src) {
    *trg=*src;
    trg++;
    src++;
  };
  *trg=0;
}

void _strcat(int alink, int *result, char *src, char *trg) {
  while (*trg) {
    trg++;
  }
  _strcpy(0, 0, src, trg);
}

void _writeString(int alink, int result, char *s){
  int len;
  _strlen(0, &len, s);

  asm("int $0x80"
    :             /* No output registers */
    : "a" (4),    /* eax = system call number (write) */
      "b" (1),    /* ebx = stdout */
      "c" (s),    /* ecx = pointer to buffer */
      "d" (len)); /* edx = buffer length */
}

void _writeInteger(int alink, int result, int x) {
  char buf[12];
  int minus=(x<0),i=11;
  if (!minus)
    x=-x;
  buf[i--]=0;
  if (x==0)
    buf[i--]='0';
  while (x<0) {
    buf[i--]='0'-x%10;
    x/=10;
  }
  if (minus)
    buf[i--]='-';
  _writeString(0,0,&buf[i+1]);
}

void _writeByte(int alink, int result, char x) {
  _writeInteger(0, 0, x);
}

void _writeChar(int alink, int result, char x) {
  char buf[2]={x,0};
  _writeString(0, 0, buf);
}

static void readSingleChar(char *buf) {
  int unused;

  asm volatile("int $0x80"
    : "=a" (unused)
    : "a" (3),    /* eax = system call number (read) */
      "b" (0),    /* ebx = stdin */
      "c" (buf),  /* ecx = pointer to buffer */
      "d" (1));   /* edx = buffer length */
}

void _readString(int *alink, int result, char *s, int size) {
  while (1) {
    readSingleChar(s);
    if (size <= 1 || *s == '\n')
      break;
    s++;
    size--;
  }
  if (*s != '\n')
    s++;
  *s = 0;
}

static inline int isDigit(char s) {
    return s >= '0' && s <= '9';
}

/* FIXME: handle overflow */
static int parseInteger(char *s) {
  int res=0,minus;
  if (!*s)
    return res;
  minus=(*s == '-');
  if (minus)
    s++;
  while (isDigit(*s)) {
    res*=10;
    res+=*s-'0';
    s++;
  }
  return minus ? -res : res;
}

static inline int isWhite(char s) {
    return s == ' ' || s == '\t' || s == '\n' || s == '\r';
}

void _readInteger(int *alink, int *result) {
  char buf[64];
  int i=0,state=0;

  while (1) {
    readSingleChar(&buf[i]);
    if (state == 0) {
        if (buf[i] == '-')
            state = 1;
        else if (isDigit(buf[i]))
            state = 2;
        else if (!isWhite(buf[i]))
            break;
        else
            i--;
    } else if (state == 1) {
        if (isDigit(buf[i]))
            state = 2;
        else
            break;
    } else if (state == 2) {
        if (!isDigit(buf[i])) {
            state = 3;
            break;
        }
    }
    i++;
  }
  buf[state == 3 ? i+1 : 0] = 0;
  *result = parseInteger(buf);
}

void _readByte(int *alink, char *result) {
  int res;
  _readInteger(0, &res);
  *result = res;
}

void _readChar(int *alink, char *result) {
  volatile struct termios s;

  asm volatile("int $0x80"
    :
    : "a" (54),     /* eax = system call number (ioctl) */
      "b" (0),      /* ebx = stdin */
      "c" (0x5401), /* ecx = ioctl request (TCGETS) */
      "d" (&s));    /* edx = buffer */

  s.c_lflag &= ~ICANON;

  asm volatile("int $0x80"
    :
    : "a" (54),     /* eax = system call number (ioctl) */
      "b" (0),      /* ebx = stdin */
      "c" (0x5403), /* ecx = ioctl request (TCSETSW) */
      "d" (&s));    /* edx = buffer */

  readSingleChar(result);

  s.c_lflag |= ICANON;

  asm volatile("int $0x80"
    :
    : "a" (54),     /* eax = system call number (ioctl) */
      "b" (0),      /* ebx = stdin */
      "c" (0x5403), /* ecx = ioctl request (TCSETSW) */
      "d" (&s));    /* edx = buffer */
}
