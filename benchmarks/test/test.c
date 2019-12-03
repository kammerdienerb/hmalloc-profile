#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/syscall.h>

#define MAIN
#define THREADS

void* thr(void *_ptr) {
    int *ptr;
    int  i, j;

    printf("THREAD tid      = %ld\n", syscall(SYS_gettid));
    free(malloc(2000));

    ptr = _ptr;

    for (i = 0; i < 5000; i += 1) {
        for (j = 2000000; j < 3000000; j += 1) {
            ptr[j] = j;
        }
    }

    return NULL;
}

int main() {
    int       *ptr;
    void      *junk;
    int        i, j;
    pthread_t  t[20];

    printf("pid             = %d\n", getpid());
    printf("main thread tid = %ld\n", syscall(SYS_gettid));

    ptr = malloc(3000000 * sizeof(int));

#ifdef THREADS
    for (i = 0; i < 20; i += 1) {
        if (pthread_create(t + i, NULL, thr, ptr) != 0) {
            printf("wut\n");
            return 1;
        }
    }
#endif

#ifdef MAIN
    for (i = 0; i < 5000; i += 1) {
        for (j = 2000000; j < 3000000; j += 1) {
            ptr[j] = j;
        }
    }
#endif

#ifdef THREADS
    for (i = 0; i < 20; i += 1) {
        pthread_join(t[i], &junk);
    }
#endif

    free(ptr);

    return 0;
}
