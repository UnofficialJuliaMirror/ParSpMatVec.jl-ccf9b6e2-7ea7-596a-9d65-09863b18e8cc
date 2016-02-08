using BinDeps

@BinDeps.setup

# set to true to support intel fortran compiler
useIntelFortran = false

# construct absolute path
depsdir  = splitdir(Base.source_path())[1]
builddir = joinpath(depsdir,"builds")
srcdir   = joinpath(depsdir,"src")

println("=== Building ParSpMatVec ===")
println("depsdir  = $depsdir")
println("builddir = $builddir")
println("srcdir   = $srcdir")
println("useIntel = $useIntelFortran")



if !isdir(builddir)
	println("creating build directory")
	mkdir(builddir)
end

@unix_only begin
	src1 = joinpath(srcdir,"A_mul_B.f90")
	src2 = joinpath(srcdir,"Ac_mul_B.f90")
	outfile = joinpath(builddir,"ParSpMatVec")
	@build_steps begin
		if useIntelFortran
			run(`ifort --O3 -xHost -fPIC -fpp -openmp -integer-size 64 -diag-disable=7841 -shared  $src1 $src2 -o $outfile`)
		else
			run(`gfortran -O3 -fPIC -cpp -fopenmp -fdefault-integer-8 -shared  $src1 $src2 -o $outfile`)
		end
	end
end


