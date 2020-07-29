### A Pluto.jl notebook ###
# v0.10.6

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ db2904fe-c378-11ea-27a8-dd467b0c4f60
using KernelFunctions

# ╔═╡ 26b45326-c379-11ea-3402-0d45587c6478
begin 
	using Plots; default(lw = 3.0)
	using Distributions
	using LinearAlgebra
	using PlutoUI
end

# ╔═╡ c582a514-c385-11ea-3817-6b416c7ff706
f_target(x) = sinc(x) # Target function

# ╔═╡ 2a15b832-c379-11ea-07d3-793fca0d73f8
begin 
	xmin = -3; xmax = 3 # Bounds of the data
	N = 50 # Number of samples
	x_train = rand(Uniform(xmin, xmax), N) # We sample 100 random samples
	σ = 0.1 # Noise variance
	y_train = f_target.(x_train) + randn(N) * σ # We add some noise on the training
	x_test = range(xmin - 0.1, xmax + 0.1, length = 200); # We define a test set
end

# ╔═╡ 447a057c-c379-11ea-1204-f79bece7ab8f
plot([x_train, x_test], [y_train, f_target.(x_test)], lab = ["data" "true_function"], t=[:scatter :path], lw = 4.0)

# ╔═╡ f5becff2-c379-11ea-0870-c31e523e2ce4
@bind λ Slider(-5:0.01:5, 0.0)

# ╔═╡ f3b15508-c37a-11ea-03ff-e317623229a4
@bind ρ Slider(-5:0.01:5, 0.0)

# ╔═╡ f848cf1c-c37a-11ea-20a8-775a8f0b0998
@bind σ² Slider(-5:0.01:5, 0.0)

# ╔═╡ 28747356-c37b-11ea-3557-33a29d3a7568
# k = transform(SqExponentialKernel(), 1/exp(ρ))
# k = exp(σ²) * transform(SqExponentialKernel(), 1/exp(ρ))
# k = transform(SqExponentialKernel(), 1/exp(ρ)) * PeriodicKernel()
#k = PeriodicKernel()
 k = PolynomialKernel(d=3.0)

# ╔═╡ ffe99cf4-c37a-11ea-2f78-691c0ffa92b0
ŷ = kernelmatrix(k, x_test, x_train) * inv(kernelmatrix(k, x_train) + exp(λ) * I) * y_train

# ╔═╡ 41860fe0-c6ae-11ea-23da-e95e5c19a897


# ╔═╡ 351f751a-c37b-11ea-1a6c-b162eeb49e60
begin
	p1 = scatter(x_train, y_train, lab = "data")
	plot!(x_test, f_target, lab = "true function")
	plot!(x_test, ŷ, lab = "prediction")
	p2 = heatmap(kernelmatrix(k, x_test), yflip=true, colorbar = false)
	plot(p1, p2)
end

# ╔═╡ c9289304-c6aa-11ea-22a9-3563c3211a0e


# ╔═╡ Cell order:
# ╠═db2904fe-c378-11ea-27a8-dd467b0c4f60
# ╠═26b45326-c379-11ea-3402-0d45587c6478
# ╠═c582a514-c385-11ea-3817-6b416c7ff706
# ╠═2a15b832-c379-11ea-07d3-793fca0d73f8
# ╠═447a057c-c379-11ea-1204-f79bece7ab8f
# ╠═ffe99cf4-c37a-11ea-2f78-691c0ffa92b0
# ╠═f5becff2-c379-11ea-0870-c31e523e2ce4
# ╠═f3b15508-c37a-11ea-03ff-e317623229a4
# ╠═f848cf1c-c37a-11ea-20a8-775a8f0b0998
# ╠═28747356-c37b-11ea-3557-33a29d3a7568
# ╠═41860fe0-c6ae-11ea-23da-e95e5c19a897
# ╠═351f751a-c37b-11ea-1a6c-b162eeb49e60
# ╠═c9289304-c6aa-11ea-22a9-3563c3211a0e
