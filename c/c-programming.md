# C语言编程基础

## printf函数

```C
#include <stdio.h>
#include <stdbool.h>

int main(void) {
    char achar = 'a';
    printf("char :: %%c = %c || %%i = %i\n", achar, achar);

    _Bool abool = true;
    printf("_Bool :: %%i = %i || %%u = %u\n", abool, abool);
    abool = false;
    printf("_Bool :: %%i = %i || %%u = %u\n", abool, abool);

    int aint = 7;
    printf("int [base 10] :: %%i = %i || %%d = %d\n", aint, aint);

    aint = 010;
    printf("int [base 8] :: %%i = %i\n", aint);
    printf("int [base 8] :: %%o = %o || %%#o = %#o\n", aint, aint);

    aint = 0x10;
    printf("int [base 10] :: %%i = %i\n", aint);
    printf("int [base 10] :: %%x = %x || %%#x = %#x\n", aint, aint);
    printf("int [base 10] :: %%X = %X || %%#X = %#X\n", aint, aint);

    unsigned int auint = 7;
    printf("unsigned int :: %%u = %u\n", auint);

    size_t asizet = 7;
    printf("size_t :: %%zu = %zu\n", asizet);

    long long int allint = 7L; // uppercase
    printf("long long int :: %%lli = %lli\n", allint);

    float afloat = 2.57f;
    // %e ---> mantissa + exponent
    printf("float :: %%f = %f || %%e = %e\n", afloat, afloat);
    printf("float :: %%g = %g\n", afloat);

    double adouble = 2.57;
    printf("double :: %%f = %f || %%e = %e\n", adouble, adouble);
    printf("double :: %%g = %g\n", adouble);
    printf("double :: %%lf = %lf || %%le = %le\n", adouble, adouble);
    printf("double :: %%lg = %g\n", adouble);

    long double aldouble = 2.57;
    printf("long double :: %%Lf = %Lf || %%Le = %Le\n", aldouble, aldouble);
    printf("long long double :: %%Lg = %Lg\n", aldouble);

    return 0;
}
```

## const关键字

**error: assignment of read-only variable**

```C
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

```C
#include <stdio.h>

int main(void) {
    int alist[7] = {1, 2, 3};
    int blist[7] = {4, 5};

    const int *aptr = alist;
    printf("%%p = %p\n", aptr);
    aptr = blist;
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

```C
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

## 函数内部auto与static类型局部变量

```auto```类型局部变量：

* 无需显式声明 [函数局部变量默认类型]；

* 每次函数调用时都会重新创建 [重新初始化]；

* 无默认的初始值。

```static```类型局部变量：

* 需要显式声明；

* 只能初始化一次 [即在首次调用进行初始化]；

* 只能使用常量或常量表达式进行初始化 [如不指定，其默认值为0]； // error: initializer element is not constant

* 每次函数调用后，其值会被保留到下一次函数调用。

```C
#include <stdio.h>

int comp_auto_vs_static() {
    auto int ai = 0;
    static int si1 = 1;
    static int si2;
    si2 = 7;

    printf("%i vs. %i vs. %i ", ai, si1, si2);
    ai += 1;
    si1 += 1;
    si2 += 1;

    return si1;
}

int main(void) {
    int i = 0, out = 0;
    for(; i < 9; i++) {
        out = comp_auto_vs_static();
        printf("vs. %i\n", out);
    }

    return 0;
}
```
