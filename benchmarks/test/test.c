#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/syscall.h>

void* thr(void *_ptr) {
    int *ptr;
    int  i, j;

    printf("THREAD tid      = %d\n", syscall(SYS_gettid));
    free(malloc(2000));

    ptr = _ptr;

    for (i = 0; i < 50; i += 1) {
        for (j = 0; j < 100000; j += 1) {
            ptr[j] = j;
        }
        sleep(1);
    }

    return NULL;
}

int main() {
    int       *ptr;
    void      *junk;
    int        i, j;
    pthread_t  t[20];

    printf("pid             = %d\n", getpid());
    printf("main thread tid = %d\n", syscall(SYS_gettid));

    ptr = malloc(100000 * sizeof(int));


/*     for (i = 0; i < 20; i += 1) { */
/*         if (pthread_create(t + i, NULL, thr, ptr) != 0) { */
/*             printf("wut\n"); */
/*             return 1; */
/*         } */
/*     } */

    for (i = 0; i < 50; i += 1) {
        for (j = 0; j < 100000; j += 1) {
            ptr[j] = j;
        }
        sleep(1);
    }

/*     for (i = 0; i < 20; i += 1) { */
/*         pthread_join(t[i], &junk); */
/*     } */

    free(ptr);

    return 0;
}
