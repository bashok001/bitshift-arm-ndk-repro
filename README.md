# Bug Reproduction
### Bug description
Compiler optimizations are causing a issue which is only triggered when running 32 bit binaries, compiled with any optimization flags 
(`-O1` to `-Ofast`), running on 64 bit arm architectures performing 64 bit bitwise operations (specifically shift and xor), 
likely when the memory operated on, is not properly aligned on a long word boundary.

### Build
1. Download / clone "bitshift-arm-ndk-repro".
1. Run `./test.sh`

### Observations
The output of `bugRepro()` in [`native-lib.c`](jni/native-lib.c) varies depending on architecture the binary is running on.

The output should be:  10656741657

Output on x86 is:      10656741657

Output on `armeabi` binary on 64 bit processor, without optimizations, is: 10656741657

But if you run `armeabi` binary on 64 bit processor, with optimizations, the output is: 35173553994009

### Notes:
* If you remove `volatile` declaration on `oops a` from native-lib.c#L17, then the output on `armeabi` binary matches the expected.
* If you add `volatile` declaration to `long long state` from native-lib.c#L8, then the output matches the expected.
