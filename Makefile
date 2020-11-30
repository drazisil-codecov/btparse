all:
	rustup +nightly component add llvm-tools-preview
	cargo install rustfilt
	LLVM_PROFILE_FILE=test.0.profraw RUSTFLAGS=-Zinstrument-coverage cargo test
	$(rustc --print target-libdir)/../bin/llvm-profdata merge --sparse test.*.profraw -o test.profdata
	$(rustc --print target-libdir)/../bin/llvm-cov show -format=html -Xdemangler=rustfilt -show-instantiations -output-dir=./coverage -instr-profile=./test.profdata $(find target/debug/deps -type f -perm -u+x ! -name '*.so')

clean:
	rm -rf coverage
	rm -rf *.lcov
	rm -rf *.profraw
	rm -rf *.profdata

