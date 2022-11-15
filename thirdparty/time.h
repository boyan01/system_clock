
struct timespec {
	long	tv_sec;			/* seconds */
	long	tv_nsec;		/* nanoseconds */
};

int clock_gettime(int clock_id, struct timespec *spec);