# C语言编程基础


## printf函数常用格式汇总
```
#include <stdio.h>
#include <stdbool.h>

int main(void) {
    char achar = 'a';
    printf("%%c = %c || %%i = %i\n", achar, achar);

    _Bool abool = true;
    printf("%%i = %i || %%u = %u\n", abool, abool);
    abool = false;
    printf("%%i = %i || %%u = %u\n", abool, abool);

    int aint = 7;
    printf("%%i = %i || %%d = %d\n", aint, aint);

    aint = 010;
    printf("%%i = %i\n", aint);
    printf("%%o = %o || %%#o = %#o\n", aint, aint);

    aint = 0x10;
    printf("%%i = %i\n", aint);
    printf("%%x = %x || %%#x = %#x\n", aint, aint);
    printf("%%X = %X || %%#X = %#X\n", aint, aint);

    unsigned int auint = 7;
    printf("%%u = %u\n", auint);

    size_t ausint = 7;
    printf("%%zu = %zu\n", ausint);

    long long int allint = 7L; // uppercase
    printf("%%lli = %lli\n", allint);

    float afloat = 2.57f;
    // %e ---> mantissa + exponent
    printf("%%f = %f || %%e = %e\n", afloat, afloat);
    printf("%%g = %g\n", afloat);

    double adouble = 2.57;
    printf("%%f = %f || %%e = %e\n", adouble, adouble);
    printf("%%g = %g\n", adouble);
    printf("%%lf = %lf || %%le = %le\n", adouble, adouble);
    printf("%%lg = %g\n", adouble);

    long double aldouble = 2.57;
    printf("%%Lf = %Lf || %%Le = %Le\n", aldouble, aldouble);
    printf("%%Lg = %Lg\n", aldouble);

    return 0;
}
```

## const使用常见错误总结

**error: assignment of read-only variable**

```
#include <stdio.h>

int main(void) {
    const int aint = 7;
    aint = 2;

    return 0;
}
```

const data-type *pointer-name

*pointer-name = new-value // error: assignment of read-only location

pointer-name = &new-variable

```
#include <stdio.h>

int main(void) {
    int alist[7] = {1, 2, 3};
    int blist[7] = {4, 5};

    const int *aptr = alist;
    printf("%%p = %p\n", aptr);
    aptr = blist; // YES
    printf("%%p = %p\n", aptr);

    int i = 0;
    for(; i < 7; i++) {
        printf("%i ", *(aptr + i));
    }
    printf("\n");
/*
    *aptr = 6; // error: assignment of read-only location
*/
    return 0;
}
```

data-type *const pointer-name

*pointer-name = new-value

pointer-name = &new-variable // error: assignment of read-only variable

```
#include <stdio.h>

int main(void) {
    int alist[7] = {1, 2, 3};
    int blist[7] = {4, 5};

    int *const aptr = alist;
    *(aptr + 6) = 7;

    int i = 0;
    for(; i < 7; i++) {
        printf("%i ", *(aptr + i));
    }
    printf("\n");
/*
    aptr = blist; // error: assignment of read-only variable
*/
    return 0;
}
```

const data-type *const pointer-name

*pointer-name = new-value // error

pointer-name = &new-variable // error
