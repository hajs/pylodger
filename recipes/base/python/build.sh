# http://koansys.com/tech/building-python-with-enable-shared-in-non-standard-location
# Python Performance Boost by using Profile Guided Optimization
# http://komodoide.com/blog/2014-06/python-pgo-on-linux/

#export CFLAGS="-I${SYS_PREFIX}/include -fprofile-generate"
#export CXXFLAGS="-I${SYS_PREFIX}/include -fprofile-generate"
#export CPPFLAGS="-I${SYS_PREFIX}/include -fprofile-generate"
#export LDFLAGS="-L${SYS_PREFIX}/lib -fprofile-generate"
export CFLAGS="-I${SYS_PREFIX}/include"
export CXXFLAGS="-I${SYS_PREFIX}/include"
export CPPFLAGS="-I${SYS_PREFIX}/include"
export LDFLAGS="-L${SYS_PREFIX}/lib"
export SSL=${SYS_PREFIX}
export LD_LIBRARY_PATH=${SYS_PREFIX}/lib


EXCLUDE_TESTS="test_gdb test_subprocess test_faulthandler \
  test_multiprocessing test_multiprocessing_fork \
  test_multiprocessing_forkserver test_multiprocessing_spawn \
  test_multiprocessing_main_handling test_signal \
  test_concurrent_futures test_httplib test_imaplib test_smtpnet test_ssl"
PROFILE_TASK="-m test.regrtest -w -uall,-audio -x $EXCLUDE_TESTS"


#./configure --enable-unicode=ucs4 --prefix=${SYS_PREFIX} --enable-shared
./configure --with-computed-gotos --enable-unicode=ucs4 --prefix=$PREFIX --enable-shared \
##    LDFLAGS="-Wl,-rpath $PREFIX/lib"
#                --infodir='${prefix}/share/info' \
#                --mandir='${prefix}/share/man' \
#                --with-libc="" \
#		--with-libm="" \
#                --enable-loadable-sqlite-extensions \

#make
#make run_profile_task 
#make clean
#export CFLAGS="-I${SYS_PREFIX}/include -fprofile-use -fprofile-correction"
#export CXXFLAGS="-I${SYS_PREFIX}/include -fprofile-use -fprofile-correction"
#export CPPFLAGS="-I${SYS_PREFIX}/include -fprofile-use -fprofile-correction"
#export LDFLAGS="-L${SYS_PREFIX}/lib -fprofile-use -fprofile-correction"
#make

# Build with support for profile generation
make build_all_generate_profile
# Run workload to generate profile data
# Errors in the test suite are ignored
make run_profile_task PROFILE_TASK="$PROFILE_TASK" || true
# Rebuild with profile guided optimizations
make clean
make build_all_use_profile


make install
#make install DESTDIR=$PREFIX
