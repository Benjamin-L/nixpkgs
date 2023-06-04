{ lib
, stdenv
, fetchFromGitHub
, cmake
, opencl-headers
, khronos-ocl-icd-loader
, python3
}:
stdenv.mkDerivation rec {
  pname = "opencl-cts";
  version = "v2023-05-16-00";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-CTS";
    rev = "${version}";
    hash = "sha256-b5eFM0T/p6BhINw7xYAnPNjX/RpW2UiYeXNac414Cp8=";
  };

  buildInputs = [
    python3
  ];

  nativeBuildInputs = [
    cmake
  ];

  hardeningDisable = [ "format" ]; # TODO interacts badly with -Werror

  # workaround for https://github.com/KhronosGroup/OpenCL-CTS/issues/1582
  CXXFLAGS = "-Wno-alloc-size-larger-than";

  cmakeFlags = [
    "-DCL_INCLUDE_DIR=${opencl-headers}/include" # TODO find actual include path
    "-DCL_LIB_DIR=${khronos-ocl-icd-loader}/lib" # TODO actual lib path
    "-DOPENCL_LIBRARIES=OpenCL"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -a test_conformance/* $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "The OpenCL Conformance Tests";
    homepage = "https://github.com/KhronosGroup/OpenCL-CTS";
    license = licenses.asl20;
    maintainers = with maintainers; [ Benjamin-L ];
  };
}
